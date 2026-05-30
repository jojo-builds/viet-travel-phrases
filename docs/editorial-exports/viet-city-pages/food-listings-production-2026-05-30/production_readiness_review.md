# Viet City Food Listings Production Readiness Review

Date: 2026-05-30  
Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`  
Base commit: `494e325f9 Merge saveworthy-food-voice`  
Scope: first-class V2.2 source objects in `content-draft/viet/city-library/app-detail-v2-2/`

## Decision

The food, restaurant, cafe, market, and drink listings are not broadly production-ready by taste yet.

They are structurally valid V2.2 pages, but a validator pass should be treated as schema proof, not editorial approval. The current direction is correct: these pages should make a pre-trip traveler understand why a place, dish, market, or restaurant is worth remembering and saving, then give enough phrase/audio utility to use it in Vietnam.

This pass moved a high-priority first set closer to that standard. It does not approve all 500 pages.

## Product Positioning Used

SpeakLocal is not trying to be Duolingo, Google Translate, or an AI language tutor.

For this surface, the product job is:

- help an excited traveler picture Vietnam before arrival;
- make specific foods and places feel worth saving;
- give practical phrase/audio cards for the real moment at the place;
- connect nearby or comparable pages through meaningful Mentioned Here and Related cards;
- keep runtime behavior offline.

The copy voice should feel like a well-traveled friend quietly pointing things out: short, concrete, adult, warm, and useful. It should not sound like a database row, generic travel SEO, or an app explaining itself.

## Swarm Findings

Three read-only reviewers agreed on the same risk:

- The catalog is V2.2-shaped, but many pages still feel batch-written.
- Food-specific pages are stronger than generic cafes, malls, comfort stops, and thin-source modern dining pages.
- Mentioned Here was underused; before this work only a tiny number of pages rendered natural food/place mentions.
- Related cards still often look mechanically selected, with subtitles like a generic same-city comparison rather than a real route, pairing, or decision.
- Michelin recognition helps only when it is bounded and truthful; it should not turn every page into award-copy.

The useful mental split is:

- `feature anchor`: strong enough to make a traveler want to save it.
- `support listing`: useful in-app, but not strong enough to feature in marketing or trip-building shelves.
- `revise / deemphasize`: keep out of high-visibility surfaces until a clearer food reason exists.

## Pages Touched In This Pass

Changed food/place entries: 38.

### Da Nang

- `city-danang-place-banh-xeo-ba-duong`
- `city-danang-place-be-man`
- `city-danang-place-bep-cuon`
- `city-danang-place-boulevard-gelato-coffee`
- `city-danang-place-bun-cha-ca-hon`
- `city-danang-place-co-chu-nho`
- `city-danang-place-con-market`
- `city-danang-place-madame-lan`
- `city-danang-place-mi-quang-1a`
- `city-danang-place-nen`

### Hanoi

- `city-hanoi-place-bia-hoi`
- `city-hanoi-place-cha-ca-thang-long`
- `city-hanoi-place-gia`
- `city-hanoi-place-hibana-by-koki`
- `city-hanoi-place-lamai-garden`
- `city-hanoi-place-mien-luon-chan-cam`
- `city-hanoi-place-pho-bo-lam`
- `city-hanoi-place-tam-vi`
- `city-hanoi-place-udam`

### Saigon

- `city-hcmc-place-akuna`
- `city-hcmc-place-banh-xeo-46a`
- `city-hcmc-place-bep-me-in`
- `city-hcmc-place-cheo-leo-cafe`
- `city-hcmc-place-ciel`
- `city-hcmc-place-coco-dining`
- `city-hcmc-place-long-trieu`
- `city-hcmc-place-nephele`
- `city-hcmc-place-workshop-coffee`

### Hoi An

- `city-hoian-place-bale-well`
- `city-hoian-place-cao-lau-city`
- `city-hoian-place-com-ga`
- `city-hoian-place-vys-market`
- `city-hoian-place-white-rose-restaurant`

### Hue

- `city-hue-place-banh-khoai`
- `city-hue-place-bun-bo-city`
- `city-hue-place-dong-ba`
- `city-hue-place-lien-hoa-vegetarian`
- `city-hue-place-tinh-gia-vien`

## What Changed

- Strengthened food desire on major dishes, markets, and restaurant pages.
- Added or tightened Mentioned Here candidates for natural dish/place references.
- Replaced some generic related-card pairings with route, comparison, or food-context pairings.
- Added bounded 2025 MICHELIN context where official source support was strong enough.
- Flagged weaker support listings so they are not mistaken for feature anchors.
- Kept category behavior distinct: a street-food dish page, wet-market page, fine-dining page, beer-corner page, vegetarian restaurant, and dessert/cafe page should not share one visible section formula.

## Michelin Handling

Visible MICHELIN copy is bounded to the 2025 guide and only used where it strengthens an already specific page.

Official source references checked:

- Michelin corporate 2025 release: `https://www.michelin.com/en/publications/products-and-services/the-2025-michelin-guide-hanoi`
- Michelin Guide 2025 article: `https://guide.michelin.com/us/en/article/michelin-guide-ceremony/michelin-guide-vietnam-2025`
- Michelin Guide full-star list: `https://guide.michelin.com/sg/en/article/michelin-guide-ceremony/full-list-michelin-stars-michelin-guide-vietnam-2025`
- Michelin Guide page for `Bếp Cuốn`: `https://guide.michelin.com/us/en/da-nang-region/da-nang_2984390/restaurant/bep-cuon`
- Michelin Guide page for `Cô Chủ Nhỏ`: `https://guide.michelin.com/ca/en/da-nang-region/da-nang_2984390/restaurant/co-chu-nho`
- Michelin Guide page for `The Temptation`: `https://guide.michelin.com/en/da-nang-region/da-nang_2984390/restaurant/the-temptation`

Bounded claims used:

- One MICHELIN Star in the 2025 guide: `Gia`, `Hibana by Koki`, `Tam Vi`, `Akuna`, `CieL`, `Coco Dining`, `Long Trieu`, plus existing `Anan Saigon` and `La Maison 1888`.
- MICHELIN Green Star in the 2025 guide: `Nen Danang`, `Lamai Garden`.
- MICHELIN Selected / Guide-listed source support noted where useful: `Bếp Cuốn`, `The Temptation`.
- Bib Gourmand source support noted where useful: `Uu Dam`, `Mien luon Chan Cam`, `Pho Bo Lam`, `Cô Chủ Nhỏ`.

Freshness note: these are 2025-guide claims. Re-check before release if a newer official Vietnam guide has been published.

Da Nang continuation note, 2026-05-30:

- `city-danang-place-bep-cuon` now exposes the 2025 MICHELIN Selected signal while keeping the save reason on pork, rice paper, herbs, and mam nem.
- `city-danang-place-co-chu-nho` moved out of support-risk because the visible page now has a specific Bib Gourmand duck-specialist hook.
- `city-danang-place-the-temptation` now says MICHELIN Guide-listed French Contemporary, without implying a star or Bib Gourmand.
- Runtime trip-building gap found and fixed for these three pages: the V2.2 source already had related-place candidates, but the current native runtime renders `Compare Nearby` cards only through the native `LocationRelatedPicksCatalog`. Added Bếp Cuốn -> Bánh xèo Bà Dưỡng, Cô Chủ Nhỏ -> Bếp Cuốn, and The Temptation -> Nén so the edited pages actually support saving/comparing nearby meal decisions.

## Current Risk Metrics

These counts are intentionally treated as warnings, not blockers:

- Total V2.2 city/place entries: 500.
- Changed food/place entries in this pass: 38.
- Pages with rendered Mentioned Here candidates after this pass: 28.
- Related cards still need a full editorial pass. A source scan found 457 pages with generic approved-inventory reasons and/or same-city "different pace" subtitles.

