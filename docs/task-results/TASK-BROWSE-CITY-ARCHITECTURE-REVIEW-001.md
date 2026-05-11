# Browse City Architecture Review

Date: 2026-05-12
Branch: feature/browse-page

## Direction Checked

Browse should start with entities first and phrases second.

For city pages that means the first useful layer should be city nouns:
- places
- neighborhoods
- streets
- markets
- restaurants
- dishes
- landmarks

Phrase/action rows such as "Where is Dragon Bridge?" or "Go to Dragon Bridge" should appear after the user selects an entity or a moment.

## Current State

The SQLite content already separates city rows by `page_kind`:

- `place`
- `restaurant`
- `dish`
- `phrase`

That is the right foundation. City browse groups already filter to entity page kinds only, and existing tests assert those groups are not populated with long-tail route/question phrases.

## Drift Found

The Da Nang, Hanoi, Saigon, Hoi An, and Hue city pages were still visually action-first:

1. city name audio
2. "What are you doing?" cards
3. selected phrase rows
4. practice card
5. names
6. quick phrases
7. city browse groups

That made the page feel like a phrase/action feed even though the underlying data had entity rows.

## Fix Applied

City hubs now render entity discovery before phrase/action layers:

1. city name audio
2. Names to know
3. Browse <city>
4. selected entity group rows
5. city practice card
6. Common moments
7. selected moment rows
8. Quick phrases

This keeps Browse aligned with:

city -> thing -> phrase depth

instead of:

city -> phrase/action feed

## Category Page Finding

Generic category pages are still mixed. Airport and hotel are mostly action/filter based, which is acceptable for task categories. Food/coffee, landmarks, streets, and restaurant-style categories need a separate entity-content pass so they can start with nouns such as:

- Cà phê đen
- Cà phê sữa đá
- Bún bò Huế
- Cầu Rồng
- Đường Bạch Đằng
- Chợ Cồn

Some of those entity rows exist now through city place/dish pages, but coffee/drink nouns are still mostly represented as phrase pages. That should not be patched only in UI; it needs proper entity rows so search, browse, audio, and detail pages stay consistent.

## Guardrails Updated

Tests were updated so city pages use `Common moments` for action cards and render the entity sections (`Names to know`, `Browse <city>`) as the first browse layer.

## Validation

- Synced `feature/browse-page` with current local `main` before starting.
- `git diff --check`
- XcodeBuildMCP simulator build/run on `SpeakLocal Browse`
- Focused tests:
  - `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndPracticePolicy`
  - `AppChromeTests/testDaNangCityDescriptorUsesTravelModeHubInsteadOfPhraseFeed`
  - `AppChromeTests/testCityBrowseGroupsAreEntityFirstAcrossCities`

Manual proof screenshot:

- `native-ios/artifacts/browse-city-architecture-review/danang-entity-first-top.jpg`
