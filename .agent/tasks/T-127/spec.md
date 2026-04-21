# Task Spec: T-127

## Title
Desktop Codex automation pilot, Viet country-route trust-panel parity and app-depth honesty packet

## Objective
Tighten the live Vietnam country-route conversion surface so the trust cues, starter-scope explanation, and app-depth handoff tell one cleaner story across both country-page routes without reopening broader website strategy or export plumbing.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `.agent/tasks/T-115/result.md`
- `.agent/tasks/T-110/result.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `content-draft/viet/website-preview.json`

## Task type
- website conversion hardening
- country-route trust parity
- starter-versus-app boundary tightening

## Scope
### Allowed write scopes
- `.agent/tasks/T-127/**`
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- bounded related include or data surfaces under `site/**` only if required to keep those two routes in parity and truthful

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `site/**`
- `app/family/packs/**` as read-only starter-shape reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- unrelated country pages or broad website strategy surfaces outside the Vietnam country-route trust/conversion seam
- manual edits to generated preview JSON when source or exporter truth should drive the fix instead

## Source-of-truth notes
- `T-115` already tightened the Vietnam country-page conversion path around high-stress starter situations.
- `T-110` hardened the phrase-page playback seam and the honest starter-export boundary.
- The remaining gap is route-level parity and trust framing: both Vietnam country-page routes should make the same honest promise about what the site gives now, what the app gives next, and what remains outside current live proof.
- Keep this task bounded to public country-route surfaces. Do not reopen export-manifest logic, app-shell code, or device-proof ops docs.

## Required outputs
Create or update these files:
- `site/countries/vietnam.html`
- `site/countries/vietnam/index.html`
- `.agent/tasks/T-127/logs/viet-country-trust-parity-audit.md`
- `.agent/tasks/T-127/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-127/reviews/` for each required gate

## Concrete requirement
- make both Vietnam country-page routes agree on the same starter-safe trust cues, including what is available on-web now, what requires the app for deeper coverage, and what still should not be implied as device-proven or full-library-complete
- keep the current approved starter subset and situation ordering honest unless bounded repo truth clearly supports a better wording or grouping
- tighten the handoff language around when a traveler should stay on-web versus go deeper into the app, especially for higher-stress fallback situations
- leave one compact audit explaining the final trust-panel/app-depth contract and any deliberate route-specific differences that remain
- keep the work meaningful and synthesis-heavy, not a thin wording polish pass

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-traveler-trust-review.md`
2. `02-conversion-honesty-review.md`
3. `03-route-parity-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify required output files exist
- verify route-pair parity still holds between `site/countries/vietnam.html` and `site/countries/vietnam/index.html`
- verify the final copy stays honest about current on-web starter scope versus deeper app-only coverage
- verify no `app/**`, `ops/**`, `docs/operations/**`, or unrelated country pages changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Vietnam country-route trust story is materially clearer and more internally consistent
- both route variants make the same honest promise about starter-safe web utility versus deeper app value
- the final copy does not imply full-library coverage or fresh device proof
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no export-plumbing, app-surface, or ops-doc drift was introduced
