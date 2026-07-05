# Visual Surface Audit

Worker: A - Visual / Surface QA
Date: 2026-07-04
Repo/branch: `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`
Commit audited: `07a2db5d8`

## Summary Verdict

**Launch blocker:** 20 generated city/place listing pages reference hero image names that are not bundled in `native-ios/Resources/Assets.xcassets`; at least one sampled page renders with a blank white masthead area.

**Fix now:** Generic Browse collection/category and city/detail scrolled states let content sit under the static top controls/status area. Food Menu's scrolled state has a better top-admin/admin-card treatment with a pinned section chip; Airport, Hotel, Eating Out, city hub, and place detail surfaces do not consistently preserve that same readable top treatment.

**Follow-up:** Some generic category subcategory rails repeat fallback imagery across adjacent cards, especially Eating Out, which makes the category page feel less deliberate than Food Menu even when assets exist.

No app-code edits were made.

## Surfaces Inspected

- Home launch, top state.
- Food Menu: `--browse-category vietnamese-food-menu`, top and scrolled.
- Airport: `--browse-category airport`, top and scrolled.
- Hotel: `--browse-category hotel`, top and scrolled.
- Eating Out / Food category: `--browse-category food`, top and scrolled.
- Saigon city hub: `--browse-city hcmc`, top and scrolled.
- City/place detail with valid hero: `--detail-page viet-family-city-hcmc-place-pho-hoa-pasteur`, top and scrolled.
- City/place detail with missing hero: `--detail-page viet-family-city-hanoi-place-pho-10-ly-quoc-su`, top.

## Findings

### HARD_BLOCK - Missing City/Place Hero Images Render Blank

Evidence:
- Static audit found 20 generated authored listing pages whose `heroImageName` is not present as an `.imageset`.
- Sampled page `viet-family-city-hanoi-place-pho-10-ly-quoc-su` rendered a blank white masthead: `visual/missing-hero-pho-10-top.jpg`.
- The missing names live in generated native resource `native-ios/Resources/viet-authored-listing-pages.json`, for example lines around `300479` reference `HeroCityHanoiPlacePho10LyQuocSu`.
- `PhrasePhotoBackdropLayout.supportsCityListingPage` treats any city page with a `HeroCity*` name as photo-backdrop capable without checking asset existence: `native-ios/App/Views/PhraseListingView.swift:1217`.
- The backdrop renderer then calls `AdminBackdropPreparedImage(name:)` with that name directly: `native-ios/App/Views/PhraseListingView.swift:533`.

Missing page heroes found:

```text
viet-family-city-danang-place-banh-canh-yen       HeroCityDanangPlaceBanhCanhYen
viet-family-city-danang-place-bep-hen             HeroCityDanangPlaceBepHen
viet-family-city-danang-place-bun-cha-ca-109      HeroCityDanangPlaceBunChaCa109
viet-family-city-danang-place-bun-rieu-cua-39     HeroCityDanangPlaceBunRieuCua39
viet-family-city-danang-place-moc-quan-seafood    HeroCityDanangPlaceMocQuanSeafood
viet-family-city-danang-place-my-quang-sua-hong-van HeroCityDanangPlaceMyQuangSuaHongVan
viet-family-city-hanoi-place-banh-cuon-ba-hoanh   HeroCityHanoiPlaceBanhCuonBaHoanh
viet-family-city-hanoi-place-banh-cuon-ba-xuan    HeroCityHanoiPlaceBanhCuonBaXuan
viet-family-city-hanoi-place-bun-cha-dac-kim      HeroCityHanoiPlaceBunChaDacKim
viet-family-city-hanoi-place-pho-10-ly-quoc-su    HeroCityHanoiPlacePho10LyQuocSu
viet-family-city-hanoi-place-pho-ga-nguyet        HeroCityHanoiPlacePhoGaNguyet
viet-family-city-hanoi-place-tuyet-bun-cha-34     HeroCityHanoiPlaceTuyetBunCha34
viet-family-city-hcmc-place-bo-kho-ganh           HeroCityHcmcPlaceBoKhoGanh
viet-family-city-hcmc-place-bun-bo-hue-14b        HeroCityHcmcPlaceBunBoHue14b
viet-family-city-hcmc-place-man-moi               HeroCityHcmcPlaceManMoi
viet-family-city-hcmc-place-pho-huong-binh        HeroCityHcmcPlacePhoHuongBinh
viet-family-city-hcmc-place-pho-le-district-5     HeroCityHcmcPlacePhoLeDistrict5
viet-family-city-hcmc-place-pho-minh              HeroCityHcmcPlacePhoMinh
viet-family-city-hoian-place-cao-lau-thanh        HeroCityHoianPlaceCaoLauThanh
viet-family-city-hoian-place-com-ga-ba-buoi       HeroCityHoianPlaceComGaBaBuoi
```

Recommended safe fixes:
- Best: add the missing `.imageset` assets for the 20 referenced `HeroCity*` names under `native-ios/Resources/Assets.xcassets`.
- Also add a generated-resource validation check that every `heroImageName` in `native-ios/Resources/viet-authored-listing-pages.json` resolves to an asset before launch proof passes.
- Consider a defensive runtime fallback in `PhrasePhotoBackdropLayout.supportsListingPage` / `PhraseArticleTemplateView` so missing image names fall back to a known city/category hero instead of a blank masthead.

