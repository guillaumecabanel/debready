#!/bin/bash

set -e

cd ~/.local/share/debready/dotfiles
stow -t "$HOME" i3

mkdir -p "$HOME/Pictures"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" background
cd -
