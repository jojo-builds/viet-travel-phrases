# Latest Validation

Last updated: 2026-07-05 (Asia/Manila local)
Authority lane: latest durable native iOS validation evidence

## Use This Doc For

- the latest durable validation evidence that already exists
- what still needs proof after the native-only cleanup

Do not use this file as the execution checklist. `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `IOS_DEVICE_BUILDING.md` own the current handoff path.

## Current Main Proof

Current `main` app-code payload after the 2026-07-05 three-hour parallel launch-readiness push:

- immediate 2026-07-05 follow-up renamed stale Browse/Practice conversation labels: `Quick conversations` -> `Practice moments`, local hello cards -> `Market greeting` / `Hotel greeting` / `Respectful greeting`, and visible Practice `Messages` labels -> Practice-oriented language
- focused red/green validation passed for `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy` and `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`
- new static visible product-language audit passed: `node native-ios/scripts/audit-visible-product-language.js`
- eight-hour-audit follow-up tightened the visible-language audit for uppercase/case variants, Practice completion wording, and accessibility fallback wording, then renamed nested scenario labels and awkward Browse copy: `MESSAGES` -> `PRACTICE`, `Conversation complete` -> `Practice complete`, `thread` -> `practice run`, `Conversation break` -> `Practice beat`, local greeting scenario titles -> `Market greeting` / `Hotel greeting` / `Respectful greeting`, `Respectful hellos` -> `Respectful greetings`, unknown city fallback `messages` -> `practice`, and trip fallback copy -> `Practical travel moments to practice first.`
- eight-hour visual follow-up fixed the Practice Saved action capsule truncating `Start` into `St...`; fresh current-build simulator proof saved at `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/visual-layout-screenshots/23-practice-hub-start-fixed.jpg`
- eight-hour visual follow-up fixed the `Phở bò` menu detail first-viewport crop so the bowl is visible in the photo backdrop; fresh simulator proof saved at `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/visual-layout-screenshots/24-menu-pho-bo-focal-fixed.jpg`
- focused validation passed for the `Phở bò` crop fix: red/green unit `AppChromeTests/testVietnameseMenuBackdropImageUsesStablePortraitFrame`, then current-build focused rerun `AppChromeTests/testVietnameseMenuBackdropImageUsesStablePortraitFrame` plus `BottomInsetUITests/testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar`, `2` tests, `0` failures
- focused validation passed after that follow-up: `node --test ./native-ios/scripts/audit-visible-product-language.test.js ./native-ios/scripts/viet-practice-copy.test.js`, `node native-ios/scripts/audit-visible-product-language.js`, native guards, `git diff --check`, XcodeBuildMCP simulator tests `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`, `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`, `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy`, `AppChromeTests/testBrowseCategoryMessageSectionsMirrorMessagesHubGroups`, `AppChromeTests/testCategoryPracticeEntryCopyDescribesMatchPractice`, and single-test UI rerun `BrowseSearchUITests/testFoodCollectionUsesPracticeMomentsAfterNounRows`
- route/function worker report updated at `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/route-function-worker-report.md`; confirmed route passes include Search/Browse handoffs, city jumps, save/unsave loops, Browse Practice sheet dismissal, Saved Practice isolated rerun, fast double-back restore, and focused breakdown-audio rerun. The two worker-flagged follow-ups were rerun on current `main` at `7228e5339`: `BackSwipeUITests/testHomePracticePoolOpensDirectRoundWithoutPracticeHubFallback` passed, and `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved` passed after rebooting the simulator from an initial runner-channel disconnect.
- eight-hour test-harness cleanup removed stale Practice-era drift from active UITests/Tests: dock helpers now use `Practice` instead of the old `Messages` alias, local-greetings proof labels now expect `Hotel greeting` / `Respectful greeting`, and an exact stale-term scan finds no `openDock("Messages")`, `case "Messages"`, `Hotel Hello`, `Respectful Hello`, or `Quick conversations` references in `native-ios/UITests` or `native-ios/Tests`. Focused validation passed: `AdminChromeUITests/testPrimarySystemTabsRemainReachableAroundSearch`, `AdminChromeUITests/testSystemTabTapsCommitDestinations`, `AdminChromeUITests/testSystemTabTapCommitsDestination`, `BrowseSearchUITests/testAdminDetoursFromBrowseCollectionBackReturnToCollection`, `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`, `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`, and `BrowseSearchUITests/testFoodCollectionUsesPracticeMomentsAfterNounRows`.
- eight-hour Practice surface follow-up replaced visible/accessibility inbox wording in scenario practice: `Unread` -> `Ready to practice`, `Mark Unread` -> `Mark for practice`, and `Open thread` -> `Start practice`. The static visible-language audit now blocks those retired labels, and focused validation passed: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, `PracticeUITests/testPracticeHubUsesMatchPracticeInsteadOfMessages`, `PracticeUITests/testLegacyPracticeScenarioLaunchFallsBackToMatchRound`, and `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`.
- broad current-main Browse/Search front-end regression passed after the eight-hour repairs: `BrowseSearchUITests`, `68` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T16-57-11-230Z_pid2504_8f5f7c4e.xcresult`. This sweep covered Browse root/category/city surfaces, city Browse-by jumps, Vietnamese menu top-admin/section controls, detail photo-backdrop behavior, Search flows, Saved interactions, and Browse-launched Practice entry points.
- broad current-main Practice front-end regression passed after the eight-hour repairs: `PracticeUITests`, `13` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T17-21-37-183Z_pid2504_8ac43b3d.xcresult`. This sweep covered Practice hub copy, saved-practice entry, Browse-launched match rounds, topic picker sources, close/continue controls, hint controls, and match completion.
- broad current-main back/forward navigation regression passed after the eight-hour repairs: `BackSwipeUITests`, `13` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T17-34-31-335Z_pid2504_a51d010a.xcresult`. This sweep covered Home-to-Browse, Home-to-city, Home-to-phrase, Home-to-Practice, direct detail edge-swipe, and forward-history restoration paths.
- broad current-main bottom-inset regression passed after the eight-hour repairs: `BottomInsetUITests`, `2` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T17-38-43-431Z_pid2504_96675f9b.xcresult`. This sweep covered primary root routes and representative collection/detail routes staying above the system tab bar.
- broad current-main admin/chrome regression passed after the eight-hour repairs: `AdminChromeUITests`, `30` tests, `1` skipped, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T17-40-12-615Z_pid2504_9977228b.xcresult`. This sweep covered Home/Browse/Saved/Practice/Search chrome, photo-backdrop hide/restore behavior, top-admin controls, More menu links, audio speed selector, and tab destination commitment.
- broad current-main audio-tap regression passed after the eight-hour repairs: `AudioTapReliabilityUITests`, `2` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T17-51-09-574Z_pid2504_758920ec.xcresult`. This sweep covered breakdown audio cards and row audio buttons across Search, menu, and Saved surfaces.
- current-main listing production visual proof passed after the eight-hour repairs: `ListingProductionQADiverse20ProofUITests`, `1` test, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T17-52-55-243Z_pid2504_2bbe24a6.xcresult`. This captured top/middle/bottom proof for `20` diverse listing/detail pages across phrase, hotel, city/place, restaurant, dish, street, and practical-flow surfaces.
- current-main latest-feedback listing proof passed after the eight-hour repairs: `ListingLatestFeedbackProofUITests`, `2` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T18-02-22-730Z_pid2504_2a561c9d.xcresult`. This captured the latest-feedback detail and hub page proof paths.
- current-main representative listing proof passed after the eight-hour repairs: `ListingProductionQAProofUITests`, `1` test, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T18-05-36-452Z_pid2504_981275af.xcresult`. This captured representative phrase, hotel, city/place, street, restaurant, and landmark detail pages.
- current-main listing hub/random-loop proof passed after the eight-hour repairs: `ListingHubRandomLoopProofUITests`, `2` tests, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T18-07-20-183Z_pid2504_ec5b3750.xcresult`. This captured hub pages for city/country/topic QA and a fresh diverse listing loop.
- current-main V2.2 city/place render proof passed after the eight-hour repairs: `520` pages, `1560` screenshots, all `PASS`, results at `docs/task-results/frontend-qa-2026-07-05/eight-hour-audit/v22-render-proof-results.jsonl`. This direct-render pass covered top, middle, and bottom-inset proof across the full Da Nang, Hanoi, HCMC, Hoi An, and Hue city/place inventory.
- current-main native unit/product-contract suites passed after the eight-hour repairs: `AppChromeTests` (`241` passed), `SQLiteLanguagePackRepositoryTests` (`28` passed), `PhrasePageFixtureTests` (`61` passed, `26` intentionally skipped), `PracticeNativeMVPTests` (`25` passed), `PracticeScenarioModeTests` (`48` passed), and `LocalUserIntentStoreTests` (`14` passed), all with `0` failures. These suites cover route/history contracts, Browse/Search destination models, city/menu/listing render policies, phrase/audio fixtures including `Không cay`, Practice source selection, scenario-practice coherence, SQLite runtime health, and saved/recent local state.
- current-main offline content/audio gates passed after the eight-hour repairs: `validate-viet-sqlite-fixture.js` (`1800` source phrases, `1793` canonical pages, `5353` audio assets, `0` release-blocking missing-audio rows), `sync-viet-audio.js` (`5353` manifest entries), `validate-tier-one-listing-pages.js` (`150` strong, `0` placeholder/thin/awkward), and `validate-vietnamese-menu-copy.js` (`355` handwritten menu item pages, `15` ready helper phrases).
- late eight-hour semantic-copy follow-up found and fixed two lower-page/product-language leaks after the broad sweeps: the Da Nang terminal SIM proof now says `hotel check-in details` instead of `hotel messages`, and the Browse `Hello basics` subtitle now says `Simple ways to start speaking.` The visible-language audit now also scans source-backed retired phrases, not only direct SwiftUI `Text`/`Label` literals. Fresh validation passed: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, exact stale-term `rg` scan, `git diff --check`, and `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs` (`1` test, `0` failures), result bundle `/Users/jojolim/Library/Developer/Xcode/DerivedData/SpeakLocalNative-ckdwludnenwmndfazdhqudhskoxq/Logs/Test/Test-SpeakLocalNative-2026.07.06_05-15-23-+0800.xcresult`.
- late eight-hour test-harness cleanup removed old Messages wording from non-visible UI-test identifiers: `Practice.Messages.*` / `Practice.Message.*` -> `Practice.Scenarios.*` / `Practice.Scenario.*`, and `BrowseCollection.Messages.*` / `BrowseCollection.Message.*` -> `BrowseCollection.PracticeMoments.*` / `BrowseCollection.PracticeMoment.*`. Fresh validation passed: visible-language audit, audit unit test, exact old-identifier `rg` scan, `git diff --check`, Swift parse over modified Swift files, and focused native Xcode rerun with `3` tests and `0` failures (`AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`, `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy`, `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`), result bundle `/Users/jojolim/Library/Developer/Xcode/DerivedData/SpeakLocalNative-ckdwludnenwmndfazdhqudhskoxq/Logs/Test/Test-SpeakLocalNative-2026.07.06_05-26-22-+0800.xcresult`.
- merged stale photo-backdrop route/back hardening as `2834a52af`
- merged rapid audio tap stabilization as `48c608b92`
- committed active playback stress hardening as `4f6462906`
- follow-up local UI-test harness change aligns the Drink Menu row-audio stress path with the real Coffee-section route; it does not change shipped app runtime behavior
- `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved` passed after the harness fix: `1` test, `0` failures, result bundle `/tmp/speaklocal-audio-harness-single-1783255528.xcresult`
- full `AudioTapReliabilityUITests` passed after the harness fix: `2` tests, `0` failures, result bundle `/tmp/speaklocal-audio-harness-class-1783255691.xcresult`
- fresh focused UI rerun after correcting stale `only-testing` selectors passed in two commands: `4` tests + `5` tests, `9` unique tests total, `0` failures across audio reliability, Browse detail back restore, fast double-back restore, Search category/city handoffs, Hoi An Browse-by jump, city top-admin clearance, and Practice saved match sheet
- current `main` built and installed on Jojo's active physical iPhone; launch was blocked because the phone was locked
- fallback simulator launch proof passed for current `main`
- App Store screenshot proof captured seven Pro Max screenshots at `1320x2868` under `docs/task-results/parallel-goals-2026-07-05/three-hour-push/app-store-screenshot-proof/`
- static audio release audit found no launch-blocking audio defect: required validators passed, no broken manifest references, no zero-duration bundled audio files, and `Không cay` is covered
- post-checkpoint main validator sweep passed on `abd3f3a6e`: SQLite fixture, audio manifest sync, tier-one listing pages, Vietnamese menu copy, production QA audit, city app-detail v2.2 strict production, search-only surfacing, and focused Node tests
- release-submission gap pass verified seven screenshot candidates, local support/privacy/terms/about sources, launch metadata files, and `1024 x 1024` app icon; App Store Connect-only fields still require Jojo/ASC decisions
- paywall final risk pass kept `feature/paywall` isolated and reran `SubscriptionAccessStateTests`: `13` tests, `0` failures; real purchase/restore/relaunch and App Store Connect product state remain unproven
- root photo-backdrop immersive chrome regression was fixed after a broad UI sweep exposed four pre-fix root-page failures; focused validation now passes `6` tests across the root policy unit test plus Home, Browse, Saved, Practice, and Search hidden/restored chrome UI checks
- root photo-backdrop fix receipt: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/root-photo-backdrop-immersive-fix-report.md`
- app-code commit `0a7fb4d50` built for Jojo's active physical iPhone after the root photo-backdrop fix and installed successfully; launch was blocked only because the phone was locked
- signing hygiene stayed clean: no tracked changes to `native-ios/project.yml` or the native Xcode project signing files
- `feature/paywall` remains excluded from `main`; it has green hosted StoreKit/XCTest readiness at commit `453d6f55a`, but still needs real purchase/restore/relaunch proof before merge

## Prior 2026-07-05 Main Merge Proof

App-code payload after the 2026-07-05 non-paywall launch-readiness checkpoint and real-traveler Browse-back merge:

