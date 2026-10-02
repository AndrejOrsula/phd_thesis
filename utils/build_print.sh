#!/usr/bin/env bash
set -euo pipefail

repo_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)
exec uv run --no-project --script "$repo_dir/template/tools/build.py" \
    "$repo_dir/thesis.typ" \
    --name thesis_AndrejOrsula \
    --edition print \
    --layout "$repo_dir/utils/print_layout.sha256" \
    "$@"
