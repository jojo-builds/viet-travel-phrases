# SpeakLocal Hourly Queue Repair

Use this file for the cheap recurring queue repair pass.

## Purpose
- repair queue truth drift using each task's `state.json` as lifecycle truth
- normalize stale or malformed active ownership before workers claim more tasks
- surface newly `done` or `blocked` task state with minimal reads
- stop fast when the queue is already healthy

## Read order
1. run `powershell -NoProfile -File .agent\Invoke-SpeakLocalQueueTool.ps1 repair`
2. `queue-index.json` only after the helper runs, to confirm resulting counts if needed
3. `state.json` only for tasks whose status newly moved to `done` or `blocked`
4. `result.md` only for those newly completed/blocked tasks when their output has not yet been folded into durable truth
5. `E:\AI\OpenClaw\workspace\ops\LANES.md` only if newly completed/blocked task truth needs to be folded or surfaced
6. `.agent/queue_tool.py` only if the wrapper failed or this run is explicitly in queue self-heal/debugging mode

Do not seed new tasks in this pass.
Do not read roadmap, blueprint, or broad repo docs in this pass.
Do not do strategic prioritization in this pass.

## Fast exit
Stop immediately when all of the following are true:
- `powershell -NoProfile -File .agent\Invoke-SpeakLocalQueueTool.ps1 repair` made no lifecycle-truth changes beyond a clean queue-index rewrite
- no task newly moved to `done` or `blocked`
- no malformed `in_progress` task exists
- no reclaimable stale task needs surfacing

A healthy quiet hour should usually end here.

## Allowed actions
- helper-backed queue repair
- narrow intake for newly completed or newly blocked tasks
- narrow lane-board repair when task truth materially changed

## Forbidden actions
- no backlog seeding
- no strategic next-task authoring
- no broad doc rereads
- no manual patching of `queue-index.json` when the helper can rewrite it
- no direct `py .agent\queue_tool.py ...` launch from recurring repair; use the wrapper

## Why this exists
The old hourly pass mixed repair, intake, and strategy. That made it heavier and raised the failure surface. This file keeps the recurring lane cheap and deterministic.
