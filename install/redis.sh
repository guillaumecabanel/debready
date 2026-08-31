#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

CONTAINER=redis

have docker || die "docker is not installed — run: $DEBREADY_ROOT/install.sh docker"

# `ps -a`, not `ps`: a stopped container still holds the name and would make
# `docker run` fail.
#
# No -v and no --appendonly: the official image declares VOLUME /data and its
# default RDB snapshots persist there, so Sidekiq's queues survive a restart.
if docker ps -a --format '{{.Names}}' | grep -x "$CONTAINER" >/dev/null; then
    docker start "$CONTAINER" >/dev/null
    skip "container $CONTAINER already exists"
else
    docker run -d --restart unless-stopped \
        -p 127.0.0.1:6379:6379 --name "$CONTAINER" redis:8-alpine >/dev/null
fi
