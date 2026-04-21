# Task Spec: T-110

## Title
Desktop Codex automation pilot, Viet phrase-page audio playback seam and starter export hardening pass

## Objective
Follow the current website export truth with one bounded phrase-page pass. Add or tighten simple on-demand audio playback only on the Viet phrase surfaces that already carry site-owned starter audio, and leave behind a clearer durable contract for how phrase-page playback should stay aligned with the export seam.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-093/result.md`
- `.agent/tasks/T-102/result.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `content-draft/viet/website-preview.json`
- bounded `site/**` Viet phrase-page templates, loaders, and starter-export surfaces
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`

## Task type
- bounded website seam implementation
- phrase-page playback hardening
- starter export contract tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-110/**`
- `site/**` within Viet phrase-page, loader, and starter-export playback scope
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` only if a bounded validation update is needed for the new playback contract

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `app/family/packs/**`
- `app/assets/audio/**` for bounded reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- unrelated country pages or broad website conversion strategy surfaces outside the Viet starter/audio seam
- manual edits to generated preview JSON when source or exporter truth should drive the fix instead

## Source-of-truth notes
- Keep this work bounded to phrase pages that already have site-owned starter audio coverage.
- Do not claim broad website audio rollout or full-country-page playback if the repo truth only supports phrase-surface playback.
- Preserve the starter-only export boundary and route-pair parity.
- If the current phrase surfaces are already good enough, leave an evidence-backed no-churn result instead of cosmetic UI churn.

## Required outputs
Create or update these files:
- bounded `site/**` files only where playback or seam clarity genuinely needs work
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `.agent/tasks/T-110/logs/phrase-page-audio-playback.md`
- `.agent/tasks/T-110/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-110/reviews/` for each required gate

## Concrete requirement
- inspect the existing Viet phrase/article surfaces that already rely on the starter export seam
- implement or tighten simple on-demand playback only where the repo truth supports it cleanly
- keep the work aligned with exported `/data/phrase-audio/*` truth and the current validator path
- if code changes are required, run the smallest relevant website validation and document the result

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-website-audio-seam-review.md`
2. `02-viet-phrase-surface-review.md`
3. `03-starter-boundary-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify `phrase-page-audio-playback.md` exists
- run the smallest relevant website validation for touched surfaces and capture it in the result
- verify route-pair parity still holds if any paired Viet route files change
- verify no `app/**`, `ops/**`, `docs/operations/**`, or unrelated country-route files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Viet website phrase surface is either measurably clearer on bounded on-demand audio playback or honestly confirmed as already good enough
- starter export and site-owned audio truth remain honest and validation-backed
- all 3 mandatory review gates passed with unanimous 4-subagent approval
