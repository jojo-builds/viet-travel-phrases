SpeakLocal v2.2 BATCH_005 - Hanoi A - 2026-05-26

Reviewer source basis: exact Batch 005 rows, chat-as-canonical handoff, and ready-audio constraints came from the attached Batch 005 prompt . The v2.2 output model, phrase-card rules, Mentioned Here rules, and no-duplicate requirement came from the Source Bundle . Tone, status flow, and Jojo-before-Codex approval direction came from the Project Instructions .

---

## 1. Quận Ba Đình / Ba Dinh District — Hanoi — neighborhood

### Reader View

**Broad Streets, Then Smaller Edges**

Ba Đình is where Hanoi’s formal side and everyday rhythm sit close together. Broad avenues, trees, and official buildings give the area weight; nearby cafés, hotel edges, and evening side streets make it feel lived-in.

**Useful phrase cards**

* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Cho tôi tới đây.”** — Take me here.

**The Formal Core Comes First**

Ba Đình makes more sense when you picture the public space first: long roads, shade, official buildings, and Ba Đình Square. After that, the smaller streets read more clearly.

**Let The Walk Shrink**

Move from the big roads toward cafés, shopfronts, and hotel-side streets. The shift from ceremony to daily life is the best part of the district.

**Good After One Major Stop**

Pair Ba Đình with one nearby landmark or garden, then leave space to walk. Too many formal stops in a row can make the area feel heavier than it needs to.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-ba-dinh-district`
* `displayName: Quận Ba Đình`
* `englishName: Ba Dinh District`
* `city: Hanoi`
* `category: neighborhood`
* `pronunciation: kwun ba dinh`
* `target_hero_image: HeroCityHanoiPlaceBaDinhDistrict`

**Closest canonical anchor:** Chợ Lớn — broad district through a small number of usable anchors.
**Anchor behavior copied:** Make a large area readable through one formal core, one walking edge, and one route decision.
**How this page differs:** Ba Đình is quieter and more official-feeling than Chợ Lớn; the copy avoids market density and focuses on the shift from public space to lived-in side streets.
**Owned traveler moment:** Leaving a formal landmark area and deciding whether to keep walking into the neighborhood edges.

**Phrase/audio status**

* “Tôi có thể đi bộ tới đó được không?” — `intent: ask_walkable` · `phraseId: v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped`
* “Đi bộ mất bao lâu?” — `intent: ask_walking_time` · `phraseId: directions-3` · `audioId: directions-3` · `status: mapped`
* “Cho tôi tới đây.” — `intent: show_driver_destination` · `phraseId: taxi-1` · `audioId: taxi-1` · `status: mapped`

**Mentioned Here candidates**

* **Ba Dinh Square / Quảng trường Ba Đình** — `type: landmark` · `catalogId: hanoi-ba-dinh-square` · `status: render`

  * `displaySubtitle: Broad public space in Ba Đình’s formal core.`
  * `reason: Named naturally in the formal-core section and present in City Places Catalog.`

**Related place candidates**

* **Hanoi Botanical Garden / Vườn Bách Thảo Hà Nội** — `relationship: nearby_green_break` · `catalogId: hanoi-botanical-garden` · `status: render`

  * `displaySubtitle: A shaded park pause near Ba Đình’s formal streets.`
  * `reason: Route pairing helps soften a Ba Đình landmark-heavy walk.`

**Source notes**

* Batch row source note: Hanoi tourism portal.
* Legacy row supports broad Ba Đình avenues, trees, official buildings, hotel edges, cafés, side streets, and evening walks.
* City Places Catalog contains `hanoi-ba-dinh-district`, `hanoi-ba-dinh-square`, and `hanoi-botanical-garden`.

**Freshness notes**

* Keep hours, closures, ticketing, and official-area access out of visible copy until checked.
* Pre-import QA should confirm route/card relationship for Ba Dinh Square and Hanoi Botanical Garden.

**Verification flags**

* `type: light` · `reason: Official-area access, nearby landmark access, and route conditions can change.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Ba Dinh Square and Hanoi Botanical Garden card targets open correctly.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm pronunciation and phrase fit in Hanoi context.` · `blocking: false`
* `type: audio_qa` · `reason: Runtime should confirm mapped ready-audio IDs render as playable cards.` · `blocking: false`

**Score**

27/30 — Stronger broad-neighborhood draft with concrete walking behavior; capped for broad evidence and pending route/card/freshness checks.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible phrase cards use reusable ready-audio IDs.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Bánh cuốn ở Hà Nội / Steamed rice rolls — Hanoi — dish

### Reader View

**Start With Steam And Sauce**

Bánh cuốn is a quiet Hanoi breakfast move: thin rice sheets lifted from the steamer, herbs, fried shallots, and fish-sauce dip doing most of the work. It is light, quick, and clearest while the plate is still warm.

**Useful phrase cards**

* **“Cho tôi một phần.”** — One portion, please.
* **“Cái này bao nhiêu?”** — How much is this?
* **“Tính tiền giúp tôi.”** — Please let me pay.

**Watch The Plate First**

The order is easier when you look at what is already moving from steamer to table. Notice the sauce, herbs, and side pieces before adding anything extra.

**One Portion Teaches The Texture**

Start small. The point is the soft rice sheet, the warm filling, and the sauce soaking in without drowning the plate.

**A Softer Hanoi Food Memory**

Bánh cuốn is less loud than a noodle bowl and less smoky than grilled meat. That is why it stays with you: steam, sauce, herbs, and a table that turns over fast.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-banh-cuon`
* `displayName: Bánh cuốn ở Hà Nội`
* `englishName: Steamed rice rolls`
* `city: Hanoi`
* `category: dish`
* `pronunciation: bahn kwun`
* `target_hero_image: HeroCityHanoiPlaceBanhCuon`

