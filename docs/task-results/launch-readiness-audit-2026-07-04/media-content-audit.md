# Media And Content Audit

Worker: B - Media / Content Completeness
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Branch / commit audited: `main` at `07a2db5d8`
Date: 2026-07-04

## Summary Verdict

Verdict: **FIX NOW before launch**.

The content database, listing-page QA, menu image pairs, phrase backdrop pool, and missing-audio posture are structurally healthy. I found **one concrete media launch risk**: **20 active authored city/place pages reference `HeroCity*Place*` imagesets that are not present in `native-ios/Resources/Assets.xcassets`**. These are not merely stale tracker rows; the current `PhraseArticleTemplateView` photo-backdrop path treats `HeroCity*` detail pages as eligible image-backed pages and passes the missing asset name to SwiftUI `Image(...)` / preheating. That can render a blank/empty hero/backdrop area for those pages.

Audio verdict: **accepted temporary risk / follow-up**, not a release blocker from current repo evidence. SQLite has **778 planned missing-audio rows**, all `release_blocking = 0`, mirrored by `docs/audio-queues/viet-planned-missing-audio.csv`; no exact reusable audio conflicts were reported by the SQLite validator.

## Counts

- Catalog: **1,782 families**, **1,800 phrases**, **19 scenarios**.
- SQLite/runtime: **1,793 canonical phrase pages**, **1,800 search documents**, **11,728 relations**, **520 city places**, **355 Vietnamese menu items**.
- Audio: **4,318 manifest entries**; phrase rows are **1,022 ready audio** and **778 planned audio**; release-blocking missing audio rows: **0**.
- Listing pages: **1,793 resource pages**; Tier 1 index: **150/150 strong**, 0 thin/awkward/placeholder/needs-work rows.
- Images/assets: **1,273 imagesets** total; **879 Hero***, **505 HeroCity***, **11 HeroCategory***, **355 HeroMenu***, **377 Backdrop***, **355 BackdropMenu***, **20 BackdropPhrase***.
- Explicit authored listing hero refs: **826 refs**, **521 unique refs**, **20 missing refs**.
- Phrase backdrops: **952 placements**, **12 semantic pools**, **20 semantic-pool assets**; validator passed.
- Menu images: **355/355 thumbnail assets** and **355/355 backdrop assets** present; 355 unique thumbnail hashes and 355 unique backdrop hashes; 0 issues in the read-only report-local audit.

## Launch-Blocking / Fix-Now Finding

### `SAFE_FIX_NOW`: 20 active authored city/place hero images are missing

Evidence:

- `node native-ios/scripts/validate-viet-hero-image-assets.js` failed with 20 missing `HeroCity*Place*` imagesets and 20 source/authored hero mismatches.
- `docs/task-results/launch-readiness-audit-2026-07-04/media/missing-hero-assets.csv` lists the affected pages.
- The same 20 names are present in the generated SQLite `phrase_page.hero_image_name`.
- `native-ios/App/Views/PhraseListingView.swift` uses the effective page hero name for photo-backdrop pages; `HeroCity*` page IDs satisfy `PhrasePhotoBackdropLayout.supportsCityListingPage(...)`.

Affected pages:

| Page | Missing asset |
| --- | --- |
| Bánh Canh Yến | `HeroCityDanangPlaceBanhCanhYen` |
| Bếp Hên | `HeroCityDanangPlaceBepHen` |
| Bún Chả Cá 109 | `HeroCityDanangPlaceBunChaCa109` |
| Bún Riêu Cua 39 | `HeroCityDanangPlaceBunRieuCua39` |
| MỘC Quán Seafood | `HeroCityDanangPlaceMocQuanSeafood` |
| Mỳ Quảng Sứa Hồng Vân | `HeroCityDanangPlaceMyQuangSuaHongVan` |
| Bánh Cuốn Bà Hoành | `HeroCityHanoiPlaceBanhCuonBaHoanh` |
| Bánh Cuốn Bà Xuân | `HeroCityHanoiPlaceBanhCuonBaXuan` |
| Bún Chả Đắc Kim | `HeroCityHanoiPlaceBunChaDacKim` |
| Phở 10 Lý Quốc Sư | `HeroCityHanoiPlacePho10LyQuocSu` |
| Phở Gà Nguyệt | `HeroCityHanoiPlacePhoGaNguyet` |
| Tuyết Bún Chả 34 | `HeroCityHanoiPlaceTuyetBunCha34` |
| Bò Kho Gánh | `HeroCityHcmcPlaceBoKhoGanh` |
| Bún Bò Huế 14B | `HeroCityHcmcPlaceBunBoHue14b` |
| Mặn Mòi | `HeroCityHcmcPlaceManMoi` |
| Phở Hương Bình | `HeroCityHcmcPlacePhoHuongBinh` |
| Phở Lệ | `HeroCityHcmcPlacePhoLeDistrict5` |
| Phở Minh | `HeroCityHcmcPlacePhoMinh` |
| Cao Lầu Thanh | `HeroCityHoianPlaceCaoLauThanh` |
| Cơm Gà Bà Buội | `HeroCityHoianPlaceComGaBaBuoi` |

