#!/bin/bash

apply_light_theme() {
  ln -sf "$HOME/.config/alacritty/theme-light.toml" "$HOME/.current-theme.toml"
  touch ~/.config/alacritty/alacritty.toml
  jq '."editor.rulers" = [{"column": 80,"color": "#e5e5e5"},{"column": 120,"color": "#f87171"}]' ~/.config/Cursor/User/settings.json > tmp.json && mv tmp.json ~/.config/Cursor/User/settings.json
}

apply_dark_theme() {
  ln -sf "$HOME/.config/alacritty/theme-dark.toml" "$HOME/.current-theme.toml"
  touch ~/.config/alacritty/alacritty.toml
  jq '."editor.rulers" = [{"column": 80,"color": "#171717"},{"column": 120,"color": "#7f1d1d"}]' ~/.config/Cursor/User/settings.json > tmp.json && mv tmp.json ~/.config/Cursor/User/settings.json
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
