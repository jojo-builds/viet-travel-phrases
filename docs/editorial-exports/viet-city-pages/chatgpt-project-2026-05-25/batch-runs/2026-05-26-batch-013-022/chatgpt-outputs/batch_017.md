SpeakLocal v2.2 BATCH_017 - Da Nang - 2026-05-26

Source grounding: exact batch scope and handoff requirements came from the pasted batch; v2.2 output shape, voice rules, phrase-card requirements, and production-status limits came from the project instructions and source bundle; catalog IDs came from the Copy Ledger and Catalogs workbook.    

## 1. Fatfish / Fatfish Restaurant & Lounge Bar — Da Nang — restaurant

### Reader View — app-visible copy only

**A River Table When Dinner Matters**

Fatfish is for the evening when dinner is not just a gap between bridge photos and the ride home. The terrace, warm light, drinks, and Han River blur give the meal a slower Da Nang shape without turning it into a formal night.

### Useful phrase cards

* **“Cho tôi bàn cho hai người nhé”** — A table for two, please.
* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Tính tiền giúp tôi”** — Please let me pay.

### Sections

**Terrace First, If The Air Is Kind**

The riverside seat is the reason to linger. If the weather is heavy or the room feels easier, keep the order simple and let the view do less work.

**One Round Before The Table Fills**

Start with drinks and one or two plates, then widen the order after you understand the portions. It keeps the meal from becoming a table-management problem.

**A Calm Pair With The River**

Fatfish makes sense before or after a Hàn River walk, especially when the day has already had enough movement. The slower table is the memory here.

### Implementation notes

**Closest canonical anchor:** Morning Glory Original — controlled restaurant ordering without turning the page into menu inventory.
**Anchor behavior copied:** Make the first table move clear: seating, menu, portions, payment.
**How this page differs:** Fatfish is a riverside restaurant/lounge moment, not a local-specialty ordering lesson.
**Owned traveler moment:** Arriving for an evening river-table meal and deciding how much of the night to let the restaurant hold.

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-fatfish`
* `displayName: Fatfish`
* `englishName: Fatfish Restaurant & Lounge Bar`
* `city: Đà Nẵng`
* `category: Restaurant`
* `pronunciation: fatfish`

**Useful phrase card mapping**

* “Cho tôi bàn cho hai người nhé” — `intent: ask_table_for_two` · `phraseId: food-need-table` · `audioId: food-need-table` · `status: mapped`
* “Cho tôi xem thực đơn được không?” — `intent: see_menu` · `phraseId: food-menu` · `audioId: food-menu` · `status: mapped`
* “Tính tiền giúp tôi” — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

**Mentioned Here candidates**

* **Han River / Sông Hàn** — `type: river` · `catalogId: danang-han-river` · `status: render`
  `displaySubtitle: Riverside walks and evening light in central Đà Nẵng.`
  `reason: Named naturally in the intro and river-pairing section.`

**Related place candidates**

* None. Route value is already covered by the Han River mention; no extra card needed unless Codex wants a nearby-evening cluster.

**Verification flags**

* `type: light` · `reason: Current venue hours, menu, terrace availability, and operating status can change.` · `blocking: false`
* `type: audio_qa` · `reason: Visible phrase cards use ready-audio rows; Codex should verify imported IDs before render.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Han River card opens the intended Da Nang catalog target.` · `blocking: false`

**Source notes**

* Venue and local map sources in ledger.
* Legacy copy supports riverside terrace, warm lights, Han River blur, drinks, table rhythm, and evening meal energy.
* No visible claim made about current hours, menu items, reservations, payment rules, or price.

**Score**
27/30 — Stronger first-screen voice after revision, with concrete river-table behavior. Capped for venue-specific freshness and limited evidence beyond the ledger source notes.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready-audio reusable phrases.
* Mentioned Here test: pass; Han River evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* First-screen revision note: revised from a broader “riverside meal” frame to a sharper evening table moment.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Bảo tàng Mỹ thuật Đà Nẵng / Da Nang Fine Arts Museum — Da Nang — museum

### Reader View — app-visible copy only

**One Floor Before Every Label**

Da Nang Fine Arts Museum is a compact downtown art stop, which is exactly why it is easier with a narrow plan. Pick modern Vietnamese works or folk craft first, then give yourself three pieces to actually notice.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Có hướng dẫn tiếng Anh không?”** — Is there an English guide?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?

### Sections

**Modern Works, Folk Objects After**

The useful split is modern art versus folk craft and regional objects: lacquer, oil, silk, sculpture, masks, textiles, wood, and ceramics. The first lap is better when it is not about reading everything.

**Quiet Downtown Texture**

The Lê Duẩn setting gives this stop a calmer city register than the riverfront. It fits when heat or rain makes another outdoor plan feel thin.

**Compact, Then Back Outside**

Keep the visit short if art is not the day’s main thread. Hàn Market, coffee, or the river can follow without making the museum feel rushed.

### Implementation notes

**Closest canonical anchor:** Museum of Cham Sculpture — museum-fatigue prevention.
**Anchor behavior copied:** Give the traveler a selection method before asking them to read labels.
**How this page differs:** This page is about choosing a floor theme—modern art or folk craft—rather than choosing Cham galleries or historical forms.
**Owned traveler moment:** Standing inside a compact museum and choosing one floor lens before the visit gets label-heavy.

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-fine-arts-museum`
* `displayName: Bảo tàng Mỹ thuật Đà Nẵng`
* `englishName: Da Nang Fine Arts Museum`
* `city: Đà Nẵng`
* `category: Museum`
* `pronunciation: bao tang my thuat da nang`

