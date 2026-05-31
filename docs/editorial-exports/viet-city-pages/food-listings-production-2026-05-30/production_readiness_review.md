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
xcodebuild test -only-testing:SpeakLocalNativeTests/AppChromeTests/testV22CityPagesExposeProductionHeadingsAndPhraseCards
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
- focused native V2.2 heading/phrase-card test: PASS, 1 test.

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
- Saigon Bib Gourmand candidates not currently represented in the V2.2 source from the visible official list section: `Chay Garden`, `Hồng Phát`, `Hum Garden`, `Nhà Tú`, `Phở Chào`, `Phở Hoàng`.
- Da Nang new Bib Gourmand candidates not currently represented in the V2.2 source: `Bánh Xèo 76`, `Bún Bò Huế Bà Thương`, `Quê Xưa`, `Shamballa`.
- Da Nang new MICHELIN Selected candidates not currently represented in the V2.2 source: `Moc`.

Do not drop existing support listings from the app by default. Keep them available for utility and route planning, but do not promote them as headline foodie saves. If a high-visibility shelf or marketing surface needs a tighter restaurant set, the first replacement candidates should come from the official list above before using support-first pages such as `Boulevard Gelato & Coffee`, `Reply 1988`, `Faifo Coffee`, or setting-led Hue dinner pages.

Mặn Mòi moved out of this backlog in the thirteenth pass and now exists as `city-hcmc-place-man-moi`.
Bò Kho Gánh moved out of this backlog in the fourteenth pass and now exists as `city-hcmc-place-bo-kho-ganh`.
Bún Bò Huế 14B moved out of this backlog in the fifteenth pass and now exists as `city-hcmc-place-bun-bo-hue-14b`.
Phở Lệ moved out of the high-priority pho add list in the sixteenth pass and now exists as `city-hcmc-place-pho-le-district-5`.
Bánh Cuốn Bà Hoành moved out of the high-priority Hanoi breakfast add list in the seventeenth pass and now exists as `city-hanoi-place-banh-cuon-ba-hoanh`.
Bún Riêu Cua 39 moved out of the high-priority Da Nang noodle add list in the eighteenth pass and now exists as `city-danang-place-bun-rieu-cua-39`.
Phở Gà Nguyệt moved out of the high-priority Hanoi chicken-pho add list in the nineteenth pass and now exists as `city-hanoi-place-pho-ga-nguyet`.
Bánh Canh Yến moved out of the high-priority Da Nang thick-noodle add list in the twentieth pass and now exists as `city-danang-place-banh-canh-yen`.

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

## Continuation: Bò Kho Gánh Additive Saigon Pilot

Fourteenth pass date: 2026-05-31

Commit before pass: `3030cf326 Add Man Moi Saigon restaurant listing`

This continuation implements the next highest-priority MICHELIN-backed add candidate from the audit. The product choice remains additive expansion: Saigon now carries 102 noun/place rows and the full city-place runtime carries 502 rows total.

### Page Added

- `city-hcmc-place-bo-kho-ganh`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Bò Kho Gánh as a specific bò kho bowl save rather than a generic restaurant pin;
- uses bounded 2025 MICHELIN Bib Gourmand language supported by the official 2025 source;
- uses meal-shape cues: hot beef stew, bread or noodles, herbs, sauce, and a direct bowl-led stop;
- keeps hours, address, booking, closure, and fragile menu-detail claims out of bundled copy.

### Contract Widening

The additive contract now has a second proved row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 102 rows while the other cities remain at 100.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: expected handwritten-copy count follows the approved noun source pages instead of a hardcoded 100-per-city value.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 502 noun/place pages, with HCMC at 102.

This keeps the growing food catalog explicit in validation instead of hiding new restaurants as loose JSON extras.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Bò Kho Gánh`: 2025 MICHELIN Bib Gourmand, Ho Chi Minh City, Street Food.

The live MICHELIN restaurant page returned a CloudFront/WAF challenge in this environment, so the visible app copy avoids hours, exact address, booking, closure, and narrow menu-detail claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bo-kho-ganh-additive/`

Representative page captured:

- `viet-family-city-hcmc-place-bo-kho-ganh`
  - `bo-kho-ganh-first-screen.jpg`: first viewport shows the new Bò Kho Gánh page, pronunciation row, 2025 MICHELIN Bib Gourmand framing, and bowl-led bò kho intro.
  - `bo-kho-ganh-bottom-inset.jpg`: bottom-validation launch shows related Saigon food cards and playable Useful Phrases above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-bo-kho-ganh`
  - `--detail-page viet-family-city-hcmc-place-bo-kho-ganh --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 102 places, other cities 100 each.
- V2.2 projection and handwritten-copy import: PASS, 502 entries imported.
- native resource generation: PASS, 1749 families, 1767 phrases, 1760 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 502 entries, 502 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 502 city noun pages, 502 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 502 city places, 808 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bò Kho Gánh Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path was proven for two stronger Saigon food pages at this point. `Bún Bò Huế 14B` became the next scoped add candidate and moved into the fifteenth-pass continuation below.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only.

## Continuation: Bún Bò Huế 14B Additive Saigon Pilot

Fifteenth pass date: 2026-05-31

Commit before pass: `82a70d35a Add Bo Kho Ganh Saigon food listing`

This continuation implements the next dish-specific MICHELIN-backed add candidate from the audit. The product choice remains additive expansion: Saigon now carries 103 noun/place rows and the full city-place runtime carries 503 rows total.

### Page Added

- `city-hcmc-place-bun-bo-hue-14b`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Bún Bò Huế 14B as a specific Saigon save for a Hue-style spicy bowl rather than a generic restaurant pin;
- uses bounded 2025 MICHELIN Bib Gourmand language supported by the official 2025 source;
- uses bowl-shape cues: lemongrass broth, beef, tendon, herbs, chili, lime, and round noodles;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a third proved row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 103 rows while the other cities remain at 100.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: expected handwritten-copy count follows the approved noun source pages instead of a hardcoded 100-per-city value.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 503 noun/place pages, with HCMC at 103.

This keeps the growing food catalog explicit in validation instead of hiding new restaurants as loose JSON extras.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Bún Bò Huế 14B`: 2025 MICHELIN Bib Gourmand, Ho Chi Minh City, Street Food.

The live MICHELIN restaurant page was not used as the runtime source of truth, so the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-bo-hue-14b-additive/`

Representative page captured:

- `viet-family-city-hcmc-place-bun-bo-hue-14b`
  - `bun-bo-hue-14b-first-screen.jpg`: first viewport shows the new Bún Bò Huế 14B page, pronunciation row, 2025 MICHELIN Bib Gourmand framing, and Hue-style bowl intro.
  - `bun-bo-hue-14b-bottom-inset.jpg`: bottom-validation launch shows related food cards and playable Useful Phrases above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-bun-bo-hue-14b`
  - `--detail-page viet-family-city-hcmc-place-bun-bo-hue-14b --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 103 places, other cities 100 each.
- V2.2 projection and handwritten-copy import: PASS, 503 entries imported.
- native resource generation: PASS, 1750 families, 1768 phrases, 1761 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 503 entries, 503 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 503 city noun pages, 503 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 503 city places, 809 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bún Bò Huế 14B Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path was proven for three stronger Saigon food pages at this point. `Phở Lệ` became the next scoped add candidate and moved into the sixteenth-pass continuation below.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only.

## Continuation: Phở Lệ Additive Saigon Pilot

Sixteenth pass date: 2026-05-31

Commit before pass: `b7c34827b Add Bun Bo Hue 14B Saigon food listing`

This continuation implements the next MICHELIN-backed pho candidate from the audit. The product choice remains additive expansion: Saigon now carries 104 noun/place rows and the full city-place runtime carries 504 rows total.

### Page Added

- `city-hcmc-place-pho-le-district-5`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Phở Lệ as a District 5 southern-phở save rather than replacing Phở Hòa Pasteur;
- uses bounded 2025 MICHELIN Bib Gourmand language supported by the official 2025 source;
- uses food-specific cues: beef broth, rice noodles, herbs, bean sprouts, lime, and table sauces;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a fourth proved row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 104 rows while the other cities remain at 100.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: expected handwritten-copy count follows the approved noun source pages instead of a hardcoded 100-per-city value.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 504 noun/place pages, with HCMC at 104.

This keeps the growing food catalog explicit in validation instead of hiding new restaurants as loose JSON extras.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Phở Lệ (District 5)`: 2025 MICHELIN Bib Gourmand, Ho Chi Minh City, Noodles.

The live MICHELIN restaurant page was not used as the runtime source of truth, so the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-le-district-5-additive/`

Representative page captured:

- `viet-family-city-hcmc-place-pho-le-district-5`
  - `pho-le-district-5-first-screen.jpg`: first viewport shows the new Phở Lệ page, compact title, 2025 MICHELIN Bib Gourmand framing, and southern-phở intro.
  - `pho-le-district-5-bottom-inset.jpg`: bottom-validation launch shows related pho/noodle cards and playable Useful Phrases above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-pho-le-district-5`
  - `--detail-page viet-family-city-hcmc-place-pho-le-district-5 --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 104 places, other cities 100 each.
