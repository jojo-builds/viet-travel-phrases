SpeakLocal v2.2 BATCH_041 - Hanoi/Saigon - 2026-05-26

## Nhà hát Múa rối Thăng Long / Thang Long Water Puppet Theatre — Hanoi

### Reader View

**An Evening Show With Real Hanoi Texture**

Thang Long Water Puppet Theatre turns a Hoàn Kiếm evening into something warmer than another lake loop. The dark water, live music, lacquered puppets, and small-stage timing give Vietnamese performance a shape you can remember after the lights come up.

**Useful phrase cards**

* **Vé bao nhiêu?** — How much is the ticket?
* **Tôi có thể chọn chỗ ngồi của mình không?** — Can I choose my seat?
* **Nó bắt đầu lúc mấy giờ?** — What time does it start?

**Arrive Before The Curtain**

The theatre sits in a busy central pocket, so the first win is simple: arrive with enough time to find the door, settle your seat, and stop treating the show like one more errand between photos.

**Music Does More Than Decorate**

The puppets are the image people remember, but the musicians give the show its pulse. Listen for the drum hits, voices, and water sounds before trying to follow every story beat.

**Check Photos Before You Lift The Phone**

Stage rules can change, and a phone screen is the fastest way to pull yourself out of the room. Ask first, then put the show back in front of you.

### Implementation notes

* Phrases: `sight-1` / `sight-1` ready; `v500-time-date-book-can-i-choose-my-seat` / same ready; `v900-time-date-book-what-time-does-it-start` / same ready.
* Mentioned Here candidates: Hoàn Kiếm Lake — `hanoi-hoan-kiem-lake`, place, `render`; Old Quarter — `hanoi-old-quarter`, neighborhood, `check_catalog` if copy later names it.
* Related place candidates: Hanoi Opera House — `hanoi-opera-house`, performance contrast, `check_catalog`; Hoàn Kiếm Lake — `hanoi-hoan-kiem-lake`, evening pairing, `render`.
* Place-name audio: `city-hanoi-place-water-puppet-theatre` ready, `audio-authored-nha-hat-mua-roi-thang-long-bee079cc3d`.
* Freshness/source: Vietnam Travel Hanoi source; recheck show times, ticket flow, seat rules, and photo policy before import.
* Score/QA: 28/30. Voice pass; phrase cards ready; catalog candidates evaluated; no duplicate body; screenshot and production gates not_run.

## Chợ đêm phố cổ Hà Nội / Hanoi Weekend Night Market — Hanoi

### Reader View

**A Slow Lap Before The Lights Take Over**

Hanoi Weekend Night Market is less about one famous stall than the Old Quarter changing gears after dark. Stalls open into the street, walkers thicken, and the better move is to browse once before committing to food, small gifts, or a photo stop.

**Useful phrase cards**

* **Cái này bao nhiêu?** — How much is this?
* **Bớt chút được không?** — Can you lower it a little?
* **Tôi chỉ xem thôi.** — I’m just looking.

**Browse Once Before Buying**

Give yourself one pass with your hands free. The first stall is rarely the only version, and the walk makes it easier to see which prices, snacks, and souvenirs repeat.

**Keep Orders Small**

Night-market food is better in rounds than in one heavy decision. Try one snack, keep moving, then decide whether the crowd still feels fun.

**Step Out When The Street Narrows**

The best parts can also be the tightest: warm lights, food smoke, bikes at the edges, and people stopping suddenly. Keep your bag close and pause at the side before checking your phone.

### Implementation notes

* Phrases: `price-1` / `price-1` ready; `price-4` / `price-4` ready; `shop-4` / `shop-4` ready.
* Mentioned Here candidates: Old Quarter — `hanoi-old-quarter`, neighborhood, `render`; Hoàn Kiếm Lake — `hanoi-hoan-kiem-lake`, nearby place, `check_catalog` if copy later names it.
* Related place candidates: Old Quarter walking route — `hanoi-old-quarter-walking-tour`, route pairing, `check_catalog`; Dong Xuan Market — `hanoi-dong-xuan`, daytime market contrast, `check_catalog`.
* Place-name audio: `city-hanoi-place-weekend-night-market` planned; hide place-name audio until ready.
* Freshness/source: Vietnam Travel Hanoi source; recheck weekend timing, street coverage, stall mix, and any pedestrian rules.
* Score/QA: 28/30. Market behavior clear; phrase cards ready; no one-off phrases; no duplicate body; screenshot and production gates not_run.

