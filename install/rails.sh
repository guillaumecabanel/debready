#!/bin/bash

set -e

cd ~/.local/share/debready/dotfiles
stow -t "$HOME" mise
cd -

mise use --global ruby@latest
mise settings add idiomatic_version_file_enable_tools ruby
mise x ruby -- gem install bundler rails --no-document
docker run -d --restart unless-stopped -p "127.0.0.1:5432:5432" --name=postgres17 -e POSTGRES_HOST_AUTH_METHOD=trust postgres:17
