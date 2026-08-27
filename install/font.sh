#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

FONT_DIR="$HOME/.local/share/fonts/JetBrainsMono"

if fc-list | grep -i 'JetBrainsMono Nerd Font' >/dev/null; then
    skip "JetBrainsMono Nerd Font already installed"
    exit 0
fi

# A temp dir rather than the cwd: this used to drop a 30 MB zip wherever the
# caller happened to be, and leave it behind on a partial failure.
tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT

wget -qO "$tmp/JetBrainsMono.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip
mkdir -p "$FONT_DIR"
unzip -qo "$tmp/JetBrainsMono.zip" -d "$FONT_DIR"
fc-cache -f >/dev/null
