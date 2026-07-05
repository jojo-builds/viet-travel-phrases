# Feature vs Main Functionality Audit

Date: 2026-05-31
Branch audited: `feature/admin-photo-backdrop-polish`
Feature head: `76f9a433b`
Compared against local `main`: `494e325f9`
Merge base: `494e325f9`

## Executive Read

This branch does not delete any app source files compared with local `main`.

The branch adds the phrase photo-backdrop rollout and a long set of performance fixes for rapid listing navigation. The main intentional behavioral change is that hidden/offscreen pages no longer stay fully mounted unless the current route, forward preview, or an active back-swipe preview actually needs them. That can make a back transition feel slightly different because the previous page is instantiated at gesture time instead of being continuously alive offscreen. The browser-style back/forward stack itself is still present and covered by focused tests.

No evidence was found that saved pages, practice pages, search, detail navigation, menu detail pages, or forward navigation were removed. The most important tradeoffs to watch manually are called out below.

## What Changed Since Main

- 76 commits on top of local `main`.
- 152 changed files in the branch diff.
- No deleted files in the app diff.
- 20 new `BackdropPhrase*.imageset` runtime assets in `native-ios/Resources/Assets.xcassets`.
- `content-draft/viet/phrase-backdrops-v1.json` maps 952 phrase/listing placements to semantic backdrop pools.
- `docs/editorial-exports/viet-image-assets/phrase-backdrop-mini-pools-2026-05-30/manifest.json` records 20 runtime assets at `720x1556`.
- Native SQLite fixture was regenerated so phrase/listing pages can carry those backdrop assignments.

## Main Feature Areas Added Or Preserved

### Photo Backdrop Rollout

Added or expanded:

- phrase/category listing photo backdrops using `BackdropPhrase*` or `HeroCategory*`
- `Xin chao` and static greeting pages using `BackdropPhraseGreetingCafeDoorway`
- semantic mini-pool assignment for the 952 phrase/listing pages that needed backdrop work
- focused preheat for detail, browse collection, menu, and root photo backdrops
- full-sheet photo reveal and immersive tap behavior remain the intended replacement for the old standalone image reveal on eligible pages

Preserved:

- non-photo and compact pages can still use their standard layout
- old image lightbox path is still available only where the page is not using the photo-backdrop layout
- bottom chrome backing, tab/search chrome, status-bar hiding, and tap-to-restore behavior remain wired through shell preferences

### Navigation, Back, Forward, And Transitions

Preserved:

- browser-style `detailPath`
- `forwardStack`
- back button behavior
- back edge-swipe behavior
- forward edge-swipe behavior
- search back/forward history
- browse collection back chains
- saved/practice detours returning to the previous collection
- interactive presentation math for back and forward layers

Changed intentionally for heat:

- when not actively back-swiping, only the active detail page is rendered instead of also keeping the immediate previous detail page alive
- when actively back-swiping, the immediate previous detail page is rendered for the preview
- browse collection pages follow the same pattern: active only by default, active plus immediate back-preview during a back swipe
- root surfaces such as Home, Browse, Saved, Practice, and the root `Xin chao` page render only when they are current, back-preview, or forward-preview routes

Risk to manually inspect:

- the very first frame of a back swipe after rapid navigation, especially on old/detail-heavy pages
- any blank flash or delayed previous-page appearance when starting an edge swipe
- forward swipe after going back from Search, Browse, or a detail page

### Saved, Practice, And Recently Viewed

Preserved:

- saved IDs still publish app-state changes immediately
- practice IDs still publish app-state changes immediately
- saved menu items persist as trip items
- saved pages do not automatically enter practice
- recent pages still update in memory and canonicalize page IDs

Changed intentionally for heat:

- recent-page recording no longer publishes a broad `ObservableObject` invalidation on every detail tap
- recent-page persistence is batched instead of writing to UserDefaults on every rapid navigation tap
- recent pages flush on scene phase leaving active, and explicit flush remains available

Risk to manually inspect:

- Recently Viewed should update after returning Home or after app background/foreground, but it is no longer designed to repaint every hidden Home shelf instantly during rapid detail tapping.

### Search And Browse

Preserved:

- search can open phrase details and return to Search
- search can open browse collections and return to Search
- strong search collection matches stay ahead of phrase rows
- browse category/city collection routes are still available
- the 315 search-only phrase rows remain surfaced through browsable category sections from prior work

Changed intentionally for heat:

- generated `Hero*` and `Backdrop*` browse assets are trusted directly instead of probing `UIImage(named:)` just to see whether they exist
- only the small set of custom-focused browse thumbnails reads image sizes for focus decisions
- category masthead hero overrides are stored in a bounded cache instead of an unbounded dictionary

Risk to manually inspect:

- after opening more than 96 category-backed details, very old back-history entries may lose a category masthead override and fall back to the page's own hero image. This is bounded by design, but it is a visible tradeoff if someone walks back through a very long route history.

