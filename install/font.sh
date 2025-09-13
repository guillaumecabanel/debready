#!/bin/bash

set -e

wget -qO- https://github.com/ryanoasis/nerd-fonts/releases/latest/download/CascadiaMono.zip > CascadiaMono.zip
mkdir -p ~/.local/share/fonts
unzip -qo CascadiaMono.zip -d ~/.local/share/fonts
rm CascadiaMono.zip
fc-cache -f
