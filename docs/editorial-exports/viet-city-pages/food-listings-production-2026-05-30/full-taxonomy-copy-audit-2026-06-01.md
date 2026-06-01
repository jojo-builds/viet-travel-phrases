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
- Continue the reliable single-page render harness over the remaining `285` pages, or split by offset into resumable batches that launch one page per xcodebuild invocation.
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
- Added `high-risk-taxonomy-proof-001-results.jsonl`: `20` high-risk pages, `60` screenshots, `0` failures. The slice covered arrivals, stations, markets, streets, beach, nature, museums, river, neighborhood, villages, port, dessert, and Hue landmarks.
- Text review after that render slice found and repaired several lines that still validated but read stiff on a phone: `street-spine role`, repeated `threshold`, and `name confusion resolved by boats`.
- Added `high-risk-humanized-rerun-results.jsonl`: `8` edited pages, `24` fresh screenshots, `0` failures after the humanization patch.
- Added `high-risk-taxonomy-proof-002-results.jsonl`: `30` under-covered city pages, `90` screenshots, `0` failures. The slice covered Hanoi, HCMC, Hội An, and Huế cafes, markets, museums, parks, streets, rivers, stations, ports, drinks, desserts, villages, and arrivals.
- Text review after that render slice found and repaired more validating-but-stiff transport framing: repeated `threshold` language and one `Choose...` lead.
- Added `high-risk-humanized-rerun-002-results.jsonl`: `4` edited pages, `12` fresh screenshots, `0` failures after the humanization patch.
- Added `hoian-hue-low-coverage-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures across Hội An and Huế beaches, rivers, museum/performance/street/assembly/cafe/restaurant/dish/shopping pages, plus Hue landmarks, restaurants, dishes, park, market, and cafe pages.
- Text review after that render slice found more validating-but-stiff copy. Repaired `spine` metaphors, directive `Choose...` leads, and duplicated summary clauses in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `hoian-hue-humanized-rerun-001-results.jsonl`: `12` edited pages, `36` fresh screenshots, `0` failures.
- Added `balanced-culture-city-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures across five-city museum, cafe, neighborhood, attraction, landmark, and market coverage.
- Text review after that render slice found phone-readable but still improvable copy: directive `Choose...` headings, duplicated `a few a few`, repeated `practical`, and one overly abstract cafe/museum mood line. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `balanced-culture-city-humanized-rerun-001-results.jsonl`: `6` edited pages, `18` fresh screenshots, `0` failures.
- Added `balanced-food-city-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures across restaurants, dish pages, cafes, markets, dessert/drink pages, and high-risk Da Nang mì Quảng comparison pages.
- Text review after that render slice found food-copy issues that passed render but needed human cleanup: directive `Choose...` phrasing, a missing verb in the seafood price warning, `Not Street Food`, `Drink Before Room`, `Fast Moving Meal`, and a leftover `The draw is more concrete` line. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `balanced-food-city-humanized-rerun-001-results.jsonl`: `7` edited pages, `21` fresh screenshots, `0` failures.
- Added `balanced-mobility-landmark-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures across five-city landmarks, attractions, streets, stations, nature, parks, and neighborhoods.
- Text review after that render slice found more validating-but-stiff phone copy: a sentence fragment on Hải Vân Pass, directive cyclo wording, `Ordinary Is Enough`, duplicated Đống Đa neighborhood guidance, and awkward Hội An bus-station grammar. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `balanced-mobility-landmark-humanized-rerun-001-results.jsonl`: `5` edited pages, `15` fresh screenshots, `0` failures.
- Combined latest-current proof across maintained result files is now `235` unique pages, `705` screenshots, and `0` current failures.

Remaining honest risks:

- The global V2.2 rendered proof gate is still open: `236` pages still need current screenshots unless the gate is explicitly amended.
- The cross-taxonomy auditor found large repeated phrase-card sets by taxonomy. Some repetition is expected for common travel actions, but high-traffic pages still need human-rendered review for phrase-card fit.
- Runtime taxonomy mismatches from the subagent hard-block list were repaired and rendered in the sample above. Related grouping should still be watched during the remaining screenshot pass, because older legacy metadata can still leak into shelves/search even when visible copy is strong.

