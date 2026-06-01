# V2.2 Global Render Proof - 2026-06-01

Status: IN_PROGRESS_PARTIAL_RENDER_PROOF

This folder contains the manifest and screenshot output for the rendered V2.2 proof gate. The manifest covers 520 first-class app-detail source pages from `content-draft/viet/city-library/app-detail-v2-2/*.json`.

Current command shape for a single-page proof invocation:

```sh
TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_MANIFEST="$PWD/docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/v2-2-render-proof-manifest.json" \
TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_DIR="$PWD/docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/screenshots-single-001" \
TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_OFFSET=0 \
TEST_RUNNER_SPEAKLOCAL_V2_2_RENDER_PROOF_LIMIT=1 \
xcodebuild test-without-building \
  -project native-ios/SpeakLocalNative.xcodeproj \
  -scheme SpeakLocalNative \
  -destination 'platform=iOS Simulator,id=7C386DD3-4BF1-4A34-A918-768C43CD1258' \
  -derivedDataPath /Users/jojolim/Library/Developer/XcodeBuildMCP/workspaces/orchestrator-309442864093/DerivedData/SpeakLocalNative-8f3e721625a0 \
  -only-testing:SpeakLocalNativeUITests/CityAppDetailV22RenderProofUITests/testCaptureCityAppDetailV22RenderProofBatch
```

Why single page per invocation: the test harness works, but multi-page runs can kill the UI-test runner on the current simulator after several launches. Single-page invocations returned stable receipts and still capture top, middle, and end-of-content screenshots for each page.

## Current Partial Proof

Category-balanced batch:

- Results: `category-balanced-results.jsonl`
- Xcode logs: `xcodebuild-logs/proof-*.log`
- Scope: `43` current rows, `129` screenshots, `0` current failures.
- Coverage: one page from each of the `20` top-level categories, plus `city-hcmc-place-banh-xeo-46a` and one restaurant page from Hanoi, HCMC, Hoi An, and Hue.
- Bánh Xèo screenshot-feedback proof:
  - `screenshots-single-223/223-hcmc-restaurant-hcmc-place-banh-xeo-46a-top.png`
  - `screenshots-single-223/223-hcmc-restaurant-hcmc-place-banh-xeo-46a-middle.png`
  - `screenshots-single-223/223-hcmc-restaurant-hcmc-place-banh-xeo-46a-bottom.png`
- Award/jargon repair proof:
  - `award-jargon-repair-results.jsonl`: `12` Da Nang pages, `36` screenshots, `0` failures.
  - `award-jargon-cross-city-results.jsonl`: `10` cross-city restaurant/dish pages, `30` screenshots, `0` failures.
  - `con-market-after-bottom-relaunch-results.jsonl`: `1` rerun page, `3` screenshots, `0` failures.
- Taxonomy hard-block repair proof:
  - `taxonomy-hardblock-repair-results.jsonl`: `10` repaired pages, `30` screenshots, `0` failures.
  - Scope: Boulevard Gelato & Coffee, Wonderlust, Mặn Mòi, Phá lấu, Hội An wonton, Đại Nam Restaurant, Hanoi Train Street, Bến Thành Metro Station, War Remnants Museum, and Perfume River.
- Runtime taxonomy repair proof:
  - `taxonomy-runtime-repair-results.jsonl`: `8` repaired pages, `24` screenshots, `0` failures.
  - Scope: Nguyễn Hiển Dĩnh Tuồng Theatre, Vietnam Central Circus, Vietnam National Tuồng Theatre, Golden Dragon Water Puppet Theater, À Ố Show, Duyệt Thị Đường Royal Theater, 42 Nguyễn Huệ apartment building, and Reaching Out Arts & Crafts.
- High-risk taxonomy proof:
  - `high-risk-taxonomy-proof-001-results.jsonl`: `20` high-risk pages, `60` screenshots, `0` failures.
  - Scope: arrivals, stations, markets, streets, beach, nature, museums, river, neighborhood, villages, port, dessert, and Hue landmarks.
  - Text review after this batch found a few stiff but validating lines (`street-spine role`, repeated `threshold`, and `name confusion resolved by boats`). Those were repaired in source.
  - `high-risk-humanized-rerun-results.jsonl`: `8` edited pages rerun after the copy repair, `24` screenshots, `0` failures.
- Under-covered cities proof:
  - `high-risk-taxonomy-proof-002-results.jsonl`: `30` pages, `90` screenshots, `0` failures.
  - Scope: Hanoi, HCMC, Hội An, and Huế cafes, markets, museums, parks, streets, rivers, stations, ports, drinks, desserts, villages, and arrivals.
  - Text review after this batch found more stiff transport framing (`threshold`) and one `Choose...` lead. Those were repaired in source.
  - `high-risk-humanized-rerun-002-results.jsonl`: `4` edited pages rerun after the copy repair, `12` screenshots, `0` failures.
