SpeakLocal v2.2 BATCH_016 - Da Nang - 2026-05-26

Grounding note: drafted from the exact BATCH_016 rows and the v2.2 project/source instructions, with phrase cards kept to reusable ready-audio traveler actions and visible copy kept separate from internal implementation notes.      

## Reader View

## Nhà ga quốc nội Đà Nẵng / Da Nang Domestic Terminal

**A Quick Arrival, Then The City**

The domestic terminal gives Đà Nẵng a practical first scene: local signs, families waiting near bags, baggage carts, and warm air outside the doors. The city feels close here, but the better first move is slower: find the right exit, match the pickup point, then let the ride begin.

### Useful phrase cards

* **Sảnh đến ở đâu?** — Where is the arrivals hall?
* **Điểm đón Grab ở đâu?** — Where is the Grab pickup point?
* **Bạn có thể giúp tôi đặt một chiếc taxi được không?** — Can you help me book a taxi?

### Read The Exit Before The Ride

Domestic arrivals can feel simple until everyone is moving at once. Step out of the baggage flow, read the signs, and decide whether you are meeting a driver, finding a taxi, or walking toward a pickup zone.

### Pause Before The Pickup

A minute inside is worth taking if phones, water, or bags are not settled. It is easier to message a driver or find family once you are not standing in the door stream.

### Close Enough To Begin

This is not a place to linger, but it gives the first local texture: Vietnamese announcements, short flights emptying out, and the beach road waiting beyond the airport edge.

---

## Bảo tàng Đồng Đình / Dong Dinh Museum

**A Small Museum Under Trees**

Đồng Đình is a quiet garden-house museum on the Sơn Trà side of Đà Nẵng. The first thing to notice may be shade, stone paths, water, and old house materials before any display case. Keep the visit narrow: two stories, a slow walk, then back into the peninsula day.

### Useful phrase cards

* **Mấy giờ mở cửa?** — What time does it open?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?

### Garden First, Labels Later

The garden is part of the visit, not just the way in. Trees and stone make the museum feel more like a retreat from beach-and-bridge traffic than a room-by-room assignment.

### Choose Two Threads

Old house materials, ceramics, fishing-life objects, and ethnography rooms can blur if you try to read everything. Pick two threads and let the rest stay quiet.

### Better Beside Lady Buddha

Đồng Đình makes more sense before or after a Sơn Trà stop than as a cross-city errand on its own. Come for shade and slower culture, not a heavy museum session.

---

## Cầu Rồng / Dragon Bridge

**Choose Dry Or Back**

Dragon Bridge is easy to understand once you stop treating the bridge as the whole plan. Close to the dragon head means crowd energy, traffic noise, and possible spray on show nights. Farther back on the riverbank gives the cleaner shape: dragon, skyline, reflections, and room to breathe.

### Useful phrase cards

* **Tôi có nên băng qua đường không?** — Should I cross the street?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Bạn có thể chỉ ra một điểm mốc gần đó không?** — Can you point out a nearby landmark?

### The Riverbank Shows The Shape

The bridge itself is movement: scooters, lanes, walkers, and phones at the rail. The riverbank gives enough distance to see the dragon instead of only standing on it.

### Close Has A Different Energy

If spray and crowd noise are part of the fun, stand nearer. If you care more about photos, skyline, and not getting pushed around, stay back and let the river frame it.

### Keep It In A Short Loop

Pair the bridge with a Hàn River walk, Love Bridge, the Dragon Carp Statue, or a nearby night-market stop. It is strongest as a sharp riverfront moment, not a whole evening by itself.

---

## Màn phun lửa Cầu Rồng / Dragon Bridge fire show

**A Street Crowd, Not A Seat**

The fire show is Đà Nẵng looking up together: scooters slowing, families at the rail, phones already raised, and the dragon head glowing over the river. The choice is physical, not complicated: close for heat, sound, and spray, or farther back for the cleaner view.

### Useful phrase cards

* **Mấy giờ?** — What time?
* **Tôi có nên băng qua đường không?** — Should I cross the street?
* **Khu vực này có an toàn vào ban đêm không?** — Is this area safe at night?

### Close Means Noise And Spray

Near the bridge, the show feels less like a performance and more like a crowd reaction. Expect shoulder-to-shoulder watching, quick phones, and a little chaos when the burst comes.

### Farther Back Holds The Frame

