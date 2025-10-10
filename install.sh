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

echo "Protect agains evil internet…"
~/.local/share/debready/install/ufw.sh

echo "Setting up i3…"
~/.local/share/debready/install/i3.sh

echo "Installing Nerd Font…"
~/.local/share/debready/install/font.sh

echo "Setting up terminal…"
~/.local/share/debready/install/terminal.sh

echo "Installing Firefox…"
~/.local/share/debready/install/firefox.sh

echo "Installing Mise…"
~/.local/share/debready/install/mise.sh

echo "Installing Docker…"
~/.local/share/debready/install/docker.sh

echo "Installing Rails…"
~/.local/share/debready/install/rails.sh

echo "Making things beautiful…"
~/.local/share/debready/install/plymouth.sh
