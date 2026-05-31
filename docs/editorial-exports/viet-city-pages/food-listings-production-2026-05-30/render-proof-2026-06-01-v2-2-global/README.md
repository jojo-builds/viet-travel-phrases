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
- Combined latest-current proof across the maintained result files is `145` unique pages, `435` screenshots, and `0` current failures. Total historical proof rows in this folder include `188` rows and `564` screenshots, but the current count uses the latest passing row for each page.

This is a meaningful rendered proof expansion, not the final 520-page receipt. The final gate still needs either all `520` pages captured by this harness or an explicit approval-standard amendment accepting full source/runtime review plus category-balanced rendered proof.

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
