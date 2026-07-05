SpeakLocal v2.2 BATCH_020 - Da Nang - 2026-05-26

Inputs checked: exact batch rows and batch controls, project voice rules, v2.2 app-detail contract, canonical example behavior, ledger/catalog rows, ready-audio phrase rows, and menu catalog coffee rows.       

## La Maison 1888 / La Maison 1888 — Da Nang — restaurant

### Reader View

**Make Dinner The Plan**

La Maison 1888 is the Da Nang meal to save for a night with its own pace. White tablecloths, a colonial-style room, and careful service matter more here than checking off local dishes between stops.

**Useful phrase cards**

* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Cho tôi bàn cho hai người nhé.”** — A table for two, please.
* **“Tính tiền giúp tôi.”** — Please let me pay.

**Sections**

**Arrive Ready To Slow Down**

This is not the meal to squeeze between the beach and a bridge walk. Leave room for the table rhythm: menus, drinks, pauses, and the feeling that dinner is the evening.

**Ask Before The Table Fills**

If ingredients, wine, allergies, or portion size matter, ask early. A polished room is easier when the first questions happen before the first course lands.

**Keep The Night Light Afterward**

The room does the heavy lifting. After dinner, choose a short ride, a quiet drink, or the hotel return instead of stacking the night with too many extra plans.

### Implementation Notes

**Source object basics**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-la-maison-1888`
* `displayName: La Maison 1888`
* `englishName: La Maison 1888`
* `city: Da Nang`
* `category: restaurant`
* `pronunciation: la maison eighteen eighty-eight`

**Closest canonical example:** Morning Glory Original — controlled restaurant behavior without turning the page into a review.
**Behavior copied:** Make the meal readable through one first move and a restrained ordering frame.
**How this page differs:** La Maison is an occasion meal, not a broad first-meal restaurant.
**Owned traveler moment:** Arriving for a special dinner and letting the table set the night’s pace.

**Phrase/audio status**

* “Cho tôi xem thực đơn được không?” — `intent: see_menu` · `phraseId: food-menu` · `audioId: food-menu` · `status: mapped`
* “Cho tôi bàn cho hai người nhé.” — `intent: request_table_for_two` · `phraseId: food-need-table` · `audioId: food-need-table` · `status: mapped`
* “Tính tiền giúp tôi.” — `intent: pay_now` · `phraseId: food-pay-now` · `audioId: coffee-7` · `status: mapped`

**Place-name pronunciation/audio**

* La Maison 1888 — `phraseId: city-danang-place-la-maison-1888` · `audioId: null` · `status: hide_until_audio`
* Render as name/pronunciation support only, not a visible traveler-action phrase card.

**Mentioned Here candidates**

* None. Visible copy does not naturally name a catalog food, street, or nearby place strongly enough to render a card.

**Related place candidates**

* None. No route/comparison card is necessary from this draft.

**Freshness notes**

* Same-week check before import: current venue status, MICHELIN status, chef/menu positioning, booking pattern, dress expectations, and holiday closures.
* Visible copy avoids unstable claims about price, menu, stars, chef, hours, reservations, and dress code.

**Source notes**

* Batch row source labels: Da Nang Fantasticity MICHELIN article; MICHELIN or venue source.
* Ledger legacy detail retained only where stable: white tablecloths, colonial-style room mood, table rhythm, evening meal energy.

**Score**

28/30 — Stronger occasion-meal frame after revision; capped for current venue/menu/recognition freshness and thin source detail.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all visible cards are reusable ready-audio traveler actions.
* Mentioned Here test: pass; no forced cards.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Tượng Phật Bà / Lady Buddha — Da Nang — landmark

### Reader View

**The Statue Belongs To The Pagoda**

Lady Buddha is the tall white figure people mean at Linh Ung Pagoda on Son Tra. Go for the statue, but leave time for temple courtyards, sea wind, and the view back over Da Nang.

**Useful phrase cards**

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Tôi có thể chụp ảnh ở đây được không?”** — Can I take a photo here?
* **“Dừng ở đây được rồi.”** — You can stop here.

**Sections**

**Quiet Before The View**

The statue is the reason most travelers come, but the setting is not just a lookout. Move through the courtyard slowly, keep voices down, and let the sea-facing scale appear as you walk.

**Name It With Context**

“Lady Buddha” usually works in English, but the local idea sits closer to **Tượng Phật Bà** at **Chùa Linh Ứng**. Adding Linh Ung or Son Tra helps a driver or hotel desk understand the stop.

**One Stop, Two Readings**

It can be a photo stop, a pagoda visit, or a wider Son Tra pause. The visit feels better when you do not rush the statue, the incense, and the coast into one quick glance.

### Implementation Notes

**Source object basics**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-lady-buddha`
* `displayName: Tượng Phật Bà`
* `englishName: Lady Buddha`
* `city: Da Nang`
* `category: landmark`
* `pronunciation: too-uhng fut bah`

