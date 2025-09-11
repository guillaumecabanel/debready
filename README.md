# Debian setup
## Prerequisite
- Install Debian with no DE

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
- Super + Enter => terminal
- Super + F => Files

**Terminal:**
- Alacritty
- Oh My Zsh

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

### Fonts
Caskaydia Mono Nerd Font

### Gnome extensions
- tactile
- clipboard history

### Apps
- localsend (need script)
- firefox (need script)

### Shortcuts
- super + B => browser

### Terminal
( see gnu stow ?)
- ohmyzsh
- [prompt](https://starship.rs/)
- fzf
- zoxide
- eza
- fd

### Dev setup
- mise
- ruby
- rails
- docker (postgresql, redis)
- lazydocker
- lazygit
- neovim
- cursor
