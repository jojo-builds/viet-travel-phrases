# TASK-HOME-LIQUID-GLASS-REDESIGN-001

## Summary

Implemented the new SpeakLocal Home surface using the supplied Apple-style liquid glass direction:

- Hero masthead with SpeakLocal Vietnam brand, large editorial title, and search entry.
- Continue card, quick phrase cards, practice scenario rail, saved-for-later cards, relationship greeting rows, situation rows, city cards, and practice list.
- App-owned generated image assets for the Home cards and rails.
- Home proof screenshots at top, middle, lower, and final bottom scroll positions.

The larger card scale is intentional; the final proof keeps labels readable and confirms the bottom content can clear the floating dock.

## Proof

- Top: `docs/task-results/assets/TASK-HOME-LIQUID-GLASS-REDESIGN-001/home-liquid-top.png`
- Mid: `docs/task-results/assets/TASK-HOME-LIQUID-GLASS-REDESIGN-001/home-liquid-mid.png`
- Lower: `docs/task-results/assets/TASK-HOME-LIQUID-GLASS-REDESIGN-001/home-liquid-lower.png`
- Bottom: `docs/task-results/assets/TASK-HOME-LIQUID-GLASS-REDESIGN-001/home-liquid-bottom.png`

## Validation

- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests/testHomeChromeUsesHomeSelectedDockWithSearchIsland -only-testing:SpeakLocalNativeTests/AppChromeTests/testHomeSituationRowsUseStableCardMetrics`
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/AdminChromeUITests/testHomeLiquidGlassRedesignProofScreenshots`
- `git diff --check`

## Notes

- Generated card illustrations are app-owned bitmap assets, not externally licensed photos.
- Existing bottom chrome remains active; Home content uses the established scroll clearance and the bottom proof shows final content above the dock.
