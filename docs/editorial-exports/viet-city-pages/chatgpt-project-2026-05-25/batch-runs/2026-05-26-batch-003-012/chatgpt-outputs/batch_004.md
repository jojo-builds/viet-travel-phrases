SpeakLocal v2.2 BATCH_004 - Da Nang B - 2026-05-26

Source basis: exact Batch 004 rows and handoff constraints are from the attached prompt; v2.2 shape, voice, phrase-card, Mentioned Here, and production-gate rules are from the Source Bundle; place/catalog checks use the Copy Ledger and Catalogs spreadsheet.    

---

## 1. Bà Nà Hills / Ba Na Hills — Da Nang — Landmark

### Reader View

**More Theme Park Than Viewpoint**

Ba Na Hills is the big mountain production west of Da Nang: cable cars, cooler air, the Golden Bridge, replica French streets, gardens, rides, and weather that can rewrite the day.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Điểm gặp ở đâu?”** — Where is the meeting point?
* **“Mấy giờ đóng cửa?”** — What time does it close?

### Sections

**The Cable Car Is The Arrival**

The climb is the part that turns city heat into a mountain day: forest below, mist on the glass, cooler air at the top. When the sky opens, the scale still feels cinematic.

**Do The Bridge Before The Park Spreads Out**

If the Golden Bridge is the point, put it first. After that, choose how much French Village, gardens, indoor rides, or food you actually want instead of drifting until everyone is tired.

**Weather Belongs In The Plan**

Fog can make the famous view disappear; rain can make the mountain feel like an expensive cloud walk. Check the forecast before leaving Da Nang, then keep the day loose.

**Give It The Day Space It Needs**

This is not a quick city stop. Travel time, tickets, cable cars, walking, and crowd flow all take room, so pair it with less rather than forcing a full Da Nang checklist around it.

### Implementation notes

**Page metadata**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-danang-place-ba-na-hills`
* `displayName: Bà Nà Hills`
* `englishName: Ba Na Hills`
* `city: Da Nang`
* `category: Landmark`
* `pronunciation: bah na hills`
* `target_hero_image: HeroCityDanangPlaceBaNaHills`
* `place_name_audio_status: ready`
* `place_name_audio_id: audio-authored-ba-na-hills-c5674a9b64`

**Closest canonical anchor:** Ba Na Hills / Bà Nà Hills
**Anchor behavior copied:** expectation-setting without deflation: name the theme-park reality, then keep the still-worth-it cable-car/mountain sentence.
**How this page differs:** this draft tightens phrase cards to three ready-audio reusable logistics phrases and keeps all operational risk internal.
**Owned traveler moment:** leaving city heat, riding the cable car up, then deciding whether the Golden Bridge or the wider park gets priority.

**Useful phrase card status**

* **“Vé bao nhiêu?”** — `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* **“Điểm gặp ở đâu?”** — `intent: ask_meeting_point` · `phraseId: sight-5` · `audioId: sight-5` · `status: mapped`
* **“Mấy giờ đóng cửa?”** — `intent: ask_closing_time` · `phraseId: sight-4` · `audioId: sight-4` · `status: mapped`

**Mentioned Here candidates**

* **Golden Bridge / Cầu Vàng** — `type: landmark` · `catalogId: danang-golden-bridge` · `sourceText: Golden Bridge` · `status: render`
  `displaySubtitle: The famous hand-held bridge inside the Ba Na Hills plan.`
  `reason: Named as the first priority inside the park sequence.`
* **Ba Na cable car / Cáp treo Bà Nà** — `type: experience` · `catalogId: danang-ba-na-cable-car` · `sourceText: cable cars` · `status: render`
  `displaySubtitle: The mountain climb that gives the visit its arrival moment.`
  `reason: Central to the arrival section and route logic.`
* **French Village** — `type: place` · `catalogId: null` · `sourceText: French Village` · `status: check_catalog`
  `displaySubtitle: A staged park area to decide on after the bridge.`
  `reason: Named naturally, but needs catalog confirmation before rendering.`

