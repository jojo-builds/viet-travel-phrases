# Latest Validation

Last updated: 2026-05-31
Authority lane: latest durable native iOS validation evidence

## Use This Doc For

- the latest durable validation evidence that already exists
- what still needs proof after the native-only cleanup

Do not use this file as the execution checklist. `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `IOS_DEVICE_BUILDING.md` own the current handoff path.

## Current Admin Photo Backdrop Thermal Evidence

Current `feature/admin-photo-backdrop-polish` evidence from the 2026-05-30 listing-navigation thermal pass:

- root cause 1: opening each new listing recorded recent-page history through a broad `@Published` field on `LocalUserIntentStore`, invalidating offscreen Home/Browse/Saved surfaces while the user was only navigating detail pages
- root cause 2: listing photo backdrops used the plain SwiftUI asset image path, so newly generated portrait backdrops could decode/prepare on the render path instead of sharing the bounded prepared-image cache used by root photo backdrops
- root cause 3: city listing sheets recomputed "Mentioned Here" and "Compare Nearby" pick arrays repeatedly inside section rendering, including alias normalization and menu-item scans for page bodies that can be re-evaluated during navigation/scrolling
- root cause 4: Home stayed fully mounted behind deeper detail navigation even when it was not the current/back/forward route surface, so its large shelf tree could rebuild while the user was tapping through listing pages
- root cause 5: the previous detail page stayed mounted at opacity `0` between back-swipe gestures, so tapping through new listing pages could still keep one full offscreen listing sheet alive just to be ready for a possible back preview
- root cause 6: the root `Xin chào` article surface stayed mounted in the shell even when it was no longer current or the immediate back/forward preview route
- root cause 7: browse/category/menu collection pages stayed mounted at opacity `0` behind listing detail pages even when they were not visible and not needed for the current back-swipe preview; those collection pages include large section trees, photo backdrops, scroll geometry, and menu section tracking
- root cause 8: category/city/menu photo backdrop pages still rendered their large static backdrop through plain SwiftUI `Image(...)` instead of the prepared-image cache used by root and listing backdrops, so opening those collection pages could still decode/prepare large assets on the render path
- root cause 9: the shared backdrop preheater retained only a few prepared images, but the preparation work itself was unbounded; rapid listing taps could enqueue many large-image `preparingForDisplay()` jobs in parallel for pages the user had already left
- root cause 10: recent-page tracking stopped publishing broad SwiftUI invalidations, but still JSON-encoded and wrote the recent-page array to `UserDefaults` immediately on every detail tap; rapid listing browsing now updates the in-memory shelf immediately and batches the disk write until the burst settles or the app leaves the active scene phase
- root cause 11: the shared backdrop preheater kept the latest queued image names but drained them oldest-first, so rapid listing taps could still spend image-preparation work on stale pages before the newest visible page; the queue now drains newest-first while preserving the bounded latest-work policy
- root cause 12: opening a detail page canonicalized the same page ID once for navigation and again for recently viewed tracking; detail navigation now returns the already-resolved canonical phrase ID so recent-page recording can reuse it instead of repeating the lookup/cache path on every rapid listing tap
- root cause 13: Vietnamese menu detail pages resolved `viet-menu-*` IDs by repeatedly scanning the full menu item array across navigation, backdrop preheat, detail-page construction, and linked location menu rows; menu items are now indexed by item ID and detail page ID so rapid menu-listing taps reuse constant-time lookups without removing any menu/page functionality
- root cause 14: the generic detail-page resolver asked the SQLite phrase graph to resolve `viet-menu-*` pages before falling back to the menu and location-menu catalogs; rapid menu-listing taps now route menu-owned detail pages directly through the menu/location-menu catalogs and bypass the extra SQLite phrase-detail lookup
- root cause 15: menu-owned `viet-menu-*` routes still asked the SQLite phrase graph to canonicalize page IDs during navigation before the app recognized those pages as Vietnamese menu or location-menu pages; menu-owned route IDs now canonicalize through the menu catalogs first, eliminating SQLite canonical misses for rapid menu-listing taps
- root cause 16: related phrase rows/cards checked whether a destination was a self-link by canonicalizing both the destination and current page from SwiftUI body-derived properties; repeated sheet redraws could re-enter the SQLite canonical path for the same pair, so row navigation now uses a bounded pair-decision cache while preserving self-link suppression and related-page navigation
- root cause 17: the app-shell check for whether a detail route should render the special designed `Xin chào` article canonicalized the current page ID from the render path for every normal listing; the shell now answers direct/canonical `Xin chào` IDs cheaply and caches fallback alias decisions, so normal listing redraws do not repeatedly enter the SQLite canonical resolver just to reject the special route
- root cause 18: SwiftUI detail redraws resolved the same canonical `PhraseDetailPage` by re-entering `VietSQLitePhraseGraphRuntime.detailPage(withID:)` every time; the runtime cache avoided full reloads, but the shell still paid the resolver/lock path repeatedly, so `PhraseDetailPage.page(withID:)` now keeps a bounded resolved-page cache above the SQLite runtime while preserving generated, menu, location-menu, and static fallback behavior
- root cause 19: the detail-page render stack kept only the active page, or the active plus immediate back-preview page, but computed that small render set by filtering the entire detail history on every SwiftUI refresh; rapid listing taps can leave a long browser-style history, so render selection now slices only the visible suffix while preserving back/forward navigation history
- root cause 20: city listing "Mentioned Here" and "Compare Nearby" catalogs cached empty pick arrays for every eligible city page ID, so rapidly tapping through many city-backed listing pages could grow both static caches for pages with no cards; both catalogs now keep a bounded recent-page cache while preserving alias sharing and all existing cards
- root cause 21: inactive standard phrase article pages could still run their startup scroll/bottom-inset `.task` while mounted for hidden navigation states; the task is now gated by active-route state so inactive detail pages do not run delayed scroll work during rapid listing navigation
- root cause 22: browse category/card taps preheated category hero backdrops in `openDetailFromBrowse` and then immediately reached the generic detail preheat path with the same browse hero override; category masthead browse opens now keep the hero override but skip that duplicate generic shell preheat, while non-category browse opens and all non-browse detail opens keep their existing fallback preheat behavior
- root cause 23: browse category/card taps stored contextual hero image overrides in an unbounded app-shell `@State` dictionary; rapidly opening many category listing pages could retain one override per distinct page even though rendering is limited to the active/immediate preview pages, so the shell now keeps those overrides in a bounded recent-page cache while preserving category masthead overrides for recent back/forward navigation
- root cause 24: inactive but visible root/admin photo-backdrop preview surfaces could still run delayed startup scroll and bottom-inset validation work while mounted for navigation previews; that delayed work now requires the surface to be both active and visible, while immediate visual positioning for visible previews is preserved
- root cause 25: browse city/category thumbnail rendering still asked UIKit for image dimensions from the SwiftUI body for every focused thumbnail image, even though only two assets need custom crop focus; normal thumbnails now skip that `UIImage(named:)` size probe and render directly, preserving the two custom crops while avoiding extra asset lookup/decode pressure during rapid browsing
- root cause 26: browse city/category thumbnail selection still asked UIKit whether generated bundled hero/backdrop image names existed before SwiftUI rendered them; generated `Hero*` and `Backdrop*` browse assets now render directly while unknown/manual image names keep the old fallback existence check, avoiding extra `UIImage(named:)` probes during rapid page browsing
- root cause 27: inactive menu and standard browse collection pages could still run delayed section-tracking, section-jump settle, focus-restore, or bottom-inset tasks while mounted for hidden/back-preview navigation states; those deferred collection tasks now require active-route state, while active collection pages keep their scroll, focus, and section-jump behavior
- root cause 28: inactive listing, browse collection, and menu photo-backdrop pages could still publish scroll-geometry state, and inactive menu pages could still process section-frame/rail preferences while mounted only as hidden/back-preview surfaces; scroll-geometry and menu section preference tracking now require active-route state, preserving active page behavior while preventing extra state churn during rapid navigation
- root cause 29: generic detail navigation synchronously asked the SQLite phrase graph for a generated page's hero image name just to preheat a backdrop before the actual detail page loaded, duplicating database work on every new SQLite-backed listing tap; navigation preheat now uses only already-known cheap image names such as static authored backdrops, menu backdrops, or browse category overrides, while generated pages still preheat from the active page after its already-loaded detail model supplies the hero image
- root cause 30: `PhraseDetailView` rebuilt each detail page's `PhraseArticlePage` adapter from `body`, remapping sections and playback metadata on SwiftUI refreshes for the same page; the view now builds that adapter once during initialization and reuses it across redraws, preserving article layout while removing repeated per-refresh transformation work
- root cause 31: `PhraseArticleTemplateView` still derived visible article sections from `body`, re-filtering sections and re-running duplicate-hero text normalization during repeated SwiftUI redraws for the same page; the view now derives the visible section list once per page instance and reuses it across redraws
- root cause 32: saved/practice membership checks canonicalized page IDs even when their ID lists were empty or when the caller already supplied the exact canonical ID; those render-path checks now use empty/direct-ID fast paths before entering the SQLite canonical resolver, preserving alias support while avoiding unnecessary lookup work during detail redraws
- root cause 33: `PhraseArticleTemplateView` still canonicalized a home-hero morph identity from detail render paths even when no home morph was active; morph identity now returns the raw page ID when both morph IDs are nil and resolves once per view only when morph state exists
- root cause 34: inactive Home/root/admin photo-backdrop preview surfaces could still publish scroll-geometry state while mounted as navigation previews; those callbacks now require active and visible state, matching the existing delayed-task and listing/browse/menu scroll-geometry gates
- root cause 35: city listing articles reused cached "Mentioned Here" and "Compare Nearby" pick arrays, but still asked the catalogs to refilter those arrays by section ID from the article render path; each article page now builds grouped menu/related pick buckets once per page instance and the body reads those buckets directly
- root cause 36: phrase rows and breakdown cards resolved playable audio keys from SwiftUI row/card rendering, repeatedly entering `AudioAssetManifest` normalization and lookup work for deterministic phrase text during detail redraws; article pages now prepare row playback keys once per `PhraseArticleTemplateView` instance and rows read the prepared values
- root cause 37: location-card rows reused grouped pick buckets, but each row could still resolve linked-menu audio from `AudioAssetManifest` while rendering; the location-pick grouping step now prepares pick audio keys once per page instance so "Mentioned Here", "Compare Nearby", and trailing place/menu cards read stored keys
- root cause 38: listing/category/menu photo-backdrop pages queued hero-image preparation work for pages the user had already left; root/home still keep their small lookahead queue, but single-current-page detail, browse collection, and menu backdrops now use focused preheat mode so rapid page taps drop stale queued full-screen hero decodes and keep the newest active hero work
- root cause 39: location-card rows prepared linked-menu audio keys, but still looked up the linked menu item from SwiftUI row rendering just to tint the speaker button; location-pick grouping now prepares the audio tint alongside the audio key, so rows read stored playback presentation metadata instead of re-entering the menu catalog
- root cause 40: catalog and Explore rows still resolved playable audio from `PhraseCatalogItem.playbackAudioKey` during row rendering; catalog items now use a bounded playback-audio decision cache so repeated Browse/Home/Explore redraws reuse the same manifest result without re-entering `AudioAssetManifest`
- root cause 41: focused photo-backdrop preheat dropped stale queued work, but an already-popped full-screen hero image could still finish preparing and commit after the user had opened a newer page; focused preheat now tags in-flight work with the current request generation and rejects stale completed images while still committing the newest active hero
- root cause 42: saved/practice membership checks skipped empty lists and direct saved hits, but repeated unsaved misses with a non-empty saved list still canonicalized the same visible location/card page IDs on every redraw; `LocalUserIntentStore` now keeps bounded per-store membership caches and invalidates them when saved/practice IDs change
- root cause 43: category, city, and menu collection pages still requested their photo-backdrop preheat from page `.task`, after the route had already begun rendering; the app shell now preheats the collection backdrop before opening the route so first render is less likely to fall back to a cold full-screen image path
- root cause 44: Food/Drink menu rows still resolved exact item-name audio from `AudioAssetManifest` inside row rendering; `VietnameseMenuItem` now keeps a bounded playback-audio decision cache and menu rows/descriptors read the prepared item audio key
- root cause 45: a new SQLite-backed listing detail load still canonicalized the same page ID twice inside the detail resolver: once to find the canonical page and again inside `loadPhraseDetailPage(pageID:)`; the runtime now reuses the already-canonical ID and loads the canonical page directly, so rapid new-page tapping removes one SQL alias lookup per uncached listing detail
- root cause 46: each new SQLite-backed listing detail loaded sections with an N+1 query pattern: after the section list, it prepared one phrase-row query and one breakdown-row query per section, even for empty sections; section phrase rows and breakdown rows now load in two batched section-ID queries, reducing a representative new detail load from `15` prepared statements to at most `5`
- preserved UX: listing pages still use the static full-screen photo, pull-down sheet, tap-to-immersive reveal, bottom chrome backing, saved/practice state, and city/menu related cards

Fresh command evidence from this pass:

- Visual simulator proof for the current `feature/admin-photo-backdrop-polish` head `dc9157f57`
  - launched `SpeakLocalNative` on iPhone 17 Pro Simulator with `--detail-page viet-phrase-polite-1`
  - confirmed `Xin chào` renders with `BackdropPhraseGreetingCafeDoorway`, a lowered rounded content sheet, visible photo area, and normal bottom chrome backing instead of the old single static hero layer
  - screenshot: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_86deb15a-000f-419c-8ba3-e2e70468f280.jpg`
- Physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` commit `dc9157f57`
  - build passed
  - install passed
  - launch passed after install
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- focused failing tests were added before the fixes and then passed after implementation:
  - `AppChromeTests/testRenderedDetailPagesDoNotScanEntireLongHistory`
  - `AppChromeTests/testMenuDetailNavigationBypassesSQLiteCanonicalLookup`
  - `AppChromeTests/testPhraseRowNavigationCachesRepeatedCanonicalPairChecks`
  - `AppChromeTests/testMenuDetailPagesBypassSQLitePhraseGraphLookup`
  - `AppChromeTests/testVietnameseMenuDetailLookupsUseIndexedItems`
  - `AppChromeTests/testForwardDetailNavigationReturnsCanonicalIDForRecentRecording`
  - `LocalUserIntentStoreTests/testRecentPagesCanRecordAlreadyCanonicalPageID`
  - `LocalUserIntentStoreTests/testRecentPagesPersistAfterExplicitFlushInsteadOfEveryTap`
  - `AppChromeTests/testAdminBackdropPreheatPlanKeepsLatestQueuedWorkBounded`
  - `AppChromeTests/testAdminBackdropPreheatPlanDrainsNewestQueuedWorkFirst`
  - `LocalUserIntentStoreTests/testRecordingRecentPageDoesNotPublishStoreWideInvalidation`
  - `LocalUserIntentStoreTests/testSavedPageToggleStillPublishesStoreChanges`
  - `AppChromeTests/testPhrasePhotoBackdropPreheatPolicyOnlyWarmsEligibleListingHero`
  - `AppChromeTests/testLocationMenuPicksCacheCanonicalCityLookups`
  - `AppChromeTests/testLocationRelatedPicksCacheCanonicalCityLookups`
  - `AppChromeTests/testLocationPickCachesStayBoundedDuringRapidCityBrowsing`
  - `AppChromeTests/testRootSurfacesRenderOnlyWhenCurrentBackOrForwardRouteNeedsThem`
  - `AppChromeTests/testRootXinChaoSurfaceRendersOnlyWhenCurrentBackOrForwardRouteNeedsIt`
  - `AppChromeTests/testHiddenBackDetailPageCanStayUnmountedUntilBackSwipePreview`
  - `AppChromeTests/testHiddenBackBrowseCollectionCanStayUnmountedUntilBackSwipePreview`
  - `AppChromeTests/testBrowseCollectionsKeepOnlyVisibleRouteUntilBackSwipePreview`
  - `AppChromeTests/testBrowseCollectionPhotoBackdropPreheatPolicyWarmsOnlyPhotoBackdrops`
  - `AppChromeTests/testVietnameseMenuPhotoBackdropPreheatPolicyWarmsOnlyPhotoBackdrops`
  - `SQLiteLanguagePackRepositoryTests/testRuntimeHeroImageLookupDoesNotLoadFullDetailPage`
  - `AppChromeTests/testPhraseArticleStandardScrollTaskRunsOnlyForActivePages`
  - `AppChromeTests/testBrowseDetailHeroImageOverrideKeepsOnlyCategoryMastheads`
  - `AppChromeTests/testBrowseDetailGenericPreheatSkipsOnlyAfterCategoryOverride`
  - `AppChromeTests/testBrowseDetailHeroOverrideCacheStaysBoundedDuringRapidCategoryBrowsing`
  - `AppChromeTests/testAdminPhotoBackdropDelayedTaskRunsOnlyForActiveVisiblePages`
  - `AppChromeTests/testBrowseFocusedAssetImagesReadSizesOnlyForCustomFocusAssets`
  - `AppChromeTests/testBrowseImageAssetPolicyTrustsGeneratedAssetsWithoutExistenceProbe`
  - `AppChromeTests/testInactiveCollectionPagesSkipDeferredScrollTasks`
  - `AppChromeTests/testInactivePagesSkipScrollGeometryAndPreferenceTracking`
  - `AppChromeTests/testDetailNavigationPreheatSkipsSQLiteHeroLookupForGeneratedPages`
  - `AppChromeTests/testPhraseDetailViewBuildsArticleTemplateOncePerPageInstance`
  - `AppChromeTests/testPhraseArticleTemplateBuildsVisibleSectionsOncePerPageInstance`
  - `LocalUserIntentStoreTests/testSavedMembershipSkipsCanonicalLookupForEmptyAndDirectCanonicalIDs`
  - `AppChromeTests/testPhraseArticleMorphPolicySkipsCanonicalLookupWhenNoHomeMorphIsActive`
  - `AppChromeTests/testAdminPhotoBackdropDelayedTaskRunsOnlyForActiveVisiblePages` was extended to cover inactive scroll-geometry gating
  - `AppChromeTests/testPhraseArticleTemplateGroupsLocationPicksOncePerPageInstance`
  - `AppChromeTests/testPhraseArticleTemplatePreparesRowPlaybackAudioOncePerPageInstance`
  - `AppChromeTests/testPhraseArticleLocationPickGroupsPrepareAudioKeysOncePerPageInstance`
  - `AppChromeTests/testFocusedDetailBackdropPreheatDropsStaleQueuedHeroWork`
  - `AppChromeTests/testPhraseArticleLocationPickGroupsPrepareAudioTintOncePerPageInstance`
  - `AppChromeTests/testPhraseCatalogItemsCachePlaybackAudioAcrossRepeatedRowRendering`
  - `AppChromeTests/testFocusedBackdropPreheaterRejectsStaleInFlightHeroWork`
  - `LocalUserIntentStoreTests/testSavedMembershipCachesRepeatedUnsavedMissesWhenSavedListIsNonEmpty`
  - `AppChromeTests/testBrowseCollectionRoutePreheatWarmsBackdropBeforeNavigation`
  - `AppChromeTests/testVietnameseMenuItemsCachePlaybackAudioAcrossRepeatedRowRendering`
- XcodeBuildMCP simulator focused collection-route preheat set on iPhone 17 Pro
  - failed before implementation because `AppShellView.browseCollectionBackdropPreheatImageNames(for:)` did not exist and collection routes could only preheat from page tasks
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-40-59-946Z_pid15747_1da1cf51.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-43-20-739Z_pid15747_c91c1dc4.xcresult`
- XcodeBuildMCP simulator focused Vietnamese menu-row audio cache set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuItem` had no playback-audio cache/reset seam and menu rows read the audio manifest directly
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-45-50-614Z_pid15747_91819910.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-47-29-255Z_pid15747_3a096ca0.xcresult`
- XcodeBuildMCP simulator focused collection/menu thermal-regression set on iPhone 17 Pro
  - passed: `11` tests, `0` failures
  - covered early collection-route backdrop preheat, Vietnamese menu-row audio caching, catalog row audio caching, stale in-flight focused backdrop rejection, focused queued-backdrop replacement, browse/menu photo-backdrop preheat policy, browse detail override policy/cache, and saved unsaved-miss caching
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-48-28-655Z_pid15747_c656195d.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `89fe3f545`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused SQLite detail-load canonicalization set on iPhone 17 Pro
  - failed before implementation because `testRuntimeDetailPageLoadCanonicalizesOnlyOncePerNewPage` observed `2` repository canonical lookups for one new SQLite-backed detail load instead of `1`
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log for missing counter seam: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T02-11-01-142Z_pid15747_c9aa6548.log`
    - red result bundle for duplicate canonicalization: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-12-33-144Z_pid15747_d77df48e.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-14-26-013Z_pid15747_176a6171.xcresult`
