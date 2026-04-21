# Task Spec: T-078

## Title
Desktop Codex automation pilot, Germany second translation pack and unresolved-row reduction

## Objective
Continue the Germany prep lane from the cleared top-30 batch into the next unresolved high-value rows, tightening traveler usefulness and preserving explicit review flags on sensitive wording so the lane keeps moving toward runtime-ready source quality without claiming graduation.

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
- `.agent/tasks/T-070/spec.md`
- `.agent/tasks/T-070/result.md`
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`

## Task type
- translation authoring
- second-pass unresolved-row reduction
- prep-lane hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-078/**`
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
- Start from the already translated top-30 batch. Do not reopen cleared rows unless a blocker in that row prevents honest next-pass progress.
- The default next cluster is room-problem, convenience-store, directions follow-up, and related practical traveler rows.
- Keep medical, transit-jargon, and service-wording sensitivity visible rather than flattening it away.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/german/README.md`
- `content-draft/german/source-notes.md`
- `content-draft/german/phrase-source.csv`
- `content-draft/german/first-wave-priority.csv`
- `content-draft/german/research-backlog.md`
- `.agent/tasks/T-078/logs/translation-pack-audit.md`
- `.agent/tasks/T-078/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-078/reviews/` for each required gate

## Concrete requirement
- clear at least 24 additional unresolved row outcomes unless the remaining high-value set is genuinely smaller
- keep pronunciation and review flags honest on sensitive rows
- leave the Germany lane with a materially smaller unresolved queue than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-german-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify required output files exist
- verify `content-draft/german/phrase-source.csv` parses as CSV after edits
- verify `content-draft/german/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the Germany prep lane advances beyond the first translated batch into the next meaningful unresolved cluster
- review-risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
