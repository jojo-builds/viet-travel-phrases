# Handwritten Recovery Batch 067

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered / polished in this batch: 8
- Total recovered: 339 / 520
- Remaining: 181
- City note: HCMC continuity batch after Batch 066.

## Scope

1. `viet-family-city-hcmc-place-ben-thanh-market` - Ben Thanh Market
2. `viet-family-city-hcmc-place-ben-thanh-metro-station` - Ben Thanh Metro Station
3. `viet-family-city-hcmc-place-bep-me-in` - Bep Me In
4. `viet-family-city-hcmc-place-binh-tay-market` - Binh Tay Market
5. `viet-family-city-hcmc-place-bitexco-tower` - Bitexco Financial Tower
6. `viet-family-city-hcmc-place-bo-kho-ganh` - Bo Kho Ganh
7. `viet-family-city-hcmc-place-bo-la-lot` - Beef in betel leaves
8. `viet-family-city-hcmc-place-bot-chien` - Fried rice-flour cakes

## Editorial Result

Batch 067 kept the useful place/food substance and removed the next visible seams: `Save the name`, `Start With`, `the point`, `the draw`, negative `not a...` phrasing, and `surface` wording that trips the voice gate.

- Ben Thanh Market now keeps the clock-tower, snack, souvenir, bargaining, lap, and outside-meeting-point utility without direct group commands.
- Ben Thanh Metro Station now explains the station as the downtown metro name tied to market exits, ride pickups, signs, and above-ground handoffs.
- Bep Me In still explains Bib Gourmand for U.S. readers, then moves into yellow walls, stools, shared plates, bánh xèo, rice, recommendations, and spice/ingredient checks.
- Binh Tay Market now frames Chợ Lớn as Saigon's Chinese-Vietnamese market district and explains the courtyard, facade, delivery movement, wholesale trade, temple pairing, and west-side ride.
- Bitexco now keeps the lotus-shaped tower, District 1 orientation, river pairing, street-level usefulness, and SkyDeck/ticket volatility without `reason to remember` language.
- Bo Kho Ganh now defines bò kho as Vietnamese beef stew and keeps the bread/noodle/sauce choice focused on one clear bowl.
- Bò lá lốt now explains grilled beef wrapped in fragrant leaves and the shared herb/rice-paper/dipping-sauce table rhythm.
- Bột chiên now defines fried rice-flour cakes on a griddle with egg and green onions, then explains crisp edges, soft centers, sauce, and snack-plate scale.

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

- `viet-family-city-hcmc-place-bot-chien`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-067-screenshots/001-hcmc-bot-chien-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Define dish names immediately in plain English when the Vietnamese name may be unfamiliar.
- For transit pages, use physical route language such as exits, signs, rides, pickups, and above-ground landmarks.
- Keep award or guide terms only when they are explained in traveler language.
- Treat validators as early warning, not taste approval; fix source phrasing that could recreate direct-save, worksheet, or internal-rationale voice.
