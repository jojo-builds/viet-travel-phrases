SpeakLocal v2.2 BATCH_009 - Hoi An A - 2026-05-26

Source basis read: Batch 009 prompt, Project Instructions, Source Bundle, New Chat Prompt, and Copy Ledger/Catalog tabs.    

Status: draft for Jojo voice review. Not ready for import.

---

## 1. Biển An Bàng / An Bang Beach — Hoi An — Beach

### Reader View

**Trade The Lanes For Sea Air**

An Bang is the easy coast break after Hoi An’s old streets: open sand, basket boats, seafood places, and enough breeze to make the day feel less packed.

### Useful phrase cards

* **“Biển An Bàng”** — An Bang Beach
* **“Cái này bao nhiêu?”** — How much is this?
* **“Tôi cần kem chống nắng.”** — I need sunscreen.

### Sections

**Go Early If The Beach Is The Point**

Morning keeps the stop simple: a swim, a walk, a shaded seat, then lunch if the coast is still holding you. Later in the day, it can feel more like a seafood-and-sunset pause.

**Settle Before You Order**

Choose your chair or table before the meal takes over. If a seat, drink, or seafood plate is unclear, ask the price first and keep the first order modest.

**Leave The Schedule Loose**

An Bang works best when it changes the pace of the day. Sand, sunscreen, sandals, and a flexible ride back matter more than trying to make it a landmark stop.

### Implementation notes

**contentContract:** `speaklocal.place.app-detail.v2.2`
**page_id:** `city-hoian-place-an-bang`
**displayName:** `Biển An Bàng`
**englishName:** `An Bang Beach`
**city:** `Hoi An`
**category:** `beach`
**pronunciation:** `byen an bang`
**target_hero_image:** `HeroCityHoianPlaceAnBangBeach`

**Closest canonical anchor:** Lập An Lagoon / Đầm Lập An
**Anchor behavior copied:** water place as a condition-and-pacing choice, not a checklist stop.
**How this page differs:** An Bang is easier and closer to Hoi An’s old core; the page owns the shift from heritage lanes to open coast.
**Owned traveler moment:** leaving Ancient Town heat/crowds for a beach seat and slower lunch.

### Phrase/audio status

* **“Biển An Bàng”** — `intent: recognize_place_name` · `phraseId: city-hoian-place-an-bang` · `audioId: audio-authored-bien-an-bang-75a08f8df0` · `status: mapped`
* **“Cái này bao nhiêu?”** — `intent: ask_price` · `phraseId: price-1` · `audioId: price-1` · `status: mapped`
* **“Tôi cần kem chống nắng.”** — `intent: need_sunscreen` · `phraseId: v900-heal-phar-i-need-sunscreen` · `audioId: v900-heal-phar-i-need-sunscreen` · `status: mapped`

### Mentioned Here candidates

* **Hoi An Ancient Town** — `type: neighborhood` · `catalogId: hoian-ancient-town` · `status: render`
  `sourceText: old streets`
  `displaySubtitle: The heritage core An Bang gives you a break from.`
  `reason: The copy contrasts the beach with Hoi An’s old streets.`

### Related place candidates

* **Hoi An Ancient Town** — `relationship: pace_contrast` · `catalogId: hoian-ancient-town` · `status: render`
  `displaySubtitle: Pair the old streets with a sea-air break.`
  `reason: Direct planning contrast between old-town wandering and the beach pause.`

* **Cam Thanh basket boat** — `relationship: coastal_water_contrast` · `catalogId: hoian-cam-thanh-basket-boat` · `status: check_catalog`
  `displaySubtitle: A working-water contrast to An Bang’s beach pause.`
  `reason: Basket boats are visible in beach context, but the specific Cam Thanh experience should not be implied unless catalog QA wants this route link.`

### Verification flags

* `type: light`
  `reason: Beach chair pricing, seafood venue availability, sea conditions, and vendor setup can change; visible copy avoids fixed hours, prices, and rules.`
  `blocking: false`

