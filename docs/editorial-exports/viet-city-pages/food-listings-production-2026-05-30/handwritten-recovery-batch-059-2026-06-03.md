# Handwritten Recovery Batch 059

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 294 / 520
- Remaining: 226

## Scope

1. `viet-family-city-hcmc-place-pham-ngu-lao-street` - Pham Ngu Lao Street
2. `viet-family-city-hcmc-place-pho-hoa-pasteur` - Pho Hoa Pasteur
3. `viet-family-city-hcmc-place-pho-huong-binh` - Pho Huong Binh
4. `viet-family-city-hcmc-place-pho-le-district-5` - Pho Le District 5
5. `viet-family-city-hcmc-place-pho-minh` - Pho Minh

## Editorial Result

Batch 059 focused on Saigon backpacker logistics plus a cluster of phở pages. The main goal was to preserve useful phrase cards and related links while removing source/visible language that sounded like a rationale for the page structure.

- Pham Ngu Lao now frames the street as a real District 1 backpacker logistics area: bus offices, travel agencies, budget stays, Bùi Viện nearby, exact pickup doors, and night noise changes.
- Pho Hoa Pasteur now defines phở plainly for first-time U.S. travelers and gives the shop a central Saigon baseline role without saying the page is "useful."
- Pho Huong Binh now explains the chicken-or-beef decision, clear broth, chicken skin, egg yolk, brisket, tendon, and why one table can split its bowls naturally.
- Pho Le District 5 now reads as a fuller District 5 southern beef-phở meal, with rich broth, mixed beef cuts, herbs, sprouts, lime, and sauces.
- Pho Minh now carries the old Pasteur-alley breakfast role: narrow entrance, 1945 history, beef cuts, herbs, and pâté chaud as a real breakfast detail.

Drift fixes folded in:

- Removed `The page should explain`, `useful when`, `useful first`, `Good For`, `Related because:`, and `Mentioned here because:` from the current five.
- Replaced direct source-rationale language with traveler-facing phrasing.
- Preserved useful phrase cards and related/Mentioned Here cards.
- Kept restaurant claims stable and avoided hours, prices, booking, closure, or fragile operational promises.

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

- `viet-family-city-hcmc-place-pho-minh`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-059-screenshots/001-hcmc-pho-minh-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Continue source-cleaning `reason` and Mentioned Here fields even when they do not render today.
- Restaurant pages should explain the dish or dining format before relying on local names or awards.
- Preserve the comparison graph, but make subtitles and reasons sound like real trip-building, not app-internal matching logic.

## Backward-Pass Addendum

2026-06-03 follow-up after Jojo/orchestrator steering:

- Ran the cold visible-copy gate on the five Batch 059 pages before revalidation.
- Replaced `Daytime Is Practical` with `Bus Offices, Hostel Blocks`.
- Replaced phở comparison-role language such as `District 5 Over Pasteur` and `gives ... comparison` with table/trip-facing reasons: central Pasteur bowl, District 5 fuller beef bowl, narrow Pasteur-alley breakfast, chicken-or-beef table split, and southern-phở table finishing.
- Preserved all phrase cards, Mentioned Here cards, and related cards.
- Root cause recorded: this batch originally started from phở comparison roles and related-card graph logic, then cleaned visible text afterward. The replacement method is city/food proof first: write the specific table setup and trip decision first, then connect related cards around that real traveler decision.
- Cold visible-copy gate result after patch: PASS.
- Revalidation after patch: full projection, import, native generation, strict v2.2, voice audit, city copy, city library, SQLite fixture, production QA, and `git diff --check` all PASS.
