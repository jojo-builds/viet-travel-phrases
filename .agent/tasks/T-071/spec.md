# Task Spec: T-071

## Title
Desktop Codex automation pilot, Viet device-proof ops truth sync and evidence pack refresh

## Objective
Refresh the Viet device-proof operating surfaces so `docs/operations/**` and `ops/apps/viet.json` honestly reflect the current build IDs, prerequisite gates, evidence checklist, and open blockers without overstating completion.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-022/spec.md`
- `.agent/tasks/T-022/result.md`
- `.agent/tasks/T-068/spec.md`
- if present, `.agent/tasks/T-068/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`

## Task type
- ops-truth sync
- evidence-pack refresh
- readiness documentation hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-071/**`
- `docs/operations/**`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `.agent/tasks/T-022/**`
- `.agent/tasks/T-068/**`
- `app/family/**`
- `content-draft/viet/**`

### Must not touch
- `app/**` as a write surface
- `site/**`
- `content-draft/**` as a write surface
- release/build/TestFlight files
- unrelated task folders outside `.agent/tasks/T-071/**`

## Source-of-truth notes
- Stay honest about pending device proof, pending preview install, pending TestFlight readiness, and pending purchase/restore proof.
- Do not claim physical device results that do not exist.
- Treat this as the clean rerun successor to blocked `T-022`, not a continuation of the old non-proven runtime attempt.
- This task may strengthen durable ops truth even if product state itself does not change.

## Required outputs
Create or update these files:
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`
- `.agent/tasks/T-071/logs/evidence-pack-audit.md`
- `.agent/tasks/T-071/result.md`
- exactly 4 review artifacts for each required review gate under `.agent/tasks/T-071/reviews/`

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ops-truth-review.md`
2. `02-device-proof-honesty-review.md`
3. `03-evidence-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main sync pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are read-only except for their assigned review file.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifacts, and only the latest relevant prior review artifacts for that role.
- Create the current gate/pass folder on demand.

## Required checks
- verify all required output files exist
- verify docs and `ops/apps/viet.json` agree on current blocker posture
- verify no app/site/content-draft files were changed
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet device-proof operating docs are clearer, tighter, and still honest about pending human/device dependencies
- required files exist and agree on core blocker truth
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write `.agent/tasks/T-071/result.md` with the standard task result shape.
