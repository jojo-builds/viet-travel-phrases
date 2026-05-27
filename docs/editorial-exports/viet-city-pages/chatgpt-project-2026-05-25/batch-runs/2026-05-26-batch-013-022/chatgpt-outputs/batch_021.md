SpeakLocal v2.2 BATCH_021 - Da Nang - 2026-05-26

Source basis read: exact pasted batch constraints and rows, v2.2 source bundle/app-detail contract, and Copy Ledger/Catalogs including place rows and ready-audio phrase catalog.   

## 1. Lotte Mart Đà Nẵng / Lotte Mart Da Nang — Reader View

**A Cool-Aisle Reset**

Lotte Mart Đà Nẵng is the clean, air-conditioned errand stop for the part of the day when water, sunscreen, tissues, snacks, or a backup shirt matter more than atmosphere. Go in with a short list, come out with fewer small problems.

### Useful phrase cards

* **“Cho tôi chai nước.”** — A bottle of water, please.
* **“Tôi quẹt thẻ được không?”** — Can I pay by card?
* **“Trả ở đâu?”** — Where do I pay?

### Sections

**Bring The Ordinary List**

This is where the unglamorous things belong: water, sunscreen, toiletries, tissues, snacks, simple clothes, small gifts. It is a good stop before the beach, a ride south, or a room reset.

**Cool Down Before Calling The Car**

If the group is fading, take ten minutes inside before choosing the next move. Bags, water, and a clear pickup point make the taxi feel less scrambled.

**Market Texture Is Elsewhere**

For bargaining, fabric, food counters, and local-market noise, go to Hàn Market. Lotte is for posted prices, bright shelves, receipts, and lower decision pressure.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-lotte-mart`
* `displayName: Lotte Mart Đà Nẵng`
* `englishName: Lotte Mart Da Nang`
* `city: Da Nang`
* `category: market`
* `pronunciation: lotte mart da nang`
* `targetHeroImage: HeroCityDanangPlaceLotteMart`
* **Closest canonical anchor:** Chợ Hàn / Hàn Market.
* **Anchor behavior copied:** define the place’s practical role before listing inventory.
* **How this page differs:** this is not a working market; it is the low-friction supermarket reset.
* **Owned traveler moment:** indoor restock and regroup before the next taxi or beach move.

### Phrase/audio status

* **Cho tôi chai nước.** — `intent: buy_water` · `phraseId: store-1` · `audioId: store-1` · `status: mapped`
* **Tôi quẹt thẻ được không?** — `intent: ask_card_payment` · `phraseId: store-6` · `audioId: store-6` · `status: mapped`
* **Trả ở đâu?** — `intent: ask_pay_location` · `phraseId: shop-5` · `audioId: shop-5` · `status: mapped`
* Place-name audio: `city-danang-place-lotte-mart` is planned only; render as pronunciation support only after audio exists, otherwise `hide_until_audio`.

### Mentioned Here candidates

* **Chợ Hàn / Han Market** — `type: market` · `catalogId: danang-han-market` · `status: render`

  * `sourceText: For bargaining, fabric, food counters, and local-market noise, go to Hàn Market.`
  * `displaySubtitle: Central market for bargaining, food counters, fabric, and gifts.`
  * `reason: Natural market contrast in visible copy.`

### Related place candidates

* **Chợ Hàn / Han Market** — `relationship: market_contrast` · `catalogId: danang-han-market` · `status: render`

  * `displaySubtitle: Choose this when you want market texture instead of supermarket ease.`
  * `reason: Direct comparison helps travelers choose the right shopping stop.`

### Verification flags

* `type: light` · `reason: Current hours, floor layout, payment norms, and store services can change.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name audio is planned, not ready.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog rows but still need final native QA in import flow.` · `blocking: false`

### Source notes

* Ledger source label: Local map.
* Legacy row indicates hot/rainy/low-supply restock role, water/sunscreen/toiletries/snacks/groceries, posted shelves, and contrast with Hàn Market.
* Menu catalog: no food item rendered; visible copy mentions generic snacks only.

### Score

27/30 — Tight and usable, but capped for thin source evidence, current store-operation checks, and planned place-name audio.

### QA notes

* Replaceability test: pass; supermarket reset role is distinct from Hàn/Cồn market pages.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass; Hàn Market evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 2. Cầu Tình Yêu / Love Bridge — Reader View

**A Five-Minute River Pause**

Cầu Tình Yêu is a quick Hàn River stop near Dragon Bridge: heart lanterns, lock-covered railings, the Dragon Carp statue nearby, and one easy photo frame before the evening moves on.

### Useful phrase cards

* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Tôi chỉ xem thôi.”** — I’m just looking.
* **“Điểm đón ở đâu?”** — Where is the pickup point?

### Sections

**Sweet, Not Subtle**

The bridge is romantic in an obvious way. That is fine. Give it a few minutes, take the river angle, and leave before the pose starts feeling bigger than the place.

**Locks Need A Current Check**

If a lock matters, confirm where to buy one and whether the rules allow it that day. Otherwise, the railing and lanterns are enough.

**Fold It Into The River Walk**

Pair the stop with Dragon Bridge, the Dragon Carp statue, APEC Park, Sơn Trà Night Market, or a slow Hàn River walk.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-love-bridge`
* `displayName: Cầu Tình Yêu`
* `englishName: Love Bridge`
* `city: Da Nang`
* `category: landmark`
* `pronunciation: cow tinh yeu`
* `targetHeroImage: HeroCityDanangPlaceLoveBridge`
* **Closest canonical anchor:** Dragon Bridge / Cầu Rồng.
* **Anchor behavior copied:** turn a simple riverfront landmark into one clear decision and route pairing.
* **How this page differs:** Love Bridge is a shorter, softer photo pause, not a show-centered landmark.
* **Owned traveler moment:** evening river walk pause: photo, lock decision, then move on.

