# Task Spec: T-117

## Title
Desktop Codex automation pilot, Viet starter export contract and off-hub module parity hardening pass

## Objective
Strengthen the export-driven Viet website seam without reopening broad conversion copy. Audit the full seven-module starter export surface, keep the approved four-module on-hub subset intact unless repo truth clearly disproves it, and make the off-hub contract more explicit in export metadata, docs, and validator coverage so future website edits do not silently drift.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-093/result.md`
- `.agent/tasks/T-102/result.md`
- `.agent/tasks/T-110/result.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`

## Task type
- website starter-export hardening
- export-contract parity pass
- Viet live-seam guardrail work

## Scope
### Allowed write scopes
- `.agent/tasks/T-117/**`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/data/phrase-previews/**`
- `site/public/data/phrase-previews/**`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `site/**`
- `app/family/packs/**` for bounded starter-shape reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- unrelated country-page conversion copy outside the export contract
- release/build/TestFlight files
- manual patching of generated surfaces when source-truth or deterministic export metadata should drive the fix instead

## Source-of-truth notes
- The approved live posture is still a seven-module export surface with a four-module Vietnam hub subset and three intentionally off-hub modules.
- This task owns export contract clarity, not broader country-page conversion wording.
- Keep playback scope and export subset honesty aligned with `T-102` and `T-110`.

## Required outputs
Create or update these files:
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- `.agent/tasks/T-117/logs/viet-starter-export-contract.md`
- `.agent/tasks/T-117/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-117/reviews/` for each required gate

## Concrete requirement
- make the full seven-module export contract explicit enough that on-hub versus off-hub status is easy to validate from repo truth
- preserve the current approved four-module Vietnam hub subset unless bounded evidence clearly supports a different split
- add or tighten validator coverage so export metadata, public-copy manifests, and durable docs fail together instead of drifting silently
- record a compact audit explaining why the final contract is more robust for future website work

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-website-export-review.md`
2. `02-conversion-honesty-review.md`
3. `03-viet-surface-scope-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify required output files exist
- verify both manifest files still parse as JSON
- run `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- verify no `app/**`, `ops/**`, or unrelated country-page files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Viet starter export contract is harder to drift accidentally
- on-hub versus off-hub module truth is explicit across docs, export metadata, and validator checks
- the website seam stays honest and bounded
- all 3 mandatory review gates passed with unanimous 4-subagent approval
