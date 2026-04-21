# Spain tail audit

Date: 2026-04-20
Task: T-095

## Summary

- Validated the current Spain lane pronunciation posture against the drafted set and normalized one outlier: `spanish-small-talk-3` now uses `behs` instead of a Castilian-style `behth` in the `pronunciation` field.
- Replaced the residual-tail narrative with an explicit contract across `README.md`, `source-notes.md`, `first-wave-priority.csv`, and `research-backlog.md`.
- Added the pharmacy-adjacent mini-slice to `first-wave-priority.csv` so the next worker inherits an actual ranked `next` target instead of an implied future idea.

## Bucketed residual contract

- `next`
- `spanish-convenience-store-3`
- `spanish-convenience-store-4`
- `later-review`
- `spanish-convenience-store-5`
- `spanish-small-talk-5`
- `spanish-small-talk-7`
- `deferred`
- `spanish-small-talk-1`
- `spanish-small-talk-2`
- `spanish-small-talk-3`
- `spanish-small-talk-4`
- `spanish-small-talk-6`

## Validation

- `phrase-source.csv` imports cleanly with `70` rows.
- `first-wave-priority.csv` imports cleanly with `50` rows.
- Gate 1 latest pass is `gate-01-pass-02` with four explicit approvals.
- Gate 2 pass `gate-02-pass-01` has four explicit approvals.
- `git diff --name-only` was unavailable because this workspace is not mounted as a git worktree, so scope verification relied on the explicit files touched during this run.