From the promenade, you lose some force but gain the scene: dragon head, river, lights, and crowd silhouettes. That distance can make the moment easier to photograph and easier to leave.

### Move After The Burst

The area shifts quickly once people start walking, scooters start feeding back in, and groups look for the next snack or ride. Know your side of the river before the show ends.

---

## Tượng Cá Chép Hóa Rồng / Dragon Carp Statue

**The Statue Gives The River A Foreground**

The Dragon Carp Statue is a quick Hàn River stop with a clear visual purpose: carp-dragon form in front, bridge lights and river behind, people pausing for photos along the promenade. It is small, but it can make the river walk feel more specific.

### Useful phrase cards

* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Bạn có thể chỉ ra một điểm mốc gần đó không?** — Can you point out a nearby landmark?
* **Tôi có nên băng qua đường không?** — Should I cross the street?

### Look Across, Not Only At It

The statue makes more sense with the river around it. Step back enough to catch Dragon Bridge, Love Bridge, or the Hàn River lights in the same mental frame.

### Better As One Link In The Walk

This is a short stop between other riverfront pieces: a photo, a look at the water, then a decision about where to go next. Do not make it carry the whole evening.

### Small, Still Memorable

The form is easy to remember after the name clicks: fish becoming dragon, local symbol becoming photo foreground. At night, the surrounding lights do most of the work.

---

# Implementation notes

## 1. Nhà ga quốc nội Đà Nẵng / Da Nang Domestic Terminal — Da Nang — airport

* `page_id: city-danang-place-domestic-terminal`
* `contentContract: speaklocal.place.app-detail.v2.2`
* `displayName: Nhà ga quốc nội Đà Nẵng`
* `englishName: Da Nang Domestic Terminal`
* `city: Đà Nẵng`
* `category: airport`
* `pronunciation: nyah gah kwok noy dah nang`
* `target_hero_image: HeroCityDanangPlaceDomesticTerminal`
* `current_status_from_ledger: not_started`
* `closest canonical anchor: Perfume River / Sông Hương`
* `anchor behavior copied: arrival/route logistics become usable only when the traveler confirms the next step before moving`
* `how this page differs: airport arrival, not scenic route; the page owns the first-exit and pickup moment`
* `owned traveler moment: arrival sequence from baggage flow to pickup point`
* `source basis: exact ledger row and City Places Catalog airport entry`  

### Phrase/audio status

* **Sảnh đến ở đâu?** — Where is the arrivals hall?

  * `intent: find_arrivals_hall`
  * `phraseId: v900-airp-bord-arri-where-is-the-arrivals-hall`
  * `audioId: v900-airp-bord-arri-where-is-the-arrivals-hall`
  * `status: mapped`
* **Điểm đón Grab ở đâu?** — Where is the Grab pickup point?

  * `intent: find_grab_pickup`
  * `phraseId: v900-airp-bord-arri-where-is-the-grab-pickup-point`
  * `audioId: v900-airp-bord-arri-where-is-the-grab-pickup-point`
  * `status: mapped`
* **Bạn có thể giúp tôi đặt một chiếc taxi được không?** — Can you help me book a taxi?

  * `intent: get_taxi_help`
  * `phraseId: v900-airp-bord-arri-can-you-help-me-book-a-taxi`
  * `audioId: v900-airp-bord-arri-can-you-help-me-book-a-taxi`
  * `status: mapped`

Phrase source: airport arrival ready-audio rows from the phrase catalog.  

### Mentioned Here candidates

* **Đà Nẵng**

  * `type: city`
  * `catalogId: existing_or_null`
  * `sourceText: Đà Nẵng`
  * `displaySubtitle: The coastal city just beyond the terminal doors.`
  * `reason: City name appears naturally in the intro and place title.`
  * `status: check_catalog`

### Related place candidates

* **Da Nang International Terminal**

  * `relationship: terminal_contrast`
  * `catalogId: danang-international-terminal`
  * `displaySubtitle: The other passenger terminal to check when a flight is not domestic.`
  * `reason: Catalog neighbor; useful when travelers confuse domestic and international arrivals.`
  * `status: render`

### Verification flags

* `type: light`

  * `reason: Airport pickup zones, taxi flows, terminal service points, and signage can change.`
  * `blocking: false`
* `type: audio_qa`

  * `reason: Confirm mapped airport phrases render with the intended ready audio.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Phrase rows are catalog-ready, but final native pass still belongs in import workflow.`
  * `blocking: false`

