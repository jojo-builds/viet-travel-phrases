SpeakLocal v2.2 BATCH_019 - Da Nang - 2026-05-26

Source basis read for this handoff: exact batch rows and handoff requirements, v2.2 operating gate/output model, phrase-card and Mentioned Here rules, place catalog rows, and the kem bơ menu catalog item.     

---

## Chợ đêm Helio / Helio Night Market — Da Nang — Market

### Reader View

**A Food-Court Night With Breathing Room**

Helio is the easier night when you want food, seating, lights, and music without working-market pressure. Make one small first order, find where you actually want to sit, then decide whether the night deserves another round.

### Useful phrase cards

* **“Cái này bao nhiêu?”** — How much is this?
* **“Cho tôi một phần.”** — One portion, please.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Practical sections

**One Lap Before The Tray**

Walk the stalls once before ordering. Helio is clearer than a tight market, but the first lap still helps you read portions, seating, grills, drinks, and dessert counters before your hands are full.

**Rounds Beat A Full Table**

Start with one dish or snack, then add a skewer, drink, or sweet cup after you see the size. If seafood pricing feels unclear, ask before you agree.

**Different Night Than Sơn Trà**

Sơn Trà fits better beside Dragon Bridge. Helio is the more controlled food-and-seating night when you want options, lower pressure, and music without making dinner a negotiation.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-helio-night-market`
* `displayName: Chợ đêm Helio`
* `englishName: Helio Night Market`
* `city: Da Nang`
* `category: Market`
* `targetHeroImage: HeroCityDanangPlaceHelioNightMarket`
* `pronunciation: chuh dem HEH-lee-oh`
* Closest canonical anchor: **Chợ đêm Helio** secondary canonical, with **Hàn Market / Chợ Cồn** behavior for defining the market’s job.
* Anchor behavior copied: define the night market’s practical role before listing food.
* How this page differs: Helio is not a working market or Dragon Bridge add-on; it owns the controlled food-court evening.
* Owned traveler moment: first lap, first small order, then deciding whether to stay.

### Phrase/audio IDs

* **Cái này bao nhiêu?** — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* **Cho tôi một phần.** — `intent: order_one_portion` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **Tính tiền giúp tôi.** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

### Mentioned Here candidates

* **Hải sản ở Đà Nẵng** — `type: food/dish` · `catalogId: danang-hai-san` · `status: render`
  `displaySubtitle: Seafood is worth pricing clearly before ordering.`
  `reason: Visible copy mentions seafood pricing as a practical market risk.`

* **Cầu Rồng** — `type: landmark` · `catalogId: danang-dragon-bridge` · `status: check_catalog`
  `displaySubtitle: The riverfront landmark that shapes nearby night-market plans.`
  `reason: Mentioned only as part of the Sơn Trà contrast; render only if the route link helps rather than distracting from Helio.`

### Related place candidates

* **Chợ đêm Sơn Trà** — `relationship: night_market_contrast` · `catalogId: danang-son-tra-night-market` · `status: render`
  `displaySubtitle: Better when the night is built around Dragon Bridge.`
  `reason: Direct comparison in visible copy; useful for choosing the right night-market role.`

### Freshness notes

* Same-week check needed for hours, stall mix, event/music schedule, food prices, and payment norms.
* Visible copy avoids fixed hours, current program claims, exact stall count, or payment rules.

### Source notes

* Ledger source notes: City library; Da Nang Fantasticity.
* Source bundle/canonical behavior identifies Helio as an organized outdoor food-court night with seating, music, and less vendor pressure than tighter markets.
* Place catalog row exists: `danang-helio-night-market`.

### Score

28/30 — Strong role definition and natural first-screen voice. Capped for same-week venue programming, pricing, and stall-mix verification.

### QA notes

* Replaceability test: pass.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass; seafood and route contrast evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Khu du lịch Hòa Phú Thành / Hoa Phu Thanh — Da Nang — Attraction

### Reader View

**A Wet Mountain Day Needs A Plan**

Hòa Phú Thành sits on the greener side of Da Nang’s trip map: stream water, trees, simple rafting gear, and a ride that should be clear before you leave town. It is still worth considering when beaches and bridges have started to make the city feel too flat.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Điểm gặp ở đâu?”** — Where is the meeting point?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?

### Practical sections

**Confirm What Is Running**

Ask what activities are operating before you commit the day. A stream recreation area depends more on weather, water, gear, and staff rhythm than a normal sightseeing stop.

**Keep Dry Things Separate**

Treat the wet part as the point. Pack your phone, cash, and dry layer so you are not solving everything with wet hands after the first activity.

**Do Not Crowd The Evening**

The ride out and back matters. Leave space after the trip instead of stacking it with a tight dinner, bridge show, or airport transfer.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-hoa-phu-thanh`
* `displayName: Khu du lịch Hòa Phú Thành`
* `englishName: Hoa Phu Thanh`
* `city: Da Nang`
* `category: Attraction`
* `targetHeroImage: HeroCityDanangPlaceHoaPhuThanh`
* `pronunciation: hwa foo tahng`
* Closest canonical anchor: **Bà Nà Hills** for commitment-setting without deflation, plus **Bạch Mã National Park** for condition awareness.
* Anchor behavior copied: set the commitment and condition risk before the traveler imagines the outing as a simple stop.
* How this page differs: lighter and wetter than Ba Na; less of a theme-park day, more of a stream-and-transport day.
* Owned traveler moment: arriving for a wet outdoor activity and needing the plan, gear, and return ride to stay simple.