- Hội An / Huế low-coverage proof:
  - `hoian-hue-low-coverage-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures.
  - Scope: Hội An and Huế beaches, rivers, museum/performance/street/assembly/cafe/restaurant/dish/shopping pages, plus Hue landmarks, restaurants, dishes, park, market, and cafe pages.
  - Text review after this batch found more validating-but-stiff language: `spine` metaphors, directive `Choose...` leads, and duplicated summary clauses. Those were repaired in source.
  - `hoian-hue-humanized-rerun-001-results.jsonl`: `12` edited pages rerun after the copy repair, `36` screenshots, `0` failures.
- Balanced culture/city proof:
  - `balanced-culture-city-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures.
  - Scope: one museum, cafe, neighborhood, attraction, landmark, and market page from each of Đà Nẵng, Hà Nội, Saigon, Hội An, and Huế.
  - Text review after this batch found phone-readable but still improvable copy: directive `Choose...` headings, duplicated `a few a few`, repeated `practical`, and one overly abstract cafe/museum mood line. Those were repaired in source.
  - `balanced-culture-city-humanized-rerun-001-results.jsonl`: `6` edited pages rerun after the copy repair, `18` screenshots, `0` failures.
- Balanced food/city proof:
  - `balanced-food-city-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures.
  - Scope: restaurants, dish pages, cafes, markets, dessert/drink pages, and high-risk Da Nang mì Quảng comparison pages across the five-city inventory.
  - Text review after this batch found food-copy issues that passed render but needed human cleanup: directive `Choose...` phrasing, a missing verb in the seafood price warning, `Not Street Food`, `Drink Before Room`, `Fast Moving Meal`, and a leftover `The draw is more concrete` line. Those were repaired in source.
  - `balanced-food-city-humanized-rerun-001-results.jsonl`: `7` edited pages rerun after the copy repair, `21` screenshots, `0` failures.
- Balanced mobility/landmark proof:
  - `balanced-mobility-landmark-proof-001-results.jsonl`: `30` pages, `90` screenshots, `0` failures.
  - Scope: landmarks, attractions, streets, stations, nature, parks, and neighborhoods across Đà Nẵng, Hà Nội, Saigon, Hội An, and Huế.
  - Text review after this batch found copy that validated but still needed a more human phone read: a sentence fragment on Hải Vân Pass, directive cyclo wording, the formula-risk heading `Ordinary Is Enough`, duplicated Đống Đa neighborhood guidance, and awkward Hội An bus-station grammar. Those were repaired in source.
  - `balanced-mobility-landmark-humanized-rerun-001-results.jsonl`: `5` edited pages rerun after the copy repair, `15` screenshots, `0` failures.
- Subagent hard-block / screenshot-feedback proof:
  - `subagent-hardblock-humanized-rerun-001-results.jsonl`: `33` repaired pages, `99` screenshots, `0` failures.
  - Scope: the user-flagged Bánh Xèo 46A page after `Bib Gourmand`/award-language removal, food glossary pages, culture/performance phrase-card repairs, mobility/arrival/station/river/street repairs, and the retargeted Hanoi street related-card cluster.
- Missing-pages proof 001:
  - `missing-pages-proof-001-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
  - Scope: remaining Da Nang museum, landmark, attraction, arrival, beach, restaurant, cafe, dish, neighborhood, market, street, and nature pages, plus a small Hanoi food run covering bún chả, Bún Chả Hương Liên, Bún Chả Đắc Kim, Tuyết Bún Chả 34, bún thang, and chả cá.
  - Text review after this batch found validating-but-stiff phone copy: `Choose it`, `carry the visit`, `support`, `stronger`, `are enough`, and a few abstract `draw` or `whether` lines. Those were repaired in authored V2.2 source and regenerated.
  - `missing-pages-humanized-rerun-001-results.jsonl`: `15` edited pages rerun after the copy repair, `45` screenshots, `0` failures.
- Subagent hard-block repair proof 002:
  - `subagent-hardblock-repair-002-results.jsonl`: `58` passing rows, `174` screenshots, `0` failures.
  - Scope: current repaired Danang food/cafe/arrival/river/market/street/port pages, HCMC show/river/restaurant/neighborhood pages, and Hội An assembly hall/old-house/restaurant pages.
  - Note: this file includes one accidental but passing Espresso Station row because the proof runner skips offsets already passed in the same result file.
  - `subagent-hardblock-repair-003-results.jsonl`: `1` edited old-house page rerun after final wording cleanup, `3` screenshots, `0` failures.
- Missing-pages proof 002:
  - `missing-pages-proof-002-results.jsonl`: `40` previously unrendered Hanoi pages, `120` screenshots, `0` failures.
  - Scope: Hanoi restaurants, drink, neighborhoods, attractions, stations, landmarks, nature, markets, dishes, cafes, museum, and park pages, including the phở cluster, French Quarter, Old Quarter, coffee pages, and Ba Đình/temple landmarks.
  - Text review after this batch found validating-but-stiff copy: `carry the visit`, `draw`, `register`, `spine`, and the grammar error `A Eel-Noodle Bowl`. Those were repaired in authored V2.2 source and regenerated.
  - `missing-pages-humanized-rerun-002-results.jsonl`: `18` edited Hanoi pages rerun after copy repair, `54` screenshots, `0` failures.