### Source notes

* Ledger source notes: Airport and transport sources.
* Visible copy avoids current pickup rules, prices, exact doors, ride-hailing policies, and terminal service claims.
* Place-name phrase should be pronunciation/name support only, not a visible phrase card unless Codex confirms a ready-audio name row and product need.

### Freshness notes

* Recheck current airport pickup flow and official taxi/ride-hailing pickup signage before publication.
* No same-week visible claim was made.

### Score

28/30 — Clear arrival sequence and reusable phrases; capped for airport operational freshness, catalog-card confirmation, and no rendered screenshot proof.

### QA notes

* Replaceability test: pass — baggage flow, pickup point, arrivals hall, and airport-door texture make this specific.
* Phrase card test: pass — 3 reusable airport-action phrase cards, no place-name phrase card.
* Mentioned Here test: pass — city mention evaluated without forcing cards.
* Catalog mention scan: pass — International Terminal evaluated as related.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Bảo tàng Đồng Đình / Dong Dinh Museum — Da Nang — museum

* `page_id: city-danang-place-dong-dinh-museum`
* `contentContract: speaklocal.place.app-detail.v2.2`
* `displayName: Bảo tàng Đồng Đình`
* `englishName: Dong Dinh Museum`
* `city: Đà Nẵng`
* `category: museum`
* `pronunciation: bao tahng dong ding`
* `target_hero_image: HeroCityDanangPlaceDongDinhMuseum`
* `current_status_from_ledger: voice_rejected_rewrite`
* `closest canonical anchor: Museum of Cham Sculpture`
* `anchor behavior copied: prevent museum fatigue by narrowing the visit to a few things to notice`
* `how this page differs: smaller private garden-house stop, where the garden and shade carry the visit as much as the rooms`
* `owned traveler moment: shaded garden pause before or after a Sơn Trà route stop`
* `source basis: exact ledger row, including Jojo voice-rejected rewrite status, and City Places Catalog museum entry`  

### Phrase/audio status

* **Mấy giờ mở cửa?** — What time does it open?

  * `intent: ask_opening_time`
  * `phraseId: time-5`
  * `audioId: time-5`
  * `status: mapped`
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

  * `intent: ask_photo_permission`
  * `phraseId: sight-3`
  * `audioId: sight-3`
  * `status: mapped`
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?

  * `intent: ask_english_guide`
  * `phraseId: v900-sigh-acti-is-there-an-english-guide`
  * `audioId: v900-sigh-acti-is-there-an-english-guide`
  * `status: mapped`

Phrase source: time and sightseeing ready-audio rows from the phrase catalog.   

### Mentioned Here candidates

* **Sơn Trà**

  * `type: neighborhood`
  * `catalogId: existing_or_null`
  * `sourceText: Sơn Trà`
  * `displaySubtitle: The peninsula side that gives this small museum its route logic.`
  * `reason: Named naturally in the intro and route section.`
  * `status: check_catalog`
* **Lady Buddha**

  * `type: landmark`
  * `catalogId: danang-lady-buddha`
  * `sourceText: Lady Buddha`
  * `displaySubtitle: A nearby peninsula landmark that can pair with a quieter museum pause.`
  * `reason: Named naturally in the final section as a route pairing.`
  * `status: render`

### Related place candidates

* **Lady Buddha**

  * `relationship: peninsula_pairing`
  * `catalogId: danang-lady-buddha`
  * `displaySubtitle: Pair a large Sơn Trà landmark with a shaded museum pause.`
  * `reason: Route pairing is central to the page’s traveler use.`
  * `status: render`
* **Linh Ung Pagoda**

  * `relationship: peninsula_route`
  * `catalogId: danang-linh-ung-pagoda`
  * `displaySubtitle: Another Sơn Trà-side stop to check when planning the same ride.`
  * `reason: Catalog neighbor near the Lady Buddha route; useful for comparison and routing.`
  * `status: render`

### Verification flags

* `type: light`

  * `reason: Current hours, ticketing, photo policy, English interpretation, and exhibit access can change.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm Sơn Trà catalog target before rendering; Lady Buddha and Linh Ung catalog IDs appear available.`
  * `blocking: false`
* `type: native_speaker_qa`

  * `reason: Phrase rows are catalog-ready, but final native pass still belongs in import workflow.`
  * `blocking: false`

### Source notes

