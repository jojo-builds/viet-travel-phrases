# Vietnam City And Place Page Model Audit

Research date: 2026-05-03
Assignment: define the SpeakLocal Vietnam city/place page model, audit current city/place outputs, and recommend validator rules.
Owner lane: Research / Product Strategy

## Executive Takeaway

SpeakLocal should split the current city-guide article model into explicit page kinds instead of treating every city item as either a generic `phrase` page or generic `place` page.

The current generator is structurally valid and the city validator passes, but the content model is too flat. A restaurant, landmark, neighborhood, dish, city collection, category collection, and relationship/person teaching page all need different jobs. The shared template causes predictable semantic drift: restaurant pages talk like landmark pages, place briefs repeat themselves, breakdowns sometimes gloss English/proper-name fragments as if they were Vietnamese learning chunks, and many generated phrase pages are low-value utility shells such as `Eat near X` or `ATM near X`.

Recommendation: adopt the seven-kind taxonomy now as content-model direction, then create a follow-up generator/validator task that adds `pageKind`/`placeKind`-aware templates before regenerating city resources.

## Source Map

### Repo Sources

| Source | How Used |
| --- | --- |
| `content-draft/viet/city-library/v1.json` | Source truth for the current 750 approved city-guide rows. |
| `native-ios/Resources/viet-authored-listing-pages.json` | Generated page output audited for template issues. |
| `native-ios/scripts/generate-authored-tier-one-pages.js` | Current city-page template implementation. |
| `native-ios/scripts/validate-viet-city-library.js` | Current structural validator and gap analysis target. |
| `docs/V2_CONTENT_MODEL.md` | Existing phrase/listing terminology and canonical page graph model. |
| `docs/PHRASE_RELATIONSHIP_MODEL.md` | Existing relationship/person page direction. |
| `docs/task-results/VIET_CITY_PHRASE_LIBRARY_V1.md` | Original city-library source/provenance and validation result. |
| `docs/task-results/VIET_CITY_PHRASE_LIBRARY_750_EXPANSION.md` | Current 750-page expansion counts and validation result. |
| `docs/task-results/TASK-BROWSE-CATEGORY-CITY-NATIVE-UI-001.md` | Current Browse-owned category/city collection behavior. |

### Public Sources Checked

Access date: 2026-05-03.

