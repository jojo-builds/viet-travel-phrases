# V2.2 Production Review Receipt - Five City Pages

Date: 2026-05-24

Reviewer: Codex city-pages audit/fix pass

Worktree / branch / commit: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages`, `feature/city-pages`, base commit `533eaa633` with uncommitted production fixes in this receipt.

Receipt note: this file records the production review for the five scoped pages below. The reusable review standard for future pages is `V2_2_PRODUCTION_REVIEW_GATE.md`.

## Scope

- `viet-family-city-danang-place-international-terminal`
- `viet-family-city-danang-place-dong-dinh-museum`
- `viet-family-city-hcmc-place-pasteur-street`
- `viet-family-city-hanoi-place-loading-t-cafe`
- `viet-family-city-danang-place-lotte-mart`

## Source And Runtime Files

- V2.2 source objects: `docs/design/city-pages/V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`
- Native authored source: `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc}.json`
- Generated city library: `content-draft/viet/city-library/v1.json`
- Generated native listing bundle: `native-ios/Resources/viet-authored-listing-pages.json`
- Generated SQLite fixture: `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- Native Mentioned Here / Related cards: `native-ios/App/Models/VietnameseMenuCatalog.swift`
- Screenshot proof folder: `docs/design/city-pages/screenshots/v2-2-native-production-2026-05-24/`

## Guidance Read

- `CURRENT_CITY_PAGE_STANDARD.md`
- `SpeakLocal_Editorial_Playbook_v2_2_Portable.md`
- `SpeakLocal_Canonical_31_Example_Set_V2_2_App_Ready.md`
- `speaklocal.place.app-detail.v2.2.schema.json`
- `SpeakLocal_V2_2_New_Session_Generation_Prompt.md`
- `SpeakLocal_V2_2_App_Implementation_Audit_Prompt.md`
- `V2_2_SCREENSHOT_REVIEW_GATE.md`
- `V2_2_PRODUCTION_REVIEW_GATE.md`
- `/Users/jojolim/.codex/skills/speaklocal-copy-authoring/SKILL.md`

## Production Fixes In This Pass

- Lotte Mart Da Nang: removed visible food-court claims from the summary, intro, section heading, body, V2.2 source object, generated runtime resources, and SQLite fixture. The page now stays on the stable indoor restock/reset job.
- Lotte Mart Da Nang: removed the unresolved `Food court` Mentioned Here candidate from the V2.2 source object and updated the verification flag so no unsupported food-court card is implied.
- Lotte Mart Da Nang: revised the native Sunscreen card proof from internal-sounding "trip fixes this page is for" copy to traveler-facing copy: "Worth grabbing before beach time, a long walk, or a ride out of town."
- Pasteur Street: replaced the `repair-5` map phrase with `repair-show-me`, because `repair-5` had ready audio but no primary bundled-audio row in the SQLite graph. The visible traveler job stays the same: ask someone to show the nearby doorway/pin with the phone open.
- Regenerated `content-draft/viet/city-library/v1.json`, `native-ios/Resources/viet-phrase-catalog.json`, `native-ios/Resources/viet-authored-listing-pages.json`, and the Viet SQLite fixture after the source fix.
- Recaptured the native screenshot proof folder after the Lotte copy/card fix and Pasteur phrase/audio fix.

## Freshness Sources Checked

- Da Nang International Airport guide and facilities pages: `https://danangairport.vn/airport-guide` and `https://danangairport.vn/airport-guide-facilities-service`
- Dong Dinh Museum on Visit Da Nang: `https://visitdanang.travel/en/dong-dinh-museum-2046`
- Pasteur Street history source: `https://www.historicvietnam.com/pasteur-street/`
- Loading T Cafe official site: `https://www.loadingtcafe.com/`
- Lotte Mart official Da Nang store page: `https://lottemart.com.vn/he-thong/sieu-thi-lotte-mart-da-nang/`

Freshness result: PASS for visible copy. Exact hours, prices, payment rules, ticket rules, pickup doors, and mutable food-court/service status are omitted or softened. Where the copy uses an unstable setting, it tells the reader to check rather than asserting a current operational fact.

## Authoring Proof

