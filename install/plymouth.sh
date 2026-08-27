#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

need_initramfs=no

if ! grep -q '^GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"$' /etc/default/grub; then
    sudo sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=.*$/GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"/' /etc/default/grub
    sudo update-grub >/dev/null 2>&1
    need_initramfs=yes
fi

# plymouth-set-default-theme writes /etc/plymouth/plymouthd.conf. This used to
# sed /usr/share/plymouth/plymouthd.defaults, which is package-owned and gets
# overwritten on upgrade — and already ships Theme=spinner on trixie anyway.
if [ "$(/usr/sbin/plymouth-set-default-theme)" != spinner ]; then
    sudo /usr/sbin/plymouth-set-default-theme spinner
    need_initramfs=yes
fi

# By far the slowest step in the whole install, so only pay for it when one of
# the two blocks above actually changed something.
if [ "$need_initramfs" = yes ]; then
    sudo update-initramfs -u -k all >/dev/null 2>&1
else
    skip "boot splash already configured"
fi
