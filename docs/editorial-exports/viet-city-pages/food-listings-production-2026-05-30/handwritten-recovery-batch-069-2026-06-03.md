# Handwritten Recovery Batch 069

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered / polished in this batch: 8
- Total recovered: 355 / 520
- Remaining: 165
- City note: HCMC continuity batch after Batch 068.

## Scope

1. `viet-family-city-hcmc-place-cafe-hop-nguyen-hue` - Nguyen Hue cafe hop
2. `viet-family-city-hcmc-place-cafe-vot-pham-ngoc-thach` - Pham Ngoc Thach cloth-filter coffee
3. `viet-family-city-hcmc-place-che` - Sweet soup dessert
4. `viet-family-city-hcmc-place-cheo-leo-cafe` - Cheo Leo Cafe
5. `viet-family-city-hcmc-place-cho-lon` - Cho Lon
6. `viet-family-city-hcmc-place-cho-lon-walking-route` - Cho Lon walking route
7. `viet-family-city-hcmc-place-ciel` - CieL
8. `viet-family-city-hcmc-place-city-hall` - Ho Chi Minh City Hall

## Editorial Result

Batch 069 kept the useful place and dish context while removing remaining command/template seams: `keep it short`, `the point`, `remember`, `come for`, `start with`, `give it`, `why ... matters`, `anchor`, and similar app-like phrasing.

- Nguyen Hue cafe hop now explains the 42 Nguyen Hue starting point, one or two upstairs rooms, balcony views, facade clues, and the walking-street return.
- Pham Ngoc Thach cloth-filter coffee now defines `cà phê vợt` as net/cloth-filter coffee, with filter, pot, counter, glass, ice, and simple order context.
- Chè now explains the dessert category through coconut milk, beans, jelly, fruit, tapioca, shaved ice, warm/cold display cues, and pointing.
- Cheo Leo now presents the old visible coffee method: cloth filter, clay pot, condensed milk, ice, compact shop, and 1938 family-room context.
- Chợ Lớn now gives first-time context for Saigon's Chinatown area through Bình Tây Market, Thiên Hậu Temple, medicine/dried-goods streets, incense, trade, and short rides.
- Chợ Lớn walking route now explains why the area is not one neat loop: market center, temple pause, nearby walking, and longer gaps by taxi/Grab.
- CieL now frames the Thao Dien tasting-menu dinner through a villa room, open kitchen, Vietnamese ingredients, French technique, wine, and a full-evening pace.
- City Hall now explains the People's Committee building as the formal outside landmark at the north end of Nguyen Hue, with facade, boulevard light, statue, and exterior-view limits.

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

- `viet-family-city-hcmc-place-city-hall`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-069-screenshots/001-hcmc-city-hall-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Words such as `anchor`, `point`, `remember`, `give it`, `come for`, and `why ... matters` often recreate content-system voice even when the underlying idea is correct.
- For cultural districts, make the area concrete through named stops, shop types, worship spaces, ride/walk reality, and why the district differs.
- For tasting-menu restaurants, explain the room, kitchen, pacing, ingredients, and reservation rhythm before relying on awards.
- For civic landmarks, clarify whether the value is outside view, interior access, route orientation, or current-registration logistics.
