#!/bin/bash

set -e

echo "Install packages"
sudo apt-get install -y $(cat ~/.local/share/debready/install/packages_list) > /dev/null

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo "Caskaydia Mono Nerd Font"
~/.local/share/debready/install/font.sh

echo "Gnome settings"
~/.local/share/debready/install/gnome_settings.sh

echo "Gnome shortcuts"
dconf load "/org/gnome/settings-daemon/plugins/media-keys/" < ~/.local/share/debready/install/shortcuts.ini

echo "Terminal"
~/.local/share/debready/install/terminal.sh

echo "Add boot splash"
~/.local/share/debready/install/plymouth.sh
