SpeakLocal v2.2 BATCH_035 - Hanoi - 2026-05-26

## 1. Hibana by Koki / Hibana by Koki — Hanoi — restaurant

`page_id: city-hanoi-place-hibana-by-koki`

### Reader View

**Counter Seats Make The Meal**

Hibana by Koki is a polished Hanoi dinner where the counter is part of the scene: grill heat, chef hands, quiet pacing, and food arriving in small, watched moments. Save it for a night when the meal can carry its own weight.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Bạn đề xuất món gì?** — What do you recommend?
* **Tôi quẹt thẻ được không?** — Can I pay by card?

**The Grill Is The View**

The teppanyaki counter changes how the meal feels. You are watching timing, heat, and hands at work, not just waiting for plates to arrive.

**Give The Pace Room**

This is not the kind of dinner to squeeze between two rushed stops. Let the first few minutes settle, then decide whether the room, service rhythm, and menu style fit the evening.

**Keep The Rest Of The Night Light**

Plan something simple afterward: a short ride back, a quiet drink, or a walk if the weather is kind. The meal will feel better if it is not fighting a crowded schedule.

### Implementation notes

* Phrase/audio status:

  * `food-menu` / `food-menu` — mapped, ready audio.
  * `v900-food-drin-what-do-you-recommend` / `v900-food-drin-what-do-you-recommend` — mapped, ready audio.
  * `store-6` / `store-6` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hibana-by-koki` planned; hide pronunciation audio until ready.
* Mentioned Here candidates: none to render. Teppanyaki/grill scene can stay prose unless a catalog item exists.
* Related place candidates:

  * **Lamai Garden** — `catalogId: hanoi-lamai-garden` · `status: render` · displaySubtitle: Garden-side contemporary Vietnamese dinner.
  * **Gia** — `catalogId: hanoi-gia` · `status: render` · displaySubtitle: Another polished Hanoi dining room to compare.
* Freshness notes: current menu, booking flow, prices, award status, and holiday operations need current check before import.
* Source notes: MICHELIN Vietnam 2025; legacy city-v1 row.
* Score: 27/30 — strong counter-meal shape; capped for limited current venue detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 2. Lăng Bác / Ho Chi Minh Mausoleum — Hanoi — landmark

`page_id: city-hanoi-place-ho-chi-minh-mausoleum`

### Reader View

**A Quiet Line On Ba Đình Square**

The mausoleum pulls Hanoi into a formal register: broad paving, flags, pale stone, and a slower line than the streets around it. Even if you only take in the exterior and square, the stop changes the tone of the morning.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?

**Keep The Visit Formal**

Move softly, follow the line, and treat the square as a memorial setting rather than a quick photo backdrop. The place works through restraint.

**Do The Nearby Stops In One Pass**

The Ho Chi Minh Museum and One Pillar Pagoda sit close enough to think of this as a small civic cluster. Check access first, then keep the route simple.

**The Exterior Still Counts**

A full interior visit may not fit every day. The square, guards, flags, and stone face still give you a clear read on Hanoi’s formal public memory.

### Implementation notes

* Phrase/audio status:

  * `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
  * `repair-5` / `repair-5` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-ho-chi-minh-mausoleum` ready.
* Mentioned Here candidates:

  * **Ba Đình Square** — `catalogId: null` · `status: check_catalog` · displaySubtitle: Formal civic square around the mausoleum.
  * **Ho Chi Minh Museum** — `catalogId: hanoi-ho-chi-minh-museum` · `status: render` · displaySubtitle: Museum stop beside the mausoleum area.
  * **One Pillar Pagoda** — `catalogId: hanoi-one-pillar-pagoda` · `status: render` · displaySubtitle: Small pagoda nearby.
* Related place candidates:

  * **Ho Chi Minh Museum** — `catalogId: hanoi-ho-chi-minh-museum` · `status: render` · displaySubtitle: Add context after the square.
  * **Imperial Citadel of Thang Long** — `catalogId: hanoi-imperial-citadel` · `status: render` · displaySubtitle: Another formal history stop nearby.
* Freshness notes: access flow, hours, dress expectations, closures, and photo rules need current check.
* Source notes: Vietnam Travel Hanoi; Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — clear tone and route logic; capped for access and photo-rule checks.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 3. Bảo tàng Hồ Chí Minh / Ho Chi Minh Museum — Hanoi — museum

`page_id: city-hanoi-place-ho-chi-minh-museum`

### Reader View

**Pick One Thread Before The Rooms**

Ho Chi Minh Museum is easiest when you enter with one question instead of trying to absorb every display. From the plaza outside to the quieter rooms inside, it adds context after the formal space of Ba Đình.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**After The Square, Go Indoors**

The museum makes the area feel less like a single monument stop. Pair it after the mausoleum if you want the day to move from public ceremony into objects, rooms, and interpretation.

**Choose Objects, Not Every Label**

A short, focused visit can work well. Pick a few displays that actually hold your attention, then leave before the museum turns into a blur of text.

**Short Visits Are Fine**

This is a context stop, not a test of stamina. If you are also seeing One Pillar Pagoda or the mausoleum area, keep enough energy for the whole cluster.

### Implementation notes

* Phrase/audio status:

  * `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` — mapped, ready audio.
  * `v900-sigh-acti-is-there-an-english-guide` / `v900-sigh-acti-is-there-an-english-guide` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-ho-chi-minh-museum` planned; hide pronunciation audio until ready.
