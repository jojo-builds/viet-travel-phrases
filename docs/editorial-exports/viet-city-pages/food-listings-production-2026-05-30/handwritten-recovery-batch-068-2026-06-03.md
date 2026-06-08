# Handwritten Recovery Batch 068

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered / polished in this batch: 8
- Total recovered: 347 / 520
- Remaining: 173
- City note: HCMC continuity batch after Batch 067.

## Scope

1. `viet-family-city-hcmc-place-bui-vien-street` - Bui Vien Street
2. `viet-family-city-hcmc-place-bun-bo-hue-14b` - Bun Bo Hue 14B
3. `viet-family-city-hcmc-place-pho-le-district-5` - Pho Le District 5
4. `viet-family-city-hcmc-place-pho-minh` - Pho Minh
5. `viet-family-city-hcmc-place-pho-huong-binh` - Pho Huong Binh
6. `viet-family-city-hcmc-place-bun-thit-nuong` - Grilled pork vermicelli
7. `viet-family-city-hcmc-place-ca-phe-sua-da` - Saigon iced milk coffee
8. `viet-family-city-hcmc-place-cafe-apartment-nguyen-hue` - Cafe Apartment on Nguyen Hue

## Editorial Result

Batch 068 kept the useful food/place detail and removed guidebook-command phrasing such as `Remember it`, `Go for`, `Start with`, `Choose`, `Find`, `See it`, and `Related because:`.

- Bui Vien now reads as one loud backpacker-nightlife lane with bars, sidewalk seats, signs, bags/price awareness, and District 1 balance without command-heavy wording.
- Bun Bo Hue 14B now explains the Hue-origin spicy beef noodle soup through lemongrass broth, round noodles, chili, beef cuts, herbs, lime, and home-city related context.
- Pho Le now distinguishes the fuller District 5 beef-pho bowl, table herbs/sauces, beef cuts, and central-Pasteur comparisons.
- Pho Minh now keeps the 1945 alley-shop context, Pasteur entrance, beef-cut choice, and pâté chaud breakfast detail.
- Pho Huong Binh now clarifies the chicken-or-beef split, clearer broth, and why one table can handle both pho paths.
- Bun thit nuong now defines grilled pork over cool vermicelli, herbs, pickles, peanuts, and fish-sauce dressing as a hot-day southern bowl.
- Ca phe sua da keeps the condensed-milk explanation, sweetness timing, midday reset, and setting differences.
- Cafe Apartment now frames 42 Nguyen Hue as the old block above the walking street: facade first, tenant choice second, balconies, iced drinks, stairs/elevator, and address clarity.

Batch 067 heartbeat patch folded in before validation:

- Binh Tay intro now avoids direct `Remember it` language and explains the Chinese-Vietnamese market district through working trade beyond the central souvenir loop.
- Binh Tay west-side section now says the ride west is part of the visit.
- Bo Kho Ganh intro now says the choice stays simple instead of `the useful choice`.
- Bo la lot heading changed to `Shared Plate Rhythm`.
- Bot chien related reason now says the dish can lead into a broader evening street-food route.

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

- `viet-family-city-hcmc-place-cafe-apartment-nguyen-hue`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-068-screenshots/001-hcmc-cafe-apartment-nguyen-hue-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Avoid `remember it`, `use it`, `useful choice`, `go for`, `start with`, and `choose` when they sound like app/validator instructions.
- Related-card reasons should read like traveler context, not source rationale.
- Food pages should define Vietnamese dishes or ingredients immediately, then explain the table rhythm.
- Named building pages should say what the visitor sees and how the address/building works before tenant details.
