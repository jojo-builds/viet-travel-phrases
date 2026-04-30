# Vietnam City Phrase Library V1 Result

Status: complete and review-approved.

Date: 2026-04-30

Commit: reported in the closing thread after commit creation.

## Scope Delivered

- Added a durable authored source lane at `content-draft/viet/city-library/v1.json`.
- Added 5 V1 cities: Saigon / HCMC, Hanoi, Da Nang, Hoi An, and Hue.
- Added 125 approved canonical city pages: 25 pages per city.
- Added 57 sourced city/place/food anchors, including landmark-only and dish/place-name practice records.
- Added 6 city subcategories:
  - `arrivals-routes`
  - `landmarks-attractions`
  - `neighborhoods-streets`
  - `food-coffee`
  - `shopping-markets`
  - `practical-help-near-places`
- Difficulty mix:
  - Beginner: 90 pages
  - Intermediate: 30 pages
  - Advanced: 5 pages
- Final generated catalog counts:
  - Source phrases: 1,071
  - Base phrase count: 946
  - City phrase count: 125
  - Families: 1,052
  - SQLite canonical pages: 1,063
  - Scenarios: 19

## App And Resource Changes

- City library pages are generated into:
  - `native-ios/Resources/viet-phrase-catalog.json`
  - `native-ios/Resources/viet-authored-listing-pages.json`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- The native app build no longer bundles the legacy JSON fallback resources:
  - `viet-phrase-catalog.json`
  - `viet-authored-listing-pages.json`
  - `viet-authored-audio-audit.json`
- The app runtime is SQLite-first/SQLite-only for the Viet phrase graph. The JSON files remain repo-local generator intermediates for building the SQLite pack and audits, but are excluded from the app bundle.
- The native project is configured for automatic device signing with team `F7MH7N9445` so Xcode and `xcodebuild` can build the phone target without hand-editing the generated project.
- SQLite now includes city tables and tags for city, subcategory, place, and difficulty filtering.
- Practice Core sample deck now includes city-guides items and a `city-first-trip` flow.
- Missing city audio is planned and visible as unavailable. No audio files were generated.
- Missing audio queue:
  - Path: `docs/audio-queues/viet-city-library-v1-missing-audio.csv`
  - Data rows: 125
  - Release-blocking missing audio: 0
- Native audio UI now shows disabled `speaker.slash.fill` for planned missing audio with the accessibility label `Audio not available yet`.

## Source Provenance

Primary factual sources used in the source lane:

- Vietnam Tourism Cities: https://www.vietnam.travel/index.php/things-to-do/cities
- Vietnam Tourism Places to go: https://vietnam.travel/place-to-go
- Vietnam Tourism Ho Chi Minh City: https://vietnam.travel/places-to-go/southern-vietnam/ho-chi-minh-city
- Vietnam Tourism Hanoi: https://vietnam.travel/places-to-go/northern-vietnam/ha-noi
- Vietnam Tourism Da Nang: https://vietnam.travel/node/1366
- Vietnam Tourism Hoi An: https://vietnam.travel/places-to-go/central-vietnam/hoi-an
- Vietnam Tourism Hue: https://vietnam.travel/places-to-go/central-vietnam/hue
- Michelin Guide Vietnam: https://guide.michelin.com/vn/en
- Cafe Giang official site: https://cafegiang.vn/
- Quang Nam Tourism Morning Glory: https://quangnamtourism.com.vn/en/morninggloryoriginalrestaurant
- Hue Tourism Les Jardins: https://khamphahue.com.vn/en-us/Tourism/Useful-Information/Detail/tid/Les-Jardins-de-la-Carambole-Restaurant.html/pid/15121/cid/507
- Vietnam Airlines Dong Ba bun bo reference: https://www.vietnamairlines.com/mm/en/plan-book/travel/travel-guide/best-bun-bo-hue-in-hue

## Validation

Passed:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-viet-full-universe-authoring.js`
- Focused native tests: 25 tests, 0 failures
- `xcodebuild build -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'generic/platform=iOS' CODE_SIGNING_ALLOWED=NO`
- `xcodebuild build -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS,id=00008140-000955D00188801C' -allowProvisioningUpdates -allowProvisioningDeviceRegistration`
- `xcrun devicectl device install app --device 00008140-000955D00188801C .../SpeakLocalNative.app`
- `xcrun devicectl device process launch --device 00008140-000955D00188801C app.speaklocal.vietnam.native --terminate-existing --activate`

SQLite validation proof:

- Cities: 5
- City places: 57
- City phrase tags: 125
- Duplicate canonical normalized Vietnamese pages: 0
- Duplicate visible phrase targets per page: 0
- Duplicate visible phrase text per page: 0
- Planned missing audio rows: 125
- Release-blocking missing audio rows: 0
- Banned/internal wording matches: 0

Bundle proof:

- The iPhoneOS build app contains `LanguagePacks/viet/speaklocal-viet.sqlite` and `LanguagePacks/viet/speaklocal-viet-report.json`.
- The iPhoneOS build app does not contain `viet-phrase-catalog.json`, `viet-authored-listing-pages.json`, or `viet-authored-audio-audit.json`.
- Legacy JSON bundle hit count: 0.
- Built app size: 93M. Bundled SQLite pack size: 20M.
- Physical device detected: `Alex's iPhone 16 Pro Max` (`00008140-000955D00188801C`).
- Physical device build succeeded with Apple development team `F7MH7N9445` and provisioning profile `iOS Team Provisioning Profile: *`.
- Physical device install succeeded for bundle ID `app.speaklocal.vietnam.native`.
- Physical device launch succeeded via `xcrun devicectl device process launch`.

## Simulator Proof

Screenshots captured:

- `docs/task-results/screenshots/viet-city-library-v1/hcmc-go-ben-thanh.jpg`
- `docs/task-results/screenshots/viet-city-library-v1/hanoi-go-hoan-kiem.jpg`
- `docs/task-results/screenshots/viet-city-library-v1/danang-go-my-khe.jpg`
- `docs/task-results/screenshots/viet-city-library-v1/hoian-go-ancient-town.jpg`
- `docs/task-results/screenshots/viet-city-library-v1/hue-go-imperial-city.jpg`
- `docs/task-results/screenshots/viet-city-library-v1/hue-bottom-category-shelf.jpg`

## Review Gate

Reviewer 1, Traveler + factual fit: APPROVE.

- Confirmed final blockers were fixed for `city-hoian-cao-lau` and `city-hue-bun-bo`.
- Confirmed city/dish anchors now match both source records and generated page metadata.
- Confirmed provenance spot checks for Cafe Giang, Morning Glory, Hue Les Jardins, and Dong Ba bun bo.

Reviewer 2, Language + system integrity: APPROVE.

- Confirmed 125 source city pages, 125 authored city pages, and 125 city catalog phrases.
- Confirmed no duplicate city Vietnamese targets, no duplicate city page IDs, and no broken or cross-city authored links.
- Confirmed planned audio queue is deduped and all city audio states are planned.
- Confirmed repeated `At a glance` / `When to use it` copy was eliminated and validator-protected.

## Notes And Next Task

- No `native-ios/Resources/Audio/**` files changed.
- The legacy JSON fallback is no longer shipped in the app bundle. SQLite/default-runtime tests are the native proof surface for phrase graph behavior.
- Recommended next task: build the city-selection onboarding and practice filtering UI using the new city/subcategory/difficulty tags.