### Phrase/audio status

* **Tôi chụp hình ở đây được không?** — `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* **Tôi chỉ xem thôi.** — `intent: politely_decline_buying` · `phraseId: shop-4` · `audioId: shop-4` · `status: mapped`
* **Điểm đón ở đâu?** — `intent: ask_pickup_point` · `phraseId: directions-8` · `audioId: directions-8` · `status: mapped`
* Place-name audio: `city-danang-place-love-bridge` · `audioId: audio-authored-cau-tinh-yeu-dae5912687` · ready; render as pronunciation/name support, not as a visible phrase card.

### Mentioned Here candidates

* **Sông Hàn / Han River** — `type: river` · `catalogId: danang-han-river` · `status: render`

  * `sourceText: Cầu Tình Yêu is a quick Hàn River stop near Dragon Bridge.`
  * `displaySubtitle: The riverfront spine for bridges, evening walks, and light.`
  * `reason: Natural setting in intro and route section.`
* **Cầu Rồng / Dragon Bridge** — `type: landmark` · `catalogId: danang-dragon-bridge` · `status: render`

  * `sourceText: near Dragon Bridge`
  * `displaySubtitle: Nearby bridge landmark and evening route partner.`
  * `reason: Direct pairing in visible copy.`
* **Tượng Cá Chép Hóa Rồng / Dragon Carp Statue** — `type: landmark` · `catalogId: danang-dragon-carp-statue` · `status: render`

  * `sourceText: the Dragon Carp statue nearby`
  * `displaySubtitle: Riverfront statue beside the Love Bridge photo loop.`
  * `reason: Named nearby landmark in visible copy.`
* **Công viên APEC / APEC Park** — `type: park` · `catalogId: danang-apec-park` · `status: render`

  * `sourceText: APEC Park`
  * `displaySubtitle: Nearby riverfront park for an easy evening add-on.`
  * `reason: Listed as route pairing.`
* **Chợ đêm Sơn Trà / Sơn Trà Night Market** — `type: market` · `catalogId: danang-son-tra-night-market` · `status: render`

  * `sourceText: Sơn Trà Night Market`
  * `displaySubtitle: Nearby night-market add-on after the riverfront walk.`
  * `reason: Listed as route pairing.`

### Related place candidates

* **Cầu Rồng / Dragon Bridge** — `relationship: evening_route_pairing` · `catalogId: danang-dragon-bridge` · `status: render`

  * `displaySubtitle: Pair with Love Bridge when the riverfront is already the plan.`
  * `reason: Closest strong route partner and canonical comparison.`
* **Chợ đêm Sơn Trà / Sơn Trà Night Market** — `relationship: evening_food_add_on` · `catalogId: danang-son-tra-night-market` · `status: render`

  * `displaySubtitle: Add snacks after the short bridge pause.`
  * `reason: Natural nearby evening sequence.`
* **Công viên APEC / APEC Park** — `relationship: riverfront_walk_pairing` · `catalogId: danang-apec-park` · `status: render`

  * `displaySubtitle: Add a park pause to the Hàn River loop.`
  * `reason: Nearby riverfront pairing named in visible copy.`

### Verification flags

* `type: same_week` · `reason: Lock rules, lighting, access, crowd pattern, and any Dragon Bridge show pairing should be checked close to import.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog rows but still need final native QA in import flow.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm all route-pairing cards open to correct Da Nang targets.` · `blocking: false`

### Source notes

* Ledger source labels: City library; Da Nang Fantasticity.
* Legacy row supports heart lanterns, love locks, Dragon Bridge nearby, Dragon Carp statue, Hàn River evening route, APEC Park, and Sơn Trà Night Market pairing.
* Visible copy avoids current claims about lock availability, lighting time, or show schedules.

### Score

28/30 — Strong short-landmark route logic and clean voice; capped for same-week lock/lighting/access checks and final catalog QA.

### QA notes

* Replaceability test: pass; the heart lanterns, lock railings, Dragon Carp statue, and Hàn River route make it specific.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass; natural route/place mentions evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 3. Madame Lân / Madame Lan — Reader View

**Dinner With A Room Around It**

Madame Lân is the Da Nang restaurant to choose when the meal should feel like part of the night, not just a stop between Hàn River plans. Think courtyard, lantern light, shared plates, and enough polish to make a first Vietnamese dinner feel readable.

### Useful phrase cards

* **“Cho tôi bàn cho hai người nhé.”** — A table for two, please.
* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Tính tiền giúp tôi.”** — Please let me pay.

### Sections

**Read The Menu Before Ordering Wide**

The room makes it tempting to order too much. Choose one main, one vegetable or shared plate, then see the table size before adding more.

**Courtyard Time Beats A Rush**

If you land near the lanterned courtyard, give the meal a little time. This is one of the easier places in Da Nang to make dinner feel like a pause instead of another task.

**When The Group Needs Range**

It suits a group with different confidence levels: visitors who want Vietnamese food, someone who wants a clearer menu, and anyone tired of negotiating every detail.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-madame-lan`
* `displayName: Madame Lân`
* `englishName: Madame Lan`
* `city: Da Nang`
* `category: restaurant`
* `pronunciation: madame lan`
* `targetHeroImage: HeroCityDanangPlaceMadameLan`
* **Closest canonical anchor:** Morning Glory Original, with Bale Well as a secondary ordering-confidence reference.
* **Anchor behavior copied:** make a broad restaurant menu feel readable through one first ordering move.
* **How this page differs:** the page leans on room, courtyard, lanterns, and shared dinner rhythm rather than a dish-source or set-menu experience.
* **Owned traveler moment:** sitting down for a polished first Vietnamese dinner and resisting the urge to overorder.

