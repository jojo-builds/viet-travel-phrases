# TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001

## Task Done

Native Browse category and city collection pages are implemented. Browse cards open real collection pages; Search can discover matching collections and hand off to Browse instead of turning those matches into plain phrase search results.

## Context

Use `docs/design/category-pages/README.md`, `docs/design/category-pages/prompt-packet.md`, and `docs/design/NATIVE_VISUAL_REFERENCE.md` as the design packet. The category-page packet says Browse owns the deeper hierarchy, Search discovers collections, Melo stays out of Browse/Search utility pages, and phrase rows must continue to route to canonical phrase pages.

## Worker Judgment

- Prefer a native route for Browse collections over overloaded phrase detail IDs.
- Keep collection page models value-driven and cached per route.
- Keep SwiftUI bodies cheap: no SQLite query, sorting, grouping, or broad filtering in the collection view render path.
- Use existing `PhraseCatalog` / SQLite bundle data. Do not create duplicate generated phrase content or a new content system.
- Use asset-catalog mastheads and lazy stacks/shelves for the visible UI.

## Required Outcome

- Add `AppRoute.browseCollection(BrowseCollectionRoute)` with category and city routes.
- Browse category and city cards open collection pages with image mastheads, subcategory cards, starter phrase rows, Practice entry, and Explore shelves.
- Search shows a best-match category/city collection card above phrase rows when the query strongly matches a collection.
- Opening a collection from Search closes Search and lands in Browse with Browse selected in bottom chrome.
- Phrase rows continue to open canonical phrase pages.
- Category Practice adds only visible starter phrase rows to local practice state before opening Practice.
- City Practice opens the existing city practice mode where available.

## Boundaries

- Do not add runtime AI, network image loading, generated phrase content, or duplicate page graph IDs.
- Do not move generated native resources or language packs.
- Do not commit personal signing settings.
- Leave unrelated content/resource drift out of the scoped commit.

## Validation

- `git status --short` before edits and before commit.
- `cd native-ios && xcodegen generate`.
- `git diff --check`.
- Native build on the iPhone 17 Pro simulator.
- Targeted unit coverage for route chrome/history, Search handoff, city ID normalization, collection model caching, and Practice entry policy.
- Targeted UI coverage for Browse-to-collection, Search-to-category, Search-to-city, back behavior, bottom chrome stability, and Practice entry.
- Simulator proof screenshots for Browse root, Airport/Hotel/Food category pages, Hanoi city page, scrolled collection, Search hotel, Search city, and Practice entry.

## Result Contract

Write `docs/task-results/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001.md` with status, validation, screenshots, performance note, known gaps, and recommended next task. Commit the scoped implementation and leave unrelated worktree changes unstaged.