- committed the non-paywall launch-readiness checkpoint as `7b63e4fd7`
- merged `feature/real-traveler-walkthrough-20260705` into `main`; final merge head is `470016d3e`
- later docs/marketing commits may sit on top of that app-code payload without changing the native binary inputs
- user-facing merge addition: Browse root now remounts/resets safely after a detail -> collection -> Browse back chain, preserving the newer detail-aware reset guard from `main`
- `git diff --check` passed
- `node scripts/guard-native-only.js` passed
- `node native-ios/scripts/guard-native-chrome.js` passed
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: `1782` clusters, `1800` source phrases, `1793` canonical pages, `5353` audio assets, and `0` release-blocking missing-audio rows
- `node native-ios/scripts/sync-viet-audio.js` passed: validated `5353` native audio manifest entries
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed: `150` strong, `0` thin/awkward/placeholder
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` passed: `355` handwritten menu item pages and `15` ready helper phrases
- XcodeBuildMCP simulator regression passed on final `main`: `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`, `1` test, `0` failures
- physical iPhone build/install/launch proof for the latest `main` checkout remains pending because device tooling reported no available paired iPhone during the latest attempts
- fallback Simulator proof for app-equivalent head `b101ed419` passed on 2026-07-05: XcodeBuildMCP built, installed, and launched `SpeakLocalNative` on `SpeakLocal Launch Runtime`, with screenshot proof in `docs/task-results/parallel-goals-2026-07-05/three-hour-push/phone-device-simulator-home-b101ed419.jpg`
- signing hygiene stayed clean: no tracked changes to `native-ios/project.yml` or the native Xcode project signing files
- `feature/paywall` was synced forward to current `main` in paywall commit `9fcdf217a`, but paywall remains excluded from `main`

## Current Front-End QA Proof

Current 2026-07-05 deep visual QA follow-up after Jojo's physical iPhone review exposed missed visual/functionality defects:

- deep visual QA ledger: `docs/task-results/deep-visual-qa-2026-07-05/BUG_LEDGER.md`
- fixes covered: not-spicy `Không cay` breakdown audio, Browse detail fast back/back blank canvas, city header save/favorite, city row save persistence, city Browse-by jumps and top-admin clearance, Practice native sheet top-header clearance, and stale Practice/Home quick-practice UI test expectation
- focused unit receipt passed: `4` tests, `0` failures across not-spicy audio, speaker manifest policy, audio-session setup, and city saved-trip persistence
- focused Browse/Search UI matrix passed: `8` tests, `0` failures covering double-back restoration, city header save, city row save, Browse-by jump behavior, top-admin clearance, and Saved unsave
- audio UI reliability passed: `2` focused tests, `0` failures across breakdown audio cards and row audio taps
- BackSwipe UI suite passed: `13` tests, `0` failures across detail, Browse, Home city/phrase/practice, forward history, and tab back chains
- Practice visual sheet proof passed on a Pro Max simulator: `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`, `1` executed test, `0` failures, screenshot proof at `/tmp/speaklocal-practice-proof-pro-max/saved-round-start.png`
- Practice home quick-practice return flow passed after aligning the test to the current direct-round behavior: `1` executed test, `0` failures
- broad post-fix UI sweep on the Pro Max simulator executed `135` tests with `132` passing and `1` skipped; the `2` failures were both test-harness/configuration issues found by the deeper pass, not accepted as green:
  - `CityAppDetailV22RenderProofUITests/testCaptureCityAppDetailV22RenderProofBatch` now skips when the required render-proof manifest is not supplied instead of failing generic full sweeps
  - `PracticeUITests/testHomeQuickPracticeCallerCompletesRoundAndReturnsToHomePracticeRail` exposed an offscreen Home quick-practice tap caused by relying on XCTest `isHittable` without visible-window geometry; the helper now requires visible geometry before tapping
- focused post-broad-sweep rerun passed: `2` selected tests, `1` pass, `1` intentional skip, `0` failures
- physical iPhone proof passed for the corrected `main` working tree: Debug build, install, and launch completed on Jojo's active physical iPhone with local-only signing overrides; repo signing files stayed clean after the build
- final post-harness app-code proof also passed on Jojo's active physical iPhone after the Home quick-practice visibility fix and render-proof skip repair: Debug build, install, launch, and signing hygiene all completed cleanly
- the earlier broad frontend QA green is narrowed by this follow-up: future validation claims must verify nonzero XCTest execution counts and should include exact visual/state assertions for native sheet chrome, audio affordances, city jumps, and rapid navigation paths
- paywall remains excluded

Current 2026-07-04/05 non-paywall native UI evidence from the frontend QA bug hunt:

- full final simulator sweep passed: `SpeakLocalNativeUITests` executed `132` tests, with `1` intentional skip and `0` failures, completing at 2026-07-05 04:42 Asia/Manila local time
- the sweep covered Admin/Chrome, audio button reliability, Bà Nà journey proof, Back/Forward navigation, bottom insets, Browse/Search, city V2.2 render proof, listing hub/detail/production proof, and Practice flows
- compact summary: `docs/task-results/frontend-qa-2026-07-04/test-summaries/full-ui-final-sweep-summary.json`
- per-test xcodebuild receipt: `docs/task-results/frontend-qa-2026-07-04/test-logs/full-ui-final-sweep.log`
- screenshot/proof set: `259` files under `docs/task-results/frontend-qa-2026-07-04/full-ui-final-sweep-proofs/`
- frontend QA issue ledger: `docs/task-results/frontend-qa-2026-07-04/BUG_LEDGER.md`; issues `FQA-001` through `FQA-019` were fixed or covered and then validated
- follow-up Practice header clearance proof passed after Jojo's physical-device screenshot exposed a missed visual gate: the saved-practice geometry regression failed red before the layout fix, passed green afterward, the full `PracticeUITests` class passed with `13` tests and `0` failures, visual screenshots were retained under `docs/task-results/frontend-qa-2026-07-04/practice-header-fix-proof/`, and a follow-up physical iPhone Debug build/install/launch passed with repo signing files clean
- physical iPhone proof for the same QA/resource payload passed: Debug build, install, and launch completed on Jojo's active physical iPhone with local-only signing overrides; repo signing files stayed clean
- paywall / StoreKit proof remains separate and excluded from this frontend QA result

## Current Audio Coverage Proof

Current 2026-07-04 launch-readiness working-tree evidence after the ElevenLabs remediation pass:

- visible placeholder scan passed with `0` `TODO` / `TBD` / placeholder / `coming soon` / `audio not available yet` hits across `native-ios/Resources/viet-phrase-catalog.json`, `native-ios/Resources/viet-authored-listing-pages.json`, and `native-ios/Resources/vietnamese-menu-copy.json`
- `node native-ios/scripts/sync-viet-audio.js` passed: validated `5353` native audio manifest entries in `native-ios/Resources/Audio`
- `node native-ios/scripts/generate-city-noun-audio-elevenlabs.js --dry-run` passed with `520` already ready and `0` to generate
- `node native-ios/scripts/generate-vietnamese-menu-audio-elevenlabs.js --dry-run` passed with `709` already ready and `0` to generate
- `node native-ios/scripts/generate-breakdown-audio-elevenlabs.js --authored-audit-missing --dry-run` passed with `0` manifest keys and `0` to generate
- `native-ios/Resources/viet-authored-audio-audit.json` reports `2246` required audio entries and `0` missing audio entries
- regenerated Viet SQLite report shows `5353` audio assets, `3949` unique normalized spoken texts, `19552` audio usages, `0` missing-audio audit rows, `0` planned missing-audio audit rows, `0` release-blocking missing-audio rows, and `0` planned missing-audio queue rows
- focused simulator test command passed for `9` audio/content tests across SQLite audio resolution, authored phrase-row audio, phrase option audio, city/place audio, and Vietnamese menu audio
- fresh physical iPhone proof for the regenerated audio payload passed: Debug build, install, and launch all completed with local-only signing overrides; repo signing files stayed clean
- human audio-quality/listen spot-checks are still recommended before claiming perfect pronunciation or same-voice consistency

## Current New-Phone Device Proof

Current `main` evidence from 2026-07-04, based on commit `07a2db5d8`:

- `./scripts/status.sh` showed most non-paywall lanes at `07a2db5d8`; `feature/paywall` and legacy `feature/messages-section` remain outside `main`
- `git branch --no-merged main` showed only the archived/legacy Messages branch, `feature/messages-section`, and `feature/paywall`
- `git cherry -v main feature/paywall` showed the paywall setup/skeleton commits still unmerged
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with `1782` clusters, `1800` source phrases, `1793` canonical pages, `11728` relations, `778` planned missing-audio rows, and `0` release-blocking missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check` passed with `1793` pages, `0` blockers, and `0` majors; it still reported `500` missing-audio priority rows
- first physical install attempt to Jojo's replacement/new active iPhone did not complete because Xcode reported Developer Mode disabled on the phone before install
- after Developer Mode was enabled, Xcode saw the phone as a valid iOS destination, but signing/provisioning initially failed because Xcode had no signed-in Apple account, the cached development profile did not include the new phone, and Apple required a Program License Agreement update
- after Xcode account sign-in and Apple Program License Agreement acceptance, the current-`main` debug build passed with local-only signing overrides
- install to the replacement/new active physical iPhone passed for bundle `app.speaklocal.vietnam.native`
- launch on the replacement/new active physical iPhone passed
- signing hygiene checks before and after the successful build showed no tracked signing-file changes and no personal signing/team/device identifiers written into `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- after the Home scroll-jank report on the same launch-readiness working tree, the original Home lifted/glass panel styling was restored and the deeper scroll-state fix moved photo-backdrop/chrome offset updates out of the full Home content tree
- focused Home validation passed after that fix: `AppChromeTests/testHomePhotoBackdropPublishesScrollStateAtCoarserPerformanceStride` and `AdminChromeUITests/testHomeLiquidGlassRedesignProofScreenshots`
- full Browse/Search UI validation passed after the Home fix: `BrowseSearchUITests`, `60` tests, `0` failures, result bundle `docs/task-results/launch-readiness-audit-2026-07-04/runtime/browse-search-full-post-home-fix.xcresult`

## Current Launch Readiness Main Evidence

Current `main` evidence after merging `feature/launch-readiness-bug-hunt-20260616`, based on merge commit `93c08cf64`:

- merged `feature/launch-readiness-bug-hunt-20260616` into `main` with merge commit `93c08cf64`
- target bug-hunt commits included in `main`: `92aa37f83` (`Complete Viet launch readiness bug hunt`) and `6e86e38ea` (`Fix launch bug hunt goal whitespace`)
- paywall remained excluded; `git cherry -v main feature/paywall` still showed the paywall setup/skeleton commits as unmerged
- bug-hunt recommendation on the merged lane: `PASS_WITH_FOLLOW_UPS` for simulator-tested non-paywall native Vietnam paths
- user-facing fixes included:
  - relationship-form Practice/detail copy changed from awkward labels such as `How are you, older man?` to natural parenthetical labels such as `How are you? (to an older man)`
  - Vietnamese menu bottom-clearance scroll target added for bottom chrome validation
  - production QA `--check` mode stopped rewriting audit artifacts
  - stale city V2.2 unit-test fixture expectations aligned to current source truth

Fresh command evidence from merged `main`:

- `git diff --check` passed
- `node scripts/guard-native-only.js` passed
- `node native-ios/scripts/guard-native-chrome.js` passed
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check` passed: `1793` pages, `0` blockers, `0` majors
- `node --test ./native-ios/scripts/audit-viet-listing-production-qa.test.js ./native-ios/scripts/viet-practice-copy.test.js` passed: `2` tests
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` passed: `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: `1793` canonical pages, `11728` relations, `0` release-blocking missing-audio rows, `778` planned missing-audio rows
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed: `150` strong, `0` thin/awkward/placeholder
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` passed: `355` handwritten Vietnamese menu item pages, `15` ready helper phrases
- `node native-ios/scripts/validate-viet-search-only-surfacing.js` passed: `315` search-only rows, `315` generated relations, `315` generated section items
- focused simulator unit test command passed: `30` tests executed, `0` failures, `1` intentional skip
- targeted simulator UI test command passed: `7` tests executed, `0` failures

Physical iPhone proof for this merged `main` payload:

- Debug build from `main` commit `93c08cf64` passed with local-only signing overrides
- install to the connected physical iPhone passed for bundle `app.speaklocal.vietnam.native`
- launch on the connected physical iPhone passed
- post-build signing scan passed; repo signing files stayed clean
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` returned no changes after the build

Remaining honest follow-ups:

- StoreKit/paywall proof remains separate and excluded unless Jojo explicitly includes paywall in the release
- audio continuity remains a quality watch item; the current audio coverage proof above cleared the planned missing-audio queue in the launch-readiness working tree and passed a fresh phone build/install/launch, but human listen spot-checks are still recommended
- device performance profiling for search, first audio tap, Browse/Home first render, and Saved/Practice state fanout would strengthen App Store confidence but no user-visible jank was reproduced in the tested simulator paths

## Current Merge Sweep Main Evidence

Current `main` app-code evidence after merging the ready non-paywall lanes, based on app-code merge head `a8df5ce59`:

- merged `feature/practice-area` into `main` with merge commit `a7497ba97`
- merged `feature/browse-page` into `main` with merge commit `a8df5ce59`
- checkpointed included lane work: `6d9e07237` (`Checkpoint practice match polish`) and `597aa4515` (`Checkpoint browse selectable text work`)
- synced all clean non-paywall feature/codex worktrees to `a8df5ce59`
- intentionally skipped legacy Messages, archived Messages, old integration lanes, and `feature/paywall`
- paywall remained excluded; `git cherry -v main feature/paywall` still shows the paywall setup/skeleton commits as unmerged
- legacy Messages remained excluded; `git cherry -v main feature/messages-section` still shows `04dd789f2` as unmerged

Fresh command evidence from merged `main`:

- `git diff --check` passed
- `node scripts/guard-native-only.js` passed
- `node native-ios/scripts/guard-native-chrome.js` passed
- `xcodegen generate` passed and left `native-ios/SpeakLocalNative.xcodeproj` clean
- focused simulator test passed: `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' -only-testing:SpeakLocalNativeTests/AppChromeTests/testCategoryPracticeEntryCopyDescribesMatchPractice -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests/testEveryLoadedMatchSourceCanAdvancePastFirstCompletedRound test`

Physical iPhone proof for this app-code payload:

- Debug build from current `main` passed with local-only signing overrides; native app code matched merge payload `a8df5ce59`
- install to the connected physical iPhone passed for bundle `app.speaklocal.vietnam.native`
- launch was blocked because the iPhone was locked; iOS returned the locked-device launch denial after install succeeded
- post-build signing scan passed; repo signing files stayed clean
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` returned no changes after the build

## Current Phrase Copy Production Gate Main Evidence

Current `main` evidence after merging `codex/phrase-copy-production-gate`, based on merge commit `e06b28c0b`:

- merged `codex/phrase-copy-production-gate` into `main` with merge commit `e06b28c0b`
- target checkpoint commit included in `main`: `1176231b7` (`Finalize phrase copy production gate`)
- paywall remained excluded; `git cherry -v main feature/paywall` still shows the paywall setup/skeleton commits as unmerged
- visible copy recommendation: `PASS`
- merge/release recommendation: `PASS_WITH_ACCEPTED_RISKS`
- premium visible-copy audit after the derived place-phrase copy-floor follow-up: `1793` pages, `0` `HARD_REVIEW`, `0` `WEAK_REVIEW`, `148` `WATCH`, `1645` `PASS`; the earlier zero-watch receipt remains historical because the follow-up tightened derived helper-page scrutiny
- subagent review gates: Euclid returned focused copy `PASS`; Noether returned `MERGE_OK_ACCEPT_RISK` for source/render card parity
- accepted source/render parity risk on merged `main`: `319` mismatch rows, `201` page mismatches, `57` unique source-card missing rows, `262` section layout diff rows, `0` hard-block rows, recommendation `REVISE_BEFORE_PRODUCTION`; accepted as runtime/source-card curation bookkeeping, not visible-copy failure
- anti-thinning evidence remains branch-local: `882` ledger rows across `613` unique edited page IDs, including `20` Batch 48 rows and `4` Batch 49 rows
- production QA remains `0` blockers / `0` majors; remaining non-copy follow-ups are missing-audio priority rows and hidden duplicate `sayThis` hero sections

Fresh command evidence from merged `main`:

- `node native-ios/scripts/audit-viet-premium-listing-copy.js` completed: `1793` pages, `0` hard, `0` weak, `148` watch, `1645` pass
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: SQLite OK, `1793` canonical pages, `11728` relations, `0` release-blocking missing-audio rows, `778` planned missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js` passed: `1793` pages, `0` blockers, `0` majors, `775` duplicate hero sections hidden at render time, `500` missing-audio priority rows
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed: `150 / 150` strong
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` passed: `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/validate-viet-city-copy.js` passed: `5` hubs, `520` city noun pages, `520` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js` passed: `826` pages
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` passed: `355` handwritten Vietnamese menu item pages, `15` ready helper phrases
- `node native-ios/scripts/audit-viet-source-render-card-parity.js` completed with `0` hard-block rows and accepted `REVISE_BEFORE_PRODUCTION` bookkeeping recommendation
- `node scripts/guard-native-only.js` passed
- `git diff --check` passed

Physical iPhone proof from this merged copy gate:

- Debug build from `main` commit `d6f06b719` passed with local-only signing overrides
- install to the connected physical iPhone passed for bundle `app.speaklocal.vietnam.native`
- launch was blocked because the iPhone was locked; iOS returned the locked-device launch denial after install succeeded
- post-build signing scan passed; repo signing files stayed clean
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` returned no changes after the build

## Rendered Listing Front-End QA Follow-Up

Follow-up on top of `main` commit `51f229b86`, continuing thread `019ea562-0e44-7370-86fd-a2b53f4d9243`:

- original task: pick `25` mixed listing pages across tier-one, catalog-promoted, city/place, and derived city phrase pages, then verify the simulator front-end copy still reads production-ready
- recovered proof: the prior thread had captured `150` screenshots into `/tmp/speaklocal-listing-front-end-qa-20260611/`, but that temp folder was gone during this continuation
- fresh simulator reproof used an `iPhone 17 Pro` simulator and app bundle `app.speaklocal.vietnam.native`
- fresh visual pass covered pages `11` through `25`; pages `1` through `5` were already reviewed as production-ready in the original thread, and page group `6` through `10` was re-opened in this continuation before the temp folder disappeared
- issue found and fixed: the page `viet-phrase-food-premium-which-dish-safe` visually ellipsized its three-line Vietnamese hero title under the photo-backed listing layout
- code fix: `PhraseListingView` now allows three hero title lines for listing article heroes, matching the compact phrase hero allowance and preventing the page-12 headline truncation
- verification: XcodeBuildMCP simulator build/install/launch succeeded for `SpeakLocalNative` on `iPhone 17 Pro` after the fix
- visual proof after fix: `/tmp/speaklocal-listing-front-end-qa-reproof-20260611/page12-after-title-fix.png` showed the full Vietnamese title with no ellipsis and the English title, pronunciation, playback dock, and first content section still fitting
- runtime spot checks after fix: `viet-phrase-food-premium-which-dish-safe`, `viet-family-city-danang-atm-han-market`, and `viet-family-city-danang-where-nen` launched and exposed readable title, subtitle, breakdown, and related phrase text in the UI snapshot tree
- remaining accepted follow-up: compact derived city phrase pages expose sparse main player chrome and at least one `audio not available yet` breakdown accessibility label; this is audio/accessibility debt, not a visible-copy blocker for this rendered copy gate
- final rendered-copy verdict for the `25`-page sample: `PASS_WITH_FOLLOW_UPS`, with no remaining visible-copy blocker after the hero title line-limit fix
- `git diff --check` passed after the fix

## Derived Place Phrase Copy Floor Follow-Up

Follow-up on `main` after screenshot review of `viet-family-city-danang-where-nen`:

- root cause: derived place-phrase pages were treated as compact helper pages and allowed to render only `Break it down`, `Related phrases`, and `Tip`; the premium copy audit skipped their thin-page floor because they are `city-v1`
- scope found before fix: `306 / 306` derived place-phrase pages had no first-copy `at-glance` body, and the tightened all-page copy audit correctly raised `306` `HARD_REVIEW` rows before regeneration
- generator fix: derived place-phrase pages now render `At a glance` first, then `Break it down`, `Related phrases`, and `Tip`; derived tips now prefer authored traveler tips over source `context` so source notes like `A compact direction question...` do not surface
- validator fix: production QA, premium copy audit, city-library validation, and the intent-routing validator now require the derived-page copy floor instead of forbidding it
- generated resources refreshed: `native-ios/Resources/viet-authored-listing-pages.json` and the Viet SQLite fixture/report were regenerated from the updated authored listing payload
- direct resource proof after fix: `306` derived place-phrase pages, `0` missing or misordered `at-glance` copy sections
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check` passed: `1793` pages, `0` blockers, `0` majors
- `node native-ios/scripts/audit-viet-premium-listing-copy.js` completed: `0` `HARD_REVIEW`, `0` `WEAK_REVIEW`, `148` `WATCH`, `1645` `PASS`; remaining watch rows are repeated helper-copy taste debt, not missing-copy blockers
- `node native-ios/scripts/validate-viet-city-library.js` passed: `826` pages
- `node native-ios/scripts/validate-viet-listing-intent-routing.js` passed after updating stale Bà Nà, Anăn, recovery, and table-wait expectations to current resource truth
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` passed: SQLite integrity OK, `1793` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: `1793` canonical pages, `11728` relations, `0` release-blocking missing-audio rows, `778` planned missing-audio rows
- `node native-ios/scripts/validate-tier-one-listing-pages.js`, `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js`, `node native-ios/scripts/validate-viet-breakdown-audit.js`, `node scripts/guard-native-only.js`, and `git diff --check` passed

## Branch-Local Phrase Copy Production Gate

Current branch-local evidence for `codex/phrase-copy-production-gate`, based on base `0a503335c`:

### 2026-06-10 Zero-Watch Final Copy Addendum

