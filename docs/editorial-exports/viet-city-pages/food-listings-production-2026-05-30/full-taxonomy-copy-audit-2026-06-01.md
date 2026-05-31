# Full Taxonomy Copy Audit - 2026-06-01

Status: `SOURCE_VALIDATED_RENDER_PROOF_STILL_REQUIRED`

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`  
Branch: `feature/city-listings-production-ready`  
Starting commit for this audit wave: `519b91652`

## Scope

Audited the first-class V2.2 source objects in:

`content-draft/viet/city-library/app-detail-v2-2/*.json`

Inventory checked:

- total V2.2 entries: `520`
- cities: Da Nang `106`, Hanoi `106`, Saigon `106`, Hoi An `102`, Hue `100`
- top-level categories: Arrival `7`, Attraction `55`, Beach `8`, Cafe `38`, Dessert `6`, Dish `46`, Drink `5`, Landmark `77`, Market `40`, Museum `34`, Nature `19`, Neighborhood `28`, Park `12`, Port `5`, Restaurant `79`, River `7`, Shopping `1`, Station `16`, Street `28`, Village `9`

Subcategory context was cross-checked through generated runtime fields in:

`native-ios/Resources/viet-authored-listing-pages.json`

That generated layer exposes `categoryIDs` and `cityMetadata` such as `subcategoryID`, `pageKind`, `placeKind`, and `contentRole`. It is evidence for Browse/runtime grouping, not the copy authority.

## Auditor Slices

Read-only subagents covered:

- Food slice: Restaurant, Dish, Cafe, Drink, Dessert, Market
- Culture/Attraction slice: Landmark, Attraction, Museum, Park, Shopping
- Mobility/Route slice: Arrival, Station, Street, Port, River
- Place-feel slice: Nature, Beach, Village, Neighborhood

Local scans also flagged formula density, visible process language, related-card residue, and category/card mismatch candidates.

## Current Finding

The source copy is much closer, and the current regeneration/validation chain passes. The full production-ready claim is still not complete because the V2.2 rendered screenshot proof gate has not been promoted from representative review to a final 520-page receipt.

Validators and structural gates can pass while visible copy still reads like content architecture, inventory balancing, or generated routing. The user screenshot of `city-hcmc-place-banh-xeo-46a` confirmed this: the page was coherent but stiff, with phrases such as `A Dish-Specific Meal`, `recognition helps`, and `carry the stop`.

Second screenshot review tightened the reader-assumption bar again: unexplained food-guide awards such as `Bib Gourmand`, `MICHELIN Selected`, or `One MICHELIN Star` cannot appear as insider shorthand. If visible copy uses one, it must explain the term in plain English at the point of use, and if the award is not essential to the traveler decision, omit it and lead with the food, room, table, route, or practical reason to care.

## Hard Blockers Found

### Food / Restaurant / Dish

- `city-hcmc-place-42-nguyen-hue-apartment` and `city-hcmc-place-cafe-apartment-nguyen-hue`: near-duplicate same-building loop with confusing cross-related cards.
- `city-hoian-place-com-ga-ba-buoi`: visible story copy explained catalog coverage instead of traveler desire.
- `city-hanoi-place-banh-cuon-ba-xuan`: story/related copy described coverage balancing.
- `city-hcmc-place-bun-bo-hue-14b`: visible copy described app coverage instead of Saigon bowl desire.
- `city-hcmc-place-bo-kho-ganh`: visible copy described filling a missing lane and a save reason.
- `city-danang-place-bep-cuon`: visible copy used abstract `worth remembering` logic.
- `city-danang-place-fatfish`: copy undercut the restaurant as not really food-led.
- `city-hanoi-place-bun-cha` and `city-hue-place-banh-bot-loc`: related-card subtitles exposed app mechanics.
- `city-hcmc-place-banh-xeo-46a`: screenshot-confirmed stiff, architecture-like copy that needed humanization.
- Award-language audit after the second screenshot found visible guide/award language on `58` V2.2 source pages: `52` Restaurant pages and `6` Dish pages. This is a human-readability blocker unless each line explains the award in ordinary traveler terms at the point of use. The production copy pass chose the safer traveler-first fix: remove award shorthand when the food, room, table, route, or practical choice already explains why the page matters.

### Mobility / Route

- `city-danang-place-domestic-terminal`: phrase card used `Where is immigration?` on a domestic-terminal page.
- `city-hcmc-place-ben-thanh-metro-station`: phrase card used a bus-route phrase on a metro-station page.
- Hue station pages used airport-specific pickup intent for non-airport transport pages.
- `city-hoian-place-from-danang-airport`: freshness-sensitive fare/pickup-zone/timing wording.

### Culture / Attraction

- Large related-card fallback clusters rendered generic wrong-context cards, especially:
  - Da Nang landmarks pointing to Ba Na Hills
  - Da Nang attractions pointing to Ba Na cable car
  - Hue landmarks pointing to An Dinh Palace
  - HCMC attractions pointing to Nguyen Hue coffee hop
- Performance/culture pages are misclassified in generated metadata as museum-like pages, which can distort subcategory context.
- `city-hoian-place-reaching-out-arts-crafts`: craft-shop page was grouped like a market and related to An Bang Beach.
- `city-danang-place-3d-art-in-paradise`: copy was thin and a little cynical.
- `city-hoian-place-ancient-town-ticket-booth`: ticket-booth copy referenced a `coffee counter` in a first-move section.

### Place-Feel

- `city-hoian-place-cua-dai-beach`: phrase cards were ferry/island logistics, not beach use.
- `city-hoian-place-kim-bong-carpentry-village`: visible generated wording: `Wood Becomes practical` / `Watch Wood Turn practical`.
- `city-danang-place-hai-chau-district`: visible grammar error: `The district help`.
- `city-hoian-place-tra-nhieu-village`: imported `pottery context` into a bamboo/fishing-net village page.

## First Repair Batch Started

Applied source repairs for:

- `city-hcmc-place-banh-xeo-46a`
- `city-hoian-place-com-ga-ba-buoi`
- `city-hanoi-place-banh-cuon-ba-xuan`
- `city-hcmc-place-bun-bo-hue-14b`
- `city-hcmc-place-bo-kho-ganh`
- `city-danang-place-bep-cuon`
- `city-danang-place-fatfish`
- `city-hanoi-place-bun-cha`
- `city-hue-place-banh-bot-loc`
- `city-hcmc-place-42-nguyen-hue-apartment`
- `city-hcmc-place-cafe-apartment-nguyen-hue`
- `city-danang-place-domestic-terminal`
- `city-hcmc-place-ben-thanh-metro-station`
- `city-hue-place-northern-bus-station`
- `city-hue-place-railway-station`
- `city-hue-place-southern-bus-station`
- `city-hoian-place-from-danang-airport`
- `city-danang-place-3d-art-in-paradise`
- `city-hoian-place-ancient-town-ticket-booth`
- `city-hoian-place-reaching-out-arts-crafts`
- `city-hoian-place-cua-dai-beach`
- `city-hoian-place-kim-bong-carpentry-village`
- `city-danang-place-hai-chau-district`
- `city-hoian-place-tra-nhieu-village`

Also repaired the most obviously wrong generic related-card fallback clusters with page-specific route/comparison cards instead of rendering wrong context.

## Validation After Repair Batch

Regenerated and validated after the source repairs:

- `node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js`: wrote `520` V2.2 entries across `5` cities.
- `node native-ios/scripts/import-viet-city-handwritten-copy.js`: imported `520` handwritten city copy entries.
- `node native-ios/scripts/generate-viet-catalog.js`: wrote `1767` families and `1785` phrases.
- `node native-ios/scripts/generate-authored-tier-one-pages.js`: wrote native authored listing pages.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`: SQLite `integrity_check: ok`.
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`: `PASS` for all `520` entries.
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`: `failures: []`.
- `node native-ios/scripts/validate-viet-city-copy.js`: passed `5` hubs, `520` city noun pages, `520` unique target heroes.
- `node native-ios/scripts/validate-viet-city-library.js`: passed `826` pages.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: `ok: true`, `0` release-blocking missing-audio rows.
- `node native-ios/scripts/audit-viet-listing-production-qa.js`: `0` blockers, `0` majors.
- `node scripts/guard-native-only.js`: passed.
- `git diff --check`: passed.

Screenshot-driven humanization check:

- `city-hcmc-place-banh-xeo-46a` now renders generated copy around concrete table behavior: wide hot pancake, herbs, lettuce, sauce, first bite, and ingredient checks. The previous screenshot phrases `The Plate Needs Space`, `A Dish-Specific Meal`, `table attention`, `Bib Gourmand`, and `carry the stop` no longer appear in the generated native page.
- Follow-on voice cleanup removed the remaining validator/voice-audit catches: `it fits` on Cơm Gà Bà Buội, over-threshold `belongs`, top/best-style claims, and `good when` formula phrasing.

Award/jargon readability cleanup:

- Read-only follow-up slices reviewed the award-heavy restaurant/dish pages in Da Nang, Hanoi, and HCMC after the user flagged `Bib Gourmand` as unexplained insider language.
- The visible copy scan was expanded beyond the first count and found `58` pages with hard award/guide or dining-insider language in visible fields.
- Repaired the class across V2.2 source and projected layers: no visible `Bib Gourmand`, `MICHELIN`, `Green-Star`, `Service Award`, `promoted`, `sommelier`, `tasting-menu`, `Asian Contemporary`, `French Contemporary`, `support role`, or `source inventory` phrasing remains in the audited app-detail visible fields.
- The scan result after repair is `0` visible award-or-hard-jargon pages. The intended authoring rule is now explicit: first-time travelers should not have to decode guide taxonomy before understanding the page.

Rendered proof expansion after this batch:

- Added an environment-driven native UI-test harness: `CityAppDetailV22RenderProofUITests/testCaptureCityAppDetailV22RenderProofBatch`.
- Added a `520`-page manifest at `render-proof-2026-06-01-v2-2-global/v2-2-render-proof-manifest.json`.
- Ran a category-balanced proof batch on simulator `SpeakLocal City Listings`: `25` pages, `75` screenshots, `0` failures.
- The batch covered all `20` top-level categories, the screenshot-feedback page `city-hcmc-place-banh-xeo-46a`, and one restaurant page in each non-Da Nang city.
- Bánh Xèo 46A native proof now exists at `render-proof-2026-06-01-v2-2-global/screenshots-single-223/`.
- Added award/jargon repair proof batches:
  - `award-jargon-repair-results.jsonl`: `12` Da Nang pages, `36` screenshots, `0` failures.
  - `award-jargon-cross-city-results.jsonl`: `10` cross-city restaurant/dish pages, `30` screenshots, `0` failures.
  - Con Market was rerun after the bottom-proof relaunch patch and now passes with `3` screenshots.
  - Combined unique rendered proof rows across the current result files: `52` pages, `156` screenshots, `0` current failures.
- Multi-page-in-one-test runs are unstable on this simulator; single-page xcodebuild invocations are the reliable path for the remaining `495` pages.

## Remaining Work

- Promote the rendered proof gate: either literal top/scrolled screenshots for all `520` V2.2 pages or an explicit amended receipt standard that accepts full source/runtime text review plus representative rendered proof.
- Continue the reliable single-page render harness over the remaining `468` pages, or split by offset into resumable batches that launch one page per xcodebuild invocation.
- Continue targeted rendered review for street `spine/line` repetition, high-traffic beach/nature phrase-card fit, performance page first-move copy, and remaining hub-biased related-card feel.
- If rendered review finds copy that reads stiff on-device, repair it in `content-draft/viet/city-library/app-detail-v2-2/*.json`, then run the full regeneration/validation chain again.

## Full Taxonomy Re-Audit And Hard-Block Repair - 2026-06-01

Status after this pass: `SOURCE_RUNTIME_VALIDATED_RENDER_PROOF_EXPANDED_GLOBAL_PROOF_STILL_OPEN`.

Jojo rejected the narrower award-jargon checkpoint as insufficient. The re-audit therefore treated V2.2 production readiness as a taxonomy-wide copy problem, not a single-term cleanup.

Independent read-only subagents audited:

- Food: `214` pages across Restaurant `79`, Dish `46`, Market `40`, Cafe `38`, Dessert `6`, Drink `5`.
- Culture / attraction: `216` pages across Landmark `77`, Attraction `55`, Museum `34`, Neighborhood `28`, Park `12`, Village `9`, Shopping `1`.
- Mobility / route / outdoor: `90` pages across Arrival `7`, Station `16`, Street `28`, Port `5`, River `7`, Beach `8`, Nature `19`.
- Cross-taxonomy repetition / mobile readability / card-copy scan: all `520` V2.2 source entries and `1,778` generated runtime pages.

Runtime subcategory coverage checked during the local inventory pass:

- `food-coffee`: `174`
- `landmarks-attractions`: `223`
- `neighborhoods-streets`: `56`
- `shopping-markets`: `39`
- `arrivals-routes`: `28`

Hard-block classes found:

- Food copy that still read like support architecture or dining-insider notes: Dai Nam Restaurant, Hội An wonton, Boulevard Gelato & Coffee, Wonderlust, Phá lấu, and Mặn Mòi.
- Culture/attraction related-card mismatch: seven HCMC museum pages were pointing to the same Áo Dài Museum subtitle even when the page was medicine history, war history, or city history.
- Mobility/outdoor mismatch and freshness risk: Train Street access wording, Bạch Đằng Waterbus and Bến Thành Metro related cards, Hue nature pages using the same Lập An Lagoon fallback, beach/nature phrase-card fit, Cửa Đại Estuary first move, and Perfume River timing/performance wording.
- Cross-taxonomy systematic issues: repeated phrase-card sets by taxonomy, reason-like internal card fields, near-duplicate page pairs, and mobile readability risks. These are not all fixed globally yet, but the hard-block examples from the independent slices were repaired.

Repaired source pages in this batch:

- Food hard blockers: `city-hue-place-dai-nam-restaurant`, `city-hoian-place-wonton`, `city-danang-place-boulevard-gelato-coffee`, `city-danang-place-wonderlust`, `city-hcmc-place-pha-lau`, `city-hcmc-place-man-moi`.
- HCMC museum related-card cluster: `city-hcmc-place-fine-arts-museum`, `city-hcmc-place-fito-museum`, `city-hcmc-place-history-museum`, `city-hcmc-place-ho-chi-minh-city-museum`, `city-hcmc-place-ton-duc-thang-museum`, `city-hcmc-place-war-remnants-museum`, `city-hcmc-place-southern-women-museum`.
- Mobility/outdoor hard blockers and high-risk pages: `city-hanoi-place-train-street`, `city-hcmc-place-bach-dang-waterbus-station`, `city-hcmc-place-ben-thanh-metro-station`, `city-hue-place-ngu-binh-mountain`, `city-hue-place-ru-cha-mangrove`, `city-hue-place-tam-giang-lagoon`, `city-hue-place-vong-canh-hill`, `city-danang-place-man-thai-beach`, `city-danang-place-my-khe`, `city-danang-place-non-nuoc-beach`, `city-hoian-place-cua-dai-beach`, `city-hoian-place-bay-mau-coconut-forest`, `city-hoian-place-cua-dai-estuary`, `city-hue-place-perfume-river`.
- Local scan residue fixes: `city-danang-place-ba-na-cable-car`, `city-hcmc-place-cu-chi-day-trip`, `city-hcmc-place-cu-chi-tunnels`, `city-hoian-place-nu-eatery`, `city-hoian-place-silk-village`, `city-hoian-place-white-rose-dumplings`, `city-hoian-place-white-rose-restaurant`, plus visible voice-audit cleanup on `city-danang-place-golden-bridge`, `city-danang-place-son-tra-wildlife-drive`, `city-hanoi-place-bun-cha-huong-lien`, `city-hcmc-place-notre-dame`, `city-hoian-place-bale-well`, `city-hue-place-ancient-space-restaurant`, `city-hue-place-duyet-thi-duong-theater`, and `city-hue-place-le-ba-dang-art-center`.
- Runtime taxonomy repair: corrected generated grouping metadata for `city-danang-place-nguyen-hien-dinh-tuong-theatre`, `city-hanoi-place-vietnam-circus`, `city-hanoi-place-vietnam-national-tuong-theatre`, `city-hcmc-place-golden-dragon-water-puppet`, `city-hcmc-place-opera-a-o-show`, `city-hue-place-duyet-thi-duong-theater`, `city-hcmc-place-42-nguyen-hue-apartment`, and `city-hoian-place-reaching-out-arts-crafts`. These no longer project as museum/market-like pages from legacy runtime metadata.

Validation after this repair batch:

- `node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js`: wrote `520` entries across `5` cities.
- `node native-ios/scripts/import-viet-city-handwritten-copy.js`: imported `520` handwritten city copy entries.
- `node native-ios/scripts/generate-viet-catalog.js`: wrote `1767` families and `1785` phrases.
- `node native-ios/scripts/generate-authored-tier-one-pages.js`: wrote native authored listing pages.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`: SQLite `integrity_check: ok`.
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`: `PASS` for all `520`.
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`: `failures: []`.
- `node native-ios/scripts/validate-viet-city-copy.js`: passed `5` hubs, `520` city noun pages, `520` unique target heroes.
- `node native-ios/scripts/validate-viet-city-library.js`: passed `826` pages.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: `ok: true`, `0` release-blocking missing-audio rows.
- `node native-ios/scripts/audit-viet-listing-production-qa.js`: `0` blockers, `0` majors.
- `node scripts/guard-native-only.js`: passed.
- `git diff --check`: passed.

Rendered proof after this repair batch:

- Rebuilt `SpeakLocalNative` for testing on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- Added `taxonomy-hardblock-repair-results.jsonl`: `10` repaired pages, `30` screenshots, `0` failures.
- Repaired pages rendered in this sample: Boulevard Gelato & Coffee, Wonderlust, Mặn Mòi, Phá lấu, Hội An wonton, Đại Nam Restaurant, Hanoi Train Street, Bến Thành Metro Station, War Remnants Museum, and Perfume River.
- Added `taxonomy-runtime-repair-results.jsonl`: `8` taxonomy-repaired pages, `24` screenshots, `0` failures.
- Runtime-taxonomy pages rendered in this sample: Nguyễn Hiển Dĩnh Tuồng Theatre, Vietnam Central Circus, Vietnam National Tuồng Theatre, Golden Dragon Water Puppet Theater, À Ố Show, Duyệt Thị Đường Royal Theater, 42 Nguyễn Huệ apartment building, and Reaching Out Arts & Crafts.
- Combined current proof across maintained result files is now `67` unique pages, `252` screenshots, and `0` current failures.

Remaining honest risks:

- The global V2.2 rendered proof gate is still open: `453` pages still need current screenshots unless the gate is explicitly amended.
- The cross-taxonomy auditor found large repeated phrase-card sets by taxonomy. Some repetition is expected for common travel actions, but high-traffic pages still need human-rendered review for phrase-card fit.
- Runtime taxonomy mismatches from the subagent hard-block list were repaired and rendered in the sample above. Related grouping should still be watched during the remaining 453-page screenshot pass, because older legacy metadata can still leak into shelves/search even when visible copy is strong.
