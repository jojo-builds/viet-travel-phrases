# Task Spec: T-074

## Title
Desktop Codex automation pilot, cross-language ElevenLabs prep audio batch

## Objective
Use the expiring ElevenLabs credits on one meaningful prep-only phrase-audio batch for future language lanes that already have translated rows. Generate durable MP3 prep assets plus manifest evidence for the currently translated non-Viet rows in `content-draft/german/`, `content-draft/japanese/`, `content-draft/spanish/`, `content-draft/italian/`, and `content-draft/turkish/`. If `T-070` lands before this task claims, include any newly translated German rows in the same batch. Do not wire these clips into runtime app surfaces yet.

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
- if present, `.agent/coordination/elevenlabs-prep-audio-batch-summary-2026-04-20.json`
- `content-draft/german/**` within the bounded prep-audio surface
- `content-draft/japanese/**` within the bounded prep-audio surface
- `content-draft/spanish/**` within the bounded prep-audio surface
- `content-draft/italian/**` within the bounded prep-audio surface
- `content-draft/turkish/**` within the bounded prep-audio surface

## Task type
- bounded prep-audio generation
- cross-language batch burn
- continuity-honest prep asset packaging

## Scope
### Allowed write scopes
- `.agent/tasks/T-074/**`
- `content-draft/german/**`
- `content-draft/japanese/**`
- `content-draft/spanish/**`
- `content-draft/italian/**`
- `content-draft/turkish/**`

### Allowed read scopes
- `docs/**`
- `.agent/coordination/**`
- `content-draft/**`

### Must not touch
- `site/**`
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- runtime app wiring or family-pack integration surfaces
- unrelated language lanes beyond the 5 named prep-audio candidates

## Source-of-truth notes
- Prefer one coherent high-value batch, usually at least `24` row outcomes unless the currently translated candidate set is genuinely smaller.
- This is prep-only asset generation, not runtime wiring or app-readiness proof.
- Use the current ElevenLabs multilingual voice/model/settings already established in repo truth unless an exact blocker forces a documented deviation.
- Preserve honest caution language about draft/prep audio quality and do not imply native review or runtime readiness.
- Leave behind exact evidence of what changed and what still remains untranslated or audio-missing.

## Required outputs
Create or update these files:
- prep-only MP3 outputs and `manifest.json` under each touched language lane, typically `content-draft/<language>/audio-draft/**`
- `.agent/tasks/T-074/logs/audio-followup-audit.md`
- `.agent/tasks/T-074/result.md`
- exactly 4 review artifacts for each required review gate under `.agent/tasks/T-074/reviews/`

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-audio-utility-review.md`
2. `02-continuity-risk-review.md`
3. `03-mapping-scope-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are read-only except for their assigned review file.
- Keep review-only reads lean: `spec.md`, the claimed `state.json`, the target artifacts, and only the latest relevant prior review artifacts for that role.
- Create the current gate/pass folder on demand.

## Required checks
- verify the audit artifact exists
- verify each touched language prep-audio folder has internally consistent file-to-manifest coverage
- verify latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify scope stayed bounded to the named prep-language audio surfaces

## Definition of done
- a meaningful cross-language prep-audio batch is either advanced honestly or the bounded blocker is documented with exact evidence
- required outputs exist
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write `.agent/tasks/T-074/result.md` with the standard task result shape.
