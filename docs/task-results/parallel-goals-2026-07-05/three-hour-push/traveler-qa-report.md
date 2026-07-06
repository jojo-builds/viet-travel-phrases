# Backup Traveler QA Report

> Boundary note: the original report and early continuation sections are pre-fix / earlier-worker evidence. Unless a section explicitly says otherwise, screenshots and test receipts in those early sections apply to the current-thread build of `main` at `7989e1f67` on the `SpeakLocal Traveler` simulator. Later addenda are separately labeled for `4f6462906` and `60db7e9fb`. Do not use the broad Browse/Search class evidence below to override newer post-fix receipts.

Run timestamp: 2026-07-05 19:24 PST
Worker scope: backup visual/function QA for Home, Browse/category/detail/back, city Browse-by jump, Search, Saved, and Practice sheet chrome.
Checkout: `main` at `7989e1f67`
Simulator: `SpeakLocal Traveler`, iOS 26.5
Build: `SUCCEEDED` via XcodeBuildMCP `build_run_sim` with `CODE_SIGNING_ALLOWED=NO`
App-code edits: none. Jojo/orchestrator took ownership of the blank-route code fix in a separate lane; this worker did not edit app code for that issue.

## Screens And Routes Tested

- Home: launched current `main`; verified `Xin chào` feature card, audio controls, quick phrases, and bottom chrome.
  - Proof: `traveler-qa-proof/01-home-baseline.jpg`
- Browse root: opened Browse tab; verified category cards and fixed top/bottom chrome.
  - Proof: `traveler-qa-proof/02-browse-root.jpg`
- Browse category: opened `Eating Out`; verified subcategory cards, phrase rows, speaker affordances, top Back, and bottom chrome.
  - Proof: `traveler-qa-proof/03-browse-eating-out-category.jpg`
- Browse detail: opened `Cà phê đen` detail from the category; verified article hero, save/audio controls, breakdown strip, and chrome.
  - Proof: `traveler-qa-proof/04-browse-detail-coffee.jpg`
- City Browse-by: observed Da Nang city collection restored/jumped into `Restaurants`; verified visible restaurant rows, row audio/save controls, and sticky `Restaurants` section pill.
  - Proof: `traveler-qa-proof/06-city-browseby-restaurants-jump.jpg`
- Saved: verified Saved copy, saved trip row, section rail, row audio, and remove control.
  - Proof: `traveler-qa-proof/07-saved-trip-row.jpg`
- Search: interactive Search initially exposed a field/results snapshot, but visual screenshot capture showed a blank white screen; a fresh direct `--search-query coffee --reset-demo-state` launch also rendered blank with no runtime targets/text.
  - Proof: `traveler-qa-proof/08-bug-search-query-blank.jpg`
- Practice: launched with `--practice --reset-demo-state --enable-practice-layout-probes`; verified hub and topic cards.
  - Proof: `traveler-qa-proof/10-practice-hub.jpg`
- Practice sheet chrome: opened an Essentials practice round from a clean Practice launch; verified top header sits below the Dynamic Island, close control is visible, cards/audio controls are readable, and hint control is visible.
  - Proof: `traveler-qa-proof/11-practice-essentials-sheet.jpg`

## Bugs Found

### HARD_BLOCK: route transitions can blank the app down to only the backdrop

1. Browse category detail back path:
   - Repro: Home -> Browse -> `Eating Out` -> `Cà phê đen` detail -> top Back.
   - Result: screen settled with only the photo backdrop visible. Runtime snapshot had no tappable/text content and no top/bottom chrome.
   - Proof: `traveler-qa-proof/05-bug-blank-after-detail-back.jpg`
   - Notes: waiting for UI settle did not recover the content. Relaunch later restored Home, so the install/build itself was not corrupt.

2. Direct Search query launch:
   - Repro: stop app, launch with `--search-query coffee --reset-demo-state`.
   - Result: visual screenshot is blank white and runtime snapshot count is 1 with no tappable/text content.
   - Proof: `traveler-qa-proof/08-bug-search-query-blank.jpg`
   - Notes: this means Search cannot be counted as visually passed in this run, even though an earlier runtime snapshot briefly listed coffee result targets.

