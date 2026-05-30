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

Bounded claims used:

- One MICHELIN Star in the 2025 guide: `Gia`, `Hibana by Koki`, `Tam Vi`, `Akuna`, `CieL`, `Coco Dining`, `Long Trieu`, plus existing `Anan Saigon` and `La Maison 1888`.
- MICHELIN Green Star in the 2025 guide: `Nen Danang`, `Lamai Garden`.
- Bib Gourmand source support noted where useful: `Uu Dam`, `Mien luon Chan Cam`, `Pho Bo Lam`.

Freshness note: these are 2025-guide claims. Re-check before release if a newer official Vietnam guide has been published.

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
- `city-danang-place-co-chu-nho`: support listing until the exact house dish or stronger reason is refreshed.
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
