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

echo "Setup will need your password. Press Enter to continue…"
read -r

sudo apt-get update > /dev/null
sudo apt-get install -y git > /dev/null

echo "Cloning Debready…"
rm -rf ~/.local/share/debready
git clone https://github.com/guillaumecabanel/debready.git ~/.local/share/debready > /dev/null

echo "Preparing your Debian…"
source ~/.local/share/debready/install.sh
echo "Installation complete, your Debian is ready!"
echo "Rebooting in now…"
sleep 2
sudo systemctl reboot