- XcodeBuildMCP simulator focused SQLite/detail-navigation regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered one-canonicalization detail loads, hero-image lookup staying lightweight, SQLite search/detail/history routing, resolved-page reuse, bounded SQLite caches, generated-page preheat skipping hero lookup, and menu detail/canonical bypasses
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-16-37-237Z_pid15747_409271eb.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `b29fd26c1`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused SQLite section-item batching set on iPhone 17 Pro
  - failed before implementation because `testRuntimeDetailPageLoadBatchesSectionItemQueriesPerNewPage` observed `15` prepared statements for one new SQLite-backed detail load instead of the batched target of at most `5`
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log for missing prepared-statement counter seam: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T02-25-24-958Z_pid15747_4ce79046.log`
    - red result bundle for N+1 section-item statements: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-26-37-202Z_pid15747_9591fe2e.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-28-11-185Z_pid15747_9917e116.xcresult`
- XcodeBuildMCP simulator focused SQLite/detail-loader regression set on iPhone 17 Pro
  - passed: `9` tests, `0` failures
  - covered batched section item loading, one-canonicalization detail loads, hero-image lookup staying lightweight, SQLite search/detail/history routing, resolved-page reuse, bounded SQLite caches, generated-page preheat skipping hero lookup, and menu detail/canonical bypasses
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T02-31-13-030Z_pid15747_65ffce74.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `636b7ce40`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused catalog-row audio cache set on iPhone 17 Pro
  - failed before implementation because `PhraseCatalogItem` had no playback-audio resolution cache reset seam and repeated row reads had no cache
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-14-33-491Z_pid15747_ff4552d3.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-15-32-220Z_pid15747_b1be77e4.xcresult`
- XcodeBuildMCP simulator focused in-flight backdrop preheat set on iPhone 17 Pro
  - failed before implementation because `AdminBackdropImagePreheater` had no reset/injected-preparer test seam and no stale in-flight focused-work rejection
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T01-19-08-177Z_pid15747_e122555d.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-21-38-490Z_pid15747_262eaa93.xcresult`
- XcodeBuildMCP simulator focused saved-membership miss cache set on iPhone 17 Pro
  - failed before implementation because two visible unsaved related-card IDs caused `20` canonical lookups over ten redraw-style saved-state passes
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-24-06-049Z_pid15747_240fbfc5.xcresult`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-26-50-631Z_pid15747_cafb31ac.xcresult`
- XcodeBuildMCP simulator focused thermal-regression set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered catalog row audio caching, article row audio preparation, stale in-flight focused backdrop rejection, focused queued-backdrop replacement, bounded/latest/newest-first preheat policy, saved direct fast path, saved unsaved-miss caching, saved publish behavior, and saved menu-item persistence
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T01-27-44-484Z_pid15747_bc3d3df8.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `2b52b7c89`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused location-pick audio-tint preparation set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuCatalog` had no item lookup counter and `LocationMenuPick` had no prepared `audioTintName`
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T00-51-04-446Z_pid15747_8e6b17cd.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-52-33-300Z_pid15747_3c0a612c.xcresult`
- XcodeBuildMCP simulator focused location-card playback regression set on iPhone 17 Pro
  - passed: `7` tests, `0` failures
  - covered prepared location-card tint, prepared location-card audio, per-page grouped Mentioned/Related picks, bounded pick caches, canonical city lookup caching, and existing Lusine saved-trip card behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-53-15-433Z_pid15747_6515cfee.xcresult`
- local hygiene checks after the location-pick audio-tint preparation fix:
  - `git diff --check -- native-ios/App/Models/VietnameseMenuCatalog.swift native-ios/App/Views/PhraseListingView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `ca166a859`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused detail-backdrop preheat set on iPhone 17 Pro
  - failed before implementation because `AdminBackdropImagePreheatPlan.focusedQueuedImageNames(...)` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T00-38-27-020Z_pid15747_ec606b65.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-42-46-255Z_pid15747_d870356f.xcresult`
- XcodeBuildMCP simulator focused photo-backdrop preheat regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered stale focused detail queue replacement, root/home selected-plus-lookahead behavior, bounded latest-work behavior, newest-first queue draining, and phrase/browse/menu photo-backdrop preheat eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-43-31-173Z_pid15747_bd4eb3b9.xcresult`
- local hygiene checks after the focused listing-backdrop preheat fix:
  - `git diff --check -- native-ios/App/Views/AdminPhotoBackdropSurfaceView.swift native-ios/App/Views/AppShellView.swift native-ios/App/Views/BrowseCollectionPageView.swift native-ios/App/Views/PhraseListingView.swift native-ios/App/Views/VietnameseMenuPageView.swift native-ios/Tests/AppChromeTests.swift docs/operations/LATEST_VALIDATION.md` passed
  - `node scripts/guard-native-only.js` passed
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `ee876f443`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- local hygiene checks after the detail redraw and saved-membership fixes:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Models/AppChrome.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the inactive root backdrop redraw fixes:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Views/AppShellView.swift native-ios/App/Views/AdminPhotoBackdropSurfaceView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the location-pick grouping fix:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Models/VietnameseMenuCatalog.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the row playback-audio preparation fix:
  - `git diff --check -- native-ios/App/Models/AudioAssetManifest.swift native-ios/App/Models/PhrasePage.swift native-ios/App/Views/PhraseListingView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- local hygiene checks after the location-pick audio preparation fix:
  - `git diff --check -- native-ios/App/Views/PhraseListingView.swift native-ios/App/Models/VietnameseMenuCatalog.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- XcodeBuildMCP simulator focused location-pick audio preparation set on iPhone 17 Pro
  - failed before implementation because `LocationMenuPick.resolvingAudioKey()` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-31T00-12-25-437Z_pid15747_a511370a.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-13-42-358Z_pid15747_dd0c798a.xcresult`
- XcodeBuildMCP simulator focused location-card/audio regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered location-pick audio preparation, grouped Mentioned/Related card reuse, article row audio preparation, calibrated city menu picks, menu/related pick canonical lookup caching, bounded rapid city-browsing caches, and Vietnamese menu name audio
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-14-15-608Z_pid15747_66c5804f.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `0d45202f4`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused row playback-audio preparation set on iPhone 17 Pro
  - failed before implementation because `AudioAssetManifest` had no lookup counter and `PhraseArticlePlaybackAudioResolver` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-58-41-166Z_pid15747_f43ff2af.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-04-55-130Z_pid15747_970f7c3e.xcresult`
- XcodeBuildMCP simulator focused article/audio regression set on iPhone 17 Pro
  - passed: `9` tests, `0` failures
  - covered per-article row playback-audio preparation, visible-section derivation reuse, detail article-adapter reuse, location-pick grouping, Tier 1 visible audio keys, designed phrase exact-text audio fallback, `Xin chào` row audio reuse, all phrase option audio resolution, and bundled-file validation for resolved phrase option audio
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-31T00-06-11-757Z_pid15747_cbf2144b.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `6dd111d13`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused location-pick grouping set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleLocationPickGroups` and catalog section-filter counters did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-36-16-052Z_pid15747_ba70322e.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-38-48-359Z_pid15747_106470a1.xcresult`
- XcodeBuildMCP simulator focused location-card/redraw regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered per-page grouping for Mentioned/Related cards, visible-section derivation reuse, detail article-adapter reuse, menu/related pick cache canonicalization, bounded rapid city-browsing caches, Han Market related-card routing, and V2.2 related-place card exposure
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-39-42-358Z_pid15747_02d47361.xcresult`
- Corrected physical iPhone Debug build/install explicitly from worktree root `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/admin-photo-backdrop-polish` at branch HEAD `3ea7487f0` with app-code commit `7a7f0dcbe`
  - this corrected the phone-build root after Jojo observed the old static `Xin chào` screen; the phone helper defaults to the canonical app-family checkout unless `SPEAKLOCAL_REPO_ROOT` is set
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `7a7f0dcbe`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused morph-policy set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleMorphPolicy` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-09-52-706Z_pid15747_f442da87.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-10-55-774Z_pid15747_5e8cce2a.xcresult`
- XcodeBuildMCP simulator focused inactive root/admin scroll-geometry set on iPhone 17 Pro
  - failed before implementation because `AdminPhotoBackdropTaskPolicy.shouldApplyScrollGeometry` and `HomePhotoBackdropTaskPolicy` did not exist
  - passed after implementation as part of the focused regression set below
  - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T23-13-25-315Z_pid15747_06d3d2e7.log`
