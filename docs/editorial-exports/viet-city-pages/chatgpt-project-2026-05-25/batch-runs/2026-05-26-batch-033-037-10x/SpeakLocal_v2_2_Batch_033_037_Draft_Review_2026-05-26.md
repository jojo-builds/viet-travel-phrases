# SpeakLocal v2.2 Batch 033-037 Draft Review

Date: 2026-05-26

Status: draft captured for Jojo voice review. These 50 listings are not import-ready or production-ready until voice approval, Codex phrase/audio/catalog mapping, source import, native regeneration, rendered review, and the v2.2 production gate.

Raw ChatGPT captures are preserved in `captured-handoffs-2026-05-26/`.

## Audit Summary

- Batch 033: 10 listings captured. Flags: quote-wrapped phrase cards, render/production gates not run.
- Batch 034: 10 listings captured. Flags: quote-wrapped phrase cards.
- Batch 035: 10 listings captured. Flags: numbered listing headings, uses canonical Useful phrase cards label, catalog checks remain, render/production gates not run.
- Batch 036: 10 listings captured. Flags: quote-wrapped phrase cards, uses canonical Useful phrase cards label, catalog checks remain, render/production gates not run.
- Batch 037: 10 listings captured. Flags: quote-wrapped phrase cards, uses canonical Useful phrase cards label, catalog checks remain, render/production gates not run.

## Drafts


---

# Batch 033

SpeakLocal v2.2 BATCH_033 - Hanoi - 2026-05-26

## Chợ Bưởi / Buoi Market — Hanoi — market

### Reader View

**Errands Before Souvenirs**

Chợ Bưởi feels like a neighborhood market still doing its own work. Plant pots, housewares, small stalls, snack counters, and scooters close to the lane give the place a practical Hanoi texture before anything feels staged for visitors.

**Phrase cards**

* **"Cái này bao nhiêu?"** — How much is this?
* **"Tôi chỉ xem thôi."** — I’m just looking.
* **"Trả ở đâu?"** — Where do I pay?

**Plants Give The First Read**

The plant stalls are the easiest way into the mood here. They make the market feel domestic and local: people choosing pots, carrying bags, comparing small goods, moving around each other in tight space.

**Browse Lightly**

One slow pass is enough. Look at the household goods, notice where people are actually buying, then ask a price only when you are ready to pause. Keep your bag close and step aside when scooters edge through.

**A Small Snack Is Enough**

If you eat here, keep it simple: one snack, one drink, or one quick stop at a counter that already has movement. This is a local-market browse more than a long food crawl.

### Implementation notes

* `page_id: city-hanoi-place-cho-buoi-market`
* Phrase/audio IDs: `price-1 / price-1` mapped; `shop-4 / shop-4` mapped; `shop-5 / shop-5` mapped.
* Place-name audio: `city-hanoi-place-cho-buoi-market` planned; hide name-audio until ready.
* Mentioned Here candidates: none to render from visible copy beyond current page.
* Related place candidates: `hanoi-dong-xuan-market` check as larger market contrast; `hanoi-quang-ba-flower-market` check if plant-market comparison is desired; `hanoi-long-bien-market` check as market-neighborhood contrast.
* Freshness notes: light check for current access, stall mix, and whether the visible plant/housewares emphasis still holds.
* Source notes: supplied row cites Hanoi tourism portal and legacy city-v1 handwritten source.
* Score: 26/30 — restrained and specific enough for sparse evidence; capped for thin current source detail and place-name audio.
* QA notes: replaceability test pass; phrase cards pass; Mentioned Here scan pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Đi cà phê Hà Nội / Hanoi coffee hop — Hanoi — experience

### Reader View

**Three Cups Make A Route**

A Hanoi coffee hop works when the city arrives in small pauses: one iced milk coffee on a low table, one richer café stop upstairs, and a short walk between corners. The cups matter, but the street between them does just as much.

**Phrase cards**

* **"Cho tôi một cà phê sữa đá."** — One iced milk coffee, please.
* **"Cho tôi cà phê đen đá."** — I’d like an iced black coffee.
* **"Tính tiền giúp tôi."** — Please let me pay.

**One Classic, One Richer Cup**

Start with a classic order you can recognize, like cà phê sữa đá or cà phê đen đá. Then add one richer Hanoi-style stop, such as egg coffee, if the day still wants something sweet and slow.

**Walk Between Cafés**

Do not stack cafés like errands. The good part is the shift between rooms: balcony signs, narrow stairs, old windows, motorbikes below, and the small reset before the next cup.

**Stop Before The Coffee Wins**

Two or three stops is usually enough. Share a sweet cup, drink water between cafés, and keep the route short enough that the final table still feels like a pleasure.

### Implementation notes

* `page_id: city-hanoi-place-coffee-hop`
* Phrase/audio IDs: `coffee-1 / coffee-1` mapped; `coffee-2 / coffee-2` mapped; `coffee-7 / coffee-7` mapped.
* Place-name audio: `city-hanoi-place-coffee-hop` planned; hide name-audio until ready.
* Mentioned Here candidates: `drink-ca-phe-sua-da` render; `drink-ca-phe-den-da` render; `hanoi-egg-coffee` render; `drink-ca-phe-trung` render.
* Related place candidates: `hanoi-dinh-cafe` render; `hanoi-giang-cafe` render; `hanoi-the-note-coffee` check; `hanoi-trieu-viet-vuong-coffee-street` check.
* Freshness notes: light check for any named venue pairing if Codex later adds specific stops.
* Source notes: supplied row cites Vietnam Travel Hanoi and legacy city-v1 handwritten source.
* Score: 27/30 — strong route behavior and reusable coffee phrases; capped for route specificity and planned place-name audio.
* QA notes: replaceability test pass; phrase cards pass; Mentioned Here scan needs catalog QA for drink/place modules; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Cộng Cà Phê / Cong Ca Phe — Hanoi — cafe

### Reader View

**A Pause With A Set Look**

Cộng Cà Phê is strongest as a controlled Hanoi coffee pause: green chairs, retro design cues, cold glasses, and enough room to slow the walk down for a while. Save it for the moment when the city heat needs a table.

**Phrase cards**

* **"Cho tôi xem thực đơn được không?"** — Can I see the menu?
* **"Ít đá thôi."** — Just a little ice.
* **"Tính tiền giúp tôi."** — Please let me pay.

**Cold Coffee Carries The Stop**

The safer move is a cold coffee order you can handle in the heat. If the menu has coconut coffee, bạc xỉu, or phin coffee, choose one clear drink rather than turning the table into a tasting flight.

**Notice The Room, Then Move On**

The design is part of the appeal, but the stop stays better when it stays short. Sit, cool down, watch the counter rhythm, and leave before the pause turns into a whole afternoon.

**Coffee Street If You Want More**

If you are near Triệu Việt Vương, the broader coffee-street mood can carry the next decision. Cộng can be the first table, not the only café memory.

### Implementation notes

* `page_id: city-hanoi-place-cong-ca-phe-trieu-viet-vuong`
* Phrase/audio IDs: `food-menu / food-menu` mapped; `coffee-4 / coffee-4` mapped; `coffee-7 / coffee-7` mapped.
* Place-name audio: `city-hanoi-place-cong-ca-phe-trieu-viet-vuong` planned; hide name-audio until ready.
* Mentioned Here candidates: `drink-ca-phe-cot-dua` render if coconut coffee remains in copy; `drink-bac-xiu` render; `drink-ca-phe-phin` render; `hanoi-trieu-viet-vuong-coffee-street` check.
* Related place candidates: `hanoi-coffee-hop` render; `hanoi-trieu-viet-vuong-coffee-street` check.
* Freshness notes: branch status, current menu, and exact local context need a late check because the supplied source is place-name only.
* Source notes: supplied row is place-name only plus legacy city-v1 handwritten source.
* Score: 26/30 — usable café ritual with limited claims; capped for place-name-only evidence and planned audio.
* QA notes: replaceability test needs_review because branch evidence is thin; phrase cards pass; Mentioned Here scan needs catalog QA; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Xích lô phố cổ / Old Quarter cyclo ride — Hanoi — experience

### Reader View

**The Old Quarter From Seat Height**

A cyclo ride changes the Old Quarter by lowering the speed. Shopfronts, hanging signs, parked scooters, and pedestrians pass close enough to notice, while someone else handles the traffic pattern you would usually thread on foot.

**Phrase cards**

* **"Cho tôi tới đây."** — Take me here.
* **"Tiền xe bao nhiêu?"** — How much is the fare?
* **"Dừng ở đây được rồi."** — You can stop here.

**Agree Before Rolling**

Confirm the rough route, time, and fare before you climb in. A short loop is easier to enjoy than a vague ride that keeps stretching through traffic.

**Passenger View, Not Fast Transport**

This is slow sightseeing, not the fastest way across town. Keep your phone and bag close, take photos carefully, and let the ride be about the old-lane texture rather than distance covered.

**Finish With A Walk**

The ride pairs well with a short Old Quarter walk after you get out. Once your feet are back on the pavement, the same streets feel easier to read.

### Implementation notes

* `page_id: city-hanoi-place-cyclo-old-quarter`
* Phrase/audio IDs: `taxi-1 / taxi-1` mapped; `transport-fare / transport-fare` mapped; `taxi-3 / taxi-3` mapped.
* Place-name audio: `city-hanoi-place-cyclo-old-quarter` planned; hide name-audio until ready.
* Mentioned Here candidates: `hanoi-old-quarter` render.
* Related place candidates: `hanoi-old-quarter-walking-tour` check; `hanoi-dong-xuan-market` render if paired in route cards; `hanoi-hoan-kiem-lake` render if added as nearby walking follow-up.
* Freshness notes: fare, route length, pickup point, and current street access need same-week checking before import.
* Source notes: supplied row cites Vietnam Travel Hanoi and legacy city-v1 handwritten source.
* Score: 27/30 — clear traveler friction and safe reusable phrases; capped for fare/access freshness.
* QA notes: replaceability test pass; phrase cards pass; Mentioned Here scan pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Cà phê Đinh / Dinh Cafe — Hanoi — cafe

### Reader View

**Find The Stairwell Before The Cup**

Cà phê Đinh is a small upstairs coffee pause near Hoàn Kiếm Lake. The arrival does half the work: find the Đinh Tiên Hoàng entrance, climb into the older room, then let the hot egg coffee make sense in that tight second-floor space.

**Phrase cards**

* **"Cho tôi xem thực đơn được không?"** — Can I see the menu?
* **"Không đường nhé."** — No sugar, please.
* **"Tính tiền giúp tôi."** — Please let me pay.

**The Climb Is Part Of It**

Do not rush the approach. The stairwell, small room, low tables, and lake-edge feeling are what separate the cup from a quick coffee counter.

**Hot Egg Coffee First**

If this is your first comparison stop, order hot cà phê trứng before chasing other drinks. The foam, bitterness, and small cup are easier to understand when the drink stays warm.

**Leave Before The Room Feels Full**

This is better as a short pause than a long wait. If the room is packed, let the lake walk continue and keep another nearby coffee stop in reserve.

### Implementation notes

* `page_id: city-hanoi-place-dinh-cafe`
* Phrase/audio IDs: `food-menu / food-menu` mapped; `coffee-5 / coffee-5` mapped; `coffee-7 / coffee-7` mapped.
* Place-name audio: `city-hanoi-place-dinh-cafe` planned; hide name-audio until ready.
* Mentioned Here candidates: `hanoi-egg-coffee` render; `drink-ca-phe-trung` render; `hanoi-hoan-kiem-lake` render; `hanoi-giang-cafe` render if comparison copy stays.
* Related place candidates: `hanoi-giang-cafe` render; `hanoi-the-note-coffee` check; `hanoi-coffee-hop` render.
* Freshness notes: current entrance path, hours, seating, balcony access, and menu need a late check.
* Source notes: supplied row cites Hanoi tourism portal; source bundle also carries Đinh Café model notes.
* Score: 28/30 — strong physical arrival sequence; capped for current venue checks and direct egg-coffee order audio gap.
* QA notes: replaceability test pass; phrase cards pass with generic ready audio only; Mentioned Here scan needs catalog QA; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Đống Đa / Dong Da — Hanoi — neighborhood

### Reader View

**A District For Ordinary Edges**

Đống Đa gives Hanoi a different scale: hotel streets, local shops, food counters, school-hour traffic, and small evenings that do not ask to be photographed. It matters most when your stay, meal, or walk is already nearby.

**Phrase cards**

* **"Ở gần đây không?"** — Is it near here?
* **"Đi bộ mất bao lâu?"** — How long does it take on foot?
* **"Cho tôi tới đây."** — Take me here.

**Name The Area Around Your Plan**

Đống Đa is too broad to wander as one idea. Pair the district name with a hotel, café, restaurant, or street on your map so the area becomes practical instead of abstract.

**Short Walks Beat Full Coverage**

Choose a small section and let the details do the work: storefront signs, parked scooters, coffee stops, school gates, and the slower rhythm after office hours.

**Evening Gives The Texture**

The district can feel most legible when people are coming home, buying dinner, or filling small cafés. That everyday movement is the point of recognizing the name.

### Implementation notes

