#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# dconf load replaces the whole subtree, so this converges on a re-run.
dconf load /org/gnome/settings-daemon/plugins/media-keys/ \
    <"$DEBREADY_ROOT/install/shortcuts.ini"