- V2.2 projection and handwritten-copy import: PASS, 504 entries imported.
- native resource generation: PASS, 1751 families, 1769 phrases, 1762 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 504 entries, 504 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 504 city noun pages, 504 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 504 city places, 810 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Phở Lệ Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven for four stronger Saigon food pages. The next MICHELIN-backed adds should move beyond Saigon unless a remaining pho page can clearly differ from Phở Lệ and Phở Hòa Pasteur. Stronger next candidates are a Hanoi breakfast/noodle page or a Da Nang dish-specific page with enough source detail to answer why this place, why this dish, and why save it.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only.

## Continuation: Bánh Cuốn Bà Hoành Additive Hanoi Pilot

Seventeenth pass date: 2026-05-31

Commit before pass: `5c9c834cb Add Pho Le Saigon food listing`

This continuation implements the first additive Hanoi food pilot after four Saigon additions. The product choice remains additive expansion: Saigon carries 104 noun/place rows, Hanoi now carries 101, and the full city-place runtime carries 505 rows total.

### Page Added

- `city-hanoi-place-banh-cuon-ba-hoanh`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Bánh Cuốn Bà Hoành as a named Hanoi breakfast/steam-table save;
- uses bounded 2025 MICHELIN Selected language supported by the official 2025 source;
- uses dish-specific cues: thin steamed rice sheets, savory filling, fried shallot, herbs, and dipping sauce;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a first Hanoi expansion row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 104 rows and Hanoi to carry 101 while Da Nang, Hội An, and Hue remain at 100.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: expected handwritten-copy count follows the approved noun source pages instead of a hardcoded 100-per-city value.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 505 noun/place pages, with HCMC at 104 and Hanoi at 101.

This keeps the growing food catalog explicit in validation instead of hiding new restaurants as loose JSON extras.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Bánh Cuốn Bà Hoành`: 2025 MICHELIN Selected, Hanoi, Street Food.

The live MICHELIN restaurant page was not used as the runtime source of truth, so the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-banh-cuon-ba-hoanh-additive/`

Representative page captured:

- `viet-family-city-hanoi-place-banh-cuon-ba-hoanh`
  - `banh-cuon-ba-hoanh-first-screen.jpg`: first viewport shows the new Bánh Cuốn Bà Hoành page, compact wrapped title, 2025 MICHELIN Selected framing, and steamed-rice-roll intro.
  - `banh-cuon-ba-hoanh-bottom-inset.jpg`: bottom-validation launch shows related Hanoi food cards and playable Useful Phrases above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-banh-cuon-ba-hoanh`
  - `--detail-page viet-family-city-hanoi-place-banh-cuon-ba-hoanh --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 104 places, Hanoi 101 places, Da Nang/Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 505 entries imported.
- native resource generation: PASS, 1752 families, 1770 phrases, 1763 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 505 entries, 505 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 505 city noun pages, 505 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 505 city places, 811 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bánh Cuốn Bà Hoành Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven across four Saigon food pages and one Hanoi breakfast page. The next MICHELIN-backed adds should keep answering why this place, why this dish, and why save it before the trip, rather than expanding every guide-listed restaurant.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only.

## Continuation: Bún Riêu Cua 39 Additive Da Nang Pilot

Eighteenth pass date: 2026-05-31

Commit before pass: `894fce9f6 Add Banh Cuon Ba Hoanh Hanoi food listing`

This continuation implements the first additive Da Nang food pilot after four Saigon additions and one Hanoi breakfast addition. The product choice remains additive expansion: Saigon carries 104 noun/place rows, Hanoi carries 101, Da Nang now carries 101, and the full city-place runtime carries 506 rows total.

### Page Added

- `city-danang-place-bun-rieu-cua-39`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Bún Riêu Cua 39 as a distinct Da Nang crab-tomato noodle save;
- uses bounded 2025 MICHELIN Selected language supported by the official 2025 source;
- uses bowl-specific cues: red crab-tomato broth, rice vermicelli, tofu, herbs, shrimp paste, chili, and table condiments;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a first Da Nang expansion row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 104 rows, Hanoi to carry 101, and Da Nang to carry 101 while Hội An and Hue remain at 100.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: expected handwritten-copy count follows the approved noun source pages instead of a hardcoded 100-per-city value.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 506 noun/place pages, with HCMC at 104, Hanoi at 101, and Da Nang at 101.

This keeps the growing food catalog explicit in validation instead of hiding new restaurants as loose JSON extras.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Bún Riêu Cua 39`: 2025 MICHELIN Selected, Da Nang, Noodles.

The live MICHELIN restaurant page was not used as the runtime source of truth, so the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-rieu-cua-39-additive/`

Representative page captured:

- `viet-family-city-danang-place-bun-rieu-cua-39`
  - `bun-rieu-cua-39-first-screen.jpg`: first viewport shows the new Bún Riêu Cua 39 page, compact wrapped title, 2025 MICHELIN Selected framing, and crab-tomato noodle intro.
  - `bun-rieu-cua-39-bottom-inset.jpg`: bottom-validation launch shows related Da Nang noodle cards and playable Useful Phrases above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-bun-rieu-cua-39`
  - `--detail-page viet-family-city-danang-place-bun-rieu-cua-39 --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 104 places, Hanoi 101 places, Da Nang 101 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 506 entries imported.
- native resource generation: PASS, 1753 families, 1771 phrases, 1764 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 506 entries, 506 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 506 city noun pages, 506 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 506 city places, 812 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bún Riêu Cua 39 Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven across Saigon, Hanoi, and Da Nang. The next adds should keep widening specific food desire only when the page adds a new dish memory or a clearly better save reason, not just because a restaurant appears in the guide list.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only.

## Continuation: Phở Gà Nguyệt Additive Hanoi Pilot

Nineteenth pass date: 2026-05-31

Commit before pass: `13ee69d68 Add Bun Rieu Cua 39 Da Nang food listing`

This continuation implements the second additive Hanoi food pilot and the first named chicken-pho restaurant add. The product choice remains additive expansion: Saigon carries 104 noun/place rows, Hanoi now carries 102, Da Nang carries 101, and the full city-place runtime carries 507 rows total.

### Page Added

- `city-hanoi-place-pho-ga-nguyet`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Phở Gà Nguyệt as Hanoi's named chicken-pho counterpoint beside the existing beef-pho pages;
- uses bounded 2025 MICHELIN Bib Gourmand language supported by the official 2025 source;
- uses bowl and room cues: clear chicken broth, rice noodles, tender chicken, herbs, lime, and a counter meal built around phở gà;
- avoids telling the reader to save the place in visible copy, and lets the specific dish role carry the save reason;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a second Hanoi expansion row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 104 rows, Hanoi to carry 102, and Da Nang to carry 101 while Hội An and Hue remain at 100.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 507 noun/place pages, with HCMC at 104, Hanoi at 102, and Da Nang at 101.
- `native-ios/scripts/generate-authored-tier-one-pages.js`: restaurant section ordering now keeps `quick-say` immediately after `at-glance`, matching the V2.2 render contract that phrase cards should appear after the intro.
- `native-ios/scripts/generate-authored-tier-one-pages.js`: V2.2 authored city sections no longer receive generic generated support phrases when the source did not ask for them.

This keeps the growing food catalog explicit in validation and fixes the shared restaurant render order instead of hiding phrase cards below the practical sections or injecting unrelated payment phrases into authored food modules.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Phở Gà Nguyệt`: 2025 MICHELIN Bib Gourmand, Hanoi, Street Food.

The live MICHELIN restaurant page was not used as the runtime source of truth, so the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-ga-nguyet-additive/`

Representative page captured:

