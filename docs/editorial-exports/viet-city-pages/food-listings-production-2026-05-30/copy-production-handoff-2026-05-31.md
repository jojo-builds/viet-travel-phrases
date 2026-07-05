# Copy Production Handoff - 2026-05-31

## Where To Continue

Open this folder for the next copy-production session:

`/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch:

`feature/city-listings-production-ready`

Use the root app-family docs plus:

- `AGENTS.md`
- `native-ios/AGENTS.md`
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/production_readiness_review.md`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/copy-production-handoff-2026-05-31.md`

Do not continue this work from the Browse UI lane. Browse can be used for rendered review, but the copy source of truth is this city-listings feature lane.

## Current Product Direction

SpeakLocal Vietnam is not trying to be a language course. The listing copy should make Vietnam feel vivid, searchable, and easy to act on: places, dishes, restaurants, cafes, drinks, routes, and phrases worth remembering before or during a trip.

The page should make something feel worth saving without saying "save this." Avoid app-internal phrasing such as "counter to save," "route the user," "same-city comparison," or copy that assumes the reader already knows Vietnamese venue names.

Voice target:

- shorter, sharper, observed, adult, calm, useful;
- concrete details over broad travel adjectives;
- U.S.-based English-speaking traveler lens;
- no default template across restaurants, food pages, city pages, drinks, cafes, markets, and phrase pages.

## What This Checkpoint Changed

- Repaired remaining generic related-card copy across Da Nang, Hanoi, Saigon, and Hoi An after the earlier Hue pass.
- Removed visible generic related-card patterns such as "same-city," "different pace," and save-instruction style language from authored related cards.
- Tightened a few visible non-related residues where "different pace" or "counter" language sounded unnatural.
- Restored the top photo-backdrop chrome to match `main` after a prior pinned-audio shield commit caused a white wash over the hero image.
- Regenerated native resources and SQLite from the authored copy.

## Current Validation Receipts

Latest successful checks in this lane:

- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
- `node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-city-michelin-coverage.js`
- `node native-ios/scripts/audit-viet-listing-production-qa.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node scripts/guard-native-only.js`
- `git diff --check`

Simulator proof:

- Built and launched `SpeakLocalNative` on simulator `SpeakLocal City Listings`.
- Direct route used for visual proof: `--detail-page viet-family-city-hoian-place-banh-mi-phuong`.
- The top hero/chrome now matches `main`: no giant white wash over the image.

## Remaining Work

Correction, 2026-06-01:

The earlier `PASS_GLOBAL_PRODUCTION_READY` classification was revoked after a full copy audit. Current status is `NOT_PRODUCTION_READY`; continue from `full-copy-audit-2026-06-01.md`.

Second repair batch, 2026-06-01:

- Fresh read-only food, non-food, and phrase-card subagents audited the current lane.
- The next blocker batch was repaired and projected: fixed-price mall phrase cards, coffee-route cards, cooking-class/craft/lagoon-seafood cards, the singular ticket-buying tap-through risk, and visible editor-language residue across V2.2 app-detail source.
- Current validators pass after regeneration, but this still is not a final production-ready receipt. Continue from the `Second Repair Batch - 2026-06-01` section in `full-copy-audit-2026-06-01.md`.

Third repair batch, 2026-06-01:

- Read-only audits found two current risks: thin high-use generated phrase pages and `85` repeated `food-menu | food-1 | food-3` card sets.
- Repaired source copy for ticket buying, walking, less sugar, hot coffee, recommendations, and pack-for-travel phrase pages.
- Retargeted `32` high-risk food listings across fine dining, seafood-by-weight, dessert, vegetarian, and service-led restaurant pages.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; the repeated food-card set is now `53` pages, mostly simple dish/stall pages.
- Built and launched on simulator `SpeakLocal City Listings`; spot-checked Anan Saigon, Be Man Seafood, che xoa xoa hat luu, less-sugar phrase page, pack-for-travel phrase page, and Lien Hoa Vegetarian. Render review found one compact-card issue on Lien Hoa, fixed by switching to shorter ready phrase `food-premium-no-meat`, then rebuilt and rechecked successfully.
- This is improved but still not a final production-ready receipt because rendered review needs broader category coverage.

Fourth repair batch, 2026-06-01:

- Read-only audits found `7` remaining hard-block restaurant retargets in the repeated food-card set and `3` hard-block related-card mismatches in non-food/native projection.
- Retargeted those restaurant pages, repaired Tiên Sa Port / Perfume River / Tòa Khâm Boat Station related links, retargeted Trường Tiền Plaza mall cards, and repaired a small safe-fix set across cafes, nature/activity pages, and Thủy Biều Village.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; the repeated food-card set is now `46` pages: `33` Dish and `13` focused one-dish/snack Restaurant pages.
- Rebuilt and spot-checked Bếp Cuốn, Trường Tiền Plaza, and Perfume River on simulator `SpeakLocal City Listings`.

Fifth repair batch, 2026-06-01:

- Cleaned remaining process-language residue in related/mentioned candidate metadata: `387` internal reason fields normalized, plus `5` visible related-card subtitles hand-rewritten.
- Retargeted the two render-review restaurant rows: Cô Chủ Nhỏ and Bánh Xèo 46A now use distinct table/recommendation/payment or sauce utility cards instead of the old repeated generic food set.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; process/residue relationship strings are now `0`, and exact repeated phrase-card sets across V2.2 source are now `0`.
- Rebuilt and spot-checked Cô Chủ Nhỏ and Bánh Xèo 46A on simulator `SpeakLocal City Listings`.

Sixth repair batch, 2026-06-01:

- Repaired the six visible soft freshness/status phrases found by the final sidecar audit: Asia Park, Dragon Carp Statue, Noi Bai Airport, Quan Thanh Temple, Ben Thanh Metro Station, and Golden Dragon Water Puppet Theater.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after regeneration; targeted soft schedule/rules/open/timing phrases are now `0`.
- Final source-completeness sidecar: `PASS` for all `520` V2.2 source objects.
- Final native/generated sidecar: structural native evidence passes, but global status remains `REVISE` until the rendered screenshot evidence is promoted from representative proof to a final global receipt.

Highest-leverage next pass:

1. Decide whether to satisfy the V2.2 production gate literally with top/scrolled screenshot proof for all `520` V2.2 pages, or amend the receipt standard to accept full source/runtime text review plus representative rendered proof.
2. If using the literal screenshot standard, build a repeatable UI-test harness that captures top and scrolled screenshots for all `520` `viet-family-city-*` pages into a dated proof folder.
3. Run the final requirement-by-requirement production receipt against the V2.2 gate after that proof exists.
4. Keep generated resources in sync: project V2.2 to handwritten copy, import handwritten copy, generate authored listing pages, generate SQLite, then validate.

Good starter pages/searches for rendered review:

- `viet-family-city-hoian-place-banh-mi-phuong`
- `viet-family-city-hoian-place-madame-khanh`
- `viet-family-city-hcmc-place-anan-saigon`
- `viet-family-city-hcmc-place-pho-minh`
- `viet-family-city-hanoi-place-bun-cha-huong-lien`
- `viet-family-city-danang-place-han-market`
- `viet-family-city-hcmc-place-42-nguyen-hue-apartment`
- `viet-family-city-hoian-place-the-field`
- `viet-family-city-danang-place-ba-na-hills`

## Subagent Note

This desktop thread repeatedly hung when using real subagent spawn/close controls. A fresh session can try subagents again, but keep each agent read-only and narrow:

- one agent reviews phrase-page thinness;
- one reviews food/restaurant desire;
- one reviews city/place related-card usefulness;
- one reviews rendered simulator pages for visual/copy fit.

Do not let subagents auto-edit the same files concurrently. Fold their findings back through the authored V2.2 source and regeneration chain.

Seventh repair batch, 2026-06-01:

- User screenshot review found `city-hcmc-place-banh-xeo-46a` still too hard to read on-device: stiff section language such as `A Dish-Specific Meal`, `table attention`, and `carry the stop`.
- Follow-up screenshot review found unexplained award jargon: `Bib Gourmand` reads like an unknown dish/place label to first-time Vietnam travelers. Visible copy must either explain awards in plain English at the point of use or omit them when the food/table detail is stronger.
- Ran a full taxonomy audit across all `520` V2.2 entries with read-only food, culture/attraction, mobility/route, and place-feel slices.
- Repaired the screenshot page and first taxonomy hard-block batch in source: food pages with app-architecture language, transport phrase-card mismatches, wrong culture/attraction related cards, Cửa Đại Beach phrase cards, Kim Bồng/Trà Nhiêu wording leaks, and several visible grammar or voice issues.
- Repaired related-card fallback clusters with page-specific route/comparison cards rather than suppressing all relationships.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current source/runtime validators pass: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Award-language audit found visible guide/award or dining-insider language on `58` V2.2 source pages. That class is now repaired to `0` visible hard hits across the audited app-detail fields. `Bib Gourmand`, `MICHELIN`, `Green-Star`, `Service Award`, `promoted`, `sommelier`, `tasting-menu`, `Asian Contemporary`, `French Contemporary`, `support role`, and `source inventory` should not appear as unexplained traveler-facing shorthand.
- The authoring rule from the screenshot review is now explicit: if a first-time U.S. traveler would not know whether a term is a dish, place, award, or restaurant category, explain it immediately or omit it and lead with concrete food/table/route utility.
- Global status is still not final production-ready until the rendered proof gate is closed or explicitly amended. Continue from `full-taxonomy-copy-audit-2026-06-01.md`.

Rendered proof expansion, 2026-06-01:

- Added a resumable native UI-test harness for the V2.2 screenshot gate: `CityAppDetailV22RenderProofUITests/testCaptureCityAppDetailV22RenderProofBatch`.
- Added a full `520`-page manifest under `render-proof-2026-06-01-v2-2-global/`.
- Proved `52` unique current pages with `156` screenshots and `0` current failures across the category-balanced, award-jargon repair, cross-city, and Con Market rerun result files. This includes the user-flagged `city-hcmc-place-banh-xeo-46a`.
- Multi-page-in-one-test runs can kill the UI-test runner; use single-page xcodebuild invocations with `TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_OFFSET=<n>` and `TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_LIMIT=1` for reliable continuation.
- Remaining global proof gap: `315` V2.2 pages still need rendered screenshots, unless Jojo explicitly amends the final gate to accept source/runtime validation plus category-balanced native proof.

Eighth repair batch, 2026-06-01:

- Jojo rejected the award-jargon checkpoint as too narrow. A new full taxonomy re-audit used four read-only subagents plus a local inventory pass.
- Audited slices covered Food `214` pages, Culture/Attraction `216`, Mobility/Route/Outdoor `90`, and cross-taxonomy repetition/card/mobile-readability across all `520`.
- Repaired hard blockers from the independent audits: food support-language pages, HCMC museum related-card mismatch cluster, Train Street rules wording, Bạch Đằng Waterbus and Bến Thành Metro related cards, Hue nature fallback cards, beach/nature phrase-card fit, Cửa Đại Estuary first move, and Perfume River timing copy.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current source/runtime validators pass: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added rendered proof `taxonomy-hardblock-repair-results.jsonl`: `10` repaired pages, `30` screenshots, `0` failures.
- Repaired runtime taxonomy metadata for performance/show/craft/apartment pages that were projecting as museum or market-like groups: Nguyễn Hiển Dĩnh Tuồng Theatre, Vietnam Central Circus, Vietnam National Tuồng Theatre, Golden Dragon Water Puppet Theater, À Ố Show, Duyệt Thị Đường Royal Theater, 42 Nguyễn Huệ apartment building, and Reaching Out Arts & Crafts.
- Added rendered proof `taxonomy-runtime-repair-results.jsonl`: `8` repaired pages, `24` screenshots, `0` failures.
- Added high-risk taxonomy proof `high-risk-taxonomy-proof-001-results.jsonl`: `20` pages, `60` screenshots, `0` failures across arrivals, stations, markets, streets, beach, nature, museums, river, neighborhood, villages, port, dessert, and Hue landmarks.
- Text review after that render slice found validating-but-stiff copy on a few pages. Repaired `street-spine role`, repeated `threshold`, and `name confusion resolved by boats` style language in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `high-risk-humanized-rerun-results.jsonl`: `8` edited pages, `24` screenshots, `0` failures.
- Added under-covered cities proof `high-risk-taxonomy-proof-002-results.jsonl`: `30` pages, `90` screenshots, `0` failures across Hanoi, HCMC, Hội An, and Huế cafes, markets, museums, parks, streets, rivers, stations, ports, drinks, desserts, villages, and arrivals.
- Text review after that render slice found more validating-but-stiff transport framing. Repaired repeated `threshold` language and one `Choose...` lead in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `high-risk-humanized-rerun-002-results.jsonl`: `4` edited pages, `12` screenshots, `0` failures.
- Added Hội An / Huế low-coverage rendered proof: `hoian-hue-low-coverage-proof-001-results.jsonl` covers `30` pages and `90` screenshots with `0` failures.
- Text review after that render slice found validating-but-stiff copy on the phone: `spine` metaphors, directive `Choose...` leads, and duplicated summary clauses. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `hoian-hue-humanized-rerun-001-results.jsonl`: `12` edited pages, `36` screenshots, `0` failures.
- Added balanced culture/city rendered proof: `balanced-culture-city-proof-001-results.jsonl` covers `30` pages and `90` screenshots with `0` failures across five-city museum, cafe, neighborhood, attraction, landmark, and market coverage.
- Text review after that render slice found phone-readable but still improvable copy: directive `Choose...` headings, duplicated `a few a few`, repeated `practical`, and one overly abstract cafe/museum mood line. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `balanced-culture-city-humanized-rerun-001-results.jsonl`: `6` edited pages, `18` screenshots, `0` failures.
- Added balanced food/city rendered proof: `balanced-food-city-proof-001-results.jsonl` covers `30` pages and `90` screenshots with `0` failures across restaurants, dish pages, cafes, markets, dessert/drink pages, and high-risk Da Nang mì Quảng comparison pages.
- Text review after that render slice found food-copy issues that passed render but needed human cleanup: directive `Choose...` phrasing, a missing verb in the seafood price warning, `Not Street Food`, `Drink Before Room`, `Fast Moving Meal`, and a leftover `The draw is more concrete` line. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `balanced-food-city-humanized-rerun-001-results.jsonl`: `7` edited pages, `21` screenshots, `0` failures.
- Added balanced mobility/landmark rendered proof: `balanced-mobility-landmark-proof-001-results.jsonl` covers `30` pages and `90` screenshots with `0` failures across landmarks, attractions, streets, stations, nature, parks, and neighborhoods in all five cities.
- Text review after that render slice found more phone-readable-but-not-human-enough copy: a sentence fragment on Hải Vân Pass, directive cyclo wording, `Ordinary Is Enough`, duplicated Đống Đa neighborhood guidance, and awkward Hội An bus-station grammar. Repaired those in authored V2.2 source, regenerated native resources, and reran validators.
- Added current-text rerun proof `balanced-mobility-landmark-humanized-rerun-001-results.jsonl`: `5` edited pages, `15` screenshots, `0` failures.
- Combined latest-current rendered proof is now `235` unique pages, `705` screenshots, `0` current failures.
- Global status remains not complete: `285` V2.2 pages still need current rendered proof unless the standard is amended, and repeated phrase-card clusters remain a follow-up class.

Ninth repair batch, 2026-06-01:

- Continued from the user screenshot objection that `Bib Gourmand` and similar terms are confusing if left unexplained for first-time U.S. travelers.
- Applied the editorial rule: explain unfamiliar awards, cuisines, performance forms, ingredients, transport terms, or local labels at the point of use, or omit them and lead with concrete food/table/place utility.
- Re-audited hard-block slices with read-only agents: Food `214` pages, Culture/Attraction `191`, Mobility/Outdoor/Place-feel `118`, plus local runtime/taxonomy checks across all `520`.
- Repaired the screenshot page `city-hcmc-place-banh-xeo-46a`: no visible `Bib Gourmand`, `MICHELIN`, or `restaurant version` phrasing remains; the intro now describes the hot pancake, herbs, sauce, and table experience in plain language.
- Repaired source hard blockers from the subagent slices: food glossary gaps (`mắm nêm`, `nhà rường`, `cơm niêu`), performance-form explanations (`tuồng`, `Nhã nhạc`), theater/show phrase cards, airport/rail/metro/transfer phrase cards, river/street schematic wording, and related-card fallback clusters in HCMC, Hội An, Huế, Đà Nẵng, and Hanoi.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current source/runtime validators pass: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Targeted hard-block text sweep against authored V2.2 source and generated runtime is clean for `Bib Gourmand`, `MICHELIN`, old award/dining shorthand, schema headings, and the listed process-language residue.
- Added current-text rendered proof `subagent-hardblock-humanized-rerun-001-results.jsonl`: `33` repaired pages, `99` screenshots, `0` failures. The batch includes the user-flagged Bánh Xèo 46A page plus food, culture/performance, mobility, and Hanoi related-card repairs.
- Combined latest-current rendered proof is now `244` unique pages, `732` screenshots, `0` current failures.
- Global status remains not complete: `276` V2.2 pages still need current rendered proof unless the standard is amended.

Tenth proof / humanization batch, 2026-06-01:

- Continued the literal V2.2 screenshot gate rather than narrowing the definition of production-ready.
- Added rendered proof `missing-pages-proof-001-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures. The slice finished a large set of remaining Đà Nẵng museum, landmark, attraction, arrival, beach, restaurant, cafe, dish, neighborhood, market, street, and nature pages, plus a small Hanoi food run.
- Human-readability review after the render found source copy that passed screenshots but still read too mechanical on a phone: `Choose it`, `carry the visit`, `support`, `stronger`, `are enough`, and a few abstract `draw` or `whether` lines.
- Repaired those lines in authored V2.2 source, including Hải Vân Pass, Hàn River Cruise, Lady Buddha, Linh Ứng Pagoda, Marble Mountain cave walk, Mỹ Khê, Nam House, Nam Ô fish sauce village, nem lụi, Phạm Văn Đồng Beach, Phước Mỹ, Reply 1988, The Temptation, Trần Thị Lý Bridge, and Vincom Plaza.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added current-text rendered proof `missing-pages-humanized-rerun-001-results.jsonl`: `15` edited pages, `45` screenshots, `0` failures.
- Combined latest-current rendered proof is now `284` unique pages, `852` screenshots, `0` current failures.
- Global status remains not complete: `236` V2.2 pages still need current rendered proof unless the standard is amended.

