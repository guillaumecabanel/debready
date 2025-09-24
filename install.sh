#!/bin/bash

set -e

run_with_braille_spinner() {
echo -n "" > /dev/null
    local message="$1"
    shift
    local frames=("⠋" "⠙" "⠹" "⠸" "⠼" "⠴" "⠦" "⠧" "⠇" "⠏")
    "$@" > /dev/null &
    local pid=$!
    local i=0
    tput civis 2>/dev/null || true
    while kill -0 "$pid" 2>/dev/null; do
        printf "\r%s %s" "${frames[$i]}" "$message"
        i=$(( (i + 1) % ${#frames[@]} ))
        sleep 0.1
    done
    wait "$pid"
    local exit_code=$?
    printf "\r\033[K"
    tput cnorm 2>/dev/null || true
    return $exit_code
}

mkdir -p ~/.local/bin
mkdir -p ~/.config/systemd/user

run_with_braille_spinner "Installing packages…" sudo apt-get install -y $(cat ~/.local/share/debready/install/packages_list)
echo "Installing packages… done."

if [ -z "$DBUS_SESSION_BUS_ADDRESS" ]; then
    eval $(dbus-launch --sh-syntax)
    export DBUS_SESSION_BUS_ADDRESS
fi

echo "Installing beautiful font…"
~/.local/share/debready/install/font.sh

echo "Setting up Gnome…"
~/.local/share/debready/install/gnome_settings.sh

echo "Setting up shortcuts…"
dconf load "/org/gnome/settings-daemon/plugins/media-keys/" < ~/.local/share/debready/install/shortcuts.ini

echo "Setting up terminal…"
~/.local/share/debready/install/terminal.sh

echo "Installing Firefox…"
~/.local/share/debready/install/firefox.sh

echo "Installing Cursor…"
~/.local/share/debready/install/cursor.sh

echo "Installing Mise…"
~/.local/share/debready/install/mise.sh

echo "Installing Rails…"
~/.local/share/debready/install/rails.sh

echo "Making things beautiful…"
cd ~/.local/share/debready/dotfiles
stow -t "$HOME" theme-switcher
cd -
systemctl --user enable theme-switcher.service
systemctl --user start theme-switcher.service
~/.local/share/debready/install/plymouth.sh

echo "Schedule GNOME extensions install on first terminal start"
sed -i 's|shell = { program = "/bin/zsh" }|shell = { program = "~/.local/share/debready/install/gnome_extensions.sh" }|' ~/.config/alacritty/alacritty.toml