* Ledger source notes: Da Nang Fantasticity.
* The 2026-05-24 pilot was mechanically/native validated but Jojo rejected the voice; this draft rewrites the first screen and keeps implementation language out of visible copy. 
* Visible copy avoids current hours, ticket price, and specific exhibit claims beyond the supplied legacy notes.

### Freshness notes

* Recheck official/current museum access, open days, photo policy, and English interpretation before import.
* No schedule or price appears in visible copy.

### Score

28/30 — Stronger first screen and a clear small-museum behavior; capped for current venue facts, catalog confirmation for Sơn Trà, and no rendered proof.

### QA notes

* Replaceability test: pass — private garden-house, shade, Sơn Trà, old house materials, ceramics, fishing-life objects.
* Phrase card test: pass — 3 reusable museum/sightseeing phrase cards, no museum-name phrase card.
* Mentioned Here test: pass — natural route mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Cầu Rồng / Dragon Bridge — Da Nang — landmark

* `page_id: city-danang-place-dragon-bridge`
* `contentContract: speaklocal.place.app-detail.v2.2`
* `displayName: Cầu Rồng`
* `englishName: Dragon Bridge`
* `city: Đà Nẵng`
* `category: landmark`
* `pronunciation: kow rong`
* `target_hero_image: HeroCityDanangPlaceDragonBridge`
* `current_status_from_ledger: not_started`
* `closest canonical anchor: Dragon Bridge / Cầu Rồng`
* `anchor behavior copied: turn the famous object into one real decision — close and wet versus farther and cleaner`
* `how this page differs: this entry covers the bridge as a landmark and riverfront choice; the separate fire-show entry owns the timed crowd ritual`
* `owned traveler moment: choosing where to stand before crossing or photographing the bridge`
* `source basis: exact ledger row, City Places Catalog entry, and canonical Dragon Bridge behavior`   

### Phrase/audio status

* **Tôi có nên băng qua đường không?** — Should I cross the street?

  * `intent: confirm_street_crossing`
  * `phraseId: v900-dire-navi-should-i-cross-the-street`
  * `audioId: v900-dire-navi-should-i-cross-the-street`
  * `status: mapped`
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

  * `intent: ask_photo_permission`
  * `phraseId: sight-3`
  * `audioId: sight-3`
  * `status: mapped`
* **Bạn có thể chỉ ra một điểm mốc gần đó không?** — Can you point out a nearby landmark?

  * `intent: ask_nearby_landmark`
  * `phraseId: v900-dire-navi-can-you-point-out-a-nearby-landmark`
  * `audioId: v900-dire-navi-can-you-point-out-a-nearby-landmark`
  * `status: mapped`

Phrase source: directions and sightseeing ready-audio rows.   

### Mentioned Here candidates

* **Hàn River**

  * `type: river`
  * `catalogId: danang-han-river`
  * `sourceText: Hàn River`
  * `displaySubtitle: The riverfront frame that makes the bridge easier to read.`
  * `reason: Named naturally in the short-loop section.`
  * `status: render`
* **Love Bridge**

  * `type: landmark`
  * `catalogId: danang-love-bridge`
  * `sourceText: Love Bridge`
  * `displaySubtitle: A small riverfront pause near Dragon Bridge.`
  * `reason: Named naturally as a nearby walk pairing.`
  * `status: render`
* **Dragon Carp Statue**

  * `type: landmark`
  * `catalogId: danang-dragon-carp-statue`
  * `sourceText: Dragon Carp Statue`
  * `displaySubtitle: A quick photo foreground on the same riverfront walk.`
  * `reason: Named naturally as a nearby riverfront pairing.`
  * `status: render`

### Related place candidates

* **Dragon Bridge fire show**

  * `relationship: sibling_experience`
  * `catalogId: danang-dragon-bridge-fire-show`
  * `displaySubtitle: The timed crowd ritual connected to the bridge.`
  * `reason: Separate listing in this batch; useful comparison with the non-show landmark page.`
  * `status: render`
* **Hàn River**

  * `relationship: route_frame`
  * `catalogId: danang-han-river`
  * `displaySubtitle: Walk the riverbank for cleaner views and easier exits.`
  * `reason: Riverbank framing is central to the page.`
  * `status: render`
