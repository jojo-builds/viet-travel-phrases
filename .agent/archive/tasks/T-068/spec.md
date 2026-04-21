# Task Spec: T-068

## Title
Desktop Codex automation pilot, Viet TestFlight execution packet selected-build branch fix and final gate rerun

## Objective
Finish the narrow follow-up left by T-034 by removing stale hard-coded build identity from the Viet TestFlight execution packet so every retry or resubmit branch points to the build selected in Step 2, then rerun the required review gates honestly.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-034/result.md`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`

## Task type
- operator packet repair
- TestFlight truth hardening
- bounded review rerun

## Scope
### Allowed write scopes
- `.agent/tasks/T-068/**`
- `docs/operations/**`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `.agent/tasks/T-034/**`

### Must not touch
- `app/**`
- `site/**`
- `content-draft/**`
- release/build/TestFlight artifacts themselves
- unrelated task folders outside `.agent/tasks/T-068/**`

## Source-of-truth notes
- Preserve the current honest posture that build `1.0.0 (3)` is the latest installable artifact unless the docs already prove otherwise.
- Treat `1.0.0 (4)` and `1.0.0 (5)` as in-flight references only unless durable ops truth says otherwise.
- The point of this task is not broad release-strategy rewriting. It is to make the packet's selected-build branch internally consistent and then clear the strict review contract if the bounded fix is sound.

## Required outputs
Create or update these files:
- `.agent/tasks/T-068/logs/packet-branch-audit.md`
- `.agent/tasks/T-068/result.md`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- any other `docs/operations/**` or `ops/apps/viet.json` surface only if needed to keep the same TestFlight truth aligned
- exactly 4 review artifacts for each required review gate under `.agent/tasks/T-068/reviews/`

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-release-truth-review.md`
2. `02-apple-lane-review.md`
3. `03-operator-sequence-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the packet fix, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are read-only except for their assigned review file.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target packet/truth artifacts, and only the latest relevant prior review artifacts for that role.
- Create the current gate/pass folder on demand.

## Required checks
- verify `.agent/tasks/T-068/logs/packet-branch-audit.md` exists
- verify the packet no longer hard-codes a stale Step 5 build identity when Step 2 can select a different retry/resubmit build
- verify touched docs and `ops/apps/viet.json` still agree on current Viet readiness truth
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Viet execution packet is internally consistent across the selected-build branch
- required outputs exist
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before Gate 3, write `.agent/tasks/T-068/result.md` with the standard task result shape and keep it at `in_review` until the latest Gate 3 pass is unanimously approved.