- XcodeBuildMCP simulator focused inactive root backdrop redraw regression set on iPhone 17 Pro
  - passed: `7` tests, `0` failures
  - covered inactive admin/root backdrop delayed-task and scroll-geometry gating, no-morph detail identity fast path, visible-section derivation reuse, article-adapter reuse, generated detail preheat SQLite bypass, phrase photo-backdrop preheat eligibility, inactive listing/browse/menu scroll-geometry gating, and Home backdrop activation behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-17-12-997Z_pid15747_d0a9e12f.xcresult`
- XcodeBuildMCP simulator visual build/run for `Xin chào` on iPhone 17 Pro from app-code commit `6bc2f3bcc`
  - build passed
  - launch passed with `--detail-page viet-polite-hello`
  - screenshot confirmed the current branch opens `Xin chào` with the rounded pull-down content sheet over the photo backdrop
  - build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/build_run_sim_2026-05-30T23-24-11-471Z_pid15747_8e5815bc.log`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `6bc2f3bcc`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - a follow-up force-launch with existing-process termination was also blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused visible-section derivation set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleTemplateView.resetVisibleSectionsBuildCountForTesting` and `PhraseArticleTemplateView.visibleSectionsBuildCountForTesting` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-53-27-063Z_pid15747_85228af8.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-56-07-091Z_pid15747_12de26f1.xcresult`
- XcodeBuildMCP simulator focused saved-membership canonical-lookup set on iPhone 17 Pro
  - failed before implementation: `LocalUserIntentStoreTests/testSavedMembershipSkipsCanonicalLookupForEmptyAndDirectCanonicalIDs` observed one SQLite canonical lookup for an empty Saved list and one for an already-canonical saved ID
  - passed after implementation as part of the focused regression set below
  - red result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-59-31-334Z_pid15747_1f513330.xcresult`
- XcodeBuildMCP simulator focused detail redraw/saved-membership regression set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered visible-section derivation reuse, article-adapter reuse, generated detail preheat SQLite bypass, phrase photo-backdrop preheat eligibility, saved-membership empty/direct-canonical lookup fast paths, saved toggle invalidation, saved/practice persistence, and saved menu-item behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T23-01-34-500Z_pid15747_2b4c72b0.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `c4e597907`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- local hygiene checks after the detail article-adapter fix:
  - `git diff --check -- native-ios/App/Models/PhrasePage.swift native-ios/App/Views/PhraseDetailView.swift native-ios/Tests/AppChromeTests.swift` passed
  - `node scripts/guard-native-only.js` passed
- XcodeBuildMCP simulator focused detail article-adapter set on iPhone 17 Pro
  - failed before implementation because `PhraseDetailPage.resetArticleTemplateBuildCountForTesting` and `PhraseDetailPage.articleTemplateBuildCountForTesting` did not exist
  - passed after implementation as part of the focused performance/backdrop set below
  - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-33-39-105Z_pid15747_28b1eae4.log`
- XcodeBuildMCP simulator focused performance/backdrop set with article-adapter reuse on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered generated detail navigation skipping SQLite hero-name lookup for preheat, inactive standard article task gating, phrase photo-backdrop preheat eligibility, and detail article-adapter reuse across repeated body refreshes
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-40-52-245Z_pid15747_d6976ca6.xcresult`
- XcodeBuildMCP broader `AppChromeTests` sweep on iPhone 17 Pro
  - not clean: `208` tests passed and `4` tests failed
  - failures are content/fixture expectation drift unrelated to the detail article-adapter code path: entity template row hiding, V2.2 production heading/phrase-card expectations, handwritten menu source copy expectations, and one generic menu guide-copy audit row
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-40-24-498Z_pid15747_8a700f42.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `39fcfe557`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused detail-navigation hero-preheat set on iPhone 17 Pro
  - failed before implementation because `AppShellView.detailBackdropPreheatImageNames(pageID:heroImageNameOverride:)` and `VietSQLitePhraseGraphRuntime.heroImageNameLookupCountForTesting` did not exist
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-22-19-924Z_pid15747_dc3d7592.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-24-47-367Z_pid15747_7d06b02b.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with detail-navigation hero-preheat SQLite bypass on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered generated detail navigation skipping SQLite hero-name lookup for preheat, static authored preheat preservation, phrase/category/menu backdrop preheat policies, bounded SQLite/search/detail caches, inactive listing/browse/menu scroll-geometry gating, inactive collection deferred-task gating, generated browse asset probe bypasses, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-25-25-867Z_pid15747_7ad03d56.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `1a6248f58`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused inactive scroll-geometry/preference-tracking set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleTaskPolicy`, `BrowseCollectionTaskPolicy`, and `VietnameseMenuTaskPolicy` had no policy seam for inactive scroll-geometry or menu section-preference callbacks
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T22-02-09-403Z_pid15747_f17c2e77.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-03-35-668Z_pid15747_3765bbfa.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with inactive scroll-geometry/preference gating on iPhone 17 Pro
  - passed: `14` tests, `0` failures
  - covered inactive listing/browse/menu photo-backdrop scroll-geometry gating, inactive menu section-preference gating, inactive collection deferred-task gating, active+visible admin/root backdrop delayed-task gating, inactive standard article task gating, generated browse hero/backdrop image names skipping UIKit existence probes, normal browse thumbnails skipping UIKit image-size reads, visible-only browse collection mounting, bounded category browse hero overrides, bounded city pick caches, phrase/category backdrop eligibility, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T22-04-23-090Z_pid15747_89c97878.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `71c706b4b`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused inactive collection deferred-task set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuTaskPolicy` and `BrowseCollectionTaskPolicy` did not exist, and the affected tasks were keyed without an active-route gate
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T21-51-57-118Z_pid15747_0abb7eb3.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-53-15-492Z_pid15747_ea811de1.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with inactive collection task gating on iPhone 17 Pro
  - passed: `13` tests, `0` failures
  - covered inactive menu/standard browse collection task gating, active+visible admin/root backdrop delayed-task gating, inactive standard article task gating, generated browse hero/backdrop image names skipping UIKit existence probes, normal browse thumbnails skipping UIKit image-size reads, visible-only browse collection mounting, bounded category browse hero overrides, bounded city pick caches, phrase/category backdrop eligibility, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-54-16-872Z_pid15747_3099a719.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `67bf033f7`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- XcodeBuildMCP simulator focused browse generated-image existence-probe set on iPhone 17 Pro
  - failed before implementation because `BrowseImageAssetPolicy` did not exist and browse rows always had to call through the `BrowseImageAssetCache.exists` seam for generated image names
  - passed after implementation: `1` test, `0` failures
  - result artifacts:
    - red build log: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/logs/test_sim_2026-05-30T21-36-42-474Z_pid15747_f7147d4e.log`
    - green result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-38-35-307Z_pid15747_24f0e6e0.xcresult`
- XcodeBuildMCP simulator focused thermal/navigation set with generated-image existence-probe bypass on iPhone 17 Pro
  - passed: `11` tests, `0` failures
  - covered generated browse hero/backdrop image names skipping UIKit existence probes, normal browse thumbnails skipping UIKit image-size reads, active+visible admin/root backdrop delayed-task gating, bounded category browse hero overrides, duplicate browse category preheat avoidance, bounded city pick caches, listing photo-backdrop preheat policy, phrase/category backdrop eligibility, and static designed `Xin chào` photo-backdrop eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T21-39-44-450Z_pid15747_796c827f.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `950ffc04b`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- xcodebuild simulator focused browse thumbnail size-probe set on iPhone 17 Pro
  - failed before implementation because `BrowseFocusedAssetImagePolicy` did not exist and normal thumbnails had no policy seam to skip UIKit size reads
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-16-41-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-17-53-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with browse thumbnail size-probe gating on iPhone 17 Pro
  - passed: `26` tests, `0` failures
  - covered normal browse thumbnails skipping UIKit image-size reads, active+visible admin/root backdrop delayed-task gating, bounded category browse hero overrides, inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, static designed `Xin chào` photo-backdrop eligibility, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-18-54-+0700.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `01682364a`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- xcodebuild simulator focused admin/root photo-backdrop delayed-task set on iPhone 17 Pro
  - failed before implementation because `AdminPhotoBackdropTaskPolicy` did not exist
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-53-39-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-01-54-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with active+visible root photo-backdrop task gating on iPhone 17 Pro
  - passed: `25` tests, `0` failures
  - covered active+visible admin/root backdrop delayed-task gating, bounded category browse hero overrides, inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, static designed `Xin chào` photo-backdrop eligibility, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_04-02-38-+0700.xcresult`
- Physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` app-code commit `1889ce305`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- xcodebuild simulator focused inactive phrase-article task set on iPhone 17 Pro
  - failed before implementation because `PhraseArticleTaskPolicy` did not exist
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-12-54-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-13-42-+0700.xcresult`
- xcodebuild simulator focused browse detail preheat policy set on iPhone 17 Pro
  - failed before implementation because `AppShellView` had no browse hero override or generic-preheat policy seam
  - passed after implementation: `2` tests, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-35-41-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-36-57-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with inactive-task gating and duplicate browse-preheat avoidance on iPhone 17 Pro
  - passed: `27` tests, `0` failures
  - covered inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, V2.2 Mentioned Here/related cards, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-37-56-+0700.xcresult`
- xcodebuild simulator focused browse hero override cache-growth set on iPhone 17 Pro
  - failed before implementation because `AppShellBrowseDetailHeroOverrideCache` did not exist
  - passed after implementation: `1` test, `0` failures
  - result bundles:
    - red: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-45-10-+0700.xcresult`
    - green: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-46-45-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with bounded browse hero overrides on iPhone 17 Pro
  - passed: `24` tests, `0` failures
  - covered bounded category browse hero overrides, inactive standard article task gating, browse detail category hero override/preheat policy, bounded city pick caches, long-history render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_03-47-51-+0700.xcresult`
- xcodebuild simulator focused canonical recent-page reuse set on iPhone 17 Pro
  - passed: `2` tests, `0` failures
  - covered returning the canonical detail ID from navigation and recording an already-canonical recent page without re-running the page canonicalization path
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-12-44-+0700.xcresult`
- xcodebuild simulator focused thermal set with canonical recent-page reuse on iPhone 17 Pro
  - passed: `20` tests, `0` failures
  - covered canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-13-36-+0700.xcresult`
- xcodebuild simulator focused Vietnamese menu indexed lookup set on iPhone 17 Pro
  - failed before implementation because `VietnameseMenuCatalog` had no indexed item lookup/testing surface
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-33-47-+0700.xcresult`
- xcodebuild simulator focused thermal set with Vietnamese menu indexed lookups on iPhone 17 Pro
  - passed: `22` tests, `0` failures
  - covered indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-34-41-+0700.xcresult`
- xcodebuild simulator focused menu-detail SQLite-bypass set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testMenuDetailPagesBypassSQLitePhraseGraphLookup` counted `2` SQLite detail-page resolver calls for two menu-owned pages
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-48-05-+0700.xcresult`
- xcodebuild simulator focused thermal set with menu-detail SQLite bypass on iPhone 17 Pro
  - passed: `23` tests, `0` failures
  - covered menu-owned detail pages bypassing the SQLite phrase-detail resolver, indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_23-48-55-+0700.xcresult`
- xcodebuild simulator focused menu-route SQLite-canonical bypass set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testMenuDetailNavigationBypassesSQLiteCanonicalLookup` counted `4` SQLite canonical resolver calls while opening two menu-owned pages
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_00-38-19-+0700.xcresult`
- xcodebuild simulator focused thermal set with menu-route SQLite-canonical bypass on iPhone 17 Pro
  - passed: `24` tests, `0` failures
  - covered menu-owned route navigation bypassing the SQLite canonical resolver, menu-owned detail pages bypassing the SQLite phrase-detail resolver, indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_00-39-38-+0700.xcresult`
- xcodebuild simulator focused phrase-row navigation cache set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testPhraseRowNavigationCachesRepeatedCanonicalPairChecks` showed repeated row body checks pushed SQLite canonical lookup count from `2` to `26`
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_01-08-55-+0700.xcresult`
- XcodeBuildMCP simulator focused designed-`Xin chào` route set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testDesignedXinChaoCheckAvoidsRepeatedCanonicalLookupForNormalListings` showed repeated normal-listing checks pushed SQLite canonical lookup count from `2` to `26`
  - passed after implementation: `4` tests, `0` failures
  - covered the designed `Xin chào` direct/canonical route check, normal listing rejection without repeated canonical resolver calls, static designed phrase pages using photo-backdrop layout, and listing backdrop preheat eligibility
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-31-40-871Z_pid15747_4c6eec00.xcresult`
- XcodeBuildMCP simulator focused canonical detail-page resolved-cache set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testCanonicalDetailPagesReuseResolvedPageWithoutRepeatedSQLiteLookup` showed repeated same-page resolution pushed SQLite detail resolver count from `1` to `13`
  - passed after implementation: `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-52-47-725Z_pid15747_abfc4edf.xcresult`
- xcodebuild simulator focused long detail-history render set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testRenderedDetailPagesDoNotScanEntireLongHistory` showed the detail renderer inspecting all `7` history entries to render only `1` active page or `2` active/back-preview pages
  - passed after implementation: `1` test, `0` failures; active-page rendering now checks `1` candidate and back-preview rendering checks `2`
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-28-00-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with long-history suffix rendering on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered long-history detail render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-29-52-+0700.xcresult`
- xcodebuild simulator focused city-pick cache-growth set on iPhone 17 Pro
  - failed before implementation: `AppChromeTests/testLocationPickCachesStayBoundedDuringRapidCityBrowsing` showed both city pick caches growing to `108` entries while the intended cap was `96`
  - passed after implementation: `6` tests, `0` failures
  - covered bounded city menu/related pick caches, canonical city alias sharing, existing V2.2 Mentioned Here cards, and existing V2.2 Compare Nearby cards
  - failed result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-52-12-+0700.xcresult`
  - passed result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-53-55-+0700.xcresult`
- xcodebuild simulator focused thermal/navigation set with bounded city-pick caches on iPhone 17 Pro
  - passed: `22` tests, `0` failures
  - covered bounded city pick caches, city-card alias behavior, long-history detail render suffixing, current-only detail/collection mounting, resolved canonical detail-page reuse, menu-owned detail/canonical SQLite bypasses, designed `Xin chào` route checks, phrase-row canonical pair caching, root `Xin chào` surface gating, listing photo-backdrop layout/preheat policy, SQLite hero-image lightweight lookup, and default SQLite runtime behavior
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-admin-photo-backdrop-polish/Logs/Test/Test-SpeakLocalNative-2026.05.31_02-54-54-+0700.xcresult`
- repo hygiene after bounded city-pick cache fix
  - `git diff --check`: passed
  - `node scripts/guard-native-only.js`: passed
  - signing scan found no repo-visible personal signing values; only generic project `CODE_SIGN_IDENTITY = "iPhone Developer"` entries remain
- XcodeBuildMCP simulator focused thermal set with resolved detail-page cache on iPhone 17 Pro
  - passed: `23` tests, `0` failures
  - covered resolved canonical detail-page reuse, menu-owned detail lookup bypass, menu route canonical bypass, designed `Xin chào` route check, phrase-row canonical pair caching, hidden detail/collection mounting, root-surface gating, listing/category/menu backdrop preheat policies, bounded/newest-first image preheat work, indexed menu item lookup, SQLite hero-image lightweight lookup, default SQLite runtime behavior, and legacy ID canonicalization
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-53-51-679Z_pid15747_ee0f3668.xcresult`
- XcodeBuildMCP simulator local-intent thermal set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered batched recent-page disk persistence, recording already-canonical recent pages, suppressing broad invalidation while recording recents, and preserving saved-page invalidation
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-54-16-891Z_pid15747_72f59336.xcresult`
- XcodeBuildMCP simulator fixture/runtime compatibility set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered SQLite-disabled static authored pages, default SQLite runtime detail resolution, and legacy-home-ID canonicalization after adding the resolved-page cache
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T18-55-05-780Z_pid15747_ec4e8893.xcresult`
- XcodeBuildMCP simulator build/run smoke on iPhone 17 Pro
  - current `Xin chào` deep-link smoke passed for `--detail-page viet-phrase-polite-1`
  - current Home featured `Xin chào` tap smoke passed from the Home card
  - current branch shows the pull-down content sheet over `BackdropPhraseGreetingCafeDoorway`, not the old static Ha Long masthead layout
- xcodebuild simulator focused thermal set with phrase-row navigation cache on iPhone 17 Pro
  - passed: `22` tests, `0` failures
  - covered repeated phrase-row canonical pair caching, phrase-row self-link suppression, menu-owned route navigation bypassing the SQLite canonical resolver, menu-owned detail pages bypassing the SQLite phrase-detail resolver, indexed menu item/detail-page lookup, large menu model non-Equatable guard, canonical recent-page reuse, newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_01-10-06-+0700.xcresult`
- xcodebuild simulator focused local-intent thermal set on iPhone 17 Pro
  - passed: `4` tests, `0` failures
  - covered batched recent-page disk persistence, recording already-canonical recent pages, suppressing broad invalidation while recording recents, and preserving saved-page invalidation
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.31_01-11-09-+0700.xcresult`
- XcodeBuildMCP simulator focused recent-page batched-persist thermal set on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered batched recent-page disk persistence, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T14-49-34-348Z_pid15747_b555ea44.xcresult`
- xcodebuild simulator focused newest-first preheat thermal set on iPhone 17 Pro
  - passed: `18` tests, `0` failures
  - covered newest-first queued backdrop preheat work, bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, batched recent-page disk persistence, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-fbepxxxydckfxhhkxqoxsbhddgek/Logs/Test/Test-SpeakLocalNative-2026.05.30_22-11-13-+0700.xcresult`
- XcodeBuildMCP simulator focused serialized-preheat thermal set on iPhone 17 Pro
  - passed: `16` tests, `0` failures
  - covered bounded/latest queued backdrop preheat work, category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T14-23-54-799Z_pid15747_11f74f08.xcresult`
- XcodeBuildMCP simulator focused collection/menu prepared-image thermal set on iPhone 17 Pro
  - passed: `14` tests, `0` failures
  - covered category/city/menu photo backdrop preheat policy, current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T14-09-15-196Z_pid15747_321127fc.xcresult`
