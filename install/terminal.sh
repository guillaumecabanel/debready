#!/bin/bash

set -e

sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

cd ~/.local/share/debready/dotfiles
stow -t "$HOME" alacritty
rm -f "$HOME/.zshrc"
stow -t "$HOME" zsh
stow -t "$HOME" tmux
cd -

ln -sfn "$HOME/.config/tmux/theme-dark.conf" "$HOME/.current-tmux-theme.conf"