* Mentioned Here candidates:

  * **Ho Chi Minh Mausoleum** — `catalogId: hanoi-ho-chi-minh-mausoleum` · `status: render` · displaySubtitle: Formal square stop beside the museum.
  * **Ba Đình Square** — `catalogId: null` · `status: check_catalog` · displaySubtitle: Civic space around the museum area.
  * **One Pillar Pagoda** — `catalogId: hanoi-one-pillar-pagoda` · `status: render` · displaySubtitle: Nearby pagoda in the same area.
* Related place candidates:

  * **Hoa Lo Prison Relic** — `catalogId: hanoi-hoa-lo-prison` · `status: render` · displaySubtitle: A heavier Hanoi memory stop.
  * **Vietnam National Museum of History** — `catalogId: hanoi-national-museum-history` · `status: render` · displaySubtitle: Broader national-history museum.
* Freshness notes: current exhibits, entrance route, hours, ticketing, photo rules, and English guide availability need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — useful museum-fatigue framing; capped for planned place-name audio and current access details.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 4. Nhà tù Hỏa Lò / Hoa Lo Prison Relic — Hanoi — museum

`page_id: city-hanoi-place-hoa-lo-prison`

### Reader View

**A Heavy Stop Behind A Yellow Gate**

Hoa Lo Prison Relic sits behind a yellow gate on a Hanoi street that can feel ordinary until the visit turns inward. It is cells, displays, and a harder layer of memory, not a casual museum filler.

**Useful phrase cards**

* **Vé bao nhiêu?** — How much is the ticket?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**The Gate Sets The Tone**

The exterior is part of the shift. Step in slowly, then let the building narrow the pace before you move through the rooms.

**Take The Displays In Order**

This is one of those museums where jumping around can make the visit feel thinner. Follow the sequence, read selectively, and give the heavier rooms enough attention.

**Leave Space Afterward**

Hoàn Kiếm Lake or the Old Quarter can be a lighter next move, but do not rush straight into noise. A short walk helps the visit land.

### Implementation notes

* Phrase/audio status:

  * `sight-1` / `sight-1` — mapped, ready audio.
  * `v900-sigh-acti-is-there-an-english-guide` / `v900-sigh-acti-is-there-an-english-guide` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hoa-lo-prison` ready.
* Mentioned Here candidates:

  * **Hoan Kiem Lake** — `catalogId: hanoi-hoan-kiem-lake` · `status: render` · displaySubtitle: Lighter walk after a heavy museum.
  * **Old Quarter** — `catalogId: hanoi-old-quarter` · `status: render` · displaySubtitle: Nearby street area for a softer next move.
* Related place candidates:

  * **Ho Chi Minh Museum** — `catalogId: hanoi-ho-chi-minh-museum` · `status: render` · displaySubtitle: Another memory-focused Hanoi stop.
  * **Vietnamese Women’s Museum** — `catalogId: hanoi-womens-museum` · `status: render` · displaySubtitle: Nearby museum with a different lens on Vietnamese history.
* Freshness notes: current hours, tickets, exhibit access, audio/guide options, and photo rules need check.
* Source notes: Vietnam Travel Hanoi; Hanoi tourism portal; legacy city-v1 row.
* Score: 28/30 — strong physical arrival and pacing; capped for current museum logistics.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 5. Hồ Hoàn Kiếm / Hoan Kiem Lake — Hanoi — nature

`page_id: city-hanoi-place-hoan-kiem`

### Reader View

**Central Hanoi Opens Around Water**

Hoàn Kiếm Lake gives the Old Quarter side of Hanoi a pause: water, shade, Turtle Tower in the distance, the red bridge to Ngọc Sơn Temple, and people walking instead of pushing through traffic.

**Useful phrase cards**

* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?
* **Dừng ở đây được rồi.** — You can stop here.
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**Circle Once Before Sitting**

The lake is better after one unhurried loop or half-loop. Notice the bridge, shaded edges, benches, cafés, and crossings before choosing where to pause.

**The Bridge Gives The Lake A Focus**

The red bridge and Ngọc Sơn Temple make the water feel like more than a view. Turtle Tower does the quieter work from a distance.

**Easy Between Street Stops**

The lake is a good reset between Old Quarter lanes, coffee stops, museum time, and evening plans. It lets the center of Hanoi feel walkable for a while.

### Implementation notes

* Phrase/audio status:

  * `repair-5` / `repair-5` — mapped, ready audio.
  * `taxi-3` / `taxi-3` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hoan-kiem` ready.
