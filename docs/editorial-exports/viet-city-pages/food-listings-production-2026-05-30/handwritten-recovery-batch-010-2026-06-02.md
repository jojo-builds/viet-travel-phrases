# Handwritten Recovery Batch 010 - HCMC Market Specificity

Date: 2026-06-02

Branch/worktree: `feature/city-listings-production-ready` at `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered:

- `city-hcmc-place-ben-thanh-market`
- `city-hcmc-place-an-dong-market`
- `city-hcmc-place-binh-tay-market`
- `city-hcmc-place-ho-thi-ky-flower-market`
- `city-hcmc-place-saigon-square`

Current recovery count: 50 / 520 recovered.

Remaining: 470 / 520.

## Editorial Change

This batch focuses on HCMC markets and shopping stops. The copy now explains why each market exists in the trip instead of treating all markets as the same "browse, ask price, take a lap" experience.

Jojo's city-specificity correction is now part of the recovery standard: when a listing calls something Saigon-style, Hanoi-style, or otherwise local, the page must say what makes it local. That can be night rhythm, sauce style, trade pattern, neighborhood role, shopping depth, architecture, or how people actually use the place.

## Page Notes

`city-hcmc-place-ben-thanh-market`

- Reframed Ben Thanh as the central clock-tower market and easy first market name to know.
- Added why it is useful: bearings, District 1 meeting point, first bargaining practice, snacks, souvenirs, and an outside meeting point.

`city-hcmc-place-an-dong-market`

- Reframed An Dong around District 5 fabric, fashion, accessories, and wholesale-style browsing.
- Clarified that it is better for a specific shopping errand than for random tourist wandering.

`city-hcmc-place-binh-tay-market`

- Reframed Binh Tay as Cho Lon trade energy, not a District 1 souvenir market.
- Added courtyard, historic facade, Chinese-Vietnamese market context, working goods movement, and west-side pairing logic.

`city-hcmc-place-ho-thi-ky-flower-market`

- Reframed Ho Thi Ky around working flower trade: bouquets, arranging, delivery lanes, scooters, wet pavement, and evening color.
- Added the nearby snack-lane pairing without pretending the flower market is mainly a food stop.

`city-hcmc-place-saigon-square`

- Reframed Saigon Square as a central indoor bargain-shopping stop near Ben Thanh.
- Added the real tradeoff: less market atmosphere, more speed, cooler air, small counters, clothes, bags, and quick price checks.

## Source Checks Used

- HCMC tourism and local guide references for Ben Thanh as the central District 1 landmark market.
- Local market guides for An Dong as a District 5 fabric, fashion, accessories, and wholesale-style shopping market.
- Cho Lon/Binh Tay guide references for the market's courtyard, historic facade, Chinese-Vietnamese trade context, and west-side location.
- Ho Thi Ky guide references for the flower-market lane, delivery/arranging trade, and nearby food-lane pairing.
- Saigon Square shopping references for its indoor central counter layout near Ben Thanh, clothes/bags focus, and bargain-shopping role.

## Edited Source Files

- `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`
- `content-draft/viet/city-library/handwritten-copy/hcmc.json`

Generated/projection files were updated only by scripts after authored source edits.

## Validation

Focused smell scan:

- Initial scan caught `strongest`, `useful when`, and `helps you`; those were fixed before final validation.

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
--detail-page viet-family-city-hcmc-place-binh-tay-market
```

Simulator status:

- Build/run: SUCCEEDED.
- Left open on `viet-family-city-hcmc-place-binh-tay-market`.
- UI text proof found: `Chợ Lớn Trade, Not District 1 Souvenirs`.

## Physical iPhone

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: SUCCEEDED.
- Install: NOT completed. The device connection/install service interrupted once, then a retry stalled during the install-service handoff and was stopped after it made no progress.
- Launch: NOT completed because install did not complete.
- Signing hygiene: repo signing files stayed clean.

## Copy Judgment

This batch strengthens the production rule Jojo called out during the ốc read-through:

- A city-style label is not enough.
- If the app says a thing is Saigon-style, the page must explain what makes it Saigon-style versus just Vietnamese in general.
- The same applies to markets: a central souvenir market, a District 5 wholesale/fabric market, a Cho Lon trade market, a flower delivery lane, and an indoor bargain counter stop should not read like interchangeable browsing advice.

## Remaining Work

50 of 520 city/place listings have now received this recovery-batch treatment:

- Batch 001: 5 pages
- Batch 002: 5 pages
- Batch 003: 5 pages
- Batch 004: 5 pages
- Batch 005: 5 pages
- Batch 006: 5 pages
- Batch 007: 5 pages
- Batch 008: 5 pages
- Batch 009: 5 newly recovered pages plus one revisit
- Batch 010: 5 pages

Remaining authored recovery scope: 470 listings.

Continue with small batches. The next batch should keep prioritizing high-visibility HCMC food, restaurant, market, and style pages where a U.S.-based first-time visitor needs the app to define the thing, explain why it belongs to that city, and give a reason to remember it.
