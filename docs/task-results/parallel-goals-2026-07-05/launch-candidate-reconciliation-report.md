# SpeakLocal Launch Candidate Reconciliation Report

Date: 2026-07-05 Asia/Manila local
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Branch: `main`
Head: `07a2db5d8 Record launch readiness phone proof`
Remote state: `main...origin/main [ahead 20]`

## Scope Boundary

This was a read-only reconciliation run over dirty `main`. I did not stage, commit, pull, rebase, merge, reset, clean, or regenerate resources.

## Branch And Lane Truth

- Current `main` is ahead of `origin/main` by 20 commits.
- `HEAD` is `07a2db5d8`, shared by most non-paywall feature/worktree lanes.
- `feature/paywall` remains separate at `775687823`.
- `feature/messages-section` remains separate at `04dd789f2`.
- `./scripts/status.sh` confirmed the main worktree is dirty and the non-paywall lanes are mostly aligned to `07a2db5d8`; the `city-pages` worktree also has unrelated modified screenshot artifacts.

## Dirty Tree Classification

Tracked modified files: 119 files, 11133 insertions, 14257 deletions.

Untracked non-ignored files: 1597 files.

Signing hygiene check:

- `native-ios/project.yml`: clean
- `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean

### Tracked Source Content

These appear to be launch/audio/source edits that feed generated resources and runtime copy:

- `content-draft/viet/breakdown-audit/audit/rendered-breakdown-audit.json`
- `content-draft/viet/city-library/v1.json`
- `content-draft/viet/menu/items/coffee/drink-ca-phe-sua-da.json`
- `content-draft/viet/menu/speaklocal_vietnamese_full_menu_detail_copy.csv`
- 70 canonical page JSON files under `content-draft/viet/canonical-pages/`
  - 51 catalog-promoted pages, mostly airport, directions, food/drink, health, hotel, phone/internet/power, shopping, and transport rows.
  - 19 tier-one food/drink pages plus `_tier-one-index.json`.

### Tracked Native App Code

These appear to belong to launch-readiness and deep visual QA fixes:

- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/App/Models/AppChrome.swift`
- `native-ios/App/Models/BrowseSearchDestinations.swift`
- `native-ios/App/Models/PracticeScenarioBuilder.swift`
- `native-ios/App/Models/VietnameseMenuCatalog.swift`
- `native-ios/App/Views/AdminPhotoBackdropSurfaceView.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Views/BrowseCollectionPageView.swift`
- `native-ios/App/Views/BrowsePageView.swift`
- `native-ios/App/Views/PracticeView.swift`
- `native-ios/App/Views/SearchPageView.swift`
- `native-ios/App/Views/VietnameseMenuPageView.swift`

Observed fix themes:

- Home photo-backdrop/chrome scroll performance and restoration.
- Browse fallback category routing for airport/hotel.
- Browse detail back/back root reset.
- City header save/favorite and Saved trip city persistence.
- City/category top section jump chrome.
- Practice native sheet top clearance.
- Search/chrome interaction and route restoration.
- Vietnamese menu location/related card lookup for city-prefixed IDs.

### Tracked Tests And Harnesses

These appear to be the proof harness for frontend QA/deep visual QA:

- `native-ios/Tests/AppChromeTests.swift`
- `native-ios/Tests/PhrasePageFixtureTests.swift`
- `native-ios/Tests/PracticeNativeMVPTests.swift`
- `native-ios/Tests/PracticeScenarioModeTests.swift`
- `native-ios/Tests/SQLiteLanguagePackRepositoryTests.swift`
- `native-ios/UITests/AdminChromeUITests.swift`
- `native-ios/UITests/AudioTapReliabilityUITests.swift`
- `native-ios/UITests/BaNaHillsJourneyProofUITests.swift`
- `native-ios/UITests/BackSwipeUITests.swift`
- `native-ios/UITests/BrowseSearchUITests.swift`
- `native-ios/UITests/PracticeUITests.swift`

Observed proof themes:

- Not-spicy breakdown audio.
- Row audio taps across Search/Menu/Saved.
- Saved unsave.
- Search recovery cards and related chips.
- City save and Browse-by section jumps.
- Fast Browse detail back/back blank-canvas regression.
- Top forward button restore.
- Practice sheet header clearance geometry.
- Updated stale content/render expectations.