* `page_id: city-hanoi-place-dong-da`
* Phrase/audio IDs: `directions-2 / directions-2` mapped; `directions-3 / directions-3` mapped; `taxi-1 / taxi-1` mapped.
* Place-name audio: `city-hanoi-place-dong-da` planned; hide name-audio until ready.
* Mentioned Here candidates: none to render from visible copy.
* Related place candidates: `hanoi-french-quarter` check as neighborhood contrast; `hanoi-old-quarter` check; `hanoi-tay-ho` check if neighborhood comparison module is desired.
* Freshness notes: sparse evidence; avoid adding named venues without current checks.
* Source notes: supplied row cites Hanoi tourism portal and legacy city-v1 handwritten source.
* Score: 26/30 — controlled broad-neighborhood draft; capped for scarce evidence and planned name audio.
* QA notes: replaceability test needs_review because neighborhood evidence is broad; phrase cards pass; Mentioned Here scan pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Chợ Đồng Xuân / Dong Xuan Market — Hanoi — market

### Reader View

**The Market With Volume**

Chợ Đồng Xuân is Hanoi at a bigger pitch: a market building, narrow aisles, goods stacked high, scooters at the edges, and snack stops around the flow. Go for one careful browse, not a calm boutique mood.

**Phrase cards**

* **"Cái này bao nhiêu?"** — How much is this?
* **"Bớt chút được không?"** — Can you lower it a little?
* **"Trả ở đâu?"** — Where do I pay?

**Walk The Edges First**

The outside gives a quick read before the aisles close in: scooters, signs, food movement, and people carrying goods in and out. Then decide whether the inside is worth your energy.

**Buy Small, Carry Less**

This is a better market for light browsing than heavy shopping on a hot day. Ask the price, check the total, and avoid buying more than you want to carry through the Old Quarter.

**Turn It Into An Old Quarter Link**

The market makes more sense as part of an Old Quarter walk than as a standalone block of time. Pair it with nearby streets, a snack, or a later night-market pass if the timing fits.

### Implementation notes

* `page_id: city-hanoi-place-dong-xuan`
* Phrase/audio IDs: `price-1 / price-1` mapped; `price-4 / price-4` mapped; `shop-5 / shop-5` mapped.
* Place-name audio: `city-hanoi-place-dong-xuan` ready; render name audio.
* Mentioned Here candidates: `hanoi-old-quarter` render; `hanoi-night-market-walk` check if night-market pairing remains; current page should not render as its own card.
* Related place candidates: `hanoi-cho-buoi-market` render as local-market contrast; `hanoi-long-bien-market` check; `hanoi-hang-da-market` check.
* Freshness notes: light check for current market access, hours, internal layout, and night-market pairing.
* Source notes: supplied row cites Vietnam Travel Hanoi and legacy city-v1 handwritten source.
* Score: 27/30 — clear market behavior and ready place-name audio; capped for current layout/hours checks.
* QA notes: replaceability test pass; phrase cards pass; Mentioned Here scan needs catalog QA for Old Quarter/night-market cards; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Cà phê trứng ở Hà Nội / Egg coffee — Hanoi — drink

### Reader View

**Coffee That Drinks Like Dessert**

Cà phê trứng is not just coffee with an egg note. The cup is small and rich, with strong coffee underneath a thick sweet foam. It slows a café stop down, especially in older Hanoi rooms where the stairs, cups, and low tables do part of the memory.

**Phrase cards**

* **"Cho tôi xem thực đơn được không?"** — Can I see the menu?
* **"Không đường nhé."** — No sugar, please.
* **"Tính tiền giúp tôi."** — Please let me pay.

**Hot Shows The Texture**

If it is your first cup, hot egg coffee makes the texture easier to understand: warm foam, bitter coffee, and a dessert-like finish in a small serving.

**One Cup Is Plenty**

This is richer than an everyday iced coffee. Share one if you are curious, or treat it as a sweet pause between walks instead of stacking it after a heavy meal.

**Compare Rooms, Not Winners**

Giảng, Đinh, and other Hanoi cafés each make the drink feel different because the room changes the ritual. The better comparison is the stairs, counter, cup, and mood, not just which version is “best.”

### Implementation notes

* `page_id: city-hanoi-place-egg-coffee`
* Phrase/audio IDs: `food-menu / food-menu` mapped; `coffee-5 / coffee-5` mapped; `coffee-7 / coffee-7` mapped.
* Place-name audio: `city-hanoi-place-egg-coffee` planned; hide name-audio until ready.
* Mentioned Here candidates: `drink-ca-phe-trung` render; `hanoi-giang-cafe` render; `hanoi-dinh-cafe` render; `hanoi-coffee-hop` render.
* Related place candidates: `hanoi-giang-cafe` render; `hanoi-dinh-cafe` render; `hanoi-the-note-coffee` check.
* Freshness notes: current café menus and branch status need late checks if specific venues are named in rendered cards.
* Source notes: supplied row cites Vietnam Travel Hanoi and Cafe Giang official site; menu catalog includes `drink-ca-phe-trung`.
* Score: 27/30 — strong drink ritual; capped because exact egg-coffee order phrase is not rendered as ready-audio.
* QA notes: replaceability test pass; phrase cards pass with generic ready audio only; Mentioned Here scan needs catalog QA; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Bảo tàng Dân tộc học / Vietnam Museum of Ethnology — Hanoi — museum

### Reader View

**Pick Three Objects, Then Go Outside**

Bảo tàng Dân tộc học opens Hanoi into the rest of Vietnam: textiles, tools, ritual objects, house forms, and outdoor structures that make the country feel larger than the capital. The better visit is selective, not exhaustive.

**Phrase cards**

* **"Vé bao nhiêu?"** — How much is the ticket?
* **"Bắt đầu ở đâu?"** — Where do we start?
* **"Tôi chụp hình ở đây được không?"** — Can I take photos here?

**Slow The First Gallery Down**

Choose three objects before reading everything: a textile, a tool, a ritual object, or a house detail. The museum becomes easier once you are looking for materials and daily life, not trying to absorb every label.

**Save Energy For The Courtyard**

The outdoor architecture gives the visit a second rhythm. Step outside with enough time to notice stairs, stilts, roofs, courtyards, and how different homes shape movement.

**A Quiet Counterweight To Street Days**

This is a good Hanoi pause when the Old Quarter has been loud and close. The museum gives context without asking you to keep moving through traffic.

### Implementation notes

* `page_id: city-hanoi-place-ethnology-museum`
* Phrase/audio IDs: `sight-1 / sight-1` mapped; `sight-2 / sight-2` mapped; `sight-3 / sight-3` mapped.
* Place-name audio: `city-hanoi-place-ethnology-museum` ready; render name audio.
* Mentioned Here candidates: `hanoi-old-quarter` render if the street-day contrast remains.
* Related place candidates: `hanoi-womens-museum` check; `hanoi-vietnam-fine-arts-museum` check; `hanoi-national-museum-history` check; `hanoi-temple-literature` check.
* Freshness notes: hours, ticketing, gallery access, photo policy, and temporary exhibit conditions need late checks.
* Source notes: supplied row cites Hanoi tourism portal and legacy city-v1 handwritten source.
* Score: 28/30 — strong museum-fatigue prevention and ready audio; capped for ticket/photo/current access checks.
* QA notes: replaceability test pass; phrase cards pass; Mentioned Here scan pass with one optional candidate; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Khu phố Pháp / French Quarter — Hanoi — neighborhood

### Reader View

**Wide Streets After Old Lanes**

Khu phố Pháp gives Hanoi a wider stride after the Old Quarter: broader boulevards, older facades, hotel doors, cafés, and scooters passing under trees. It works as a walk between a few nearby points, not a checklist.

**Phrase cards**

* **"Cho hỏi, đi tới đó thế nào?"** — Excuse me, how do I get there?
* **"Đi bộ mất bao lâu?"** — How long does it take on foot?
* **"Cho tôi tới đây."** — Take me here.

**Opera House As A Marker**

The Opera House area gives the walk a clean mental marker. From there, read the streets slowly: facades, shade, traffic crossings, café doors, and the shift away from Old Quarter density.

**Keep To Short Blocks**

The streets are wider, but Hanoi traffic still sets the pace. Cross carefully, pause when the shade is good, and let one café or museum edge be enough structure.

**Pair The Walk With The Lake**

Hoàn Kiếm Lake keeps the neighborhood from feeling detached from the rest of central Hanoi. A lake walk before or after the French Quarter makes the scale easier to understand.

### Implementation notes

* `page_id: city-hanoi-place-french-quarter`
* Phrase/audio IDs: `directions-1 / directions-1` mapped; `directions-3 / directions-3` mapped; `taxi-1 / taxi-1` mapped.
* Place-name audio: `city-hanoi-place-french-quarter` planned; hide name-audio until ready.
* Mentioned Here candidates: `hanoi-old-quarter` render; `hanoi-opera-house` render; `hanoi-hoan-kiem-lake` render.
* Related place candidates: `hanoi-french-quarter-walk` check; `hanoi-old-quarter` render; `hanoi-national-museum-history` check if museum pairing is added.
* Freshness notes: light check for current access around Opera House area, construction, closures, and named museum cards if rendered.
* Source notes: supplied row cites Vietnam Travel Hanoi and Hanoi tourism portal, plus legacy city-v1 handwritten source.
* Score: 27/30 — clear neighborhood route logic; capped for place-name audio and current access checks.
* QA notes: replaceability test pass; phrase cards pass; Mentioned Here scan needs catalog QA; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Codex handoff block

