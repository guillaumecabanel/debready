#!/bin/bash

set -e

cd ~/.local/share/debready/dotfiles
stow -t "$HOME" i3
stow -t "/" root-i3

mkdir -p "$HOME/Pictures"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" background
cd -
sudo rm -rf /usr/share/applications/btop.desktop
