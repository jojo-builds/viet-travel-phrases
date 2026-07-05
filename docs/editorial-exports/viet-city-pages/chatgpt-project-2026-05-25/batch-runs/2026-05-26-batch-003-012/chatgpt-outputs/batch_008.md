SpeakLocal v2.2 BATCH_008 - Saigon B - 2026-05-26

Source basis: the attached batch prompt fixes these five rows, requires the first line above, keeps phrase cards to 2–3 ready-audio reusable phrases, and makes this chat the canonical handoff.  The v2.2 source bundle sets the app-detail order, phrase-card rules, Mentioned Here behavior, and internal-only verification handling.  The catalog spreadsheet contains the HCMC place IDs for all five rows and sibling items used below. 

---

## 1. Bến Bạch Đằng / Bach Dang Wharf — Saigon — Landmark

### Reader View

**Let The River Reframe District 1**

Bến Bạch Đằng is where central Saigon loosens toward the water: promenade paving, boat movement, skyline across the river, and traffic still close behind you. Come for a short walk, a river look, and a cleaner sense of how District 1 meets the Saigon River.

### Useful phrase cards

* **“Điểm đón ở đâu?”** — Where is the pickup point?
* **“Tôi có thể chụp ảnh ở đây được không?”** — Can I take a photo here?

### Sections

**A Short Walk Does Enough**

Start with the river edge before adding more plans. Watch the boats, look back at the towers, then decide whether to keep walking, sit nearby, or head back into the denser streets.

**Skyline, Boats, Traffic**

The contrast is the point: polished riverfront, working water, hotel glass, motorbikes, and city noise all close together. It is not quiet, but it can make Saigon feel wider.

**Keep The Return Simple**

Evening can make the view sharper, but the area is easiest when you already know where your pickup point is. A clean exit keeps the river pause from turning into a traffic puzzle.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hcmc-place-bach-dang-wharf`
* `displayName: Bến Bạch Đằng`
* `englishName: Bach Dang Wharf`
* `city: Saigon`
* `category: landmark`
* `pronunciation: ben bahk dang`
* `targetHeroImage: HeroCityHcmcPlaceBachDangWharf`
* Closest canonical anchor: Dragon Bridge / Cầu Rồng.
* Anchor behavior copied: simple landmark with one real decision; make the object usable by giving the traveler where to stand, how long to stay, and how to leave.
* How this page differs: no event schedule or show timing; the decision is short river pause versus overbuilding the stop.
* Owned traveler moment: stepping out of District 1 traffic onto the riverfront, then choosing a short walk and pickup point.

### Phrase/audio status

* **“Điểm đón ở đâu?”** — `intent: ask_pickup_point` · `phraseId: directions-8` · `audioId: directions-8` · `status: mapped`
* **“Tôi có thể chụp ảnh ở đây được không?”** — `intent: ask_photo_permission` · `phraseId: v900-sigh-acti-can-i-take-a-photo-here` · `audioId: v900-sigh-acti-can-i-take-a-photo-here` · `status: mapped`

### Mentioned Here candidates

* **Saigon River** — `type: landmark/place` · `catalogId: null` · `sourceText: “Saigon River”` · `status: check_catalog`

  * `displaySubtitle: The river edge that gives central Saigon more space.`
  * `reason: Named naturally in the intro as the physical reason for the stop.`
* **District 1** — `type: neighborhood` · `catalogId: null` · `sourceText: “District 1”` · `status: check_catalog`

  * `displaySubtitle: The central hotel-and-sightseeing core beside the river.`
  * `reason: Named naturally to orient the traveler’s arrival and exit.`

### Related place candidates

* **Bach Dang Waterbus Station** — `relationship: nearby_river_transport` · `catalogId: hcmc-bach-dang-waterbus-station` · `status: render`

  * `displaySubtitle: Nearby river boarding point; verify current routes before planning around it.`
  * `reason: Catalog sibling beside Bach Dang Wharf; useful only as route context, not a visible current-schedule claim.`

### Verification flags

* `type: light` · `reason: Confirm current promenade access, nearby pickup behavior, and any construction or riverfront routing changes.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm whether Saigon River and District 1 have existing catalog targets before rendering Mentioned Here cards.` · `blocking: false`
* `type: audio_qa` · `reason: Confirm v900 sightseeing phrase ID maps cleanly in the app audio system.` · `blocking: false`

### Source notes

* Exact row supplied in the batch prompt with Visit HCMC / existing-city-library source notes and legacy riverfront/skyline context. 
* City Places Catalog includes `hcmc-bach-dang-wharf` and sibling `hcmc-bach-dang-waterbus-station`. 
* Visible copy avoids hours, prices, boat schedules, ticket rules, or current access claims.

### Freshness notes

* Same-week check is not required for this draft because visible copy avoids schedule claims.
* Before import, Codex should verify current riverfront access, pickup-point practicality, nearby construction, and waterbus route status if the related card renders.

### Score

27/30 — Stronger and calmer than the legacy copy, with a clear traveler moment. Capped for light evidence, catalog checks on river/neighborhood mentions, and no rendered screenshot review.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass, with one Codex audio-ID confirmation.
* Mentioned Here test: pass; no forced link stuffing.
* Catalog mention scan: pass, with two check_catalog items.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Bánh mì ở Thành phố Hồ Chí Minh / Banh mi — Saigon — Dish

### Reader View

**Choose Chili Before The Roll Closes**

Bánh mì is Saigon at counter speed: crisp bread, pâté or meat, pickles, herbs, cucumber, and chili if you let it in. The order gets easier when you decide heat and takeaway before the vendor reaches for sauce.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion, please.
* **“Không cay nhé.”** — Not spicy, please.
* **“Mang đi.”** — To go.

### Sections

**Crunch First, Then Richness**

A good bánh mì lands in layers: bread crackle, pâté or meat, sour pickles, fresh herbs, and a little heat. The sandwich is small, but it can carry a full street-food memory.

**Start With A Clear Filling**

If the counter has options, bánh mì thịt and bánh mì đặc biệt are easy first reads. If you see eggs on the griddle, bánh mì ốp la gives you a softer breakfast version.

**Pointing Works**

Many counters move by sight. Point to the filling, say your spice level, then say whether you are staying nearby or taking it away. The confidence matters more than a perfect sentence.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hcmc-place-banh-mi`
* `displayName: Bánh mì ở Thành phố Hồ Chí Minh`
* `englishName: Banh mi`
* `city: Saigon`
* `category: dish`
* `pronunciation: banh mee`
* `targetHeroImage: HeroCityHcmcPlaceBanhMi`
* Closest canonical anchor: Bánh Mì Phượng, with Madam Khanh as the secondary comparison.
* Anchor behavior copied: choose filling, chili, and takeaway before the counter moves.
* How this page differs: citywide dish page, not a named shop; keeps the behavior reusable and does not imply one best vendor.
* Owned traveler moment: standing at a fast sandwich counter and making the heat/takeaway decision before the roll is built.

