#!/bin/bash

set -e

ascii_art=' _______           __                                        __
|       \         |  \                                      |  \
| ▓▓▓▓▓▓▓\ ______ | ▓▓____   ______   ______   ______   ____| ▓▓__    __
| ▓▓  | ▓▓/      \| ▓▓    \ /      \ /      \ |      \ /      ▓▓  \  |  \
| ▓▓  | ▓▓  ▓▓▓▓▓▓\ ▓▓▓▓▓▓▓\  ▓▓▓▓▓▓\  ▓▓▓▓▓▓\ \▓▓▓▓▓▓\  ▓▓▓▓▓▓▓ ▓▓  | ▓▓
| ▓▓  | ▓▓ ▓▓    ▓▓ ▓▓  | ▓▓ ▓▓   \▓▓ ▓▓    ▓▓/      ▓▓ ▓▓  | ▓▓ ▓▓  | ▓▓
| ▓▓__/ ▓▓ ▓▓▓▓▓▓▓▓ ▓▓__/ ▓▓ ▓▓     | ▓▓▓▓▓▓▓▓  ▓▓▓▓▓▓▓ ▓▓__| ▓▓ ▓▓__/ ▓▓
| ▓▓    ▓▓\▓▓     \ ▓▓    ▓▓ ▓▓      \▓▓     \\▓▓    ▓▓\▓▓    ▓▓\▓▓    ▓▓
 \▓▓▓▓▓▓▓  \▓▓▓▓▓▓▓\▓▓▓▓▓▓▓ \▓▓       \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓ \▓▓▓▓▓▓▓_\▓▓▓▓▓▓▓
                                                               |  \__| ▓▓
                                                                \▓▓    ▓▓
                                                                 \▓▓▓▓▓▓
'

echo -e "$ascii_art"

sudo apt-get update > /dev/null
sudo apt-get install -y git > /dev/null

echo "Cloning Debready…"
rm -rf ~/.local/share/debready
git clone https://github.com/guillaumecabanel/debready.git ~/.local/share/debready > /dev/null

echo "Installation starting…"
source ~/.local/share/debready/install.sh
