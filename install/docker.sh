#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# shellcheck source=/dev/null
. /etc/os-release

apt_keyring docker https://download.docker.com/linux/debian/gpg
apt_repo docker "Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $VERSION_CODENAME
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc"

# Limit log size to avoid running out of disk. Written *before* the packages so
# a fresh install starts its daemon with the limit already in place — this used
# to be written afterwards with no restart, so it never took effect at all.
tmp="$(mktemp)"
trap 'rm -f "$tmp"' EXIT
printf '%s\n' '{"log-driver":"json-file","log-opts":{"max-size":"10m","max-file":"5"}}' >"$tmp"
daemon_json_changed=no
if install_file 0644 "$tmp" /etc/docker/daemon.json; then
    daemon_json_changed=yes
fi

apt_refresh
apt_install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# On a re-run the daemon was already running with the previous config.
if [ "$daemon_json_changed" = yes ] && systemctl is-active --quiet docker; then
    sudo systemctl restart docker
fi
sudo systemctl enable --quiet --now docker

if ! in_group docker; then
    sudo usermod -aG docker "$DEBREADY_USER"
fi

# usermod does not affect an already-running process, so nothing later in this
# session could talk to the socket as us. sg starts a shell that re-reads
# /etc/group, which both works around that and proves the group add took — a
# `sudo docker` here would mask a failed usermod until the next login.
for _ in $(seq 30); do
    if sg docker -c 'docker info' >/dev/null 2>&1; then
        break
    fi
    sleep 1
done
sg docker -c 'docker info' >/dev/null 2>&1 \
    || die "docker daemon not reachable as $DEBREADY_USER"

# lazydocker, from the mise registry (aqua:jesseduffield/lazydocker). This
# replaces a `mise use -g go` + `go install` pair that could not work: step
# scripts are plain bash with no mise activation, so `go` was never on PATH,
# and ~/go/bin is not on PATH in .zshrc either.
mise use --global lazydocker >/dev/null
