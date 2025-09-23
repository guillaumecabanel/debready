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

## Features

**Shortcuts:**
- Terminal: <kbd>Super</kbd> + <kbd>Enter</kbd>
- Files: <kbd>Super</kbd> + <kbd>F</kbd>
- Browse: <kbd>Super</kbd> + <kbd>B</kbd>
- Tile manager: <kbd>Super</kbd> + <kbd>T</kbd>
- Clipboard history: <kbd>Alt.</kbd> + <kbd>V</kbd>

**Apps:**
- Alacritty
- Firefox
- Cursor

**Shell tools:**
- Oh My Zsh
- eza (aliased as `ls`)
- zoxide (aliased as `z`)
- system update (aliased as `up`)

**TUI:**
- lazygit (aliased as `lg`)

**Dev:**
- Mise
- Ruby
- Rails

**Misc:**
- Boot splash
- Automatic login
- Set <kbd>Capslock</kbd> as Compose key
- Set power button behaviour to nothing
- Show battery percentage
- Remove automatic screen blank
- Automatic suspend on battery power afer 20 minutes
- Remove automatic suspend when plugged in
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

### Gnome extensions
- tactile
- clipboard history

### Apps
- localsend (need script)

### TUI
- fzf
- fd

### Dev setup
- docker (postgresql, redis)
- lazydocker
- neovim
