#!/bin/bash

set -e

CURRENT_USER=$(whoami)
sudo mkdir -p /etc/gdm3
echo "[daemon]
AutomaticLogin=$CURRENT_USER
AutomaticLoginEnable=true" | sudo tee /etc/gdm3/custom.conf > /dev/null

gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface font-name "'CaskaydiaMono Nerd Font Mono 12'"
gsettings set org.gnome.desktop.interface monospace-font-name "'CaskaydiaMono Nerd Font Mono 12'"
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.settings-daemon.plugins.power power-button-action "nothing"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1200
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "suspend"
