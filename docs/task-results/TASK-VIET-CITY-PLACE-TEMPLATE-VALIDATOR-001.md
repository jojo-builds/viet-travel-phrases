# TASK-VIET-CITY-PLACE-TEMPLATE-VALIDATOR-001 Result

Status: complete. Commit hash is recorded in the final closeout because a commit cannot contain its own final hash without changing it.

## What Changed

- Added compatibility-first `pageKind`, `placeKind`, and `contentRole` metadata to the city library while preserving canonical page IDs and legacy `kind`.
- Changed actual generated page copy, not just metadata:
  - `phrase` pages keep the phrase-article flow.
  - `place` pages teach place-name recognition, map/ride/ticket/route use, and linked helper phrases.
  - `restaurant` pages now focus on durable tasks: reservation, table, menu, dietary/allergy, bill, payment, and ride back.
  - `dish` pages now teach dish recognition, ordering, ingredients/diet, and city-specific food use.
- Kept helper/action pages such as ATM/ride/stop/where-near-place as full phrase pages and linked them to the relevant place page.
- Stopped fake literal breakdowns for proper names. Proper names now use recognition labels unless a reliable reusable word exists.
- Added page-kind metadata into generated catalog, SQLite city/place tags, practice deck tags, and audit outputs.
- Hardened validators so the previous wrong-template city/place output fails before regeneration and stays blocked from returning.

## Accepted Jojo Steers

- Page-kind fit must visibly change generated page copy.
- Canonical helper phrases stay full-depth and are not deleted or downgraded.
- Proper names should not get guessed literal meanings.
- Restaurant copy must avoid unsourced current hours, prices, awards, or popularity claims.
- Result proof must summarize final generated structures for Bà Nà Hills, Da Nang, Hanoi Old Quarter, Nén Đà Nẵng, and one dish page.
- Validator pass is not enough; include a human-facing traveler-experience readout.

## Counts

- City library source pages: `750`
- Per city: `150` each for HCMC, Hanoi, Da Nang, Hoi An, Hue
- Page-kind counts: `601 phrase`, `134 place`, `13 restaurant`, `2 dish`
- Difficulty mix: `638 beginner`, `107 intermediate`, `5 advanced`
- SQLite canonical pages: `3,038`
- SQLite phrase rows: `3,046`
- Duplicate canonical page groups: `0`
- Missing audio rows: `2,094 planned`, `0 release-blocking`

## Proof Samples

### Bà Nà Hills

- Page kind: `place`; place kind: `landmark`
- Flow: At a glance, Quick say, Break it down, What it is, Use it with, When to use it, Good to know, Explore next.
- Breakdown: `Bà Nà -> name recognition`; `Hills -> English word in the name`; full phrase `Bà Nà Hills -> Ba Na Hills`.
- Linked phrase rows include `Có ATM gần Bà Nà Hills không?`, `Ăn gần Bà Nà Hills`, `Đi Bà Nà Hills`, and `Dừng ở Bà Nà Hills`.

### Da Nang

- City record remains Browse-owned metadata for this no-Swift task: `pageKind: city`.
- City subcategories remain collection metadata with `pageKind: category`: arrivals/routes, landmarks/attractions, neighborhoods/streets, food/coffee, shopping/markets, and practical help near places.
- Da Nang canonical phrase/place pages carry city, subcategory, difficulty, place kind, and content-role tags for future Browse/onboarding/practice surfaces.

### Hanoi Old Quarter

- Page kind: `place`; place kind: `neighborhood`
- At a glance now teaches it as a neighborhood name for maps, hotel notes, and walking directions.
- What it is uses authored context: a core first-time traveler area in Hanoi, useful for hotels, pickup points, and walking directions.
- Breakdown: `Phố cổ -> old quarter`; `Hà Nội -> name recognition`; full phrase `Phố cổ Hà Nội -> Hanoi Old Quarter`.

### Nén Đà Nẵng

- Page kind: `restaurant`; place kind: `restaurant`; content role: `fine-dining`.
- Flow: At a glance, Quick say, Break it down, Restaurant name, Before you go, Menu and dietary help, When to use it, Good to know, Explore next.
- Copy avoids current hours, prices, awards, and popularity claims; it teaches reservation/table/menu/dietary/payment/ride-back tasks instead.
- Linked phrase rows include `Đi Nén Đà Nẵng`, `Tôi có đặt bàn ở Nén Đà Nẵng`, `Dừng ở Nén Đà Nẵng`, and `Nhà hàng Nén Đà Nẵng ở đâu?`.

### Cao Lầu In Hoi An

- Page kind: `dish`; place kind: `dish`; content role: `dish-anchor`.
- Flow: At a glance, Quick say, Break it down, What it is, How to order, Ingredients and diet, When to use it, Good to know, Explore next.
- The page treats the dish as a city-specific food anchor, then links into ordering and dietary phrases.
- Linked phrase rows include `Tôi muốn ăn cao lầu ở Hội An`, `Đi Cao lầu ở Hội An`, `Dừng ở Cao lầu ở Hội An`, and diet/allergy helper phrases.

## Traveler Experience Readout

The city library now feels less like one generic place template wearing different names. A traveler landing on a landmark page gets map, ride, ticket, route, and nearby-helper language. A restaurant page teaches the tasks that happen around a booking and meal. A dish page helps the traveler recognize the dish, order it, and ask about ingredients. Proper-name pages no longer pretend names have simple literal meanings; they teach recognition first and keep the useful phrase rows close by.

## Validation

- `node native-ios/scripts/generate-viet-catalog.js` passed.
- `node native-ios/scripts/generate-authored-tier-one-pages.js` passed.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` passed.
- `node scripts/practice/generate-viet-practice-deck.js` passed.
- `node native-ios/scripts/validate-viet-city-library.js` passed.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed.
- `node native-ios/scripts/audit-viet-canonical-content.js --check` passed with `3,038 PASS`.
- `node native-ios/scripts/audit-viet-page-quality.js` passed with `3,038 / 3,038`.
- `node native-ios/scripts/validate-tier-one-listing-pages.js` passed.
- `node native-ios/scripts/validate-viet-practice-expansion.js` passed.
- `node scripts/practice/generate-viet-practice-deck.js --check` passed.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed.
- `node --test scripts/practice/generate-viet-practice-deck.test.js` passed.
- Broad wrong-template scan over current generated resources/city source/practice prototype returned no matches.
- `git diff --check` passed.
- `native-ios/App/**`, native tests, project files, and `native-ios/Resources/Audio/**` were not changed by this task.

## Reviewer Gate

Read-only reviewer gate approved from the full audit and proof samples:

- Traveler usefulness: approved. Page kind now matches what a first-time traveler is trying to do.
- Copy/page-kind fit: approved. Restaurant, dish, place, and phrase pages have distinct teaching flows.
- Canonical/system integrity: approved. Canonical IDs are preserved, duplicate canonical groups are zero, city tags resolve, and planned missing audio remains queued only.
