# Handwritten Recovery Batch 058

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 289 / 520
- Remaining: 231
- Hue status: complete under the current handwritten recovery pass

## Scope

1. `viet-family-city-hue-place-tu-hieu-pagoda` - Tu Hieu Pagoda
2. `viet-family-city-hue-place-vong-canh-hill` - Vong Canh Hill
3. `viet-family-city-hue-place-vy-da` - Vy Da
4. `viet-family-city-hue-place-walking-street` - Hue Walking Street
5. `viet-family-city-hue-place-y-thao-garden` - Y Thao Garden

## Editorial Result

This batch used the positive-proof-first recovery method: write the place, scene, first move, and story spine in natural traveler-facing language before letting validators review drift.

- Tu Hieu now introduces Thich Nhat Hanh in plain English as a Vietnamese Zen teacher and peace activist, then grounds the visit in active monastery life, pine shade, incense, worship areas, and filial piety.
- Vong Canh now reads as a modest pine viewpoint on the royal-tomb side of Hue, with Perfume River bends, countryside light, pickup planning, and distance guidance in normal trip language.
- Vy Da now explains the neighborhood as a lived-in river area with lanes, cafes, homestays, local food edges, and the literary echo of Han Mac Tu's poem, without assuming the reader already knows the name.
- Hue Walking Street now separates the riverside walk from the livelier Pham Ngu Lao / Chu Van An / Vo Thi Sau night-street area, with evening planning that does not sound like a fixed show.
- Y Thao Garden now presents the restaurant as an old Hue house meal inside the Citadel area, with garden seating, lanterns, woven mats, ceramics, wood furniture, and shared Hue dishes.

Heartbeat fixes folded in before closure:

- Removed visible phrase-card rationale language such as `The photo phrase matters`, `The distance phrases belong`, `The direction phrases matter`, and `The recommendation phrase fits`.
- Replaced those lines with human-facing guidance about monastery photos, west-side ride planning, Vy Da area bearings, and Y Thao table guidance.
- Cleaned the current batch for direct saved-list language, `Related because:` source leakage, label-like `useful for` copy, `works well`, `best`, `not a`, and overused `quiet` / `enough` drift.
- Preserved useful phrase cards and related links.

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

- `viet-family-city-hue-place-y-thao-garden`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-058-screenshots/001-hue-y-thao-garden-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Continue the next batch with positive proof first, validators second.
- Do not fix phrase-card rationale leaks by removing phrase cards; rewrite visible copy so the phrase card simply feels natural in the travel moment.
- Do not let source `reason` fields use `Related because:` or visible app-internal labels, even if the field does not currently render.

## Post-Receipt Polish

After a heartbeat editorial review, Batch 058 received a light final polish and the full validation chain was rerun successfully:

- Tu Hieu: replaced `The visit is small in the right way` with a more direct visual sentence about calm details, tiled roofs, incense, and monastery movement.
- Vong Canh: replaced `The draw is...` with a more immediate sentence about what the hill gives the reader.
- Vy Da: replaced an explanatory `works best` sentence with a simpler route-fitting sentence.
- Hue Walking Street: made the riverside/night-street contrast more vivid and less mechanical.

Post-polish validation result: PASS on the same full command chain listed above.
