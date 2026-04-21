# Migration Cutover

## Current cutover state

The app-family repo is now operated from the canonical family path:

- `E:\AI\SpeakLocal-App-Family`

The physical live working tree is still backed by:

- `E:\AI\Viet-Travel-Phrases`

This is intentional during the transition window.

## Path map

- canonical family path:
  - `E:\AI\SpeakLocal-App-Family`
- canonical OpenClaw/Codex workspace path:
  - `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`
- compatibility alias:
  - `E:\AI\Viet-Travel-Phrases`
- compatibility workspace alias:
  - `C:\Users\Administrator\.openclaw\workspace\projects\viet-travel-phrases`

## What changed

- Added the canonical family paths as junctions to the existing live repo.
- Did not physically rename or move the live working tree yet.
- Preserved the current git working state and release-sensitive implementation surface.

## Why this was done first

- The live repo has a dirty working tree.
- Alias-first cutover makes rollback trivial.
- It standardizes future sessions on the family path without risking the active implementation.

## Rollback

If the alias-first cutover needs to be reversed:

1. remove `E:\AI\SpeakLocal-App-Family`
2. remove `C:\Users\Administrator\.openclaw\workspace\projects\speaklocal-app-family`
3. leave the live repo untouched at `E:\AI\Viet-Travel-Phrases`

## Remaining transition rule

- new work should start from the family path
- old Viet-named paths are compatibility-only

## Workflow normalization during transition

- Treat repo startup authority as normalized even before the physical git root is renamed.
- Broad manual sessions should start from:
  - `AGENTS.md`
  - `docs/DECISIONS.md`
  - `docs/PRIORITIES.md`
  - `docs/operations/README.md`
- Repo-local queue runs should start from:
  - `AGENTS.md`
  - `.agent/README.md`
  - `.agent/QUEUE_START.md`
  - `.agent/AUTOMATION.md`
- `docs/START_SESSION.md`, `docs/CURRENT_STATE.md`, and `docs/NEXT_STEPS.md` may exist only as compatibility pointers for older references. They must not become maintained duplicate truth surfaces again.
- During this alias-first window, Git may still resolve the working tree to `E:\AI\Viet-Travel-Phrases`. Treat that as a lexical/path migration detail, not as the startup authority.
