SpeakLocal v2.2 BATCH_011 - Hue A - 2026-05-26

Source basis: fixed rows and handoff requirements followed from the attached Batch 011 prompt; this is draft review material only, not import-ready or production-validated. 

## Chợ An Cựu / An Cuu Market — Hue — Market

### Reader View

**Make One Slow Lap First**

An Cựu is a working Hue market where the rhythm matters: herbs near the entrance, scooters nosing past, snack counters, small goods, and shoppers who already know their route. Arrive with a light appetite and read the aisles before you buy.

**Phrase cards**

* **“Cái này bao nhiêu?”** — How much is this?
* **“Cho tôi một phần.”** — One portion, please.
* **“Tôi chỉ xem thôi.”** — I’m just looking.

**Snacks Before Souvenirs**

Start small. Look for a counter where people are already eating, then order one portion before committing. If you see bánh bèo or bánh nậm, treat them as small bites rather than a full meal plan.

**Ask Before The Bag Opens**

Prices feel easier when you ask early, especially around snacks, dried goods, or small gifts. A soft price question keeps the exchange simple and leaves room to smile and move on.

**A Quieter Counterpoint To Đông Ba**

Đông Ba is the bigger name. An Cựu is better when you want a smaller market pause with everyday buying around you, not a grand market crawl.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-an-cuu-market`
* `displayName: Chợ An Cựu`
* `englishName: An Cuu Market`
* `city: Hue`
* `category: Market`
* `pronunciation: chuh an kyew`
* `target_hero_image: HeroCityHuePlaceAnCuuMarket`
* `current_status_after_draft: needs_jojo_voice_review`

**Closest canonical anchor:** Chợ Hàn, with Chợ Cồn as the secondary market contrast.
**Anchor behavior copied:** One first lap, one snack move, one price/browse interaction, and a clear market role before inventory.
**How this page differs:** An Cựu is written with thinner evidence and a smaller everyday-market frame, not as Hue’s headline market.
**Owned traveler moment:** Entering the market, walking one slow lap, then choosing one snack counter or small purchase.

**Useful phrase cards**

* **“Cái này bao nhiêu?”** — How much is this?
  `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* **“Cho tôi một phần.”** — One portion, please.
  `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Tôi chỉ xem thôi.”** — I’m just looking.
  `intent: browse_without_pressure` · `phraseId: shop-4` · `audioId: shop-4` · `status: mapped`

**Mentioned Here candidates**

* **Bánh bèo** — `type: food` · `catalogId: food-banh-beo` · `status: render`
  `displaySubtitle: Small steamed rice cakes for a light Hue market bite.`
  `reason: Named naturally in snack-counter guidance; exists in Menu Catalog.`
* **Bánh nậm** — `type: food` · `catalogId: food-banh-nam` · `status: render`
  `displaySubtitle: Flat steamed rice dumpling often seen with Hue-style small plates.`
  `reason: Named naturally in snack-counter guidance; exists in Menu Catalog.`
* **Chợ Đông Ba** — `type: market` · `catalogId: hue-dong-ba-market` · `status: render`
  `displaySubtitle: The bigger Hue market name, useful for comparison.`
  `reason: Direct comparison appears in the final section.`

**Related place candidates**

* **Chợ Đông Ba** — `relationship: market_contrast` · `catalogId: hue-dong-ba-market` · `status: render`
  `displaySubtitle: Bigger, more famous Hue market; compare before choosing.`
  `reason: Comparison helps travelers decide between a smaller daily-market pause and a larger market stop.`

**Verification flags**

* `type: light`
  `reason: Current hours, stall mix, snack availability, and market entrance flow can change.`
  `blocking: false`
* `type: audio_qa`
  `reason: Codex should verify mapped phrase/audio IDs against Phrase Picker Ready Audio before import.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm Bánh bèo, Bánh nậm, and Chợ Đông Ba catalog targets open correctly in the Hue context.`
  `blocking: false`

**Source notes**

* Batch row source says legacy evidence comes from existing city library and Hue tourism specialities, with v2.2 authoring required before production. 
* Hue portal material references An Cựu in relation to Hue food/snack culture; visible copy avoids vendor names, hours, exact stall locations, or price claims. ([Khám Phá Huế][1])
* Menu candidates checked against uploaded Menu Catalog: `food-banh-beo`, `food-banh-nam`.
* Place candidates checked against uploaded City Places Catalog: `hue-dong-ba-market`.

**Score**

27/30 — Clear market behavior and useful phrase fit; capped for thin place-specific evidence and changeable stall/snack conditions.

**QA notes**

* Replaceability test: pass — An Cựu is framed as a smaller Hue market pause, not generic “local market” prose.
* Phrase card test: pass — 3 reusable ready-audio phrase cards.
* Mentioned Here test: pass — natural food and market mentions evaluated.
* Catalog mention scan: pass — visible catalogable items mapped.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run until rendered proof exists.
* Production review gate: not_run until Codex import/render/screenshots exist.

---

## Nhà vườn An Hiên / An Hien Garden House — Hue — Landmark

### Reader View

**Let The Gate Slow You Down**

An Hiên starts before the house: an old gate, trees over the path, a tiled roof beyond the garden. Give it a quiet half-step before taking photos; the place reads better when the path, screen, courtyard, and rooms feel like one sequence.

**Phrase cards**

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Mấy giờ đóng cửa?”** — What time does it close?

**Read The Garden Before The House**

The trees, pond, and approach are not just scenery around the building. They prepare you for the old timber room, so the visit works better when you move slowly instead of heading straight for the main photo.

**Keep It Near The River Route**

An Hiên sits naturally with Thiên Mụ Pagoda or a Perfume River day. It makes sense when you already want Hue at a slower volume, not when you are squeezing one more stop between tombs.

**Photos, Then A Real Look**

Take the gate and garden photos, then put the phone down for a minute. The quiet part is the proportion: roof, shade, carved wood, and garden space holding together without much explanation.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-an-hien-garden-house`
* `displayName: Nhà vườn An Hiên`
* `englishName: An Hien Garden House`
* `city: Hue`
* `category: Landmark`
* `pronunciation: nyah vuon an heen`
* `target_hero_image: HeroCityHuePlaceAnHienGardenHouse`
* `current_status_after_draft: needs_jojo_voice_review`

