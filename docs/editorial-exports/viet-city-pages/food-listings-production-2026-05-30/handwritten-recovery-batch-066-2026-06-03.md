# Handwritten Recovery Batch 066

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered / polished in this batch: 8
- Total recovered: 331 / 520
- Remaining: 189
- City note: HCMC continuity batch after Batch 065, with sidecar review applied to nearby source-risk pages.

## Scope

1. `viet-family-city-hcmc-place-bach-dang-waterbus-station` - Bach Dang Waterbus Station
2. `viet-family-city-hcmc-place-bach-dang-wharf` - Bach Dang Wharf
3. `viet-family-city-hcmc-place-banh-mi` - Banh mi
4. `viet-family-city-hcmc-place-banh-mi-huynh-hoa` - Banh Mi Huynh Hoa
5. `viet-family-city-hcmc-place-banh-xeo` - Southern sizzling pancake
6. `viet-family-city-hcmc-place-banh-xeo-46a` - Banh Xeo 46A
7. `viet-family-city-hcmc-place-nephele` - Nephele
8. `viet-family-city-hcmc-place-nguyen-trai-street` - Nguyen Trai Street

## Editorial Result

Batch 066 removed the next visible drift pattern: direct save-language, command-shaped section headings, app-internal schedule language, and food descriptions that sounded like critique instead of traveler context.

- Bach Dang Waterbus Station now explains the public river bus as transportation, with route, return point, tickets, river air, and boarding details.
- Bach Dang Wharf now separates central riverfront, promenade, wharf area, boat points, sunset light, and nearby skyline context without turning the page into a command checklist.
- Banh mi now defines the sandwich and gives `pâté` a plain-English cue as a rich spread.
- Banh Mi Huynh Hoa now reads as a specific fast Saigon counter with rich fillings, takeaway pace, and bread texture rather than direct `come here` phrasing.
- Banh xeo now explains the sizzling crepe, fillings, southern wrap-and-dip rhythm, and seafood/pork checks without `reads like` critic language.
- Banh Xeo 46A now describes the hands-on table rhythm and wide pancake trays without telling the reader to come for the ritual.
- Nephele now explains the tasting menu, sommelier recognition, pairings, alley arrival, and reservation rhythm without `the point` or negative walk-in framing.
- Nguyen Trai Street now uses shop/block/address context instead of `Go with`, `Start with`, or `Save the...` instructions.

Batch 065 heartbeat patch folded in before validation:

- Akuna now says to leave the evening open for courses, explanations, and slower pace.
- An Dong Market now avoids `loose target` / short-list worksheet phrasing.
- Anan Saigon now converts `the contrast is the point` into visible market/outside and composed/inside details.
- Ao Dai Museum now uses `High Collar, Long Panels` and explains why the dress feels formal, graceful, and recognizable in Vietnam.

Sidecar review:

- Read-only subagent reviewed Bach Dang Waterbus Station, Bach Dang Wharf, Banh mi, Nephele, and Nguyen Trai Street.
- Applied the high-impact findings locally; no subagent edits were made directly.

Focused grep:

- Batch scope passed for `save it`, `save this`, `why save`, `reason to save`, `Related because:`, `the appeal`, `it reads like`, `the value`, `this listing`, `useful as`, `the point`, `What To Notice`, `Start With`, `Come here`, `Come for`, `worth having ready`, `belongs with the app`, and `page should`.

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

Results:

- V2.2 projection: PASS, 520 entries.
- V2.2 strict production validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS.
- Listing production QA: PASS, 0 blockers, 0 majors, 1 duplicate hero section hidden at render-time, 500 missing-audio priority rows.
- `git diff --check`: PASS.

## Render Proof

Simulator profile: `city-listings-production-ready`

Rendered page:

- `viet-family-city-hcmc-place-nguyen-trai-street`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-066-screenshots/001-hcmc-nguyen-trai-street-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Subagent review is useful as a sidecar for batches with known pattern risk, but final copy decisions and edits stay local and item-level.
- Do not copy suggested replacement language blindly when it introduces banned formulas such as `works better`, `the point`, or `not a...`.
- For transportation pages, make the physical action clear: ticket, route, boarding, return point, driver, address, or walk from the curb.
- For food pages, define unfamiliar ingredients or dishes in plain English before leaning on Vietnamese names.
