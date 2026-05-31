# Save-Worthy Restaurant Add Path

Date: 2026-05-31

Scope: current Viet V2.2 city/place source and native runtime projection.

## Why This Needs A Deliberate Path

Adding a missing restaurant is not currently a one-object edit. The city inventory started as 500 noun/place pages: 100 per city. The current importer validates the approved shape before projecting V2.2 copy into the legacy-compatible runtime.

That means a new restaurant page needs one of two explicit product choices:

- swap a weaker current HCMC row out of the 100-page inventory; or
- expand the inventory contract and update the scripts, reports, generated resources, render proof, and validation expectations that currently assume 100 pages per city.

For the additive pilots so far, Jojo chose the expansion path. The runtime shape was widened deliberately: HCMC now carries 106 noun/place rows, Hanoi carries 106, Da Nang carries 106, Hội An carries 101, and Hue remains at 100, for 519 total city places.

That makes Mặn Mòi, Bò Kho Gánh, Bún Bò Huế 14B, Phở Lệ, Phở Minh, Phở Hương Bình, Bánh Cuốn Bà Hoành, Bánh Cuốn Bà Xuân, Bún Chả Đắc Kim, Tuyết Bún Chả 34, Bún Riêu Cua 39, Phở Gà Nguyệt, Phở 10 Lý Quốc Sư, Bánh Canh Yến, Mỳ Quảng Sứa Hồng Vân, Bún Chả Cá 109, Bếp Hên, MỘC Quán Seafood, and Cơm Gà Bà Buội the current test set for whether stronger foodie pages make the app feel more save-worthy without forcing a premature drop decision.

## Implemented Pilot

First add: `Mặn Mòi` in Saigon.

Why this one first:

- It is a 2025 MICHELIN Bib Gourmand restaurant in the official Vietnam 2025 release.
- It also carries the 2025 Service Award signal, which gives the page a stronger human reason than another generic restaurant pin.
- It fills a clear gap: Saigon needs more recognized Vietnamese-table dinner pages, not only polished tasting rooms, cafes, and generic dish anchors.
- The save reason can be practical and emotional at once: shared dishes, rice, sauce, table rhythm, service, and a dinner that feels chosen before the trip.

Do not add it as a copied MICHELIN list item. The page should make the traveler want to save the place because they can picture the dinner and know why it belongs in Saigon.

## Proposed Runtime Identity

- Place ID: `hcmc-man-moi`
- V1 city page ID: `city-hcmc-place-man-moi`
- V2.2 app-detail ID: `viet-family-city-hcmc-place-man-moi`
- Display name: `Mặn Mòi`
- English name: `Man Moi`
- City: `Saigon`
- Category: `Restaurant`
- Hero target: `HeroCityHcmcPlaceManMoi`

Hero note: use an owned/licensed or generated realistic app asset that does not pretend to be documentary proof of the exact restaurant interior. A safe asset direction is a warm Vietnamese shared-table dinner with rice, clay dishes, herbs, sauces, and no readable signage, logos, faces as the subject, or fake storefront text.

## Draft Voice Direction

Owned traveler moment:

Save Mặn Mòi for a Saigon dinner where the point is not novelty, but a steady Vietnamese table: shared dishes, rice, sauce, attentive service, and a room that can carry the evening without becoming formal.

Story spine:

The restaurant matters because it gives Saigon a recognized, service-aware Vietnamese-table save. The 2025 Bib Gourmand and Service Award signals should support the choice, while the visible copy stays about the dinner itself.

Possible intro:

Heading: `A Service-Aware Vietnamese Table`

Body: `Mặn Mòi is the Saigon restaurant to save when dinner should feel settled: shared Vietnamese dishes, rice on the table, sauces close by, and service that helps the room stay calm. Its 2025 MICHELIN Bib Gourmand and Service Award signals make the save stronger, but the reason to go is the table.`

Possible sections:

- `Let Dinner Slow Down`
  - `Choose this for a night when the group wants to sit, pass dishes, and let the meal be the plan. It should not read like a quick snack stop or another trophy dinner.`
- `Order Around The Table`
  - `The useful move is to ask what the table should share, then let rice, vegetables, soup, and sauced dishes build the meal. Keep the menu question simple if the room is busy.`
- `Why It Belongs In Saigon`
  - `Saigon food pages need this middle lane: not street-food speed, not tasting-menu polish, but a restaurant dinner a visitor can actually picture saving before the trip.`
- `Good To Know`
  - `Keep current address, hours, and booking details out of bundled copy unless they are verified close to release. The app copy should carry the reason to save, not fragile logistics.`

