#!/bin/bash

set -e

wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc >/dev/null
gpg -n -q --import --import-options import-show /etc/apt/keyrings/packages.mozilla.org.asc | awk '/pub/{getline; gsub(/^ +| +$/,""); if($0 == "35BAA0B33E9EB396F59CA838C0BA5CE6DC6315A3") print "\nThe key fingerprint matches ("$0").\n"; else print "\nVerification failed: the fingerprint ("$0") does not match the expected one.\n"}'

echo "
Types: deb
URIs: https://packages.mozilla.org/apt
Suites: mozilla
Components: main
Signed-By: /etc/apt/keyrings/packages.mozilla.org.asc" | sudo tee /etc/apt/sources.list.d/mozilla.sources >/dev/null

echo "
Package: *
Pin: origin packages.mozilla.org
Pin-Priority: 1000" | sudo tee /etc/apt/preferences.d/mozilla >/dev/null

sudo apt-get update
sudo apt-get install -y firefox > /dev/null