3. Search result route path:
   - Repro: Search -> type `coffee` -> tap a result near the top of the list.
   - Result: route produced a no-text/no-target state instead of a visible detail page; screenshot showed a blank/background-only surface.
   - Proof: `traveler-qa-proof/09-bug-blank-after-search-result.jpg`
   - Notes: a later normal launch could also restore into an empty runtime state until the app was explicitly stopped and relaunched with route flags.

Ownership: orchestrator has taken the app-code fix in a separate lane. This worker is reporting evidence only.

### FOLLOW_UP: city top-section control tap was not cleanly validated

- The Da Nang `Restaurants` Browse-by destination rendered correctly, but a subsequent top-section control tap did not produce clean city-section proof in this manual pass. It landed on Saved during the exploratory flow, likely due to stale ref/state while navigating around the blank-route issue.
- Recommendation: after the orchestrator fix lands, rerun a city Browse-by loop from fresh app state for `danang`, `hanoi`, `hcmc`, `hoian`, and `hue`, and tap section controls only after a fresh snapshot.

### ACCEPTED_TEMPORARY_RISK: Practice sheet proof is simulator-only

- Current simulator proof shows the Practice sheet header clear below the Dynamic Island and not clipped.
- Because the original clipping concern came from physical-phone presentation, repeat the same Practice sheet path on the phone after the blank-route fix merge.

## Fixes Made

None. No app code was edited and no feature lane was created by this worker.

## Validation Proof

- Build/run: XcodeBuildMCP `build_run_sim` succeeded on `SpeakLocal Traveler`.
- Screenshot packet: `docs/task-results/parallel-goals-2026-07-05/three-hour-push/traveler-qa-proof/`
- Runtime log scan: no app-level fatal/crash line found around the blank-route screenshots. Logs mainly showed simulator WebKit accessibility duplicate warnings and expected `signal 15` terminations from explicit stop/relaunch actions.

## Remaining Launch Blockers

1. The blank-route/back-stack/Search rendering failure is a launch blocker until fixed and freshly proven on simulator.
2. After that fix, rerun the affected flows:
   - Browse category -> phrase/detail -> Back -> nonblank category/root content with chrome.
   - Direct Search query launch -> visible Search results with chrome.
   - Search query -> result -> visible destination page -> Back/Close behavior without blank content.
   - App relaunch after a failed/blank route should never restore to an empty content state.
3. Physical iPhone proof should repeat the Practice sheet top clearance check after the route fix merges.

## Phone Checklist For Jojo

1. Launch app on the phone; confirm Home shows `Xin chào`, audio controls, quick phrases, and bottom chrome.
2. Tap Browse -> Eating Out -> a visible phrase row; confirm the detail page renders, then tap Back and confirm the category page is not blank.
3. In Browse, open Da Nang; tap or scroll to Browse-by sections such as `Restaurants`; confirm rows, audio, and save buttons remain visible.
4. Open Search; type `coffee`; confirm visible results appear, then tap one result and confirm it opens a visible destination page and Back does not blank the app.
5. Open Saved; confirm saved rows show audio and remove controls.
6. Open Practice; start a topic round; confirm the sheet header, topic picker, close button, cards, audio buttons, and hint control are not clipped.

---

# Continuation Addendum - Current-Thread QA

Continuation timestamp: 2026-07-05 19:45 Asia/Manila local
Thread scope: continue QA/proof collection after orchestrator status check; do not edit app code for the blank-back issue unless handed back.
Checkout/binary boundary: `main` at `7989e1f67`; later local `main` advanced to `4f6462906`, but this thread did not rebuild or revalidate the newer commit.
Simulator: `SpeakLocal Traveler`, iOS 26.5
App-code edits: none.

## Fresh Build And Launch Proof

- XcodeBuildMCP `build_run_sim` passed with `CODE_SIGNING_ALLOWED=NO`.
- App path: `/tmp/speaklocal-traveler-qa-deriveddata/Build/Products/Debug-iphonesimulator/SpeakLocalNative.app`
- Bundle: `app.speaklocal.vietnam.native`
- Build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/build_run_sim_2026-07-05T11-15-56-661Z_pid42996_9f39a46a.log`
- Launch screenshot copied to `traveler-qa-proof/000-home-launch-7989e1f67.jpg`.

## Fresh Focused Proof

- Unit audio/save proof passed:
  - `PhrasePageFixtureTests/testNotSpicyBreakdownCardHasPlayableAudio`
  - `LocalUserIntentStoreTests/testSavedCityHubIDsPersistAsTripItems`
  - Result: `2` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-17-32-135Z_pid42996_e4567625.log`