**Useful phrase card mapping**

* “Vé bao nhiêu?” — `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* “Có hướng dẫn tiếng Anh không?” — `intent: ask_english_guide` · `phraseId: v900-sigh-acti-is-there-an-english-guide` · `audioId: v900-sigh-acti-is-there-an-english-guide` · `status: mapped`
* “Tôi chụp hình ở đây được không?” — `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`

**Mentioned Here candidates**

* **Hàn Market / Chợ Hàn** — `type: market` · `catalogId: danang-han-market` · `status: render`
  `displaySubtitle: Central market stop for gifts, food, and first bearings.`
  `reason: Named naturally as a nearby follow-on stop.`
* **Han River / Sông Hàn** — `type: river` · `catalogId: danang-han-river` · `status: render`
  `displaySubtitle: Central river walk that pairs easily with downtown stops.`
  `reason: Named naturally as a nearby follow-on route.`

**Related place candidates**

* **Museum of Cham Sculpture / Bảo tàng Điêu khắc Chăm** — `relationship: museum_contrast` · `catalogId: danang-cham-museum` · `status: render`
  `displaySubtitle: A stronger sculpture-and-history museum when you want a deeper stop.`
  `reason: Useful comparison for travelers choosing between compact art and a fuller museum visit.`

**Verification flags**

* `type: light` · `reason: Current hours, ticket notice, temporary exhibits, photo policy, and English interpretation should be checked before import.` · `blocking: false`
* `type: audio_qa` · `reason: Visible phrase cards use ready-audio rows; Codex should verify imported IDs before render.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Hàn Market, Han River, and Museum of Cham Sculpture cards open correct Da Nang targets.` · `blocking: false`

**Source notes**

* Da Nang Fantasticity source note in ledger.
* Legacy copy supports Lê Duẩn setting, compact visit, modern art, folk craft, masks, textiles, wood, ceramics, lacquer, oil, silk, and sculpture.
* No visible claim made about current ticket price, hours, exhibit status, or photo rules.

**Score**
28/30 — Clear museum behavior and compact route logic. Capped for current museum policies and render proof not yet run.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready-audio reusable phrases.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Cầu Vàng / Golden Bridge — Da Nang — landmark

### Reader View — app-visible copy only

**Bridge First, Park Second**

Golden Bridge is the famous Ba Na Hills photo moment: a gold walkway held by giant stone hands high above Da Nang. It is not a city bridge; it is one stop inside a mountain resort, so give the bridge its best weather and crowd window before the day spreads out.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Điểm gặp ở đâu?”** — Where is the meeting point?

### Sections

**The Hands Are The Photograph**

The walkway is short; the image is the reason people remember it. Walk slowly once, take the angle you came for, then decide how much of Ba Na Hills you still want.

**Clouds Can Change The Trip**

Clear weather gives the open mountain view. Fog can make the bridge feel more like a strange garden set, which can still be memorable if you expected the tradeoff.

**Inside A Larger Outing**

The cable car, gardens, French Village-style streets, and other park pieces sit around the bridge. Treat Cầu Vàng as the priority inside a bigger day, not the whole plan.

### Implementation notes

**Closest canonical anchor:** Ba Na Hills — expectation-setting without deflation.
**Anchor behavior copied:** Name the high-commitment resort context while preserving the still-worth-it photo and mountain-air reason.
**How this page differs:** Golden Bridge is a sub-stop inside Ba Na Hills, so the page protects the bridge priority rather than explaining the full resort.
**Owned traveler moment:** Getting off the cable car and deciding to see the bridge before the park day spreads out.

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-golden-bridge`
* `displayName: Cầu Vàng`
* `englishName: Golden Bridge`
* `city: Đà Nẵng`
* `category: Landmark`
* `pronunciation: cow vang`

