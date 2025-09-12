#!/bin/bash

set -e

echo "Installing Oh My Zsh…"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd ~/.local/share/debready/dotfiles
stow -v -t "$HOME" alacritty
rm -f "$HOME/.zshrc"
stow -v -t "$HOME" zsh
cd -
