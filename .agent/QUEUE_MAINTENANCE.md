# SpeakLocal Queue Maintenance And Top-Up

Use this file for the heavier maintenance and queue top-up pass.

## Purpose
- run after cheap queue repair is already in place
- intake any newly completed task outputs into durable docs and lane state
- keep the queued backlog at a minimum depth of `6` meaningful non-overlapping tasks
- seed only tasks that are useful, substantial enough for the 3-gate review contract, and safe against current active locks
- handle the heavier strategic/top-up work that should not happen in every hourly repair cycle

## Lean read order
Read only what is needed, in this order.

1. `.agent/QUEUE_REPAIR.md`
2. run `powershell -NoProfile -File .agent\Invoke-SpeakLocalQueueTool.ps1 repair`
3. `.agent/coordination/locks.yaml`
4. the `state.json` files for tasks currently listed in `reclaimable`, `queued`, `in_progress`, and `blocked`
5. `state.json` files for at most the newest `4` tasks in `recently_completed`, and only to verify whether one of them changed since the last folded truth
6. `result.md` only for tasks whose `state.json` now says `done` or `blocked` and whose output has not yet been folded into durable truth
7. `E:\AI\OpenClaw\workspace\ops\LANES.md` only if there is drift to repair, a newly completed task to fold in, or a new queued task to seed
8. `docs/LANGUAGE_PREP_WORKFLOW.md` only if a completed prep-lane task changed prep truth
9. `docs/PRIORITIES.md`, `docs/V2_BASELINE.md`, and `docs/V2_CONTENT_MODEL.md` only if a completed task actually changed roadmap or blueprint truth
10. `.agent/queue_tool.py` only if the wrapper failed or this run is explicitly in queue self-heal/debugging mode

Do not read broad repo docs just because this is an hourly pass. If nothing changed materially, stop early.

## Fast-exit rule
After the helper-backed state check, stop immediately with no further reads or writes when all of the following are true:
- `powershell -NoProfile -File .agent\Invoke-SpeakLocalQueueTool.ps1 repair` made no lifecycle-truth changes beyond a clean queue-index rewrite
- no task newly moved to `done` or `blocked`
- queued depth is already `6` or more
- no reclaimable stale task needs action
- no blocker or integrity issue needs surfacing
- no desktop-app-stall signal is present

A healthy quiet top-up pass should usually end here.

## Queue-index handling rule
Treat `queue-index.json` as a rebuildable fast-selection aid, not a fragile patch target.

1. Prefer `powershell -NoProfile -File .agent\Invoke-SpeakLocalQueueTool.ps1 repair` as the first repair path.
2. Let the helper normalize reclaimable task state and rewrite `queue-index.json` in one pass.
3. Do not issue multiple partial edits to `queue-index.json` in the same maintenance run when a helper-backed rewrite can do the job.
4. After rewriting, treat the file as settled for the rest of the run unless a newly seeded task requires one final full rewrite.

Prefer a single full-file rewrite over brittle exact-text edits.

## Hourly maintenance contract
1. Repair queue drift first. If `queue-index.json` disagrees with `state.json`, trust `state.json`.
2. Intake newly completed tasks next.
3. Update only the smallest durable truth surfaces actually changed by that task result.
4. Before top-up, check for a desktop-app stall condition when queue depth is already healthy enough that the run would otherwise do nothing.
5. Keep queued depth at `6` or more. Count only `queued`, not `in_progress`.
6. Top up with meaningful non-overlapping tasks only.
7. Prefer current strategic direction over filler:
   - Viet device proof and honest readiness truth
   - Tagalog v2 real content and graduation work after current prep finishes
   - bounded website seam integrity work
   - bounded audio/truth audits
   - phrase-relationship / listing-detail hardening work for Viet and Tagalog
   - future-language prep only when it does not crowd out the real runtime path
8. Do not create queued tasks that overlap current `in_progress` write locks.
9. Every seeded meaningful task must follow the 3-review-gate rule with exactly 4 Codex subagents per gate and unanimous approval before advancement.
10. Stay quiet unless there is a real blocker, a meaningful completion, or a decision the human needs to make.

## Desktop-app stall recovery rule
Use the same hourly maintenance cron for guarded desktop-app recovery. Do not create a separate rapid watchdog loop.

