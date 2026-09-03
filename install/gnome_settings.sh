#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

DAEMON_CONF=/etc/gdm3/daemon.conf

sudo install -d -m 0755 /etc/gdm3
if [ ! -f "$DAEMON_CONF" ]; then
    printf '[daemon]\n' | sudo tee "$DAEMON_CONF" >/dev/null
elif ! grep -q '^\[daemon\]' "$DAEMON_CONF"; then
    printf '\n[daemon]\n' | sudo tee -a "$DAEMON_CONF" >/dev/null
fi

# Delete-then-insert, so re-running converges. Appending alone used to add a
# duplicate pair of keys on every run. The ^[[:space:]]* anchor deliberately
# spares the commented-out examples GDM ships.
sudo sed -i -E '/^[[:space:]]*AutomaticLogin(Enable)?[[:space:]]*=/d' "$DAEMON_CONF"
sudo sed -i "/^\[daemon\]/a AutomaticLoginEnable=true\nAutomaticLogin=$DEBREADY_USER" "$DAEMON_CONF"

# gext, used after the reboot by gnome_extensions.sh. pipx exits 0 with a notice
# when the package is already there, so this needs no guard.
pipx -q install gnome-extensions-cli --system-site-packages

# latin9_nodeadkeys, not latin9: in latin9 AltGr+7 is dead_grave, so a backtick
# needs two presses. nodeadkeys drops all four dead keys (grave, acute,
# circumflex, diaeresis); accented letters come from the Compose key below.
gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'fr+latin9_nodeadkeys')]"
gsettings set org.gnome.desktop.input-sources xkb-options "['compose:caps']"
gsettings set org.gnome.desktop.interface clock-format "'24h'"
gsettings set org.gnome.desktop.interface enable-animations true
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
gsettings set org.gnome.shell favorite-apps "['org.gnome.Nautilus.desktop']"
gsettings set org.gnome.shell.app-switcher current-workspace-only true
gsettings set org.gnome.shell.window-switcher current-workspace-only true