**Closest canonical anchor:** Cà phê Giảng plus Hàn Market.
**Anchor behavior copied:** Make a food ritual feel specific through one first order, texture, and small service rhythm; use catalog-aware food mentions without a menu dump.
**How this page differs:** This is a dish page, not a venue page; the copy stays on the plate, not a shop address or current opening pattern.
**Owned traveler moment:** Sitting down for a first small breakfast plate and deciding how to order without overthinking it.

**Phrase/audio status**

* “Cho tôi một phần.” — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* “Cái này bao nhiêu?” — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* “Tính tiền giúp tôi.” — `intent: ready_to_pay` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

**Mentioned Here candidates**

* **Bánh cuốn** — `type: food` · `catalogId: food-banh-cuon` · `status: render`

  * `displaySubtitle: Steamed rice rolls with herbs and fish-sauce dip.`
  * `reason: Main dish listing; Menu Catalog has `food-banh-cuon` with reviewed item detail.`

**Related place candidates**

* None.

  * `reason: No route or comparison card is needed from the visible copy.`

**Source notes**

* Batch row source note: MICHELIN Hanoi guide.
* Menu Catalog row `food-banh-cuon` supports the dish detail: steamed rice rolls, pork-and-mushroom filling, fried shallots, herbs, and fish-sauce dip.
* Menu Catalog order line for “Cho tôi một phần bánh cuốn” is text-only by policy, so the visible phrase cards use reusable ready-audio phrases instead.

**Freshness notes**

* Avoid current venue names, hours, prices, or claims about specific shops until checked.
* If Codex wants a dish-specific order line, hide it unless audio is mapped.

**Verification flags**

* `type: light` · `reason: Any named shop, current serving style, menu availability, or price would need a fresh check.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm `food-banh-cuon` renders as a Menu Catalog item card, not as an unmapped phrase.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm phrase fit and pronunciation.` · `blocking: false`
* `type: audio_qa` · `reason: Runtime should confirm mapped ready-audio IDs render as playable cards.` · `blocking: false`

**Score**

28/30 — Strong dish-specific draft with mapped reusable phrases and a natural menu-catalog link; capped for venue/source freshness and native phrase QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; no dish-specific text-only order line rendered as audio.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Hồ Bảy Mẫu / Bay Mau Lake — Hanoi — nature

### Reader View

**A Lake For Slowing The Walk**

Bay Mau Lake gives Hanoi a calmer shape: water, trees, park paths, and a few minutes away from traffic noise. Keep the plan light; this is a walk-around-water pause, not a full-day plan.

**Useful phrase cards**

* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Nhà vệ sinh gần nhất ở đâu?”** — Where is the nearest restroom?

**Keep The Loop Gentle**

