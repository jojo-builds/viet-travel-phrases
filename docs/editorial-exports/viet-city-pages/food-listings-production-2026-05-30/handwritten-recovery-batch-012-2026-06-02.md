# Handwritten Recovery Batch 012 - HCMC Cafe And Planned-Dinner Specificity

Date: 2026-06-02

Branch/worktree: `feature/city-listings-production-ready` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered:

- `city-hcmc-place-akuna`
- `city-hcmc-place-cafe-apartment-nguyen-hue`
- `city-hcmc-place-cafe-vot-pham-ngoc-thach`
- `city-hcmc-place-che`
- `city-hcmc-place-cong-ca-phe-dong-khoi`

Current recovery count: 60 / 520 recovered.

Remaining: 460 / 520.

## Editorial Change

This batch tightened five HCMC food-adjacent pages that previously had usable shape but weak save-worthiness. The revised copy explains the real object or venue:

- Akuna is now a chef-led tasting-menu dinner with a specific room, chef, floor, and reason to choose it.
- Cafe Apartment is now clearly the old 42 Nguyễn Huệ apartment block reused as a vertical cafe/shop stack.
- Cà phê vợt now defines the cloth-filter method instead of assuming the reader knows why it matters.
- Chè now explains that it is a dessert category with many versions, not one fixed dish.
- Cộng Đồng Khởi now reads as a familiar central Cộng branch with coconut coffee and brand identity, not a hidden old-Saigon cafe.

## Page Notes

`city-hcmc-place-akuna`

- Added chef Sam Aisbett, Le Méridien Saigon, 9th-floor setting, open kitchen, light rods, tasting-menu pace, and Vietnamese-produce reason.
- Clarified why a visitor would choose it: fine-dining Vietnamese ingredient interpretation, not a quick local meal.

`city-hcmc-place-cafe-apartment-nguyen-hue`

- Reframed the page around 42 Nguyễn Huệ as the old apartment block above the walking street.
- Added the concrete visit sequence: look up, find the entrance, choose a floor, sit at a small table above central Saigon.

`city-hcmc-place-cafe-vot-pham-ngoc-thach`

- Defined cà phê vợt as net-filter coffee made through a cloth filter.
- Added the older southern/Saigon method: strong coffee, condensed milk, ice, compact tables, and method over interior design.

`city-hcmc-place-che`

- Defined chè as a category with many versions.
- Added the stall-choice moment: color, texture, coconut milk, beans, jelly, fruit, tapioca, shaved ice, and warm/cold versions.

`city-hcmc-place-cong-ca-phe-dong-khoi`

- Clarified this as Cộng Cà Phê Vincom Đồng Khởi, a central branch of the Vietnamese coffee chain.
- Added the honest reason to save: coconut coffee, retro green brand styling, mall cool-down, and central-loop convenience.

## Source Checks Used

- Michelin Guide and Akuna official pages for Akuna's chef Sam Aisbett, Le Méridien Saigon location, Michelin-star context, open-kitchen/light-rod room, tasting/wine menus, and Vietnamese ingredient focus.
- Travel guide references for 42 Nguyễn Huệ as an old apartment block on Nguyễn Huệ Walking Street now filled with cafes, small shops, signs, balconies, and floor-by-floor tenants.
- Net-filter coffee references for cà phê vợt as a traditional southern Vietnam cloth-filter brewing method associated with older Saigon/HCMC cafes and Chinese-Vietnamese coffee culture.
- Food references for chè as a Vietnamese dessert category with beans, tapioca, jelly, fruit, coconut cream or milk, syrup, shaved ice, and hot/cold versions.
- Cộng official pages for Vincom Đồng Khởi branch presence, coconut coffee as a signature drink, and the chain's retro Vietnamese design language.

## Edited Source Files

- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`

Generated/projection files were updated only by scripts after authored source edits.

## Validation

Focused smell scan:

- PASS for Batch 012 visible copy across app-detail source and related-card subtitles.
- The scan checked for app-visible terms such as `use this`, `helps`, `useful when`, `perfect for`, `hidden gem`, `must-visit`, `deserves`, `this page`, `traveler`, `counter dinner`, `not a`, `not one`, and `layer`.

Full validation command:

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

Result:

- V2.2 strict production validation: PASS.
- Voice audit: PASS, `failures: []`.
- City production copy: 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library: OK, 826 pages, 726 beginner, 95 intermediate, 5 advanced.
- SQLite integrity check: OK.
- Listing production QA: 0 blockers, 0 majors.
- `git diff --check`: PASS.

## Simulator

Built and launched with XcodeBuildMCP profile `city-listings-production-ready`.

Launch args:

```sh
--detail-page viet-family-city-hcmc-place-cong-ca-phe-dong-khoi
```

Simulator status:

- Build/run: SUCCEEDED.
- Left open on `viet-family-city-hcmc-place-cong-ca-phe-dong-khoi`.
- UI text proof found: `Coconut Coffee In The Central Loop`.
- Screenshot path: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_5414f236-eeda-47e2-b962-df5cb90690e2.jpg`

## Physical iPhone

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: SUCCEEDED.
- Install: NOT completed. The install again reached the device install-service handoff and then stalled with no further progress, matching the Batch 010 and Batch 011 device-side stall pattern. The stuck helper/install processes were stopped narrowly.
- Launch: NOT completed because install did not complete.
- Signing hygiene: repo signing files stayed clean.

## Copy Judgment

This batch directly addresses Jojo's restaurant/place-specificity concern. A page cannot just say "a planned dinner," "old coffee," "a cafe break," or "sweet dessert" and expect a U.S.-based first-time visitor to care.

The revised pages now answer why this one exists:

- Akuna: chef-led tasting menu in a specific hotel room above the river, with Vietnamese ingredients at the center.
- Cafe Apartment: reused apartment-block facade and floor-by-floor cafe browse above Nguyễn Huệ.
- Cà phê vợt: older cloth-filter coffee method, not generic iced coffee.
- Chè: many dessert versions under one name, chosen visually at a stall.
- Cộng Đồng Khởi: branded central convenience and coconut coffee, not a hidden local room.

## Remaining Work

60 of 520 city/place listings have now received this recovery-batch treatment.

Remaining authored recovery scope: 460 listings.

Continue with small batches. The next HCMC batch can keep clearing unrecovered food-adjacent pages that still need either named-place identity, dish definition, or a city-specific reason: Ciel, Coco Dining, Little Hanoi Egg Coffee, L'Usine Thảo Điền, and Long Triều.
