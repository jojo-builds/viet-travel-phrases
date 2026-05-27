> REDO NOTE — the 2026-05-22 v2.2 redo source objects now live in `V2_2_RENDER_PILOT_REDO_APP_DETAILS.json`, with render QA in `V2_2_RENDER_PILOT_REDO_QA.md` and screenshots in `screenshots/v2-2-redo-2026-05-22/`. The markdown below is retained as the prior pilot narrative, not the current source object of record.
>
> Current standard: `speaklocal.place.app-detail.v2.2`. Start from `CURRENT_CITY_PAGE_STANDARD.md`.

# SpeakLocal Five More City Listings v2.2

This batch adds five app-ready city listings across five live Browse buckets:

| Runtime page ID | Listing | City | Runtime category |
|---|---|---|---|
| `viet-family-city-danang-place-international-terminal` | Nhà ga quốc tế Đà Nẵng / Da Nang International Terminal | Đà Nẵng | Arrivals and routes |
| `viet-family-city-danang-place-dong-dinh-museum` | Bảo tàng Đồng Đình / Dong Dinh Museum | Đà Nẵng | Landmarks and attractions |
| `viet-family-city-hcmc-place-pasteur-street` | Đường Pasteur / Pasteur Street | Saigon | Neighborhoods and streets |
| `viet-family-city-hanoi-place-loading-t-cafe` | Loading T Cafe | Hà Nội | Food and coffee |
| `viet-family-city-danang-place-lotte-mart` | Lotte Mart Đà Nẵng / Lotte Mart Da Nang | Đà Nẵng | Shopping and markets |

## Nhà ga quốc tế Đà Nẵng / Da Nang International Terminal - Đà Nẵng - Arrival

**Closest canonical anchor:** Da Nang Airport / city-arrival pages - this is an arrival-use listing, so the value is not sightseeing copy; it is making the first airport sequence feel nameable and less abstract.

### App-detail entry

**Solve The First Thirty Minutes**  
Da Nang International Terminal is where the central-Vietnam trip becomes practical: immigration, baggage, SIMs, cash, pickup doors, and the first warm road into the city. Treat it as a sequence, not a place to admire.

### Useful phrase cards

- **"Lấy hành lý ở đâu?"** - Where is baggage claim?  
  `intent: airport_baggage` - `phrase_id: airport-2` - `audio_status: existing`
- **"Mua SIM ở đâu?"** - Where can I buy a SIM card?  
  `intent: airport_sim` - `phrase_id: airport-3` - `audio_status: existing`
- **"Khu đón ở đâu?"** - Where is the pickup area?  
  `intent: airport_pickup_area` - `phrase_id: airport-5` - `audio_status: existing`
- **"Đây là hộ chiếu của tôi"** - Here is my passport  
  `intent: passport_ready` - `phrase_id: v500-airp-bord-arri-here-is-my-passport` - `audio_status: existing`

### Sections

**Follow The Arrival Order**  
The useful path is immigration, baggage, customs, then the public hall. Do not solve SIMs, cash, and pickup until you are out where those counters and drivers actually appear.

**Keep The Ride Visible**  
Open the pickup pin before leaving the hall. Da Nang is close, but terminal exits, ride apps, hotel drivers, and tour pickups can still split people across different doors.

**Good For Hoi An Plans Too**  
This terminal often starts the Da Nang or Hoi An trip. If the plan is a transfer south, confirm driver name, car plate, and hotel district before stepping into the pickup flow.

### Mentioned Here candidates

- **SIM card** - `type: service` - `catalog_status: known` - Directly named in the arrival flow.
- **ATM** - `type: service` - `catalog_status: known` - Natural arrival need.
- **Hoi An** - `type: city` - `catalog_status: known` - Common onward destination from the same arrival sequence.

### Related place candidates

- **Sân bay Đà Nẵng** - `type: airport` - `catalog_status: known` - Parent airport page.
- **Nhà ga quốc nội Đà Nẵng** - `type: airport` - `catalog_status: known` - Useful terminal contrast.

### Verification flags

- `same_week_verification: airport pickup rules, ride-app pickup location, and terminal service counters may change`
- `source_note: Official airport search result and Da Nang terminal arrival guide describe Terminal 2/international-arrival flow; repo source notes mark this as airport and transport sourced.`

