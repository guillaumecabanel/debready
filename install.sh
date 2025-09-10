#!/bin/bash

set -e

echo "Install packages"
sudo apt-get install -y $(cat ~/.local/share/debready/install/packages_list) > /dev/null

echo "Check if we're in a D-Bus session, if not, start one"
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo -e "\nAdd boot splash"
~/.local/share/debready/install/plymouth.sh

echo -e "\nGnome settings"
~/.local/share/debready/install/gnome_settings.sh

echo -e "\nGnome shortcuts"
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ~/.local/share/debready/install/shortcuts.ini