* `type: audio_qa`
  `reason: Rendered phrase cards use ready audio; confirm no long-row wrapping issue for the sunscreen phrase.`
  `blocking: false`

* `type: catalog_qa`
  `reason: Confirm whether Cam Thanh basket boat should remain related or be removed to avoid implying it is at An Bang.`
  `blocking: false`

### Source notes

* Exact batch row source notes: Existing city-library; Vietnam Tourism Hoi An.
* Legacy copy supplies the durable scene: sand, basket boats, seafood places, sun beds, morning light, and contrast with Ancient Town.
* No current venue/vendor facts added.

### Score

28/30 — Strong, concrete beach-pause draft. Capped for light freshness checks around beach setup, seafood venues, and the Cam Thanh basket-boat relation.

### QA notes

* Replaceability test: pass. The old-town-to-beach shift, basket boats, seafood places, and beach-seat decision keep it specific to An Bang.
* Phrase card test: pass. Three ready-audio cards; no unsupported one-off phrase.
* Mentioned Here test: pass. Ancient Town evaluated; Cam Thanh held for catalog QA rather than forced.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Đảo An Hội / An Hoi Island — Hoi An — Neighborhood

### Reader View

**Cross Over Before Choosing A Seat**

An Hoi Island sits just across the river from the old streets. It is where the evening loosens into lantern light, small shops, hotel edges, and a slower riverside walk.

### Useful phrase cards

* **“Đảo An Hội”** — An Hoi Island
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Tôi chỉ xem thôi.”** — I’m just looking.

### Sections

**Let The River Orient You**

Start by finding the water again. Once you know which side faces the old town, the island feels less like a maze of lights and more like a small evening loop.

**Step Back From The Brightest Edge**

The riverside is the easy first look, but one lane back can be calmer. That is often where the walk starts to feel like a neighborhood instead of only a photo line.

**Know Your Way Back**

Before sitting down, keep the bridge or pickup point in mind. An Hoi is still worth the evening pause, but it is easier when the return does not become the last decision of the night.

### Implementation notes

**contentContract:** `speaklocal.place.app-detail.v2.2`
**page_id:** `city-hoian-place-an-hoi-island`
**displayName:** `Đảo An Hội`
**englishName:** `An Hoi Island`
**city:** `Hoi An`
**category:** `neighborhood`
**pronunciation:** `dao an hoy`
**target_hero_image:** `HeroCityHoianPlaceAnHoiIsland`

**Closest canonical anchor:** Japan Town Saigon
**Anchor behavior copied:** a cluster-neighborhood entry needs one first move, then a read of doors, lanes, and evening rhythm.
**How this page differs:** An Hoi is gentler and river-shaped; the useful move is crossing, orienting, and keeping the return leg clear.
**Owned traveler moment:** crossing from the old streets into the lantern-lit island before choosing where to sit.

### Phrase/audio status

* **“Đảo An Hội”** — `intent: recognize_place_name` · `phraseId: city-hoian-place-an-hoi-island` · `audioId: audio-authored-dao-an-hoi-caf3fa03f4` · `status: mapped`
* **“Đi bộ mất bao lâu?”** — `intent: ask_walking_time` · `phraseId: directions-3` · `audioId: directions-3` · `status: mapped`
* **“Tôi chỉ xem thôi.”** — `intent: decline_vendor_pressure_softly` · `phraseId: shop-4` · `audioId: shop-4` · `status: mapped`

### Mentioned Here candidates

* **Hoi An Ancient Town** — `type: neighborhood` · `catalogId: hoian-ancient-town` · `status: render`
  `sourceText: old streets`
  `displaySubtitle: The old core just across the water.`
  `reason: The copy positions An Hoi as an evening contrast to the old streets.`

* **Hoai River** — `type: river` · `catalogId: hoian-hoai-river` · `status: check_catalog`
  `sourceText: river`
  `displaySubtitle: The waterline that shapes the island walk.`
  `reason: The visible copy says river generically; catalog QA should decide whether to render Hoai River or keep it unlinked.`

### Related place candidates

