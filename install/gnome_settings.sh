#!/bin/bash

set -e

CURRENT_USER=$(whoami)
sudo mkdir -p /etc/gdm3

DAEMON_CONF="/etc/gdm3/daemon.conf"
if [ -f "$DAEMON_CONF" ]; then
    if grep -q "^\[daemon\]" "$DAEMON_CONF"; then
        sudo sed -i "/^\[daemon\]/a AutomaticLogin=$CURRENT_USER\nAutomaticLoginEnable=true" "$DAEMON_CONF"
    else
        echo -e "\n[daemon]\nAutomaticLogin=$CURRENT_USER\nAutomaticLoginEnable=true" | sudo tee -a "$DAEMON_CONF" > /dev/null
    fi
else
    echo "[daemon]
AutomaticLogin=$CURRENT_USER
AutomaticLoginEnable=true" | sudo tee "$DAEMON_CONF" > /dev/null
fi

pipx install gnome-extensions-cli --system-site-packages

gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"
gsettings set org.gnome.desktop.interface enable-animations true
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface enable-hot-corners false
gsettings set org.gnome.desktop.interface font-name "'JetBrainsMono Nerd Font Mono 12'"
gsettings set org.gnome.desktop.interface monospace-font-name "'JetBrainsMono Nerd Font Mono 12'"
gsettings set org.gnome.desktop.interface show-battery-percentage true
gsettings set org.gnome.desktop.session idle-delay 0
gsettings set org.gnome.desktop.wm.preferences num-workspaces 5
gsettings set org.gnome.mutter attach-modal-dialogs false
gsettings set org.gnome.mutter dynamic-workspaces false
gsettings set org.gnome.mutter workspaces-only-on-primary false
gsettings set org.gnome.settings-daemon.plugins.power power-button-action "nothing"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-ac-type "nothing"
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-timeout 1200
gsettings set org.gnome.settings-daemon.plugins.power sleep-inactive-battery-type "suspend"
gsettings set org.gnome.shell.extensions.window-list display-all-workspaces false
gsettings set org.gnome.shell.extensions.window-list grouping-mode "never"
gsettings set org.gnome.shell.extensions.window-list show-on-all-monitors false
gsettings set org.gnome.shell.window-switcher current-workspace-only true
