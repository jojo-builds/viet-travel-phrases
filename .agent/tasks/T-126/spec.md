# Task Spec: T-126

## Title
Desktop Codex automation pilot, Viet device-proof return packet and ASC evidence sync contract

## Objective
Tighten the operator-facing Viet device-proof lane so the next human return packet and App Store Connect evidence sync can be folded back into repo truth with less ambiguity, less cross-file drift, and no fake claim that device proof already exists.

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
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`

## Task type
- ops truth hardening
- device-proof evidence intake contract
- ASC return-packet sync prep

## Scope
### Allowed write scopes
- `.agent/tasks/T-126/**`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `app/family/**` as read-only reference only
- `content-draft/viet/**` as read-only context only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `content-draft/**` as a write surface
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- release/build/TestFlight generated artifacts
- unrelated task folders outside `.agent/tasks/T-126/**`

## Source-of-truth notes
- `T-100` and `T-112` already tightened honesty around the six-item return packet and the execution-packet owner file.
- The remaining gap is operator usability and later fold-in safety: the next human/device pass still risks returning evidence in a shape that is annoying to reconcile across the execution packet, runbook, app status, and dashboard JSON.
- This task must improve the intake contract only. It must not invent new build, purchase, restore, shared-search, or device evidence.
- Keep `CURRENT_BLOCKERS.md` and `LATEST_VALIDATION.md` out of scope in this pass so this task stays clear of the blocked shared-search lane and only hardens the packet owner plus sync contract.

## Required outputs
Create or update these files:
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`
- `.agent/tasks/T-126/logs/viet-device-proof-return-packet.md`
- `.agent/tasks/T-126/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-126/reviews/` for each required gate

## Concrete requirement
- make the next human return packet easier to submit and easier to fold back into repo truth by standardizing one exact evidence shape for preview install state, TestFlight/store state, Apple-side purchase readiness, on-device purchase/restore/relaunch proof, shared-search follow-through or explicit carry-forward, and sync completion
- ensure the execution packet, runbook, app status, and `ops/apps/viet.json` all point at the same intake owner and the same evidence fields
- leave one compact audit that explains what changed in the intake contract, what still requires a real human/device return, and which surfaces should update first when evidence arrives
- preserve honest wording that Viet remains not yet device-proven until real evidence lands

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ops-truth-review.md`
2. `02-device-proof-honesty-review.md`
3. `03-operator-usability-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify `ops/apps/viet.json` still parses as JSON
- verify every required output file physically exists
- verify no `app/**`, `site/**`, `content-draft/**`, `docs/operations/CURRENT_BLOCKERS.md`, or `docs/operations/LATEST_VALIDATION.md` changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the next Viet human/device return packet is explicit, compact, and cross-file consistent
- ops truth stays honest about the absence of fresh device proof
- future evidence fold-in has a smaller ambiguity surface
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no fake readiness claim or out-of-scope blocker rewrite was introduced