### Phrase/audio IDs

* **Vé bao nhiêu?** — `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* **Điểm gặp ở đâu?** — `intent: ask_meeting_point` · `phraseId: sight-5` · `audioId: sight-5` · `status: mapped`
* **Tôi chụp hình ở đây được không?** — `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`

### Mentioned Here candidates

* None for visible render. No food, dish, or secondary place is named naturally enough in the visible copy.

### Related place candidates

* **Bà Nà Hills** — `relationship: mountain_day_contrast` · `catalogId: danang-ba-na-hills` · `status: check_catalog`
  `displaySubtitle: A bigger, more built-out mountain attraction day.`
  `reason: Useful comparison for commitment and weather planning, but not named in visible copy; render only if related cards can appear without implying the two should be combined.`

### Hidden / planned phrase needs

* **“Có áo phao không?”** — Are there life jackets?
  `intent: ask_life_jackets` · `phraseId: existing_or_null` · `audioId: existing_or_null` · `status: hide_until_audio`
  Reason: useful for rafting/water activities, but not found as ready audio in the current Phrase Picker.

### Freshness notes

* Same-week check needed for current access, ticketing, activity availability, rafting/water conditions, gear rules, weather, and operating status.
* Visible copy avoids exact hours, prices, routes, age/health requirements, and guaranteed activity claims.

### Source notes

* Ledger source notes: Da Nang Fantasticity; venue source.
* Legacy row supports a forested stream recreation area with simple rafting gear.
* Place catalog row exists: `danang-hoa-phu-thanh`.

### Score

27/30 — Clearer and more traveler-useful than legacy, but capped for thin evidence and activity/weather volatility.

### QA notes

* Replaceability test: pass after revision; the water/gear/ride-back moment is specific.
* Phrase card test: pass; 3 reusable ready-audio attraction phrases.
* Mentioned Here test: pass; no forced mentions.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Hồ Hòa Trung / Hoa Trung Lake — Da Nang — Nature

### Reader View

**A Slow Lake Before The Day Gets Loud**

Hòa Trung Lake is the softer side of Da Nang: broad water, grass, low hills, and a morning pace that feels far from beach traffic and bridge photos. Go for quiet minutes and a clean view, not a packed activity list.

### Useful phrase cards

* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Dừng ở đây được rồi.”** — You can stop here.

### Practical sections

**Morning Gives It Shape**

Soft light does most of the work here. The lake can feel plain in harsh midday sun, but early light gives the grassy banks, water, and distant hills a clearer reason to pause.

**Keep The Stop Small**

This is not the place to force a full outing. Take the view, walk only as far as conditions feel easy, and leave before the stop starts asking for more planning than it deserves.

**Pin The Ride Back**

Transport matters more than the lake name. Set the pickup point before wandering, especially if you are using a driver or ride app outside the denser city streets.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-hoa-trung-lake`
* `displayName: Hồ Hòa Trung`
* `englishName: Hoa Trung Lake`
* `city: Da Nang`
* `category: Nature`
* `targetHeroImage: HeroCityDanangPlaceHoaTrungLake`
* `pronunciation: hoh hwa troong`
* Closest canonical anchor: **Lập An Lagoon** for condition-dependent water/nature pacing, with **Vọng Cảnh Hill** for short viewpoint restraint.
* Anchor behavior copied: make timing, light, and route commitment carry the page instead of inflating scenery.
* How this page differs: smaller and quieter than a lagoon route; it owns a short lake pause rather than a seafood or road-trip stop.
* Owned traveler moment: arriving around soft light, taking a short look, and keeping the return ride clear.

