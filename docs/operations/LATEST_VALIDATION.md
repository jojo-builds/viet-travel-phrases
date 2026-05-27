# Latest Validation

Last updated: 2026-05-27
Authority lane: latest durable native iOS validation evidence

## Use This Doc For

- the latest durable validation evidence that already exists
- what still needs proof after the native-only cleanup

Do not use this file as the execution checklist. `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `IOS_DEVICE_BUILDING.md` own the current handoff path.

## Current City Pages Hard Reset v2.2 Evidence

Current `feature/city-pages` evidence from the 2026-05-27 hard reset:

- hard-reset receipt: `docs/editorial-exports/viet-city-pages/hard-reset-v2-2-2026-05-27/HARD_RESET_V2_2_FINAL_RECEIPT.md`
- current city/page authority: `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- source authority: `content-draft/viet/city-library/app-detail-v2-2/`
- inventory: `500` in-scope city/place listings, `100` each for Da Nang, Hanoi, Ho Chi Minh City, Hoi An, and Hue
- status: all four hard-reset gates issued `FINAL_PASS`

Fresh command evidence from this pass:

- V2.2 regeneration chain
  - passed: projected `500` entries into compatibility source, regenerated authored listing resources, SQLite fixture, and practice deck
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
  - passed: `500` total, `500` `FINAL_PASS`, `0` revise/fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
  - passed: `0` failures; formula checks reported zero hits for the repaired banned phrases
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `500` city places, `0` release-blocking missing-audio rows
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed under the current non-unique hero gate
- `node scripts/guard-native-only.js`
  - passed
- V2.2 Node test chain and practice deck check/test
  - passed
- Native UI screenshot proof
  - passed: `SpeakLocalNativeUITests/BrowseSearchUITests/testCaptureV22CityPageProductionProof`, `1` test, `0` failures
  - screenshot folder: `docs/design/city-pages/screenshots/v2-2-500-story-production-2026-05-27`
  - fresh artifacts: `20` PNGs, top and scrolled states for `10` proof pages
  - xcresult: `native-ios/artifacts/DerivedData-v2-2-hard-reset-final/Logs/Test/Test-SpeakLocalNative-2026.05.27_16-04-01-+0700.xcresult`
- Physical iPhone Debug build/install/launch from `feature/city-pages`
  - build passed
  - install passed
  - launch passed after the phone became unlockable
  - signing scan stayed clean; personal signing remained local and was not written to repo files

Four-gate status from this pass: Authority / Scope `FINAL_PASS`, Editorial Voice `FINAL_PASS`, Data / Catalog / Audio `FINAL_PASS`, Native Runtime / Release `FINAL_PASS`.

## Current Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-21 non-paywall/non-messages merge sweep:

- validated app/content commit on `main`: `c6c795b3a` (`Reconcile merged city detail phrase rows`)
- merged lanes: `feature/admin-photo-backdrop-polish`, `feature/city-pages`, `feature/practice-area`, `feature/homepage-design`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`, and old `integration/*` worktrees
- merge reconciliation preserved Ba Na Hills journey utility rows, Dragon Bridge map/stop rows, city generated resources, and the homepage playback dock fit checkpoint

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `19` scenarios, `1747` clusters, `1765` phrases, `1758` pages, `0` release-blocking missing-audio rows, `8325` relations
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - passed: `150` strong Tier 1 families, `0` failing rows
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- XcodeBuildMCP simulator regression test
  - passed: `SpeakLocalNativeTests/AppChromeTests/testEntityDetailPagesHideGeneratedPlaceTemplateRows`
- XcodeBuildMCP simulator focused tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `189` tests, `0` failures
- XcodeBuildMCP simulator build/install/launch from `main`
  - passed on booted `iPhone 17 Pro` simulator

No physical iPhone build was run in this pass because the request only asked to merge lanes to `main`.

## Current Main Thermal Bug Hunt Evidence

Current `main` evidence from the 2026-05-21 native thermal bug hunt:

- validated app-code commit installed on Jojo's iPhone: `e8293cd92` (`Merge thermal bug hunt fixes`)
- merged lane: `feature/thermal-bug-hunt-20260521`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`
- thermal-risk fixes landed for cached SQLite canonical page lookups, direct local-state canonical membership checks, non-canceling backdrop image preheat reservation, one-shot Search return-focus restore tasks, and coalesced Practice Match snapshot loads

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- XcodeBuildMCP simulator focused and regression tests
  - passed: `14` tests, `0` failures
  - covered new thermal-regression tests plus `LocalUserIntentStoreTests` and SQLite canonical lookup regressions
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous City Copy Lane Evidence

Fresh evidence from the 2026-05-18 city-place reason-to-go copy pass on `feature/city-pages`:

- `node native-ios/scripts/build-viet-city-copy-review-report.js`
  - passed: `500` approved city noun/place pages, `0` fix-now, `0` hard-block, `0` follow-up, `100/100` approved in each of Ho Chi Minh City, Hanoi, Da Nang, Hoi An, and Hue
- `node native-ios/scripts/audit-viet-city-audience-fit.js`
  - passed: `5` city hubs plus `All Vietnam`, `500` city noun/place pages
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3129` source phrases, `3121` canonical pages, `20248` relations, `0` release-blocking missing-audio rows, `5` cities, `500` city places, `807` city phrase tags, `0` banned file matches
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `8267` items, `18` scenarios, `8` question types
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `git diff --check`
  - passed

Scope note: this was a copy/content/resource pass. No simulator or physical iPhone build was run because no Swift app behavior changed.

## Previous Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-20 homepage follow-up merge sweep:

- validated app-code commit installed on Jojo's iPhone: `5baa2d2c` (`Merge homepage-design`)
- merged lanes: `feature/homepage-design`
- direct `main` app-code checkpoint included: `6325088b` (`Throttle home backdrop work`)
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages, `706` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `164` tests, `0` failures
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-20 non-paywall, non-message-section merge sweep:

- validated app-code commit prepared for Jojo's iPhone: `b1577b01` (`Merge homepage-design`)
- merged lanes: `feature/browse-page`, `feature/city-pages`, `feature/homepage-design`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- clean non-paywall, non-message feature lanes were eligible for sync after the sweep

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages, `706` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `163` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Current `main` evidence from the late 2026-05-19 non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `a3619e55` (`Merge practice-area`)
- merged lanes: `feature/city-pages`, `feature/menu-section`, `feature/browse-page`, `feature/glass-static-area`, `feature/practice-area`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes after the sweep

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages, `706` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `158` tests, `0` failures
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-19 follow-up non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `7091d8fe` (`Merge menu-section`)
- merged lanes: `feature/city-pages`, `feature/practice-area`, `feature/browse-page`, `feature/homepage-design`, `feature/menu-section`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes after the sweep

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `8267` items, `18` scenarios, `8` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `157` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Older Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-19 non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `c1902f28` (`Align hero asset validation with category backdrops`)
- merged lanes: `feature/browse-page`, `feature/city-pages`, `feature/homepage-design`, `feature/menu-section`, `feature/practice-area`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes back to `c1902f28`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `8267` items, `18` scenarios, `8` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `155` tests, `0` failures
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Earlier Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-18 non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `705eb21f` (`Preserve generated city editorial phrase rows`)
- merged lanes: `feature/browse-page`, `feature/city-pages`, `feature/practice-area`, `feature/search-page`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes back to `705eb21f`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js --require-unique-city-place-assets`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3129` source phrases, `3121` canonical pages, `21648` relations, `0` release-blocking missing-audio rows, `5` cities, `500` city places, `807` city phrase tags, `0` banned file matches
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' test -only-testing:SpeakLocalNativeTests/AppChromeTests/testEntityDetailPagesHideGeneratedPlaceTemplateRows -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `18` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed on bounded retry after an initial `devicectl` install hang
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

Known validation caveat from this pass:

- A broad pre-fix selected UI run failed in `BrowseSearchUITests` on photo-backdrop city hub proof/test-expectation cases and older menu-scroll assertions. `PracticeUITests` passed in that same run. The fixed AppChrome regression was rerun and passed afterward.

## Earliest Main Merge Sweep Evidence

Current `main` evidence from the non-paywall, non-Messages merge sweep:

- validated app-code commit: `067ad01d` (`Align city browse tests with noun-first tours`)
- merged lane: `feature/browse-page`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes back to `067ad01d`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3129` source phrases, `3121` canonical pages, `22923` relations, `0` release-blocking missing-audio rows, `5` cities, `500` city places, `807` city phrase tags, `0` banned file matches
- `node native-ios/scripts/sync-viet-audio.js`
  - passed: validated `4353` native audio manifest entries in `native-ios/Resources/Audio`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - still fails on inherited asset debt: `HeroVietnameseFoodMenu` is `864 x 1821`, expected `853 x 1844`
  - the asset blob matches the pre-merge `main` baseline, so this is not a merge regression
  - the new strict unique city-place hero asset gate is optional behind `--require-unique-city-place-assets`
- XcodeBuildMCP simulator build, `SpeakLocalNative`, Debug, iOS 26.5 simulator
  - passed with `CODE_SIGNING_ALLOWED=NO`
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests`
  - passed: `122` tests, `0` failures
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` plus `SpeakLocalNativeTests/PracticeScenarioModeTests`
  - passed: `68` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Native-Only Cleanup Evidence

This cleanup records the repo direction that `native-ios/` is the only active app product surface.

Validated or prepared in this pass:

- the legacy Expo/React Native `app/` tree was removed from active repo truth
- Codex run actions were redirected to native Xcode build/test/doctor commands
- native audio validation was redirected to `native-ios/Resources/Audio` and `native-ios/Resources/viet-audio-manifest.json`
- active operational docs were rewritten to stop directing workers to Windows, Expo, React Native, Metro, EAS, or `app/`
- `scripts/guard-native-only.js` was added as a structural guardrail

Fresh command evidence from this pass:

- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `python3 scripts/check-family-consistency.py --repo-root "$PWD"`
  - passed: native family consistency check
- `node native-ios/scripts/sync-viet-audio.js`
  - passed: validated `3910` native audio manifest entries in `native-ios/Resources/Audio`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3078` source phrases, `3070` canonical pages, `20413` relations, `0` release-blocking missing-audio rows, `0` banned file matches
- `git diff --check`
  - passed
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' build CODE_SIGNING_ALLOWED=NO`
  - passed on Xcode `26.5` / iOS Simulator SDK `26.5`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=45430432-6E67-495B-8A1F-A0086D721315' test -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests CODE_SIGNING_ALLOWED=NO`
  - passed: `158` tests, `0` failures

Known pre-existing test debt:

- `PhrasePageFixtureTests/testAuthoredAudioAuditOnlyHasPlannedCityMissingAudio` fails on current `main` before this cleanup. The failure is the legacy fixture/resource path, not a new native-only cleanup regression.
- Broader `PhrasePageFixtureTests` also still contains tests that explicitly disable the default SQLite runtime. That suite should be retired or rewritten as a native SQLite/content-fixture suite in a dedicated follow-up.

## Last Known Native App Truth

- Active app root: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Bundle ID: `app.speaklocal.vietnam.native`
- Product ID: `app.speaklocal.vietnam.subscription.monthly`
- Current language pack under active development: Viet
- Tagalog remains a future native language-pack candidate unless Jojo explicitly reactivates that lane.

## Remaining Proof Needed

- Fresh StoreKit purchase/restore/relaunch proof when the native paywall branch is ready.
- Fresh screenshots for any native UI work that changes visible app behavior.

## Historical Evidence Boundary

Older validation snapshots may mention Windows paths, Expo, EAS, React Native, or an `app/` folder. Those records are archive context only. They do not define the current app build path.