- `viet-family-city-hanoi-place-pho-ga-nguyet`
  - `pho-ga-nguyet-first-screen.jpg`: first viewport shows the new Phở Gà Nguyệt page, 2025 MICHELIN Bib Gourmand chicken-pho intro, and playable Useful Phrases immediately after the intro.
  - `pho-ga-nguyet-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here and Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-pho-ga-nguyet`
  - `--detail-page viet-family-city-hanoi-place-pho-ga-nguyet --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 104 places, Hanoi 102 places, Da Nang 101 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 507 entries imported.
- native resource generation: PASS, 1754 families, 1772 phrases, 1765 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 507 entries, 507 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 507 city noun pages, 507 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 507 city places, 813 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Phở Gà Nguyệt Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven across seven stronger food pages, including the first named chicken-pho page. The next adds should stay selective: only add a restaurant when it creates a new food memory, a stronger comparison, or a clearer reason to remember the place before the trip.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Cao Lầu Thanh Additive Hội An Pilot

Pass date: 2026-05-31

Commit before pass: `2c0d9e75a Add Com Ga Ba Buoi Hoi An food listing`

This continuation answers the open Hội An cao lầu question directly: the existing `Cao lầu ở Hội An` dish page was useful, but its phrase cards were too generic and it had no focused named cao lầu stop. `Cao Lầu Thanh` adds the save-worthy bowl destination while keeping `Morning Glory Hội An` as the broader-menu orientation table.

### Page Added And Page Repaired

- `city-hoian-place-cao-lau-thanh`: new first-class V2.2 Hội An restaurant page.
- `city-hoian-place-cao-lau-city`: repaired with food-ordering phrase cards and a related card to the named Cao Lầu Thanh page.

Visible page direction:

- `Cao Lầu Thanh` is framed as the focused Thái Phiên save for cao lầu itself: thick noodles, pork, herbs, crisp pieces, and sauce.
- Mentioned Here links back to `Cao lầu ở Hội An`, so the named restaurant and dish guide support each other.
- Compare Nearby renders `Cao lầu ở Hội An`, `Morning Glory Hội An`, and `Cơm Gà Bà Buội`, giving the user a real food-planning choice rather than another isolated card.

### Add Decision

Decision: add, and let it lead as the focused cao lầu bowl save.

Source support:

- Vietnam Travel `Explore the food of Hoi An` lists `Quán Cao Lầu Thanh` at `26 Thái Phiên`.
- Quang Nam Tourism's 2026 cao lầu roundup identifies Thanh as a small, recognized cao lầu stop.

No MICHELIN claim is used. Hội An remains outside the current MICHELIN Vietnam city coverage tracked by this audit.

### Runtime Shape

- `docs/city-production/agent-inputs/hoian-nouns.md`: added row `hoian-cao-lau-thanh`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: added the authored V2.2 source object and repaired the dish-page phrase cards.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 520 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js`, `native-ios/scripts/validate-viet-city-copy.js`, and `native-ios/scripts/build-viet-city-app-detail-v2-2.test.js`: city count expectations now allow HCMC 106, Hanoi 106, Da Nang 106, Hội An 102, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-cao-lau-thanh-additive/`

Representative page captured:

- `viet-family-city-hoian-place-cao-lau-thanh`
  - `cao-lau-thanh-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `The Bowl Gets A Counter` intro, and Useful Phrases start.
  - `cao-lau-thanh-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hoian-place-cao-lau-thanh`
  - `--detail-page viet-family-city-hoian-place-cao-lau-thanh --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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
node native-ios/scripts/build-viet-city-app-detail-v2-2.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 520 entries imported.
- city noun intake: PASS, Saigon 106 places, Hanoi 106 places, Da Nang 106 places, Hội An 102 places, Hue 100 places.
- native resource generation: PASS, 1767 families, 1785 phrases, 1778 pages.
- SQLite fixture generation: PASS, integrity OK, 1778 pages.
- strict V2.2 source validation: PASS, 520 entries, 520 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS after rerunning generation and validation serially, 520 city places, 826 city phrase tags, 0 release-blocking missing audio rows, 9099 relations.
- SQLite fixture test: PASS, 1 test.
- deterministic V2.2 builder unit test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Cao Lầu Thanh Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthens Hội An cao lầu coverage, but it does not settle every smaller Hội An restaurant. The next Hội An food pass should compare remaining named local candidates against the dish pages and ask whether each one creates a concrete save decision, not just another list entry.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only because prior real-agent lifecycle attempts froze.

## Continuation: Cơm Gà Bà Buội Additive Hội An Pilot

Twenty-sixth pass date: 2026-05-31

Commit before pass: `a32799a4e Add Tuyet Bun Cha 34 Hanoi food listing`

This continuation moves beyond the MICHELIN-covered cities and fixes a specific Hội An food gap. The app already had a general `Cơm gà Hội An` dish page, but it did not give the traveler a named chicken-rice place to save. `Cơm Gà Bà Buội` becomes the first additive Hội An food pilot because the page can answer the user’s question directly: why this place, why Hội An, why save it before the trip?

### Page Added

- `city-hoian-place-com-ga-ba-buoi`: new first-class V2.2 Hội An restaurant page.

Visible page direction:

- The page frames Bà Buội as the named old-town chicken-rice lunch: yellow rice, shredded chicken, herbs, papaya, soup, and sauce on Phan Châu Trinh.
- It links Mentioned Here to `Cơm gà Hội An`, so the named place and the dish guide reinforce each other.
- It renders Morning Glory, Bánh mì Phượng, and the general Cơm gà dish page as Compare Nearby cards, so the page helps a traveler choose between a wider menu, a sandwich counter, and chicken rice.

### Dish-Page Repair

- `city-hoian-place-com-ga`: phrase cards changed from generic sight/water cards to food cards: one portion, not spicy, and pack to go.
- The dish page now points to `Cơm Gà Bà Buội` as the named chicken-rice stop while keeping `Bánh mì Phượng` as a quick-meal contrast.

### Add Decision

Decision: add, and let it lead for Hội An chicken rice.

This is intentionally not a MICHELIN add. Hội An remains outside the current MICHELIN Vietnam coverage used by the audit, so the production standard here is local significance, dish specificity, source restraint, and render proof. Visible copy avoids ranking, hours, prices, branch status, and operational claims.

Source support:

- Quang Nam Tourism source: `https://quangnamtourism.com.vn/ja/nhhacomgababuoi`

### Runtime Shape

- `docs/city-production/agent-inputs/hoian-nouns.md`: added `hoian-com-ga-ba-buoi`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: added the authored V2.2 source object and repaired the general chicken-rice dish page.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 519 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js`, `native-ios/scripts/validate-viet-city-copy.js`, and `native-ios/scripts/build-viet-city-app-detail-v2-2.test.js`: city count expectations now allow HCMC 106, Hanoi 106, Da Nang 106, Hội An 101, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-com-ga-ba-buoi-additive/`

Representative page captured:

- `viet-family-city-hoian-place-com-ga-ba-buoi`
  - `com-ga-ba-buoi-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `Chicken Rice Gets A Name` intro, and Useful Phrases start.
  - `com-ga-ba-buoi-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus Morning Glory, Bánh mì Phượng, and Cơm gà Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hoian-place-com-ga-ba-buoi`
  - `--detail-page viet-family-city-hoian-place-com-ga-ba-buoi --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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
node native-ios/scripts/build-viet-city-app-detail-v2-2.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection: PASS, 519 entries by city: Da Nang 106, Hanoi 106, HCMC 106, Hội An 101, Hue 100.
- city noun intake: PASS, 519 city place pages.
- handwritten-copy import: PASS, 519 entries imported.
- native resource generation: PASS, 1766 families, 1784 phrases.
- authored listing generation: PASS, 825 city library pages.
- SQLite fixture generation: PASS, integrity OK, 1777 pages.
- strict V2.2 source validation: PASS, 519 entries, 519 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after removing app-internal `anchor`/negation phrasing before final screenshots.
- city-copy compatibility validation: PASS, 5 hubs, 519 city noun pages, 519 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 519 city places, 825 city phrase tags, 0 release-blocking missing audio rows, 9092 relations.
- SQLite fixture test: PASS, 1 test.
- deterministic V2.2 builder unit test: PASS after updating the count contract to 519.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Cơm Gà Bà Buội Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass proves the first non-MICHELIN Hội An additive pattern: when MICHELIN coverage is unavailable, a place can still earn a slot if it repairs a dish gap and makes a specific save more desirable. The next Hội An pass should compare named cao lầu candidates against the existing `Cao lầu ở Hội An` dish page before adding another restaurant.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Tuyết Bún Chả 34 Additive Hanoi Pilot

Pass date: 2026-05-31

Commit before pass: `d27e95065 Add Pho Huong Binh HCMC food listing`

This continuation adds `Tuyết Bún Chả 34` only after the remaining bún chả candidate cleared the difference bar. The page does not flatten Hanoi into another generic grilled-pork listing. It gives the bún chả set a numbered Hàng Than street-food stall: pork chargrilled to order, noodles dipped in broth, herbs, and an optional spring roll for crunch.

### Page Added

- `city-hanoi-place-tuyet-bun-cha-34`: new first-class V2.2 Hanoi restaurant page.

Visible page direction:

- The first screen frames Tuyết as the grill-smoke-and-crunch bún chả save, not another famous room or sauce-led table.
- Mentioned Here links to `Bún chả ở Hà Nội`, so the named stall sits behind the broader dish guide.
- Compare Nearby renders `Bún chả Hương Liên`, `Bún Chả Ta`, and `Bún Chả Đắc Kim`, making the four bún chả roles clearer instead of flatter.
- The dish-level bún chả page plus the current Hương Liên, Bún Chả Ta, and Đắc Kim pages now route toward Tuyết where that comparison helps.

### Add Decision

Decision: add, with a narrow role.

Hương Liên remains the famous MICHELIN Selected room. Bún Chả Ta remains the seated Old Quarter Bib Gourmand table. Đắc Kim remains the Hàng Mành sauce, mango, and pork-patty lunch. Tuyết adds a different memory: a Hàng Than numbered street-food stall where chargrilled-to-order pork and spring-roll crunch carry the save.

