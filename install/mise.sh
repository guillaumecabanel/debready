#!/bin/bash

set -e

wget -qO - https://mise.jdx.dev/gpg-key.pub | gpg --dearmor | sudo tee /etc/apt/keyrings/mise-archive-keyring.gpg 1> /dev/null

echo "
Types: deb
URIs: https://mise.jdx.dev/deb
Suites: stable
Components: main
Signed-By: /etc/apt/keyrings/mise-archive-keyring.gpg" | sudo tee /etc/apt/sources.list.d/mise.sources > /dev/null


sudo apt-get update > /dev/null
sudo apt-get install -y mise > /dev/null
