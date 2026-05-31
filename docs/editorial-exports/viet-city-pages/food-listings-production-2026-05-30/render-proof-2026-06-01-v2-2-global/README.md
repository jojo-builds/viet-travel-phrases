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
- Scope: `25` pages, `75` screenshots, `0` failures.
- Coverage: one page from each of the `20` top-level categories, plus `city-hcmc-place-banh-xeo-46a` and one restaurant page from Hanoi, HCMC, Hoi An, and Hue.
- Bánh Xèo screenshot-feedback proof:
  - `screenshots-single-223/223-hcmc-restaurant-hcmc-place-banh-xeo-46a-top.png`
  - `screenshots-single-223/223-hcmc-restaurant-hcmc-place-banh-xeo-46a-middle.png`
  - `screenshots-single-223/223-hcmc-restaurant-hcmc-place-banh-xeo-46a-bottom.png`

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
