# Handwritten Recovery Batch 063

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 314 / 520
- Remaining: 206

## Scope

1. `viet-family-city-hcmc-place-thien-hau-pagoda` - Thien Hau Pagoda
2. `viet-family-city-hcmc-place-thu-thiem-riverfront` - Thu Thiem riverfront
3. `viet-family-city-hcmc-place-ton-duc-thang-museum` - Ton Duc Thang Museum
4. `viet-family-city-hcmc-place-turtle-lake` - Turtle Lake
5. `viet-family-city-hcmc-place-vincom-dong-khoi` - Vincom Center Dong Khoi

## Editorial Result

Batch 063 focused on cultural context, river views, focused museum pacing, informal evening landmarks, and downtown mall utility without falling back into direct-command copy.

- Thien Hau Pagoda now explains the temple as a Chinese-community place of worship in Chợ Lớn dedicated to Thiên Hậu, the sea goddess, with incense coils, courtyards, tiled roofs, and respect cues.
- Thu Thiem riverfront now makes the across-the-water skyline view concrete: open bank, reflections, dusk light, air, and District 1 across the river.
- Ton Duc Thang Museum now explains who the museum is about and why the focused waterfront visit differs from broader city-history museums.
- Turtle Lake now reads as a District 3 traffic-circle social marker with fountain edges, snack stalls, scooter noise, evening lights, and sit-and-watch energy.
- Vincom Center Dong Khoi now keeps the mall value concrete: cool air, storefronts, food counters, bathrooms, card-friendly shopping, meetups, and the street right outside.

Drift fixes folded in:

- Removed `belongs`, `lands cleanly`, `go when`, `give them time`, `come here`, and `it suits` seams from visible copy.
- Converted contrast lines into positive place context.
- Preserved useful phrase cards and related-place links.
- Folded the Batch 062 heartbeat polish into the same validation run.

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

- `viet-family-city-hcmc-place-vincom-dong-khoi`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-063-screenshots/001-hcmc-vincom-dong-khoi-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Cultural pages should define unfamiliar religious or historical terms at first mention.
- Avoid direct `go`, `come`, `give it`, and `belongs` phrasing when a concrete scene can carry the recommendation.
- Exact heartbeat wording still has to pass repo validators; preserve intent when validator wording differs.
