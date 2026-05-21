# Migration Cutover

## Current State

SpeakLocal development is MacBook-only now.

The canonical working root is:

- `/Users/jojolim/Developer/products/speaklocal/app-family`

The active app product surface is:

- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`

Do not treat any Windows path as a live workspace. Older Windows paths may remain in archived notes for historical lookup only.

## Historical Context

Earlier repo recovery work used Windows paths such as `E:\AI\SpeakLocal-App-Family`. That was a temporary migration state, not the current development setup.

Those paths are now archive context only:

- do not start new work from them
- do not copy commands from them into current task specs
- do not use them as canonical roots in docs, scripts, or agent instructions

## Operating Rule

New work starts from the Mac repo root and uses the native iOS app:

1. Open `/Users/jojolim/Developer/products/speaklocal/app-family`.
2. Use `native-ios/` for all app implementation, simulator testing, iPhone builds, and SwiftUI/Liquid Glass work.
3. Use feature worktrees under `.worktrees/` only for parallel lanes.
4. Keep `main` as the source for Jojo's phone build unless he explicitly asks to test a feature branch.

## Workflow Normalization

Broad sessions should start from:

- `AGENTS.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/operations/README.md`

Native app sessions should also read:

- `native-ios/AGENTS.md`
- `docs/operations/TESTING_RUNBOOK.md`

Repo-local queue runs should start from:

- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`

`docs/START_SESSION.md`, `docs/CURRENT_STATE.md`, and `docs/NEXT_STEPS.md` may exist only as compatibility pointers for older references. They must not become maintained duplicate truth surfaces again.
