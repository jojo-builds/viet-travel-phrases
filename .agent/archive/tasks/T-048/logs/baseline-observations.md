# T-048 baseline observations

## Session
- Direct task-contract session: `t048-direct-c8a40286-be5b-49ae-ad97-f89dbf6d2870`
- Observation time: `2026-04-19 10:57:49 -05:00`

## Read-first surfaces completed
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent/queue_tool.py`
- `.agent/coordination/runtime-review-path.json`
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-2\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-2\memory.md`
- `.agent/tasks/T-040/result.md`
- `.agent/tasks/T-042/result.md`
- `.agent/tasks/T-044/result.md`
- `.agent/tasks/T-046/result.md`
- `.agent/tasks/T-047/result.md`

## Current manual queue helper results
- Unsupported-runtime real claim now passes cleanly:
  - `py .agent\queue_tool.py claim-next --session-id "t048-unsupported-real-202de220-8ec3-4b9f-a868-d4f6afe3e699" --label "T-048 unsupported real" --review-runtime no-review-subagents`
  - Result: structured JSON, `result: "no_task"`, `skippedIneligible` for `T-030` through `T-037`
- Unsupported-runtime dry-run now passes cleanly:
  - `py .agent\queue_tool.py claim-next --session-id "t048-unsupported-dry-2081739f-0307-4ca6-9ad9-d97262af98e4" --label "T-048 unsupported dry" --review-runtime no-review-subagents --dry-run`
  - Result: structured JSON, `result: "no_task"`, `skippedIneligible` for `T-030` through `T-037`
- Meaningful-capable dry-run still surfaces a real meaningful task:
  - `py .agent\queue_tool.py claim-next --session-id "t048-meaningful-dry-47ad07e2-65fc-42f0-a8e2-210ca17f27db" --label "T-048 meaningful dry" --dry-run`
  - Result: structured JSON, `result: "dry-run-claimable"`, task `T-030`

## Drift and risk surfaces still present
- `task-queue-10-2` is still `ACTIVE` and still points at alias cwd `E:\AI\Viet-Travel-Phrases`.
- `task-queue-10` is `PAUSED` but its prompt body matches the repo prompt more closely.
- Prompt diff shows `task-queue-10-2` is missing:
  - the explicit `memory.md` avoidance reminder
  - the `--review-runtime no-review-subagents` startup guidance
  - the blocked-run evidence-copy instruction
  - the current repo wording for claim/runtime mismatch handling
- `task-queue-10-2` memory preserves the failure report:
  - real unsupported-runtime claim hit `PermissionError` while replacing `.agent/coordination/queue-index.json`
  - dry-run retry hit `PermissionError` appending `.agent/coordination/queue-events.jsonl`
  - stale `queue-mutation.lock` with dead PID `8084` was observed

## Helper implementation facts
- `queue_tool.py` already has:
  - dead-PID and stale-age lock recovery in `queue_mutation_lock()`
  - retrying `os.replace()` in `replace_with_retry()`
  - unsupported-runtime meaningful-task skipping in `claim_eligibility_errors()`
- `queue_tool.py` does not yet retry `append_event()`
- `queue_tool.py` still leaves unhandled `OSError` / `PermissionError` paths capable of surfacing a traceback instead of structured JSON if retries are exhausted
- `.agent/coordination/` still contains old `queue-index.json.*.tmp` files from earlier failed replace attempts

## Implication for Gate 1
- The user-facing helper crash is not reproducible from this shell right now, but the stale active automation entry and the helper's remaining write-path fragility still make recurrence plausible.
- Gate 1 should challenge whether production readiness requires:
  - helper write-path hardening beyond the current `replace_with_retry()`
  - duplicate automation retirement or authoritative re-alignment
  - explicit stale-lock and repeated live-proof evidence after any repair
