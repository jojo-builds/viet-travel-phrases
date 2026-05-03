# TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001 Result

## Status

Done. Native bottom chrome hit testing and the bottom separation gradient were fixed in the shared SwiftUI chrome/design layer without changing generated content JSON, SQLite resources, bundled audio, signing settings, or project membership.

## Root Cause

- The visible dock/search chrome did not have one shared bottom hit-test envelope. Taps inside glass padding or near control edges could fall outside the actual button surfaces and reach dense scroll content behind the overlay.
- Dock and search controls exposed their visible shape, but the outer tappable frames were not pinned as explicit stable shapes at the shared chrome layer.
- `AppChromeLayout.bottomSeparationHeight` was 240 points, and the gradient became opaque too early. That made the lower page content look washed out well above the toolbar.

## Behavior Fixed

- `AppShellView` now wraps `staticBottomChromeContent` in a transparent full-width bottom envelope with a rectangular `contentShape` and a no-op tap owner, so the bottom admin band owns taps while the real Home, Browse, Saved, Practice, and Search buttons keep their existing actions.
- Dock buttons and the Search island/search-origin buttons now have explicit outer frames and hit shapes.
- The search morph identifiers and previous swipe-transition behavior remain intact.
- The bottom separation gradient is now a shorter 132-point chrome-local fade, remains non-interactive by policy, and uses softer stops that stay transparent above the toolbar.

## Files Changed

- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/Tests/AppChromeTests.swift`
- `native-ios/UITests/AdminChromeUITests.swift`
- `docs/task-results/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001.md`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/*.png`

## Validation

- `git status --short` before edits: unrelated untracked `docs/design/homepage/visual-refresh-v3/` was present and left unstaged.
- Red test check: the new focused layout policy tests failed before production code existed because `AppChromeLayout.bottomHitTestEnvelopeHeight` and `AppChromeLayout.chromeSeparationAllowsHitTesting` were not defined.
- `xcodegen generate`: skipped; no new Swift files or project membership changes.
- `git diff --check`: passed.
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`: passed.
- Focused unit check for the new bottom chrome layout tests: passed, 2 tests.
- New UI regression check `AdminChromeUITests/testBottomChromeControlsWinEdgeBiasedTapsOverDenseDetailContent`: passed.
- Screenshot proof check `AdminChromeUITests/testBottomChromeGradientProofScreenshots`: passed and generated six simulator screenshots.
- Targeted native suite: `AppChromeTests`, `AdminChromeUITests`, and `BackSwipeUITests` passed together. `AppChromeTests` executed 68 tests with 0 failures; `AdminChromeUITests` executed 5 tests with 0 failures; `BackSwipeUITests` executed 3 tests with 0 failures.

## Proof Assets

- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/detail-bottom-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/home-bottom-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/browse-bottom-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/search-bottom-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/saved-bottom-chrome.png`
- `docs/task-results/assets/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001/practice-bottom-chrome.png`

All six proof screenshots are simulator PNGs at 1206 x 2622.

## Reviewer Outcome

Read-only local review: PASS. The diff stays in the shared chrome/design layer plus focused tests and proof/result artifacts. The hit-test fix is envelope-based rather than per-screen, the gradient remains non-interactive, search morph identifiers are preserved, and targeted BackSwipe coverage still passes. No generated resources, content data, audio files, signing settings, or project files were changed.

## Remaining Risks

- This was proven on the iPhone 17 Pro simulator. Because the original symptom was touch precision near the bottom chrome, a quick physical-device tap pass is still useful before release.
- The proof screenshots verify the softer gradient and visible chrome state; the edge-biased UI test is the stronger proof for tap dispatch.

## Final Closeout `git status --short`

```text
?? docs/design/homepage/visual-refresh-v3/
?? docs/task-cards/TASK-PRACTICE-LEARNING-LOOP-RD-001.md
```

Both entries are unrelated untracked work and were left unstaged. No scoped task changes remain uncommitted.
