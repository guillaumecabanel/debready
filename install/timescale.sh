#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

CONTAINER=timescaledb

have docker || die "docker is not installed — run: $DEBREADY_ROOT/install.sh docker"

# A second Postgres, on 6543 so it does not collide with the plain postgres17
# container on 5432. Apps that need hypertables point at this one.
#
# Unlike postgres17 this uses a *named* volume: the data here is worth keeping
# across a `docker rm`, and an anonymous volume makes that a lookup by hash.
if docker ps -a --format '{{.Names}}' | grep -x "$CONTAINER" >/dev/null; then
    docker start "$CONTAINER" >/dev/null
    skip "container $CONTAINER already exists"
else
    docker run -d --restart unless-stopped \
        -p 127.0.0.1:6543:5432 --name "$CONTAINER" \
        -v timescaledb_data:/var/lib/postgresql/data \
        -e POSTGRES_USER=postgres -e POSTGRES_PASSWORD=timescaledb \
        timescale/timescaledb:latest-pg17 >/dev/null
fi