Eleventh repair batch, 2026-06-01:

- Fresh read-only subagents audited food, culture/attraction/landmark, and mobility/outdoor/place-feel slices after the first-time-traveler readability complaint.
- Reconfirmed the `Bib Gourmand` rule: if a first-time U.S. traveler may not know whether a term is a dish, place, award, restaurant category, or local custom, explain it immediately or remove it and lead with concrete food/table/route/place utility.
- Repaired current hard blockers in source: Nu Eatery grammar, Vy's Market duplicate section job, CieL/Coco Dining/Long Triều dining-room copy, Golden Dragon and À Ố Show phrase cards, Saigon River boat phrase cards, Chợ Lớn/Củ Chi/Mỹ Sơn/Hội An assembly hall related-card mismatches, plus a Danang readability slice.
- Removed one remaining `carry the stop` residue from a Hội An old-house page after targeted source/runtime search caught it.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Targeted hard-block text sweep against source and generated runtime is now `0` for `Bib Gourmand`, `MICHELIN`, dining-insider shorthand, old award terms, `restaurant version`, `recognition helps`, and `carry the stop`.
- Added rendered proof `subagent-hardblock-repair-002-results.jsonl`: `58` passing rows, `174` screenshots, `0` failures.
- Added rendered proof `subagent-hardblock-repair-003-results.jsonl`: `1` old-house rerun, `3` screenshots, `0` failures.
- Combined latest-current rendered proof is now `293` unique pages, `879` screenshots, `0` current failures.
- Global status remains not complete: `227` V2.2 pages still need current rendered proof unless the standard is amended.