Treat these as a likely stall signal when taken together:
- queued depth is already at or above target, so no top-up is needed
- no task newly moved to `done` or `blocked` this run
- no queued task was claimed since the previous maintenance run, or an `in_progress` task was normalized into stale/reclaimable state without forward progress
- one or more meaningful tasks show stale ownership patterns such as `stale-awaiting-reclaim`, `inactive-in-progress`, or equivalent helper-normalized reclaim posture

When that signal is present:
1. check a small recovery ledger under `.agent/coordination/desktop-app-recovery.json`
2. if the Codex desktop app is not running and queued/reclaimable/in-progress work exists, start it first and record that start event
3. otherwise, if no restart was attempted recently, do one controlled restart of the Windows Codex desktop app
4. record the timestamp, reason, and observed queue state in the recovery ledger
5. do not loop starts/restarts inside the same maintenance run
6. on the next hourly run, prefer evidence of resumed claims/completions before attempting another restart
7. if the app is still stalled after a recent restart, surface it as a real blocker instead of thrashing

Guardrails:
- if the app is missing entirely, starting it is allowed even when a prior restart cooldown exists
- never restart repeatedly inside one run
- never restart just because queued depth is high; require stalled movement too
- prefer one restart attempt per stuck episode, then wait for the next cron cycle to judge recovery
- if live claims/completions resumed, clear the stuck episode and do not restart

## Intake scope rule
Default fold-in targets are narrow:
- repo-local task `state.json`
- `queue-index.json`
- `E:\AI\OpenClaw\workspace\ops\LANES.md`
- the smallest affected project truth file, such as `docs/LANGUAGE_PREP_WORKFLOW.md`

Do not reopen roadmap or blueprint docs unless the completed task genuinely changes them.
Do not reread old completed tasks just to restate known truth.

## Queue-top-up rule
- minimum queued depth target: `6`
- if queued depth drops below `6`, seed enough new tasks to restore it to at least `6`
- favor distinct write locks so multiple desktop Codex runs can stay parallel-safe
- bias new queued work toward Tagalog/Viet implementation and validation before adding more future-language prep
- do not seed tasks whose likely execution scope is too small to justify the full 3-gate / 4-reviewer unanimous-review cost
- default to tasks that require real synthesis, restructuring, or multi-artifact hardening, not simple row cleanup or a thin second-pass sweep
- for bulk phrase authoring or translation tasks, do not seed tiny conservative batches; default to clearing the full currently unresolved high-value set and usually require at least `24` row outcomes before a batch can count as meaningful
- for meaningful authoring tasks, prefer a stronger floor such as one of:
  - a full unresolved cluster across multiple related traveler situations
  - a starter-to-premium boundary hardening pass with schema/docs/audit updates together
  - a phrase-family restructuring pass that changes source rows, notes, prioritization, and handoff docs together
  - a retrieval/listing improvement pass that requires related-phrase mapping, phrase-detail enrichment, and public/runtime truth updates together
- if a candidate would mostly be "translate the next few rows" or "do a small unresolved-row reduction pass," merge it into a larger contract or leave the queue slot open
- only allow smaller row-count batches when the category is genuinely sensitive, expert-gated, or the bounded high-value set is actually smaller than that floor
- if no high-value non-overlapping task exists, document the true bottleneck instead of inventing filler

## Meaningful-task floor rule
When the cron seeds a task that carries the mandatory 3-gate / 4-subagent review contract, that task must be large enough that the review compute is proportionate.

A seeded meaningful task should usually satisfy most of these:
- touches multiple truth surfaces, not just one CSV
- leaves behind a materially better runtime/content handoff, not just more rows
- requires judgment about structure, prioritization, or relation modeling, not just direct translation
- reduces a real unresolved cluster or creates a reusable content-system improvement
- would still feel worth doing even if review cost were visible to a human reviewer

If a candidate does not clear that bar, either:
- merge it into a deeper task contract, or
- classify it as a lighter non-meaningful/proof lane outside the heavy review path, or
- do not seed it yet

## Reliability note from first cron test
The first hourly test proved the maintenance flow could do useful intake and queue seeding, but it was too expensive and ended with a brittle `queue-index.json` edit failure. The queue is now split conceptually:
- `QUEUE_REPAIR.md` for cheap recurring repair
- this file for heavier intake/top-up work when needed

That split exists to avoid repeating the old pattern of paying strategic queue-authoring cost every hour.
