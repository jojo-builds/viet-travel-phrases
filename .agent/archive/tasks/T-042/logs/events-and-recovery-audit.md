# T-042 Events and Recovery Audit

## Signals that are sufficient today
- Claim history is reconstructable from `.agent/coordination/queue-events.jsonl` `claim-next-claimed` records because they include `taskId`, `claimGroup`, `taskClass`, `proofTask`, and `sessionId`.
- Heartbeat history is reconstructable from `heartbeat` records because they include `taskId`, `sessionId`, and `phase`.
- Finish history is reconstructable from `finish` and `finish-prereq-blocked` records because they include `taskId`, `sessionId`, final state/phase, blockers, and missing-prerequisite details.
- Reclaim intent is partially reconstructable when a prior `repair` record marks a task reclaimable and a later `claim-next-claimed` record shows the same task with `claimGroup: "reclaimable"`.
- Operator resume context is strongest in task-local recovery breadcrumbs such as `.agent/tasks/T-026/recovery-notes.md`, `.agent/tasks/T-027/recovery-notes.md`, `.agent/tasks/T-028/recovery-notes.md`, and `.agent/tasks/T-029/recovery-notes.md` because they state found artifacts, chosen checkpoint, next step, and carried uncertainty.

## Exact evidence checked
- `.agent/coordination/queue-events.jsonl`
  - `2026-04-19T05:32:56.393329-05:00` shows reclaimed claim of `T-901` with `claimGroup: "reclaimable"`.
  - `2026-04-19T05:33:00.457912-05:00` and `2026-04-19T05:33:00.667391-05:00` show phase progression heartbeats for `T-901`.
  - `2026-04-19T05:33:06.577003-05:00` shows `finish-prereq-blocked` for `T-901`, which is strong failure evidence before final finish.
  - `2026-04-19T05:33:06.733505-05:00` shows final blocked finish for `T-901`.
  - `2026-04-19T09:47:50.732308-05:00` through `2026-04-19T09:51:30.840481-05:00` show the round-1 reclaim/heartbeat/blocked sequence for `T-026` to `T-029`.
- Recovery breadcrumbs
  - `T-026` note clearly states found artifact, resume checkpoint, resumed next step, and uncertainty.
  - `T-027` note is usable but less templated, with the same core facts present.
  - `T-028` note clearly records a stop-before-edit checkpoint and the mismatch between repo gate and runtime capability.
  - `T-029` note clearly records stray artifact discovery and lack of durable implementation checkpoint.

## Ambiguities or missing breadcrumbs
1. Reclaim is not logged as its own explicit event.
   - Evidence: `T-901` shows a `repair` event with `normalized-reclaimable`, then a later `claim-next-claimed` with `claimGroup: "reclaimable"`, but there is no single event that says "task reclaimed by session X from prior session Y for reason Z".
   - Impact: an operator can infer reclaim, but must mentally join multiple records.
2. `claim-next-claimed` omits the run label and prior owner/session.
   - Evidence: every `claim-next-claimed` line checked contains `sessionId` but not `label`; reclaim claims also do not record the displaced owner/session from task state.
   - Impact: operators cannot map an event back to the human-readable run label without opening task state, and reclaim lineage is weaker than it could be.
3. Recovery breadcrumb shape is not fully standardized.
   - Evidence: `T-026`, `T-028`, and `T-029` use different heading/detail patterns; `T-027` uses a looser bullet style.
   - Impact: all four are usable, but comparison is slower and some fields require interpretation instead of quick scanning.
4. Session-validation failures are clear, but they do not state whether task state remained unchanged.
   - Evidence: `session-validation-failed` lines for `T-901`, `T-038`, and `T-039` capture mismatch details only.
   - Impact: safe enough, but an operator may still want to inspect state to confirm no mutation landed.

## Recommendations
- Add a dedicated reclaim event containing `taskId`, previous `session.sessionId`, new `sessionId`, and `execution.reclaimReason`.
- Include `label` in `claim-next-claimed`, `heartbeat`, and `finish` events.
- Standardize recovery-notes sections to: found artifacts, checkpoint chosen, next action, carried uncertainty.
- Optionally add a short `stateUnchanged: true` field to `session-validation-failed` events after validation exits before write.

## Overall judgment
The checked surface is usable for an operator who knows the queue model, especially when task-local recovery notes exist. The weakest part is reclaim reconstruction, because it currently depends on joining multiple events plus task-local notes instead of reading one explicit reclaim record.