## Hồ Tây / West Lake — Hanoi

### Reader View

**A Water Break From The Street Noise**

West Lake gives Hanoi a wider horizon: shore roads, café edges, temple silhouettes, and long views that change with the weather. It is the place for a walk, coffee, or sunset pause when the Old Quarter feels too tight.

**Useful phrase cards**

* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Ở gần đây không?** — Is it near here?
* **Tôi có thể đi bộ tới đó được không?** — Can I walk there?

**Choose One Shoreline**

The lake is bigger than it looks on a phone. Pick one edge for the day—Tây Hồ café streets, the temple side, or a short sunset stretch—rather than trying to fold the whole lake into a quick gap.

**Cafés Make The Pause Easier**

A drink gives the view a frame. Sit near the water, watch the scooters and walkers pass, then decide whether you want more shoreline or a ride back into the center.

**Temples And Neighborhoods Change The Mood**

Tran Quoc Pagoda, Tây Hồ streets, and smaller lake roads each give a different version of the same water. The lake can hold the pause even when haze softens the view.

### Implementation notes

* Phrases: `directions-3` / `directions-3` ready; `directions-2` / `directions-2` ready; `v500-dire-navi-can-i-walk-there` / same ready.
* Mentioned Here candidates: Tây Hồ — `hanoi-tay-ho`, neighborhood, `render`; Tran Quoc Pagoda — `hanoi-tran-quoc-pagoda`, landmark, `render`; Old Quarter — `hanoi-old-quarter`, neighborhood, `check_catalog`.
* Related place candidates: West Lake loop — `hanoi-west-lake-loop`, route pairing, `render`; Tran Quoc Pagoda — `hanoi-tran-quoc-pagoda`, nearby landmark, `render`.
* Place-name audio: `city-hanoi-place-west-lake` ready, `audio-authored-ho-tay-e93d0b9507`.
* Freshness/source: Hanoi tourism portal source; recheck access notes only if future copy adds hours, parking, events, or venue claims.
* Score/QA: 29/30. Calm, specific, and low-risk; phrase cards ready; catalog candidates evaluated; no duplicate body; screenshot and production gates not_run.

## Vòng Hồ Tây / West Lake loop — Hanoi

### Reader View

**Circle Only As Much As The Day Allows**

The West Lake loop sounds tidy on a map, but in real Hanoi it is a long shoreline with scooters, shade gaps, cafés, and changing sidewalks. Treat it as a flexible ride or walk in sections, not a promise to finish every meter.

**Useful phrase cards**

* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Điểm đón ở đâu?** — Where is the pickup point?
* **Tôi gặp tài xế ở đâu?** — Where do I meet the driver?

**Pick A Section Before Moving**

A short, good stretch beats a heroic loop done tired. Choose a side near your café, temple stop, or hotel route, then let the lake decide how far you keep going.

**Leave Room For Traffic And Heat**

The road rhythm changes fast: quiet water, then scooter clusters, then a tight corner with no patience for wandering. Keep the plan loose, especially in midday heat.

**End Near Food Or A Ride Point**

The loop is easier when the finish is already imagined. End near a café, a known street, or a pickup point instead of waiting until you are tired to solve the ride back.

### Implementation notes

* Phrases: `directions-3` / `directions-3` ready; `directions-8` / `directions-8` ready; `airport-pickup-clearer` / `airport-pickup-clearer` ready.
* Mentioned Here candidates: West Lake — `hanoi-west-lake`, place, `render`; Tây Hồ — `hanoi-tay-ho`, neighborhood, `render`; Tran Quoc Pagoda — `hanoi-tran-quoc-pagoda`, landmark, `check_catalog` if copy later names it.
* Related place candidates: West Lake — `hanoi-west-lake`, parent place, `render`; Tây Hồ — `hanoi-tay-ho`, neighborhood stop, `render`.
* Place-name audio: `city-hanoi-place-west-lake-loop` planned; hide place-name audio until ready.
* Freshness/source: Hanoi tourism portal source; verify route conditions only if future copy adds bike-rental, closure, or traffic-rule claims.
* Score/QA: 28/30. Clear route behavior; phrase cards ready; no unsupported transport claims; no duplicate body; screenshot and production gates not_run.

## Bảo tàng Phụ nữ Việt Nam / Vietnamese Women's Museum — Hanoi