The source validator now reports 500 `FINAL_PASS` records, but `FINAL_PASS` cannot mean "taste-approved." It currently means the object can satisfy the V2.2 contract.

## Feature Anchors From This Pass

These pages are the strongest candidates for high-visibility trip-building surfaces after render proof:

- `city-danang-place-banh-xeo-ba-duong`
- `city-danang-place-bep-cuon`
- `city-danang-place-co-chu-nho`
- `city-danang-place-con-market`
- `city-danang-place-mi-quang-1a`
- `city-danang-place-nen`
- `city-hanoi-place-cha-ca-thang-long`
- `city-hanoi-place-gia`
- `city-hanoi-place-tam-vi`
- `city-hanoi-place-bia-hoi`
- `city-hcmc-place-akuna`
- `city-hcmc-place-ciel`
- `city-hcmc-place-coco-dining`
- `city-hoian-place-bale-well`
- `city-hoian-place-white-rose-restaurant`
- `city-hoian-place-vys-market`
- `city-hue-place-dong-ba`
- `city-hue-place-bun-bo-city`

## Support / Deemphasize Until Stronger Evidence

Keep these useful, but do not make them headline trip-building recommendations yet:

- `city-danang-place-boulevard-gelato-coffee`: support cool-down listing unless stronger flavor/venue evidence is added.
- `city-hcmc-place-nephele`: support/fine-dining context; needs clearer food hook if used as a feature anchor.
- `city-danang-place-bun-cha-ca-hon`: promising food page, but should receive a fuller dish-specific review before hero placement.

## Remaining Editorial Work

1. Run a dedicated Related Cards pass.
   Replace generic `different pace` subtitles with real trip logic: same crawl, alternate meal, nearby follow-up, contrast in price/formality, rainy-day swap, or do not render.

2. Run Mentioned Here by category.
   Markets, dish pages, cafes, restaurants, drinks, desserts, streets, neighborhoods, and cultural sites need different mention patterns. Do not use one template.

3. Re-score food listings into three visible product lanes.
   `feature anchor`, `support listing`, and `revise/deemphasize`.

4. Add or swap missing food anchors after source refresh.
   Candidate gaps from the swarm: stronger named Hoi An com ga/cao lau anchors, Hue casual food, Saigon oc/street lunch, Hanoi sticky rice or bun dau, and Da Nang seafood/mi Quang depth.

5. Render-review the changed pages.
   A page is not production-ready until screenshots prove intro, phrase cards, Mentioned Here, related cards, and chrome spacing in the app.

## Validation Run

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, integrity OK, 8784 relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- Native related-card targeted test: PASS, `AppChromeTests/testV22CityPagesExposeNativeRelatedPlaceCards`.
- native-only guard: PASS.
- whitespace check: PASS.

Issue caught during validation:

- `city-hcmc-place-coco-dining` contained visible banned wording `template`; revised to `What The Star Signals`.
- `city-hanoi-place-pho-bo-lam` lacked a restaurant-texture cue after projection; revised source copy to include `meal` / `table` texture.

## Final Status

Status for this batch: `REVISE_BEFORE_GLOBAL_PRODUCTION`

The first 38 food/place entries are materially better and should proceed to runtime projection and render proof. The full catalog still needs a systematic related-card, Mentioned Here, and save-worthiness pass before it can honestly be called production-ready.

## Continuation: Food Graph Pass

Second pass date: 2026-05-30
Commit before pass: `923cf63c8 Improve Viet food listing production pass`

This continuation focused on trip-building links, not new restaurant prose. The goal was to stop food pages from behaving like generic same-city inventory and make the graph answer clearer questions:

- Which dish page leads to a real named place?
- Which named place should point back to the dish guide?
- Which market leads to a useful nearby meal or route?
- Which snack/drink page should become a room, counter, or evening path?
- Which fine-dining page should stay in the planned-dinner lane instead of absorbing everyday food pages?

### Pages Touched

HCMC / Saigon:

- `city-hcmc-place-banh-mi-huynh-hoa`
- `city-hcmc-place-com-tam-ba-ghien`
- `city-hcmc-place-pho-hoa-pasteur`
- `city-hcmc-place-banh-mi`
- `city-hcmc-place-com-tam`
- `city-hcmc-place-pho-nam`
- `city-hcmc-place-hu-tieu`
- `city-hcmc-place-oc`
- `city-hcmc-place-bot-chien`
- `city-hcmc-place-pha-lau`
- `city-hcmc-place-bo-la-lot`
- `city-hcmc-place-ca-phe-sua-da`
- `city-hcmc-place-cafe-vot-pham-ngoc-thach`
- `city-hcmc-place-ben-thanh-market`
- `city-hcmc-place-binh-tay-market`
- `city-hcmc-place-ho-thi-ky-flower-market`
- `city-hcmc-place-long-trieu`

Hanoi:

- `city-hanoi-place-cha-ca`
- `city-hanoi-place-pho-bo`
- `city-hanoi-place-pho-gia-truyen`
- `city-hanoi-place-mien-luon`
- `city-hanoi-place-bun-cha-huong-lien`
- `city-hanoi-place-egg-coffee`
- `city-hanoi-place-dinh-cafe`
- `city-hanoi-place-dong-xuan`

Hue:

- `city-hue-place-dong-ba-bun-bo`
- `city-hue-place-banh-beo`
- `city-hue-place-banh-nam`
- `city-hue-place-che-hue`
- `city-hue-place-me-xung`

### Food Graph Metrics

Measured on food-surface categories only: `Restaurant`, `Cafe`, `Market`, `Dish`, `Dessert`, `Drink`, `Bar`.

Before this continuation:

- Food-surface pages: 195.
- Food pages with generic related-card language: 152.
- Food pages with rendered Mentioned Here candidates: 28.

After this continuation:

- Food-surface pages: 195.
- Food pages with generic related-card language: 123.
- Food pages with rendered Mentioned Here candidates: 36.

By city after this continuation:

- Da Nang: 28 generic food related cards, 9 food Mentioned Here pages.
- Hanoi: 22 generic food related cards, 11 food Mentioned Here pages.
- Saigon: 15 generic food related cards, 7 food Mentioned Here pages.
- Hoi An: 32 generic food related cards, 4 food Mentioned Here pages.
- Hue: 26 generic food related cards, 5 food Mentioned Here pages.

### Notable Direction Changes

- Removed the `Akuna` fine-dining default from everyday Saigon food pages such as Bánh mì Huỳnh Hoa, Cơm tấm Ba Ghiền, and Phở Hòa Pasteur.
- Connected Saigon dish pages to concrete named places: bánh mì to Bánh mì Huỳnh Hoa, cơm tấm to Cơm tấm Ba Ghiền, phở to Phở Hòa Pasteur.
- Connected Saigon snack pages to the evening street-food route instead of generic bánh mì comparisons.
- Connected Hanoi dish/drink pages to specific rooms: chả cá to Chả cá Thăng Long, phở bò to Phở Bò Lâm, egg coffee to Giảng Cafe.
- Connected Hue food pages by setting and texture: Đông Ba market bun bo to Đông Ba and broader bún bò Huế, soft rice snacks to bánh khoái contrast, chè to mè xửng as a portable sweet.

### Validation Run After Continuation

