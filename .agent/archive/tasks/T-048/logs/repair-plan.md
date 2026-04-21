# T-048 revised repair plan after Gate 1 pass 1

## Verified facts
- Manual helper checks from the main lane now pass for:
  - unsupported-runtime real claim
  - unsupported-runtime dry-run
  - meaningful-capable dry-run
- `task-queue-10-2` is still the active duplicate automation surface and still embeds stale prompt/cwd guidance.
- `task-queue-10` is the closer-to-truth automation surface but is still paused.
- `queue_tool.py` still has an uncovered crash family:
  - retrying atomic JSON replace exists
  - `append_event()` still has no retry/fallback
  - `main()` still does not catch `OSError` / `PermissionError`
  - failed atomic replace attempts have already left `queue-index.json.*.tmp` residue under `.agent/coordination/`

## Gate 1 pass 1 blockers to fix in the plan
- Treat authoritative automation state as a first-class repair item:
  - promote exactly one automation id as the sole authoritative runner
  - retire/disable the duplicate entry so there is no same-name ambiguity
  - do not treat alias `cwd` spelling alone as the root cause
- Harden both observed write-failure paths:
  - `queue-index.json` replacement
  - `queue-events.jsonl` append
- Make helper write failures return structured output instead of a traceback wherever possible.
- Add evidence enforcement in `state.json` so T-048 cannot finish `done` without the required verification ledger and recovery logs.
- Explicitly prove the original crash family under controlled failure injection:
  - forced `queue-events.jsonl` append denial
  - forced `queue-index.json` replace denial
  - expected outcome: no raw traceback, structured output, recoverable coordination state
- Run the unsupported-runtime `no_task` proof against a drained proof-task queue snapshot so proof-task traffic cannot mask the meaningful-skip evidence.
- Keep a timestamped aggregate ledger for all proof-task runs, including claim, heartbeat, finish, task id, and runner identity.
- Include a post-retirement survivor smoke for the authoritative automation entry itself, using the surviving prompt/cwd posture rather than only ad hoc helper commands.

## Revised execution sequence
1. Preserve current baseline evidence and Gate 1 pass 1 review artifacts.
2. Implement helper hardening for:
   - retrying / best-effort event-log append
   - structured handling for write-path `OSError` / `PermissionError`
   - temp-file cleanup / recoverability after failed atomic writes
   - safer stale-lock recovery when metadata is malformed
3. Make `task-queue-10` the only authoritative queue automation entry and retire `task-queue-10-2` explicitly.
4. Prove injected coordination-write failures are now safe:
   - forced `queue-events.jsonl` append denial
   - forced `queue-index.json` replace denial
   - verify structured output, no raw traceback, and no unsafe residue beyond clearly logged recoverable artifacts
5. Re-run baseline verification:
   - `py -m py_compile .agent\queue_tool.py`
   - unsupported-runtime real claim with a drained proof-task queue
   - unsupported-runtime dry-run with a drained proof-task queue
   - meaningful-capable dry-run
   - stale-lock recovery proof
    - one survivor-automation smoke using the authoritative `task-queue-10` prompt/cwd posture after the duplicate is retired
6. Create bounded proof-only tasks `T-050` through at least `T-059`.
7. Run 10 or more real proof-task queue pickups through the live helper path with Codex subagents, including bounded parallel batches.
8. Build a timestamped verification ledger and throughput/parallel summary from queue events plus task artifacts.
9. Rerun Gate 1 on this revised plan, then move to implementation only if all 4 reviewers approve.

## Intended authoritative automation posture
- Survivor: `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- Retired duplicate: `C:\Users\Administrator\.codex\automations\task-queue-10-2\automation.toml`
- Final posture target:
  - one active authoritative queue runner entry
  - one clearly retired duplicate with no ambiguity about which id operators should trust