### Reader View

**Choose A Few Rooms And Slow Down**

The Vietnamese Women’s Museum gives Hanoi a quieter interior story after the street rush: clothing, family life, wartime memory, and everyday labor shown through objects rather than spectacle. A short visit works if you choose a few rooms and let the details do the work.

**Useful phrase cards**

* **Xin một vé.** — One ticket, please.
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Có được phép chụp ảnh không?** — Is photography allowed?

**Follow Objects, Not Every Label**

Follow what catches your eye: a garment, a wedding object, a work tool, a wartime photo. The museum lands better when you build meaning from a few objects instead of trying to absorb every panel.

**Ask About English Support**

Interpretation can shape the visit here. If English support is limited, keep the visit visual and slow; the rooms still give enough texture through materials, faces, and arrangement.

**Leave Space After Heavy Rooms**

Some galleries may carry more emotional weight than the calm entrance suggests. Plan a café, a walk, or a quiet reset afterward instead of stacking the day too tightly.

### Implementation notes

* Phrases: `v500-time-date-book-one-ticket-please` / same ready; `v900-sigh-acti-is-there-an-english-guide` / same ready; `v900-sigh-acti-is-photography-allowed` / same ready.
* Mentioned Here candidates: none forced; current copy does not name a natural catalog item besides the page itself.
* Related place candidates: Hoa Lo Prison Relic — `hanoi-hoa-lo-prison`, serious museum pairing, `check_catalog`; Hanoi Opera House — `hanoi-opera-house`, nearby culture pairing, `check_catalog`.
* Place-name audio: `city-hanoi-place-womens-museum` planned; hide place-name audio until ready.
* Freshness/source: Hanoi tourism portal source; recheck hours, ticketing, English interpretation, temporary exhibits, and photo policy.
* Score/QA: 28/30. Museum-fatigue prevention clear; phrase cards ready; no duplicate body; catalog scan complete; screenshot and production gates not_run.

## Xôi xéo ở Hà Nội / Sticky rice with mung bean — Hanoi

### Reader View

**Breakfast That Fits In One Hand**

Xôi xéo is yellow sticky rice folded into a quick Hanoi meal: mung bean pressed soft, fried shallots on top, and warm grains that travel well in paper or leaf. It is a breakfast move more than a sit-down event.

**Useful phrase cards**

* **Cho tôi một phần.** — One portion, please.
* **Cái này bao nhiêu?** — How much is this?
* **Mang đi.** — To go.

**Look For Steam And Turnover**

This dish is best when it feels recently made. Watch for warm rice, steady local buying, and toppings moving quickly rather than a tray that looks forgotten.

**Order Small The First Time**

Sticky rice is heavier than it looks. A small portion gives you the texture—soft mung bean, chewy rice, crisp shallot—without turning breakfast into a weight you carry all morning.

**Toppings Change The Meal**

Plain xôi xéo is simple and fragrant. Extra meat, egg, or sausage can make it closer to a full meal, so point carefully and check the price before the packet is closed.

### Implementation notes

* Phrases: `food-1` / `food-1` ready; `price-1` / `price-1` ready; `coffee-6` / `coffee-6` ready.
* Mentioned Here candidates: Xôi xéo — `food-xoi-xeo`, food, `render`; xôi mặn — `food-xoi-man`, food, `check_catalog` only if future copy names the savory variant.
* Related place candidates: none; dish page can stand without a route card.
* Place-name audio: `city-hanoi-place-xoi-xeo` planned; hide place-name audio until ready.
* Freshness/source: place-name source plus Menu Catalog item `food-xoi-xeo`; do not render exact dish quick-say unless audio is mapped or created.
* Score/QA: 27/30. Concrete food behavior; capped for thin place evidence and planned place-name audio; no duplicate body; screenshot and production gates not_run.

## Công viên Yên Sở / Yen So Park — Hanoi

### Reader View

**Open Air Without A Sightseeing Script**

Yen So Park is the Hanoi pause where nothing has to be checked off. Lakeside paths, open grass, trees, and family movement make it feel more like a local afternoon than a formal attraction.

**Useful phrase cards**

* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Điểm đón ở đâu?** — Where is the pickup point?
* **Bây giờ nó có mở không?** — Is it open now?

**Go For Space, Not A Landmark**

