#!/bin/bash

apply_light_theme() {
  /bin/cp -f "$HOME/.config/alacritty/theme-light.toml" "$HOME/.current-theme.toml"
  touch "$HOME/.config/alacritty/alacritty.toml"
}

apply_dark_theme() {
  /bin/cp -f "$HOME/.config/alacritty/theme-dark.toml" "$HOME/.current-theme.toml"
  touch "$HOME/.config/alacritty/alacritty.toml"
}

# Monitor GNOME theme changes
gsettings monitor org.gnome.desktop.interface color-scheme |
  while read -r line; do
    if [[ "$line" == *"prefer-dark"* ]]; then
      apply_dark_theme
    else
      apply_light_theme
    fi
  done
