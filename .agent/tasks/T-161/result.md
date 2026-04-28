## Status
- done

## Summary
- Implemented parallel-safe `claim-next` write-lock checks for queued/reclaimable candidates.
- `claim-next` now reports `skippedLockConflicts` in dry-run and real claim paths.
- Added conservative lock semantics: exact lock names conflict, path-scope `/**` locks conflict with descendants, and task-local `agent_task_T-xxx` locks do not block unrelated task folders.
- Fixed a Gate 2 reviewer-found write-block edge case by deep-copying claim state before mutation, preventing a failed candidate write from becoming an in-memory phantom active owner.

## Files changed
- `.agent/queue_tool.py`
- `.agent/tests/test_queue_tool_lock_conflicts.py`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/TASK_PROMPTING.md`
- `.agent/QUEUE_MAINTENANCE.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent/CODEX_MANUAL_TASK_PROMPT.txt`
- `.agent/tasks/T-161/reviews/**`
- `.agent/tasks/T-161/state.json`
- `.agent/coordination/queue-index.json`

## Validation
- `python3 .agent/tests/test_queue_tool_lock_conflicts.py` passed: 3 tests.
- `python3 -m py_compile .agent/queue_tool.py .agent/tests/test_queue_tool_lock_conflicts.py` passed.
- `SPEAKLOCAL_REVIEW_RUNTIME=subagents python3 .agent/queue_tool.py claim-next --dry-run --session-id validation-dry-run --label validation --lease-minutes 180` passed and returned `dry-run-claimable` for `T-160` while `T-161` was `in_progress`.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy` passed with no changes.
- `python3 .agent/queue_tool.py health` passed with no reclaimable or malformed in-progress tasks.
- `python3 -m json.tool .agent/tasks/T-161/state.json >/tmp/t-161-state.json` passed.
- `python3 -m json.tool .agent/coordination/queue-index.json >/tmp/queue-index.json` passed.
- `git diff --check` passed.

## Review gates
- Gate 1 pass 1: unanimous APPROVE.
- Gate 2 pass 1: BLOCK from queue helper code reviewer for phantom in-memory claim after handled write-block; other reviewers approved.
- Gate 2 pass 2: unanimous APPROVE after deep-copy fix and regression test.
- Gate 3 pass 1: unanimous APPROVE.

## Tradeoffs
- Lock conflict detection is intentionally conservative and small: it handles exact names and obvious `/**` descendant path scopes without trying to become a full scheduler.
- Documentation now prefers helper-backed `claim-next` for parallel safety, while preserving direct patch fallback for prompt-only desktop runs that must still re-read and honor the same lock conflict rule.

## Follow-up tasks
- Consider refreshing `.agent/coordination/locks.yaml` in a later queue-maintenance task so the legacy registry mirrors the newer lock-class guidance.
- If automation cards become common, add an explicit launcher/task for multi-card fan-out strategy; this task only made non-overlapping claims safe.

## Process feedback
- BUG Gate 2 caught a real write-block edge case where in-memory candidate mutation could have created phantom active conflicts; fixed with a regression test.