Commands:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
```

Results:

- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, integrity OK, 8784 relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.

### Remaining Risk

This pass materially improves the graph, especially Saigon, but the full food catalog still is not globally production-ready. The next highest-value regions are Da Nang and Hoi An, where food-surface generic related-card counts remain high.

## Continuation: Da Nang / Hoi An Food Graph Pass

Third pass date: 2026-05-30
Commit before pass: `aa0db27f9 Improve Viet food graph links`

This continuation focused on the two cities that still felt least save-worthy after the first graph pass. The goal was not to make every page loud; it was to make the food, cafe, market, drink, dessert, and tailor-adjacent cards explain a real trip-building move instead of pointing to a generic same-city comparison.

### Pages Touched

Da Nang:

- `city-danang-place-43-factory`
- `city-danang-place-bac-my-an-market`
- `city-danang-place-banh-mi`
- `city-danang-place-banh-trang-cuon-thit-heo`
- `city-danang-place-banh-xeo`
- `city-danang-place-bun-cha-ca`
- `city-danang-place-che-xoa-xoa-hat-luu`
- `city-danang-place-cong-caphe-bach-dang`
- `city-danang-place-fatfish`
- `city-danang-place-hai-san`
- `city-danang-place-helio-night-market`
- `city-danang-place-kem-bo`
- `city-danang-place-la-maison-1888`
- `city-danang-place-le-duan-night-market`
- `city-danang-place-long-coffee`
- `city-danang-place-lotte-mart`
- `city-danang-place-mi-quang`
- `city-danang-place-my-quang-ba-mua`
- `city-danang-place-my-quang-dung`
- `city-danang-place-nam-danh-seafood`
- `city-danang-place-nam-house`
- `city-danang-place-nem-lui`
- `city-danang-place-nen`
- `city-danang-place-oc-hut`
- `city-danang-place-reply-1988`
- `city-danang-place-six-on-six`
- `city-danang-place-son-tra-night-market`
- `city-danang-place-the-temptation`
- `city-danang-place-vincom-plaza`
- `city-danang-place-wonderlust`

Hoi An:

- `city-hoian-place-banh-dap-hen-xao`
- `city-hoian-place-banh-mi`
- `city-hoian-place-banh-mi-phuong`
- `city-hoian-place-banh-xeo`
- `city-hoian-place-bebe-tailor`
- `city-hoian-place-cargo-club`
- `city-hoian-place-che-bap-cam-nam`
- `city-hoian-place-cocobox`
- `city-hoian-place-espresso-station`
- `city-hoian-place-faifo-coffee`
- `city-hoian-place-hoi-an-market`
- `city-hoian-place-madam-khanh`
- `city-hoian-place-mai-fish`
- `city-hoian-place-mango-mango`
- `city-hoian-place-metiseko`
- `city-hoian-place-mi-quang`
- `city-hoian-place-mot-herbal-drink`
- `city-hoian-place-nguyen-hoang-night-market`
- `city-hoian-place-night-market`
- `city-hoian-place-nu-eatery`
- `city-hoian-place-phin-coffee`
- `city-hoian-place-reach-out-tea-house`
- `city-hoian-place-rosies-cafe`
- `city-hoian-place-silk-village`
- `city-hoian-place-streets-restaurant`
- `city-hoian-place-tailor-fitting`
- `city-hoian-place-the-field`
- `city-hoian-place-u-cafe`
- `city-hoian-place-white-rose-dumplings`
- `city-hoian-place-wonton`
- `city-hoian-place-yaly-couture`

### Food Graph Metrics After This Pass

Measured on food-surface categories only: `Restaurant`, `Cafe`, `Market`, `Dish`, `Dessert`, `Drink`, `Bar`.

Current strict scan after this continuation:

- Food-surface pages: 195.
- Food pages with generic `same-city` / `different pace` related-card language: 82.
- Food pages with rendered Mentioned Here candidates: 41.

By city after this continuation:

- Da Nang: 0 generic food related cards, 12 food Mentioned Here pages.
- Hoi An: 0 generic food related cards, 6 food Mentioned Here pages.
- Hanoi: 31 generic food related cards, 11 food Mentioned Here pages.
- Saigon: 23 generic food related cards, 7 food Mentioned Here pages.
- Hue: 28 generic food related cards, 5 food Mentioned Here pages.

The current strict scan supersedes the rough by-city debt counts above for next-work prioritization. It intentionally checks only food-surface related-card copy in `relationship`, `displaySubtitle`, and `reason`, not QA notes or non-food place pages.

### Notable Direction Changes

- Da Nang food pages now route through specific food decisions: mì Quảng places, seafood tables, avocado ice cream, night markets, coffee-register contrasts, and planned dinners.
- Hội An food and shopping-adjacent pages now connect dish-to-place, cafe-to-cafe, market-to-dish, tailor-to-fitting, and evening-drink paths instead of broad same-city cards.
- Remaining `anchor` wording was removed from the edited Da Nang/Hoi An source files.
- Da Nang and Hoi An now pass the food-surface generic-card scan at 0; this does not mean every non-food place page is editorially finished.

### Validation Run After Da Nang / Hoi An Continuation

Commands:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, integrity OK, 8784 relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk

Status remains `REVISE_BEFORE_GLOBAL_PRODUCTION`.

Da Nang and Hoi An food-surface graph debt is in much better shape, but Hanoi, Saigon, and Hue still need the same related-card specificity pass, and none of these changes have been render-reviewed in the app yet. The next real production gate is screenshot proof for representative food/place pages: intro, phrase cards, Mentioned Here, related cards, and chrome spacing.

## Continuation: Hanoi / Saigon / Hue Food Graph Completion

Fourth pass date: 2026-05-30
Commit before pass: `ca3caba5e Improve Da Nang Hoi An food graph links`

This continuation finished the strict food-surface related-card pass for the remaining three cities. The edit target was narrow: remove generic `same-city` / `different pace` related cards from food, cafe, market, drink, dessert, bar, and restaurant pages, then replace them with specific trip-building logic.

The point was not to force every subcategory into the same structure. Dish pages now tend to point to named places or useful food contrasts. Restaurants point to comparable meal decisions. Cafes point to room, ritual, or coffee-register differences. Markets point to route, errand, or snack context. Malls and support stops stay practical instead of pretending to be headline food anchors.

### Pages Touched

Hanoi:

- `city-hanoi-place-banh-cuon`
- `city-hanoi-place-bia-hoi`
- `city-hanoi-place-bun-cha`
- `city-hanoi-place-bun-cha-ta`
- `city-hanoi-place-bun-thang`
- `city-hanoi-place-ca-phe-sua-da`
- `city-hanoi-place-cha-ca-thang-long`
- `city-hanoi-place-cho-buoi-market`
- `city-hanoi-place-cong-ca-phe-trieu-viet-vuong`
- `city-hanoi-place-gia`
- `city-hanoi-place-giang-cafe`
- `city-hanoi-place-hang-da-market`
- `city-hanoi-place-hibana-by-koki`
- `city-hanoi-place-hom-market`
- `city-hanoi-place-lam-cafe`
- `city-hanoi-place-lamai-garden`
- `city-hanoi-place-loading-t-cafe`
- `city-hanoi-place-long-bien-market`
- `city-hanoi-place-nang-cafe`
- `city-hanoi-place-nem-cua-be`
- `city-hanoi-place-night-market-walk`
- `city-hanoi-place-pho-bat-dan`
- `city-hanoi-place-pho-bo-lam`
- `city-hanoi-place-pho-ga`
- `city-hanoi-place-quang-ba-flower-market`
- `city-hanoi-place-tam-vi`
- `city-hanoi-place-the-note-coffee`
- `city-hanoi-place-trang-tien-plaza`
- `city-hanoi-place-udam`
- `city-hanoi-place-weekend-night-market`
- `city-hanoi-place-xoi-xeo`

Saigon:

- `city-hcmc-place-42-nguyen-hue-apartment`
- `city-hcmc-place-akuna`
- `city-hcmc-place-an-dong-market`
- `city-hcmc-place-anan-saigon`
- `city-hcmc-place-banh-xeo`
- `city-hcmc-place-bun-thit-nuong`
- `city-hcmc-place-cafe-apartment-nguyen-hue`
- `city-hcmc-place-che`
- `city-hcmc-place-ciel`
- `city-hcmc-place-coco-dining`
- `city-hcmc-place-com-tam-ba-ghien`
- `city-hcmc-place-cong-ca-phe-dong-khoi`
- `city-hcmc-place-cuc-gach-quan`
- `city-hcmc-place-goi-cuon`
- `city-hcmc-place-hu-tieu`
- `city-hcmc-place-little-hanoi-egg-coffee`
- `city-hcmc-place-lusine-thao-dien`
- `city-hcmc-place-nephele`
- `city-hcmc-place-pho-hoa-pasteur`
- `city-hcmc-place-russian-market`
- `city-hcmc-place-saigon-square`
- `city-hcmc-place-takashimaya-saigon-centre`
- `city-hcmc-place-vincom-dong-khoi`

Hue:

- `city-hue-place-an-cuu-market`
- `city-hue-place-ancient-hue-gallery-cuisine`
- `city-hue-place-ancient-hue-restaurant`
- `city-hue-place-ancient-space-restaurant`
- `city-hue-place-ba-van-banh-loc`
- `city-hue-place-banh-bot-loc`
- `city-hue-place-banh-nam`
- `city-hue-place-ben-ngu-market`
- `city-hue-place-ben-trang-cafe-bistro`
- `city-hue-place-bun-hen`
- `city-hue-place-bun-thit-nuong`
- `city-hue-place-com-am-phu`
- `city-hue-place-com-hen`
- `city-hue-place-dai-nam-restaurant`
- `city-hue-place-de-po-cafe`
- `city-hue-place-khong-gian-hoai-co-coffee`
- `city-hue-place-kodo-cafe`
- `city-hue-place-lang-thang-coffee`
- `city-hue-place-les-jardins`
- `city-hue-place-lien-hoa-vegetarian`
- `city-hue-place-mandarin-coffee-restaurant`
- `city-hue-place-night-market`
- `city-hue-place-phu-hau-market`
- `city-hue-place-song-huong-floating-restaurant`
- `city-hue-place-tay-loc-market`
- `city-hue-place-thanh-cafe`
- `city-hue-place-truong-tien-plaza`
- `city-hue-place-y-thao-garden`

### Food Graph Metrics After This Pass

Measured on food-surface categories only: `Restaurant`, `Cafe`, `Market`, `Dish`, `Dessert`, `Drink`, `Bar`.

Current strict scan after this continuation:

- Food-surface pages: 195.
- Food pages with generic `same-city` / `different pace` related-card language: 0.
- Food pages with rendered Mentioned Here candidates: 41.

By city after this continuation:

- Da Nang: 0 generic food related cards, 12 food Mentioned Here pages.
- Hanoi: 0 generic food related cards, 11 food Mentioned Here pages.
- Saigon: 0 generic food related cards, 7 food Mentioned Here pages.
- Hoi An: 0 generic food related cards, 6 food Mentioned Here pages.
- Hue: 0 generic food related cards, 5 food Mentioned Here pages.

This is a graph-copy metric only. It does not claim every restaurant page has enough food-specific desire, enough review-backed dish detail, or rendered screenshot proof.

### Notable Direction Changes

- Hanoi dish pages now route through breakfast texture, named bun cha / pho counters, Old Quarter night flow, old cafe rooms, and 2025 MICHELIN-bounded dinner comparisons.
- Saigon dish and restaurant pages now separate everyday food from planned dinners: Bánh xèo points to Bánh xèo 46A, dessert points into Hồ Thị Kỷ evening-snack context, L'Usine points to a coffee-craft contrast, and One MICHELIN Star pages compare against other planned-dinner saves.
- Hue food pages now use stronger local logic: clam rice connects to Cồn Hến, bánh bột lọc connects to Bánh lọc Bà Vân, floating dinner connects to Perfume River boat context, and markets route through Đông Ba when first-time food orientation matters.
- Leftover internal `anchor` wording was removed from the edited Hanoi / Saigon / Hue source files.
- No new MICHELIN claims were added beyond the existing 2025-bounded wording. Re-check official MICHELIN sources before release if a newer Vietnam guide has been published.

### Validation Run After Hanoi / Saigon / Hue Continuation

Commands:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, integrity OK, 8784 relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk

Status remains `REVISE_BEFORE_GLOBAL_PRODUCTION`.

The food-surface related-card graph is now much stronger across all five cities, but the full production-ready promise still requires rendered app proof and a focused page-level food-desire review. The highest remaining editorial risk is not generic related cards anymore; it is whether each restaurant, cafe, market, and dish page itself makes a foodie want to save it before the trip.

## Continuation: Food-Desire Support/Demotion Pass

Third pass date: 2026-05-30
Commit before pass: `2aedd7e88 Complete Viet food graph specificity pass`

This continuation answered the remaining taste question directly: some pages should become more specific, and some should stop pretending to be headline food saves. The work did not force one template across restaurants, cafes, drinks, markets, and support stops. It gave each weak page a clearer role:

- lead food recommendations should make the food itself worth saving;
- support listings should explain the exact trip job they serve;
- thin restaurant/cafe pages should be demoted in score/review notes until better source evidence exists.

### Pages Touched

Changed weak food/place entries: 9.

- `city-danang-place-boulevard-gelato-coffee`: demoted to 27/30 support cool-down listing; visible copy now frames gelato/coffee as a short heat reset between stronger Da Nang food plans.
- `city-danang-place-reply-1988`: demoted to 28/30 support cafe; added retro-room, egg/salt coffee, tiramisu, cheesecake, and Hai Chau context.
- `city-hcmc-place-nephele`: demoted to 27/30 support modern-dinner listing; visible copy now says 2025 MICHELIN Guide-listed and sommelier/wine-led without making a star claim.
- `city-hoian-place-cargo-club`: adjusted to 29/30 restaurant-and-patisserie support listing; added river terrace, cakes, broad menu, and Ms Vy restaurant-world context.
- `city-hoian-place-faifo-coffee`: demoted to 28/30 view-led cafe support listing; clarified rooftop first, coffee second, with coconut/egg/milk coffee options.
- `city-hue-place-ancient-space-restaurant`: demoted to 27/30 heritage-dinner support listing; added ruong-house, com nieu, Hue dishes, and court-cuisine positioning.
- `city-hue-place-dai-nam-restaurant`: demoted to 27/30 Citadel-side Hue-cakes support listing; added traditional Hue cakes and route role.
- `city-hue-place-les-jardins`: adjusted to 28/30 polished French-Vietnamese Citadel meal; added banana-flower salad / lemongrass-and-chili cue and kept it below Hue street-food-first pages.
- `city-hue-place-song-huong-floating-restaurant`: adjusted to 28/30 setting-led river dinner; added Perfume River, Truong Tien Bridge, seafood, and Hue-style dishes.

### Source Refresh Notes

The new visible claims were kept bounded and source-backed. Sources checked included:

- MICHELIN Guide 2025 Vietnam release for Nephele as newly selected and Paul Vo's Sommelier Award.
- Taste Vietnam / Hoi An Creative City for Cargo Club as part of Ms Vy's restaurant group.
- Hoi An cafe guides for Faifo Coffee's 130 Tran Phu rooftop/coffee context.
- Restaurant and Hue tourism pages for Les Jardins, Ancient Space, Dai Nam, and Song Huong Floating Restaurant.
- Da Nang cafe listings for Reply 1988's address, retro/K-drama room, egg/salt coffee, tiramisu, and cheesecake context.

No new unbounded hours, prices, closure, reservation, or current operations claims were added.

### Phrase-Page Finding

`Cái này bao nhiêu?` is not thin in source. The canonical phrase page at `content-draft/viet/canonical-pages/tier-one/money-numbers-prices/money-how-much.json` already has a deep page: at-glance, breakdown, standard phrase, variation, why-it-matters, traveler insight, when-to-use, good-to-know, local tip, you-may-hear, and explore-next.

If the app only shows a small amount of content for that phrase, the likely issue is render/surface behavior rather than source depth. This pass did not patch that phrase page because the source itself is already richer than the selected phrase text suggested.

### Validation Run After Food-Desire Pass

Commands:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, integrity OK, 8784 relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Food-Desire Pass

Status remains `REVISE_BEFORE_GLOBAL_PRODUCTION`.

This pass made the weakest reviewed restaurants/cafes more honest and save-worthy, but it still does not prove the full catalog is production-ready. Remaining gates:

- render-proof these changed pages in the native app;
- continue the same food-desire scoring across remaining cafes, malls, support markets, and room-led restaurants;
- make high-visibility surfaces consume the support/lead distinction instead of treating all `FINAL_PASS` pages equally;
- investigate why `Cái này bao nhiêu?` may appear thin in the app if Jojo's observed surface was the full detail page, not just a quick phrase card.

## Continuation: Native Render Proof and Internal-Language Fix

Fourth pass date: 2026-05-30

Fresh native screenshots exposed a real V2.2 gate miss: a few support/demotion notes were still written in reviewer language and could render to users. The visible leaks were fixed in first-class V2.2 source and regenerated into handwritten copy, city V1 projection, native listing resources, and the SQLite fixture.

### Visible Copy Fixes

- `city-hcmc-place-nephele`: replaced "source pack" copy with a traveler-facing dinner-choice note.
- `city-hue-place-ancient-space-restaurant`: replaced "later review / feature placement" copy with a heritage-dinner role note.
- `city-hue-place-dai-nam-restaurant`: replaced "current source" copy with a plain Hue-cakes stop reason.
- `city-hue-place-les-jardins`: replaced "Feature With Caution" with "Keep It Secondary" and a food-day routing note.

Targeted internal-language scan after regeneration returned no visible `body`, `heading`, `tip`, `summary`, or `context` matches for the blocked phrases: `source pack`, `later review`, `feature placement`, `current source`, `Feature With Caution`, or `Support Listing`.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-30/`