The point is the room to breathe: grass, paths, water, and ordinary city life happening around you. Bring the right expectation and the park does not have to perform for you.

**Keep It Weather-Aware**

Open air is the appeal and the catch. Heat, rain, and muddy paths can change the visit quickly, so keep the plan light and leave room to shorten it.

**Know Your Exit Before Dusk**

A big park can feel easy until the return ride becomes vague. Save your pickup point, notice the gate you entered, and leave while the way back still feels clear.

### Implementation notes

* Phrases: `directions-3` / `directions-3` ready; `directions-8` / `directions-8` ready; `v500-dire-navi-is-it-open-now` / same ready.
* Mentioned Here candidates: none forced; current copy does not name a natural catalog item besides the page itself.
* Related place candidates: none unless future route copy pairs the park with a specific south-Hanoi stop.
* Place-name audio: `city-hanoi-place-yen-so-park` planned; hide place-name audio until ready.
* Freshness/source: Hanoi tourism portal source; recheck access, opening pattern, gates, weather-sensitive conditions, and any event closures.
* Score/QA: 27/30. Sparse-evidence copy kept restrained; phrase cards ready; no duplicate body; screenshot and production gates not_run.

## Ga Bến Thành / Ben Thanh Metro Station — Saigon

### Reader View

**Read The Signs Before You Surface**

Ga Bến Thành is the stop where Saigon shifts from maps to street choices. Give yourself a minute with the route boards, exits, and meeting points before stepping back into the traffic around Ben Thanh.

**Useful phrase cards**

* **Đây có đúng bến không?** — Is this the right platform?
* **Đó là lối ra nào?** — Which exit is it?
* **Điểm đón ở đâu?** — Where is the pickup point?

**Match The Exit To The Next Street**

The wrong exit can turn a simple transfer into a hot, noisy backtrack. Check the street name, market side, or pickup point before following the fastest crowd upstairs.

**Crowds Move Faster Than First-Timers**

Stations reward small pauses. Step aside to read the board, confirm the direction, and let commuters pass before you make the next move.

**Solve The Handoff Outside**

After the train, the next question is usually not the station itself—it is the walk, taxi, market, or hotel route after it. Confirm the meeting point while you still have your bearings.

### Implementation notes

* Phrases: `transport-1` / `transport-1` ready; `repair-premium-which-exit` / same ready; `directions-8` / `directions-8` ready.
* Mentioned Here candidates: Ben Thanh Market — `hcmc-ben-thanh-market`, market, `render`; District 1 — `hcmc-district-1`, neighborhood, `check_catalog` if future copy names it.
* Related place candidates: Ben Thanh Market — `hcmc-ben-thanh-market`, nearby market, `render`; Nguyen Hue Walking Street — `hcmc-nguyen-hue-walking-street`, central walk pairing, `check_catalog`.
* Place-name audio: `city-hcmc-place-ben-thanh-metro-station` planned; hide place-name audio until ready.
* Freshness/source: Visit HCMC portal source; recheck station access, ticketing, line status, exits, and wayfinding before import.
* Score/QA: 27/30. Specific station moment; visible copy avoids current-service promises; phrase cards ready; screenshot and production gates not_run.

## Bếp Mẹ Ỉn / Bep Me In — Saigon

### Reader View

**Make Dinner Part Of The Walk**

Bếp Mẹ Ỉn is the kind of central Saigon meal that can slow the day down without turning dinner into a ceremony. Expect a compact room feel, clay-pot warmth, herbs, shared plates, and a table rhythm that suits travelers who want Vietnamese food without decoding a street stall first.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Ít cay thôi.** — Less spicy, please.
* **Tính tiền giúp tôi.** — Please let me pay.

**Read The Menu Before Ordering Wide**

A comfortable restaurant can make it too easy to order the whole idea of Vietnam at once. Choose one main dish, one vegetable or shared plate, then see how the table feels.

**Ask Early About Heat And Ingredients**

If pork, shellfish, spice, or herbs matter to you, ask before the order starts moving. A calm table is the right place to handle that, not after dishes arrive.

**Keep The Meal Close To The Evening**

This is a good central dinner before or after Ben Thanh browsing. Let it be the meal, then move back into the night instead of asking one table to carry the whole evening.

### Implementation notes