* `batch_id: batch_033`
* `page_ids: city-hanoi-place-cho-buoi-market, city-hanoi-place-coffee-hop, city-hanoi-place-cong-ca-phe-trieu-viet-vuong, city-hanoi-place-cyclo-old-quarter, city-hanoi-place-dinh-cafe, city-hanoi-place-dong-da, city-hanoi-place-dong-xuan, city-hanoi-place-egg-coffee, city-hanoi-place-ethnology-museum, city-hanoi-place-french-quarter`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none rendered; all visible phrase cards use ready-audio reusable traveler-action phrases`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; ready for Dong Xuan Market and Vietnam Museum of Ethnology; planned/hidden for Buoi Market, Hanoi coffee hop, Cong Ca Phe, Old Quarter cyclo ride, Dinh Cafe, Dong Da, Egg coffee, French Quarter`
* `visible_copy_risks: sparse evidence for Buoi Market, Cong Ca Phe branch, and Dong Da; exact egg-coffee order line not rendered because ready-audio mapping was not confirmed`
* `source_freshness_risks: market access/layout, branch status, cafe menus, cyclo fare/route/pickup, museum hours/tickets/photo policy, neighborhood construction or access changes`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`

---

# Batch 034

SpeakLocal v2.2 BATCH_034 - Hanoi - 2026-05-26

## Đi bộ khu phố Pháp / French Quarter walk — Hanoi — experience

### Reader View

**Wider Streets After The Old Quarter**

The French Quarter gives Hanoi more shoulder room: broad pavements, shade, pale old facades, and corners where the city slows down without going quiet. It is a good walk when the Old Quarter has started to feel too tight but you still want Hanoi under your feet.

**Phrase cards**

* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Tôi có thể đi bộ tới đó được không?”** — Can I walk there?
* **“Tôi có nên băng qua đường không?”** — Should I cross the street?

**Read The Corners, Not A Checklist**

Pick two or three points and let the streets between them do some of the work. The Opera House, museum edges, leafy blocks, and the return toward Hoàn Kiếm give the walk shape without turning it into a building hunt.

**Give The Sidewalks Time**

The appeal is in the spacing: tree shade, doorways, embassies, cafe edges, and traffic that feels wider than the old lanes. Walk slower here than you would through a snack street.

**Pair It With A Lake Loop**

The walk lands cleanly before or after Hoàn Kiếm. It gives the day a calmer middle section between Old Quarter lanes, coffee stops, and the bigger public buildings east of the lake.

### Implementation notes

* IDs: `page_id: city-hanoi-place-french-quarter-walk`; `place_catalog_id: hanoi-french-quarter-walk`; `hero: HeroCityHanoiPlaceFrenchQuarterWalk`.
* Phrase/audio: `directions-3` ready; `v500-dire-navi-can-i-walk-there` ready; `v900-dire-navi-should-i-cross-the-street` ready.
* Place-name audio: `city-hanoi-place-french-quarter-walk` planned; hide name phrase until audio.
* Mentioned Here candidates: `hanoi-french-quarter` render/check; `hanoi-opera-house` render/check; `hanoi-hoan-kiem-lake` render/check; `hanoi-national-museum-history` render/check if named-card density allows.
* Related place candidates: `hanoi-old-quarter` route contrast; `hanoi-old-quarter-walking-tour` route pairing.
* Freshness/source notes: Vietnam Travel Hanoi and Hanoi tourism portal; visible copy avoids hours, ticketing, closures, or specific access rules.
* Score/QA: 27/30 draft; phrase cards use ready reusable audio; mention scan done; duplicate body pass; render/screenshot review not run.

## Gia / Gia — Hanoi — restaurant

### Reader View

**A Meal With Its Own Clock**

Gia is a Hanoi dinner to plan around, not one to squeeze between errands. The room reads quiet and modern, the food is meant to arrive in a considered rhythm, and the first move is to arrive with time, not with the next errand already pressing.

**Phrase cards**

* **“Tôi có thể đặt chỗ được không?”** — Can I make a reservation?
* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Tính tiền giúp tôi.”** — Please let me pay.

**Book Before The Day Gets Full**

A polished meal is easier when it has its own slot. Keep the afternoon light, confirm the booking path before you go, and do not stack the table after a heavy snack crawl.

**The Table Sets The Pace**

This is the opposite of grabbing a bowl and moving on. Expect the staff rhythm, drinks, pacing, and quiet room to matter as much as any single plate.

**Ask Early About Limits**

If shellfish, pork, alcohol, or spice matters, say it before the meal starts. Fine dining is usually better at handling questions early than rescuing a table halfway through.

### Implementation notes

* IDs: `page_id: city-hanoi-place-gia`; `place_catalog_id: hanoi-gia`; `hero: HeroCityHanoiPlaceGia`.
* Phrase/audio: `v500-time-date-book-can-i-make-a-reservation` ready; `food-menu` ready; `coffee-7` ready.
* Place-name audio: `city-hanoi-place-gia` planned; hide name phrase until audio.
* Mentioned Here candidates: none in visible copy beyond the venue.
* Related place candidates: `hanoi-tam-vi` restaurant contrast; `hanoi-hibana-by-koki` fine-dining comparison; render only after catalog QA.
* Freshness/source notes: MICHELIN Vietnam 2025 and MICHELIN Hanoi guide; verify current booking flow, menu format, opening status, and holiday closures before import.
* Score/QA: 27/30 draft; no menu items forced; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Ga Gia Lâm / Gia Lam Railway Station — Hanoi — station

### Reader View

**A Quieter Rail Edge Of Hanoi**

Gia Lam Railway Station feels like a travel-day handoff rather than a sightseeing stop: signs, benches, bags, and the small pause before the city resumes. When a ticket points here, slow down enough to confirm the station name before following the crowd.

**Phrase cards**

* **“Tôi có thể mua vé ở đâu?”** — Where can I buy a ticket?
* **“Đây có đúng bến không?”** — Is this the right platform?
* **“Chuyến tàu này có bị trễ không?”** — Is this train delayed?

**Check The Name Twice**

Hanoi has more than one rail stop in traveler conversation. Match the Vietnamese name, the ticket, and the ride-hailing pin before you relax.

**Keep The Exit Plain**

This is a place for simple moves: collect bags, find the correct door, choose a ride, and leave the station area without turning the handoff into a wandering plan.

**Do Less With Luggage**

A station can make the city feel immediate, but bags make small mistakes heavier. Save the coffee stop or first walk for after you have dropped things off.

### Implementation notes

* IDs: `page_id: city-hanoi-place-gia-lam-station`; `place_catalog_id: hanoi-gia-lam-station`; `hero: HeroCityHanoiPlaceGiaLamStation`.
* Phrase/audio: `v900-tran-where-can-i-buy-a-ticket` ready; `transport-1` ready; `v500-tran-is-this-train-delayed` ready.
* Place-name audio: `city-hanoi-place-gia-lam-station` planned; hide name phrase until audio.
* Mentioned Here candidates: none; station copy stays thin-source and practical.
* Related place candidates: `hanoi-hanoi-railway-station` central-station comparison; `hanoi-noi-bai-airport` arrival/departure planning if broader transport cards render.
* Freshness/source notes: place-name-only row; verify route service, signage, access, and ride pickup before import.
* Score/QA: 26/30 draft; intentionally restrained for sparse evidence; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Cà phê Giảng / Cafe Giang — Hanoi — cafe

### Reader View

**Go Hot For The First Cup**

Cà phê Giảng is still best approached as one clear Hanoi coffee ritual: find the narrow Nguyễn Hữu Huân entrance, sit close, and order hot cà phê trứng before comparing anything else. The cup is small, rich, and closer to dessert than a normal caffeine stop.

**Phrase cards**

* **“Tôi có lên lầu không?”** — Do I go upstairs?
* **“Chúng ta đặt hàng ở đây hay tại quầy?”** — Do we order here or at the counter?
* **“Làm ơn bớt đường đi.”** — Less sugar, please.

**Narrow Door, Close Tables**

Expect an old-school room more than a lounge. The tight seating and quick turnover are part of the visit, so make the order simple and keep the pause small.

**The Texture Is The Point**

Hot egg coffee gives the thick cream its best chance: warm, sweet, and foamy over dark coffee. Treat it like a small dessert cup, not an all-afternoon cafe session.

**Compare Later If You Want**

Nguyễn Hữu Huân has become a natural coffee street for travelers. Giảng is the origin-heavy stop; Đinh or The Note can wait for another lake-side coffee moment.

### Implementation notes

* IDs: `page_id: city-hanoi-place-giang-cafe`; `place_catalog_id: hanoi-giang-cafe`; `hero: HeroCityHanoiPlaceGiangCafe`.
* Phrase/audio: `v500-dire-navi-do-i-go-upstairs` ready; `v900-food-drin-do-we-order-here-or-at-the-counter` ready; `v900-food-drin-less-sugar-please` ready.
* Place-name audio: `city-hanoi-place-giang-cafe` ready; render name pronunciation support. Egg-coffee order line from menu catalog is text-only; do not render as audio phrase unless mapped.
* Mentioned Here candidates: `drink-ca-phe-trung` render/check; `hanoi-egg-coffee` render/check; `hanoi-nguyen-huu-huan-street` render/check; `hanoi-old-quarter` render/check.
* Related place candidates: `hanoi-dinh-cafe` coffee comparison; `hanoi-the-note-coffee` coffee-route contrast.
* Freshness/source notes: Cafe Giang official site and menu catalog; verify current branch/address details, hours, seating flow, and menu availability before import.
* Score/QA: 28/30 draft; strong ritual shape; phrase cards ready and reusable; duplicate body pass; render/screenshot review not run.

## Bến xe Giáp Bát / Giap Bat Bus Station — Hanoi — station

### Reader View

**Bags First, City Second**

Giap Bat Bus Station is a practical Hanoi edge: awnings, signs, luggage, waiting benches, and the first view back into the city. Treat it as a place to get oriented, confirm the right bay, and move cleanly into the next ride.

**Phrase cards**

* **“Đây có đúng bến không?”** — Is this the right platform?
* **“Khi nào có chuyến xe buýt tiếp theo?”** — When is the next bus?
* **“Tôi có thể đặt túi của tôi ở đây được không?”** — Can I put my bag here?

**Confirm Before You Sit**

Bus stations can look obvious until the bay changes or a sign is easy to miss. Ask once, then wait where your bag and the route board are both in view.

**Keep Pickups Simple**

For ride-hailing or a taxi, choose a clear door or visible curb rather than drifting through traffic with luggage. The cleaner exit is usually better than the closest one.

**Save Hanoi For After The Transfer**

The station gives a real slice of travel-day Hanoi, but it does not need extra romance. Get the bag, confirm the ride, then let the city return outside the station.

### Implementation notes

* IDs: `page_id: city-hanoi-place-giap-bat-bus-station`; `place_catalog_id: hanoi-giap-bat-bus-station`; `hero: HeroCityHanoiPlaceGiapBatBusStation`.
* Phrase/audio: `transport-1` ready; `v500-tran-when-is-the-next-bus` ready; `v500-tran-can-i-put-my-bag-here` ready.
* Place-name audio: `city-hanoi-place-giap-bat-bus-station` planned; hide name phrase until audio.
* Mentioned Here candidates: none; station copy stays transfer-focused.
* Related place candidates: `hanoi-my-dinh-bus-station` route comparison; `hanoi-nuoc-ngam-bus-station` route comparison.
* Freshness/source notes: place-name-only row; verify current route operations, signage, pickup norms, and station access before import.
* Score/QA: 26/30 draft; sparse evidence handled with restrained claims; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Phố Hàng Bạc / Hang Bac Street — Hanoi — street

### Reader View

**Follow The Silver-Shop Thread**

Hàng Bạc gives the Old Quarter a clear line to follow: jewelry signs, narrow shopfronts, scooters, crossings, and that small flash of metal in the windows. It is a street to read slowly, not a shopping race.

**Phrase cards**

* **“Tôi chỉ xem thôi.”** — I’m just looking.
* **“Cái này bao nhiêu?”** — How much is this?
* **“Tôi có nên băng qua đường không?”** — Should I cross the street?

**Browse Before Buying**

The first few windows teach you the rhythm. Look, compare, and ask lightly before turning one shopfront into a decision.

**Mind The Moving Street**

This is still a working Old Quarter lane. Scooters, shop stools, delivery bags, and people stepping out of doorways all matter more than a straight walking line.

**Fold It Into The Old Quarter**

Hàng Bạc is strongest as part of a short Old Quarter walk, especially when paired with nearby lanes, coffee, or a market stop rather than stretched into a long errand.

### Implementation notes

* IDs: `page_id: city-hanoi-place-hang-bac-street`; `place_catalog_id: hanoi-hang-bac-street`; `hero: HeroCityHanoiPlaceHangBacStreet`.
* Phrase/audio: `shop-4` ready; `price-1` ready; `v900-dire-navi-should-i-cross-the-street` ready.
* Place-name audio: `city-hanoi-place-hang-bac-street` ready; render name pronunciation support.
* Mentioned Here candidates: `hanoi-old-quarter` render/check.
* Related place candidates: `hanoi-hang-gai-street` nearby shopping-street comparison; `hanoi-dong-xuan-market` market pairing if route cards are wanted.
* Freshness/source notes: Vietnam Travel Hanoi; verify current shop mix only if specific stores are later named.
* Score/QA: 27/30 draft; street role is clear and not overclaimed; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Chợ Hàng Da / Hang Da Market — Hanoi — market

### Reader View

**Browse Once Before Asking Prices**

Hang Da Market is better with a slow first lap: outside shops, scooters, small goods, bags, and a compact buying rhythm. Go in for a browse and a few practical interactions rather than a full food-market crawl.

**Phrase cards**

* **“Cái này bao nhiêu?”** — How much is this?
* **“Bớt chút được không?”** — Can you lower it a little?
* **“Trả ở đâu?”** — Where do I pay?

**One Lap Calms The Room**

Markets are easier once you know where the stalls, exits, and quieter corners are. Walk first, then decide whether to ask about a small item.

**Keep Bargaining Light**

A small discount question is enough. If the answer is no, smile, thank them, and move on without turning the exchange into a performance.

**Snacks Stay Secondary**

Treat any food or drink here as a small pause unless current stall evidence says more. The steadier pull is the browsing rhythm and everyday shopping texture.

### Implementation notes

* IDs: `page_id: city-hanoi-place-hang-da-market`; `place_catalog_id: hanoi-hang-da-market`; `hero: HeroCityHanoiPlaceHangDaMarket`.
* Phrase/audio: `price-1` ready; `price-4` ready; `shop-5` ready.
* Place-name audio: `city-hanoi-place-hang-da-market` planned; hide name phrase until audio.
* Mentioned Here candidates: none; no specific foods or shops named in visible copy.
* Related place candidates: `hanoi-dong-xuan-market` bigger-market comparison; `hanoi-old-quarter` nearby route context.
* Freshness/source notes: Hanoi tourism portal; verify current hours, stall mix, and any renovation/access changes before import.
* Score/QA: 27/30 draft; market behavior is clear without inventing inventory; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Phố Hàng Gai / Hang Gai Street — Hanoi — street

### Reader View

**Silk Windows Make The Street Legible**

Hang Gai is one of the Old Quarter streets that quickly explains itself: silk signs, fabric displays, polished windows, scooters, and hotel-side foot traffic. It is useful as a short walking spine when you want the neighborhood to feel less random.

**Phrase cards**

* **“Tôi chỉ xem thôi.”** — I’m just looking.
* **“Cái này bao nhiêu?”** — How much is this?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?

**Look First, Shop Later**

The street is easier if you separate browsing from buying. Take one pass for windows and shop tone, then return only if something actually holds your attention.

**Keep The Walk Compact**

Hàng Gai works well as a connector between lake-side walking, Old Quarter lanes, and a coffee break. A short section is enough to understand the street.

**Watch The Curb More Than The Map**

The name may be clear, but the pavement is still Hanoi: scooters, delivery stops, uneven edges, and people moving faster than you expect.

### Implementation notes

* IDs: `page_id: city-hanoi-place-hang-gai-street`; `place_catalog_id: hanoi-hang-gai-street`; `hero: HeroCityHanoiPlaceHangGaiStreet`.
* Phrase/audio: `shop-4` ready; `price-1` ready; `directions-3` ready.
* Place-name audio: `city-hanoi-place-hang-gai-street` ready; render name pronunciation support.
* Mentioned Here candidates: `hanoi-old-quarter` render/check; `hanoi-hoan-kiem-lake` render/check if lake-side route mention is kept.
* Related place candidates: `hanoi-hang-bac-street` nearby shopping-street comparison; `hanoi-st-joseph-cathedral` nearby walking extension if route cards are wanted.
* Freshness/source notes: Vietnam Travel Hanoi; verify current shop mix only if named stores are later added.
* Score/QA: 27/30 draft; concise street-spine behavior; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Cột cờ Hà Nội / Hanoi Flag Tower — Hanoi — landmark

### Reader View

**History You Can Read In Stone**

Hanoi Flag Tower makes the city’s past feel physical: old walls, stone paths, courtyard space, and the red flag lifting above the surrounding roofs. It is a compact landmark, but the scale gives the stop weight.

**Phrase cards**

* **“Lối vào ở đâu?”** — Where is the entrance?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Mấy giờ đóng cửa?”** — What time does it close?

**Look At The Base Before The Flag**

The flag is the obvious image, but the older stone, gates, and ground-level proportions carry more of the mood. Give the base a minute before stepping back for photos.

**Keep Ba Đình In The Frame**

The tower sits better when you understand the wider public space around it: broad roads, official buildings, old walls, and the slower pace of this part of Hanoi.

**A Short Stop Can Be Enough**

You do not need to stretch the visit. A careful look, a few photos, and a nearby walk can make the landmark feel complete without museum fatigue.

### Implementation notes

* IDs: `page_id: city-hanoi-place-hanoi-flag-tower`; `place_catalog_id: hanoi-hanoi-flag-tower`; `hero: HeroCityHanoiPlaceHanoiFlagTower`.
* Phrase/audio: `v500-sigh-acti-where-is-the-entrance` ready; `sight-3` ready; `sight-4` ready.
* Place-name audio: `city-hanoi-place-hanoi-flag-tower` planned; hide name phrase until audio.
* Mentioned Here candidates: `hanoi-ba-dinh-district` render/check; `hanoi-ba-dinh-square` render/check if card density allows.
* Related place candidates: `hanoi-temple-literature` heritage pairing; `hanoi-one-pillar-pagoda` nearby landmark pairing; render only after catalog QA.
* Freshness/source notes: Hanoi tourism portal; verify current access, hours, ticket/photo rules, and any surrounding-site changes before import.
* Score/QA: 28/30 draft; strong landmark decision and restrained facts; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Ga Hà Nội / Hanoi Railway Station — Hanoi — station

### Reader View

**The Capital Arrives In Yellow**

Hanoi Railway Station is one of the city’s clearest travel-day images: yellow facade, route boards, bags, shaded platforms, and streets pulling you back toward old Hanoi. It is a threshold where the trip briefly becomes practical again.

**Phrase cards**

* **“Tôi có thể mua vé ở đâu?”** — Where can I buy a ticket?
* **“Đây có đúng bến không?”** — Is this the right platform?
* **“Chuyến tàu này có bị trễ không?”** — Is this train delayed?

**Read The Boards Before Moving**

Pause long enough to match your train, time, and platform before following the busiest flow. A station mistake costs more energy when bags are involved.

**Make The Exit Boring**

Choose a clear pickup point, confirm the ride, and avoid dragging luggage through extra corners just to improvise. The city will feel better once the transfer is done.

**Old Hanoi Starts Outside**

The station is more than a practical doorway. The streets just beyond it bring back the capital’s everyday rhythm: signs, shade, traffic, and the next small decision.

### Implementation notes

* IDs: `page_id: city-hanoi-place-hanoi-railway-station`; `place_catalog_id: hanoi-hanoi-railway-station`; `hero: HeroCityHanoiPlaceHanoiRailwayStation`.
* Phrase/audio: `v900-tran-where-can-i-buy-a-ticket` ready; `transport-1` ready; `v500-tran-is-this-train-delayed` ready.
* Place-name audio: `city-hanoi-place-hanoi-railway-station` planned; hide name phrase until audio.
* Mentioned Here candidates: `hanoi-old-quarter` render/check if old-Hanoi card is desired.
* Related place candidates: `hanoi-gia-lam-station` station comparison; `hanoi-noi-bai-airport` arrival/departure planning if broader transport cards render.
* Freshness/source notes: Vietnam Travel Hanoi and Hanoi tourism portal; verify train operations, access, signage, pickup areas, and any station works before import.
* Score/QA: 28/30 draft; strong arrival scene and clear transfer behavior; phrase cards ready; duplicate body pass; render/screenshot review not run.

## Codex handoff block

* `batch_id: batch_034`
* `page_ids: city-hanoi-place-french-quarter-walk, city-hanoi-place-gia, city-hanoi-place-gia-lam-station, city-hanoi-place-giang-cafe, city-hanoi-place-giap-bat-bus-station, city-hanoi-place-hang-bac-street, city-hanoi-place-hang-da-market, city-hanoi-place-hang-gai-street, city-hanoi-place-hanoi-flag-tower, city-hanoi-place-hanoi-railway-station`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible cards; all visible cards use ready reusable audio IDs listed above`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: Jojo voice review still required; thin-source station pages intentionally restrained; Gia and Cafe Giang avoid current menu/hour claims`
* `source_freshness_risks: Gia booking/menu/opening status; Cafe Giang branch/address/hours/menu; station operations and pickup areas; Hang Da hours/stall mix/access; Flag Tower access/photo/hour rules; street shop mix only if named stores are later added`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`