**Closest canonical example:** Dragon Bridge — a simple landmark becomes useful when the traveler understands the real on-site choice.
**Behavior copied:** Turn a famous object into a practical visit decision, not a static description.
**How this page differs:** The decision is not where to stand; it is whether to treat the statue as a pagoda visit, not just a photo.
**Owned traveler moment:** Stepping from the ride into the pagoda courtyard and orienting the statue within the Son Tra setting.

**Phrase/audio status**

* “Lối vào ở đâu?” — `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* “Tôi có thể chụp ảnh ở đây được không?” — `intent: ask_photo_permission` · `phraseId: v900-sigh-acti-can-i-take-a-photo-here` · `audioId: v900-sigh-acti-can-i-take-a-photo-here` · `status: mapped`
* “Dừng ở đây được rồi.” — `intent: stop_here` · `phraseId: transport-stop-here` · `audioId: taxi-3` · `status: mapped`

**Place-name pronunciation/audio**

* Tượng Phật Bà — `phraseId: city-danang-place-lady-buddha` · `audioId: null` · `status: hide_until_audio`
* Render as pronunciation/name support only, not a visible traveler-action phrase card.

**Mentioned Here candidates**

* **Chùa Linh Ứng / Linh Ung Pagoda** — `type: landmark` · `catalogId: danang-linh-ung-pagoda` · `status: render`

  * `displaySubtitle: The pagoda setting around the Lady Buddha statue.`
  * `reason: Named naturally in intro and context section.`
* **Bán đảo Sơn Trà / Son Tra Peninsula** — `type: nature` · `catalogId: danang-son-tra` · `status: render`

  * `displaySubtitle: The coastal peninsula that frames the visit.`
  * `reason: Named naturally as location context.`
* **Da Nang** — `type: city` · `catalogId: null` · `status: check_catalog`

  * `displaySubtitle: The city seen from the pagoda side of Son Tra.`
  * `reason: City context appears naturally but city-card target needs Codex/catalog confirmation.`

**Related place candidates**

* **Chùa Linh Ứng / Linh Ung Pagoda** — `relationship: same_site_context` · `catalogId: danang-linh-ung-pagoda` · `status: render`

  * `displaySubtitle: The temple grounds that give the statue its setting.`
  * `reason: Directly useful for avoiding a duplicate mental model of statue versus pagoda.`
* **Bán đảo Sơn Trà / Son Tra Peninsula** — `relationship: route_context` · `catalogId: danang-son-tra` · `status: render`

  * `displaySubtitle: Add the wider peninsula if you want a longer coastal drive.`
  * `reason: Route planning naturally extends from Lady Buddha to the peninsula.`
* **Chuyến đi Sơn Trà / Son Tra wildlife drive** — `relationship: possible_extension` · `catalogId: danang-son-tra-wildlife-drive` · `status: check_catalog`

  * `displaySubtitle: A longer Son Tra plan when the road, weather, and timing fit.`
  * `reason: Useful route extension, but should not render until route suitability is checked.`

**Freshness notes**

* Light check before import: access route, photo expectations, current traffic/parking flow, and any temple guidance.
* Visible copy avoids unstable hours, rules, fees, and claims about exact statue height.

**Source notes**

* Batch row source labels: Vietnam Tourism Da Nang; Da Nang Fantasticity.
* Ledger stable context retained: statue at Linh Ung Pagoda on Son Tra, sea-facing city view, respectful pagoda setting.

**Score**

29/30 — Clearer landmark behavior and clean page separation from Linh Ung Pagoda; capped for access/photo guidance and native-speaker pronunciation QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; no place-name card used as a traveler action.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Chợ đêm Lê Duẩn / Le Duan Night Market — Da Nang — market

### Reader View

**A Short Night Browse**

Le Duan Night Market is a compact after-dark lane for clothing racks, small gifts, warm bulbs, and a little food smoke. Treat it as a short browse after dinner, not the whole night.

**Useful phrase cards**

* **“Cái này bao nhiêu?”** — How much is this?
* **“Bớt chút được không?”** — Can you lower it a little?
* **“Tôi lấy cái này.”** — I’ll take this one.

**Sections**

**One Lap Before Buying**

Walk the lane once before choosing. The market is easier when you know where the clothes, snacks, phone cases, and small gifts cluster instead of stopping at the first bright stall.

**Bargain Lightly**

This is a place for small decisions, not a long negotiation performance. Ask the price, smile, try one polite discount if it feels normal, then buy or keep moving.

**Small Scale Is The Point**

The stop can feel thin if you expect a full food crawl. It works better as a quick pocket of night color when the day needs one more walk before the hotel.

### Implementation Notes

**Source object basics**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-le-duan-night-market`
* `displayName: Chợ đêm Lê Duẩn`
* `englishName: Le Duan Night Market`
* `city: Da Nang`
* `category: market`
* `pronunciation: chuh dem leh zwan`

