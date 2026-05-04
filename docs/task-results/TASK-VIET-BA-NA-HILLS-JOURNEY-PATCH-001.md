# TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001 Result

Status: complete

Commit: recorded in final response after commit

## Canonical ID Check

- Runtime SQLite/app canonical page ID: `viet-phrase-city-danang-place-ba-na-hills`
- Authored listing resource compatibility page ID: `viet-family-city-danang-place-ba-na-hills`
- Source phrase/page ID: `city-danang-place-ba-na-hills`
- Vietnamese title preserved: `Bà Nà Hills`
- English title preserved: `Ba Na Hills`
- Duplicate Bà Nà canonical pages: `0`

The task card/staging ID matched the runtime SQLite/app canonical ID. The authored JSON resource still uses the `viet-family-*` compatibility ID for the same source phrase. The patch preserves both existing IDs and does not create another Bà Nà Hills page.

## What Changed

- Added a task-owned patch contract and Jojo approval overlay under `docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/`.
- Imported only `BNH-001` through the source-owned editorial path.
- Replaced the generated Bà Nà sections with the approved journey structure:
  - `at-glance`
  - `quick-say`
  - `journey-flow`
  - `key-phrases`
  - `breakdown` titled `Name guide`
  - `good-to-know`
  - `explore-next`
- Added `heroImageName: "HeroBaNaHills"` through source, generated listing JSON, SQLite, Swift models, and `PhraseListingView`.
- Added `HeroBaNaHills.imageset` from a production-quality Bà Nà Hills/Golden Bridge photo and recorded attribution.
- Added a dedicated Bà Nà journey validator and screenshot proof UI test.
- Updated SQLite/report validators so only this approved Bà Nà journey page can use `journey-flow` in the role normally filled by `when-to-use`.

## Page Proof

Final section order:

`at-glance | quick-say | journey-flow | key-phrases | breakdown | good-to-know | explore-next`

Required copy present:

- At a glance: `Treat Bà Nà Hills as a day-trip flow, not just a place name. The useful moments are pickup, tickets, cable car, photos, food or drinks, and the return ride.`
- Quick say: `Use this at the ticket counter or when asking staff for help.`
- Good to know: `Ticket rules, hours, and pickup details can change. Keep your ticket or booking screen visible, and confirm where your return ride will meet you.`
- Explore next: `Practice the next phrases for getting there, finding the cable car, asking for photos, buying food or drinks, and getting back.`

Journey flow rows:

- `city-danang-go-ba-na-hills` - `Đi Bà Nà Hills`
- `ves-two-tickets-ba-na-hills` - `Dạ, cho tôi hai vé lên Bà Nà Hills.`
- `ves-where-cable-car` - `Cáp treo ở đâu?`
- `ves-take-photo-for-me` - `Bạn chụp giúp tôi được không?`
- `store-1` - `Cho tôi chai nước`
- `ves-call-taxi-for-me` - `Gọi giúp tôi taxi được không?`

Key phrase rows:

- `city-danang-go-ba-na-hills`
- `ves-two-tickets-ba-na-hills`
- `ves-where-cable-car`
- `ves-take-photo-for-me`
- `ves-call-taxi-for-me`

Name guide:

- `Bà Nà` -> `name recognition`
- `Hills` -> `English word in the attraction name`
- `Bà Nà Hills` -> `Ba Na Hills`

## Store-1 Review

`store-1` was reviewed and kept for Food/drinks. It renders cleanly as `Cho tôi chai nước` / `A bottle of water please`, has bundled audio key `store-1`, and is a practical beginner row for the Bà Nà journey flow.

## Hero Image Decision

`HeroBaNaHills` is approved for this patch. It is a real Bà Nà Hills/Golden Bridge image, visually consistent with the existing tall masthead treatment, and it compiled into the asset catalog during the simulator build.

Attribution: `docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/hero-image-attribution.md`

## Screenshots

- Top hero: `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-top-hero.png`
- Journey flow: `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-journey-key-phrases.png`
- Key phrases and Name guide: `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-name-guide.png`
- Good to know and Explore next: `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-good-to-know-explore-next.png`

## Validation

Passed:

- `node native-ios/scripts/import-viet-editorial-pilot.js --patch docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/SpeakLocal_Ba_Na_Hills_Journey_Patch_v2.json --approval docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/approved-imports-TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.json --dry-run`
- `node native-ios/scripts/import-viet-editorial-pilot.js --patch docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/SpeakLocal_Ba_Na_Hills_Journey_Patch_v2.json --approval docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/approved-imports-TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.json --apply`
- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node native-ios/scripts/validate-viet-ba-na-hills-journey-patch.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-editorial-ready-import.js`
- `node native-ios/scripts/validate-viet-editorial-model-support.js`
- `node native-ios/scripts/validate-viet-editorial-pilot-import.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' build`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeUITests/BaNaHillsJourneyProofUITests/testCaptureBaNaHillsJourneyProof test`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests test`
- `git diff --check`

Counts after regeneration:

- Canonical pages: `3070`
- Source phrases: `3078`
- Missing audio audit rows: `2126`
- Release-blocking missing audio rows: `0`

Audio handling:

- No audio files were generated.
- `native-ios/Resources/Audio/**` unchanged.
- Missing Bà Nà support audio remains planned/queued and disabled with the missing-audio icon.

Meta/slash scan:

- Bà Nà generated page banned/meta/slash matches: `0`
- Relationship section on Bà Nà page: absent

## Reviewer Gate

Approval: APPROVE

The patch is traveler-useful, page-kind-appropriate, source-owned, canonical-safe, and visually proved in simulator. The page now teaches Bà Nà Hills as a day-trip flow instead of a generic place card, with no fake proper-name breakdown and no duplicate canonical page.

## Final Status

Ready to commit.
