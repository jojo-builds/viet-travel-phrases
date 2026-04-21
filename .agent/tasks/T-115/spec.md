# Task Spec: T-115

## Title
Desktop Codex automation pilot, Vietnam starter conversion path and situation-copy hardening pass

## Objective
Tighten the public Vietnam starter path so the current country pages lead more cleanly from high-stress traveler situations into the starter-safe app handoff without reopening broader website strategy. This should strengthen the live conversion seam and keep the copy honest about what the website shows versus what the app unlocks.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-091/result.md`
- `.agent/tasks/T-102/result.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `content-draft/viet/website-preview.json`

## Task type
- website conversion hardening
- Vietnam situation-copy tightening
- starter-path honesty pass

## Scope
### Allowed write scopes
- `.agent/tasks/T-115/**`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- bounded related include or data surfaces under `site/**` only if required to keep those two routes truthful and in parity

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `site/**`
- `app/family/packs/**` for starter-shape reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- unrelated country pages or broad website strategy surfaces outside the Vietnam country-route conversion seam
- manual edits to generated preview JSON when source or exporter truth should drive the fix instead

## Source-of-truth notes
- Start from the already-approved 4-of-7 Vietnam hub subset and the current website honesty posture from `T-091` and `T-102`.
- Do not claim live device proof, purchase proof, or full-library website coverage.
- Keep this bounded to the Vietnam country-page conversion seam, not the phrase-page playback seam owned by `T-110`.
- Prefer clearer situation-first conversion guidance over broader marketing churn.

## Required outputs
Create or update these files:
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `.agent/tasks/T-115/logs/viet-conversion-path-audit.md`
- `.agent/tasks/T-115/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-115/reviews/` for each required gate

## Concrete requirement
- keep the current approved Vietnam starter subset intact unless repo evidence clearly supports a different ordering or framing
- make the country-page path clearer about the highest-stress starter situations now surfaced on-web versus the deeper app-only backup path
- leave route-pair parity intact between the flat and routed Vietnam country pages
- record a compact audit showing why the final copy structure is more honest and more useful for a traveler deciding whether to go deeper into the app

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-utility-review.md`
2. `02-conversion-honesty-review.md`
3. `03-situation-coverage-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify required output files exist
- verify route-pair parity still holds between `site/countries/vietnam.html` and `site/countries/vietnam/index.html`
- verify the final copy still matches the current approved Vietnam starter subset and does not overclaim the website surface
- verify no `app/**`, `ops/**`, or unrelated country pages changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the public Vietnam country-page conversion path is materially clearer and more situation-first without overstating website scope
- the final copy preserves the current honest starter versus app-depth boundary
- route-pair parity is preserved
- all 3 mandatory review gates passed with unanimous 4-subagent approval
