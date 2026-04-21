# Migration Cutover

## Current cutover state

The app-family repo now lives physically at the canonical family path:

- `E:\AI\SpeakLocal-App-Family`

The old Viet-named path now exists only as a compatibility junction:

- `E:\AI\Viet-Travel-Phrases` -> `E:\AI\SpeakLocal-App-Family`

The pre-cutover broken recursive tree was preserved for safety at:

- `E:\AI\VTP-recursive-recovery-20260421-150452`

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

- Promoted `E:\AI\SpeakLocal-App-Family` to the real physical git working tree.
- Recreated `E:\AI\Viet-Travel-Phrases` as a compatibility-only junction back to the family root.
- Preserved the pre-cutover broken tree as a safety archive instead of deleting it in place.
- Preserved the rescued git working state, workflow surfaces, and release-sensitive implementation surface.

## Why this was done

- The repo now has one real implementation root and one compatibility alias.
- Git, queue tooling, app validation, and website validation all resolve from the family path.
- Future sessions can start from the canonical family root without lexical-path ambiguity.

## Rollback

If an emergency rollback is ever required:

1. stop work and preserve the current family-root state
2. use the full backup at `E:\AI\Shared\Backups\speaklocal-repo-rescue\20260421-143045`
3. use the archived pre-cutover tree at `E:\AI\VTP-recursive-recovery-20260421-150452` only for forensic comparison, not as the preferred restore target

## Operating rule

- new work should start from the family path
- old Viet-named paths are compatibility-only

## Workflow normalization after cutover

- Treat the family path as both startup authority and physical git root.
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
- Git should resolve the working tree to `E:\AI\SpeakLocal-App-Family` from both the canonical path and the legacy compatibility alias.
