# TASK-NATIVE-AUDIO-TAP-RELIABILITY-001 Result

## Status

Done. Native audio tap reliability was fixed in the SwiftUI interaction layer and playback cache path without changing generated content JSON, SQLite resources, audio assets, runtime AI, network behavior, or signing settings.

## Root Cause

- Breakdown token audio used a small visible speaker target inside horizontally scrolling cards, so normal taps could miss the playable control.
- Some Home/Search phrase rows placed speaker controls inside larger navigation buttons, creating competing nested-button hit paths.
- `AudioPlaybackService` cached only successful first starts after this task; before the fix, failed player starts were not explicitly guarded as a cache failure path.
- Detail launch proof could race the first-breakdown scroll target because the scroll task marked itself complete before the delayed scroll actually ran.

## Behavior Fixed

- `AudioSpeakerButton` now keeps the requested visual size while exposing at least a 44 x 44 native tap target with an explicit circular hit shape and optional accessibility identifier.
- Playable breakdown token cards are now one first-class tappable surface. The whole card plays the token audio, and the visible speaker indicator is non-nested. Missing-audio cards show a muted state.
- Home and Search phrase rows now keep audio buttons as siblings of navigation buttons, matching the safer Browse collection row pattern.
- Repeated same-clip taps restart the cached player predictably. Failed first starts and failed cached replay preparation clear or avoid poisoned cached state.
- The first-breakdown launch scroll target now marks completion only after the delayed scroll executes.

## Files Changed

- `native-ios/App/Models/AudioAssetManifest.swift`
- `native-ios/App/Views/AudioControls.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Views/SearchPageView.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/Tests/PhrasePageFixtureTests.swift`
- `native-ios/UITests/AudioTapReliabilityUITests.swift`
- `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- `docs/task-results/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001.md`
- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/*.png`

## Validation

- `git status --short` before edits: clean.
- Red test check: a focused `AudioSpeakerButton.minimumHitSize` / `tapTargetSize` assertion failed before the production hit-target API existed.
- `cd native-ios && xcodegen generate`: passed; required because `AudioTapReliabilityUITests.swift` was added.
- `git diff --check`: passed after final changes.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`: passed after final changes.
- Targeted unit/chrome tests passed: `PhrasePageFixtureTests/testSpeakerButtonKeepsReliableMinimumTapTarget`, `testBreakdownAudioReliabilityExamplesResolvePlayableAudio`, `testAudioPlaybackServiceDoesNotCacheFailedFirstStart`, `testAudioPlaybackServiceClearsCachedPlayerAfterFailedReplayPrepare`, plus full `AppChromeTests`; 71 selected tests, 0 failures.
- Targeted UI stress test passed: `AudioTapReliabilityUITests/testBreakdownAudioCardsStayResponsiveAcrossTargetPages`; coffee `Cho tôi` tapped 20 times, then `Xin chào` and quiet-room breakdown audio tapped 8 times each, with the detail page and bottom Search chrome still present.
- Broader `PhrasePageFixtureTests` class was attempted and still has existing generated-catalog fixture drift unrelated to this task: 38 failures. Representative failures include `GeneratedVietCatalog` nil unwraps, missing generated detail pages/search results, and existing search-priority/count mismatches such as expected `viet-family-hotel-room-hot` but got `viet-hello-ba-way-how-are-you`.

## Proof Assets

- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/viet-family-food-coffee-black-breakdown.png`
- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/viet-family-food-coffee-black-after-taps.png`
- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/viet-phrase-polite-1-breakdown.png`
- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/viet-phrase-polite-1-after-taps.png`
- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/viet-phrase-hotel-quiet-room-breakdown.png`
- `docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/viet-phrase-hotel-quiet-room-after-taps.png`

All six proof screenshots are simulator PNGs at 1206 x 2622. The UI stress test proves tap dispatch and stable navigation/chrome state; it does not capture an acoustic waveform.

## Reviewer Outcome

Read-only local review: PASS. The diff keeps the fix scoped to native hit testing, sibling controls, breakdown-card tap routing, playback cache hardening, tests, project membership, and proof/result artifacts. No generated catalog JSON, SQLite database, bundled audio, runtime AI/network behavior, or personal signing settings were edited.

## Remaining Risks

- Simulator UI tests cannot independently prove audible speaker output. A quick physical-device audible pass is still useful before external release.
- Existing broad fixture drift in `PhrasePageFixtureTests` should be cleaned up separately; the targeted audio reliability tests and AppChrome tests passed.

## Final `git status --short`

```text
 M native-ios/App/Models/AudioAssetManifest.swift
 M native-ios/App/Views/AppShellView.swift
 M native-ios/App/Views/AudioControls.swift
 M native-ios/App/Views/PhraseListingView.swift
 M native-ios/App/Views/SearchPageView.swift
 M native-ios/SpeakLocalNative.xcodeproj/project.pbxproj
 M native-ios/Tests/PhrasePageFixtureTests.swift
?? docs/task-results/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001.md
?? docs/task-results/assets/TASK-NATIVE-AUDIO-TAP-RELIABILITY-001/
?? native-ios/UITests/AudioTapReliabilityUITests.swift
```