---

# Batch 035

SpeakLocal v2.2 BATCH_035 - Hanoi - 2026-05-26

## 1. Hibana by Koki / Hibana by Koki — Hanoi — restaurant

`page_id: city-hanoi-place-hibana-by-koki`

### Reader View

**Counter Seats Make The Meal**

Hibana by Koki is a polished Hanoi dinner where the counter is part of the scene: grill heat, chef hands, quiet pacing, and food arriving in small, watched moments. Save it for a night when the meal can carry its own weight.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Bạn đề xuất món gì?** — What do you recommend?
* **Tôi quẹt thẻ được không?** — Can I pay by card?

**The Grill Is The View**

The teppanyaki counter changes how the meal feels. You are watching timing, heat, and hands at work, not just waiting for plates to arrive.

**Give The Pace Room**

This is not the kind of dinner to squeeze between two rushed stops. Let the first few minutes settle, then decide whether the room, service rhythm, and menu style fit the evening.

**Keep The Rest Of The Night Light**

Plan something simple afterward: a short ride back, a quiet drink, or a walk if the weather is kind. The meal will feel better if it is not fighting a crowded schedule.

### Implementation notes

* Phrase/audio status:

  * `food-menu` / `food-menu` — mapped, ready audio.
  * `v900-food-drin-what-do-you-recommend` / `v900-food-drin-what-do-you-recommend` — mapped, ready audio.
  * `store-6` / `store-6` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hibana-by-koki` planned; hide pronunciation audio until ready.
* Mentioned Here candidates: none to render. Teppanyaki/grill scene can stay prose unless a catalog item exists.
* Related place candidates:

  * **Lamai Garden** — `catalogId: hanoi-lamai-garden` · `status: render` · displaySubtitle: Garden-side contemporary Vietnamese dinner.
  * **Gia** — `catalogId: hanoi-gia` · `status: render` · displaySubtitle: Another polished Hanoi dining room to compare.
* Freshness notes: current menu, booking flow, prices, award status, and holiday operations need current check before import.
* Source notes: MICHELIN Vietnam 2025; legacy city-v1 row.
* Score: 27/30 — strong counter-meal shape; capped for limited current venue detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 2. Lăng Bác / Ho Chi Minh Mausoleum — Hanoi — landmark

`page_id: city-hanoi-place-ho-chi-minh-mausoleum`

### Reader View

**A Quiet Line On Ba Đình Square**

The mausoleum pulls Hanoi into a formal register: broad paving, flags, pale stone, and a slower line than the streets around it. Even if you only take in the exterior and square, the stop changes the tone of the morning.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?

**Keep The Visit Formal**

Move softly, follow the line, and treat the square as a memorial setting rather than a quick photo backdrop. The place works through restraint.

**Do The Nearby Stops In One Pass**

The Ho Chi Minh Museum and One Pillar Pagoda sit close enough to think of this as a small civic cluster. Check access first, then keep the route simple.

**The Exterior Still Counts**

A full interior visit may not fit every day. The square, guards, flags, and stone face still give you a clear read on Hanoi’s formal public memory.

### Implementation notes

* Phrase/audio status:

  * `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
  * `repair-5` / `repair-5` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-ho-chi-minh-mausoleum` ready.
* Mentioned Here candidates:

  * **Ba Đình Square** — `catalogId: null` · `status: check_catalog` · displaySubtitle: Formal civic square around the mausoleum.
  * **Ho Chi Minh Museum** — `catalogId: hanoi-ho-chi-minh-museum` · `status: render` · displaySubtitle: Museum stop beside the mausoleum area.
  * **One Pillar Pagoda** — `catalogId: hanoi-one-pillar-pagoda` · `status: render` · displaySubtitle: Small pagoda nearby.
* Related place candidates:

  * **Ho Chi Minh Museum** — `catalogId: hanoi-ho-chi-minh-museum` · `status: render` · displaySubtitle: Add context after the square.
  * **Imperial Citadel of Thang Long** — `catalogId: hanoi-imperial-citadel` · `status: render` · displaySubtitle: Another formal history stop nearby.
* Freshness notes: access flow, hours, dress expectations, closures, and photo rules need current check.
* Source notes: Vietnam Travel Hanoi; Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — clear tone and route logic; capped for access and photo-rule checks.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 3. Bảo tàng Hồ Chí Minh / Ho Chi Minh Museum — Hanoi — museum

`page_id: city-hanoi-place-ho-chi-minh-museum`

### Reader View

**Pick One Thread Before The Rooms**

Ho Chi Minh Museum is easiest when you enter with one question instead of trying to absorb every display. From the plaza outside to the quieter rooms inside, it adds context after the formal space of Ba Đình.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**After The Square, Go Indoors**

The museum makes the area feel less like a single monument stop. Pair it after the mausoleum if you want the day to move from public ceremony into objects, rooms, and interpretation.

**Choose Objects, Not Every Label**

A short, focused visit can work well. Pick a few displays that actually hold your attention, then leave before the museum turns into a blur of text.

**Short Visits Are Fine**

This is a context stop, not a test of stamina. If you are also seeing One Pillar Pagoda or the mausoleum area, keep enough energy for the whole cluster.

### Implementation notes

* Phrase/audio status:

  * `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` — mapped, ready audio.
  * `v900-sigh-acti-is-there-an-english-guide` / `v900-sigh-acti-is-there-an-english-guide` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-ho-chi-minh-museum` planned; hide pronunciation audio until ready.
* Mentioned Here candidates:

  * **Ho Chi Minh Mausoleum** — `catalogId: hanoi-ho-chi-minh-mausoleum` · `status: render` · displaySubtitle: Formal square stop beside the museum.
  * **Ba Đình Square** — `catalogId: null` · `status: check_catalog` · displaySubtitle: Civic space around the museum area.
  * **One Pillar Pagoda** — `catalogId: hanoi-one-pillar-pagoda` · `status: render` · displaySubtitle: Nearby pagoda in the same area.
* Related place candidates:

  * **Hoa Lo Prison Relic** — `catalogId: hanoi-hoa-lo-prison` · `status: render` · displaySubtitle: A heavier Hanoi memory stop.
  * **Vietnam National Museum of History** — `catalogId: hanoi-national-museum-history` · `status: render` · displaySubtitle: Broader national-history museum.
* Freshness notes: current exhibits, entrance route, hours, ticketing, photo rules, and English guide availability need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — useful museum-fatigue framing; capped for planned place-name audio and current access details.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 4. Nhà tù Hỏa Lò / Hoa Lo Prison Relic — Hanoi — museum

`page_id: city-hanoi-place-hoa-lo-prison`

### Reader View

**A Heavy Stop Behind A Yellow Gate**

Hoa Lo Prison Relic sits behind a yellow gate on a Hanoi street that can feel ordinary until the visit turns inward. It is cells, displays, and a harder layer of memory, not a casual museum filler.

**Useful phrase cards**

* **Vé bao nhiêu?** — How much is the ticket?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**The Gate Sets The Tone**

The exterior is part of the shift. Step in slowly, then let the building narrow the pace before you move through the rooms.

**Take The Displays In Order**

This is one of those museums where jumping around can make the visit feel thinner. Follow the sequence, read selectively, and give the heavier rooms enough attention.

**Leave Space Afterward**

Hoàn Kiếm Lake or the Old Quarter can be a lighter next move, but do not rush straight into noise. A short walk helps the visit land.

### Implementation notes

* Phrase/audio status:

  * `sight-1` / `sight-1` — mapped, ready audio.
  * `v900-sigh-acti-is-there-an-english-guide` / `v900-sigh-acti-is-there-an-english-guide` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hoa-lo-prison` ready.
* Mentioned Here candidates:

  * **Hoan Kiem Lake** — `catalogId: hanoi-hoan-kiem-lake` · `status: render` · displaySubtitle: Lighter walk after a heavy museum.
  * **Old Quarter** — `catalogId: hanoi-old-quarter` · `status: render` · displaySubtitle: Nearby street area for a softer next move.
* Related place candidates:

  * **Ho Chi Minh Museum** — `catalogId: hanoi-ho-chi-minh-museum` · `status: render` · displaySubtitle: Another memory-focused Hanoi stop.
  * **Vietnamese Women’s Museum** — `catalogId: hanoi-womens-museum` · `status: render` · displaySubtitle: Nearby museum with a different lens on Vietnamese history.
* Freshness notes: current hours, tickets, exhibit access, audio/guide options, and photo rules need check.
* Source notes: Vietnam Travel Hanoi; Hanoi tourism portal; legacy city-v1 row.
* Score: 28/30 — strong physical arrival and pacing; capped for current museum logistics.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 5. Hồ Hoàn Kiếm / Hoan Kiem Lake — Hanoi — nature

`page_id: city-hanoi-place-hoan-kiem`

### Reader View

**Central Hanoi Opens Around Water**

Hoàn Kiếm Lake gives the Old Quarter side of Hanoi a pause: water, shade, Turtle Tower in the distance, the red bridge to Ngọc Sơn Temple, and people walking instead of pushing through traffic.

**Useful phrase cards**

* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?
* **Dừng ở đây được rồi.** — You can stop here.
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**Circle Once Before Sitting**

The lake is better after one unhurried loop or half-loop. Notice the bridge, shaded edges, benches, cafés, and crossings before choosing where to pause.

**The Bridge Gives The Lake A Focus**

The red bridge and Ngọc Sơn Temple make the water feel like more than a view. Turtle Tower does the quieter work from a distance.

**Easy Between Street Stops**

The lake is a good reset between Old Quarter lanes, coffee stops, museum time, and evening plans. It lets the center of Hanoi feel walkable for a while.

### Implementation notes

* Phrase/audio status:

  * `repair-5` / `repair-5` — mapped, ready audio.
  * `taxi-3` / `taxi-3` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hoan-kiem` ready.
