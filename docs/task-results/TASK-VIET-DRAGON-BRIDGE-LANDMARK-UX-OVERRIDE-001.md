# TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001

Status: `BLOCKED_NOT_IMPORTED`

The Dragon Bridge override was reviewed and tested, but it was not committed into source/runtime resources because the required live rendered-page review did not pass.

## Incoming Override

- Raw incoming path: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/incoming-chatgpt/`
- Completed patch files: `page_patch`, `section_patch`, `phrase_row_patch`, `renderer_directives_patch`, and `validator_rules_patch`
- Raw incoming files were preserved unchanged.

## Gate Results

- Traveler/editorial review: `APPROVE`
- Canonical/import safety review: `APPROVE`
- Live rendered-page review: `BLOCK`

The copy itself passed the traveler task-flow review. The blocked item was the top rendered page: it still used the generic Vietnam masthead instead of a Dragon Bridge / Cầu Rồng-specific landmark image. The task card explicitly forbids adding or replacing images, and no existing Dragon Bridge-specific image asset was available in `native-ios/Resources/Assets.xcassets`.

## Alias Resolution

- Incoming patch page ID: `viet-phrase-city-danang-place-dragon-bridge`
- Current generated authored page ID: `viet-family-city-danang-place-dragon-bridge`
- Canonical phrase ID: `city-danang-place-dragon-bridge`
- Import safety review confirmed the patch should resolve by phrase ID/current canonical family mapping, not by blindly creating a duplicate page from the stale exported page ID.

All visible target rows resolved exactly once during the dry-run/apply attempt:

- `city-danang-place-dragon-bridge`
- `city-danang-go-dragon-bridge`
- `city-danang-where-dragon-bridge`
- `ves-drop-near-dragon-bridge`
- `city-danang-stop-dragon-bridge`
- `ves-take-photo-for-me`
- `city-danang-atm-dragon-bridge`
- `city-danang-eat-near-dragon-bridge`

## Validator Guardrail Outcome

The incoming validator rules and the prototype validator path were checked during the attempted import. They targeted these internal/user-facing leak terms:

- `anchor`
- `place name`
- `useful moments`
- `where-question`
- `route phrase`
- `connect to`
- `this page`
- `relationship rows`

Because the import failed the final live rendered-page gate, the source/runtime import and validator-code changes were rolled back rather than committed as a half-passed task.

## Validation Attempt

These checks passed before the live rendered-page gate blocked the final import:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`

The blocked import was then reverted so no runtime/source override ships without the required live approval.

## Proof Artifacts

- Approval overlay: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/approval-overlay.json`
- Traveler review: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/traveler-editorial-review.md`
- Import safety review: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/canonical-import-safety-review.md`
- Live review: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/live-rendered-page-review.md`
- Final decision: `docs/editorial-exports/viet-canonical-pages/dragon-bridge-ux-copy-override-v2/agent-approved-import/final-decision.json`
- Top screenshot: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001/dragon-bridge-top.jpg`
- Mid screenshot: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001/dragon-bridge-mid.jpg`
- Lower screenshot: `docs/task-results/assets/TASK-VIET-DRAGON-BRIDGE-LANDMARK-UX-OVERRIDE-001/dragon-bridge-lower.jpg`

## Forbidden Path Proof

- No audio was generated.
- No image was added or replaced.
- No native UI, signing, provisioning, or project setting change is included in the final commit.
- The attempted source/resource import was rolled back after the live review block.

## Phone Test Term

After the follow-up image/hero blocker is cleared and the import is rerun, Jojo should test:

- `Cầu Rồng`

## Recommended Next Step

Create a follow-up task that explicitly allows a production-quality Dragon Bridge hero asset, then rerun this same override import and live rendered-page review. The patch copy and canonical links are ready; the blocker is the landmark-specific top visual.

## Commit

- Commit hash: recorded in the final Codex response after commit creation.