Representative pages captured, top and scrolled:

- `viet-family-money-how-much`
- `viet-family-city-danang-place-reply-1988`
- `viet-family-city-hcmc-place-nephele`
- `viet-family-city-hue-place-ancient-space-restaurant`
- `viet-family-city-hoian-place-cargo-club`
- `viet-family-city-hoian-place-faifo-coffee`
- `viet-family-city-hue-place-song-huong-floating-restaurant`

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hook: `--detail-page <pageID>`
- Build/run: PASS for `viet-family-city-hcmc-place-nephele` after the internal-language fix.

### Validation Run After Render-Proof Fix

Commands:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 8784 relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Render-Proof Fix

Status improves for the reviewed support pages, but the full 500-page catalog should still stay below `GLOBAL_PRODUCTION_READY` until the remaining cafe, market, mall, and room-led restaurant pages get the same rendered proof sweep. `Cái này bao nhiêu?` is confirmed rendered as a deep detail page; if it felt thin, the likely problem is that the user was seeing a compact phrase card or only the first viewport.

## Continuation: Dynamic V2.2 Candidate Card Rendering

Fifth pass date: 2026-05-30

This pass found a structural render gap: first-class V2.2 source had renderable `relatedPlaceCandidates` for all 500 city/place pages, but the native app only rendered 14 hardcoded `Compare Nearby` cases. That meant many source-approved save/trip-building links were invisible in the shipped detail pages.