**Closest canonical example:** Hàn Market — define the market’s role before listing inventory.
**Behavior copied:** One first lap, restrained shopping behavior, and a clear market role.
**How this page differs:** Le Duan is a smaller night browse, not a central first-bearings market.
**Owned traveler moment:** Walking one compact night lane after dinner before deciding whether to buy anything.

**Phrase/audio status**

* “Cái này bao nhiêu?” — `intent: ask_price` · `phraseId: money-how-much` · `audioId: price-1` · `status: mapped`
* “Bớt chút được không?” — `intent: bargain_lightly` · `phraseId: money-lower-price` · `audioId: price-4` · `status: mapped`
* “Tôi lấy cái này.” — `intent: take_this_item` · `phraseId: money-take-this` · `audioId: price-7` · `status: mapped`

**Place-name pronunciation/audio**

* Chợ đêm Lê Duẩn — `phraseId: city-danang-place-le-duan-night-market` · `audioId: null` · `status: hide_until_audio`
* Render as pronunciation/name support only, not a visible traveler-action phrase card.

**Mentioned Here candidates**

* None. Copy deliberately avoids naming unsupported dish/stall items.

**Related place candidates**

* **Chợ Hàn / Han Market** — `relationship: market_contrast` · `catalogId: danang-han-market` · `status: render`

  * `displaySubtitle: A stronger daytime market for bearings, gifts, and central browsing.`
  * `reason: Useful contrast if traveler wants a fuller market stop.`
* **Chợ Cồn / Con Market** — `relationship: food_market_contrast` · `catalogId: null` · `status: check_catalog`

  * `displaySubtitle: A stronger food-first market if snacks matter more than a short browse.`
  * `reason: Useful contrast, but catalog ID was not confirmed in retrieved rows.`
* **Chợ đêm Sơn Trà / Son Tra Night Market** — `relationship: night_market_contrast` · `catalogId: danang-son-tra-night-market` · `status: render`

  * `displaySubtitle: A river-side evening market to compare if you are near Dragon Bridge.`
  * `reason: Useful night-market comparison in Da Nang.`

**Freshness notes**

* Same-week check before import: current operating status, hours, stall mix, exact lane footprint, and recent local-map status.
* Visible copy stays small and avoids current hours, prices, payment rules, named vendors, and specific dishes.