**Closest canonical anchor:** Làng hương Thủy Xuân, with Vọng Cảnh Hill as a route-pairing secondary.
**Anchor behavior copied:** Do not reduce a visual place to photos; give the traveler a first physical move and a slower way to look.
**How this page differs:** No craft/workshop action; the page owns an arrival sequence through garden-house architecture.
**Owned traveler moment:** Passing through the gate, slowing down along the shaded path, then reading the house and garden together.

**Useful phrase cards**

* **“Lối vào ở đâu?”** — Where is the entrance?
  `intent: find_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
  `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* **“Mấy giờ đóng cửa?”** — What time does it close?
  `intent: ask_closing_time` · `phraseId: sight-4` · `audioId: sight-4` · `status: mapped`

**Mentioned Here candidates**

* **Chùa Thiên Mụ** — `type: landmark` · `catalogId: hue-thien-mu-pagoda` · `status: render`
  `displaySubtitle: Nearby river-route landmark that pairs naturally with a garden-house stop.`
  `reason: Named in the route-pairing section.`
* **Sông Hương / Perfume River** — `type: river` · `catalogId: hue-perfume-river` · `status: render`
  `displaySubtitle: Hue’s river spine; useful context for slower west-side planning.`
  `reason: Named in the route-pairing section.`

**Related place candidates**

* **Chùa Thiên Mụ** — `relationship: nearby_route_pairing` · `catalogId: hue-thien-mu-pagoda` · `status: render`
  `displaySubtitle: Pair with An Hiên when planning a slower river-side route.`
  `reason: Route planning helps this small landmark feel intentional.`
* **Sông Hương / Perfume River** — `relationship: river_context` · `catalogId: hue-perfume-river` · `status: render`
  `displaySubtitle: Use the river route to frame An Hiên’s slower pace.`
  `reason: Directly supports planning around the garden-house visit.`

**Verification flags**

* `type: light`
  `reason: Current hours, ticketing, photo expectations, and access flow should be checked before publication.`
  `blocking: false`
* `type: audio_qa`
  `reason: Codex should verify mapped phrase/audio IDs against Phrase Picker Ready Audio before import.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm Thiên Mụ and Perfume River cards open to Hue catalog targets.`
  `blocking: false`

**Source notes**

* Batch row source references Hue tourism portal famous places and legacy garden-house scene details. 
* Hue tourism sources describe An Hiên as an old Hue garden house with gate/path/garden/nhà rường sequence; visible copy avoids address, current ownership, ticket price, and opening-hour claims. ([Visit Hue][2])
* Related place candidates checked against uploaded City Places Catalog: `hue-thien-mu-pagoda`, `hue-perfume-river`.

