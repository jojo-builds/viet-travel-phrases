# Task Spec: T-048

## Title
Desktop queue runner parity, lock recovery, and live no-review-subagents verification

## Objective
Fix the current desktop queue runner break so Codex Desktop queue runs can start and stop cleanly again in both supported modes:
1. unsupported runtime mode using `--review-runtime no-review-subagents`, which must return clean `no_task` / skipped-ineligible evidence instead of crashing
2. meaningful-capable mode, which must still surface real meaningful tasks as claimable when appropriate

This task must repair stale automation-entry drift, stale-lock / write-path failure cases, stale secondary automation surfaces, and any remaining helper or prompt mismatches needed to make the live queue path honestly runnable.

Codex is explicitly authorized to reason, debug, create bounded verification tasks, seed queue tasks, let Codex subagents pick them up through the live helper path, run repeated live tests, and iterate until the queue is genuinely production-ready or a real external blocker remains.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent/queue_tool.py`
- `.agent/coordination/runtime-review-path.json`
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-2\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-2\memory.md`
- `.agent/tasks/T-040/result.md`
- `.agent/tasks/T-042/result.md`
- `.agent/tasks/T-044/result.md`
- `.agent/tasks/T-046/result.md`
- `.agent/tasks/T-047/result.md`

## Scope
### Allowed write scopes
- `.agent/tasks/T-048/**`
- `.agent/queue_tool.py`
- `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10-2\automation.toml`
- `C:\Users\Administrator\.codex\automations\task-queue-10\memory.md` only if needed for a bounded verification note
- `C:\Users\Administrator\.codex\automations\task-queue-10-2\memory.md` only if needed for a bounded verification note
- additional proof-only verification tasks under `.agent/tasks/T-050/**` through `.agent/tasks/T-099/**` if and only if you need fresh live queue canaries to prove the fix

### Allowed read scopes
- queue helper and queue coordination surfaces under `.agent/**`
- task-local artifacts under `.agent/tasks/**` when needed for evidence
- desktop automation entries under `C:\Users\Administrator\.codex\automations\task-queue-10*\**`
- repo-local validation scripts that are directly needed for bounded queue verification

### Must not touch
- application/product/runtime files outside `.agent/**`
- language content files outside proof-task canaries created by this task
- unrelated user workspace trackers or lane boards
- meaningful task folders `T-026` through `T-037` except read-only inspection
- shared queue state by hand when the helper can mutate it deterministically

## Source-of-truth notes
- The current live failure from the user is not hypothetical. In `task-queue-10-2`, a real run using `--review-runtime no-review-subagents` hit helper write failures while rewriting `.agent/coordination/queue-index.json` and appending `.agent/coordination/queue-events.jsonl`, and a stale `queue-mutation.lock` with dead PID `8084` was observed.
- The current burn-in already proved one core fix: unsupported runtimes must skip meaningful tasks instead of claiming them. That behavior now exists in `queue_tool.py`, but the launch surfaces and stale second automation entry drifted.
- `task-queue-10-2` is currently a known stale surface: old prompt body, old assumptions, and `cwds = ["E:\AI\Viet-Travel-Phrases"]`.
- Treat `.agent/queue_tool.py`, `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt`, `.agent/QUEUE_START.md`, `.agent/AUTOMATION.md`, and both automation TOMLs as the repair surface.

## Required checks
You must run and record exact results for all of these unless a bounded fix changes the command shape, in which case record the replacement command and why.

### Baseline parity and syntax
- `py -m py_compile .agent\queue_tool.py`
- verify `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt` and both automation TOMLs are aligned on the live claim command and blocked-run behavior

### Unsupported-runtime live behavior
- run one real unsupported-runtime claim using:
  - `py .agent\queue_tool.py claim-next --session-id "<sid>" --label "<label>" --review-runtime no-review-subagents`
- expected good outcome:
  - structured JSON response
  - no crash
  - `result: "no_task"` when only meaningful tasks remain
  - `skippedIneligible` evidence for meaningful tasks

### Unsupported-runtime dry-run behavior
- run one dry-run unsupported-runtime claim using:
  - `py .agent\queue_tool.py claim-next --session-id "<sid>" --label "<label>" --review-runtime no-review-subagents --dry-run`
- expected good outcome:
  - structured JSON response
  - no crash
  - no write/append permission failure on queue surfaces

### Meaningful-capable behavior
- run one meaningful-capable dry run using:
  - `py .agent\queue_tool.py claim-next --session-id "<sid>" --label "<label>" --dry-run`
- expected good outcome:
  - structured JSON response
  - no crash
  - a real meaningful task should still surface as claimable if the queue actually has one

### Stale lock recovery
- simulate or reproduce a stale queue mutation lock with a dead PID in a bounded way
- prove the helper can recover cleanly and continue
- record the exact before/after evidence

