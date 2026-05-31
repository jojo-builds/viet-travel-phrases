# Full Listing Copy Audit - 2026-06-01

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

Source head at audit start: `e4c3ae35b Mark city listings production ready`

Status: `NOT_PRODUCTION_READY`

## Decision

The current Viet listing copy is structurally valid, but not production-ready by the V2.2 editorial standard.

The previous `PASS_GLOBAL_PRODUCTION_READY` receipt was too narrow. It treated strict schema validation, voice-drift scans, and static runtime QA as approval evidence. Those gates are necessary, but they do not prove the actual copy is finished.

Production readiness still fails on:

- desire-diluted food and restaurant copy;
- phrase cards that are mapped and playable but wrong for the page moment;
- relationship-card copy and internal `reason` fields that still carry batch-repair language;
- generated phrase pages that are present but thin;
- repeated editor vocabulary such as `route`, `pace`, `counterpoint`, `when the day needs`, `signal`, `the point`, and `should lead`.

## Current Hierarchy

V2.2 app-detail source contains `520` entries across five cities:

- Đà Nẵng: `106`
- Hà Nội: `106`
- Saigon: `106`
- Hội An: `102`
- Huế: `100`

Top-level V2.2 categories:

| Category | Count |
|---|---:|
| Restaurant | 79 |
| Landmark | 76 |
| Attraction | 55 |
| Dish | 46 |
| Market | 40 |
| Cafe | 39 |
| Museum | 34 |
| Neighborhood | 28 |
| Street | 28 |
| Nature | 19 |
| Station | 16 |
| Park | 12 |
| Village | 9 |
| Beach | 8 |
| Arrival | 7 |
| River | 7 |
| Dessert | 6 |
| Drink | 5 |
| Port | 5 |
| Shopping | 1 |

Legacy runtime subcategories, used as the nearest subcategory layer in native resources:

- `food-coffee`: `226`
- `landmarks-attractions`: `226`
- `arrivals-routes`: `150`
- `neighborhoods-streets`: `99`
- `shopping-markets`: `82`
- `practical-help-near-places`: `43`

There is no explicit V2.2 `subcategory` or `subSubcategory` field in the app-detail source. The nearest sub-subcategory layer is runtime `placeKind`: `restaurant`, `dish`, `market`, `cafe`, `landmark`, `museum`, `experience`, `neighborhood`, `street`, `station`, `airport`, `nature`, `park`, `river`, `village`, `beach`, `attraction`, and `port`.

## Subagent Audit Summary

Four read-only subagents reviewed independent slices:

1. Food/desire: restaurants, cafes, dishes, drinks, desserts, markets.
2. Non-food places: attractions, landmarks, museums, streets, neighborhoods, transport, nature, beaches, parks, rivers, villages.
3. Phrase surfaces: generated phrase pages, canonical phrase pages, and V2.2 useful phrase cards.
4. Hierarchy/card graph: category coverage, related cards, Mentioned Here cards, and relationship subtitles.

Consensus:

- Inventory coverage is broad enough; copy quality is the blocker.
- Food pages often explain why the app included the page instead of making the place or dish feel worth remembering.
- MICHELIN-supported restaurant pages often lead with award status instead of sensory/table evidence.
- Some pages argue against themselves with lines such as `not the hidden food find`, `not a must-do`, or `do not build the plan around one dish`.
- Some phrase cards are objectively wrong for the moment, even though they are mapped and playable.
- Relationship-card `displaySubtitle` fields are improved, but many still use stiff `when X should...` phrasing.
- Internal `reason` fields still contain production-process text such as `now has an authored related-card role` and `replacing generic same-city pacing copy`.

## High-Priority Failure Classes

### 1. Wrong Phrase Cards

These are production blockers because they teach the wrong traveler move:

- `city-hoian-place-espresso-station`: cafe page had pickup/ticket/transport cards.
- `city-hoian-place-trade-ceramics-museum`: museum page had shopping/bargaining cards.
- `city-danang-place-vincom-plaza`: fixed-price mall page had bargaining.
- `city-hcmc-place-takashimaya-saigon-centre`: fixed-price mall page had bargaining.
- `city-hue-place-me-xung`: gift sweet page had bargaining and one-portion food language instead of gift/packing language.
- `city-hanoi-place-hom-market`: fabric/household market had food-order language.
- `city-hoian-place-tailor-fitting`: fitting page had generic bargain/pay cards instead of fitting/pickup/alteration language.
- `city-hoian-place-pottery-workshop`: craft workshop had bargaining-first language.
- `city-hoian-place-silk-village`: craft/process page had bargaining-first language.
- `city-hcmc-place-cafe-hop-nguyen-hue`: cafe-apartment page had only direction cards.
- `city-danang-place-ba-na-cable-car`: cable-car page foregrounded `Can I walk there?`.
- `city-hanoi-place-opera-house`: performance venue used closing-time framing instead of ticket/start/meeting-point framing.

### 2. Food Desire Dilution

High-priority pages called out by audit:

- `city-hoian-place-morning-glory`
- `city-hoian-place-vys-market`
- `city-hanoi-place-bun-cha-huong-lien`
- `city-hanoi-place-pho-gia-truyen`
- `city-danang-place-bun-cha-ca-hon`
- `city-danang-place-banh-canh-yen`
- `city-danang-place-mi-quang-1a`
- `city-danang-place-la-maison-1888`
- `city-hanoi-place-gia`
- `city-hanoi-place-tam-vi`
- `city-hcmc-place-anan-saigon`
- `city-hoian-place-the-field`
- `city-hue-place-tinh-gia-vien`
- `city-hue-place-ancient-hue-restaurant`
- `city-hue-place-song-huong-floating-restaurant`
- `city-danang-place-43-factory`
- `city-danang-place-wonderlust`
- `city-hoian-place-rosies-cafe`
- `city-hue-place-mandarin-coffee-restaurant`
- `city-danang-place-long-coffee`
- `city-hanoi-place-dong-xuan`
- `city-hue-place-dong-ba`
- `city-danang-place-le-duan-night-market`
- `city-hcmc-place-che`
- `city-hoian-place-mot-herbal-drink`
- `city-danang-place-hai-san`
- `city-hcmc-place-oc`
- `city-hoian-place-banh-mi-phuong`
- `city-hoian-place-madam-khanh`
- `city-danang-place-my-quang-ba-mua`

Common repair direction:

- lead with sensory/table/place evidence before credentials;
- remove app-rationale words like `useful`, `signal`, `memory hook`, and `the point`;
- soften or remove anti-desire framing;
- make dish pages taste like texture, order, table rhythm, and first move.

### 3. Non-Food Voice Drift

High-priority pages called out by audit:

- `city-hue-place-dien-tho-palace`
- `city-hanoi-place-botanical-garden`
- `city-hoian-place-cam-kim-island`
- `city-hanoi-place-national-museum-history`
- `city-hoian-place-cham-islands`
- `city-hcmc-place-cafe-hop-nguyen-hue`
- `city-hcmc-place-independence-palace`
- `city-hue-place-duc-duc-tomb`
- `city-danang-place-son-tra`
- `city-hanoi-place-nuoc-ngam-bus-station`
- `city-hcmc-place-mien-dong-bus-station`
- `city-danang-place-my-an-beach`
- `city-hcmc-place-bach-dang-wharf`
- `city-hanoi-place-cho-buoi-market`
- `city-hue-place-tam-giang-lagoon`
- `city-hoian-place-an-hoi-island`
- `city-danang-place-bach-dang-street`
- `city-hoian-place-tra-que`
- `city-danang-place-yen-retreat`
- `city-hanoi-place-west-lake-loop`
- `city-hanoi-place-dong-da`
- `city-hoian-place-ancient-town`
- `city-hoian-place-cam-thanh-coconut-village`
- `city-hcmc-place-ben-thanh-market`
- `city-hoian-place-japanese-bridge`

Common repair direction:

- replace abstract contrast words with physical evidence;
- make first moves concrete;
- remove visible-sounding process language such as `route`, `counterpoint`, `day needs`, and `pace` when it reads like prompt scaffolding.

### 4. Relationship/Card Source Debt

Measured source state:

- `578` renderable related-place candidates.
- `72` renderable Mentioned Here candidates.
- `329` candidate `reason` fields still contain `now has an authored related-card role`.
- `330` candidate `reason` fields still contain `replacing generic same-city pacing copy`.
- `146` card snippets use stiff `when X should...` phrasing.
- `56` card snippets use `need/needs` phrasing that often reads like workflow copy.

The worst concrete bug found:

- `city-danang-place-3d-art-in-paradise` has a related card to `Bảo tàng Mỹ thuật Đà Nẵng`, but the internal reason says: `Han Market gives Lotte Mart a true local-market contrast...`

This is not visible copy if the app correctly renders `displaySubtitle`, but it proves the relationship layer still contains copied repair residue.

## First Repair Batch

The first implementation batch should fix:

1. the objectively wrong phrase-card sets above;
2. the obviously stale relationship reasons and save-language residues;
3. a small set of food pages where the fix is clear and source-safe.

After that, rerun projection:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
```

Then validate:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
git diff --check
```

Final production-ready status remains blocked until repaired pages and representative rendered screens pass review.

## Second Repair Batch - 2026-06-01

Status: `IN_PROGRESS_NOT_PRODUCTION_READY`

This batch used fresh read-only subagent audits against `a380fcf28` for food, non-food, and phrase-card surfaces. It repaired the highest-confidence current blockers they found:

- removed the audited visible editor-language patterns from V2.2 app-detail source for `useful`, `signal`, `the point`, `counterpoint`, `day needs`, `should lead`, `should be`, and `do not build` where those phrases read like scaffolding rather than traveler copy;
- retargeted fixed-price mall cards for `city-hanoi-place-trang-tien-plaza` and `city-hcmc-place-vincom-dong-khoi` to card/bag/bathroom instead of bargaining;
- retargeted coffee-route cards for `city-hanoi-place-coffee-hop` and `city-hanoi-place-trieu-viet-vuong-coffee-street`;
- retargeted class/craft/water-food cards for `city-hoian-place-cooking-class`, `city-hoian-place-handicraft-workshop`, and `city-hue-place-lagoon-seafood-boat`;
- tightened non-food pages called out by subagents, including `city-hoian-place-cam-kim-island`, `city-hcmc-place-cafe-hop-nguyen-hue`, `city-danang-place-son-tra`, `city-danang-place-yen-retreat`, `city-hanoi-place-dong-da`, and `city-hue-place-tam-giang-lagoon`;
- fixed the `v900-tran-where-can-i-buy-a-ticket` tap-through risk by mapping the singular transport ticket phrase to the existing authored ticket-buying page `viet-phrase-v500-sigh-acti-where-can-i-buy-tickets`, avoiding a duplicate canonical page for the same Vietnamese sentence.

Validation after this batch:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
node scripts/guard-native-only.js
git diff --check
```

All commands above passed. `audit-viet-listing-production-qa.js` still reports `0` blockers, `0` majors, `1` duplicate hero section hidden at render time, and `500` missing-audio priority rows with no release-blocking missing-audio rows from SQLite validation.

Remaining production-readiness work is still real: repeated generic phrase-card sets remain too broad at scale, generated phrase pages still need a thinness pass, and representative simulator-rendered review has not yet proven the full set.

## Third Repair Batch - 2026-06-01

Status: `IN_PROGRESS_NOT_PRODUCTION_READY`

This batch used two fresh read-only audits against `b14bdc008`:

- high-use generated phrase pages: ticket buying, walking, less sugar, hot coffee, recommendations, and pack-for-travel;
- the exact repeated food phrase-card set `food-menu | food-1 | food-3`.

Repairs completed:

- enriched the six high-use canonical phrase pages so their source copy teaches the actual traveler moment instead of generic catalog-promoted scaffolding;
- corrected bad breakdown copy for `less sugar` and `pack it for travel`;
- added explicit language-risk notes where the current phrase string is understandable but may deserve native-language/audio review before a final polish pass;
- retargeted `32` high-risk food listings away from the generic menu/one-portion/not-spicy set:
  - fine dining and MICHELIN-supported restaurants now use wait/table, recommendation, dish-content, seating, and bill/card phrases;
  - seafood-by-weight pages now use per-kilo/price confirmation and table utility phrases;
  - dessert pages now use less-sugar/one-more/to-go phrases instead of `not spicy`;
  - `city-hue-place-lien-hoa-vegetarian` now foregrounds vegetarian/no-meat/recommendation phrases;
  - service-led restaurants such as `city-danang-place-fatfish`, `city-danang-place-madame-lan`, `city-hoian-place-cargo-club`, `city-hoian-place-mango-mango`, `city-hoian-place-the-field`, and `city-hue-place-song-huong-floating-restaurant` now use seating/recommendation/bill phrases.

Current repeated-set state after the batch:

- exact `food-menu | food-1 | food-3` count is down from `85` to `53`;
- remaining count by category: `33` Dish, `20` Restaurant, `0` Dessert;
- remaining count by city: Đà Nẵng `17`, Saigon `15`, Hội An `8`, Huế `13`, Hà Nội `0`.

The remaining repeated cards are mostly simple dish/stall pages where menu, one portion, and not spicy are production-safe as a temporary default, but they are still a good target for a later full phrase-card polish pass.

Validation after this batch:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
node scripts/guard-native-only.js
git diff --check
```

All commands above passed. `audit-viet-listing-production-qa.js` reports `0` blockers, `0` majors, `1` duplicate hero section hidden at render time, and `500` missing-audio priority rows. SQLite validation reports `0` release-blocking missing-audio rows.

Rendered simulator spot-check after this batch:

- built and launched `SpeakLocalNative` on simulator `SpeakLocal City Listings`;
- checked `viet-family-city-hcmc-place-anan-saigon`: revised table/recommendation/bill cards render and the intro/sections read cleanly;
- checked `viet-family-city-danang-place-be-man`: seafood-by-weight price cards render in the first screen;
- checked `viet-family-city-danang-place-che-xoa-xoa-hat-luu`: dessert page renders less-sugar instead of not-spicy;
- checked `viet-phrase-v900-food-drin-less-sugar-please`: rendered page now explains `đường` as sugar, not street;
- checked `viet-phrase-v900-shop-can-you-pack-it-for-travel`: long title renders without clipping;
- checked `viet-family-city-hue-place-lien-hoa-vegetarian`: initial no-meat phrase was too long in the compact card, so it was retargeted from `v900-food-drin-can-i-order-this-without-meat` to shorter ready phrase `food-premium-no-meat`, rebuilt, and rechecked successfully.

Remaining production-readiness work: broaden simulator-rendered review across more categories, and sample the remaining dish/stall repeated cards before a final production-ready receipt is restored.
