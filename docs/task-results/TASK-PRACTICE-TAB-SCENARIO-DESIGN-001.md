# TASK-PRACTICE-TAB-SCENARIO-DESIGN-001

## Summary

The Practice tab was not using the current Scenario Mode design. The designs were not missing from the workspace; the live bottom-tab route still rendered the older Practice surface.

This pass updated the active `PracticeView` route so tapping Practice opens a guided Scenario Mode surface:

- Hero copy now uses `Practice what happens next`.
- The primary card uses `Continue rehearsal` and `Start scene`.
- Scenario rows use the cleaner `Try a scenario` list.
- The “how it works” area matches the saved/recent/follow-up model without quiz wording.
- Scene screens remain guided rehearsal, not quiz flow.
- Decorative glass card strokes no longer intercept taps.
- Scenario navigation scrolls each new moment back to the top.

## Proof

Simulator screenshots:

- `docs/task-results/assets/TASK-PRACTICE-TAB-SCENARIO-DESIGN-001/scenario-mode-hub.png`
- `docs/task-results/assets/TASK-PRACTICE-TAB-SCENARIO-DESIGN-001/taxi-grab-moment-1.png`
- `docs/task-results/assets/TASK-PRACTICE-TAB-SCENARIO-DESIGN-001/taxi-grab-moment-2.png`
- `docs/task-results/assets/TASK-PRACTICE-TAB-SCENARIO-DESIGN-001/completion-state.png`
- `docs/task-results/assets/TASK-PRACTICE-TAB-SCENARIO-DESIGN-001/restaurant-scenario.png`
- `docs/task-results/assets/TASK-PRACTICE-TAB-SCENARIO-DESIGN-001/hotel-airbnb-scenario.png`

## Validation

Passed:

```sh
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/PracticeUITests/testScenarioModeProofScreenshots
```

```sh
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests -only-testing:SpeakLocalNativeUITests/PracticeUITests/testScenarioModeReadsAsGuidedRehearsal
```

```sh
git diff --check
```

Forbidden-path scan was clean for audio, signing/project settings, app info, and asset catalogs.

## Notes

This is a native UI route change, so `native-ios/App/**` changed intentionally. No content resources, audio, app assets, signing files, or Xcode project settings changed.
