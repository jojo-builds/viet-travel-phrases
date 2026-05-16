#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 1 ]]; then
  echo "Usage: $0 <feature-slug>" >&2
  exit 2
fi

REPO_ROOT="/Users/jojolim/Developer/products/speaklocal/app-family"
FLOW="/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh"

cd "$REPO_ROOT"
"$FLOW" create "$1"
