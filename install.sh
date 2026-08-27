#!/usr/bin/env bash

set -euo pipefail

DEBREADY_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export DEBREADY_ROOT
source "$DEBREADY_ROOT/lib/common.sh"

# gsettings and dconf need a session bus, which does not exist yet on a fresh
# machine with no desktop running. dbus-run-session ships in dbus-daemon (no
# dbus-x11 needed) and the re-exec is self-limiting: the variable is set inside.
if [ -z "${DBUS_SESSION_BUS_ADDRESS:-}" ]; then
  exec dbus-run-session -- bash "$DEBREADY_ROOT/install.sh" "$@"
fi

# "<step>:<description>". The list is also the order of a full run.
#
#   packages first    every step below needs the tools it installs
#   mise before terminal   the stowed zsh init activates mise; stowing it while
#                          mise is missing leaves a broken shell if we abort
#   docker before postgres the container needs a running daemon and the group
#   docker before redis    same
#   postgres before rails  a Rails app expects its database to be up
#   plymouth late          update-initramfs is by far the slowest step, so let
#                          everything that can fail cheaply fail first
STEPS=(
  "packages:Installing packages"
  "ufw:Protecting against evil internet"
  "font:Installing Nerd Font"
  "locale:Setting up locale"
  "gnome_settings:Setting up Gnome"
  "shortcuts:Setting up shortcuts"
  "mise:Installing Mise"
  "terminal:Setting up terminal"
  "chrome:Installing Chrome"
  "firefox:Installing Firefox"
  "vscodium:Installing VSCodium"
  "docker:Installing Docker"
  "postgres:Starting PostgreSQL"
  "redis:Starting Redis"
  "rails:Installing Rails"
  "theme_switcher:Making things beautiful"
  "plymouth:Setting up boot splash"
  "autostart:Scheduling post reboot script"
)

usage() {
  cat <<USAGE
Usage: install.sh [step...]

With no arguments, runs every step in order. With arguments, runs only the
named steps, in the order listed below. Every step is idempotent, so a step
or a full run can be repeated safely.

Steps:
USAGE
  local entry
  for entry in "${STEPS[@]}"; do
    printf '  %-16s %s\n' "${entry%%:*}" "${entry#*:}"
  done
}

case "${1:-}" in
  -h | --help | --list | list)
    usage
    exit 0
    ;;
esac

selected=()
if [ $# -eq 0 ]; then
  selected=("${STEPS[@]}")
else
  for arg in "$@"; do
    match=""
    for entry in "${STEPS[@]}"; do
      if [ "${entry%%:*}" = "$arg" ]; then
        match="$entry"
      fi
    done
    if [ -z "$match" ]; then
      printf 'unknown step: %s\n\n' "$arg" >&2
      usage >&2
      exit 1
    fi
    selected+=("$match")
  done
fi

# A full run takes well over the 15 minute sudo timeout, and its stdin may be
# the `wget … | bash` pipe rather than a terminal, so a mid-run password prompt
# would hang. Ask once, up front, then keep the timestamp alive.
sudo -v
while kill -0 "$$" 2>/dev/null; do
  sudo -n true || true
  sleep 60
done >/dev/null 2>&1 &
SUDO_KEEPALIVE=$!
trap 'kill "$SUDO_KEEPALIVE" 2>/dev/null || true' EXIT

for entry in "${selected[@]}"; do
  name="${entry%%:*}"
  log "${entry#*:}…"
  bash "$DEBREADY_ROOT/install/$name.sh" \
    || die "step '$name' failed — fix the error above, then re-run: $DEBREADY_ROOT/install.sh $name"
done
