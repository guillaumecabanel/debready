#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# Runs post_reboot.sh once, at the first login after the reboot, in a terminal
# so its prompts are visible. post_reboot.sh deletes this file when it is done.
mkdir -p "$HOME/.config/autostart"
cat >"$HOME/.config/autostart/alacritty.desktop" <<DESKTOP
[Desktop Entry]
Type=Application
Exec=/usr/bin/alacritty -e $DEBREADY_ROOT/post_reboot.sh
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Post Reboot
Comment=Run post reboot script
DESKTOP
