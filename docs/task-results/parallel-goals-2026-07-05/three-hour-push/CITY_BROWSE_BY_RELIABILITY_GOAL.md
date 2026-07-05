# City Browse-By Reliability Goal

## Objective

Investigate and, if needed, fix city Browse-by reliability on current `main`.

The current QA signal is mixed: some Hoi An and Da Nang Browse-by jumps passed, but the broader Browse/Search class reported failures around:

- `testCityBrowseCardJumpClearsTopAdminChrome`;
- `testCityBrowseCardSelectionJumpsToMatchingSection`;
- city Browse-by cards being hard to make comfortably tappable after scrolling.

The user explicitly noticed city Browse-by links not scrolling to their intended page section, so this is launch-relevant.

## Constraints

- Work from `/Users/jojolim/Developer/products/speaklocal/app-family`.
- Start by verifying current `main`; do not assume the pre-fix findings are still current.
- If app-code edits are needed, create a feature branch/worktree from current `main` before editing.
- Keep paywall isolated.
- Preserve the existing visual design. Do not remove glass, imagery, or panel styling to make tests pass.
- Use a dedicated simulator for UI proof.

## Suggested Investigation

- Read the city Browse-by implementation and its existing tests.
- Reproduce on at least two city pages, including Da Nang and Hoi An.
- Check whether the failure is:
  - data target mismatch;
  - card hit target or horizontal rail gesture issue;
  - scroll anchor not exposed or not resolved;
  - sticky top admin chrome blocking taps;
  - test harness coordinate fragility.
- If you fix code, add or strengthen a focused regression test.

## Validation

Run the smallest honest validation for any change, likely including:

- `git diff --check`;
- `node scripts/guard-native-only.js`;
- focused city Browse-by UI tests;
- screenshot proof after a city Browse-by jump lands on the intended section.

## Report

Write:

`docs/task-results/parallel-goals-2026-07-05/three-hour-push/city-browse-by-reliability-report.md`

Include:

- root cause or strongest current hypothesis;
- current repro steps;
- files changed, if any;
- tests/screenshots;
- branch/commit if code changed;
- whether it is safe to merge to `main`.
