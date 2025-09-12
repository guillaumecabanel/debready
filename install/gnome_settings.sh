#!/bin/bash

set -e

echo "Enable automatic login"
CURRENT_USER=$(whoami)
sudo mkdir -p /etc/gdm3
echo "[daemon]
AutomaticLogin=$CURRENT_USER
AutomaticLoginEnable=true" | sudo tee /etc/gdm3/custom.conf > /dev/null

echo "Compose key => capslock"
dconf write "/org/gnome/desktop/input-sources/xkb-options" "['compose:caps']"

echo "Power button behaviour => nothing"
dconf write "/org/gnome/settings-daemon/plugins/power/power-button-action" "'nothing'"

echo "Show battery percentage => ON"
dconf write "/org/gnome/desktop/interface/show-battery-percentage" "true"

echo "Automatic screen blank => OFF"
dconf write "/org/gnome/desktop/session/idle-delay" "uint32 0"

echo "Automatic suspend on battery power => ON, 20 minutes"
dconf write "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type" "'suspend'"
dconf write "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout" "1200"

echo "Automatic suspend when plugged in => OFF"
dconf write "/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type" "'nothing'"

echo "Settings Caskaydia Mono Nerd Font as font"
dconf write "/org/gnome/desktop/interface/font-name" "'CaskaydiaMonoNerdFontMono-Regular 11'"