Source support:

- Official MICHELIN Guide Vietnam 2025 PDF lists `Tuyết Bún Chả 34` in the Hanoi Bib Gourmand section as Street Food.
- Current MICHELIN venue-page evidence supports the stable visible details used in copy: 34 Hang Than Street, street-food stall, bún chả chargrilled to order, rice noodles, fresh herbs, pork, broth, and optional extra spring roll for crunch.

The page avoids hours, booking, closure, price, and fragile operating claims.

### Runtime Shape

- `docs/city-production/agent-inputs/hanoi-nouns.md`: added row `106`.
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`: added the authored V2.2 source object and comparison cards from the bún chả dish page plus Hương Liên, Bún Chả Ta, and Đắc Kim.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 518 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 106, Hanoi 106, Da Nang 106, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-tuyet-bun-cha-34-additive/`

Representative page captured:

- `viet-family-city-hanoi-place-tuyet-bun-cha-34`
  - `tuyet-bun-cha-34-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `Grill Smoke, Then Crunch` intro, and playable Useful Phrases.
  - `tuyet-bun-cha-34-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus Hương Liên, Bún Chả Ta, and Đắc Kim Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-tuyet-bun-cha-34`
  - `--detail-page viet-family-city-hanoi-place-tuyet-bun-cha-34 --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 518 entries imported.
- native resource generation: PASS, 1765 families, 1783 phrases, 1776 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 518 entries, 518 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing one `best` sentence before projection.
- city-copy compatibility validation: PASS, 5 hubs, 518 city noun pages, 518 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 518 city places, 824 city phrase tags, 0 release-blocking missing audio rows, 9083 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Tuyết Bún Chả 34 Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass resolves the remaining high-priority Hanoi bún chả add candidate. Future bún chả additions should be exceptional: a new candidate needs a different food job than Hương Liên, Bún Chả Ta, Đắc Kim, and Tuyết. The next work should shift back toward rendered proof and support/demotion checks for existing restaurant, cafe, drink, market, and non-MICHELIN food pages.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source-fit, food-desire, voice, graph/runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Phở Hương Bình Additive HCMC Pilot

Pass date: 2026-05-31

Commit before pass: `9f3cda275 Add Banh Cuon Ba Xuan Hanoi food listing`

This continuation adds `Phở Hương Bình` because the remaining Saigon phở candidate finally clears the difference bar. It is not another generic southern-phở listing. The page owns the chicken-or-beef family-shop choice: phở gà or phở bò, clearer broth, herbs, chicken skin, egg yolk, brisket, tendon, and add-ons inside a long-running shop story.

### Page Added

- `city-hcmc-place-pho-huong-binh`: new first-class V2.2 HCMC restaurant page.

Visible page direction:

- The first screen frames Hương Bình as the chicken-or-beef Bib Gourmand phở comparison, not another Pasteur or District 5 bowl.
- Mentioned Here links to `Phở Sài Gòn ở Thành phố Hồ Chí Minh` so the named shop has dish-level context.
- Compare Nearby renders `Phở Lệ`, `Phở Minh`, and `Phở Hòa Pasteur`, making the Saigon phở hierarchy clearer rather than flatter.

### Add Decision

Decision: add, with a narrow role.

The page earns the extra slot because it answers a different trip question than the current Saigon phở set. `Phở Lệ` is the fuller District 5 Bib Gourmand bowl. `Phở Minh` is the quieter Pasteur-alley breakfast. `Phở Hòa Pasteur` is the familiar central support shop. Hương Bình is the family-shop phở choice when chicken and beef both need to stay on the table.

Source support:

- Official MICHELIN Guide Vietnam 2025 PDF lists `Phở Hương Bình` in the Ho Chi Minh City Bib Gourmand section as noodles.
- Current MICHELIN venue-page evidence supports the stable visible details used in copy: 1958 family/second-generation story, phở gà, phở bò, clear light broth, chicken skin, egg yolk, brisket, tendon, and bowl add-ons.

The page avoids hours, address, booking, closure, price, or operating claims.

### Runtime Shape

- `docs/city-production/agent-inputs/hcmc-nouns.md`: added row `65`.
- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`: added the authored V2.2 source object and comparison cards from the southern-phở dish page plus Phở Lệ, Phở Minh, and Phở Hòa Pasteur.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 517 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 106, Hanoi 105, Da Nang 106, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-huong-binh-additive/`

Representative page captured:

- `viet-family-city-hcmc-place-pho-huong-binh`
  - `pho-huong-binh-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `Chicken Or Beef, Same Room` intro, and playable Useful Phrases.
  - `pho-huong-binh-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus `Phở Lệ`, `Phở Minh`, and `Phở Hòa Pasteur` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-pho-huong-binh`
  - `--detail-page viet-family-city-hcmc-place-pho-huong-binh --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 517 entries imported.
- native resource generation: PASS, 1764 families, 1782 phrases, 1775 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 517 entries, 517 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after removing one internal-sounding sentence before projection.
- city-copy compatibility validation: PASS, 5 hubs, 517 city noun pages, 517 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 517 city places, 823 city phrase tags, 0 release-blocking missing audio rows, 9072 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Phở Hương Bình Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass resolves the remaining Saigon phở add candidate by giving it a narrow chicken-or-beef family-shop role. Remaining MICHELIN-backed adds should now focus outside Saigon phở unless a new candidate proves a genuinely different food job. `Tuyết Bún Chả 34` was later resolved by the additive Hanoi pilot once its Hàng Than numbered-stall role cleared the bar.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source-fit, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Bánh Cuốn Bà Xuân Additive Hanoi Pilot

Pass date: 2026-05-31

Commit before pass: `ea1242ba8 Add Bun Cha Dac Kim Hanoi food listing`

This continuation adds `Bánh Cuốn Bà Xuân` because it is not just another Hanoi breakfast row. The page gives bánh cuốn coverage a different food-specific reason to save: soft rice sheets, minced pork and black fungus filling, poached egg option, sausage or meatloaf, herbs, chili, lime, garlic, and dipping sauce. It sits beside Bà Hoành as a fuller same-dish comparison rather than replacing it.

### Page Added

- `city-hanoi-place-banh-cuon-ba-xuan`: new first-class V2.2 Hanoi restaurant page.

Visible page direction:

- The first screen frames Bà Xuân as the egg-and-condiment bánh cuốn save, not a generic steamed-roll listing.
- Mentioned Here links to `Bánh cuốn ở Hà Nội` so the restaurant has dish-level context.
- Compare Nearby renders `Bánh Cuốn Bà Hoành`, `Xôi xéo`, and `Phở Gà Nguyệt`, which turns the page into a real breakfast decision set.

### Add Decision

Decision: add, and keep the page food-specific.

The current catalog already has Bà Hoành, so Bà Xuân only earns a slot if it teaches a difference. The official 2025 MICHELIN PDF lists `Bánh Cuốn Bà Xuân` in the Hanoi MICHELIN Selected section as street food, and the visible copy uses that recognition as support while staying focused on the plate.

The page avoids hours, address, booking, closure, price, or operating claims. It keeps the bundled copy to stable food facts and source-supported MICHELIN recognition.

### Runtime Shape

- `docs/city-production/agent-inputs/hanoi-nouns.md`: added row `105`.
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`: added the authored V2.2 source object and updated related cards from the dish page and Bà Hoành.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 516 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 105, Hanoi 105, Da Nang 106, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-banh-cuon-ba-xuan-additive/`

Representative page captured:

- `viet-family-city-hanoi-place-banh-cuon-ba-xuan`
  - `banh-cuon-ba-xuan-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `Egg In The Steam` intro, and the Useful Phrases start.
  - `banh-cuon-ba-xuan-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus `Bánh Cuốn Bà Hoành`, `Xôi xéo`, and `Phở Gà Nguyệt` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-banh-cuon-ba-xuan`
  - `--detail-page viet-family-city-hanoi-place-banh-cuon-ba-xuan --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 516 entries imported.
- native resource generation: PASS, 1763 families, 1781 phrases, 1774 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 516 entries, 516 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing one banned `strongest` sentence before projection.
- city-copy compatibility validation: PASS, 5 hubs, 516 city noun pages, 516 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 516 city places, 822 city phrase tags, 0 release-blocking missing audio rows, 9061 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bánh Cuốn Bà Xuân Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass resolves the Bà Xuân candidate by making it a distinct fuller bánh cuốn save. Remaining MICHELIN-backed candidates should be harder to add now. `Tuyết Bún Chả 34` was later resolved by the additive Hanoi pilot once its Hàng Than numbered-stall role cleared the bar, and `Phở Hương Bình` was later resolved by the additive HCMC pilot once its chicken-or-beef family-shop role cleared the bar.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source-fit, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Bún Chả Đắc Kim Additive Hanoi Pilot

Thirtieth pass date: 2026-05-31