### Phrase/audio status

* **Cho tôi bàn cho hai người nhé.** — `intent: request_table_for_two` · `phraseId: food-need-table` · `audioId: food-need-table` · `status: mapped`
* **Cho tôi xem thực đơn được không?** — `intent: ask_for_menu` · `phraseId: food-menu` · `audioId: food-menu` · `status: mapped`
* **Tính tiền giúp tôi.** — `intent: ask_to_pay` · `phraseId: coffee-7` · `audioId: coffee-7` · `status: mapped`
* Place-name audio: `city-danang-place-madame-lan` is planned only; render as pronunciation support only after audio exists, otherwise `hide_until_audio`.

### Mentioned Here candidates

* **Sông Hàn / Han River** — `type: river` · `catalogId: danang-han-river` · `status: render`

  * `sourceText: between Hàn River plans`
  * `displaySubtitle: Riverfront plan to pair before or after dinner.`
  * `reason: Natural route context in intro.`

### Related place candidates

* **Sông Hàn / Han River** — `relationship: before_after_dinner_route` · `catalogId: danang-han-river` · `status: render`

  * `displaySubtitle: Keep dinner near an easy riverfront walk.`
  * `reason: The listing positions Madame Lan as part of an evening river plan.`

### Verification flags

* `type: light` · `reason: Current hours, booking pattern, seating, and menu availability can change.` · `blocking: false`
* `type: catalog_qa` · `reason: No specific dish card is rendered until venue/menu source confirms stable items.` · `blocking: false`
* `type: audio_qa` · `reason: Place-name audio is planned, not ready.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog rows but still need final native QA in import flow.` · `blocking: false`

