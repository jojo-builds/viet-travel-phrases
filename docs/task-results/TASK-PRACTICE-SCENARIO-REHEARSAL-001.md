# TASK-PRACTICE-SCENARIO-REHEARSAL-001

## Summary

Converted Practice Scenario Mode from a quiz/check-answer surface into guided travel rehearsal.

The current flow is now:

- Practice home: "Practice real travel moments" with "Start scene".
- Active scene: "Moment", "They may say", "Recommended reply", "Other useful replies", "If you are unsure", and "Next moment".
- Completion: "Scene complete", "Practice another scene", "Back to Practice", "Find another phrase", and "Phrase pages used".

The implementation avoids user-facing quiz language such as "Check fit", "Good fit", "Review missed", "correct", "incorrect", "quiz", "source page", and "reply options" on the Scenario Mode surface.

## Changed Files

- `native-ios/App/Views/PracticeView.swift`
- `native-ios/App/Models/PracticeModels.swift`
- `native-ios/App/Models/PracticeScenarioBuilder.swift`
- `native-ios/App/Models/PracticeScenarioModels.swift`
- `native-ios/Tests/PracticeScenarioModeTests.swift`
- `native-ios/UITests/PracticeUITests.swift`
- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/*`

The persistent listing-page skill was also updated outside this repo:

- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`

## Proof Screenshots

- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/scenario-mode-hub.png`
- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/taxi-grab-moment-1.png`
- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/taxi-grab-moment-2.png`
- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/completion-state.png`
- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/restaurant-scenario.png`
- `docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001/hotel-airbnb-scenario.png`

## Validation

Passed:

```sh
xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests -only-testing:SpeakLocalNativeUITests/PracticeUITests/testScenarioModeReadsAsGuidedRehearsal
```

Passed:

```sh
touch /tmp/speaklocal-practice-scenario-proof-enabled
rm -rf docs/task-results/assets/TASK-PRACTICE-SCENARIO-REHEARSAL-001
xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeUITests/PracticeUITests/testScenarioModeProofScreenshots
```

Passed:

```sh
git diff --check
```

## Notes

- Scenario Mode still references existing phrase/page candidates; this task did not add AI-written conversation content.
- Older internal progress storage still has correct/missed enum names for compatibility, but Scenario Mode does not surface those labels to users.
- No audio, signing, provisioning, or Xcode project setting files were changed.