One easy loop, or even part of one, can be enough. Shade and water are the point; rushing turns the stop back into traffic management.

**Boats Are A Bonus**

If pedal boats are operating, treat them as a small extra. The sturdier move is still the path: trees, bridge views, and the lake opening up between streets.

**Good Between Busier Stops**

Bay Mau works best when the day needs a softer middle. It gives you water and space without asking much from the schedule.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-bay-mau-lake`
* `displayName: Hồ Bảy Mẫu`
* `englishName: Bay Mau Lake`
* `city: Hanoi`
* `category: nature`
* `pronunciation: hoh bay mau`
* `target_hero_image: HeroCityHanoiPlaceBayMauLake`

**Closest canonical anchor:** Lập An Lagoon plus Vọng Cảnh Hill.
**Anchor behavior copied:** Keep thin-evidence nature copy modest; make the place a condition-light pause with route restraint.
**How this page differs:** Bay Mau is urban and low-commitment, so the copy avoids weather/tide drama and stays with path, shade, water, and time-boxing.
**Owned traveler moment:** Arriving at the water after traffic and choosing a short loop instead of trying to make the stop bigger.

**Phrase/audio status**

* “Tôi có thể đi bộ tới đó được không?” — `intent: ask_walkable` · `phraseId: v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped`
* “Đi bộ mất bao lâu?” — `intent: ask_walking_time` · `phraseId: directions-3` · `audioId: directions-3` · `status: mapped`
* “Nhà vệ sinh gần nhất ở đâu?” — `intent: ask_nearest_restroom` · `phraseId: v500-dire-navi-where-is-the-nearest-restroom` · `audioId: v500-dire-navi-where-is-the-nearest-restroom` · `status: mapped`

**Mentioned Here candidates**

* None.

  * `reason: Visible copy does not naturally name a separate catalog item beyond the page itself.`

**Related place candidates**

* **Thong Nhat Park / Công viên Thống Nhất** — `relationship: park_context_check` · `catalogId: hanoi-thong-nhat-park` · `status: check_catalog`

  * `displaySubtitle: Park context around Bay Mau Lake.`
  * `reason: City catalog contains Thong Nhat Park; relation should be confirmed against source evidence before rendering.`

**Source notes**

* Batch row source note: place-name only.
* Legacy row supports calm lake, Hanoi park setting, pedal boats, trees, shade, bridges, walking paths, and water.
* Evidence is thin; visible copy intentionally avoids exact access, hours, fees, or operating claims.

**Freshness notes**

* Pedal boat availability, park access, path condition, and any rules should be checked before import.
* Related card for Thong Nhat Park should not render until catalog/source relationship is confirmed.

**Verification flags**

* `type: light` · `reason: Park access, pedal boats, and path condition can change.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm whether `hanoi-thong-nhat-park` should render as a related card for this lake.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm pronunciation and phrase fit.` · `blocking: false`
* `type: audio_qa` · `reason: Runtime should confirm mapped ready-audio IDs render as playable cards.` · `blocking: false`

**Score**

26/30 — Calm and usable, but capped by place-name-only evidence and a related-card relationship that needs confirmation.

**QA notes**

* Replaceability test: needs_review; the copy is restrained but still needs stronger source evidence for specificity.
* Phrase card test: pass; all visible phrase cards use reusable ready-audio IDs.
* Mentioned Here test: pass; no forced cards.
* Catalog mention scan: needs_review for Thong Nhat Park relation.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Bia hơi Hà Nội / Fresh beer — Hanoi — drink

### Reader View

**Sit Low, Keep It Simple**

Bia hơi is Hanoi at sidewalk height: light fresh beer, small stools, shared snacks, and glasses that make a walk feel less planned. The drink is simple; the street-corner pause is the memory.

**Useful phrase cards**

* **“Bạn có bia không?”** — Do you have beer?
* **“Chúng ta có thể ngồi bên ngoài được không?”** — Can we sit outside?
* **“Xin thêm một cái nữa.”** — One more, please.

**Read The Corner First**

Look for the tables that already feel settled: glasses moving, snacks arriving, people not lingering over a long menu. A quieter corner can be better than the loudest cluster.

**Snack, Sip, Move On**

A light order keeps the stop from becoming the whole night. Share what looks easy, finish the glass, and keep the next crossing or ride in mind.

**Still Good Around The Edges**

Bia hơi can feel rough around the edges, but that is part of why it works. Cold glass, low stool, evening street light: Hanoi becomes easier to read from that height.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-bia-hoi`
* `displayName: Bia hơi Hà Nội`
* `englishName: Fresh beer`
* `city: Hanoi`
* `category: drink`
* `pronunciation: bee-ah hoy`
* `target_hero_image: HeroCityHanoiPlaceBiaHoi`