### Source notes

* Ledger source labels: Da Nang tourism and venue sources.
* Legacy row supports courtyard, lanterns, family-style dishes, table rhythm, house dishes, menu details, staff rhythm, and Hàn River light.
* Menu catalog checked; no dish-specific Mentioned Here card is forced because visible copy does not name a sourced dish.

### Score

28/30 — Stronger restaurant voice with a clear ordering behavior; capped for current menu/seating checks and planned place-name audio.

### QA notes

* Replaceability test: pass; courtyard, lantern light, shared-plate pacing, and Hàn River evening context make it specific.
* Phrase card test: pass; 3 reusable ready-audio restaurant phrases.
* Mentioned Here test: pass; Hàn River evaluated.
* Catalog mention scan: pass; no unsupported menu item forced.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 4. Biển Mân Thái / Man Thai Beach — Reader View

**Fishing Boats Before The Beach Day**

Biển Mân Thái is the beach scene to picture before Da Nang turns into hotel towers and sunbeds: fishing boats on sand, Sơn Trà hills behind them, and the morning still quiet.

### Useful phrase cards

* **“Cho tôi tới đây.”** — Take me here.
* **“Nhà vệ sinh gần nhất ở đâu?”** — Where is the nearest restroom?
* **“Điểm đón ở đâu?”** — Where is the pickup point?

### Sections

**Early Light, Working Sand**

Morning is when the boats and light make the place feel specific. Walk gently, keep out of working space, and treat the beach as more than a backdrop.

**Not The Easiest All-Day Setup**

For loungers, hotel services, and a more familiar swim plan, another beach may be easier. Mân Thái is better as a short coastal pause, photo walk, or seafood-side detour.

**Leave With A Pickup Plan**

