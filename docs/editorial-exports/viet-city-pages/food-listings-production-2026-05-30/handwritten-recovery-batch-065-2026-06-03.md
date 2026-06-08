# Handwritten Recovery Batch 065

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`
Status: PASS

## Progress

- Recovered in this batch: 5
- Total recovered: 323 / 520
- Remaining: 197
- City note: early-HCMC continuity batch after the Batch 064 HCMC closeout.

## Scope

1. `viet-family-city-hcmc-place-42-nguyen-hue-apartment` - 42 Nguyen Hue apartment building
2. `viet-family-city-hcmc-place-akuna` - Akuna
3. `viet-family-city-hcmc-place-an-dong-market` - An Dong Market
4. `viet-family-city-hcmc-place-anan-saigon` - Anan Saigon
5. `viet-family-city-hcmc-place-ao-dai-museum` - Ao Dai Museum

## Editorial Result

Batch 065 tightened five early Saigon entries with first-time U.S. traveler context, preserved useful phrase cards/related links, and removed source-level save-language residue.

- 42 Nguyen Hue now explains the old apartment-block/cafe-building shape, the street facade, and why the address matters more than any one tenant.
- Akuna now frames the restaurant as a Michelin-recognized 9th-floor tasting-menu dinner at Le Meridien Saigon, with open-kitchen and Vietnamese-ingredient context.
- An Dong Market now reads as a District 5 fabric, clothing, accessory, and wholesale-style shopping building outside the District 1 souvenir loop.
- Anan Saigon now explains the market-street setting, chef Peter Cuong Franklin, modern Vietnamese cooking, and why the outside/inside contrast matters.
- Ao Dai Museum now defines `ao dai` immediately as Vietnam's long tunic worn over trousers, then connects the museum to fabric, silhouette, formal life, photos, and a planned ride outside District 1.

Source hygiene folded in:

- Removed `reason to save`, `when to save`, and `Save-worthy` language from Batch 065 source notes/score reasons.
- Focused grep for Batch 065 passed for direct save-language, `Related because:`, `the appeal`, `it reads like`, `the value`, `this listing`, and `useful as`.
- Carried forward Batch 064 heartbeat rule: translate `appeal`, `reason`, `reads`, and repeated abstractions into visible traveler details.

2026-06-04 orchestrator repair:

- `city-hcmc-place-an-dong-market`, section `Walk One Level At A Time`
  - Before: `Walk one level before buying. Notice where fabric, clothes, accessories, and food cluster, then return to the counters with a clearer target.`
  - After: `Walk one level before buying. Notice where fabric, clothes, accessories, and food cluster, then circle back to the fabric counter, shirt racks, accessory case, or food stall that caught your eye.`

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

- `viet-family-city-hcmc-place-ao-dai-museum`

Build/run result:

- `mcp__xcodebuildmcp.build_run_sim` succeeded on simulator `7C386DD3-4BF1-4A34-A918-768C43CD1258`.
- App left open on Simulator for Jojo review.

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-065-screenshots/001-hcmc-ao-dai-museum-top.jpg`

## Signing Scan

Command:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`

## Carry Forward

- For named restaurants, explain what happens in the room and what makes that restaurant distinct before using award or reservation shorthand.
- For unfamiliar Vietnamese culture terms, define the thing first, then connect it to the place.
- Keep phrase cards and related links, but remove any source rationale that sounds like a worksheet or saved-list instruction.
- Do not reduce pages to sparse checklists; keep concrete visual, logistical, and cultural context.
