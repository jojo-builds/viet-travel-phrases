# Handwritten Recovery Batch 031

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered five HCMC V2.2 source listings:

- `viet-family-city-hcmc-place-mariamman-temple`
- `viet-family-city-hcmc-place-mien-dong-bus-station`
- `viet-family-city-hcmc-place-mien-tay-bus-station`
- `viet-family-city-hcmc-place-motorbike-food-tour`
- `viet-family-city-hcmc-place-municipal-theatre-square`

Progress after this batch: 154 / 520 recovered, 366 remaining.

## Human Rewrite Notes

- Mariamman Hindu Temple now explains the Tamil Hindu / Goddess Mariamman context, its Ben Thanh / central Saigon setting, and why it differs from nearby pagodas, churches, markets, and hotel streets.
- Mien Dong Bus Station now warns about old/new terminal ambiguity and makes the station name, address, operator, ticket counter, and pickup point the visible travel-day job.
- Mien Tay Bus Station now makes the western / Mekong Delta role legible with Can Tho and Ca Mau route examples, instead of relying on vague compass language.
- Saigon motorbike food tour now reads as an activity format, not a place: guided ride, pickup, timing, helmet, rain plan, diet limits, and multiple food stops.
- Lam Son Square was lightly polished around the Opera House, Dong Khoi, show-entry, photo, pickup, and meeting-point role.

## Review Loop

Two sub-agent reviews were used:

- Factual/source-risk QA: `019e8a97-3a3f-7e30-b607-d6ab13b89840`
- Human-readability QA: `019e8a97-485b-7b51-a710-aa18499cb022`

Reviewer-driven fixes applied:

- Added Mariamman / Tamil Hindu context and removed abstract `temple detail` language.
- Added old/new Mien Dong terminal caution after factual QA flagged it as the highest real-world risk in the batch.
- Clarified Mien Tay as the Mekong Delta / western terminal and contrasted it with Mien Dong.
- Replaced motorbike food tour walking phrase cards with pickup-point, time, and vegetarian cards.
- Replaced motorbike `crowded District 1 map` language with a plainer guide-and-route explanation.
- Removed local visible formula hits such as `pause`, `the value is`, and `not just` before final validation.

## Validation

Command chain passed:

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

- V2.2 strict production validation: PASS
- Voice audit failures: none
- City copy validation: PASS
- City library validation: PASS
- SQLite fixture validation: PASS
- Production QA audit: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator build/run succeeded on `SpeakLocal City Listings` with launch arg:

```sh
--detail-page viet-family-city-hcmc-place-motorbike-food-tour
```

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-031-screenshots/001-hcmc-motorbike-food-tour-top.jpg`

The Simulator was left open on the revised Saigon motorbike food tour listing for Jojo review.

## Phone Build

Physical iPhone build and install were run via the SpeakLocal device-build helper with `SPEAKLOCAL_REPO_ROOT` pointed at this worktree.

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the phone was locked
- Signing hygiene: repo project files stayed clean