Commit before pass: `b7968d080 Add Pho Minh HCMC food listing`

This continuation adds `Bún Chả Đắc Kim` as a food-specific Hanoi bún chả page. The point is not to add every bún chả shop; the page earns the slot because the official MICHELIN venue page gives enough concrete food evidence to make the save feel different from Hương Liên and Bún Chả Ta.

### Page Added

- `city-hanoi-place-bun-cha-dac-kim`: new first-class V2.2 Hanoi restaurant page.

Visible page direction:

- The page frames Đắc Kim as a MICHELIN Guide Hàng Mành bún chả stop where the sauce, pickled green mango, smoky pork, and pork patties lead the desire.
- It links Mentioned Here to `Bún chả ở Hà Nội`, so the named restaurant sits behind the broader dish guide.
- It renders `Bún chả Hương Liên`, `Bún Chả Ta`, and `Tuyến đi bộ Phố cổ` as Compare Nearby cards, separating famous-room, Bib Gourmand dipping-bowl, and Hàng Mành sauce-and-pork lunch roles.
- The dish-level bún chả page plus the current Hương Liên and Bún Chả Ta pages now route toward Đắc Kim where that comparison helps.

### Add Decision

Decision: add, because it makes the Hanoi bún chả set more food-specific.

Hương Liên remains the famous MICHELIN Selected room. Bún Chả Ta remains the 2025 Bib Gourmand Old Quarter table. Đắc Kim adds a sharper Hàng Mành lunch reason: sweet fish-sauce dip, pickled green mango, smoky shredded pork, plump patties, noodles, and herbs.

Source support:

- Current MICHELIN venue page for `Bún Chả Đắc Kim` lists it as a Hanoi street-food restaurant in the MICHELIN Guide.
- The same MICHELIN page supports the stable visible food details used in the app copy: sweet fish-sauce dip, pickled green mango, vermicelli, smoky pork, and plump pork patties.

### Runtime Shape

- `docs/city-production/agent-inputs/hanoi-nouns.md`: added row `hanoi-bun-cha-dac-kim`.
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`: added the authored V2.2 source object and bún chả comparison cards.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 515 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 105, Hanoi 104, Da Nang 106, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-cha-dac-kim-additive/`

Representative page captured:

- `viet-family-city-hanoi-place-bun-cha-dac-kim`
  - `bun-cha-dac-kim-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `Sauce, Smoke, Mango` intro, and playable Useful Phrases.
  - `bun-cha-dac-kim-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus Hương Liên, Bún Chả Ta, and Old Quarter walk Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-bun-cha-dac-kim`
  - `--detail-page viet-family-city-hanoi-place-bun-cha-dac-kim --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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

- city noun intake: PASS, Saigon 105 places, Hanoi 104 places, Da Nang 106 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 515 entries imported.
- native resource generation: PASS, 1762 families, 1780 phrases, 1773 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 515 entries, 515 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 515 city noun pages, 515 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 515 city places, 821 city phrase tags, 0 release-blocking missing audio rows, 9051 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bún Chả Đắc Kim Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthens Hanoi bún chả coverage, but it also raises the bar for adding `Tuyết Bún Chả 34`. That page should only be added if current source evidence proves a different role from Hương Liên, Bún Chả Ta, and Đắc Kim.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Phở Minh Additive HCMC Pilot

Twenty-ninth pass date: 2026-05-31

Commit before pass: `95d4fd220 Add MOC Da Nang seafood listing`

This continuation adds `Phở Minh` as a distinct Saigon phở page. The reason to add it is not another phở slot; the page earns the slot because it gives the HCMC set a quieter old-alley Pasteur Street breakfast role that differs from both `Phở Lệ` and `Phở Hòa Pasteur`.

### Page Added

- `city-hcmc-place-pho-minh`: new first-class V2.2 HCMC restaurant page.

Visible page direction:

- The page frames Phở Minh as a 2025 MICHELIN Bib Gourmand phở shop tucked down a Pasteur Street alley, with a shop story dating to 1945.
- It uses beef cuts, herbs, broth, and pâté chaud as the concrete food cues, while avoiding fragile hours, prices, booking, address, closure, and availability claims in visible copy.
- It renders `Phở Sài Gòn` and `Đường Pasteur` as Mentioned Here cards.
- It renders `Phở Lệ`, `Phở Hòa Pasteur`, and `Đường Pasteur` as Compare Nearby cards, so the user can build a small Saigon phở plan instead of saving a disconnected pin.
- `Phở Lệ`, `Phở Hòa Pasteur`, and the southern-phở dish page now point back to Phở Minh where that comparison helps.

### Add Decision

Decision: add, because it creates a new trip moment inside an already crowded phở set.

Phở Lệ carries the fuller District 5 Bib Gourmand bowl. Phở Hòa Pasteur remains the familiar central shop. Phở Minh adds the old-alley breakfast room: smaller, earlier-feeling, tied to Pasteur Street, and specific enough for a foodie to save before arrival.

Source support:

- Current MICHELIN venue page for `Phở Minh` lists it as Bib Gourmand, Ho Chi Minh City, Noodles.
- The same MICHELIN page supports the stable visible facts used in the app copy: narrow alley off Pasteur Street, 1945 origin, traditional beef noodle soup, cut choices, and pâté chaud.

### Runtime Shape

- `docs/city-production/agent-inputs/hcmc-nouns.md`: added row `hcmc-pho-minh`.
- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`: added the authored V2.2 source object and related cards from existing phở pages.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 514 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 105, Hanoi 103, Da Nang 106, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-minh-additive/`

Representative page captured:

- `viet-family-city-hcmc-place-pho-minh`
  - `pho-minh-first-screen.jpg`: first viewport shows the title, pronunciation line, `An Alley Pho Breakfast` intro, and playable Useful Phrases.
  - `pho-minh-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here and Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-pho-minh`
  - `--detail-page viet-family-city-hcmc-place-pho-minh --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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

- city noun intake: PASS, Saigon 105 places, Hanoi 103 places, Da Nang 106 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 514 entries imported.
- native resource generation: PASS, 1761 families, 1779 phrases, 1772 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 514 entries, 514 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 514 city noun pages, 514 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 514 city places, 820 city phrase tags, 0 release-blocking missing audio rows, 9041 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Phở Minh Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthened Saigon phở coverage and made further Saigon phở additions harder to justify. `Phở Hương Bình` was later added only after the source evidence proved a different chicken-or-beef table role from Phở Lệ, Phở Hòa Pasteur, and Phở Minh.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: MỘC Quán Seafood Additive Da Nang Pilot

Twenty-eighth pass date: 2026-05-31

Commit before pass: `1e05f0274 Add Bep Hen Da Nang food listing`

This continuation adds `MỘC Quán Seafood` as a guided seafood-table page. The point is not to copy another seafood name into the catalog; the page earns the slot because it gives Da Nang seafood a clearer table role than the existing louder display-table pages.

### Page Added

- `city-danang-place-moc-quan-seafood`: new first-class V2.2 Da Nang restaurant page.

Visible page direction:

- The page frames MỘC as a 2025 MICHELIN Selected seafood table for choosing from tanks, getting help with shellfish, and letting lobster in garlic butter lead the meal.
- It links Mentioned Here to `Hải sản ở Đà Nẵng`, so the named restaurant sits behind the broader seafood-ordering guide.
- It renders `Hải sản Bé Mặn` and `Hải sản Năm Đảnh` as Compare Nearby cards, separating guided seafood from louder display ordering and casual neighborhood rounds.
- The dish-level seafood guide now renders MỘC as a related named seafood table.

### Add Decision

Decision: add, because it improves the seafood hierarchy.

MỘC is different from Bé Mặn and Năm Đảnh. Bé Mặn remains the louder display-table save; Năm Đảnh remains the neighborhood rounds save. MỘC gives the app a guided seafood-choice save where tanks, shellfish help, and a richer lobster-garlic-butter cue can make the table feel easier to imagine and save before the trip.

Source support:

- Current MICHELIN venue page for `Moc` describes tanks, staff wearing gloves to help with shellfish, and lobster in garlic butter.
- 2025 MICHELIN Guide Vietnam coverage supports `Moc` as a MICHELIN Selected Da Nang restaurant.

### Runtime Shape

- `docs/city-production/agent-inputs/danang-nouns.md`: added row `danang-moc-quan-seafood`.
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`: added the authored V2.2 source object and a dish-guide related card.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 513 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 104, Hanoi 103, Da Nang 106, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-moc-quan-seafood-additive/`

Representative page captured:

- `viet-family-city-danang-place-moc-quan-seafood`
  - `moc-quan-seafood-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `Guided Seafood From The Tanks` intro, and Useful Phrases start.
  - `moc-quan-seafood-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus `Hải sản Bé Mặn` and `Hải sản Năm Đảnh` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-moc-quan-seafood`
  - `--detail-page viet-family-city-danang-place-moc-quan-seafood --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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

- city noun intake: PASS, Saigon 104 places, Hanoi 103 places, Da Nang 106 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 513 entries imported.
- native resource generation: PASS, 1760 families, 1778 phrases, 1771 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 513 entries, 513 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing the initial `belongs when` wording before final generation.
- city-copy compatibility validation: PASS, 5 hubs, 513 city noun pages, 513 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 513 city places, 819 city phrase tags, 0 release-blocking missing audio rows, 9030 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After MỘC Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthens the Da Nang seafood hierarchy, but it also raises the bar for further Da Nang additions. The next Da Nang restaurant should not be added simply because it is guide-listed; it needs a new food emotion, table role, or trip-building comparison beyond the current guide-backed set.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Bếp Hên Additive Da Nang Pilot

Twenty-seventh pass date: 2026-05-31

Commit before pass: `96d1a35f1 Add Bun Cha Ca 109 Da Nang food listing`

This continuation adds `Bếp Hên` to address the product concern that the food expansion was getting noodle-heavy. The page earns the slot through a different reason: a warmer home-style Da Nang dinner, smaller-room feeling, handwritten-menu energy, garlicky prawns, beef, greens, and shared plates.

### Page Added

- `city-danang-place-bep-hen`: new first-class V2.2 Da Nang restaurant page.

Visible page direction:

- The page frames Bếp Hên as a 2025 MICHELIN Selected home-style dinner save rather than another noodle or guide-list duplicate.
- It renders `Madame Lân` and `Bếp Cuốn Đà Nẵng` as Compare Nearby cards, separating a small house-style table from a broader courtyard table and a focused roll-and-dip meal.
- `Madame Lân` now also renders Bếp Hên as a related dinner contrast.

### Add Decision

Decision: add, because it changes the emotional mix of the Da Nang restaurant set.

Bếp Hên is stronger than adding another similar bowl at this moment. It gives foodies a reason to save a place before the trip that is about room, table, and house dishes, while still carrying MICHELIN support.

Source support:

- Current MICHELIN venue page for `Bếp Hên` describes the owner's mum in the kitchen, a handwritten menu, fried garlic prawn, and stir-fried beef cues.
- 2025 MICHELIN Guide Vietnam coverage supports `Bếp Hên` as a MICHELIN Selected Da Nang restaurant.

### Runtime Shape

- `docs/city-production/agent-inputs/danang-nouns.md`: added row `danang-bep-hen`.
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`: added the authored V2.2 source object and a Madame Lân related card.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 512 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 104, Hanoi 103, Da Nang 105, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bep-hen-additive/`

Representative page captured:

- `viet-family-city-danang-place-bep-hen`
  - `bep-hen-first-screen.jpg`: first viewport shows the title, pronunciation line, `A Small House Dinner` intro, and Useful Phrases start.
  - `bep-hen-bottom-inset.jpg`: bottom-validation launch shows `Beside Madame Lân` plus `Madame Lân` and `Bếp Cuốn Đà Nẵng` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-bep-hen`
  - `--detail-page viet-family-city-danang-place-bep-hen --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

### Validation Status

Commands:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-city-noun-intake.js
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

- city noun intake: PASS, Saigon 104 places, Hanoi 103 places, Da Nang 105 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 512 entries imported.
- native resource generation: PASS, 1759 families, 1777 phrases, 1770 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 512 entries, 512 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing the initial `anchor` wording before final generation.
- city-copy compatibility validation: PASS, 5 hubs, 512 city noun pages, 512 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 512 city places, 818 city phrase tags, 0 release-blocking missing audio rows, 9023 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bếp Hên Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass improves the restaurant mix rather than only expanding dish coverage. The next pass should keep comparing remaining MICHELIN-backed candidates against the current inventory and should prefer pages that add a new food emotion, table role, or trip-planning contrast over another duplicate dish slot.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Bún Chả Cá 109 Additive Da Nang Pilot

Twenty-sixth pass date: 2026-05-31

Commit before pass: `ec43f89a0 Add Pho 10 Ly Quoc Su Hanoi food listing`

This continuation adds `Bún Chả Cá 109` after rechecking the remaining MICHELIN-backed candidates against the existing catalog. The point is not to add another generic fish-cake noodle shop; the page earns the slot through a distinct food reason: house-made fried and steamed fish cakes, seafood broth depth, herbs, and a pineapple-tomato edge.

### Page Added

- `city-danang-place-bun-cha-ca-109`: new first-class V2.2 Da Nang restaurant page.

Visible page direction:

- The page frames Bún Chả Cá 109 as a 2025 MICHELIN Bib Gourmand fish-cake noodle bowl with texture first.
- It links Mentioned Here to `Bún chả cá ở Đà Nẵng`, so the named shop has dish-level context.
- It renders `Bún Chả Cá Hờn` and `Bánh Canh Yến` as Compare Nearby cards, separating same-dish comparison from a different Da Nang noodle-texture choice.

### Add Decision

Decision: add, because it now has a clearer difference from Hờn.

The previous audit held Bún Chả Cá 109 as conditional because it needed a sharper distinction from `Bún Chả Cá Hờn`. The current page gives it that distinction: Hờn remains the cleaner fish-cake soup comparison, while 109 is the more texture-led fish-cake and seafood-broth save.

Source support:

- Official MICHELIN Guide Vietnam 2025 PDF lists `Bún Chả Cá 109` in the Da Nang Bib Gourmand section as noodles.
- Current MICHELIN venue page for `Bún Chả Cá 109` describes house-made fried and steamed fish cakes, tuna, mackerel, crab, and pineapple-tomato broth.

### Runtime Shape

- `docs/city-production/agent-inputs/danang-nouns.md`: added row `danang-bun-cha-ca-109`.
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`: added the authored V2.2 source object and a dish-page related card.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 511 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 104, Hanoi 103, Da Nang 104, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-cha-ca-109-additive/`

Representative page captured:

- `viet-family-city-danang-place-bun-cha-ca-109`
  - `bun-cha-ca-109-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `House-Made Fish-Cake Texture` intro, and Useful Phrases start.
  - `bun-cha-ca-109-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus `Bún Chả Cá Hờn` and `Bánh Canh Yến` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-bun-cha-ca-109`
  - `--detail-page viet-family-city-danang-place-bun-cha-ca-109 --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

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

- city noun intake: PASS, Saigon 104 places, Hanoi 103 places, Da Nang 104 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 511 entries imported.
- native resource generation: PASS, 1758 families, 1776 phrases, 1769 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 511 entries, 511 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after removing negation-style copy from the new 109 page.
- city-copy compatibility validation: PASS, 5 hubs, 511 city noun pages, 511 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 511 city places, 817 city phrase tags, 0 release-blocking missing audio rows, 9017 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bún Chả Cá 109 Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthens Da Nang fish-cake soup coverage with a differentiated second named bowl. The next candidate should probably shift away from another duplicate noodle category unless the source evidence gives it a clearly different food job.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Bánh Canh Yến Additive Da Nang Pilot

Twentieth pass date: 2026-05-31

Commit before pass: `927332603 Add Pho Ga Nguyet Hanoi food listing`

This continuation implements the second additive Da Nang food pilot and adds a thick-noodle soup page rather than another duplicate pho, bún chả, or fish-cake soup page. The product choice remains additive expansion: Saigon carries 104 noun/place rows, Hanoi carries 102, Da Nang now carries 102, and the full city-place runtime carries 508 rows total.

### Page Added

- `city-danang-place-banh-canh-yen`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Bánh Canh Yến as a distinct Da Nang thick-noodle soup stop, not another generic noodle listing;
- uses bounded 2025 MICHELIN Selected language supported by the official 2025 source;
- uses bowl and texture cues: thick slippery noodles, hot broth, toppings, herbs, chili, and a short street-food meal;
- keeps the MICHELIN signal as support while the food texture carries the reason to remember it;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a second Da Nang expansion row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 104 rows, Hanoi to carry 102, and Da Nang to carry 102 while Hội An and Hue remain at 100.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 508 noun/place pages, with HCMC at 104, Hanoi at 102, and Da Nang at 102.

This keeps the growing food catalog explicit in validation instead of hiding the add as a loose JSON extra.

### Source Handling

Official 2025 MICHELIN reference checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`

Claim added only where this source supported it:

- `Bánh Canh Yến`: 2025 MICHELIN Selected, Da Nang, Street Food.

