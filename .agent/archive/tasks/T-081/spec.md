# Task Spec: T-081

## Title
Desktop Codex automation pilot, Spain second translation pack and unresolved-row reduction

## Objective
Continue the Spain prep lane from the completed first-wave translation pass by clearing the remaining unresolved high-value rewrite rows, then pull the next practical traveler rows forward so the lane leaves behind a materially smaller unresolved queue instead of another tiny follow-up pass.

This is still prep-only work. Do not wire Spanish into the runtime app.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/V2_CONTENT_MODEL.md`
- `.agent/tasks/T-013/result.md`
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/phrase-source.csv`
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`
- `research/language-pipeline/spanish/SPAIN-TRAVEL-RESEARCH.md`

## Task type
- translation authoring
- second-pass unresolved-row reduction
- prep-lane hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-081/**`
- `content-draft/spanish/**`

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
- Start from the translated top rows already landed by `T-013`.
- Clear the deferred bargaining and directions rewrite debt before pretending the next pass is clean.
- After those rewrites, prefer practical Spain traveler rows like station help, card payment, receipt, reservation follow-through, and repair phrases over filler.
- Keep medical, allergy, police, and lost-passport sensitivity explicit rather than flattening it away.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/spanish/README.md`
- `content-draft/spanish/source-notes.md`
- `content-draft/spanish/phrase-source.csv`
- `content-draft/spanish/first-wave-priority.csv`
- `content-draft/spanish/research-backlog.md`
- `.agent/tasks/T-081/logs/translation-pack-audit.md`
- `.agent/tasks/T-081/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-081/reviews/` for each required gate

## Concrete requirement
- clear at least 24 additional unresolved row outcomes unless the remaining high-value set is genuinely smaller
- rewrite the flagged bargaining and directions rows before literal translation when that produces more honest Spain-fit phrasing
- keep pronunciation and review flags honest on sensitive rows
- leave the Spain lane with a materially smaller unresolved queue than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-spanish-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify `content-draft/spanish/phrase-source.csv` parses as CSV after edits
- verify `content-draft/spanish/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the Spain prep lane advances beyond the first translated batch into the next meaningful unresolved cluster
- review-risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
