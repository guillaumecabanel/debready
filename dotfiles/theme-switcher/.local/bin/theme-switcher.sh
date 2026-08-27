#!/usr/bin/env bash

# Follows the GNOME colour scheme and repoints the theme symlinks Alacritty,
# tmux and VSCodium read.
#
# No `set -e`: the monitor loop below must survive a bad iteration.
set -uo pipefail

CODIUM_SETTINGS="$HOME/.config/VSCodium/User/settings.json"

RULERS_DARK='[{"column":80,"color":"#171717"},{"column":120,"color":"#7f1d1d"}]'
RULERS_LIGHT='[{"column":80,"color":"#e5e5e5"},{"column":120,"color":"#f87171"}]'

# apply_theme <light|dark> <rulers-json>
apply_theme() {
  ln -sfn "$HOME/.config/alacritty/theme-$1.toml" "$HOME/.current-theme.toml"
  # Alacritty reloads on a write to its own config, not to the imported file.
  touch "$HOME/.config/alacritty/alacritty.toml"

  ln -sfn "$HOME/.config/tmux/theme-$1.conf" "$HOME/.current-tmux-theme.conf"
  # Guarded so it is a no-op when no tmux server is running.
  tmux has-session 2>/dev/null && tmux source-file "$HOME/.current-tmux-theme.conf" 2>/dev/null

  # VSCodium writes settings.json on its first launch, so on a fresh machine
  # there is nothing to patch yet. jq into a sibling temp file rather than
  # tmp.json in the cwd, which for a systemd user service is $HOME.
  if [ -f "$CODIUM_SETTINGS" ] && command -v jq >/dev/null; then
    local tmp
    tmp="$(mktemp "$CODIUM_SETTINGS.XXXXXX")" || return 0
    if jq "\"editor.rulers\" = $2" "$CODIUM_SETTINGS" >"$tmp"; then
      mv "$tmp" "$CODIUM_SETTINGS"
    else
      rm -f "$tmp"
    fi
  fi

  # Keep the caller's exit status clean.
  return 0
}

apply_current_theme() {
  case "$1" in
    *prefer-dark*) apply_theme dark "$RULERS_DARK" ;;
    *) apply_theme light "$RULERS_LIGHT" ;;
  esac
}

# gsettings monitor only reports *changes*, so sync once at startup — otherwise
# the symlinks stay missing until the user happens to toggle the theme.
apply_current_theme "$(gsettings get org.gnome.desktop.interface color-scheme)"

gsettings monitor org.gnome.desktop.interface color-scheme |
  while read -r line; do
    apply_current_theme "$line"
  done
