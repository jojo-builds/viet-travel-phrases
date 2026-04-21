# Task Spec: T-132

## Title
Desktop Codex automation pilot, Viet device-proof blocker ledger and return-readiness packet hardening

## Objective
Turn the current Viet return path into one sharper live-ops packet before the next human device pass. Reconcile the blocker ledger, latest validation surface, app status posture, and app record so they all tell the same honest story about what is ready, what is still blocked, and what exact evidence the next return pass must capture.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-100/result.md`
- `.agent/tasks/T-112/result.md`
- `.agent/tasks/T-126/result.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `ops/apps/viet.json`

## Task type
- ops truth hardening
- blocker-ledger reconciliation
- Viet return-readiness packet

## Scope
### Allowed write scopes
- `.agent/tasks/T-132/**`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `app/family/**` as read-only context only
- `content-draft/viet/**` as read-only context only

### Must not touch
- `site/**`
- `content-draft/**` as a write surface
- release/build/TestFlight generated artifacts
- unrelated task folders outside `.agent/tasks/T-132/**`
- app code as a write surface

## Source-of-truth notes
- Keep this packet honest about the difference between repo readiness, App Store Connect prerequisites, and unperformed human device proof.
- Do not invent successful purchase, restore, restart, or locked-state evidence that has not happened.
- Prefer one exact blocker ledger and next-pass evidence checklist over broad status prose.
- Treat `T-126` as the latest bounded handoff, then tighten contradictions or stale phrasing it left behind.

## Required outputs
Create or update these files:
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`
- `.agent/tasks/T-132/logs/viet-return-readiness-ledger.md`
- `.agent/tasks/T-132/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-132/reviews/` for each required gate

## Concrete requirement
- leave one explicit Viet return-readiness ledger that names the current blocking prerequisites, the exact next human actions, and the exact evidence required to clear each blocker
- make `CURRENT_BLOCKERS.md`, `LATEST_VALIDATION.md`, `APP_STATUS.md`, and `ops/apps/viet.json` agree on the same blocked-versus-ready posture
- keep the packet focused on device-proof and readiness truth, not another broad product summary
- if repo truth shows a blocker is already cleared or overstated, fix that truth narrowly and explain why

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ops-truth-review.md`
2. `02-device-proof-readiness-review.md`
3. `03-blocker-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `ops/apps/viet.json` still parses as JSON
- verify the touched docs all agree on the same current blocker posture
- verify the result does not claim device, purchase, restore, or restart success without cited evidence
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `site/**`, `content-draft/**`, or app-code files changed

## Definition of done
- the Viet return path is easier to execute because the blocker story and next-evidence contract are unambiguous
- operator-facing truth no longer drifts across the main readiness surfaces
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no fake completion or overclaim was introduced