**Score**

28/30 — Strong physical arrival cue and stable architectural frame; capped for current access, hours, and photo-policy verification.

**QA notes**

* Replaceability test: pass — gate/path/garden-house sequence is specific to An Hiên.
* Phrase card test: pass — 3 reusable ready-audio phrase cards.
* Mentioned Here test: pass — route mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run until rendered proof exists.
* Production review gate: not_run until Codex import/render/screenshots exist.

---

## Ancient Hue Gallery Cuisine / Ancient Hue Gallery Cuisine — Hue — Restaurant

### Reader View

**Let The Meal Be The Quiet Plan**

Ancient Hue Gallery Cuisine is for the night when dinner should slow the day down. Expect a polished room: dark timber, court-style plating, and Hue flavors presented with more ceremony than a street snack crawl.

**Phrase cards**

* **“Cho tôi bàn cho hai người nhé.”** — A table for two, please.
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?

**Order Around One Hue Thread**

The menu may be wider than the room first suggests. Start with one Hue dish or house recommendation, then build around it instead of collecting every royal-sounding plate.

**Ask Before The Table Fills**

If pork, shrimp, fish sauce, or chili matters, ask early. A formal room can make people nod along too quickly; one clear question keeps the meal comfortable.

**Make Dinner The Memory**

This is a better fit after a slower sightseeing day than between two rushed stops. The reason to keep it on the list is the setting: a meal that lets Hue feel composed for an hour.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-ancient-hue-gallery-cuisine`
* `displayName: Ancient Hue Gallery Cuisine`
* `englishName: Ancient Hue Gallery Cuisine`
* `city: Hue`
* `category: Restaurant`
* `pronunciation: AN-shent hway GAL-uh-ree kwee-ZEEN`
* `target_hero_image: HeroCityHuePlaceAncientHueGalleryCuisine`
* `current_status_after_draft: needs_jojo_voice_review`

**Closest canonical anchor:** Morning Glory Original, with Bale Well for early ordering confidence.
**Anchor behavior copied:** Make a broad/polished restaurant usable by giving one ordering strategy and one ingredient question before the table fills.
**How this page differs:** This page leans on setting and court-style presentation, not a first-meal restaurant near old streets.
**Owned traveler moment:** Arriving for a polished dinner and choosing one Hue-oriented thread before the meal becomes too broad.

**Useful phrase cards**

* **“Cho tôi bàn cho hai người nhé.”** — A table for two, please.
  `intent: request_table` · `phraseId: food-need-table` · `audioId: food-need-table` · `status: mapped`
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?
  `intent: ask_recommendation` · `phraseId: social-9` · `audioId: social-9` · `status: mapped`
* **“Cái này có chứa tôm không?”** — Does this contain shrimp?
  `intent: ask_shrimp_allergy` · `phraseId: v500-food-drin-does-this-contain-shrimp` · `audioId: v500-food-drin-does-this-contain-shrimp` · `status: mapped`

**Mentioned Here candidates**

* **Fish sauce / nước mắm** — `type: food` · `catalogId: null` · `status: check_catalog`
  `displaySubtitle: Common Vietnamese sauce; check catalog before rendering.`
  `reason: Mentioned as an ingredient/allergy concern, not as a dish recommendation.`
* **Shrimp** — `type: food` · `catalogId: null` · `status: do_not_render`
  `displaySubtitle: Ingredient concern only.`
  `reason: Mentioned for allergy clarity; not a natural travel-learning card here.`

**Related place candidates**

* **Ancient Hue Restaurant** — `relationship: same_name_comparison` · `catalogId: hue-ancient-hue-restaurant` · `status: render`
  `displaySubtitle: A garden-house restaurant frame under the Ancient Hue cluster.`
  `reason: Similar naming can confuse travelers; comparison helps route and booking decisions.`
* **Ancient Space Restaurant** — `relationship: old_hue_restaurant_contrast` · `catalogId: hue-ancient-space-restaurant` · `status: render`
  `displaySubtitle: Another old-Hue dining room, with a stronger rường-house compound feel.`
  `reason: Comparison helps travelers pick the kind of ceremonial dinner they want.`

**Verification flags**

* `type: light`
  `reason: Current menu, opening status, booking pattern, and room/venue naming should be checked before publication.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Ingredient candidates should not render unless a real catalog target exists; related restaurant cards need correct Hue targets.`
  `blocking: false`
* `type: audio_qa`
  `reason: Codex should verify mapped phrase/audio IDs against Phrase Picker Ready Audio before import.`
  `blocking: false`

**Source notes**

* Batch row source references Hue tourism portal restaurants and legacy room cues: court-style plating, dark timber, royal motifs. 
* Hue tourism/KhamphaHue materials support the court-style and Hue-specialty dining frame; visible copy avoids current set menus, prices, hours, awards, capacity, or booking rules. ([Khám Phá Huế][3])
* Related place candidates checked against uploaded City Places Catalog: `hue-ancient-hue-restaurant`, `hue-ancient-space-restaurant`.

**Score**

27/30 — Stronger restaurant behavior than the legacy copy; capped for current menu/venue-status risk and similarity with the adjacent Ancient Hue pages.

**QA notes**

* Replaceability test: pass — court-style plating and polished Hue dinner role separate it from generic restaurant copy.
* Phrase card test: pass — 3 reusable ready-audio phrase cards.
* Mentioned Here test: pass — ingredient mentions evaluated and not forced into rendered cards.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run until rendered proof exists.
* Production review gate: not_run until Codex import/render/screenshots exist.

---

## Ancient Hue Restaurant / Ancient Hue Restaurant — Hue — Restaurant

### Reader View

**Choose The Garden-House Dinner**

Ancient Hue Restaurant leans into the old-Hue room: rường-house timber, lantern light, garden paths, and a table set to make dinner feel slower than the day around it.

**Phrase cards**

* **“Cho tôi bàn cho hai người nhé.”** — A table for two, please.
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?
* **“Tính tiền giúp tôi.”** — Please let me pay.

**Let The Room Set The Pace**

Do not rush straight into ordering. Notice the timber, rooflines, and courtyard rhythm first; the room is part of why this meal can stay in your memory.

**Ask For A House Direction**

If the menu feels broad, ask what they recommend and choose one Hue-leaning path before adding shared dishes. That keeps the table from turning into a set of guesses.

**Good After The Citadel Side Of Town**

It makes sense after Hue Imperial City or a Kim Long route, when the architecture is already in your head. The meal can carry that mood without needing a formal history lesson.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-ancient-hue-restaurant`
* `displayName: Ancient Hue Restaurant`
* `englishName: Ancient Hue Restaurant`
* `city: Hue`
* `category: Restaurant`
* `pronunciation: AN-shent hway RES-tuh-rahnt`
* `target_hero_image: HeroCityHuePlaceAncientHueRestaurant`
* `current_status_after_draft: needs_jojo_voice_review`

