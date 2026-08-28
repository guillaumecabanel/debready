#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# stow folds ~/.vim into dotfiles/vim/.vim, so ~/.vim is the git checkout
# itself. Everything vim writes at runtime is redirected out of it by the
# stowed vimrc; these are the directories it redirects to.
mkdir -p "$HOME/.local/state/vim/swap" "$HOME/.local/state/vim/undo"

# Colorschemes as vim 8 native packages — no plugin manager. They go under
# ~/.local/share/vim rather than the conventional ~/.vim/pack for the same
# reason as above: a clone there would nest a git repo inside the checkout.
#
# opt/ and not start/: the stowed vimrc reaches them with `packadd!`, because a
# start package is only added to 'runtimepath' after the vimrc has run, which
# is too late for the :colorscheme call the vimrc ends with.
THEME_PACK="$HOME/.local/share/vim/pack/themes/opt"
mkdir -p "$THEME_PACK"

# clone_theme <dir> <url>  — clone once, then fast-forward on a re-run.
clone_theme() {
  if [ -d "$THEME_PACK/$1/.git" ]; then
    git -C "$THEME_PACK/$1" pull --ff-only --quiet
  else
    git clone --depth 1 --quiet "$2" "$THEME_PACK/$1"
  fi
}

clone_theme tokyonight-vim https://github.com/ghifarit53/tokyonight-vim
clone_theme catppuccin-vim https://github.com/catppuccin/vim

stow_pkg vim

# Seed the theme symlink. theme-switcher only reacts to gsettings *changes*,
# so without this vim has nothing to source until the user happens to toggle
# the colour scheme by hand — same reasoning as the two ln -sfn lines at the
# end of install/terminal.sh.
ln -sfn "$HOME/.vim/theme-dark.vim" "$HOME/.current-vim-theme.vim"