The beach can feel quiet once you step away from the main road. Drop a pin before wandering and choose the pickup point while everyone still has energy.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-man-thai-beach`
* `displayName: Biển Mân Thái`
* `englishName: Man Thai Beach`
* `city: Da Nang`
* `category: beach`
* `pronunciation: byen man thai`
* `targetHeroImage: HeroCityDanangPlaceManThaiBeach`
* **Closest canonical anchor:** Lập An Lagoon, with scarce-evidence restraint.
* **Anchor behavior copied:** treat working water with dignity and give the traveler a route/timing cue rather than a generic scenic claim.
* **How this page differs:** this is a lighter beach pause, not a road-trip lagoon or full-day nature plan.
* **Owned traveler moment:** early morning walk near fishing boats, then a clear pickup plan.

### Phrase/audio status

* **Cho tôi tới đây.** — `intent: show_driver_destination` · `phraseId: taxi-1` · `audioId: taxi-1` · `status: mapped`
* **Nhà vệ sinh gần nhất ở đâu?** — `intent: ask_nearest_restroom` · `phraseId: v500-dire-navi-where-is-the-nearest-restroom` · `audioId: v500-dire-navi-where-is-the-nearest-restroom` · `status: mapped`
* **Điểm đón ở đâu?** — `intent: ask_pickup_point` · `phraseId: directions-8` · `audioId: directions-8` · `status: mapped`
* Place-name audio: `city-danang-place-man-thai-beach` · `audioId: audio-authored-bien-man-thai-397d136a26` · ready; render as pronunciation/name support, not as a visible phrase card.

### Mentioned Here candidates

* **Bán đảo Sơn Trà / Sơn Trà Peninsula** — `type: nature` · `catalogId: danang-son-tra` · `status: render`

  * `sourceText: Sơn Trà hills behind them`
  * `displaySubtitle: Green hillside backdrop and nearby coastal route.`
  * `reason: Natural geographic context in intro.`

### Related place candidates

* **Bán đảo Sơn Trà / Sơn Trà Peninsula** — `relationship: coastal_route_pairing` · `catalogId: danang-son-tra` · `status: render`

  * `displaySubtitle: Pair the beach pause with a Sơn Trà coastal plan.`
  * `reason: Visible copy names Sơn Trà hills and source context supports coastal pairing.`
* **Biển Mỹ Khê / My Khe Beach** — `relationship: beach_contrast` · `catalogId: danang-my-khe-beach` · `status: render`

  * `displaySubtitle: Easier choice for a more familiar beach setup.`
  * `reason: Helps compare Mân Thái’s quieter working-beach feel with a better-known beach option.`

### Verification flags

* `type: light` · `reason: Beach access, services, restroom availability, fishing activity, and pickup convenience can change.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm whether Sơn Trà should render as peninsula, district, or broader nature card.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog rows but still need final native QA in import flow.` · `blocking: false`

### Source notes

* Ledger source labels: City library; Da Nang Fantasticity.
* Legacy row supports fishing boats, quiet beach, Sơn Trà hills, early morning, sea air, sand, seafood, and coastal morning rhythm.
* Visible copy avoids claims about swimming conditions, lifeguards, vendor hours, restroom availability, or exact services.

### Score

27/30 — Distinct and observed, but capped for sparse evidence and changing beach conditions/services.

### QA notes

* Replaceability test: pass; fishing boats, working sand, Sơn Trà hills, and pickup planning keep it specific.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass; Sơn Trà evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass; expectation setting stays gentle.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## 5. Hang động Ngũ Hành Sơn / Marble Mountain cave walk — Reader View

**Stone Steps Before Shrine Light**

The Marble Mountain cave walk is the part of Ngũ Hành Sơn where the city drops away: stone steps, cave shade, incense, shrine light, and a slower kind of attention than the beach road asks for.

### Useful phrase cards

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?

### Sections

**Choose The Cave Pace**

This is not a flat photo stop. Expect steps, uneven stone, dimmer cave spaces, and places where quiet matters more than speed.

**Respect The Shrine Light**

Some corners feel more like worship spaces than sightseeing stops. Lower your voice, watch signs, and put the camera away when the space calls for it.

**Enough Without Every Viewpoint**

A cave walk can be enough if the heat or stairs start to win. Pair it with a café break or a ride back toward the beach instead of stacking every viewpoint.

### Implementation notes

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-marble-mountain-cave-walk`
* `displayName: Hang động Ngũ Hành Sơn`
* `englishName: Marble Mountain cave walk`
* `city: Da Nang`
* `category: experience`
* `pronunciation: hang dong ngu hanh son`
* `targetHeroImage: HeroCityDanangPlaceMarbleMountainCaveWalk`
* **Closest canonical anchor:** Museum of Cham Sculpture, with Bạch Mã condition-awareness as a secondary reference.
* **Anchor behavior copied:** prevent fatigue by narrowing attention and giving the traveler permission not to cover everything.
* **How this page differs:** this is physical, stepped, cave-and-shrine movement rather than a museum route.
* **Owned traveler moment:** entering the caves after stone steps and adjusting pace/respect before taking photos.

### Phrase/audio status

* **Vé bao nhiêu?** — `intent: ask_ticket_price` · `phraseId: sight-1` · `audioId: sight-1` · `status: mapped`
* **Lối vào ở đâu?** — `intent: ask_entrance_location` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* **Tôi chụp hình ở đây được không?** — `intent: ask_photo_permission` · `phraseId: sight-3` · `audioId: sight-3` · `status: mapped`
* Place-name audio: `city-danang-place-marble-mountain-cave-walk` is planned only; render as pronunciation support only after audio exists, otherwise `hide_until_audio`.
* Parent place-name audio available for **Ngũ Hành Sơn / Marble Mountains**: `city-danang-place-marble-mountains` · `audioId: audio-authored-ngu-hanh-son-7cd09d8626` · ready; use only if Codex chooses parent-place pronunciation support, not as a visible phrase card.