### Phrase/audio status

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Không cay nhé.”** — `intent: request_not_spicy` · `phraseId: food-3` · `audioId: food-3` · `status: mapped`
* **“Mang đi.”** — `intent: takeaway` · `phraseId: coffee-6` · `audioId: coffee-6` · `status: mapped`

### Mentioned Here candidates

* **Bánh mì thịt** — `type: food` · `catalogId: food-banh-mi-thit` · `sourceText: “bánh mì thịt”` · `status: render`

  * `displaySubtitle: Classic pork bánh mì with pickles, herbs, and chili optional.`
  * `reason: Named naturally as an easy first filling choice; catalog item exists.`
* **Bánh mì đặc biệt** — `type: food` · `catalogId: food-banh-mi-dac-biet` · `sourceText: “bánh mì đặc biệt”` · `status: render`

  * `displaySubtitle: House-special style with pâté, cold cuts, pickles, herbs, and seasoning.`
  * `reason: Named naturally as a common counter option; catalog item exists.`
* **Bánh mì ốp la** — `type: food` · `catalogId: food-banh-mi-op-la` · `sourceText: “bánh mì ốp la”` · `status: render`

  * `displaySubtitle: Fried-egg bánh mì for a softer breakfast order.`
  * `reason: Named naturally as a visible griddle-based breakfast variant; catalog item exists.`

### Related place candidates

* **Banh Mi Huynh Hoa** — `relationship: named_banh_mi_counter` · `catalogId: hcmc-banh-mi-huynh-hoa` · `status: render`

  * `displaySubtitle: Named Saigon bánh mì stop; verify current hours and queue pattern.`
  * `reason: Direct sibling in this batch and useful for travelers who want one named shop after learning the dish.`

### Verification flags

* `type: native_speaker_qa` · `reason: Confirm phrase tone and diacritics before import even though rows are ready-audio mapped.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm food catalog IDs render as Mentioned Here cards and do not collide with the current page itself.` · `blocking: false`

### Source notes

