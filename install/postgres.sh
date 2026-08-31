#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

CONTAINER=postgres17

have docker || die "docker is not installed — run: $DEBREADY_ROOT/install.sh docker"

# `ps -a`, not `ps`: a stopped container still holds the name and would make
# `docker run` fail.
if docker ps -a --format '{{.Names}}' | grep -x "$CONTAINER" >/dev/null; then
    docker start "$CONTAINER" >/dev/null
    skip "container $CONTAINER already exists"
else
    docker run -d --restart unless-stopped \
        -p 127.0.0.1:5432:5432 --name "$CONTAINER" \
        -e POSTGRES_HOST_AUTH_METHOD=trust postgres:17 >/dev/null
fi
