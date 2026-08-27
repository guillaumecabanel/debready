#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# The installer version-checks against the installed cursor.desktop and no-ops
# when it is already current, so it needs no guard of our own. -f matters:
# without it an HTTP error page would be piped into bash as a script.
curl -fsSL https://links.kuartz.fr/install_cursor | bash
