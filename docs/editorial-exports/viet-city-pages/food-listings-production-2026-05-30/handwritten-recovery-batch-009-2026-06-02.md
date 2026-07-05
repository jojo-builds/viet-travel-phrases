# Handwritten Recovery Batch 009 - HCMC Specificity Layer

Date: 2026-06-02

Branch/worktree: `feature/city-listings-production-ready` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Newly recovered:

- `city-hcmc-place-anan-saigon`
- `city-hcmc-place-bep-me-in`
- `city-hcmc-place-cheo-leo-cafe`
- `city-hcmc-place-cuc-gach-quan`
- `city-hcmc-place-workshop-coffee`

Revisited from Batch 008:

- `city-hcmc-place-oc`

Current recovery count: 45 / 520 recovered.

Remaining: 475 / 520.

## Editorial Change

This batch responds to Jojo's read-through note that restaurant pages need to explain why this specific place matters, not only what food is served. Real venue pages now carry a concrete reason to choose the restaurant or cafe over similar options. Food-style pages do not fake restaurant history; they explain why the style is city-specific and how to choose a good version.

## Page Notes

`city-hcmc-place-anan-saigon`

- Added chef Peter Cuong Franklin, Michelin-starred modern Vietnamese context, and the old Ton That Dam market-block setting.
- The page now explains the market-outside / polished-dinner-inside contrast as the reason this is not just another nice restaurant.

`city-hcmc-place-bep-me-in`

- Explained Bib Gourmand in plain English as Michelin's good-value award category.
- Reframed the restaurant as an approachable central Vietnamese sit-down meal near Ben Thanh, useful when a visitor wants shared dishes and rice-friendly ordering without decoding a sidewalk stall.

`city-hcmc-place-cheo-leo-cafe`

- Added the long-running Saigon coffee-shop angle, cloth-filter coffee, family-run room, and short seated ritual.
- The page now has a real reason beyond "old cafe" or "iced coffee."

`city-hcmc-place-cuc-gach-quan`

- Tightened the reason around the old-house setting plus family-style Vietnamese meal.
- Added rice, vegetables, soup/fish, tiled floors, wood details, and slower-room logic.

`city-hcmc-place-workshop-coffee`

- Clarified the specialty-coffee reason: espresso, pour-over, beans, counter focus, upstairs old-building room.
- Framed it as the deliberate coffee counterpoint to a quick street iced coffee.

`city-hcmc-place-oc`

- Clarified this is a Saigon night seafood-table style, not a named restaurant.
- Added why it is specifically Saigon: quan oc streets, cold drinks, bold sauces, group ordering, shared shells, and adding plates as the table gets going.

## Source Checks Used

- Michelin Guide profile/article context for Anan Saigon and chef Peter Cuong Franklin.
- Michelin Guide profile for Cuc Gach Quan and Bib Gourmand/good-value wording.
- Saigoneer/Vietnamese coffee source checks for Cheo Leo's long-running cloth-filter coffee context.
- Vietnam Coracle and Saigon street-food source checks for the Saigon oc night-table / Vinh Khanh / quan oc pattern.
- Specialty-coffee source checks for The Workshop Coffee as an upstairs Saigon specialty-coffee stop.

## Edited Source Files

- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`

Generated/projection files were updated only by scripts after authored source edits.

## Validation

Focused smell scan:

- PASS for Batch 009 visible copy across app-detail and handwritten projection.

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
- City library: OK, 826 pages.
- SQLite integrity check: OK.
- Listing production QA: 0 blockers, 0 majors.
- `git diff --check`: PASS.

## Simulator

Built and launched with XcodeBuildMCP profile `city-listings-production-ready`.

Launch args:

```sh
--detail-page viet-family-city-hcmc-place-oc
```

Simulator status:

- Build/run: SUCCEEDED.
- Left open on `viet-family-city-hcmc-place-oc`.
- UI text proof found: `What makes it feel Saigon is the night-out rhythm: quán ốc tables, cold drinks, bold sauces, friends sharing shells, and more plates added slowly.`

## Physical iPhone

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: SUCCEEDED.
- Install: SUCCEEDED.
- Launch: blocked because the iPhone was locked.
- Signing hygiene: repo signing files stayed clean.