- final receipt: `docs/content-audits/phrase-copy-production-gate-2026-06-08/final-copy-audit-zero-watch-addendum-2026-06-10.md`
- visible copy recommendation: `PASS`
- merge/release recommendation: `PASS_WITH_RISKS`
- premium visible-copy audit: `1793` pages, `0` `HARD_REVIEW`, `0` `WEAK_REVIEW`, `0` `WATCH`, `1793` `PASS`
- final review gate: Euclid (`019eaec5-575b-7571-8504-467f8b14ae20`) returned focused `PASS` on the final five risk pages after Batch 49, with no exact page ID needing copy revision before the zero-watch gate
- merge-risk review: Noether (`019eb2a9-71b7-7bb0-bbd7-d0201e002e89`) returned `MERGE_OK_ACCEPT_RISK` for source/render card parity, with no visible-copy blockers found; accepted risk page IDs are runtime/source-card curation debt, not failed copy
- final repair pass: Batch 48 repaired `20` remaining watch pages; Batch 49 repaired `4` reviewer-risk pages; generator overrides repaired the remaining tier-one and derived-place utility-copy risks
- anti-thinning evidence: branch ledger now has `882` JSONL rows across `613` unique edited page IDs, including `20` Batch 48 rows and `4` Batch 49 rows
- regenerated resources: authored listing pages, phrase catalog, and Viet SQLite were regenerated from source after final copy/generator fixes
- validation summary: catalog-promoted authoring, premium copy audit, production QA, tier-one listing pages, breakdown audit, editorial model support, city app-detail V2.2, city copy, city library, city voice, city what/why, SQLite fixture, and `git diff --check` passed
- accepted risks before merge: source/render card parity still recommends `REVISE_BEFORE_PRODUCTION` despite `0` hard-block rows and is explicitly accepted as runtime curation bookkeeping; production QA still reports `500` missing-audio priority rows and `775` duplicate hero sections hidden at render time; physical iPhone proof was not run from this feature branch

Historical evidence below records the earlier state before the final addendum and should not be read as the current branch verdict.

- isolated worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/phrase-copy-production-gate`
- `main` was not edited by this pass
- phrase copy gate recommendation: `REVISE_BEFORE_PRODUCTION` under the fresh premium visible-copy audit
- validator / schema recommendation: `PASS_WITH_COPY_RISKS`
- material improvement: first-class phrase source and generated native payload now preserve rich authored phrase editorial instead of thinning phrase listings into bare `Vietnamese means English` shells
- generated scope after regeneration: `1782` phrase families, `1800` phrases, `1793` authored listing pages
- generated listing mix: `145` main tier-one pages, `13` child pages, `770` catalog-promoted pages, `826` city library pages, `39` editorial model support pages
- production QA result: `1793` pages, `0` blockers, `0` majors, `775` duplicate hero sections hidden at render time, `500` missing-audio priority rows
- stricter premium copy audit result: `297` hard-review pages, `70` weak-review pages, `312` watch pages, `1114` pass pages
- main copy risk: catalog-promoted phrase pages still contain repeated projection prose; `275 / 770` catalog-promoted pages are hard-review, with recurring title-as-summary and formulaic section-body patterns such as `lead with the question`, `first phrase leads`, `fits the next step`, `ready for the next turn`, and `can carry the next detail`
- final focused Batch 25 source/rendered blocker scan: `12 / 12` pages at `PASS`, `0` focused source/render card-parity rows, `0` exact old-text hits in active source/projection paths, `8` semantic/casing phrase repairs accounted for, and three HCMC city Useful Phrase cards swapped to bundled-audio alternatives so city/SQLite gates stay green
- final focused Batch 26 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` tracked helper/process-language hits on those pages, phrase cards preserved (`9` each except the restaurant wait page at `11`), and catalog-promoted authoring validation passed after removing one banned `support` wording
- final focused Batch 27 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` issue codes, phrase cards preserved (`9` each except the two help handoff pages at `8` after duplicate non-rendered help-card cleanup), and source/render card parity improved without hard blocks
- final focused Batch 28 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, phrase cards preserved (`9` each except clean-table at `11` and too-spicy at `7`), and two reviewer-polish visible bodies fixed after initial `PASS_WITH_RISKS`
- final focused Batch 30 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` targeted process-language hits, rendered phrase cards preserved at `11/9/9/9/9/9/9/11/9/9/7/9`, one breakdown punctuation reconstruction fix, one banned wording fix, and three non-thinning food card-parity source alignments
- final focused Batch 31 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` hard blocks, no visible process-language hits in the repaired rendered bodies, and no card-depth thinning
- final focused Batch 32 source/rendered proof: `12 / 12` pages at `PASS`, `0` focused source/render card-parity rows after the full-CSV recheck, `0` visible process-language hits, rendered phrase cards preserved at `9/9/9/11/11/9/9/9/8/9/9/9`, and two non-thinning source/card parity repairs for peanut allergy follow-ups plus a missing-phone duplicate helper card
- final focused Batch 33 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows after review-gate fixes, rendered phrase cards preserved at `7/9/9/9/9/9/9/9/9/9/9/9`, and Archimedes rechecked the batch with final `PASS`
- final focused Batch 34 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows after review-gate fixes, rendered phrase cards preserved at `8/9/9/9/8/9/9/9/10/9/9/9`, and Descartes rechecked the batch with final `PASS`
- final focused Batch 35 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows after review-gate fixes, `0` duplicate rendered targets, `0` visible shorthand hits, rendered phrase cards preserved at `9/9/9/9/9/9/9/8/9/9/9/11`, Plato rechecked with final `PASS`, and Pascal returned `PASS_WITH_RISKS` with no hard blockers
- final focused Batch 36 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` duplicate rendered targets, `0` suspicious visible process-language hits, rendered phrase cards preserved at `11/11/9/9/9/9/9/10/9/9/9/9`, `32` Batch 36 anti-thinning rows recorded, and Erdos returned `PASS_WITH_RISKS` with no hard blockers
- final focused Batch 37 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows after reviewer-follow-up fixes, `0` duplicate rendered targets, `0` suspicious visible process-language hits, rendered phrase cards preserved at `9/9/11/9/9/9/9/9/9/9/9/11`, `25` Batch 37 anti-thinning rows recorded, and Helmholtz rechecked with final `PASS`
- final focused Batch 38 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows after reviewer-follow-up fixes, `0` duplicate rendered targets, `0` suspicious visible shorthand/process hits, rendered phrase cards preserved at `11/9/9/9/9/9/9/9/9/9/9/9`, `19` Batch 38 anti-thinning rows recorded, and Raman rechecked with final `PASS`
- final focused Batch 39 source/rendered proof: `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` duplicate rendered targets, `0` visible internal/process-language hits, rendered phrase cards preserved at `9/14/11/9/9/9/9/7/9/9/9/9`, `14` Batch 39 anti-thinning rows recorded, and Darwin rechecked with final `PASS`
- final focused Batch 40 source/rendered proof: `12 / 12` pages at `PASS`, `0` focused source/render card-parity rows after the non-thinning natural-variant source alignment, `0` duplicate rendered targets, rendered phrase cards preserved at `9/9/9/9/9/9/9/8/8/9/9/9`, and `14` Batch 40 anti-thinning rows recorded
- rendered visible-copy scan: `11736` phrase cards, `5964` breakdown cards, `0` empty learning sections, `0` duplicate card-target pages, `0` zero-phrase pages, `0` zero-learning pages, `0` long bodies over `55` words
- anti-thinning/card graph check against base: `1778` shared phrase-ID pages checked, `0` shared phrase-card drops, `945` shared pages gained phrase cards, `833` stayed at the same phrase-card count
- shared phrase-ID page phrase cards: `8101` -> `11610`; shared phrase-ID page breakdown cards: `6900` -> `5914` after semantic retokenization, with full phrase rows preserved
- final source-backfill receipt: `933` source pages checked, `38` summaries updated, `80` sections updated, `106` files changed; anti-thinning ledger now has `740` JSONL rows total after Batch 40, including `14` Batch 39 rows and `14` Batch 40 rows across visible-copy polish and card parity
- read-only review gate: older subagent `019ea901-ce25-7353-ba6e-463c8f427e68` initially returned `REVISE_BEFORE_PRODUCTION` for source scaffolding, then rechecked after the earlier validator-focused fixes and returned `PASS`; Batch 6 subagent `019ea983-f4df-7182-8648-049199ff4c3a` returned `PASS_WITH_RISKS`, after which the repeated `Use it...` opener risk was fixed and all ten Batch 6 pages re-audited at `PASS 0`; Batch 7 subagent `019ea993-1f23-76e3-81fb-5003ffe775b7` initially returned `REVISE_BEFORE_PRODUCTION`, then `PASS_WITH_RISKS`, and finally `PASS` after source breakdown/card-label fixes; Batch 8 subagent `019ea9b4-d9fa-75c3-9b3d-01d51a03ec48` initially returned `REVISE_BEFORE_PRODUCTION`, then final `PASS_WITH_RISKS` after the `sẵn sàng` breakdown and planned/no-audio queue rendering blockers were fixed; Batch 9 repaired `12 / 12` hard-review/trust-blocker pages to `PASS 0`, fixed the initial read-only `PASS_WITH_RISKS` source-only concerns, and received final `PASS` from subagent `019ea9df-b24d-7413-a427-a061cda6c0a0`; Batch 10 repaired another `12 / 12` top hard-review pages to `PASS 0`, then fixed three reviewer semantic/audio risks by moving changed self-phrases to planned audio; Batch 11 repaired another `12 / 12` top hard-review pages out of `HARD_REVIEW` (`11` to `PASS`, `1` to `WATCH`), fixed Hegel's `PASS_WITH_RISKS` source/rendered pickup-card mismatch, and received final `PASS` from subagent `019eaa1d-349a-7d12-b91d-c024928715e5`; Batch 12 repaired another `12 / 12` top hard-review pages to `PASS`, moved six semantically corrected self-phrases to planned audio, then fixed Bacon's initial stale hero-pronunciation and source/rendered card-parity blockers; Bacon (`019eaa35-7e03-7f70-b3df-49fa82b1f776`) rechecked with final `PASS` and no remaining issue page IDs; Batch 13 repaired another `12 / 12` top hard-review pages to `PASS 0`; Ohm (`019eaa53-8488-7ce2-9add-20967905d1a3`) initially returned `PASS_WITH_RISKS`, then the main thread fixed source/render wording, police-station card parity, and full-breakdown punctuation risks; Ohm rechecked with final `PASS` and no remaining issue page IDs; Batches 14-17 each repaired another `12 / 12` top hard-review pages to `PASS 0`; Batch 18 repaired another `12 / 12` pages to `PASS 0`, with Hilbert (`019eaabc-b99f-75d0-b041-bcc3f700f2d5`) returning `PASS_WITH_RISKS` before the main thread fixed the `May I?` semantic/audio decision and mild-food source/rendered card parity; Batch 19 repaired another `12 / 12` pages to `PASS 0`, with Mendel (`019eaad0-dcd1-74f2-9e43-c8f05b6e2d69`) initially returning `REVISE_BEFORE_PRODUCTION` against the pre-fix batch before the main thread fixed bad source glosses, bare summaries, and four source/render card-parity risks; Batch 20 repaired another `12 / 12` pages to `PASS`, with Confucius (`019eaae4-0bd2-7a41-a08c-e3cbdb6ac6b2`) initially returning `REVISE_BEFORE_PRODUCTION` before the main thread fixed template language, emergency-template leaks, semantic/audio risks, and `21` related card audio-state parity issues; Batch 21 repaired another `12 / 12` pages to `PASS 0`, restored the audio-backed `Can we sit inside?` compromise required by city Useful Phrases, and raised that page's source `Explore next` card set from `2` to `5` to match rendered proof; Batch 21 reviewers Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) and Pauli (`019eab18-6b39-7202-a18f-1aef899a9f43`) returned `PASS_WITH_RISKS`, after which the main thread fixed the directions-call source/render text drift and stale `can-we-sit-inside` ledger row, regenerated resources, revalidated, and received Pauli's focused recheck verdict `PASS`; Batch 22 repaired another `12 / 12` pages to `PASS 0`, fixed one breakdown reconstruction issue, and raised the half-portion source `Explore next` card set from `2` to `5`; Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) re-reviewed after Batch 22 and returned `REVISE_BEFORE_PRODUCTION` for the full corpus while confirming Batch 22 itself is clean and not thinned; Batch 23 repaired another `12 / 12` pages to `PASS 0` and raised two source `Explore next` sections from `2` to `5` cards to match rendered proof; Plato returned `REVISE_BEFORE_PRODUCTION` for the full corpus and found two Batch 23 body-parity risks, which the main thread fixed and directly rechecked in rendered proof; fresh prose reviewer Hume (`019eaaf8-72a7-7212-9537-094ead7b0d9f`) and card-graph reviewer Lovelace (`019eaaf8-a972-7272-ba3a-7b2e01b67922`) both returned `REVISE_BEFORE_PRODUCTION`; Lovelace's stale rendered `audio-authored-*` finding for `food-premium-without-this-ingredient` was fixed with a narrow generator suppression, but adjacent food/allergy source/render layout parity remains part of the global backlog; remaining-corpus sidecar `019ea9e9-0c0f-7412-bca2-64c277d6f080` and fresh prose sidecar `019eaa09-28fd-7be0-b4cb-107f2da6e646` also returned `REVISE_BEFORE_PRODUCTION` with priority risks around formulaic catalog-promoted copy, food, transport/mobility, health-pharmacy, queue/line wording, literal `Can I have...` Vietnamese, source/rendered breakdown mismatches, stale audio, and related-card topicality
- Batch 24 read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `REVISE_BEFORE_PRODUCTION` for the full corpus and initially flagged outdoor-seating card parity, ATM rendered-summary fallback, and three source-only fallback bodies. The main thread grew outdoor seating from `2` to `5` source `Explore next` cards, rewrote the ATM summary, replaced the crossing/extra-night/invoice fallback bodies, regenerated, and reran focused proof at `12 / 12` PASS with `0` focused parity rows.
- Batch 25 repaired another `12 / 12` hard-review pages to `PASS`, moved seven changed self-phrases to planned/no-audio instead of reusing mismatched recordings, kept the hurry page on existing audio after casing/gloss repair, synced stale related phrase-card references and search-only placements, and substituted three HCMC city Useful Phrase cards with bundled-audio alternatives (`food-1`, `smalltalk-5`) in v2.2 source plus `city-library/v1.json`. Focused Batch 25 proof: `12 / 12` PASS, `0` focused parity rows, `0` exact stale old-text hits in active source/projection paths.
- Batch 26 repaired another `12 / 12` hard-review pages to `PASS 0`, covering ticket refunds, confirmation messages, shower access, stolen bag/phone/card problems, declined cards, charger borrowing, cooler-place small talk, long restaurant waits, rehydration salts, and luggage hold before check-in. A focused reviewer returned `PASS_WITH_RISKS` for one long-wait source/render card-list mismatch; the main thread aligned that source section upward to the five rendered restaurant-flow cards, added one anti-thinning ledger row, regenerated resources and SQLite, improved source/render parity to `386` rows across `234` pages, and kept production QA at `0` blockers / `0` majors.
- Batch 27 repaired another `12 / 12` hard-review pages to `PASS 0`, covering service-counter email requests, lunch-included checks, help-call and come-with-me handoffs, key-card and hot-water hotel problems, later booking changes, hotel-landmark and traffic-light direction checks, chest-pain safety wording, cash change, and correct-street confirmation. The main thread removed only duplicate, non-rendered source help cards from the two help pages, added `14` anti-thinning ledger rows, regenerated resources and SQLite, improved source/render parity to `382` rows across `232` pages, and kept production QA at `0` blockers / `0` majors.
- Batch 27 review gate: Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `REVISE_BEFORE_PRODUCTION` for one visible process-language blocker on the correct-street page. The main thread replaced it with traveler-facing street-sign/map guidance, verified the old process wording had `0` source/rendered hits, and Carson rechecked with final Batch 27 verdict `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.
- Batch 28 repaired another `12 / 12` hard-review pages to `PASS 0`, covering rear-entrance directions, table-cleaning, quiet rooms away from the street, luggage help, housekeeping skip, wake-up calls, smoke-smell reports, mosquito repellent, rental insurance, show-me-start-it, too-spicy restaurant repair, and no-printed-copy counter handoffs. The main thread grew the clean-table source `Explore next` set to match the richer rendered restaurant-flow cards, removed only one source-only too-spicy card the renderer already omitted, fixed two reviewer-polish visible bodies, regenerated resources and SQLite, and improved source/render parity to `378` rows across `230` pages.
- Batch 28 review gate: Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `PASS_WITH_RISKS` with no hard blockers and anti-thinning `PASS`; the main thread fixed the two body-polish risks, and Carson rechecked with final Batch 28 verdict `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.
- Batch 29 repaired another `12 / 12` hard-review pages to `PASS`, covering sanitizer, hotel-return directions, shop bag/availability, wrong-time booking, fever medicine, English-speaking medical help, SIM/eSIM data allowances, passport requirements, translation checks, bottle refills, and driver turn-around recovery. The main thread preserved `9` phrase cards on every page, fixed the gigabytes punctuation reconstruction issue, replaced `very thin plastic` with `lightweight plastic` instead of deleting the useful bag caveat, regenerated resources and SQLite, and kept source/render parity at `378` rows across `230` pages.
- Batch 29 review gate: Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially found two source/render body-parity blockers; the main thread rewrote the hotel-return and fever-medicine bodies, regenerated authored listing pages, catalog, and SQLite, and verified `0` Batch 29 source/render body mismatch pages. Carson's focused recheck returned final Batch 29 verdict `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 30 repaired another `12 / 12` hard-review pages to `PASS 0`, covering fish-sauce allergy, ramp access, SIM/eSIM activation, too-big sizing, copy-shop documents, phone repair timing, card refunds, wrong food orders, no signal, missing OTP codes, spoiled food, and written-password setup. The main thread fixed one copy-document breakdown punctuation issue, removed one banned `support` wording, aligned three food `Explore next` source card lists to rendered proof without thinning, regenerated resources and SQLite, and improved source/render parity to `372` rows across `227` pages.
- Batch 30 review gate: Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `PASS_WITH_RISKS` for three food source/render card-parity risks; after the main thread aligned those source card lists and reran proof, Carson's final recheck returned `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 31 repaired another `12 / 12` hard-review pages to `PASS 0`, covering agreement, map requests, written addresses, translation checks, bill mistakes, same-dish ordering, quieter seating, black-and-white printing, black item color checks, tomorrow bookings, ticket-date checks, and embassy help. The main thread replaced unrelated follow-up card clusters with relevant existing targets, repaired breakdown gloss drift, regenerated resources and SQLite, and improved source/render parity to `369` rows across `225` pages.
- Batch 31 review gate: Lagrange (`019ead98-e047-7c71-be7a-4b4f31c2c113`) returned `PASS_WITH_RISKS`; hard copy blockers: none; anti-thinning: `PASS`; remaining risk: native-speaker phrase fit for the audio-backed same-dish wording and minor review of map / black-and-white print phrasing. Whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 32 repaired another `12 / 12` hard-review pages to `PASS`, covering recommendations, bus stops, peanut requests, medicine frequency, bottled water, elevator access, missing phones, raincoats, trunk access, immigration lines, landmarks, and bill removal. The main thread found two focused source/render card-parity drifts in the full CSV after the JSON top-row shortcut looked clean, fixed both without thinning rendered cards, regenerated resources and SQLite, and improved source/render parity to `364` rows across `222` pages.
- Batch 32 review gate: Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) returned `PASS_WITH_RISKS`; hard copy blockers: none; anti-thinning: `PASS`; remaining risks are low-level phrase-fit/style items on the bottled-water and nearby-landmark audit scores plus formal-literal immigration-line / landmark wording. Whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 33 repaired another `12 / 12` hard-review pages to `PASS 0`, covering undercooked food, ambulance calls, penicillin allergy, mosquito repellent, clinic-address writing, laundry wash/dry requests, QR payment, SIM troubleshooting, round-number bargaining, gift shopping, and written-name sightseeing help. The main thread removed only one non-rendered undercooked source-only card, matched the penicillin page to the richer medication-safety card set, corrected the SIM card body to name the rendered data-top-up card, regenerated resources and SQLite, and improved source/render parity to `362` rows across `221` pages.
- Batch 33 review gate: Archimedes (`019eadbf-d9b5-7f52-baff-d5eb7e0e07c6`) initially returned `REVISE_BEFORE_PRODUCTION` for two body/card mismatch fixes, then rechecked with final `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 34 repaired another `12 / 12` hard-review pages to `PASS 0`, covering official-report filing, advance booking, lost-luggage reports, toothpaste errands, lost-item search help, written prices, partial understanding, bottled-water errands, fish-sauce checks, pill dosage, breathing trouble, and allergy-medicine pages. The main thread moved fish-sauce dietary variant cards into the rendered Natural Variants section, aligned the booking source text to `map location`, retargeted the allergy-medicine doctor card to the canonical health-doctor page, regenerated resources and SQLite, and improved source/render parity to `358` rows across `219` pages.
- Batch 34 review gate: Descartes (`019eaddb-223c-7500-b523-77f4e632c760`) initially returned `PASS_WITH_RISKS`; after the fish-sauce, map-location, and doctor-card fixes, Descartes rechecked with final `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 35 repaired another `12 / 12` hard-review pages to `PASS 0`, covering wrong-bill handoff, airline contact help, total-price confirmation, exit directions, double-charge recovery, canceled airport driver, baggage-tag handoff, lost room key, show-instead repair, tap-screen help, driver-call help, and counter-versus-table ordering pages. The main thread fixed the tap-page duplicate source target, refreshed the stale Batch 35 anti-thinning ledger rows, removed visible slug-like shorthand, regenerated resources and SQLite, and improved source/render parity to `350` rows across `215` pages.
- Batch 35 review gate: Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned final `PASS`; hard blockers: none; safe-fix items: none; accepted Batch 35 risks: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`. Pascal (`019eadf6-c082-7bd2-a589-ca74dca0163b`) returned `PASS_WITH_RISKS` with no hard blockers, accepting the 8-card room-key page because source/render/ledger agree.
- Batch 36 repaired another `12 / 12` hard-review pages to `PASS 0`, covering not-spicy correction, no-meat ordering, hotel total checks, app-card failure, photo permission, missing tour guide, English-speaker handoff, pickup points, stolen wallets, wrong hotel rooms, exit directions, and trunk luggage pages. The main thread fixed one internal `fallback` wording, made helper-generated card icons audio-manifest-aware, regenerated resources and SQLite, and improved source/render parity to `344` rows across `212` pages.
- Batch 36 review gate: Erdos (`019eae1f-83e6-7312-a99c-cf631bbfacba`) returned `PASS_WITH_RISKS`; hard blockers: none; safe-fix items: none; anti-thinning: `PASS`; accepted risk: some support-card targets rely on native route canonicalization / SQLite authored `phrase_page` rows. Whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Batch 37 repaired another `12 / 12` hard-review pages to `PASS 0`, covering walkability checks, first aid, shellfish allergy, passport check-in, cash/change limits, embassy contact help, same-day activity availability, photo boundaries, airport taxi booking, safe-now updates, and lime table requests. The main thread fixed the reviewer-flagged walk rendered line, aligned shellfish source cards to rendered proof, fixed the lime source/render card mismatch, cleaned two minor at-glance residues, regenerated resources and SQLite, improved source/render parity to `338` rows across `209` pages, and received Helmholtz's final review-gate verdict `PASS`.
- Batch 38 repaired another `12 / 12` hard-review pages to `PASS 0`, covering pork-free ordering, written cancellation policies, sheet changes, low water pressure, wrong-room booking mismatch, apologies, larger sizes, wrong-size returns, damaged items, two-person reservations, student discounts, and email document delivery. The main thread fixed reviewer-flagged visible shorthand in follow-up bodies, regenerated resources and SQLite, improved source/render parity to `336` rows across `208` pages, and received Raman's final review-gate verdict `PASS`.
- Batch 39 repaired another `12 / 12` hard-review/trust-risk pages to `PASS 0`, covering ride-app booking, bottled water, no-meat ordering, mobile data, Wi-Fi login pages, written airport reports, bridge crossings, object-in-food problems, service timing, charging cables, pointing requests, and written-address handoffs. The main thread aligned two source/render card risks without thinning rendered proof, regenerated resources and SQLite, improved source/render parity to `332` rows across `206` pages, and received Darwin's final review-gate verdict `PASS`.
- Batch 40 repaired another `12 / 12` hard-review pages to `PASS`, covering entrance choice, pain medicine, emergency-help escalation, sunscreen errands, duplicate payment taps, nighttime safety, right-side entrance checks, security calls, written-name reports, driver calls, good/bad clarification, and final-total checks. The main thread aligned two help-page natural-variant source sections to rendered proof without thinning visible cards, regenerated resources and SQLite, and improved source/render parity to `328` rows across `204` pages. A read-only Batch 40 reviewer is still running at this receipt update.
- physical iPhone proof: not run from this feature branch

Fresh command evidence from this branch:

- `node native-ios/scripts/generate-viet-catalog.js` passed: `1782` families, `1800` phrases
- `node native-ios/scripts/generate-authored-tier-one-pages.js` passed: `145` main tier-one pages, `13` child pages, `770` catalog-promoted pages, `826` city library pages, `39` editorial model support pages
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` passed: SQLite integrity OK, `19` scenarios, `1782` clusters, `1800` phrases, `1793` pages
- `node native-ios/scripts/apply-viet-premium-batch-28.js` passed: `12` repaired pages, `0` duplicate ledger rows added on reapply
- `node native-ios/scripts/apply-viet-premium-batch-31.js` passed: `12` repaired pages, `24` Batch 31 anti-thinning ledger rows present across authored repair and visible-copy polish passes
- `node native-ios/scripts/apply-viet-premium-batch-32.js` passed: `12` repaired pages, `15` Batch 32 anti-thinning ledger rows present across visible-copy polish, card parity, and parity recheck
- `node native-ios/scripts/apply-viet-premium-batch-33.js` passed: `12` repaired pages, `13` initial Batch 33 anti-thinning ledger rows added across visible-copy polish and card parity
- `node native-ios/scripts/apply-viet-premium-batch-33-review-fixes.js` passed: `2` review-gate fixes, `2` anti-thinning ledger rows added
- `node native-ios/scripts/apply-viet-premium-batch-34.js` passed: `12` repaired pages, `23` Batch 34 anti-thinning ledger rows present across visible-copy polish, card parity, and review-gate fixes
- `node native-ios/scripts/apply-viet-premium-batch-35.js` passed: `12` repaired pages, `26` Batch 35 anti-thinning ledger rows present across `12` pages
- `node native-ios/scripts/apply-viet-premium-batch-36.js` passed: `12` repaired pages, `32` Batch 36 anti-thinning ledger rows present across `12` pages
- `node native-ios/scripts/apply-viet-premium-batch-37.js` passed: `12` repaired pages, `25` Batch 37 anti-thinning ledger rows present across `12` pages
- `node native-ios/scripts/apply-viet-premium-batch-38.js` passed: `12` repaired pages, `19` Batch 38 anti-thinning ledger rows present across `12` pages
- `node native-ios/scripts/apply-viet-premium-batch-39.js` passed: `12` repaired pages, `14` Batch 39 anti-thinning ledger rows present across `12` pages
- `node native-ios/scripts/apply-viet-premium-batch-40.js` passed: `12` repaired pages, `14` Batch 40 anti-thinning ledger rows present across `12` pages
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed: `150 / 150` strong, `0` thin, `0` over-templated, `0` needs work
- `node native-ios/scripts/validate-viet-catalog-promoted-authoring.js` passed: `ok: true`, `770` authored pages
- `node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js` passed: `5` cities, `520` entries projected
- `node native-ios/scripts/sync-viet-premium-batch-25-references.js` passed: final runtime projection sync preserved city Useful Phrase card counts and added `3` v1 projection ledger rows
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: `1793` canonical pages, `11724` relations, `0` release-blocking missing-audio rows, `772` planned missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js` passed: `1793` pages, `0` blockers, `0` majors
- `node native-ios/scripts/audit-viet-premium-listing-copy.js` completed: `1793` pages, `297` hard-review, `70` weak-review, `312` watch, `1114` pass
- `node native-ios/scripts/audit-viet-source-render-card-parity.js` completed: `328` mismatch rows, `204` page mismatches, `60` unique source-card missing rows, `268` section layout diff rows, `0` hard-block rows
- `node native-ios/scripts/validate-viet-editorial-model-support.js` passed: `39` support pages
- `node native-ios/scripts/validate-viet-breakdown-audit.js --write-export` passed
- `node native-ios/scripts/validate-viet-phrase-backdrops.js` passed: `952` placements
- `node native-ios/scripts/validate-viet-search-only-surfacing.js` passed: `315` generated relations
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` passed: `355` handwritten Vietnamese menu item pages, `15` ready helper phrases
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` passed: `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/audit-viet-city-listing-what-why.js` passed: `520` entries, `0` findings, `0` hard-review pages
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js` passed; watch item: `first` is exactly at the max threshold (`175 / 175` entries)
- `node native-ios/scripts/validate-viet-city-copy.js` passed: `5` hubs, `520` city noun pages, `520` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js` passed: `826` pages
- `node scripts/guard-native-only.js` passed
- `git diff --check` passed

Remaining risks:

- This branch is not merged to `main`.
- This branch has not been built to the physical iPhone.
- `772` planned missing-audio rows remain in SQLite validation, with `0` release-blocking rows.
- `500` missing-audio priority rows remain in production QA.
- `775` duplicate `sayThis` hero sections are hidden at render time.
- The old audio manifest still contains the stale `Đường dây ở đâu?` recording entry for `v500-time-date-book-where-is-the-line`, but the rendered page and catalog no longer reference it.
- Literal `Can I have...` Vietnamese remains a corpus-level semantic/audio risk. Batch 10 fixed the `higher floor` and `seats together` reviewer examples and moved their changed self-phrases to planned audio; a broader audio-aware semantic pass is still needed.
- The Batch 27 `correct street` page keeps its audio-backed formal Vietnamese (`Đây có phải là đường phố chính xác không?`) as an accepted temporary wording risk until an audio-aware native-speaker replacement can be recorded.
- The Batch 31 same-dish page keeps the audio-backed literal Vietnamese `Tôi sẽ có những gì họ đang có`; visible prose passed, but native-speaker phrase fit should be reviewed before calling that wording production-natural.
- City copy passes, but the `first` voice crutch is exactly at its max threshold and should be watched in future edits.

Branch-local receipt:

- `docs/content-audits/phrase-copy-production-gate-2026-06-08/README.md`

## Current City Copy Production Gate Main Evidence

Current `main` evidence after merging `codex/city-copy-final-production-gate`, based on head `43ce9503b` before the phone-build receipt:

- merged `codex/city-copy-final-production-gate` into `main` with merge commit `43ce9503b`
- target copy checkpoint commit included in `main`: `420ef8aeb` (`Finalize city copy production gate`)
- paywall remained excluded; `git cherry -v main feature/paywall` still shows the paywall setup/skeleton commits as unmerged
- regenerated native/content projections on merged `main`: V2.2 handwritten projection, handwritten import, phrase catalog, authored listing pages, and Viet SQLite fixture
- copy-production result remains `PASS`: `520 / 520` cold-audited pages pass, `0` hard blocks, `0` safe-fix items, `0` accepted temporary copy risks
- anti-thinning gate remains clean: phrase cards were preserved, no useful card targets were removed, and `12 / 12` duplicate-card demotions still leave the same target rendered once on the same page
- render proof receipts remain current: `520 / 520` current pages pass, `1560` screenshots, `0` current failures, and Bà Nà clean-pass proof has `3 / 3` screenshots

Fresh command evidence from merged `main`:

- `git diff --check` passed
- `node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js` passed: `5` cities, `520` entries projected
- `node native-ios/scripts/import-viet-city-handwritten-copy.js` passed: `520` handwritten city copy entries imported
- `node native-ios/scripts/generate-viet-catalog.js` passed: `1767` families, `1785` phrases
- `node native-ios/scripts/generate-authored-tier-one-pages.js` passed: `826` city library pages
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` passed: SQLite integrity OK, `1778` pages
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` passed: `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js` passed with no failures
- `node native-ios/scripts/audit-viet-city-listing-what-why.js` passed: `520` entries, `0` findings, `0` hard-review pages
- `node native-ios/scripts/validate-viet-city-copy.js` passed: `5` hubs, `520` city noun pages, `520` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js` passed: `826` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: SQLite fixture OK, `1778` canonical pages, `0` release-blocking missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js` passed: `1778` pages, `0` blockers, `0` majors
- `node native-ios/scripts/validate-viet-ba-na-hills-journey-patch.js` passed: Bà Nà Hills V2.2 journey validation passed
- `node scripts/guard-native-only.js` passed

Physical iPhone proof from this merged copy gate:

- build from `main` commit `18cb1d77a` passed with local-only signing overrides
- install to the connected physical iPhone passed for bundle `app.speaklocal.vietnam.native`
- launch passed: `Launched application with app.speaklocal.vietnam.native bundle identifier.`
- post-build signing scan passed; repo signing files stayed clean
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` returned no changes before the build, and the phone helper reported no signing pollution after the build

