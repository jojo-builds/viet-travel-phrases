#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/Users/jojolim/Developer/products/speaklocal/app-family"
FLOW="/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh"

cd "$REPO_ROOT"
"$FLOW" sync-nonpaywall-lanes
