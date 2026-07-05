# Final Gate: Hanoi 001-050 Humanized City Copy

Date: 2026-05-26
Reviewer: Codex read-only final production gate
Scope:
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_001_025_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_026_050_humanized.json`
- Compared against `content-draft/viet/city-library/handwritten-copy/hanoi.json` indices 0-49

## Summary

Reviewed all 50 visible entries across summary, context, tip, rationale, and every section title/body.

safe_for_import: 46
unsafe_for_import: 4

Hanoi 001-050 does not fully pass. Most entries now read as natural mobile travel copy, with no visible reviewer/database/prompt/process language, no banned `traveler` / `travelers` / `anchor` / `place name` / `helps` / `useful because` wording, and no command-like reviewer headings. The remaining unsafe entries fail because their visible `quick-say` section bodies are empty.

## Preservation Checks

- Page order and pageIDs match source indices 0-49.
- All source section IDs are present in the humanized entries.
- PhraseIDs are preserved exactly for the four phrase-backed entries:
  - `city-hanoi-place-bun-cha`: `food-menu`, `food-3`, `coffee-7`
  - `city-hanoi-place-dinh-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
  - `city-hanoi-place-giang-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
  - `city-hanoi-place-loading-t-cafe`: `coffee-1`, `v500-dire-navi-do-i-go-upstairs`, `coffee-4`, `coffee-7`
- Note: entries 001-025 preserve the same section ID set, but many place `quick-say` before `place-brief`. This report treats that as ID-preserved, not deletion, because the requested IDs remain present.

Validation command run:

```sh
node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js
```

Result:

```txt
Humanizer chunk validation passed. entries=200 warnings=0
```

## Unsafe Entries

### `city-hanoi-place-bun-cha`

Snippet:

```txt
[quick-say] Useful Phrases ::
```

Reason: visible section body is empty. This fails the no deletion or thin bodies gate for section title/body review, even though phraseIDs are preserved.

### `city-hanoi-place-dinh-cafe`

Snippet:

```txt
[quick-say] Useful Phrases ::
```

Reason: visible section body is empty. This fails the no deletion or thin bodies gate for section title/body review, even though phraseIDs are preserved.

### `city-hanoi-place-giang-cafe`

Snippet:

```txt
[quick-say] Useful Phrases ::
```

Reason: visible section body is empty. This fails the no deletion or thin bodies gate for section title/body review, even though phraseIDs are preserved.

### `city-hanoi-place-loading-t-cafe`

Snippet:

```txt
[quick-say] Useful Phrases ::
```

Reason: visible section body is empty. This fails the no deletion or thin bodies gate for section title/body review, even though phraseIDs are preserved.

## Final Decision

Hanoi 001-050 is partially safe for import: 46 pass, 4 unsafe.

Do not import the four unsafe entries until their empty `quick-say` bodies are repaired or the importer/rendering contract explicitly proves those empty bodies are intentionally replaced by playable phrase cards and never appear as thin visible copy.
