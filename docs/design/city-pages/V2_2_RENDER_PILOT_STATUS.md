# SpeakLocal v2.2 Render Pilot Status

Status source for the five v2.2 render pilot pages and their native productionization pass.

## Productionized 2026-05-24

The five redo pages have been promoted through the native city-library pipeline and passed the final review gate.

Production status: `production_ready_native_passed`

Canonical example status: `not_promoted_to_canonical_31_examples`

Native source:

- `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc}.json`

Regenerated runtime:

- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`

Native screenshot proof:

- `screenshots/v2-2-native-production-2026-05-24/`

Final review gate:

- `V2_2_PRODUCTION_REVIEW_GATE_2026-05-24.md`

The HTML redo JSON remains audit evidence only:

- `V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`

## Redo Completed 2026-05-22

The five entries that were previously marked `redo_required` received a fresh v2.2 appDetail source-object pass and rendered screenshot QA.

Superseded by the 2026-05-24 native productionization pass above.

The 2026-05-22 follow-up card-subtitle patch is also folded in: Mentioned Here and Related Places candidates now use `displaySubtitle` for visible card subtitles and keep `reason` as internal QA/source rationale only.

The 2026-05-24 voice review pass is also folded in. A thin screenshot review gate now separates mechanical contract status from SpeakLocal voice status. All five pages pass the render contract and the second-cycle voice gate.

Source objects:

- `V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`

Render preview:

- `render-pilot-redo/index.html`

Screenshot audit folder:

- `screenshots/v2-2-redo-2026-05-22/`
- `screenshots/v2-2-redo-voice-2026-05-24/`

Manifest:

- `screenshots/v2-2-redo-2026-05-22/manifest.json`
- `screenshots/v2-2-redo-voice-2026-05-24/manifest.json`

Review gate:

- `V2_2_SCREENSHOT_REVIEW_GATE.md`

## Page Status

### Da Nang International Terminal

Status: `production_ready_native_passed`

Production status: `production_ready_native_passed`

Canonical example status: `not_promoted_to_canonical_31_examples`

Final review: `PASS`

Production review:

- final gate PASS on 2026-05-24
- unresolved Hội An candidate remains internal and does not render

### Dong Dinh Museum

Status: `production_ready_native_passed`

Production status: `production_ready_native_passed`

Canonical example status: `not_promoted_to_canonical_31_examples`

Final review: `PASS`

Production review:

- final gate PASS on 2026-05-24
- unstable details such as ticket/photo rules are not asserted in visible copy

### Pasteur Street

Status: `production_ready_native_passed`

Production status: `production_ready_native_passed`

Canonical example status: `not_promoted_to_canonical_31_examples`

Final review: `PASS`

Production review:

- final gate PASS on 2026-05-24
- individual cafe / office context remains intentionally unverified
- Pasteur Institute remains internal until a catalog item exists
- useful phrase row now uses `repair-show-me` for primary bundled-audio compatibility

### Loading T Cafe

Status: `production_ready_native_passed`

Production status: `production_ready_native_passed`

Canonical example status: `not_promoted_to_canonical_31_examples`

Final review: `PASS`

Production review:

- final gate PASS on 2026-05-24
- exact hours/payment rules are not asserted in visible copy

### Lotte Mart Da Nang

Status: `production_ready_native_passed`

Production status: `production_ready_native_passed`

Canonical example status: `not_promoted_to_canonical_31_examples`

Final review: `PASS`

Production review:

- final gate PASS on 2026-05-24
- production fix removed visible food-court claims; Lotte now owns the stable indoor restock/reset job

## Render QA Result

All five pages passed the preview render checks:

- phrase cards render immediately after intro
- no duplicate body text
- no Useful Phrases prose block
- phrase rows wrap without overflow
- Mentioned Here cards render for status `render`
- Related Places cards render for status `render`
- Mentioned Here / Related Places cards render `displaySubtitle`, not internal `reason`
- 2026-05-24 command-language drift checks are clear
- hero images load
- internal catalog relationship labels are not visible in app UI
- bottom chrome does not overlap the last content module

Screenshot review gate result:

- first review cycle: four pass, Pasteur revise
- focused fixes applied to Pasteur, Da Nang International Terminal, and Lotte Mart Da Nang
- second review cycle: all focused pages pass

This status file now records both the older v2.2 render-pilot pass and the 2026-05-24 native runtime productionization pass.