The live MICHELIN restaurant page was not used as the runtime source of truth, so the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-banh-canh-yen-additive/`

Representative page captured:

- `viet-family-city-danang-place-banh-canh-yen`
  - `banh-canh-yen-first-screen.jpg`: first viewport shows the new Bánh Canh Yến page, 2025 MICHELIN Selected thick-noodle intro, and playable Useful Phrases immediately after the intro.
  - `banh-canh-yen-bottom-inset.jpg`: bottom-validation launch shows Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-banh-canh-yen`
  - `--detail-page viet-family-city-danang-place-banh-canh-yen --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 104 places, Hanoi 102 places, Da Nang 102 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 508 entries imported.
- native resource generation: PASS, 1755 families, 1773 phrases, 1766 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 508 entries, 508 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing one repeated `belongs` construction in the new page.
- city-copy compatibility validation: PASS, 5 hubs, 508 city noun pages, 508 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 508 city places, 814 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Bánh Canh Yến Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven across eight stronger food pages. This pass also confirms the direction Jojo asked for: food-specific desire should win over filling every MICHELIN slot. Bánh Canh Yến was chosen because it adds a new bowl texture to Da Nang, while other candidates such as another bún chả or beef-pho shop risk duplicating pages the app already carries.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Mỳ Quảng Sứa Hồng Vân Additive Da Nang Pilot

Twenty-first pass date: 2026-05-31

Commit before pass: `fdf00d7dc Add Banh Canh Yen Da Nang food listing`

This continuation implements the third additive Da Nang food pilot and adds a more specific mì Quảng page rather than another generic noodle or seafood page. The product choice remains additive expansion: Saigon carries 104 noun/place rows, Hanoi carries 102, Da Nang now carries 103, and the full city-place runtime carries 509 rows total.

### Page Added

- `city-danang-place-my-quang-sua-hong-van`: added as a first-class V2.2 app-detail source object and projected into the legacy-compatible native resources.

Visible page direction:

- frames Mỳ Quảng Sứa Hồng Vân as a sharper Da Nang mì Quảng save, not another support restaurant;
- uses bounded 2025 MICHELIN Bib Gourmand language supported by the official 2025 PDF and current MICHELIN venue page;
- uses food-specific cues: orange-red shrimp broth, yellow noodles, herbs, rice cracker, pork, shrimp, quail egg, and optional jellyfish texture;
- renders the city-level mì Quảng dish page in Mentioned Here;
- compares nearby against Mì Quảng 1A and Bánh Canh Yến so the page has a clear role inside Da Nang's noodle set;
- keeps hours, address, booking, closure, and fragile operations out of bundled copy.

### Contract Widening

The additive contract now has a third Da Nang expansion row:

- `native-ios/scripts/import-city-noun-intake.js`: city expected-row contract now allows HCMC to carry 104 rows, Hanoi to carry 102, and Da Nang to carry 103 while Hội An and Hue remain at 100.
- `native-ios/scripts/validate-viet-city-copy.js`: city production validation now expects 509 noun/place pages, with HCMC at 104, Hanoi at 102, and Da Nang at 103.

This keeps the growing food catalog explicit in validation instead of hiding the add as a loose JSON extra.

### Source Handling

Official MICHELIN references checked for bounded recognition language:

- `https://dgaddcosprod.blob.core.windows.net/cxf-corporate/attachments/c3pr870zifu1vnufz1fqsd6c-20250605-pr-michelin-guide-hanoi-ho-chi-minh-city-da-nang-2025.pdf`
- `https://guide.michelin.com/gb/en/da-nang-region/da-nang_2984390/restaurant/my-quang-sua-hong-van`

Claim added only where these sources supported it:

- `Mỳ Quảng Sứa Hồng Vân`: 2025 MICHELIN Bib Gourmand, Da Nang, Street Food.

The current MICHELIN restaurant page was used to confirm live guide status and dish specificity, but the visible app copy avoids hours, exact address, booking, closure, and narrow operational claims.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-my-quang-sua-hong-van-additive/`

Representative page captured:

- `viet-family-city-danang-place-my-quang-sua-hong-van`
  - `my-quang-sua-hong-van-first-screen.jpg`: first viewport shows the new Mỳ Quảng Sứa Hồng Vân page, 2025 MICHELIN Bib Gourmand mì Quảng intro, and playable Useful Phrases immediately after the intro.
  - `my-quang-sua-hong-van-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here and Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-my-quang-sua-hong-van`
  - `--detail-page viet-family-city-danang-place-my-quang-sua-hong-van --validate-bottom-inset-scroll-to-bottom`
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

- city noun intake: PASS, Saigon 104 places, Hanoi 102 places, Da Nang 103 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 509 entries imported.
- native resource generation: PASS, 1756 families, 1774 phrases, 1767 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 509 entries, 509 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing `this is not` and `layered` wording in the new page.
- city-copy compatibility validation: PASS, 5 hubs, 509 city noun pages, 509 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 509 city places, 815 city phrase tags, 0 release-blocking missing audio rows.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Mỳ Quảng Sứa Hồng Vân Additive Pilot

Status remains below `GLOBAL_PRODUCTION_READY`.

The additive path is now proven across nine stronger food pages. This pass confirms the food-specific-desire direction again: Mỳ Quảng Sứa Hồng Vân was chosen because it makes a familiar Da Nang dish more vivid through shrimp-broth color and jellyfish texture, while remaining candidates such as Bún Chả Cá 109 need a sharper difference from existing fish-cake soup coverage before they deserve another slot.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Mì Quảng Support Demotion Pass

Twenty-second pass date: 2026-05-31

Commit before pass: `1565a0c3e Add My Quang Sua Hong Van Da Nang food listing`

This continuation addresses Jojo's drop/demote concern directly. The goal was not to remove useful Da Nang mì Quảng pages, but to stop older support pages from competing with stronger MICHELIN-backed mì Quảng saves.

### Pages Revised

- `city-danang-place-my-quang-ba-mua`: demoted from 30/30 to 28/30 support listing.
- `city-danang-place-my-quang-dung`: demoted from 30/30 to 27/30 support listing.

Visible page direction:

- `Mỳ Quảng Bà Mua` now reads as the easier branch-style backup: a clearer table, a named stop, yellow noodles, shallow broth, herbs, rice cracker, and low-friction ordering.
- `Mỳ Quảng Dung` now reads as the compact counter fallback: point, watch bowls move, taste first, and get a simple bowl without turning lunch into a destination plan.
- Both pages keep the city-level `Mì Quảng ở Đà Nẵng` card in Mentioned Here.
- Both pages now compare against `Mỳ Quảng Sứa Hồng Vân` and `Mì Quảng 1A`, making the stronger food saves visible instead of hiding the hierarchy.

### Demotion Decision

Decision: keep, but do not lead.

These pages still serve browse, route, and ordering jobs. They should not anchor a high-visibility foodie shelf while `Mỳ Quảng Sứa Hồng Vân` and `Mì Quảng 1A` carry stronger MICHELIN-backed reasons to save a mì Quảng stop before the trip.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-mi-quang-support-demotion/`

Representative pages captured:

- `viet-family-city-danang-place-my-quang-ba-mua`
  - `ba-mua-first-screen.jpg`: first viewport shows the new `The Easy Backup Bowl` support framing and playable Useful Phrases immediately after the intro.
  - `ba-mua-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here and Compare Nearby cards above the bottom chrome.
- `viet-family-city-danang-place-my-quang-dung`
  - `dung-first-screen.jpg`: first viewport shows the new `A Small Counter Bowl` support framing and playable Useful Phrases immediately after the intro.
  - `dung-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here and Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-my-quang-ba-mua`
  - `--detail-page viet-family-city-danang-place-my-quang-ba-mua --validate-bottom-inset-scroll-to-bottom`
  - `--detail-page viet-family-city-danang-place-my-quang-dung`
  - `--detail-page viet-family-city-danang-place-my-quang-dung --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for all four scoped launches.

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
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 509 entries imported.
- native resource generation: PASS, 1756 families, 1774 phrases, 1767 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 509 entries, 509 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing template-like `Use this` and internal `belongs because` wording before projection.
- city-copy compatibility validation: PASS, 5 hubs, 509 city noun pages, 509 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 509 city places, 815 city phrase tags, 0 release-blocking missing audio rows, 9002 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Mì Quảng Support Demotion

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass proves the add/drop posture can be applied without deleting useful inventory: weaker support restaurants can stay, but their copy, scores, and related cards should make the hierarchy clear. The next demotion pass should look for other older restaurant/cafe pages still carrying 30/30 headline posture without an equally strong reason to lead.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Fatfish Support Demotion Pass

Twenty-third pass date: 2026-05-31

Commit before pass: `c988d7951 Demote Da Nang Mi Quang support listings`

This continuation applies the same add/drop posture to `Fatfish`: keep the useful place, but stop letting it compete with more food-led Da Nang saves.

### Page Revised

- `city-danang-place-fatfish`: demoted from 30/30 to 27/30 support listing.

Visible page direction:

- The page now frames Fatfish as a slower Hàn River dinner: terrace light, drinks, an easy table after a bridge walk, and a soft landing near the water.
- The copy no longer presents Fatfish as a headline food recommendation.
- The related card keeps `Hải sản Bé Mặn` as the stronger food-led seafood contrast.

### Demotion Decision

Decision: keep, but do not lead.

