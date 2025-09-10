#!/bin/bash

set -e

sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
sudo update-grub
sudo sed -i 's/^Theme=.*$/Theme=spinner/' /usr/share/plymouth/plymouthd.defaults
sudo update-initramfs -u -k all