### Score

27/30 - Clear traveler job, existing phrase cards, and good runtime category fit. Loses points only because airport pickup details need current verification.

### QA notes

- Replaceability test: pass.
- Phrase card test: pass.
- Mentioned Here test: pass.
- Duplicate body test: pass.
- Anti-cynicism test: pass.

## Bảo tàng Đồng Đình / Dong Dinh Museum - Đà Nẵng - Museum

**Closest canonical anchor:** Da Nang Museum / Cham Museum - this is a quieter culture stop, but the decision is different: go for a garden-house museum on Sơn Trà, not a central civic museum.

### App-detail entry

**Use Sơn Trà For Quiet Culture**  
Dong Dinh Museum is a private garden-house museum on the Sơn Trà side of Đà Nẵng, better for shade, old houses, ceramics, fishing-life objects, and a slower route than for a checklist museum hour.

### Useful phrase cards

- **"Vé bao nhiêu?"** - How much is the ticket?  
  `intent: ticket_price` - `phrase_id: sight-1` - `audio_status: existing`
- **"Tôi chụp hình ở đây được không?"** - Can I take photos here?  
  `intent: photo_permission` - `phrase_id: sight-3` - `audio_status: existing`
- **"Mấy giờ đóng cửa?"** - What time does it close?  
  `intent: closing_time` - `phrase_id: sight-4` - `audio_status: existing`
- **"Gọi taxi giúp tôi được không?"** - Can you call a taxi for me?  
  `intent: call_taxi` - `phrase_id: hotel-9` - `audio_status: existing`

### Sections

**Expect Garden Before Gallery**  
The first memory may be trees, stone, water, and shade before any display case. That is part of the point: the museum feels like a retreat from beach and bridge traffic.

**Look For The Four Stories**  
The collection is usually framed through antiquities, art, fishing life, and ethnography. Move slowly enough to see the house materials, not just the labels.

**Pair It With The Peninsula**  
It makes most sense near a Sơn Trà or Lady Buddha plan. Crossing town only for one small museum can feel thin unless you want quiet as the main event.

### Mentioned Here candidates

- **Sơn Trà Peninsula** - `type: place` - `catalog_status: known` - Route context.
- **Lady Buddha** - `type: landmark` - `catalog_status: known` - Natural same-route comparison.
- **Kim Bồng carpentry village** - `type: village` - `catalog_status: check_catalog` - Source-linked craft context from the museum story.

### Related place candidates

- **Chùa Linh Ứng** - `type: landmark` - `catalog_status: known` - Same peninsula pairing.
- **Bảo tàng Điêu khắc Chăm** - `type: museum` - `catalog_status: known` - Stronger central museum contrast.

### Verification flags

- `same_week_verification: hours and ticket price`
- `source_note: Central Vietnam Guide describes Dong Dinh Museum as a garden museum on Hoang Sa Street near Lady Buddha, with antiquities, art, fisherman life, and ethnography sections.`

### Score

28/30 - Specific place behavior, route pairing, and existing phrase cards. Needs only current-hour confirmation.

### QA notes

- Replaceability test: pass.
- Phrase card test: pass.
- Mentioned Here test: pass.
- Duplicate body test: pass.
- Anti-cynicism test: pass.

## Đường Pasteur / Pasteur Street - Saigon - Street

**Closest canonical anchor:** Đồng Khởi Street / Japan Town Saigon - this is a named-walk listing, not an attraction. It needs anchors, crossings, and a reason to say the street name.

### App-detail entry

**Use The Street As A Spine**  
Pasteur Street helps Saigon feel readable on foot: old street name, institute history, shophouses, cafes, offices, scooters, and short links toward District 1 anchors. Pick one stop, then walk nearby.

### Useful phrase cards

- **"Cho hỏi, đi tới đó thế nào?"** - Excuse me, how do I get there?  
  `intent: directions` - `phrase_id: directions-1` - `audio_status: existing`
- **"Đi bộ mất bao lâu?"** - How long does it take on foot?  
  `intent: walking_time` - `phrase_id: directions-3` - `audio_status: existing`