* Mentioned Here candidates:

  * **Turtle Tower** — `catalogId: hanoi-turtle-tower` · `status: render` · displaySubtitle: Small landmark in the lake.
  * **Ngoc Son Temple** — `catalogId: hanoi-ngoc-son-temple` · `status: render` · displaySubtitle: Temple reached by the red bridge.
  * **Old Quarter** — `catalogId: hanoi-old-quarter` · `status: render` · displaySubtitle: Street area wrapped around the lake side.
* Related place candidates:

  * **The Note Coffee** — `catalogId: hanoi-the-note-coffee` · `status: render` · displaySubtitle: Short coffee ritual near the lake.
  * **Cafe Giang** — `catalogId: hanoi-giang-cafe` · `status: render` · displaySubtitle: Classic egg-coffee stop after a walk.
* Freshness notes: temple access, bridge crowding, lake-edge works, and nearby pedestrian changes need light check.
* Source notes: Vietnam Travel Hanoi; legacy city-v1 row.
* Score: 29/30 — stable, concrete, and easy to use; capped for route/access checks.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 6. Chợ Hôm / Hom Market — Hanoi — market

`page_id: city-hanoi-place-hom-market`

### Reader View

**Fabric First, Then The Aisles**

Chợ Hôm feels practical before it feels scenic: bolts of cloth, fluorescent light, bags moving through tight aisles, and shoppers who already know what they came for. Browse slowly and let the market show its everyday rhythm.

**Useful phrase cards**

* **Cái này bao nhiêu?** — How much is this?
* **Bớt chút được không?** — Can you lower it a little?
* **Trả ở đâu?** — Where do I pay?

**Walk Before Pointing**

Do one slow pass before asking prices. The fabric area is easier once you understand where people are browsing, cutting, carrying, and paying.

**Keep Purchases Small**

This is a good place for small practical buys or fabric curiosity, not a pressure test. If you are not sure, smile, step aside, and look again.

**A Market For Texture, Not A Checklist**

The best read here is the rhythm: cloth, counters, fluorescent light, movement, and ordinary shopping. You do not need to decode every stall.

### Implementation notes

