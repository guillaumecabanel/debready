#!/bin/bash

set -e

echo "Welcome to your brand new Debian machine!"
echo "Now that Desktop Environment is set up, we need to install some Gnome extensions."
echo "Please, accept the extentions when prompted."
echo "Press Enter to continue…"
read -n 1 -s

gext install tactile@lundal.io
gext install clipboard-history@alexsaveau.dev


sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/clipboard-history@alexsaveau.dev/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/


gsettings set org.gnome.shell.extensions.tactile gap-size 12

gsettings set org.gnome.shell.extensions.clipboard-history ignore-password-mimes false
gsettings set org.gnome.shell.extensions.clipboard-history display-mode 3 # no icon in tray
gsettings set org.gnome.shell.extensions.clipboard-history toggle-menu "['<Alt>V']"

sed -i '$d' ~/.config/shell/init

echo "Done!"