## Ninth Repair Batch, 2026-06-01

This continuation followed the user screenshot feedback that unexplained terms such as `Bib Gourmand` are not acceptable for first-time U.S. travelers. The rule applied in source review: if a reader might not know whether a term is a dish, place, award, restaurant category, or local custom, explain it immediately or remove it and lead with concrete food, table, route, or place utility.

Read-only audit scope:

- Food: `214` pages across Restaurant, Dish, Market, Cafe, Dessert, and Drink.
- Culture / attraction: `191` pages across Landmark, Attraction, Museum, Park, Village, Shopping, and craft/shopping edge pages.
- Mobility / outdoor / place-feel: `118` pages across Arrival, Station, Street, Port, River, Beach, Nature, and Neighborhood.
- Local runtime inventory checked all `520` V2.2 pages and the generated `viet-authored-listing-pages.json` taxonomy groupings.

Repaired source classes:

- Screenshot-specific readability: `city-hcmc-place-banh-xeo-46a` no longer uses `Bib Gourmand`, award shorthand, or `restaurant version` language. The intro now explains the table experience in plain food terms.
- Food hard blockers: explained `mắm nêm`, `nhà rường`, and `cơm niêu`; removed `support choice`, `Heritage Dinner Role`, `Central Market Role`, `Simple Bowl Logic`, and similar app-architecture copy; softened cafe and restaurant role-language on Hội An and Huế pages.
- Culture/performance hard blockers: explained `tuồng` and `Nhã nhạc` as performance forms; swapped walking/direction phrases on theater/show pages to ticket, entrance, photo, and start-time phrases.
- Related-card mismatches: retargeted HCMC, Hội An, Huế, Đà Nẵng, and Hanoi fallback clusters where old cafe, ticket-booth, cyclo, airport-market, river, or jewelry-lane cards were rendering on unrelated pages.
- Mobility hard blockers: fixed airport, railway, metro, canal, river, street, and transfer pages with more fitting phrase cards, fresher verification flags, and less schematic `spine/service facts` language.

Validation after the ninth batch:

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
- Targeted hard-block text sweep against source and generated runtime: `0` hits for `Bib Gourmand`, `MICHELIN`, dining-insider shorthand, old schema headings, and the listed process-language phrases.

Rendered proof after the ninth batch:

- Added `subagent-hardblock-humanized-rerun-001-results.jsonl`: `33` repaired pages, `99` screenshots, `0` failures.
- The sample includes the user-flagged `city-hcmc-place-banh-xeo-46a`, food glossary fixes, culture/performance phrase-card fixes, airport/rail/metro/river/street mobility fixes, and the retargeted Hanoi street related-card cluster.
- Combined latest-current proof is now `244` unique pages, `732` latest screenshots, and `0` current failures across maintained result files.
- Remaining global proof gap: `276` pages still need current rendered screenshots unless the gate is explicitly amended.

## Tenth Proof / Humanization Batch, 2026-06-01

This batch continued the literal rendered proof gate and treated passing screenshots as necessary but not sufficient.

Rendered proof:

- Added `missing-pages-proof-001-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
- Scope: remaining Đà Nẵng museum, landmark, attraction, arrival, beach, restaurant, cafe, dish, neighborhood, market, street, and nature pages, plus a small Hanoi food run.

Human readability review:

- The rendered pages passed structurally, but text review still found stiff source patterns: `Choose it`, `carry the visit`, `support`, `stronger`, `are enough`, and a few abstract `draw` or `whether` lines.
- Repaired the affected authored V2.2 source pages, then regenerated handwritten copy, native resources, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added `missing-pages-humanized-rerun-001-results.jsonl`: `15` edited pages, `45` screenshots, `0` failures.

Updated proof state:

- Combined latest-current proof is now `284` unique pages, `852` screenshots, and `0` current failures.
- Remaining global proof gap: `236` pages still need current rendered screenshots unless the gate is explicitly amended.

## Eleventh Subagent Hard-Block Repair Batch, 2026-06-01

This batch followed another first-time-traveler readability pass. The user specifically called out `Bib Gourmand` as unexplained insider language: a U.S. visitor may not know whether it is a dish, a place, an award, or a restaurant category. The authoring rule remains: explain unfamiliar terms immediately in plain English or remove them and lead with concrete food, table, route, or place utility.

Fresh read-only subagent slices audited:

- Food-led pages: `214` Restaurant, Dish, Market, Cafe, Dessert, and Drink entries.
- Culture / attraction / landmark pages: `195` entries, with special attention to performance venues and wrong related-card links.
- Mobility / outdoor / place-feel pages: river, street, transfer, beach, station, and route-style entries.

Repaired source classes:

- Food hard blockers: Nu Eatery grammar, Vy's Market duplicate section job, CieL open-kitchen copy, Coco Dining sauce/table pacing, Long Triều dining-room wording, plus a Danang food readability slice that removed stiff `draw`, `carry`, `Choose it`, and `are enough` phrasing.
- Culture/performance hard blockers: Golden Dragon Water Puppet Theater, À Ố Show, Chợ Lớn walking route, Củ Chi day trip, Mỹ Sơn Sanctuary, and Hội An assembly hall related-card mismatches.
- Mobility/outdoor hard blockers: Saigon River boat phrase cards and Danang river/arrival/street/port pages with more natural route wording.
- Targeted residue cleanup: removed the remaining `carry the stop` phrase from a Hội An old-house page after a hard-block text sweep caught it in source and generated runtime.

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
- Targeted hard-block text sweep against source and generated runtime: `0` hits for `Bib Gourmand`, `MICHELIN`, dining-insider shorthand, old award terms, `restaurant version`, `recognition helps`, or `carry the stop`.

Rendered proof after this repair batch:

- Rebuilt `SpeakLocalNative` for testing on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- Added `subagent-hardblock-repair-002-results.jsonl`: `58` passing rows, `174` screenshots, `0` failures. This includes the 57-page current repair set plus one accidental but passing Espresso Station row caused by the proof script skipping an already-passed offset in the same result file.
- Added `subagent-hardblock-repair-003-results.jsonl`: `1` fresh rerun for `city-hoian-place-duc-an-old-house` after the final `carry the stop` cleanup, `3` screenshots, `0` failures.
- Combined latest-current proof is now `293` unique pages, `879` screenshots, and `0` current failures.
- Remaining global proof gap: `227` pages still need current rendered screenshots unless the gate is explicitly amended.

## Twelfth Missing-Page Proof / Hanoi Humanization Batch, 2026-06-01

This batch continued the literal rendered proof gate by taking the next `40` unproved pages from the manifest, rather than cherry-picking easier pages. The slice was entirely Hanoi because Hanoi was the first remaining city band in manifest order.

Rendered proof:

- Added `missing-pages-proof-002-results.jsonl`: `40` previously unrendered Hanoi pages, `120` screenshots, `0` failures.
- Scope included restaurant, drink, neighborhood, attraction, station, landmark, nature, market, dish, cafe, museum, and park pages. The slice covered the Hanoi phở cluster, French Quarter, Old Quarter, Ba Đình/temple landmarks, coffee pages, transit pages, and museum/market pages.

Human readability review:

- The rendered pages passed structurally, but text review still found validating-but-stiff language: `carry the visit`, `draw`, `register`, `spine`, plus the grammar error `A Eel-Noodle Bowl`.
- Repaired the affected authored V2.2 source pages in `hanoi.json`, then regenerated handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added `missing-pages-humanized-rerun-002-results.jsonl`: `18` edited Hanoi pages, `54` screenshots, `0` failures.

Updated proof state:

- Combined latest-current proof is now `333` unique pages, `999` screenshots, and `0` current failures.
- Remaining global proof gap: `187` pages still need current rendered screenshots unless the gate is explicitly amended.

## Thirteenth Missing-Page Proof / Hanoi-HCMC Humanization Batch, 2026-06-01

This batch continued the literal rendered proof gate with the next `40` unproved manifest pages. It completed the remaining Hanoi proof gap and moved into the first Saigon missing-page band.

Rendered proof:

- Added `missing-pages-proof-003-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
- Scope included Hanoi park, pagoda, lake, landmark, vegetarian restaurant, gallery, museums, theatre, market, street, dish, and park pages, then Saigon restaurant, market, dish, cafe, landmark, tunnel, museum, street, and central walk pages.

