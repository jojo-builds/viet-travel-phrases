# Viet City Hook Audit - 2026-05-19

## Scope

This pass reviewed the 500 approved city noun/place pages for pages that had structurally valid copy but did not clearly answer: what is this place, why is it in the app, and why would someone want to go?

The audit compared current city-page copy against the original city-production noun rows and looked for high-confidence cases where the source hook was stronger than the visible page. The main failure pattern was generic copy such as cafe culture, landmark scene, local pride, or soft pauses replacing the concrete reason the place exists.

## Pages Fixed

The pass intentionally kept scope narrow and changed only high-confidence misses:

- `city-hcmc-place-cafe-apartment-nguyen-hue`: clarifies that this is an old apartment building turned into a vertical cafe cluster, not one cafe.
- `city-hcmc-place-42-nguyen-hue-apartment`: distinguishes the physical address/building from the broader Cafe Apartment experience.
- `city-danang-place-dragon-bridge`: restores the dragon-shaped Han River bridge hook.
- `city-danang-place-golden-bridge`: restores the Ba Na Hills bridge-held-by-giant-hands hook.
- `city-danang-place-hai-van-pass`: restores the coastal mountain-road route hook.
- `city-danang-place-lady-buddha`: restores the Linh Ung Pagoda / Son Tra statue hook.
- `city-danang-place-marble-mountains`: restores the caves, pagodas, viewpoints, and stone-carving hook.
- `city-danang-place-nam-o-fish-sauce-village`: restores the coastal fish-sauce craft-village hook.
- `city-hanoi-place-the-note-coffee`: restores the sticky-note-covered cafe hook.
- `city-hoian-place-faifo-coffee`: restores the rooftop old-town view hook.
- `city-hoian-place-reach-out-tea-house`: restores the quiet social-enterprise teahouse hook.

## Editorial Decision

Do not bulk-rewrite city pages just because they share a structure. Keep good copy intact. Fix only entries where a reader could reasonably ask "what exactly is this?" after reading the page.

The source-of-truth edits are in `content-draft/viet/city-library/handwritten-copy/*.json` and were projected into `content-draft/viet/city-library/v1.json`, `native-ios/Resources/viet-authored-listing-pages.json`, `native-ios/Resources/viet-phrase-catalog.json`, and the Viet SQLite fixture.

## Validation

- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/audit-viet-city-audience-fit.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`

