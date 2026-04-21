# Task Spec: T-082

## Title
Desktop Codex automation pilot, Tagalog v2 premium-follow-on pack and holdout reduction

## Objective
Continue the Tagalog v2 prep lane from the hardened `16 / 7 / 1` split by pulling the strongest premium-follow-on rows into materially stronger draft truth, tightening the remaining holdout logic, and leaving a cleaner next-pass queue without claiming runtime graduation.

This is still prep-only work. Do not wire Tagalog into the runtime app.

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
- `.agent/tasks/T-077/result.md`
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/research-backlog.md`

## Task type
- translation authoring
- premium-follow-on hardening
- prep-lane holdout reduction

## Scope
### Allowed write scopes
- `.agent/tasks/T-082/**`
- `content-draft/tagalog/**`

### Allowed read scopes
- `docs/**`
- `templates/**`
- `research/**`
- `content-draft/viet/**`
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
- Start from the current `16` starter-core rows already hardened by `T-077`.
- Pull from the `7` premium-follow-on rows first, especially the strongest traveler-value rows that reduce known holdouts without pretending the refusal row is solved.
- Keep the single deferred refusal row explicit unless the evidence becomes clearly stronger.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/tagalog/README.md`
- `content-draft/tagalog/source-notes.md`
- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/rewrite-notes.md`
- `content-draft/tagalog/risk-review.md`
- `content-draft/tagalog/research-backlog.md`
- `.agent/tasks/T-082/logs/premium-follow-on-audit.md`
- `.agent/tasks/T-082/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-082/reviews/` for each required gate

## Concrete requirement
- clear at least 24 row outcomes unless the bounded high-value set is genuinely smaller
- prefer meaningful premium-follow-on and adjacent unresolved rows over tiny cosmetic edits
- keep pronunciation and confidence notes honest on sensitive or awkward lines
- leave the Tagalog lane with a materially smaller non-starter queue than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-tagalog-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.

## Required checks
- verify required output files exist
- verify `content-draft/tagalog/phrase-source.csv` parses as CSV after edits
- verify `content-draft/tagalog/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the Tagalog prep lane advances beyond the starter-core split into a materially stronger premium-follow-on surface
- review-risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
