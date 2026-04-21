# Task Spec: T-118

## Title
Desktop Codex automation pilot, Italy residual holdout adjudication and graduation-readiness packet

## Objective
Close the Italy prep lane to one sharper graduation-ready packet. Start from the near-finished lane left by `T-111`, decide the final posture for the remaining two unresolved holdouts, and leave one explicit readiness handoff instead of a half-finished residual tail.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-111/result.md`
- `content-draft/italian/README.md`
- `content-draft/italian/source-notes.md`
- `content-draft/italian/phrase-source.csv`
- `content-draft/italian/first-wave-priority.csv`
- `content-draft/italian/research-backlog.md`

## Task type
- residual-holdout adjudication
- graduation-readiness packet
- Italy prep-lane closeout

## Scope
### Allowed write scopes
- `.agent/tasks/T-118/**`
- `content-draft/italian/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
- `content-draft/tagalog/**` for bounded handoff-shape reference only
- `app/family/**` as read-only context only

### Must not touch
- `app/**` as a write surface
- `site/**`
- `ops/**`
- `docs/operations/**`
- runtime registry wiring
- release/build/TestFlight files
- unrelated language lanes except read-only comparison

## Source-of-truth notes
- `T-111` left the Italy lane with exactly two unresolved holdouts and a near-finished translation backlog.
- This smaller-than-usual batch is allowed because the bounded high-value set is now genuinely small, but the output still needs to feel proportionate by leaving one stronger readiness packet, not just two row edits.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/italian/README.md`
- `content-draft/italian/source-notes.md`
- `content-draft/italian/phrase-source.csv`
- `content-draft/italian/first-wave-priority.csv`
- `content-draft/italian/research-backlog.md`
- `.agent/tasks/T-118/logs/italian-graduation-packet.md`
- `.agent/tasks/T-118/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-118/reviews/` for each required gate

## Concrete requirement
- adjudicate the final two unresolved holdouts into one explicit outcome each: promote, rewrite-needed, native-review-only, or later-only hold, with clear reasons
- make the lane-level docs agree on whether Italy is effectively translation-complete for the current prep scope
- leave one explicit graduation-readiness packet so future runtime or launch planning can see what is done, what remains blocked, and what should not be promoted yet
- keep the result meaningful even if the row count is small by improving the handoff surfaces, not just editing the CSV

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-italian-language-risk-review.md`
3. `03-graduation-readiness-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify every required output file physically exists
- verify `content-draft/italian/phrase-source.csv` and `content-draft/italian/first-wave-priority.csv` still parse after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or `ops/**` files changed

## Definition of done
- the Italy lane no longer has an ambiguous residual tail
- the remaining holdout posture is explicit and easy to retrieve
- future planning can judge Italy readiness from one compact packet
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