- Browse/city/Saved matrix first run:
  - Passed: normal Browse detail back restore, city header save, Da Nang row save, Hoi An Browse-by restaurant jump, city Browse-by top-admin clearance, city top-section jump.
  - Failed: fast double-back setup could not make `Browse.PhraseFamily.polite-repair` comfortably visible; Saved unsave failed before Drink Menu appeared.
  - Result: `6` passed, `2` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-17-58-912Z_pid42996_2894209c.log`
- Saved/menu rerun passed:
  - `BrowseSearchUITests/testSavedTripUnsaveRemovesSavedMenuItem`
  - `BrowseSearchUITests/testVietnameseMenuRowSaveAddsItemToSavedTrip`
  - Result: `2` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-44-23-084Z_pid42996_38afbd3d.log`
- Search focused recovery passed:
  - `BrowseSearchUITests/testSearchCategoryResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchCityResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchRecoveryCardsAndRelatedChipsStayInteractive`
  - Result: `3` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-43-13-244Z_pid42996_a71bd504.log`
- Back/Forward proof:
  - Passed: `BackSwipeUITests/testHomeBrowseTabBackButtonReturnsScrolledHomePosition`
  - Failed: `BackSwipeUITests/testTopForwardButtonRestoresForwardPageAfterBackButton`; after Back from direct detail to Home, `TopAdmin.ForwardButton` did not appear.
  - Result: `1` passed, `1` failed in that run.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-34-24-086Z_pid42996_740858d0.log`
  - Follow-up BackSwipe run passed `testRightEdgeSwipeRestoresForwardPageAfterBackSwipe` and `testBrowseRootOpenedFromHomeShowsBackButton`; `testEdgeSwipeReturnsFromDirectDetailToHome` crashed with signal kill.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-41-58-604Z_pid42996_9bb1ea9b.log`
- Full BackSwipe class attempt:
  - XcodeBuildMCP timed out at 5 minutes while the class was still emitting logs.
  - The partial log shows additional Home/Practice/Home shelf routes passing after the timeout, but no completed result marker was produced.
  - The app/test-runner state was stopped/cleared before starting later work.
  - Treat this as inconclusive, not as a pass or product failure.
  - Partial receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-46-50-673Z_pid42996_8a1f0928.log`

## Additional Bugs / Risks From Continuation

### P1: blank-back issue remains externally owned

- The backup report's blank-detail/back proof is preserved at `traveler-qa-proof/05-bug-blank-after-detail-back.jpg`.
- Per orchestrator instruction, app-code ownership moved to a separate lane. This thread did not edit app code for it.

### P1/P2: audio tap reliability was red before the audio-harness correction

- `AudioTapReliabilityUITests/testBreakdownAudioCardsStayResponsiveAcrossTargetPages` failed during repeated taps on the coffee breakdown audio card. The first target page opened, but repeated tapping lost the expected detail context and the failure hierarchy showed Practice content instead of the detail page.
- `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved` failed because `VietnameseMenu.Audio.viet-menu-drink-ca-phe-sua-da` / `Play phrase audio` never became hittable after repeated scroll attempts.
- Result: `0` passed, `2` failed.
- Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-21-25-284Z_pid42996_a5f41c15.log`
- Superseding note: this is retained as pre-harness-fix evidence. Later `audio-harness-fix-report.md` records the real user-path harness correction and green full audio-class proof in the orchestrator lane.

### P2: top Forward button proof failed, right-edge forward passed

- The right-edge forward gesture restored the detail page after back-swipe.
- The visible top Forward button did not appear after tapping the top Back button from direct detail to Home.
- This may be a route-history visibility mismatch rather than total forward-history loss, but it is user-visible because the app direction expects browser-like back/forward controls.

### P2/P3: Practice regression gate is unstable; visual saved-round screenshot looks acceptable

- `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound` opened the saved match round and saved screenshot `traveler-qa-proof/practice/saved-round-start.png`.
- The screenshot shows the sheet header and controls readable below the top edge.
- The test failed because the geometry assertion could not find `Practice.Match.Close` by identifier.
- `PracticeUITests/testHomeQuickPracticeCallerCompletesRoundAndReturnsToHomePracticeRail` failed later with `application app.speaklocal.vietnam.native is not running` while trying to scroll/tap through the round.
- Result: `0` passed, `2` failed.
- Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T11-27-36-981Z_pid42996_7afeaca0.log`
- Recommendation: keep the visual screenshot as evidence that the original clipping symptom was not reproduced in this simulator shot, but do not call the Practice gate green until the identifier/app-running failures are resolved or rerun cleanly.

