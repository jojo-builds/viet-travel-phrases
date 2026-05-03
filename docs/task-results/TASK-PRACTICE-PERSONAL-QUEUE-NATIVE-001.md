# TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001 Result

Status: DONE

Final commit hash: supplied in the worker reply after commit.

## Accepted Steering

- Scenario Mode replaces the visible quiz/deck UX for Practice.
- Scenario copy must feel authored and situation-specific, not generated.
- Weak scenario steps are skipped instead of filled with generic travel copy.
- Visible UI avoids the word `incorrect`; feedback uses softer fit language.
- V1 stays tight to taxi/Grab, restaurant ordering/payment, and hotel/Airbnb check-in/help.
- Personal queues are ranking inputs only, not the product concept shown to users.

## User Flow

- The bottom tab remains `Practice`.
- The Practice hub now leads with `Scenario Mode` and `Travel rehearsal`, with secondary labels for `Review missed`, `Rehearse saved phrases`, and `Trip practice`.
- Sessions follow a native travel rehearsal loop: scene, what a local might say, what the traveler can say, playable audio on response phrases, gentle feedback, what they might say next, recovery framing, source-page link, and next step.
- Completion summarizes scenario readiness with practiced steps, good-fit responses, review count, and restrained Melo placement.

## Starter Scenarios

- Taxi / Grab pickup: covers driver/passenger confirmation and route or wrong-drop-off recovery because it is a high-stress travel moment with strong existing transport phrases.
- Restaurant ordering: covers ordering one item and paying because it is frequent, short, and benefits from calm phrase confidence.
- Hotel check-in: covers reservation/passport check-in and room help because it anchors arrival and practical lodging repair.

## Queue Behavior

- Missed scenario prompts rank first through stable progress IDs.
- Explicit Add-to-Practice page IDs rank second and can pull real phrase candidates into matching scenarios.
- Saved and recent phrase pages rank third, separate from the explicit practice pool.
- Trip fallback remains bounded to the three starter scenario templates and a capped set of real phrase candidates so first render stays testable without loading every future city/category path.

## Interactions

- Kept: choose what you can say, hear the Vietnamese response option, calm feedback, next-local-reply framing, recovery phrase, source-page link, add/remove practice.
- Changed: personal queue and saved/recent review now feed scenario selection rather than separate visible quiz modes.
- Rejected for this task: generic travel trivia, school quiz framing, Bucket List as the main label, punitive answer language, pressure-game mechanics.
- Deferred: speak-aloud, tone-mark mode, street-sign mode, city map, onboarding/paywall, runtime AI, generated audio, analytics, XP/streak/hearts/lives.

## Screenshots

- `docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001/scenario-mode-hub.png`
- `docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001/taxi-grab-scenario.png`
- `docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001/restaurant-scenario.png`
- `docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001/hotel-airbnb-scenario.png`
- `docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001/soft-feedback-state.png`
- `docs/task-results/assets/TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001/completion-state.png`

## Validation

- PASS: `xcodebuild test -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests -only-testing:SpeakLocalNativeTests/AppChromeTests`
  - 85 tests, 0 failures.
- PASS: `xcodebuild test -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/PracticeUITests`
  - 2 tests, 0 failures.
- PASS: `xcodebuild test -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeUITests/PracticeUITests/testScenarioModeProofScreenshots`
  - Refreshed all six proof screenshots.
- PASS: `xcodebuild build -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`
- PASS: Installed and launched the built simulator app with `--practice`.
- PASS: `git diff --check`

## Peer Review

- Read-only peer review found two audio-affordance issues before commit:
  - the authored `They might say` card was playing the answer phrase audio;
  - answer-row speaker icons looked playable but selected the answer.
- Both were fixed: the authored local line no longer shows mismatched audio, and each response option now has a separate playable `AudioSpeakerButton`.
- Residual risk: the first scenario screen is intentionally information-rich, so smaller-device and Dynamic Type polish should be a follow-up pass.

## Open Product Questions

- Should Scenario Mode eventually expose city-specific scenario packs, or should city context stay implicit through phrase ranking?
- Should the local-person line get authored/bundled audio later, or should audio stay limited to traveler response phrases?
- How much Melo should appear inside session feedback versus only hub/completion confidence moments?

## Recommended Next Task

Run a smaller-device and Dynamic Type Scenario Mode polish pass focused on density, bottom-chrome occlusion, and audio affordance clarity, then expand authored scenario coverage only after the first three scenes stay polished.

Process feedback: NONE
