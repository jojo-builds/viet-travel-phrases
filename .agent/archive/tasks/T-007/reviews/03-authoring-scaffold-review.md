# Authoring Scaffold Review

- Verdict: pass after one fix

## What was checked

- whether the next translation task can start directly from the new artifacts
- whether the CSV ranking is concrete, non-empty, and coherent with the source notes
- whether rewrite-before-translation rows are surfaced clearly enough to avoid wasted translation work

## Findings

1. The ranked CSV is concrete enough to start the next translation pass without redoing orientation.
2. Initial draft issue: `source-notes.md` called out three weak coffee-baseline rows, but the CSV only demoted two of them.
3. Strength after fix:
   - coffee rows `1`, `2`, and `3` are now consistently treated as low-priority rewrite candidates
   - bargaining rows are also explicitly pushed out of the early translation wave

## Fix applied

- Added `italian-coffee-shop-2` to `content-draft/italian/first-wave-priority.csv` as a low-confidence `rewrite-before-translation` row.

## Residual caution

- The next translation task should still decide the exact replacement coffee intents before translating those flagged rows.
