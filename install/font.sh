#!/bin/bash

set -e

wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip > JetBrainsMono.zip
mkdir -p ~/.local/share/fonts
unzip -qo JetBrainsMono.zip -d ~/.local/share/fonts
rm JetBrainsMono.zip
fc-cache -f
