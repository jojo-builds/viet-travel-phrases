# Task Spec: T-131

## Title
Desktop Codex automation pilot, Viet restore-path walkthrough and locked-state shell packet

## Objective
Tighten the repo-side Viet purchase, restore, and locked-state walkthrough so the next real device-proof run hits honest small-screen copy and clear recovery guidance instead of rediscovering repo-side ambiguity. Apply only bounded Viet-shell fixes if current repo truth shows a real mismatch. Otherwise leave a stronger walkthrough packet that makes the remaining device-only unknowns explicit without pretending physical proof already exists.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-072/result.md`
- `.agent/tasks/T-126/spec.md`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- bounded `app/family/**` Viet-specific premium, locked-state, restore, and restart-related shell surfaces
- `content-draft/viet/**` only where needed for count or truth references

## Task type
- bounded app-shell walkthrough audit
- Viet-specific restore-path honesty hardening
- small-screen locked-state packet

## Scope
### Allowed write scopes
- `.agent/tasks/T-131/**`
- `app/family/**` within the bounded Viet purchase, restore, restart-persistence, and locked-state walkthrough scope only

### Allowed read scopes
- `docs/**`
- `ops/**` as read-only context only
- `.agent/tasks/T-072/**`
- `.agent/tasks/T-126/**` as read-only context only
- `content-draft/viet/**`

### Must not touch
- `site/**`
- `docs/operations/**` as a write surface
- release/build/TestFlight files as generated artifacts
- unrelated shared-search or family-shell work outside the bounded Viet purchase / restore walkthrough scope
- unrelated task folders outside `.agent/tasks/T-131/**`

## Source-of-truth notes
- `T-072` already closed the current repo-side baseline for Viet purchase-surface honesty. Do not reopen that work unless the current repo actually contradicts the needed walkthrough contract.
- `T-126` is hardening the operator return packet, not the app-shell copy and state flow that a tester sees on-device.
- Real purchase, restore, restart, and persistence proof still requires a human/device pass. This task must not imply that repo inspection equals device validation.
- Prefer bounded clarity fixes and explicit unknowns over speculative redesign.

## Required outputs
Create or update these files:
- bounded `app/family/**` purchase, restore, restart, or locked-state surfaces only if a real repo-side contradiction exists
- `.agent/tasks/T-131/logs/viet-restore-walkthrough.md`
- `.agent/tasks/T-131/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-131/reviews/` for each required gate

## Concrete requirement
- audit the current Viet install, paywall, restore, and relaunch walkthrough surfaces with extra attention to small-screen clarity and the locked-to-premium handoff
- make sure any restore or restart guidance matches current repo truth and does not claim that fresh physical-device proof already exists
- if repo truth shows a real mismatch, fix only the bounded Viet shell surfaces needed for honest walkthrough continuity
- if the repo-side shell is already honest, leave a compact audit packet that names the exact remaining device-only unknowns so the next human proof run has a cleaner baseline
- keep the work meaningful and bounded, not a thin wording cleanup

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-purchase-honesty-review.md`
2. `02-restore-path-clarity-review.md`
3. `03-small-screen-viet-shell-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the audit or fix pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify `.agent/tasks/T-131/logs/viet-restore-walkthrough.md` exists
- run the smallest relevant validation or test commands for any touched `app/family` files and capture them in the result
- verify every required output file physically exists
- verify no `site/**`, `docs/operations/**`, release/build/TestFlight files, or unrelated shared-search files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify the final repo-side walkthrough does not claim physical-device proof that the repo does not actually have

## Definition of done
- the Viet repo-side purchase and restore walkthrough is either improved or more explicitly bounded for the next real device-proof run
- future human validation can trust one current shell-baseline packet instead of rediscovering the same ambiguity
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no fake readiness claim or out-of-scope shell rewrite was introduced
