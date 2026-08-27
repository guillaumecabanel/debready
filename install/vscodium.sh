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
