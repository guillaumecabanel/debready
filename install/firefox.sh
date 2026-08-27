#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

MOZILLA_FINGERPRINT=35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3

# Older versions of this script used packages.mozilla.org.asc as the filename.
sudo rm -f /etc/apt/keyrings/packages.mozilla.org.asc

apt_keyring mozilla https://packages.mozilla.org/apt/repo-signing-key.gpg

# Verify before writing the .sources file: until that exists the keyring is
# inert, so a mismatch here means we simply never trust the repo. This used to
# print "Verification failed" and carry on regardless.
fingerprint="$(gpg_fingerprint /etc/apt/keyrings/mozilla.asc)"
if [ "$fingerprint" != "$MOZILLA_FINGERPRINT" ]; then
    sudo rm -f /etc/apt/keyrings/mozilla.asc
    die "Mozilla signing key fingerprint mismatch: got $fingerprint, expected $MOZILLA_FINGERPRINT"
fi

apt_repo mozilla 'Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/mozilla.asc'

# Prefer Mozilla's build over Debian's ESR package.
printf '%s\n' 'Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000' | sudo tee /etc/apt/preferences.d/mozilla >/dev/null

apt_refresh
apt_install firefox