| Source | Why It Matters |
| --- | --- |
| [Vietnam Tourism: Bà Nà Hills](https://www.vietnam.travel/things-to-do/explore-ba-na-hills) | Grounds Bà Nà Hills as a mountain/theme-park destination with tickets, cable car, Golden Bridge, transport from Da Nang, and crowd/timing implications. |
| [Vietnam Tourism: Da Nang](https://www.vietnam.travel/places-to-go/central-vietnam/da-nang) | Grounds Da Nang as a city collection: beach, Son Tra, Cham Museum, food, Marble Mountains, airport, train/bus, taxis, and day trips. |
| [Da Nang Fantasticity](https://danangfantasticity.com/en/) | Confirms Da Nang tourism categories such as See & Do, Eat & Drink, shopping, stay, events, and traveler essentials. |
| [Vietnam Tourism: Ha Noi](https://vietnam.travel/places-to-go/northern-vietnam/ha-noi) | Grounds Hanoi city and Old Quarter relationship to food, transport, walking, cafes, Hoan Kiem, and first-time visitor behavior. |
| [Vietnam Tourism: Explore the Old Quarter](https://vietnam.travel/things-to-do/explore-old-quarter-your-way) | Grounds Old Quarter as a walkable neighborhood with 36 guild streets, Hoan Kiem, street food, shopping, cafes, landmarks, and navigation pressure. |
| [Michelin Guide: Nén Danang](https://guide.michelin.com/us/en/da-nang-region/da-nang_2984390/restaurant/nen-danang) | Grounds Nén as a named contemporary Vietnamese restaurant, not a generic place. |
| [Nén Danang official site](https://restaurantnen.com/nen-danang-restaurant/) | Grounds reservation, address, service-time, dietary arrangement, pairing, and restaurant-specific page needs. |
| [Vietnam Tourism: Nén Danang Green Star](https://vietnam.travel/node/1639) | Grounds Nén as a sustainability/fine-dining destination with address and hyper-local ingredient story. |

## Current State Audit

### Current Inventory

Read-only checks found:

| Metric | Current Value |
| --- | ---: |
| Approved city-guide source pages | 750 |
| Source page kinds | 601 `phrase`, 149 `place` |
| Cities | 5 |
| Beginner pages | 638 |
| Intermediate pages | 107 |
| Advanced pages | 5 |
| Generated city pages with `Relationship words` sections | 0 |
| Suspect breakdown tokens in generated city pages | 41 |
| Place pages whose `when-to-use` says "visit [city]" rather than the place | 149 |
| Food/coffee place pages whose quick-say text says "landmark" | 15 |
| Place pages with repeated `X is a Y in City` prefix in `Place brief` | 124 |

Validation command:

```text
node native-ios/scripts/validate-viet-city-library.js
```

Result:

```text
City library OK: 750 pages, 638 beginner, 107 intermediate, 5 advanced
```

The important finding is that the current validator proves structural integrity, not page-kind fit.

### Wrong-Template Issues Found

| Issue | Evidence | Why It Matters |
| --- | --- | --- |
| City source model is too flat | `content-draft/viet/city-library/v1.json` has only `phrase` and `place` page kinds. | It cannot express city, restaurant, dish, category, or relationship/person jobs directly. |
| Relationship words on landmark pages | Checked: 0 generated city pages currently include `Relationship words`. | Good current state, but the future validator should keep this page-kind-gated. |
| Generic landmark language on restaurant pages | `viet-family-city-danang-place-nen` quick-say says the name helps when you "hear a local say the landmark quickly." | A restaurant page should talk about reservation, address, table, menu, dietary needs, and payment, not landmark recognition. |
| Place pages tell users to visit the city | 149 place pages use the pattern `Use this page before you visit [City]...`. | Bà Nà Hills should say "before the day trip / cable car / ticket desk"; Nén should say "before a reservation or ride"; Old Quarter should say "before walking/navigation." |
| Repeated place-brief copy | 124 place pages repeat the prefix `X is a Y in City`. Bà Nà and Nén both repeat the sentence start. | The page feels machine-filled instead of authored. |
| Fake or weak breakdown labels | 41 suspicious tokens, including `Hills -> Hills`, `APEC -> APEC`, `Bạc -> Street`, `Viện -> Street`, `Morning Glory -> Morning Glory`. | Breakdown should teach reusable Vietnamese pieces or say "proper name, recognition only"; it should not invent literal teaching value. |
| Filler phrase families | In just Da Nang and Hanoi, 46 source rows start with broad generated families such as `eat-near-` or `atm-`. | These can be useful as helpers, but they should not all become full "deep article" pages. Many belong as rows inside place/city/restaurant pages. |
| Weak restaurant selection model | Only 13 restaurant/cafe anchors exist across 5 cities, and Da Nang currently has only one restaurant place anchor: Nén. | Nén is credible for fine dining, but a city food model also needs everyday dish/stall/cafe anchors and a reason for each selected restaurant. |

## Proposed Page Kinds

### 1. `phrase`

Purpose: teach one thing the traveler can say or recognize.

Use when:

- the page's primary object is a Vietnamese utterance;
- audio, pronunciation, and breakdown are the core value;
- nearby rows are variants, likely replies, repairs, or next-step phrases.

Recommended sections:

| Section | Job |
| --- | --- |
| `At a glance` | Why this phrase matters in a real traveler moment. |
| `Quick say` or `Standard way` | The safest phrase to say first, with offline audio. |
| `Break it down` | Only reusable Vietnamese pieces; proper names should be recognition-only. |
| `When to use it` | Concrete setting, person, and moment. |
| `You may hear` | Short likely replies or local signals where useful. |
| `Repair / next step` | What to say if the first phrase is not enough. |
| `Good to know` | Positive local/tone note. |
| `Explore next` | Canonical phrase pages, not duplicate rows. |

Validation direction:

- phrase pages must have a playable or explicitly planned phrase audio state;
- breakdown must not use generic labels such as `key word`, `place detail`, or proper-name fragments as literal English;
- `relationship-words` is allowed only when page content contains relationship/pronoun/social-address signals.

### 2. `place`

Purpose: help the traveler recognize, say, show, and route to one destination or neighborhood.

Use when:

- the primary object is a named place, landmark, airport, station, bridge, museum, beach, market, street, or neighborhood;
- the traveler likely points to a map or asks a driver/hotel/staff member.

Recommended sections:

| Section | Job |
| --- | --- |
| `Place name` | Vietnamese name, English name, pronunciation, audio state. |
| `What it is` | Place type and why a traveler needs this name. |
| `Use it with` | Map pin, driver, ticket desk, hotel desk, entrance, pickup point. |
| `Useful phrases here` | Go/stop/where/ticket/time/helper phrases tied to the place. |
| `What you may hear` | Entrance, ticket, cable car, street, counter, wait time, turn, closed/open where relevant. |
| `Good to know` | Practical context, not generic praise. |
| `Nearby / next` | Related city/place/category pages. |

Validation direction:

- no `relationship-words` section unless a relationship/person signal is explicit;
- no generic `landmark` wording for restaurant/cafe/station/airport pages;
- `when-to-use` must mention the place or place type, not only the city;
- place-brief must not repeat `X is a Y in City` twice.

### 3. `city`

Purpose: Browse-owned city collection, not a phrase-detail article.

Use when:

- the primary object is Da Nang, Hanoi, Saigon/HCMC, Hoi An, Hue, or future cities;
- the user is choosing what to browse/practice in that city.

Recommended sections:

| Section | Job |
| --- | --- |
| `City snapshot` | Short city promise and when this city page helps. |
| `Arrive and get oriented` | Airport/station/first ride phrases. |
| `Places and neighborhoods` | Major landmarks, streets, districts, old town/quarter surfaces. |
| `Food, coffee, and markets` | Dish, restaurant, cafe, market, allergy/payment helper links. |
| `Practical help nearby` | ATM, pharmacy, bathroom, lost item, phone/SIM, hotel desk. |
| `Practice this city` | City-scoped Practice entry. |
| `Explore next` | Neighboring cities and major day-trip anchors. |

Validation direction:

- city pages should be `BrowseCollectionRoute.city`, not phrase pages;
- city collection should group real place/phrase rows by subcategory;
- city should not have phrase breakdown cards.

### 4. `restaurant`

Purpose: help the traveler find, enter, confirm, order, handle dietary needs, and pay at a named restaurant.

Use when:

- `place.kind` is `restaurant` or a named cafe that functions like a destination;
- source supports the name, address, food style, reservation/booking, or traveler relevance.

Recommended sections:

| Section | Job |
| --- | --- |
| `Restaurant name` | Name, pronunciation, audio state, map/address support. |
| `Before you go` | Reservation, opening/service-time, address, ride/drop-off phrase. |
| `At the door` | Table/reservation/party-size phrases. |
| `Menu and dietary help` | Menu, signature dish, allergy, vegetarian/vegan, spice/shellfish where supported. |
| `During the meal` | Water, utensils, recommendation, wait time, takeaway if appropriate. |
| `Pay and leave` | Bill, card/cash/QR, receipt. |
| `Dishes / nearby` | Dish pages and nearby food/city pages. |

Validation direction:

- restaurant pages must not use `landmark` copy unless the restaurant is literally a landmark and source says so;
- source selection should classify restaurant role as `everyday`, `iconic`, `fine-dining`, `cafe`, `market-stall`, or `dish-anchor`;
- fine-dining restaurants should include reservation/dietary/payment phrasing, not just `go/stop/where`.

### 5. `dish`

Purpose: help the traveler recognize and order a specific food or drink.

Use when:

- primary object is `mì Quảng`, `bún chả`, `phở`, `cao lầu`, `bún bò Huế`, egg coffee, or similar;
- the traveler needs what-it-is, ordering, ingredient, diet, and pronunciation support.

Recommended sections:

| Section | Job |
| --- | --- |
| `Dish name` | Vietnamese name, English explanation, pronunciation/audio. |
| `What it is` | Plain-language description without overclaiming. |
| `How to order` | One simple ordering phrase plus variants. |
| `Ingredients and diet` | Pork/beef/seafood/nuts/herbs/spice/allergy checks. |
| `Where it fits` | City/region, restaurants/markets, meal context. |
| `Good to know` | Local ordering note, positive and practical. |
| `Explore next` | Restaurant, market, allergy, bill, and nearby dish pages. |

Validation direction:

- dish pages must not be typed as `restaurant` just because a restaurant name contains a dish;
- dish page body must include ingredient/diet note when the dish commonly raises diet/allergy questions;
- avoid "best/top/must-try" unless source-backed and not used as product hype.

### 6. `category`

Purpose: Browse-owned collection page.

Use when:

- the user is browsing a scenario, category, or subcategory such as food, hotel, transport, city guides, or practical help.

Recommended sections:

| Section | Job |
| --- | --- |
| `Category masthead` | Short utility promise. |
| `Start here` | 3-5 high-value starter rows. |
| `Subcategory shelves` | Grouped Browse cards. |
| `Popular city/place links` | Optional city/place handoffs. |
| `Practice entry` | Category-scoped practice when useful. |
| `Explore next` | Adjacent categories and likely next needs. |

Validation direction:

- category pages should not be emitted as phrase/detail pages;
- no phrase breakdown or pronunciation unless the collection opens a specific phrase;
- Search should hand off to Browse collection for strong category/city matches.

### 7. `relationship/person`

Purpose: teach social-address choices, pronouns, roles, and relationship words.

Use when:

- the page teaches `anh`, `chị`, `em`, `cô`, `chú`, `ông`, `bà`, service roles, age/relationship, or greeting forms.

Recommended sections:

| Section | Job |
| --- | --- |
| `Who this is for` | Person/role relationship in plain traveler English. |
| `Say-first phrase` | Main usable phrase. |
| `Relationship words` | Pronoun/role rows with when-to-use notes. |
| `When to use / avoid` | Social fit, uncertainty fallback, sensitive cases. |
| `Examples` | Greeting/service/thanks/yes/no examples. |
| `Good to know` | Warm local guidance without grammar jargon. |
| `Explore next` | Greeting, thanks, apology, polite repair pages. |

Validation direction:

- `relationship-words` is required only on eligible relationship/person or greeting pages;
- relationship sections are forbidden on generic city/place/restaurant/dish/category pages;
- title/body copy should say "relationship words" or traveler role, not internal grammar jargon.

## Example Revised Outlines

### Bà Nà Hills - `place`

Grounding: Vietnam Tourism describes Bà Nà Hills as a unique mountain theme-park destination outside Da Nang, with cable car access, Golden Bridge, tickets, hotels/restaurants, and transport from Da Nang by private car, Grab, or taxi.

Page outline:

| Section | Proposed Content Job |
| --- | --- |
| `Place name` | `Bà Nà Hills` / `Ba Na Hills`; pronunciation; note that the English-style `Hills` is part of the name, not a reusable Vietnamese word. |
| `What it is` | Mountain resort/theme park day trip outside Da Nang; useful for Golden Bridge, cable car, tickets, pickup/return planning. |
| `Use it with` | Show the map pin or ticket screen; use with hotel desk, driver, tour desk, ticket counter. |
| `Useful phrases here` | `Đi Bà Nà Hills`, `Bà Nà Hills ở đâu?`, `Dừng ở Bà Nà Hills`, `Một vé vào Bà Nà Hills`, `Mấy giờ cáp treo đóng?` if added. |
| `What you may hear` | Cable car, ticket, private car/taxi, round trip, early morning, crowded, return ride. |
| `Good to know` | For route planning, the return trip and cable-car timing matter more than a generic "where is it" answer. |
| `Explore next` | Da Nang city, Golden Bridge, Marble Mountains, My Khe, practical help near Bà Nà Hills. |

Validation notes:

- do not split `Hills` into a fake learning card;
- do not say "before you visit Da Nang";
- do not repeat `Bà Nà Hills is a landmark in Da Nang`.

### Da Nang - `city`

Grounding: Vietnam Tourism frames Da Nang around beaches, Son Tra, Cham Museum, street food, Marble Mountains, airport, train/bus hub, taxis/ride-hailing, and day trips. Da Nang Fantasticity organizes traveler content into See & Do, Eat & Drink, Shopping, Stay, Events, Explore, and Traveler Essentials.

Page outline:

| Section | Proposed Content Job |
| --- | --- |
| `City snapshot` | Coastal central Vietnam city for beach, airport arrival, food, day trips, and Da Nang/Hoi An/Hue movement. |
| `Arrive and get oriented` | Da Nang Airport, railway station, Tien Sa Port, first taxi/ride phrases. |
| `Places and neighborhoods` | My Khe, Son Tra, Marble Mountains, Dragon Bridge, Han River, Ba Na Hills. |
| `Food, coffee, and markets` | Mi Quang, seafood near My Khe, Han Market, Con Market, Nén as fine-dining example, everyday food anchors still needed. |
| `Practical help nearby` | ATM, pharmacy, bathroom, SIM/data, hotel/driver help near actual places. |
| `Practice this city` | Da Nang Coast Loop and city-scoped prompt deck. |
| `Explore next` | Hoi An, Hue, Ba Na Hills, Marble Mountains, airport/station surfaces. |

Validation notes:

- should render as Browse collection, not a phrase detail;
- no `Break it down`;
- each shelf must use real city-tagged rows and not duplicate phrase pages.

### Hanoi Old Quarter - `place` / neighborhood

Grounding: Vietnam Tourism describes Hanoi's Old Quarter as a walkable neighborhood with 36 guild streets, old shops, street food, cafes, Hoan Kiem, shopping, landmarks, and a frenetic but rewarding walking experience.

Page outline:

| Section | Proposed Content Job |
| --- | --- |
| `Place name` | `Phố cổ Hà Nội` / `Hanoi Old Quarter`; pronunciation; explain `phố cổ` as old quarter/old streets and `Hà Nội` as city anchor. |
| `What it is` | Walkable historic neighborhood, good for hotels, walking routes, cafes, street food, shopping, and meetup points. |
| `Use it with` | Hotel desk, driver, cyclo, map pin, walking direction, pickup point. |
| `Useful phrases here` | `Đi Phố cổ Hà Nội`, `Phố cổ Hà Nội ở đâu?`, `Dừng ở phố cổ Hà Nội`, `Phố cổ Hà Nội gần đây không?`, Old Quarter street/market helpers. |
| `What you may hear` | Hoan Kiem, Hang streets, night market, walking, cyclo, one-way/traffic, nearby lake/cathedral. |
| `Good to know` | For Old Quarter, street names and nearby landmarks are often more useful than one broad district name. |
| `Explore next` | Hoan Kiem Lake, Ta Hien, Dong Xuan Market, Giang Cafe, St. Joseph Cathedral, Hanoi city. |

Validation notes:

- place kind should be `neighborhood`, not generic landmark;
- breakdown should teach `Phố cổ` and `Hà Nội`, not generic fragments;
- food/shopping/cafe content belongs as shelves, not filler paragraphs.

### Nén Đà Nẵng - `restaurant`

Grounding: Michelin lists Nén Danang at 16 My Da Tay 2 Street, Khue My Ward, Ngu Hanh Son District, Da Nang, as contemporary Vietnamese/farm-to-table. Nén's official site describes modern Vietnamese fine dining, hyper-local ingredients, reservation, service time, dietary arrangements with advance notice, pairings, and address. Vietnam Tourism notes its Michelin Green Star and hyper-local ingredient story.

Page outline:

| Section | Proposed Content Job |
| --- | --- |
| `Restaurant name` | `Nén Đà Nẵng` / `Nen Danang`; pronunciation/audio; address/map support. |
| `Before you go` | Reservation, service time, ride/drop-off, address confirmation. |
| `At the door` | `Tôi có đặt bàn ở Nén Đà Nẵng`, party size, reservation name, wait time. |
| `Menu and dietary help` | Set menu, vegetarian/vegan/dietary arrangement, allergies, pairing, "no shellfish/pork/nuts" phrase links. |
| `During the meal` | Water, recommendation/explanation, ingredient question, slow/repeat explanation. |
| `Pay and leave` | Bill, card/cash/QR, receipt, taxi back. |
| `Dishes / nearby` | Da Nang food collection, Michelin/fine-dining note, My Khe/Ngũ Hành Sơn nearby area, not a generic restaurant list. |

Validation notes:

- no "landmark quickly" wording;
- no `before you visit Da Nang`;
- page must include reservation/dietary/payment phrase opportunities because the public sources make those restaurant jobs relevant.

## Validator Recommendations

### Source Schema

- Add explicit `pageKind`: `phrase`, `place`, `city`, `restaurant`, `dish`, `category`, `relationship-person`.
- Add `placeKind` where applicable: `landmark`, `neighborhood`, `street`, `market`, `restaurant`, `cafe`, `dish`, `airport`, `station`, `port`, `beach`, `museum`, `park`, `nature`, `temple`, `bridge`.
- Add `contentRole` for restaurants/dishes: `everyday`, `iconic`, `fine-dining`, `cafe`, `market-stall`, `dish-anchor`.
- Add `templateID` or derive template from `pageKind` + `placeKind` before generating sections.

### Template Validators

- Forbid `relationship-words` outside `relationship-person` and eligible greeting/social-address pages.
- Forbid "landmark" in restaurant/cafe quick-say, when-to-use, or place-brief copy unless `placeKind=landmark`.
- Forbid `Use this page before you visit [city]` on non-city place pages.
- Forbid repeated `X is a Y in City. X is a Y in City...` prefixes.
- Forbid page titles in non-final breakdown cards unless the token is marked `proper-name-recognition`.
- Flag English/proper-name token glosses that equal the Vietnamese token, such as `Hills -> Hills`, `Morning Glory -> Morning Glory`, or `Landmark 81 -> Landmark 81`.
- Require restaurant pages to include at least two restaurant-specific phrase opportunities from reservation, table, menu, dietary/allergy, recommendation, payment, or receipt.
- Require dish pages to include ingredient/diet/allergy guidance.
- Require city pages to be Browse collection descriptors, not generated phrase articles.
- Cap filler pattern pages such as `eat-near-*`, `atm-*`, `stop-*`, and `where-*` per place unless they serve different traveler jobs.

### Source Selection Validators

- Restaurant/cafe anchors should include a source role and traveler fit reason.
- Each city should have a mix of everyday food/dish anchors and optional fine-dining/iconic anchors. A Michelin-only city food set is not enough.
- Named restaurants should not be promoted only because they are famous; they need a practical phrase job.
- Public source links should be rechecked before launch if a page relies on opening hours, service time, prices, or current awards.

## Fold-In Recommendations

### Adopt Now

- Treat city/place research as page-kind work, not only phrase expansion.
- Use the seven-kind taxonomy as the next city-guide source direction.
- Keep city and category pages Browse-owned.
- Keep relationship/person pages separate from place/restaurant/dish/category pages.
- Use Nén only as a fine-dining restaurant example, not as the broad Da Nang food model.

### Create Task Card

- `TASK-VIET-CITY-PLACE-TEMPLATE-VALIDATOR-001`: add page-kind-aware city templates and validators, then regenerate city resources.
- `TASK-VIET-CITY-FOOD-ANCHOR-REBALANCE-001`: rebalance restaurant/dish anchors for Da Nang, Hanoi, HCMC, Hoi An, and Hue with everyday food plus sourced iconic/fine-dining examples.
- `TASK-VIET-CITY-BROWSE-COLLECTION-COPY-001`: define city/category collection copy and shelf rules for Browse, separate from phrase-detail articles.

### Hold For Later

- Full current-resource regeneration.
- App UI changes for new page-kind rendering.
- More cities beyond the current five.
- Launch-store content based on city/place pages.

### Reject

- One shared article template for all city phrases and all named places.
- Proper-name breakdowns that pretend English fragments are reusable Vietnamese.
- Restaurant pages that read like landmark pages.
- City pages emitted as phrase articles.
- Filler rows promoted to deep pages just because they pass structural validation.

### Needs Jojo Decision

- Whether to prioritize template/validator repair before adding more city pages.
- Whether Da Nang food should lead with everyday dishes such as mì Quảng/seafood before fine-dining restaurants.
- Whether restaurant pages should support reservation/payment/dietary phrase bundles in the first implementation pass.

## Folded Into

Pending Jojo/orchestrator review. No app code, generated resources, city source JSON, SQLite, audio, or validator code has been changed from this audit yet.

This audit should be the source brief for the next content-data task that updates city-library source schema, generator templates, and validation rules.