### Menu And Location Cards

Preserved:

- Vietnamese menu detail pages still resolve
- menu detail pages still use portrait backdrop images
- menu item audio still plays from bundled audio
- location menu picks and related picks still appear where configured
- saved-trip rows still group menu items and phrase items

Changed intentionally for heat:

- menu detail lookup now uses indexes instead of full-array scans
- menu-owned routes bypass unnecessary SQLite phrase lookup/canonicalization
- location cards prepare linked audio/tint once per page instance
- location pick caches are bounded

### SQLite And Detail Page Runtime

Preserved:

- aliases still resolve to canonical pages
- canonical detail pages still load article sections, phrase rows, breakdown rows, related/search/history routes, and audio keys
- generated pages still open through search, browse, history, and direct launch routes

Changed intentionally for heat:

- known catalog page IDs seed the SQLite canonical cache
- detail page construction is cached above the SQLite runtime
- section phrase rows and breakdown rows load in batched queries instead of per-section N+1 queries
- hero-image lookup can happen without loading the full detail page
- generic detail navigation no longer synchronously loads SQLite just to preheat a hero image

## Potentially Removed Or Reduced Runtime Work

These are not user-facing feature removals, but they are real behavior reductions made for efficiency:

1. Hidden page bodies are no longer always alive.
   The prior app kept offscreen detail/collection/root surfaces mounted at opacity zero for preview readiness. The branch keeps browser history state but avoids rendering those heavy surfaces until the current route or gesture needs them.

2. Inactive pages no longer run delayed scroll/focus/geometry tasks.
   The tasks still run when the page is active. Hidden previews no longer do bottom-inset checks, section-tracking updates, scroll-geometry publishing, or initial-scroll work.

3. Stale backdrop preheat work can be dropped.
   If the user leaves a page before its full-screen hero preparation finishes, focused preheat may reject that stale prepared image and prioritize the newest active page.

4. Recent pages no longer publish store-wide invalidations.
   The in-memory list changes, but broad SwiftUI invalidation is avoided during rapid navigation bursts. Saved and practice still publish.

5. Photo-backdrop pages do not stack the old lightbox on top.
   Eligible photo-backdrop pages use tap-to-immersive reveal instead of the old standalone image-lightbox behavior. Non-photo eligible pages retain the old path.

## Verification Run During This Audit

Simulator, focused navigation/preview audit:

- 11 passed, 0 failed
- Covered: back/forward route restoration, forward swipe, back and forward interactive presentation, hidden detail/back-preview rendering, hidden browse collection rendering, root surface render gating, root `Xin chao` render gating
- Result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-51-04-953Z_pid15747_e71e9211.xcresult`

Simulator, focused feature/hot-path audit:

- 13 passed, 0 failed
- Covered: search return, search ranking, menu detail lookup, menu detail photo backdrops, photo-backdrop preheat policy, SQLite backdrop coverage, static designed page backdrop coverage, lightweight hero lookup, catalog-seeded canonical detail loads, alias canonicalization, batched section item loading
- Result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-51-53-123Z_pid15747_cd980fb3.xcresult`

Simulator, saved/practice/recent intent-store audit:

- 5 passed, 0 failed
- Covered: saved publishes, saved/practice persistence, saved menu items, recent persistence after flush, recent recording without broad invalidation
- Result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T04-55-11-742Z_pid15747_522fb534.xcresult`

Local hygiene:

- `git diff --check -- native-ios/App native-ios/Tests native-ios/scripts docs/design/photo-backdrop-listing-pages.md docs/operations/LATEST_VALIDATION.md` passed
- `node scripts/guard-native-only.js` passed

Phone state from this audit:

- current feature worktree build succeeded
- install to the physical iPhone succeeded
- launch was denied by iOS because the phone was locked
- repo signing files stayed clean

## What To Look For On The Phone

1. `Xin chao` should show the cafe-doorway photo with the rounded pull-down content sheet, not the old Ha Long single-layer page.
2. Pull down on eligible listing pages: the photo should become more visible while the sheet remains recoverable.
3. Tap the visible photo area: content and chrome should hide; tap or scroll upward should restore them.
4. Rapidly open listing pages from Home, Browse, Search, city, and menu surfaces: the phone should feel cooler than before.
5. Back swipe after several rapid detail opens: the previous page should appear and track horizontally without vertical jump or blank flash.
6. Forward swipe after going back: the forward page should still return like browser history.
7. Saved, Practice, Search, and menu detail pages should behave the same functionally as `main`.
8. Recently Viewed should be accurate when returning Home or after app background/foreground, but it may no longer repaint hidden Home immediately during the rapid tapping burst.

## Open Follow-Up

The branch has strong simulator and install evidence, but the paused thermal goal still lacks the final proof that matters most: the current build launched on the unlocked physical iPhone and manually tested through a rapid listing-navigation run.
