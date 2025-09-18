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

## Main script

```bash
wget -qO- https://raw.githubusercontent.com/guillaumecabanel/debready/main/boot.sh | bash
```

## Features
- Boot splash
- Automatic login

**Gnome settings:**
- Compose key => capslock
- Power button behaviour => nothing
- Show battery percentage => ON
- Automatic screen blank => OFF
- Automatic suspend on battery power => ON, 20 minutes
- Automatic suspend when plugged in => OFF

**Shortcuts:**
- Terminal: <kbd>Super</kbd> + <kbd>Enter</kbd>
- Files: <kbd>Super</kbd> + <kbd>F</kbd>
- Browse: <kbd>Super</kbd> + <kbd>B</kbd>

**Terminal:**
- Alacritty
- Oh My Zsh

**TUI:**
- eza (aliased as `ls`)
- lazygit (aliased as `lg`)
- zoxide (aliased as `z`)
- system update (aliased as `up`)

**Fonts:**
- JetBrainsMono Nerd Font

**Apps:**
- Firefox
- Cursor

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
- mise
- ruby
- rails
- docker (postgresql, redis)
- lazydocker
- neovim