**Closest canonical anchor:** Bùi Viện Walking Street plus Hàn Market.
**Anchor behavior copied:** Keep nightlife/social copy practical without fear, and define the ritual through first-look behavior rather than hype.
**How this page differs:** Bia hơi is smaller and more casual than a nightlife street; the copy stays with one sidewalk pause, not a whole evening scene.
**Owned traveler moment:** Choosing a sidewalk table after a walk and keeping the beer stop short, social, and easy to leave.

**Phrase/audio status**

* “Bạn có bia không?” — `intent: ask_beer_available` · `phraseId: v900-food-drin-do-you-have-beer` · `audioId: v900-food-drin-do-you-have-beer` · `status: mapped`
* “Chúng ta có thể ngồi bên ngoài được không?” — `intent: ask_sit_outside` · `phraseId: v900-food-drin-can-we-sit-outside` · `audioId: v900-food-drin-can-we-sit-outside` · `status: mapped`
* “Xin thêm một cái nữa.” — `intent: order_one_more` · `phraseId: v900-food-drin-one-more-please` · `audioId: v900-food-drin-one-more-please` · `status: mapped`

**Mentioned Here candidates**

* **Bia hơi** — `type: drink` · `catalogId: drink-bia-hoi` · `status: render`

  * `displaySubtitle: Light fresh draft beer poured for sidewalk drinking.`
  * `reason: Main drink listing; Menu Catalog has `drink-bia-hoi` with reviewed item detail.`

**Related place candidates**

* None.

  * `reason: Visible copy does not name a separate route or place card; keep this page focused on the drink ritual.`

**Source notes**

* Batch row source note: Vietnam Travel Hanoi.
* Menu Catalog row `drink-bia-hoi` supports fresh draft beer, light body, chilled glass, and sidewalk social-drinking context.
* Menu Catalog order line for “Cho tôi một ly bia hơi” is text-only by policy, so the visible phrase cards use reusable ready-audio phrases instead.

**Freshness notes**

* Avoid current prices, named corners, venue hours, or payment norms until checked.
* Alcohol-specific product handling may need app-level policy review; visible copy stays descriptive and moderate.

**Verification flags**

* `type: light` · `reason: Sidewalk setup, venue availability, payment norms, and snack options can change.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm `drink-bia-hoi` renders as a drink/menu card, not as an unmapped phrase.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm phrase fit for a sidewalk beer setting.` · `blocking: false`
* `type: audio_qa` · `reason: Runtime should confirm mapped ready-audio IDs render as playable cards.` · `blocking: false`

**Score**

28/30 — Strong ritual page with mapped reusable phrases and a natural drink-catalog link; capped for current sidewalk/venue norms and native QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; no drink-specific text-only order line rendered as audio.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Vườn Bách Thảo Hà Nội / Hanoi Botanical Garden — Hanoi — park

### Reader View

**Shade Before The Next Formal Stop**

Hanoi Botanical Garden gives Ba Đình a quieter edge: palms, benches, shaded paths, and open air close to the city’s official quarter. It is a short reset, not a checklist attraction.

**Useful phrase cards**

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Nhà vệ sinh gần nhất ở đâu?”** — Where is the nearest restroom?

**Let The Garden Stay Small**

A short walk can be enough. Take the shade, notice the benches and family rhythm, then move on before the calm turns into waiting around.

**Good Around A Ba Đình Route**

Pair the garden with nearby Ba Đình stops when you need air between heavier sights. The contrast is the point: official streets outside, trees and slower walking inside.

**Leave The Stop Loose**

