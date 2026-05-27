SpeakLocal v2.2 BATCH_003 RECOVERY - Da Nang A - 2026-05-26

Source context checked: exact recovery constraints and five-row batch list, v2.2 voice/contract guidance, app display order, phrase-card rules, and the Da Nang place/phrase catalog rows.      

## Sân bay Đà Nẵng / Da Nang Airport — Da Nang — Airport

### Reader View

**The First Road Into Đà Nẵng**

Đà Nẵng starts before the beach. It starts at sliding doors, luggage wheels, humidity, signs, and the small decision of where to meet your ride without drifting into the wrong curb lane.

### Useful phrase cards

* **“Khu đón ở đâu?”** — Where is the pickup area?
* **“Tôi gặp tài xế ở đâu?”** — Where do I meet the driver?
* **“Đi vào trung tâm thành phố mất bao lâu?”** — How long does it take to get downtown?

### Practical sections

**Find The Pickup Before The Coffee**

After baggage, solve the ride handoff first. The airport feels manageable, but tired travelers lose time when they leave the hall before knowing which pickup area they need.

**Domestic Or International Matters**

Check which terminal your flight uses before giving directions to a driver or meeting someone. The local name, Sân bay Đà Nẵng, helps with recognition; the terminal does the practical work.

**Let The City Arrive Slowly**

The first drive gives you a quick read on the city: road heat, river bridges, hotel blocks, and beach-side traffic. Keep the first stop simple until you know how tired everyone is.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-airport`
* `displayName: Sân bay Đà Nẵng`
* `englishName: Da Nang Airport`
* `city: Đà Nẵng`
* `category: Airport`
* `pronunciation: sun bay da nang`
* `targetHeroImage: HeroCityDanangPlaceAirport`
* **Closest canonical anchor:** Dragon Bridge / Cầu Rồng — simple place, one real decision.
* **Anchor behavior copied:** Turn a familiar location into the first practical choice: where to stand / where to meet / what to do first.
* **How this page differs:** Airport page owns arrival sequencing, not sightseeing.
* **Owned traveler moment:** Arrival doors → baggage → pickup-zone decision → first road into the city.
* **Phrase/audio status:**

  * `airport-5` · `audioId: airport-5` · `status: mapped` · ready audio.
  * `airport-pickup-clearer` · `audioId: airport-pickup-clearer` · `status: mapped` · ready audio.
  * `v900-airp-bord-arri-how-long-does-it-take-to-get-downtown` · `audioId: v900-airp-bord-arri-how-long-does-it-take-to-get-downtown` · `status: mapped` · ready audio.
* **Place-name phrase:** `city-danang-place-airport` has ready audio; pronunciation/name support only, not a visible phrase card.
* **Mentioned Here candidates:**

  * None for render. The page itself should not render as its own Mentioned Here card.
* **Related place candidates:**

  * **Da Nang Domestic Terminal** — `catalogId: danang-domestic-terminal` · `relationship: airport_terminal_choice` · `status: render`

    * `displaySubtitle: Check the terminal before arranging pickup.`
    * `reason: Terminal choice is named in visible copy and changes the arrival handoff.`
  * **Da Nang International Terminal** — `catalogId: danang-international-terminal` · `relationship: airport_terminal_choice` · `status: render`

    * `displaySubtitle: Useful when arrival signs split by terminal.`
    * `reason: Terminal choice is named in visible copy and affects pickup/rides.`
* **Verification flags:**

  * `type: light` · `reason: Pickup-zone signage, rideshare pickup behavior, and terminal flow can change.` · `blocking: false`
  * `type: audio_qa` · `reason: Phrase IDs are ready-audio rows; Codex should still confirm final runtime mapping.` · `blocking: false`
* **Source notes:**

  * Row source labels: City library; Vietnam Tourism Da Nang.
  * Spreadsheet confirms catalog rows for Da Nang Airport, Domestic Terminal, and International Terminal.
  * No hours, taxi prices, airport rankings, or pickup-point promises are rendered.
* **Freshness notes:**

  * Same-week operational check recommended only if Codex adds pickup maps, terminal-specific instructions, parking details, taxi counter names, or rideshare claims.
* **Score:** 28/30 — clear arrival moment and reusable phrases; capped for airport-flow freshness and no rendered screenshot proof.
* **QA notes:**

  * Replaceability test: pass.
  * Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
  * Mentioned Here test: pass; self-card avoided.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: not_run.
  * Production review gate: not_run.

---

## Khu An Thượng / An Thuong Area — Da Nang — Neighborhood

### Reader View

**Pick A Lane Before Dinner**

An Thuong is beach-side Đà Nẵng at street level: cafe signs, small restaurants, scooters easing between hotel fronts, and visitors deciding whether this is dinner, a drink, or just a walk.

### Useful phrase cards

* **“Tôi chỉ xem thôi.”** — I’m just looking.
* **“Bạn gợi ý gì ở đây?”** — What do you recommend here?
* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?

### Practical sections

**Beach Nearby, Neighborhood First**

The sea is part of the mood, but the better read is the low-rise grid behind it. Walk one short lane, notice where the light and crowd feel comfortable, then choose one stop.

**One Stop Keeps It Better**

An Thuong can blur if you treat every cafe and bar as equal. Choose coffee, dinner, dessert, or a quiet drink first, then let the next corner decide.

**Evening Shows The Shape**

Daytime can feel like hotel edges and parked scooters. After dark, signs, lanterns, and small terraces make the area easier to read, especially if you are staying near Mỹ An or Mỹ Khê.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-an-thuong-street-area`
* `displayName: Khu An Thượng`
* `englishName: An Thuong Area`
* `city: Đà Nẵng`
* `category: Neighborhood`
* `pronunciation: khu an thuong`
* `targetHeroImage: HeroCityDanangPlaceAnThuongStreetArea`
* **Closest canonical anchor:** Japan Town Saigon — cluster-neighborhood entry.
* **Anchor behavior copied:** Choose one first lane or stop instead of making a broad neighborhood feel like a checklist.
* **How this page differs:** An Thuong is softer, beach-side, and lower-friction; the risk is drift, not adult-oriented door-reading.
* **Owned traveler moment:** Evening walk from beach-side hotel edge into a cafe/restaurant lane.
* **Phrase/audio status:**

  * `shop-4` · `audioId: shop-4` · `status: mapped` · ready audio.
  * `social-9` · `audioId: social-9` · `status: mapped` · ready audio.
  * `v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped` · ready audio.
