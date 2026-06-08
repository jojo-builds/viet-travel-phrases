# Handwritten Recovery Batch 064

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 4
- Total recovered: 318 / 520
- Remaining: 202
- City milestone: Saigon / HCMC recovered through final source entry.

## Scope

1. `viet-family-city-hcmc-place-vinhomes-central-park` - Vinhomes Central Park
2. `viet-family-city-hcmc-place-war-remnants-museum` - War Remnants Museum
3. `viet-family-city-hcmc-place-workshop-coffee` - The Workshop Coffee
4. `viet-family-city-hcmc-place-zoo-botanical-gardens` - Saigon Zoo and Botanical Gardens

## Editorial Result

Batch 064 closed the remaining Saigon pages with concrete traveler context and preserved phrase cards/related links.

- Vinhomes Central Park now reads as modern Saigon through lawns, river air, family walks, Landmark 81, and skyline scale.
- War Remnants Museum keeps a sober, emotionally honest Vietnam War museum framing with photographs, documents, military equipment, and room around the visit.
- The Workshop Coffee now avoids direct save-language and explains the specialty-coffee value: upstairs old-building room, espresso gear, pour-over pacing, and a seat above the street.
- Saigon Zoo and Botanical Gardens now has a clearer factual hook as an open-air city park institution with old trees, walking paths, families, gardens, and animal areas.

Drift fixes folded in:

- Removed direct `Why ... Save It` heading.
- Removed `Related because:` from source reason text.
- Replaced `Come on a day`, `Give the museum`, and `reason to go` phrasing with observed traveler-facing prose.
- Kept the War Remnants Museum tone serious without making it vague or overly instructive.

Post-receipt heartbeat polish:

- Vinhomes Central Park now turns `scale` / `appeal` language into lawns, tower views, river wind, and Landmark 81 context.
- War Remnants Museum section heading changed from `A Clearer Day Around It` to `A Slower Day Helps`.
- The Workshop Coffee first section now describes the room built around the cup instead of repeating content-rationale language.
- Saigon Zoo now says it feels like a long shaded walk, and its sections split grounds, family rhythm, and heat/shade planning into different jobs.

## Orchestrator Repair - 2026-06-04

Root cause: the cold pass removed most module language, but two reviewer/anti-pattern concepts still leaked into visible prose as negative instructions. Repair move: state the positive traveler action or physical texture directly.

Exact source repairs:

- `city-hcmc-place-war-remnants-museum` / `Images Stay With You`
  - Before: `Some rooms are graphic and direct. The visit is easier to absorb when the group agrees to move floor by floor without turning it into a checklist.`
  - After: `Some rooms are graphic and direct. Move through the photos and captions at a pace the group can absorb before heading upstairs or outside.`
- `city-hcmc-place-zoo-botanical-gardens` / `Gardens Between Enclosures`
  - Before: `Gardens, benches, and tree canopy are part of the visit, not just the spaces between exhibits. Let the walk breathe instead of treating every path as a shortcut.`
  - After: `Gardens, benches, tree canopy, and winding paths give the visit its pauses between animal areas. Shade and water breaks are part of the rhythm from the start.`

Preservation check:

- War Remnants Museum phrase cards preserved: entrance, tickets, photo permission.
- War Remnants Museum related link preserved: Củ Chi Tunnels.
- Saigon Zoo and Botanical Gardens phrase cards preserved: start, meeting point, water.
- Saigon Zoo and Botanical Gardens related link preserved: Gia Định Park.

Repair validation rerun:

- Required generation/validation chain rerun on 2026-06-04: PASS.
- V2.2 strict production validation: PASS, 520 pass, 0 revise, 0 fail.
- Voice audit: PASS, no failures.
- City copy, city library, SQLite fixture, and listing production QA: PASS.
- `git diff --check`: PASS.

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

- `viet-family-city-hcmc-place-zoo-botanical-gardens`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-064-screenshots/001-hcmc-zoo-botanical-gardens-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- Direct save-language can appear in older headings and source reasons; keep grepping for it before receipt.
- For serious history pages, make the emotional weight clear without turning the copy into commands.
- For park/garden pages, include a clear factual hook such as park, garden, river, trees, landmark, or family use so the value is legible.
