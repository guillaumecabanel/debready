#!/bin/bash

set -e

gext install tactile@lundal.io
gext install clipboard-history@alexsaveau.dev


sudo cp ~/.local/share/gnome-shell/extensions/tactile@lundal.io/schemas/org.gnome.shell.extensions.tactile.gschema.xml /usr/share/glib-2.0/schemas/
sudo cp ~/.local/share/gnome-shell/extensions/clipboard-history@alexsaveau.dev/schemas/org.gnome.shell.extensions.clipboard-indicator.gschema.xml /usr/share/glib-2.0/schemas/
sudo glib-compile-schemas /usr/share/glib-2.0/schemas/


gsettings set org.gnome.shell.extensions.tactile gap-size 12

gsettings set org.gnome.shell.extensions.clipboard-history ignore-password-mimes false
gsettings set org.gnome.shell.extensions.clipboard-history display-mode 3 # no icon in tray
gsettings set org.gnome.shell.extensions.clipboard-history toggle-menu "['<Alt>V']"
