# Worker Goal: Traveler-Grade Visual And Function QA

Run time target: at least 3 hours or until a deep current-`main` QA pass is complete and documented.

## Objective

Act like a real traveler using SpeakLocal Vietnam and hunt for visible launch blockers: clipped UI, blank sheets, broken buttons, missing audio affordances, bad back navigation, non-working browse-by links, stale placeholders, and severe lag.

## Starting Context

- Work from current `main` in `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Latest known hot spots from Jojo:
  - Practice sheet title/top controls clipping;
  - missing audio affordance on detail breakdown token such as "Không cay";
  - blank route/sheet after backing out from detail pages;
  - city page save/favorite expectations;
  - city `Browse by` cards should scroll/jump correctly;
  - homepage scroll lag and glass/card design must not be flattened to fix performance.

## Required Reading

Read:

- `/Users/jojolim/Developer/products/speaklocal/app-family/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/AGENTS.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/design/NATIVE_VISUAL_REFERENCE.md`
- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/operations/TESTING_RUNBOOK.md`
- relevant prior latest-feedback reports under `docs/task-results/frontend-qa-2026-07-04/` if needed.

## Work Plan

1. Run a current simulator build/launch on a QA-specific simulator.
2. Exercise Home, Browse, category pages, city pages, listing/detail pages, Search, Saved, and Practice.
3. Use screenshots or UI-test proof for any reported bug.
4. For small safe fixes, create a new feature lane from current `main` and fix there; do not edit `main` directly if app code changes are non-trivial.
5. Validate fixes with focused UI tests or simulator screenshots.
6. Leave a merge recommendation for every fix lane.

## Constraints

- Do not remove visual richness to make things faster.
- Do not strengthen the top chrome into an opaque shield as a shortcut.
- Do not merge paywall.
- Do not claim production-ready from smoke tests alone.
- Do not modify existing dirty city-pages screenshot files.

## Output

Write a report to:

`/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/parallel-goals-2026-07-05/three-hour-push/traveler-qa-report.md`

Include:

- screens/routes tested;
- bugs found and severity;
- fixes made, branches/commits, and validation proof;
- remaining launch blockers;
- manual QA checklist Jojo can repeat on the phone.