### Runtime Fix

- Projected V2.2 `relatedPlaceCandidates` with `status: "render"` into SQLite `phrase_relation` rows as `compare-nearby`.
- Projected V2.2 `mentionedHereCandidates` with `status: "render"` into SQLite `phrase_relation` rows as `mentioned-here`.
- Updated native `LocationRelatedPicksCatalog` and `LocationMenuPicksCatalog` to merge existing hand-picked cards with SQLite-authored candidate cards.
- Added de-duplication by canonical detail page ID so old hand-picked cards and source-authored cards do not render twice.
- Kept user-facing card copy on `displaySubtitle`; internal `reason` remains non-visible.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-30-dynamic-candidate-cards/`

Representative page captured:

- `viet-family-city-danang-place-banh-xeo-ba-duong`: shows V2.2-authored `Mentioned Here` cards for `Bánh xèo ở Đà Nẵng` and `Nem lụi ở Đà Nẵng`, plus a `Compare Nearby` card for `Hải sản Bé Mặn`, with save buttons visible.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hook: `--detail-page viet-family-city-danang-place-banh-xeo-ba-duong`
- Build/run: PASS

### Validation Run After Dynamic Candidate Rendering

Commands:

```sh
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node scripts/guard-native-only.js
git diff --check
```

Focused native XCTest:

```sh
SpeakLocalNativeTests/AppChromeTests/testCalibratedCityMenuPicksResolveInlineAndStayCapped
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesExposeNativeMentionedHereCards
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesExposeNativeRelatedPlaceCards
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesRenderSQLiteRelatedCandidates
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesRenderSQLiteMentionedHereCandidates
```

Results:

- SQLite fixture generation: PASS, integrity OK.
- SQLite relation inventory now includes 503 `compare-nearby` rows and 55 `mentioned-here` rows.
- SQLite fixture validation: PASS, 9342 total relations, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- native-only guard: PASS.
- whitespace check: PASS.
- focused native XCTest: PASS, 5 tests.

### Remaining Risk After Dynamic Candidate Rendering

This removes the largest app/runtime mismatch behind the save-worthy-place concern: source-authored related and mentioned candidates now have a generic render path instead of relying on one-off Swift switch cases.

Status should still remain below `GLOBAL_PRODUCTION_READY` until the next sweep confirms actual rendered screenshots across the remaining high-visibility food pages and checks that weaker support restaurants/cafes are not promoted as feature anchors.

## Continuation: Hanoi MICHELIN Bib / Green Food-Desire Refinement

Sixth pass date: 2026-05-30

Commit before pass: `2ede5a09d Render V2.2 candidate cards from SQLite`

This continuation tightened four Hanoi pages where the visible copy was still leaning on reviewer/source phrasing instead of giving the traveler a concrete food reason to save the place.

### Pages Touched

- `city-hanoi-place-lamai-garden`: kept the 2025 MICHELIN Green Star claim, but moved the save reason toward garden calm, farm-minded ingredients, herbs, and ordering judgment.
- `city-hanoi-place-mien-luon-chan-cam`: replaced "source support" phrasing with a 2025 MICHELIN Bib Gourmand eel/glass-noodle lunch hook.
- `city-hanoi-place-pho-bo-lam`: replaced "source support" phrasing with a 2025 MICHELIN Bib Gourmand beef-pho, tendon, broth, and counter-pace hook.
- `city-hanoi-place-udam`: replaced "source support" phrasing with a 2025 MICHELIN Bib Gourmand vegetarian-table hook built around herbs, mushrooms, tofu, rice, and sauces.

### Source Handling

Official 2025 MICHELIN references checked for bounded recognition language:

- `https://guide.michelin.com/us/en/article/michelin-guide-ceremony/michelin-guide-vietnam-2025`
- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

No new hours, prices, closure, reservation, or operational claims were added.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-30-hanoi-michelin-bib-green/`

Representative page captured:

- `viet-family-city-hanoi-place-pho-bo-lam`: first viewport shows the revised "A Bib Gourmand Pho Stop" intro, beef-cut/tendon copy, early sections, and native chrome without visible overlap.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hook: `--detail-page viet-family-city-hanoi-place-pho-bo-lam`
- Build/run: PASS

### Validation Run After Hanoi MICHELIN Refinement

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Focused native XCTest:

```sh
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesExposeNativeMentionedHereCards
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesExposeNativeRelatedPlaceCards
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesRenderSQLiteRelatedCandidates
SpeakLocalNativeTests/AppChromeTests/testV22CityPagesRenderSQLiteMentionedHereCandidates
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9342 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.
- focused native XCTest: PASS, 4 tests.