* **Place-name phrase:** `city-danang-place-an-thuong-street-area` is planned/no ready audio; pronunciation/name support should hide until audio.
* **Mentioned Here candidates:**

  * **Mỹ An** — `type: neighborhood` · `catalogId: danang-my-an` · `status: render`

    * `displaySubtitle: Beach-side neighborhood context near An Thuong.`
    * `reason: Named naturally in the evening section.`
  * **My Khe Beach** — `type: beach` · `catalogId: danang-my-khe-beach` · `status: render`

    * `displaySubtitle: The main beach reference near this side of Đà Nẵng.`
    * `reason: Mỹ Khê is named naturally as stay-area context.`
* **Related place candidates:**

  * **Bac My An Market** — `catalogId: danang-bac-my-an-market` · `relationship: nearby_snack_contrast` · `status: render`

    * `displaySubtitle: A smaller snack stop near the beach-side grid.`
    * `reason: Useful nearby contrast for a food/snack move, but not forced into visible copy.`
  * **My An Beach** — `catalogId: danang-my-an-beach` · `relationship: nearby_beach_pairing` · `status: render`

    * `displaySubtitle: A quieter beach-side reference near Mỹ An.`
    * `reason: Helps route the neighborhood page with beach context.`
* **Verification flags:**

  * `type: light` · `reason: Business mix, open venues, and evening character can shift.` · `blocking: false`
  * `type: catalog_qa` · `reason: Confirm whether Mỹ Khê should map to My Khe Beach or broader beach-side place context.` · `blocking: false`
* **Source notes:**

  * Row source labels: Da Nang Fantasticity; local map.
  * Claims are intentionally restrained: no named restaurants, bars, hours, street program, or venue count.
* **Freshness notes:**

  * Business turnover and construction/hotel frontage changes should be checked before adding specific venues.
* **Score:** 27/30 — useful and place-specific for sparse evidence; first screen revised once from a broader “beach-side pocket” opening to the more physical lane/dinner moment.
* **QA notes:**

  * Replaceability test: pass.
  * Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
  * Mentioned Here test: pass.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: not_run.
  * Production review gate: not_run.

---

## Công viên APEC / APEC Park — Da Nang — Park

### Reader View

**A Breather On The Hàn River**

APEC Park gives central Đà Nẵng an easy pause beside the Hàn River: open walkway, families lingering, shade, river light, and the curving canopy that makes the stop feel more deliberate than a random bench.

### Useful phrase cards

* **“Tôi có thể ngồi đây được không?”** — Can I sit here?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?

### Practical sections

**Between Bigger Stops**

