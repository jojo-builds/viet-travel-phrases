# Task Spec: T-043

## Title
Burn-in proof, path-alias and atomic-write resilience audit

## Objective
Inspect the current path-resolution and atomic-write behavior after the alias-path patch, then write down any remaining junction/replace edge cases that could still break queue runs.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/queue_tool.py`
- `.agent/coordination/queue-index.json`
- `E:\AI\Viet-Travel-Phrases\.agent\coordination\queue-index.json`

## Scope
### Allowed write scopes
- `.agent/tasks/T-043/**`

### Allowed read scopes
- `AGENTS.md`
- `.agent/README.md`
- `.agent/queue_tool.py`
- `.agent/coordination/queue-index.json`
- `E:\AI\Viet-Travel-Phrases\.agent\coordination\queue-index.json`

### Must not touch
- app runtime files outside your claimed task folder
- content-draft language files outside your claimed task folder
- shared queue docs, helper code, or automation prompt files in this task
- unrelated task folders

## Source-of-truth notes
- This is a proof/canary burn-in task for desktop queue production hardening.
- The task should gather real evidence from the live queue surfaces, but shared fixes are owned by the main orchestrator after synthesis.
- Task-local artifacts under `.agent/tasks/T-043/**` are the required output truth for this task.

## Required checks
- Run non-mutating path-resolution checks with `py -c` and record the resolved roots.
- Do not create or edit shared non-task files in this audit task.

## Review gate
- This is an explicitly flagged proof task for cold-runtime burn-in.
- Nested 3-gate / 4-reviewer meaningful review is not required here.
- Store all evidence in task-local logs instead of shared review folders unless you genuinely need extra task-local review notes.

## Automation state contract
- `state.json` declares `automation.taskClass: "proof"` and `automation.proofTask: true` because this task is testing queue/process behavior, not shipping domain work.
- Passing this task does not by itself authorize meaningful production-task execution in a runtime that lacks the required nested review workflow.

## Definition of done
- Write a concise evidence log at `.agent/tasks/T-043/logs/path-alias-write-audit.md`.
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
