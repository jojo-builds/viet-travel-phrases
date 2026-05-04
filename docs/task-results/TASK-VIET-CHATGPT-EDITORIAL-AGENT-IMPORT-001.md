# TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001

Status: Completed and committed after importing the agent-approved subset only.

Commit: recorded in the final task response after commit.

## Summary

- Used ChatGPT Batch 001 completed patch files from `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/incoming-chatgpt/completed-patch-files/`.
- Preserved all raw ChatGPT patch files unchanged; they remain `REVIEW_ONLY`.
- Created an agent-gated overlay under `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/`.
- Imported `8` pages that passed both pre-import gates and survived live rendered-page review.
- Skipped `17` pages. Skips are not treated as failures; each skip has a reason or a next product/native-language question.
- No audio was generated. `native-ios/Resources/Audio/**`, `native-ios/App/**`, signing files, and project settings were not changed.

## Incoming artifacts

- `page_patch`: 25 rows
- `section_patch`: 216 rows
- `phrase_row_patch`: 261 rows
- `breakdown_patch`: 88 rows
- `relationship_reorder_patch`: 223 rows
- `renderer_directives_patch`: 25 rows
- `asset_directives_patch`: 25 rows
- `validator_rules_patch`: 10 rows
- `questions_for_jojo`: 25 rows

Raw patch folder: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/incoming-chatgpt/completed-patch-files/`

Agent import folder: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/`

## Imported pages

| Phrase ID | Page ID | Imported shape |
|---|---|---|
| `city-danang-place-dragon-bridge` | `viet-family-city-danang-place-dragon-bridge` | 8 sections, 8 phrase rows, 3 breakdown tokens |
| `city-danang-place-bach-dang-street` | `viet-family-city-danang-place-bach-dang-street` | 11 sections, 9 phrase rows, 3 breakdown tokens |
| `city-danang-place-nguyen-van-linh-street` | `viet-family-city-danang-place-nguyen-van-linh-street` | 11 sections, 9 phrase rows, 3 breakdown tokens |
| `city-danang-go-ba-na-hills` | `viet-family-city-danang-go-ba-na-hills` | 7 sections, 6 phrase rows, 3 breakdown tokens |
| `city-danang-go-dragon-bridge` | `viet-family-city-danang-go-dragon-bridge` | 7 sections, 6 phrase rows, 3 breakdown tokens |
| `city-danang-near-nguyen-van-linh-street` | `viet-family-city-danang-near-nguyen-van-linh-street` | 9 sections, 8 phrase rows, 3 breakdown tokens |
| `v500-airp-bord-arri-where-is-the-taxi-counter` | `viet-phrase-v500-airp-bord-arri-where-is-the-taxi-counter` | 7 sections, 9 phrase rows, 3 breakdown tokens |
| `hotel-9` | `viet-phrase-hotel-9` | 7 sections, 9 phrase rows, 4 breakdown tokens |

## Skipped pages

- `city-hanoi-place-bun-cha-huong-lien`: restaurant page still placed destination/route rows inside the in-restaurant flow.
- `city-hanoi-place-pho-bat-dan`: restaurant page mixed go/stop/where/drop-off rows into inside-the-place ordering flow.
- `city-hoian-place-cao-lau-city`: canonical title decision needed.
- `city-hue-place-bun-bo-city`: dish page retained place-style ATM/eat-near rows for the dish itself.
- `city-danang-place-ba-na-hills`: reference/completed model page, not an active import target.
- `city-danang-place-marble-mountains`: key phrases included a Dragon Bridge route row.
- `city-danang-place-son-tra`: use-it-with rows included an unrelated Dragon Bridge route row.
- `city-danang-place-vo-nguyen-giap-street`: use-it-with rows included a Bach Dang Street route row.
- `city-danang-where-ba-na-hills`: visible use-it-with rows targeted a section missing from the proposed section order.
- `city-danang-ticket-marble-mountains`: canonical ticket-counter wording decision needed.
- `acknowledge-da-chao-anh`: live rendered-page review found the relationship-swap row pointed to `Anh nói tiếng Anh không?`; the page was reverted and deferred.
- `v900-airp-bord-arri-can-you-help-me-track-my-bag`: baggage-desk wording decision needed.
- `v900-hote-acco-can-you-arrange-a-taxi-for-me`: hotel taxi wording decision needed.
- `food-peanut-allergy`: allergy page still surfaced generic food-order rows and weak split-token breakdowns.
- `v500-food-drin-i-am-allergic-to-shellfish`: shellfish wording decision needed.
- `emergency-3`: passport-loss page used generic injury/hospital rows.
- `emergency-hospital`: Tier 1 generated-source lane overwrote the direct source import during regeneration; this needs generator-level Batch 001 import support before durable import.

## Next questions

- `city-hoian-place-cao-lau-city`: Should the canonical title stay `Cao lầu ở Hội An`, or should the page title become `Cao lầu` with Hội An handled as city context?
- `city-danang-ticket-marble-mountains`: Should the canonical phrase remain `Một vé vào Ngũ Hành Sơn`, or should native review add a more polite `Dạ, cho tôi một vé vào Ngũ Hành Sơn`?
- `acknowledge-da-chao-anh`: What relationship/greeting rows should replace the unrelated `Anh nói tiếng Anh không?` row in `Relationship swaps`?
- `v900-airp-bord-arri-can-you-help-me-track-my-bag`: Should this airport baggage page keep `túi`, or move to a more natural baggage-desk phrase using `hành lý` or `kiểm tra hành lý`?
- `v900-hote-acco-can-you-arrange-a-taxi-for-me`: Should the canonical hotel taxi phrase stay formal, or should the shorter `Gọi taxi giúp tôi được không?` become canonical?
- `v500-food-drin-i-am-allergic-to-shellfish`: Should shellfish be taught as `động vật có vỏ`, `hải sản có vỏ`, or a different native-validated allergy phrase?
- `emergency-hospital`: Should Batch 001 import support be extended into the Tier 1 generated-source lane so this approved technical row can import durably?