Recommended safe fix:

1. Shortest launch-safe fix: regenerate the authored listing resource / SQLite so these 20 pages use the existing city fallback hero (`HeroCityDanang`, `HeroCityHanoi`, `HeroCityHcmc`, `HeroCityHoian`) until page-specific owned images exist.
2. Better visual fix: generate/import the 20 missing owned photo-style imagesets, then rerun `node native-ios/scripts/validate-viet-hero-image-assets.js`, `node native-ios/scripts/validate-viet-sqlite-fixture.js`, and simulator spot-check 3-5 affected pages.
3. Prevent recurrence: update the city handwritten import path so it does not promote `targetHeroImageName` into generated authored resources unless the corresponding asset exists, or make `validate-viet-hero-image-assets.js` part of launch validation.

## Audio Posture

No release-blocking audio blank was found by the current SQLite fixture validator.

- `missing_audio_audit`: **778 rows**, all `target_kind = phrase`, `severity = planned`, `release_blocking = 0`.
- Planned queue: **778 rows** in `docs/audio-queues/viet-planned-missing-audio.csv`.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed and specifically asserted:
  - release-blocking missing audio rows are zero;
  - missing audio audit rows are all planned;
  - planned missing-audio queue rows match the audit rows;
  - duplicated planned missing-audio normalized text rows are zero;
  - missing audio rows do not have exact reusable bundled audio assets/usages.

Interpretation: launch can proceed with the planned-audio posture only if UI surfaces continue to hide/mark unready playback honestly. This audit did not do rendered speaker-icon screenshots; Runtime/Visual workers should confirm no disabled or misleading speaker controls appear on affected planned-audio rows.

## Passed Checks

- `node native-ios/scripts/audit-viet-listing-production-qa.js --check`
  - `1793 pages; 0 blockers; 0 majors; 775 duplicate hero sections hidden at render-time; 500 missing-audio priority rows`.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `ok: true`; `1800` phrase rows; `1793` canonical pages; `0` release-blocking missing audio rows.
- `node native-ios/scripts/validate-viet-phrase-backdrops.js`
  - `ok: true`; `952` needs-backdrop rows and `952` placements; all semantic-pool assets present.
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - validated `355` handwritten Vietnamese menu item pages; `15` ready helper phrases.
- Report-local read-only menu image audit
  - `355` expected thumbnail assets present; `355` expected backdrop assets present; `0` issues.
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - `150` Tier 1 families strong; `0` failing rows; resource page count `1793`.
- `node native-ios/scripts/validate-viet-listing-intent-routing.js`
  - `ok: true`.
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js`
  - `520` entries; all `FINAL_PASS`; pass=520 revise=0 fail=0.
- `node native-ios/scripts/validate-viet-catalog-promoted-authoring.js`
  - `ok: true`; `27` task phrase rows; `770` authored pages; `770` rationale records.
- `node native-ios/scripts/validate-viet-breakdown-audit.js`
  - `PASS; 1407/1273 reviewed entries`.
- `node native-ios/scripts/validate-viet-editorial-model-support.js`
  - `status: pass`.
- `node native-ios/scripts/validate-viet-search-only-surfacing.js`
  - `ok: true`; `315` keep-search-only rows.
- `node scripts/guard-native-only.js`
  - passed.

## Artifacts

- `docs/task-results/launch-readiness-audit-2026-07-04/media/media-coverage-audit.mjs`
- `docs/task-results/launch-readiness-audit-2026-07-04/media/media-coverage-summary.json`
- `docs/task-results/launch-readiness-audit-2026-07-04/media/missing-hero-assets.csv`
- `docs/task-results/launch-readiness-audit-2026-07-04/media/missing-audio-sample.csv`

## Files Edited

I did **not** edit app code, generated native resources, paywall, or phone/signing files.

I edited only:

- `docs/task-results/launch-readiness-audit-2026-07-04/media-content-audit.md`
- report-local optional artifacts under `docs/task-results/launch-readiness-audit-2026-07-04/media/`