**Useful phrase card mapping**

* “Vé bao nhiêu?” — `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* “Tôi chụp hình ở đây được không?” — `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* “Điểm gặp ở đâu?” — `intent: ask_meeting_point` · `phraseId: sight-5` · `audioId: sight-5` · `status: mapped`

**Mentioned Here candidates**

* **Ba Na Hills / Bà Nà Hills** — `type: landmark` · `catalogId: danang-ba-na-hills` · `status: render`
  `displaySubtitle: The mountain resort that contains Golden Bridge.`
  `reason: Named naturally in the intro and sections as the larger outing.`
* **Ba Na cable car / Cáp treo Bà Nà** — `type: experience` · `catalogId: danang-ba-na-cable-car` · `status: render`
  `displaySubtitle: The cable-car arrival that makes the bridge feel high above the city.`
  `reason: Named naturally in the larger-outing section.`
* **French Village** — `type: experience/place` · `catalogId: null` · `status: check_catalog`
  `displaySubtitle: Resort-area streets often paired with the bridge visit.`
  `reason: Named naturally as a Ba Na Hills park area; catalog target not confirmed in the workbook search.`

**Related place candidates**

* None. Ba Na Hills and the cable car already cover the needed route context.

**Verification flags**

* `type: same_week` · `reason: Ticketing, cable-car operation, access, weather, crowd conditions, and park routing can materially affect the visit.` · `blocking: false`
* `type: audio_qa` · `reason: Visible phrase cards use ready-audio rows; Codex should verify imported IDs before render.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Ba Na Hills and Ba Na cable car cards render correctly; check whether French Village has an existing target.` · `blocking: false`

**Source notes**

* City library, Vietnam Tourism Da Nang, and Da Nang Fantasticity source labels in ledger.
* Legacy copy supports mountaintop pedestrian bridge, giant stone hands, Ba Na Hills context, mountain air, clouds, and photo-moment framing.
* Place-name pronunciation row for Cầu Vàng has ready audio; keep as name support, not a visible phrase card.

**Score**
28/30 — Strong sub-stop expectation-setting and clear first priority. Capped for same-week weather/operations dependency and French Village catalog check.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready-audio reusable phrases.
* Mentioned Here test: pass with one catalog check.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Quận Hải Châu / Hai Chau District — Da Nang — neighborhood

### Reader View — app-visible copy only

**A Central Base With Real Streets**

Hải Châu is the side of Da Nang where hotel edges, shopfronts, cafés, offices, and river walks start to connect. It is not something to finish in one sweep; it is the central grid that helps the day make sense.

### Useful phrase cards

* **“Chỉ trên bản đồ giúp tôi được không?”** — Can you show me on the map?
* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Gọi taxi giúp tôi được không?”** — Can you call a taxi for me?

### Sections

**One Street, Then The River**

Pick one café, market edge, or riverside point, then walk the nearby blocks. The district is easier in pieces than as a vague central area.

**Hotels, Shops, Everyday Edges**

Expect practical city texture: small shops, trees where you find them, traffic, offices, and the Hàn River close enough to pull the walk east or west.

**Better As A Base Than A Quest**

Stay or pass through when you want dinner, errands, coffee, or an evening walk without crossing the city. The reward is orientation, not spectacle.

### Implementation notes