* Exact dish row comes from the batch prompt with Vietnam Travel HCMC source notes and legacy details: crisp bread, pâté, herbs, pickles, chili, and counter speed. 
* Menu Catalog includes `food-banh-mi-dac-biet`, `food-banh-mi-thit`, and related bánh mì item details. 
* Menu Catalog also includes `food-banh-mi-op-la` as a breakfast bánh mì variant. 
* Ready-audio food phrase rows include one portion, not spicy, and takeaway. 

### Freshness notes

* Citywide dish copy avoids specific vendor hours, pricing, rankings, or “best” claims.
* Before import, Codex should confirm whether all three food items are live catalog targets.

### Score

28/30 — Clear, practical, and catalog-aware. Capped for no native-speaker phrase pass in this chat and no rendered screenshot review.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Bánh mì Huỳnh Hoa / Banh Mi Huynh Hoa — Saigon — Restaurant

### Reader View

**Decide Before The Glass Case**

Huỳnh Hoa makes bánh mì feel like a planned food stop because the counter moves with purpose. Arrive with your heat level and takeaway decision already made, then let the sandwich be the break.

### Useful phrase cards

* **“Không cay nhé.”** — Not spicy, please.
* **“Gói mang về.”** — Pack it to go.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Sections

**Famous Can Still Be Small**

The sandwich can be rich and layered: crisp bread, pâté, meat, pickles, herbs, sauce, and heat. Do not make the order bigger than it needs to be. One clean sandwich is enough.

**Control The Heat Early**

Chili and sauce matter here because the sandwich is built fast. Say mild before the roll closes, not after the first bite.

**Eat Nearby, Then Move On**

This works best as a central Saigon food pause. If the counter feels crowded, takeaway keeps the moment simple; find a place nearby, eat, and return to the day.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hcmc-place-banh-mi-huynh-hoa`
* `displayName: Bánh mì Huỳnh Hoa`
* `englishName: Banh Mi Huynh Hoa`
* `city: Saigon`
* `category: restaurant`
* `pronunciation: banh mee hween hwa`
* `targetHeroImage: HeroCityHcmcPlaceBanhMiHuynhHoa`
* Closest canonical anchor: Bánh Mì Phượng.
* Anchor behavior copied: famous sandwich counter, pre-order confidence, heat decision before the sandwich is built.
* How this page differs: Saigon named counter with less source depth in the bundle; keeps venue-specific claims restrained.
* Owned traveler moment: reaching the glass case and ordering without freezing while the counter moves.

### Phrase/audio status

* **“Không cay nhé.”** — `intent: request_not_spicy` · `phraseId: food-3` · `audioId: food-3` · `status: mapped`
* **“Gói mang về.”** — `intent: pack_to_go` · `phraseId: food-7` · `audioId: food-7` · `status: mapped`
* **“Tính tiền giúp tôi.”** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

### Mentioned Here candidates

* **Banh mi** — `type: food` · `catalogId: hcmc-banh-mi` · `sourceText: “bánh mì”` · `status: render`

  * `displaySubtitle: Saigon’s fast, layered street sandwich.`
  * `reason: The dish is named throughout visible copy and has a city catalog page.`

### Related place candidates

* **Ben Thanh Market** — `relationship: central_area_pairing` · `catalogId: hcmc-ben-thanh-market` · `status: render`

  * `displaySubtitle: Nearby central market area; verify route and timing before pairing.`
  * `reason: Legacy row ties the stop to Ben Thanh market energy, but visible copy keeps this as central-area context only.`
* **Banh mi** — `relationship: parent_dish` · `catalogId: hcmc-banh-mi` · `status: render`

  * `displaySubtitle: Learn the sandwich before choosing a named counter.`
  * `reason: Parent dish page helps travelers understand the order before a famous counter.`

### Verification flags

* `type: light` · `reason: Verify current hours, address/branch, queue pattern, menu options, and takeaway flow before import.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm related Ben Thanh Market card should render for this page or remain internal route context.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm pronunciation for Huỳnh Hoa and phrase-card fit.` · `blocking: false`

### Source notes

* Exact named-restaurant row is supplied in the batch prompt with local named-restaurant source notes and legacy counter imagery. 
* City Places Catalog includes `hcmc-banh-mi-huynh-hoa`, `hcmc-banh-mi`, and `hcmc-ben-thanh-market`. 
* Ready-audio food phrase rows include not spicy, pack to go, and pay now. 

### Freshness notes

* Visible copy avoids current hours, prices, line length, address, exact fillings, or ranking claims.
* Named-restaurant status should be checked same week before any import or rendered card promotion.

### Score

27/30 — Strong counter behavior and controlled claims. Capped for named-venue freshness risk, sparse local source detail, and no screenshot review.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Bánh xèo ở Thành phố Hồ Chí Minh / Southern sizzling pancake — Saigon — Dish

### Reader View

**The Meal Happens In Your Hands**

Bánh xèo lands loud: turmeric batter crisped at the edge, shrimp or pork inside, herbs piled beside it, and dipping sauce waiting. The pancake is only half the dish; the real bite comes from tearing, wrapping, and dipping.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion, please.
* **“Cho thêm rau.”** — More herbs, please.
* **“Cái này có nước mắm không?”** — Does this contain fish sauce?

### Sections

**Crisp Edge, Fresh Herb**

The first pleasure is texture: brittle pancake edge, warm filling, cool greens, and sauce cutting through the oil. Do not rush the first bite; it is better when the herb pile joins the pancake.

**Small Pieces Beat Big Bites**

Tear off a piece you can actually fold. Wrap it with lettuce or rice paper if served, add herbs, dip lightly, and keep going. A huge bite usually breaks before it reaches your mouth.

**Chay Still Needs A Sauce Check**

A bánh xèo chay version can solve the filling question, but the dip still matters if fish sauce is off-limits. Ask before the plate settles in front of you.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hcmc-place-banh-xeo`
* `displayName: Bánh xèo ở Thành phố Hồ Chí Minh`
* `englishName: Southern sizzling pancake`
* `city: Saigon`
* `category: dish`
* `pronunciation: banh say-oh`
* `targetHeroImage: HeroCityHcmcPlaceBanhXeo`
* Closest canonical anchor: Bale Well.
* Anchor behavior copied: turn a roll/wrap meal into confidence by explaining the first physical move.
* How this page differs: dish page rather than restaurant set meal; focuses on tearing, wrapping, herbs, and sauce.
* Owned traveler moment: the pancake lands on the table and the traveler decides how to eat it without making a mess.

