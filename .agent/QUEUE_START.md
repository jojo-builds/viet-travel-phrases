# Queue Start

Use this file for repo-local Codex queue runs.

## Startup
- Normalize to `E:\AI\SpeakLocal-App-Family`.
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
- If a listed candidate is already terminal, owned by another live session, or otherwise ineligible, skip it immediately instead of trying to repair it during an ordinary run.

## Claim
- Confirm this worker exposes `functions.spawn_agent`.
- Generate a fresh session id and label.
- Claim by patching the candidate `state.json` directly with exact context.
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

## Execution
- Read the chosen `spec.md` and only task-required files.
- Ignore `.agent/coordination/queue-index.json` and `.agent/coordination/locks.yaml` after claim unless the task is explicitly about queue maintenance/self-heal.
- Heartbeat by patching the claimed task's `state.json`:
  - update `phase`
  - update `execution.lastHeartbeatAt`
  - update `execution.leaseExpiresAt`
  - update `lastUpdated`
- Re-read `state.json` before substantial work, before long review passes, and before finish. If ownership changed, stop.
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
- Make `result.md` agree with the final `state.json` before stopping.

Process one task only, then stop.
