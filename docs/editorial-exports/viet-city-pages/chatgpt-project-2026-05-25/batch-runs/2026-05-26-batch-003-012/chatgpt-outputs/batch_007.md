SpeakLocal v2.2 BATCH_007 - Saigon A - 2026-05-26

Batch source basis: exact Batch 007 rows and handoff rules came from the attached prompt; v2.2 structure, phrase-card rules, catalog/link handling, and production-status limits came from the source bundle and project instructions; phrase IDs/audio IDs and related place IDs were checked against the attached catalog workbook.    

---

## Akuna / Akuna — Saigon — Restaurant

### Reader View

**Let Dinner Carry The Evening**

Akuna is a polished Saigon dinner built for attention, not a stop between errands. Come ready for a slower counter-and-table rhythm, Vietnamese ingredients in a fine-dining frame, and a room where the meal can carry the night.

### Useful phrase cards

* **“Tôi có đặt chỗ.”** — I have a booking.
* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Tính tiền giúp tôi.”** — The bill, please.

### Sections

**Confirm The Meal First**

Let staff confirm the menu format, pairings, allergies, and pace before the first course. This is the clean moment to say what you cannot eat.

**Watch The Room, Not Just The Plate**

The contrast is part of the memory: a controlled interior set against Saigon’s street movement outside. The meal feels better when you stop checking the next stop and let the room set the pace.

**Still Saigon, Just Slower**

The polish is obvious, but the thread is still local: Vietnamese ingredients, staff rhythm, drinks, courses, and timing. Keep the evening open enough for the meal to land.

### Implementation notes

* `contentContract`: `speaklocal.place.app-detail.v2.2`
* `id`: `city-hcmc-place-akuna`
* `displayName`: `Akuna`
* `englishName`: `Akuna`
* `city`: `Saigon`
* `category`: `restaurant`
* `pronunciation`: `ah-koo-nah`
* `target_hero_image`: `HeroCityHcmcPlaceAkuna`
* `draft_status`: `needs_jojo_voice_review`
* **Closest canonical anchor:** Bà Lễ Well / Bale Well.
* **Anchor behavior copied:** reduce first-meal awkwardness by making the first interaction clear before food arrives.
* **How this page differs:** Akuna is not a roll-it-yourself or casual ordering page; the traveler moment is reservation arrival and pacing in a fine-dining room.
* **Owned traveler moment:** arriving for a booked dinner and letting staff set the first rhythm.
* **Reader View phrase/audio status**

  * `time-4` / `time-4` — “Tôi có đặt chỗ.” — `mapped`
  * `food-menu` / `food-menu` — “Cho tôi xem thực đơn được không?” — `mapped`
  * `coffee-7` / `coffee-7` — “Tính tiền giúp tôi.” — `mapped`
* **Mentioned Here candidates**

  * None to render. Saigon is page-frame context, and no menu/catalog item is named in visible copy.
* **Related place candidates**

  * **Anăn Sài Gòn** — `relationship: polished_modern_vietnamese_restaurant_contrast` · `catalogId: hcmc-anan-saigon` · `status: render`

    * `displaySubtitle: Another high-attention Saigon dinner with a stronger market-side frame.`
    * `reason: Useful comparison for travelers choosing one modern Vietnamese dinner.`
* **Verification flags**

  * `type: light` · `reason: Current menu format, reservation flow, hours, pricing, and pairing options need pre-import verification.` · `blocking: false`
  * `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog phrases, but final native QA remains required before import.` · `blocking: false`
  * `type: catalog_qa` · `reason: Related restaurant card should be mapped to the exact existing HCMC place record.` · `blocking: false`
* **Source notes**

  * Batch row source notes list MICHELIN Vietnam 2025 / MICHELIN HCMC guide and the legacy fine-dining counter cue. 
  * Akuna’s official site frames the restaurant around Sam Aisbett’s cooking and Saigon context; exact current menu/reservation details should stay out of visible copy until verified. ([AKUNA Restaurant][1])
  * MICHELIN search result confirms the Akuna guide context but should be rechecked before any award/status language is rendered. ([Michelin Guide][2])