* Phrases: `food-menu` / `food-menu` ready; `food-not-spicy-clearer` / `audio-authored-it-cay-thoi-05b8e258a2` ready; `coffee-7` / `coffee-7` ready.
* Mentioned Here candidates: Ben Thanh Market — `hcmc-ben-thanh-market`, market, `render`; specific menu items — `do_not_render` until current menu is checked.
* Related place candidates: Ben Thanh Market — `hcmc-ben-thanh-market`, nearby pre/post-meal pairing, `render`; District 1 — `hcmc-district-1`, central-area context, `check_catalog`.
* Place-name audio: `city-hcmc-place-bep-me-in` planned; hide place-name audio until ready.
* Freshness/source: local named-restaurant source plus legacy copy; recheck current address, opening status, menu, booking/queue pattern, and holiday closures.
* Score/QA: 27/30. Voice is controlled and menu claims are restrained; phrase cards ready; no duplicate body; screenshot and production gates not_run.

## Chợ Bình Tây / Binh Tay Market — Saigon

### Reader View

**Watch The Market Work First**

Binh Tay Market is better when you arrive ready to observe before buying. The courtyard, yellow facade, packed aisles, bags, produce colors, and wholesale rhythm show a different Saigon from the hotel core.

**Useful phrase cards**

* **Cái này bao nhiêu?** — How much is this?
* **Bớt chút được không?** — Can you lower it a little?
* **Tôi chỉ xem thôi.** — I’m just looking.

**Make The First Lap Reconnaissance**

Walk once with no pressure to purchase. Notice which aisles feel wholesale, which counters are easier for small buys, and where the crowd naturally slows.

**Buy Lightly, Carry Less**

The market can tempt you into bags before the day is ready for them. Small goods, snacks, or a short browse keep the visit useful without turning the rest of the route into luggage management.

**Pair It With Chợ Lớn Streets**

Binh Tay makes the most sense as part of a Cho Lon morning. Add Thien Hau Pagoda or a nearby street look afterward if you still have attention for one more stop.

### Implementation notes

* Phrases: `price-1` / `price-1` ready; `price-4` / `price-4` ready; `shop-4` / `shop-4` ready.
* Mentioned Here candidates: Cho Lon — `hcmc-cho-lon`, neighborhood, `render`; Thien Hau Pagoda — `hcmc-thien-hau-pagoda`, landmark, `render`; Ben Thanh Market — `hcmc-ben-thanh-market`, market contrast, `check_catalog` if future copy names it.
* Related place candidates: Cho Lon walking route — `hcmc-cho-lon-walking-route`, area route, `check_catalog`; Thien Hau Pagoda — `hcmc-thien-hau-pagoda`, nearby cultural stop, `render`; Ben Thanh Market — `hcmc-ben-thanh-market`, central-market contrast, `render`.
* Place-name audio: `city-hcmc-place-binh-tay-market` ready, `audio-authored-cho-binh-tay-4e1f45d293`.
* Freshness/source: existing city library plus Vietnam Travel HCMC source; recheck hours, access, renovation status, stall mix, and visitor-facing buying norms.
* Score/QA: 28/30. Market role is distinct from Ben Thanh; phrase cards ready; catalog candidates evaluated; no duplicate body; screenshot and production gates not_run.

## Codex handoff block

* `batch_id: batch_041`
* `page_ids: city-hanoi-place-water-puppet-theatre, city-hanoi-place-weekend-night-market, city-hanoi-place-west-lake, city-hanoi-place-west-lake-loop, city-hanoi-place-womens-museum, city-hanoi-place-xoi-xeo, city-hanoi-place-yen-so-park, city-hcmc-place-ben-thanh-metro-station, city-hcmc-place-bep-me-in, city-hcmc-place-binh-tay-market`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none visible; all visible phrase cards use ready-audio reusable traveler-action phrases`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; ready for water-puppet-theatre, west-lake, binh-tay-market; planned/hide for weekend-night-market, west-lake-loop, womens-museum, xoi-xeo, yen-so-park, ben-thanh-metro-station, bep-me-in`
* `visible_copy_risks: Bep Me In menu specifics intentionally limited; Ben Thanh Metro Station avoids service-frequency or ticket-rule claims; all hours/prices/current rules kept out of visible copy`
* `source_freshness_risks: theatre show times and photo rules; weekend night market timing and stall mix; museum hours and English support; xoi vendor variation; Yen So Park access and gates; metro station access/wayfinding; Bep Me In current menu/address/status; Binh Tay Market hours/access/stall mix`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
