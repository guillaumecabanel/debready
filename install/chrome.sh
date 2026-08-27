#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# The .deb registers Google's own apt source, so upgrades come from apt (the
# `up` alias) and there is no reason to re-download it here.
if pkg_installed google-chrome-stable; then
    skip "Chrome already installed"
else
    tmp="$(mktemp -d)"
    trap 'rm -rf "$tmp"' EXIT
    wget -qO "$tmp/google-chrome-stable.deb" \
        https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo apt-get install -y "$tmp/google-chrome-stable.deb" >/dev/null
fi

xdg-settings set default-web-browser google-chrome.desktop
