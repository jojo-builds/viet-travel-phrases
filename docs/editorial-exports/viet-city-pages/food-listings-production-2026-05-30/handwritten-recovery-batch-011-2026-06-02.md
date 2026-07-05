# Handwritten Recovery Batch 011 - HCMC Foundational Dish Definitions

Date: 2026-06-02

Branch/worktree: `feature/city-listings-production-ready` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered:

- `city-hcmc-place-banh-mi`
- `city-hcmc-place-banh-xeo`
- `city-hcmc-place-bun-thit-nuong`
- `city-hcmc-place-com-tam`
- `city-hcmc-place-pho-nam`

Current recovery count: 55 / 520 recovered.

Remaining: 465 / 520.

## Editorial Change

This batch focused on foundational HCMC dish pages where a first-time U.S.-based reader needs plain definitions before the copy asks them to care. Each page now explains:

- what the dish actually is;
- what the first ordering or eating move is;
- what makes the dish feel Saigon, southern, or city-specific rather than just broadly Vietnamese;
- which named local stop can turn a dish idea into a real meal plan.

## Page Notes

`city-hcmc-place-banh-mi`

- Defined bánh mì as Vietnam's crisp baguette sandwich instead of assuming the reader already knows it.
- Added the Saigon counter rhythm: fast fillings, chili decision, portable street-food pace, and shop-to-shop variation.

`city-hcmc-place-banh-xeo`

- Clarified that bánh xèo is closer to a crisp crepe than an American breakfast pancake.
- Added the southern/Saigon table ritual: big turmeric-rice shell, shrimp or pork, bean sprouts, greens, herbs, wrapping, and dipping.

`city-hcmc-place-bun-thit-nuong`

- Defined bún thịt nướng as a southern grilled-pork vermicelli bowl.
- Added the hot-day Saigon logic: cool noodles, grilled pork, herbs, pickles, peanuts, and fish-sauce dressing without a heavy soup bowl.

`city-hcmc-place-com-tam`

- Explained that cơm tấm means broken rice, but the Saigon plate is much more than the translation.
- Added common plate parts: grilled pork, pickles, fish sauce, egg, shredded pork skin, and steamed egg meatloaf.

`city-hcmc-place-pho-nam`

- Defined phở Nam as southern pho and explained the table-finish pattern.
- Added the southern-vs-northern distinction in practical terms: more herbs, sprouts, lime, chili, sauces, sweetness, and personal adjustment.

## Source Checks Used

- Vietnam food/travel sources for bánh mì as a Vietnamese baguette sandwich commonly layered with meat or pate, pickled vegetables, herbs, cucumber, chili, and sauce.
- Vietnam food/travel sources for bánh xèo as a sizzling rice-flour/turmeric pancake or crepe, often with shrimp or pork and bean sprouts, eaten with greens and dipping sauce.
- Vietnam food/travel sources for bún thịt nướng as grilled pork with vermicelli noodles, herbs or vegetables, peanuts, pickles, and fish-sauce dressing.
- Vietnam food/travel sources for cơm tấm as broken rice strongly associated with Saigon or southern Vietnam, commonly served with grilled pork, pickles, fish sauce, and add-ons such as shredded pork skin or egg meatloaf.
- Vietnam food/travel sources for southern/Saigon phở as commonly served with herbs, bean sprouts, lime, chili, and sauces, with a more flexible table-finished style than northern bowls.

## Edited Source Files

- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`

Generated/projection files were updated only by scripts after authored source edits.

## Validation

Focused smell scan:

- PASS for Batch 011 visible copy across app-detail source and related-card subtitles.
- The scan checked for app-visible terms such as `use this`, `helps`, `useful when`, `perfect for`, `hidden gem`, `must-visit`, `deserves`, `carry the`, `this page`, `traveler`, and `counter dinner`.

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
--detail-page viet-family-city-hcmc-place-pho-nam
```

Simulator status:

- Build/run: SUCCEEDED.
- Left open on `viet-family-city-hcmc-place-pho-nam`.
- UI text proof found: `Southern Pho, Finished At The Table`.
- Screenshot path: `/var/folders/z4/rl0d7cg94zvfy4b0_zytwc7c0000gn/T/screenshot_optimized_de008e62-94d6-4f61-a939-548e0862a983.jpg`

## Physical iPhone

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: SUCCEEDED.
- Install: NOT completed. The install reached the device install-service handoff and then stalled with no further progress, matching the Batch 010 device-side stall pattern. The stuck helper/install processes were stopped narrowly.
- Launch: NOT completed because install did not complete.
- Signing hygiene: repo signing files stayed clean.

## Copy Judgment

This batch advances Jojo's latest correction: city or regional labels need explanation. The revised pages no longer just say "Saigon" or "southern" as color. They tell the reader what the label means in the food:

- bánh mì: fast Saigon sandwich counter rhythm;
- bánh xèo: southern wrapping/dipping table ritual;
- bún thịt nướng: cool-noodle hot-day southern bowl;
- cơm tấm: Saigon broken-rice plate culture;
- phở Nam: southern table-finished bowl with herbs, sprouts, lime, chili, and sauce.

## Remaining Work

55 of 520 city/place listings have now received this recovery-batch treatment.

Remaining authored recovery scope: 465 listings.

Continue with small batches. The next HCMC batch should likely cover the remaining unrecovered food-adjacent pages that still need either dish definitions, real restaurant identity, or city-specific reasons: Akuna, Cafe Apartment Nguyễn Huệ, Cafe Vợt Phạm Ngọc Thạch, chè, and Cộng Cà Phê Đồng Khởi.
