# Task Spec: T-079

## Title
Desktop Codex automation pilot, South Korea second translation pack and unresolved-row reduction

## Objective
Continue the South Korea prep lane from the cleared top-30 batch into the next unresolved high-value rows, keeping Hangul, traveler-friendly pronunciation support, and explicit sensitivity notes honest while shrinking the remaining queue for later runtime consideration.

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
- `.agent/tasks/T-076/result.md`
- `content-draft/korean/README.md`
- `content-draft/korean/source-notes.md`
- `content-draft/korean/phrase-source.csv`
- `content-draft/korean/first-wave-priority.csv`
- `content-draft/korean/research-backlog.md`

## Task type
- translation authoring
- second-pass unresolved-row reduction
- prep-lane hardening

## Scope
### Allowed write scopes
- `.agent/tasks/T-079/**`
- `content-draft/korean/**`

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
- Start from the translated top-30 batch and continue into the remaining unresolved cluster.
- Keep the medically sensitive line and any apology-versus-attention service wording explicitly review-visible.
- Preserve Hangul as display truth and use pronunciation only as helper support.
- Stay prep-only.

## Required outputs
Create or update these files:
- `content-draft/korean/README.md`
- `content-draft/korean/source-notes.md`
- `content-draft/korean/phrase-source.csv`
- `content-draft/korean/first-wave-priority.csv`
- `content-draft/korean/research-backlog.md`
- `.agent/tasks/T-079/logs/translation-pack-audit.md`
- `.agent/tasks/T-079/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-079/reviews/` for each required gate

## Concrete requirement
- clear at least 24 unresolved row outcomes unless the remaining high-value set is genuinely smaller
- keep review flags and pronunciation posture honest on sensitive rows
- leave a materially smaller unresolved queue than before

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-korean-language-risk-review.md`
3. `03-translation-pack-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify required output files exist
- verify `content-draft/korean/phrase-source.csv` parses as CSV after edits
- verify `content-draft/korean/first-wave-priority.csv` parses as CSV after edits
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify no `app/**`, `site/**`, or runtime-wiring files were changed

## Definition of done
- the South Korea prep lane advances beyond the first translated batch into the next meaningful unresolved cluster
- risk posture remains honest
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- prep-only boundary is preserved
