#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

have zsh || die "zsh is not installed — run: $DEBREADY_ROOT/install.sh packages"
ZSH_BIN="$(command -v zsh)"

# The installer exits non-zero when ~/.oh-my-zsh already exists, which would be
# fatal here. --unattended (RUNZSH=no) stops it from exec'ing a login zsh at the
# end and hijacking the rest of the install; --keep-zshrc stops it writing a
# .zshrc that would then collide with stow.
if [ -d "$HOME/.oh-my-zsh" ]; then
    skip "oh-my-zsh already installed"
else
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c \
        "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" \
        "" --unattended --keep-zshrc
fi

# CHSH=no above, because the installer's own chsh is an interactive prompt and
# our stdin may be the `wget … | bash` pipe — it silently skipped the shell
# change. sudo chsh instead of chsh: sudo is already authenticated.
# readlink -f on both sides: /bin/zsh and /usr/bin/zsh are the same shell on a
# merged-usr Debian, and comparing the raw strings would re-run chsh every time.
current_shell="$(getent passwd "$DEBREADY_USER" | cut -d: -f7)"
if [ "$(readlink -f "$current_shell")" != "$(readlink -f "$ZSH_BIN")" ]; then
    sudo chsh -s "$ZSH_BIN" "$DEBREADY_USER"
else
    skip "login shell is already $current_shell"
fi

stow_pkg alacritty
# Discard whatever .zshrc is there unless stow already owns it.
[ -L "$HOME/.zshrc" ] || rm -f "$HOME/.zshrc"
stow_pkg zsh
stow_pkg tmux
stow_pkg stamp

# Seed both theme symlinks. alacritty.toml imports ~/.current-theme.toml and
# tmux.conf sources ~/.current-tmux-theme.conf, but theme-switcher only reacts
# to gsettings *changes* — so without this the files do not exist until the user
# happens to toggle the GNOME colour scheme by hand.
ln -sfn "$HOME/.config/alacritty/theme-dark.toml" "$HOME/.current-theme.toml"
ln -sfn "$HOME/.config/tmux/theme-dark.conf" "$HOME/.current-tmux-theme.conf"
