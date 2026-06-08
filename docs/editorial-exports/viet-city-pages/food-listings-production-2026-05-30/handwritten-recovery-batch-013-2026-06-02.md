# Handwritten Recovery Batch 013 - 2026-06-02

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

Status: Batch 013 recovered and projected. The full 520-page set is still not production-ready as a whole; this receipt covers five newly recovered pages plus three small screenshot-feedback cleanups.

Progress count after this batch: 65 / 520 recovered. Remaining: 455.

## Pages Recovered

1. `city-hcmc-place-ciel`
   - Rewrote from generic "newer Saigon dinner" copy into a Thao Dien tasting-menu page.
   - Visible copy now explains the restaurant type, chef/open-kitchen draw, private-house setting, Vietnamese ingredients, and what the Michelin star signals.
   - Source check: official CieL site, chef/journey page.

2. `city-hcmc-place-coco-dining`
   - Rewrote from vague "warm planned dinner" language into CoCo Saigon's Vietnamese-journey tasting-menu page.
   - Visible copy now explains the Lữ Hành menu, pairing decision, CoCo Bar context, and difference from CieL.
   - Source check: official CoCo Dining page.

3. `city-hcmc-place-little-hanoi-egg-coffee`
   - Rewrote to define egg coffee for first-time U.S. readers.
   - Visible copy now explains the drink, the Hanoi-in-Saigon significance, the rich foam/coffee experience, and the comparison with Saigon filter-coffee ritual.
   - Source check: official Little HaNoi site was reachable but thin; copy uses stable egg-coffee facts and avoids hours/address/menu breadth claims.

4. `city-hcmc-place-long-trieu`
   - Rewrote from generic formal Chinese table copy into a Nguyen Hue Cantonese hotel-dining page.
   - Visible copy now explains Michelin-starred Cantonese, dim sum entry point, private-room/formal setting, and why Cho Lon is the right city-context comparison.
   - Source check: official The Reverie Saigon Long Triều page.

5. `city-hcmc-place-lusine-thao-dien`
   - Rewrote from branch-generic brunch copy into a Thao Dien neighborhood/concept-store brunch page.
   - Visible copy now explains Thao Dien's relaxed/creative neighborhood mood, the concept-store/cafe/brunch mix, and the difference from coffee-craft stops.
   - Kept required menu examples from existing source assumptions: eggs Benedict, squid ink crab pasta, premium pho, and salt caramel coffee.
   - Source check: official L'Usine Thao Dien journal page.

## Screenshot-Feedback Cleanups Included

- `city-hcmc-place-cong-ca-phe-dong-khoi`
  - Removed command-like "Sit briefly" phrasing.
  - Removed internal-sounding "The reason is convenience" language.
  - Replaced with a clearer central-branch/coconut-coffee/air-conditioned District 1 pause.

- `city-hanoi-place-old-quarter`
  - Removed a separate "Sit briefly" line from the coffee-stop section.

- `city-hcmc-place-saigon-square`
  - Removed "Its reason is convenience" and softened the intro from command language to a practical browse description.

## Source Links Used

- CieL official site: https://cieldining.com/
- CoCo Dining official page: https://cocosgn.com/coco-dining
- Long Triều official page at The Reverie Saigon: https://www.thereveriesaigon.com/restaurants-bars/long-trieu
- L'Usine Thao Dien official journal page: https://lusinespace.com/breakfast-brunch-in-thao-dien-coffee-comfort-food-good-vibes/
- Little HaNoi Egg Coffee official site: https://littlehanoi.com.vn/

## Validation

Passed:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
git diff --check
```

Validation summary:

- V2.2 strict validation: PASS, 520 total entries, 520 pass.
- Voice audit: PASS, no formula failures.
- City production copy: PASS, 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: PASS, 826 pages.
- SQLite fixture: PASS, integrity check ok.
- Production QA audit: 0 blockers, 0 majors.
- `git diff --check`: PASS.

## Simulator Proof

Simulator profile: `city-listings-production-ready`

Page left open: `viet-family-city-hcmc-place-little-hanoi-egg-coffee`

Visible proof text:

> Little HaNoi Egg Coffee Saigon is a small cafe table built around egg coffee, Vietnamese coffee topped with a sweet, creamy mix of egg yolk and condensed milk.

Screenshot:

`/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_75e0fd94-d67d-41a5-b787-cc136485b445.jpg`

## Phone Build

Physical iPhone attempt from this worktree:

- Build: succeeded.
- Install: succeeded.
- Launch: not completed because the phone was locked and iOS denied the launch request.
- Signing hygiene: clean. `native-ios/project.yml` and `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj` had no repo-visible personal signing settings after the build.

## Next Batch

Continue with the next five unrecovered listings. Keep the active rule: unfamiliar labels, city-style claims, Michelin/Bib/Guide terms, neighborhood labels, food styles, and branch roles must be explained in visible traveler language.