### Phrase/audio status

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cho thêm rau.”** — `intent: request_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`
* **“Cái này có nước mắm không?”** — `intent: ask_contains_fish_sauce` · `phraseId: v900-food-drin-does-this-contain-fish-sauce` · `audioId: v900-food-drin-does-this-contain-fish-sauce` · `status: mapped`

### Mentioned Here candidates

* **Bánh xèo chay** — `type: food` · `catalogId: food-banh-xeo-chay` · `sourceText: “bánh xèo chay”` · `status: render`

  * `displaySubtitle: Vegetarian crispy pancake; sauce still needs a check if fish sauce matters.`
  * `reason: Named naturally in the dietary/sauce section; Menu Catalog has an item row.`
* **Nước mắm** — `type: food` · `catalogId: null` · `sourceText: “nước mắm”` · `status: check_catalog`

  * `displaySubtitle: Fish sauce, often part of Vietnamese dipping sauces.`
  * `reason: Named in the phrase card and sauce guidance; render only if catalog target exists.`

### Related place candidates

* **Banh Xeo 46A** — `relationship: named_banh_xeo_restaurant` · `catalogId: hcmc-banh-xeo-46a` · `status: render`

  * `displaySubtitle: Named Saigon bánh xèo stop; verify current venue details first.`
  * `reason: Direct sibling in the batch and useful for travelers who want a restaurant version after learning the dish.`

### Verification flags

* `type: catalog_qa` · `reason: Confirm whether nước mắm has a live catalog item before rendering.` · `blocking: false`
* `type: audio_qa` · `reason: Confirm v900 fish-sauce phrase maps cleanly as a playable card.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm English gloss and phrase tone for the fish-sauce line.` · `blocking: false`

### Source notes

* Exact dish row comes from the batch prompt with Vietnam Travel HCMC source notes and legacy details: shrimp, pork, herbs, dipping sauce, steam, and texture. 
* Menu Catalog includes `food-banh-xeo-chay` and notes sauce checks for vegetarian versions. 
* Ready-audio food phrase rows include one portion and more herbs; Phrase Picker includes the fish-sauce question as ready audio.  

### Freshness notes

* Dish copy avoids naming specific stalls, prices, hours, or current restaurant details.
* Confirm related restaurant card only after Bánh xèo 46A venue status is checked.

### Score

28/30 — Strong physical eating cue and practical sauce/herb phrase fit. Capped for fish-sauce catalog/audio confirmation and no screenshot review.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass, with one v900 mapping confirmation.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Bánh xèo 46A / Banh Xeo 46A — Saigon — Restaurant

### Reader View

**Let The Pancake Fill The Table**

Bánh xèo 46A is the kind of stop where the order looks bigger once it lands: a broad crisp pancake, herbs, sauce, and everyone making space at the table. Come for the shared rhythm, not a tidy fork-and-knife plate.

### Useful phrase cards