Likely files:
- `native-ios/Resources/Assets.xcassets/`
- `native-ios/Resources/viet-authored-listing-pages.json` via source regeneration, not hand-editing.
- Validation script location under `native-ios/scripts/` or existing resource validation scripts.
- Defensive UI fallback: `native-ios/App/Views/PhraseListingView.swift`.

### SAFE_FIX_NOW - Scrolled Category/Detail Content Collides With Top Chrome

Evidence:
- Food Menu scrolled state keeps a readable top admin section chip: `visual/food-menu-scrolled.jpg`.
- Airport scrolled state shows section/title content under the dynamic island/status area and static back/more controls: `visual/airport-scrolled.jpg`.
- Hotel scrolled state shows phrase rows pushed under the top controls: `visual/hotel-scrolled.jpg`.
- Eating Out scrolled state shows row content under the top status/control area: `visual/eating-out-scrolled.jpg`.
- Saigon city hub scrolled state leaves the horizontal filter rail under the status/control area: `visual/hcmc-city-scrolled.jpg`.
- Phở Hòa Pasteur place detail scrolled state shows phrase row content under the status/control area: `visual/pho-hoa-pasteur-place-scrolled.jpg`.

Why Food Menu feels better:
- Food/Drink Menu route through `VietnameseMenuPageView` when `VietnameseMenuCatalog.kind(for:)` matches: `native-ios/App/Views/AppShellView.swift:761`.
- Menu pages emit and use section chrome preferences: `native-ios/App/Views/VietnameseMenuPageView.swift:88` and `native-ios/App/Views/AppShellView.swift:652`.
- Food/Drink Menu declare explicit photo backdrops: `native-ios/App/Models/VietnameseMenuCatalog.swift:52`.
- Generic Browse collection pages use `BrowseCollectionPageView` and do not emit the same menu-section admin chip/rail: `native-ios/App/Views/BrowseCollectionPageView.swift:48`.

Recommended safe fixes:
- Add a generic top-readable scrolled-state policy for `BrowseCollectionPageView` and `PhraseArticleTemplateView`, or reuse/adapt the menu section chrome pattern for collection subcategories and detail sections.
- At minimum, increase/anchor top scroll clearance when photo-backed collection/detail content is scrolled so rows and section rails cannot sit behind the dynamic island, status bar, back button, speed chip, or more button.
- Add focused UI proof for scrolled top states on `airport`, `hotel`, `food`, one city hub, and one city/place detail page.

Likely files:
- `native-ios/App/Views/BrowseCollectionPageView.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Design/NativeGlass.swift`

### FOLLOW_UP - Generic Category Card Imagery Feels Repetitive

Evidence:
- Eating Out top shows multiple subcategory cards using the same food backdrop image in a row: `visual/eating-out-top.jpg`.
- Hotel top has some photo-backed cards, but `Room help` uses a more illustrated/flat-looking image compared with neighboring photo cards: `visual/hotel-top.jpg`.
- Airport, Hotel, Eating Out, and city hubs all have valid top hero imagery in the sampled routes, so this is not the same as the missing-hero blocker.

Likely cause:
- Generic subcategory cards use `BrowseCollectionSubcategory.imageName` with fallback to `descriptor.mastheadImageName`: `native-ios/App/Views/BrowseCollectionPageView.swift:702`.
- A curated subcategory image map exists for some cards: `native-ios/App/Models/BrowseSearchDestinations.swift:3099`, but category coverage/variety is uneven.

Recommended safe fixes:
- Fill/curate subcategory image mappings for high-traffic launch routes: Airport, Hotel, Eating Out, Getting Around, First Day.
- Prefer actual relevant photos over repeated route mastheads where possible.

## Screenshots / Logs

Screenshot folder:

```text
docs/task-results/launch-readiness-audit-2026-07-04/visual/
```

Key screenshots:

```text
food-menu-top.jpg
food-menu-scrolled.jpg
airport-top.jpg
airport-scrolled.jpg
hotel-top.jpg
hotel-scrolled.jpg
eating-out-top.jpg
eating-out-scrolled.jpg
hcmc-city-top.jpg
hcmc-city-scrolled.jpg
pho-hoa-pasteur-place-top.jpg
pho-hoa-pasteur-place-scrolled.jpg
missing-hero-pho-10-top.jpg
home-initial-banner-obstructed.jpg
```

Simulator/build evidence:

```text
Simulator: SpeakLocal Launch Visual
Simulator ID: 7F02E830-AD29-4158-A6B7-38B871096D93
Build/run: XcodeBuildMCP build_run_sim succeeded
Build log: /Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/logs/build_run_sim_2026-07-04T07-54-01-040Z_pid11482_4aaaa15f.log
Runtime log sample: /Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/logs/app.speaklocal.vietnam.native_2026-07-04T08-02-15-848Z_helperpid49715_ownerpid11482_9aec1ea5.log
```

Notes:
- XcodeBuildMCP accessibility snapshot failed once with `Failed to get accessibility hierarchy`; screenshots still captured cleanly and route launch arguments worked.
- The first Home screenshot was obstructed by an iOS system "Ready for Apple Intelligence" banner; it is saved only as context and not used as a defect against the app.

## Files Edited

Edited only this assigned report file:

```text
docs/task-results/launch-readiness-audit-2026-07-04/visual-surface-audit.md
```

Created screenshots only under:

```text
docs/task-results/launch-readiness-audit-2026-07-04/visual/
```

No app code, generated resources, paywall branch, or physical-phone build/install state was changed.