**Related place candidates**

* None for this draft; direct park components are handled as Mentioned Here candidates.

**Verification flags**

* `type: same_week`
  `reason: Recheck ticket price, cable-car operations, park hours, weather, access, and Golden Bridge availability before import.`
  `blocking: false`
* `type: audio_qa`
  `reason: Selected phrase cards have ready audio IDs; Codex should remap against native runtime assets.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Golden Bridge and Ba Na cable car appear in catalog; French Village needs lookup before rendering.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards are catalog-ready but still need final native QA pass in normal workflow.`
  `blocking: false`

**Source notes**

* Based on exact Batch 004 row source notes: City library; Vietnam Tourism Da Nang; Da Nang Fantasticity.
* Visible copy avoids current prices, schedules, official opening claims, and cable-car timing specifics.
* Place-name audio appears ready in Native Phrase Catalog; no new place-name phrase requested.

**Freshness notes**

* Operations and weather are material to the visit; keep same-week verification before any import decision.
* Do not render operational claims beyond the softened weather/crowd planning language above.

**Score**

28/30 — Strong v2.2 expectation-setting and concrete traveler sequence; capped for same-week operations/weather checks and catalog QA on French Village.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; three reusable ready-audio phrase cards.
* Mentioned Here test: pass; natural mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Chợ Bắc Mỹ An / Bac My An Market — Da Nang — Market

### Reader View

**Start With Kem Bơ, Then Decide**

Bắc Mỹ An Market works best as a small snack stop near the Mỹ An side of Da Nang. Go in for kem bơ, read the room, then add one hot snack only if the stalls look easy.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion please.
* **“Ít cay thôi.”** — Less spicy, please.
* **“Cái này bao nhiêu?”** — How much is this?

### Sections

**Small Orders Keep It Easy**

Do not make the first lap a test. Point, smile, ask the price, and keep the first order small; the market is better as a quick bite than a full decode.

**Kem Bơ Gives The Stop Its Shape**

The avocado ice cream is cold, green, sweet, and easy to understand before the hot counters. If that is the best bite of the visit, that is enough.

**Beach Side, Not Cross-City**

It makes sense when you are already near Mỹ An, Mỹ Khê, or a beach-side stay. Hàn is easier for central bearings; Cồn is better for a fuller food crawl.

### Implementation notes

**Page metadata**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-danang-place-bac-my-an-market`
* `displayName: Chợ Bắc Mỹ An`
* `englishName: Bac My An Market`
* `city: Da Nang`
* `category: Market`
* `pronunciation: cho bac my an`
* `target_hero_image: HeroCityDanangPlaceBacMyAnMarket`
* `place_name_audio_status: planned`
* `place_name_audio_id: null`
* `place_name_phrase_status: hide_until_audio`

**Closest canonical anchor:** Chợ Bắc Mỹ An revised example, with Hàn Market / Cồn Market as market-job references.
**Anchor behavior copied:** keep the market narrow, snack-led, and honest; do not inflate sparse evidence.
**How this page differs:** this draft removes generic market language and makes kem bơ the opening behavior while keeping phrase cards generic and ready-audio.
**Owned traveler moment:** standing near the beach side of Da Nang, choosing one cold snack first, then deciding whether to continue.

**Useful phrase card status**

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Ít cay thôi.”** — `intent: request_less_spicy` · `phraseId: food-not-spicy-clearer` · `audioId: audio-authored-it-cay-thoi-05b8e258a2` · `status: mapped`
* **“Cái này bao nhiêu?”** — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`

**Mentioned Here candidates**

* **Kem bơ** — `type: food` · `catalogId: food-kem-bo` · `sourceText: kem bơ` · `status: render`
  `displaySubtitle: Avocado ice cream, the easy first order here.`
  `reason: Named in the intro and section as the main opening bite.`
