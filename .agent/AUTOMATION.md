# Desktop Codex Automation Rules

Use this file when the automation prompt says to process the next repo-local queue task.

## Scope
- This is a queue run, not a broad repo session.
- Do not load broad family docs or skills unless the claimed task spec requires them.
- Do not read automation `memory.md` during normal queue execution.
- Once claimed, do not keep revisiting queue-index or locks unless the task is explicitly queue maintenance/self-heal.

## Core Flow
1. Follow `.agent/QUEUE_START.md` to shortlist and claim exactly one task by direct `state.json` patch plus immediate re-read.
2. Execute only that task and keep ownership fresh with heartbeat patches.
3. Write `result.md`, then patch `state.json` to `done` or `blocked`.

## Meaningful Review Contract
- Reviewers are fully read-only. They must not edit repo files or write review artifacts themselves.
- Each reviewer returns judgment text only, including explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker creates the gate/pass folder on demand and writes all 4 review artifacts in one `apply_patch` after the reviewer responses arrive.
- After harvesting a reviewer result, the parent worker should `close_agent` that reviewer promptly. Historical session logs may remain on disk; idle reviewer agents should not remain open.
- If a review gate aborts early or ownership is lost, close any already-started reviewer agents before stopping.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifact(s), and only the latest relevant prior review artifacts for that role.
- Create gate/pass folders on demand.
- Keep `result.md` at `in_review` until the latest Gate 3 pass is unanimous, then finalize `result.md` and `state.json` together.

## Guardrails
- `state.json` is lifecycle truth; `queue-index.json` is advisory only.
- Skip stale shortlist entries quickly instead of trying to heal them during ordinary task execution.
- If a claim patch fails or the re-read `session.sessionId` is not yours, move to the next eligible task instead of looping on the same file.
- If no candidate can be claimed, stop honestly and report why.
- If the runtime cannot satisfy the required 3-gate / 4-subagent / unanimous review contract for meaningful tasks, stop honestly instead of downgrading.
- Process one task only, then stop.
