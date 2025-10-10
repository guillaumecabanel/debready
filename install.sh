#!/bin/bash

set -e

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user
mkdir -p ~/.config/autostart

sudo install -d -m 0755 /etc/apt/keyrings
mkdir -p ~/.gnupg
chmod 700 ~/.gnupg

# Count total packages for progress tracking
TOTAL_PACKAGES=$(wc -l < ~/.local/share/debready/install/packages_list)
echo "Installing $TOTAL_PACKAGES packages…"

# Install packages with progress display
PACKAGES=($(cat ~/.local/share/debready/install/packages_list))
for i in "${!PACKAGES[@]}"; do
    PACKAGE="${PACKAGES[$i]}"
    PROGRESS=$(( (i + 1) * 100 / TOTAL_PACKAGES ))
    echo -ne "\rInstalling packages: [$PROGRESS%] ($((i + 1))/$TOTAL_PACKAGES)"
    sudo apt-get install -y "$PACKAGE" >/dev/null 2>&1
done
echo ""

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
  eval $(dbus-launch --sh-syntax)
  export DBUS_SESSION_BUS_ADDRESS
fi

echo "Protect agains evil internet…"
~/.local/share/debready/install/ufw.sh

echo "Installing Nerd Font…"
~/.local/share/debready/install/font.sh

echo "Setting up Gnome…"
~/.local/share/debready/install/gnome_settings.sh

echo "Setting up shortcuts…"
dconf load "/org/gnome/settings-daemon/plugins/media-keys/" <~/.local/share/debready/install/shortcuts.ini

echo "Setting up terminal…"
~/.local/share/debready/install/terminal.sh

echo "Installing Chrome…"
~/.local/share/debready/install/chrome.sh

echo "Installing Firefox…"
~/.local/share/debready/install/firefox.sh

echo "Installing Cursor…"
~/.local/share/debready/install/cursor.sh

echo "Installing Mise…"
~/.local/share/debready/install/mise.sh

echo "Installing Rails…"
~/.local/share/debready/install/rails.sh

echo "Installing Docker…"
~/.local/share/debready/install/docker.sh

echo "Making things beautiful…"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" theme-switcher
cd -
systemctl --user enable theme-switcher.service
systemctl --user start theme-switcher.service
~/.local/share/debready/install/plymouth.sh

echo "Schedule post reboot script on first terminal start"
cat >~/.config/autostart/alacritty.desktop <<EOF
[Desktop Entry]
Type=Application
Exec=/usr/bin/alacritty -e $HOME/.local/share/debready/post_reboot.sh
Hidden=false
X-GNOME-Autostart-enabled=true
Name=Post Reboot
Comment=Run post reboot script
EOF
