#!/usr/bin/env bash

set -euo pipefail

DEBREADY_ROOT="${DEBREADY_ROOT:-$HOME/.local/share/debready}"
DEBREADY_REPO=https://github.com/guillaumecabanel/debready.git

# stdin is the script itself when this is run the documented way
# (`wget -qO- boot.sh | bash`), so a plain `read` would swallow the next lines
# of the script instead of waiting for a keypress.
prompt() {
    printf '%s\n' "$1"
    if [ -e /dev/tty ]; then
        read -r </dev/tty
    fi
}

wget -qO- https://raw.githubusercontent.com/guillaumecabanel/debready/main/ascii.txt

prompt "Setup will need your password. Press Enter to continue…"

echo "Installing Git…"
sudo apt-get update >/dev/null
sudo apt-get install -y git >/dev/null

if [ -d "$DEBREADY_ROOT/.git" ]; then
    echo "Updating Debready (this discards local changes in $DEBREADY_ROOT)…"
    git -C "$DEBREADY_ROOT" fetch --quiet origin
    git -C "$DEBREADY_ROOT" reset --quiet --hard origin/main
else
    echo "Cloning Debready…"
    rm -rf "$DEBREADY_ROOT"
    git clone --quiet "$DEBREADY_REPO" "$DEBREADY_ROOT"
fi

echo "Preparing your Debian…"
# Executed, not sourced: install.sh gets its own `set -e` scope, its cd/exec
# cannot leak into this shell, and a failure is reported instead of silently
# skipping the reboot below.
if ! bash "$DEBREADY_ROOT/install.sh"; then
    echo "Installation failed. Fix the error above, then re-run:" >&2
    echo "  $DEBREADY_ROOT/install.sh" >&2
    exit 1
fi

echo "Installation complete, your Debian is ready!"
echo "Rebooting now…"
sleep 2
sudo systemctl reboot
