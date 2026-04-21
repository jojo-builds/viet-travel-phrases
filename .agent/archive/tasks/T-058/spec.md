# Task Spec: T-058

## Title
Desktop queue production proof run 09

## Objective
Complete one real helper-driven proof-task run for T-048 production-readiness burn-in, using the live claim, heartbeat, and finish flow without touching shared queue surfaces.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/queue_tool.py`
- `.agent/coordination/queue-index.json`

## Scope
### Allowed write scopes
- `.agent/tasks/T-058/**`

### Allowed read scopes
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/queue_tool.py`
- `.agent/coordination/queue-index.json`
- `.agent/coordination/queue-events.jsonl`

### Must not touch
- shared queue helper code
- shared automation prompts or docs
- task folders other than `T-058`
- app, content, or ops files outside this task folder

## Source-of-truth notes
- This is a proof-only task created by T-048 to verify desktop queue production readiness with live helper pickups.
- Task-local artifacts under `.agent/tasks/T-058/**` are the required output truth for this run.

## Required checks
- Capture concise evidence that the task was claimed through the helper path, heartbeated at least once, and finished honestly.
- Record any helper `warnings` if they appear; otherwise say none were observed.
- Do not hand-edit queue state to force completion.

## Review gate
- This is an explicitly flagged proof task for queue burn-in.
- Nested meaningful review gates are not required for this task.

## Automation state contract
- `state.json` declares `automation.taskClass: "proof"` and `automation.proofTask: true`.
- This task proves helper-lane behavior only; it does not authorize meaningful task execution.

## Definition of done
- Write `.agent/tasks/T-058/logs/proof-run.md` with compact claim/heartbeat/finish evidence.
- Write `.agent/tasks/T-058/result.md` using the repo template.
- Finish honestly with the helper.

## Blocker rule
- If a shared-surface defect prevents honest completion, capture exact evidence in task-local artifacts and finish `blocked`.
- Do not mutate shared repo files just to force the proof task through.

## Token discipline
- Keep the log concise and evidence-based.
- Prefer exact paths, command summaries, and observed helper results over long narrative.

## Required result contract
Before stopping, write `result.md` using the repo template shape.
Include compact `Process feedback` focused on the queue helper or proof-task execution path.
