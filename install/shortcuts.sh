#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# dconf load replaces the whole subtree, so this converges on a re-run.
dconf load /org/gnome/settings-daemon/plugins/media-keys/ \
    <"$DEBREADY_ROOT/install/shortcuts.ini"

# GNOME 40+ gives Super+1..9 to the dash (switch-to-application-N); take the whole
# row back so the number row means "workspace" everywhere.
#
# Written as <Super>1, not <Super>&: mutter resolves a keysym to every keycode
# that can produce it at any shift level and matches on the keycode, so this
# fires on the unshifted AZERTY key. (tmux does not — see the Alt+& duplicates
# in dotfiles/tmux/.config/tmux/tmux.conf.)
for n in $(seq 1 9); do
    gsettings set org.gnome.shell.keybindings "switch-to-application-$n" "@as []"
done

for n in $(seq 1 5); do
    gsettings set org.gnome.desktop.wm.keybindings "switch-to-workspace-$n" "['<Super>$n']"
    gsettings set org.gnome.desktop.wm.keybindings "move-to-workspace-$n" "['<Super><Shift>$n']"
done

# Superseded by the number row above.
gsettings set org.gnome.desktop.wm.keybindings switch-to-workspace-last "@as []"
gsettings set org.gnome.desktop.wm.keybindings move-to-workspace-last "@as []"