- XcodeBuildMCP simulator focused browse-collection hidden-work thermal set on iPhone 17 Pro
  - passed: `12` tests, `0` failures
  - covered current-only browse/category/menu collection mounting between gestures, current-only detail mounting between gestures, back/forward presentation behavior, root `Xin chào` surface gating, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-59-55-976Z_pid15747_c6bc3e88.xcresult`
- XcodeBuildMCP simulator focused root-surface thermal set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered root `Xin chào` surface gating, inactive Home render gating, current-only detail mounting between gestures, back/forward presentation behavior, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-37-41-947Z_pid15747_633dcb71.xcresult`
- XcodeBuildMCP simulator focused hidden-detail thermal set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered current-only detail mounting between gestures, back/forward presentation behavior, inactive Home render gating, listing backdrop preheat policy, local-intent invalidation, saved-page invalidation, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-26-40-467Z_pid15747_c28f5fef.xcresult`
- XcodeBuildMCP simulator focused second-layer thermal set on iPhone 17 Pro
  - passed: `10` tests, `0` failures
  - covered inactive Home render gating, local-intent invalidation, listing backdrop preheat policy, city menu/related pick caching, Home recently-viewed canonicalization, static `Xin chào` photo-card layout, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T13-12-53-413Z_pid15747_3411df8e.xcresult`
- XcodeBuildMCP simulator focused thermal/content set on iPhone 17 Pro
  - passed: `17` tests, `0` failures
  - covered local-intent invalidation, listing backdrop preheat policy, city menu/related pick caching, V2.2 mentioned/related cards, and lightweight SQLite hero lookup
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/admin-photo-backdrop-polish-345f0f53dadb/result-bundles/test_sim_2026-05-30T12-44-09-205Z_pid15747_1987ab03.xcresult`
- XcodeBuildMCP simulator build/run smoke on iPhone 17 Pro
  - current `Xin chào` card-over-photo smoke passed for `--detail-page viet-polite-hello`
  - phrase backdrop smoke passed for `--detail-page viet-phrase-phone-1`
  - city/listing backdrop smoke passed for `--detail-page viet-family-city-danang-place-international-terminal`
  - screenshots captured at:
    - `docs/task-results/listing-thermal-audit-2026-05-30/xin-chao-current-card-smoke.jpg`
    - `docs/task-results/listing-thermal-audit-2026-05-30/phrase-phone-backdrop-smoke.jpg`
    - `docs/task-results/listing-thermal-audit-2026-05-30/city-terminal-backdrop-smoke.jpg`
- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- broader XcodeBuildMCP simulator `AppChromeTests` + `SQLiteLanguagePackRepositoryTests`
  - compiled and ran `208` tests
  - passed: `203`
  - failed: `5` pre-existing content-expectation/copy-audit tests outside the thermal files, including V2.2 city copy expectation drift and Vietnamese menu guide-copy audit drift
- Physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish`
  - build passed
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files
- Latest physical iPhone launch readiness check from `feature/admin-photo-backdrop-polish` commit `c8093ca3d`
  - simulator focused thermal/navigation set passed with bounded city menu/related pick caches; both caches now stay at or below `96` entries during a synthetic rapid city-listing browsing burst
  - physical phone launch readiness check reported the phone was locked, so build/install/launch proof for this exact commit remains pending
  - remaining proof gap: unlock the phone, keep it awake, rerun the corrected worktree installer, then continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone launch check from `feature/admin-photo-backdrop-polish` commit `719783c1a`
  - simulator focused thermal/navigation set passed with long-history detail render suffixing; rendering now inspects only the active page, or active plus immediate back-preview page, instead of filtering the full detail history
  - physical phone launch check reported the phone was locked, so build/install/launch proof for this exact commit remains pending
  - remaining proof gap: unlock the phone, keep it awake, rerun the corrected worktree installer, then continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `b5cff54fd`
  - simulator focused thermal set passed with the resolved detail-page cache; repeated same-page resolution now stays at `1` SQLite detail resolver entry instead of rising to `13`
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `28e259f22`
  - simulator build/run smoke passed for `--detail-page viet-phrase-polite-1` and for tapping the Home featured `Xin chào` card; current branch shows the pull-down sheet over `BackdropPhraseGreetingCafeDoorway`, not the old static Ha Long masthead layout
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then confirm the on-phone `Xin chào` screen and continue the hands-on thermal retest while rapidly opening listing pages
- Latest physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` commit `48e664d74`
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch passed
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install/launch from `feature/admin-photo-backdrop-polish` commit `ae598fb8a`
  - simulator build/run smoke passed for `--detail-page viet-polite-hello`; current branch shows the `Xin chào` pull-down sheet over the `BackdropPhraseGreetingCafeDoorway` image instead of the old static Ha Long masthead layout
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch passed
  - signing scan stayed clean before and after the build; personal signing remained local and was not written to repo files
  - remaining proof gap: hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `53a586239`
  - build passed
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `a88d8063f`
  - build passed from a dedicated `Debug-iphoneos` product
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `8ce390df0`
  - build passed from a dedicated `Debug-iphoneos` product
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone
- Latest physical iPhone Debug build/install from `feature/admin-photo-backdrop-polish` commit `1d665972b`
  - simulator build/run smoke passed for `--detail-page viet-polite-hello`; current branch shows the `Xin chào` pull-down sheet over the `BackdropPhraseGreetingCafeDoorway` image instead of the old static Ha Long masthead layout
  - build passed from the feature worktree
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean before the build; personal signing remained local and was not written to repo files
  - remaining proof gap: unlock the phone, launch the installed build, then do the hands-on thermal retest while rapidly opening listing pages on the physical iPhone

## Current Main Non-Paywall Merge Sweep Evidence

Current `main` evidence from the 2026-05-29 orchestrator merge sweep:

- merged lanes: `feature/admin-photo-backdrop-polish`, `feature/bottom-padding-audit`, and `feature/menu-section`
- explicitly skipped lanes: `feature/messages-section`, `feature/paywall`, and `archive/messages-section-20260516`
- preserved boundary: Paywall and Messages branch heads remain unmerged into `main`
- merge resolution: kept a single `AppChromeLayout.topReadableShieldHeight` declaration using `max(topSeparationHeight, topAdminHitTestEnvelopeHeight)`, while preserving bottom-clearance validation helpers and Menu scroll-coordinator behavior
- follow-up validation fix: Search standard-scroll validation now scrolls to `Search.BottomSentinel` under the `--validate-bottom-inset-scroll-to-bottom` launch argument, and `BottomInsetUITests` now query sentinel `otherElements` directly instead of broad `.any` snapshots

Fresh command evidence from this pass:

- `git diff --check`
  - passed before and after the Search validation fix
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-search-only-surfacing.js`
  - passed: `315` keep-search-only rows, `26` browsable subcategories, `315` generated relations, `315` generated section items
- XcodeBuildMCP simulator `AppChromeTests` focused merge set on iPhone 17 Pro
  - passed: `8` tests, `0` failures
  - covered search-only Browse surfacing, bottom-clearance policy, Menu section inventory, Menu large-model `Equatable` guard, pinned section coalescing, immediate jump policy, and top-section chrome coordinator behavior
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T14-53-21-114Z_pid4769_05fb8cb6.xcresult`
- XcodeBuildMCP simulator Menu UI checks on iPhone 17 Pro
  - passed: `BrowseSearchUITests/testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive` and `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `2` tests, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T14-53-54-621Z_pid4769_defac781.xcresult`
- XcodeBuildMCP simulator bottom-inset UI split reruns on iPhone 17 Pro
  - passed: `BottomInsetUITests/testPrimaryRootRoutesKeepBottomContentAboveSystemTabBar`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T15-00-08-099Z_pid4769_e7a89e4a.xcresult`
  - passed: `BottomInsetUITests/testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/result-bundles/test_sim_2026-05-29T15-00-55-255Z_pid4769_9093f927.xcresult`
- XcodeBuildMCP simulator build/run smoke on iPhone 17 Pro
  - build passed
  - install passed
  - launch passed
  - bundle id: `app.speaklocal.vietnam.native`
- Physical iPhone Debug build/install from current `main`
  - commit: `8fa4f7718` (`Record non-paywall merge sweep validation`)
  - build passed
  - install passed for bundle id `app.speaklocal.vietnam.native`
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Current Menu Section Worktree Evidence

Current `feature/menu-section` evidence from the 2026-05-29 Vietnamese menu top-section picker fix:

- taxonomy fix: the Food Menu now publishes restaurant-style section headers to the in-page rail, visible section titles, and top glass dropdown from the same `VietnameseMenuCatalog.sections(for:)` source; legacy protein buckets such as `Pork` and `Beef & goat` are folded into `Grilled & braised meats`
- root-cause fix: pinned top-section `Menu` selections now keep the selected section label stable while the lazy, variable-height section stack converges on the requested anchor
- smoothness fix: pinned, scroll-derived section-title crossings are coalesced before publishing to the top glass label, while direct dropdown/rail jumps still update immediately
- direct-jump stability fix: explicit top-picker selections now keep ownership of the pill label through the short lazy-stack settle window so scroll geometry cannot relabel the pill to a neighboring section while the jump lands
- second-layer smoothness fix: unnecessary deep `Equatable` conformance was removed from large Vietnamese menu payload/section/item structs after a scroll CPU sample showed AttributeGraph comparing whole section/item arrays during section-boundary updates
- preserved UX: the existing top glass dropdown surface, in-page rail, audio speed chrome, and menu rows remain in place; the food inventory still exposes 269 unique rows

Fresh command evidence from this pass:

- XcodeBuildMCP simulator `AppChromeTests` menu inventory/taxonomy set
  - passed: `testVietnameseMenuCollectionsUseCsvBackedInventory`, `testVietnameseMenuSectionsExposeFullVerticalInventory`, `testVietnameseMenuSectionTrackingCoordinatorPublishesOnlyMeaningfulChanges`, and `testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges`, `4` tests, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T12-50-59-636Z_pid11523_ca9b3100.xcresult`
- XcodeBuildMCP simulator top-picker UI taxonomy set
  - passed: `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `testVietnameseMenuTopSectionPillJumpsToSeafood`, `testVietnameseFoodMenuSectionRailScrollsToCategory`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `4` tests, `0` failures
  - verifies the top picker exposes `Seafood`, `Grilled & braised meats`, and `Soups & hot pots`, while old `pork` and `beef-and-goat` menu entries are absent
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T12-51-21-598Z_pid11523_0fee6598.xcresult`
- XcodeBuildMCP simulator resumed top-picker proof
  - initial rerun failed before app launch because the previously configured feature simulator was no longer available
  - rerun on the available iPhone 17 Pro simulator passed: `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `1` test, `0` failures
  - result bundle: `~/Library/Developer/XcodeBuildMCP/workspaces/menu-section-25e9f9157f08/result-bundles/test_sim_2026-05-29T14-43-37-911Z_pid11523_e9e8457a.xcresult`
- Physical iPhone install for the taxonomy fix
  - previous four attempts were blocked before build/install because Xcode reported no connected or available paired iPhone
  - resumed physical-device attempt passed build, install, and launch for the current `feature/menu-section` app build
  - post-build signing scan passed; local personal signing remained outside repo-tracked signing files
- simulator CPU sample while driving the fast Vietnamese Food Menu section-boundary swipe
  - before the second-layer fix: sampled stacks included `VietnameseMenuSection.__derived_struct_equals` / `VietnameseMenuItem.__derived_struct_equals` under AttributeGraph equality work
  - after the fix: repeated sample at `native-ios/artifacts/menu-section-cpu-sample-20260529-174504-post-equatable/vietnamese-menu-section-scroll.sample.txt` no longer contained those equality stacks
- XcodeBuildMCP simulator `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`
  - failed before the first scroll-stability fix because the top pill did not stay on the chosen `Seafood` section
  - now passes against the restaurant-style section set instead of the old protein buckets
- XcodeBuildMCP simulator `AppChromeTests` second-layer performance guard
  - passed: `testVietnameseMenuLargeModelsAvoidDeepEquatableComparisons`, plus section coalescing and immediate-jump policy tests, `3` tests, `0` failures
- XcodeBuildMCP simulator current combined menu smoothness set after the second-layer fix
  - passed: `testVietnameseMenuLargeModelsAvoidDeepEquatableComparisons`, `testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges`, `testVietnameseMenuSectionJumpPolicyUsesImmediateScroll`, `testVietnameseMenuSectionChromeCoordinatorSeparatesPinnedChangesFromLabelChanges`, `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `6` tests, `0` failures
- Physical iPhone focused UI test run after the second-layer fix
  - passed: `BrowseSearchUITests/testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive` and `BrowseSearchUITests/testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, `2` tests, `0` failures
  - result bundle: `~/Library/Developer/Xcode/DerivedData/SpeakLocalNative-dnxakcrpfonvumejbiymsetlqwjq/Logs/Test/Test-SpeakLocalNative-2026.05.29_17-49-35-+0700.xcresult`
- XcodeBuildMCP simulator combined direct-jump and boundary-coalescing smoke set
  - passed: `testVietnameseMenuSectionTrackingDefersPinnedScrollBoundaryChanges`, `testVietnameseMenuSectionJumpPolicyUsesImmediateScroll`, `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `4` tests, `0` failures
- XcodeBuildMCP simulator `AppChromeTests` focused menu/chrome set
  - passed: `8` tests, `0` failures
- XcodeBuildMCP simulator menu/top-picker focused UI set
  - passed: `testVietnameseFoodMenuSectionRailScrollsToCategory`, `testVietnameseMenuTopSectionPillAppearsAfterInPageRailScrollsOff`, `testVietnameseMenuTopSectionPillJumpsToSeafood`, `testVietnameseMenuTopSectionPillJumpsToMatchingFoodSections`, and `testVietnameseMenuFastSectionBoundaryScrollKeepsTopPickerResponsive`, `5` tests, `0` failures
- XcodeBuildMCP simulator visual check
  - passed: fast scrolls across section-title boundaries remain responsive, and selecting a top dropdown section keeps the top pill on the selected restaurant-style section
- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- signing-file cleanliness check
  - passed: `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` stayed unchanged
- Physical iPhone Debug build/install from `feature/menu-section` after the second-layer fix
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Current Main City Pages v2.2 Merge Evidence

Current `main` evidence from the 2026-05-29 city-pages merge:

- merged app/content commit: `7ba42f0fc` (`Merge city-pages`)
- merged lanes: `feature/city-pages`
- synced clean allowed lanes to final `main`: all clean non-Messages/non-Paywall worktrees were fast-forwarded to `7ba42f0fc`
- explicitly skipped lanes: `feature/messages-section`, `feature/paywall`, and `archive/messages-section-20260516`
- exclusion check passed: `main` does not contain the Messages or Paywall branch heads

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
  - passed: `500` total, `500` `FINAL_PASS`, `0` revise/fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
  - passed: `0` failures
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed under the current non-unique hero gate
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `500` city places, `0` release-blocking missing-audio rows
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- V2.2 Node test chain
  - passed: validator, projection, and builder tests
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Current City Pages Hard Reset v2.2 Evidence

Current `feature/city-pages` evidence from the 2026-05-27 hard reset:

- hard-reset receipt: `docs/editorial-exports/viet-city-pages/hard-reset-v2-2-2026-05-27/HARD_RESET_V2_2_FINAL_RECEIPT.md`
- current city/page authority: `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- source authority: `content-draft/viet/city-library/app-detail-v2-2/`
- inventory: `500` in-scope city/place listings, `100` each for Da Nang, Hanoi, Ho Chi Minh City, Hoi An, and Hue
- status: all four hard-reset gates issued `FINAL_PASS`

Fresh command evidence from this pass:

- V2.2 regeneration chain
  - passed: projected `500` entries into compatibility source, regenerated authored listing resources, SQLite fixture, and practice deck
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
  - passed: `500` total, `500` `FINAL_PASS`, `0` revise/fail
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
  - passed: `0` failures; formula checks reported zero hits for the repaired banned phrases
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `500` city places, `0` release-blocking missing-audio rows
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed under the current non-unique hero gate
- `node scripts/guard-native-only.js`
  - passed
- V2.2 Node test chain and practice deck check/test
  - passed
- Native UI screenshot proof
  - passed: `SpeakLocalNativeUITests/BrowseSearchUITests/testCaptureV22CityPageProductionProof`, `1` test, `0` failures
  - screenshot folder: `docs/design/city-pages/screenshots/v2-2-500-story-production-2026-05-27`
  - fresh artifacts: `20` PNGs, top and scrolled states for `10` proof pages
  - xcresult: `native-ios/artifacts/DerivedData-v2-2-hard-reset-final/Logs/Test/Test-SpeakLocalNative-2026.05.27_16-04-01-+0700.xcresult`
- Physical iPhone Debug build/install/launch from `feature/city-pages`
  - build passed
  - install passed
  - launch passed after the phone became unlockable
  - signing scan stayed clean; personal signing remained local and was not written to repo files

Four-gate status from this pass: Authority / Scope `FINAL_PASS`, Editorial Voice `FINAL_PASS`, Data / Catalog / Audio `FINAL_PASS`, Native Runtime / Release `FINAL_PASS`.

## Current Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-25 non-City-Pages/non-Paywall/non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `a3af0ab41` (`Merge practice-area`)
- merged lanes: `feature/practice-area`
- synced clean allowed feature lanes to final `main`
- explicitly skipped lanes: `feature/city-pages`, `codex/viet-city-phrase-library-v1`, `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`, and old `integration/*` worktrees
- City Pages dirty worktree was left untouched by request

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- XcodeBuildMCP simulator focused Practice/Browse/Home sheet tests
  - passed: `5` tests, `0` failures
- XcodeBuildMCP simulator `SpeakLocalNativeTests/AppChromeTests`
  - passed: `168` tests, `0` failures
- Paywall and Messages exclusion checks
  - passed: paywall commits are contained only by `feature/paywall`; Messages commit is contained only by Messages branches
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Main evidence from the 2026-05-21 non-paywall/non-messages merge sweep:

