#!/usr/bin/env bash

set -euo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/common.sh"

mise use --global ruby@latest >/dev/null

# `settings add` appends to a list, so it is the one call here that does not
# converge on its own.
if ! mise settings get idiomatic_version_file_enable_tools 2>/dev/null | grep '"ruby"' >/dev/null; then
    mise settings add idiomatic_version_file_enable_tools ruby
fi

if mise exec ruby -- gem list -i bundler >/dev/null 2>&1 \
    && mise exec ruby -- gem list -i rails >/dev/null 2>&1; then
    skip "bundler and rails already installed"
else
    mise exec ruby -- gem install bundler rails --no-document >/dev/null
fi