## Branch-Local City Copy Final Production Gate

Current branch-local evidence for `codex/city-copy-final-production-gate`, based on base `083c87301`:

- isolated worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-copy-final-production-gate`
- `main` was not edited by this pass
- final copy gate recommendation: `PASS`
- cold visible-copy audit: `520 / 520` PASS, `0` HARD_BLOCK, `0` SAFE_FIX_NOW, `0` ACCEPTED_TEMPORARY_RISK
- edited V2.2 source pages in earlier final gate: `31`
- clean-pass source cleanup: `160` stale `Related because:` / `Mentioned here because:` source reason prefixes normalized across `147` first-class V2.2 pages, without changing rendered card subtitles or removing copy
- Bà Nà Hills native projection fix: rendered section labels now preserve authored V2.2 headings `More Park Than Viewpoint` and `Give It Room`
- anti-thinning result: phrase cards preserved exactly; no phrase cards were removed; no Mentioned Here or Related cards were removed, hidden, or retargeted in the clean pass
- duplicate-card adjudication: `12 / 12` full-branch `render` -> `do_not_render` demotions versus `main` still render the same target once on the same page in the other visible card module, so they are accepted as duplicate cleanup rather than copy thinning
- prior edited-page render proof: `31 / 31` PASS, `93 / 93` top/middle/bottom screenshots
- clean-pass render proof: `1 / 1` PASS, `3 / 3` screenshots for `viet-family-city-danang-place-ba-na-hills`
- combined current render proof remains `520 / 520` current pages PASS, `1560` current screenshots, `0` current failures, `0` missing manifest pages
- final read-only subagent reviews: visible copy/projection `PASS`; anti-thinning/card graph `PASS`

Fresh command evidence from this branch:

- `jq empty content-draft/viet/city-library/app-detail-v2-2/*.json` passed
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` passed: `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js` passed with no failures
- `node native-ios/scripts/audit-viet-city-listing-what-why.js` passed: `520` entries, `0` findings, `0` hard-review pages
- `node native-ios/scripts/validate-viet-city-copy.js` passed: `5` hubs, `520` city noun pages, `520` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js` passed: `826` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: SQLite fixture OK, `1778` canonical pages, `0` release-blocking missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js` passed: `1778` pages, `0` blockers, `0` majors
- `node native-ios/scripts/validate-viet-ba-na-hills-journey-patch.js` passed: Bà Nà Hills V2.2 journey validation passed
- `git diff --check` passed
- `xcodebuild build-for-testing -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=7C386DD3-4BF1-4A34-A918-768C43CD1258' -derivedDataPath /Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/city-copy-final-production-gate/DerivedData/SpeakLocalNative CODE_SIGNING_ALLOWED=NO` passed with `** TEST BUILD SUCCEEDED **`

Branch-local receipt files:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/final-copy-production-gate-receipt-2026-06-08.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/anti-thinning-ledger-2026-06-08.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/anti-thinning-clean-pass-addendum-2026-06-08.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/duplicate-card-demotion-adjudication-2026-06-08.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-copy-production-gate-2026-06-08/cold-visible-copy-audit-2026-06-08.jsonl`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-final-gate/README.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-08-city-copy-clean-pass/README.md`

Remaining non-copy risks:

- `500` missing-audio priority rows.
- `700` planned missing-audio rows with `0` release-blocking missing-audio rows.
- `1` duplicate hero section hidden at render time.

## Current City Listings V2.2 Main Evidence

Current `main` evidence after fast-forwarding `feature/city-listings-production-ready`, based on head `2b92f4a9c`:

- merged `feature/city-listings-production-ready` into `main` by fast-forward after the feature lane had already merged current local `main`
- preserved the fuller V2.2 city/place listing structure; final repairs fixed copy/schema/related-card issues instead of thinning pages
- committed final receipts:
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/final-closeout-receipt-2026-06-08.md`
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/README.md`
- rendered proof recompute: `520` current unique pages, `520` current pass, `1560` current screenshots, `0` current failures, `0` missing manifest pages
- latest proof result file: `final-orchestrator-repair-2026-06-08-results.jsonl`, `11 / 11` final repair pages passed with `33 / 33` screenshots

Fresh command evidence from this pass:

- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production` passed: `520` pass, `0` revise, `0` fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js` passed with no failures
- `node native-ios/scripts/audit-viet-city-listing-what-why.js` passed on the synced feature lane before merge: `520` entries, `0` findings, `0` hard-review pages
- `node native-ios/scripts/validate-viet-city-copy.js` passed: `5` hubs, `520` city noun pages, `520` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js` passed: `826` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed: SQLite fixture OK, `1778` canonical pages, `0` release-blocking missing-audio rows
- `node native-ios/scripts/audit-viet-listing-production-qa.js` passed on the synced feature lane before merge: `1778` pages, `0` blockers, `0` majors
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` passed: `355` handwritten Vietnamese menu item pages
- `node native-ios/scripts/validate-viet-phrase-backdrops.js` passed: `952` required backdrop placements
- `node scripts/guard-native-only.js` passed
- `node native-ios/scripts/guard-native-chrome.js` passed
- `git diff --check` passed
- Physical iPhone Debug build from `main` passed with local-only signing overrides
- Physical iPhone install did not complete: device install failed with `CoreDeviceError 3002` / `IXRemoteErrorDomain 6` connection interrupted before launch
- Phone launch was not attempted because install failed
- post-build signing hygiene stayed clean: `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` were unchanged; signing scan found no repo-visible personal team/provisioning values

Known non-blocking risks remain:

- `500` missing-audio priority rows in production QA
- `700` planned missing-audio rows, with `0` release-blocking missing-audio rows
- `1` duplicate hero section hidden at render time

## Current Main Merge Sweep Evidence

Current `main` evidence from the 2026-06-01 lane merge sweep, based on head `6649991c8` before this documentation receipt:

- merged completed non-excluded lanes into `main`: `feature/browse-page`, `feature/search-page`, `feature/menu-section`, `feature/admin-photo-backdrop-polish`, and `feature/city-listings-production-ready`
- intentionally skipped `feature/messages-section` and `feature/paywall`
- resolved merge conflicts by preserving both feature intents, including city/listing runtime cache work, menu-section cache work, search focus-return behavior, and admin photo-backdrop navigation fixes
- regenerated the Viet SQLite fixture after merged source/runtime changes; SQLite integrity check passed
- post-merge fix: canonical menu/location relation lookups now resolve aliases through the SQLite canonical page map before relation lookup
- post-merge fix: Vietnamese menu copy audit no longer flags `drink-ca-phe-sua-da` generic template wording
- post-merge fix: SQLite repository summary expectation now matches the current production copy for `viet-phrase-polite-1`

Fresh command evidence from this pass:

- `git diff --check` passed
- `node scripts/guard-native-only.js` passed
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed
- `node native-ios/scripts/validate-viet-phrase-backdrops.js` passed
- `node native-ios/scripts/validate-vietnamese-menu-copy.js` passed
- iPhone 17 Pro simulator Debug build passed with `xcodebuild`
- focused post-merge tests found real drift first; after fixes, a retry was blocked by Simulator app-launch preflight/busy state rather than a clean test pass
- Physical iPhone Debug build/install from `main` passed
- phone launch was blocked because iOS reported the phone was locked
- post-build signing scan stayed clean; personal signing remained local and was not written to repo files

## Current Back Navigation Fix Evidence

Current `feature/admin-photo-backdrop-polish` working-tree evidence from the 2026-05-31 back-navigation bug hunt, based on head `76f9a433b`:

- root cause 1: collection back navigation could restore an older explicit detail-page snapshot immediately after popping a Home/Browse collection. This made flows like listing -> Home -> Da Nang -> Back land on the older listing instead of the visible Home/Browse parent.
- root cause 2: button-driven back navigation reused the default trailing slide transition. Because hidden detail/collection pages are intentionally unmounted for thermal reasons until a swipe-back preview is active, the previous page was inserted as a new page from the right.
- fix: collection pop now honors the visible parent route first; older explicit history remains behind that route instead of being restored immediately.
- fix: button back/forward now sets a short-lived route transition direction so button back uses reverse slide edges while normal forward/default navigation keeps the existing trailing slide behavior.
- preserved performance intent: the hidden back detail/collection pages still stay unmounted unless the back-swipe preview path asks for them.

Fresh command evidence from this pass:

- XcodeBuildMCP simulator focused stale-history red tests on iPhone 17 Pro
  - failed before implementation: Home/Browse collection back landed on prior detail pages (`viet-phrase-airport-1`, `viet-phrase-airport-2`)
  - passed after implementation: `2` tests, `0` failures
- XcodeBuildMCP simulator focused transition policy red/green on iPhone 17 Pro
  - failed before implementation because there was no explicit route-transition policy
  - passed after implementation: `1` test, `0` failures
- XcodeBuildMCP simulator focused navigation/transition sweep on iPhone 17 Pro
  - passed: `15` tests, `0` failures
  - covered Home/Browse collection back chains, search-backed collection history, forward-stack restoration, back-preview routing, hidden page render gating, long-history slicing, button back transition edges, and swipe presentation layers
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T05-59-19-735Z_pid15747_0a8ed0fb.xcresult`
- broader XcodeBuildMCP `AppChromeTests` sweep
  - not clean: `226` passed, `4` failed
  - failures are content/copy audit expectations outside the touched navigation files (`testEntityDetailPagesHideGeneratedPlaceTemplateRows`, `testV22CityPagesExposeProductionHeadingsAndPhraseCards`, `testVietnameseMenuDetailPagesUseHandwrittenSourceCopy`, `testVietnameseMenuGuideCopyAuditFindsNoMissingOrGenericGuideFields`)
- local hygiene checks
  - `git diff --check -- native-ios/App/Views/AppShellView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
  - signing scan found no repo-visible personal team/provisioning settings in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- Physical iPhone Debug build/install from current `feature/admin-photo-backdrop-polish` working tree
  - build passed
  - install passed
  - launch was blocked because iOS reported the phone was locked
  - post-build signing scan stayed clean; personal signing remained local and was not written to repo files

## Current Admin Photo Backdrop Thermal Evidence

Current `feature/admin-photo-backdrop-polish` evidence from the 2026-05-30 listing-navigation thermal pass:

- root cause 1: opening each new listing recorded recent-page history through a broad `@Published` field on `LocalUserIntentStore`, invalidating offscreen Home/Browse/Saved surfaces while the user was only navigating detail pages
- root cause 2: listing photo backdrops used the plain SwiftUI asset image path, so newly generated portrait backdrops could decode/prepare on the render path instead of sharing the bounded prepared-image cache used by root photo backdrops
- root cause 3: city listing sheets recomputed "Mentioned Here" and "Compare Nearby" pick arrays repeatedly inside section rendering, including alias normalization and menu-item scans for page bodies that can be re-evaluated during navigation/scrolling
- root cause 4: Home stayed fully mounted behind deeper detail navigation even when it was not the current/back/forward route surface, so its large shelf tree could rebuild while the user was tapping through listing pages
- root cause 5: the previous detail page stayed mounted at opacity `0` between back-swipe gestures, so tapping through new listing pages could still keep one full offscreen listing sheet alive just to be ready for a possible back preview
- root cause 6: the root `Xin chào` article surface stayed mounted in the shell even when it was no longer current or the immediate back/forward preview route
- root cause 7: browse/category/menu collection pages stayed mounted at opacity `0` behind listing detail pages even when they were not visible and not needed for the current back-swipe preview; those collection pages include large section trees, photo backdrops, scroll geometry, and menu section tracking
- root cause 8: category/city/menu photo backdrop pages still rendered their large static backdrop through plain SwiftUI `Image(...)` instead of the prepared-image cache used by root and listing backdrops, so opening those collection pages could still decode/prepare large assets on the render path
- root cause 9: the shared backdrop preheater retained only a few prepared images, but the preparation work itself was unbounded; rapid listing taps could enqueue many large-image `preparingForDisplay()` jobs in parallel for pages the user had already left
- root cause 10: recent-page tracking stopped publishing broad SwiftUI invalidations, but still JSON-encoded and wrote the recent-page array to `UserDefaults` immediately on every detail tap; rapid listing browsing now updates the in-memory shelf immediately and batches the disk write until the burst settles or the app leaves the active scene phase
- root cause 11: the shared backdrop preheater kept the latest queued image names but drained them oldest-first, so rapid listing taps could still spend image-preparation work on stale pages before the newest visible page; the queue now drains newest-first while preserving the bounded latest-work policy
- root cause 12: opening a detail page canonicalized the same page ID once for navigation and again for recently viewed tracking; detail navigation now returns the already-resolved canonical phrase ID so recent-page recording can reuse it instead of repeating the lookup/cache path on every rapid listing tap
- root cause 13: Vietnamese menu detail pages resolved `viet-menu-*` IDs by repeatedly scanning the full menu item array across navigation, backdrop preheat, detail-page construction, and linked location menu rows; menu items are now indexed by item ID and detail page ID so rapid menu-listing taps reuse constant-time lookups without removing any menu/page functionality
- root cause 14: the generic detail-page resolver asked the SQLite phrase graph to resolve `viet-menu-*` pages before falling back to the menu and location-menu catalogs; rapid menu-listing taps now route menu-owned detail pages directly through the menu/location-menu catalogs and bypass the extra SQLite phrase-detail lookup
- root cause 15: menu-owned `viet-menu-*` routes still asked the SQLite phrase graph to canonicalize page IDs during navigation before the app recognized those pages as Vietnamese menu or location-menu pages; menu-owned route IDs now canonicalize through the menu catalogs first, eliminating SQLite canonical misses for rapid menu-listing taps
- root cause 16: related phrase rows/cards checked whether a destination was a self-link by canonicalizing both the destination and current page from SwiftUI body-derived properties; repeated sheet redraws could re-enter the SQLite canonical path for the same pair, so row navigation now uses a bounded pair-decision cache while preserving self-link suppression and related-page navigation
- root cause 17: the app-shell check for whether a detail route should render the special designed `Xin chào` article canonicalized the current page ID from the render path for every normal listing; the shell now answers direct/canonical `Xin chào` IDs cheaply and caches fallback alias decisions, so normal listing redraws do not repeatedly enter the SQLite canonical resolver just to reject the special route
- root cause 18: SwiftUI detail redraws resolved the same canonical `PhraseDetailPage` by re-entering `VietSQLitePhraseGraphRuntime.detailPage(withID:)` every time; the runtime cache avoided full reloads, but the shell still paid the resolver/lock path repeatedly, so `PhraseDetailPage.page(withID:)` now keeps a bounded resolved-page cache above the SQLite runtime while preserving generated, menu, location-menu, and static fallback behavior
- root cause 19: the detail-page render stack kept only the active page, or the active plus immediate back-preview page, but computed that small render set by filtering the entire detail history on every SwiftUI refresh; rapid listing taps can leave a long browser-style history, so render selection now slices only the visible suffix while preserving back/forward navigation history
- root cause 20: city listing "Mentioned Here" and "Compare Nearby" catalogs cached empty pick arrays for every eligible city page ID, so rapidly tapping through many city-backed listing pages could grow both static caches for pages with no cards; both catalogs now keep a bounded recent-page cache while preserving alias sharing and all existing cards
- root cause 21: inactive standard phrase article pages could still run their startup scroll/bottom-inset `.task` while mounted for hidden navigation states; the task is now gated by active-route state so inactive detail pages do not run delayed scroll work during rapid listing navigation
- root cause 22: browse category/card taps preheated category hero backdrops in `openDetailFromBrowse` and then immediately reached the generic detail preheat path with the same browse hero override; category masthead browse opens now keep the hero override but skip that duplicate generic shell preheat, while non-category browse opens and all non-browse detail opens keep their existing fallback preheat behavior
- root cause 23: browse category/card taps stored contextual hero image overrides in an unbounded app-shell `@State` dictionary; rapidly opening many category listing pages could retain one override per distinct page even though rendering is limited to the active/immediate preview pages, so the shell now keeps those overrides in a bounded recent-page cache while preserving category masthead overrides for recent back/forward navigation
- root cause 24: inactive but visible root/admin photo-backdrop preview surfaces could still run delayed startup scroll and bottom-inset validation work while mounted for navigation previews; that delayed work now requires the surface to be both active and visible, while immediate visual positioning for visible previews is preserved
- root cause 25: browse city/category thumbnail rendering still asked UIKit for image dimensions from the SwiftUI body for every focused thumbnail image, even though only two assets need custom crop focus; normal thumbnails now skip that `UIImage(named:)` size probe and render directly, preserving the two custom crops while avoiding extra asset lookup/decode pressure during rapid browsing
- root cause 26: browse city/category thumbnail selection still asked UIKit whether generated bundled hero/backdrop image names existed before SwiftUI rendered them; generated `Hero*` and `Backdrop*` browse assets now render directly while unknown/manual image names keep the old fallback existence check, avoiding extra `UIImage(named:)` probes during rapid page browsing
- root cause 27: inactive menu and standard browse collection pages could still run delayed section-tracking, section-jump settle, focus-restore, or bottom-inset tasks while mounted for hidden/back-preview navigation states; those deferred collection tasks now require active-route state, while active collection pages keep their scroll, focus, and section-jump behavior
- root cause 28: inactive listing, browse collection, and menu photo-backdrop pages could still publish scroll-geometry state, and inactive menu pages could still process section-frame/rail preferences while mounted only as hidden/back-preview surfaces; scroll-geometry and menu section preference tracking now require active-route state, preserving active page behavior while preventing extra state churn during rapid navigation
- root cause 29: generic detail navigation synchronously asked the SQLite phrase graph for a generated page's hero image name just to preheat a backdrop before the actual detail page loaded, duplicating database work on every new SQLite-backed listing tap; navigation preheat now uses only already-known cheap image names such as static authored backdrops, menu backdrops, or browse category overrides, while generated pages still preheat from the active page after its already-loaded detail model supplies the hero image
- root cause 30: `PhraseDetailView` rebuilt each detail page's `PhraseArticlePage` adapter from `body`, remapping sections and playback metadata on SwiftUI refreshes for the same page; the view now builds that adapter once during initialization and reuses it across redraws, preserving article layout while removing repeated per-refresh transformation work
- root cause 31: `PhraseArticleTemplateView` still derived visible article sections from `body`, re-filtering sections and re-running duplicate-hero text normalization during repeated SwiftUI redraws for the same page; the view now derives the visible section list once per page instance and reuses it across redraws
- root cause 32: saved/practice membership checks canonicalized page IDs even when their ID lists were empty or when the caller already supplied the exact canonical ID; those render-path checks now use empty/direct-ID fast paths before entering the SQLite canonical resolver, preserving alias support while avoiding unnecessary lookup work during detail redraws
- root cause 33: `PhraseArticleTemplateView` still canonicalized a home-hero morph identity from detail render paths even when no home morph was active; morph identity now returns the raw page ID when both morph IDs are nil and resolves once per view only when morph state exists
- root cause 34: inactive Home/root/admin photo-backdrop preview surfaces could still publish scroll-geometry state while mounted as navigation previews; those callbacks now require active and visible state, matching the existing delayed-task and listing/browse/menu scroll-geometry gates
- root cause 35: city listing articles reused cached "Mentioned Here" and "Compare Nearby" pick arrays, but still asked the catalogs to refilter those arrays by section ID from the article render path; each article page now builds grouped menu/related pick buckets once per page instance and the body reads those buckets directly
- root cause 36: phrase rows and breakdown cards resolved playable audio keys from SwiftUI row/card rendering, repeatedly entering `AudioAssetManifest` normalization and lookup work for deterministic phrase text during detail redraws; article pages now prepare row playback keys once per `PhraseArticleTemplateView` instance and rows read the prepared values
- root cause 37: location-card rows reused grouped pick buckets, but each row could still resolve linked-menu audio from `AudioAssetManifest` while rendering; the location-pick grouping step now prepares pick audio keys once per page instance so "Mentioned Here", "Compare Nearby", and trailing place/menu cards read stored keys
- root cause 38: listing/category/menu photo-backdrop pages queued hero-image preparation work for pages the user had already left; root/home still keep their small lookahead queue, but single-current-page detail, browse collection, and menu backdrops now use focused preheat mode so rapid page taps drop stale queued full-screen hero decodes and keep the newest active hero work
- root cause 39: location-card rows prepared linked-menu audio keys, but still looked up the linked menu item from SwiftUI row rendering just to tint the speaker button; location-pick grouping now prepares the audio tint alongside the audio key, so rows read stored playback presentation metadata instead of re-entering the menu catalog
- root cause 40: catalog and Explore rows still resolved playable audio from `PhraseCatalogItem.playbackAudioKey` during row rendering; catalog items now use a bounded playback-audio decision cache so repeated Browse/Home/Explore redraws reuse the same manifest result without re-entering `AudioAssetManifest`
- root cause 41: focused photo-backdrop preheat dropped stale queued work, but an already-popped full-screen hero image could still finish preparing and commit after the user had opened a newer page; focused preheat now tags in-flight work with the current request generation and rejects stale completed images while still committing the newest active hero
- root cause 42: saved/practice membership checks skipped empty lists and direct saved hits, but repeated unsaved misses with a non-empty saved list still canonicalized the same visible location/card page IDs on every redraw; `LocalUserIntentStore` now keeps bounded per-store membership caches and invalidates them when saved/practice IDs change
- root cause 43: category, city, and menu collection pages still requested their photo-backdrop preheat from page `.task`, after the route had already begun rendering; the app shell now preheats the collection backdrop before opening the route so first render is less likely to fall back to a cold full-screen image path
- root cause 44: Food/Drink menu rows still resolved exact item-name audio from `AudioAssetManifest` inside row rendering; `VietnameseMenuItem` now keeps a bounded playback-audio decision cache and menu rows/descriptors read the prepared item audio key
- root cause 45: a new SQLite-backed listing detail load still canonicalized the same page ID twice inside the detail resolver: once to find the canonical page and again inside `loadPhraseDetailPage(pageID:)`; the runtime now reuses the already-canonical ID and loads the canonical page directly, so rapid new-page tapping removes one SQL alias lookup per uncached listing detail
- root cause 46: each new SQLite-backed listing detail loaded sections with an N+1 query pattern: after the section list, it prepared one phrase-row query and one breakdown-row query per section, even for empty sections; section phrase rows and breakdown rows now load in two batched section-ID queries, reducing a representative new detail load from `15` prepared statements to at most `5`
- root cause 47: catalog and browse rows already hand navigation canonical `viet-phrase-*` page IDs, but `PhraseCatalog.canonicalPageID(forOpenablePageID:)` still entered the SQLite alias resolver before checking the already-loaded in-memory catalog; after Browse/Home/Search have warmed the catalog, known catalog page IDs now return directly from `itemsByPageID`, removing one SQLite alias lookup from rapid listing taps without forcing cold launch to build the full catalog early
- root cause 48: repeated listing page instances reused the same phrase rows and breakdown tokens, but row playback-audio decisions were only prepared per page instance; phrase options and breakdown tokens now keep bounded shared playback-audio decision caches so rapid page-to-page navigation reuses the same audio-manifest decisions without changing playback behavior
- root cause 49: Home can remain mounted as the back-preview surface while the user rapidly opens listing pages from Home, and its Recently viewed shelf rebuilt feature-card article adapters for the same still-visible recent pages on each route change; Recently viewed now uses a bounded feature-item cache so a new listing open adds only the new recent card adapter while unchanged recent cards are reused
- root cause 50: Home's Recently viewed shelf already receives canonical recent page IDs from `LocalUserIntentStore`, but it still used the alias-safe card helper and canonicalized each recent ID before reading cached feature cards; the Home-only recent-ID path now dedupes and limits store-owned canonical IDs directly while preserving the general alias-safe helper for external callers
- root cause 51: Browse/Home/catalog rows already know their canonical `viet-phrase-*` page IDs, but the SQLite detail loader did not know that the catalog had already proved those IDs canonical; the catalog fast path now seeds the SQLite runtime canonical cache so the first detail load for a known canonical listing page skips the extra SQL alias lookup, while alias page IDs still canonicalize once
- preserved UX: listing pages still use the static full-screen photo, pull-down sheet, tap-to-immersive reveal, bottom chrome backing, saved/practice state, and city/menu related cards

Fresh command evidence from this pass:

- App-code commit `291461ca8` on `feature/admin-photo-backdrop-polish`
  - root-cause 51 fix committed as `Seed canonical detail lookup cache`
  - physical iPhone build/install was attempted after commit, but Xcode reported no connected or available paired iPhone; phone proof is still pending for this exact commit
- XcodeBuildMCP simulator focused catalog-canonical detail-load regression on iPhone 17 Pro
  - failed before implementation because a known canonical catalog page still performed `1` repository canonical lookup instead of `0`
  - passed after implementation: `3` tests, `0` failures
  - covered catalog-seeded canonical detail loading, alias detail loading still canonicalizing once, and known catalog page IDs bypassing SQLite canonical lookup
  - result artifacts:
    - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-26-34-710Z_pid15747_b82ffc9e.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-27-55-317Z_pid15747_b1a7e173.xcresult`
- XcodeBuildMCP simulator focused SQLite/detail routing thermal slice on iPhone 17 Pro
  - passed: `9` tests, `0` failures
  - covered catalog-seeded canonical detail loading, alias canonicalization, batched section item loading, hero-image lookup staying lightweight, generated/static photo-backdrop eligibility, canonical detail-page cache reuse, known catalog canonical bypass, and menu-owned canonical bypass
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-29-44-973Z_pid15747_421bfe15.xcresult`
- local hygiene checks after root cause 51:
  - `git diff --check -- native-ios/App/Models/PhrasePage.swift native-ios/App/Models/VietSQLiteLanguagePackRepository.swift native-ios/Tests/SQLiteLanguagePackRepositoryTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install/launch from current `feature/admin-photo-backdrop-polish` head `0b5556336`
  - build passed
  - install passed
  - launch passed after install
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused `Xin chào`/photo-backdrop proof on iPhone 17 Pro
  - passed: `2` tests, `0` failures
  - covered static designed phrase pages resolving to photo-backdrop assets and listing photo-backdrop preheat eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-09-03-982Z_pid15747_e856b57c.xcresult`
- Physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` app-code commit `100e40bad`
  - build passed
  - install passed
  - launch passed after install
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused Home recently-viewed adapter-cache test on iPhone 17 Pro
  - failed before implementation because `HomeRecentlyViewedContent` had no cached feature-item resolution seam; the new regression proves the next rapid-listing open builds only `1` new article adapter instead of rebuilding the five unchanged recent cards
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T03-45-25-278Z_pid15747_95aac599.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-46-16-952Z_pid15747_a5309b2e.xcresult`
- XcodeBuildMCP simulator focused Home/back-preview navigation set on iPhone 17 Pro
  - passed: `6` tests, `0` failures
  - covered recently-viewed feature-item caching, six-card recent ordering, duplicate/missing-page skipping, root-surface render gating, Xin chào root-surface gating, and long detail-history render slicing
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-47-18-736Z_pid15747_7b6c7cfa.xcresult`
- XcodeBuildMCP simulator focused route/detail/audio thermal regression set on iPhone 17 Pro
  - passed: `15` tests, `0` failures
  - covered Home recent-card adapter caching, detail article-template reuse, visible-section reuse, location-pick grouping, row/breakdown audio caching, catalog/menu audio caches, known-catalog canonical bypass, generated-page preheat staying lightweight, focused backdrop stale-work rejection, and recent-page store invalidation/persist behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-48-12-721Z_pid15747_fff35e4e.xcresult`
- XcodeBuildMCP simulator focused SQLite/photo-backdrop regression set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered one-canonicalization detail loads, batched section item loading, generated phrase backdrop eligibility, and static designed phrase-page backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-48-50-984Z_pid15747_2b5783da.xcresult`
- local hygiene checks after the Home recent-card adapter cache fix:
  - `git diff --check -- native-ios/App/Views/AppShellView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` app-code commit `a1929cbc5`, explicitly built from the feature worktree after verifying the default phone helper can otherwise target the main checkout
  - build passed
  - install passed
  - launch passed after install
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused phrase-row audio cache test on iPhone 17 Pro
  - failed before implementation because `testPhraseRowPlaybackAudioResolutionCachesAcrossPageInstances` observed `65` audio-manifest lookups after repeated fresh row/token resolutions instead of retaining the first-page decision count of `5`
  - passed after implementation with real bundled audio examples: `1` test, `0` failures
  - result artifacts:
    - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-14-20-565Z_pid15747_3a69040f.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-20-39-075Z_pid15747_ffdace87.xcresult`
- XcodeBuildMCP simulator focused route/detail/audio thermal regression set on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered shared phrase-row audio caching, per-page row audio preparation, location-pick audio preparation, catalog/menu audio caches, known-catalog canonical bypass, one-canonicalization detail loads, batched section item loading, lightweight hero-image lookup, and generated-page preheat staying lightweight
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-22-24-861Z_pid15747_fdbdb4c5.xcresult`
- local hygiene checks after the shared phrase-row audio cache fix:
  - `git diff --check -- native-ios/App/Models/PhrasePage.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- XcodeBuildMCP simulator focused known-catalog canonical fast-path test on iPhone 17 Pro
  - failed before implementation because `testKnownCatalogPageIDsBypassSQLiteCanonicalLookup` observed `1` SQLite canonical lookup for a known catalog page ID after the catalog had already been loaded
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-00-22-137Z_pid15747_36e5465e.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-01-55-173Z_pid15747_e4ad95e3.xcresult`
- XcodeBuildMCP simulator focused route/canonical/detail regression set on iPhone 17 Pro
  - passed: `9` tests, `0` failures
  - covered known catalog page IDs bypassing SQLite canonical lookup, menu-owned canonical bypass, resolved detail-page reuse, recent-page canonical recording, generated-page preheat staying lightweight, designed Xin chào special-route caching, one-canonicalization detail loads, batched section item loading, and hero-image lookup staying lightweight
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T03-03-42-331Z_pid15747_e2ff36c4.xcresult`
- local hygiene checks after the known-catalog canonical fast-path fix:
  - `git diff --check -- native-ios/App/Models/PhrasePage.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `f2db535c3`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- Visual simulator proof for the current `feature/admin-photo-backdrop-polish` head `dc9157f57`
  - launched `SpeakLocalNative` on iPhone 17 Pro Simulator with `--detail-page viet-phrase-polite-1`
  - confirmed `Xin chào` renders with `BackdropPhraseGreetingCafeDoorway`, a lowered rounded content sheet, visible photo area, and normal bottom chrome backing instead of the old single static hero layer
  - screenshot: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_86deb15a-000f-419c-8ba3-e2e70468f280.jpg`
- Physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` commit `dc9157f57`
  - build passed
  - install passed
  - launch passed after install
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- focused failing tests were added before the fixes and then passed after implementation:
  - `AppChromeTests/testRenderedDetailPagesDoNotScanEntireLongHistory`
  - `AppChromeTests/testMenuDetailNavigationBypassesSQLiteCanonicalLookup`
  - `AppChromeTests/testPhraseRowNavigationCachesRepeatedCanonicalPairChecks`
  - `AppChromeTests/testMenuDetailPagesBypassSQLitePhraseGraphLookup`
  - `AppChromeTests/testVietnameseMenuDetailLookupsUseIndexedItems`
  - `AppChromeTests/testForwardDetailNavigationReturnsCanonicalIDForRecentRecording`
  - `LocalUserIntentStoreTests/testRecentPagesCanRecordAlreadyCanonicalPageID`
  - `LocalUserIntentStoreTests/testRecentPagesPersistAfterExplicitFlushInsteadOfEveryTap`
  - `AppChromeTests/testAdminBackdropPreheatPlanKeepsLatestQueuedWorkBounded`
  - `AppChromeTests/testAdminBackdropPreheatPlanDrainsNewestQueuedWorkFirst`
  - `LocalUserIntentStoreTests/testRecordingRecentPageDoesNotPublishStoreWideInvalidation`
  - `LocalUserIntentStoreTests/testSavedPageToggleStillPublishesStoreChanges`
  - `AppChromeTests/testPhrasePhotoBackdropPreheatPolicyOnlyWarmsEligibleListingHero`
  - `AppChromeTests/testLocationMenuPicksCacheCanonicalCityLookups`
  - `AppChromeTests/testLocationRelatedPicksCacheCanonicalCityLookups`
  - `AppChromeTests/testLocationPickCachesStayBoundedDuringRapidCityBrowsing`
  - `AppChromeTests/testRootSurfacesRenderOnlyWhenCurrentBackOrForwardRouteNeedsThem`
  - `AppChromeTests/testRootXinChaoSurfaceRendersOnlyWhenCurrentBackOrForwardRouteNeedsIt`
  - `AppChromeTests/testHiddenBackDetailPageCanStayUnmountedUntilBackSwipePreview`
  - `AppChromeTests/testHiddenBackBrowseCollectionCanStayUnmountedUntilBackSwipePreview`
  - `AppChromeTests/testBrowseCollectionsKeepOnlyVisibleRouteUntilBackSwipePreview`
  - `AppChromeTests/testBrowseCollectionPhotoBackdropPreheatPolicyWarmsOnlyPhotoBackdrops`
  - `AppChromeTests/testVietnameseMenuPhotoBackdropPreheatPolicyWarmsOnlyPhotoBackdrops`
  - `SQLiteLanguagePackRepositoryTests/testRuntimeHeroImageLookupDoesNotLoadFullDetailPage`
  - `AppChromeTests/testPhraseArticleStandardScrollTaskRunsOnlyForActivePages`
  - `AppChromeTests/testBrowseDetailHeroImageOverrideKeepsOnlyCategoryMastheads`
  - `AppChromeTests/testBrowseDetailGenericPreheatSkipsOnlyAfterCategoryOverride`
  - `AppChromeTests/testBrowseDetailHeroOverrideCacheStaysBoundedDuringRapidCategoryBrowsing`
  - `AppChromeTests/testAdminPhotoBackdropDelayedTaskRunsOnlyForActiveVisiblePages`
  - `AppChromeTests/testBrowseFocusedAssetImagesReadSizesOnlyForCustomFocusAssets`
  - `AppChromeTests/testBrowseImageAssetPolicyTrustsGeneratedAssetsWithoutExistenceProbe`
  - `AppChromeTests/testInactiveCollectionPagesSkipDeferredScrollTasks`
  - `AppChromeTests/testInactivePagesSkipScrollGeometryAndPreferenceTracking`
  - `AppChromeTests/testDetailNavigationPreheatSkipsSQLiteHeroLookupForGeneratedPages`
  - `AppChromeTests/testPhraseDetailViewBuildsArticleTemplateOncePerPageInstance`
  - `AppChromeTests/testPhraseArticleTemplateBuildsVisibleSectionsOncePerPageInstance`
  - `LocalUserIntentStoreTests/testSavedMembershipSkipsCanonicalLookupForEmptyAndDirectCanonicalIDs`
  - `AppChromeTests/testPhraseArticleMorphPolicySkipsCanonicalLookupWhenNoHomeMorphIsActive`
  - `AppChromeTests/testAdminPhotoBackdropDelayedTaskRunsOnlyForActiveVisiblePages` was extended to cover inactive scroll-geometry gating
  - `AppChromeTests/testPhraseArticleTemplateGroupsLocationPicksOncePerPageInstance`
  - `AppChromeTests/testPhraseArticleTemplatePreparesRowPlaybackAudioOncePerPageInstance`
  - `AppChromeTests/testPhraseArticleLocationPickGroupsPrepareAudioKeysOncePerPageInstance`
  - `AppChromeTests/testFocusedDetailBackdropPreheatDropsStaleQueuedHeroWork`
  - `AppChromeTests/testPhraseArticleLocationPickGroupsPrepareAudioTintOncePerPageInstance`
  - `AppChromeTests/testPhraseCatalogItemsCachePlaybackAudioAcrossRepeatedRowRendering`
  - `AppChromeTests/testFocusedBackdropPreheaterRejectsStaleInFlightHeroWork`
  - `LocalUserIntentStoreTests/testSavedMembershipCachesRepeatedUnsavedMissesWhenSavedListIsNonEmpty`
  - `AppChromeTests/testBrowseCollectionRoutePreheatWarmsBackdropBeforeNavigation`
  - `AppChromeTests/testVietnameseMenuItemsCachePlaybackAudioAcrossRepeatedRowRendering`
- XcodeBuildMCP simulator focused collection-route preheat set on iPhone 17 Pro
  - failed before implementation because `AppShellView.browseCollectionBackdropPreheatImageNames(for:)` did not exist and collection routes could only preheat from page tasks
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-40-59-946Z_pid15747_1da1cf51.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-43-20-739Z_pid15747_c91c1dc4.xcresult`
- XcodeBuildMCP simulator focused Vietnamese menu-row audio cache set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuItem` had no playback-audio cache/reset seam and menu rows read the audio manifest directly
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-45-50-614Z_pid15747_91819910.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-47-29-255Z_pid15747_3a096ca0.xcresult`
- XcodeBuildMCP simulator focused collection/menu thermal-regression set on iPhone 17 Pro
  - passed: `11` tests, `0` failures
  - covered early collection-route backdrop preheat, Vietnamese menu-row audio caching, catalog row audio caching, stale in-flight focused backdrop rejection, focused queued-backdrop replacement, browse/menu photo-backdrop preheat policy, browse detail override policy/cache, and saved unsaved-miss caching
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-48-28-655Z_pid15747_c656195d.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `89fe3f545`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused SQLite detail-load canonicalization set on iPhone 17 Pro
  - failed before implementation because `testRuntimeDetailPageLoadCanonicalizesOnlyOncePerNewPage` observed `2` repository canonical lookups for one new SQLite-backed detail load instead of `1`
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log for missing counter seam: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T02-11-01-142Z_pid15747_c9aa6548.log`
    - red result bundle for duplicate canonicalization: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-12-33-144Z_pid15747_d77df48e.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-14-26-013Z_pid15747_176a6171.xcresult`
- XcodeBuildMCP simulator focused SQLite/detail-navigation regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered one-canonicalization detail loads, hero-image lookup staying lightweight, SQLite search/detail/history routing, resolved-page reuse, bounded SQLite caches, generated-page preheat skipping hero lookup, and menu detail/canonical bypasses
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-16-37-237Z_pid15747_409271eb.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `b29fd26c1`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused SQLite section-item batching set on iPhone 17 Pro
  - failed before implementation because `testRuntimeDetailPageLoadBatchesSectionItemQueriesPerNewPage` observed `15` prepared statements for one new SQLite-backed detail load instead of the batched target of at most `5`
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log for missing prepared-statement counter seam: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T02-25-24-958Z_pid15747_4ce79046.log`
    - red result bundle for N+1 section-item statements: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-26-37-202Z_pid15747_9591fe2e.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-28-11-185Z_pid15747_9917e116.xcresult`
- XcodeBuildMCP simulator focused SQLite/detail-loader regression set on iPhone 17 Pro
  - passed: `9` tests, `0` failures
  - covered batched section item loading, one-canonicalization detail loads, hero-image lookup staying lightweight, SQLite search/detail/history routing, resolved-page reuse, bounded SQLite caches, generated-page preheat skipping hero lookup, and menu detail/canonical bypasses
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-31-13-030Z_pid15747_65ffce74.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `636b7ce40`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused catalog-row audio cache set on iPhone 17 Pro
  - failed before implementation because `PhraseCatalogItem` had no playback-audio resolution cache reset seam and repeated row reads had no cache
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-14-33-491Z_pid15747_ff4552d3.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-15-32-220Z_pid15747_b1be77e4.xcresult`
- XcodeBuildMCP simulator focused in-flight backdrop preheat set on iPhone 17 Pro
  - failed before implementation because `AdminBackdropImagePreheater` had no reset/injected-preparer test seam and no stale in-flight focused-work rejection
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-19-08-177Z_pid15747_e122555d.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-21-38-490Z_pid15747_262eaa93.xcresult`
- XcodeBuildMCP simulator focused saved-membership miss cache set on iPhone 17 Pro
  - failed before implementation because two visible unsaved related-card IDs caused `20` canonical lookups over ten redraw-style saved-state passes
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-24-06-049Z_pid15747_240fbfc5.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-26-50-631Z_pid15747_cafb31ac.xcresult`
- XcodeBuildMCP simulator focused thermal-regression set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered catalog row audio caching, article row audio preparation, stale in-flight focused backdrop rejection, focused queued-backdrop replacement, bounded/latest/newest-first preheat policy, saved direct fast path, saved unsaved-miss caching, saved publish behavior, and saved menu-item persistence
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-27-44-484Z_pid15747_bc3d3df8.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `2b52b7c89`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused location-pick audio-tint preparation set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuCatalog` had no item lookup counter and `LocationMenuPick` had no prepared `audioTintName`
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T00-51-04-446Z_pid15747_8e6b17cd.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-52-33-300Z_pid15747_3c0a612c.xcresult`
- XcodeBuildMCP simulator focused location-card playback regression set on iPhone 17 Pro
  - passed: `7` tests, `0` failures
  - covered prepared location-card tint, prepared location-card audio, per-page grouped Mentioned/Related picks, bounded pick caches, canonical city lookup caching, and existing Lusine saved-trip card behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-53-15-433Z_pid15747_6515cfee.xcresult`
- local hygiene checks after the location-pick audio-tint preparation fix:
  - `git diff --check -- native-ios/App/Models/VietnameseMenuCatalog.swift native-ios/App/Views/PhraseListingView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `ca166a859`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused detail-backdrop preheat set on iPhone 17 Pro
  - failed before implementation because `AdminBackdropImagePreheatPlan.focusedQueuedImageNames(...)` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T00-38-27-020Z_pid15747_ec606b65.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-42-46-255Z_pid15747_d870356f.xcresult`
- XcodeBuildMCP simulator focused photo-backdrop preheat regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered stale focused detail queue replacement, root/home selected-plus-lookahead behavior, bounded latest-work behavior, newest-first queue draining, and phrase/browse/menu photo-backdrop preheat eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-43-31-173Z_pid15747_bd4eb3b9.xcresult`
- local hygiene checks after the focused listing-backdrop preheat fix:
  - `git diff --check -- native-ios/App/Views/AdminPhotoBackdropSurfaceView.swift native-ios/App/Views/AppShellView.swift native-ios/App/Views/BrowseCollectionPageView.swift native-ios/App/Views/PhraseListingView.swift native-ios/App/Views/VietnameseMenuPageView.swift native-ios/Tests/AppChromeTests.swift docs/operations/LATEST_VALIDATION.md` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `ee876f443`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- local hygiene checks after the detail redraw and saved-membership fixes:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Models/AppChrome.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the inactive root backdrop redraw fixes:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Views/AppShellView.swift native-ios/App/Views/AdminPhotoBackdropSurfaceView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the location-pick grouping fix:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Models/VietnameseMenuCatalog.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the row playback-audio preparation fix:
  - `git diff --check -- native-ios/App/Models/AudioAssetManifest.swift native-ios/App/Models/PhrasePage.swift native-ios/App/Views/PhraseListingView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the location-pick audio preparation fix:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Models/VietnameseMenuCatalog.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- XcodeBuildMCP simulator focused location-pick audio preparation set on iPhone 17 Pro
  - failed before implementation because `LocationMenuPick.resolvingAudioKey()` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T00-12-25-437Z_pid15747_a511370a.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-13-42-358Z_pid15747_dd0c798a.xcresult`
- XcodeBuildMCP simulator focused location-card/audio regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered location-pick audio preparation, grouped Mentioned/Related card reuse, article row audio preparation, calibrated city menu picks, menu/related pick canonical lookup caching, bounded rapid city-browsing caches, and Vietnamese menu name audio
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-14-15-608Z_pid15747_66c5804f.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `0d45202f4`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused row playback-audio preparation set on iPhone 17 Pro
  - failed before implementation because `AudioAssetManifest` had no lookup counter and `PhraseArticlePlaybackAudioResolver` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-58-41-166Z_pid15747_f43ff2af.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-04-55-130Z_pid15747_970f7c3e.xcresult`
- XcodeBuildMCP simulator focused article/audio regression set on iPhone 17 Pro
  - passed: `9` tests, `0` failures
  - covered per-article row playback-audio preparation, visible-section derivation reuse, detail article-adapter reuse, location-pick grouping, Tier 1 visible audio keys, designed phrase exact-text audio fallback, `Xin chào` row audio reuse, all phrase option audio resolution, and bundled-file validation for resolved phrase option audio
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-06-11-757Z_pid15747_cbf2144b.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `6dd111d13`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused location-pick grouping set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleLocationPickGroups` and catalog section-filter counters did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-36-16-052Z_pid15747_ba70322e.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-38-48-359Z_pid15747_106470a1.xcresult`
- XcodeBuildMCP simulator focused location-card/redraw regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered per-page grouping for Mentioned/Related cards, visible-section derivation reuse, detail article-adapter reuse, menu/related pick cache canonicalization, bounded rapid city-browsing caches, Han Market related-card routing, and V2.2 related-place card exposure
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-39-42-358Z_pid15747_02d47361.xcresult`
- Corrected physical iPhone Debug build/install explicitly from worktree root `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/admin-photo-backdrop-polish` at branch HEAD `3ea7487f0` with app-code commit `7a7f0dcbe`
  - this corrected the phone-build root after Jojo observed the old static `Xin chào` screen; the phone helper defaults to the canonical app-family checkout unless `SPEAKLOCAL_REPO_ROOT` is set
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `7a7f0dcbe`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused morph-policy set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleMorphPolicy` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-09-52-706Z_pid15747_f442da87.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-10-55-774Z_pid15747_5e8cce2a.xcresult`
- XcodeBuildMCP simulator focused inactive root/admin scroll-geometry set on iPhone 17 Pro
  - failed before implementation because `AdminPhotoBackdropTaskPolicy.shouldApplyScrollGeometry` and `HomePhotoBackdropTaskPolicy` did not exist
  - passed after implementation as part of the focused regression set below
  - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-13-25-315Z_pid15747_06d3d2e7.log`
- XcodeBuildMCP simulator focused inactive root backdrop redraw regression set on iPhone 17 Pro
  - passed: `7` tests, `0` failures
  - covered inactive admin/root backdrop delayed-task and scroll-geometry gating, no-morph detail identity fast path, visible-section derivation reuse, article-adapter reuse, generated detail preheat SQLite bypass, phrase photo-backdrop preheat eligibility, inactive listing/browse/menu scroll-geometry gating, and Home backdrop activation behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-17-12-997Z_pid15747_d0a9e12f.xcresult`
- XcodeBuildMCP simulator visual build/run for `Xin chào` on iPhone 17 Pro from app-code commit `6bc2f3bcc`
  - build passed
  - launch passed with `--detail-page viet-polite-hello`
  - screenshot confirmed the current branch opens `Xin chào` with the rounded pull-down content sheet over the photo backdrop
  - build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/build_run_sim_2026-05-30T23-24-11-471Z_pid15747_8e5815bc.log`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `6bc2f3bcc`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - a follow-up force-launch with existing-process termination was also blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused visible-section derivation set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleTemplateView.resetVisibleSectionsBuildCountForTesting` and `PhraseArticleTemplateView.visibleSectionsBuildCountForTesting` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-53-27-063Z_pid15747_85228af8.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-56-07-091Z_pid15747_12de26f1.xcresult`
- XcodeBuildMCP simulator focused saved-membership canonical-lookup set on iPhone 17 Pro
  - failed before implementation: `LocalUserIntentStoreTests/testSavedMembershipSkipsCanonicalLookupForEmptyAndDirectCanonicalIDs` observed one SQLite canonical lookup for an empty Saved list and one for an already-canonical saved ID
  - passed after implementation as part of the focused regression set below
  - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-59-31-334Z_pid15747_1f513330.xcresult`
- XcodeBuildMCP simulator focused detail redraw/saved-membership regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered visible-section derivation reuse, article-adapter reuse, generated detail preheat SQLite bypass, phrase photo-backdrop preheat eligibility, saved-membership empty/direct-canonical lookup fast paths, saved toggle invalidation, saved/practice persistence, and saved menu-item behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-01-34-500Z_pid15747_2b4c72b0.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `c4e597907`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- local hygiene checks after the detail article-adapter fix:
  - `git diff --check -- native-ios/App/Models/PhrasePage.swift native-ios/App/Views/PhraseDetailView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- XcodeBuildMCP simulator focused detail article-adapter set on iPhone 17 Pro
  - failed before implementation because `PhraseDetailPage.resetArticleTemplateBuildCountForTesting` and `PhraseDetailPage.articleTemplateBuildCountForTesting` did not exist
  - passed after implementation as part of the focused performance/backdrop set below
  - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-33-39-105Z_pid15747_28b1eae4.log`
- XcodeBuildMCP simulator focused performance/backdrop set with article-adapter reuse on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered generated detail navigation skipping SQLite hero-name lookup for preheat, inactive standard article task gating, phrase photo-backdrop preheat eligibility, and detail article-adapter reuse across repeated body refreshes
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-40-52-245Z_pid15747_d6976ca6.xcresult`
- XcodeBuildMCP broader `AppChromeTests` sweep on iPhone 17 Pro
  - not clean: `208` tests passed and `4` tests failed
  - failures are content/fixture expectation drift unrelated to the detail article-adapter code path: entity template row hiding, V2.2 production heading/phrase-card expectations, handwritten menu source copy expectations, and one generic menu guide-copy audit row
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-40-24-498Z_pid15747_8a700f42.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `39fcfe557`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused detail-navigation hero-preheat set on iPhone 17 Pro
  - failed before implementation because `AppShellView.detailBackdropPreheatImageNames(pageID:heroImageNameOverride:)` and `VietSQLitePhraseGraphRuntime.heroImageNameLookupCountForTesting` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-22-19-924Z_pid15747_dc3d7592.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-24-47-367Z_pid15747_7d06b02b.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with detail-navigation hero-preheat SQLite bypass on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered generated detail navigation skipping SQLite hero-name lookup for preheat, static authored preheat preservation, phrase/category/menu backdrop preheat policies, bounded SQLite/search/detail caches, inactive listing/browse/menu scroll-geometry gating, inactive collection deferred-task gating, generated browse asset probe bypasses, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-25-25-867Z_pid15747_7ad03d56.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `1a6248f58`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused inactive scroll-geometry/preference-tracking set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleTaskPolicy`, `BrowseCollectionTaskPolicy`, and `VietnameseMenuTaskPolicy` had no policy seam for inactive scroll-geometry or menu section-preference callbacks
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-02-09-403Z_pid15747_f17c2e77.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-03-35-668Z_pid15747_3765bbfa.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with inactive scroll-geometry/preference gating on iPhone 17 Pro
  - passed: `14` tests, `0` failures
  - covered inactive listing/browse/menu photo-backdrop scroll-geometry gating, inactive menu section-preference gating, inactive collection deferred-task gating, active+visible admin/root backdrop delayed-task gating, inactive standard article task gating, generated browse hero/backdrop image names skipping UIKit existence probes, normal browse thumbnails skipping UIKit image-size reads, visible-only browse collection mounting, bounded category browse hero overrides, bounded city pick caches, phrase/category backdrop eligibility, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-04-23-090Z_pid15747_89c97878.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `71c706b4b`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused inactive collection deferred-task set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuTaskPolicy` and `BrowseCollectionTaskPolicy` did not exist, and the affected tasks were keyed without an active-route gate
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T21-51-57-118Z_pid15747_0abb7eb3.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-53-15-492Z_pid15747_ea811de1.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with inactive collection task gating on iPhone 17 Pro
  - passed: `13` tests, `0` failures
  - covered inactive menu/standard browse collection task gating, active+visible admin/root backdrop delayed-task gating, inactive standard article task gating, generated browse hero/backdrop image names skipping UIKit existence probes, normal browse thumbnails skipping UIKit image-size reads, visible-only browse collection mounting, bounded category browse hero overrides, bounded city pick caches, phrase/category backdrop eligibility, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-54-16-872Z_pid15747_3099a719.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `67bf033f7`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused browse generated-image existence-probe set on iPhone 17 Pro
  - failed before implementation because `BrowseImageAssetPolicy` did not exist and browse rows always had to call through the `BrowseImageAssetCache.exists` seam for generated image names
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T21-36-42-474Z_pid15747_f7147d4e.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-38-35-307Z_pid15747_24f0e6e0.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with generated-image existence-probe bypass on iPhone 17 Pro
  - passed: `11` tests, `0` failures
  - covered generated browse hero/backdrop image names skipping UIKit existence probes, normal browse thumbnails skipping UIKit image-size reads, active+visible admin/root backdrop delayed-task gating, bounded category browse hero overrides, duplicate browse category preheat avoidance, bounded city pick caches, listing photo-backdrop preheat policy, phrase/category backdrop eligibility, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-39-44-450Z_pid15747_796c827f.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `950ffc04b`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- xcodebuild simulator focused browse thumbnail size-probe set on iPhone 17 Pro
  - failed before implementation because `BrowseFocusedAssetImagePolicy` did not exist and normal thumbnails had no policy seam to skip UIKit size reads
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-16-41-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-17-53-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with browse thumbnail size-probe gating on iPhone 17 Pro
  - passed: `26` tests, `0` failures
  - covered normal browse thumbnails skipping UIKit image-size reads, active+visible admin/root backdrop delayed-task gating, bounded category browse hero overrides, inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, static designed `Xin chào` photo-backdrop eligibility, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-18-54-+0700.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `01682364a`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- xcodebuild simulator focused admin/root photo-backdrop delayed-task set on iPhone 17 Pro
  - failed before implementation because `AdminPhotoBackdropTaskPolicy` did not exist
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-53-39-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-01-54-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with active+visible root photo-backdrop task gating on iPhone 17 Pro
  - passed: `25` tests, `0` failures
  - covered active+visible admin/root backdrop delayed-task gating, bounded category browse hero overrides, inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, static designed `Xin chào` photo-backdrop eligibility, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-02-38-+0700.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `1889ce305`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- xcodebuild simulator focused inactive phrase-article task set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleTaskPolicy` did not exist
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-12-54-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-13-42-+0700.xcresult`
- xcodebuild simulator focused browse detail preheat policy set on iPhone 17 Pro
  - failed before implementation because `AppShellView` had no browse hero override or generic-preheat policy seam
  - passed after implementation: `2` tests, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-35-41-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-36-57-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with inactive-task gating and duplicate browse-preheat avoidance on iPhone 17 Pro
  - passed: `27` tests, `0` failures
  - covered inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, V2.2 Mentioned Here/related cards, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-37-56-+0700.xcresult`
- xcodebuild simulator focused browse hero override cache-growth set on iPhone 17 Pro
  - failed before implementation because `AppShellBrowseDetailHeroOverrideCache` did not exist
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-45-10-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-46-45-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with bounded browse hero overrides on iPhone 17 Pro
  - passed: `24` tests, `0` failures
  - covered bounded category browse hero overrides, inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-47-51-+0700.xcresult`
- xcodebuild simulator focused canonical recent-page reuse set on iPhone 17 Pro
  - passed: `2` tests, `0` failures
  - covered returning the canonical detail ID from navigation and recording an already-canonical recent page without re-running the page canonicalization path
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-12-44-+0700.xcresult`
- xcodebuild simulator focused thermal set with canonical recent-page reuse on iPhone 17 Pro
  - passed: `20` tests, `0` failures
  - covered canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-13-36-+0700.xcresult`
- xcodebuild simulator focused Vietnamese menu indexed lookup set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuCatalog` had no indexed item lookup/testing surface
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-33-47-+0700.xcresult`
- xcodebuild simulator focused thermal set with Vietnamese menu indexed lookups on iPhone 17 Pro
  - passed: `22` tests, `0` failures
  - covered indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-34-41-+0700.xcresult`
- xcodebuild simulator focused menu-detail SQLite-bypass set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testMenuDetailPagesBypassSQLitePhraseGraphLookup` counted `2` SQLite detail-page resolver calls for two menu-owned pages
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-48-05-+0700.xcresult`
- xcodebuild simulator focused thermal set with menu-detail SQLite bypass on iPhone 17 Pro
  - passed: `23` tests, `0` failures
  - covered menu-owned detail pages bypassing the SQLite phrase-detail resolver, indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-48-55-+0700.xcresult`
- xcodebuild simulator focused menu-route SQLite-canonical bypass set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testMenuDetailNavigationBypassesSQLiteCanonicalLookup` counted `4` SQLite canonical resolver calls while opening two menu-owned pages
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_00-38-19-+0700.xcresult`
- xcodebuild simulator focused thermal set with menu-route SQLite-canonical bypass on iPhone 17 Pro
  - passed: `24` tests, `0` failures
  - covered menu-owned route navigation bypassing the SQLite canonical resolver, menu-owned detail pages bypassing the SQLite phrase-detail resolver, indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_00-39-38-+0700.xcresult`
- xcodebuild simulator focused phrase-row navigation cache set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testPhraseRowNavigationCachesRepeatedCanonicalPairChecks` showed repeated row body checks pushed SQLite canonical lookup count from `2` to `26`
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_01-08-55-+0700.xcresult`
- XcodeBuildMCP simulator focused designed-`Xin chào` route set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testDesignedXinChaoCheckAvoidsRepeatedCanonicalLookupForNormalListings` showed repeated normal-listing checks pushed SQLite canonical lookup count from `2` to `26`
  - passed after implementation: `4` tests, `0` failures
  - covered the designed `Xin chào` direct/canonical route check, normal listing rejection without repeated canonical resolver calls, static designed phrase pages using photo-backdrop layout, and listing backdrop preheat eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-31-40-871Z_pid15747_4c6eec00.xcresult`
- XcodeBuildMCP simulator focused canonical detail-page resolved-cache set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testCanonicalDetailPagesReuseResolvedPageWithoutRepeatedSQLiteLookup` showed repeated same-page resolution pushed SQLite detail resolver count from `1` to `13`
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-52-47-725Z_pid15747_abfc4edf.xcresult`
- xcodebuild simulator focused long detail-history render set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testRenderedDetailPagesDoNotScanEntireLongHistory` showed the detail renderer inspecting all `7` history entries to render only `1` active page or `2` active/back-preview pages
  - passed after implementation: `1` test, `0` failures; active-page rendering now checks `1` candidate and back-preview rendering checks `2`
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-28-00-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with long-history suffix rendering on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered long-history detail render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-29-52-+0700.xcresult`
- xcodebuild simulator focused city-pick cache-growth set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testLocationPickCachesStayBoundedDuringRapidCityBrowsing` showed both city pick caches growing to `108` entries while the intended cap was `96`
  - passed after implementation: `6` tests, `0` failures
  - covered bounded city menu/related pick caches, canonical city alias sharing, existing V2.2 Mentioned Here cards, and existing V2.2 Compare Nearby cards
  - failed result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-52-12-+0700.xcresult`
  - passed result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-53-55-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with bounded city-pick caches on iPhone 17 Pro
  - passed: `22` tests, `0` failures
  - covered bounded city pick caches, city-card alias behavior, long-history detail render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-54-54-+0700.xcresult`
- repo hygiene after bounded city-pick cache fix
  - `git diff --check`: passed
  - `node scripts/guard-native-only.js`: passed
  - signing scan found no repo-visible personal signing values; only generic project `CODE_SIGN_IDENTITY = "iPhone Developer"` entries remain
- XcodeBuildMCP simulator focused thermal set with resolved detail-page cache on iPhone 17 Pro
  - passed: `23` tests, `0` failures
  - covered resolved canonical detail-page reuse, menu-owned detail lookup bypass, menu route canonical bypass, designed `Xin chào` route check, phrase-row canonical pair caching, hidden detail/collection mounting, root-surface gating, listing/category/menu backdrop preheat policies, bounded/newest-first image preheat work, indexed menu item lookup, SQLite hero-image lightweight lookup, default SQLite runtime behavior, and legacy ID canonicalization
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-53-51-679Z_pid15747_ee0f3668.xcresult`
- XcodeBuildMCP simulator local-intent thermal set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered batched recent-page disk persistence, recording already-canonical recent pages, suppressing broad invalidation while recording recents, and preserving saved-page invalidation
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-54-16-891Z_pid15747_72f59336.xcresult`
- XcodeBuildMCP simulator fixture/runtime compatibility set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered SQLite-disabled static authored pages, default SQLite runtime detail resolution, and legacy-home-ID canonicalization after adding the resolved-page cache
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-55-05-780Z_pid15747_ec4e8893.xcresult`
- XcodeBuildMCP simulator build/run smoke on iPhone 17 Pro
  - current `Xin chào` deep-link smoke passed for `--detail-page viet-phrase-polite-1`
  - current Home featured `Xin chào` tap smoke passed from the Home card
  - current branch shows the pull-down content sheet over `BackdropPhraseGreetingCafeDoorway`, not the old static Ha Long masthead layout
- xcodebuild simulator focused thermal set with phrase-row navigation cache on iPhone 17 Pro
  - passed: `22` tests, `0` failures
  - covered repeated phrase-row canonical pair caching, phrase-row self-link suppression, menu-owned route navigation bypassing the SQLite canonical resolver, menu-owned detail pages bypassing the SQLite phrase-detail resolver, indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_01-10-06-+0700.xcresult`
- xcodebuild simulator focused local-intent thermal set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered batched recent-page disk persistence, recording already-canonical recent pages, suppressing broad invalidation while recording recents, and preserving saved-page invalidation
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_01-11-09-+0700.xcresult`
- XcodeBuildMCP simulator focused recent-page batched-persist thermal set on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered batched recent-page disk persistence, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T14-49-34-348Z_pid15747_b555ea44.xcresult`
- xcodebuild simulator focused newest-first preheat thermal set on iPhone 17 Pro
  - passed: `18` tests, `0` failures
  - covered newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_22-11-13-+0700.xcresult`
- XcodeBuildMCP simulator focused serialized-preheat thermal set on iPhone 17 Pro
  - passed: `16` tests, `0` failures
  - covered bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T14-23-54-799Z_pid15747_11f74f08.xcresult`
- XcodeBuildMCP simulator focused collection/menu prepared-image thermal set on iPhone 17 Pro
  - passed: `14` tests, `0` failures
  - covered category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T14-09-15-196Z_pid15747_321127fc.xcresult`
- XcodeBuildMCP simulator focused browse-collection hidden-work thermal set on iPhone 17 Pro
  - passed: `12` tests, `0` failures
  - covered current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-59-55-976Z_pid15747_c6bc3e88.xcresult`
- XcodeBuildMCP simulator focused root-surface thermal set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered root `Xin chào` surface gating, inactive Home render gating, current-only detail mounting between gestures, back/forward presentation behavior, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-37-41-947Z_pid15747_633dcb71.xcresult`
- XcodeBuildMCP simulator focused hidden-detail thermal set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered current-only detail mounting between gestures, back/forward presentation behavior, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-26-40-467Z_pid15747_c28f5fef.xcresult`
- XcodeBuildMCP simulator focused second-layer thermal set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered inactive Home render gating, local-intent invalidation, listing backdrop preheat policy, city menu/related pick caching, Home recently-viewed canonicalization, static `Xin chào` photo-card layout, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-12-53-413Z_pid15747_3411df8e.xcresult`
- XcodeBuildMCP simulator focused thermal/content set on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered local-intent invalidation, listing backdrop preheat policy, city menu/related pick caching, V2.2 mentioned/related cards, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T12-44-09-205Z_pid15747_1987ab03.xcresult`
- XcodeBuildMCP simulator build/run smoke on iPhone 17 Pro
  - current `Xin chào` card-over-photo smoke passed for `--detail-page viet-polite-hello`
  - phrase backdrop smoke passed for `--detail-page viet-phrase-phone-1`
  - city/listing backdrop smoke passed for `--detail-page viet-family-city-danang-place-international-terminal`
  - screenshots captured at:
    - `docs/task-results/listing-thermal-audit-2026-05-30/xin-chao-current-card-smoke.jpg`
    - `docs/task-results/listing-thermal-audit-2026-05-30/phrase-phone-backdrop-smoke.jpg`
    - `docs/task-results/listing-thermal-audit-2026-05-30/city-terminal-backdrop-smoke.jpg`
- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- broader XcodeBuildMCP simulator `AppChromeTests` + `SQLiteLanguagePackRepositoryTests`
  - compiled and ran `208` tests
  - passed: `203`
  - failed: `5` pre-existing content-expectation/copy-audit tests outside the thermal files, including V2.2 city copy expectation drift and Vietnamese menu guide-copy audit drift
- Physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish`
  - build passed
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- Latest physical iPhone launch readiness check from `feature/admin-photo-backdrop-polish` commit `c8093ca3d`
  - simulator focused thermal/navigation set passed with bounded city menu/related pick caches; both caches now stay at or below `96` entries during a synthetic rapid city-listing browsing burst
  - physical phone launch readiness check reported the phone was locked, so build/install/launch proof for this exact commit remains pending
  - remaining proof gap: unlock the phone, keep it awake, rerun the corrected worktree installer, then continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone launch check from `feature/admin-photo-backdrop-polish` commit `719783c1a`
  - simulator focused thermal/navigation set passed with long-history detail render suffixing; rendering now inspects only the active page, or active plus immediate back-preview page, instead of filtering the full detail history
  - physical phone launch check reported the phone was locked, so build/install/launch proof for this exact commit remains pending
  - remaining proof gap: unlock the phone, keep it awake, rerun the corrected worktree installer, then continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `b5cff54fd`
  - simulator focused thermal set passed with the resolved detail-page cache; repeated same-page resolution now stays at `1` SQLite detail resolver entry instead of rising to `13`
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `28e259f22`
  - simulator build/run smoke passed for `--detail-page viet-phrase-polite-1` and for tapping the Home featured `Xin chào` card; current branch shows the pull-down sheet over `BackdropPhraseGreetingCafeDoorway`, not the old static Ha Long masthead layout
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then confirm the on-phone `Xin chào` screen and continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` commit `48e664d74`
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch passed
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` commit `ae598fb8a`
  - simulator build/run smoke passed for `--detail-page viet-polite-hello`; current branch shows the `Xin chào` pull-down sheet over the `BackdropPhraseGreetingCafeDoorway` image instead of the old static Ha Long masthead layout
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch passed
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `53a586239`
  - build passed
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `a88d8063f`
  - build passed from a dedicated `Debug-iphoneos` product
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `8ce390df0`
  - build passed from a dedicated `Debug-iphoneos` product
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `1d665972b`
  - simulator build/run smoke passed for `--detail-page viet-polite-hello`; current branch shows the `Xin chào` pull-down sheet over the `BackdropPhraseGreetingCafeDoorway` image instead of the old static Ha Long masthead layout
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean before the build; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone

## Current Main Non-Paywall Merge Sweep Evidence

Current `main` evidence from the 2026-05-29 orchestrator merge sweep:

- merged lanes: `feature/admin-photo-backdrop-polish`, `feature/bottom-padding-audit`, and `feature/menu-section`
- explicitly skipped lanes: `feature/messages-section`, `feature/paywall`, and `archive/messages-section-20260516`
- preserved boundary: Paywall and Messages branch heads remain unmerged into `main`
- merge resolution: kept a single `AppChromeLayout.topReadableShieldHeight` declaration using `max(topSeparationHeight, topAdminHitTestEnvelopeHeight)`, while preserving bottom-clearance validation helpers and Menu scroll-coordinator behavior
- follow-up validation fix: Search standard-scroll validation now scrolls to `Search.BottomSentinel` under the `--validate-bottom-inset-scroll-to-bottom` launch argument, and `BottomInsetUITests` now query sentinel `otherElements` directly instead of broad `.any` snapshots

Fresh command evidence from this pass:

- `git diff --check`
  - passed before and after the Search validation fix
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-search-only-surfacing.js`
  - passed: `315` keep-search-only rows, `26` browsable subcategories, `315` generated relations, `315` generated section items
- XcodeBuildMCP simulator `AppChromeTests` focused merge set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered search-only Browse surfacing, bottom-clearance policy, Menu section inventory, Menu large-model `Equatable` guard, pinned section coalescing, immediate jump policy, and top-section chrome coordinator behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T14-53-21-114Z_pid4769_05fb8cb6.xcresult`
- XcodeBuildMCP simulator Menu UI checks on iPhone 17 Pro
  - passed: `BrowseSearchUITests/testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive` and `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `2` tests, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T14-53-54-621Z_pid4769_defac781.xcresult`
- XcodeBuildMCP simulator bottom-inset UI split reruns on iPhone 17 Pro
  - passed: `BottomInsetUITests/testPrimaryRootRoutesKeepBottomContentAboveSystemTabBar`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T15-00-08-099Z_pid4769_e7a89e4a.xcresult`
  - passed: `BottomInsetUITests/testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T15-00-55-255Z_pid4769_9093f927.xcresult`
- XcodeBuildMCP simulator build/run smoke on iPhone 17 Pro
  - build passed
  - install passed
  - launch passed
  - bundle id: `app.speaklocal.vietnam.native`
- Physical iPhone Debug build/install from current `main`
  - commit: `8fa4f7718` (`Record non-paywall merge sweep validation`)
  - build passed
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Current Menu Section Worktree Evidence

Current `feature/menu-section` evidence from the 2026-05-29 Vietnamese menu top-section picker fix:

- taxonomy fix: the Food Menu now publishes restaurant-style section headers to the in-page rail, visible section titles, and top glass dropdown from the same `VietnameseMenuCatalog.sections(for:)` source; legacy protein buckets such as `Pork` and `Beef & goat` are folded into `Grilled & braised meats`
- root-cause fix: pinned top-section `Menu` selections now keep the selected section label stable while the lazy, variable-height section stack converges on the requested anchor
- smoothness fix: pinned, scroll-derived section-title crossings are coalesced before publishing to the top glass label, while direct dropdown/rail jumps still update immediately
- direct-jump stability fix: explicit top-picker selections now keep ownership of the pill label through the short lazy-stack settle window so scroll geometry cannot relabel the pill to a neighboring section while the jump lands
- second-layer smoothness fix: unnecessary deep `Equatable` conformance was removed from large Vietnamese menu payload/section/item structs after a scroll CPU sample showed AttributeGraph comparing whole section/item arrays during section-boundary updates
- five-whys lag/thermal root cause: the top picker repeatedly read `VietnameseMenuCatalog.sections(for:)`, which rebuilt the grouped Food Menu sections on every access, and each section block used an inner eager row stack, so jumping through the dropdown one by one could materialize every row in a large section such as `Grilled & braised meats`
- lag/thermal fix: menu items, categories, popular items, and sections are now cached per menu kind, and each section's rows render through a nested lazy stack so selector jumps preserve the same dropdown/rail/menu functionality without rebuilding the full section model or eagerly constructing every row in the landed section
- break-test coverage: simulator UI now walks every real Food Menu top-picker section after `Popular dishes` in sequence and asserts the chosen section title and first visible row appear for each jump
- preserved UX: the existing top glass dropdown surface, in-page rail, audio speed chrome, and menu rows remain in place; the food inventory still exposes 269 unique rows

Fresh command evidence from this pass:

- XcodeBuildMCP simulator cache regression before the cache fix
  - failed as expected: `AppChromeTests/testVietnameseMenuSectionsAreCachedForRepeatedSelectorAccess` saw 20 grouped-section builds from 20 repeated selector-style reads
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T15-41-57-738Z_pid11523_d7629bfa.xcresult`
- XcodeBuildMCP simulator menu cache/performance guard after the fix
  - passed: `testVietnameseMenuSectionsAreCachedForRepeatedSelectorAccess`, `testVietnameseMenuSectionsExposeFullVerticalInventory`, and `testVietnameseMenuLargeModelsAvoidDeepEquatableComparisons`, `3` tests, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T15-43-33-376Z_pid11523_239c45a5.xcresult`
- XcodeBuildMCP simulator sequential Food Menu top-picker break test
  - passed: `BrowseSearchUITests/testVietnameseMenuTopSectionPillSurvivesSequentialBreakTest`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T15-44-40-678Z_pid11523_5cc930ee.xcresult`
- XcodeBuildMCP simulator current top-picker focused UI set after the lag/thermal fix
  - passed: `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `testVietnameseMenuTopSectionPillJumpsToSeafood`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `3` tests, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T15-46-10-758Z_pid11523_edf7587b.xcresult`
- Physical iPhone Debug build/install/launch from `feature/menu-section` after the lag/thermal fix
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator `AppChromeTests` menu inventory/taxonomy set
  - passed: `testVietnameseMenuCollectionsUseCsvBackedInventory`, `testVietnameseMenuSectionsExposeFullVerticalInventory`, `testVietnameseMenuSectionTrackingCoordinatorPublishesOnlyMeaningfulChanges`, and `testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges`, `4` tests, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T12-50-59-636Z_pid11523_ca9b3100.xcresult`
- XcodeBuildMCP simulator top-picker UI taxonomy set
  - passed: `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `testVietnameseMenuTopSectionPillJumpsToSeafood`, `testVietnameseFoodMenuSectionRailScrollsToCategory`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `4` tests, `0` failures
  - verifies the top picker exposes `Seafood`, `Grilled & braised meats`, and `Soups & hot pots`, while old `pork` and `beef-and-goat` menu entries are absent
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T12-51-21-598Z_pid11523_0fee6598.xcresult`
- XcodeBuildMCP simulator resumed top-picker proof
  - initial rerun failed before app launch because the previously configured feature simulator was no longer available
  - rerun on the available iPhone 17 Pro simulator passed: `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T14-43-37-911Z_pid11523_e9e8457a.xcresult`
- Physical iPhone install for the taxonomy fix
  - previous four attempts were blocked before build/install because Xcode reported no connected or available paired iPhone
  - resumed physical-device attempt passed build, install, and launch for the current `feature/menu-section` app build
  - post-build signing scan passed; local personal signing remained outside repo-tracked signing files
- simulator CPU sample while driving the fast Vietnamese Food Menu section-boundary swipe
  - before the second-layer fix: sampled stacks included `VietnameseMenuSection.__derived_struct_equals` / `VietnameseMenuItem.__derived_struct_equals` under AttributeGraph equality work
  - after the fix: repeated sample at `native-ios/artifacts/menu-section-cpu-sample-20260529-174504-post-equatable/vietnamese-menu-section-scroll.sample.txt` no longer contained those equality stacks
- XcodeBuildMCP simulator `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`
  - failed before the first scroll-stability fix because the top pill did not stay on the chosen `Seafood` section
  - now passes against the restaurant-style section set instead of the old protein buckets
- XcodeBuildMCP simulator `AppChromeTests` second-layer performance guard
  - passed: `testVietnameseMenuLargeModelsAvoidDeepEquatableComparisons`, plus section coalescing and immediate-jump policy tests, `3` tests, `0` failures
- XcodeBuildMCP simulator current combined menu smoothness set after the second-layer fix
  - passed: `testVietnameseMenuLargeModelsAvoidDeepEquatableComparisons`, `testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges`, `testVietnameseMenuSectionJumpPolicyUsesImmediateScroll`, `testVietnameseMenuSectionChromeCoordinatorSeparatesPinnedChangesFromLabelChanges`, `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `6` tests, `0` failures
- Physical iPhone focused UI test run after the second-layer fix
  - passed: `BrowseSearchUITests/testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive` and `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `2` tests, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-dnxakcrpfonvumejbiymsetlqwjq/Logs/Test/Test-SpeakLocalNative-2026.05.29_17-49-35-+0700.xcresult`
- XcodeBuildMCP simulator combined direct-jump and boundary-coalescing smoke set
  - passed: `testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges`, `testVietnameseMenuSectionJumpPolicyUsesImmediateScroll`, `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `4` tests, `0` failures
- XcodeBuildMCP simulator `AppChromeTests` focused menu/chrome set
  - passed: `8` tests, `0` failures
- XcodeBuildMCP simulator menu/top-picker focused UI set
  - passed: `testVietnameseFoodMenuSectionRailScrollsToCategory`, `testVietnameseMenuTopSectionPillAppearsAfterInPageRailScrollsOff`, `testVietnameseMenuTopSectionPillJumpsToSeafood`, `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `5` tests, `0` failures
- XcodeBuildMCP simulator visual check
  - passed: fast scrolls across section-title boundaries remain responsive, and selecting a top dropdown section keeps the top pill on the selected restaurant-style section
- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- signing-file cleanliness check
  - passed: `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` stayed unchanged
- Physical iPhone Debug build/install from `feature/menu-section` after the second-layer fix
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Current Main City Pages v2.2 Merge Evidence

Current `main` evidence from the 2026-05-29 city-pages merge:

- merged app/content commit: `7ba42f0fc` (`Merge city-pages`)
- merged lanes: `feature/city-pages`
- synced clean allowed lanes to final `main`: all clean non-Messages/non-Paywall worktrees were fast-forwarded to `7ba42f0fc`
- explicitly skipped lanes: `feature/messages-section`, `feature/paywall`, and `archive/messages-section-20260516`
- exclusion check passed: `main` does not contain the Messages or Paywall branch heads

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
  - passed: `500` total, `500` `FINAL_PASS`, `0` revise/fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
  - passed: `0` failures
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed under the current non-unique hero gate
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `500` city places, `0` release-blocking missing-audio rows
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- V2.2 Node test chain
  - passed: validator, projection, and builder tests
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

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

Current `main` evidence from the 2026-05-25 non-City-Pages/non-Paywall/non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `a3af0ab41` (`Merge practice-area`)
- merged lanes: `feature/practice-area`
- synced clean allowed feature lanes to final `main`
- explicitly skipped lanes: `feature/city-pages`, `codex/viet-city-phrase-library-v1`, `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`, and old `integration/*` worktrees
- City Pages dirty worktree was left untouched by request

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- XcodeBuildMCP simulator focused Practice/Browse/Home sheet tests
  - passed: `5` tests, `0` failures
- XcodeBuildMCP simulator `SpeakLocalNativeTests/AppChromeTests`
  - passed: `168` tests, `0` failures
- Paywall and Messages exclusion checks
  - passed: paywall commits are contained only by `feature/paywall`; Messages commit is contained only by Messages branches
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Main evidence from the 2026-05-21 non-paywall/non-messages merge sweep:

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