* Mentioned Here candidates:

  * **Turtle Tower** — `catalogId: hanoi-turtle-tower` · `status: render` · displaySubtitle: Small landmark in the lake.
  * **Ngoc Son Temple** — `catalogId: hanoi-ngoc-son-temple` · `status: render` · displaySubtitle: Temple reached by the red bridge.
  * **Old Quarter** — `catalogId: hanoi-old-quarter` · `status: render` · displaySubtitle: Street area wrapped around the lake side.
* Related place candidates:

  * **The Note Coffee** — `catalogId: hanoi-the-note-coffee` · `status: render` · displaySubtitle: Short coffee ritual near the lake.
  * **Cafe Giang** — `catalogId: hanoi-giang-cafe` · `status: render` · displaySubtitle: Classic egg-coffee stop after a walk.
* Freshness notes: temple access, bridge crowding, lake-edge works, and nearby pedestrian changes need light check.
* Source notes: Vietnam Travel Hanoi; legacy city-v1 row.
* Score: 29/30 — stable, concrete, and easy to use; capped for route/access checks.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 6. Chợ Hôm / Hom Market — Hanoi — market

`page_id: city-hanoi-place-hom-market`

### Reader View

**Fabric First, Then The Aisles**

Chợ Hôm feels practical before it feels scenic: bolts of cloth, fluorescent light, bags moving through tight aisles, and shoppers who already know what they came for. Browse slowly and let the market show its everyday rhythm.

**Useful phrase cards**

* **Cái này bao nhiêu?** — How much is this?
* **Bớt chút được không?** — Can you lower it a little?
* **Trả ở đâu?** — Where do I pay?

**Walk Before Pointing**

Do one slow pass before asking prices. The fabric area is easier once you understand where people are browsing, cutting, carrying, and paying.

**Keep Purchases Small**

This is a good place for small practical buys or fabric curiosity, not a pressure test. If you are not sure, smile, step aside, and look again.

**A Market For Texture, Not A Checklist**

The best read here is the rhythm: cloth, counters, fluorescent light, movement, and ordinary shopping. You do not need to decode every stall.

### Implementation notes

* Phrase/audio status:

  * `price-1` / `price-1` — mapped, ready audio.
  * `price-4` / `price-4` — mapped, ready audio.
  * `shop-5` / `shop-5` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-hom-market` planned; hide pronunciation audio until ready.
* Mentioned Here candidates: none to render. Fabric/stall browsing can remain prose unless catalog has a shopping item.
* Related place candidates:

  * **Dong Xuan Market** — `catalogId: hanoi-dong-xuan-market` · `status: render` · displaySubtitle: Larger Old Quarter market contrast.
  * **Hang Da Market** — `catalogId: hanoi-hang-da-market` · `status: render` · displaySubtitle: Another central market to compare.
  * **Long Bien Market** — `catalogId: hanoi-long-bien-market` · `status: render` · displaySubtitle: More active wholesale-market rhythm.
* Freshness notes: hours, stall mix, fabric availability, payment norms, and renovation/access changes need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — clear market behavior; capped for sparse current detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 7. Hoàng thành Thăng Long / Imperial Citadel of Thang Long — Hanoi — landmark

`page_id: city-hanoi-place-imperial-citadel`

### Reader View

**Gates, Courtyards, Then Context**

The Imperial Citadel of Thang Long turns Hanoi’s long history into walls, brick courts, gates, and open ceremonial space. It is not loud or fast; the visit works when you slow your stride and let the scale build.

**Useful phrase cards**

* **Vé bao nhiêu?** — How much is the ticket?
* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

**Follow The Open Spaces**

Move from gate to courtyard to wall instead of treating the site like a single photo stop. The distance between things is part of how the place speaks.

**Old Walls, Modern Capital**

The citadel feels strongest when you notice the contrast: old brick and ceremony space sitting inside a working capital city.

**Build A Nearby History Loop**

Hanoi Flag Tower, the Vietnam Military History Museum, and the Temple of Literature can sit naturally around the same history-heavy day if you keep the route calm.

### Implementation notes

* Phrase/audio status:

  * `sight-1` / `sight-1` — mapped, ready audio.
  * `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` — mapped, ready audio.
  * `sight-3` / `sight-3` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-imperial-citadel` ready.
* Mentioned Here candidates:

  * **Hanoi Flag Tower** — `catalogId: hanoi-hanoi-flag-tower` · `status: render` · displaySubtitle: Nearby tower for a history route.
  * **Vietnam Military History Museum** — `catalogId: hanoi-vietnam-military-history-museum` · `status: render` · displaySubtitle: Museum pairing near the citadel area.
  * **Temple of Literature** — `catalogId: hanoi-temple-literature` · `status: render` · displaySubtitle: Another major Hanoi history stop.
* Related place candidates:

  * **Ho Chi Minh Mausoleum** — `catalogId: hanoi-ho-chi-minh-mausoleum` · `status: render` · displaySubtitle: Formal civic-memory stop nearby.
  * **Lenin Park** — `catalogId: hanoi-lenin-park` · `status: render` · displaySubtitle: Open-air pause after heavier history.
* Freshness notes: hours, tickets, gate flow, exhibit access, and photo rules need current check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 28/30 — strong landmark pacing and nearby route logic; capped for access details.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 8. Cà phê Lâm / Lam Cafe — Hanoi — cafe

`page_id: city-hanoi-place-lam-cafe`

### Reader View

**Old Hanoi In A Coffee Room**

Cà phê Lâm is a coffee pause where the room matters: framed paintings, dark coffee, old tables, and the street falling away for a few minutes. The cup is simple; the texture is in the walls and the slow break.

**Useful phrase cards**

* **Cho tôi cà phê đen đá.** — I’d like an iced black coffee.
* **Cho tôi một cà phê sữa đá.** — One iced milk coffee please.
* **Không đường nhé.** — No sugar please.

**Order Plain And Watch The Room**

A simple black coffee or milk coffee fits the old-café rhythm. Sit long enough to notice the paintings, tables, and quiet pace before checking your phone again.

**Better As A Pause Than A Work Session**

This is more satisfying as a short Hanoi reset than a long laptop stop. Let it be twenty calm minutes between streets.

**Coffee Links The Old Quarter**

Pair it with a nearby walk, gallery stop, or lake-side stretch if the day needs a gentler middle. The point is the pause, not a complicated order.

### Implementation notes

* Phrase/audio status:

  * `coffee-2` / `coffee-2` — mapped, ready audio.
  * `coffee-1` / `coffee-1` — mapped, ready audio.
  * `coffee-5` / `coffee-5` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-lam-cafe` planned; hide pronunciation audio until ready.
* Mentioned Here candidates:

  * **Vietnamese iced black coffee** — `catalogId: drink-ca-phe-den-da` · `status: render` · displaySubtitle: Strong iced black coffee order.
  * **Vietnamese iced milk coffee** — `catalogId: drink-ca-phe-sua-da` · `status: render` · displaySubtitle: Classic iced coffee with condensed milk.
* Related place candidates:

  * **Cafe Giang** — `catalogId: hanoi-giang-cafe` · `status: render` · displaySubtitle: Classic Hanoi egg-coffee comparison.
  * **The Note Coffee** — `catalogId: hanoi-the-note-coffee` · `status: render` · displaySubtitle: More touristy lake-side coffee ritual.
  * **Trieu Viet Vuong Coffee Street** — `catalogId: hanoi-trieu-viet-vuong-coffee-street` · `status: render` · displaySubtitle: Broader Hanoi coffee-street context.
* Freshness notes: current hours, seating, menu, and room condition need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row; coffee items mapped from Menu Catalog.
* Score: 27/30 — good café ritual and menu mapping; capped for current venue detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 9. Lamai Garden / Lamai Garden — Hanoi — restaurant

`page_id: city-hanoi-place-lamai-garden`

### Reader View

**Dinner With A Garden Edge**

Lamai Garden softens the Hanoi dinner rhythm with a path, herbs, warm interior light, and contemporary Vietnamese cooking. It feels suited to an evening when conversation and pacing matter as much as the plates.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Bạn đề xuất món gì?** — What do you recommend?
* **Tôi ăn chay.** — I am vegetarian.

**Arrive Ready To Slow Down**

The garden-side setting gives the meal a calmer beginning. Take a minute before ordering and let the room set the pace.

**Ask Before The Table Fills**

If pork, shellfish, spice, or vegetarian food matters, ask early. A polished room still works best when the first questions are clear.

**Keep The Evening Uncrowded**

This is a better dinner when it has space around it. Do not stack too many plans after the meal unless they are close and easy.

### Implementation notes

* Phrase/audio status:

  * `food-menu` / `food-menu` — mapped, ready audio.
  * `v900-food-drin-what-do-you-recommend` / `v900-food-drin-what-do-you-recommend` — mapped, ready audio.
  * `food-vegetarian` / `food-vegetarian` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-lamai-garden` planned; hide pronunciation audio until ready.
* Mentioned Here candidates: none to render. No current dish claims added.
* Related place candidates:

  * **Hibana by Koki** — `catalogId: hanoi-hibana-by-koki` · `status: render` · displaySubtitle: Counter-led polished dinner contrast.
  * **Tam Vi** — `catalogId: hanoi-tam-vi` · `status: render` · displaySubtitle: Vietnamese meal comparison in Hanoi.
  * **Uu Dam** — `catalogId: hanoi-udam` · `status: render` · displaySubtitle: Vegetarian-friendly restaurant comparison to check.
* Freshness notes: current menu, hours, booking flow, pricing, holiday operations, and MICHELIN listing state need check.
* Source notes: MICHELIN Vietnam 2025; legacy city-v1 row.
* Score: 27/30 — calm restaurant shape and reusable phrases; capped for limited current menu detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## 10. Công viên Lê Nin / Lenin Park — Hanoi — park

`page_id: city-hanoi-place-lenin-park`

### Reader View

**Ordinary Hanoi In Open Air**

Lenin Park is a small city pause: shade trees, open paths, a statue plaza, and people using the space for walking, talking, and family time. It gives the day a breath without asking you to make it a major stop.

**Useful phrase cards**

* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?
* **Dừng ở đây được rồi.** — You can stop here.
* **Nhà vệ sinh gần nhất ở đâu?** — Where is the nearest restroom?

**Shade Before The Next Museum**

The park sits well before or after heavier nearby stops like the Imperial Citadel, Hanoi Flag Tower, or the Vietnam Military History Museum. A few shaded minutes can reset the route.

**Watch The Evening Change**

Late-day light, families, students, walkers, and traffic around the edges make the park feel more local than formal.

**A Short Pause Is Enough**

There is no need to stretch the stop. Walk, sit, take in the statue plaza and trees, then keep moving when the city starts calling again.

### Implementation notes

* Phrase/audio status:

  * `repair-5` / `repair-5` — mapped, ready audio.
  * `taxi-3` / `taxi-3` — mapped, ready audio.
  * `v500-dire-navi-where-is-the-nearest-restroom` / `v500-dire-navi-where-is-the-nearest-restroom` — mapped, ready audio.
* Place-name audio: `city-hanoi-place-lenin-park` planned; hide pronunciation audio until ready.
* Mentioned Here candidates:

  * **Imperial Citadel of Thang Long** — `catalogId: hanoi-imperial-citadel` · `status: render` · displaySubtitle: Nearby history stop.
  * **Hanoi Flag Tower** — `catalogId: hanoi-hanoi-flag-tower` · `status: render` · displaySubtitle: Nearby landmark.
  * **Vietnam Military History Museum** — `catalogId: hanoi-vietnam-military-history-museum` · `status: render` · displaySubtitle: Nearby museum pairing.
* Related place candidates:

  * **Thong Nhat Park** — `catalogId: hanoi-thong-nhat-park` · `status: render` · displaySubtitle: Larger Hanoi park contrast.
  * **Hoan Kiem Lake** — `catalogId: hanoi-hoan-kiem-lake` · `status: render` · displaySubtitle: Central water-and-walking pause.
* Freshness notes: current park access, maintenance, nearby construction, and restroom availability need check.
* Source notes: Hanoi tourism portal; legacy city-v1 row.
* Score: 27/30 — specific small-park role; capped for sparse current detail and planned place-name audio.
* QA notes: replaceability pass; phrase cards pass; Mentioned Here pass; duplicate body pass; anti-cynicism pass; screenshot review not_run; production review gate not_run.

---

## Codex handoff block