### Tracked Generators, Validators, And Generated Resources

Generator/validator changes:

- `native-ios/scripts/generate-authored-tier-one-pages.js`
- `native-ios/scripts/generate-viet-sqlite-fixture.js`
- `native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `native-ios/scripts/validate-viet-hero-image-assets.js`
- `native-ios/scripts/validate-viet-sqlite-fixture.js`

Generated/native resources:

- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/viet-audio-manifest.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-phrase-catalog.json`

Observed generated-resource story:

- Planned audio queue was reduced from 778 rows to header-only in `docs/audio-queues/viet-planned-missing-audio.csv`.
- SQLite validation now reports `0` missing audio rows, `0` planned missing audio rows, and `0` release-blocking missing audio rows.
- Audio manifest validation currently reports `5353` entries with matching files. Existing docs mention `5352`; the current tree has one more manifest entry than that older receipt, likely from the deep visual QA not-spicy audio fix.

### Tracked Docs And Ops

Durable docs:

- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/VIET_PREMIUM_EXPANSION_PLAN.md`

Operational docs:

- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`

Ops app readiness:

- `ops/apps/viet.json`

Other tracked artifact:

- `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-top-hero.png`

### Untracked Non-Ignored Files

Task result receipts/proofs:

- `docs/task-results/deep-visual-qa-2026-07-05/`: 2 files.
- `docs/task-results/frontend-qa-2026-07-04/`: 480 files.
- `docs/task-results/launch-readiness-audit-2026-07-04/`: 66 non-ignored files.
- `docs/task-results/parallel-goals-2026-07-05/`: 4 goal files before this report; this report is now an additional untracked file.

Audio files:

- `native-ios/Resources/Audio/`: 1045 untracked mp3 files.
- Prefix split: 779 `breakdown-*.mp3`; 266 `menu-order-*.mp3`.

Note: there are many ignored files under some task-result runtime/proof folders. They are not part of `git ls-files -o --exclude-standard`.

## Ownership Mapping

### Launch-Readiness Audit

Likely belongs here:

- Home scroll/chrome performance changes in `AppShellView.swift`, `AdminPhotoBackdropSurfaceView.swift`, `NativeGlass.swift`, and related `AppChromeTests`.
- Browse fallback routing for airport/hotel in `BrowseSearchDestinations.swift` and proof expectations.
- City/menu/relationship source truth alignment.
- `docs/task-results/launch-readiness-audit-2026-07-04/`.
- Operational doc updates around new-phone proof, Home scroll fix, and non-paywall payload state.

### Frontend QA And Deep Visual QA Fixes

Likely belongs here:

- Search hit-test/chrome repairs.
- Back/forward and Home restoration repairs.
- Browse city save/favorite and section jump repairs.
- Practice sheet top clearance.
- Row/breakdown audio UI coverage.
- UI test harness hardening for visible geometry and nonzero proof expectations.
- `docs/task-results/frontend-qa-2026-07-04/`.
- `docs/task-results/deep-visual-qa-2026-07-05/`.

### Audio Remediation

Likely belongs here:

- 1045 new audio mp3s under `native-ios/Resources/Audio/`.
- `native-ios/Resources/viet-audio-manifest.json`.
- `native-ios/Resources/viet-authored-audio-audit.json`.
- `docs/audio-queues/viet-planned-missing-audio.csv`.
- SQLite/report/resource updates showing missing/planned audio queue cleared.
- Generator changes that reuse exact normalized audio for breakdown tokens.

### Generated Collateral

Likely generated from the above source/code changes:

- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `content-draft/viet/city-library/v1.json`
- `content-draft/viet/breakdown-audit/audit/rendered-breakdown-audit.json`

### Review Before Stage

These need human or orchestrator review before a commit-ready stage:

- `ops/apps/viet.json`: clears `system`, `detail`, and `nextHumanAction` fields while setting `blockerTag` to `blocked:none`. This may be intended dashboard semantics, but it should be confirmed before staging.
- `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-top-hero.png`: modified tracked proof/artifact PNG. Confirm it is deliberate launch evidence, not stale local artifact churn.
- `docs/VIET_PREMIUM_EXPANSION_PLAN.md`: durable roadmap doc changed during launch validation. Review for product-decision language before staging.
- Generated resources are coherent under validators, but the exact generator commands were not rerun in this reconciliation lane.

