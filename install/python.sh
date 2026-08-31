#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

PYTHON_VERSION=3.14

have mise || die "mise is not installed — run: $DEBREADY_ROOT/install.sh mise"

# uv from the mise registry (aqua:astral-sh/uv), for the same reason lazydocker
# comes from there (see install/docker.sh): Astral publishes no apt repo, uv is
# not in trixie, and their curl|sh installer appends a PATH line to ~/.zshrc —
# which is a stow symlink into this checkout, so the line would land in git.
mise use --global uv@latest >/dev/null

# Step scripts are plain bash with no mise activation, so uv is not on PATH
# here — same reason rails.sh goes through `mise exec ruby -- gem`.
#
# --default adds `python` and `python3` to ~/.local/bin next to `python3.14`.
# .zshrc prepends that directory, so this shadows Debian's /usr/bin/python3 in
# interactive shells. Deliberate. Anything with an absolute shebang — pipx's
# gext, apt-installed tooling — keeps running the system interpreter.
#
# `uv python install` exits 0 with a notice when the version is already there,
# so this needs no guard (same as the pipx call in gnome_settings.sh).
#
# --preview-features only silences uv's "the --default option is experimental"
# warning; without it every re-run prints it. Drop it once --default is stable.
mise exec uv -- uv python install "$PYTHON_VERSION" \
    --default --preview-features python-install-default >/dev/null