* Phrase/audio status:

  * `price-1` / `price-1` — mapped, ready audio.
  * `price-4` / `price-4` — mapped, ready audio.
  * `shop-5` / `shop-5` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hom-market` planned; hide pronunciation audio until ready.
* Mentioned Here candidates: none to render. Fabric/stall browsing can remain prose unless catalog has a shopping item.
* Related place candidates:

  * **Dong Xuan Market** — `catalogId: hanoi-dong-xuan-market` · `status: render` · displaySubtitle: Larger Old Quarter market contrast.
  * **Hang Da Market** — `catalogId: hanoi-hang-da-market` · `status: render` · displaySubtitle: Another central market to compare.
  * **Long Bien Market** — `catalogId: hanoi-long-bien-market` · `status: render` · displaySubtitle: More active wholesale-market rhythm.
* Freshness notes: hours, stall mix, fabric availability, payment norms, and renovation/access changes need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — clear market behavior; capped for sparse current detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 7. Hoàng thành Thăng Long / Imperial Citadel of Thang Long — Hanoi — landmark

`page_id: city-hanoi-place-imperial-citadel`

### Reader View

**Gates, Courtyards, Then Context**

The Imperial Citadel of Thang Long turns Hanoi’s long history into walls, brick courts, gates, and open ceremonial space. It is not loud or fast; the visit works when you slow your stride and let the scale build.

**Useful phrase cards**

* **Vé bao nhiêu?** — How much is the ticket?
* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**Follow The Open Spaces**

Move from gate to courtyard to wall instead of treating the site like a single photo stop. The distance between things is part of how the place speaks.

**Old Walls, Modern Capital**

The citadel feels strongest when you notice the contrast: old brick and ceremony space sitting inside a working capital city.

**Build A Nearby History Loop**

Hanoi Flag Tower, the Vietnam Military History Museum, and the Temple of Literature can sit naturally around the same history-heavy day if you keep the route calm.

### Implementation notes

* Phrase/audio status:

  * `sight-1` / `sight-1` — mapped, ready audio.
  * `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-imperial-citadel` ready.
* Mentioned Here candidates:

  * **Hanoi Flag Tower** — `catalogId: hanoi-hanoi-flag-tower` · `status: render` · displaySubtitle: Nearby tower for a history route.
  * **Vietnam Military History Museum** — `catalogId: hanoi-vietnam-military-history-museum` · `status: render` · displaySubtitle: Museum pairing near the citadel area.
  * **Temple of Literature** — `catalogId: hanoi-temple-literature` · `status: render` · displaySubtitle: Another major Hanoi history stop.
* Related place candidates:

  * **Ho Chi Minh Mausoleum** — `catalogId: hanoi-ho-chi-minh-mausoleum` · `status: render` · displaySubtitle: Formal civic-memory stop nearby.
  * **Lenin Park** — `catalogId: hanoi-lenin-park` · `status: render` · displaySubtitle: Open-air pause after heavier history.
* Freshness notes: hours, tickets, gate flow, exhibit access, and photo rules need current check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 28/30 — strong landmark pacing and nearby route logic; capped for access details.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 8. Cà phê Lâm / Lam Cafe — Hanoi — cafe

`page_id: city-hanoi-place-lam-cafe`

### Reader View

**Old Hanoi In A Coffee Room**

Cà phê Lâm is a coffee pause where the room matters: framed paintings, dark coffee, old tables, and the street falling away for a few minutes. The cup is simple; the texture is in the walls and the slow break.

**Useful phrase cards**

* **Cho tôi cà phê đen đá.** — I’d like an iced black coffee.
* **Cho tôi một cà phê sữa đá.** — One iced milk coffee please.
* **Không đường nhé.** — No sugar please.

**Order Plain And Watch The Room**

A simple black coffee or milk coffee fits the old-café rhythm. Sit long enough to notice the paintings, tables, and quiet pace before checking your phone again.

**Better As A Pause Than A Work Session**

This is more satisfying as a short Hanoi reset than a long laptop stop. Let it be twenty calm minutes between streets.

**Coffee Links The Old Quarter**

Pair it with a nearby walk, gallery stop, or lake-side stretch if the day needs a gentler middle. The point is the pause, not a complicated order.

### Implementation notes

* Phrase/audio status:

  * `coffee-2` / `coffee-2` — mapped, ready audio.
  * `coffee-1` / `coffee-1` — mapped, ready audio.
  * `coffee-5` / `coffee-5` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-lam-cafe` planned; hide pronunciation audio until ready.
* Mentioned Here candidates:

  * **Vietnamese iced black coffee** — `catalogId: drink-ca-phe-den-da` · `status: render` · displaySubtitle: Strong iced black coffee order.
  * **Vietnamese iced milk coffee** — `catalogId: drink-ca-phe-sua-da` · `status: render` · displaySubtitle: Classic iced coffee with condensed milk.
* Related place candidates:

  * **Cafe Giang** — `catalogId: hanoi-giang-cafe` · `status: render` · displaySubtitle: Classic Hanoi egg-coffee comparison.
  * **The Note Coffee** — `catalogId: hanoi-the-note-coffee` · `status: render` · displaySubtitle: More touristy lake-side coffee ritual.
  * **Trieu Viet Vuong Coffee Street** — `catalogId: hanoi-trieu-viet-vuong-coffee-street` · `status: render` · displaySubtitle: Broader Hanoi coffee-street context.
* Freshness notes: current hours, seating, menu, and room condition need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row; coffee items mapped from Menu Catalog.
* Score: 27/30 — good café ritual and menu mapping; capped for current venue detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 9. Lamai Garden / Lamai Garden — Hanoi — restaurant

`page_id: city-hanoi-place-lamai-garden`

### Reader View

**Dinner With A Garden Edge**

Lamai Garden softens the Hanoi dinner rhythm with a path, herbs, warm interior light, and contemporary Vietnamese cooking. It feels suited to an evening when conversation and pacing matter as much as the plates.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Bạn đề xuất món gì?** — What do you recommend?
* **Tôi ăn chay.** — I am vegetarian.

**Arrive Ready To Slow Down**

The garden-side setting gives the meal a calmer beginning. Take a minute before ordering and let the room set the pace.

**Ask Before The Table Fills**

If pork, shellfish, spice, or vegetarian food matters, ask early. A polished room still works best when the first questions are clear.

**Keep The Evening Uncrowded**

