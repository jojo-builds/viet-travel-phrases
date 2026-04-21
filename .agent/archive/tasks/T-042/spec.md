# Task Spec: T-042

## Title
Burn-in proof, queue-events and recovery-breadcrumb usability audit

## Objective
Inspect current queue event history and round-1 recovery notes to judge whether an operator could reconstruct what happened without guesswork.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/queue_tool.py`
- `.agent/coordination/queue-events.jsonl`
- `.agent/tasks/T-026/recovery-notes.md`
- `.agent/tasks/T-027/recovery-notes.md`
- `.agent/tasks/T-028/recovery-notes.md`
- `.agent/tasks/T-029/recovery-notes.md`

## Scope
### Allowed write scopes
- `.agent/tasks/T-042/**`

### Allowed read scopes
- `AGENTS.md`
- `.agent/README.md`
- `.agent/queue_tool.py`
- `.agent/coordination/queue-events.jsonl`
- `.agent/tasks/T-026/recovery-notes.md`
- `.agent/tasks/T-027/recovery-notes.md`
- `.agent/tasks/T-028/recovery-notes.md`
- `.agent/tasks/T-029/recovery-notes.md`

### Must not touch
- app runtime files outside your claimed task folder
- content-draft language files outside your claimed task folder
- shared queue docs, helper code, or automation prompt files in this task
- unrelated task folders

## Source-of-truth notes
- This is a proof/canary burn-in task for desktop queue production hardening.
- The task should gather real evidence from the live queue surfaces, but shared fixes are owned by the main orchestrator after synthesis.
- Task-local artifacts under `.agent/tasks/T-042/**` are the required output truth for this task.

## Required checks
- Document which exact signals are enough to reconstruct claim, heartbeat, reclaim, and finish history.
- Call out missing breadcrumbs or ambiguous event patterns with exact file/path evidence.

## Review gate
- This is an explicitly flagged proof task for cold-runtime burn-in.
- Nested 3-gate / 4-reviewer meaningful review is not required here.
- Store all evidence in task-local logs instead of shared review folders unless you genuinely need extra task-local review notes.

## Automation state contract
- `state.json` declares `automation.taskClass: "proof"` and `automation.proofTask: true` because this task is testing queue/process behavior, not shipping domain work.
- Passing this task does not by itself authorize meaningful production-task execution in a runtime that lacks the required nested review workflow.

## Definition of done
- Write a concise evidence log at `.agent/tasks/T-042/logs/events-and-recovery-audit.md`.
- Write `result.md` using the repo template.
- Capture concrete improvement recommendations or explicitly say the checked surface looked clean.
- Finish honestly with the helper.

## Blocker rule
- If a shared-surface defect prevents honest completion, record exact evidence and finish `blocked`.
- Do not mutate shared repo files just to force this proof task through.

## Token discipline
- Keep findings concise and evidence-based.
- Prefer exact paths, commands, and observations over long narrative.

## Required result contract
Before stopping, write `result.md` using the repo template shape.
Include compact `Process feedback` focused on the queue runner, helper, or prompt discipline.