**Closest canonical anchor:** Morning Glory Original, with An Hiên Garden House behavior borrowed for architecture-before-detail pacing.
**Anchor behavior copied:** Make the broad restaurant usable through one ordering direction, while letting the room explain why the meal matters.
**How this page differs:** Stronger garden-house and rường-house frame than Gallery Cuisine; less about plating, more about setting and pace.
**Owned traveler moment:** Arriving through the garden-house setting, sitting down, then asking for one house direction before ordering.

**Useful phrase cards**

* **“Cho tôi bàn cho hai người nhé.”** — A table for two, please.
  `intent: request_table` · `phraseId: food-need-table` · `audioId: food-need-table` · `status: mapped`
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?
  `intent: ask_recommendation` · `phraseId: social-9` · `audioId: social-9` · `status: mapped`
* **“Tính tiền giúp tôi.”** — Please let me pay.
  `intent: ask_to_pay` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

**Mentioned Here candidates**

* **Kinh thành Huế / Hue Imperial City** — `type: landmark` · `catalogId: hue-imperial-city` · `status: render`
  `displaySubtitle: The citadel-side landmark that frames an old-Hue evening.`
  `reason: Named in the route/context section.`
* **Kim Long** — `type: neighborhood` · `catalogId: hue-kim-long` · `status: render`
  `displaySubtitle: Garden-house area that helps frame this style of Hue dining.`
  `reason: Named in the route/context section.`

**Related place candidates**

* **Ancient Hue Gallery Cuisine** — `relationship: same_cluster_comparison` · `catalogId: hue-ancient-hue-gallery-cuisine` · `status: render`
  `displaySubtitle: More polished gallery-style dinner; compare with this garden-house frame.`
  `reason: Similar Ancient Hue naming can confuse travelers; comparison is useful.`
