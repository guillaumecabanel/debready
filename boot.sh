#!/bin/bash

set -e

wget -qO- https://raw.githubusercontent.com/guillaumecabanel/debready/main/ascii.txt

echo "Setup will need your password. Press Enter to continue…"
read -r

echo "Installing Git…"
sudo apt-get -q update
sudo apt-get -q install -y git

echo "Cloning Debready…"
rm -rf ~/.local/share/debready
git -q clone https://github.com/guillaumecabanel/debready.git ~/.local/share/debready

echo "Preparing your Debian…"
source ~/.local/share/debready/install.sh
echo "Installation complete, your Debian is ready!"
echo "Rebooting in now…"
sleep 2
sudo systemctl reboot
