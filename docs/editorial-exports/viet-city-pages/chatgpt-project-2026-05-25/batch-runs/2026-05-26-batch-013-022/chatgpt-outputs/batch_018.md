SpeakLocal v2.2 BATCH_018 - Da Nang - 2026-05-26

Source basis: exact batch rows and handoff rules came from the uploaded BATCH_018 prompt; v2.2 shape, voice, phrase-card, Mentioned Here, and validation rules came from the Source Bundle and Copy Ledger/Catalog files.    

---

## 1. Đèo Hải Vân / Hai Van Pass — Đà Nẵng — Landmark

### Reader View

**The Scenic Way Out Of Da Nang**

Hải Vân Pass is the old mountain road between Đà Nẵng and Huế: bends above the sea, low cloud on the ridge, green slopes, and quick pull-offs where Lăng Cô opens below. Save it for a day when the road can be part of the memory, not just the way north.

### Useful phrase cards

* **“Cho hỏi, đi tới đó thế nào?”** — Excuse me, how do I get there?
* **“Đi xe máy mất bao lâu?”** — How long does it take by motorbike?

### Sections

**Route First, Viewpoint Second**

The pass is not one single stop. It makes sense when your car, motorbike, or transfer takes the old road over the mountain instead of treating the coast as something to rush past.

**Cloud Can Be The Point**

Clear weather gives you the sea and lagoon views. Mist changes the mood instead of ruining the place: guardrails, wet road, pale sky, and the feeling of central Vietnam shifting from city beach to mountain edge.

**Build In One Stop**

A short pause is enough if the day is mostly Đà Nẵng to Huế. If the ride itself matters, leave room for photos, coffee, and a slower descent rather than stacking the day too tightly.

### Implementation notes

**Content contract:** `speaklocal.place.app-detail.v2.2`
**Page ID:** `city-danang-place-hai-van-pass`
**Display name:** `Đèo Hải Vân`
**English name:** `Hai Van Pass`
**City:** `Đà Nẵng`
**Category:** `Landmark`
**Pronunciation:** `deh-oh high vun` — native QA needed.

**Closest canonical anchor:** Perfume River / Sông Hương — scenic places need a route, not vague scenery.
**Anchor behavior copied:** Tie the scenery to a clear movement decision, timing, return/pacing, and expectation-setting.
**How this page differs:** This is a road crossing, not a boat route; the useful decision is old-road scenic transfer versus faster routing.
**Owned traveler moment:** Choosing the old pass road on a Đà Nẵng–Huế movement day.

**Phrase/audio status**

* `directions-1` / `directions-1` — “Cho hỏi, đi tới đó thế nào?” — `mapped`, ready audio. 
* `v900-dire-navi-how-long-does-it-take-by-motorbike` / same — “Đi xe máy mất bao lâu?” — `mapped`, ready audio. 
* Place-name support: `Đèo Hải Vân` — render as pronunciation/name support only if ready audio exists; otherwise `hide_until_audio`.

**Mentioned Here candidates**

* **Lăng Cô** — `type: place` · `catalogId: null` · `status: check_catalog`
  `displaySubtitle: Lagoon-side coast view below the pass.`
  `reason: Naturally named in the intro as the view that opens below the road.`
