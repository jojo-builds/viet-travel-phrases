# Task Spec: T-061

## Title
Strict subagent-only queue runner hardening and four-worker live production proof

## Objective
Bring the SpeakLocal desktop queue fully back into line with the standing operator rule:
- meaningful queue work always uses the required Codex subagent review workflow
- there is no downgrade path
- `--review-runtime no-review-subagents` is not an allowed operating mode for this queue lane
- if a runtime cannot perform the required subagent-backed review contract, it is not a valid runtime for this lane

Then prove the fix live by having exactly 4 Codex subagents each run the shared launcher prompt:
`Read and execute:
E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
and successfully claim and complete real meaningful queue tasks as if they were normal automation workers.

This task is not done until the queue no longer contains the old no-review fallback logic, the startup surfaces clearly enforce the standing rule, and 4 real subagent-driven queue runs complete meaningful tasks through the normal helper path.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent\README.md`
- `.agent\QUEUE_START.md`
- `.agent\AUTOMATION.md`
- `.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent\queue_tool.py`
- `.agent\coordination\queue-index.json`
- `.agent\coordination\runtime-review-path.json`
- `.agent\tasks\T-048\result.md`
- `.agent\tasks\T-049\result.md`
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md`
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\agents\openai.yaml`
- active automation entries under `C:\Users\Administrator\.codex\automations\task-queue-*\automation.toml`

## Scope
### Allowed write scopes
- `.agent\tasks\T-061\**`
- `.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent\QUEUE_START.md`
- `.agent\AUTOMATION.md`
- `.agent\queue_tool.py`
- `.agent\coordination\queue-index.json`
- `.agent\coordination\runtime-review-path.json` only if truth-alignment requires it
- meaningful queue task folders that are actually claimed and executed during this task's required four-worker live proof
- new meaningful queue task contracts under `.agent\tasks\T-062\**` through `.agent\tasks\T-079\**` only if needed to keep at least 6 meaningful non-overlapping queue tasks available before/after the live proof
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md`
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\agents\openai.yaml`
- active automation entries under `C:\Users\Administrator\.codex\automations\task-queue-*\automation.toml` only if queue-launch truth needs to be aligned there

### Allowed read scopes
- queue coordination and task surfaces under `.agent\**`
- active automation memory files under `C:\Users\Administrator\.codex\automations\task-queue-*\memory.md` only for bounded debugging evidence
- repo-local files directly needed by whichever meaningful queue tasks are claimed during the four-worker proof

### Must not touch
- proof/synthetic queue tasks as a substitute for meaningful production proof
- non-queue app/runtime surfaces unrelated to claimed meaningful tasks
- unrelated workspace lane boards except the normal orchestration update for this launch
- any fallback design that still lets a queue worker choose `no-review-subagents` for meaningful work

## Source-of-truth notes
- User's standing rule is non-negotiable: meaningful Codex queue tasks always require the full review contract with exactly 4 Codex subagents per gate.
- There should never be an operational path where queue workers downgrade themselves into a no-subagent mode for meaningful tasks.
- The current queue startup surfaces still mention `--review-runtime no-review-subagents`, and live disposable-clone runs have been using that fallback instead of actually doing the work.
- The active meaningful backlog was intentionally reset to six non-test tasks: `T-030` through `T-035`.
- The live proof for this task must use meaningful queue work, not proof/synthetic tasks.

## Required checks
Record exact commands, outputs, and artifact paths.

### Rule-stripping audit
- prove every remaining place where queue startup or helper flow still mentions, implies, or enables `no-review-subagents`
- remove or rewrite those paths so the lane follows the standing operator rule literally
- prove broad-family startup drift or automation-memory startup drift no longer overrides the queue rule

### Queue-runtime contract audit
- prove the startup surfaces now say, in effect:
  - meaningful queue runs require the real subagent-backed review contract
  - there is no downgrade path
  - runtimes that cannot satisfy that contract must not run this lane
