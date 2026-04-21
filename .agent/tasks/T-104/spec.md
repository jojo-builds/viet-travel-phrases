# Task Spec: T-104

## Title
Desktop Codex automation pilot, Turkey residual-tail closure and native-review handoff pack

## Objective
Push the Turkish lane past the recent utility pass by resolving as much of the remaining practical tail as honestly fits, then convert whatever still should not be promoted into an explicit native-review or rewrite handoff. The goal is to leave Turkey with a small, crisp residual story instead of a mixed queue of practical rows and vague holdouts.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-028/result.md`
- `.agent/tasks/T-097/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/turkish/README.md`
- `content-draft/turkish/source-notes.md`
- `content-draft/turkish/phrase-source.csv`
- `content-draft/turkish/first-wave-priority.csv`
- `content-draft/turkish/research-backlog.md`

## Task type
- prep-lane translation follow-up
- residual-tail closure
- native-review handoff tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-104/**`
- `content-draft/turkish/**`

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
- Start from the `12` remaining `needs-translation` rows and the explicit holdouts called out in `T-097`.
- Prefer clearing the full currently unresolved practical set if it still fits cleanly; do not seed a tiny conservative batch.
- Keep `turkish-street-food-6` deferred unless it gets a clearly stronger Turkey-natural rewrite.
- Preserve visible caution around medical, bargaining, and context-sensitive service wording.

## Required outputs
Create or update these files:
- `content-draft/turkish/README.md`
- `content-draft/turkish/source-notes.md`
- `content-draft/turkish/phrase-source.csv`
- `content-draft/turkish/first-wave-priority.csv`
- `content-draft/turkish/research-backlog.md`
- `.agent/tasks/T-104/logs/turkish-residual-pack.md`
- `.agent/tasks/T-104/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-104/reviews/` for each required gate

## Concrete requirement
- resolve the remaining practical Turkish tail as far as current source quality honestly allows
- leave one explicit residual handoff for the rows that still need rewrite or native/expert review
- preserve a clean distinction between translated rows, rewrite-needed rows, and later-only holdouts

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-turkey-coverage-review.md`
2. `02-register-and-risk-review.md`
3. `03-residual-tail-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify touched Turkish CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Turkish lane has a materially smaller unresolved tail or a sharper explicit residual handoff than before
- every remaining unresolved Turkish row has an explicit reason and next owner
- all 3 mandatory review gates passed with unanimous 4-subagent approval