* **Huế** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`
  `displaySubtitle: Northern city often paired with the pass road.`
  `reason: Route context in the intro.`
* **Đà Nẵng** — `type: city` · `catalogId: danang` · `status: check_catalog`
  `displaySubtitle: Central Vietnam city where the pass route begins for many travelers.`
  `reason: Origin context in intro and page city.`

**Related place candidates**

* **Hai Van Pass ride** — `relationship: experience_variant` · `catalogId: danang-hai-van-pass-ride` · `status: render`
  `displaySubtitle: The same mountain road framed as a ride experience.`
  `reason: Direct companion entry in this batch and City Places Catalog.` 

**Freshness notes**

* Check current road conditions, weather, safe stopping points, vehicle restrictions, and any access issues before import.
* Avoid rendering operational claims about schedules, prices, or tour pickups without same-week verification.

**Source notes**

* Batch row source: user-provided BATCH_018 exact row and legacy copy. 
* Catalog row exists for `danang-hai-van-pass`. 

**Score**

28/30 — Strong route decision and concrete road feel; capped for weather/road freshness and pronunciation/audio QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; 2 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass; natural mentions evaluated, not forced.
* Catalog mention scan: needs catalog QA for Lăng Cô, Huế, and city card handling.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex import/validation.

---

## 2. Chuyến đi đèo Hải Vân / Hai Van Pass ride — Đà Nẵng — Experience

### Reader View

**Ride The Old Road Slowly**

A Hai Van Pass ride turns the Đà Nẵng–Huế move into open road: guardrail curves, sea below, cloud near the ridge, and small stops that make the coast feel earned. It is best when the pace is calm enough to look around.

### Useful phrase cards

* **“Bạn là tài xế của tôi à?”** — Are you my driver?
* **“Đi xe máy mất bao lâu?”** — How long does it take by motorbike?
* **“Xin hãy lái xe chậm lại.”** — Please drive slower.

### Sections

**Pick A Pace You Trust**

The ride can be a self-drive motorbike, a hired rider, or a private car with stops. Choose the version that lets you relax; this road rewards attention, not nervous proof.

**Keep The Weather Honest**

Morning cloud can make the ride feel dramatic, but rain or heavy fog changes the whole plan. Treat the view as a bonus and the road conditions as the real decision.

**Pause Before The Ridge Drops**

One well-timed stop does more than five rushed photos. Let the climb, the high point, and the descent feel different before the road flattens toward lagoon and city again.

### Implementation notes

**Content contract:** `speaklocal.place.app-detail.v2.2`
**Page ID:** `city-danang-place-hai-van-pass-ride`
**Display name:** `Chuyến đi đèo Hải Vân`
**English name:** `Hai Van Pass ride`
**City:** `Đà Nẵng`
**Category:** `Experience`
**Pronunciation:** `chwen dee deh-oh high vun` — native QA needed.

**Closest canonical anchor:** Bạch Mã National Park — condition-setting for outdoor movement, with Perfume River as the route-confirmation secondary model.
**Anchor behavior copied:** Make weather, pacing, and commitment explicit without making the copy heavy.
**How this page differs:** This is a road ride, not a hike or boat plan; the first decision is who controls the ride and pace.
**Owned traveler moment:** Meeting the rider/driver and choosing a calm pace before the pass begins.

**Phrase/audio status**

* `v500-tran-are-you-my-driver` / same — “Bạn là tài xế của tôi à?” — `mapped`, ready audio. 
* `v900-dire-navi-how-long-does-it-take-by-motorbike` / same — “Đi xe máy mất bao lâu?” — `mapped`, ready audio. 
* `v500-tran-please-drive-slower` / same — “Xin hãy lái xe chậm lại.” — `mapped`, ready audio. 
* Place-name support: `Chuyến đi đèo Hải Vân` — render as pronunciation/name support only if ready audio exists; otherwise `hide_until_audio`.

**Mentioned Here candidates**

* **Hai Van Pass** — `type: landmark` · `catalogId: danang-hai-van-pass` · `status: render`
  `displaySubtitle: The mountain road behind the ride experience.`
  `reason: Directly named in intro and title.`
* **Huế** — `type: city` · `catalogId: existing_or_null` · `status: check_catalog`
  `displaySubtitle: Northern city often paired with the pass ride.`
  `reason: Route context in intro.`
* **Đà Nẵng** — `type: city` · `catalogId: danang` · `status: check_catalog`
  `displaySubtitle: Central Vietnam city where many pass rides begin.`
  `reason: Page city and route context.`

**Related place candidates**

* **Hai Van Pass** — `relationship: parent_landmark` · `catalogId: danang-hai-van-pass` · `status: render`
  `displaySubtitle: The road itself, separate from the ride format.`
  `reason: Direct companion listing and catalog row.`
* **Lăng Cô** — `relationship: route_context` · `catalogId: null` · `status: check_catalog`
  `displaySubtitle: Lagoon-side coast often seen below the pass road.`
  `reason: Natural route context from legacy source and nearby geography; needs catalog proof before render.`

**Freshness notes**

* Same-week check for weather, fog/rain, traffic, road works, safe stopping points, operator pickup details, and motorbike suitability.
* Avoid current claims about tour format, rental rules, or exact pickup points until verified.

**Source notes**

* Batch row source: user-provided BATCH_018 exact row and legacy copy. 
* Catalog rows exist for `danang-hai-van-pass` and `danang-hai-van-pass-ride`. 

**Score**

28/30 — Good traveler pacing and safety-use cues; capped for same-week road/weather checks and native pronunciation QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass.
* Catalog mention scan: needs QA for Huế, Đà Nẵng, and Lăng Cô card handling.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex import/validation.

---

## 3. Chợ Hàn / Han Market — Đà Nẵng — Market

### Reader View

**A Market For First Bearings**

Hàn Market gives you a practical first read on central Đà Nẵng. Fish-sauce jars, dried seafood, fabric stalls, rattan bags, and breakfast bowls sit close together, so the city starts to feel specific even if you buy nothing.

### Useful phrase cards

* **“Cái này bao nhiêu?”** — How much is this?
* **“Cho tôi một phần.”** — One portion, please.
* **“Trả ở đâu?”** — Where do I pay?

### Sections

**One Slow Lap**

The food area is easier after you circle once. Notice where people are already eating, then choose mì Quảng, bánh bèo, or a small bánh xèo instead of answering the first call.

**Food Early, Gifts Later**

Morning is better for breakfast energy and fresh-market texture. Fabric, dried food, and souvenir browsing can feel easier after the first rush, when you are less likely to buy just because a stall has your attention.

**Hàn For Bearings, Cồn For Snacks**

Hàn is the easier central market for a quick food look, a gift errand, or a first city-center orientation stop. Cồn is stronger when the whole point is small dishes, stools, steam, and cash-ready snacking.

### Implementation notes

**Content contract:** `speaklocal.place.app-detail.v2.2`
**Page ID:** `city-danang-place-han-market`
**Display name:** `Chợ Hàn`
**English name:** `Han Market`
**City:** `Đà Nẵng`
**Category:** `Market`
**Pronunciation:** `chuh hahn` — native QA needed.

**Closest canonical anchor:** Chợ Hàn — first-bearings market.
**Anchor behavior copied:** One roof, one first lap, one starter food move, timing split, and market contrast without inventory dumping.
**How this page differs:** This draft tightens the canonical entry to 3 phrase cards and trims food mentions to avoid over-linking.
**Owned traveler moment:** First slow lap before choosing food or buying gifts.

**Phrase/audio status**

* `price-1` / `price-1` — “Cái này bao nhiêu?” — `mapped`, ready audio. 
* `food-1` / `food-1` — “Cho tôi một phần.” — `mapped`, ready audio. 
* `shop-5` / `shop-5` — “Trả ở đâu?” — `mapped`, ready audio. 
* Place-name support: `Chợ Hàn` — render as pronunciation/name support only if ready audio exists; otherwise `hide_until_audio`.

**Mentioned Here candidates**

* **Mì Quảng** — `type: food` · `catalogId: food-mi-quang-ga or food-mi-quang-tom-thit` · `status: check_catalog`
  `displaySubtitle: Central Vietnam turmeric noodle bowl.`
  `reason: Copy names generic mì Quảng; Menu Catalog contains specific variants that may render instead.` 
* **Bánh bèo** — `type: food` · `catalogId: food-banh-beo` · `status: render`
  `displaySubtitle: Tiny steamed rice cakes with shrimp topping.`
  `reason: Naturally named in food-area guidance; item exists in Menu Catalog.` 
* **Bánh xèo** — `type: food` · `catalogId: food-banh-xeo` · `status: render`
  `displaySubtitle: Crisp turmeric-rice pancake with herbs and dip.`
  `reason: Naturally named in food-area guidance; item exists in Menu Catalog.` 
* **Chợ Cồn** — `type: market` · `catalogId: danang-con-market` · `status: render`
  `displaySubtitle: Food-first market for Đà Nẵng snacks.`
  `reason: Direct comparison in final section; catalog row exists.` 

**Related place candidates**

* **Han River** — `relationship: nearby_city_center_pairing` · `catalogId: danang-han-river` · `status: check_catalog`
  `displaySubtitle: Easy central walk after a market stop.`
  `reason: Legacy source pairs Hàn Market with central river orientation; not named in visible copy, so render only if route module needs it.`
* **Dragon Bridge** — `relationship: evening_pairing` · `catalogId: danang-dragon-bridge` · `status: check_catalog`
  `displaySubtitle: Nearby landmark often paired with central Đà Nẵng stops.`
  `reason: Legacy source mentions pairing; not named in visible copy, so keep optional.`

**Freshness notes**

* Light verification for current hours, stall mix, breakfast availability, fabric/souvenir patterns, prices, and payment norms.
* Do not render exact hours, stall claims, or price expectations without current check.

**Source notes**

* Batch row source and legacy copy provided in BATCH_018. 
* Canonical Hàn Market app-detail anchor in Source Bundle supports first-bearings pattern and Mentioned Here behavior. 

**Score**

29/30 — Strong canonical fit, sharper phrase count, and natural catalog mentions; capped for current market facts, menu/card mapping, and native QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass.
* Catalog mention scan: pass with Mì Quảng variant check still needed.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex import/validation.

---

## 4. Sông Hàn / Han River — Đà Nẵng — River

### Reader View

**Read Da Nang From The Waterline**

The Hàn River helps Da Nang make sense: bridges, reflections, open banks, evening light, and the easy split between city center and beach side. Go when the day is loosening, not when you need a headline attraction.

### Useful phrase cards

* **“Ở gần đây không?”** — Is it near here?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?

### Sections

**Evening Makes The Bridges Legible**

Late light is when the river does the most work. The bridges turn into silhouettes first, then reflections, then lit-up markers you can use to understand where you are in the city.

**Walk A Stretch, Not The Whole Bank**

Pick one side and one section. A short walk with a bridge, a coffee stop, or a dinner plan nearby feels better than trying to turn the whole riverfront into a march.

**A Calm Link Between Bigger Stops**

The river is often strongest between plans: after Hàn Market, before Dragon Bridge, or after seafood when you want air and city lights without another crowded stop.

### Implementation notes

**Content contract:** `speaklocal.place.app-detail.v2.2`
**Page ID:** `city-danang-place-han-river`
**Display name:** `Sông Hàn`
**English name:** `Han River`
**City:** `Đà Nẵng`
**Category:** `River`
**Pronunciation:** `sohm hahn` — native QA needed.

**Closest canonical anchor:** Perfume River / Sông Hương — water needs a route and one clear way to enter the experience.
**Anchor behavior copied:** Turn scenery into a simple traveler sequence: timing, stretch, pairing, and return to the day.
**How this page differs:** Hàn River is urban and bridge-led, more about short walks and orientation than a boat route.
**Owned traveler moment:** Choosing one evening river stretch between market, bridge, dinner, or hotel movement.

**Phrase/audio status**

* `directions-2` / `directions-2` — “Ở gần đây không?” — `mapped`, ready audio. 
* `directions-3` / `directions-3` — “Đi bộ mất bao lâu?” — `mapped`, ready audio. 
* Place-name support: `Sông Hàn` — render as pronunciation/name support only if ready audio exists; otherwise `hide_until_audio`.

**Mentioned Here candidates**

* **Hàn Market** — `type: market` · `catalogId: danang-han-market` · `status: render`
  `displaySubtitle: Central market that pairs naturally with the river.`
  `reason: Named in practical pairing section; catalog row exists.` 
* **Dragon Bridge** — `type: landmark` · `catalogId: danang-dragon-bridge` · `status: render`
  `displaySubtitle: River landmark with its own viewing decision.`
  `reason: Named in practical pairing section; catalog row exists.` 
* **Seafood in Đà Nẵng** — `type: dish` · `catalogId: danang-hai-san` · `status: check_catalog`
  `displaySubtitle: Coastal meal idea before or after the river walk.`
  `reason: Copy references seafood as a meal context; catalog row exists for seafood, but card fit needs QA.` 

**Related place candidates**

* **Han River cruise** — `relationship: water_experience_variant` · `catalogId: danang-han-river-cruise` · `status: render`
  `displaySubtitle: A slower night view from the water.`
  `reason: Direct river experience companion in batch and catalog.`
* **Dragon Bridge** — `relationship: landmark_pairing` · `catalogId: danang-dragon-bridge` · `status: render`
  `displaySubtitle: Stronger when you choose close or clean view before arriving.`
  `reason: Practical evening pairing named in copy.`

**Freshness notes**

* Light verification for promenade access, temporary riverfront works, lighting/event disruptions, and any bridge-side crowd controls.
* If pairing with Dragon Bridge show behavior later, verify schedule same week.

**Source notes**

* Batch row source and legacy copy provided in BATCH_018. 
* Catalog rows exist for Hàn River, Hàn Market, Dragon Bridge, seafood, and Han River cruise. 

**Score**

28/30 — Calm, specific, and useful for route pairing; capped for broad-river evidence and current riverfront/lighting freshness.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; 2 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass.
* Catalog mention scan: pass; seafood card needs QA before render.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex import/validation.

---

## 5. Du thuyền sông Hàn / Han River cruise — Đà Nẵng — Experience

### Reader View

**Board For The Lights, Not The Checklist**

A Han River cruise is a simple night move: small boat, bridge lights, darker water, and a slower look at the city from below the skyline. Keep it short in your mind and it can feel easy instead of overbuilt.

### Useful phrase cards

* **“Cho xin một vé người lớn.”** — One adult ticket, please.
* **“Nó bắt đầu lúc mấy giờ?”** — What time does it start?
* **“Chuyến tàu cuối cùng về lúc mấy giờ?”** — What time is the last boat back?

### Sections

**Confirm The Boat Before Boarding**

Ask where to board, when the trip starts, and what route the boat actually takes. The river is calmest when the basics are clear before you step on.

**The Better Seat Is The Unhurried One**

Do not chase every bridge photo from the first minute. Settle in, watch the lights change, then choose when to stand, sit, or move for a cleaner view.

**Light, Bridges, Then Back To Land**

The cruise works as one evening piece, not the whole night. Pair it with a river walk, Dragon Bridge view, or a late dinner plan so the boat has a clean place in the evening.

### Implementation notes

**Content contract:** `speaklocal.place.app-detail.v2.2`
**Page ID:** `city-danang-place-han-river-cruise`
**Display name:** `Du thuyền sông Hàn`
**English name:** `Han River cruise`
**City:** `Đà Nẵng`
**Category:** `Experience`
**Pronunciation:** `zoo thwee-en sohm hahn` — native QA needed.

**Closest canonical anchor:** Perfume River / Sông Hương — scenery needs a route, price/time clarity, and return confidence.
**Anchor behavior copied:** Make the boat experience usable by tying it to boarding, start time, route clarity, and evening pairing.
**How this page differs:** Hàn River cruise is a short urban night ride, not a temple or countryside route.
**Owned traveler moment:** Standing at the boarding point and confirming the boat basics before stepping on.

**Phrase/audio status**

* `v900-time-date-book-one-adult-ticket-please` / same — “Cho xin một vé người lớn.” — `mapped`, ready audio. 
* `v900-time-date-book-what-time-does-it-start` / same — “Nó bắt đầu lúc mấy giờ?” — `mapped`, ready audio. 
* `v900-tran-what-time-is-the-last-boat-back` / same — “Chuyến tàu cuối cùng về lúc mấy giờ?” — `mapped`, ready audio. 
* Place-name support: `Du thuyền sông Hàn` — render as pronunciation/name support only if ready audio exists; otherwise `hide_until_audio`.

**Mentioned Here candidates**

* **Han River** — `type: river` · `catalogId: danang-han-river` · `status: render`
  `displaySubtitle: The waterline that frames the cruise.`
  `reason: Named directly in title and copy; catalog row exists.` 
* **Dragon Bridge** — `type: landmark` · `catalogId: danang-dragon-bridge` · `status: render`
  `displaySubtitle: River landmark to pair before or after the boat.`
  `reason: Named in evening-pairing section; catalog row exists.` 
* **Đà Nẵng** — `type: city` · `catalogId: danang` · `status: check_catalog`
  `displaySubtitle: Central Vietnam city seen from the river at night.`
  `reason: City context in intro and page metadata.`

**Related place candidates**

* **Han River** — `relationship: parent_river` · `catalogId: danang-han-river` · `status: render`
  `displaySubtitle: Walk the riverfront without boarding a boat.`
  `reason: Direct parent place and companion listing in this batch.`
* **Dragon Bridge** — `relationship: evening_pairing` · `catalogId: danang-dragon-bridge` · `status: render`
  `displaySubtitle: Choose your viewing side before the bridge becomes the plan.`
  `reason: Natural pairing in final section; schedule-sensitive details kept out of visible copy.`
* **Dragon Bridge fire show** — `relationship: schedule_sensitive_pairing` · `catalogId: danang-dragon-bridge-fire-show` · `status: check_catalog`
  `displaySubtitle: Schedule-sensitive bridge event; verify before rendering.`
  `reason: Catalog row exists, but visible copy avoids show timing and should not render without same-week verification.` 

**Freshness notes**

* Same-week verification for operators, routes, boarding points, start times, ticketing, safety equipment, weather, river conditions, and any event pairing.
* Do not render exact schedules, prices, boat names, or route guarantees without current confirmation.

**Source notes**

* Batch row source and legacy copy provided in BATCH_018. 
* Catalog row exists for `danang-han-river-cruise`; source notes flag Da Nang tourism/operator-neutral sourcing. 

**Score**

28/30 — Clear boarding moment and practical boat checks; capped for same-week operator/schedule verification and phrase/native QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass.
* Catalog mention scan: pass; Dragon Bridge fire show should stay check-only until schedule verification.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run; draft only, pending Jojo voice approval and Codex import/validation.

---

## Codex handoff block

```markdown
- `batch_id: batch_018`
- `page_ids: city-danang-place-hai-van-pass, city-danang-place-hai-van-pass-ride, city-danang-place-han-market, city-danang-place-han-river, city-danang-place-han-river-cruise`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none for selected visible cards; all visible cards use ready-audio reusable traveler-action phrases, but Codex should confirm phrase/audio IDs before import`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: Hai Van Pass and Hai Van Pass ride are close siblings; keep both only if one remains the road landmark and the other remains the ride/pacing experience. Han River and Han River cruise are also close siblings; keep one as waterline orientation and one as boarding/boat clarity.`
- `source_freshness_risks: Hai Van weather/road conditions, ride operator/pickup details, Han Market hours/stall mix/prices, Han River promenade/event disruptions, Han River cruise operators/routes/boarding points/schedules/safety equipment`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```
