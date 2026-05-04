# TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001

Status: `COMPLETE`

Commit hash: recorded in the final Codex response after commit creation.

## Summary

Imported the approved Dragon Bridge / `Cầu Rồng` landmark copy override through the source-owned city-library path, regenerated Viet resources, validated canonical links, and reviewed the live rendered simulator page. The missing Dragon Bridge-specific hero image is explicitly recorded as `FOLLOW_UP`, not a copy-import blocker.

## Imported Source And Resources

- Source updated: `content-draft/viet/city-library/v1.json`
- Import overlay: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/copy-import/approval-overlay.json`
- Dry run: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/copy-import/import-dry-run.json`
- Apply summary: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/copy-import/import-apply.json`
- Live review: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/copy-import/live-rendered-page-review.md`
- Regenerated resources: `native-ios/Resources/viet-phrase-catalog.json`, `native-ios/Resources/viet-authored-listing-pages.json`, `native-ios/Resources/viet-authored-audio-audit.json`, `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`, `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- Regenerated practice outputs: `content-draft/viet/practice/practice-deck.sample.json`, `prototypes/practice-quiz/practice-deck.sample.json`

## Prior Approval Reused

- Previous task result: `docs/task-results/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001.md`
- Traveler/editorial review: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/traveler-editorial-review.md`
- Canonical/import safety review: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/canonical-import-safety-review.md`
- The previous live block was reclassified as `FOLLOW_UP` because this task explicitly says not to block copy import on the generic masthead.

## Canonical Mapping Proof

- Incoming patch page ID: `viet-phrase-city-danang-place-dragon-bridge`
- Current generated authored page ID: `viet-family-city-danang-place-dragon-bridge`
- SQLite canonical page ID: `viet-phrase-city-danang-place-dragon-bridge`
- Canonical phrase ID: `city-danang-place-dragon-bridge`
- Duplicate Dragon Bridge canonical pages: `0`
- Linked rows resolve exactly once.

## Section Order Proof

Rendered/SQLite order:

1. `Start here`
2. `Say the name`
3. `Getting there`
4. `At the bridge`
5. `Meeting or pickup`
6. `What the name means`
7. `Good to know`
8. `Nearby needs`

Implementation note: the visible `What the name means` section uses the existing `breakdown` section key so the full article contract and breakdown validators remain compatible while the traveler-facing title matches the approved copy.

## Row Grouping Proof

- `Say the name`: `Cầu Rồng`
- `Getting there`: `Đi cầu Rồng`, `Cầu Rồng ở đâu?`
- `At the bridge`: `Bạn chụp giúp tôi được không?`
- `Meeting or pickup`: `Cho tôi xuống gần Cầu Rồng.`, `Dừng ở Cầu Rồng`
- `Nearby needs`: `Có ATM gần cầu Rồng không?`, `Ăn gần Cầu Rồng`

The current-page self row has no detail-page destination. All other visible phrase rows resolve to one canonical page.

## Banned/Internal Wording Scan

Rendered Dragon Bridge landmark-action page scan:

- `anchor`: `0`
- `place name`: `0`
- `useful moments`: `0`
- `where-question`: `0`
- `route phrase`: `0`
- `connect to`: `0`
- `this page`: `0`
- `relationship rows`: `0`

The broader raw repo contains existing editor/source and unrelated page uses of terms such as `anchor`; those are outside this surgical Dragon Bridge copy import and are not new from this task.

## Simulator Proof

- Top page: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001/dragon-bridge-top.jpg`
- Mid page: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001/dragon-bridge-mid.jpg`
- Lower page: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-LANDMARK-COPY-IMPORT-001/dragon-bridge-lower.jpg`

Live rendered-page review outcome: `APPROVE_WITH_FOLLOW_UP`.

## Issue Classifications

- `FOLLOW_UP`: Add a production-quality Dragon Bridge-specific hero asset in `TASK-VIET-DRAGON-BRIDGE-HERO-ASSET-001`.
- `ACCEPTED_TEMPORARY_RISK`: Stale exported `viet-phrase-*` page IDs in the patch were resolved through the current canonical phrase/family mapping.
- `SAFE_FIX_NOW`: Imported task-based landmark copy and added Dragon/landmark-action validator guardrails.
- `HARD_BLOCK`: none.

## Validation

- `node --check native-ios/scripts/import-viet-dragon-bridge-landmark-copy.js`
- `node --check native-ios/scripts/validate-viet-dragon-bridge-landmark-copy.js`
- `node native-ios/scripts/import-viet-dragon-bridge-landmark-copy.js --dry-run --output docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/copy-import/import-dry-run.json`
- `node native-ios/scripts/import-viet-dragon-bridge-landmark-copy.js --apply --output docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/copy-import/import-apply.json`
- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-viet-dragon-bridge-landmark-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' -derivedDataPath native-ios/build/DerivedData build`
- `git diff --check`

## Forbidden Path Proof

- No `native-ios/App/**` edits.
- No `native-ios/Resources/Audio/**` edits.
- No `native-ios/Resources/Assets.xcassets/**` edits.
- No signing, provisioning, or Xcode project setting edits.
- No audio generated.

## Phone Test Term

- `Cầu Rồng`

## Final Status

Final `git status --short`: recorded clean after commit in the final Codex response.
