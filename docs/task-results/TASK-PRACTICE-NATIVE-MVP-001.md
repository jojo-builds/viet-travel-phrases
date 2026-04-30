# TASK-PRACTICE-NATIVE-MVP-001 Result

## Status

done

## Commit Hash

Recorded in the worker final reply after commit creation. The committed result file cannot know its own final Git hash before it is staged and committed.

## Accepted Steering Recorded

- Practice is a fourth item in the existing native bottom bar; the Search island remains separate.
- Saved Review is its own mode and does not automatically mix saved pages into the main Bucket List.
- The MVP scope is Hanoi Bucket List first, with real starter/Hanoi candidates so Practice is immediately testable offline.
- Melo is represented by a compact native placeholder/hook only; final art remains a later asset task.
- City metadata is preserved on practice candidates and prompts: city, city subcategory, and place fields remain optional model fields for future city-specific deck work.

## Practice Modes Implemented

- Hanoi Bucket List: explicit practice pages first, then seeded real Hanoi/audio-backed phrase candidates.
- Saved Review: prompts generated from `savedPageIDs` only.
- Missed Review: prompts reappear when local progress records a missed stable prompt ID.
- Prompt kinds: listen and pick, English to Vietnamese, Vietnamese to English, and missing token.

## Reward And Mascot Behavior

The reward loop is local readiness, not XP. Correct answers increment ready marks, missed answers become calm review prompts, and completion shows a small "Bucket List updated" moment with practiced/correct/ready counts.

Melo appears as a small native placeholder mark in the hub/completion flow, with no final mascot art committed in this task.

## Data Sources Used

Practice uses the bundled SQLite phrase graph instead of the empty `practice_deck` / `practice_item` tables. The adapter joins real phrase/page/audio/content/city tables including `phrase`, `phrase_page`, `audio_usage`, `audio_asset`, `page_section`, `page_section_item`, `phrase_city_tag`, `city`, `city_subcategory`, and `city_place`.

Local progress persists privately in `UserDefaults`, keyed by stable prompt IDs.

## Simulator Proof Screenshots

- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-hub.png`
- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-session.jpg`
- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-feedback.jpg`
- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-source-link.jpg`
- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-completion.jpg`
- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-add-from-source.jpg`
- `docs/task-results/assets/TASK-PRACTICE-NATIVE-MVP-001/practice-hub-after-add.jpg`

The simulator flow covered launching Practice with `--practice`, starting a session, answering a prompt, viewing calm feedback, opening the source page, reaching completion, adding a phrase page to Practice, and returning to the Practice tab with the added count reflected.

## Validation Commands And Outcomes

- `xcodebuild test -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` -> ran; current full suite fails outside this task in legacy `PhrasePageFixtureTests` generated JSON fixture expectations (`GeneratedVietContent.catalog` nil / 38 failures). New Practice tests passed in that run.
- `xcodebuild test -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` -> passed; 70 tests, 0 failures.
- `xcodebuild build -quiet -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` -> passed.
- `xcrun simctl install booted .../SpeakLocalNative.app && xcrun simctl launch booted app.speaklocal.vietnam.native --practice` -> passed; app launched on iPhone 17 Pro simulator.
- `git diff --check` -> passed.

## Peer Review Outcome

BUG found and fixed before closeout.

The read-only reviewer flagged that Vietnamese-to-English prompts leaked the answer because answer-option subtitles repeated Vietnamese phrases. The fix now uses non-answer context subtitles for that mode, and `PracticeNativeMVPTests` includes a regression check that Vietnamese-to-English option subtitles do not expose Vietnamese phrases.

The reviewer also noted the hub may still feel visually busy, but treated that as non-blocking polish. Saved/Missed/Practice state separation and the native/Liquid Glass fit were acceptable for MVP after the answer-leak fix.

## Known Product And Design Decisions Still Needed

- Final Melo art and animation direction.
- Exact readiness thresholds and whether city-specific readiness should unlock later Hanoi route marks.
- Future city-specific deck selection beyond the Hanoi MVP seed.
- Whether to add street-sign, tone-mark, pronunciation, or speak-aloud modes in later tasks.
- A later visual polish pass to reduce hub density after broader simulator use.

## Recommended Next Task

Create a native Practice polish task for final Melo assets, hub density tuning, and expanded city-specific deck weighting after the first MVP is exercised on device.