This is not a place to over-plan. It sits best between museum time, river walking, coffee, or a bridge photo, when everyone needs air without leaving the center.

**The Canopy Carries The Stop**

Look for the lifted, curved structure first. Once you have it, the rest is simple: walk, sit, photograph lightly, and keep moving when the light flattens.

**Better At Soft Light**

Midday can be hard and bright. Late afternoon gives the river, trees, and open pavement a gentler edge, and the park can feel worthwhile even if you only stay ten minutes.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-apec-park`
* `displayName: Công viên APEC`
* `englishName: APEC Park`
* `city: Đà Nẵng`
* `category: Park`
* `pronunciation: kohng vee-en apec`
* `targetHeroImage: HeroCityDanangPlaceApecPark`
* **Closest canonical anchor:** Dragon Bridge / Cầu Rồng — simple riverfront place with one real use choice.
* **Anchor behavior copied:** Make the page about how to stand, pause, and pair the stop instead of describing the object abstractly.
* **How this page differs:** APEC Park is lower commitment and more everyday than a major landmark.
* **Owned traveler moment:** Afternoon river walk pause under/near the canopy before continuing.
* **Phrase/audio status:**

  * `v900-poli-basi-can-i-sit-here` · `audioId: v900-poli-basi-can-i-sit-here` · `status: mapped` · ready audio.
  * `sight-3` · `audioId: sight-3` · `status: mapped` · ready audio.
  * `directions-3` · `audioId: directions-3` · `status: mapped` · ready audio.
* **Place-name phrase:** `city-danang-place-apec-park` has ready audio; pronunciation/name support only, not a visible phrase card.
* **Mentioned Here candidates:**

  * **Han River** — `type: river` · `catalogId: danang-han-river` · `status: render`

    * `displaySubtitle: The riverfront context that makes the park make sense.`
    * `reason: Hàn River is named naturally in the intro.`
* **Related place candidates:**

  * **Dragon Bridge** — `catalogId: danang-dragon-bridge` · `relationship: nearby_riverfront_pairing` · `status: render`

    * `displaySubtitle: A stronger landmark stop nearby on the river.`
    * `reason: Bridge-photo language appears in visible copy; useful route pairing.`
  * **Bach Dang Street** — `catalogId: danang-bach-dang-street` · `relationship: river_walk_pairing` · `status: render`

    * `displaySubtitle: A practical riverfront walking spine.`
    * `reason: Supports the river-walk behavior without forcing it into visible copy.`
* **Verification flags:**

  * `type: light` · `reason: Park access, events, and surrounding construction can change.` · `blocking: false`
  * `type: audio_qa` · `reason: Phrase rows ready; Codex should verify final audio IDs in runtime.` · `blocking: false`
* **Source notes:**

  * Row source labels: City library; Da Nang Fantasticity.
  * Visible copy uses stable physical cues from the row: riverside public park, curving canopy, open walkway, afternoon light.
* **Freshness notes:**

  * Recheck only if adding events, exact entrances, parking, lighting, nearby road closures, or photo-policy claims.
* **Score:** 28/30 — calm, specific, and short; capped for park/current-condition freshness and no screenshot proof.
* **QA notes:**

  * Replaceability test: pass.
  * Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
  * Mentioned Here test: pass.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: not_run.
  * Production review gate: not_run.

---

## Công viên Châu Á / Asia Park — Da Nang — Park

### Reader View

**A Night-Out Park, Not A Quiet One**

Asia Park belongs to Đà Nẵng after dark: bright paths, snack stops, families walking slowly, and the Sun Wheel lifting above the skyline. Come for the city’s modern leisure mood, not shade or silence.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Mấy giờ đóng cửa?”** — What time does it close?
* **“Bắt đầu ở đâu?”** — Where do we start?

### Practical sections

**Check The Gate First**

The park can shift by season and programming, so make the entrance your first read. If rides are the reason, confirm what is open before you buy or linger.

**Food And Lights Carry The Evening**

Even without making every ride the point, the park can work as an easy evening scene: lights, snacks, open paths, and a family crowd that feels different from the beach strip.

**Different From A Market Night**

If dinner matters more than rides and lights, Helio is the easier food-first choice. Asia Park makes more sense when the park setting is the reason.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-asia-park`
* `displayName: Công viên Châu Á`
* `englishName: Asia Park`
* `city: Đà Nẵng`
* `category: Park`
* `pronunciation: kohng vee-en chau a`
* `targetHeroImage: HeroCityDanangPlaceAsiaPark`
* **Closest canonical anchor:** Ba Na Hills / Bà Nà Hills — expectation-setting without deflation.
* **Anchor behavior copied:** Name the real category and commitment, then keep the still-enjoyable reason.
* **How this page differs:** Asia Park is urban, night-oriented, and easier to treat as a shorter evening than Ba Na Hills.
* **Owned traveler moment:** Arriving after dark, checking the gate, then deciding whether the evening is rides, snacks, lights, or a short walk.
* **Phrase/audio status:**

  * `sight-1` · `audioId: sight-1` · `status: mapped` · ready audio.
  * `sight-4` · `audioId: sight-4` · `status: mapped` · ready audio.
  * `sight-2` · `audioId: sight-2` · `status: mapped` · ready audio.