* **Sơn Trà Night Market**

  * `relationship: evening_pairing`
  * `catalogId: existing_or_null`
  * `displaySubtitle: A nearby night-market add-on after the bridge.`
  * `reason: Named in the canonical/source guidance as a natural pairing, but catalog ID needs confirmation.`
  * `status: check_catalog`

### Verification flags

* `type: same_week`

  * `reason: Any show-night schedule, crowd-control, traffic, and access details need same-week check.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm Sơn Trà Night Market catalog ID if rendering related card.`
  * `blocking: false`
* `type: audio_qa`

  * `reason: Confirm selected direction/photo phrase cards render cleanly and are not too long on device.`
  * `blocking: false`

### Source notes

* Ledger source notes: City library; Vietnam Tourism Da Nang.
* Canonical anchor already defines the close/wet versus riverbank/clean-view decision and same-week schedule caution. 
* Visible copy avoids current show times, traffic closures, police control, and exact side recommendations.

### Freshness notes

* Recheck official show schedule and riverfront access the same week before import.
* Keep schedule facts out of visible copy unless verified close to release.

### Score

29/30 — Strong canonical decision and clean sibling separation from the fire-show page; capped for same-week schedule/access checks and no rendered proof.

### QA notes

* Replaceability test: pass — dragon head, riverbank, spray, bridge traffic, skyline, nearby walk loop.
* Phrase card test: pass — 3 reusable traveler-action cards, no place-name card.
* Mentioned Here test: pass — natural riverfront place mentions mapped.
* Catalog mention scan: pass, with Sơn Trà Night Market held for catalog check.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Màn phun lửa Cầu Rồng / Dragon Bridge fire show — Da Nang — experience

* `page_id: city-danang-place-dragon-bridge-fire-show`
* `contentContract: speaklocal.place.app-detail.v2.2`
* `displayName: Màn phun lửa Cầu Rồng`
* `englishName: Dragon Bridge fire show`
* `city: Đà Nẵng`
* `category: experience`
* `pronunciation: mahn foon lua kow rong`
* `target_hero_image: HeroCityDanangPlaceDragonBridgeFireShow`
* `current_status_from_ledger: not_started`
* `closest canonical anchor: Dragon Bridge / Cầu Rồng`
* `anchor behavior copied: make timing, side choice, and crowd position more important than landmark facts`
* `how this page differs: this page owns the street-crowd ritual, not the bridge as a daytime/static landmark`
* `owned traveler moment: choosing a side and exit path before the burst`
* `source basis: exact ledger row and City Places Catalog experience entry`  

### Phrase/audio status

* **Mấy giờ?** — What time?

  * `intent: ask_time`
  * `phraseId: time-1`
  * `audioId: time-1`
  * `status: mapped`
* **Tôi có nên băng qua đường không?** — Should I cross the street?

  * `intent: confirm_street_crossing`
  * `phraseId: v900-dire-navi-should-i-cross-the-street`
  * `audioId: v900-dire-navi-should-i-cross-the-street`
  * `status: mapped`
* **Khu vực này có an toàn vào ban đêm không?** — Is this area safe at night?

  * `intent: ask_night_area_safety`
  * `phraseId: v900-sigh-acti-is-this-area-safe-at-night`
  * `audioId: v900-sigh-acti-is-this-area-safe-at-night`
  * `status: mapped`

Phrase source: time, directions, and sightseeing ready-audio rows.   

### Mentioned Here candidates

* **Dragon Bridge**

  * `type: landmark`
  * `catalogId: danang-dragon-bridge`
  * `sourceText: dragon head`
  * `displaySubtitle: The bridge itself, separate from the timed fire-and-water ritual.`
  * `reason: The visible copy refers to the dragon head and the whole experience depends on the bridge.`
  * `status: render`
* **Hàn River**

  * `type: river`
  * `catalogId: danang-han-river`
  * `sourceText: river`
  * `displaySubtitle: The riverfront setting for watching and leaving the show.`
  * `reason: Named naturally through the river and promenade framing.`
  * `status: render`

### Related place candidates

* **Dragon Bridge**

  * `relationship: parent_landmark`
  * `catalogId: danang-dragon-bridge`
  * `displaySubtitle: Learn the bridge-view decision before choosing the show crowd.`
  * `reason: Sibling/parent page in the same batch.`
  * `status: render`
* **Hàn River**

  * `relationship: viewing_route`
  * `catalogId: danang-han-river`
  * `displaySubtitle: The promenade gives the wider frame and easier movement.`
  * `reason: Riverfront position is central to the show experience.`
  * `status: render`