### Phrase/audio IDs

* **Tôi chụp hình ở đây được không?** — `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* **Đi bộ mất bao lâu?** — `intent: ask_walking_time` · `phraseId: directions-3` · `audioId: directions-3` · `status: mapped`
* **Dừng ở đây được rồi.** — `intent: ask_driver_to_stop` · `phraseId: taxi-3` · `audioId: taxi-3` · `status: mapped`

### Mentioned Here candidates

* None for visible render. The copy intentionally avoids forcing nearby catalog items.

### Related place candidates

* None for first render.

  * `reason: Related route cards could become misleading without a checked local route plan. Keep this page as a standalone quiet-water pause unless catalog QA wants a broader nature cluster.`

### Freshness notes

* Light verification needed for access, current road/parking approach, lake conditions, safety, and any local restrictions.
* Visible copy avoids exact route instructions, entrance claims, camping/activity claims, and current access guarantees.

### Source notes

* Ledger source notes: Da Nang tourism source; local map.
* Legacy row supports broad lake, grassy banks, distant hills, and soft sunrise.
* Place catalog row exists: `danang-hoa-trung-lake`.

### Score

27/30 — Calm and specific enough for a scarce-evidence nature page; capped for thin evidence and access/condition uncertainty.

### QA notes

* Replaceability test: pass after revision; lake/light/ride-back details make it less generic.
* Phrase card test: pass; 3 reusable ready-audio phrases.
* Mentioned Here test: pass; no forced mentions.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Nhà ga quốc tế Đà Nẵng / Da Nang International Terminal — Da Nang — Airport

### Reader View

**Land, Then Solve The Ride**

Da Nang’s international terminal is a short practical sequence, not a place to multitask. Clear immigration, collect bags, step into the public hall, then sort SIM, cash, hotel driver, or ride-app pickup with space around you.

### Useful phrase cards

* **“Sảnh đến ở đâu?”** — Where is the arrivals hall?
* **“Tôi đã đặt dịch vụ đón tại sân bay.”** — I have an airport pickup booked.
* **“Điểm đón Grab ở đâu?”** — Where is the Grab pickup point?

### Practical sections

**Public Hall Before Pickup**

Do not start solving the car while you are still behind the arrival flow. Immigration, baggage, customs, then the public hall: the airport gets easier once you can see counters, signs, drivers, and exits.

**One Pin, One Door**

Before leaving the hall, open the pickup pin and check the door, column, or outside meeting point. Da Nang is close to the city, but airport exits can split a group quickly.

**Hội An Needs A Clear Car**

If the next stop is Hội An, confirm the driver name, car plate, and hotel area while you still have light, room, and Wi‑Fi. The ride is simple once the car is clearly yours.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-international-terminal`
* `displayName: Nhà ga quốc tế Đà Nẵng`
* `englishName: Da Nang International Terminal`
* `city: Da Nang`
* `category: Airport`
* `targetHeroImage: HeroCityDanangPlaceInternationalTerminal`
* `pronunciation: nyah gah gwok tay dah nang`
* Closest canonical anchor: **airport arrival sequence** from the legacy pilot shape, rewritten away from mechanical voice; secondary behavior from **Perfume River** for sequence/return clarity.
* Anchor behavior copied: turn a practical place into an ordered first-hour sequence.
* How this page differs: it is not a sightseeing place; it owns stress reduction after landing.
* Owned traveler moment: stepping from baggage/customs into the public hall and choosing the right pickup.

### Phrase/audio IDs

