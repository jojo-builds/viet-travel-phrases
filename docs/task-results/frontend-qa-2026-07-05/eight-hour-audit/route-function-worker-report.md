# Route/Function Worker Report

Date: 2026-07-06
Worker scope: `WORKER_ROUTE_FUNCTION_GOAL.md`
Worker baseline: local `main` at `87d50da00a4b5dd589d9e7b7636ceb4936a5cf98`
Orchestrator follow-up baseline: local `main` at `7228e5339` (`Tighten Practice-era front-end copy audit`)
Paywall: isolated; no paywall branch, StoreKit surface, or paywall files were edited or tested as part of this worker run.
Write scope: report only. I did not edit app code.

## Current-Files Check

- Re-read current app/test files after the orchestrator update that landed `911864b12` and `87d50da00`.
- Ran `node native-ios/scripts/audit-visible-product-language.js`.
  - Result: `Visible product language audit passed: no retired visible labels found.`
- Did not report old Browse/Practice conversation-label issues as current. I did see stale label strings in test code during search, but the current app-visible audit passed and I did not reproduce those labels in product UI.

## Orchestrator Follow-Up On Current Main

After the worker report, local `main` advanced to `7228e5339`. The two suspicious route/function findings were rerun as focused single-test checks against that newer current build:

- `BackSwipeUITests/testHomePracticePoolOpensDirectRoundWithoutPracticeHubFallback` passed: `1` test, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T16-32-33-663Z_pid2504_d44efca4.xcresult`.
- `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved` first hit an immediate runner-channel disconnect while the simulator was shut down; after a fresh simulator boot/rerun, the same single test passed: `1` test, `0` failures, result bundle `/Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-07-05T16-34-16-262Z_pid2504_16f2b952.xcresult`.

Conclusion: RF-01 and RF-02 should not be carried as current confirmed product bugs on `7228e5339`. They remain useful examples of why broad XCTest batches need focused reruns before a shipping blocker is declared.

## Tooling Notes

- XcodeBuildMCP was configured for the non-paywall `SpeakLocal Frontend QA` simulator, but `build_run_sim` failed with `Transport closed`; I switched to shell `xcodebuild` per repo runbook.
- A broad current-baseline run against shared/default DerivedData lost the built app path mid-run. I reran affected slices with isolated `/tmp` DerivedData paths.
- The final combined Practice/Back/Audio chunk wedged during XCTest cleanup after two recorded assertion failures. Per orchestrator direction, I stopped waiting, terminated that specific `xcodebuild`, and inspected the partial staging logs. The interrupted bundle lacks `Info.plist`, so `xcresulttool` cannot read it, but staging/session logs preserve the failure points.

## Passed / Clean Proof

- Static visible-language audit passed on current files.
- Saved Practice rerun passed:
  - Command: `BrowseSearchUITests/testSavedPracticeOpensAsSheetOverSavedTrip`
  - Bundle: `/tmp/speaklocal-saved-practice-single-1783268187.xcresult`
  - Result: 1 passed, 0 failed.
  - Coverage: Saved opens Practice as a sheet, shows `Match the pairs`, hides tab bar during sheet, closes Practice, and returns to Saved content.
- Breakdown audio rerun passed:
  - Command: `AudioTapReliabilityUITests/testBreakdownAudioCardsStayResponsiveAcrossTargetPages`
  - Bundle: `/tmp/speaklocal-audio-breakdown-single-1783268393.xcresult`
  - Result: 1 passed, 0 failed.
  - Coverage: 20 repeated taps on the coffee breakdown audio card, then 8 repeated taps each on `Xin chào` and hotel quiet-room breakdown audio cards, with page content and system chrome still present.
- Isolated Browse/Search/Saved rerun passed 7 of 8, with the one Saved Practice AX failure cleared by the single-test rerun above:
  - Passed in isolated rerun: progressive Search typing/deleting, Saved item unsave, Search category handoff, Search city handoff, Search recovery cards/chips, Vietnamese menu section rail jump, Vietnamese menu row save.
- Earlier current-baseline terminal output also showed passes before an infrastructure app-path failure for: Browse detail back, Search-to-Browse back, Browse Practice sheet launch, city Browse-by jump, city header save, Da Nang row save, fast double-back restore, and Hoi An Browse-by restaurant jump.

## Findings

### RF-01: Search row-audio repeated taps lost the expected result text check

Worker classification: unresolved, possible product issue; not enough proof to call it a confirmed product bug yet.
Current-main follow-up classification: resolved as not reproduced on focused rerun against `7228e5339`.
Severity: none current; keep as harness/watch item only.

Exact repro observed:

1. Launch the app with `--search-query "Cà phê sữa đá"`.
2. Wait for `Results for Cà phê sữa đá`.
3. Find `SearchResult.Audio.viet-menu-drink-ca-phe-sua-da`.
4. Tap that audio button 8 times with short pauses.
5. Assert the stable result text `Cà phê sữa đá` remains present.

Expected:

- Repeated taps on a Search result audio button should play/queue audio only.
- The Search results page should remain stable, with the original result row and system chrome still available.

Actual:

- The test found the Search audio button and tapped it repeatedly.
- The follow-up assertion failed at `native-ios/UITests/AudioTapReliabilityUITests.swift:34` via `verifyRowAudioButton` line 142 because `app.staticTexts["Cà phê sữa đá"]` was not found within the wait.
- Staging logs prove the row and static text existed earlier in the same launch, and later show a changed accessibility tree with many other Search results plus top chrome. The partial bundle was corrupted by the later interrupted cleanup, so I could not extract a clean screenshot/attachment.

Suggested focused test:

- Split the Search row-audio portion into its own test with fresh DerivedData and screenshot/debug-description capture after every tap.
- After each tap, assert all three of these, not just the bare static text:
  - `SearchPageView` still exists.
  - `SearchResult.Audio.viet-menu-drink-ca-phe-sua-da` still exists.
  - `SearchResult.viet-menu-drink-ca-phe-sua-da` still exists and remains hittable/visible.
- If that reproduces, classify as a product bug in Search audio row stability; if it passes, keep it as a harness flake from the combined stress run.

### RF-02: Home Practice direct round did not dismiss on downward drag

Worker classification: possible product bug.
Current-main follow-up classification: resolved as not reproduced on focused rerun against `7228e5339`.
Severity: none current; keep as harness/watch item only.

Exact repro observed:

1. Launch the app with `--seed-returning-user-shelves`.
2. Wait for `HomeView`.
3. Scroll to the Home Practice starter rail.
4. Tap `Home.PracticeStarter.practice` (`Practice pool, Your added phrases`).
5. Confirm `Match the pairs` appears.
6. Confirm the Home caller opens the direct round rather than the Practice hub:
   - `Practice.Match.Hub` absent.
   - `Practice.Match.Topic.essentials` absent.
7. Drag vertically from roughly 58% down the screen to 94% down the screen.
8. Wait for `Practice.Match.Root` to disappear and then for `HomeView` to exist.

Expected:

- A downward dismiss gesture on the Home-launched Practice sheet should close the Practice round and return the traveler to Home/the Practice rail.

Actual:

- The test reached the direct `Match the pairs` round correctly.
- After the downward drag, the log still showed `Practice.Match.Root` present in the accessibility hierarchy and the test timed out waiting for the dismissal/return assertion at `native-ios/UITests/BackSwipeUITests.swift:281`.
- The accessibility tree also contained the Home hierarchy behind the sheet, so this is not a total navigation loss; it is the Practice sheet failing to dismiss from that gesture path.
- After this failure, the broader XCTest command wedged during cleanup and was interrupted, so later selected tests in that chunk are not trustworthy coverage.

Suggested focused test:

- Keep `BackSwipeUITests/testHomePracticePoolOpensDirectRoundWithoutPracticeHubFallback`, but add diagnostic capture immediately after the downward drag.
- Add a companion focused test for the explicit `Practice.Match.Close` button from the same Home caller:
  - If the close button returns Home but drag does not, the bug is specifically sheet gesture dismissal.
  - If both fail, the bug is the Home Practice caller's return/dismiss state.

## Non-Issue / Harness Notes

- `BrowseSearchUITests/testSavedPracticeOpensAsSheetOverSavedTrip` failed once in an isolated rerun with `Unknown kAXError value -25218` after the visible flow had completed, then passed cleanly by itself. I classify that as an AX/XCTest harness issue, not a product bug.
- `AudioTapReliabilityUITests/testBreakdownAudioCardsStayResponsiveAcrossTargetPages` crashed the runner once in a combined chunk, then passed cleanly by itself. I classify the combined-run crash as runner instability, not a product bug.
- The interrupted `route-function-rest` run is not a reliable full-suite result because its result bundle is corrupt and it was manually terminated after cleanup wedged.

## Remaining Risk

- No current route/function product bug remains from RF-01 or RF-02 after focused current-main reruns.
- The worker's interrupted broad batch still should not be treated as a full-suite green; use the focused pass evidence above plus the clean route passes listed here.
- No physical iPhone proof was performed by this worker.
- Paywall stayed out of scope.