**Closest canonical anchor:** Quận 3 — broad neighborhood by anchor, then nearby walking.
**Anchor behavior copied:** Do not ask the traveler to “do” the whole district; give one first point and a small walking frame.
**How this page differs:** Hải Châu is a central Da Nang base district, not a Saigon neighborhood with multiple landmark anchors.
**Owned traveler moment:** Leaving a hotel, café, or shopfront and using the district name to understand the central city grid.

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-hai-chau-district`
* `displayName: Quận Hải Châu`
* `englishName: Hai Chau District`
* `city: Đà Nẵng`
* `category: Neighborhood`
* `pronunciation: quan hai chau`

**Useful phrase card mapping**

* “Chỉ trên bản đồ giúp tôi được không?” — `intent: show_on_map` · `phraseId: repair-5` · `audioId: repair-5` · `status: mapped`
* “Tôi có thể đi bộ tới đó được không?” — `intent: ask_walkable` · `phraseId: v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped`
* “Gọi taxi giúp tôi được không?” — `intent: call_taxi` · `phraseId: hotel-9` · `audioId: hotel-9` · `status: mapped`

**Mentioned Here candidates**

* **Han River / Sông Hàn** — `type: river` · `catalogId: danang-han-river` · `status: render`
  `displaySubtitle: The river edge that helps orient central Đà Nẵng.`
  `reason: Named naturally in the sections as the central walking reference.`

**Related place candidates**

* **Hàn Market / Chợ Hàn** — `relationship: central_route_pairing` · `catalogId: danang-han-market` · `status: render`
  `displaySubtitle: A central market stop that can give Hải Châu clearer bearings.`
  `reason: Useful nearby anchor for district orientation.`
* **Dragon Bridge / Cầu Rồng** — `relationship: evening_route_pairing` · `catalogId: danang-dragon-bridge` · `status: render`
  `displaySubtitle: A river landmark that helps connect central walks after dark.`
  `reason: Useful comparison/route card for travelers using Hải Châu as a base.`

**Verification flags**

* `type: light` · `reason: Administrative naming, business turnover, hotel/café edges, and walking comfort can change or vary by block.` · `blocking: false`
* `type: audio_qa` · `reason: Visible phrase cards use ready-audio rows; Codex should verify imported IDs before render.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Han River, Hàn Market, and Dragon Bridge cards open correct Da Nang targets.` · `blocking: false`

**Source notes**

* Da Nang Fantasticity and local map source labels in ledger.
* Legacy copy supports central Da Nang street grid near river, shops, trees, cafés, lanes, hotel edges, evening walks, and neighborhood identity.
* Evidence is area-level, so visible copy stays route-oriented and avoids naming current businesses.

**Score**
27/30 — Clearer after revision and useful for central orientation. Capped for broad-neighborhood evidence and lack of rendered proof.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready-audio reusable phrases.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* First-screen revision note: revised away from a generic “district identity” opening into a central-base walking cue.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Hải sản ở Đà Nẵng / Seafood — Da Nang — dish

### Reader View — app-visible copy only

**Order By Weight, Then By Mood**

Seafood in Da Nang is less about one famous dish than the table moment: ice trays, grilled smoke, lime-salt dips, and a coastal room deciding what dinner becomes. Settle the price and portion before the table fills.

### Useful phrase cards

* **“Bao nhiêu một ký?”** — How much per kilo?
* **“Cho tôi một phần”** — One portion, please.
* **“Ít cay thôi”** — Less spicy, please.

### Sections

**Fresh Tray, Clear Price**

Pointing can work well, but weight pricing can surprise visitors. Ask before agreeing, especially for crab, shrimp, fish, clams, snails, or anything pulled from ice.

**One Plate Before The Feast**

Start with one clear plate: nghêu hấp sả, mực nướng sa tế, tôm nướng muối ớt, or lẩu hải sản if the table wants a shared pot. Add more only after you see portion size.

**Sauce, Herbs, Shells**

The flavor often comes from dipping salts, lime, chili, herbs, garlic, lemongrass, and sweet shellfish juices. It is hands-on food; clean shells and a crowded plate are part of the rhythm.

**Beach Night, Not A Test**

Seafood is still worth planning when the day has been beach, river, and heat. Keep the first order clear, ask about spice, and do not let a big display case make the decision for you.

### Implementation notes

**Closest canonical anchor:** Chợ Cồn — food-first, start small, follow the table rhythm.
**Anchor behavior copied:** Start with a small confident order and use phrases to reduce price/portion uncertainty.
**How this page differs:** This is a dish/category page, not a specific market or restaurant.
**Owned traveler moment:** Standing in front of seafood on ice and confirming weight, portion, and spice before ordering.

**Schema fields**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-hai-san`
* `displayName: Hải sản ở Đà Nẵng`
* `englishName: Seafood`
* `city: Đà Nẵng`
* `category: Dish`
* `pronunciation: hai san`

**Useful phrase card mapping**