* **An Hoi Bridge** — `relationship: crossing_point` · `catalogId: hoian-an-hoi-bridge` · `status: render`
  `displaySubtitle: The simple crossing that makes the island easy to place.`
  `reason: The route behavior depends on crossing and returning clearly.`

* **Bach Dang Street** — `relationship: riverfront_pairing` · `catalogId: hoian-bach-dang-street` · `status: render`
  `displaySubtitle: Walk the old-town river edge before or after crossing.`
  `reason: Useful adjacent riverfront route pairing.`

* **Hoi An Night Market** — `relationship: evening_pairing` · `catalogId: hoian-night-market` · `status: check_catalog`
  `displaySubtitle: A nearby evening add-on if the night is already centered here.`
  `reason: An Hoi often functions as an evening area, but visible copy does not name the market; render only if catalog QA wants this route card.`

### Verification flags

* `type: light`
  `reason: Business mix, lighting, crowd pattern, and night-market adjacency can change; visible copy stays general.`
  `blocking: false`

* `type: catalog_qa`
  `reason: Confirm Hoai River and Hoi An Night Market card choices before render.`
  `blocking: false`

### Source notes

* Exact batch row source notes: Existing city-library; Hoi An local references.
* Legacy copy supplies the durable scene: lantern-lit riverside island street, low buildings, cafes, lanes, small shops, hotel edges, and evening walks.
* No venue names, hours, or current business claims added.

### Score

27/30 — Clear neighborhood route draft. Capped for sparse evidence and catalog QA around river/night-market linking.

### QA notes

* Replaceability test: pass. The crossing, river orientation, lantern edge, and return plan tie it to An Hoi.
* Phrase card test: pass. Three ready-audio cards; no one-off planned directions phrase rendered.
* Mentioned Here test: pass.
* Catalog mention scan: pass, with Hoai River held for check.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Phố cổ Hội An / Hoi An Ancient Town — Hoi An — Neighborhood

### Reader View

**Start Before The Lantern Hour**

Hoi An Ancient Town is compact enough to wander and busy enough to reward patience. Yellow walls, tiled roofs, shopfronts, assembly halls, tailors, and the river edge all sit close together.

### Useful phrase cards

* **“Phố cổ Hội An”** — Hoi An Ancient Town
* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Nơi nào ít đông đúc hơn?”** — Where is less crowded?

### Sections

**Walk One Spine Slowly**

Start with Trần Phú or the river edge, then let one lane lead to another. The details are close together, so rushing makes the old houses, signs, courtyards, and shopfronts blur.

**Morning Shows The Buildings**

Early light gives the yellow walls and tiled roofs more room. Evening brings lanterns and reflections, but also the densest walk, so it helps to know which mood you are choosing.

**Choose One Interior**

One old house, hall, or quiet courtyard is enough for a first pass. Ask before photos, then go back to wandering instead of turning the whole old town into a checklist.

**Let The Side Streets Save It**

The famous lanes will be crowded at the prettiest hours. Step away from the brightest stretch for a few minutes and the place usually becomes easier to read again.

### Implementation notes

**contentContract:** `speaklocal.place.app-detail.v2.2`
**page_id:** `city-hoian-place-ancient-town`
**displayName:** `Phố cổ Hội An`
**englishName:** `Hoi An Ancient Town`
**city:** `Hoi An`
**category:** `neighborhood`
**pronunciation:** `foh koh hoy an`
**target_hero_image:** `HeroCityHoianPlaceAncientTown`

**Closest canonical anchor:** Đường Đồng Khởi / Đồng Khởi Street
**Anchor behavior copied:** turn a historic area into a walkable spine with timing, direction, and traffic/crowd realism.
**How this page differs:** Ancient Town is denser and more atmospheric; the page needs to protect the traveler from rushing the whole heritage core at peak glow.
**Owned traveler moment:** arriving before the lantern-hour crowd and choosing one walking spine instead of trying to absorb every lane.

### Phrase/audio status