* **Sảnh đến ở đâu?** — `intent: ask_arrivals_hall` · `phraseId: v900-airp-bord-arri-where-is-the-arrivals-hall` · `audioId: v900-airp-bord-arri-where-is-the-arrivals-hall` · `status: mapped`
* **Tôi đã đặt dịch vụ đón tại sân bay.** — `intent: say_airport_pickup_booked` · `phraseId: v900-airp-bord-arri-i-have-an-airport-pickup-booked` · `audioId: v900-airp-bord-arri-i-have-an-airport-pickup-booked` · `status: mapped`
* **Điểm đón Grab ở đâu?** — `intent: ask_grab_pickup_point` · `phraseId: v900-airp-bord-arri-where-is-the-grab-pickup-point` · `audioId: v900-airp-bord-arri-where-is-the-grab-pickup-point` · `status: mapped`

### Mentioned Here candidates

* **Hội An** — `type: city/place` · `catalogId: existing_or_null` · `status: check_catalog`
  `displaySubtitle: Common onward stop after landing in Da Nang.`
  `reason: Visible copy names Hội An as an onward transfer context; catalog may prefer a city-level target or the Da Nang Airport for Hoi An page.`

### Related place candidates

* **Da Nang Airport for Hoi An** — `relationship: onward_transfer_context` · `catalogId: hoian-from-danang-airport` · `status: render`
  `displaySubtitle: For travelers landing in Da Nang and continuing to Hội An.`
  `reason: Directly supported by the Hội An transfer section.`

* **Da Nang Domestic Terminal** — `relationship: terminal_contrast` · `catalogId: danang-domestic-terminal` · `status: check_catalog`
  `displaySubtitle: The other terminal to confirm if your flight is domestic.`
  `reason: Useful airport contrast, but not named in visible copy; render only if terminal-switch UX needs it.`

### Freshness notes

* Light/same-week check needed for terminal signage, pickup-point names, Grab/taxi routing, SIM/ATM counter availability, and any airport access changes.
* Visible copy avoids exact pickup door numbers, counter locations, transport prices, and current airport policy claims.
* Existing row notes that the 2026-05-24 pilot was mechanically/native validated but voice rejected; this is a rewrite, not production approval.

### Source notes

* Ledger source notes: Airport and transport sources.
* Legacy row supports immigration, baggage, SIM, cash, pickup doors, and ride into the city as the first practical hour.
* Place catalog row exists: `danang-international-terminal`.
* Related catalog rows found for `danang-domestic-terminal`, `danang-airport`, and `hoian-from-danang-airport`.

### Score

28/30 — Strong arrival-sequence rewrite with mapped airport audio; capped for pickup/signage freshness and no rendered screenshot proof.

### QA notes

* Replaceability test: pass; specific to Da Nang arrival flow and Hội An onward transfer.
* Phrase card test: pass; 3 ready-audio airport phrases.
* Mentioned Here test: pass; Hội An evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Kem bơ ở Đà Nẵng / Avocado ice cream — Da Nang — Dessert

### Reader View

**Green, Cold, Done In Ten Minutes**

Kem bơ is a small Da Nang sweetness break: avocado cream, ice cream, condensed milk, maybe coconut, spoonable and colder than a smoothie. It fits best between bigger plans, when you want texture and a sit-down minute more than another meal.

### Useful phrase cards

* **“Cái này bao nhiêu?”** — How much is this?
* **“Cho tôi một phần.”** — One portion, please.
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Practical sections

**Texture Is The Point**

Do not expect savory avocado. The pleasure is cold, thick, green, and sweet, with the avocado making the cup feel richer than fruit juice or shaved ice.

**Small First, Sweet Enough**

One cup is usually the right first move. Add another dessert only after you know how sweet and heavy this shop makes it.

**Best After Salt Or Heat**

Kem bơ works as a reset after seafood, a market lap, or a hot ride back from the beach side of the city. Keep it short and let the cold do the work.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-kem-bo`
* `displayName: Kem bơ ở Đà Nẵng`
* `englishName: Avocado ice cream`
* `city: Da Nang`
* `category: Dessert`
* `targetHeroImage: HeroCityDanangPlaceKemBo`
* `pronunciation: kem buh uh dah nang`
* Closest canonical anchor: **Chợ Bắc Mỹ An** for narrowing kem bơ into a small snack decision, plus café/ritual examples for short pause behavior.
* Anchor behavior copied: keep the food page small, tactile, and ordering-focused instead of writing a broad dessert guide.
* How this page differs: this is the dessert item itself, not a market page.
* Owned traveler moment: taking a short cold dessert pause between bigger Da Nang plans.

### Phrase/audio IDs

* **Cái này bao nhiêu?** — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* **Cho tôi một phần.** — `intent: order_one_portion_while_pointing` · `phraseId: food-1` · `audioId: food-1` · `status: mapped`
* **Tính tiền giúp tôi.** — `intent: pay_now` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`

