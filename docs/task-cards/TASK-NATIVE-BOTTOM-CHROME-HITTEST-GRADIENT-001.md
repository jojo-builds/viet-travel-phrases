# TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001

## Task Done

The bottom admin chrome is reliable and visually aligned: tapping Home/Browse/Saved/Practice/Search always activates the chrome control instead of content underneath, and the bottom fade/gradient no longer starts high above the admin bar or washes out normal page content.

## Context

Jojo reproduced two bottom admin area bugs on-device:

- Tapping the Browse icon sometimes opens a phrase/detail page instead of Browse. The likely cause is tap-through: the toolbar visual glass is present, but the hit target sometimes lets the underlying scroll content receive the tap.
- The bottom gradient is too high. It begins well above the admin bar, washing out readable page content such as the `At a glance`/`Quick say` area. The gradient should exist only to support bottom chrome legibility and the Liquid Glass effect, not to blanket content above the toolbar.

Reference expectation:

- Tapping Browse from any page should go to the Browse homepage/route every time.
- Content behind/under the glass may shine through, especially near the toolbar, but readable content above the toolbar should not be faded out unnecessarily.
- Native iOS/App Store-style glass often lets content show behind the chrome; avoid a heavy high white fade unless it is needed for legibility.

## Worker Judgment

Find the root cause before patching. Likely areas include hit-testing layers, `allowsHitTesting`, z-index/order of the bottom chrome, `contentShape`, safe-area overlays, gesture priority, and the gradient overlay frame.

Fix the admin chrome system, not one button.

## Required Outcome

- Bottom admin controls always win taps inside their visible/tappable area.
- Tapping Browse repeatedly from phrase pages, listing pages, search, saved, and practice always opens Browse.
- Tapping Home/Saved/Practice/Search remains reliable and does not trigger underlying phrase rows or cards.
- Bottom gradient starts at a visually intentional point near the chrome/bottom safe area, not high above it.
- The fade supports Liquid Glass readability while preserving content visibility above the toolbar.
- Search morph/swipe transition work from `TASK-NATIVE-SWIPE-TRANSITION-POLISH-001` remains intact.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Expected write scope: `native-ios/App/**`, native tests/UI tests, and small task result/screenshot artifacts.
- Do not touch content JSON, generated resources, SQLite, or audio assets.
- Do not change Apple signing/project personal settings.

## Validation

- Reproduce or instrument the tap-through before fixing, and describe the root cause in the result.
- Add or update focused tests for bottom chrome hit targets where practical.
- Build the native app.
- Run targeted app chrome/navigation/UI tests.
- Simulator-check or device-check:
  - from a phrase/detail page with clickable rows behind the bottom chrome, tap Browse repeatedly and confirm every tap opens Browse
  - tap Home/Saved/Practice/Search repeatedly from dense content pages
  - inspect bottom gradient on phrase/detail, Home, Browse, Search, Saved, and Practice
  - confirm gradient does not begin high above the toolbar and does not wash out normal readable content
- Capture screenshot or short screen-recording evidence if practical.
- Run `git diff --check`.
- Run one focused read-only peer review for chrome hit testing, gradient placement, and navigation regression risk.

## Result Contract

Write `docs/task-results/TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001.md` with:

- root cause
- user-visible behavior fixed
- files changed
- validation run
- reviewer outcome
- remaining risks or follow-up, if any
- final `git status --short`

Commit when done.