Go for shade, a bench, and a calmer pace. The garden works best when it breaks up the day instead of carrying the whole plan.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hanoi-place-botanical-garden`
* `displayName: Vườn Bách Thảo Hà Nội`
* `englishName: Hanoi Botanical Garden`
* `city: Hanoi`
* `category: park`
* `pronunciation: vuon bach thao ha noi`
* `target_hero_image: HeroCityHanoiPlaceBotanicalGarden`

**Closest canonical anchor:** Vọng Cảnh Hill plus Ba Đình / broad-area logic from Chợ Lớn.
**Anchor behavior copied:** Keep a low-commitment green stop small, route-paired, and honest about its scale.
**How this page differs:** This is an urban garden, not a viewpoint; the value comes from shade and pacing between Ba Đình stops.
**Owned traveler moment:** Breaking up a formal Ba Đình route with shade, benches, and a slower walk.

**Phrase/audio status**

* “Lối vào ở đâu?” — `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* “Tôi có thể đi bộ tới đó được không?” — `intent: ask_walkable` · `phraseId: v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped`
* “Nhà vệ sinh gần nhất ở đâu?” — `intent: ask_nearest_restroom` · `phraseId: v500-dire-navi-where-is-the-nearest-restroom` · `audioId: v500-dire-navi-where-is-the-nearest-restroom` · `status: mapped`

**Mentioned Here candidates**

* **Ba Dinh District / Quận Ba Đình** — `type: neighborhood` · `catalogId: hanoi-ba-dinh-district` · `status: render`

  * `displaySubtitle: The formal district around the garden.`
  * `reason: Named naturally in the intro and route section; catalog row exists.`

**Related place candidates**

* **Ba Dinh Square / Quảng trường Ba Đình** — `relationship: nearby_formal_core` · `catalogId: hanoi-ba-dinh-square` · `status: render`

  * `displaySubtitle: A nearby formal public space to pair with a garden pause.`
  * `reason: Route pairing helps explain the garden’s role beside official Ba Đình streets.`
* **Ho Chi Minh Mausoleum / Lăng Bác** — `relationship: nearby_major_stop_check` · `catalogId: hanoi-ho-chi-minh-mausoleum` · `status: check_catalog`

  * `displaySubtitle: A heavier nearby sight that may pair with a garden break.`
  * `reason: Catalog row exists, but current access and route pairing need a freshness check before rendering.`

**Source notes**

* Batch row source note: Hanoi tourism portal.
* Legacy row supports shaded botanical garden paths, palms, benches, walking paths, trees, open lawns, family time, and evening light.
* City Places Catalog contains `hanoi-botanical-garden`, `hanoi-ba-dinh-district`, `hanoi-ba-dinh-square`, and `hanoi-ho-chi-minh-mausoleum`.

**Freshness notes**

* Check current entrance, access, hours, ticket/payment norms if any, and path condition before import.
* Ho Chi Minh Mausoleum related card should stay `check_catalog` until route/freshness QA confirms it should render.

**Verification flags**

* `type: light` · `reason: Garden access, hours, entrance flow, and conditions can change.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm Ba Dinh District, Ba Dinh Square, and Ho Chi Minh Mausoleum card targets and statuses.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm pronunciation and phrase fit.` · `blocking: false`
* `type: audio_qa` · `reason: Runtime should confirm mapped ready-audio IDs render as playable cards.` · `blocking: false`

**Score**

27/30 — Useful park draft with a clear Ba Đình route role and mapped phrases; capped for access/freshness and one related card needing confirmation.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible phrase cards use reusable ready-audio IDs.
* Mentioned Here test: pass.
* Catalog mention scan: pass, with one related candidate held for check.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Codex handoff block

* `batch_id: batch_005`
* `page_ids: city-hanoi-place-ba-dinh-district, city-hanoi-place-banh-cuon, city-hanoi-place-bay-mau-lake, city-hanoi-place-bia-hoi, city-hanoi-place-botanical-garden`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible reusable ready-audio cards; item-specific Menu Catalog quick-say lines for food-banh-cuon and drink-bia-hoi are text-only and should stay hidden unless audio is mapped`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; none rendered in this batch`
* `visible_copy_risks: Bay Mau Lake has sparse evidence; Ba Dinh District and Hanoi Botanical Garden need Jojo voice review for broad-area/park specificity; visible copy avoids hours, prices, closures, and current policy claims`
* `source_freshness_risks: check current park/garden access, entrances, path conditions, official-area restrictions, sidewalk beer norms, item/card mapping, and any current menu or venue specifics before import`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
