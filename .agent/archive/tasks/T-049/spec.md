# Task Spec: T-049

## Title
Canonical-root queue launcher hardening for disposable Codex automation clones

## Objective
Make the repo-local queue launcher robust enough that newly created Codex desktop automation clones can safely use the shared queue prompt file without depending on the automation entry's cwd, stale alias-path setup, or automation-local memory.

The real problem to solve is this:
- user-created automation clones such as `task-queue-10-3` may point at `E:\AI\Viet-Travel-Phrases`
- user wants to be able to create new automation entries freely and simply paste a shared prompt file
- queue execution should still normalize to `E:\AI\SpeakLocal-App-Family` and stop relying on automation-wrapper cwd

Fix this correctly and leanly. Prefer the smallest durable fix that makes the shared prompt file the true startup authority for queue runs.

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
- `.agent\tasks\T-048\result.md`
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-3\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-3\memory.md`
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md`

## Scope
### Allowed write scopes
- `.agent\tasks\T-049\**`
- `.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent\QUEUE_START.md`
- `.agent\AUTOMATION.md`
- `C:\Users\Administrator\.codex\automations\task-queue-10-3\automation.toml` only if needed for bounded verification or retirement guidance
- `C:\Users\Administrator\.codex\automations\task-queue-10-3\memory.md` only for bounded verification notes
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md` only if a lean queue-run exception fix is required to stop stale broad-family load behavior

### Allowed read scopes
- queue coordination surfaces under `.agent\**`
- active/retired automation entries under `C:\Users\Administrator\.codex\automations\**`
- bounded task artifacts needed for evidence

### Must not touch
- product/runtime app files outside `.agent\**`
- meaningful queue task folders `T-026` through `T-037` except read-only inspection
- unrelated workspace trackers except the normal result artifact for this task
- queue lifecycle files by hand when helper-driven inspection is enough

## Source-of-truth notes
- Current shared queue prompt file: `.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- Current canonical repo root: `E:\AI\SpeakLocal-App-Family`
- Compatibility alias only: `E:\AI\Viet-Travel-Phrases`
- The user wants new Codex automations to be disposable wrappers that can all safely point at the shared prompt file without special per-automation maintenance.
- T-048 proved the queue helper is materially repaired, but the newest clone `task-queue-10-3` still used alias-path cwd and produced alias-path warnings / stale-lock behavior.
- The fix should make the prompt file and queue surfaces authoritative enough that cloned automations stop being operational snowflakes.

## Required checks
Record exact commands and outcomes.

### Root-cause proof
- prove whether the bad behavior came from automation cwd, prompt-relative helper invocation, skill startup drift, automation memory, or a combination

### Canonical-root hardening proof
- demonstrate one queue-helper invocation from a non-canonical cwd that still resolves through the canonical repo root after the fix
- demonstrate the prompt no longer depends on `py .agent\queue_tool.py ...` style relative helper calls if that is still a risk

### Unsupported-runtime behavior
- run a bounded unsupported-runtime claim check in the hardened shape and confirm it still returns structured `no_task` or structured skip evidence instead of claiming meaningful work

### Meaningful-capable behavior
- run a bounded meaningful-capable dry run in the hardened shape and confirm a real meaningful task still surfaces when eligible

### Alias-path safety
- prove the hardened flow no longer writes or locks through the compatibility alias just because an automation wrapper was born with alias cwd

## Review gate
This is meaningful queue-launch repair work.

Gate 1, root-cause audit:
- exactly 4 Codex subagents
- challenge whether the actual failure source is correctly identified and whether the smallest durable fix is being chosen

Gate 2, patch review:
- exactly 4 Codex subagents
- challenge whether the prompt/docs/skill changes truly remove cwd dependence and stale queue-start drift without weakening queue safety

Gate 3, verification review:
- exactly 4 Codex subagents
- challenge whether the recorded checks are enough to say new automation clones can safely call the shared prompt file

Each gate must loop until all 4 Codex subagents explicitly approve advancement.
Store artifacts under `.agent\tasks\T-049\reviews\gate-01-pass-01\`, etc.

## Automation state contract
- This is meaningful repair work, not a proof-only task.
- Keep the full `3`-gate / `4`-reviewer / unanimous approval contract in `state.json`.
- Do not convert this into a queue-run task.

## Definition of done
This task is only done when all of the following are true:
- the exact cause of the bad `task-queue-10-3` behavior is stated clearly
- `.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt` is hardened so new automation clones can safely call it without depending on alias cwd
- any required supporting changes in `.agent\QUEUE_START.md`, `.agent\AUTOMATION.md`, or the skill are aligned with that truth
- the hardened launch path uses canonical-root behavior in a way that is robust even when the wrapper cwd is wrong
- unsupported-runtime behavior still fails closed
- meaningful-capable dry-run behavior still surfaces meaningful work when appropriate
- verification evidence shows the flow no longer routes queue writes/locks through the alias path just because the automation clone started there
- all 3 review gates passed with unanimous approval
- `result.md` states the exact operator guidance for future disposable automation clones

## Blocker rule
- Prefer the smallest durable fix.
- Do not sprawl into a broad queue redesign if bounded startup hardening is enough.
- Only stop blocked if a real platform limitation prevents canonical-root enforcement from the shared prompt path.

## Token discipline
- Keep the task focused on startup hardening and proof.
- Put longer traces under `.agent\tasks\T-049\logs\`.
- In `result.md`, summarize and point at evidence paths instead of pasting long logs.

## Required result contract
Before stopping, write `.agent\tasks\T-049\result.md` using `.agent\tasks\TEMPLATE\result.md` as the default shape.
- Include exact files changed.
- Include exact verification commands and whether they passed.
- Include a compact `Process feedback` section with bullets starting with `BUG`, `SUGGESTION`, or `NONE`.
- End with a short operator note explaining how the user should create future automation clones safely.