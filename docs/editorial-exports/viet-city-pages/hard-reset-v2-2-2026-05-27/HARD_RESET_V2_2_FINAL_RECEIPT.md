# City Pages Hard Reset v2.2 Final Receipt

Date: 2026-05-27
Reviewer: Codex hard-reset coordinator, with four independent final gate agents
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages`
Branch: `feature/city-pages`
Commit at review time: `533eaa633`
Dirty-state note: this worktree already contained broad dirty docs/generated/app files before this pass. This receipt records the production-candidate hard-reset state; unrelated pre-existing dirt was not reverted.

## Inventory

Total in-scope listings reviewed: 500
FINAL_PASS listings in first-class V2.2 source: 500
REVISE listings: 0
FAIL listings: 0
Cities covered: Da Nang, Hanoi, Ho Chi Minh City, Hoi An, Hue
Manifest: `content-draft/viet/city-library/app-detail-v2-2/_index.json`
City counts: 100 per city
Inventory is 500+: current V2.2 manifest contains exactly 500 in-scope city/place entries; no extra in-scope entries are excluded by this receipt.
500 shortcut used: no

## Sources and Runtime

Source authority:

- `content-draft/viet/city-library/app-detail-v2-2/_index.json`
- `content-draft/viet/city-library/app-detail-v2-2/danang.json`
- `content-draft/viet/city-library/app-detail-v2-2/hanoi.json`
- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`
- `content-draft/viet/city-library/app-detail-v2-2/hue.json`

Generated compatibility/runtime files:

- `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc,hoian,hue}.json`
- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `content-draft/viet/practice/practice-deck.sample.json`
- `prototypes/practice-quiz/practice-deck.sample.json`

Review docs and gates:

- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `docs/design/city-pages/V2_2_SCREENSHOT_REVIEW_GATE.md`
- `docs/editorial-exports/viet-city-pages/hard-reset-v2-2-2026-05-27/HARD_RESET_V2_2_RUNBOOK_RECEIPT.md`
- `docs/editorial-exports/viet-city-pages/hard-reset-v2-2-2026-05-27/HARD_RESET_V2_2_FINAL_RECEIPT.md`

Legacy city-v1 resources are projection evidence only. No approved listing depends on legacy city-v1 section IDs as source of truth.

## Commands and Output

Regeneration:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node scripts/practice/generate-viet-practice-deck.js
```

Output summary: projected 5 V2.2 city files and 500 entries; imported 500 handwritten city copy entries; generated authored listing resource with 806 city-library pages; generated SQLite fixture with integrity OK; wrote practice deck with 2791 items, 14 scenarios, and 7 question types.

Source and content validators:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-hero-image-assets.js
node scripts/guard-native-only.js
```

Output summary: all passed. V2.2 source validator reported 500 total, 100 per city, 500 `FINAL_PASS`; voice audit reported 0 failures and zero hits for `it fits`, `street fits`, `works as`, `anchor`, and `layer`; city copy validator reported 5 hubs, 500 city noun pages, and 500 unique target heroes; city library validator reported 806 pages; SQLite validator reported 19 scenarios, 1747 clusters, 1765 phrases, 1758 pages, 500 city places, 150 ready-audio city phrase rows, 656 planned-audio city phrase rows, and 0 release-blocking missing-audio audit rows; native-only guard passed.

Test chain:

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.test.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.test.js
node native-ios/scripts/build-viet-city-app-detail-v2-2.test.js
node native-ios/scripts/generate-viet-sqlite-fixture.test.js
node scripts/practice/generate-viet-practice-deck.js --check
node --test scripts/practice/generate-viet-practice-deck.test.js
git diff --check
```

Output summary: all passed. V2.2 validator tests passed 10/10; projection tests passed 2/2; source build test passed 1/1; SQLite fixture test passed 1/1; practice deck check reported 2791 items, 14 scenarios, 7 question types; practice deck contract test passed; `git diff --check` passed before docs receipt updates.

Legacy humanizer scripts:

```sh
node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/validate-humanizer-chunks.js
node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/audit-production-voice.js
node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/audit-production-story.js
```

Output summary: default execution now exits as `LEGACY_REVOKED_NOT_CURRENT_GATE` and points to the current V2.2 validators. These scripts are historical and no longer a current approval path.

Candidate count proof:

```json
{ "entries": 500, "relatedPlaceCandidates": 500, "mentionedHereCandidates": 0, "verificationFlags": 0, "renderableCandidates": 500 }
```

## Screenshot Proof

Screenshot folder: `docs/design/city-pages/screenshots/v2-2-500-story-production-2026-05-27`
Simulator proof: `SpeakLocalNativeUITests/BrowseSearchUITests/testCaptureV22CityPageProductionProof`
Result: passed, 1 test, 0 failures
Xcode result: `native-ios/artifacts/DerivedData-v2-2-hard-reset-final/Logs/Test/Test-SpeakLocalNative-2026.05.27_16-04-01-+0700.xcresult`
Fresh screenshots: 20 PNGs after 2026-05-27 16:04 +0700
Coverage: top and scrolled states for Da Nang airport, Dong Dinh Museum, Pasteur Street, Loading T Cafe, Lotte Mart Da Nang, 3D Art in Paradise, Hanoi bun cha, Ben Thanh Market, Bach Ma National Park, and Hoi An Ancient Town ticket booth.
Issues found during this proof run: none in the test output.

## Phone Proof

Device class: paired physical iPhone
Build result: passed
Install result: passed
Launch result: passed after the phone became unlockable
Signing scan result: passed; repo-visible signing files stayed clean, and no personal signing settings were written to `native-ios/project.yml`, `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`, `native-ios/*.xcconfig`, or `native-ios/Config`
Notes: earlier retries showed the paired iPhone as unavailable or locked. The final retry launched the installed app successfully from this exact final resource state.

## Exclusions and Non-Blocking Backlog

Excluded city/place listings: 0
Missing or planned audio: SQLite validator reports 0 release-blocking missing-audio audit rows and 680 planned missing-audio rows. V2.2 phrase cards reuse existing catalog/audio where possible; planned audio remains a non-blocking catalog backlog.
Hero/image backlog: `validate-viet-hero-image-assets.js` passed the current gate; unique city-place hero asset enforcement remains skipped unless run with `--require-unique-city-place-assets`.
Freshness follow-ups: page-level evidence/freshness notes remain in source QA fields where applicable; none are marked blocking in the current strict validator.
Known non-blockers: source `mentionedHereCandidates` count is 0, but every listing now has at least one renderable related-place candidate, for 500 renderable link candidates total.
Blocking unresolved items: none for Native Runtime / Release.

## FINAL_PASS Signoffs

Authority / Scope: FINAL_PASS
Editorial Voice: FINAL_PASS
Data / Catalog / Audio: FINAL_PASS
Native Runtime / Release: FINAL_PASS

Final decision: FINAL_PASS
Promotion status: production-ready candidate for the 500 in-scope V2.2 city/place listings
Next owner: merge/release coordinator