Phrase cards:

- `food-menu` / `Cho tôi xem thực đơn được không?`
- `food-1` / `Cho tôi một phần`
- `food-3` / `Không cay nhé`

Related candidates:

- `viet-family-city-hcmc-place-cuc-gach-quan` as the old-house shared-table comparison.
- `viet-family-city-hcmc-place-bep-me-in` as the central Bib Gourmand comfort-table comparison.
- `viet-family-city-hcmc-place-anan-saigon` only if the copy needs a contrast with a more creative Saigon dinner.

## Future Swap Candidates To Review

Do not automatically remove `Phở Hòa Pasteur`; it still has a recognizable southern-phở job. Do not remove transit, market, or landmark rows to make room for a restaurant.

Review these types first:

- cafe rows that are useful but not central to a foodie-first Saigon save;
- duplicate experience rows where a place page and route page cover nearly the same traveler job;
- support shopping or mall rows that matter less than a stronger restaurant in a food-led launch slice.

The product question is not "is the old row bad?" It is "does this exact row still deserve a Saigon save slot once the food catalog gets more opinionated?"

## Implementation Checklist

For future swap mode:

1. Choose the outgoing city row and record why it is demoted, not deleted from history.
2. Update the matching `docs/city-production/agent-inputs/<city>-nouns.md` file while preserving the approved city count.
3. Run the city noun intake path or make an equivalent audited source update to `content-draft/viet/city-library/v1.json`.
4. Add the first-class V2.2 source object in `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`.
5. Update `content-draft/viet/city-library/app-detail-v2-2/_index.json`.
6. Add or wire the hero asset target and source notes.
7. Project V2.2 source to handwritten copy, import city copy, regenerate native catalog/listing pages/SQLite.
8. Run strict V2.2 validation, voice audit, city copy validation, listing validation, SQLite validation, fixture test, native-only guard, and `git diff --check`.
9. Render the new page top and bottom-clearance views in the `SpeakLocal City Listings` simulator.
10. Add a receipt to the food-listings production review with source, validation, and screenshot paths.

Expansion mode was treated as a separate product/engineering task because it changes the 500-page contract, validator expectations, and possibly UI assumptions around city inventory size.

Expansion mode has now been proven nineteen times for Mặn Mòi, Bò Kho Gánh, Bún Bò Huế 14B, Phở Lệ, Phở Minh, Phở Hương Bình, Bánh Cuốn Bà Hoành, Bánh Cuốn Bà Xuân, Bún Chả Đắc Kim, Tuyết Bún Chả 34, Bún Riêu Cua 39, Phở Gà Nguyệt, Phở 10 Lý Quốc Sư, Bánh Canh Yến, Mỳ Quảng Sứa Hồng Vân, Bún Chả Cá 109, Bếp Hên, MỘC Quán Seafood, and Cơm Gà Bà Buội. The implemented changes widened the importer and validators to expect HCMC 106 + Hanoi 106 + Da Nang 106 + Hội An 101 / total 519, added first-class V2.2 source objects, regenerated native resources, and recorded render proof under:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-man-moi-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bo-kho-ganh-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-bo-hue-14b-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-le-district-5-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-minh-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-huong-binh-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-banh-cuon-ba-hoanh-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-banh-cuon-ba-xuan-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-cha-dac-kim-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-tuyet-bun-cha-34-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-rieu-cua-39-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-ga-nguyet-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-10-ly-quoc-su-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-banh-canh-yen-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-my-quang-sua-hong-van-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bun-cha-ca-109-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-bep-hen-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-moc-quan-seafood-additive/`

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-com-ga-ba-buoi-additive/`

The first explicit support-demotion proof pass for existing restaurants lives under:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-mi-quang-support-demotion/`

The second support-demotion proof pass for an existing restaurant lives under:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-fatfish-support-demotion/`

The third support-demotion proof pass for an existing restaurant lives under:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-05-31-pho-hoa-pasteur-support-demotion/`

## Acceptance Gate

The page is not production-ready until it passes all of these:

- The visible copy answers why this restaurant, why its city, and why save it before the trip.
- MICHELIN language is date-bounded and source-supported.
- No fragile hours, prices, booking, address, closure, or menu-item claims are bundled without fresh verification.
- Useful phrase cards are playable.
- Mentioned Here and related-place cards render correctly if marked `render`.
- The hero image is owned/licensed/generated safely and does not mislead as exact documentary proof.
- Simulator screenshots prove first viewport, phrase cards, related modules, and bottom chrome clearance.