### Remaining Risk After Hanoi MICHELIN Refinement

Status remains below `GLOBAL_PRODUCTION_READY`.

These four pages are cleaner and more save-worthy than before, and the source-to-native path is proven for one representative page. The full catalog still needs the remaining high-visibility food pages, support restaurants, cafes, drink pages, markets, and category-specific related-card choices checked in rendered app context before the 500-page set can be called production-ready.

## Continuation: Saigon Bib / Everyday Counter Food-Desire Refinement

Seventh pass date: 2026-05-30

Commit before pass: `2f4b819c9 Refine Hanoi Michelin food listing copy`

This continuation focused on four Saigon food pages where the graph links were better than the visible food desire. The goal was to make each page answer Jojo's question directly: why this place, why save it, and why choose it over the many other places Vietnam offers?

### Pages Touched

- `city-hcmc-place-banh-mi-huynh-hoa`: sharpened the page around a named Saigon banh mi counter, stacked fillings, chili choices, takeaway pace, and queue confidence. No current MICHELIN claim was added.
- `city-hcmc-place-com-tam-ba-ghien`: added bounded 2025 MICHELIN Bib Gourmand language and made the save reason the pork chop, broken rice, egg, pickles, fish sauce, and fast shop pace.
- `city-hcmc-place-cuc-gach-quan`: added bounded 2025 MICHELIN Bib Gourmand language and made the page about an old-house, family-style Saigon dinner instead of a generic nice restaurant.
- `city-hcmc-place-pho-hoa-pasteur`: sharpened the southern pho shop experience: broth, beef, herbs, bean sprouts, lime, sauces, busy room, and Pasteur Street context. No current MICHELIN claim was added.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claims added only where this source supported them:

- `Com Tam Ba Ghien`: 2025 MICHELIN Bib Gourmand.
- `Cuc Gach Quan`: 2025 MICHELIN Bib Gourmand.

No new hours, prices, reservation, closure, address, or operational claims were added.

### Bottom Chrome Finding And Fix

Fresh render proof found a real screenshot-gate problem: automated bottom validation stopped at the readable sentinel before the bottom clearance, so the scrolled screenshot could still show a related card under the tab bar.

Root cause:

- `AppBottomSentinel` marked the last readable content.
- Phrase pages then added bottom clearance after that sentinel with padding.
- `AppBottomInsetValidation.scrollToBottom` scrolled to the sentinel, not to the post-clearance position.

Runtime fix:

- Added `AppBottomClearanceScrollTarget`, a hidden post-clearance scroll target.
- Phrase article pages now keep the readable sentinel above the chrome and place the validation target after the clearance.
- The validation helper first scrolls to the sentinel, then to the post-clearance target when present.
- This keeps existing bottom-inset UI tests meaningful while making screenshot proof land at the actual safe bottom position.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-30-hcmc-bib-everyday/`

Representative page captured:

- `viet-family-city-hcmc-place-com-tam-ba-ghien`
  - `com-tam-ba-ghien-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand pork-chop framing.
  - `com-tam-ba-ghien-bottom-clearance.jpg`: post-fix bottom validation shows Compare Nearby and Useful Phrases above the tab bar with reading space below.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hook: `--detail-page viet-family-city-hcmc-place-com-tam-ba-ghien`
- Bottom-clearance launch hook: `--detail-page viet-family-city-hcmc-place-com-tam-ba-ghien --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for both launches

### Validation Run After Saigon Refinement

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Focused native XCTest:

```sh
SpeakLocalNativeTests/AppChromeTests/testBottomInsetValidationUsesPostClearanceScrollTarget
SpeakLocalNativeTests/AppChromeTests/testCityPlacePhotoBackdropDetailPagesHaveExtraBottomScrollClearance
SpeakLocalNativeUITests/BottomInsetUITests/testRepresentativeCollectionAndDetailRoutesKeepBottomContentAboveSystemTabBar
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9342 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.
- focused native XCTest: PASS, 2 unit tests and 1 representative UI test.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation because the Codex desktop thread-limit / agent-close path froze twice before. This pass stayed single-process and used local repo evidence, official source checks, simulator proof, and focused tests.

### Remaining Risk After Saigon Refinement

Status remains below `GLOBAL_PRODUCTION_READY`.

The four Saigon pages above are materially more save-worthy, and the bottom-chrome screenshot proof gap has a runtime fix plus test coverage. The global catalog still needs the remaining high-visibility food pages and support listings checked in rendered context before the whole 500-page set can honestly be called production-ready.

## Continuation: Saigon Bib Gourmand Recognition Patch

Eighth pass date: 2026-05-30

Commit before pass: `405f834c6 Refine Saigon food listings and bottom proof`

This continuation corrected two current in-app Saigon pages that already had official 2025 MICHELIN Bib Gourmand recognition but were not saying so in visible copy. The fix keeps the restaurant-specific food reason first, with MICHELIN used as a bounded save signal.

### Pages Touched

- `city-hcmc-place-banh-xeo-46a`: added bounded 2025 MICHELIN Bib Gourmand language and sharpened the page around the large pancake, herbs, metal trays, sauce, and wrapping ritual.
- `city-hcmc-place-bep-me-in`: added bounded 2025 MICHELIN Bib Gourmand language and sharpened the page around shared Vietnamese comfort dishes, clay-pot cues, herbs, and a calmer central room.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claims added only where this source supported them:

- `Banh Xeo 46A`: 2025 MICHELIN Bib Gourmand.
- `Bep Me In`: 2025 MICHELIN Bib Gourmand.

No new hours, prices, reservation, closure, address, or operational claims were added.

### Add / Replace Candidate Backlog

These are not current-source edits yet. They are official 2025 MICHELIN-recognized add candidates to consider when the catalog needs stronger restaurant representation than weak support listings:

- Saigon MICHELIN Selected candidates not currently represented in the V2.2 source: `Bà Cô Lốc Cốc`, `Hoi An Sense`, `Okra FoodBar`, `ST25 by KOTO`, `The Albion by Kirk Westaway`.
- Saigon Bib Gourmand candidates not currently represented in the V2.2 source from the visible official list section: `Bò Kho Gánh`, `Bún Bò Huế 14B`, `Chay Garden`, `Hồng Phát`, `Hum Garden`, `Nhà Tú`, `Phở Chào`, `Phở Hoàng`.
- Da Nang new Bib Gourmand candidates not currently represented in the V2.2 source: `Bánh Xèo 76`, `Bún Bò Huế Bà Thương`, `Quê Xưa`, `Shamballa`.
- Da Nang new MICHELIN Selected candidates not currently represented in the V2.2 source: `Bún Riêu Cua 39`, `Moc`.

Do not drop existing support listings from the app by default. Keep them available for utility and route planning, but do not promote them as headline foodie saves. If a high-visibility shelf or marketing surface needs a tighter restaurant set, the first replacement candidates should come from the official list above before using support-first pages such as `Boulevard Gelato & Coffee`, `Reply 1988`, `Faifo Coffee`, or setting-led Hue dinner pages.

Mặn Mòi moved out of this backlog in the thirteenth pass and now exists as `city-hcmc-place-man-moi`.

### Validation Status

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-30-hcmc-bib-gourmand-recognition/`

Representative pages captured:

- `viet-family-city-hcmc-place-banh-xeo-46a`
  - `banh-xeo-46a-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand pancake-table framing.
