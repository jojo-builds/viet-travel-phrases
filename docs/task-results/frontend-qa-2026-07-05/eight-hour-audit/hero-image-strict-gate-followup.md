# Hero Image Strict Gate Follow-Up

Date: 2026-07-06 Asia/Manila
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Branch: `main`
Checked commit: `701981bd4`

## Summary

The current app does not reproduce the older blank-masthead report for the 20 affected city/place pages. The active generated native resource uses shared city fallback heroes such as `HeroCityDanang`, `HeroCityHanoi`, `HeroCityHcmc`, and `HeroCityHoian`, so the pages render with bundled photo assets.

The remaining issue is a stricter production-media completion gap: 20 approved city/place pages have `targetHeroImageName` metadata for unique page-specific owned hero images, but those 20 imagesets do not exist and the current `city-hero-production-505` manifest has no rows for them. That means the unique-asset pipeline cannot complete these pages without first adding/generating/importing the missing asset rows.

## Why The Earlier Blank-Hero Claim Is Stale

- `native-ios/Resources/viet-authored-listing-pages.json` currently sets the 20 affected pages' `heroImageName` to the bundled city fallback hero.
- `native-ios/scripts/generate-authored-tier-one-pages.js` prefers `pageRecord.heroImageName` before `pageRecord.editorialImport?.heroImageName`, so these pages do not render the missing target name today.
- The full V2.2 render proof passed on current main with `520` pages, `1560` screenshots, and all `PASS`.

## Strict Gate Failure

Command:

```sh
node native-ios/scripts/validate-viet-hero-image-assets.js --require-unique-city-place-assets
```

Result:

- normal hero validation passes without the strict flag;
- strict unique city/place asset validation fails because these 20 target imagesets are missing and the pages still use shared city heroes by design.

Missing target imagesets:

```text
HeroCityDanangPlaceBanhCanhYen.imageset
HeroCityDanangPlaceBepHen.imageset
HeroCityDanangPlaceBunChaCa109.imageset
HeroCityDanangPlaceBunRieuCua39.imageset
HeroCityDanangPlaceMocQuanSeafood.imageset
HeroCityDanangPlaceMyQuangSuaHongVan.imageset
HeroCityHanoiPlaceBanhCuonBaHoanh.imageset
HeroCityHanoiPlaceBanhCuonBaXuan.imageset
HeroCityHanoiPlaceBunChaDacKim.imageset
HeroCityHanoiPlacePho10LyQuocSu.imageset
HeroCityHanoiPlacePhoGaNguyet.imageset
HeroCityHanoiPlaceTuyetBunCha34.imageset
HeroCityHcmcPlaceBoKhoGanh.imageset
HeroCityHcmcPlaceBunBoHue14b.imageset
HeroCityHcmcPlaceManMoi.imageset
HeroCityHcmcPlacePhoHuongBinh.imageset
HeroCityHcmcPlacePhoLeDistrict5.imageset
HeroCityHcmcPlacePhoMinh.imageset
HeroCityHoianPlaceCaoLauThanh.imageset
HeroCityHoianPlaceComGaBaBuoi.imageset
```

## Root Cause

The ordinary launch asset gate verifies the assets actually referenced by the current runtime hero names. The stricter completion gate also verifies future/target unique city-place heroes. These 20 target assets were recorded in source metadata, but not added to the `city-hero-production-505` generation manifest, so they never entered the generation/import queue.

## Recommendation

Do not solve this by swapping in cheap or fake visuals. Either:

1. Keep the current shared city fallback hero behavior for the first non-paywall launch and track this as a post-launch media-completion task; or
2. Add a deliberate owned-image production task for these 20 pages, with review before import, then rerun the strict gate and a visual proof pass.

Current release implication: this is not a known blank-screen runtime blocker on `main`; it is a unique-photo completion gap if Jojo wants every city/place page to have a page-specific owned hero before launch.