* **Place-name phrase:** `city-danang-place-asia-park` has ready audio; pronunciation/name support only, not a visible phrase card.
* **Mentioned Here candidates:**

  * **Sun Wheel** — `type: landmark` · `catalogId: null` · `status: check_catalog`

    * `displaySubtitle: Skyline marker inside/around Asia Park.`
    * `reason: Named naturally in intro; no matching catalog row found in the current City Places Catalog parse.`
  * **Helio Night Market** — `type: market` · `catalogId: danang-helio-night-market` · `status: render`

    * `displaySubtitle: A more food-first evening nearby.`
    * `reason: Named naturally in the market-night contrast section.`
* **Related place candidates:**

  * **Helio Night Market** — `catalogId: danang-helio-night-market` · `relationship: evening_food_contrast` · `status: render`

    * `displaySubtitle: Better when the night is mainly about food and seating.`
    * `reason: Direct comparison appears in visible copy.`
  * **Son Tra Night Market** — `catalogId: danang-son-tra-night-market` · `relationship: evening_market_contrast` · `status: render`

    * `displaySubtitle: Riverfront snack-and-walk alternative near Dragon Bridge.`
    * `reason: Useful comparison for night planning; not forced into visible copy.`
* **Verification flags:**

  * `type: same_week` · `reason: Operating days, ride availability, ticketing, Sun Wheel status, food stalls, and closing time can materially change the visit.` · `blocking: false`
  * `type: catalog_qa` · `reason: Sun Wheel needs catalog decision before rendering as a card.` · `blocking: false`
* **Source notes:**

  * Row source labels: City library; Da Nang Fantasticity.
  * Visible copy keeps operations soft and avoids fixed hours, ticket prices, ride list, and current-event claims.
  * Menu Catalog not used; no specific food item is named.
* **Freshness notes:**

  * Same-week check required before any import that implies active rides, current Sun Wheel access, exact hours, ticket pricing, or food-stall availability.
* **Score:** 28/30 — strong expectation-setting and current-risk control; capped for same-week operations and Sun Wheel catalog uncertainty.
* **QA notes:**

  * Replaceability test: pass.
  * Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
  * Mentioned Here test: pass; Sun Wheel marked check_catalog.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: not_run.
  * Production review gate: not_run.

---

## Cáp treo Bà Nà / Ba Na cable car — Da Nang — Experience

### Reader View

**The Climb Is The Moment**

The Ba Na cable car is not just the way up. It is the shift from Đà Nẵng heat into forest, mist, cooler air, and a much bigger production on the mountain.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Điểm gặp ở đâu?”** — Where is the meeting point?
* **“Mấy giờ đóng cửa?”** — What time does it close?

### Practical sections

**Boarding Comes Before The View**

Find the right line and meeting point before chasing photos. The ride feels better when ticket, group, and return timing are clear early.

**Weather Changes The Whole Ride**

Cloud can make the climb moody or hide the view completely. If the Golden Bridge is the main reason you are going, the forecast matters before you leave Đà Nẵng.

**Bigger Than A Quick Detour**

