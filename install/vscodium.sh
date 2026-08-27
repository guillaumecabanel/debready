#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

VSCODIUM_FINGERPRINT=1302DE60231889FE1EBACADC54678CF75A278D9C

apt_keyring vscodium https://gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg

# Verify before writing the .sources file: until that exists the keyring is
# inert, so a mismatch here means we simply never trust the repo.
fingerprint="$(gpg_fingerprint /etc/apt/keyrings/vscodium.asc)"
if [ "$fingerprint" != "$VSCODIUM_FINGERPRINT" ]; then
    sudo rm -f /etc/apt/keyrings/vscodium.asc
    die "VSCodium signing key fingerprint mismatch: got $fingerprint, expected $VSCODIUM_FINGERPRINT"
fi

# One suite for every distro — the repo is not codename-scoped, so unlike
# docker.sh there is nothing to interpolate and single quotes suffice.
apt_repo vscodium 'Types: deb
URIs: https://download.vscodium.com/debs
Suites: vscodium
Components: main
Signed-By: /etc/apt/keyrings/vscodium.asc'

apt_refresh
apt_install codium

CODIUM_USER="$HOME/.config/VSCodium/User"

# Create the leaf directory before stowing. stow folds: with ~/.config/VSCodium
# absent it would link the whole directory into the checkout, and VSCodium would
# then write globalStorage/, History/ and workspaceStorage/ into the git repo.
mkdir -p "$CODIUM_USER"

# A settings.json VSCodium wrote itself is a real file, which stow refuses to
# overwrite. Keep it once, then get out of the way. On a fresh machine codium has
# never been launched at this point, so there is nothing here and this is a no-op.
if [ -f "$CODIUM_USER/settings.json" ] && [ ! -L "$CODIUM_USER/settings.json" ]; then
    if [ -e "$CODIUM_USER/settings.json.pre-debready" ]; then
        rm -f "$CODIUM_USER/settings.json"
    else
        mv "$CODIUM_USER/settings.json" "$CODIUM_USER/settings.json.pre-debready"
    fi
fi

stow_pkg vscodium

# Extensions. Never under sudo — they land in ~/.vscode-oss.
mapfile -t EXTENSIONS < <(grep -vE '^[[:space:]]*(#|$)' "$DEBREADY_ROOT/install/vscodium_extensions")
# One listing for the whole loop rather than one per extension: each codium CLI
# call spawns Electron and costs about a second. --list-extensions lowercases the
# publisher, so compare against a lowercased needle.
installed="$(codium --list-extensions | tr '[:upper:]' '[:lower:]')"

for extension in "${EXTENSIONS[@]}"; do
    if printf '%s\n' "$installed" | grep -Fx "$(printf '%s' "$extension" | tr '[:upper:]' '[:lower:]')" >/dev/null; then
        skip "$extension already installed"
        continue
    fi
    codium --install-extension "$extension" >/dev/null
done