* **Score**

  * `27/30` — Strong voice and useful arrival behavior; capped for current menu/reservation freshness and no rendered screenshot review.
* **QA notes**

  * Replaceability test: pass.
  * Phrase card test: pass; all visible phrases use ready audio.
  * Mentioned Here test: pass; no natural renderable catalog item forced.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: `not_run`.
  * Production review gate: `not_run`; not production-ready.

---

## Chợ An Đông / An Dong Market — Saigon — Market

### Reader View

**Start With A Slow Fabric Lap**

Chợ An Đông is a shopping market, not a quick souvenir shelf. Walk one level slowly first: fabric stacks, clothing racks, small counters, bags, and gifts before you decide what is worth pricing.

### Useful phrase cards

* **“Cái này bao nhiêu?”** — How much is this?
* **“Giảm giá chút được không?”** — Can you lower the price?
* **“Tôi chỉ xem thôi.”** — I’m just looking.

### Sections

**Price After You Compare**

Do not ask at the first fabric stack unless you already know what you want. Compare color, weight, stitching, and quantity first, then ask the price with less pressure.

**Keep Your Hands Clear**

Browsing is easier when your hands are free and your bag is close. Point, smile, and keep a photo or sample ready if you are matching fabric or a clothing style.

**A Different Shopping Mood Than Bến Thành**

Bến Thành is easier for a central landmark-and-gifts stop. An Đông feels more like a layered shopping run: fabric, clothing, bags, and counters stacked into one market building.

### Implementation notes

* `contentContract`: `speaklocal.place.app-detail.v2.2`
* `id`: `city-hcmc-place-an-dong-market`
* `displayName`: `Chợ An Đông`
* `englishName`: `An Dong Market`
* `city`: `Saigon`
* `category`: `market`
* `pronunciation`: `chuh ahn dohng`
* `target_hero_image`: `HeroCityHcmcPlaceAnDongMarket`
* `draft_status`: `needs_jojo_voice_review`
* **Closest canonical anchor:** Chợ Hàn / Hàn Market.
* **Anchor behavior copied:** define what the market is for before listing inventory; give the traveler one first lap.
* **How this page differs:** Hàn is first-bearings plus food/gifts; An Đông is a shopping and fabric page with fewer food claims.
* **Owned traveler moment:** stepping into a multi-level shopping market and doing one fabric/clothing lap before asking prices.
* **Reader View phrase/audio status**

  * `price-1` / `price-1` — “Cái này bao nhiêu?” — `mapped`
  * `audio-authored-giam-gia-chut-duoc-khong-a718a9e74f` / `audio-authored-giam-gia-chut-duoc-khong-a718a9e74f` — “Giảm giá chút được không?” — `mapped`
  * `shop-4` / `shop-4` — “Tôi chỉ xem thôi.” — `mapped`
* **Mentioned Here candidates**

  * **Chợ Bến Thành** — `type: market` · `catalogId: hcmc-ben-thanh-market` · `status: render`

    * `displaySubtitle: The easier central market for landmark-and-gift browsing.`
    * `reason: Named naturally as the contrast to An Đông’s fabric/clothing shopping role.`
* **Related place candidates**

  * **Chợ Bình Tây** — `relationship: west_side_market_contrast` · `catalogId: hcmc-binh-tay-market` · `status: render`

    * `displaySubtitle: A larger Chợ Lớn market to compare with An Đông’s shopping lanes.`
    * `reason: Useful market comparison for travelers already thinking beyond central District 1.`
  * **Chợ Lớn** — `relationship: area_context` · `catalogId: hcmc-cho-lon` · `status: render`

    * `displaySubtitle: The broader west-side trading area around markets and older shop streets.`
    * `reason: Helps route planning for travelers pairing An Đông with a wider west-side look.`
* **Verification flags**

  * `type: light` · `reason: Current opening hours, stall mix, payment norms, bargaining norms, and building access should be checked before import.` · `blocking: false`
  * `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog phrases, but final native QA remains required before import.` · `blocking: false`
  * `type: catalog_qa` · `reason: Bến Thành, Bình Tây, and Chợ Lớn related/mention cards need final catalog ID confirmation.` · `blocking: false`
