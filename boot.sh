#!/bin/bash

set -e

sudo apt-get update
sudo apt-get install -y git > /dev/null

rm -rf ~/.local/share/debready
git clone https://github.com/guillaumecabanel/debready.git ~/.local/share/debready > /dev/null

echo "Installation starting…"
source ~/.local/share/debready/install.sh
