#!/bin/bash

set -e

# Enable automatic login for the current user
CURRENT_USER=$(whoami)
sudo mkdir -p /etc/gdm3
echo "[daemon]
AutomaticLogin=$CURRENT_USER
AutomaticLoginEnable=true" | sudo tee /etc/gdm3/custom.conf > /dev/null

# Compose key => capslock
sudo dconf write "org.gnome.desktop.input-sources/xkb-options" "['compose:caps']"

# Power button behaviour => nothing
sudo dconf write "org.gnome.settings-daemon.plugins.power/power-button-action" "'nothing'"

# Show battery percentage => ON
sudo dconf write "org.gnome.desktop.interface/show-battery-percentage" "true"

# Automatic screen blank => OFF
sudo dconf write "org.gnome.desktop.session/idle-delay" "uint32 0"

# Automatic suspend on battery power => ON, 20 minutes
sudo dconf write "org.gnome.settings-daemon.plugins.power/sleep-inactive-battery-type" "'suspend'"
sudo dconf write "org.gnome.settings-daemon.plugins.power/sleep-inactive-battery-timeout" "1200"

# Automatic suspend when plugged in => OFF
sudo dconf write "org.gnome.settings-daemon.plugins.power/sleep-inactive-ac-type" "'nothing'"
