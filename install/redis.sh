#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

CONTAINER=redis

have docker || die "docker is not installed — run: $DEBREADY_ROOT/install.sh docker"

# sg, because `usermod -aG docker` in docker.sh cannot affect this session's
# already-running processes. See the comment there.
#
# `ps -a`, not `ps`: a stopped container still holds the name and would make
# `docker run` fail.
#
# No -v and no --appendonly: the official image declares VOLUME /data and its
# default RDB snapshots persist there, so Sidekiq's queues survive a restart.
if sg docker -c "docker ps -a --format '{{.Names}}'" | grep -x "$CONTAINER" >/dev/null; then
    sg docker -c "docker start $CONTAINER" >/dev/null
    skip "container $CONTAINER already exists"
else
    sg docker -c "docker run -d --restart unless-stopped \
        -p 127.0.0.1:6379:6379 --name $CONTAINER redis:8-alpine" >/dev/null
fi