- Missing-pages proof 003:
  - `missing-pages-proof-003-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
  - Scope: the final Hanoi proof gap plus the opening Saigon missing-page band, including Hanoi park, pagoda, lake, landmark, gallery, museum, theatre, market, street, and dish pages; then Saigon restaurant, market, dish, cafe, landmark, tunnel, museum, street, and central walk pages.
  - Text review after this batch found phone-readable but still too internal wording: `carry`, `draw`, `spine`, stiff casing, and two mismatched phrase cards. Those were repaired in authored V2.2 source and regenerated.
  - `missing-pages-humanized-rerun-003-results.jsonl`: `23` edited pages rerun after copy repair, `69` screenshots, `0` failures.
- Missing-pages proof 004:
  - `missing-pages-proof-004-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
  - Scope: the remaining Saigon proof gap plus the opening Hội An band, including HCMC flower/food/cafe/market/street/landmark/shopping/park pages and Hội An Ancient Town, bánh mì, bánh xèo, and Cẩm Châu.
  - Text review before and after this batch followed the first-time U.S. traveler rule: no unexplained award/guide jargon, no insider shorthand, and no abstract `carry`, `draw`, `spine`, `threshold`, or `register` copy where concrete food, room, route, or place language is clearer.
  - Source/runtime scan is clean for `Bib Gourmand`, `MICHELIN`, and `Gourmand`.
- Missing-pages proof 005:
  - `missing-pages-proof-005-results.jsonl`: `40` previously unrendered Hội An pages, `120` screenshots, `0` failures.
  - Scope: Hội An neighborhoods, dishes, restaurants, Cham Islands / boat pages, cooking/bicycle/lantern attractions, assembly hall / bridge / temple landmarks, museums, markets, streets, cafes, and workshop pages.
  - Text review before render fixed wrong related cards, weak phrase-card fit, directive `Choose...` phrasing, `Route Rather Than Attraction`, `reference point`, and abstract museum/boat wording.
  - Huế source was also preflight-cleaned before the next render band, but those Huế pages still need screenshots.
- Missing-pages proof 006:
  - `missing-pages-proof-006-results.jsonl`: `40` previously unrendered pages, `120` screenshots, `0` failures.
  - Scope: the final `11` Hội An proof-gap pages plus the first `29` Huế pages, including old houses, tea/coffee/farm pages, Huế dishes, tombs, Citadel landmarks, art spaces, chay dining, royal-object museums, and river/night-walk pages.
  - Text review before render followed the first-time U.S. traveler rule: unfamiliar terms must be explained immediately or replaced by concrete food/place utility. This batch added plain glosses for `Sa Huynh`, `Cơm âm phủ`, `Cơm hến`, `Forbidden Purple City`, `Princess Huyền Trân`, `chay`, `Nguyễn Dynasty`, `Nam Giao`, and `Nine Dynastic Urns`, and removed route/page-ish related-card copy.
- Missing-pages proof 007:
  - `missing-pages-proof-007-results.jsonl`: `27` previously unrendered Huế pages, `81` screenshots, `0` failures.
  - Scope: the final Huế proof gap, including river boats, streets, church, markets, stations, royal museums/music, mangrove/lagoon nature, floating restaurant, SốngLab, palaces, cafes, bridge, temples, tombs, neighborhoods, walking street, and garden restaurants.
  - Text review before render added or tightened first-time-reader explanations for dragon boats, Phạm Ngũ Lão as a hotel/backpacker-area street, Phủ Cam as a modern Catholic cathedral, royal antiquities, nhã nhạc, mangroves, SốngLab as a contemporary digital/art space, Tam Giang as a shallow coastal lagoon, Thái Hòa Palace as the main audience hall, Thế Miếu as a Citadel temple honoring Nguyễn emperors, Từ Hiếu as a Buddhist pagoda and monastery, and Vọng Cảnh Hill as a viewpoint near royal tombs.
- Combined latest-current proof across the maintained result files is `520` unique pages, `1560` latest-current screenshots, and `0` current failures. Total historical proof rows in this folder include `712` rows and `2136` screenshots, but the current count uses the latest passing row for each page.

This folder now contains the final 520-page rendered proof receipt for the current V2.2 city/place inventory.

Category coverage in manifest:

- arrival: 7
- attraction: 55
- beach: 8
- cafe: 38
- dessert: 6
- dish: 46
- drink: 5
- landmark: 77
- market: 40
- museum: 34
- nature: 19
- neighborhood: 28
- park: 12
- port: 5
- restaurant: 79
- river: 7
- shopping: 1
- station: 16
- street: 28
- village: 9

Remaining current proof gap after the latest recompute:

- total missing: `0`