The cable car leads into Ba Na Hills, not a small lookout. Give the day enough space for the ride up, the top, and the ride down without stacking too many city stops around it. When the clouds open, the cabin over dense green forest can still feel cinematic.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-ba-na-cable-car`
* `displayName: Cáp treo Bà Nà`
* `englishName: Ba Na cable car`
* `city: Đà Nẵng`
* `category: Experience`
* `pronunciation: cap treo ba na`
* `targetHeroImage: HeroCityDanangPlaceBaNaCableCar`
* **Closest canonical anchor:** Ba Na Hills / Bà Nà Hills — expectation-setting without deflation.
* **Anchor behavior copied:** Protect the traveler from wrong expectations while keeping the cinematic payoff.
* **How this page differs:** This page owns the ride sequence itself, not the whole mountaintop park.
* **Owned traveler moment:** Ticket/line/meeting-point clarity before boarding, then the forest-and-mist climb.
* **Phrase/audio status:**

  * `sight-1` · `audioId: sight-1` · `status: mapped` · ready audio.
  * `sight-5` · `audioId: sight-5` · `status: mapped` · ready audio.
  * `sight-4` · `audioId: sight-4` · `status: mapped` · ready audio.
* **Place-name phrase:** `city-danang-place-ba-na-cable-car` is planned/no ready audio; hide until audio for pronunciation/name support.
* **Mentioned Here candidates:**

  * **Golden Bridge** — `type: landmark` · `catalogId: danang-golden-bridge` · `status: render`

    * `displaySubtitle: The famous bridge many travelers prioritize above the clouds.`
    * `reason: Named naturally in the weather section.`
  * **Ba Na Hills** — `type: landmark` · `catalogId: danang-ba-na-hills` · `status: render`

    * `displaySubtitle: The larger mountain complex reached by the cable car.`
    * `reason: Named naturally in the detour/commitment section.`
* **Related place candidates:**

  * **Ba Na Hills** — `catalogId: danang-ba-na-hills` · `relationship: parent_experience` · `status: render`

    * `displaySubtitle: The full mountain park around the cable-car ride.`
    * `reason: The cable car page should route to the broader Ba Na Hills listing.`
  * **Golden Bridge** — `catalogId: danang-golden-bridge` · `relationship: priority_stop_after_ride` · `status: render`

    * `displaySubtitle: The bridge many travelers do first after arriving above.`
    * `reason: Weather/priority logic appears in visible copy.`
* **Verification flags:**

  * `type: same_week` · `reason: Cable-car operation, ticketing, queue flow, park hours, meeting points, weather, and Golden Bridge access can materially affect the visit.` · `blocking: false`
  * `type: audio_qa` · `reason: Visible phrases are mapped to ready sightseeing audio; place-name phrase is planned and should not render as a phrase card.` · `blocking: false`
* **Source notes:**

  * Row source labels: Vietnam Tourism Da Nang; Da Nang Fantasticity.
  * Canonical Ba Na Hills guidance supports expectation-setting around cable cars, cooler air, crowds, weather, Golden Bridge, and half-day commitment.
  * Visible copy avoids current ticket prices, exact cable-car line names, hours, wait times, or active operations.
* **Freshness notes:**

  * Same-week check required before rendering any operational specifics or if the hero/route copy implies a particular station, line, ticket class, schedule, or access route.
* **Score:** 29/30 — strong owned moment and tight expectation-setting; capped for same-week operations/weather and no rendered screenshot proof.
* **QA notes:**

  * Replaceability test: pass.
  * Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
  * Mentioned Here test: pass.
  * Catalog mention scan: pass.
  * Duplicate body test: pass.
  * Anti-cynicism test: pass.
  * Screenshot review status: not_run.
  * Production review gate: not_run.

---

## Batch-level QA notes

* All five requested page IDs are included; no replacements chosen.
* Visible phrase cards are limited to 2–3 per page and use reusable traveler-action phrases with ready audio.
* Place-name audio is treated as pronunciation/name support, not visible phrase-card content.
* No visible copy uses the banned phrases called out in the recovery prompt.
* Menu Catalog was not used for rendered food cards; the batch does not name specific dishes.
* Reader View copy is draft material for Jojo review only; import waits on voice approval and Codex mapping/validation.

## Codex handoff block

* `batch_id: batch_003`
* `page_ids: city-danang-place-airport, city-danang-place-an-thuong-street-area, city-danang-place-apec-park, city-danang-place-asia-park, city-danang-place-ba-na-cable-car`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none; all visible phrase cards are mapped to ready-audio reusable traveler-action phrases`
* `place_name_phrases: city-danang-place-airport ready pronunciation/name support only; city-danang-place-an-thuong-street-area planned hide_until_audio; city-danang-place-apec-park ready pronunciation/name support only; city-danang-place-asia-park ready pronunciation/name support only; city-danang-place-ba-na-cable-car planned hide_until_audio`
* `visible_copy_risks: An Thuong evidence is sparse and intentionally restrained; Asia Park avoids fixed operation claims but still needs same-week operations review; Ba Na cable car weather/operations affect traveler value; no visible hours, prices, ticket rules, schedules, parking, payment, or queue claims`
* `source_freshness_risks: airport pickup/terminal flow, An Thuong business mix, APEC Park events/access, Asia Park ride/Sun Wheel/opening status, Ba Na cable-car operations/weather/ticketing/meeting points`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
