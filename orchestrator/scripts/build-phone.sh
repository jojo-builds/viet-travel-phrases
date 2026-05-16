#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/Users/jojolim/Developer/products/speaklocal/app-family"
BUILD="/Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh"

cd "$REPO_ROOT"
SPEAKLOCAL_REPO_ROOT="$REPO_ROOT" "$BUILD"
