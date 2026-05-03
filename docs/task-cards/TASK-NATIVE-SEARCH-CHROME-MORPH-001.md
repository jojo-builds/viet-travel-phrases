# TASK-NATIVE-SEARCH-CHROME-MORPH-001: Search And Admin Chrome Morph Together

## Task Done

The bottom admin chrome and expanded search field animate as one coordinated Liquid Glass morph in both directions: when Search expands, the dock yields smoothly; when the user taps the left return icon from expanded Search, the search field shrinks while the admin dock returns without overlapping, overtaking, jumping, or visually racing over the text field.

## Context

Jojo found a visible animation bug in the bottom chrome. Repro:

1. Navigate to the Search page.
2. Let the search text field be fully expanded.
3. The expanded search field has an icon on the left representing the previous admin page, such as Home or Browse.
4. Tap that left icon to return to the previous admin page.

Observed: the admin bar grows/returns on top of the expanded search field before the search field has shrunk, so the two glass surfaces visibly overlap. This breaks the Liquid Glass feel; it should look like one flowing morph, not one component covering another.

Related recent work:

- `TASK-NATIVE-SWIPE-TRANSITION-POLISH-001`
- `TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001`

Those fixed other bottom-chrome behaviors, but this specific expanded-search-to-dock morph still needs polish.

## Worker Judgment

Use GPT-5.5 judgment. This is native UI polish, not a redesign. Preserve the existing bottom admin chrome model, icons, route behavior, hit-testing improvements, and search page behavior. The goal is coordinated timing/layout/state, not a new visual direction.

Think of the search island and admin dock as linked glass components. If one grows, the other should make space at the same time. If one shrinks, the other should return at the same time. Avoid temporary overlap unless it is intentionally masked and visually invisible.

## Required Outcome

- Fix the expanded Search -> previous admin page transition so the search field and admin dock animate together.
- Fix the reverse direction if needed: previous admin page -> expanded Search should also avoid the search island sliding over or racing ahead of the dock.
- Confirm behavior for at least Home and Browse as the left return icon source, and check Saved/Practice if the same path exists.
- Preserve the current intended no-keyboard and keyboard-up search behavior:
  - no wordy `Cancel` button;
  - no duplicate clear buttons;
  - left icon reflects the previous admin route;
  - keyboard-up mode remains visually clean.
- Keep bottom chrome hit-test protection from `TASK-NATIVE-BOTTOM-CHROME-HITTEST-GRADIENT-001`.
- Capture simulator proof frames/screenshots that show before, mid-transition, and final states, or provide a reliable UI test/proof harness if mid-transition screenshots are hard to capture.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own native SwiftUI chrome/search animation code, focused tests, and task result/proof artifacts.
- Do not edit content sources, generated resources, SQLite data, audio files, mascot assets, or signing settings.
- Do not redesign the homepage, Browse page, Search content, or phrase listing template.
- Do not change page routing semantics except as needed to make the existing transition visually coherent.

## Validation

- Run `git diff --check`.
- Run focused native tests for app chrome/search behavior.
- Build on an iPhone simulator.
- Run or add focused UI coverage for Search expanded -> Home/Browse and Home/Browse -> Search transitions.
- Use one focused peer review or self-review checklist if the change is narrow; reviewer/checklist should explicitly inspect for overlap, double-animation, wrong icon direction, hit-test regression, and keyboard-up regressions.

## Result Contract

Write `docs/task-results/TASK-NATIVE-SEARCH-CHROME-MORPH-001.md` with:

- status: done or blocked;
- commit hash;
- root cause summary;
- animation behavior changed;
- files changed;
- simulator proof artifacts;
- validation commands and outcomes;
- peer review or self-review outcome;
- remaining risks;
- final `git status --short`.
