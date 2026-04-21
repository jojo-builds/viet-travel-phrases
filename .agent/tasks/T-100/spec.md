# Task Spec: T-100

## Title
Desktop Codex automation pilot, Viet device-proof evidence packet and blocker handoff tightening

## Objective
Tighten the Viet operator-facing readiness surfaces so the next human device pass has one clean, current evidence packet. Make the blocker ledger, latest validation snapshot, testing runbook, and app status agree on the exact build ids, purchase and restore proof gaps, and next required evidence without pretending any missing proof already exists.

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
- `.agent/tasks/T-090/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`

## Task type
- ops-truth sync
- device-proof handoff hardening
- blocker-ledger tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-100/**`
- `docs/operations/**`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `app/family/**`
- `content-draft/viet/**`
- `.agent/tasks/T-071/**`
- `.agent/tasks/T-072/**`
- `.agent/tasks/T-090/**`

### Must not touch
- `app/**` as a write surface
- `site/**`
- `content-draft/**` as a write surface
- release/build/TestFlight files
- unrelated task folders outside `.agent/tasks/T-100/**`

## Source-of-truth notes
- Stay strict about the missing proof: fresh iPhone install, purchase, restore, restart persistence, and any App Store Connect dependency that still blocks those checks.
- Use recent queue evidence as support, not as an excuse to overclaim readiness.
- The win here is a cleaner operator handoff and blocker packet, not product-state inflation.
- If repo surfaces disagree, fix the disagreement and record the exact evidence boundary.

## Required outputs
Create or update these files:
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `ops/apps/viet.json`
- `.agent/tasks/T-100/logs/device-proof-handoff.md`
- `.agent/tasks/T-100/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-100/reviews/` for each required gate

## Concrete requirement
- leave one aligned device-proof handoff covering the current build ids, current blocker causes, and exact next evidence needed
- remove any stale wording that makes the repo look more proven than it is
- keep the next human/device pass easier to execute than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ops-truth-review.md`
2. `02-device-proof-honesty-review.md`
3. `03-blocker-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the touched docs and `ops/apps/viet.json` agree on the current blocker posture
- verify no app, site, or content-draft files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- Viet operator-facing readiness truth is tighter and more actionable than before
- missing device and purchase proof is still stated honestly
- the next human/device pass has a clearer handoff packet
- all 3 mandatory review gates passed with unanimous 4-subagent approval