## Updated Remaining Launch Blockers / Follow-Ups

1. Blank-back / blank-route state was the highest-priority launch blocker in the early `7989e1f67` evidence; later post-fix proof sections and reports should be treated as authoritative for current `main`.
2. Audio tap reliability was red in this early continuation, then superseded by the orchestrator audio-harness report with green full-class proof.
3. Visible top Forward button behavior failed in the early continuation, then passed in the later `4f6462906` and `60db7e9fb` route-state reruns.
4. Practice sheet visual clearance had good screenshot evidence but an early automated gate failure; later Practice saved-round and representative Practice flow checks passed.
5. Search category/city/recovery automated proof passed in the early continuation and was reinforced by later post-fix route-state and visual proof.

## Boundary Wrap After Main Advanced

Orchestrator update received after the broad Browse/Search run had started: local `main` had advanced beyond this thread's built app. The broad `/tmp/speaklocal-traveler-qa-browse-search` run was therefore stopped and should be read only as pre-fix evidence for the `7989e1f67` binary/source boundary.

Partial broad Browse/Search evidence before stopping:

- Log: `/tmp/speaklocal-traveler-qa-browse-search.log`
- Result bundle: `/tmp/speaklocal-traveler-qa-browse-search.xcresult`
- Build/run source boundary: `7989e1f67`
- Later observed local `main`: `4f6462906`
- Broad run status: interrupted/stopped after the boundary update; no final suite summary should be inferred.
- Useful pre-fix signal: many Search, Saved, menu, and normal Browse/detail paths passed, while the class repeatedly restarted the UI-test runner and produced two city Browse-by failures:
  - `BrowseSearchUITests/testCityBrowseCardJumpClearsTopAdminChrome`
  - `BrowseSearchUITests/testCityBrowseCardSelectionJumpsToMatchingSection`

No app code was edited in this thread. At the time of this boundary wrap, no post-`4f6462906` rebuild or validation had been performed here; the later section below is labeled separately.

## Post-Advance Validation - Current Main Snapshot

Continuation timestamp: 2026-07-05 21:04 Asia/Manila local
Source/worktree boundary: shared checkout on `main` at `4f6462906`, with preexisting dirty files limited to docs plus `native-ios/UITests/AudioTapReliabilityUITests.swift`.
Reason for dirty label: orchestrator reported an uncommitted UI-test harness fix for `AudioTapReliabilityUITests` and separate full audio-class green proof. This thread did not edit app code, did not touch the audio harness, and did not rerun or reinterpret the audio-class result.
Detached-worktree attempt: `/tmp/speaklocal-main-4f6462906` could not be created because the machine hit `No space left on device` while copying large image assets; the partial temp artifact was removed.
Simulator: `SpeakLocal Traveler`, iOS 26.5
Proof folder: `traveler-qa-proof-post-4f6462906/`

### Build And Visible Proof

- XcodeBuildMCP `build_run_sim` passed with `CODE_SIGNING_ALLOWED=NO`.
- App path: `/tmp/speaklocal-traveler-qa-deriveddata/Build/Products/Debug-iphonesimulator/SpeakLocalNative.app`
- Bundle: `app.speaklocal.vietnam.native`
- Build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/build_run_sim_2026-07-05T12-56-34-063Z_pid42996_94933ae9.log`
- Runtime log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/app.speaklocal.vietnam.native_2026-07-05T12-56-59-817Z_helperpid23998_ownerpid42996_51e8a7f1.log`
- Visible Home proof: `traveler-qa-proof-post-4f6462906/000-home-launch-4f6462906-dirty-harness.jpg`
- Visual read: Home renders visible `Xin chào` content, audio controls, Home/Essentials shelf context, and bottom chrome on the post-advance build.

### Focused Route/State Proof