Human readability review:

- The rendered pages passed structurally, but text review still found copy that read like internal editorial shorthand on a phone: `carry`, `draw`, `spine`, stiff casing, and phrase cards that did not match the page moment.
- Repaired the affected authored V2.2 source in `hanoi.json` and `hcmc.json`, replacing abstract terms with concrete place, food, route, and room language.
- Repaired two phrase-card fit issues: Water Puppet Theatre now asks `What time does it start?`, and City Hall now uses directions instead of `One ticket, please`.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added `missing-pages-humanized-rerun-003-results.jsonl`: `23` edited pages, `69` screenshots, `0` failures.

Updated proof state:

- Combined latest-current proof is now `373` unique pages, `1119` latest-current screenshots, and `0` current failures.
- Remaining global proof gap: `147` pages still need current rendered screenshots unless the gate is explicitly amended.

## Fourteenth Missing-Page Proof / HCMC-Hội An-Huế Subagent Cleanup, 2026-06-01

This batch continued the literal rendered proof gate and folded in three read-only subagent audits focused on the remaining HCMC, Hội An, and Huế proof gaps. The editorial lens was the user screenshot objection: first-time U.S. travelers should never have to decode whether a term is an award, dish, place, transport mode, performance form, or app-internal label.

Rendered proof:

- Added `missing-pages-proof-004-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
- Scope completed the remaining Saigon proof gap and started the Hội An band: HCMC flower/food/cafe/market/street/landmark/shopping/park pages, then Hội An Ancient Town, bánh mì, bánh xèo, and Cẩm Châu.

Human readability review:

- HCMC repairs removed or softened `carry`, `draw`, `spine`, `support role`, and directive `Choose it` phrasing across Ho Thi Ky, hủ tiếu, L'Usine Thảo Điền, Phở Hòa Pasteur, Russian Market, Takashimaya/Saigon Centre, Vincom Đồng Khởi, The Workshop Coffee, and other rendered HCMC pages.
- Hội An repairs fixed wrong or weak related-card routes, old-house wording such as `threshold details`, generic phrase cards on Quan Cong Temple and countryside bicycle pages, and repeated `carry` language on food, craft, museum, and restaurant pages.
- Huế repairs fixed hard-block source wording such as `register`, `threshold`, and `visitor-quarter spine`, plus phrase-card mismatches and stiff `Choose it` lines on tomb, gate, river, bridge, vegetarian, lagoon, and street pages.
- Restaurant copy kept required researched menu signals while making them readable in context. L'Usine Thảo Điền now names eggs Benedict, squid ink crab pasta, a premium pho bowl, and salt caramel coffee as menu items.
- Targeted source/runtime scan is clean for `Bib Gourmand`, `MICHELIN`, and `Gourmand`.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Simulator build proof passed: `xcodebuild build-for-testing` for `SpeakLocalNative` on `SpeakLocal City Listings` returned `TEST BUILD SUCCEEDED`.

Updated proof state:

- Combined latest-current proof is now `413` unique pages, `1239` latest-current screenshots, and `0` current failures.
- Remaining global proof gap: `107` pages still need current rendered screenshots unless the gate is explicitly amended.
- Remaining by city: Hội An `51`, Huế `56`.
- Remaining by category: Neighborhood `7`, Dish `7`, Restaurant `12`, Nature `7`, Attraction `12`, Cafe `9`, Station `3`, Landmark `27`, Museum `9`, Market `8`, Street `5`, Village `1`.

## Fifteenth Missing-Page Proof / Hội An Render And Huế Preflight, 2026-06-01

This batch continued the literal rendered proof gate with the next `40` missing pages, while using fresh read-only agents to avoid proving pages that still had obvious first-time-traveler copy issues.

Rendered proof:

- Added `missing-pages-proof-005-results.jsonl`: `40` previously unrendered Hội An pages, `120` screenshots, `0` failures.
- Scope covered Hội An neighborhoods, dishes, restaurants, Cham Islands / boat pages, cooking/bicycle/lantern attractions, assembly hall / bridge / temple landmarks, museums, markets, streets, cafes, and workshop pages.

Human readability review:

- Hội An source was repaired before render: Cam Thanh no longer routes to the An Hội night-island card, Hainan Assembly Hall no longer carries stray Mỹ Sơn/Cham day-trip related copy, STREETS Restaurant Cafe uses restaurant phrases instead of coffee phrases, and Memories Land now uses ticket/start/meeting phrases.
- Additional Hội An cleanup removed directive `Choose...` phrasing, `Route Rather Than Attraction`, `reference point`, and abstract museum/boat wording from the rendered slice.
- Huế source was repaired before its upcoming render band: Trường Tiền Plaza naming, wrong royal-object museum related cards, southern bus station related routing, Imperial City `thresholds`, Huyen Tran `register`, Lang Thang directive phrasing, Le Ba Dang `draw/register`, Thanh Toan bridge casing, and Phu Cam Church related-card fit.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Simulator build proof passed before render: `xcodebuild build-for-testing` for `SpeakLocalNative` on `SpeakLocal City Listings` returned `TEST BUILD SUCCEEDED`.

Updated proof state:

- Combined latest-current proof is now `453` unique pages, `1359` latest-current screenshots, and `0` current failures.
- Remaining global proof gap: `67` pages still need current rendered screenshots unless the gate is explicitly amended.
- Remaining by city: Hội An `11`, Huế `56`.
- Remaining by category: Landmark `23`, Cafe `7`, Nature `5`, Museum `6`, Market `5`, Restaurant `5`, Village `1`, Dish `4`, Neighborhood `3`, Attraction `3`, Street `3`, Station `2`.

## Sixteenth Missing-Page Proof / Final Hội An And Huế Glossary-Readability Batch, 2026-06-01

This batch continued the literal rendered proof gate and folded in the explicit first-time U.S. traveler rule from Jojo's `Bib Gourmand` feedback: if a term may be unfamiliar, the copy must explain it immediately in plain English or remove it and lead with concrete food/place utility.

Rendered proof:

- Added `missing-pages-proof-006-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
- Scope covered the final `11` Hội An proof-gap pages and the first `29` Huế proof-gap pages: old houses, tea/coffee/farm pages, silk/tailor pages, Huế dishes, tombs, Citadel landmarks, art spaces, chay dining, royal-object museums, river/night-walk pages, and the Nine Dynastic Urns.