* **“Phố cổ Hội An”** — `intent: recognize_place_name` · `phraseId: city-hoian-place-ancient-town` · `audioId: audio-authored-pho-co-hoi-an-dad0e3f293` · `status: mapped`
* **“Vé bao nhiêu?”** — `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* **“Nơi nào ít đông đúc hơn?”** — `intent: ask_less_crowded_area` · `phraseId: v900-sigh-acti-where-is-less-crowded` · `audioId: v900-sigh-acti-where-is-less-crowded` · `status: mapped`

### Mentioned Here candidates

* **Tran Phu Street** — `type: street` · `catalogId: hoian-tran-phu-street` · `status: render`
  `sourceText: Trần Phú`
  `displaySubtitle: A simple first spine through the old core.`
  `reason: Named naturally in the first practical walking section.`

### Related place candidates

* **An Hoi Island** — `relationship: evening_crossing` · `catalogId: hoian-an-hoi-island` · `status: render`
  `displaySubtitle: Cross the river when the old streets feel too dense.`
  `reason: Useful evening route pairing after Ancient Town.`

* **Bach Dang Street** — `relationship: river_edge_route` · `catalogId: hoian-bach-dang-street` · `status: render`
  `displaySubtitle: Follow the river edge when you need a clearer line.`
  `reason: Route pairing for the river-edge part of the old-town walk.`

* **An Bang Beach** — `relationship: pace_contrast` · `catalogId: hoian-an-bang-beach` · `status: render`
  `displaySubtitle: Trade the old streets for sea air later in the day.`
  `reason: Useful contrast after the dense old-town core.`

### Verification flags

* `type: light`
  `reason: Ticketing, old-house access, photo expectations, and pedestrian flow should be checked before import; visible copy avoids fixed policies.`
  `blocking: false`

* `type: catalog_qa`
  `reason: Confirm Tran Phu Street card and related cards render to correct Hoi An targets.`
  `blocking: false`

### Source notes

* Exact batch row source notes: Existing city-library; Vietnam Tourism Hoi An; UNESCO.
* Legacy copy supplies the durable scene: yellow walls, lanterns, tiled roofs, old houses, river walks, shopfronts, tailors, temples, assembly halls, and side-street wandering.
* No hours, fee amounts, or entry-rule claims added.

### Score

28/30 — Strong and specific first-screen draft. Capped for ticket/access/photo-policy freshness and final card mapping.

### QA notes

* Replaceability test: pass. Yellow walls, tiled roofs, Trần Phú, lantern-hour crowd, assembly halls, and old-town river edge are Hoi An-specific.
* Phrase card test: pass. Three ready-audio cards; ticket phrase is generic and does not assert a current rule.
* Mentioned Here test: pass. Trần Phú evaluated; related river/area cards separated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Bến thuyền Bạch Đằng / Bach Dang boat pier — Hoi An — Port

### Reader View

**Let The River Shape The Next Move**

Bach Dang boat pier is where Hoi An changes speed. Street noise drops into river steps, boat noses, bridge views, and the small pause before you decide whether to board.

### Useful phrase cards

* **“Bến thuyền ở đâu?”** — Where is the boat pier?
* **“Đây có đúng bến không?”** — Is this the right platform?
* **“Phải mất bao lâu?”** — How long does it take?

### Sections

**Name The Ride Before Boarding**

Do not let “boat ride” stay vague. Ask where it goes, how long it takes, and where you return before you step down to the water.

**Watch The Shift From Street To Water**

Even if you do not board, the pier is worth a short pause. Bạch Đằng’s shopfront rhythm gives way to ropes, hulls, reflections, and people waiting for the next small movement.

**Price First, Then Sit**

A quick price question keeps the moment cleaner. Once the amount and ride shape are clear, you can relax into the view instead of negotiating from the boat.

**Keep The Return Simple**

Evening light can make the river tempting, but the better plan is still plain: know your return point, keep the bridge in sight, and leave before the walk back feels like work.

### Implementation notes

**contentContract:** `speaklocal.place.app-detail.v2.2`
**page_id:** `city-hoian-place-bach-dang-boat-pier`
**displayName:** `Bến thuyền Bạch Đằng`
**englishName:** `Bach Dang boat pier`
**city:** `Hoi An`
**category:** `port`
**pronunciation:** `ben thuyen bach dang`
**target_hero_image:** `HeroCityHoianPlaceBachDangBoatPier`

**Closest canonical anchor:** Perfume River / Sông Hương
**Anchor behavior copied:** water scenery needs a route, price, time, and return question before boarding.
**How this page differs:** This is not a broad river-cruise page; it is a specific landing-edge scene in Hoi An.
**Owned traveler moment:** standing at the river steps and deciding whether the next move is a boat ride or just a pause by the water.

### Phrase/audio status

* **“Bến thuyền ở đâu?”** — `intent: find_boat_pier` · `phraseId: v900-tran-where-is-the-boat-pier` · `audioId: v900-tran-where-is-the-boat-pier` · `status: mapped`
* **“Đây có đúng bến không?”** — `intent: confirm_boarding_point` · `phraseId: transport-1` · `audioId: transport-1` · `status: mapped`
* **“Phải mất bao lâu?”** — `intent: ask_duration` · `phraseId: v500-time-date-book-how-long-does-it-take` · `audioId: v500-time-date-book-how-long-does-it-take` · `status: mapped`

**Place-name phrase:**

* **“Bến thuyền Bạch Đằng”** — `intent: recognize_place_name` · `phraseId: city-hoian-place-bach-dang-boat-pier` · `audioId: null` · `status: hide_until_audio`
  Do not render as a phrase card until ready audio exists.

### Mentioned Here candidates

* **Bach Dang Street** — `type: street` · `catalogId: hoian-bach-dang-street` · `status: render`
  `sourceText: Bạch Đằng’s shopfront rhythm`
  `displaySubtitle: The street edge beside the boarding scene.`
  `reason: The copy connects the pier to the adjacent street movement.`

### Related place candidates

* **Lantern boat ride** — `relationship: boat_experience_pairing` · `catalogId: hoian-lantern-boat` · `status: check_catalog`
  `displaySubtitle: The river ride to map only if current routing is confirmed.`
  `reason: A natural route relation, but current boarding and ride details need freshness check before render.`

* **An Hoi Island** — `relationship: river_crossing_context` · `catalogId: hoian-an-hoi-island` · `status: render`
  `displaySubtitle: The island walk across the evening river scene.`
  `reason: Nearby planning context for bridge/river orientation.`

* **Hoai River** — `relationship: river_context` · `catalogId: hoian-hoai-river` · `status: check_catalog`
  `displaySubtitle: The waterline behind the pier scene.`
  `reason: Visible copy says river generically; catalog QA should confirm whether Hoai River is the correct rendered water card.`

### Verification flags

* `type: same_week`
  `reason: Boat routes, boarding points, prices, return points, and evening availability can change; visible copy avoids exact claims.`
  `blocking: false`

* `type: audio_qa`
  `reason: Place-name phrase is planned without audio and must stay hidden until audio exists.`
  `blocking: false`

* `type: catalog_qa`
  `reason: Confirm Lantern boat ride and Hoai River card statuses before render.`
  `blocking: false`

### Source notes

* Exact batch row source notes: Local map and Hoi An river references.
* Legacy copy supplies the durable scene: river steps, boat noses, skyline edges, boarding points, boats, and bridges.
* No current route, price, schedule, or vendor claim added.

### Score

27/30 — Useful water-entry draft with strong traveler questions. Capped for same-week boat-operation checks and hidden place-name audio.

### QA notes

* Replaceability test: pass. River steps, Bạch Đằng shopfront edge, boat noses, return point, and boarding decision keep it specific.
* Phrase card test: pass for rendered cards; place-name phrase correctly hidden until audio.
* Mentioned Here test: pass.
* Catalog mention scan: pass, with boat/river cards held for QA.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Đường Bạch Đằng ở Hội An / Bach Dang Street — Hoi An — Street

### Reader View

**Walk The River Edge Once**

Bach Dang Street gives Hoi An a clear line to follow: yellow buildings on one side, boats and water on the other, with lantern reflections taking over as the light drops.

### Useful phrase cards

* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Chỉ trên bản đồ giúp tôi được không?”** — Can you show me on the map?
* **“Không, cảm ơn.”** — No, thank you.

### Sections

**Start With The Water Side**

Walk with the river in view first. It keeps the old town legible: bridges, boat steps, cafe edges, and shopfronts all line up more clearly when you have the water beside you.

**Blue Hour Brings The Crowd**

The street gets prettier as the reflections come on, and less relaxed at the same time. It is still worth walking, but pause before the densest stretch rather than stopping in the middle of it.

**Pair It With A Crossing**

Bach Dang works best as part of a small route: river edge, boat pier, bridge, then An Hoi if the evening still has room. Keep it a walk, not a forced march.

### Implementation notes

**contentContract:** `speaklocal.place.app-detail.v2.2`
**page_id:** `city-hoian-place-bach-dang-street`
**displayName:** `Đường Bạch Đằng ở Hội An`
**englishName:** `Bach Dang Street`
**city:** `Hoi An`
**category:** `street`
**pronunciation:** `duong bach dang`
**target_hero_image:** `HeroCityHoianPlaceBachDangStreet`

**Closest canonical anchor:** Đường Đồng Khởi / Đồng Khởi Street
**Anchor behavior copied:** street as a walkable spine with direction, traffic/crowd realism, and nearby route pairings.
**How this page differs:** Bach Dang is lower and river-facing; the page owns the river-edge walk rather than a big-city historic avenue.
**Owned traveler moment:** choosing the river side of the street at blue hour and deciding whether to continue to the pier, bridge, or island.

### Phrase/audio status

* **“Tôi có thể đi bộ tới đó được không?”** — `intent: confirm_walkable_route` · `phraseId: v500-dire-navi-can-i-walk-there` · `audioId: v500-dire-navi-can-i-walk-there` · `status: mapped`
* **“Chỉ trên bản đồ giúp tôi được không?”** — `intent: ask_show_on_map` · `phraseId: repair-5` · `audioId: repair-5` · `status: mapped`
* **“Không, cảm ơn.”** — `intent: decline_politely` · `phraseId: polite-4` · `audioId: polite-4` · `status: mapped`

**Place-name phrase:**

* **“Đường Bạch Đằng ở Hội An”** — `intent: recognize_place_name` · `phraseId: city-hoian-place-bach-dang-street` · `audioId: null` · `status: hide_until_audio`
  Do not render as a phrase card until ready audio exists. Do not use the Da Nang Bach Dang Street audio for this Hoi An listing.

### Mentioned Here candidates

* **Bach Dang boat pier** — `type: port` · `catalogId: hoian-bach-dang-boat-pier` · `status: render`
  `sourceText: boat pier`
  `displaySubtitle: Where the street turns into a boarding edge.`
  `reason: Named naturally in the route-pairing section.`

* **An Hoi Island** — `type: neighborhood` · `catalogId: hoian-an-hoi-island` · `status: render`
  `sourceText: An Hoi`
  `displaySubtitle: Cross over when the river walk needs a next step.`
  `reason: Named naturally as the route continuation.`

### Related place candidates

* **Hoi An Ancient Town** — `relationship: street_within_old_core` · `catalogId: hoian-ancient-town` · `status: render`
  `displaySubtitle: The old core around the river walk.`
  `reason: Bach Dang is useful as an orienting edge for Ancient Town.`

* **An Hoi Bridge** — `relationship: crossing_point` · `catalogId: hoian-an-hoi-bridge` · `status: render`
  `displaySubtitle: The crossing that turns the walk into an island route.`
  `reason: Bridge/crossing behavior is central to using the street at night.`

* **Hoai River** — `relationship: river_context` · `catalogId: hoian-hoai-river` · `status: check_catalog`
  `displaySubtitle: The waterline beside the walk.`
  `reason: Visible copy says river/water generically; catalog QA should confirm whether Hoai River should render.`

### Verification flags

* `type: light`
  `reason: Street access, crowd pattern, river naming, and adjacent boat activity should be checked before import; visible copy avoids fixed operations.`
  `blocking: false`

* `type: audio_qa`
  `reason: Hoi An Bach Dang Street place-name phrase has planned audio only; keep hidden until audio exists.`
  `blocking: false`

* `type: catalog_qa`
  `reason: Confirm Hoai River card and all related cards map to Hoi An targets, not Da Nang or HCMC Bach Dang targets.`
  `blocking: false`

### Source notes

* Exact batch row source notes: UNESCO river and old-town context; local map references.
* Legacy copy supplies the durable scene: riverside street, boats, yellow buildings, blue-hour lantern reflections, scooters, crossings, cafe edges, and neighborhood movement.
* No hours, closure, traffic-control, or event claims added.

### Score

28/30 — Strong street-spine draft with clear route behavior. Capped for Hoi An-specific Bach Dang audio gap and river/card QA.

### QA notes

* Replaceability test: pass. River edge, yellow buildings, boats, lantern reflections, pier, bridge, and An Hoi route keep it Hoi An-specific.
* Phrase card test: pass for rendered cards; Hoi An place-name card hidden until audio.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch-level notes

### Rendered phrase cards approved for draft review

* `city-hoian-place-an-bang` — `city-hoian-place-an-bang`, `price-1`, `v900-heal-phar-i-need-sunscreen`
* `city-hoian-place-an-hoi-island` — `city-hoian-place-an-hoi-island`, `directions-3`, `shop-4`
* `city-hoian-place-ancient-town` — `city-hoian-place-ancient-town`, `sight-1`, `v900-sigh-acti-where-is-less-crowded`
* `city-hoian-place-bach-dang-boat-pier` — `v900-tran-where-is-the-boat-pier`, `transport-1`, `v500-time-date-book-how-long-does-it-take`
* `city-hoian-place-bach-dang-street` — `v500-dire-navi-can-i-walk-there`, `repair-5`, `polite-4`

### Place-name phrase handling

* Ready/renderable: `Biển An Bàng`, `Đảo An Hội`, `Phố cổ Hội An`
* Hide until audio: `Bến thuyền Bạch Đằng`, `Đường Bạch Đằng ở Hội An`
* Explicit guard: do not substitute Da Nang or HCMC Bach Dang audio for Hoi An Bach Dang pages.

### Visible copy risk scan

* No visible copy starts with banned app-internal phrasing.
* No visible copy uses `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
* No visible copy uses `perfect for`, `must-visit`, `hidden gem`, `iconic`, `bustling`, `curated`, `vibrant`, or `nestled`.
* No visible hours, price amounts, ticket rules, closures, payment rules, or current operations added.