- `viet-family-city-hcmc-place-bep-me-in`
  - `bep-me-in-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand comfort-table framing.
  - `bep-me-in-bottom-clearance.jpg`: bottom-validation launch shows Mentioned Here, Compare Nearby, and Useful Phrases above the tab bar with reading space below.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-banh-xeo-46a`
  - `--detail-page viet-family-city-hcmc-place-bep-me-in`
  - `--detail-page viet-family-city-hcmc-place-bep-me-in --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for all three launches.

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9342 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Saigon Bib Gourmand Recognition Patch

Status remains below `GLOBAL_PRODUCTION_READY`.

The current in-app Saigon Bib Gourmand misses above are fixed and rendered. The bigger catalog question remains open: several official 2025 MICHELIN add candidates are not in the 500-source set yet, and weak support listings should stay out of high-visibility foodie surfaces until those add/replace decisions are made.

## Continuation: Da Nang MICHELIN Selected Recognition Patch

Ninth pass date: 2026-05-31

Commit before pass: `578c8d37b Patch Saigon Bib Gourmand food copy`

This continuation corrected five existing Da Nang pages that official 2025 MICHELIN materials list as MICHELIN Selected, but whose visible copy did not yet use that recognition as a bounded save signal. The edit stayed inside existing V2.2 source records; no new place inventory was added in this pass.

### Pages Touched

- `city-danang-place-banh-xeo-ba-duong`: added bounded 2025 MICHELIN Selected language while keeping the save reason on hot banh xeo, herbs, rice paper, sauce, and the shared first roll.
- `city-danang-place-be-man`: added bounded 2025 MICHELIN Selected language while keeping the save reason on seafood display ordering, tray decisions, price questions, and a loud group table.
- `city-danang-place-madame-lan`: added bounded 2025 MICHELIN Selected language while keeping the save reason on courtyard light, shared Vietnamese dishes, a clearer menu, and group-dinner ease.
- `city-danang-place-mi-quang-1a`: added bounded 2025 MICHELIN Selected language while keeping the save reason on one focused regional noodle bowl.
- `city-danang-place-nam-danh-seafood`: added bounded 2025 MICHELIN Selected language while keeping the save reason on casual seafood rounds, shared plates, stools, and table energy.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claims added only where this source supported them:

- `Bánh Xèo Bà Dưỡng`: 2025 MICHELIN Selected.
- `Bé Mặn`: 2025 MICHELIN Selected.
- `Madame Lân`: 2025 MICHELIN Selected.
- `Mì Quảng 1A`: 2025 MICHELIN Selected.
- `Năm Đảnh`: 2025 MICHELIN Selected.

No new hours, prices, reservation, closure, address, or operational claims were added.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-danang-michelin-selected/`

Representative pages captured:

- `viet-family-city-danang-place-mi-quang-1a`
  - `mi-quang-1a-top.jpg`: first viewport shows the revised 2025 MICHELIN Selected noodle-stop framing.
- `viet-family-city-danang-place-be-man`
  - `be-man-top.jpg`: first viewport shows the revised 2025 MICHELIN Selected seafood-display framing.
- `viet-family-city-danang-place-nam-danh-seafood`
  - `nam-danh-bottom-clearance.jpg`: bottom-validation launch shows Mentioned Here, Compare Nearby, and Useful Phrases above the tab bar with reading space below.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-mi-quang-1a`
  - `--detail-page viet-family-city-danang-place-be-man`
  - `--detail-page viet-family-city-danang-place-nam-danh-seafood --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for all three launches.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing three flagged phrases introduced by the patch.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9342 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Da Nang MICHELIN Selected Patch

Status remains below `GLOBAL_PRODUCTION_READY`.

These five current in-app Da Nang recognition misses are fixed and rendered. The broader catalog still needs add/replace decisions for official 2025 MICHELIN-recognized restaurants that are not in the current V2.2 source set, plus continued rendered review before weak support pages are promoted as foodie saves.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. The prior Codex desktop agent lifecycle step froze twice, so this pass stayed single-threaded and relied on repo evidence, official source checks, validators, and simulator proof.

## Continuation: Hanoi MICHELIN Recognition Patch

Tenth pass date: 2026-05-31

Commit before pass: `b7ac77bbc Patch Da Nang Michelin Selected food copy`

This continuation corrected four existing Hanoi pages that already had official 2025 MICHELIN support in source notes or nearby evidence, but whose visible copy did not yet give food-focused travelers the recognition signal. The work stayed inside existing V2.2 source records.

### Pages Touched

- `city-hanoi-place-bun-cha-huong-lien`: added bounded 2025 MICHELIN Selected language while keeping the save reason on grilled pork, warm broth, herbs, vermicelli, quick service, and a famous bún chả lunch room.
- `city-hanoi-place-bun-cha-ta`: added bounded 2025 MICHELIN Bib Gourmand language, made the Old Quarter bún chả reason first, and added a rendered `Mentioned Here` card to the dish-level bún chả guide.
- `city-hanoi-place-cha-ca-thang-long`: added bounded 2025 MICHELIN Bib Gourmand language while keeping the save reason on the hot-pan chả cá ritual: turmeric fish, dill, noodles, herbs, peanuts, and sauce.
- `city-hanoi-place-pho-gia-truyen`: added bounded 2025 MICHELIN Bib Gourmand language while keeping the save reason on broth steam, sliced beef, herbs, and Old Quarter counter pace.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claims added only where this source supported them:

- `Bún Chả Hương Liên (Hai Ba Trung)`: 2025 MICHELIN Selected.
- `Bun Cha Ta (Nguyen Huu Huan Street)`: 2025 MICHELIN Bib Gourmand.
- `Chả Cá Thăng Long (6B Duong Thanh Street)`: 2025 MICHELIN Bib Gourmand.
- `Phở Gia Truyền (Hoan Kiem)`: 2025 MICHELIN Bib Gourmand.

No new hours, prices, reservation, closure, address, queue, or operational claims were added.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-hanoi-michelin-recognition/`

Representative pages captured:

- `viet-family-city-hanoi-place-bun-cha-ta`
  - `bun-cha-ta-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand bún chả framing.
  - `bun-cha-ta-bottom-clearance.jpg`: bottom-validation launch shows Mentioned Here, Compare Nearby, and Useful Phrases above the tab bar with reading space below.
- `viet-family-city-hanoi-place-bun-cha-huong-lien`
  - `bun-cha-huong-lien-top.jpg`: first viewport shows the revised 2025 MICHELIN Selected bún chả lunch framing.
- `viet-family-city-hanoi-place-pho-gia-truyen`
  - `pho-gia-truyen-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand pho-counter framing.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-bun-cha-ta`
  - `--detail-page viet-family-city-hanoi-place-bun-cha-huong-lien`
  - `--detail-page viet-family-city-hanoi-place-pho-gia-truyen`
  - `--detail-page viet-family-city-hanoi-place-bun-cha-ta --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for all four launches.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9343 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Hanoi MICHELIN Recognition Patch

Status remains below `GLOBAL_PRODUCTION_READY`.

These four current in-app Hanoi recognition misses are fixed and rendered. The next production-ready work should continue the official-recognition coverage audit and then address add/replace decisions for official 2025 MICHELIN restaurants missing from the current V2.2 source set. Before release, re-check official MICHELIN sources because the 2025 claims are date-bounded.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. The desktop agent lifecycle path has frozen repeatedly, so this pass used a local evidence-review split instead: source coverage audit, voice gate, validation gate, and native render gate.

## Continuation: Da Nang Bib / Selected Recognition Patch

Eleventh pass date: 2026-05-31

Commit before pass: `beba3b9f8 Patch Hanoi Michelin recognition food copy`

This continuation corrected three existing Da Nang pages with official 2025 MICHELIN support. The visible copy now gives food-focused travelers the recognition signal without turning the pages into generic award blurbs.

### Pages Touched

- `city-danang-place-bun-cha-ca-hon`: added bounded 2025 MICHELIN Bib Gourmand language, corrected the Hờn spelling in visible copy, and kept the save reason on the fish-cake noodle bowl: broth, herbs, spice after tasting, and a short breakfast-table rhythm.
- `city-danang-place-co-chu-nho`: date-bounded the Bib Gourmand language to 2025 and kept the save reason on the duck-specialist meal: porridge, salad, sliced duck, herbs, and ginger fish sauce.
- `city-danang-place-the-temptation`: upgraded vague guide-listed language to bounded 2025 MICHELIN Selected language, kept the reason on a quieter French Contemporary dinner, and softened one command-like section line after screenshot review.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claims added only where this source supported them:

- `Bún Chả Cá Hờn`: 2025 MICHELIN Bib Gourmand.
- `Cô Chủ Nhỏ`: 2025 MICHELIN Bib Gourmand.
- `The Temptation`: 2025 MICHELIN Selected.

No new hours, prices, reservation, closure, address, queue, or operational claims were added.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-danang-bib-selected-recognition/`

