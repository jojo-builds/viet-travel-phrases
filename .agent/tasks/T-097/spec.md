# Task Spec: T-097

## Title
Desktop Codex automation pilot, Turkey next utility translation pack and holdout review pass

## Objective
Push the Turkish prep lane through its next bounded utility pass by translating the remaining highest-value practical rows, tightening the five flagged holdouts, and leaving the lane with a smaller, more explicit residual queue.

This remains prep-only work. Do not wire Turkish into runtime truth.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-005/result.md`
- `.agent/tasks/T-012/result.md`
- `.agent/tasks/T-028/result.md`
- `content-draft/turkish/README.md`
- `content-draft/turkish/source-notes.md`
- `content-draft/turkish/phrase-source.csv`
- `content-draft/turkish/first-wave-priority.csv`
- `content-draft/turkish/research-backlog.md`

## Task type
- prep-lane translation pass
- holdout review
- unresolved-row reduction

## Scope
### Allowed write scopes
- `.agent/tasks/T-097/**`
- `content-draft/turkish/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**`
- `app/family/**`

### Must not touch
- `app/**`
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated edits under other language lanes

## Source-of-truth notes
- Start from the remaining utility rows already called out in `research-backlog.md`: `turkish-grab-taxi-2`, `turkish-grab-taxi-6`, `turkish-directions-4`, `turkish-directions-5`, `turkish-street-food-2`, `turkish-street-food-4`, `turkish-street-food-6`, `turkish-polite-basics-3`, `turkish-polite-basics-6`, and `turkish-convenience-store-4`.
- Revisit the five still-flagged holdouts with honest traveler-utility judgment, especially bargaining, medical, food-risk, and softer service tone.
- The live bounded set is smaller than the usual `24` row floor, so clear the full worthwhile set and document any deliberate residual holdouts instead of padding with filler.
- Keep pronunciation helper guidance useful but explicitly draft-level.

## Required outputs
Create or update these files:
- `content-draft/turkish/README.md`
- `content-draft/turkish/source-notes.md`
- `content-draft/turkish/phrase-source.csv`
- `content-draft/turkish/first-wave-priority.csv`
- `content-draft/turkish/research-backlog.md`
- `.agent/tasks/T-097/logs/turkish-utility-audit.md`
- `.agent/tasks/T-097/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-097/reviews/` for each required gate

## Concrete requirement
- translate or explicitly defer the listed next utility rows
- tighten the review stance on the five flagged holdouts instead of leaving them vague
- leave the next Turkish worker a materially smaller and clearer residual queue

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-translation-quality-review.md`
2. `02-turkey-fit-review.md`
3. `03-holdout-ledger-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify the changed Turkish CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Turkish lane has more practical translated coverage and a cleaner residual queue than before
- every changed surface stays inside `content-draft/turkish/**` plus task artifacts
- the remaining holdouts are explicit and honest rather than fuzzy
- all 3 mandatory review gates passed with unanimous 4-subagent approval