* `batch_id: batch_035`
* `page_ids: city-hanoi-place-hibana-by-koki, city-hanoi-place-ho-chi-minh-mausoleum, city-hanoi-place-ho-chi-minh-museum, city-hanoi-place-hoa-lo-prison, city-hanoi-place-hoan-kiem, city-hanoi-place-hom-market, city-hanoi-place-imperial-citadel, city-hanoi-place-lam-cafe, city-hanoi-place-lamai-garden, city-hanoi-place-lenin-park`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none; all visible phrase cards use ready reusable audio`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: fine-dining pages avoid dish/menu specifics; civic and museum pages avoid hours, rule, queue, ticket, and access claims; park/market/cafe pages stay intentionally restrained`
* `source_freshness_risks: MICHELIN 2025 venue state; restaurant/cafe menus and booking flow; mausoleum access and photo rules; museum/citadel hours, ticketing, exhibits, and guide availability; market stall mix and payment norms; park access and maintenance`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`

---

# Batch 036

SpeakLocal v2.2 BATCH_036 - Hanoi - 2026-05-26

## Bảo tàng Văn học Việt Nam / Vietnam Literature Museum — Hanoi — museum

### Reader View

**Read Hanoi Through Its Writers**
Vietnam Literature Museum is a quieter Hanoi stop: books, author rooms, Vietnamese text, and a slower kind of cultural memory. Come here when the city’s lakes, cafés, and old streets have already put you in a reading mood.

**Useful phrase cards**

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Có hướng dẫn tiếng Anh không?”** — Is there an English guide?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?

**Three Rooms Are Enough**
This is the kind of museum that can reward a short visit. Choose a few rooms, notice names and book covers, then let the quieter details carry more weight than a full timeline.

**Names Before Dates**
If the labels feel text-heavy, look for portraits, manuscripts, publishing objects, and repeated author names. The point is not to master Vietnamese literature in one stop; it is to feel how deeply writing sits inside Hanoi’s cultural life.

**A Calm Stop Between Louder Ones**
It pairs better with a café, bookstore mood, or museum-heavy day than with a rushed checklist. Leave room afterward for the city to feel quieter.

### Implementation notes

* `page_id: city-hanoi-place-literature-museum`
* Phrase/audio: `sight-1` / `sight-1` mapped; `v900-sigh-acti-is-there-an-english-guide` / same mapped; `sight-3` / `sight-3` mapped.
* Mentioned Here candidates: none forced.
* Related place candidates: `hanoi-temple-literature` check_catalog; `hanoi-vietnam-fine-arts-museum` check_catalog.
* Place-name audio: render local name only if ready; otherwise hide until audio.
* Freshness risks: hours, ticketing, exhibit layout, English interpretation, photo policy.
* Source notes: Hanoi tourism portal; legacy city-v1 text used only for scope.
* Score: 27/30 — quiet museum role is clear; capped for venue freshness and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; mentions restrained; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Cầu Long Biên / Long Bien Bridge — Hanoi — landmark

### Reader View

**The Bridge Is The Frame**
Long Bien Bridge gives Hanoi a working-river image: steel truss, Red River haze, market traffic, motorbikes, and old metal against the sky. Treat it as a view and a piece of city memory, not just a way across.

**Useful phrase cards**

* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Đi bộ mất bao lâu?”** — How long does it take on foot?
* **“Gọi taxi giúp tôi được không?”** — Can you call a taxi for me?

**View First, Crossing Second**
The best first move is to read the scene before committing to movement: river below, traffic rhythm, nearby market energy, and the bridge’s long steel line. Choose a safer viewing point if the crossing feels too exposed.

**River Haze Changes The Mood**
Soft light makes the bridge easier to understand. In bright midday heat, it can feel more like infrastructure; near early morning or late afternoon, the Red River setting gives it more weight.

**Pair The Steel With Crates**
Long Bien Market sits naturally in the same mental frame: produce, carts, and the older working edge of Hanoi. The bridge feels more specific when you see it beside that daily movement.

### Implementation notes

* `page_id: city-hanoi-place-long-bien-bridge`
* Phrase/audio: `sight-3` / `sight-3` mapped; `directions-3` / `directions-3` mapped; `hotel-9` / `hotel-9` mapped.
* Mentioned Here candidates: `hanoi-red-river` render; `hanoi-long-bien-market` render.
* Related place candidates: `hanoi-long-bien-market` render; `hanoi-red-river` check_catalog.
* Place-name audio: render local name only if ready; otherwise hide until audio.
* Freshness risks: pedestrian access, safety conditions, nearby construction or traffic changes.
* Source notes: Vietnam Travel Hanoi; legacy city-v1 text used only for scope.
* Score: 28/30 — strong landmark decision and physical scene; capped for access/safety freshness and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; Mentioned Here evaluated; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Chợ Long Biên / Long Bien Market — Hanoi — market

### Reader View

**Crates Before Souvenirs**
Long Bien Market is not a polished browsing market. It is crates, fruit, carts, quick hands, and wholesale movement near the bridge. Go for the working rhythm more than for a tidy shopping stop.

**Useful phrase cards**

* **“Cái này bao nhiêu?”** — How much is this?
* **“Bớt chút được không?”** — Can you lower it a little?
* **“Tôi chỉ xem thôi.”** — I’m just looking.

**Watch The Flow First**
Stand back for a minute before stepping in. The market has its own traffic: people carrying produce, sellers sorting goods, buyers moving fast, and narrow gaps that close quickly.

**Small Cash, Small Buys**
If you browse, keep it simple. Ask the price, buy a small amount, and avoid slowing a working seller when the lane is busy.

**Bridge Light Nearby**
The bridge gives the market a stronger setting. Fruit crates and steel truss belong to the same older Hanoi edge, especially when the light is soft.

### Implementation notes

* `page_id: city-hanoi-place-long-bien-market`
* Phrase/audio: `price-1` / `price-1` mapped; `price-4` / `price-4` mapped; `shop-4` / `shop-4` mapped.
* Mentioned Here candidates: `hanoi-long-bien-bridge` render; `hanoi-red-river` check_catalog.
* Related place candidates: `hanoi-long-bien-bridge` render; `hanoi-dong-xuan-market` check_catalog.
* Place-name audio: render local name only if ready; otherwise hide until audio.
* Freshness risks: best visiting window, current access, market traffic, stall activity.
* Source notes: Hanoi tourism portal; legacy city-v1 text used only for scope.
* Score: 27/30 — specific market behavior; capped for shifting market conditions and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; Mentioned Here evaluated; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Manzi / Manzi Art Space — Hanoi — attraction

### Reader View

**Art Before The Coffee Pause**
Manzi is a small creative stop where framed work, quiet rooms, and a café pause can sit in the same visit. Arrive for the art first; let the drink be the slower part if the room feels right.

**Useful phrase cards**

* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?
* **“Tôi có thể ngồi đây được không?”** — Can I sit here?
* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?

**Check The Room Before Settling**
Look at what is actually on view before deciding how long to stay. A small art space changes with its current show, so the first few minutes matter.

**One Show, One Slow Drink**
The best rhythm is simple: see the work, choose a quiet table if available, and let the café pause stay short enough that it still feels like part of the art stop.

**Quiet Beats A Long Stay**
Manzi is strongest as a compact creative pause, not a whole afternoon plan. If the rooms are full or the show is light, keep the stop gentle and move on without forcing it.

### Implementation notes

* `page_id: city-hanoi-place-manzi-art-space`
* Phrase/audio: `sight-3` / `sight-3` mapped; `v900-poli-basi-can-i-sit-here` / same mapped; `food-menu` / `food-menu` mapped.
* Mentioned Here candidates: none forced.
* Related place candidates: `hanoi-vietnam-fine-arts-museum` check_catalog; `hanoi-vietnam-art-gallery` check_catalog.
* Place-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: current exhibition, café service, hours, photography rules, event schedule.
* Source notes: Vietnam Travel Hanoi; legacy city-v1 text used only for scope.
* Score: 26/30 — voice is restrained and place-specific; capped for venue-programming freshness and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; mentions restrained; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Miến lươn ở Hà Nội / Eel glass noodles — Hanoi — dish

### Reader View

**Texture Leads The Bowl**
Miến lươn is a Hanoi noodle order built around contrast: slippery glass noodles, eel, herbs, broth or sauce, and sometimes crisp pieces that change the whole bite. It is a small meal that feels more memorable than it looks on paper.

**Useful phrase cards**

* **“Cho tôi tô này.”** — I’ll take this bowl.
* **“Cho thêm rau.”** — More herbs, please.
* **“Không cay nhé.”** — Not spicy, please.

**Choose Crisp Or Brothy**
If the shop gives you a choice, decide whether you want the cleaner comfort of soup or the sharper texture of crisp eel. Pointing works when the menu moves faster than your Vietnamese.

**Herbs Change The Finish**
Do not treat the herbs as decoration. Add them slowly, taste the broth or sauce, then adjust. The bowl is lighter when the herbs stay fresh.

**One Bowl Is Enough**
This is a good single-stop food memory. Order one bowl, understand the texture, then leave room for coffee or another snack later.

### Implementation notes

* `page_id: city-hanoi-place-mien-luon`
* Phrase/audio: `food-2` / `food-2` mapped; `food-4` / `food-4` mapped; `food-3` / `food-3` mapped.
* Mentioned Here candidates: `hanoi-mien-luon` render as current item only if self-linking is allowed; exact menu item `Miến lươn` check_catalog.
* Related place candidates: `hanoi-mien-luon-chan-cam` render; `hanoi-street-food-walk` check_catalog.
* Place/dish-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: dish availability by shop, current MICHELIN 2025 references, exact bowl styles.
* Source notes: MICHELIN Vietnam 2025; legacy city-v1 text used only for scope.
* Score: 27/30 — clear dish texture and ordering moment; capped for catalog mapping and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; dish mention needs catalog check; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Miến lươn Chân Cầm / Mien Luon Chan Cam — Hanoi — restaurant

### Reader View

**The Bowl Sets The Pace**
Mien Luon Chan Cam is a focused Hanoi noodle stop: eel, glass noodles, herbs, steam, and a small-shop rhythm. Know the bowl you want before the room starts moving around you.

**Useful phrase cards**

* **“Cho tôi xem thực đơn được không?”** — Can I see the menu?
* **“Cho tôi một phần.”** — One portion, please.
* **“Cho thêm rau.”** — More herbs, please.

**Order Before The Room Moves**
Noodle shops feel easier when you decide quickly: bowl style, herbs, and whether you want anything extra. If you are unsure, point to a nearby bowl and keep the order simple.

**Herbs, Glass Noodles, Eel**
The pleasure is in the texture more than the size of the meal. Glass noodles slip, eel adds chew or crispness, and herbs keep the bowl from feeling heavy.

**Quick Meal, Clear Stop**
Do not stretch it into a long dinner. Eat, pay, and let the stop be one sharp food memory in an old-lane Hanoi day.

### Implementation notes

* `page_id: city-hanoi-place-mien-luon-chan-cam`
* Phrase/audio: `food-menu` / `food-menu` mapped; `food-1` / `food-1` mapped; `food-4` / `food-4` mapped.
* Mentioned Here candidates: `hanoi-mien-luon` render; exact menu item `Miến lươn` check_catalog.
* Related place candidates: `hanoi-street-food-walk` check_catalog; `hanoi-mien-luon` render.
* Place-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: current opening, menu options, pricing, holiday closures, MICHELIN 2025 listing context.
* Source notes: MICHELIN Vietnam 2025; legacy city-v1 text used only for scope.
* Score: 27/30 — compact restaurant behavior and dish link; capped for current venue details and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; Mentioned Here evaluated; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Bến xe Mỹ Đình / My Dinh Bus Station — Hanoi — station

### Reader View

**A Western Road Hub**
My Dinh Bus Station shows Hanoi at its onward-road edge: bags, route boards, waiting benches, ticket counters, taxis, and buses pointing toward the wider north. It is practical, busy, and better with a clear plan.

**Useful phrase cards**

* **“Tôi có thể mua vé ở đâu?”** — Where can I buy a ticket?
* **“Điểm đón ở đâu?”** — Where is the pickup point?
* **“Gọi taxi giúp tôi được không?”** — Can you call a taxi for me?

**Route Board Before Bench**
Confirm the route, company, departure point, and pickup area before relaxing. A station can feel calm for five minutes and confusing the moment boarding begins.

**Keep The Pickup Simple**
Save your pickup point, station name, and bus company where you can show them. If a driver or staff member asks a question, pointing to the text is often faster than trying to explain.

**Leave Time For The Edge**
The station sits in a wider, road-heavy part of the city. Give yourself time for traffic, ticket checks, and the short scramble between waiting area and bus.

### Implementation notes

* `page_id: city-hanoi-place-my-dinh-bus-station`
* Phrase/audio: `v900-tran-where-can-i-buy-a-ticket` / same mapped; `directions-8` / `directions-8` mapped; `hotel-9` / `hotel-9` mapped.
* Mentioned Here candidates: none forced.
* Related place candidates: `hanoi-giap-bat-bus-station` check_catalog; `hanoi-nuoc-ngam-bus-station` check_catalog; `hanoi-hanoi-railway-station` check_catalog.
* Place-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: route operators, pickup gates, ticketing flow, station access, traffic.
* Source notes: Hanoi tourism portal; legacy city-v1 text used only for scope.
* Score: 27/30 — useful station behavior without volatile route claims; capped for live transport details and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; related candidates evaluated; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Cà phê Năng / Nang Cafe — Hanoi — cafe

### Reader View

**Coffee As A Short Pause**
Nang Cafe belongs to Hanoi’s older coffee rhythm: small tables, strong cups, ice, sweetness, and a room that asks you to slow down for a little while. Come for the pause, not for a long work session.

**Useful phrase cards**

* **“Cho tôi một cà phê sữa đá.”** — One iced milk coffee, please.
* **“Cho tôi cà phê đen đá.”** — I’d like an iced black coffee.
* **“Ít đá thôi.”** — Just a little ice.

**Order The Classic Glass**
Start with iced milk coffee if you want the sweet Hanoi-café feel. Choose iced black coffee if you want the sharper roast without condensed milk.

**Small Table, Slow Drip**
The best part of a Hanoi coffee stop is often the waiting: phin filter, melting ice, street noise, and the first strong sip after walking too long.

**Move On Before It Becomes A Wait**
If the room is full, keep the stop light. Hanoi has enough coffee nearby that forcing one seat can flatten the mood.

### Implementation notes

* `page_id: city-hanoi-place-nang-cafe`
* Phrase/audio: `coffee-1` / `coffee-1` mapped; `coffee-2` / `coffee-2` mapped; `coffee-4` / `coffee-4` mapped.
* Mentioned Here candidates: `drink-ca-phe-sua-da` render; `drink-ca-phe-den-da` render; `drink-ca-phe-phin` render.
* Related place candidates: `hanoi-coffee-hop` check_catalog; `hanoi-giang-cafe` check_catalog; `hanoi-dinh-cafe` check_catalog.
* Place-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: place-name-only evidence, current address/branch status, hours, seating, menu availability.
* Source notes: place-name only; legacy city-v1 text used only for scope.
* Score: 26/30 — solid café ritual but evidence is thin; capped for venue freshness and no rendered review.
* QA notes: replaceability pass after narrowing to Hanoi coffee behavior; phrase cards mapped; menu mentions evaluated; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Bảo tàng Lịch sử Quốc gia / Vietnam National Museum of History — Hanoi — museum

### Reader View

**History In A Cooler Room**
Vietnam National Museum of History gives Hanoi a slower indoor layer: display cases, artifacts, quiet light, and an ochre building with palms outside. It is strongest when you choose a lane instead of trying to absorb the whole country at once.

**Useful phrase cards**

* **“Vé bao nhiêu?”** — How much is the ticket?
* **“Có hướng dẫn tiếng Anh không?”** — Is there an English guide?
* **“Tôi chụp hình ở đây được không?”** — Can I take photos here?

**Pick One Era**
Start by choosing what you want from the visit: ancient objects, historical context, architecture, or a calm break from the street. That choice keeps the museum from becoming a blur of labels.

**Building Before Labels**
Notice the building as part of the experience. Arched windows, warm exterior color, palms, and gallery light help the museum feel like a Hanoi place, not only a sequence of cases.

**Leave Space Afterward**
Do not stack it too tightly with another heavy museum. A short walk or coffee afterward gives the objects time to settle.

### Implementation notes

* `page_id: city-hanoi-place-national-museum-history`
* Phrase/audio: `sight-1` / `sight-1` mapped; `v900-sigh-acti-is-there-an-english-guide` / same mapped; `sight-3` / `sight-3` mapped.
* Mentioned Here candidates: none forced.
* Related place candidates: `hanoi-vietnam-fine-arts-museum` check_catalog; `hanoi-womens-museum` check_catalog; `hanoi-hoa-lo-prison` check_catalog.
* Place-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: hours, ticketing, exhibit access, English interpretation, photo policy.
* Source notes: Hanoi tourism portal; legacy city-v1 text used only for scope.
* Score: 27/30 — clear museum-fatigue control and physical scene; capped for current museum operations and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; related candidates evaluated; no duplicate body; screenshot review not_run; production review gate not_run.

---

## Nem cua bể ở Hà Nội / Crab spring rolls — Hanoi — dish

### Reader View

**Crisp, Square, Shareable**
Nem cua bể is the fried-roll order to remember by shape and texture: square pieces, crab filling, hot crisp edges, herbs, and dipping sauce. It is better as a shared plate than a heavy meal by itself.

**Useful phrase cards**

* **“Cho tôi một phần.”** — One portion, please.
* **“Cho thêm rau.”** — More herbs, please.
* **“Tôi bị dị ứng với động vật có vỏ.”** — I am allergic to shellfish.

**Order One Plate First**
Start with one plate and see how rich it feels. The crab filling and fried wrapper can be satisfying fast, especially if you are adding noodles or another dish nearby.

**Dip Without Drowning**
A light dip keeps the wrapper crisp. Add herbs between bites so the plate stays fresh instead of turning oily.

**Know The Shellfish Risk**
This is a crab dish, so allergy questions matter. If shellfish is a concern, do not rely on guessing from the English menu.

### Implementation notes

* `page_id: city-hanoi-place-nem-cua-be`
* Phrase/audio: `food-1` / `food-1` mapped; `food-4` / `food-4` mapped; `v500-food-drin-i-am-allergic-to-shellfish` / same mapped.
* Mentioned Here candidates: `hanoi-nem-cua-be` render as current item only if self-linking is allowed; exact menu item `Nem cua bể` check_catalog; `food-nem-ran` check_catalog as broader northern fried-roll item if needed.
* Related place candidates: `hanoi-street-food-walk` check_catalog; `hanoi-bun-cha` check_catalog if a food-route pairing is desired.
* Place/dish-name audio: render only if ready; otherwise hide until audio.
* Freshness risks: current MICHELIN guide context, shop availability, shellfish labeling, exact serving style.
* Source notes: MICHELIN Hanoi guide; legacy city-v1 text used only for scope.
* Score: 27/30 — distinct dish behavior and allergy caution; capped for exact catalog mapping and no rendered review.
* QA notes: replaceability pass; phrase cards mapped; dish mentions need catalog check; no duplicate body; screenshot review not_run; production review gate not_run.

```markdown
## Codex handoff block

