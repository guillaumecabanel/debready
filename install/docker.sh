#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# shellcheck source=/dev/null
. /etc/os-release

# Docker runs ROOTLESS here, and that is the point of most of this script.
#
# Membership in the `docker` group is equivalent to root: the daemon runs as
# root and will bind-mount / into a container for anyone who can reach its
# socket. sudo on this machine asks for a password, so the group would be the
# one password-free path to root — available not just to the human but to
# everything running as them: a gem/npm postinstall hook, an editor extension,
# an agent with shell access. Rootless moves the daemon into a user namespace,
# so there is no root to escalate to and no group to belong to.

apt_keyring docker https://download.docker.com/linux/debian/gpg
apt_repo docker "Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $VERSION_CODENAME
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc"

apt_refresh
# The last two arrive as Recommends today, but nothing below works without
# them, so name them: docker-ce-rootless-extras ships rootlesskit and
# dockerd-rootless-setuptool.sh, uidmap ships the newuidmap/newgidmap helpers
# that write the user namespace's id maps.
apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin \
    docker-compose-plugin docker-ce-rootless-extras uidmap

docker_was_active=no
if systemctl --user is-active --quiet docker 2>/dev/null; then
    docker_was_active=yes
fi

# The rootless daemon reads ~/.config/docker/daemon.json. /etc/docker/daemon.json
# belongs to the *root* daemon and is never consulted once we switch, so the
# log-size cap (which keeps a chatty container from filling the disk) has to
# live here instead.
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
printf '%s\n' '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' >"$tmp"
daemon_json_changed=no
if ! cmp -s "$tmp" "$HOME/.config/docker/daemon.json"; then
    install -m 0644 -D "$tmp" "$HOME/.config/docker/daemon.json"
    daemon_json_changed=yes
fi

# Shut the root daemon down and keep it down. Masking *both* units matters:
# disabling only docker.service leaves docker.socket to activate it again on
# the first touch of /var/run/docker.sock.
sudo systemctl stop docker.service docker.socket >/dev/null 2>&1 || true
sudo systemctl disable docker.service docker.socket >/dev/null 2>&1 || true
sudo systemctl mask docker.service docker.socket >/dev/null

if in_group docker; then
    sudo gpasswd -d "$DEBREADY_USER" docker >/dev/null
    skip "removed $DEBREADY_USER from the docker group"
fi

# rootlesskit maps the container's uids onto this range. Debian's adduser
# allocates one at account creation, but an older account may have none.
if ! grep "^$DEBREADY_USER:" /etc/subuid >/dev/null 2>&1 \
    || ! grep "^$DEBREADY_USER:" /etc/subgid >/dev/null 2>&1; then
    sudo usermod --add-subuids 100000-165535 --add-subgids 100000-165535 "$DEBREADY_USER"
fi

# The rootless daemon is a `systemd --user` unit, so it needs this user's
# systemd instance and runtime dir. pam_systemd supplies both on any real
# login; install.sh's dbus-run-session re-exec supplies a session bus but not
# these, so fail loudly here rather than half-installing.
if [ -z "${XDG_RUNTIME_DIR:-}" ] || ! systemctl --user show-environment >/dev/null 2>&1; then
    die "rootless docker needs a systemd --user session — run this step from a normal login as $DEBREADY_USER"
fi

# --force because the setuptool refuses while a rootful daemon is installed,
# which it still is: we masked it rather than removing the package.
if [ ! -f "$HOME/.config/systemd/user/docker.service" ]; then
    dockerd-rootless-setuptool.sh install --force >/dev/null
fi

systemctl --user enable --now docker >/dev/null

# Only on a re-run: a fresh install started above with the config already written.
if [ "$daemon_json_changed" = yes ] && [ "$docker_was_active" = yes ]; then
    systemctl --user restart docker
fi

# Without lingering, the user manager — and so dockerd, and so every
# `--restart unless-stopped` container — only starts at login. Autologin makes
# that nearly always true; linger makes it not depend on autologin.
if [ "$(loginctl show-user "$DEBREADY_USER" -p Linger --value 2>/dev/null || true)" != yes ]; then
    sudo loginctl enable-linger "$DEBREADY_USER"
fi

# The setuptool creates and selects this context; re-selecting is idempotent and
# documents where the socket comes from. It lives in ~/.docker/config.json, so
# clients that never read a shell profile still find the daemon. dotfiles/zsh
# additionally exports DOCKER_HOST, for Go clients (lazydocker) that only look
# at the environment.
docker context inspect rootless >/dev/null 2>&1 \
    || docker context create rootless --docker "host=unix://$XDG_RUNTIME_DIR/docker.sock" >/dev/null
docker context use rootless >/dev/null

# The daemon takes a moment to come up, and this loop is also the proof that the
# whole rootless chain works — newuidmap, the subuid range, the user namespace.
# A `sudo docker` here would mask a broken setup until the next login.
for _ in $(seq 30); do
    if docker info >/dev/null 2>&1; then
        break
    fi
    sleep 1
done
docker info >/dev/null 2>&1 || die "rootless docker daemon not reachable as $DEBREADY_USER"

# lazydocker, from the mise registry (aqua:jesseduffield/lazydocker). This
# replaces a `mise use -g go` + `go install` pair that could not work: step
# scripts are plain bash with no mise activation, so `go` was never on PATH,
# and ~/go/bin is not on PATH in .zshrc either.
mise use --global lazydocker >/dev/null