* **Mỹ An** — `type: neighborhood` · `catalogId: danang-my-an` · `sourceText: Mỹ An` · `status: render`
  `displaySubtitle: The beach-side neighborhood context for this market.`
  `reason: Used to explain when the stop makes sense.`
* **Mỹ Khê Beach** — `type: beach` · `catalogId: danang-my-khe-beach` · `sourceText: Mỹ Khê` · `status: render`
  `displaySubtitle: Nearby beach-side context for a low-pressure snack stop.`
  `reason: Named in the route/location guidance.`
* **Hàn Market / Chợ Hàn** — `type: market` · `catalogId: danang-han-market` · `sourceText: Hàn` · `status: render`
  `displaySubtitle: Better for central bearings and gifts.`
  `reason: Direct comparison appears in the final section.`
* **Cồn Market / Chợ Cồn** — `type: market` · `catalogId: danang-con-market` · `sourceText: Cồn` · `status: render`
  `displaySubtitle: Better for a fuller food-market crawl.`
  `reason: Direct comparison appears in the final section.`

**Related place candidates**

* **Hàn Market / Chợ Hàn** — `relationship: market_contrast` · `catalogId: danang-han-market` · `status: render`
  `displaySubtitle: Central market for bearings and gifts.`
  `reason: Helps the traveler choose between market types.`
* **Cồn Market / Chợ Cồn** — `relationship: food_market_contrast` · `catalogId: danang-con-market` · `status: render`
  `displaySubtitle: Stronger choice for a fuller snack crawl.`
  `reason: Helps the traveler choose whether Bắc Mỹ An is enough.`

**Verification flags**

* `type: light`
  `reason: Recheck stall hours, current snack availability, prices, and payment norms before import.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Kem bơ is in Menu Catalog; market/neighborhood links need final Codex mapping.`
  `blocking: false`
* `type: audio_qa`
  `reason: Selected phrase cards have ready audio IDs; confirm runtime mapping.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards are catalog-ready but still need final native QA pass in normal workflow.`
  `blocking: false`

**Source notes**

* Based on exact Batch 004 row source notes: Local map.
* Menu Catalog includes `food-kem-bo`; quick-say line is text-only, so it is not used as a phrase card.
* Evidence is intentionally narrow; visible copy does not claim broad stall variety or current vendor details.

**Freshness notes**

* Sparse evidence and changing stall availability keep this at review status.
* Do not render exact vendor, price, or hours claims unless checked close to import.

**Score**

27/30 — Strong narrow snack-stop behavior; capped for sparse evidence and changing stall conditions.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; three reusable ready-audio phrase cards.
* Mentioned Here test: pass; natural food, neighborhood, and market comparisons evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Đường Bạch Đằng / Bach Dang Street — Da Nang — Street

### Reader View

**Walk The River Spine**

Bạch Đằng is Da Nang’s central riverfront spine: bridges in view, hotel fronts behind you, cafés at the edges, and the Hàn River keeping the city readable.

### Useful phrase cards

* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Cho hỏi, đi tới đó thế nào?”** — Excuse me, how do I get there?

### Sections

**Late Afternoon Gives It Shape**

The street makes more sense when the light drops and people start using the promenade: walkers, scooters, café edges, bridge views, and river wind.

**Cross When You Mean To Cross**

The river is beautiful, but traffic still sets the rhythm. Pick your crossing, slow down at curb cuts, and do not drift with your phone up.

**Pair It With One Nearby Stop**

Treat Bạch Đằng as the line between things: Hàn Market, Dragon Bridge, a café, a hotel walk, or an evening riverfront pause. One nearby stop gives the walk a reason.

### Implementation notes