- validated app/content commit on `main`: `c6c795b3a` (`Reconcile merged city detail phrase rows`)
- merged lanes: `feature/admin-photo-backdrop-polish`, `feature/city-pages`, `feature/practice-area`, `feature/homepage-design`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`, and old `integration/*` worktrees
- merge reconciliation preserved Ba Na Hills journey utility rows, Dragon Bridge map/stop rows, city generated resources, and the homepage playback dock fit checkpoint

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `19` scenarios, `1747` clusters, `1765` phrases, `1758` pages, `0` release-blocking missing-audio rows, `8325` relations
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - passed: `150` strong Tier 1 families, `0` failing rows
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- XcodeBuildMCP simulator regression test
  - passed: `SpeakLocalNativeTests/AppChromeTests/testEntityDetailPagesHideGeneratedPlaceTemplateRows`
- XcodeBuildMCP simulator focused tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `189` tests, `0` failures
- XcodeBuildMCP simulator build/install/launch from `main`
  - passed on booted `iPhone 17 Pro` simulator

No physical iPhone build was run in this pass because the request only asked to merge lanes to `main`.

## Current Main Thermal Bug Hunt Evidence

Current `main` evidence from the 2026-05-21 native thermal bug hunt:

- validated app-code commit installed on Jojo's iPhone: `e8293cd92` (`Merge thermal bug hunt fixes`)
- merged lane: `feature/thermal-bug-hunt-20260521`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`
- thermal-risk fixes landed for cached SQLite canonical page lookups, direct local-state canonical membership checks, non-canceling backdrop image preheat reservation, one-shot Search return-focus restore tasks, and coalesced Practice Match snapshot loads

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- XcodeBuildMCP simulator focused and regression tests
  - passed: `14` tests, `0` failures
  - covered new thermal-regression tests plus `LocalUserIntentStoreTests` and SQLite canonical lookup regressions
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous City Copy Lane Evidence

Fresh evidence from the 2026-05-18 city-place reason-to-go copy pass on `feature/city-pages`:

- `node native-ios/scripts/build-viet-city-copy-review-report.js`
  - passed: `500` approved city noun/place pages, `0` fix-now, `0` hard-block, `0` follow-up, `100/100` approved in each of Ho Chi Minh City, Hanoi, Da Nang, Hoi An, and Hue
- `node native-ios/scripts/audit-viet-city-audience-fit.js`
  - passed: `5` city hubs plus `All Vietnam`, `500` city noun/place pages
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3129` source phrases, `3121` canonical pages, `20248` relations, `0` release-blocking missing-audio rows, `5` cities, `500` city places, `807` city phrase tags, `0` banned file matches
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `8267` items, `18` scenarios, `8` question types
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `git diff --check`
  - passed

Scope note: this was a copy/content/resource pass. No simulator or physical iPhone build was run because no Swift app behavior changed.

## Previous Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-20 homepage follow-up merge sweep:

- validated app-code commit installed on Jojo's iPhone: `5baa2d2c` (`Merge homepage-design`)
- merged lanes: `feature/homepage-design`
- direct `main` app-code checkpoint included: `6325088b` (`Throttle home backdrop work`)
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages, `706` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `164` tests, `0` failures
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-20 non-paywall, non-message-section merge sweep:

- validated app-code commit prepared for Jojo's iPhone: `b1577b01` (`Merge homepage-design`)
- merged lanes: `feature/browse-page`, `feature/city-pages`, `feature/homepage-design`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- clean non-paywall, non-message feature lanes were eligible for sync after the sweep

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages, `706` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `163` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Current `main` evidence from the late 2026-05-19 non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `a3619e55` (`Merge practice-area`)
- merged lanes: `feature/city-pages`, `feature/menu-section`, `feature/browse-page`, `feature/glass-static-area`, `feature/practice-area`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes after the sweep

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `806` pages, `706` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `2791` items, `14` scenarios, `7` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `158` tests, `0` failures
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-19 follow-up non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `7091d8fe` (`Merge menu-section`)
- merged lanes: `feature/city-pages`, `feature/practice-area`, `feature/browse-page`, `feature/homepage-design`, `feature/menu-section`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes after the sweep

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `8267` items, `18` scenarios, `8` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `157` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch was blocked because the phone was locked
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Older Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-19 non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `c1902f28` (`Align hero asset validation with category backdrops`)
- merged lanes: `feature/browse-page`, `feature/city-pages`, `feature/homepage-design`, `feature/menu-section`, `feature/practice-area`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes back to `c1902f28`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - passed: `355` handwritten Vietnamese menu item pages and `15` ready helper phrases
- `node native-ios/scripts/validate-vietnamese-menu-images.js`
  - passed: `355` menu image pairs, `710` images, `0` issues
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - passed: `8267` items, `18` scenarios, `8` question types
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests` plus `SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `155` tests, `0` failures
- Physical iPhone Debug build/install/launch from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Earlier Main Merge Sweep Evidence

Current `main` evidence from the 2026-05-18 non-paywall, non-Messages merge sweep:

- validated app-code commit installed on Jojo's iPhone: `705eb21f` (`Preserve generated city editorial phrase rows`)
- merged lanes: `feature/browse-page`, `feature/city-pages`, `feature/practice-area`, `feature/search-page`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes back to `705eb21f`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-copy.js`
  - passed: `5` hubs, `500` city noun pages, `500` unique target heroes
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-hero-image-assets.js --require-unique-city-place-assets`
  - passed: `500` approved city-library places and `524` active premium hero assets checked
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3129` source phrases, `3121` canonical pages, `21648` relations, `0` release-blocking missing-audio rows, `5` cities, `500` city places, `807` city phrase tags, `0` banned file matches
- `xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' test -only-testing:SpeakLocalNativeTests/AppChromeTests/testEntityDetailPagesHideGeneratedPlaceTemplateRows -only-testing:SpeakLocalNativeTests/PracticeNativeMVPTests`
  - passed: `18` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed on bounded retry after an initial `devicectl` install hang
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

Known validation caveat from this pass:

- A broad pre-fix selected UI run failed in `BrowseSearchUITests` on photo-backdrop city hub proof/test-expectation cases and older menu-scroll assertions. `PracticeUITests` passed in that same run. The fixed AppChrome regression was rerun and passed afterward.

## Earliest Main Merge Sweep Evidence

Current `main` evidence from the non-paywall, non-Messages merge sweep:

- validated app-code commit: `067ad01d` (`Align city browse tests with noun-first tours`)
- merged lane: `feature/browse-page`
- explicitly skipped lanes: `feature/paywall`, `feature/messages-section`, `archive/messages-section-20260516`
- synced clean non-paywall, non-Messages feature lanes back to `067ad01d`

Fresh command evidence from this pass:

- `git diff --check`
  - passed
- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `node native-ios/scripts/validate-viet-city-library.js`
  - passed: `807` pages, `707` beginner, `95` intermediate, `5` advanced
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3129` source phrases, `3121` canonical pages, `22923` relations, `0` release-blocking missing-audio rows, `5` cities, `500` city places, `807` city phrase tags, `0` banned file matches
- `node native-ios/scripts/sync-viet-audio.js`
  - passed: validated `4353` native audio manifest entries in `native-ios/Resources/Audio`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - still fails on inherited asset debt: `HeroVietnameseFoodMenu` is `864 x 1821`, expected `853 x 1844`
  - the asset blob matches the pre-merge `main` baseline, so this is not a merge regression
  - the new strict unique city-place hero asset gate is optional behind `--require-unique-city-place-assets`
- XcodeBuildMCP simulator build, `SpeakLocalNative`, Debug, iOS 26.5 simulator
  - passed with `CODE_SIGNING_ALLOWED=NO`
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/AppChromeTests`
  - passed: `122` tests, `0` failures
- XcodeBuildMCP simulator tests, `SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` plus `SpeakLocalNativeTests/PracticeScenarioModeTests`
  - passed: `68` tests, `0` failures
- Physical iPhone Debug build/install from `main`
  - build passed
  - install passed
  - launch passed
  - signing scan stayed clean; personal signing remained local and was not written to repo files

## Previous Native-Only Cleanup Evidence

This cleanup records the repo direction that `native-ios/` is the only active app product surface.

Validated or prepared in this pass:

- the legacy Expo/React Native `app/` tree was removed from active repo truth
- Codex run actions were redirected to native Xcode build/test/doctor commands
- native audio validation was redirected to `native-ios/Resources/Audio` and `native-ios/Resources/viet-audio-manifest.json`
- active operational docs were rewritten to stop directing workers to Windows, Expo, React Native, Metro, EAS, or `app/`
- `scripts/guard-native-only.js` was added as a structural guardrail

Fresh command evidence from this pass:

- `node scripts/guard-native-only.js`
  - passed: no active Expo/React Native app surface found
- `python3 scripts/check-family-consistency.py --repo-root "$PWD"`
  - passed: native family consistency check
- `node native-ios/scripts/sync-viet-audio.js`
  - passed: validated `3910` native audio manifest entries in `native-ios/Resources/Audio`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - passed: `3078` source phrases, `3070` canonical pages, `20413` relations, `0` release-blocking missing-audio rows, `0` banned file matches
- `git diff --check`
  - passed
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro,OS=latest' build CODE_SIGNING_ALLOWED=NO`
  - passed on Xcode `26.5` / iOS Simulator SDK `26.5`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=45430432-6E67-495B-8A1F-A0086D721315' test -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests CODE_SIGNING_ALLOWED=NO`
  - passed: `158` tests, `0` failures

Known pre-existing test debt:

- `PhrasePageFixtureTests/testAuthoredAudioAuditOnlyHasPlannedCityMissingAudio` fails on current `main` before this cleanup. The failure is the legacy fixture/resource path, not a new native-only cleanup regression.
- Broader `PhrasePageFixtureTests` also still contains tests that explicitly disable the default SQLite runtime. That suite should be retired or rewritten as a native SQLite/content-fixture suite in a dedicated follow-up.

## Last Known Native App Truth

- Active app root: `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios`
- Bundle ID: `app.speaklocal.vietnam.native`
- Product ID: `app.speaklocal.vietnam.subscription.monthly`
- Current language pack under active development: Viet
- Tagalog remains a future native language-pack candidate unless Jojo explicitly reactivates that lane.

## Remaining Proof Needed

- Fresh StoreKit purchase/restore/relaunch proof when the native paywall branch is ready.
- Fresh screenshots for any native UI work that changes visible app behavior.

## Historical Evidence Boundary

Older validation snapshots may mention Windows paths, Expo, EAS, React Native, or an `app/` folder. Those records are archive context only. They do not define the current app build path.
