#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

# --force: `ufw enable` prompts when it detects an SSH session, and our stdin
# may be a pipe rather than a terminal.
sudo ufw --force enable >/dev/null
sudo ufw logging on >/dev/null

# ufw skips a rule it already has, so the whole block stays declarative.
sudo ufw default deny incoming >/dev/null
sudo ufw default allow outgoing >/dev/null
sudo ufw allow 80/tcp >/dev/null
sudo ufw allow 443/tcp >/dev/null

# Allow LocalSend only on local IPv4 LANs
sudo ufw allow from 192.168.0.0/16 to any port 53517 proto tcp >/dev/null
sudo ufw allow from 192.168.0.0/16 to any port 53517 proto udp >/dev/null
