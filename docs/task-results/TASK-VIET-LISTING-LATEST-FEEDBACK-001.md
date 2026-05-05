# TASK-VIET-LISTING-LATEST-FEEDBACK-001

## Summary

Folded the latest screenshot review into the listing-page generator, validators, native chrome, and durable listing-page skill.

This pass fixed systemic issues behind:

- `Có tỏi không?` rendering `tỏi` as `tôi`.
- Generic `Practice nearby` labels.
- Ingredient/taxi/emergency/may-hear pages pulling unrelated rows.
- Emergency hub weak starter priority.
- Simple phrase pages repeating the hero in duplicate `Meaning` / `Quick say` sections.
- Sticky speed control visually covering readable rows.
- Bottom chrome content clearance.
- A first batch of high-value Da Nang hero-image fallbacks.

## Skill Update

Updated the durable listing-page skill at:

`/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`

Added guardrails for:

- Diacritic-sensitive breakdown pairs: `tỏi/tôi`, `bàn/bạn`, `bơ/bỏ`, `có/cô`, `chưa/chùa`.
- Banning generic `Practice nearby`.
- Ingredient-only row routing.
- Taxi/ride-specific row routing.
- Emergency hub priority.
- `traveler_may_hear` page routing.
- Sticky top speed control and bottom nav overlap as QA failures.

## Content And Routing Changes

- Added exact-gloss handling so `tỏi` resolves as `garlic`, not `I / me`.
- Added intent-specific labels:
  - `Other ingredients`
  - `More ingredient questions`
  - `Getting a ride`
  - `More ride phrases`
  - `Common follow-ups`
- Routed ingredient pages to food-composition rows only.
- Routed taxi help pages to ride/address/pickup/drop-off rows only.
- Routed `Bác sĩ đang đến` as a may-hear medical/help page.
- Updated `Bác sĩ đang đến` note to: `Stay nearby and keep your phone visible. They may ask where you are or what happened.`
- Updated Emergency browse priority to start with urgent help/doctor/hospital/police rows.
- Updated Emergency practice copy to `Practice asking for help calmly.`
- Suppressed duplicate hero-repeat sections on simple phrase pages while keeping useful follow-ups.

## Native UI Changes

- Added more bottom content clearance across listing/browse surfaces.
- Added a pinned top admin backdrop behind the global speed control so row text does not remain readable underneath the control.
- Kept speed control global and visible once the main player scrolls offscreen.

## Hero Image Batch

Added first-batch app-owned generated hero assets at `853 x 1844`:

- `HeroMarbleMountains`
- `HeroLinhUngPagoda`
- `HeroMyKheBeach`
- `HeroHanMarket`
- `HeroNguyenVanLinhStreet`

Wired them through `content-draft/viet/city-library/v1.json`, regenerated listing JSON, and regenerated SQLite.

Contact sheet:

`native-ios/artifacts/TASK-VIET-LISTING-LATEST-FEEDBACK-001/hero-assets-contact-sheet.png`

## Simulator Proof

Proof directory:

`native-ios/artifacts/TASK-VIET-LISTING-LATEST-FEEDBACK-001/`

Captured top/middle proof for:

- `Có tỏi không?`
- `Anh giúp tôi gọi taxi được không?`
- `Bác sĩ đang đến`
- `Emergency`
- `Shopping`
- `Da Nang`
- `All Vietnam`
- `Ngũ Hành Sơn`
- `Chùa Linh Ứng`
- `Biển Mỹ Khê`
- `Chợ Hàn`
- `Đường Nguyễn Văn Linh`

Focused UI test:

```sh
SPEAKLOCAL_LISTING_LATEST_FEEDBACK_PROOF_DIR=/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-LATEST-FEEDBACK-001 \
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj \
  -scheme SpeakLocalNative \
  -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' \
  -only-testing:SpeakLocalNativeUITests/ListingLatestFeedbackProofUITests
```

Result: passed, 2 tests, 0 failures.

## Validation

Passed:

```sh
node native-ios/scripts/validate-viet-listing-intent-routing.js
node native-ios/scripts/audit-viet-listing-production-qa.js --check
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-canonical-content.js --check
node native-ios/scripts/audit-viet-page-quality.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node scripts/practice/generate-viet-practice-deck.js --check
node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js
node --test scripts/practice/generate-viet-practice-deck.test.js
git diff --check
```

Production QA audit result:

- `3070` pages scanned.
- `0` blockers.
- `0` majors.
- `500` missing-audio priority rows.
- `2126` planned missing-audio audit rows in SQLite validation.

## Remaining Follow-Ups

- Not all hero images are done. This pass added a first batch and kept the hero report current.
- Missing audio remains a production-content queue item, especially for high-value names and scenario primary phrases.
- The current generated hero art is app-owned and shippable as a safer fallback, but several pages still deserve richer bespoke art.
- This does not claim all 3,000+ pages are production-perfect; it closes the latest screenshot bugs and strengthens the system so those classes of issues are caught.

