# Handwritten Recovery Batch 048 - 2026-06-03

Status: PASS for authored copy import, native resource generation, validator guardrails, and Simulator render proof. Physical iPhone build passed, but install did not complete because the device connection was interrupted twice.

Progress after this batch: 239 / 520 recovered. Remaining: 281.

## Scope

- `viet-family-city-hue-place-kodo-cafe` - KODO Cafe / KODO Cafe
- `viet-family-city-hue-place-lagoon-seafood-boat` - Thuyền hải sản phá Tam Giang / Lagoon seafood boat
- `viet-family-city-hue-place-lang-thang-coffee` - Lang Thang Coffee / Lang Thang Coffee
- `viet-family-city-hue-place-lap-an-lagoon` - Đầm Lập An / Lap An Lagoon
- `viet-family-city-hue-place-le-ba-dang-art-center` - Trung tâm Nghệ thuật Lê Bá Đảng / Le Ba Dang Art Center

## Authored Fixes

- KODO Cafe now explains the concrete value of the stop: a green Kim Long cafe with plants, coffee, shade, and indoor/outdoor seating between outdoor sightseeing blocks.
- Lagoon seafood boat now frames the experience as a Tam Giang lagoon meal tied to working water, boats, rafts, seafood farms, pier timing, pricing, and portions.
- Lang Thang Coffee now reads as a Kim Long neighborhood cafe tied to garden houses, pagoda routes, quieter lanes, and a west-side Hue route.
- Lap An Lagoon now explains the Hue-to-Lang Co road context: low water, oyster farms, sandbars, boats, and the Bach Ma mountain backdrop.
- Le Ba Dang Art Center now explains the artist context accurately: Lê Bá Đảng was born in Quảng Trị near Huế, worked in France, and the center is a compact modern-art visit with paintings, sculpture, and mixed-media work.
- User-flagged abstract art copy was removed. The bad section `Give A Few Works Time` / `Pick a few works and notice materials, shapes, and space` was replaced with concrete traveler value:
  - `Built Around One Artist`
  - `A Different Hue Stop`
  - `A Compact Gallery Visit`
  - `Photo Rules Can Be Easy To Miss`

## Review-Gate Update

Updated `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md` with a new 2026-06-03 counterexample and Five Whys.

Root cause recorded there: the weak section was optimized for sounding editorial instead of translating the place into concrete, first-time-traveler value. The fix is not shorter copy; the fix is more specific copy in natural American English.

New gate lesson: reject abstract appreciation instructions such as `notice materials, shapes, and space` unless the copy first explains what the place is, why this specific place matters, and what a U.S.-based first-time visitor can expect to see or do.

## Sub-Agent QA

- Source-risk QA: `019e8bc9-6fe5-72c3-95c4-baa4d95d3b5a`
  - KODO: softened to a green/garden-style Kim Long cafe based on supported evidence.
  - Lagoon seafood boat: passed as grounded in Tam Giang working-water context.
  - Lang Thang: tied more clearly to Kim Long, garden houses, pagoda routes, and quieter lanes.
  - Lap An Lagoon: passed as grounded in road, tide, oyster farms, and mountain backdrop.
  - Le Ba Dang: corrected `Hue-born` risk to Quảng Trị-born near Huế, with France-career context.
- U.S.-traveler readability QA: `019e8bc9-d775-74b0-aca5-d2bb0990f73a`
  - Flagged language that sounded like labels or app copy.
  - KODO and Lang Thang were revised away from repetitive `pause/reset` phrasing.
  - Le Ba Dang received an additional user-driven revise after Simulator review.

## Validation

Command chain:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production &&
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js &&
node native-ios/scripts/validate-viet-city-copy.js &&
node native-ios/scripts/validate-viet-city-library.js &&
node native-ios/scripts/validate-viet-sqlite-fixture.js &&
node native-ios/scripts/audit-viet-listing-production-qa.js &&
git diff --check
```

Result: PASS.

Key results:

- v2.2 projection: 520 entries
- strict production validation: 520 pass, 0 revise, 0 fail
- voice audit: 0 failures
- city production copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes
- city library validation: 826 pages
- SQLite validation: ok
- production QA: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator profile: `city-listings-production-ready`

Rendered page left open on Simulator:

- `viet-family-city-hue-place-le-ba-dang-art-center`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-048-screenshots/001-hue-le-ba-dang-art-center-top.jpg`

Simulator build/run result: PASS.

## Phone Build

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS, twice.
- Install: FAIL, twice.
- Launch: not attempted because install failed.

Failure summary: device install failed with `com.apple.dt.CoreDeviceError error 3002` / `IXRemoteErrorDomain error 6`, `Connection interrupted`. This looks like a device-link/install connection failure, not a compile failure.

Signing hygiene:

- Repo signing scan: PASS.
- No repo-visible personal signing was detected in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Carry Forward

Future batch review must actively reject:

- abstract art/museum phrases like `notice materials, shapes, and space`;
- headings that require the reader to accept the writer's framing before understanding the value;
- section bodies that tell the visitor how to appreciate something instead of explaining what the place is and why it matters.

The user wants value-rich copy, not stripped-down copy. The correction is to add concrete context in natural American English, not to shorten pages until they pass validators.
