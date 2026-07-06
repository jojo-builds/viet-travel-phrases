# App Store Screenshot Capture Goal

## Objective

Create a current-`main` App Store screenshot and preview-planning proof pack for SpeakLocal Vietnam without using App Store Connect credentials.

## Success Criteria

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family` on current `main`.
- Confirm the exact commit under test at the top of the report.
- Build, install, and launch the native SwiftUI app in a dedicated simulator/profile.
- Capture at least these user-facing states as stable screenshots:
  - Home first screen
  - Browse root
  - Food or Drink Menu page with section/top-admin chrome visible
  - City page with Browse-by/section UI visible
  - Search results for a traveler query
  - Saved
  - Practice round sheet
- Prefer 6.9-inch iPhone portrait screenshots if available; if only a same-family simulator is available, state the fallback clearly.
- Save screenshots under `docs/task-results/parallel-goals-2026-07-05/three-hour-push/app-store-screenshot-proof/`.
- Write `docs/task-results/parallel-goals-2026-07-05/three-hour-push/app-store-screenshot-capture-report.md` with:
  - exact commit and simulator/device used;
  - screenshot inventory;
  - what can be used immediately in App Store planning;
  - what still requires Jojo/App Store Connect/manual approval;
  - any visual issues that should block marketing screenshots.

## Constraints

- Do not edit app code unless an unavoidable screenshot-blocking bug is found; if that happens, stop and report the bug instead of patching.
- Do not merge or include paywall.
- Do not expose raw device identifiers or signing/team details.
- Do not claim App Store submission is complete; this is screenshot/preview readiness only.
