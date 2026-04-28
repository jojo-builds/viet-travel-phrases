# T-135 search-page implementation notes

## What changed

- Replaced the old floating `SearchResultsTray` pattern with a dedicated `SearchPage` layer in `PhraseProductPrototype.tsx`.
- Kept the bottom-right magnifier as the entry point, but collapsed the dock so only the search control remains visible during search mode.
- Moved search interaction into three clear sections:
  - `Search`
  - `Suggested`
  - `Browse`
- Changed typed results from thin rows into one-column listing cards with:
  - main open path
  - separate `Play on open` action
- Routed search-card selection into the listing page with the matched hero active when available.

## State/model decisions

- Search mode is an in-prototype dedicated page state, not a route change.
- Search ranking is lightweight and local:
  - source text gets the strongest weight
  - target text is next
  - group/context text helps break ties
- Typed results dedupe to one card per page so the search lane feels like listing-page navigation, not a raw phrase dump.
- Browse cards pivot the search page into a smaller result lane without forcing a typed query.

## Shell/fallback decisions

- The search page keeps the strongest material treatment in the shell layer:
  - search field
  - close control
  - dock search control
- Result cards and browse cards stay calmer and more content-led.
- Native and non-native paths share the same dedicated search-page structure; the dock behavior differs but the flow stays consistent.

## Supporting truth updates

- Updated `previewContent.ts` search-slide copy to describe the dedicated search page direction.
- Updated `phrase-page-blueprint.md` so blueprint language matches the dedicated search page, single surviving search control, and play-to-open listing behavior.