**Source notes**

* Batch row source labels: Da Nang local tourism source; local map.
* Ledger stable context retained: compact night shopping lane, clothes racks, warm bulbs, small gifts, food smoke, evening browse.

**Score**

28/30 — Cleaner scarce-evidence night-market copy after revision; capped for current market status, hours, stall mix, and thin source depth.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; all cards are ready-audio reusable market actions.
* Mentioned Here test: pass; no unsupported food cards forced.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Chùa Linh Ứng / Linh Ung Pagoda — Da Nang — landmark

### Reader View

**Temple Grounds Before The Sea View**

Linh Ung Pagoda is the Son Tra stop where courtyards, incense, sea wind, and Lady Buddha meet above Da Nang. The view is part of the visit, but the place still asks for temple manners.

**Useful phrase cards**

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Có được phép chụp ảnh không?”** — Is photography allowed?
* **“Gọi taxi giúp tôi được không?”** — Can you call a taxi for me?

**Sections**

**Move Like It Is Active**

Dress and walk as if people are there to pray, not only to take photos. Lower voices, give space around incense and altars, and let the courtyard set the pace.

**The Statue Sets The Scale**

Lady Buddha gives the complex its strongest visual pull. Find the statue, then look back toward the city and coast to understand why this pagoda feels tied to the peninsula.

**Leave Room For Son Tra**

The pagoda pairs naturally with a Son Tra drive, but it does not need to become a rushed checklist. If the weather, road, or group energy feels off, the temple grounds and view are enough.

### Implementation Notes