Twelfth proof / humanization batch, 2026-06-01:

- Continued the literal V2.2 screenshot gate with the next `40` unproved manifest pages, all in the Hanoi band.
- Added rendered proof `missing-pages-proof-002-results.jsonl`: `40` previously unrendered Hanoi pages, `120` screenshots, `0` failures.
- Human-read the rendered slice and repaired validating-but-stiff copy in authored V2.2 source: `carry the visit`, `draw`, `register`, `spine`, plus the grammar error `A Eel-Noodle Bowl`.
- Repaired pages included the Hanoi phở cluster, French Quarter, Old Quarter, Long Biên bridge/market, Năng Cafe, One Pillar Pagoda, Temple of Literature, Chả Cá Thăng Long, egg coffee, and related Ba Đình/landmark pages.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added current-text rendered proof `missing-pages-humanized-rerun-002-results.jsonl`: `18` edited Hanoi pages, `54` screenshots, `0` failures.
- Combined latest-current rendered proof is now `333` unique pages, `999` screenshots, `0` current failures.
- Global status remains not complete: `187` V2.2 pages still need current rendered proof unless the standard is amended.

Thirteenth proof / humanization batch, 2026-06-01:

- Continued the literal V2.2 screenshot gate with the next `40` unproved manifest pages: the final Hanoi proof gap plus the opening Saigon band.
- Added rendered proof `missing-pages-proof-003-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
- Human-read the rendered slice against the first-time U.S. traveler rule from the screenshot feedback: no unexplained award/guide jargon, no insider shorthand, no abstract `carry` / `draw` / `spine` copy where concrete food, route, or room language is clearer.
- Repaired authored V2.2 source in `hanoi.json` and `hcmc.json`, including Thống Nhất Park, Trúc Bạch Lake, Turtle Tower, Ưu Đàm, Vietnam Art Gallery, Vietnam Fine Arts Museum, Military History Museum, Water Puppet Theatre, Yên Sở Park, Bò Kho Gánh, bò lá lốt, Bún Bò Huế 14B, bún thịt nướng, City Hall, Cơm Tấm Ba Ghiền, Cộng Cà Phê Đồng Khởi, Cục Gạch Quán, Đồng Khởi walk/street, Fine Arts Museum, History Museum, and Ho Chi Minh City Museum.
- Repaired phrase-card fit in the same slice: Water Puppet Theatre now uses `What time does it start?` instead of closing time, and City Hall now uses directions instead of `One ticket, please`.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Added current-text rendered proof `missing-pages-humanized-rerun-003-results.jsonl`: `23` edited pages, `69` screenshots, `0` failures.
- Combined latest-current rendered proof is now `373` unique pages, `1119` latest-current screenshots, `0` current failures.
- Global status remains not complete: `147` V2.2 pages still need current rendered proof unless the standard is amended.

Fourteenth proof / subagent cleanup batch, 2026-06-01:

- Treated the user screenshot feedback as a production copy rule: first-time U.S. travelers must not meet unexplained award, guide, cuisine, transit, performance, or local-label jargon. If a term like `Bib Gourmand` appears, the copy must immediately say what it means, or the page should lead with concrete food/place utility instead.
- Used three read-only subagent audits on the remaining HCMC, Hội An, and Huế proof gaps. Findings focused on stiff `carry` / `draw` / `spine` / `threshold` wording, directive `Choose it` phrasing, wrong related-card routes, and phrase cards that did not match the page moment.
- Repaired authored V2.2 source in `hcmc.json`, `hoian.json`, and `hue.json`: HCMC food/shopping/cafe pages, Hội An old-town/assembly/food/cycling pages, and Huế tomb/gate/river/restaurant/street pages now use more concrete first-visit language.
- Kept researched restaurant signals where the QA gate requires them, but made them readable: for example, L'Usine Thảo Điền now frames eggs Benedict, squid ink crab pasta, premium pho, and salt caramel coffee as menu items rather than unexplained insider shorthand.
- Removed the last source slug containing `bib-gourmand`; targeted source/runtime scan is now `0` for `Bib Gourmand`, `MICHELIN`, and `Gourmand`.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Built `SpeakLocalNative` for testing on the `SpeakLocal City Listings` simulator: `TEST BUILD SUCCEEDED`.
- Added rendered proof `missing-pages-proof-004-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures. The slice completed the remaining Saigon proof gap and started the Hội An band.
- Combined latest-current rendered proof is now `413` unique pages, `1239` latest-current screenshots, `0` current failures.
- Global status remains not complete: `107` V2.2 pages still need current rendered proof unless the standard is amended. Remaining pages are in Hội An (`51`) and Huế (`56`).

