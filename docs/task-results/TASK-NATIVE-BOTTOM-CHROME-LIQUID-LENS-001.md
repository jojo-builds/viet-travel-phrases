# TASK-NATIVE-BOTTOM-CHROME-LIQUID-LENS-001

## Summary

The bottom chrome selected state now uses one dock-level liquid-glass lens that slides between Home, Browse, Saved, and Practice. Previously each selected icon owned its own subtle background, so the transition mostly looked like an icon color swap.

Changes:

- Added a persistent `AppShellDockSelectionLens` in the dock cluster.
- Animated the lens by selected dock index with a snappy 0.42 second transition.
- Kept dock icons and labels above the lens so selected icons remain readable.
- Added a native `glassEffectID` to the lens for iOS 26 Liquid Glass grouping.
- Added light spectral/glass sheen inside the lens while keeping the hit target on the real buttons.
- Added layout tests for the lens z-order and transition duration.

## Proof

Simulator proof screenshots:

- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-LIQUID-LENS-001/home-selected-lens.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-LIQUID-LENS-001/home-search-origin-and-field.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-LIQUID-LENS-001/home-returned-lens.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-LIQUID-LENS-001/saved-selected-lens.png`

## Validation

Passed:

```sh
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests/testDockSelectionLensUsesAppStoreStylePillMetrics -only-testing:SpeakLocalNativeTests/AppChromeTests/testSearchChromeMorphKeepsSearchGlassAboveReturningDock -only-testing:SpeakLocalNativeUITests/AdminChromeUITests/testBottomChromeForegroundMorphProofScreenshots
```

```sh
git diff --check
```

Forbidden-path scan was clean for audio, generated content resources, signing/project settings, app info, and asset catalogs.
