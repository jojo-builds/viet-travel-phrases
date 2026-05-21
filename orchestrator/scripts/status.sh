#!/usr/bin/env bash
set -euo pipefail

REPO_ROOT="/Users/jojolim/Developer/products/speaklocal/app-family"
FLOW="/Users/jojolim/.codex/skills/speaklocal-parallel-feature-workflows/scripts/speaklocal-feature-flow.sh"

cd "$REPO_ROOT"

echo "== SpeakLocal Orchestrator Status =="
date "+%Y-%m-%d %H:%M:%S %Z"
echo

echo "== Main =="
git status --short --branch
git rev-parse --short HEAD
git log -1 --oneline
echo

echo "== Worktrees =="
git worktree list
echo

echo "== Feature Flow Status =="
"$FLOW" status
