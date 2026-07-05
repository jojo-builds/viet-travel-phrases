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
