# Handwritten Recovery Batch 062

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 309 / 520
- Remaining: 211

## Scope

1. `viet-family-city-hcmc-place-street-food-evening` - Saigon street-food evening
2. `viet-family-city-hcmc-place-takashimaya-saigon-centre` - Takashimaya Saigon Centre
3. `viet-family-city-hcmc-place-tan-son-nhat-airport` - Tan Son Nhat International Airport
4. `viet-family-city-hcmc-place-tao-dan-park` - Tao Dan Park
5. `viet-family-city-hcmc-place-thao-dien` - Thao Dien

## Editorial Result

Batch 062 kept the useful phrase cards and related links while removing visible command/checklist language from the next Saigon group.

- Saigon street-food evening now frames the night as small dishes, sidewalk seats, steam, scooters, and short walks between bites, with food-ordering phrases preserved.
- Takashimaya Saigon Centre now reads as modern central Saigon comfort: cool air, food counters, bathrooms, card-friendly counters, predictable exits, and an easy return outside.
- Tan Son Nhat International Airport now covers the international-arrival moment without overclaiming freshness-sensitive details: immigration, bags, SIM, hotel name, ride plan, terminal changes, and the first traffic handoff.
- Tao Dan Park now gives a concrete shade-and-bench reason for the park without worksheet phrasing.
- Thao Dien now explains the neighborhood as a softer east-side cafe, dinner, gallery, and river-side pocket rather than a vague expat-area label.

Drift fixes folded in:

- Removed `works as` after strict validation caught it.
- Removed top/best style wording after the voice audit caught `best sense`.
- Replaced `Come here`, `This is the stop`, `It belongs`, `Come early`, and similar visible command/rationale phrasing with traveler-facing context.
- Preserved phrase-card utility instead of stripping sections down.

Post-receipt heartbeat polish:

- Street-food evening pacing now reads as observed rhythm instead of visible coaching.
- Tao Dan Park now uses observed park details under the trees and a fuller ordinary-use reason.
- Thao Dien now avoids app-rationale contrast and frames the river crossing as a mood shift toward cafes, dinner, galleries, and quieter streets.

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

- `viet-family-city-hcmc-place-thao-dien`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-062-screenshots/001-hcmc-thao-dien-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Keep treating validators as tripwires, not taste approval.
- Watch for command verbs in headings as well as bodies.
- Airport pages can include international-arrival phrase moments while avoiding exact terminal/pickup claims that may change.