* **Source notes**

  * Batch row and catalog workbook identify An Đông as a multi-level local market with fabric and clothing stalls. 
  * Supplementary current travel source also frames An Đông around fashion and local commercial variety; visible copy avoids hours, exact floor claims, and food-stall claims. ([Vietnam Airlines][3])
* **Score**

  * `28/30` — Clear market role, clean first action, and strong phrase fit; capped for current market details and no rendered screenshot review.
* **QA notes**

  * Replaceability test: pass.
  * Phrase card test: pass; all visible phrases use ready audio.
  * Mentioned Here test: pass.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: `not_run`.
  * Production review gate: `not_run`; not production-ready.

---

## Anăn Sài Gòn / Anan Saigon — Saigon — Restaurant

### Reader View

**Let The Market Sit Beside The Meal**

Anăn Sài Gòn keeps a polished dinner close to Saigon: herbs, small plates, market-side movement, and a narrow city-center room instead of a sealed-off hotel meal.

### Useful phrase cards

* **“Tôi có đặt chỗ.”** — I have a booking.
* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Tính tiền giúp tôi.”** — The bill, please.

### Sections

**Ask How The Menu Moves**

Before ordering, ask staff to explain the menu path, portion size, and pace. The room rewards patience; it is easy to over-order before you understand how the plates build.

**Market Energy, Controlled Room**

The nearby market context matters, but the meal is organized. Let the contrast do the work: a careful plate, a drink, herbs on the table, scooters and stalls outside.

**Still Worth The Booking**

Anăn is known now, so the room may not feel like a secret. It can still make sense when you want one Saigon meal that turns street-food memory into a calmer dinner.

### Implementation notes

* `contentContract`: `speaklocal.place.app-detail.v2.2`
* `id`: `city-hcmc-place-anan-saigon`
* `displayName`: `Anăn Sài Gòn`
* `englishName`: `Anan Saigon`
* `city`: `Saigon`
* `category`: `restaurant`
* `pronunciation`: `ahn-uhn sigh gon`
* `target_hero_image`: `HeroCityHcmcPlaceAnanSaigon`
* `draft_status`: `needs_jojo_voice_review`
* **Closest canonical anchor:** Bà Lễ Well / Bale Well, with Morning Glory Original as a secondary behavior reference.
* **Anchor behavior copied:** make the first restaurant action clear: ask how the meal works before ordering too much.
* **How this page differs:** Anan is a modern Vietnamese restaurant in a market-side setting, so the page balances polish with street/market context rather than set-menu friction.
* **Owned traveler moment:** sitting down in a narrow market-side restaurant and letting staff explain the menu path before ordering.
* **Reader View phrase/audio status**

  * `time-4` / `time-4` — “Tôi có đặt chỗ.” — `mapped`
  * `food-menu` / `food-menu` — “Cho tôi xem thực đơn được không?” — `mapped`
  * `coffee-7` / `coffee-7` — “Tính tiền giúp tôi.” — `mapped`
* **Mentioned Here candidates**

  * None to render. Visible copy names market context but not a cataloged place or dish.
* **Related place candidates**

  * **Akuna** — `relationship: polished_modern_restaurant_contrast` · `catalogId: hcmc-akuna` · `status: render`

    * `displaySubtitle: A more controlled fine-dining counter-and-table dinner.`
    * `reason: Useful comparison for travelers choosing one high-attention Saigon restaurant.`
  * **Chợ Bến Thành** — `relationship: nearby_market_context` · `catalogId: hcmc-ben-thanh-market` · `status: check_catalog`

    * `displaySubtitle: A central market reference point near the city’s visitor core.`
    * `reason: Legacy row frames the restaurant beside Ben Thanh market energy; final mapping should confirm whether this route card helps or distracts.`
* **Verification flags**

  * `type: light` · `reason: Current menu format, reservation flow, hours, pricing, and named dishes should be checked before import.` · `blocking: false`
  * `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog phrases, but final native QA remains required before import.` · `blocking: false`
  * `type: catalog_qa` · `reason: Related restaurant and optional market-context cards need final catalog QA.` · `blocking: false`
