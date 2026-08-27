#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

EXTENSIONS_DIR="$HOME/.local/share/gnome-shell/extensions"
SCHEMAS_DIR=/usr/share/glib-2.0/schemas

# Absolute path: this runs from post_reboot.sh under `alacritty -e`, whose PATH
# comes from the GNOME session, not from .zshrc. common.sh prepends
# ~/.local/bin, but be explicit about where gext comes from.
GEXT="$HOME/.local/bin/gext"

install_extension() { # <uuid> <schema-basename>
    if [ -d "$EXTENSIONS_DIR/$1" ]; then
        skip "$1 already installed"
    else
        "$GEXT" install "$1"
    fi

    # The extension ships its schema for its own prefs dialog; we need it
    # system-wide so the gsettings calls below can find it.
    if ! sudo cmp -s "$EXTENSIONS_DIR/$1/schemas/$2" "$SCHEMAS_DIR/$2"; then
        sudo cp "$EXTENSIONS_DIR/$1/schemas/$2" "$SCHEMAS_DIR/"
        SCHEMAS_CHANGED=yes
    fi
}

SCHEMAS_CHANGED=no
install_extension tactile@lundal.io org.gnome.shell.extensions.tactile.gschema.xml
install_extension clipboard-history@alexsaveau.dev org.gnome.shell.extensions.clipboard-indicator.gschema.xml

if [ "$SCHEMAS_CHANGED" = yes ]; then
    sudo glib-compile-schemas "$SCHEMAS_DIR/"
fi

gsettings set org.gnome.shell.extensions.tactile col-0 1
gsettings set org.gnome.shell.extensions.tactile col-1 3
gsettings set org.gnome.shell.extensions.tactile col-2 0
gsettings set org.gnome.shell.extensions.tactile col-3 0
gsettings set org.gnome.shell.extensions.tactile row-0 1
gsettings set org.gnome.shell.extensions.tactile row-1 0
gsettings set org.gnome.shell.extensions.tactile row-2 0
gsettings set org.gnome.shell.extensions.tactile row-3 0

gsettings set org.gnome.shell.extensions.tactile layout-2-col-0 1
gsettings set org.gnome.shell.extensions.tactile layout-2-col-1 1
gsettings set org.gnome.shell.extensions.tactile layout-2-col-2 0
gsettings set org.gnome.shell.extensions.tactile layout-2-col-3 0
gsettings set org.gnome.shell.extensions.tactile layout-2-row-0 1
gsettings set org.gnome.shell.extensions.tactile layout-2-row-1 1
gsettings set org.gnome.shell.extensions.tactile layout-2-row-2 0
gsettings set org.gnome.shell.extensions.tactile layout-2-row-3 0

gsettings set org.gnome.shell.extensions.tactile layout-3-col-0 1
gsettings set org.gnome.shell.extensions.tactile layout-3-col-1 1
gsettings set org.gnome.shell.extensions.tactile layout-3-col-2 1
gsettings set org.gnome.shell.extensions.tactile layout-3-col-3 0
gsettings set org.gnome.shell.extensions.tactile layout-3-row-0 1
gsettings set org.gnome.shell.extensions.tactile layout-3-row-1 0
gsettings set org.gnome.shell.extensions.tactile layout-3-row-2 0
gsettings set org.gnome.shell.extensions.tactile layout-3-row-3 0

gsettings set org.gnome.shell.extensions.tactile layout-4-col-0 3
gsettings set org.gnome.shell.extensions.tactile layout-4-col-1 1
gsettings set org.gnome.shell.extensions.tactile layout-4-col-2 0
gsettings set org.gnome.shell.extensions.tactile layout-4-col-3 0
gsettings set org.gnome.shell.extensions.tactile layout-4-row-0 1
gsettings set org.gnome.shell.extensions.tactile layout-4-row-1 0
gsettings set org.gnome.shell.extensions.tactile layout-4-row-2 0
gsettings set org.gnome.shell.extensions.tactile layout-4-row-3 0

gsettings set org.gnome.shell.extensions.tactile tile-0-0 "['a']"
gsettings set org.gnome.shell.extensions.tactile tile-1-0 "['z']"
gsettings set org.gnome.shell.extensions.tactile tile-2-0 "['e']"
gsettings set org.gnome.shell.extensions.tactile tile-0-1 "['q']"
gsettings set org.gnome.shell.extensions.tactile tile-1-1 "['s']"
gsettings set org.gnome.shell.extensions.tactile tile-2-1 "['d']"

gsettings set org.gnome.shell.extensions.tactile gap-size 12

gsettings set org.gnome.shell.extensions.clipboard-history ignore-password-mimes false
gsettings set org.gnome.shell.extensions.clipboard-history display-mode 3 # no icon in tray
gsettings set org.gnome.shell.extensions.clipboard-history toggle-menu "['<Alt>V']"