- **"Đây có phải là địa điểm trên bản đồ không?"** - Is this the place on the map?  
  `intent: map_check` - `phrase_id: v500-unde-repa-is-this-the-place-on-the-map` - `audio_status: existing`
- **"Dừng ở đây được rồi"** - You can stop here.  
  `intent: ride_stop` - `phrase_id: taxi-3` - `audio_status: existing`

### Sections

**Do Not Walk It End To End**  
Pasteur is useful as a street spine, not a mission. Start near one cafe, office, museum edge, or District 1 errand and let the street orient the next few blocks.

**Old Name, Present Movement**  
The street carries colonial-era layers, the Pasteur Institute story, surviving shophouses, and today's traffic. That mix is more useful than a romantic empty-street image.

**Cross With Patience**  
The real skill is crossing, pausing, checking the map, and choosing the next doorway. Ask for the street name when the pin is close but the entrance is not obvious.

### Mentioned Here candidates

- **District 1** - `type: neighborhood` - `catalog_status: known` - Natural orientation anchor.
- **Pasteur Institute** - `type: landmark` - `catalog_status: check_catalog` - Historical street-name anchor.
- **Cầu Mống** - `type: landmark` - `catalog_status: check_catalog` - Nearby historic bridge mentioned in source context.

### Related place candidates

- **Đường Đồng Khởi** - `type: street` - `catalog_status: known` - More polished heritage-shopping street contrast.
- **Quận 3** - `type: neighborhood` - `catalog_status: known` - Useful continuation west of the hotel core.

### Verification flags

- `light_verification: individual cafes and shops change quickly`
- `source_note: Historic Vietnam traces Pasteur Street's rue Pellerin history, Pasteur Institute connection, shophouses, and present street identity.`

### Score

27/30 - Strong street-use behavior and phrase cards. Kept claims intentionally stable because individual businesses change.

### QA notes

- Replaceability test: pass.
- Phrase card test: pass.
- Mentioned Here test: pass.
- Duplicate body test: pass.
- Anti-cynicism test: pass.

## Loading T Cafe - Hà Nội - Cafe

**Closest canonical anchor:** Cà phê Đinh / The Note Coffee - the page is about finding the upstairs pause and ordering one drink well, not praising "Hanoi cafe culture" in general.

### App-detail entry

**Find The Upstairs Pause**  
Loading T works well when you want an Old Quarter coffee break that feels tucked away: Chân Cầm address, second-floor room, patterned tiles, vintage corners, and cinnamon-leaning egg coffee.

### Useful phrase cards

- **"Cho tôi một cà phê sữa đá"** - One iced milk coffee please.  
  `intent: order_iced_milk_coffee` - `phrase_id: coffee-1` - `audio_status: existing`
- **"Ít đá thôi"** - Just a little ice.  
  `intent: less_ice` - `phrase_id: coffee-4` - `audio_status: existing`
- **"Tính tiền giúp tôi"** - Please let me pay.  
  `intent: pay_now` - `phrase_id: coffee-7` - `audio_status: existing`
- **"Tôi quẹt thẻ được không?"** - Can I pay by card?  
  `intent: card_payment` - `phrase_id: store-6` - `audio_status: existing`

### Sections

**Order Before Overexploring**  
Choose the drink first, especially if egg coffee or cinnamon coffee is the reason you came. The room is small enough that browsing too long can feel awkward.

**Let The Room Slow You Down**  
The draw is the pause: old building details, tile, collected objects, and a view back into Old Quarter movement. It is a reset between walks, not a work session to force.

**Check Hours Before Detouring**  
Cafe hours and address signals can drift across guide sites. If this is the coffee stop you care about, confirm it the same day before crossing town.

### Mentioned Here candidates

- **Cà phê trứng** - `type: drink` - `catalog_status: known` - Core drink context.
- **Cà phê sữa đá** - `type: drink` - `catalog_status: known` - Existing phrase/card connection.
- **Old Quarter** - `type: neighborhood` - `catalog_status: known` - Natural setting.

### Related place candidates

- **Cà phê Đinh** - `type: cafe` - `catalog_status: known` - Upstairs/egg-coffee comparison.
- **Nhà thờ Lớn Hà Nội** - `type: landmark` - `catalog_status: check_catalog` - Nearby orientation cue from source listings.

### Verification flags