* **Source notes**

  * Batch row lists existing city library plus MICHELIN Vietnam 2025, and describes Anan around herbs, small plates, and Ben Thanh market energy. 
  * Official Anan source describes the restaurant in Chợ Cũ/Tôn Thất Đạm market context and lists modern Vietnamese/tasting-menu framing; visible copy avoids specific current dish names. ([Anan Saigon][4])
  * MICHELIN page confirms 2025 MICHELIN-guide context; visible copy avoids award language until Codex/freshness check decides whether to render it. ([Michelin Guide][5])
* **Score**

  * `28/30` — Strong place-specific contrast and ordering behavior; capped for current menu/reservation freshness and no rendered screenshot review.
* **QA notes**

  * Replaceability test: pass.
  * Phrase card test: pass; all visible phrases use ready audio.
  * Mentioned Here test: pass; no dish/item forced.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: `not_run`.
  * Production review gate: `not_run`; not production-ready.

---

## Bảo tàng Áo Dài / Ao Dai Museum — Saigon — Museum

### Reader View

**Choose The Quiet Textile Stop**

Bảo tàng Áo Dài gives Saigon a slower cultural layer: silk, dress forms, photos, garden paths, and rooms built around the áo dài instead of another street-side landmark.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Có hướng dẫn tiếng Anh không?”** — Is there an English guide?

### Sections

**Look For Shape, Fabric, Story**

Do not try to read every panel. Start with the garment shape, then notice fabric, color, and who wore it. The áo dài becomes more alive when you read it through people, not only display cases.

**Leave Time For The Grounds**

The garden-like setting is part of the pause. Move between rooms and outdoor paths slowly; the visit feels flatter if you treat it like a single photo stop.

**Check The Practical Details Late**

Hours, ticket details, photo rules, and interpretation can change. Keep those checks close to the day you go, especially if you are coming from central Saigon.

### Implementation notes

* `contentContract`: `speaklocal.place.app-detail.v2.2`
* `id`: `city-hcmc-place-ao-dai-museum`
* `displayName`: `Bảo tàng Áo Dài`
* `englishName`: `Ao Dai Museum`
* `city`: `Saigon`
* `category`: `museum`
* `pronunciation`: `bow tahng ow yai`
* `target_hero_image`: `HeroCityHcmcPlaceAoDaiMuseum`
* `draft_status`: `needs_jojo_voice_review`
* **Closest canonical anchor:** Museum of Cham Sculpture.
* **Anchor behavior copied:** prevent museum fatigue by giving a few things to notice rather than asking the traveler to read everything.
* **How this page differs:** this is a textile/cultural museum with garden rhythm, not a compact sculpture-gallery route.
* **Owned traveler moment:** arriving for a slower museum-and-garden pause and choosing what to notice first.
* **Reader View phrase/audio status**

  * `sight-1` / `sight-1` — “Vé bao nhiêu?” — `mapped`
  * `sight-3` / `sight-3` — “Tôi chụp hình ở đây được không?” — `mapped`
  * `v900-sigh-acti-is-there-an-english-guide` / `v900-sigh-acti-is-there-an-english-guide` — “Có hướng dẫn tiếng Anh không?” — `mapped`
* **Mentioned Here candidates**

  * **Áo dài** — `type: experience` · `catalogId: null` · `status: check_catalog`

    * `displaySubtitle: Vietnam’s long dress, seen here through fabric, form, and personal history.`
    * `reason: Named naturally throughout the copy; render only if an existing cultural/item catalog record exists.`
* **Related place candidates**

  * **Bảo tàng Mỹ thuật** — `relationship: central_museum_alternative` · `catalogId: hcmc-fine-arts-museum` · `status: render`

    * `displaySubtitle: A more central art stop when you want culture without the longer ride.`
    * `reason: Useful comparison for travelers choosing between culture stops.`
  * **Bảo tàng Lịch sử Thành phố Hồ Chí Minh** — `relationship: museum_context_alternative` · `catalogId: hcmc-history-museum` · `status: render`

    * `displaySubtitle: A broader history museum option inside the city museum set.`
    * `reason: Helpful museum comparison; does not need to appear in visible body.`