- Browse/Search route proof passed:
  - `BrowseSearchUITests/testBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testSearchCategoryResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchCityResultHandsOffToBrowseCollection`
  - `BrowseSearchUITests/testSearchRecoveryCardsAndRelatedChipsStayInteractive`
  - Result: `5` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T12-57-28-647Z_pid42996_23f0a4f7.log`
- Saved/menu and city Browse-by route proof passed:
  - `BrowseSearchUITests/testCityBrowseCardJumpClearsTopAdminChrome`
  - `BrowseSearchUITests/testCityBrowseCardSelectionJumpsToMatchingSection`
  - `BrowseSearchUITests/testSavedTripUnsaveRemovesSavedMenuItem`
  - `BrowseSearchUITests/testVietnameseMenuRowSaveAddsItemToSavedTrip`
  - Result: `4` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T12-59-43-409Z_pid42996_135f9848.log`
  - Note: `testCityTopSectionJumpKeepsBrowseChromeClear` was requested in the run arguments but was not returned in XcodeBuildMCP's test-case list, so it is not counted here.
- Back/Forward route proof passed:
  - `BackSwipeUITests/testBrowseRootOpenedFromHomeShowsBackButton`
  - `BackSwipeUITests/testHomeBrowseTabBackButtonReturnsScrolledHomePosition`
  - `BackSwipeUITests/testRightEdgeSwipeRestoresForwardPageAfterBackSwipe`
  - `BackSwipeUITests/testTopForwardButtonRestoresForwardPageAfterBackButton`
  - Result: `4` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-01-08-184Z_pid42996_e4e18dc2.log`
- Practice saved-round proof passed:
  - `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`
  - Result: `1` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-02-23-797Z_pid42996_9fece3b4.log`
- Bottom-inset visual/layout proof passed:
  - `BottomInsetUITests/testPrimaryRootRoutesKeepBottomContentAboveSystemTabBar`
  - `BottomInsetUITests/testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar`
  - Result: `2` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-10-39-628Z_pid42996_4bbd94e0.log`
- Search keyboard/admin tab reachability proof passed:
  - `AdminChromeUITests/testFocusedSystemSearchFieldAcceptsTyping`
  - `AdminChromeUITests/testPrimarySystemTabsRemainReachableAroundSearch`
  - `AdminChromeUITests/testSystemTabTapsCommitDestinations`
  - `BrowseSearchUITests/testProgressiveSearchTypingAndDeletingKeepsFieldResponsive`
  - `BrowseSearchUITests/testSearchTabOpensSystemSearchField`
  - `BrowseSearchUITests/testSearchTapOutsideFieldReturnsToDiscoveryContent`
  - Result: `6` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-12-23-904Z_pid42996_f7baad1b.log`
- Collection section-jump and filter proof passed:
  - `BrowseSearchUITests/testAirportSubcategoryCardsFilterVisibleRows`
  - `BrowseSearchUITests/testBrowseCityTopSectionPillJumpsToNounGroup`
  - `BrowseSearchUITests/testBrowseCollectionTopSectionPillJumpsToAirportSubcategory`
  - `BrowseSearchUITests/testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`
  - `BrowseSearchUITests/testRepresentativeCategorySubcategoryJumpsClearTopAdminChrome`
  - `BrowseSearchUITests/testVietnameseFoodMenuSectionRailScrollsToCategory`
  - `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`
  - `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToSeafood`
  - Result: `8` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-24-54-786Z_pid42996_c064673b.log`
- Practice representative flow proof passed:
  - `BrowseSearchUITests/testBrowsePracticeBackReturnsToCollectionPracticeFocus`
  - `BrowseSearchUITests/testBrowsePracticeOverlayKeepsCollectionInPlaceThroughDismissal`
  - `PracticeUITests/testBrowseFirstDayPracticeCallerCompletesRoundAndReturnsToCollection`
  - `PracticeUITests/testPracticeHubUsesMatchPracticeInsteadOfMessages`
  - `PracticeUITests/testPracticeSavedSourceStartsFromSavedTripItems`
  - `PracticeUITests/testPracticeTopicHeaderClearsBottomChromeOnLaunch`
  - Result: `6` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-28-02-798Z_pid42996_b0325310.log`
