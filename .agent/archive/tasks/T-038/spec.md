# Task Spec: T-038

## Title
Desktop Codex automation proof task, helper-based claim heartbeat finish verification

## Objective
Run one controlled synthetic/proof queue task end to end so the desktop automation lane proves it can honestly:
- real-claim a task
- stay inside task scope
- send at least one helper heartbeat during execution
- write `result.md` with `Process feedback`
- finish `done`

This task is explicitly approved as a proof/synthetic queue test task for the controlled runner verification pass. It is not meaningful production work.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/queue_tool.py`
- `.agent/tasks/TEMPLATE/result.md`

## Scope
### Allowed write scopes
- `.agent/tasks/T-038/**`

### Allowed read scopes
- `.agent/tasks/TEMPLATE/**`
- `.agent/queue_tool.py`

### Must not touch
- `app/**`
- `site/**`
- `content-draft/**`
- `docs/**`
- `ops/**`
- `.agent/coordination/locks.yaml`
- any other task folder besides `T-038`

## Source-of-truth notes
- This task changes planning/workflow proof truth only.
- It exists only to verify the helper-driven desktop queue process under controlled conditions.
- Do not treat completion of this task as evidence that meaningful production tasks are now approved.
- Passing T-038 does not authorize selecting any meaningful queued task until a separate meaningful-task runtime review proof exists.

## Required outputs
Create or update these files:
- `.agent/tasks/T-038/logs/proof-run.md`
- `.agent/tasks/T-038/result.md`

## Required checks
- confirm the task was actually claimed by your session id
- send at least one helper heartbeat using a proof-specific phase such as `proof-executing`
- re-read `state.json` after heartbeat and confirm ownership still matches your session id
- verify `result.md` includes a `Process feedback` section with `BUG`, `SUGGESTION`, or `NONE`
- verify no writes happened outside `.agent/tasks/T-038/**`

## Review gate
- No multi-gate review loop is required for this synthetic proof task.
- Use a concise self-check instead: be honest about whether claim, heartbeat, result writing, and finish actually worked.

## Definition of done
- the task was really claimed by the current session
- at least one helper heartbeat was sent during task execution
- `.agent/tasks/T-038/logs/proof-run.md` exists and briefly records the proof steps taken
- `.agent/tasks/T-038/result.md` exists and follows the repo result template shape
- `result.md` includes a real `Process feedback` note or explicit `NONE`
- the task is finished with helper `finish --status done`
- no non-task files were edited

## Blocker rule
- if claim ownership is lost, helper commands fail, or finish cannot honestly complete, stop and finish `blocked` with the real blocker instead of improvising around it

## Token discipline
- keep the proof lean
- do not read broad repo docs or unrelated task folders
- do not add new process features during this task
- prefer a short proof log over narrative sprawl

## Required result contract
Before stopping, write `result.md` using the repo template shape.
The result must include a compact `Process feedback` section focused on the automation/process itself, not the domain task itself.
Capture only things like:
- unnecessary context the worker had to read or reason through
- confusing or conflicting instructions
- avoidable retries or bookkeeping
- tooling or workflow changes that would make the next run cleaner
If there is nothing useful to report, say `NONE` explicitly instead of inventing feedback.