* **Sơn Trà Night Market**

  * `relationship: post_show_pairing`
  * `catalogId: existing_or_null`
  * `displaySubtitle: A nearby snack-and-walk option after the crowd disperses.`
  * `reason: Natural evening pairing from source/canonical guidance; catalog ID needs confirmation.`
  * `status: check_catalog`

### Verification flags

* `type: same_week`

  * `reason: Fire-show timing, frequency, crowd controls, traffic changes, and weather can materially affect the visit.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm Sơn Trà Night Market catalog target before rendering.`
  * `blocking: false`
* `type: audio_qa`

  * `reason: Confirm longer night-safety phrase fits phrase-card UI.`
  * `blocking: false`

### Source notes

* Ledger source notes: Vietnam Tourism Da Nang.
* The canonical Dragon Bridge guidance flags show schedule as same-week verification; this page keeps timing out of visible copy except for the reusable “What time?” phrase. 
* Visible copy avoids exact show days/times and current crowd-control claims.

### Freshness notes

* Same-week verification required for official show schedule, weather, riverfront access, traffic/pedestrian restrictions, and nearby night-market pairing.
* If schedule cannot be verified before import, keep only general show-position copy and do not render time-specific claims.

### Score

28/30 — Clear distinction from the bridge landmark page and strong crowd-position behavior; capped for same-week schedule risk, sibling overlap risk, and no rendered proof.

### QA notes

* Replaceability test: pass — scooters slowing, phones raised, dragon head glowing, burst/crowd movement.
* Phrase card test: pass — 3 reusable traveler-action cards, no fire-show-specific one-off phrase.
* Mentioned Here test: pass — natural parent landmark and river mapping.
* Catalog mention scan: pass, with Sơn Trà Night Market held for catalog check.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Tượng Cá Chép Hóa Rồng / Dragon Carp Statue — Da Nang — landmark

* `page_id: city-danang-place-dragon-carp-statue`
* `contentContract: speaklocal.place.app-detail.v2.2`
* `displayName: Tượng Cá Chép Hóa Rồng`
* `englishName: Dragon Carp Statue`
* `city: Đà Nẵng`
* `category: landmark`
* `pronunciation: too-uhng gah chep hoa rong`
* `target_hero_image: HeroCityDanangPlaceDragonCarpStatue`
* `current_status_from_ledger: not_started`
* `closest canonical anchor: Cầu Tình Yêu / Love Bridge`
* `anchor behavior copied: treat a small riverfront landmark as a short pause inside a wider Hàn River walk`
* `how this page differs: this stop is less about romance/locks and more about giving the riverfront a memorable foreground`
* `owned traveler moment: pausing for a riverfront photo frame between bridge stops`
* `source basis: exact ledger row and City Places Catalog landmark entry`  

### Phrase/audio status

* **Tôi chụp hình ở đây được không?** — Can I take photos here?

  * `intent: ask_photo_permission`
  * `phraseId: sight-3`
  * `audioId: sight-3`
  * `status: mapped`
* **Bạn có thể chỉ ra một điểm mốc gần đó không?** — Can you point out a nearby landmark?

  * `intent: ask_nearby_landmark`
  * `phraseId: v900-dire-navi-can-you-point-out-a-nearby-landmark`
  * `audioId: v900-dire-navi-can-you-point-out-a-nearby-landmark`
  * `status: mapped`
* **Tôi có nên băng qua đường không?** — Should I cross the street?

  * `intent: confirm_street_crossing`
  * `phraseId: v900-dire-navi-should-i-cross-the-street`
  * `audioId: v900-dire-navi-should-i-cross-the-street`
  * `status: mapped`

Phrase source: sightseeing and directions ready-audio rows.   

### Mentioned Here candidates

* **Hàn River**

  * `type: river`
  * `catalogId: danang-han-river`
  * `sourceText: Hàn River`
  * `displaySubtitle: The riverfront walk that gives the statue its frame.`
  * `reason: Named naturally in the intro and section copy.`
  * `status: render`
* **Dragon Bridge**

  * `type: landmark`
  * `catalogId: danang-dragon-bridge`
  * `sourceText: Dragon Bridge`
  * `displaySubtitle: The larger bridge view behind the smaller statue stop.`
  * `reason: Named naturally in the “Look Across” section.`
  * `status: render`