**Source object basics**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-linh-ung-pagoda`
* `displayName: Chùa Linh Ứng`
* `englishName: Linh Ung Pagoda`
* `city: Da Nang`
* `category: landmark`
* `pronunciation: choo-ah linh ung`

**Closest canonical example:** Museum of Cham Sculpture — slow the visit by giving the traveler a few things to notice instead of asking them to absorb everything.
**Behavior copied:** Prevent rushed looking by giving an order: temple manners, statue, view, peninsula context.
**How this page differs:** This is an active religious place and coastal landmark, not an indoor museum route.
**Owned traveler moment:** Entering the pagoda grounds and deciding whether to treat it as a temple visit or only a viewpoint.

**Phrase/audio status**

* “Lối vào ở đâu?” — `intent: ask_entrance` · `phraseId: v500-sigh-acti-where-is-the-entrance` · `audioId: v500-sigh-acti-where-is-the-entrance` · `status: mapped`
* “Có được phép chụp ảnh không?” — `intent: ask_photo_permission` · `phraseId: v900-sigh-acti-is-photography-allowed` · `audioId: v900-sigh-acti-is-photography-allowed` · `status: mapped`
* “Gọi taxi giúp tôi được không?” — `intent: call_taxi` · `phraseId: hotel-call-taxi` · `audioId: hotel-9` · `status: mapped`

**Place-name pronunciation/audio**

* Chùa Linh Ứng — `phraseId: city-danang-place-linh-ung-pagoda` · `audioId: audio-authored-chua-linh-ung-703e8f3b92` · `status: mapped`
* Render as pronunciation/name support only, not a visible traveler-action phrase card.

**Mentioned Here candidates**

* **Tượng Phật Bà / Lady Buddha** — `type: landmark` · `catalogId: danang-lady-buddha` · `status: render`

  * `displaySubtitle: The tall white statue inside the Linh Ung visit.`
  * `reason: Named naturally in intro and section copy.`
* **Bán đảo Sơn Trà / Son Tra Peninsula** — `type: nature` · `catalogId: danang-son-tra` · `status: render`

  * `displaySubtitle: The coastal peninsula around the pagoda.`
  * `reason: Named naturally as route and setting context.`
* **Da Nang** — `type: city` · `catalogId: null` · `status: check_catalog`

  * `displaySubtitle: The city view below the pagoda.`
  * `reason: City context appears naturally but city-card target needs Codex/catalog confirmation.`

**Related place candidates**

* **Tượng Phật Bà / Lady Buddha** — `relationship: same_site_landmark` · `catalogId: danang-lady-buddha` · `status: render`

  * `displaySubtitle: The statue most travelers associate with the pagoda.`
  * `reason: Directly useful paired listing.`
* **Bán đảo Sơn Trà / Son Tra Peninsula** — `relationship: route_pairing` · `catalogId: danang-son-tra` · `status: render`

  * `displaySubtitle: Continue only if weather, road, and timing make sense.`
  * `reason: Natural route context from the pagoda.`
* **Chuyến đi Sơn Trà / Son Tra wildlife drive** — `relationship: longer_route_extension` · `catalogId: danang-son-tra-wildlife-drive` · `status: check_catalog`

  * `displaySubtitle: A longer drive option when conditions are right.`
  * `reason: Helpful but should not render without route/access freshness check.`

**Freshness notes**

* Light check before import: entrance/access flow, photo expectations, road conditions, parking/ride pickup, and any temple-specific visitor guidance.
* Visible copy avoids exact hours, fees, statue measurements, current road restrictions, and animal/wildlife guarantees.

**Source notes**

* Batch row source labels: City library; Vietnam Tourism Da Nang.
* Ledger stable context retained: Son Tra setting, courtyards, incense, sea wind, city views, Lady Buddha.

**Score**

29/30 — Strong page separation from Lady Buddha and clear temple behavior; capped for access/photo/route freshness and native QA.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; place-name audio kept out of visible cards.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Cà phê Long / Long Coffee — Da Nang — cafe

### Reader View

**Sit Low And Let The Coffee Work**

Long Coffee is for the pause: low stools, iced glasses, metal phin coffee, and a room that keeps moving without asking much from you. Come between bigger plans, not as a laptop afternoon.

**Useful phrase cards**

* **“Cho tôi một cà phê sữa đá.”** — One iced milk coffee, please.
* **“Cho tôi cà phê đen đá.”** — I’d like an iced black coffee.
* **“Tính tiền giúp tôi.”** — Please let me pay.

**Sections**

**Order Simply**

Start with cà phê sữa đá if you want the classic sweet, strong version. Choose cà phê đen đá if you want the coffee darker and less softened.

**Stay For The Street Rhythm**

The point is the table, the ice, the phin, the small talk, and the way people come and go. It can still be memorable because nothing needs to perform for you.

**Leave Before It Becomes Errand Time**

Keep the stop short enough to stay pleasant. After one coffee and a little shade, move back into the day before heat, traffic, or another plan takes over.

### Implementation Notes

**Source object basics**

* `contentContract: speaklocal.place.app-detail.v2.2`
* `id: city-danang-place-long-coffee`
* `displayName: Cà phê Long`
* `englishName: Long Coffee`
* `city: Da Nang`
* `category: cafe`
* `pronunciation: kah feh long`

**Closest canonical example:** Cà phê Giảng — café ritual with one clear first order and a physical room cue.
**Behavior copied:** Make the café usable through the order and the room, not broad café praise.
**How this page differs:** Long Coffee is an old-school Da Nang pause, not an origin-story café.
**Owned traveler moment:** Sitting down for one Vietnamese coffee between heat, meals, and sightseeing.

**Phrase/audio status**

* “Cho tôi một cà phê sữa đá.” — `intent: order_iced_milk_coffee` · `phraseId: food-coffee-milk` · `audioId: coffee-1` · `status: mapped`
* “Cho tôi cà phê đen đá.” — `intent: order_iced_black_coffee` · `phraseId: food-coffee-black` · `audioId: coffee-2` · `status: mapped`
* “Tính tiền giúp tôi.” — `intent: pay_now` · `phraseId: food-pay-now` · `audioId: coffee-7` · `status: mapped`

**Place-name pronunciation/audio**

* Cà phê Long — `phraseId: city-danang-place-long-coffee` · `audioId: null` · `status: hide_until_audio`
* Render as pronunciation/name support only, not a visible traveler-action phrase card.

**Mentioned Here candidates**

* **Cà phê sữa đá / Vietnamese iced milk coffee** — `type: drink` · `catalogId: drink-ca-phe-sua-da` · `status: render`

  * `displaySubtitle: Sweet, strong Vietnamese iced milk coffee.`
  * `reason: Named naturally in order guidance and supported by Menu Catalog.`
* **Cà phê đen đá / Vietnamese iced black coffee** — `type: drink` · `catalogId: drink-ca-phe-den-da` · `status: render`

  * `displaySubtitle: Dark iced coffee without condensed milk.`
  * `reason: Named naturally in order guidance and supported by Menu Catalog.`
* **Phin coffee** — `type: drink/experience` · `catalogId: null` · `status: check_catalog`

  * `displaySubtitle: The slow metal filter behind many Vietnamese coffee orders.`
  * `reason: Mentioned naturally, but catalog target needs confirmation.`

**Related place candidates**

* **Cà phê sữa đá / Vietnamese iced milk coffee** — `relationship: order_pairing` · `catalogId: drink-ca-phe-sua-da` · `status: render`

  * `displaySubtitle: The classic sweet iced coffee order.`
  * `reason: Helps the café page connect to the drink catalog.`
* **Cà phê đen đá / Vietnamese iced black coffee** — `relationship: order_pairing` · `catalogId: drink-ca-phe-den-da` · `status: render`

  * `displaySubtitle: The stronger black iced coffee order.`
  * `reason: Helps traveler choose the simpler coffee alternative.`

**Freshness notes**

* Light check before import: current venue status, address, hours, seating style, and menu availability.
* Visible copy avoids exact hours, prices, branch claims, Wi-Fi/work policy, and current crowd pattern.

**Source notes**

* Batch row source label: Local cafe source.
* Ledger stable context retained: old-school Vietnamese coffee table, metal phin, low stools, iced glasses, slower pause.

**Score**

28/30 — Stronger café ritual and order behavior after revision; capped for thin local source detail and current venue/menu freshness.

**QA notes**

* Replaceability test: pass.
* Phrase card test: pass; ready-audio reusable coffee actions only.
* Mentioned Here test: pass.
* Catalog mention scan: pass.
* Duplicate body test: pass.
* Anti-cynicism test: pass.
* Screenshot review status: not_run.
* Production review gate: not_run.

---

## Batch QA sweep

* Exact five requested rows used; no replacements added.
* Phrase cards kept to 2–3 per listing.
* Place-name audio treated as pronunciation/name support only.
* No one-off attraction, dish, object, or venue phrases created.
* Reader View sections checked for duplicate bodies.
* Headings varied across the batch.
* Current hours, prices, access rules, menu details, chef/star claims, and schedules kept out of app-visible copy.

## Codex handoff block

* `batch_id: batch_020`
* `page_ids: city-danang-place-la-maison-1888, city-danang-place-lady-buddha, city-danang-place-le-duan-night-market, city-danang-place-linh-ung-pagoda, city-danang-place-long-coffee`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible cards; all selected visible cards come from Phrase Picker Ready Audio with ready status, but Codex should normalize phraseId/audioId from family_id/audio_key where the spreadsheet phrase_id cell is blank`
* `place_name_phrases: La Maison 1888 planned/hide_until_audio; Tượng Phật Bà planned/hide_until_audio; Chợ đêm Lê Duẩn planned/hide_until_audio; Chùa Linh Ứng ready pronunciation support only; Cà phê Long planned/hide_until_audio`
* `visible_copy_risks: La Maison 1888 and Long Coffee rely on thin venue-specific evidence; Le Duan Night Market should stay restrained unless local status is verified; no visible hours/prices/menu/current-policy claims included`
* `source_freshness_risks: La Maison 1888 current venue, menu, booking, chef/MICHELIN status; Le Duan Night Market current operating status, stall mix, lane footprint, hours; Long Coffee current address, hours, seating, menu; Lady Buddha/Linh Ung access, photo expectations, road/parking/ride pickup guidance`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
