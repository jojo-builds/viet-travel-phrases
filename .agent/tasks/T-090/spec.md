# Task Spec: T-090

## Title
Desktop Codex automation pilot, Viet readiness truth refresh and blocker-ledger hardening

## Objective
Refresh the Viet live-operating truth after the recent shell and search audit passes so the blocker ledger, latest validation snapshot, testing runbook, and app status all agree on what is actually proven, what remains blocked, and what the next human/device checks must cover.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-071/result.md`
- `.agent/tasks/T-072/result.md`
- `.agent/tasks/T-073/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`

## Task type
- ops-truth sync
- blocker-ledger hardening
- readiness evidence refresh

## Scope
### Allowed write scopes
- `.agent/tasks/T-090/**`
- `docs/operations/**`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `.agent/tasks/T-071/**`
- `.agent/tasks/T-072/**`
- `.agent/tasks/T-073/**`
- `app/family/**`
- `content-draft/viet/**`

### Must not touch
- `app/**` as a write surface
- `site/**`
- `content-draft/**` as a write surface
- release/build/TestFlight files
- unrelated task folders outside `.agent/tasks/T-090/**`

## Source-of-truth notes
- Stay honest about what is still missing: physical-device proof, purchase and restore proof, and any runtime validation that repo inspection alone cannot establish.
- Use `T-072` and blocked `T-073` as evidence inputs, not as permission to overclaim readiness.
- Prefer tighter blocker wording, explicit evidence gaps, and clearer next-human actions over broad strategy edits.
- This task may improve live operating truth even if product state itself does not change.

## Required outputs
Create or update these files:
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`
- `.agent/tasks/T-090/logs/readiness-audit.md`
- `.agent/tasks/T-090/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-090/reviews/` for each required gate

## Concrete requirement
- make the Viet readiness surfaces agree on blocker truth, latest evidence, and next required human/device checks
- capture the bounded value of the recent queue tasks without overstating production readiness
- leave a clearer blocker ledger than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ops-truth-review.md`
2. `02-device-proof-honesty-review.md`
3. `03-blocker-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main sync pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify all required output files exist
- verify docs and `ops/apps/viet.json` agree on current blocker posture
- verify no app, site, or content-draft files were changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet readiness truth is tighter, clearer, and still honest about missing proof
- required files exist and agree on the core blocker ledger
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status