- `same_week_verification: hours and payment options`
- `source_note: Loading T official site lists 8 P. Chân Cầm; Asian Coffee Map verified the cafe on 2026-05-09 and describes it as an Old Quarter cafe with daytime hours; Made in City notes the second-floor villa, tiles, and cinnamon egg coffee.`

### Score

28/30 - Very concrete behavior, existing audio phrase cards, and strong place details. Needs current-hours confirmation.

### QA notes

- Replaceability test: pass.
- Phrase card test: pass.
- Mentioned Here test: pass.
- Duplicate body test: pass.
- Anti-cynicism test: pass.

## Lotte Mart Đà Nẵng / Lotte Mart Da Nang - Đà Nẵng - Shopping

**Closest canonical anchor:** Hàn Market / Cồn Market - this is the opposite market job: air-conditioned practical shopping, not local-food discovery.

### App-detail entry

**Use It For Practical Shopping**  
Lotte Mart Da Nang is useful when the trip needs air-conditioning, groceries, snacks, toiletries, luggage-gap fixes, a food court, or one clear indoor meetup. Do not expect market atmosphere.

### Useful phrase cards

- **"Cái này bao nhiêu?"** - How much is this?  
  `intent: ask_price` - `phrase_id: price-1` - `audio_status: existing`
- **"Trả ở đâu?"** - Where do I pay?  
  `intent: pay_where` - `phrase_id: shop-5` - `audio_status: existing`
- **"Có túi không?"** - Do you have a bag?  
  `intent: ask_bag` - `phrase_id: store-2` - `audio_status: existing`
- **"Cho tôi hóa đơn"** - Please give me the receipt.  
  `intent: receipt` - `phrase_id: store-7` - `audio_status: existing`

### Sections

**Buy The Trip Fixes Here**  
Use it for sunscreen, water, snacks, toiletries, basic clothes, pharmacy-adjacent errands, and packaged gifts. It is a practical stop when heat or rain makes wandering inefficient.

**Food Court Before The Taxi**  
If the group is tired, eat or regroup before calling the car. A mall exit is easier when everyone has water, bags, and the same pickup point.

**Different From Hàn Market**  
Hàn Market is for central-market texture and souvenir bargaining. Lotte Mart is for predictable shelves, posted prices, cool air, and a lower-effort errand.

### Mentioned Here candidates

- **Hàn Market** - `type: market` - `catalog_status: known` - Direct comparison in copy.
- **Sunscreen** - `type: service_item` - `catalog_status: known` - Existing shopping phrase connection.
- **Food court** - `type: place` - `catalog_status: check_catalog` - Natural practical module.

### Related place candidates

- **Chợ Hàn** - `type: market` - `catalog_status: known` - Local-market contrast.
- **Vincom Plaza Đà Nẵng** - `type: mall` - `catalog_status: known` - Similar indoor shopping alternative.

### Verification flags

- `same_week_verification: hours, pickup doors, and food-court status`
- `source_note: Da Nang Love lists Lotte Mart Da Nang at 6 Nai Nam with groceries, home goods, clothing, electronics, food court, and air-conditioning; repo source notes mark it as local-map sourced.`

### Score

28/30 - Distinct market job, clear phrase-card utility, and practical contrast with Hàn Market. Needs current-hours check.

### QA notes

- Replaceability test: pass.
- Phrase card test: pass.
- Mentioned Here test: pass.
- Duplicate body test: pass.
- Anti-cynicism test: pass.

## Source Links

- Da Nang Airport official site: https://danangairport.vn/
- Da Nang Terminal 2 arrival guide/search reference: https://beta.danangairportterminal.vn/en/airport-guide/arrivals/
- Dong Dinh Museum source: https://centralvietnamguide.com/museums-in-da-nang/
- Pasteur Street source: https://www.historicvietnam.com/pasteur-street/
- Loading T official site: https://www.loadingtcafe.com/
- Loading T current listing: https://asiancoffeemap.com/reviews/hanoi/loading-t-cafe-chan-cam
- Loading T place detail: https://www.madein.city/hanoi/en/places/loading-t-cafe-wj189xsxgoci4cp0slh17a65/
- Lotte Mart Da Nang source: https://dananglove.com/supermarkets-grocery-stores/
