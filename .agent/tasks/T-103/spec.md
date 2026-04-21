# Task Spec: T-103

## Title
Desktop Codex automation pilot, Tagalog v2 parked-backlog reopen order and next-pass curation pack

## Objective
Take the newly clarified Tagalog v2 `16` starter-core plus `1` deferred refusal-row handoff and convert the parked backlog into one sharper next-pass contract. Keep the refusal row deferred, decide which parked rows are realistic next pickups versus later-only holds, and leave the lane with a cleaner order for the next real Tagalog content pass instead of a fuzzy parked cluster.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-088/result.md`
- `.agent/tasks/T-096/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`

## Task type
- prep-lane curation
- parked-backlog triage
- next-pass handoff tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-103/**`
- `content-draft/tagalog/**`

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
- Start from the explicit ordered reopen contract landed by `T-096`, not the older shorthand backlog.
- Keep `tagalog-polite-basics-4` deferred unless the current lane truth itself proves a stronger refusal-safe rewrite; do not force promotion just to shrink the queue.
- A smaller row-count is acceptable here because the active unresolved Tagalog set is now narrow and high-touch.
- The win is a sharper next-pass contract for real Tagalog follow-on work, not bulk translation.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/research-backlog.md`
- `content-draft/tagalog/risk-review.md`
- `.agent/tasks/T-103/logs/parked-backlog-curation.md`
- `.agent/tasks/T-103/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-103/reviews/` for each required gate

## Concrete requirement
- make an explicit disposition for every currently parked Tagalog v2 row outside the `16` starter-core and the lone deferred refusal row
- leave one exact recommended next-pass pickup set and one later-only hold set
- preserve visible caution around refusal tone, safety-sensitive wording, and low-fit rows

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-tagalog-next-pass-review.md`
2. `02-risk-and-register-review.md`
3. `03-parked-backlog-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify touched Tagalog CSV surfaces still parse cleanly
- verify no app, site, ops, or unrelated language files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Tagalog v2 lane has a clearer post-`T-096` next-pass handoff than before
- every parked row now has an explicit next-pass or later-only disposition
- all 3 mandatory review gates passed with unanimous 4-subagent approval
