# Debian setup
## Prerequisite
**Install Debian**
- Full disk encryption
- No DE


If you set a root password:

```bash
# Add user to sudoers
su root
apt install sudo
sudo usermod -aG sudo [username]
exit
```

## Installation

```bash
wget -qO- https://raw.githubusercontent.com/guillaumecabanel/debready/main/boot.sh | bash
```

## Re-running

Every step is idempotent, so the whole setup or any single step can be repeated
safely on an already-provisioned machine.

```bash
cd ~/.local/share/debready
./install.sh --list            # show the steps, in run order
./install.sh                   # run all of them
./install.sh docker postgres   # run only these
```

`boot.sh` is the fresh-machine entry point only: it resets the checkout to
`origin/main`, discarding local changes. Re-run `install.sh` directly instead.

## Features

**Shortcuts:**
- Terminal: <kbd>Super</kbd> + <kbd>Enter</kbd>
- Files: <kbd>Super</kbd> + <kbd>F</kbd>
- Downloads: <kbd>Super</kbd> + <kbd>D</kbd>
- Default browser (Firefox): <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>Enter</kbd>
- Firefox "Perso" profile: <kbd>Super</kbd> + <kbd>B</kbd>
- Copy today's date (`yyyymmdd`) to the clipboard: <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>D</kbd>
- Switch to workspace 1-5: <kbd>Super</kbd> + <kbd>1</kbd>…<kbd>5</kbd>
- Move window to workspace 1-5: <kbd>Super</kbd> + <kbd>Shift</kbd> + <kbd>1</kbd>…<kbd>5</kbd>
- Tile manager: <kbd>Super</kbd> + <kbd>T</kbd>
- Clipboard history: <kbd>Alt</kbd> + <kbd>V</kbd>

**Apps:**
- Alacritty
- Chrome
- Firefox (the default browser)
- VSCodium (settings and extensions provisioned)

**Terminal:**
- Zsh with Oh My Zsh
- Starship prompt
- tmux, started by Alacritty (prefix <kbd>Ctrl</kbd> + <kbd>Space</kbd>)
- Alacritty, tmux and VSCodium follow the GNOME light/dark colour scheme automatically

**Shell tools:**
- eza (aliased as `ls`)
- zoxide (aliased as `z`)
- system update (aliased as `up`)
- gh, jq, sqlite3, wl-clipboard

**TUI:**
- lazygit (aliased as `lg`)
- lazydocker (aliased as `ld`)

**Dev:**
- Mise
- Ruby
- Rails
- Ruby LSP (VSCodium extension)
- Docker
- PostgreSQL running in Docker
- Redis running in Docker

**Misc:**
- Boot splash
- Automatic login
- Set <kbd>Capslock</kbd> as Compose key
- Set power button behaviour to nothing
- Show battery percentage
- 24h clock
- 5 fixed workspaces
- Remove automatic screen blank
- Automatic suspend on battery power afer 20 minutes
- Remove automatic suspend when plugged in
- Disable hot corners
- JetBrainsMono Nerd Font

## Troubleshoot
### Wifi issues
```
cat /etc/NetworkManager/NetworkManager.conf
```

```
[main]
plugins=ifupdown,keyfile

[ifupdown]
managed=true
```

last line of `/etc/network/interfaces` should be
```
iface lo inet loopback
```

## TODO

### Apps
- localsend (need script)

### TUI
- fzf
- fd

### Dev setup
- neovim
