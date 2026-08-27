#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

CONTAINER=postgres17

have docker || die "docker is not installed — run: $DEBREADY_ROOT/install.sh docker"

# sg, because `usermod -aG docker` in docker.sh cannot affect this session's
# already-running processes. See the comment there.
#
# `ps -a`, not `ps`: a stopped container still holds the name and would make
# `docker run` fail.
if sg docker -c "docker ps -a --format '{{.Names}}'" | grep -x "$CONTAINER" >/dev/null; then
    sg docker -c "docker start $CONTAINER" >/dev/null
    skip "container $CONTAINER already exists"
else
    sg docker -c "docker run -d --restart unless-stopped \
        -p 127.0.0.1:5432:5432 --name $CONTAINER \
        -e POSTGRES_HOST_AUTH_METHOD=trust postgres:17" >/dev/null
fi
