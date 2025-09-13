#!/bin/bash

set -e

CURRENT_USER=$(whoami)
sudo mkdir -p /etc/gdm3
AutomaticLogin=$CURRENT_USER
AutomaticLoginEnable=true" | sudo tee /etc/gdm3/custom.conf > /dev/null

dconf write "/org/gnome/desktop/input-sources/xkb-options" "['compose:caps']"
dconf write "/org/gnome/desktop/interface/document-font-name" "'CaskaydiaMonoNerdFontMono-Regular 12'"
dconf write "/org/gnome/desktop/interface/enable-animation" "true"
dconf write "/org/gnome/desktop/interface/enable-hot-corners" "false"
dconf write "/org/gnome/desktop/interface/font-name" "'CaskaydiaMonoNerdFontMono-Regular 12'"
dconf write "/org/gnome/desktop/interface/monospace-font-name" "'CaskaydiaMonoNerdFontMono-Regular 14'"
dconf write "/org/gnome/desktop/interface/show-battery-percentage" "true"
dconf write "/org/gnome/desktop/session/idle-delay" "uint32 0"
dconf write "/org/gnome/settings-daemon/plugins/power/power-button-action" "'nothing'"
dconf write "/org/gnome/settings-daemon/plugins/power/sleep-inactive-ac-type" "'nothing'"
dconf write "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-timeout" "1200"
dconf write "/org/gnome/settings-daemon/plugins/power/sleep-inactive-battery-type" "'suspend'"