### Required fresh proof canaries and subagent queue pickup
- Create enough bounded proof-only verification tasks under `T-050` to `T-099` to prove the queue works end to end under repeated real claims.
- At least `10` of these proof tasks must pass fully end to end after the repair.
- These are not fake paper tests. Seed them into the live queue, then let Codex subagents pick them up through the real `claim-next` helper path and finish them honestly.
- Use more than `10` if some fail during debugging. The success bar is `10` passing end-to-end runs, not merely `10` attempts.
- You may run these in bounded parallel batches when that helps prove queue concurrency safely.
- Each proof task must be intentionally scoped so it can complete honestly in a Codex-subagent test runtime without relying on unsupported review behavior.
- Each such task must use:
  - `automation.taskClass: "proof"`
  - `automation.proofTask: true`
  - `reviewersRequired: 0`
  - `reviewGatesRequired: 0`
  - task-local write scope only
- if you create any of these, claim/execute/finish them honestly and record why each was needed

## Review gate
This is a meaningful Codex repair task.

Gate 1, repair plan and source-of-truth audit:
- exactly 4 Codex subagents
- challenge whether the actual root cause is fully identified
- challenge whether the write failure is helper logic, automation drift, path aliasing, stale lock handling, stale second automation surfaces, or some combination

Gate 2, patch review:
- exactly 4 Codex subagents
- challenge whether the code/docs/prompt changes really close the observed failure cases
- challenge whether the fix accidentally weakens meaningful-task gating, stale-lock safety, or introduces unsafe claim behavior

Gate 3, live verification review:
- exactly 4 Codex subagents
- challenge whether the recorded live tests are sufficient to call the lane fixed and production-ready
- challenge whether any stale automation entry, stale lock, queue write, throughput, or parallelism edge case still remains

Each gate must loop until all 4 Codex subagents explicitly approve advancement.
If any gate fails, Codex must fix what was found and rerun that gate until unanimous approval or a real external blocker remains.
Store artifacts under `.agent/tasks/T-048/reviews/gate-01-pass-01/`, etc.

## Automation state contract
- This task is meaningful repair work, not a proof-only canary.
- Keep `automation.taskClass: "meaningful"`, `automation.proofTask: false`, and the full 3-gate / 4-reviewer / unanimous contract in `state.json`.
- If you create fresh bounded proof tasks for verification, those proof tasks must be explicitly flagged proof-only and must not be used as a loophole to skip this task's own review gates.
- The proof tasks should be designed so Codex subagents can truly claim them from the queue and finish them through the normal helper flow, not by hand-editing lifecycle state.

## Definition of done
This task is only done when all of the following are true:
- the observed user-facing failure mode is actually repaired, not just explained
- both `task-queue-10` and `task-queue-10-2` are either:
  - aligned to the live safe prompt/cwd behavior, or
  - one is explicitly retired/disabled with a clear rationale and no ambiguity about which automation entry is authoritative
- `queue_tool.py` no longer crashes on the unsupported-runtime claim path because of stale lock, stale second automation state, or coordination write failures
- structured live test evidence exists for:
  - unsupported-runtime real claim
  - unsupported-runtime dry run
  - meaningful-capable dry run
  - stale lock recovery
  - multi-run repeated queue execution after repair
  - bounded parallel queue execution after repair
- at least `10` proof-task queue runs have passed fully end to end after repair, where Codex subagents really claimed tasks from the live queue and finished them honestly through the helper path
- Codex has run enough real post-fix live tests to honestly support the claim that the lane is production-ready, and should exceed the minimum if failures during debugging mean the evidence is still weak
- throughput evidence exists that the queue path can sustain roughly 5 to 8 automation runs per hour, including parallel activity when tasks are available in the queue, without regressing into stale-lock or coordination-write failures
- if extra proof tasks were created, they completed honestly and their purpose is documented
- all 3 review gates passed with unanimous approval
- `result.md` clearly states what changed, what passed live, what throughput/parallel evidence exists, any residual non-blocking quirks, and the exact next operator action

## Blocker rule
- Do not stop at the first failing live test if a bounded repair pass could still fix it.
- Narrow the issue, patch it, and rerun the live check before surfacing a blocker.
- Only stop blocked if a real external platform limit remains after bounded repair attempts.

## Token discipline
- Keep the task contract authoritative.
- Put long command outputs and traces under `.agent/tasks/T-048/logs/`.
- In `result.md`, summarize decisions and point at evidence paths instead of pasting long logs.

## Required result contract
Before stopping, write `.agent/tasks/T-048/result.md` using `.agent/tasks/TEMPLATE/result.md` as the default shape.
- Include exact files changed.
- Include exact validation commands and whether they passed.
- Include a compact `Process feedback` section with bullets starting with `BUG`, `SUGGESTION`, or `NONE`.
- If any blocked/helper failure happens during verification, copy the exact failing command, traceback/error, and relevant `.agent/coordination/queue-events.jsonl` evidence into the task-local log/result.
