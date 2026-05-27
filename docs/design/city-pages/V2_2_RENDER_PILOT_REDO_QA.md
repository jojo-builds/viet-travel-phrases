# V2.2 Render Pilot Redo QA

Date: 2026-05-22

Voice review update: 2026-05-24

Native production update: 2026-05-24

Current standard: `speaklocal.place.app-detail.v2.2`

## Scope

Redid the five v2.2 render pilot pages that were previously marked `redo_required`:

- Da Nang International Terminal
- Dong Dinh Museum
- Pasteur Street
- Loading T Cafe
- Lotte Mart Da Nang

No city-v1 copy mechanics were used. No bulk generation script was created.

2026-05-24 productionization promoted the five pages into the current native city-library source path and regenerated native runtime resources.

## Artifacts

Source objects:

- `V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`

Native source:

- `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc}.json`

Render preview:

- `render-pilot-redo/index.html`

Full-page screenshot folder:

- `screenshots/v2-2-redo-2026-05-22/`
- `screenshots/v2-2-redo-voice-2026-05-24/`
- `screenshots/v2-2-native-production-2026-05-24/`

Screenshot manifest:

- `screenshots/v2-2-redo-2026-05-22/manifest.json`
- `screenshots/v2-2-redo-voice-2026-05-24/manifest.json`

## Source / Render Contract Patch

Mentioned Here and Related Places candidates now separate visible card copy from internal QA rationale:

- `displaySubtitle`: user-facing card subtitle rendered in the app
- `reason`: internal QA/source rationale, never rendered as visible copy

The preview renderer now uses:

1. `displaySubtitle` when present
2. catalog `summary` when `displaySubtitle` is missing
3. label only when neither subtitle exists

Before:

- `SIM card` rendered `Named in the arrival sequence and supported by a bundled airport SIM phrase.`
- `Chợ Hàn` rendered `Local-market contrast for central texture and bargaining.`

After:

- `SIM card` renders `Get connected before leaving the terminal.`
- `Chợ Hàn` renders `Central market for souvenirs, fabric, food stalls, and bargaining.`

## Validation

Local checks run:

- `jq empty V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`
- per-object schema-shape check against required v2.2 fields
- phrase/audio/catalog check against `native-ios/Resources/viet-phrase-catalog.json` and `native-ios/Resources/viet-audio-manifest.json`
- Playwright render pass against the local preview
- card subtitle leak check against visible `reason` text
- command-language drift check against the phrases called out in the 2026-05-24 review

All useful phrase cards in the five source objects resolve to ready bundled audio.

## Screenshot Review Gate

Added `V2_2_SCREENSHOT_REVIEW_GATE.md` as a thin pass/revise/fail gate for rendered v2.2 pages. The gate keeps mechanical contract checks separate from voice checks.

The 2026-05-24 review folded in Jojo's Lotte Mart feedback:

- traveler-use cue does not mean command language
- headings and first sentences should reveal the role of the place in natural English
- avoid sounding like the app is describing the listing's function
- revise only the failing voice notes instead of rewriting the whole page

Focused copy changes from the voice pass:

- Da Nang International Terminal: `Solve The Arrival Sequence` became `The Arrival Sequence Matters`; `Hội An Needs A Clear Driver` became `Know Which Car Is Yours`.
- Dong Dinh Museum: `Use Sơn Trà For Quiet Culture` became `Quiet Culture On Sơn Trà`.
- Pasteur Street: `Use The Street As A Spine` became `Start With One Doorway`, with doorway, block, traffic, crossing, and entrance details added to reduce abstraction. The production pass later swapped the map-specific repair phrase to `repair-show-me` so the native SQLite primary-audio gate passes.
- Loading T Cafe: kept `Find The Upstairs Pause`, tightened the intro and payment phrase gloss.
- Lotte Mart Da Nang: `Use It For Trip Fixes` became `The Easy Indoor Reset`; sections now frame restocking, indoor regrouping, and Hàn/Lotte contrast from the traveler's day. The production gate later removed visible food-court claims so the page does not depend on unstable venue-service status.

Review cycle result:

| Page | Contract | Voice | Review status |
|---|---|---|---|
| Da Nang International Terminal | pass | pass | `production_ready_native_passed` |
| Dong Dinh Museum | pass | pass | `production_ready_native_passed` |
| Pasteur Street | pass | pass after second-cycle fix | `production_ready_native_passed` |
| Loading T Cafe | pass | pass | `production_ready_native_passed` |
| Lotte Mart Da Nang | pass | pass after voice rewrite | `production_ready_native_passed` |

## Render Checks

Every page passed:

- phrase cards appear immediately after the intro
- no duplicate intro/section body text
- no Useful Phrases prose block
- phrase rows wrap without overflow
- Mentioned Here modules render for candidates with `status: "render"`
- Related Places modules render for candidates with `status: "render"`
- Mentioned Here cards render user-facing subtitles
- Related Places cards render user-facing subtitles
- internal `reason` text is not visible
- command-like review phrases from the failed Lotte/Pasteur pass are not visible
- hero images load
- no internal relation/type labels leak into visible app UI
- bottom chrome does not overlap the last content module
- sticky audio controls do not hide important content

## Previous Strict Scores

| Page | Score | Main cap |
|---|---:|---|
| Da Nang International Terminal | 28/30 | same-week airport pickup / counter freshness |
| Dong Dinh Museum | 28/30 | same-week hours, ticket, photo, access checks |
| Pasteur Street | 28/30 | individual business context intentionally unverified |
| Loading T Cafe | 28/30 | same-week hours, entrance, seating, payment checks |
| Lotte Mart Da Nang | 28/30 | same-week hours, pickup doors, and phrase-naturalness checks |

These older render-pilot caps were superseded by the 2026-05-24 native production review gate for visible copy. Unstable details remain omitted unless directly supported in the app. The later production fix removed Lotte Mart food-court wording from visible copy and native/runtime resources.

## Production Boundary

This render-pilot boundary applies only to the five pages named in this QA file and only to the app state reviewed on 2026-05-24. It must not be generalized to later bulk city-library imports.

All five are marked `production_ready_native_passed`.

They remain `not_promoted_to_canonical_31_examples`; this pass does not add them to the canonical v2.2 example set.

Unresolved catalog candidates left as `check_catalog` remain internal and do not render.

2026-05-26 note: later bulk import work failed rendered phone review on a different page (`city-danang-place-da-nang-museum`) because of copy voice and top-chrome overlap. Future production-ready claims require fresh rendered review, not reuse of this pilot result.
