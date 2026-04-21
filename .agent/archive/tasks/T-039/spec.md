# Task Spec: T-039

## Title
Desktop Codex automation runtime-proof task, full meaningful review-path execution proof

## Objective
Prove that the desktop Codex queue lane can execute the full meaningful-task contract end to end before normal meaningful production tasks are admitted.

This task is **not** a lightweight synthetic proof. It is a dedicated `runtime-proof` bridge task for production-readiness certification.

It must prove the live queue runtime can do the core end-to-end execution path honestly:
- real claim
- helper heartbeats during execution
- real `result.md`
- helper `finish --status done`

The required 4-subagent production-readiness review for this certification run is handled **externally** by the cold validation lanes launched by OpenClaw, not by nested subagent spawning inside this task itself. That external 4-lane certification gate is the required review authority for this bridge task.

This task still must not change app code, website code, content lanes, or release surfaces. Its purpose is to prove the desktop lane can honestly satisfy the core review/finish-capable runtime path before normal meaningful tasks are admitted.

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
- `.agent/tasks/T-039/**`

### Allowed read scopes
- `.agent/tasks/TEMPLATE/**`
- `.agent/queue_tool.py`
- `.agent/AUTOMATION.md`
- `.agent/QUEUE_START.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`

### Must not touch
- `app/**`
- `site/**`
- `content-draft/**`
- `docs/**`
- `ops/**`
- `.agent/coordination/locks.yaml`
- any other task folder besides `T-039`

## Source-of-truth notes
- This task changes planning/process proof truth only.
- It exists to prove the desktop queue runtime can satisfy the core claim / heartbeat / artifact / finish path under real execution, while the 4 cold validation lanes provide the production-readiness certification review externally.
- Passing this task, together with unanimous cold-lane certification, may justify future `automation.runtimeReviewPathProven: true` decisions for bounded meaningful tasks, but it does not by itself approve every queued production task automatically.

## Required outputs
Create or update these files:
- `.agent/tasks/T-039/logs/runtime-proof-run.md`
- `.agent/tasks/T-039/result.md`

## Required checks
- confirm the task was actually claimed by your session id
- send heartbeats on phase changes and at least once during each major stage of the run
- re-read `state.json` before each gate and before finish to confirm ownership still matches your session id
- verify `result.md` includes a `Process feedback` section with `BUG`, `SUGGESTION`, or `NONE`
- verify no writes happened outside `.agent/tasks/T-039/**`

## Review gate
- No nested in-task review-gate loop is required for this bridge task.
- The required review authority for this certification run is the external 4-cold-subagent production-readiness gate orchestrated by OpenClaw.
- This task should therefore leave behind clean execution artifacts for those 4 external validators to inspect.

## Definition of done
- the task was really claimed by the current session
- the run left a durable proof log at `.agent/tasks/T-039/logs/runtime-proof-run.md`
- `.agent/tasks/T-039/result.md` exists and follows the repo result template shape
- `result.md` includes a real `Process feedback` note or explicit `NONE`
- helper `finish --status done` succeeds honestly
- no non-task files were edited
- the external 4-cold-subagent certification gate can inspect the task artifacts and agree the bridge run was production-ready

## Blocker rule
- if claim ownership is lost or finish cannot honestly complete, stop and finish `blocked` with the real blocker instead of improvising around it

## Token discipline
- keep the proof focused on the runtime contract itself
- do not read broad repo docs or unrelated task folders
- do not add new process features mid-task unless a real blocker leaves no smaller path
- prefer short proof artifacts over long narrative recaps

## Required result contract
Before stopping, write `result.md` using the repo template shape.
The result must include a compact `Process feedback` section focused on the automation/process itself, not the domain task itself.
Capture only things like:
- unnecessary context the worker had to read or reason through
- confusing or conflicting instructions
- avoidable retries or bookkeeping
- tooling or workflow changes that would make the next run cleaner
If there is nothing useful to report, say `NONE` explicitly instead of inventing feedback.
