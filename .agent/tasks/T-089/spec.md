# Task Spec: T-089

## Title
Desktop Codex automation pilot, Germany lone-holdout isolation and native-review handoff pack

## Objective
Follow `T-084` by deciding the final Germany residual posture honestly: either land a stronger bounded rewrite for the lone remaining holdout if the evidence supports it, or convert that row into an explicit native-review handoff while tightening the lane notes around pronunciation and sensitive-row caution.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-078/result.md`
- `.agent/tasks/T-084/result.md`
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`

## Task type
- holdout isolation
- native-review handoff hardening
- prep-lane truth cleanup

## Scope
### Allowed write scopes
- `.agent/tasks/T-089/**`
- `content-draft/german/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**` for boundary reference only
- `app/family/**` for bounded family-shape reference only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes except read-only inspection

## Source-of-truth notes
- Start from the one explicit holdout and the remaining caution set left by `T-084`.
- Do not invent filler just to keep the lane busy.
- If `german-coffee-shop-4` still is not strong enough for Germany-first release truth, convert it into an explicit native-review or later-rewrite handoff instead of forcing promotion.
- Keep medical, ride-guidance, transit, and register cautions visible.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`
- `.agent/tasks/T-089/logs/holdout-decision.md`
- `.agent/tasks/T-089/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-089/reviews/` for each required gate

## Concrete requirement
- either resolve the lone remaining practical holdout or convert it into an explicit native-review handoff with clear reason
- leave the Germany lane with a final residual posture that is cleaner and more honest than after `T-084`
- keep pronunciation and risk notes honest on any row that remains sensitive

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-german-language-risk-review.md`
3. `03-handoff-integrity-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify `content-draft/german/phrase-source.csv` and `content-draft/german/first-wave-priority.csv` parse as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- Germany residual-tail truth is either fully closed or honestly converted into explicit handoff posture
- risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
