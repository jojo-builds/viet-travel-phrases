# Task Spec: T-133

## Title
Desktop Codex automation pilot, Viet ASC non-consumable and preview-launch checklist packet

## Objective
Tighten the operator packet around the next Viet preview/TestFlight push so the lane stops carrying fuzzy App Store Connect and launch-sequence wording. The goal is one exact checklist for preview launch, ASC non-consumable verification, submit posture, and evidence capture order without claiming any of those actions already happened.

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
- `.agent/tasks/T-126/result.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`

## Task type
- TestFlight/ASC checklist hardening
- operator packet tightening
- release-lane evidence sequencing

## Scope
### Allowed write scopes
- `.agent/tasks/T-133/**`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `app/family/**` as read-only context only

### Must not touch
- `site/**`
- `content-draft/**`
- app code as a write surface
- generated build artifacts
- unrelated task folders outside `.agent/tasks/T-133/**`

## Source-of-truth notes
- The packet must stay explicit that App Store Connect state and device proof are external facts, not repo-edits.
- Prefer a crisp ordered checklist over repeated narrative reminders.
- Treat the next human run as a real execution contract: prerequisite, launch order, ASC confirmation, install path, purchase proof, restore proof, restart proof, and evidence capture.
- If current docs disagree about sequence or evidence, resolve that disagreement narrowly.

## Required outputs
Create or update these files:
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `.agent/tasks/T-133/logs/viet-asc-preview-checklist.md`
- `.agent/tasks/T-133/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-133/reviews/` for each required gate

## Concrete requirement
- leave one exact preview-launch and ASC checklist that covers build prerequisites, submission posture, non-consumable confirmation, install path, purchase/restore/restart sequence, and evidence capture order
- remove or tighten any wording that could make an operator think ASC or device proof is already complete when it is not
- keep the output bounded to execution-packet quality, not broad ops-truth rewriting outside the allowed files
- if a step is still unknowable until human action, mark it as pending evidence rather than filling the gap with assumption

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-testflight-flow-review.md`
2. `02-asc-readiness-review.md`
3. `03-evidence-sequencing-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify the touched docs still keep external actions as pending until evidence exists
- verify the launch/checklist order is internally consistent across both docs
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `site/**`, `content-draft/**`, or app-code files changed

## Definition of done
- the next Viet preview/TestFlight execution path is documented as one crisp trustworthy checklist
- ASC and device-proof uncertainty is surfaced honestly instead of blurred into status prose
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no repo-only change overclaims external completion
