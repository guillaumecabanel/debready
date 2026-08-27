# shellcheck shell=bash
#
# Shared helpers for the debready install scripts. Sourced, never executed.
# Every script starts with:
#
#   #!/usr/bin/env bash
#   set -euo pipefail
#   source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"
#
# Two rules for anything added here, both because callers run `set -euo pipefail`:
#   - never end a function with a bare `cond && cmd`: it returns 1 when cond is
#     false and trips the caller's `set -e`
#   - never pipe into `grep -q`: grep exits at the first match, the producer dies
#     of SIGPIPE, and pipefail then reports the whole test as failed. Use plain
#     `grep … >/dev/null`, which reads its input to the end.

DEBREADY_ROOT="${DEBREADY_ROOT:-$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)}"
DEBREADY_USER="${USER:-$(id -un)}"

# pipx- and mise-installed binaries (gext, lazydocker) live here. post_reboot.sh
# runs under `alacritty -e`, a bash process that never reads .zshrc, so without
# this the PATH it inherits from the GNOME session has no ~/.local/bin.
case ":$PATH:" in
  *":$HOME/.local/bin:"*) ;;
  *) export PATH="$HOME/.local/bin:$PATH" ;;
esac

log()  { printf '\033[1;34m==>\033[0m %s\n' "$*"; }
skip() { printf '    \033[2m·  %s\033[0m\n' "$*"; }
die()  { printf '\033[1;31mxx\033[0m %s\n' "$*" >&2; exit 1; }

have()          { command -v "$1" >/dev/null 2>&1; }
pkg_installed() { dpkg-query -W -f='${Status}' "$1" 2>/dev/null | grep -x 'install ok installed' >/dev/null; }
in_group()      { id -nG "$DEBREADY_USER" | tr ' ' '\n' | grep -x "$1" >/dev/null; }

apt_refresh() { sudo apt-get update >/dev/null; }

# apt_install <pkg>...  — installs only what is missing, so a re-run is a no-op.
apt_install() {
  local p todo=()
  for p in "$@"; do
    pkg_installed "$p" || todo+=("$p")
  done
  if [ ${#todo[@]} -gt 0 ]; then
    sudo apt-get install -y "${todo[@]}" >/dev/null
  fi
}

# apt_keyring <name> <armored-key-url>  → /etc/apt/keyrings/<name>.asc
# Every upstream we use (docker, mozilla, mise) publishes an armored key, so no
# `gpg --dearmor` step is needed anywhere.
apt_keyring() {
  local name="$1" url="$2" tmp
  sudo install -d -m 0755 /etc/apt/keyrings
  tmp="$(mktemp)"
  wget -qO "$tmp" "$url"
  [ -s "$tmp" ] || { rm -f "$tmp"; die "empty keyring downloaded from $url"; }
  sudo install -m 0644 "$tmp" "/etc/apt/keyrings/$name.asc"
  rm -f "$tmp"
}

# apt_repo <name> <deb822-body>  → /etc/apt/sources.list.d/<name>.sources
apt_repo() {
  local name="$1" tmp
  tmp="$(mktemp)"
  printf '%s\n' "$2" >"$tmp"
  sudo install -m 0644 "$tmp" "/etc/apt/sources.list.d/$name.sources"
  rm -f "$tmp"
}

# gpg_fingerprint <armored-key-file>  — primary key fingerprint, uppercase hex.
# awk reads to EOF rather than exiting on the first match: an early exit would
# SIGPIPE gpg, and pipefail would turn that into a failed command substitution.
gpg_fingerprint() {
  gpg -n -q --import --import-options import-show --with-colons "$1" \
    | awk -F: '/^fpr:/ && !seen { print $10; seen = 1 }'
}

# stow_pkg <name>  — -R restows, so re-running converges instead of conflicting.
stow_pkg() { stow -d "$DEBREADY_ROOT/dotfiles" -t "$HOME" -R "$1"; }

# install_file <mode> <source> <dest>  — root-owned write, only when the content
# differs. Returns 0 if it wrote, 1 if the file was already correct, so callers
# can gate an expensive follow-up (systemctl restart, update-initramfs).
install_file() {
  if sudo cmp -s "$2" "$3" 2>/dev/null; then
    return 1
  fi
  sudo install -m "$1" -D "$2" "$3"
}