**Page metadata**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-danang-place-bach-dang-street`
* `displayName: Đường Bạch Đằng`
* `englishName: Bach Dang Street`
* `city: Da Nang`
* `category: Street`
* `pronunciation: duong bach dang`
* `target_hero_image: HeroCityDanangPlaceBachDangStreet`
* `place_name_audio_status: ready`
* `place_name_audio_id: audio-authored-duong-bach-dang-905007f3e8`

**Closest canonical anchor:** Đường Đồng Khởi, with Dragon Bridge as a nearby landmark-use reference.
**Anchor behavior copied:** a street becomes useful when it turns into a route with direction, timing, and nearby stops.
**How this page differs:** Bạch Đằng is riverfront orientation rather than historic-facade walking; the copy keeps the Hàn River and crossings central.
**Owned traveler moment:** starting a late-afternoon riverfront walk and using the street to understand central Da Nang before choosing a stop.

**Useful phrase card status**

* **“Tôi có thể đi bộ tới đó được không?”** — `intent: ask_if_walkable` · `phraseId: v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped`
* **“Đi bộ mất bao lâu?”** — `intent: ask_walking_time` · `phraseId: directions-3` · `audioId: directions-3` · `status: mapped`
* **“Cho hỏi, đi tới đó thế nào?”** — `intent: ask_route` · `phraseId: directions-1` · `audioId: directions-1` · `status: mapped`

**Mentioned Here candidates**

* **Han River / Sông Hàn** — `type: river` · `catalogId: danang-han-river` · `sourceText: Hàn River` · `status: render`
  `displaySubtitle: The river edge that makes central Da Nang easier to read.`
  `reason: Core spatial cue in the intro and sections.`
* **Hàn Market / Chợ Hàn** — `type: market` · `catalogId: danang-han-market` · `sourceText: Hàn Market` · `status: render`
  `displaySubtitle: Nearby central market pairing for a riverfront walk.`
  `reason: Named as a nearby stop.`
* **Dragon Bridge / Cầu Rồng** — `type: landmark` · `catalogId: danang-dragon-bridge` · `sourceText: Dragon Bridge` · `status: render`
  `displaySubtitle: Nearby bridge landmark along the riverfront.`
  `reason: Named as a route pairing.`
* **Bach Dang Street / Đường Bạch Đằng** — `type: street` · `catalogId: danang-bach-dang-street` · `sourceText: Bạch Đằng` · `status: do_not_render`
  `displaySubtitle: Current page.`
  `reason: Self-link should not render as a Mentioned Here card.`

**Related place candidates**

* **Han River / Sông Hàn** — `relationship: riverfront_context` · `catalogId: danang-han-river` · `status: render`
  `displaySubtitle: The waterline that gives the walk its shape.`
  `reason: Directly supports route planning from the street.`
* **Dragon Bridge / Cầu Rồng** — `relationship: evening_route_pairing` · `catalogId: danang-dragon-bridge` · `status: render`
  `displaySubtitle: Add it when the walk turns into an evening bridge view.`
  `reason: Natural nearby landmark pairing.`
* **Hàn Market / Chợ Hàn** — `relationship: central_market_pairing` · `catalogId: danang-han-market` · `status: render`
  `displaySubtitle: Pair before or after the riverfront walk.`
  `reason: Useful nearby stop for central bearings.`

**Verification flags**

* `type: light`
  `reason: Recheck riverfront access, construction, promenade conditions, and nearby route changes before import.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Han River, Dragon Bridge, and Hàn Market appear in catalog; confirm final card targets.`
  `blocking: false`
* `type: audio_qa`
  `reason: Selected phrase cards have ready audio IDs; confirm runtime mapping.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards are catalog-ready but still need final native QA pass in normal workflow.`
  `blocking: false`

**Source notes**

* Based on exact Batch 004 row source notes: City library; Vietnam Tourism / Da Nang sources.
* City Places Catalog includes the current page, Han River, Hàn Market, and Dragon Bridge.
* Visible copy avoids current event, lighting schedule, and venue-hour claims.

**Freshness notes**

* Street access and nearby construction can change; keep verification internal until Codex checks.
* Do not render route closures, event claims, or parking/access claims without a fresh check.

**Score**

28/30 — Clear street-spine behavior and grounded route value; capped for light access freshness and final catalog mapping.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; three reusable ready-audio phrase cards.
* Mentioned Here test: pass; natural links evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Đỉnh Bàn Cờ / Ban Co Peak — Da Nang — Landmark

### Reader View

**Let The Road Be Part Of It**

Ban Co Peak is the high-view version of Da Nang: a road climbing above beach hotels, the city and coastline below, and weather that can turn the view soft or gone.

### Useful phrase cards

* **“Nó cách đây bao xa?”** — How far is it?
* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Bạn có thể giúp tôi quay lại khách sạn được không?”** — Can you help me get back to my hotel?

### Sections

**Clouds Change The Payoff**

Clear air gives the big map: coastline, bridges, city blocks, mountain folds. Haze can still make it moody; rain can make the ride feel like the whole story.

**Do Not Rush The Climb**

The road and stops are part of the memory. Leave enough margin for curves, photos, and turning back if visibility or comfort drops.

**Pair It With Sơn Trà**

Ban Co Peak fits best with a peninsula plan: Lady Buddha, coastal roads, or a quiet viewpoint run. Squeezing it between markets and dinner makes the mountain feel like logistics.

### Implementation notes

**Page metadata**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-danang-place-ban-co-peak`
* `displayName: Đỉnh Bàn Cờ`
* `englishName: Ban Co Peak`
* `city: Da Nang`
* `category: Landmark`
* `pronunciation: dinh ban co`
* `target_hero_image: HeroCityDanangPlaceBanCoPeak`
* `place_name_audio_status: ready`
* `place_name_audio_id: audio-authored-dinh-ban-co-f4170cb874`