* **Verification flags**

  * `type: light` · `reason: Current hours, ticket policy, photo policy, English interpretation, and route timing from central Saigon should be checked before import.` · `blocking: false`
  * `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog phrases, but final native QA remains required before import.` · `blocking: false`
  * `type: catalog_qa` · `reason: Áo dài item/card should render only if a real catalog target exists.` · `blocking: false`
* **Source notes**

  * Batch row describes a garden-like museum space with áo dài displays and colorful silk. 
  * Official museum site describes the museum as dedicated to the story of the áo dài through history, documents, artifacts, and exhibition spaces, and lists current contact/hours details that should be rechecked before import. ([Áo Dài Museum][6])
* **Score**

  * `27/30` — Clear museum behavior and calm voice; capped for current visitor details, catalog uncertainty around áo dài, and no rendered screenshot review.
* **QA notes**

  * Replaceability test: pass.
  * Phrase card test: pass; all visible phrases use ready audio.
  * Mentioned Here test: pass; áo dài flagged for catalog check, not forced to render.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: `not_run`.
  * Production review gate: `not_run`; not production-ready.

---

## Bến tàu thủy Bạch Đằng / Bach Dang Waterbus Station — Saigon — Port

### Reader View

**Let The River Change The Pace**

Bến tàu thủy Bạch Đằng is the moment Saigon turns from traffic into water. Come for the boarding point, skyline edges, boat noses, and the small shift from street noise to river movement.

### Useful phrase cards

* **“Đây có đúng bến không?”** — Is this the right platform?
* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Chuyến tàu cuối cùng về lúc mấy giờ?”** — What time is the last boat back?

### Sections

**Pick The Route Before Boarding**

The river feels better when you know the stop you are riding toward. Check the route and return before the boat becomes a one-way errand across the water.

**Arrive Like It Is Transit**

This is not a vague cruise. Be a little early, find the right boarding point, and listen for the boat instead of drifting along the waterfront until the moment passes.

**Pair It With The Waterfront**

The station makes most sense beside a Bạch Đằng Wharf walk, Nguyễn Huệ, or a short riverfront pause. Even a brief ride can feel memorable when the skyline loosens and the city opens across the water.

### Implementation notes

* `contentContract`: `speaklocal.place.app-detail.v2.2`
* `id`: `city-hcmc-place-bach-dang-waterbus-station`
* `displayName`: `Bến tàu thủy Bạch Đằng`
* `englishName`: `Bach Dang Waterbus Station`
* `city`: `Saigon`
* `category`: `port`
* `pronunciation`: `ben tow twee bahk dang`
* `target_hero_image`: `HeroCityHcmcPlaceBachDangWaterbusStation`
* `draft_status`: `needs_jojo_voice_review`
* **Closest canonical anchor:** Perfume River / Sông Hương, with Dragon Bridge as a secondary riverfront decision model.
* **Anchor behavior copied:** water experiences need a route, return plan, and one clear first decision.
* **How this page differs:** this is a transit-style river station, not a scenic cruise or landmark show.
* **Owned traveler moment:** standing at the Bạch Đằng boarding area and confirming the route before stepping onto the waterbus.
* **Reader View phrase/audio status**

  * `transport-1` / `transport-1` — “Đây có đúng bến không?” — `mapped`
  * `sight-1` / `sight-1` — “Vé bao nhiêu?” — `mapped`
  * `v900-tran-what-time-is-the-last-boat-back` / `v900-tran-what-time-is-the-last-boat-back` — “Chuyến tàu cuối cùng về lúc mấy giờ?” — `mapped`
* **Mentioned Here candidates**

  * **Bến Bạch Đằng** — `type: landmark` · `catalogId: hcmc-bach-dang-wharf` · `status: render`

    * `displaySubtitle: The waterfront walk beside the waterbus station.`
    * `reason: Named naturally as the route pairing beside the station.`
  * **Phố đi bộ Nguyễn Huệ** — `type: street` · `catalogId: hcmc-nguyen-hue-walking-street` · `status: render`

    * `displaySubtitle: A central walking-street pairing before or after the river.`
    * `reason: Named naturally as a nearby route pairing.`
  * **Sông Sài Gòn** — `type: river` · `catalogId: hcmc-saigon-river` · `status: render`

    * `displaySubtitle: The river that changes the city’s pace from road to water.`
    * `reason: Core context for the waterbus station and route.`