* **“Cho tôi một phần.”** — One portion, please.
* **“Cho thêm rau.”** — More herbs, please.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Sections

**One Pancake First**

Start with one bánh xèo before adding more. The size, herbs, and wrapping rhythm tell you quickly whether the table needs another round.

**Ask For Herbs Early**

The greens are not garnish here. They cool the hot pancake, make the bite easier to fold, and keep the sauce from taking over.

**Messy Is Part Of It**

A little cracking, dripping, and rearranging is normal. The meal works better when you slow down, tear smaller pieces, and let the table share the pace.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-hcmc-place-banh-xeo-46a`
* `displayName: Bánh xèo 46A`
* `englishName: Banh Xeo 46A`
* `city: Saigon`
* `category: restaurant`
* `pronunciation: banh say-oh forty-six A`
* `targetHeroImage: HeroCityHcmcPlaceBanhXeo46a`
* Closest canonical anchor: Bale Well.
* Anchor behavior copied: shared table rhythm, roll/wrap confidence, order size control, and herb/sauce interaction.
* How this page differs: named Saigon bánh xèo restaurant with thin current-source detail; avoids hours, queue, address, and pricing.
* Owned traveler moment: the large pancake arrives, the table shifts, and the traveler learns how to portion, wrap, and share it.

### Phrase/audio status

* **“Cho tôi một phần.”** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **“Cho thêm rau.”** — `intent: request_more_herbs` · `phraseId: food-4` · `audioId: food-4` · `status: mapped`
* **“Tính tiền giúp tôi.”** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

### Mentioned Here candidates

* **Bánh xèo** — `type: food` · `catalogId: hcmc-banh-xeo` · `sourceText: “bánh xèo”` · `status: render`

  * `displaySubtitle: Southern sizzling pancake with herbs and dipping sauce.`
  * `reason: Parent dish is named naturally in intro and first section; city catalog item exists.`

### Related place candidates

* **Banh mi** — `relationship: nearby_food_contrast` · `catalogId: hcmc-banh-mi` · `status: do_not_render`

  * `displaySubtitle: Fast counter sandwich contrast.`
  * `reason: Same batch food contrast exists, but it is not named in visible copy and should not be forced.`

### Verification flags

* `type: light` · `reason: Verify current hours, address/branch, menu, portion style, and any closure or relocation before import.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Confirm pronunciation handling for “46A” and phrase-card fit.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm parent dish card should render and not create circular navigation confusion.` · `blocking: false`

### Source notes

* Exact restaurant row is supplied in the batch prompt with local named-restaurant source notes and legacy table imagery: large crispy bánh xèo, herbs, and restaurant table. 
* City Places Catalog includes `hcmc-banh-xeo-46a` and parent dish `hcmc-banh-xeo`. 
* Ready-audio food phrase rows include one portion, more herbs, and pay now. 

### Freshness notes

* Visible copy avoids current hours, prices, queue, address, and exact menu claims.
* Named-restaurant status should be checked same week before import.

### Score

27/30 — Clear shared-table behavior and good phrase fit. Capped for named-venue freshness, sparse source detail, and no rendered screenshot review.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch-level QA notes

* Reader View appears before implementation notes for each listing.
* Phrase cards are limited to 2–3 per listing.
* Phrase cards use reusable ready-audio phrases, not one-off venue or object phrases.
* No place-name phrase card is rendered.
* Visible copy avoids current hours, prices, queue length, booking rules, exact address claims, and volatile access details.
* Visible copy does not use the batch-banned terms in app-visible sections.
* No listing should be treated as ready for import until Jojo voice approval, Codex catalog/audio mapping, native review gates, and rendered screenshot checks are complete.

```markdown
## Codex handoff block

- `batch_id: batch_008`
- `page_ids: city-hcmc-place-bach-dang-wharf, city-hcmc-place-banh-mi, city-hcmc-place-banh-mi-huynh-hoa, city-hcmc-place-banh-xeo, city-hcmc-place-banh-xeo-46a`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: directions-8; v900-sigh-acti-can-i-take-a-photo-here; v900-food-drin-does-this-contain-fish-sauce; confirm coffee-6 and coffee-7 remain valid food/takeaway/pay phrase IDs despite legacy coffee-prefixed IDs`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: low; named-venue pages intentionally avoid current hours, prices, address, queue, and menu-specific claims`
- `source_freshness_risks: Bach Dang Wharf access and pickup flow; Bach Dang Waterbus related-card route status; Banh Mi Huynh Hoa current hours/address/menu/queue; Banh Xeo 46A current hours/address/menu/portion style; all related cards require catalog/link confirmation`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```