| Page | Closest canonical anchor | Page-specific difference | Owned traveler moment |
|---|---|---|---|
| Da Nang International Terminal | Airport / first-arrival behavior; Ba Na Hills-style expectation setting only for practical sequencing | Arrival is not scenic or cultural; it owns immigration-baggage-SIM-cash-pickup order | Getting from the international terminal into a clearly identified car without splitting the group |
| Dong Dinh Museum | Da Nang Museum / Cham Museum culture-stop anchors | Small private garden-house stop on Sơn Trà, not a central museum | Slowing down among shade, houses, ceramics, and peninsula context before or after Lady Buddha |
| Pasteur Street | Đồng Khởi Street / Japan Town Saigon street anchors | Less romance, more street-name orientation and doorway finding | Using one doorway, map pin, or District 1 errand to make the next few blocks readable |
| Loading T Cafe | Cà phê Đinh / The Note Coffee upstairs-cafe anchors | Focuses on the Chân Cầm second-floor pause and cinnamon-leaning egg coffee | Finding the upstairs room, ordering first, then taking the short Old Quarter reset |
| Lotte Mart Da Nang | Hàn Market / Cồn Market, inverted into indoor practical shopping | Not market texture or bargaining; predictable shelves and lower decision pressure | Restocking water, sunscreen, toiletries, snacks, and simple groceries before the next ride, beach time, or hotel reset |

## Review Table

| Page | Process provenance | Evidence | Voice | Source object | Phrase/audio | Catalog links | Freshness | Render proof | Result |
|---|---|---|---|---|---|---|---|---|---|
| Da Nang International Terminal | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| Dong Dinh Museum | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| Pasteur Street | PASS | PASS | PASS | PASS after primary-audio phrase swap | PASS | PASS | PASS | PASS after recapture | PASS |
| Loading T Cafe | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS | PASS |
| Lotte Mart Da Nang | PASS | PASS after food-court removal | PASS | PASS | PASS | PASS after Sunscreen proof cleanup | PASS after food-court removal | PASS after recapture | PASS |

## Commands Run

- `node native-ios/scripts/import-viet-city-handwritten-copy.js`
- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/guard-native-only.js`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `jq empty docs/design/city-pages/V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`
- V2.2 schema-shape check against the five redo source records
- Lotte stale-copy scan across source, generated JSON, SQLite, and native card copy
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=SpeakLocal City Pages' -only-testing:SpeakLocalNativeTests/PhrasePageFixtureTests -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests -only-testing:SpeakLocalNativeTests/AppChromeTests`
- `SPEAKLOCAL_V22_CITY_PAGE_PROOF_DIR='.../screenshots/v2-2-native-production-2026-05-24' xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=SpeakLocal City Pages' -only-testing:SpeakLocalNativeUITests/BrowseSearchUITests/testCaptureV22CityPageProductionProof`

## Results

- Native-only guard: PASS.
- City production copy validator: PASS, 5 hubs, 500 city noun pages, 500 unique target heroes.
- City library validator: PASS, 806 pages, 706 beginner, 95 intermediate, 5 advanced.
- Hero image asset validator: PASS, 524 active premium hero assets checked.
- SQLite fixture validator: PASS, 1758 canonical pages, 0 release-blocking missing audio rows, 150 ready city audio phrase rows, 656 planned city audio phrase rows.
- V2.2 source JSON: PASS, valid JSON and schema-shape check passed for 5 records.
- Lotte stale-copy scan: PASS for old food-court visible copy and internal "trip fixes" card proof. The only remaining `food-court status` text is the internal V2.2 source note saying visible copy avoids it.
- Pasteur audio gate: PASS after swapping the visible repair phrase to `repair-show-me`; city Useful Phrases rows have bundled audio.
- Native focused set: PASS, 277 tests, 26 skipped, 0 failures.
- Native screenshot proof: PASS, 1 UI test, 0 failures, 10 screenshots captured.

## Hard Blockers

None remaining.

The initial Lotte Mart receipt would have been `REVISE` under the reusable gate because visible copy depended on an unstable food-court claim and one native card proof sounded like internal page-function language. Both were fixed and revalidated.

The initial Pasteur phrase/audio proof would also have been `REVISE`: the phrase was playable in practice but did not satisfy the stricter SQLite primary-audio gate. The source now uses `repair-show-me`, and the regenerated fixture passes the city Useful Phrases audio validator.

## Do Not Change

- Do not turn the authoring proof table into a writing script.
- Do not promote these five into the canonical v2.2 example set from this receipt alone.
- Do not reintroduce visible hours, ticket prices, pickup doors, food-court status, or payment rules unless a fresh source check supports them and the exact claim is worth the risk.

## Decision

Final status: PASS.

Promotion status: `production_ready_native_passed` for the five scoped pages.
