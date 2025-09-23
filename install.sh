#!/bin/bash

set -e

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

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

echo "Mise"
~/.local/share/debready/install/mise.sh

echo "Rails"
~/.local/share/debready/install/rails.sh

echo "Theme switcher"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" theme-switcher
cd -
systemctl --user enable theme-switcher.service
systemctl --user start theme-switcher.service


echo "Add boot splash"
~/.local/share/debready/install/plymouth.sh

echo "Schedule GNOME extensions install on first graphical login"
mkdir -p ~/.config/debready
touch ~/.config/debready/first-boot
cat > ~/.config/systemd/user/debready-gnome-extensions.service << 'EOF'
[Unit]
Description=Debready - Install GNOME Extensions on first login
Wants=graphical-session.target
After=graphical-session.target
ConditionPathExists=%h/.config/debready/first-boot

[Service]
Type=oneshot
ExecStart=%h/.local/share/debready/install/gnome_extensions.sh
ExecStartPost=/usr/bin/rm -f %h/.config/debready/first-boot
ExecStartPost=/usr/bin/systemctl --user disable --now debready-gnome-extensions.service

[Install]
WantedBy=default.target
EOF

systemctl --user daemon-reload
systemctl --user enable debready-gnome-extensions.service
