# Task Spec: T-113

## Title
Desktop Codex automation pilot, Viet relation-cluster expansion and listing-handoff hardening pass

## Objective
Build on the first Viet relation sample so the lane leaves a stronger listing-detail handoff instead of a one-pass schema demo. Expand the authored relation surface, tighten cluster guidance for retrieval and likely-reply navigation, and leave the next app or website implementation pass with a clearer starter-safe contract.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `.agent/tasks/T-107/result.md`
- `content-draft/viet/README.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `content-draft/viet/website-preview.json`

## Task type
- relation-model hardening
- listing-detail handoff expansion
- Viet retrieval contract prep

## Scope
### Allowed write scopes
- `.agent/tasks/T-113/**`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/tagalog/**`
- `app/family/**`
- `site/**` as read-only reference for listing/detail needs

### Must not touch
- runtime app code as a write surface in `app/**`
- release/build/TestFlight files
- unrelated non-Viet language lanes except read-only inspection
- billing / purchase / device-proof docs unless directly needed as a bounded reference

## Source-of-truth notes
- Start from the authored relation sample landed by `T-107`, not from a blank-schema exercise.
- This is still content/handoff truth, not final UI implementation.
- Keep the relation layer additive to the current scenario -> family -> phrase-row model.
- Prefer a stronger reusable listing/detail contract over a tiny row-polish pass.

## Required outputs
Create or update these files:
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/README.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `.agent/tasks/T-113/logs/viet-relation-expansion-audit.md`
- `.agent/tasks/T-113/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-113/reviews/` for each required gate

## Concrete requirement
- expand the Viet relation-ready authored surface beyond the current first `14` clusters into a stronger starter-safe retrieval pack covering at least `24` meaningful phrase-family clusters unless bounded repo truth proves the high-value set is smaller
- for each added or revised cluster, make the handoff clearer about anchor phrase, shorter or clearer alternative, likely reply or what-you-may-hear link, and next-step or repair branch when relevant
- tighten the narrative docs so a future listing/detail implementation lane can understand what is ready now versus what still needs later authoring
- preserve honest starter-safe boundaries and do not imply the whole Viet library is already relation-modeled

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-viet-language-risk-review.md`
3. `03-listing-handoff-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify every required output file physically exists
- verify `content-draft/viet/relation-sample-v1.json` parses as JSON
- verify the final sample covers at least `24` meaningful phrase-family clusters unless bounded evidence proves a smaller high-value set
- verify `content-draft/viet/phrase-source.csv` still parses after edits
- verify the schema and notes stay aligned with the current family/row model instead of replacing it
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no runtime app code files were changed

## Definition of done
- Viet has a materially stronger relation-ready listing/detail handoff than the first demo sample alone
- the authored contract is clearer about anchor, likely reply, and next-step links across a larger high-value cluster set
- the output is detailed enough that a later implementation lane can start without redoing concept design
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no separate graph-database dependency was introduced
