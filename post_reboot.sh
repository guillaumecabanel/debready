#!/bin/bash

set -e

cat ~/.local/share/debready/ascii.txt

echo "Welcome to your brand new Debian machine!"
echo "Now that Desktop Environment is set up, we need to install some Gnome extensions."
echo "Please, accept the extentions when prompted."
echo "Press Enter to continue…"
read -r

~/.local/share/debready/install/gnome_extensions.sh

sed -i '$d' ~/.config/shell/init

echo "Done!"
