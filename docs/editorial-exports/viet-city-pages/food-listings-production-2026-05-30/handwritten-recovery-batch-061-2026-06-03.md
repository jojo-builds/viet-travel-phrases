# Handwritten Recovery Batch 061

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 304 / 520
- Remaining: 216

## Scope

1. `viet-family-city-hcmc-place-saigon-river` - Saigon River
2. `viet-family-city-hcmc-place-saigon-river-boat` - Saigon River boat ride
3. `viet-family-city-hcmc-place-saigon-skydeck` - Saigon Skydeck
4. `viet-family-city-hcmc-place-saigon-square` - Saigon Square
5. `viet-family-city-hcmc-place-southern-women-museum` - Southern Women's Museum

## Editorial Result

Batch 061 continued the positive-proof-first recovery across central Saigon river, viewpoint, shopping, and museum pages. The useful phrase cards and related-place links stayed intact.

- Saigon River now explains the river as a real city waterline: boats, bridges, skyline, riverbanks, Thu Thiem, haze, and construction edges in one view.
- Saigon River boat ride now keeps the boarding point, return point, weather, and waterline route clear without turning the page into a checklist.
- Saigon Skydeck now reads as an indoor observation-deck view over the river, rooftops, streets, and skyline rather than a generic viewpoint.
- Saigon Square now gives a concrete indoor bargain-shopping picture: clothes, bags, small counters, cooler air, price checks, size/color questions, and a first comparison lap.
- Southern Women's Museum now explains the museum for a first-time U.S. reader: southern Vietnamese women's history, wartime roles, family life, clothing, photographs, textiles, and personal objects in calmer indoor rooms.

Drift fixes folded in:

- Replaced command/checklist openings such as `Start with...`, `Choose it when...`, and `Have simple questions ready...` with natural traveler context.
- Replaced visible app-rationale phrasing with place-specific observations.
- Kept copy useful and concrete instead of shrinking it to pass a wording ban.
- Confirmed the V2.2 source file is the durable source for this batch, then reran projection so handwritten and bundled resources match.

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

- `viet-family-city-hcmc-place-southern-women-museum`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-061-screenshots/001-hcmc-southern-women-museum-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Patch the V2.2 source first when the projection step owns the downstream handwritten file.
- Preserve phrase cards and related links; fix the visible prose around them.
- Convert command-heavy itinerary copy into concrete place context.
- Keep checking rendered copy for human-facing value, not just validator pass status.