Representative pages captured:

- `viet-family-city-danang-place-bun-cha-ca-hon`
  - `bun-cha-ca-hon-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand fish-cake noodle framing.
  - `bun-cha-ca-hon-bottom-clearance.jpg`: bottom-validation launch shows Mentioned Here, Compare Nearby, and Useful Phrases above the tab bar with reading space below.
- `viet-family-city-danang-place-co-chu-nho`
  - `co-chu-nho-top.jpg`: first viewport shows the revised 2025 MICHELIN Bib Gourmand duck-specialist framing.
- `viet-family-city-danang-place-the-temptation`
  - `the-temptation-top.jpg`: first viewport shows the revised 2025 MICHELIN Selected French Contemporary framing and the softened early section copy.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-bun-cha-ca-hon`
  - `--detail-page viet-family-city-danang-place-co-chu-nho`
  - `--detail-page viet-family-city-danang-place-the-temptation`
  - `--detail-page viet-family-city-danang-place-bun-cha-ca-hon --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped launches.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9343 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

Validation note: one parallel run of `validate-viet-sqlite-fixture.js` failed while `generate-viet-sqlite-fixture.test.js` was simultaneously touching the same generated database. The same validator passed immediately when rerun sequentially, so future proof runs should keep those two SQLite checks sequential.

### Remaining Risk After Da Nang Bib / Selected Recognition Patch

Status remains below `GLOBAL_PRODUCTION_READY`.

These three current in-app Da Nang recognition misses are fixed and rendered. The next production-ready work should continue the official-recognition coverage audit and then address add/replace decisions for official 2025 MICHELIN restaurants missing from the current V2.2 source set. Before release, re-check official MICHELIN sources because the 2025 claims are date-bounded and the 2026 guide cycle is approaching.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. The prior desktop agent lifecycle step froze twice, so this pass stayed local: official-source check, item-level copy review, validators, and simulator render proof.

## Continuation: Nephele Selected Coverage + MICHELIN Add-Candidate Audit

Twelfth pass date: 2026-05-31

Commit before pass: `8fe19efb7 Patch Da Nang Bib Selected recognition copy`

This continuation fixed the remaining in-catalog recognition mismatch found in the Saigon restaurant set and added an explicit add/replace audit for future MICHELIN-backed expansion.

### Pages Touched

- `city-hcmc-place-nephele`: changed vague `guide-listed` language to bounded 2025 MICHELIN Selected language, kept Nephele as a support save rather than a top foodie anchor, and rewrote the visible sections around a quieter wine-led Saigon dinner.

### Coverage Audit Added

Audit file:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/michelin_2025_coverage_audit.md`

The audit records:

- current in-catalog One MICHELIN Star and Green Star coverage;
- current non-MICHELIN pages that should stay but not always lead;
- highest-priority missing Bib Gourmand / MICHELIN Selected add candidates;
- add/drop posture: add places when they improve dish desire, route comparison, or a weak support page; do not import the MICHELIN list wholesale.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Nephele`: 2025 MICHELIN Selected.

No new hours, prices, reservation, closure, address, queue, or operational claims were added.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-nephele-selected-coverage/`

Representative page captured:

- `viet-family-city-hcmc-place-nephele`
  - `nephele-top.jpg`: first viewport shows the revised 2025 MICHELIN Selected wine-led dinner framing.
  - `nephele-bottom-clearance.jpg`: bottom-validation launch shows the related Coco Dining card and Useful Phrases above the tab bar with reading space below.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-nephele`
  - `--detail-page viet-family-city-hcmc-place-nephele --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped launches.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 500 entries imported.
- native resource generation: PASS, 1747 families, 1765 phrases, 1758 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 500 entries, 500 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- SQLite fixture validation: PASS, 9343 relations, 0 release-blocking missing audio rows.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Nephele Selected Coverage

Status remains below `GLOBAL_PRODUCTION_READY`.

The current in-catalog star, green-star, and known recognition mismatch coverage is stronger now, but the catalog still needs an add/replace pass for missing Bib Gourmand and MICHELIN Selected places that would improve food desire. The highest-priority next candidates are captured in `michelin_2025_coverage_audit.md`.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass kept the same local evidence-review split: official-source check, add-candidate audit, item-level copy review, validators, and simulator render proof.

## Continuation: Mặn Mòi Additive Saigon Pilot

Thirteenth pass date: 2026-05-31

Commit before pass: `1598cfdea Document save-worthy restaurant add path`

This continuation implements the first save-worthy MICHELIN-backed add candidate instead of only documenting the add path. The product choice for this pilot was additive expansion: Saigon now carries 101 noun/place rows and the full city-place runtime carries 501 rows total.

### Page Added

- `city-hcmc-place-man-moi`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Mặn Mòi as a steady Vietnamese shared-table dinner rather than a generic restaurant pin;
- uses bounded 2025 MICHELIN Bib Gourmand language supported by the official 2025 source;
- uses the 2025 Service Award signal only as support for the service-aware save reason;
- keeps fragile logistics out of bundled copy.

### Contract Widening

The previous 500-page assumption was changed narrowly rather than worked around:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 101 rows while the other cities remain at 100.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: expected handwritten-copy count now follows the approved noun source pages instead of a hardcoded 100-per-city value.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 501 noun/place pages, with HCMC at 101.

This keeps the additive catalog choice explicit in validation instead of hiding the new page as a loose extra row.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-man-moi-additive/`

Representative page captured:

- `viet-family-city-hcmc-place-man-moi`
  - `man-moi-first-screen.jpg`: first viewport shows the new Mặn Mòi page, pronunciation row, 2025 MICHELIN Bib Gourmand framing, and food-specific shared-table intro.
  - `man-moi-bottom-inset.jpg`: bottom-validation launch shows related Saigon restaurant cards and playable Useful Phrases above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-man-moi`
  - `--detail-page viet-family-city-hcmc-place-man-moi --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for both scoped launches.

### Validation Status

Commands:

```sh
node native-ios/scripts/import-city-noun-intake.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- city noun intake: PASS, Saigon 101 places, other cities 100 each.
- V2.2 projection and handwritten-copy import: PASS, 501 entries imported.
- native resource generation: PASS, 1748 families, 1766 phrases, 1759 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 501 entries, 501 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 501 city noun pages, 501 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 501 city places, 807 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Mặn Mòi Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven for one stronger Saigon restaurant page, but it does not mean every MICHELIN Selected or Bib Gourmand restaurant should be imported. Continue adding only when the page gives a distinct food desire, route comparison, or stronger save reason than a weak support page.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. The earlier desktop agent lifecycle step froze twice, so this pass used local gates only: source check, voice specificity review, runtime contract widening, validator chain, and simulator render proof.
