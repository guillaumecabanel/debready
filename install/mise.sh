#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# Older versions of this script dearmored the key to mise-archive-keyring.gpg;
# nothing references that path any more.
sudo rm -f /etc/apt/keyrings/mise-archive-keyring.gpg

apt_keyring mise https://mise.jdx.dev/gpg-key.pub
apt_repo mise 'Types: deb
URIs: https://mise.jdx.dev/deb
Suites: stable
Components: main
Signed-By: /etc/apt/keyrings/mise.asc'

apt_refresh
apt_install mise
