# Debian setup
## Prerequisite
- Install Debian with no DE

```bash
# add user to sudoers
su root
apt install sudo
sudo usermod -aG sudo [username]
exit
```

## Main script

```bash
# Install packages
sudo apt install gnome-shell gnome-session gdm3 nautilus gnome-control-center gnome-settings-daemon gnome-shell-extension-prefs network-manager-gnome curl git zsh gnome-terminal plymouth-themes

# Add boot splash
sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
sudo update-grub
sudo sed -i 's/^Theme=.*$/Theme=spinner/' /usr/share/plymouth/plymouthd.defaults
sudo update-initramfs -u -k all
```
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
- terminal alacritty

### Settings
- automatic login
- compose key => capslock
- power button behaviour => nothing
- show battery percentage => ON
- Automatic screen blank => OFF
- Automatic suspend on battery power => ON, 20 minutes
- Automatic suspend when plugged in => OFF

### Shortcuts
- super + B => browser
- super + Enter => terminal
- super + F => Files

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
