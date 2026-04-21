# Task Spec: T-101

## Title
Desktop Codex automation pilot, Japan deferred-row decision and starter-slice curation pack

## Objective
Now that the Japanese lane has no raw `needs-translation` rows left, convert the remaining deferred and low-priority tail into a crisp starter-slice handoff. Decide what stays deferred, what needs rewrite or native review, and what belongs in the next practical starter recommendation instead of leaving the lane with a fuzzy post-translation tail.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-027/result.md`
- `.agent/tasks/T-094/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/japanese/README.md`
- `content-draft/japanese/source-notes.md`
- `content-draft/japanese/phrase-source.csv`
- `content-draft/japanese/first-wave-priority.csv`
- `content-draft/japanese/research-backlog.md`

## Task type
- prep-lane curation
- deferred-tail decision pass
- starter-slice handoff tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-101/**`
- `content-draft/japanese/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `app/family/**` for bounded product-shape reference only

### Must not touch
- `app/**`
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Start from the explicit deferred quartet plus the small-talk tail called out in `T-094`.
- The goal is curation clarity, not bulk new translation.
- If a row still does not deserve inclusion in a practical Japan starter handoff, keep it deferred with a sharper reason.
- A smaller row-count is acceptable here because the genuinely high-value unresolved set is now narrow.

## Required outputs
Create or update these files:
- `content-draft/japanese/README.md`
- `content-draft/japanese/source-notes.md`
- `content-draft/japanese/phrase-source.csv`
- `content-draft/japanese/first-wave-priority.csv`
- `content-draft/japanese/research-backlog.md`
- `.agent/tasks/T-101/logs/starter-slice-curation.md`
- `.agent/tasks/T-101/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-101/reviews/` for each required gate

## Concrete requirement
- make an explicit disposition for every currently deferred or low-priority Japanese tail row
- leave one clearer starter-slice recommendation for the next Japan runtime/content handoff
- preserve visible caution around medical, bargaining, and weak-fit social phrasing

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-japan-starter-slice-review.md`
2. `02-risk-and-register-review.md`
3. `03-deferred-tail-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify touched Japanese CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Japanese lane has a clearer post-translation starter-slice handoff than before
- every remaining deferred or low-priority tail row has an explicit disposition
- all 3 mandatory review gates passed with unanimous 4-subagent approval