Fifteenth proof / Hội An render and Huế preflight batch, 2026-06-01:

- Continued the literal screenshot gate with the next `40` missing pages, all in the Hội An band.
- Used two read-only subagents before/while rendering: one audited the remaining Hội An pages and caught wrong related cards/weak phrase-card fit; one audited the remaining Huế pages and caught Huế blockers to fix before the next render band.
- Repaired Hội An source before render: Cam Thanh now relates to the Bay Mau coconut-waterway context, Hainan Assembly Hall now relates to a real assembly-hall comparison, STREETS Restaurant Cafe now uses table/menu/bill phrases, Memories Land uses ticket/start/meeting phrases, and stiff `Choose` / `route` / `reference point` wording was softened.
- Added rendered proof `missing-pages-proof-005-results.jsonl`: `40` previously unrendered Hội An pages, `120` screenshots, `0` failures.
- Repaired Huế source preflight from the second subagent: Trường Tiền Plaza naming, royal-object museum related cards, southern bus station related routing, Imperial City threshold wording, Huyen Tran `register`, Lang Thang directive phrasing, Le Ba Dang `draw/register`, Thanh Toan bridge casing, and Phu Cam Church related-card fit.
- Regenerated V2.2 handwritten copy, native authored listing pages, phrase catalog, and SQLite after both Hội An and Huế repairs.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Built `SpeakLocalNative` for testing on the `SpeakLocal City Listings` simulator before render: `TEST BUILD SUCCEEDED`.
- Combined latest-current rendered proof is now `453` unique pages, `1359` latest-current screenshots, `0` current failures.
- Global status remains not complete: `67` V2.2 pages still need current rendered proof unless the standard is amended. Remaining pages are Hội An (`11`) and Huế (`56`).

