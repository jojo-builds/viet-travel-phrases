# Task Spec: T-XXX

## Title
Short task title.

## Objective
Describe the concrete outcome to achieve. Write this as the desired end state, not a command-by-command recipe.

## Success Criteria
- list what must be true when the task is done
- include user-visible behavior, source-of-truth updates, artifact expectations, and validation expectations
- keep this concrete enough that another worker can judge whether the outcome was achieved

## Repo / Working Surface
- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: set per task

## Read first
- `AGENTS.md`
- `.agent/TASK_PROMPTING.md`
- list exact source-of-truth files for this task here
- do not list `.agent/coordination/queue-index.json` or `.agent/coordination/locks.yaml` here unless this task is explicitly queue maintenance/self-heal

## Worker Judgment
- use GPT-5.5 reasoning to choose the safest implementation path within the constraints
- do not follow a brittle step sequence unless this spec marks a step as a safety requirement
- record concise decisions, evidence, and tradeoffs in `result.md`; do not dump hidden chain-of-thought

## Scope
- expected worker size: normally `30` minutes to several hours when the task has a clear write boundary and recoverable checkpoints
- do not shrink this task just to make it tiny; shrink only if write scopes conflict, validation would be unmanageable, or recovery would be unclear

### Allowed write scopes
- list writable paths or lock classes

### Allowed read scopes
- list read-only reference paths if needed

### Must not touch
- list forbidden paths, unrelated app areas, or conflicting lock classes

## Source-of-truth notes
- state what counts as live truth
- state what counts as planning truth if relevant
- note any intentional pivots already approved

## Required checks
- list the exact validation/build/test commands to run when relevant
- if a check is required, do not weaken it with "if possible"; if it cannot run, document the blocker and bounded investigation

## Relevant skills
- list the minimum task-relevant skills, for example:
  - `speaklocal-listing-pages` for Vietnam phrase listing/detail content
  - `build-ios-apps:ios-debugger-agent` for native build/simulator checks
  - `build-ios-apps:swiftui-liquid-glass` for Liquid Glass SwiftUI work
  - `openai-docs` for OpenAI model/API/prompt guidance
- do not load broad skills just in case

## Heartbeat and recovery contract
- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after long builds or simulator checks, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-XXX --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 120
```

- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`
- for long tasks, keep compact task-local breadcrumbs under `.agent/tasks/T-XXX/logs/` when useful

## Review gate
- state whether review is mandatory
- if mandatory, specify what the reviewer must challenge
- define reviewer lanes by actual outcome risk, not generic titles
- for meaningful Codex tasks, require at least 3 review gates
- each review gate must use exactly 4 Codex subagents
- each gate must loop until all 4 subagents explicitly agree the task can advance
- specify how review artifacts are stored, for example under .agent/tasks/T-xxx/reviews/gate-01-pass-01/
- the current gate/pass folder may be created on demand
- reviewers are fully read-only; they must not edit repo files or write review artifacts themselves
- each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`
- the parent worker must write all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses
- the parent worker should `close_agent` each harvested reviewer promptly after its result is recorded
- if a review gate aborts early or ownership is lost, the parent worker should close any already-started reviewers before stopping
- review-only passes should read only `spec.md`, the claimed `state.json`, the target artifact(s), and the latest relevant prior review artifacts for that role
- if a runtime fact is already known, say it explicitly in reviewer prompts instead of making reviewers infer it
- if the 3-gate 4-subagent review loop is required, the task must not be marked done unless all 3 gates pass with unanimous approval
- if the 3-gate 4-subagent review loop is required, draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too
- only explicitly flagged proof/synthetic tasks may set review gates to `0`; meaningful tasks must never do that

## Automation state contract
- meaningful tasks should declare `automation.taskClass: "meaningful"`, `automation.proofTask: false`, and the full `3`-gate / `4`-reviewer / unanimous review contract in `state.json`
- proof/synthetic tasks should declare `automation.taskClass: "proof"` or `"synthetic"`, set `automation.proofTask: true`, and explain why a reduced review path is allowed
- runtime-proof tasks may declare `automation.taskClass: "runtime-proof"` while still carrying the full meaningful review contract, when the goal is to prove that the desktop lane can execute the real 3-gate / 4-reviewer workflow before normal meaningful tasks are admitted
- passing a proof/synthetic task does not by itself authorize meaningful production-task execution

## Definition of done
- concrete completion conditions
- include artifact reality checks when files/builds/exports are claimed
- for bulk phrase authoring or translation tasks, do not use a tiny conservative batch as the completion bar; prefer clearing the full currently unresolved high-value set and usually require at least `24` row outcomes unless the bounded high-value set is genuinely smaller or unusually sensitive
- for any task using the meaningful Codex contract, the scope must be review-worthy: the work should require real synthesis or restructuring across multiple artifacts, not just a shallow next-batch cleanup
- if the task uses the meaningful Codex contract, require all 3 review gates to pass and require unanimous 4-subagent approval in the latest pass of each gate

## Meaningful-task sizing rule
If this task declares the full meaningful 3-gate / 4-reviewer contract, write the contract so the review cost is justified.

The goal is not the smallest possible batch. The goal is the largest coherent packet a single worker session can complete, validate, and leave recoverable if interrupted.

Prefer tasks that combine several of these at once:
- restructure a phrase family or unresolved cluster, not just isolated rows
- update the source CSV plus prioritization notes, README/handoff truth, and audit/result artifacts together
- improve retrieval, relatedness, or implementation-readiness, not just raw phrase count
- clarify starter vs premium boundary, phrase relation shape, or traveler-utility packaging in a reusable way

Avoid writing meaningful-task contracts that are effectively:
- "translate the next small batch"
- "do a thin second pass"
- "reduce a few unresolved rows"
without a larger structural or handoff improvement bundled into the same task.

## Blocker rule
- do not stop at the first obstacle if bounded investigation could still resolve it
- surface blockers only after reasonable unblock attempts or when a real external dependency remains

## Token discipline
- treat this file as the main task contract
- do not paste full files, full diffs, or full logs into `result.md`
- store large logs under `logs/`
- prefer paths, symbols, and concise evidence over long narrative recaps

## Required result contract
Before stopping, write `result.md` using the repo template shape.
For meaningful 3-gate tasks, `result.md` should exist before the final gate and remain `in_review` until final consensus is complete.
The result must include a compact `Process feedback` section focused on the automation/process itself, not the domain task itself.
Capture only things like:
- unnecessary context the worker had to read or reason through
- confusing or conflicting instructions
- avoidable retries or bookkeeping
- tooling or workflow changes that would make the next run cleaner
If there is nothing useful to report, say `NONE` explicitly instead of inventing feedback.
