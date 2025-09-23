#!/bin/bash

set -e

cd ~/.local/share/debready/dotfiles
stow -t "$HOME" mise
cd -

mise install ruby@latest
mise use --global ruby@latest