- if helper logic still contains stale no-review runtime branching that affects meaningful claim behavior, fix it

### Live four-worker production proof
- spawn or use exactly 4 Codex subagents as the production workers for this proof
- each worker must start from the shared launcher prompt text:
  - `Read and execute:`
  - `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- each worker must claim and complete a real meaningful queue task through the normal queue-helper path
- do not hand-edit lifecycle state to fake claims or completions
- preserve task-local results and review artifacts for the meaningful tasks they complete
- if a worker fails, repair the root cause and rerun until 4 workers successfully complete meaningful queue tasks

### Queue backlog floor after proof
- before the four-worker proof begins, ensure at least 6 meaningful non-overlapping queue tasks are available
- after the four-worker proof completes, restore the active backlog back to at least 6 meaningful non-overlapping queue tasks if the live proof consumed too much of it
- do not seed proof/synthetic tasks to satisfy this floor

### Final verification
- prove the shared launcher prompt no longer instructs or permits `--review-runtime no-review-subagents`
- prove a fresh worker following the shared launcher no longer safe-stops because it chose the wrong no-review mode
- prove the queue's active claim path contains meaningful non-test work only

## Review gate
This is meaningful repair and production-proof work.

Gate 1, rule and root-cause audit:
- exactly 4 Codex subagents
- challenge whether every stale no-review path was truly found
- challenge whether the task is fully aligned with the operator's standing rule

Gate 2, patch review:
- exactly 4 Codex subagents
- challenge whether the code/docs/launch surfaces really removed the downgrade path without weakening queue safety or lifecycle truth

Gate 3, live production proof review:
- exactly 4 Codex subagents
- challenge whether 4 real worker runs actually started from the shared launcher and completed meaningful queue tasks honestly
- challenge whether the queue backlog was left in a healthy non-test state

Each gate must loop until all 4 Codex subagents explicitly approve advancement.
Store artifacts under `.agent\tasks\T-061\reviews\gate-01-pass-01\`, etc.

## Automation state contract
- This task is meaningful repair work.
- Keep the full `3`-gate / `4`-reviewer / unanimous approval contract in `state.json`.
- Do not redefine this as proof-only work.
- Do not use proof/synthetic tasks as the main live validation for this task.

## Definition of done
This task is only done when all of the following are true:
- queue startup surfaces and helper behavior no longer include an operational `no-review-subagents` path for meaningful queue work
- the lane clearly enforces the standing rule that meaningful queue work always uses the required subagent-backed review contract
- exactly 4 Codex subagents have each run from the shared launcher prompt and completed real meaningful queue tasks through the normal helper flow
- the completed meaningful tasks have honest result artifacts and required review artifacts
- the queue is left with at least 6 meaningful non-overlapping active tasks after the production proof, counting queued plus reclaimable tasks
- the active claim path contains no proof/synthetic tasks
- all 3 review gates passed with unanimous approval
- `result.md` clearly states what was stripped, what was fixed, which 4 meaningful tasks were completed by the four workers, what backlog remains, and what operator guidance now applies

## Blocker rule
- Do not stop at the first failure.
- If a worker cannot complete the task as expected, repair the root cause and rerun.
- Only stop blocked if a real platform limitation remains after bounded repair attempts.

## Token discipline
- Keep this task tightly focused on strict rule enforcement and live production proof.
- Put longer traces under `.agent\tasks\T-061\logs\`.
- Use concise result summaries that point to evidence paths.

## Required result contract
Before stopping, write `.agent\tasks\T-061\result.md` using `.agent\tasks\TEMPLATE\result.md` as the default shape.
- Include exact files changed.
- Include exact meaningful tasks completed by the 4 workers.
- Include exact verification commands and whether they passed.
- Include a compact `Process feedback` section with bullets starting with `BUG`, `SUGGESTION`, or `NONE`.
- End with a short operator note explaining the final expected launcher behavior for normal disposable automation clones.