- `batch_id: batch_036`
- `page_ids: city-hanoi-place-literature-museum, city-hanoi-place-long-bien-bridge, city-hanoi-place-long-bien-market, city-hanoi-place-manzi-art-space, city-hanoi-place-mien-luon, city-hanoi-place-mien-luon-chan-cam, city-hanoi-place-my-dinh-bus-station, city-hanoi-place-nang-cafe, city-hanoi-place-national-museum-history, city-hanoi-place-nem-cua-be`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none for visible phrase cards; all visible cards use ready reusable audio IDs listed in implementation notes`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: Nang Cafe has thin place-name-only evidence; Manzi current programming may shift; bus station copy must stay operational and non-promotional`
- `source_freshness_risks: museum hours/tickets/photo rules/English interpretation; Long Bien access and market conditions; Manzi hours/exhibitions/cafe service; Miến lươn Chân Cầm opening/menu/pricing; My Dinh routes and pickup points; Nang address/hours/menu; MICHELIN 2025 food references should be checked before import`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```

---

# Batch 037

SpeakLocal v2.2 BATCH_037 - Hanoi - 2026-05-26

## Đền Ngọc Sơn / Ngoc Son Temple — Hanoi — landmark

### Reader View

**A Lake Crossing Before The Temple**

Ngọc Sơn begins on the red bridge over Hoàn Kiếm Lake. The temple is small, but the water, trees, incense, and low rooms make the visit feel like a pause inside central Hanoi rather than a box to tick.

**Useful phrase cards**

* **"Xin lỗi"** — Excuse me / sorry.
* **"Tôi có thể chụp ảnh ở đây được không?"** — Can I take a photo here?
* **"Cảm ơn"** — Thank you.

**Move Quietly Around Worship**

People may be there to pray, not sightsee. Step aside near offerings, keep your voice low, and let the temple rhythm set the pace before you turn back toward the bridge.

**Read It With The Lake**

The bridge, island, lake edge, and temple work as one scene. A short walk around Hoàn Kiếm afterward makes the red bridge feel part of the city center, not a separate stop.

**Small Stop, Strong Memory**

This is not a long temple outing. It is strongest as a calm layer between Old Quarter lanes, coffee, and lake walking.

### Implementation notes

* `page_id`: `city-hanoi-place-ngoc-son-temple`
* Phrase/audio IDs: `polite-excuse-me` / `polite-5` mapped; `v900-sigh-acti-can-i-take-a-photo-here` / same audio key mapped; `polite-thank-you` / `polite-2` mapped.
* Mentioned Here candidates: `hanoi-hoan-kiem-lake` Hoan Kiem Lake — `render`; `hanoi-old-quarter` Old Quarter — `render`.
* Related candidates: `hanoi-one-pillar-pagoda` One Pillar Pagoda — `render`; `hanoi-tran-quoc-pagoda` Tran Quoc Pagoda — `check_catalog`; `hanoi-temple-literature` Temple of Literature — `render`.
* Freshness/source notes: Supplied rows cite Vietnam Travel Hanoi and Hanoi tourism portal; verify current entry hours, ticketing, and photo expectations before import.
* Score: 28/30 — strong first-screen feel and practical temple behavior; capped for current access and audio/catalog confirmation.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Phố Nguyễn Hữu Huân / Nguyen Huu Huan Street — Hanoi — street

### Reader View

**Coffee Street Before The Cup**

Nguyễn Hữu Huân is where Hanoi coffee becomes a short walk: narrow doorways, upstairs rooms, egg-coffee signs, and scooters slipping past the curb. Arrive with one cup in mind, then leave when the room has done its work.

**Useful phrase cards**

* **"Cho tôi xem thực đơn được không?"** — Can I see the menu?
* **"Làm ơn cho một ly cà phê nóng"** — One hot coffee, please.
* **"Tính tiền giúp tôi"** — Please let me pay.

**Look Up Before Choosing**

Some of the best-feeling rooms are not obvious from the sidewalk. Pause at the doorway, check whether the shop is upstairs, then decide whether you want the room or just the drink.

**One Famous Cup, More Than One Room**

Cà phê Giảng can be the named stop, but the street is wider than one famous cup. Egg coffee is the reason many travelers arrive; the close storefront rhythm is why the street stays in memory.

**Keep The Walk Short**

This is a coffee pause, not a whole afternoon. Pair it with nearby Old Quarter streets, then move before the caffeine and traffic start to blur together.

### Implementation notes

* `page_id`: `city-hanoi-place-nguyen-huu-huan-street`
* Phrase/audio IDs: `food-menu` / `food-menu` mapped; `v900-food-drin-one-hot-coffee-please` / same audio key mapped; `food-pay-now` / `coffee-7` mapped.
* Mentioned Here candidates: `drink-ca-phe-trung` Cà phê trứng / Egg coffee — `render`; `hanoi-giang-cafe` Cà phê Giảng — `render`; `hanoi-old-quarter` Old Quarter — `render`.
* Related candidates: `hanoi-dinh-cafe` Dinh Cafe — `render`; `hanoi-the-note-coffee` The Note Coffee — `render`; `hanoi-coffee-hop` Hanoi coffee hop — `render`.
* Freshness/source notes: Supplied row cites MICHELIN Hanoi guide; verify current venue status for any named café before import.
* Score: 28/30 — clear street role and reusable coffee phrases; capped for named-café freshness and final audio/catalog mapping.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Đi chợ đêm phố cổ / Old Quarter night market walk — Hanoi — market

### Reader View

**A Night Lap Through The Old Quarter**

The night-market walk changes the Old Quarter’s pace: warm bulbs, stall tables, snack smoke, phone photos, and people moving more slowly than they do at noon. It is strongest as a loop for looking first and buying second.

**Useful phrase cards**

* **"Cái này bao nhiêu?"** — How much is this?
* **"Tôi chỉ xem thôi"** — I’m just looking.
* **"Không, cảm ơn"** — No, thank you.

**One Pass Before Paying**

Walk once without buying. The first stretch tells you what repeats, what feels crowded, and what is actually worth carrying for the rest of the night.

**Keep Purchases Small**

Small gifts make more sense than heavy bags. If you buy something, check the price, hold your change, and keep moving before one stall turns into a negotiation you did not want.

**Exit Before You Are Tired**

The market is better when you leave with energy for the next corner. Slip back toward a quieter Old Quarter lane or the lake edge before the crowd starts making every choice harder.

### Implementation notes

* `page_id`: `city-hanoi-place-night-market-walk`
* Phrase/audio IDs: `money-how-much` / `price-1` mapped; `shopping-just-looking` / `shop-4` mapped; `polite-no-thanks` / `polite-4` mapped.
* Mentioned Here candidates: `hanoi-old-quarter` Old Quarter — `render`; `hanoi-weekend-night-market` Hanoi Weekend Night Market — `render`; `hanoi-hoan-kiem-lake` Hoan Kiem Lake — `check_catalog`.
* Related candidates: `hanoi-old-quarter-walking-tour` Old Quarter walking route — `render`; `hanoi-ta-hien-street` Ta Hien Street — `render`; `hanoi-dong-xuan-market` Dong Xuan Market — `render`.
* Freshness/source notes: Supplied row cites Vietnam Travel Hanoi; verify current market nights, pedestrian street flow, stall mix, and crowd-control changes before import.
* Score: 27/30 — strong night-market behavior; capped for same-week timing and route checks.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Sân bay Nội Bài / Noi Bai International Airport — Hanoi — airport

### Reader View

**The First Real Hanoi Threshold**

Nội Bài is where the trip turns into bags, signs, glass doors, waiting families, and the first ride toward Hanoi. The best move is not rushing; settle your phone, pickup point, and ride plan before the doors pull you outside.

**Useful phrase cards**

* **"Nhập cảnh ở đâu?"** — Where is immigration?
* **"Lấy hành lý ở đâu?"** — Where is baggage claim?
* **"Điểm đón Grab ở đâu?"** — Where is the Grab pickup point?

**Clear The Basics Before Pickup**

Get through the official steps, find your bag, and pause before the public arrival area. A quiet minute with your phone and address saves a messier conversation outside.

**Name The Pickup Point**

Ride pickups can feel simple until everyone is standing under the same sign. Confirm the exact area before you start moving with luggage.

**Keep The First Ride Simple**

The first road into Hanoi is not the time for a complicated plan. Choose the hotel, Old Quarter, or first stop clearly, then save the city’s details for after check-in.

### Implementation notes

* `page_id`: `city-hanoi-place-noi-bai-airport`
* Phrase/audio IDs: `airport-immigration` / `airport-1` mapped; `airport-baggage` / `airport-2` mapped; `v900-airp-bord-arri-where-is-the-grab-pickup-point` / same audio key mapped.
* Mentioned Here candidates: `hanoi-old-quarter` Old Quarter — `check_catalog`.
* Related candidates: `hanoi-hanoi-railway-station` Hanoi Railway Station — `render`; `hanoi-nuoc-ngam-bus-station` Nuoc Ngam Bus Station — `render`; `hanoi-gia-lam-station` Gia Lam Railway Station — `check_catalog`.
* Freshness/source notes: Supplied rows cite Vietnam Travel Hanoi and Hanoi tourism portal; verify terminal flow, pickup areas, SIM counters, and ride-hailing pickup rules before import.
* Score: 28/30 — practical arrival sequence and ready-airport phrases; capped for current terminal/pickup details.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Bến xe Nước Ngầm / Nuoc Ngam Bus Station — Hanoi — station

### Reader View

**A Practical Handoff On Travel Day**

Nước Ngầm is a name to recognize when Hanoi turns back into movement: route boards, benches, ticket counters, motorbike horns, and the small scramble before an onward bus. It does not need romance; it needs a clear bay, a readable ticket, and a calm exit plan.

**Useful phrase cards**

* **"Đây có đúng bến không?"** — Is this the right platform?
* **"Xe này có đi tới… không?"** — Does this bus go to…?
* **"Khi nào có chuyến xe buýt tiếp theo?"** — When is the next bus?

**Confirm The Bay Before Sitting**

Do not relax just because you are inside the station. Check the bay, route, and departure time before settling onto a bench.

**Keep Tickets And Bags Close**

Travel days get messy at the edges. Keep the ticket, phone, and small bag where you can reach them while people are boarding, calling, and moving past.

**Plan The Ride Away From The Gate**

The station moment is only half the day. Know how you will leave on arrival, and keep a taxi or pickup plan ready for the other end.

### Implementation notes

* `page_id`: `city-hanoi-place-nuoc-ngam-bus-station`
* Phrase/audio IDs: `transport-platform` / `transport-1` mapped; `transport-bus-goes` / `transport-2` mapped; `v500-tran-when-is-the-next-bus` / same audio key mapped.
* Mentioned Here candidates: none for visible copy.
* Related candidates: `hanoi-my-dinh-bus-station` My Dinh Bus Station — `render`; `hanoi-giap-bat-bus-station` Giap Bat Bus Station — `render`; `hanoi-hanoi-railway-station` Hanoi Railway Station — `render`; `hanoi-noi-bai-airport` Noi Bai International Airport — `render`.
* Freshness/source notes: Supplied row is place-name only; keep claims narrow and verify current routes, ticket counters, bay layout, and access before import.
* Score: 26/30 — usable station draft with restrained claims; capped for sparse evidence and current-route uncertainty.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Phố cổ Hà Nội / Old Quarter — Hanoi — neighborhood

### Reader View

**A Neighborhood You Read On Foot**

The Old Quarter is close-up Hanoi: shop signs, scooters, hotel doors, coffee rooms, low stools, and old trade streets packed into a small area. A good visit is one short route, one pause, and a few clean crossings, not a hunt for every lane.

**Useful phrase cards**

* **"Tôi có thể đi bộ tới đó được không?"** — Can I walk there?
* **"Đi bộ mất bao lâu?"** — How long does it take on foot?
* **"Tôi chỉ xem thôi"** — I’m just looking.

**Choose One Spine**

Pick one line through the neighborhood before wandering off it. A lake edge, a coffee street, or a market corner gives the walk a shape when the lanes start folding into each other.

**Pause At Corners Before Crossing**

The traffic looks chaotic until you watch it for a moment. Stop, choose your gap, move steadily, and do not make the crossing a performance.

**Coffee Gives The Walk A Reset**

A short café pause turns the Old Quarter from noise into texture. Sit long enough to notice the room, then return to the street before the route gets too ambitious.

### Implementation notes

* `page_id`: `city-hanoi-place-old-quarter`
* Phrase/audio IDs: `v500-dire-navi-can-i-walk-there` / same audio key mapped; `directions-how-long` / `directions-3` mapped; `shopping-just-looking` / `shop-4` mapped.
* Mentioned Here candidates: `hanoi-hoan-kiem-lake` Hoan Kiem Lake — `render`; `hanoi-nguyen-huu-huan-street` Nguyen Huu Huan Street — `render`; `hanoi-coffee-hop` Hanoi coffee hop — `render`.
* Related candidates: `hanoi-old-quarter-walking-tour` Old Quarter walking route — `render`; `hanoi-night-market-walk` Old Quarter night market walk — `render`; `hanoi-ngoc-son-temple` Ngoc Son Temple — `render`; `hanoi-dong-xuan-market` Dong Xuan Market — `render`.
* Freshness/source notes: Supplied row cites Vietnam Travel Hanoi; verify pedestrian-night changes, street works, and business turnover before import.
* Score: 28/30 — specific neighborhood behavior and clean route logic; capped for current street conditions and final catalog QA.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Tuyến đi bộ Phố cổ / Old Quarter walking route — Hanoi — experience

### Reader View

**One Route Beats Ten Pins**

An Old Quarter walking route works when it gives the neighborhood a line: lake edge, street corner, coffee pause, snack stop, then one more lane before you quit while it still feels good.

**Useful phrase cards**

* **"Cho hỏi, đi tới đó thế nào?"** — Excuse me, how do I get there?
* **"Đi bộ mất bao lâu?"** — How long does it take on foot?
* **"Đi bộ có xa quá không?"** — Is it too far to walk?

**Pick Three Stops, Not Ten**

Three stops are enough: one place to look, one place to drink or eat, and one street that carries you between them. The route will feel better if it has room to breathe.

**Build In Coffee Or Shade**

A walking route needs a reset point. Plan one café, bench, lake edge, or quiet corner so the Old Quarter does not become one long traffic lesson.

**Leave A Clean Exit**

Know where you will stop walking. A clear endpoint makes it easier to enjoy the last lane instead of dragging the route past the point where you are still noticing things.

### Implementation notes

* `page_id`: `city-hanoi-place-old-quarter-walking-tour`
* Phrase/audio IDs: `directions-how-to-get` / `directions-1` mapped; `directions-how-long` / `directions-3` mapped; `v500-dire-navi-is-it-too-far-to-walk` / same audio key mapped.
* Mentioned Here candidates: `hanoi-old-quarter` Old Quarter — `render`; `hanoi-hoan-kiem-lake` Hoan Kiem Lake — `render`; `hanoi-coffee-hop` Hanoi coffee hop — `check_catalog`.
* Related candidates: `hanoi-nguyen-huu-huan-street` Nguyen Huu Huan Street — `render`; `hanoi-night-market-walk` Old Quarter night market walk — `render`; `hanoi-ngoc-son-temple` Ngoc Son Temple — `render`; `hanoi-ta-hien-street` Ta Hien Street — `render`.
* Freshness/source notes: Supplied row cites Vietnam Travel Hanoi; verify pedestrian streets, roadworks, and current route interruptions before import.
* Score: 28/30 — strong route behavior and reusable directions phrases; capped for route freshness and final mapping.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Chùa Một Cột / One Pillar Pagoda — Hanoi — landmark

### Reader View

**Small Pagoda, Slow Look**

One Pillar Pagoda is compact, so the shape has to carry the visit: the raised structure, pond, courtyard, and people moving through quietly. Give it a few still minutes instead of taking one photo and leaving.

**Useful phrase cards**

* **"Xin lỗi"** — Excuse me / sorry.
* **"Tôi có thể chụp ảnh ở đây được không?"** — Can I take a photo here?
* **"Mấy giờ đóng cửa?"** — What time does it close?

**Look At The Pond And The Platform**

The famous form makes more sense when you look at how it sits above the water. Step back, read the pond and platform together, then take the photo if the space allows.

**Give Worship Some Room**

It may be a quick visit for travelers, but it is still a religious place. Let people pass, keep voices low, and avoid turning the small courtyard into a photo queue.

**Ba Đình Makes The Stop Easier**

The pagoda fits naturally into a Ba Đình morning or afternoon. Pair it with nearby history stops only if you already have the energy for a heavier day.

### Implementation notes

* `page_id`: `city-hanoi-place-one-pillar-pagoda`
* Phrase/audio IDs: `polite-excuse-me` / `polite-5` mapped; `v900-sigh-acti-can-i-take-a-photo-here` / same audio key mapped; `sight-close` / `sight-4` mapped.
* Mentioned Here candidates: `hanoi-ba-dinh-district` Ba Dinh District — `render`; `hanoi-ho-chi-minh-mausoleum` Ho Chi Minh Mausoleum — `check_catalog`.
* Related candidates: `hanoi-ngoc-son-temple` Ngoc Son Temple — `render`; `hanoi-tran-quoc-pagoda` Tran Quoc Pagoda — `render`; `hanoi-temple-literature` Temple of Literature — `render`.
* Freshness/source notes: Supplied rows cite Hanoi tourism portal and Vietnam Travel Hanoi; verify access, hours, queue flow, and photo expectations before import.
* Score: 28/30 — tight landmark copy with a clear pace; capped for current access and photo-policy checks.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Nhà hát Lớn Hà Nội / Hanoi Opera House — Hanoi — experience

### Reader View

**Evening Belongs To The Opera House**

Hanoi Opera House feels most alive when the street is turning to evening: lamps on the façade, scooters around the square, people at the steps, and ticket doors suggesting there may be more than a photo here.

**Useful phrase cards**

* **"Tôi có thể mua vé ở đâu?"** — Where can I buy tickets?
* **"Có được phép chụp ảnh không?"** — Is photography allowed?
* **"Mấy giờ đóng cửa?"** — What time does it close?

**Check The Program Late**

The building can be a pass-by landmark or a real performance night. Look for current programming close to the date before promising the evening to it.

**Step Back For The Facade**

The street scene is part of the view. Cross with care, stand far enough back, and let the scooters, lamps, and steps give the building its Hanoi frame.

**Pair It With A French Quarter Walk**

The Opera House makes more sense with the surrounding French Quarter streets. A short walk nearby turns it from one façade into part of a quieter city rhythm.

### Implementation notes

* `page_id`: `city-hanoi-place-opera-house`
* Phrase/audio IDs: `v500-sigh-acti-where-can-i-buy-tickets` / same audio key mapped; `v900-sigh-acti-is-photography-allowed` / same audio key mapped; `sight-close` / `sight-4` mapped.
* Mentioned Here candidates: `hanoi-french-quarter` French Quarter — `render`; `hanoi-french-quarter-walk` French Quarter walk — `render`; `hanoi-trang-tien-street` Trang Tien Street — `check_catalog`.
* Related candidates: `hanoi-water-puppet-theatre` Thang Long Water Puppet Theatre — `render`; `hanoi-vietnam-national-tuong-theatre` Vietnam National Tuong Theatre — `render`; `hanoi-national-museum-history` Vietnam National Museum of History — `render`.
* Freshness/source notes: Supplied row cites Hanoi tourism portal; verify current programming, ticket access, photo rules, and opening conditions before import.
* Score: 27/30 — strong evening and performance framing; capped for event-program freshness.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Phố Phan Đình Phùng / Phan Dinh Phung Street — Hanoi — street

### Reader View

**A Leafy Street For A Slower Walk**

Phan Đình Phùng gives Hanoi a broader breath: tree shade, yellow villas, bicycles, and a street wide enough to notice façades without being swallowed by the Old Quarter crush. Come for a short walk, not a full plan.

**Useful phrase cards**

* **"Tôi có thể đi bộ tới đó được không?"** — Can I walk there?
* **"Đi bộ mất bao lâu?"** — How long does it take on foot?
* **"Tôi có thể chụp ảnh ở đây được không?"** — Can I take a photo here?

**Walk For Shade**

The trees are the reason to slow down. Keep the route simple, stay aware of traffic, and let the street be a calmer change of pace rather than another checklist.

**Take Photos From The Side**

The villas and bicycles make easy photos, but this is still a working street. Step out of the path, watch for motorbikes, and avoid blocking gates or sidewalks.

**Tie It To Ba Đình**

The street pairs naturally with Ba Đình, the Imperial Citadel area, or a quieter north-side walk. It is strongest when it gives the day air between heavier stops.

### Implementation notes

* `page_id`: `city-hanoi-place-phan-dinh-phung-street`
* Phrase/audio IDs: `v500-dire-navi-can-i-walk-there` / same audio key mapped; `directions-how-long` / `directions-3` mapped; `v900-sigh-acti-can-i-take-a-photo-here` / same audio key mapped.
* Mentioned Here candidates: `hanoi-ba-dinh-district` Ba Dinh District — `render`; `hanoi-imperial-citadel` Imperial Citadel of Thang Long — `render`; `hanoi-old-quarter` Old Quarter — `render`.
* Related candidates: `hanoi-hanoi-flag-tower` Hanoi Flag Tower — `render`; `hanoi-ba-dinh-square` Ba Dinh Square — `render`; `hanoi-west-lake` West Lake — `check_catalog`.
* Freshness/source notes: Supplied row cites Hanoi tourism portal; verify current sidewalk access, street works, traffic changes, and photo-sensitive areas before import.
* Score: 28/30 — observed street role and practical walking behavior; capped for access/current-condition checks.
* QA notes: replaceability pass; phrase-card pass; Mentioned Here pass; duplicate-body pass; anti-generic pass; screenshot/review gates not_run.

---

## Codex handoff block

* `batch_id: batch_037`
* `page_ids: city-hanoi-place-ngoc-son-temple, city-hanoi-place-nguyen-huu-huan-street, city-hanoi-place-night-market-walk, city-hanoi-place-noi-bai-airport, city-hanoi-place-nuoc-ngam-bus-station, city-hanoi-place-old-quarter, city-hanoi-place-old-quarter-walking-tour, city-hanoi-place-one-pillar-pagoda, city-hanoi-place-opera-house, city-hanoi-place-phan-dinh-phung-street`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none in visible cards; all selected cards are reusable ready-audio traveler-action phrases from Phrase Picker, with Codex to confirm final IDs/audio keys`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: light; watch for over-command headings during Jojo review, especially route/station pages`
* `source_freshness_risks: current hours, ticketing, photo rules, pedestrian/night-market timing, airport pickup zones, bus-station routes/bays, performance programming, sidewalk/street works`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
