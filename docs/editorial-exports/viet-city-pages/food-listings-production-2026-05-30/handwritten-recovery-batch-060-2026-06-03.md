# Handwritten Recovery Batch 060

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 299 / 520
- Remaining: 221

## Scope

1. `viet-family-city-hcmc-place-pho-nam` - Southern pho
2. `viet-family-city-hcmc-place-post-office` - Saigon Central Post Office
3. `viet-family-city-hcmc-place-rex-hotel-rooftop` - Rex Hotel rooftop
4. `viet-family-city-hcmc-place-russian-market` - Russian Market
5. `viet-family-city-hcmc-place-saigon-railway-station` - Saigon Railway Station

## Editorial Result

Batch 060 continued the positive-proof-first pass across a mixed Saigon batch: dish, landmark, rooftop, market, and station.

- Southern pho now defines `Phở Nam` as southern pho and explains the table-finished Saigon pattern: herbs, sprouts, lime, chili, sauces, and broth-first tasting.
- Saigon Central Post Office now keeps the actual landmark in view: yellow French-era facade, arched hall, old maps, postcard counters, public postal use, Notre-Dame nearby, and scooter pressure outside.
- Rex Hotel rooftop now reads as a rooftop bar visit, not a free viewpoint: table, drink, Nguyen Hue, City Hall, dusk angle, weather risk, and street-level pairing.
- Russian Market now stays concrete: indoor aisles, jackets, bags, textiles, price questions, browsing laps, and market texture instead of mall polish.
- Saigon Railway Station now carries the travel-day sequence: tickets, route boards, platform questions, waiting areas, station doors, bags, and traffic outside.

Drift fixes folded in:

- Removed `Related because:` from current-batch related reasons.
- Removed `Go for` / `Come for` style instruction from Rex rooftop.
- Replaced dish-page rationale reasons with normal trip-building reasons for named phở shops.
- Kept useful phrase cards and related links intact.

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

- `viet-family-city-hcmc-place-saigon-railway-station`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-060-screenshots/001-hcmc-saigon-railway-station-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Continue introducing Vietnamese food/style terms at first mention.
- For transit pages, write the physical sequence the traveler will actually follow.
- For related cards, keep source reasons clean even when they do not render.