- Home-origin route/back proof passed:
  - `BackSwipeUITests/testHomeCityCardBackButtonReturnsHome`
  - `BackSwipeUITests/testHomeCityCardBackSwipeReturnsHomePosition`
  - `BackSwipeUITests/testHomePhraseBackSwipeReturnsHomePosition`
  - `BackSwipeUITests/testHomePracticeBackChainReturnsHomePosition`
  - `BackSwipeUITests/testHomePracticePoolOpensDirectRoundWithoutPracticeHubFallback`
  - `BackSwipeUITests/testHomeShelfHeaderBackButtonPreservesViewportPosition`
  - `BackSwipeUITests/testHomeSituationBackButtonReturnsHomePosition`
  - Result: `7` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-30-03-394Z_pid42996_b36d4fde.log`

### Current Interpretation

- The earlier `7989e1f67` blank-back and top-forward failures should remain pre-fix evidence only.
- On the labeled `4f6462906` shared-checkout snapshot, the focused route/state regressions rerun here are green: Browse detail/back, fast double-back, Search category/city handoff, Search recovery, Saved/menu save-remove, city Browse-by jump/admin clearance, Back/Forward button/gesture behavior, Practice saved/collection flows, representative bottom-inset layout checks, Search/admin tab reachability, collection section/filter jumps, and Home-origin back/viewport restoration.
- Audio is intentionally excluded from this thread's post-advance claims because the current audio proof belongs to the orchestrator lane with the uncommitted `AudioTapReliabilityUITests` harness fix.
- No app-code edits were made in this thread.

## Latest Current-Main Anchor - `60db7e9fb`

Continuation timestamp: 2026-07-05 21:43 Asia/Manila local
Latest observed `main`: `60db7e9fb` (`Add release risk addendum`)
Boundary note: commits after `4f6462906` added/updated docs, reports, proof artifacts, and the audio UI-test harness file; no app-target runtime source changed in the `4f6462906..60db7e9fb` diff inspected by this thread. This thread still rebuilt exact-current `main` after the boundary moved again.

### Build And Visible Proof

- XcodeBuildMCP `build_run_sim` passed at `60db7e9fb` with `CODE_SIGNING_ALLOWED=NO`.
- App path: `/tmp/speaklocal-traveler-qa-deriveddata/Build/Products/Debug-iphonesimulator/SpeakLocalNative.app`
- Bundle: `app.speaklocal.vietnam.native`
- Build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/build_run_sim_2026-07-05T13-34-15-280Z_pid42996_877223f2.log`
- Runtime log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/app.speaklocal.vietnam.native_2026-07-05T13-34-25-633Z_helperpid68536_ownerpid42996_f29e5723.log`
- Visible Home proof: `traveler-qa-proof-post-60db7e9fb/000-home-launch-60db7e9fb.jpg`
- Visual read: Home still renders visible `Xin chào` content, audio controls, Home/Essentials shelf context, and bottom chrome.

### Tiny Exact-Current Route Sanity

- Focused exact-current route sanity passed:
  - `BackSwipeUITests/testTopForwardButtonRestoresForwardPageAfterBackButton`
  - `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent`
  - `BrowseSearchUITests/testSearchRecoveryCardsAndRelatedChipsStayInteractive`
  - `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`
  - Result: `4` passed, `0` failed.
  - Receipt: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/test_sim_2026-07-05T13-40-47-193Z_pid42996_0b54ca31.log`

### Latest Interpretation

- The broader post-advance matrix above was started at the `4f6462906` boundary and later overlapped docs/test-harness/report-only main movement.
- The latest exact-current rebuild and focused sanity pass at `60db7e9fb` preserve the key route-state signal: fast double-back, Search recovery, top Forward, and Practice saved-round are green.
- Audio remains intentionally delegated to the orchestrator/audio-harness lane, whose report records the updated `AudioTapReliabilityUITests` path and green audio-class proof.
- No app-code edits were made in this thread.

## Latest Current-Main Anchor - `0a7fb4d50`

Continuation timestamp: 2026-07-05 22:14 Asia/Manila local
Latest observed `main`: `0a7fb4d50` (`Fix root photo backdrop immersive chrome`)
Boundary note: this commit includes app-runtime changes in `native-ios/App/Views/AppShellView.swift` plus `AppChromeTests` coverage for root photo-backdrop immersive policy. This thread did not edit those files.

### Build And Visible Proof