## Reviewer outcomes

- Reviewer A, traveler/editorial quality: final approved import set is 8 pages; restaurant, dish, allergy, and several place/support rows were skipped for row-flow or product-language concerns.
- Reviewer B, canonical/import safety: 19 pages were technically import-safe, but final import used the stricter intersection with Reviewer A and the live rendered-page gate.
- Reviewer C, live rendered-page review: read representative rendered pages top-to-bottom in simulator. Approved the representative imported pages and blocked `acknowledge-da-chao-anh`; the blocked page was removed from the final approved set before commit.

Review artifacts:

- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/traveler-editorial-review.md`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/canonical-import-safety-review.md`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/live-rendered-page-review.md`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/approval-overlay.json`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/import-dry-run.json`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/import-apply.json`

## Live proof

Simulator build/run succeeded for `SpeakLocalNative` on the booted iPhone 17 Pro simulator after final resource regeneration.

Screenshots:

- `docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/dragon-bridge-top.jpg`
- `docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/dragon-bridge-content.jpg`
- `docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/nguyen-van-linh-street-top.jpg`
- `docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/airport-taxi-counter-top.jpg`
- `docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/hotel-taxi-top.jpg`
- `docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/hotel-taxi-content.jpg`

Restaurant and dish screenshots were not captured because no restaurant or dish rows passed both gates in this batch.

## Validation

- `node --check native-ios/scripts/import-viet-chatgpt-editorial-agent-batch.js`: passed
- `node --check native-ios/scripts/validate-viet-chatgpt-editorial-agent-import.js`: passed
- `node native-ios/scripts/import-viet-chatgpt-editorial-agent-batch.js --dry-run`: passed, 8 approved/importable, 17 skipped
- `node native-ios/scripts/import-viet-chatgpt-editorial-agent-batch.js --apply`: passed, 8 imported, 17 skipped
- `node native-ios/scripts/generate-viet-catalog.js`: passed, 3059 families, 3078 phrases
- `node native-ios/scripts/generate-authored-tier-one-pages.js`: passed, 3070 resource pages
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`: passed, 3070 pages, SQLite integrity ok
- `node scripts/practice/generate-viet-practice-deck.js --check`: passed, 7186 items
- `node native-ios/scripts/validate-viet-chatgpt-editorial-agent-import.js`: passed, 8 approved pages, 8 imported
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: passed, 3070 canonical pages, 0 release-blocking missing audio audit rows
- `node native-ios/scripts/validate-viet-city-library.js`: passed, 750 pages
- `node native-ios/scripts/validate-tier-one-listing-pages.js`: passed, 150 strong Tier 1 pages
- `node native-ios/scripts/audit-viet-canonical-content.js --check`: passed, 3070 PASS
- `node native-ios/scripts/audit-viet-page-quality.js`: passed, 3070/3070
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`: passed
- `node --test scripts/practice/generate-viet-practice-deck.test.js`: passed
- Broad scan for internal/meta/placeholder wording in touched Viet content/resource surfaces: 0 matches
- Forbidden path diff scan for `native-ios/Resources/Audio/**`, `native-ios/App/**`, signing, and project files: 0 matches
- `git diff --check`: passed

## Jojo phone test terms

Search these on the phone after installing the build:

- `Cầu Rồng`
- `Đường Bạch Đằng`
- `Đường Nguyễn Văn Linh`
- `Đi Bà Nà Hills`
- `Đi cầu Rồng`
- `Đường Nguyễn Văn Linh gần đây không?`
- `Quầy taxi ở đâu?`
- `Gọi taxi giúp tôi được không?`

## Final git status --short

```text
 M content-draft/viet/canonical-pages/catalog-promoted/airport-border-arrival/v500-airp-bord-arri-where-is-the-taxi-counter.json
 M content-draft/viet/canonical-pages/catalog-promoted/hotel-accommodation/hotel-9.json
 M content-draft/viet/city-library/v1.json
 M content-draft/viet/practice/practice-deck.sample.json
 M docs/content-audits/viet-canonical-content-audit-001/README.md
 M docs/content-audits/viet-canonical-content-audit-001/issue-summary.json
 M native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json
 M native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite
 M native-ios/Resources/viet-authored-audio-audit.json
 M native-ios/Resources/viet-authored-listing-pages.json
 M native-ios/Resources/viet-phrase-catalog.json
 M prototypes/practice-quiz/practice-deck.sample.json
?? docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/agent-approved-import/
?? docs/task-results/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001.md
?? docs/task-results/assets/TASK-VIET-CHATGPT-EDITORIAL-AGENT-IMPORT-001/
?? native-ios/scripts/import-viet-chatgpt-editorial-agent-batch.js
?? native-ios/scripts/validate-viet-chatgpt-editorial-agent-import.js
```
