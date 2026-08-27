#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME/.config/systemd/user"
stow_pkg theme-switcher

# daemon-reload first: systemd will not see a unit that stow only just linked.
systemctl --user daemon-reload
# No explicit start. WantedBy=default.target starts it at the next login, and
# starting it now — before a GNOME session exists — only makes it restart-loop.
systemctl --user enable theme-switcher.service >/dev/null
