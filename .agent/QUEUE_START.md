# Queue Start

Use this file for repo-local Codex queue runs.

## Startup
- Normalize to `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Treat legacy Windows roots as archive references only.
- Read, in order:
  1. `AGENTS.md`
  2. `.agent/README.md`
  3. `.agent/QUEUE_START.md`
  4. `.agent/AUTOMATION.md`

## Selection
- Read `.agent/coordination/queue-index.json`.
- Check candidates in this order:
  1. `reclaimable`
  2. `queued`
- Within a group, keep the listed order.
- Before claiming, read the candidate's live `state.json` and trust that over the index.
- Skip a candidate whose `locks.write` conflicts with any active `in_progress` task's `locks.write`.
- Lock conflicts are exact lock-name matches plus path-scope overlaps where a `/**` lock owns a descendant path. Task-local locks such as `agent_task_T-161` do not block unrelated tasks.
- If a listed candidate is already terminal, owned by another live session, or otherwise ineligible, skip it immediately instead of trying to repair it during an ordinary run.

## Claim
- Confirm this worker exposes `functions.spawn_agent`.
- Prefer helper-backed claim when the helper is available:

```bash
SPEAKLOCAL_REVIEW_RUNTIME=subagents python3 .agent/queue_tool.py claim-next --session-id "<session-id>" --label "<label>" --lease-minutes 180
```

- Set `SPEAKLOCAL_REVIEW_RUNTIME=subagents` only after confirming reviewer subagents are callable in the current worker session.
- Helper-backed `claim-next` enforces active write-lock conflicts in both `--dry-run` and real claim paths.
- Generate a fresh session id and label.
- If helper-backed claim is unavailable in a prompt-only run, claim by patching the candidate `state.json` directly with exact context after applying the same lock-conflict skip rule from Selection.
- Required claim fields:
  - `status: "in_progress"`
  - `phase: "automation-claimed"`
  - `session.owner: "codex-desktop-automation"`
  - `session.sessionId: "<session-id>"`
  - `session.label: "<label>"`
  - `execution.attempt += 1`
  - `execution.claimedAt`, `execution.lastHeartbeatAt`, `execution.leaseExpiresAt`
  - `lastUpdated`
- Re-read the same `state.json` immediately. If the session id is not yours, treat the claim as lost and continue to the next candidate.
- Manual workers use the same `session.owner` value. Put `manual-...` in `session.label` instead of changing the owner, because helper-backed heartbeat and finish verify `codex-desktop-automation`.

## Execution
- Read the chosen `spec.md` and only task-required files.
- Ignore `.agent/coordination/queue-index.json` and `.agent/coordination/locks.yaml` after claim unless the task is explicitly about queue maintenance/self-heal.
- The task spec is the real prompt. Do not rely on the launch chat to carry task requirements.
- Interpret the task spec through `.agent/TASK_PROMPTING.md`: deliver the requested outcome, preserve hard constraints, choose a sound implementation path, and report evidence rather than hidden reasoning.
- Queue tasks may be substantial. A normal worker task can run for `30` minutes to several hours if the spec has clear write scope, validations, recovery notes, and review expectations.
- Heartbeat at least every `10` to `15` minutes during active work, and always before or after long waits such as builds, simulator checks, review gates, or spawned subagents.
- Prefer helper-backed heartbeat after claim:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-xxx --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 120
```

- If helper-backed heartbeat is unavailable, patch the claimed task's `state.json` directly:
  - update `phase`
  - update `execution.lastHeartbeatAt`
  - update `execution.leaseExpiresAt`
  - update `lastUpdated`
- Re-read `state.json` before substantial work, before long review passes, and before finish. If ownership changed, stop.
- For long tasks, keep compact recovery breadcrumbs in a task-local log such as `.agent/tasks/T-xxx/logs/progress.md` when the spec allows it.
- For meaningful 3-gate review tasks:
  - reviewers are fully read-only and must not write repo files or review artifacts themselves
  - each reviewer returns judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`
  - the parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses
  - close harvested reviewer agents promptly with `close_agent`
  - if a review gate aborts early or ownership is lost, close any already-started reviewer agents before stopping
  - create the current gate/pass folder on demand
  - keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifact(s), and only the latest relevant prior review artifacts for that role
  - state known runtime facts plainly in reviewer prompts instead of making reviewers infer them

## Finish
- Write `result.md` before stopping.
- For meaningful 3-gate tasks, draft `result.md` before Gate 3 and keep it `in_review` until the latest Gate 3 pass is unanimously approved.
- Include a `Process feedback` section with at least one bullet starting with `BUG`, `SUGGESTION`, or `NONE`.
- Latest-pass review artifacts must include `Approval: APPROVE` or `Approval: BLOCK`.
- Finish by patching `state.json` directly:
  - done: `status: "done"`, `phase: "completed"`
  - blocked: `status: "blocked"`, `phase: "blocked"`, real blocker in `blockers`
  - also update `execution.lastHeartbeatAt`, `execution.leaseExpiresAt`, and `lastUpdated`
- Prefer helper-backed finish when possible:

```bash
python3 .agent/queue_tool.py finish --task-id T-xxx --status done --session-id "<session-id>"
```

- Make `result.md` agree with the final `state.json` before stopping.

Process one task only, then stop.