### Batch source/freshness risks

* An Bang: beach setup, sea conditions, chair/vendor pricing, seafood venue availability.
* An Hoi Island: business mix, lighting, crowd pattern, exact night-market adjacency.
* Ancient Town: ticketing, old-house/hall access, photo expectations, pedestrian flow.
* Bach Dang boat pier: boat routes, boarding points, prices, return points, evening availability.
* Bach Dang Street: street access, river naming, crowd pattern, adjacent boat activity, Hoi An-specific Bach Dang audio gap.

## Codex handoff block

* `batch_id: batch_009`
* `page_ids: city-hoian-place-an-bang, city-hoian-place-an-hoi-island, city-hoian-place-ancient-town, city-hoian-place-bach-dang-boat-pier, city-hoian-place-bach-dang-street`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for rendered ready-audio cards; hidden/planned place-name phrases need audio check for city-hoian-place-bach-dang-boat-pier and city-hoian-place-bach-dang-street`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: none identified after anti-drift scan; final Jojo voice review still required`
* `source_freshness_risks: beach vendor/setup conditions; An Hoi business mix/night-market adjacency; Ancient Town ticket/photo/access flow; Bach Dang boat pier route/price/return-point operations; Bach Dang Street river/card mapping and Hoi An-specific place-name audio`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