Sixteenth proof / final Hội An and Huế glossary-readability batch, 2026-06-01:

- Continued the literal screenshot gate with the next `40` missing pages: the final `11` Hội An proof-gap pages plus the first `29` Huế pages.
- Treated Jojo's `Bib Gourmand` screenshot feedback as a general production rule: a first-time U.S. visitor must not meet an unexplained award, local culture term, dish name, royal-history term, performance form, or app-internal route label.
- Used two read-only subagents on the exact batch before render. The Hội An reviewer caught unexplained `Sa Huynh`, `social enterprise`, and `training restaurant` wording, wrong old-house related cards, and internal `fitting-step` / `route` subtitles. The Huế reviewer caught unexplained `Cơm âm phủ`, `Cơm hến`, `Forbidden Purple City`, `Huyền Trân`, `chay`, `Nguyễn Dynasty`, `Nam Giao`, and `Nine Dynastic Urns`, plus route/page-ish headings.
- Repaired authored V2.2 source in `hoian.json` and `hue.json`, regenerated handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass again: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Targeted source/runtime scan is clean for `Bib Gourmand`, `MICHELIN`, and `Gourmand`.
- Built `SpeakLocalNative` for testing on the `SpeakLocal City Listings` simulator: `TEST BUILD SUCCEEDED`.
- Added rendered proof `missing-pages-proof-006-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
- Combined latest-current rendered proof is now `493` unique pages, `1479` latest-current screenshots, `0` current failures.
- Global status remains not complete: `27` V2.2 pages still need current rendered proof unless the standard is amended. Remaining pages are all Huế.

Seventeenth proof / final Huế render and production receipt, 2026-06-01:

- Completed the literal V2.2 screenshot gate with the final `27` missing Huế pages.
- Used a final read-only subagent on the remaining Huế proof gap before render. Findings focused on first-time-reader explanations for dragon boat, Phạm Ngũ Lão, Phủ Cam Church, royal antiquities, nhã nhạc, mangrove, lagoon, Thái Hòa Palace, Thế Miếu, Từ Đức/Từ Hiếu, Vọng Cảnh Hill, and garden-restaurant copy.
- Repaired authored V2.2 source in `hue.json`, regenerated handwritten copy, native authored listing pages, phrase catalog, and SQLite.
- Current validators pass: strict V2.2 `PASS` for all `520`, voice audit `failures: []`, city copy/library/SQLite/production QA/native-only/diff-check all pass.
- Targeted source/runtime scan is clean for `Bib Gourmand`, `MICHELIN`, and `Gourmand`.
- Built `SpeakLocalNative` for testing on the `SpeakLocal City Listings` simulator: `TEST BUILD SUCCEEDED`.
- Added rendered proof `missing-pages-proof-007-results.jsonl`: `27` previously unrendered pages, `81` screenshots, `0` failures.
- Final latest-current rendered proof is now `520` unique pages, `1560` latest-current screenshots, and `0` current failures.
- Global V2.2 city/place proof gap is now `0`.

Eighteenth repair batch started, 2026-06-01:

- Jojo reviewed the live phone page for `city-hanoi-place-hibana-by-koki` and rejected the production-ready classification: the copy did not plainly explain that the restaurant is Japanese teppanyaki / hibachi-style grill dining, did not make the listing save-worthy, and used vague U.S.-reader-unfriendly phrases such as `counter dinner`.
- Treated this as a new global production-copy rule, not a one-page taste note: first-time U.S. travelers need unfamiliar restaurant formats, cuisine labels, awards, local customs, performance forms, and transit/place types explained in plain English at the point of use, or omitted in favor of concrete food/place utility.
- Repaired Hibana in first-class V2.2 source: the visible copy now identifies Japanese teppanyaki, bridges the American hibachi-style mental model, names the Capella Hanoi chef-led grill format, and explains the right use case without unexplained award or `counter dinner` shorthand.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite.
- Current validators pass after the Hibana repair: strict V2.2, voice audit, city copy, city library, SQLite fixture, listing production QA, and `git diff --check`.
- Local heuristic inventory still flags a follow-up candidate set of roughly `45` visible food-adjacent / place-feel rows for human review. Many are false positives from allowed words, but the high-priority cluster is polished restaurant copy using `special-occasion`, `register`, `draw`, `carry`, or other abstract decision language where the listing should instead answer: what is this place, what happens there, why would a U.S.-based visitor remember it, and when should they choose it over nearby alternatives.
- Do not mark the full goal complete from this batch alone. Continue with the remaining candidate set, then run focused rendered proof for edited pages.
- Repaired the first polished-restaurant cluster in authored V2.2 source: La Maison 1888, Nén Đà Nẵng, Gia, Lamai Garden, Tầm Vị, Akuna, Anăn Sài Gòn, CieL, Coco Dining, Long Triều, and Nephele now use plainer U.S.-traveler framing for cuisine, room format, trip role, and comparison value instead of unexplained `special-occasion`, `register`, or `fine-dining` shorthand in visible copy.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite again.
- Current validators pass after the restaurant-cluster repair: strict V2.2, voice audit, city copy, city library, SQLite fixture, listing production QA, and `git diff --check`.
- Fresh simulator build-for-testing passed on `SpeakLocal City Listings`.
- Added targeted rendered proof for the `12` edited restaurant pages: `us-traveler-restaurant-repair-001-results.jsonl`, `12/12` PASS, `36` screenshots, `0` failures. The first multi-page run hung after page 1, so the remaining pages were captured with the known reliable single-page offset pattern.
- Quick visual read of the repaired Hibana screenshots confirms the first screen now says `Japanese teppanyaki`, explains the chef cooking at a hot grill in front of a small counter, and compares it to a refined hibachi-style experience.
- Continued the same U.S.-traveler readability repair beyond restaurants: removed visible `counter dinner` / `carry` / `draw` / `register` / `threshold` / `special-occasion` / `fine-dining` / `counterpart` style shorthand from the authored V2.2 listing fields where the copy should instead say what the place is, what happens there, why to choose it, and what to picture.
- Repaired the Thảo Điền duplicate-heading regression found during projection (`place-brief` missing at runtime) by separating the intro heading from the first section heading.
- Targeted heuristic scan after the cleanup is now `0` rows for the flagged shorthand set in visible authored V2.2 fields.
- Regenerated V2.2 handwritten copy, native authored listing pages, and SQLite after the broader cleanup.
- Current validators pass after the broader cleanup: strict V2.2, voice audit, city copy, city library, SQLite fixture, listing production QA, and `git diff --check`.
- Fresh simulator build-for-testing passed on `SpeakLocal City Listings`.
- Added rendered proof for the `87` edited language-cleanup pages: `us-traveler-language-cleanup-002-results.jsonl`, `87/87` PASS, `261` screenshots, `0` failures. The first batch hit the 15-minute guard after `50` passes, then resumed from offset `50` and completed the remaining `37`.
- Representative visual reads after this pass confirm the copy is more concrete on the actual phone-sized screen: Gia now opens as `A Calm Vietnamese Dinner`, and Ancient Hue Gallery Cuisine now says it is a composed Hue dinner with a refined room, court-style plating, dark timber, and slow table pacing.