This is a better dinner when it has space around it. Do not stack too many plans after the meal unless they are close and easy.

### Implementation notes

* Phrase/audio status:

  * `food-menu` / `food-menu` — mapped, ready audio.
  * `v900-food-drin-what-do-you-recommend` / `v900-food-drin-what-do-you-recommend` — mapped, ready audio.
  * `food-vegetarian` / `food-vegetarian` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-lamai-garden` planned; hide pronunciation audio until ready.
* Mentioned Here candidates: none to render. No current dish claims added.
* Related place candidates:

  * **Hibana by Koki** — `catalogId: hanoi-hibana-by-koki` · `status: render` · displaySubtitle: Counter-led polished dinner contrast.
  * **Tam Vi** — `catalogId: hanoi-tam-vi` · `status: render` · displaySubtitle: Vietnamese meal comparison in Hanoi.
  * **Uu Dam** — `catalogId: hanoi-udam` · `status: render` · displaySubtitle: Vegetarian-friendly restaurant comparison to check.
* Freshness notes: current menu, hours, booking flow, pricing, holiday operations, and MICHELIN listing state need check.
* Source notes: MICHELIN Vietnam 2025; legacy city-v1 row.
* Score: 27/30 — calm restaurant shape and reusable phrases; capped for limited current menu detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 10. Công viên Lê Nin / Lenin Park — Hanoi — park

`page_id: city-hanoi-place-lenin-park`

### Reader View

**Ordinary Hanoi In Open Air**

Lenin Park is a small city pause: shade trees, open paths, a statue plaza, and people using the space for walking, talking, and family time. It gives the day a breath without asking you to make it a major stop.

**Useful phrase cards**

* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?
* **Dừng ở đây được rồi.** — You can stop here.
* **Nhà vệ sinh gần nhất ở đâu?** — Where is the nearest restroom?

**Shade Before The Next Museum**

The park sits well before or after heavier nearby stops like the Imperial Citadel, Hanoi Flag Tower, or the Vietnam Military History Museum. A few shaded minutes can reset the route.

**Watch The Evening Change**

Late-day light, families, students, walkers, and traffic around the edges make the park feel more local than formal.

**A Short Pause Is Enough**

There is no need to stretch the stop. Walk, sit, take in the statue plaza and trees, then keep moving when the city starts calling again.

### Implementation notes

* Phrase/audio status:

  * `repair-5` / `repair-5` — mapped, ready audio.
  * `taxi-3` / `taxi-3` — mapped, ready audio.
  * `v500-dire-navi-where-is-the-nearest-restroom` / `v500-dire-navi-where-is-the-nearest-restroom` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-lenin-park` planned; hide pronunciation audio until ready.
* Mentioned Here candidates:

  * **Imperial Citadel of Thang Long** — `catalogId: hanoi-imperial-citadel` · `status: render` · displaySubtitle: Nearby history stop.
  * **Hanoi Flag Tower** — `catalogId: hanoi-hanoi-flag-tower` · `status: render` · displaySubtitle: Nearby landmark.
  * **Vietnam Military History Museum** — `catalogId: hanoi-vietnam-military-history-museum` · `status: render` · displaySubtitle: Nearby museum pairing.
* Related place candidates:

  * **Thong Nhat Park** — `catalogId: hanoi-thong-nhat-park` · `status: render` · displaySubtitle: Larger Hanoi park contrast.
  * **Hoan Kiem Lake** — `catalogId: hanoi-hoan-kiem-lake` · `status: render` · displaySubtitle: Central water-and-walking pause.
* Freshness notes: current park access, maintenance, nearby construction, and restroom availability need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — specific small-park role; capped for sparse current detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Codex handoff block

* `batch_id: batch_035`
* `page_ids: city-hanoi-place-hibana-by-koki, city-hanoi-place-ho-chi-minh-mausoleum, city-hanoi-place-ho-chi-minh-museum, city-hanoi-place-hoa-lo-prison, city-hanoi-place-hoan-kiem, city-hanoi-place-hom-market, city-hanoi-place-imperial-citadel, city-hanoi-place-lam-cafe, city-hanoi-place-lamai-garden, city-hanoi-place-lenin-park`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none; all visible phrase cards use ready reusable audio`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: fine-dining pages avoid dish/menu specifics; civic and museum pages avoid hours, rule, queue, ticket, and access claims; park/market/cafe pages stay intentionally restrained`
* `source_freshness_risks: MICHELIN 2025 venue state; restaurant/cafe menus and booking flow; mausoleum access and photo rules; museum/citadel hours, ticketing, exhibits, and guide availability; market stall mix and payment norms; park access and maintenance`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