## Validation Run

All commands below passed:

- `git diff --check`
- `node scripts/guard-native-only.js`
- `node native-ios/scripts/guard-native-chrome.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `1793` canonical pages, `11728` relations, `3800` practice steps.
  - `0` missing audio rows.
  - `0` planned missing audio rows.
  - `0` release-blocking missing audio rows.
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check`
  - `1793` pages, `0` blockers, `0` majors, `0` missing-audio priority rows.
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - `150` strong, `0` thin/awkward/placeholder-like/needs-work.
- `node native-ios/scripts/validate-vietnamese-menu-copy.js`
  - `355` handwritten menu pages, `15` ready helper phrases.
- `node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production`
  - `520` pass, `0` revise, `0` fail.
- `node native-ios/scripts/validate-viet-search-only-surfacing.js`
  - `315` keep-search-only rows, `315` generated relations, `315` generated section items.
- `node native-ios/scripts/validate-viet-breakdown-audit.js`
  - PASS, `1407/1273` reviewed entries as reported by the script.
- `node native-ios/scripts/validate-viet-catalog-promoted-authoring.js`
  - `770` authored pages, `770` rationale records.
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
  - `520` city-library places checked, `524` active premium hero assets checked.
  - Unique city-place hero asset gate intentionally skipped unless run with `--require-unique-city-place-assets`.
- `node native-ios/scripts/sync-viet-audio.js`
  - `5353` native audio manifest entries validated in `native-ios/Resources/Audio`.

No native simulator, Xcode, or phone validation was run in this reconciliation lane.

## Recommended Staging Groups

### Must-Stage For Current Launch Candidate

Stage together as one coherent launch-candidate checkpoint after review:

- Native app code changes under `native-ios/App/`.
- Native test and UI-test changes under `native-ios/Tests/` and `native-ios/UITests/`.
- Content source edits under `content-draft/viet/`.
- Audio remediation files: manifest, authored audio audit, planned-audio queue CSV, and the 1045 untracked audio mp3 files.
- Generated native resources: phrase catalog, authored listing pages, SQLite fixture, and SQLite report.
- Generator/validator updates needed to reproduce the new audio/resource behavior.
- Operational docs reflecting the actual 2026-07-04/05 validation state.
- Task result receipts for launch-readiness, frontend QA, and deep visual QA.

### Review-Before-Stage

- `ops/apps/viet.json`.
- `native-ios/artifacts/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001/ba-na-top-hero.png`.
- `docs/VIET_PREMIUM_EXPANSION_PLAN.md`.
- The current audio manifest count discrepancy versus older docs (`5353` current validator vs `5352` older receipt).

### Likely Generated Collateral

- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `content-draft/viet/breakdown-audit/audit/rendered-breakdown-audit.json`
- `content-draft/viet/city-library/v1.json`

### Leave-Untracked, Archive, Or Ignore Candidates

- Do not auto-stage all proof screenshots blindly. Stage the task ledgers, receipts, compact summaries, selected proof screenshots, and final report first; review whether every screenshot/video/log under `docs/task-results/frontend-qa-2026-07-04/` is useful in git.
- Do not commit ignored runtime bundles or local build products.
- Do not stage raw local signing or device-identifying logs if any appear in task-result folders.

## Hard Blockers Before Commit

No validation hard blocker was found in this read-only reconciliation.

Remaining commit blockers are review/ownership blockers:

- Confirm `ops/apps/viet.json` field-clearing is intentional.
- Confirm whether to commit the modified tracked Bà Nà PNG artifact.
- Decide how much proof media to keep in git versus summarize in receipts.
- Avoid claiming paywall readiness; paywall remains excluded.
- Avoid claiming perfect audio pronunciation or same-voice consistency without a human listen pass.

## Coherence Verdict

The dirty launch candidate is coherent enough to checkpoint after the review-before-stage items are resolved. The app/content/resource payload, generated resources, and cheap validators tell a consistent non-paywall launch-candidate story: frontend QA fixes, deep visual QA fixes, audio coverage remediation, and generated resource updates are aligned.

It is not yet commit-ready as a blind `git add .` because proof media, `ops/apps/viet.json`, and one tracked PNG artifact need deliberate staging decisions.
