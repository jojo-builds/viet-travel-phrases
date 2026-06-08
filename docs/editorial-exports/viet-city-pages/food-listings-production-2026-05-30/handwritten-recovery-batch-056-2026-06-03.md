# Handwritten Recovery Batch 056 - 2026-06-03

Status: PASS

Progress: 279 / 520 recovered, 241 remaining.

Scope:
- `viet-family-city-hue-place-the-mieu-temple`
- `viet-family-city-hue-place-thien-mu`
- `viet-family-city-hue-place-thieu-tri-tomb`
- `viet-family-city-hue-place-thuy-bieu-village`
- `viet-family-city-hue-place-thuy-xuan-incense-village`

## Authored Fixes

- The Mieu now explains the place as the Citadel's imperial ancestral temple, where Hue's Nguyen emperors are honored. It connects altars, red lacquer, incense, tiled roofs, and the nearby Nine Dynastic Urns in plain English for first-time visitors.
- Thien Mu now explains the pagoda as Hue's famous Buddhist pagoda above the Perfume River. It removes unsupported frangipani and vague `local memory` wording, while keeping the tower, worship areas, incense, river approach, and dragon-boat relationship.
- Thieu Tri Tomb now names Emperor Thieu Tri and the Nguyen tomb context. It keeps the quieter countryside setting, walls, gates, stone paths, open ground, and low mountain views without `checklist`, `heritage stop`, or expectation-label wording.
- Thuy Bieu Village now explains the garden-house and pomelo-village context: lanes, walls, bicycles, small markets, river air, and why it gives Hue a lived-in garden side after imperial sites.
- Thuy Xuan Incense Village now explains the incense craft process behind the bright displays: bamboo sticks, scented paste, dyed colors, drying racks, and family workshops. It removes awkward photo/shopping sequence wording and makes the west-Hue tomb-route relationship clearer.

## Batch 055 Heartbeat Fixes Included

- Removed direct saved-list calls from recent Hue source, including `save it for`, `Save this`, `Why Save It`, and `Save Thanh Cafe`.
- Tam Giang now opens as a place/context sentence, not a saved-list instruction: Hue opening into fishing traps, low boats, seafood cottages, village water life, and sunset light beyond the imperial-city route.
- Tam Giang's fishing-life section now gives first-time visitor context for brackish working water, bamboo traps, low boats, shrimp, clams, and villages around shallow water.
- Tay Loc now recommends the market through errands, snacks, clothing piles, small-cash shopping, and ordinary Hue market life instead of `useful` or `reason to go` label language.
- Thai Hoa related-card copy no longer contains `Related because:`, and the palace section now makes ceremony physical through columns, roof beams, throne focus, and officials moving through the hall.
- Thanh Toan Bridge was revised again after rendered review so `Step Onto The Bridge` is not a bare checklist. It now gives a fuller bridge/canal/village image while staying concrete.

## QA

- Source-risk QA: `019e8cbb-1aa4-7660-a011-13c52401e283`
  - The Mieu: PASS; Nguyen-emperor worship, red/yellow lacquered altars, and Nine Dynastic Urns supported.
  - Thien Mu: REVISE for unsupported frangipani and unexplained local-memory wording; fixed.
  - Thieu Tri Tomb: PASS; countryside, open setting, stone paths, walls, gates, and low mountain setting supported.
  - Thuy Bieu Village: PASS; pomelo gardens, narrow roads, garden architecture, agriculture, and Perfume River context supported.
  - Thuy Xuan Incense Village: REVISE for operational claim about active making; fixed with softer morning-light and route wording.
- U.S.-traveler readability QA: `019e8cbb-ab10-75c1-8ab2-b5f1cc84b3fa`
  - Overall verdict: REVISE all five for first-mention context, label-ish headings, and abstract route shorthand; all targeted fixes were applied.
  - Phrase cards and related links were preserved and rewritten around, not removed.

Sources referenced by QA included VNAT The Mieu, UNESCO Hue materials, VietnamOnline Thien Mu, Khám Phá Huế Thieu Tri, Vietnam rural tourism Thuy Bieu, Khám Phá Huế Thuy Xuan, and VNAT Thuy Xuan photo coverage.

## Validation

Command:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production &&
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js &&
node native-ios/scripts/validate-viet-city-copy.js &&
node native-ios/scripts/validate-viet-city-library.js &&
node native-ios/scripts/validate-viet-sqlite-fixture.js &&
node native-ios/scripts/audit-viet-listing-production-qa.js &&
git diff --check
```

Result:
- v2.2 projection: 520 entries.
- Strict production validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS, integrity check OK.
- Production QA: 0 blockers, 0 majors, 1 duplicate hero section hidden at render time, 500 missing-audio priority rows.
- `git diff --check`: PASS.

Signing scan:
- PASS: no committed project signing secrets found in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Render Proof

- Simulator left open on Lang huong Thuy Xuan - Thuy Xuan Incense Village:
  - `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-056-screenshots/001-hue-thuy-xuan-incense-village-top.jpg`

## Carry Forward

- The fix for label-language is not shorter copy. It is richer human-facing context that still sounds natural on an iPhone.
- Do not tell the reader to save the page. Make the page save-worthy through the place, scene, history, phrase-card moment, and related-link context.
- Avoid both extremes: no inflated travel-brochure prose, but no stripped-down checklists either.
- Preserve useful phrase cards and related links unless they are genuinely wrong; rewrite the surrounding copy so the affordance belongs to a real traveler moment.
