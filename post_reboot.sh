#!/usr/bin/env bash

set -euo pipefail

DEBREADY_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
export DEBREADY_ROOT
source "$DEBREADY_ROOT/lib/common.sh"

cat "$DEBREADY_ROOT/ascii.txt"

echo "Welcome to your brand new Debian machine!"
echo "Now that Desktop Environment is set up, we need to install some Gnome extensions."
echo "Please, accept the extensions when prompted."
echo "Press Enter to continue…"
read -r

log "Installing Gnome extensions…"
bash "$DEBREADY_ROOT/install/gnome_extensions.sh"

# Deregister ourselves. -f so a manual re-run is not fatal.
rm -f "$HOME/.config/autostart/alacritty.desktop"

echo "Done!"
echo "Enjoy your new Debian!"
echo "Press Enter to close this window."
read -r