- XcodeBuildMCP `build_run_sim` passed at `0a7fb4d50` with `CODE_SIGNING_ALLOWED=NO`.
- Build log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/build_run_sim_2026-07-05T14-10-31-684Z_pid42996_ee450b1a.log`
- Runtime log: `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/app-family-fd8e8a2a818d/logs/app.speaklocal.vietnam.native_2026-07-05T14-10-39-510Z_helperpid86371_ownerpid42996_44981ba6.log`
- Visible Home proof: `traveler-qa-proof-post-0a7fb4d50/000-home-launch-0a7fb4d50.jpg`
- Visual read: Home still renders visible `Xin chào` content, audio controls, Home/Essentials shelf context, and bottom chrome after the root photo-backdrop immersive chrome fix.
- Disk note: the first screenshot attempt failed because the volume was out of space. This thread removed only its disposable `/tmp/speaklocal-traveler-qa-deriveddata` cache, freeing enough room to capture the final screenshot. Other workers' artifacts were left alone.

### Related Fix-Lane Proof Read

- `root-photo-backdrop-immersive-fix-report.md` records focused validation for the runtime change:
  - `AppChromeTests/testAdminRootBackdropImmersivePolicyAcceptsRootSurfaceContexts`
  - `AdminChromeUITests/testHomePhotoBackdropHidesAndRestoresContent`
  - `AdminChromeUITests/testBrowseRootPhotoBackdropHidesAndRestoresContent`
  - `AdminChromeUITests/testSavedRootPhotoBackdropHidesAndRestoresContent`
  - `AdminChromeUITests/testPracticeRootPhotoBackdropHidesAndRestoresContent`
  - `AdminChromeUITests/testSearchRootPhotoBackdropHidesAndRestoresContent`
  - Result: `6` passed, `0` failed.
- This traveler thread did not rerun that root-photo class because disk was critically low; it treats the fix-lane report as authoritative for that surface and adds only the latest exact-main rebuild/Home visual anchor.

## Visual Inspection Notes From Post-Fix Proof Artifacts

These notes reuse existing post-fix proof screenshots under `post-fix-visual-regression-proof/`; this thread did not overwrite those artifacts.

- `03-browse-collection-after-detail-back.jpg`: Eating Out returns from detail to a populated collection rather than a blank sheet; top Back/Forward controls and bottom chrome remain visible.
- `04-search-coffee-results.jpg`: Search results for `coffee` render with Browse collection and phrase result content; the bottom search island remains usable and does not cover the first actionable result.
- `05-search-result-routed-drink-menu.jpg`: routed Drink Menu page is populated; row audio and save controls are visible.
- `06-hoi-an-city-route-top.jpg`: Hoi An route top renders readable intro copy plus save/audio controls.
- `07-hoi-an-restaurants-section-jump.jpg`: city Browse-by jump lands on Restaurants with row audio/save controls visible and top chrome still coherent.
- `08-saved.jpg`: Saved screen renders readable empty/onramp state and bottom chrome.
- `09-practice-round-sheet.jpg`: Practice match sheet header, close button, cards, speaker buttons, and hint control fit without top clipping in the visible screenshot.
- `11-browse-category-direct-launch-empty-ax.jpg`: direct Drink Menu launch is visually populated; the earlier audio-row red result should be read as test-path/hittability evidence, not a blank-page visual regression.

## Current Status Summary For Orchestrator

- This thread made no app-code edits and did not merge or touch paywall.
- Current exact-main anchor: `0a7fb4d50`, rebuilt and launched successfully on `SpeakLocal Traveler`.
- Latest direct proof from this thread: Home screenshot at `0a7fb4d50`; previous exact-current route sanity had `4` focused route/state tests passed at `60db7e9fb`.
- Broader route/state matrix from the earlier post-advance window is green across Browse/Search, Saved/menu, city Browse-by, Back/Forward, Practice, bottom-inset, Search/admin tab, collection section/filter, and Home-origin route restoration checks.
- Root photo-backdrop immersive chrome authority belongs to `root-photo-backdrop-immersive-fix-report.md`, which records `6` focused checks passed for Home/Browse/Saved/Practice/Search root backdrop behavior.
- Supporting App Store screenshot packet review: `app-store-screenshot-proof/contact-sheet.png` shows populated Home, Browse, Eating Out, Da Nang city section, Search, Saved, and Practice states; `app-store-screenshot-capture-report.md` records no screenshot-blocking defect in those non-paywall simulator captures.
- Older red evidence from `7989e1f67` is retained for history only and is explicitly superseded where later post-fix proof exists.
- Audio final authority belongs to `audio-harness-fix-report.md`, not this traveler report.
- Remaining non-simulator launch-risk outside this thread: physical iPhone walkthrough and any paywall-specific purchase/restore proof owned by separate lanes.
