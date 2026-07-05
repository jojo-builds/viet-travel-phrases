# Deep Visual QA Bug Ledger - 2026-07-05

## Baseline

- Goal started in the orchestrator thread on 2026-07-05 Asia/Manila local time.
- Worktree baseline: dirty `main`, ahead of `origin/main`; paywall remains excluded.
- Prior validation boundary: the 2026-07-04/05 UI sweep proved many functional flows, but Jojo's physical-phone review exposed missing visual/state assertions.

## Active Issues

- `DVQA-001` - Practice saved-match sheet header could be clipped at the native sheet top edge.
  - Status: fixed and re-hardened.
  - Product fix: active native-sheet match rounds now use explicit top chrome clearance; direct-start native sheets get the same top clearance; the header cluster has a UI-test hook.
  - Regression proof: `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound` passed on the Pro Max simulator with `1` executed test, `0` failures, and proof screenshot `/tmp/speaklocal-practice-proof-pro-max/saved-round-start.png`.
  - Broader proof: `PracticeUITests` full run had `12 / 13` pass, with the only failure caused by stale test copy; the updated home quick-practice test then passed with `1` executed test, `0` failures.

- `DVQA-002` - "Not spicy" breakdown card lacks a visible speaker affordance.
  - Status: fixed and validated.
  - Evidence: Jojo screenshot shows `Không cay` card without speaker while `nhé` and related variation cards show speaker.
  - Root fix: added exact bundled audio for `Không cay`, added manifest entry `breakdown-authored-khong-cay`, and taught SQLite generation to reuse exact normalized audio for breakdown tokens when explicit token audio is absent.
  - Regression proof: `PhrasePageFixtureTests/testNotSpicyBreakdownCardHasPlayableAudio` passed inside the focused unit batch; `AudioTapReliabilityUITests/testBreakdownAudioCardsStayResponsiveAcrossTargetPages` passed and now includes the `Không cay` target path.

- `DVQA-003` - Back/back navigation can leave a blank pull-up canvas after category -> phrase/detail.
  - Status: fixed and validated.
  - Evidence: Jojo screenshot shows empty white pull-up over photo backdrop after tapping back twice from a Browse category/detail path.
  - Root fix: detail-to-Browse back navigation now arms a Browse-root reset and consumes it when returning from a Browse collection to root Browse, forcing root content back to the top instead of preserving the hidden photo-backed sheet state.
  - Regression proof: `BrowseSearchUITests/testFastDoubleBackFromBrowseDetailRestoresBrowseRootContent` passed in the final focused Browse matrix.

- `DVQA-004` - City pages lack a save/favorite control.
  - Status: fixed and validated.
  - Evidence: Jojo screenshot of Hoi An city page shows back and more controls, but no save/favorite control.
  - Product fix: city collection headers now expose a save/remove heart action backed by saved trip city IDs.
  - Regression proof: `LocalUserIntentStoreTests/testSavedCityHubIDsPersistAsTripItems`, `BrowseSearchUITests/testCityHeaderSaveAddsCityToSavedTrip`, and `BrowseSearchUITests/testDaNangCityRowSaveAddsItemToSavedTrip` passed.

- `DVQA-005` - City page Browse-by cards/links do not jump or route as expected.
  - Status: fixed and validated.
  - Evidence: Jojo reports Browse-by links on city pages do nothing.
  - Root fix: city Browse-by section targets now use direct scroll markers inside a non-lazy group container and a viewport anchor that clears the pinned admin chrome.
  - Regression proof: `BrowseSearchUITests/testCityBrowseCardSelectionJumpsToMatchingSection`, `testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`, `testCityBrowseCardJumpClearsTopAdminChrome`, and `testBrowseCityTopSectionPillJumpsToNounGroup` passed in the final focused Browse matrix.

## Five Whys

### Why the Previous Pass Missed These

1. Why did the Practice clipping pass? The old checks asserted flow and window visibility, not the visible native sheet mask and header clearance.
2. Why was the audio gap missed? Existing data tests trusted explicit audio keys and did not assert that each visible breakdown token with a speaker affordance had a manifest-backed playable clip.
3. Why was the blank back/back state missed? The prior test walked normal back behavior, not rapid detail -> collection -> root back while photo-backed sheet state was still active.
4. Why were city save and Browse-by issues missed? Coverage existed for nearby menu/category flows and one city path, but not the full city hub interaction contract Jojo was manually checking.
5. Why did false greens happen? At least one focused command used the wrong XCTest selector and reported success with `Executed 0 tests`; the new harness parses `.xcresult` counts and fails receipts with zero executed tests.

### Process Changes Made

- Verify every focused selector exists before launching long UI runs.
- Treat xcodebuild exit code as insufficient; parse final `.xcresult` `testsCount`, failure count, and per-test status.
- Add visual/layout probes only for UI-test builds and assert against geometry, not just labels.
- Keep screenshot proof for visual repairs, especially native sheet/chrome issues.
- Separate real product failures from stale or too-brittle QA driver assumptions, then rerun the repaired harness.

## Validation Log

- `xcodebuild` unit focused batch: `4` tests, `0` failures. Covered not-spicy audio, speaker manifest policy, audio session setup, and city saved-trip persistence.
- `BrowseSearchUITests` focused matrix: `8` tests, `0` failures. Covered double-back blank state, city header save, city row save, city Browse-by jumps, top-admin clearance, and Saved unsave.
- `AudioTapReliabilityUITests`: `2` focused tests, `0` failures. Covered breakdown audio cards and row audio taps across search/menu/saved.
- `BackSwipeUITests`: `13` tests, `0` failures. Covered direct detail, Browse, Home city/phrase/practice, forward history, and tab back chains.
- `PracticeUITests/testPracticeSavedOpensSingleFourPairMatchRound`: `1` test, `0` failures on Pro Max simulator with screenshot proof.
- `PracticeUITests/testHomeQuickPracticeCallerCompletesRoundAndReturnsToHomePracticeRail`: `1` test, `0` failures after correcting the stale direct-round expectation.
- `PracticeUITests` full class before the stale-expectation patch: `13` tests, `1` failure; the other `12` Practice flows passed.
- Broad post-fix UI sweep: `135` tests executed, `132` passed, `1` skipped, and `2` failed. The failures were triaged as harness/configuration gaps:
  - city V2.2 render-proof batch now skips generic full-suite runs when `SPEAKLOCAL_V2_2_RENDER_PROOF_MANIFEST` is absent.
  - Home quick-practice test now launches explicitly to Home and requires visible-window geometry before tapping the quick-practice card; this fixed an offscreen/stale accessibility tap that left the app on Home instead of opening Practice.
- Focused rerun after those harness repairs: `2` selected tests, `1` pass, `1` intentional skip, `0` failures.
- Physical iPhone proof: Debug build, install, and launch passed on Jojo's active physical iPhone; post-build signing hygiene reported the repo signing files stayed clean.
- Final post-harness app-code iPhone proof: after the Home quick-practice visible-geometry fix and city render-proof skip repair, the corrected `main` working tree built, installed, launched, and passed signing hygiene again on Jojo's active physical iPhone.
