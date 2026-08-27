#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.gnupg"
chmod 700 "$HOME/.gnupg"
sudo install -d -m 0755 /etc/apt/keyrings

# boot.sh updates on the fresh-machine path, but install.sh has to stand on its
# own when a single step is re-run.
apt_refresh

# Blank lines and # comments are ignored, and the total comes from the array so
# it cannot disagree with what the loop actually iterates.
mapfile -t PACKAGES < <(grep -vE '^[[:space:]]*(#|$)' "$DEBREADY_ROOT/install/packages_list")
total=${#PACKAGES[@]}

for i in "${!PACKAGES[@]}"; do
    package="${PACKAGES[$i]}"
    printf '\rInstalling packages: [%3d%%] (%d/%d) %-28s' \
        "$(((i + 1) * 100 / total))" "$((i + 1))" "$total" "$package"

    if pkg_installed "$package"; then
        continue
    fi

    # Keep apt quiet on success, but never swallow the diagnosis of a failure.
    if ! output=$(sudo apt-get install -y "$package" 2>&1); then
        printf '\n%s\n' "$output" >&2
        die "apt-get install $package failed"
    fi
done
printf '\r%-70s\r' ""