* **Related place candidates**

  * **Đi thuyền sông Sài Gòn** — `relationship: river_experience_extension` · `catalogId: hcmc-saigon-river-boat` · `status: render`

    * `displaySubtitle: A broader river ride option if you want more than transit.`
    * `reason: Helpful comparison between waterbus and river-ride planning.`
  * **Bờ sông Thủ Thiêm** — `relationship: across_river_viewpoint` · `catalogId: hcmc-thu-thiem-riverfront` · `status: render`

    * `displaySubtitle: The quieter opposite-bank view after crossing the river.`
    * `reason: Useful route/comparison candidate for waterbus users.`
* **Verification flags**

  * `type: same_week` · `reason: Route, schedule, last boat, ticketing, boarding point, and service status should be checked close to import.` · `blocking: false`
  * `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog phrases, but final native QA remains required before import.` · `blocking: false`
  * `type: catalog_qa` · `reason: Waterfront, river, and related place cards should be checked for exact target IDs and card subtitles.` · `blocking: false`
* **Source notes**

  * Batch row frames the station around river steps, boats, skyline edges, and the shift from street movement to water movement. 
  * Official Saigon WaterBus station page lists Bạch Đằng as a station and names nearby waterfront/city-center pairings; visible copy avoids exact address, fare, and schedule claims. ([Saigon WaterBus][7])
  * Saigon WaterBus online ticketing page confirms route/schedule planning matters, but route times and ticket details should be checked same week before rendering. ([Saigon WaterBus][8])
* **Score**

  * `28/30` — Strong route-first water moment and clean phrase fit; capped for same-week schedule/ticket freshness and no rendered screenshot review.
* **QA notes**

  * Replaceability test: pass.
  * Phrase card test: pass; all visible phrases use ready audio.
  * Mentioned Here test: pass.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: `not_run`.
  * Production review gate: `not_run`; not production-ready.

```markdown
## Codex handoff block

- `batch_id: batch_007`
- `page_ids: city-hcmc-place-akuna, city-hcmc-place-an-dong-market, city-hcmc-place-anan-saigon, city-hcmc-place-ao-dai-museum, city-hcmc-place-bach-dang-waterbus-station`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none; all visible phrase cards use ready-audio reusable phrases, with native-speaker/audio QA still required before import`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: Jojo voice review still required; no banned visible phrases intentionally used; restaurant copy avoids award/menu specifics; waterbus copy avoids schedule/fare specifics`
- `source_freshness_risks: Akuna and Anan menu/reservation/hours/pricing; An Dong Market hours/stall/payment/bargaining norms; Ao Dai Museum hours/tickets/photo/interpretation; Bach Dang Waterbus routes/tickets/boarding/last boat/service status`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```

[1]: https://akunarestaurant.com/ "Home - AKUNA Restaurant"
[2]: https://guide.michelin.com/vn/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/akuna?utm_source=chatgpt.com "Akuna - Ho Chi Minh City Restaurants"
[3]: https://www.vietnamairlines.com/kh/vi/plan-book/travel/travel-guide/an-dong-market?utm_source=chatgpt.com "Chợ An Đông: \"Trái Tim\" Thương Mại Sôi Động Của Sài Gòn"
[4]: https://anansaigon.com/ "ANAN SAIGON"
[5]: https://guide.michelin.com/vn/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/anan-saigon?utm_source=chatgpt.com "Ănăn Saigon - Ho Chi Minh City Restaurants"
[6]: https://baotangaodai.com.vn/ "Bảo Tàng Áo Dài"
[7]: https://saigonwaterbus.com/ben-tau-bach-dang "Bến tàu Bạch Đằng - Saigon WaterBus"
[8]: https://saigonwaterbus.com/dat-ve-truc-tuyen?utm_source=chatgpt.com "Đặt vé trực tuyến"
