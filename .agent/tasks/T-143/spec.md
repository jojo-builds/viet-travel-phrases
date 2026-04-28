# Task Spec: T-143

## Title
Desktop Codex automation self-recovery handoff generator for interrupted meaningful tasks

## Objective
Extend the repo-local queue tooling so interrupted meaningful tasks can automatically produce a recovery handoff packet instead of requiring manual orchestrator shaping every time a worker thread dies after substantial progress.

## Repo / Working Surface
- canonical repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd for implementation: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/QUEUE_REPAIR.md`
- `.agent/QUEUE_MAINTENANCE.md`
- `.agent/tasks/T-143/brief.md`
- `.agent/queue_tool.py`
- `.agent/Invoke-SpeakLocalQueueTool.ps1`
- `.agent/tasks/T-139/state.json`
- `.agent/tasks/T-139/recovery-notes.md`
- `.agent/tasks/T-140/state.json`
- `.agent/tasks/T-140/recovery-notes.md`
- `.agent/tasks/TEMPLATE/spec.md`
- `.agent/tasks/TEMPLATE/state.json`
- `.agent/tasks/TEMPLATE/result.md`

## Task type
- queue tooling
- interruption recovery automation
- desktop codex maintenance hardening

## Scope
### Allowed write scopes
- `.agent/queue_tool.py`
- `.agent/Invoke-SpeakLocalQueueTool.ps1`
- `.agent/QUEUE_REPAIR.md`
- `.agent/QUEUE_MAINTENANCE.md`
- `.agent/AUTOMATION.md`
- `.agent/README.md`
- `.agent/coordination/queue-index.json`
- `.agent/coordination/desktop-app-recovery.json`
- `.agent/tasks/T-143/**`
- queue-task metadata only when the new automation intentionally generates a recovery handoff

### Allowed read scopes
- `.agent/**`
- task folders needed as interruption examples

### Must not touch
- `app/**`
- `content-draft/**`
- `ops/**`
- `docs/operations/**`
- unrelated product/UI/content worktrees

## Source-of-truth notes
- The queue tool already supports desktop-app restart recovery, but it does not yet generate recovery task packets for interrupted meaningful tasks.
- `T-139` and `T-140` are the concrete examples of the failure mode this task should address.
- Recovery generation should preserve the original interrupted task as historical truth instead of silently mutating it into a different task.

## Required outputs
Create or update these files:
- `.agent/queue_tool.py`
- `.agent/Invoke-SpeakLocalQueueTool.ps1` only if the wrapper surface must expose a new command
- `.agent/QUEUE_REPAIR.md`
- `.agent/QUEUE_MAINTENANCE.md`
- `.agent/AUTOMATION.md` only if task-runtime expectations change
- `.agent/README.md` only if durable queue-usage truth changes
- `.agent/tasks/T-143/logs/self-recovery-handoff-notes.md`
- `.agent/tasks/T-143/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-143/reviews/` for each required gate

## Concrete requirements
- add a bounded queue-maintenance-capable path that can detect interrupted meaningful tasks and generate a recovery handoff when all of these are true:
  - the original task is meaningful
  - ownership is stale/expired
  - the task is not already terminal
  - there is evidence of landed work worth salvaging
- the generated recovery handoff should:
  - create a new task id and folder
  - link back to the interrupted original task
  - copy or synthesize the minimum required recovery context
  - avoid duplicate recovery-task generation for the same original task
- leave the original task in a clear interrupted/blocked historical state
- keep the queue index and recovery ledger consistent with the new recovery task
- support at least one safe dry-run or non-destructive inspection path so operators can see what would be generated
- use `T-139` and `T-140` as validation examples for the new tooling behavior

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-recovery-policy-review.md`
2. `02-queue-tool-safety-review.md`
3. `03-idempotence-and-duplicate-avoidance-review.md`
4. `04-operator-clarity-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
Run from `E:\AI\SpeakLocal-App-Family`:
- `powershell -NoProfile -File .agent\\Invoke-SpeakLocalQueueTool.ps1 repair`
- any new dry-run or inspection command added by this task

Also verify:
- the recovery-generation path does not duplicate an existing recovery task
- queue-index output remains valid JSON
- the task did not mutate app/product files
- the latest pass for each gate contains exactly 4 review files
- all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the queue tooling can produce a recovery handoff for interrupted meaningful tasks without manual orchestrator shaping
- the implementation is safe against duplicate recovery-task generation
- operator docs clearly explain when to use the recovery path versus the existing desktop-app restart path
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- the task leaves behind one concise notes artifact describing the chosen recovery model

## Blocker rule
- do not stop because the perfect long-term queue architecture is unsettled
- only report a blocker if the current repo-local queue surface cannot safely support recovery-task generation without a real external dependency

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For this meaningful 3-gate task, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself.