Human readability review:

- Two read-only subagents audited the exact batch before render.
- Hội An repairs explained or clarified `Sa Huynh`, social-mission teahouse language, training-restaurant language, preserved old merchant houses, and tailor-fitting flow. Old-house pages now relate to old houses instead of An Hội Bridge, and related-card subtitles no longer expose page/workflow wording.
- Huế repairs explained or clarified `Cơm âm phủ`, `Cơm hến`, the former private palace area of the Forbidden Purple City, Princess Huyền Trân, `chay` as Vietnam's Buddhist vegetarian food tradition, Nguyễn as Vietnam's last royal dynasty, Nam Giao as an open-air royal ceremony site, and the Nine Dynastic Urns as bronze urns honoring Nguyễn emperors.
- Additional cleanup removed `carry`, `draw`, `works as`, `reference point`, `route pairing`, `map point`, `axis/axial`, `not a`, and `works well` residues from the rendered slice.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Targeted source/runtime scan is clean for `Bib Gourmand`, `MICHELIN`, and `Gourmand`.
- Simulator build proof passed before render: `xcodebuild build-for-testing` for `SpeakLocalNative` on `SpeakLocal City Listings` returned `TEST BUILD SUCCEEDED`.

Updated proof state:

- Combined latest-current proof is now `493` unique pages, `1479` latest-current screenshots, and `0` current failures.
- Remaining global proof gap: `27` pages still need current rendered screenshots unless the gate is explicitly amended.
- Remaining by city: Huế `27`.
- Remaining by category: Landmark `8`, Market `3`, Nature `3`, Restaurant `3`, Attraction `2`, Station `2`, Museum `2`, Street `2`, Cafe `1`, Neighborhood `1`.
