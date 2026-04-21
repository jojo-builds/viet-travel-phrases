# Task Spec: T-080

## Title
Desktop Codex automation pilot, Indonesia second translation pack and unresolved-row reduction

## Objective
Continue the Indonesia prep lane from the cleared first translated batch into the next unresolved high-value traveler rows, especially receipt, bag, room-problem, support-call, and payment follow-through language, while preserving honest politeness and food or medical risk posture.

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
- `.agent/tasks/T-075/result.md`
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`

## Task type
- translation authoring
- second-pass unresolved-row reduction
- prep-lane hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-080/**`
- `content-draft/indonesian/**`

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
- Start from the translated first batch and continue into the unresolved high-value rows immediately below it.
- Keep `permisi` versus `maaf`, QR or scan payment phrasing, food-risk language, and any medical lines review-visible instead of flattening uncertainty away.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/indonesian/README.md`
- `content-draft/indonesian/source-notes.md`
- `content-draft/indonesian/phrase-source.csv`
- `content-draft/indonesian/first-wave-priority.csv`
- `content-draft/indonesian/research-backlog.md`
- `.agent/tasks/T-080/logs/translation-pack-audit.md`
- `.agent/tasks/T-080/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-080/reviews/` for each required gate

## Concrete requirement
- clear at least 24 unresolved row outcomes unless the remaining high-value set is genuinely smaller
- keep pronunciation and review posture honest on sensitive rows
- leave the Indonesia lane with a materially smaller unresolved queue than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-indonesian-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify required output files exist
- verify `content-draft/indonesian/phrase-source.csv` parses as CSV after edits
- verify `content-draft/indonesian/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the Indonesia prep lane advances beyond the first translated batch into the next meaningful unresolved cluster
- risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
