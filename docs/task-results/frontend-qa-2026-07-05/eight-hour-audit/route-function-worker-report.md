# Route And Function Worker Report

Timestamp: 2026-07-06 00:31 Asia/Manila local
Scope: non-paywall front-end route/function audit for Browse, Search, Saved, Practice, Back/Forward, audio buttons, save/unsave loops, and city/menu jumps.
Paywall: isolated; no `feature/paywall`, StoreKit, or paywall route was launched or edited.

## Summary

The route/function worker covered a broad current-baseline UI matrix and found no confirmed app-code route blocker. It did surface two unresolved follow-up checks that should stay in the audit ledger:

- repeated Search row audio stayed tappable, but the UI test later failed to find its expected stable result text
- Home-launched quick Practice completed, but the UI test later failed its expected return-to-Home-practice-rail assertion

Both need a focused rerun with screenshot/result-bundle inspection before calling them product bugs. The worker also hit multiple XCTest infrastructure failures: stale DerivedData disappearance, accessibility snapshot errors, runner-kill during a large audio batch, and one wedged test-session cleanup. Those are not accepted as app green, but they are separate from traveler-facing behavior.

## Confirmed Passes

- Search-to-Browse category handoff passed.
- Search-to-city handoff passed.
- Browse detail back restore passed.
- Browse Practice sheet opens over the current collection and dismisses back to the collection.
- City Browse-by jumps passed in the sampled Hoi An/Hanoi paths.
- City header save and city row save paths passed.
- Menu section jump and menu save/unsave passed.
- Fast double-back restore passed.
- Saved Practice sheet failed once at the XCTest accessibility snapshot layer after returning to Saved, then passed cleanly when rerun by itself.
- Breakdown audio stress for the coffee detail passed when rerun alone, including 20 taps plus follow-up detail pages.

## Unresolved Findings

### FOLLOW_UP: Search row-audio stability assertion needs focused proof

Evidence:

- The worker reported that `AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved` tapped the Search audio control repeatedly and stayed responsive.
- The same run later failed because `app.staticTexts["Cà phê sữa đá"]` was not found within the expected timeout.
- The clean single-test breakdown-audio rerun makes this narrower than the earlier runner-kill failure.

Classification:

- unresolved, likely either a test expectation/visibility issue or a Search row state issue after repeated audio taps.

Recommended next proof:

- rerun only `SpeakLocalNativeUITests/AudioTapReliabilityUITests/testRowAudioButtonsStayResponsiveAcrossSearchMenuAndSaved`
- capture screenshots immediately before and after the Search audio loop
- if the row remains visible under a different accessibility label, repair the test
- if the row disappears or Search loses its result state, repair Search/audio interaction

### FOLLOW_UP: Home quick-practice close should prove the expected Home return anchor

Evidence:

- The worker reported `PracticeUITests/testHomeQuickPracticeCallerCompletesRoundAndReturnsToHomePracticeRail` completed the Home-launched quick Practice round.
- After tapping `Close practice`, the test did not satisfy `HomePracticeStarterRail` within the expected timeout.

Classification:

- unresolved, possible test expectation drift or Home scroll-position restoration issue.

Recommended next proof:

- rerun only `SpeakLocalNativeUITests/PracticeUITests/testHomeQuickPracticeCallerCompletesRoundAndReturnsToHomePracticeRail`
- capture the screen immediately after `Close practice`
- if Home is restored but scrolled away from `HomePracticeStarterRail`, decide whether the product should restore the rail or the test should accept Home root
- if Browse/Practice remains active, repair route dismissal

## Infrastructure Notes

- One large current-baseline UI batch passed eight product tests before later launches failed because the built simulator app path disappeared from DerivedData.
- One Saved Practice failure was an XCTest accessibility snapshot error after the app had already returned to Saved; the isolated rerun passed.
- One large audio/route batch was interrupted by runner-kill/cleanup behavior; the single breakdown-audio rerun passed.
- The final route/function worker process wedged during test-session cleanup after the two unresolved failures had already been identified. No live `xcodebuild` process remained when checked from the orchestrator thread.

## Recommendation

Do not mark the full route/function surface as production-clean from this worker alone. Keep the two follow-up tests above as the next focused route/function proof packet. The already-confirmed route paths are useful evidence, but Search row-audio state and Home quick-practice close behavior need one more clean current-build pass with screenshots.