**Closest canonical anchor:** Dragon Bridge for a landmark with one real decision, plus Bạch Mã / Lập An for condition-aware planning.
**Anchor behavior copied:** make the visit hinge on one practical decision: view/weather/road margin, not generic landmark praise.
**How this page differs:** the key move is not where to stand, but whether the road, visibility, and return plan make the viewpoint worth the climb.
**Owned traveler moment:** riding up toward the viewpoint, checking the air and comfort level, then deciding whether to continue or turn the mountain into the memory.

**Useful phrase card status**

* **“Nó cách đây bao xa?”** — `intent: ask_distance` · `phraseId: v500-dire-navi-how-far-is-it` · `audioId: v500-dire-navi-how-far-is-it` · `status: mapped`
* **“Lối vào ở đâu?”** — `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* **“Bạn có thể giúp tôi quay lại khách sạn được không?”** — `intent: ask_help_return_hotel` · `phraseId: v500-dire-navi-can-you-help-me-get-back-to-my-hotel` · `audioId: v500-dire-navi-can-you-help-me-get-back-to-my-hotel` · `status: mapped`

**Mentioned Here candidates**

* **Son Tra Peninsula / Bán đảo Sơn Trà** — `type: nature` · `catalogId: danang-son-tra` · `sourceText: Sơn Trà` · `status: render`
  `displaySubtitle: Peninsula context for pairing Ban Co Peak with coastal roads.`
  `reason: Named in the route-pairing section.`
* **Lady Buddha / Tượng Phật Bà** — `type: landmark` · `catalogId: danang-lady-buddha` · `sourceText: Lady Buddha` · `status: render`
  `displaySubtitle: Nearby peninsula landmark to pair with the viewpoint.`
  `reason: Named as a natural nearby pairing.`
* **Ban Co Peak / Đỉnh Bàn Cờ** — `type: landmark` · `catalogId: danang-ban-co-peak` · `sourceText: Ban Co Peak` · `status: do_not_render`
  `displaySubtitle: Current page.`
  `reason: Self-link should not render as a Mentioned Here card.`

**Related place candidates**

* **Son Tra Peninsula / Bán đảo Sơn Trà** — `relationship: peninsula_route_context` · `catalogId: danang-son-tra` · `status: render`
  `displaySubtitle: Build the viewpoint into a wider peninsula plan.`
  `reason: Helps travelers avoid treating the viewpoint as an isolated errand.`
* **Lady Buddha / Tượng Phật Bà** — `relationship: nearby_landmark_pairing` · `catalogId: danang-lady-buddha` · `status: render`
  `displaySubtitle: Pair when the peninsula route needs one calmer stop.`
  `reason: Named in visible copy and useful for route planning.`

**Verification flags**

* `type: same_week`
  `reason: Recheck weather, visibility, road access, and route conditions before import.`
  `blocking: false`
* `type: light`
  `reason: Confirm current access expectations and any local restrictions before rendering route-heavy claims.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Sơn Trà and Lady Buddha exist in catalog; confirm final card targets.`
  `blocking: false`
* `type: audio_qa`
  `reason: Selected phrase cards have ready audio IDs; confirm runtime mapping.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards are catalog-ready but still need final native QA pass in normal workflow.`
  `blocking: false`

**Source notes**

* Based on exact Batch 004 row source notes: City library; Da Nang Fantasticity.
* City Places Catalog includes Ban Co Peak, Son Tra Peninsula, and Lady Buddha.
* Visible copy avoids route-specific, road-safety, entry-fee, or access-rule claims.

**Freshness notes**

* Weather and road/access conditions carry the page; keep same-week verification before import.
* Do not render transport method, opening/access, or road-condition claims until checked.

**Score**

27/30 — Stronger than the legacy generic landmark copy; capped for source thinness and condition-dependent access.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; three reusable ready-audio phrase cards.
* Mentioned Here test: pass; natural route-pairing mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Bánh mì ở Đà Nẵng / Banh mi — Da Nang — Dish

### Reader View

**Choose The Filling Before The Counter**

Bánh mì in Da Nang is a small, fast meal: crisp bread, herbs, pickles, sauce, chili if you let it in, and a counter that may not slow down while you decide.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion please.
* **“Ít cay thôi.”** — Less spicy, please.
* **“Mang đi.”** — To go.

### Sections

**Pick Filling, Chili, Sauce**

Decide the big choices before you step in: pork, chicken, egg, pâté, grilled meat, how much chili, and whether sauce is okay. That is where most counter stress disappears.

**Crisp Bread, Soft Middle**

The pleasure is the contrast: shattering crust, warm filling, sharp pickles, herbs, and rich sauce. Eat it soon if the bread matters.

**Breakfast Or Fast Lunch**

It works when seafood plans are later and you need something small now. A good bánh mì gives the city a quick hand-held flavor without turning lunch into a long stop.

**When In Doubt, Start Classic**

Bánh mì thịt or bánh mì đặc biệt gives the familiar mix of meat, pâté, pickles, herbs, and chili. Bánh mì gà or ốp la is easier if you want a gentler first order.

### Implementation notes

**Page metadata**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `page_id: city-danang-place-banh-mi`
* `displayName: Bánh mì ở Đà Nẵng`
* `englishName: Banh mi`
* `city: Da Nang`
* `category: Dish`
* `pronunciation: banh mi`
* `target_hero_image: HeroCityDanangPlaceBanhMi`
* `place_name_audio_status: planned`
* `place_name_audio_id: null`
* `place_name_phrase_status: hide_until_audio`

**Closest canonical anchor:** Bánh Mì Phượng revised example, with Bale Well for pre-order confidence.
**Anchor behavior copied:** reduce counter pressure by making the first decision happen before ordering.
**How this page differs:** this is a citywide dish page, not a famous shop page, so the copy focuses on filling, chili, sauce, and speed rather than any one venue.
**Owned traveler moment:** arriving at a fast counter and choosing filling/chili/sauce before the order starts moving.

**Useful phrase card status**

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Ít cay thôi.”** — `intent: request_less_spicy` · `phraseId: food-not-spicy-clearer` · `audioId: audio-authored-it-cay-thoi-05b8e258a2` · `status: mapped`
* **“Mang đi.”** — `intent: takeaway` · `phraseId: coffee-6` · `audioId: coffee-6` · `status: mapped`

**Mentioned Here candidates**

* **Bánh mì thịt** — `type: food` · `catalogId: food-banh-mi-thit` · `sourceText: Bánh mì thịt` · `status: render`
  `displaySubtitle: Classic pork bánh mì with herbs, pickles, and chili optional.`
  `reason: Named as the familiar classic first order.`
* **Bánh mì đặc biệt** — `type: food` · `catalogId: food-banh-mi-dac-biet` · `sourceText: bánh mì đặc biệt` · `status: render`
  `displaySubtitle: House-special style bánh mì with a fuller mix.`
  `reason: Named as a classic-style option.`
* **Bánh mì gà** — `type: food` · `catalogId: food-banh-mi-ga` · `sourceText: Bánh mì gà` · `status: render`
  `displaySubtitle: Chicken bánh mì, often easier for a gentler first order.`
  `reason: Named as a softer option.`
* **Bánh mì ốp la** — `type: food` · `catalogId: food-banh-mi-op-la` · `sourceText: ốp la` · `status: render`
  `displaySubtitle: Fried-egg bánh mì for breakfast or a simpler order.`
  `reason: Named as an easier first order.`
* **Banh mi / Bánh mì ở Đà Nẵng** — `type: food` · `catalogId: danang-banh-mi` · `sourceText: bánh mì` · `status: do_not_render`
  `displaySubtitle: Current page.`
  `reason: Self-link should not render as a Mentioned Here card.`

**Related place candidates**

* None for this draft; it is a dish page, and the natural catalog value is in menu-item mentions rather than route planning.

**Verification flags**

* `type: light`
  `reason: Stall menus, fillings, prices, and hours vary; keep visible copy general unless a specific vendor is checked.`
  `blocking: false`
* `type: catalog_qa`
  `reason: Menu Catalog includes the named bánh mì variants; Codex should confirm final render targets.`
  `blocking: false`
* `type: audio_qa`
  `reason: Selected phrase cards have ready audio IDs; menu quick-say lines are text-only and should not render as audio cards here.`
  `blocking: false`
* `type: native_speaker_qa`
  `reason: Phrase cards are catalog-ready but still need final native QA pass in normal workflow.`
  `blocking: false`

**Source notes**

* Based on exact Batch 004 row source notes: Vietnam food sources.
* Menu Catalog includes bánh mì variants and text-only order lines; this draft avoids using those text-only lines as phrase cards.
* Visible copy avoids naming specific shops or current menu promises.

**Freshness notes**

* Keep vendor-specific options, prices, hours, and queue claims out unless checked close to import.
* Place-name phrase audio is planned, so render only the general dish page title/pronunciation unless Codex has ready audio.

**Score**

28/30 — Clear counter-order behavior and strong menu catalog mapping; capped for general dish freshness and place-name audio status.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; three reusable ready-audio phrase cards.
* Mentioned Here test: pass; menu-item mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Codex handoff block

```markdown
- `batch_id: batch_004`
- `page_ids: city-danang-place-ba-na-hills, city-danang-place-bac-my-an-market, city-danang-place-bach-dang-street, city-danang-place-ban-co-peak, city-danang-place-banh-mi`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none_selected_as_new; all selected phrase cards use ready-audio reusable catalog rows, but Codex/native QA should remap final phraseId/audioId in runtime`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: Bac My An Market and Ban Co Peak use restrained claims because evidence is thinner; Bach Dang Street is route-led and should be checked for voice drift after render; no current hours/prices/rules are visible`
- `source_freshness_risks: Ba Na Hills operations/weather/tickets/cable-car access; Bac My An stall availability/prices/payment norms; Bach Dang riverfront access/construction; Ban Co Peak weather/visibility/road access; banh mi stall menus/fillings/prices/hours`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```
