#!/bin/bash

set -e

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

echo "Installing packages… (this may take a while)"
sudo apt-get install -y $(cat ~/.local/share/debready/install/packages_list) > /dev/null

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo "Installing beautiful font…"
~/.local/share/debready/install/font.sh

echo "Setting up Gnome…"
~/.local/share/debready/install/gnome_settings.sh

echo "Setting up shortcuts…"
dconf load "/org/gnome/settings-daemon/plugins/media-keys/" < ~/.local/share/debready/install/shortcuts.ini

echo "Setting up terminal…"
~/.local/share/debready/install/terminal.sh

echo "Installing Firefox…"
~/.local/share/debready/install/firefox.sh

echo "Installing Cursor…"
~/.local/share/debready/install/cursor.sh

echo "Installing Mise…"
~/.local/share/debready/install/mise.sh

echo "Installing Rails…"
~/.local/share/debready/install/rails.sh

echo "Making things beautiful…"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" theme-switcher
cd -
systemctl --user enable theme-switcher.service
systemctl --user start theme-switcher.service
~/.local/share/debready/install/plymouth.sh

echo "Schedule post reboot script on first terminal start"
echo "source ~/.local/share/debready/post_reboot.sh" >> ~/.config/shell/init