Fatfish still serves a real planning job for Da Nang nights along the river. It should not lead a foodie shelf over MICHELIN-backed or dish-specific pages such as `Bé Mặn`, `Bún Riêu Cua 39`, `Bánh Canh Yến`, `Mỳ Quảng Sứa Hồng Vân`, `Mì Quảng 1A`, or `Bánh xèo Bà Dưỡng`.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-fatfish-support-demotion/`

Representative page captured:

- `viet-family-city-danang-place-fatfish`
  - `fatfish-first-screen.jpg`: first viewport shows the revised `A Slower River Table` framing and playable Useful Phrases immediately after the intro.
  - `fatfish-bottom-inset.jpg`: bottom-validation launch shows the final sections and `Compare Nearby` card above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-danang-place-fatfish`
  - `--detail-page viet-family-city-danang-place-fatfish --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for both scoped launches.

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
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 509 entries imported.
- native resource generation: PASS, 1756 families, 1774 phrases, 1767 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 509 entries, 509 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing `anchor`, ranking language, and app-internal `support save` wording before final screenshots.
- city-copy compatibility validation: PASS, 5 hubs, 509 city noun pages, 509 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 509 city places, 815 city phrase tags, 0 release-blocking missing audio rows, 9002 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Fatfish Support Demotion

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthens the hierarchy for Da Nang restaurants: a setting-led page can stay when it helps the trip, but it should carry support-score posture and point toward food-led alternatives. The next demotion pass should scan non-guide cafes, bars, and setting-led restaurants still sitting at 30/30 without a distinct food, culture, or route reason to lead.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Phở Hòa Pasteur Support Demotion Pass

Twenty-fourth pass date: 2026-05-31

Commit before pass: `70c76c31d Demote Fatfish Da Nang support listing`

This continuation applies the support hierarchy to Saigon phở. `Phở Hòa Pasteur` remains useful and specific, but it should no longer read as the top phở recommendation now that `Phở Lệ` carries the MICHELIN-backed District 5 comparison.

### Page Revised

- `city-hcmc-place-pho-hoa-pasteur`: demoted from 30/30 to 28/30 support listing.

Visible page direction:

- The page now frames Phở Hòa Pasteur as the central Pasteur Street southern-phở stop: broth, beef, herbs, bean sprouts, lime, sauces, and the fast rhythm of a busy shop.
- A new section, `Beside The District 5 Bowl`, explains the role split between central Phở Hòa and Bib Gourmand Phở Lệ.
- The related cards now render both `Phở Lệ` and `Hủ tiếu ở Thành phố Hồ Chí Minh`, so the page supports a phở choice and a broader Saigon noodle choice.

### Demotion Decision

Decision: keep, but do not lead.

Phở Hòa Pasteur still deserves to be in the app because it is recognizable, central, and dish-specific. It should not be the app's strongest phở signal while `Phở Lệ` carries a bounded 2025 MICHELIN Bib Gourmand reason to save a phở meal before the trip.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-hoa-pasteur-support-demotion/`

Representative page captured:

- `viet-family-city-hcmc-place-pho-hoa-pasteur`
  - `pho-hoa-pasteur-first-screen.jpg`: first viewport shows the revised `One Bowl On Pasteur` framing and the Useful Phrases section beginning immediately after the intro.
  - `pho-hoa-pasteur-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus `Phở Lệ` and `Hủ tiếu` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hcmc-place-pho-hoa-pasteur`
  - `--detail-page viet-family-city-hcmc-place-pho-hoa-pasteur --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for both scoped launches.

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
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/guard-native-only.js
git diff --check
```

Results:

- V2.2 projection and handwritten-copy import: PASS, 509 entries imported.
- native resource generation: PASS, 1756 families, 1774 phrases, 1767 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 509 entries, 509 `FINAL_PASS`.
- V2.2 voice drift audit: PASS after replacing negation-style heading language before final screenshots.
- city-copy compatibility validation: PASS, 5 hubs, 509 city noun pages, 509 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS, 509 city places, 815 city phrase tags, 0 release-blocking missing audio rows, 9003 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Phở Hòa Pasteur Support Demotion

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass makes the Saigon phở hierarchy clearer: Phở Hòa is still a useful central bowl, while Phở Lệ carries the stronger recognition-backed save. The next restaurant support pass should keep scanning 30/30 non-guide pages that are useful but less compelling than newer MICHELIN-backed or dish-specific additions.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.

## Continuation: Phở 10 Lý Quốc Sư Additive Hanoi Pilot

Twenty-fifth pass date: 2026-05-31

Commit before pass: `8a0ad3c1e Demote Pho Hoa Pasteur support listing`

This continuation adds a stronger Hanoi phở save rather than another support demotion. `Phở 10 Lý Quốc Sư` was already identified in the MICHELIN coverage audit as a missing high-priority candidate: a 2025 Bib Gourmand name that many visitors search before Hanoi.

### Page Added

- `city-hanoi-place-pho-10-ly-quoc-su`: new first-class V2.2 Hanoi restaurant page.

Visible page direction:

- The page frames Phở 10 Lý Quốc Sư as the obvious Hoan Kiem beef-pho save: clear broth, rice noodles, sliced beef, herbs, lime, and a quick counter meal near the Old Quarter.
- It links Mentioned Here to `Phở bò ở Hà Nội` so the named place has dish-level context.
- It renders `Phở Gia Truyền` and `Phở Bò Lâm` as Compare Nearby cards, so the page helps build a small Hanoi phở plan without claiming to be the only answer.

### Add Decision

Decision: add, and let it lead as a recognizable Hanoi phở save.

The page fills a real product gap: it gives a visitor a current, recognizable, MICHELIN-backed Hoan Kiem phở name that is easier to save before a trip than a generic beef-pho row alone. The visible copy keeps the award claim bounded to 2025 MICHELIN Bib Gourmand and avoids hours, address, booking, closure, or price claims.

Source support:

- Official MICHELIN Guide Vietnam 2025 PDF lists `Phở 10 Lý Quốc Sư (Hoan Kiem)` in the Hanoi Bib Gourmand section as noodles.
- Current MICHELIN venue page for `Phở 10 Lý Quốc Sư` carries Bib Gourmand status.

### Runtime Shape

- `docs/city-production/agent-inputs/hanoi-nouns.md`: added row `103`.
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`: added the authored V2.2 source object and a beef-pho dish-page related card.
- `content-draft/viet/city-library/app-detail-v2-2/_index.json`: current inventory is now 510 city noun/place pages.
- `native-ios/scripts/import-city-noun-intake.js` and `native-ios/scripts/validate-viet-city-copy.js`: city count expectations now allow HCMC 104, Hanoi 103, Da Nang 103, Hội An 100, Hue 100.

### Render Proof

Screenshot folder:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-10-ly-quoc-su-additive/`

Representative page captured:

- `viet-family-city-hanoi-place-pho-10-ly-quoc-su`
  - `pho-10-ly-quoc-su-first-screen.jpg`: first viewport shows the wrapped title, pronunciation line, `The Obvious Pho Save` intro, and Useful Phrases start.
  - `pho-10-ly-quoc-su-bottom-inset.jpg`: bottom-validation launch shows Mentioned Here plus `Phở Gia Truyền` and `Phở Bò Lâm` Compare Nearby cards above the bottom chrome.

Native simulator proof:

- Simulator: `SpeakLocal City Listings`
- Launch hooks:
  - `--detail-page viet-family-city-hanoi-place-pho-10-ly-quoc-su`
  - `--detail-page viet-family-city-hanoi-place-pho-10-ly-quoc-su --validate-bottom-inset-scroll-to-bottom`
- Build/run: PASS for the scoped build launch and the bottom-validation relaunch.

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

- city noun intake: PASS, Saigon 104 places, Hanoi 103 places, Da Nang 103 places, Hội An/Hue 100 each.
- V2.2 projection and handwritten-copy import: PASS, 510 entries imported.
- native resource generation: PASS, 1757 families, 1775 phrases, 1768 pages.
- SQLite fixture generation: PASS, integrity OK.
- strict V2.2 source validation: PASS, 510 entries, 510 `FINAL_PASS`.
- V2.2 voice drift audit: PASS.
- city-copy compatibility validation: PASS, 5 hubs, 510 city noun pages, 510 unique target heroes.
- tier-one listing validation: PASS, 150 strong / 0 needs-work.
- SQLite fixture validation: PASS after rerunning generation and validation serially, 510 city places, 816 city phrase tags, 0 release-blocking missing audio rows, 9010 relations.
- SQLite fixture test: PASS, 1 test.
- native-only guard: PASS.
- whitespace check: PASS.

### Remaining Risk After Phở 10 Lý Quốc Sư Add

Status remains below `GLOBAL_PRODUCTION_READY`.

This pass strengthens Hanoi phở coverage, but it does not settle every Hanoi restaurant hierarchy question. The next additive or support pass should compare remaining bún chả and bánh cuốn candidates against the current Hanoi set before adding more phở.

### Agent Lifecycle Note

No subagents were spawned or closed in this continuation. This pass used local source, voice, runtime, validator, and render gates only after prior real-agent lifecycle attempts froze.
