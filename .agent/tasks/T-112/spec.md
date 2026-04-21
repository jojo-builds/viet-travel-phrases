# Task Spec: T-112

## Title
Desktop Codex automation pilot, Viet device-proof execution packet hardening and blocker-surface sync pass

## Objective
Tighten the operator-facing Viet return lane so the next human/device pass is easier to execute correctly and easier to fold back into durable truth. Convert the current six-item handoff into a sharper execution packet, remove duplicate or fuzzy wording across ops docs, and leave the blocker surfaces aligned without claiming any new build, ASC, purchase, restore, or device evidence.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-100/result.md`
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `ops/apps/viet.json`

## Task type
- ops truth hardening
- execution-packet simplification
- blocker-surface sync

## Scope
### Allowed write scopes
- `.agent/tasks/T-112/**`
- `docs/operations/**`
- `ops/apps/viet.json`

### Allowed read scopes
- `docs/**`
- `ops/**`
- `app/family/**` for bounded product-shape reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `content-draft/**`
- release/build/TestFlight generated artifacts
- unrelated lane task folders outside `.agent/tasks/T-112/**`

## Source-of-truth notes
- Start from `T-100` and the current live ops surfaces, not older pre-refresh wording.
- This task is allowed to improve structure, ordering, evidence prompts, and blocker phrasing, but it must not invent new successful device, purchase, restore, TestFlight, or App Store Connect facts.
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md` must end this task as the sole ordered checklist owner for the next human/device Viet pass. The other touched surfaces should summarize status, blockers, and sync expectations only.
- Do not edit `docs/operations/LATEST_VALIDATION.md` in this task unless fresh durable evidence exists. This task is a wording and operator-packet hardening pass only.
- Keep the next human/device return packet explicit and easy to execute.
- Prefer one clear operator story across `VIET_TESTFLIGHT_EXECUTION_PACKET.md`, `TESTING_RUNBOOK.md`, `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, and `ops/apps/viet.json` instead of near-duplicate but slightly different wording.

## Required outputs
Create or update these files:
- `docs/operations/VIET_TESTFLIGHT_EXECUTION_PACKET.md`
- `docs/operations/TESTING_RUNBOOK.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/APP_STATUS.md`
- `ops/apps/viet.json`
- `.agent/tasks/T-112/logs/device-proof-packet-hardening.md`
- `.agent/tasks/T-112/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-112/reviews/` for each required gate

## Concrete requirement
- leave behind one exact Viet execution packet that a human can run without hunting across multiple docs
- make blocker wording and next-step wording agree across the touched ops surfaces
- preserve explicit honesty about what is still unproven
- record a compact task-local audit explaining what changed and what evidence is still missing

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-ops-truth-review.md`
2. `02-device-proof-honesty-review.md`
3. `03-operator-usability-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify `ops/apps/viet.json` still parses cleanly
- verify the required output files exist
- verify touched ops surfaces agree on the same blocker posture and next operator packet
- verify no `app/**`, `site/**`, or `content-draft/**` files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Viet execution packet is materially clearer and easier for the next operator run to follow
- touched blocker surfaces agree on the same current evidence boundary and next action
- no new evidence is claimed beyond the current repo truth
- all 3 mandatory review gates passed with unanimous 4-subagent approval