### Mentioned Here candidates

* **Kem bơ** — `type: food` · `catalogId: food-kem-bo` · `status: render`
  `displaySubtitle: Cold avocado cream with ice cream, condensed milk, and optional coconut.`
  `reason: Menu Catalog row exists for food-kem-bo; visible copy is directly about the catalog item.`

* **Hải sản ở Đà Nẵng** — `type: food/dish` · `catalogId: danang-hai-san` · `status: check_catalog`
  `displaySubtitle: A salty meal that makes a cold dessert pause make sense.`
  `reason: Visible copy mentions seafood only as a timing context, not as the page subject.`

### Related place candidates

* **Chợ Bắc Mỹ An** — `relationship: snack_market_context` · `catalogId: danang-bac-my-an-market` · `status: check_catalog`
  `displaySubtitle: A smaller snack-market context often associated with kem bơ planning.`
  `reason: Canonical anchor links kem bơ to the Bắc Mỹ An snack-stop pattern, but render should avoid promising current stall availability without verification.`

### Hidden / planned phrase needs

* **“Cho tôi một ly kem bơ.”** — I’d like one glass of avocado ice cream.
  `intent: order_kem_bo` · `phraseId: food-kem-bo/menu_quick_say` · `audioId: existing_or_null` · `status: hide_until_audio`
  Reason: Menu Catalog quick-say exists, but order-line audio policy is text-only; not used as a visible phrase card.

### Freshness notes

* Light verification needed for exact shop/stall availability, current toppings, sweetness adjustment, pricing, and whether “ly” or cup/bowl wording is preferred in the final UI.
* Visible copy avoids naming a specific vendor, hours, price, or guaranteed toppings beyond menu-catalog ingredients.

### Source notes

* Ledger source notes: Da Nang local food sources.
* Menu Catalog row exists: `food-kem-bo`, category Desserts & sweets; describes kem bơ as avocado ice cream or avocado cream with avocado, ice cream, condensed milk, and optional coconut.
* Place catalog row exists: `danang-kem-bo`.

### Score

28/30 — Strong sensory food page with catalog support and mapped reusable phrase cards; capped for text-only dish-specific audio and vendor/topping freshness.

### QA notes

* Replaceability test: pass; texture, avocado/sweetness, and short cold pause are specific.
* Phrase card test: pass for visible cards; dish-specific order line hidden until audio.
* Mentioned Here test: pass; food-kem-bo evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch QA pass

* Phrase cards kept to 2–3 visible cards per listing.
* Visible phrase cards use reusable ready-audio traveler actions only.
* Place-name pronunciation is treated as name support, not visible phrase-card content.
* No visible copy starts with the banned scaffolds from the batch prompt.
* Headings are varied; no repeated “Let…,” “Start with…,” “Good when…,” “Still worth…,” or “works best” scaffold.
* Current venue facts, pricing, hours, activity availability, airport pickup locations, and menu/stall volatility are kept in internal freshness notes.
* Public URLs omitted from the batch body; source labels and file citations are used for review context only.
* Status remains draft material for Jojo review, not production-ready.

---

## Codex handoff block

* `batch_id: batch_019`
* `page_ids: city-danang-place-helio-night-market, city-danang-place-hoa-phu-thanh, city-danang-place-hoa-trung-lake, city-danang-place-international-terminal, city-danang-place-kem-bo`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible mapped cards; hidden/planned only: Hoa Phu Thanh life-jacket/safety phrase, Kem bơ dish-specific order line from Menu Catalog text-only policy`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: Hoa Phu Thanh and Hoa Trung Lake are restrained because evidence is thin; International Terminal avoids exact pickup points; Kem bơ avoids vendor-specific claims; Helio avoids current programming claims`
* `source_freshness_risks: Helio hours/events/stall mix/prices/payment norms; Hoa Phu Thanh access/activity availability/weather/gear rules; Hoa Trung Lake access/road/lake conditions; International Terminal signage/pickup/SIM/ATM/transport flow; Kem bơ vendor availability/toppings/prices/sweetness adjustment`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