* **Nhà vườn An Hiên** — `relationship: architecture_context` · `catalogId: hue-an-hien-garden-house` · `status: render`
  `displaySubtitle: Garden-house landmark that helps explain the old-Hue setting.`
  `reason: Architecture context helps travelers understand the restaurant’s setting.`

**Verification flags**

* `type: light`
  `reason: Current hours, menu, booking pattern, venue naming, and operating status should be checked before publication.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Confirm Hue Imperial City, Kim Long, Gallery Cuisine, and An Hiên catalog targets before rendering cards.`
  `blocking: false`
* `type: audio_qa`
  `reason: Codex should verify mapped phrase/audio IDs against Phrase Picker Ready Audio before import.`
  `blocking: false`

**Source notes**

* Batch row source references Hue tourism portal restaurants and legacy cues: garden restaurant, rường-house timber, lanterns, set table. 
* External sources support the garden-house/old-house dining frame; visible copy avoids exact opening date, awards, live music, prices, and current booking claims. ([Asiatique Design][4])
* Catalog candidates checked against uploaded City Places Catalog: `hue-imperial-city`, `hue-kim-long`, `hue-ancient-hue-gallery-cuisine`, `hue-an-hien-garden-house`.

**Score**

27/30 — Clearer than the legacy restaurant copy and distinct from Gallery Cuisine; capped for current venue/menu verification and possible naming overlap.

**QA notes**

* Replaceability test: pass — garden-house/rường/lantern setting creates a distinct role.
* Phrase card test: pass — 3 reusable ready-audio phrase cards.
* Mentioned Here test: pass — route/context mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run until rendered proof exists.
* Production review gate: not_run until Codex import/render/screenshots exist.

---

## Không gian xưa / Ancient Space Restaurant — Hue — Restaurant

### Reader View

**Go For The Rường-House Mood**

Không gian xưa gives a Hue meal a house-and-garden frame: tiled roof, timber rooms, garden path, and a table that feels more settled than a quick bowl between sights.

**Phrase cards**

* **“Chúng ta có thể ngồi bên trong được không?”** — Can we sit inside?
* **“Chúng ta có thể ngồi bên ngoài được không?”** — Can we sit outside?
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?

**Choose The Seat Before The Order**

The room matters here. Ask where you can sit, then order around one or two shared dishes instead of trying to turn the table into a full Hue checklist.

**Good When The Group Needs Ease**

This is a calmer choice when everyone wants different levels of ceremony. It can still feel memorable because the building does some of the storytelling while the food stays approachable.

**Let The Local Name Help**