* **Love Bridge**

  * `type: landmark`
  * `catalogId: danang-love-bridge`
  * `sourceText: Love Bridge`
  * `displaySubtitle: Another short riverfront pause near the statue.`
  * `reason: Named naturally in the “Look Across” section.`
  * `status: render`

### Related place candidates

* **Dragon Bridge**

  * `relationship: riverfront_landmark_pairing`
  * `catalogId: danang-dragon-bridge`
  * `displaySubtitle: The larger bridge view that often sits behind the statue frame.`
  * `reason: Natural riverfront pairing in visible copy.`
  * `status: render`
* **Love Bridge**

  * `relationship: riverfront_walk_pairing`
  * `catalogId: danang-love-bridge`
  * `displaySubtitle: A nearby short stop for heart lanterns, locks, and river photos.`
  * `reason: Natural neighbor and visible mention.`
  * `status: render`
* **Dragon Bridge fire show**

  * `relationship: evening_pairing`
  * `catalogId: danang-dragon-bridge-fire-show`
  * `displaySubtitle: Add the timed show only after checking the current schedule.`
  * `reason: Same riverfront cluster; render only if schedule module does not imply unverified timing.`
  * `status: render`

### Verification flags

* `type: light`

  * `reason: Lighting, fountain/water feature behavior, access, nearby construction, and promenade conditions can change.`
  * `blocking: false`
* `type: catalog_qa`

  * `reason: Confirm all riverfront related cards open to the correct Da Nang targets.`
  * `blocking: false`
* `type: audio_qa`

  * `reason: Confirm longer nearby-landmark phrase wraps cleanly in card UI.`
  * `blocking: false`

### Source notes

* Ledger source notes: Da Nang Fantasticity; local map.
* Place catalog confirms the statue as a Da Nang landmark with the supplied hero target. 
* Visible copy avoids unsupported claims about fountain operation, lighting schedule, and current access.

### Freshness notes

* Recheck current promenade access, lighting, fountain/water feature status, and nearby work before import.
* Do not add exact lighting or fountain-timing claims without current verification.

### Score

28/30 — Clean small-landmark role and strong riverfront-linking value; capped for current access/lighting/fountain freshness, catalog render checks, and no screenshot proof.

### QA notes

* Replaceability test: pass — carp-dragon form, foreground, bridge lights, river promenade.
* Phrase card test: pass — 3 reusable photo/direction cards, no statue-name phrase card.
* Mentioned Here test: pass — natural riverfront landmarks mapped.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch QA pass

* Exact five rows used: yes.
* Replacements chosen: no.
* Reader View first: yes.
* Phrase cards: 2–3 each; all are reusable traveler-action phrases.
* Place-name-only phrase cards: none.
* One-off attraction/object phrases: none.
* Visible banned words/phrases from prompt: avoided.
* Headings varied: yes.
* Visible volatile claims about exact schedules, prices, doors, hours, policies, or current access: avoided.
* Mentioned Here and Related candidates evaluated: yes.
* Production-ready language: not used.
* Screenshot/prod gates: not_run.

## Codex handoff block

* `batch_id: batch_016`
* `page_ids: city-danang-place-domestic-terminal, city-danang-place-dong-dinh-museum, city-danang-place-dragon-bridge, city-danang-place-dragon-bridge-fire-show, city-danang-place-dragon-carp-statue`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none expected; Codex should verify mapped ready-audio IDs for v900-airp-bord-arri-where-is-the-arrivals-hall, v900-airp-bord-arri-where-is-the-grab-pickup-point, v900-airp-bord-arri-can-you-help-me-book-a-taxi, time-5, sight-3, v900-sigh-acti-is-there-an-english-guide, v900-dire-navi-should-i-cross-the-street, v900-dire-navi-can-you-point-out-a-nearby-landmark, time-1, v900-sigh-acti-is-this-area-safe-at-night`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: Dragon Bridge and Dragon Bridge fire show are sibling pages; preserve the landmark-vs-crowd distinction during Jojo review. Dong Dinh evidence is modest, so keep claims restrained. Dragon Carp should stay a short riverfront pause, not inflated landmark prose.`
* `source_freshness_risks: airport pickup/signage flows; Dong Dinh hours/photo/English interpretation/access; Dragon Bridge show schedule/traffic/riverfront access; fire-show timing/weather/crowd controls; Dragon Carp lighting/fountain/current promenade access`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