* “Bao nhiêu một ký?” — `intent: ask_price_per_kilo` · `phraseId: price-2` · `audioId: price-2` · `status: mapped`
* “Cho tôi một phần” — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* “Ít cay thôi” — `intent: ask_less_spicy` · `phraseId: food-not-spicy-clearer` · `audioId: audio-authored-it-cay-thoi-05b8e258a2` · `status: mapped`

**Mentioned Here candidates**

* **Nghêu hấp sả** — `type: food` · `catalogId: food-ngheu-hap-sa` · `status: render`
  `displaySubtitle: Clams steamed with lemongrass, ginger, herbs, and light broth.`
  `reason: Named naturally as a clear first seafood plate.`
* **Mực nướng sa tế** — `type: food` · `catalogId: food-muc-nuong-sa-te` · `status: render`
  `displaySubtitle: Grilled squid with satay chili, smoke, and chewy edges.`
  `reason: Named naturally as a seafood-table option.`
* **Tôm nướng muối ớt** — `type: food` · `catalogId: food-tom-nuong-muoi-ot` · `status: render`
  `displaySubtitle: Grilled shrimp with chili salt, lime, herbs, and dipping salt.`
  `reason: Named naturally as a simple grilled seafood plate.`
* **Lẩu hải sản** — `type: food` · `catalogId: food-lau-hai-san` · `status: render`
  `displaySubtitle: Seafood hot pot with shrimp, squid, fish, greens, and noodles.`
  `reason: Named naturally as a shared-table seafood option.`

**Related place candidates**

* **Bé Mặn Seafood / Hải sản Bé Mặn** — `relationship: seafood_restaurant_candidate` · `catalogId: danang-be-man` · `status: check_catalog`
  `displaySubtitle: Beach-side seafood restaurant candidate; verify current status before render.`
  `reason: Existing Da Nang catalog restaurant, but venue status and current experience should be checked.`
* **Nam Đảnh Seafood / Hải sản Năm Đảnh** — `relationship: seafood_restaurant_candidate` · `catalogId: danang-nam-danh-seafood` · `status: check_catalog`
  `displaySubtitle: Local seafood restaurant candidate; verify current status before render.`
  `reason: Existing Da Nang catalog restaurant, but current hours/menu/access should be checked.`
* **My Khe Beach / Biển Mỹ Khê** — `relationship: beach_route_context` · `catalogId: danang-my-khe-beach` · `status: render`
  `displaySubtitle: Beach-side context for a seafood night.`
  `reason: Useful route/context card for seafood near Da Nang’s beaches.`

**Verification flags**

* `type: light` · `reason: Seafood pricing, weight rules, restaurant status, freshness, and menu availability vary by venue and date.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Menu Catalog IDs render as food cards and restaurant candidates should not render until current status is checked.` · `blocking: false`
* `type: audio_qa` · `reason: Visible phrase cards use ready-audio rows; Codex should verify imported IDs before render.` · `blocking: false`

**Source notes**

* Vietnam Tourism Da Nang source label mentions seafood near beaches; stable local notes in ledger.
* Menu Catalog supports the named seafood items: nghêu hấp sả, mực nướng sa tế, tôm nướng muối ớt, and lẩu hải sản.
* Visible copy avoids naming a specific seafood venue as current unless related-place candidates pass catalog/freshness review.

**Score**
28/30 — Strong ordering moment and good menu-catalog integration. Capped for venue-level price/freshness variability and related restaurant freshness checks.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible cards use ready-audio reusable phrases.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

```markdown
## Codex handoff block

- `batch_id: batch_017`
- `page_ids: city-danang-place-fatfish, city-danang-place-fine-arts-museum, city-danang-place-golden-bridge, city-danang-place-hai-chau-district, city-danang-place-hai-san`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none_visible_phrase_cards_all_mapped_to_ready_audio_rows; Codex should verify phraseId/audioId during import`
- `place_name_phrases: Golden Bridge/Cầu Vàng has ready audio; Fatfish, Da Nang Fine Arts Museum, Hai Chau District, and Seafood pronunciation rows are planned, so render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: Fatfish and Hai Chau use restrained copy because evidence is thinner; Golden Bridge includes weather/crowd expectation without promising conditions; Seafood avoids venue-specific current claims`
- `source_freshness_risks: Fatfish current hours/menu/terrace/operation; Fine Arts Museum hours/tickets/photo policy/English interpretation/temporary exhibits; Golden Bridge Ba Na ticketing/cable car/access/weather; Hai Chau administrative naming and business churn; Seafood restaurant status, pricing, weight rules, and menu availability`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```