Không gian xưa means the old space. Keep the Vietnamese name close when asking a driver or host; the English label is easier after the room is already in front of you.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hue-place-ancient-space-restaurant`
* `displayName: Không gian xưa`
* `englishName: Ancient Space Restaurant`
* `city: Hue`
* `category: Restaurant`
* `pronunciation: khong zahn swe-uh`
* `target_hero_image: HeroCityHuePlaceAncientSpaceRestaurant`
* `current_status_after_draft: needs_jojo_voice_review`

**Closest canonical anchor:** Morning Glory Original for ordering control, with An Hiên Garden House for architecture-led pacing.
**Anchor behavior copied:** Give one first choice before ordering, then let the place’s physical setting do part of the work.
**How this page differs:** More group-friendly, rường-house-compound mood; less polished-gallery and less Ancient Hue cluster framing.
**Owned traveler moment:** Arriving at the compound, choosing inside/outside or room mood, then asking for a simple recommendation.

**Useful phrase cards**

* **“Chúng ta có thể ngồi bên trong được không?”** — Can we sit inside?
  `intent: ask_inside_seating` · `phraseId: v900-food-drin-can-we-sit-inside` · `audioId: v900-food-drin-can-we-sit-inside` · `status: mapped`
* **“Chúng ta có thể ngồi bên ngoài được không?”** — Can we sit outside?
  `intent: ask_outside_seating` · `phraseId: v900-food-drin-can-we-sit-outside` · `audioId: v900-food-drin-can-we-sit-outside` · `status: mapped`
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?
  `intent: ask_recommendation` · `phraseId: social-9` · `audioId: social-9` · `status: mapped`

**Mentioned Here candidates**

* **Không gian xưa** — `type: place_name_phrase` · `catalogId: hue-ancient-space-restaurant` · `status: do_not_render`
  `displaySubtitle: Local venue name only; do not render as a separate Mentioned Here card.`
  `reason: The local name is already the display name and should not duplicate the page card.`
* **Nhà rường / rường-house** — `type: experience` · `catalogId: null` · `status: check_catalog`
  `displaySubtitle: Hue timber-house architecture; render only if a real catalog item exists.`
  `reason: Architectural term appears naturally but may not have a catalog target.`

**Related place candidates**

* **Ancient Hue Restaurant** — `relationship: old_hue_restaurant_comparison` · `catalogId: hue-ancient-hue-restaurant` · `status: render`
  `displaySubtitle: Garden-house dinner with a stronger Ancient Hue cluster identity.`
  `reason: Helps distinguish similar old-Hue restaurant choices.`
* **Ancient Hue Gallery Cuisine** — `relationship: polished_dinner_contrast` · `catalogId: hue-ancient-hue-gallery-cuisine` · `status: render`
  `displaySubtitle: More polished, court-style dining room for a slower evening meal.`
  `reason: Comparison helps prevent the three restaurant pages from blurring together.`

**Verification flags**

* `type: light`
  `reason: Current branches, operating status, menu, seating, hours, and booking/payment details should be checked before publication.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Rường-house architectural term should render only if Codex finds a valid catalog target; related restaurant cards need correct Hue targets.`
  `blocking: false`
* `type: audio_qa`
  `reason: Codex should verify mapped phrase/audio IDs against Phrase Picker Ready Audio before import.`
  `blocking: false`

**Source notes**

* Batch row source references Hue tourism portal restaurants and legacy cues: rường-house compound, tiled roof, garden path, Hue meal setting. 
* KhamphaHue and official Không Gian Xưa sources support the antique/rường-house restaurant frame; visible copy avoids branch-specific hours, address, hotline, parking, air-conditioning, and live menu claims. ([Khám Phá Huế][5])
* Related place candidates checked against uploaded City Places Catalog: `hue-ancient-hue-restaurant`, `hue-ancient-hue-gallery-cuisine`.

**Score**

27/30 — Good differentiation through seating/room choice and local-name cue; capped for branch/menu freshness and possible architecture-catalog mapping.

**QA notes**

* Replaceability test: pass — seating choice, local name, and rường-house mood distinguish it from the other restaurant pages.
* Phrase card test: pass — 3 reusable ready-audio phrase cards.
* Mentioned Here test: pass — local name and rường-house term evaluated without forcing render.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run until rendered proof exists.
* Production review gate: not_run until Codex import/render/screenshots exist.

```markdown
## Codex handoff block

- `batch_id: batch_011`
- `page_ids: city-hue-place-an-cuu-market, city-hue-place-an-hien-garden-house, city-hue-place-ancient-hue-gallery-cuisine, city-hue-place-ancient-hue-restaurant, city-hue-place-ancient-space-restaurant`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none; all visible phrase cards were selected from ready-audio reusable Native Phrase Catalog / Phrase Picker candidates, but Codex should verify exact phraseId/audioId mappings before import`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; no one-off place-name phrase cards were rendered in this batch`
- `visible_copy_risks: An Cuu food mentions should stay soft because stall availability changes; the three restaurant pages may need Jojo voice tuning to sharpen differences further; restaurant ingredient mentions should not become forced Mentioned Here cards`
- `source_freshness_risks: current market hours, stall mix, restaurant opening status, menu availability, branch naming, booking patterns, seating, payment, photo rules, and landmark access all require pre-import/freshness checks`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```

[1]: https://khamphahue.com.vn/Van-hoa/Hue-Xu-so-Mai-Vang-Viet-Nam/Chi-tiet/tid/Phong-vi-am-thuc-mien-Trung.html/pid/17898/cid/28?utm_source=chatgpt.com "Phong vị ẩm thực miền Trung"
[2]: https://visithue.vn/Xanh-mat-nha-vuon-An-Hien.html/?pid=MTc3Nzl8Y3NkbGRs0&utm_source=chatgpt.com "Xanh mát nhà vườn An Hiên"
[3]: https://khamphahue.com.vn/en-us/Tourism/Detail/tid/Ancient-Hue-Gallery-Cuisine.html/pid/15465/cid/504?utm_source=chatgpt.com "Ancient Hue Gallery Cuisine"
[4]: https://asiatiquedesign.com/ancient-hue-restaurant/?utm_source=chatgpt.com "Ancient Hue Restaurant"
[5]: https://khamphahue.com.vn/en-us/Discover-Hue/Detail/tid/Ancient-Space-Restaurant.html/pid/16497/cid/505?utm_source=chatgpt.com "Ancient Space Restaurant"
