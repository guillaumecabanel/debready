#!/bin/bash

set -e

# Install packages
sudo apt-get install -y $(cat install/packages_list)

echo "Check if we're in a D-Bus session, if not, start one"
if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo "\nAdd boot splash"
./install/plymouth.sh

echo "\nGnome settings"
./install/gnome_settings.sh

echo "\nGnome shortcuts"
dconf load /org/gnome/settings-daemon/plugins/media-keys/ < ./install/shortcuts.ini
