#!/bin/bash

set -e

mkdir -p ~/.local/bin
mkdir -p ~/.config

echo "Install packages"
sudo apt-get install -y $(cat ~/.local/share/debready/install/packages_list)

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo "Font"
~/.local/share/debready/install/font.sh

echo "Gnome settings"
~/.local/share/debready/install/gnome_settings.sh

echo "Gnome shortcuts"
dconf load "/org/gnome/settings-daemon/plugins/media-keys/" < ~/.local/share/debready/install/shortcuts.ini

echo "Terminal"
~/.local/share/debready/install/terminal.sh

echo "Firefox"
~/.local/share/debready/install/firefox.sh

echo "Cursor"
~/.local/share/debready/install/cursor.sh

echo "Theme switcher"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" theme-switcher
cd -
systemctl --user enable theme-switcher.service
systemctl --user start theme-switcher.service


echo "Add boot splash"
~/.local/share/debready/install/plymouth.sh
