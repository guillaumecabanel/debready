#!/usr/bin/env bash

# Follows the GNOME colour scheme and repoints the theme symlinks Alacritty,
# tmux and vim read. VSCodium is not handled here: window.autoDetectColorScheme
# in its stowed settings.json makes it follow the XDG portal on its own, which
# beats rewriting a file a running editor also owns.
#
# No `set -e`: the monitor loop below must survive a bad iteration.
set -uo pipefail

# apply_theme <light|dark>
apply_theme() {
  ln -sfn "$HOME/.config/alacritty/theme-$1.toml" "$HOME/.current-theme.toml"
  # Alacritty reloads on a write to its own config, not to the imported file.
  touch "$HOME/.config/alacritty/alacritty.toml"

  # Vim is built -clientserver, so there is no way to push into a running
  # instance. Each one polls this symlink on a timer instead and re-sources it
  # when the target changes — see dotfiles/vim/.vim/vimrc.
  ln -sfn "$HOME/.vim/theme-$1.vim" "$HOME/.current-vim-theme.vim"

  ln -sfn "$HOME/.config/tmux/theme-$1.conf" "$HOME/.current-tmux-theme.conf"
  # Guarded so it is a no-op when no tmux server is running.
  tmux has-session 2>/dev/null && tmux source-file "$HOME/.current-tmux-theme.conf" 2>/dev/null

  # Keep the caller's exit status clean: the line above is a bare `cond && cmd`,
  # which returns 1 whenever no tmux server is running.
  return 0
}

apply_current_theme() {
  case "$1" in
    *prefer-dark*) apply_theme dark ;;
    *) apply_theme light ;;
  esac
}

# gsettings monitor only reports *changes*, so sync once at startup — otherwise
# the symlinks stay missing until the user happens to toggle the theme.
apply_current_theme "$(gsettings get org.gnome.desktop.interface color-scheme)"

gsettings monitor org.gnome.desktop.interface color-scheme |
  while read -r line; do
    apply_current_theme "$line"
  done
