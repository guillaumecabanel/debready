#!/bin/bash

set -e

echo "Welcome to your brand new Debian machine!"
echo "Now that Desktop Environment is set up, we need to install some Gnome extensions."
echo "Please, accept the extentions when prompted."
echo "Press Enter to continue…"
read -r

gext install tactile@lundal.io
gext install clipboard-history@alexsaveau.dev


sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/clipboard-history@alexsaveau.dev/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/

gsettings set org.gnome.shell.extensions.tactile col-0 1
gsettings set org.gnome.shell.extensions.tactile col-1 3
gsettings set org.gnome.shell.extensions.tactile col-2 0
gsettings set org.gnome.shell.extensions.tactile col-3 0
gsettings set org.gnome.shell.extensions.tactile row-0 1
gsettings set org.gnome.shell.extensions.tactile row-1 0
gsettings set org.gnome.shell.extensions.tactile row-2 0
gsettings set org.gnome.shell.extensions.tactile row-3 0

gsettings set org.gnome.shell.extensions.tactile layout-2-col-0 1
gsettings set org.gnome.shell.extensions.tactile layout-2-col-1 1
gsettings set org.gnome.shell.extensions.tactile layout-2-col-2 0
gsettings set org.gnome.shell.extensions.tactile layout-2-col-3 0
gsettings set org.gnome.shell.extensions.tactile layout-2-row-0 1
gsettings set org.gnome.shell.extensions.tactile layout-2-row-1 1
gsettings set org.gnome.shell.extensions.tactile layout-2-row-2 0
gsettings set org.gnome.shell.extensions.tactile layout-2-row-3 0

gsettings set org.gnome.shell.extensions.tactile layout-3-col-0 1
gsettings set org.gnome.shell.extensions.tactile layout-3-col-1 1
gsettings set org.gnome.shell.extensions.tactile layout-3-col-2 1
gsettings set org.gnome.shell.extensions.tactile layout-3-col-3 0
gsettings set org.gnome.shell.extensions.tactile layout-3-row-0 1
gsettings set org.gnome.shell.extensions.tactile layout-3-row-1 0
gsettings set org.gnome.shell.extensions.tactile layout-3-row-2 0
gsettings set org.gnome.shell.extensions.tactile layout-3-row-3 0

gsettings set org.gnome.shell.extensions.tactile layout-4-col-0 3
gsettings set org.gnome.shell.extensions.tactile layout-4-col-1 1
gsettings set org.gnome.shell.extensions.tactile layout-4-col-2 0
gsettings set org.gnome.shell.extensions.tactile layout-4-col-3 0
gsettings set org.gnome.shell.extensions.tactile layout-4-row-0 1
gsettings set org.gnome.shell.extensions.tactile layout-4-row-1 0
gsettings set org.gnome.shell.extensions.tactile layout-4-row-2 0
gsettings set org.gnome.shell.extensions.tactile layout-4-row-3 0

gsettings set org.gnome.shell.extensions.tactile tile-0-0 "['a']"
gsettings set org.gnome.shell.extensions.tactile tile-1-0 "['z']"
gsettings set org.gnome.shell.extensions.tactile tile-2-0 "['e']"
gsettings set org.gnome.shell.extensions.tactile tile-0-1 "['q']"
gsettings set org.gnome.shell.extensions.tactile tile-1-1 "['s']"
gsettings set org.gnome.shell.extensions.tactile tile-2-1 "['d']"

gsettings set org.gnome.shell.extensions.tactile gap-size 12

gsettings set org.gnome.shell.extensions.clipboard-history ignore-password-mimes false
gsettings set org.gnome.shell.extensions.clipboard-history display-mode 3 # no icon in tray
gsettings set org.gnome.shell.extensions.clipboard-history toggle-menu "['<Alt>V']"

sed -i '$d' ~/.config/shell/init

echo "Done!"