### Mentioned Here candidates

* **Ngũ Hành Sơn / Marble Mountains** — `type: landmark` · `catalogId: danang-marble-mountains` · `status: render`

  * `sourceText: the part of Ngũ Hành Sơn where the city drops away`
  * `displaySubtitle: The larger Marble Mountains site around the cave walk.`
  * `reason: Parent place named naturally in visible intro.`

### Related place candidates

* **Ngũ Hành Sơn / Marble Mountains** — `relationship: parent_place` · `catalogId: danang-marble-mountains` · `status: render`

  * `displaySubtitle: See the wider site around the cave walk.`
  * `reason: The cave walk is a sub-experience of the larger Marble Mountains place.`

### Verification flags

* `type: light` · `reason: Current ticketing, entrance routing, photo expectations, cave access, and stair/path conditions can change.` · `blocking: false`
* `type: audio_qa` · `reason: Exact cave-walk place-name audio is planned, not ready.` · `blocking: false`
* `type: catalog_qa` · `reason: Confirm parent Marble Mountains card relationship and avoid duplicate self-linking.` · `blocking: false`
* `type: native_speaker_qa` · `reason: Phrase cards are ready-audio catalog rows but still need final native QA in import flow.` · `blocking: false`

### Source notes

* Ledger source label: Vietnam Tourism Da Nang.
* Legacy row supports limestone cave entry area, shrine light, stone steps, respectful tone, route movement, and central-Vietnam beach rhythm.
* Visible copy avoids current claims about exact cave openings, hours, prices, elevator/stair availability, or photo rules.

### Score

28/30 — Clear physical moment and respectful pacing; capped for access/ticket/photo checks and planned exact place-name audio.

### QA notes

* Replaceability test: pass; stone steps, cave shade, shrine light, and pace/respect guidance are specific.
* Phrase card test: pass; 3 reusable ready-audio traveler-action phrases.
* Mentioned Here test: pass; parent Marble Mountains evaluated.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch-level QA

* Exact rows used: yes — no replacements.
* Reader View first for each listing: yes.
* Phrase cards: 2–3 each; all visible cards are reusable traveler-action phrases with ready audio.
* Place-name audio: kept as pronunciation/name support only.
* Menu/catalog use: checked; no unsupported dish claims forced.
* Visible copy hard-no scan: pass for the listed banned phrases and default heading scaffolds.
* Headings varied: pass.
* Public URLs omitted: pass.
* Google Doc created: no; chat output is canonical for handoff.
* Import status: draft/review only; not ready for import before Jojo voice approval and Codex validation.

## Codex handoff block

* `batch_id: batch_021`
* `page_ids: city-danang-place-lotte-mart, city-danang-place-love-bridge, city-danang-place-madame-lan, city-danang-place-man-thai-beach, city-danang-place-marble-mountain-cave-walk`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible phrase cards; all selected cards map to ready-audio Native Phrase Catalog rows, but Codex should verify IDs/audio keys during import`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; ready name support: city-danang-place-love-bridge, city-danang-place-man-thai-beach, parent city-danang-place-marble-mountains if needed; hide_until_audio/planned: city-danang-place-lotte-mart, city-danang-place-madame-lan, city-danang-place-marble-mountain-cave-walk`
* `visible_copy_risks: Lotte Mart and Man Thai Beach are thin-source listings; Madame Lan avoids dish-specific menu claims; Love Bridge avoids current lock/lighting claims; Marble Mountain cave walk avoids exact ticket/access/photo-rule claims`
* `source_freshness_risks: current hours, payment norms, supermarket layout, Love Bridge lock rules/lighting/access, Madame Lan menu/seating/operation, Man Thai Beach services/fishing activity/pickup conditions, Marble Mountain ticketing/entrance/photo rules/cave access/path conditions`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
