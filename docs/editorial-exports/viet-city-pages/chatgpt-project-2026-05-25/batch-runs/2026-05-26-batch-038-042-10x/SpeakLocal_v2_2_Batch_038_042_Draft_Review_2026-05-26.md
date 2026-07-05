# SpeakLocal v2.2 Batch 038-042 Draft Review


Date: 2026-05-26


Status: captured draft review. Not production-ready. Batch-level productionizer status: `revise_before_review` until the full 50-page pass is complete.


Google/reader note: this document replaces screenshots for copy review; implementation notes remain separate from app-visible copy.


## Audit Summary


- The drafts are stronger than early Codex-generated prose, but they are still drafts.
- `batch_040` leaked a visible `Sections` label into the Reader View shape. This is a hard productionizer fix before Jojo review or import.
- Several batches use bare `Phrase cards` instead of `Useful phrase cards`. That is not fatal for review docs, but it is an import risk if a normalizer treats labels as app-visible fields.
- The safer reusable-phrase rule sometimes flattens similar food pages into repeated three-card sets. Repeats need to be justified, varied, or marked for revision.
- Some headings still cluster around command verbs such as `Keep`, `Choose`, `Read`, `Ask`, `Confirm`, and `Leave`. The cadence is better than the rejected pilot voice, but a 10-listing batch makes the scaffold visible.
- Thin-source rows must stay narrow. The productionizer should block or shrink pages that invent generic station, cafe, street, market, or airport props to cover missing evidence.

## Batch Decision

Batch-level decision: `revise_before_review`.

Reason: this batch needs a productionizer pass before Jojo voice review. The pass should remove export-label leaks, sweep heading cadence, check phrase-card repetition, and mark any thin-source pages that cannot carry the current copy.

## Next Action

Run the productionizer prompt on representative slices first, then apply it to all captured batches before import work. Do not call these 50 production-ready until Jojo voice approval, phrase/audio/catalog mapping, source import, native regeneration, rendered screenshots, and `V2_2_PRODUCTION_REVIEW_GATE.md` pass.


## Captured Drafts



# BATCH_038


SpeakLocal v2.2 BATCH_038 - Hanoi - 2026-05-26

## Loading T Cafe / Loading T Cafe — Hanoi — Cafe

### Reader View

**A Short Climb For Cinnamon Coffee**

Loading T feels best as a brief Old Quarter reset: find the Chân Cầm address, climb to the second-floor room, and let the patterned tile and old furniture slow the block down. If egg coffee is why you came, order first; the cinnamon note belongs in the cup, not in a long stay.

**Useful phrase cards**

* **Tôi có lên lầu không?** — Do I go upstairs?
* **Làm ơn bớt đường đi** — Less sugar, please.
* **Tính tiền giúp tôi** — Please let me pay.

**Order Before Looking Around**

The room is small enough that the visit feels smoother once the drink is handled. Choose coffee, settle, then notice the tile, corners, and window back toward Old Quarter movement.

**Keep It A Short Pause**

This is not the cafe to turn into a full work session. It is better as a twenty-minute cup between streets, when Hanoi has been loud and you want one upstairs room.

**Confirm The Door Before Crossing Town**

Small cafes can shift hours, entrances, or seating without much warning. If Loading T is the main coffee stop of the day, verify the basics before making a long detour.

### Implementation notes

* IDs: page_id `city-hanoi-place-loading-t-cafe`; ledger_row `146`; hero `HeroCityHanoiPlaceLoadingTCafe`.
* Phrase/audio: `v500-dire-navi-do-i-go-upstairs` / `v500-dire-navi-do-i-go-upstairs` mapped; `v900-food-drin-less-sugar-please` / `v900-food-drin-less-sugar-please` mapped; `coffee-7` / `coffee-7` mapped.
* Name audio: `city-hanoi-place-loading-t-cafe` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `drink-ca-phe-trung` Egg coffee render; `hanoi-old-quarter` Old Quarter render; Chân Cầm street has no confirmed catalog row, do_not_render.
* Related place candidates: `hanoi-dinh-cafe`, `hanoi-giang-cafe`, `hanoi-the-note-coffee` for Hanoi coffee comparison; needs catalog QA before rendering.
* Source/freshness notes: supplied row is place-name only plus legacy Chân Cầm/upstairs/cinnamon-leaning egg coffee details; verify current entrance, hours, seating, and menu before import.
* Score: 26/30 — sharper upstairs moment; capped for sparse evidence and planned place-name audio.
* QA notes: Reader View has 3 ready-audio phrase cards, no duplicate body, no unsupported phrase cards, and no numbered visible heading; screenshot and production gates remain pending.

## Phở Bát Đàn / Pho Bat Dan — Hanoi — Restaurant

### Reader View

**Steam At A Metal Table**

Phở Bát Đàn is the kind of meal that makes the Old Quarter feel awake: steam over beef broth, herbs waiting at the side, and a simple table that clears quickly once the bowl is done. Come for the bowl, not a long sit.

**Useful phrase cards**

* **Làm ơn cho tôi một tô phở** — I’d like a bowl of phở, please.
* **Cho thêm rau** — More herbs, please.
* **Tính tiền giúp tôi** — Please let me pay.

**Choose The Bowl Before The Table**

The visit goes better when you already know the main move: beef pho, herbs, broth, then sit. This is a focused meal, not a menu-reading afternoon.

**Keep The Broth Clear**

Add herbs, lime, or chili slowly. Hanoi pho can be quiet in the bowl before it becomes bright at the edge, and the first spoonful tells you how much it needs.

**Leave While The Bowl Still Leads**

The memory should be steam, broth, and the street outside — not overworking the stop. Eat, pay, and let the rest of the Old Quarter keep moving.

### Implementation notes

* IDs: page_id `city-hanoi-place-pho-bat-dan`; ledger_row `166`; hero `HeroCityHanoiPlacePhoBatDan`.
* Phrase/audio: `v500-food-drin-id-like-a-bowl-of-ph-please` / `v500-food-drin-id-like-a-bowl-of-ph-please` mapped; `food-4` / `food-4` mapped; `coffee-7` / `coffee-7` mapped.
* Name audio: `city-hanoi-place-pho-bat-dan` / `audio-authored-pho-bat-dan-5484f2c6ca` ready; render as pronunciation/name support only.
* Mentioned Here candidates: `food-pho-bo` Beef pho render; `hanoi-old-quarter` Old Quarter render.
* Related place candidates: `hanoi-pho-gia-truyen`, `hanoi-pho-bo-lam`, `hanoi-pho-bo` for pho comparison; needs catalog QA before rendering.
* Source/freshness notes: supplied row is place-name only plus legacy bowl/table/Old Quarter details; verify current hours, menu flow, line/payment norms, and closure status before import.
* Score: 25/30 — clear meal rhythm; capped for thin venue evidence.
* QA notes: Reader View has 3 ready-audio phrase cards, no place-name phrase card, no duplicate body, and no volatile claims about price or queue rules; screenshot and production gates remain pending.

## Phở bò ở Hà Nội / Beef pho — Hanoi — Dish

### Reader View

**Broth Before Add-Ins**

Beef pho is the Hanoi bowl most travelers imagine before arrival: clear beef broth, flat rice noodles, sliced beef, green onion, herbs, and lime close by. The better first move is restraint — taste the broth before turning the table into a condiment project.

**Useful phrase cards**

* **Làm ơn cho tôi một tô phở** — I’d like a bowl of phở, please.
* **Cho thêm rau** — More herbs, please.
* **Không cay nhé** — Not spicy, please.

**Taste First, Then Adjust**

Take one spoonful before adding lime, chili, or extra herbs. The bowl changes quickly, and a lighter hand keeps the broth from disappearing under everything else.

**Know The Beef Words**

If you see tái, expect rarer beef. Chín points toward cooked beef. You do not need every cut on the first bowl; one clear choice is enough.

**Make It The Hanoi Baseline**

After one good beef pho, other noodle soups become easier to read. You start to notice broth weight, herbs, texture, and how much the city can fit into one bowl.

### Implementation notes

* IDs: page_id `city-hanoi-place-pho-bo`; ledger_row `167`; hero `HeroCityHanoiPlacePhoBo`.
* Phrase/audio: `v500-food-drin-id-like-a-bowl-of-ph-please` / `v500-food-drin-id-like-a-bowl-of-ph-please` mapped; `food-4` / `food-4` mapped; `food-3` / `food-3` mapped.
* Name audio: `city-hanoi-place-pho-bo` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `food-pho-bo` Phở bò render; `food-pho-tai` Phở tái render; `food-pho-chin` Phở chín render.
* Related place candidates: `hanoi-pho-ga` for chicken pho contrast; `hanoi-pho-bat-dan`, `hanoi-pho-bo-lam`, `hanoi-pho-gia-truyen` for restaurant choices; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites Vietnam Travel Hanoi and MICHELIN Hanoi guide; Menu Catalog has `food-pho-bo`, `food-pho-tai`, and `food-pho-chin`; dish-level facts are stable, but restaurant examples still need current checks.
* Score: 28/30 — strong dish briefing and menu-catalog fit; capped for planned place-name audio and phrase QA.
* QA notes: Reader View has 3 ready-audio reusable phrase cards, no text-only dish order line rendered, no duplicate body, and catalog mentions evaluated; screenshot and production gates remain pending.

## Phở Bò Lâm / Pho Bo Lam — Hanoi — Restaurant

### Reader View

**Beef Cuts, Simple Table**

Phở Bò Lâm should stay centered on the bowl: beef broth, rice noodles, herbs, and the deeper chew of tendon if that is the cut you want. The room does not need to perform; the table just needs to hold the steam.

**Useful phrase cards**

* **Làm ơn cho tôi một tô phở** — I’d like a bowl of phở, please.
* **Cho thêm rau** — More herbs, please.
* **Tính tiền giúp tôi** — Please let me pay.

**Choose Texture On Purpose**

Tendon changes the bowl. It is richer and chewier than a simple sliced-beef order, so choose it because you want that texture, not because the menu feels like a test.

**Do Not Overbuild The Bowl**

Start with broth and beef before adding too much lime or chili. The bowl has enough going on without turning every spoonful sharp.

**Keep The Meal Plain And Memorable**

This is a good stop when lunch should feel like part of the Hanoi day without becoming a long restaurant plan. Eat the bowl, notice the shop rhythm, and move on.

### Implementation notes

* IDs: page_id `city-hanoi-place-pho-bo-lam`; ledger_row `168`; hero `HeroCityHanoiPlacePhoBoLam`.
* Phrase/audio: `v500-food-drin-id-like-a-bowl-of-ph-please` / `v500-food-drin-id-like-a-bowl-of-ph-please` mapped; `food-4` / `food-4` mapped; `coffee-7` / `coffee-7` mapped.
* Name audio: `city-hanoi-place-pho-bo-lam` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `food-pho-bo` Phở bò render; tendon detail has no confirmed menu catalog item, do_not_render.
* Related place candidates: `hanoi-pho-bat-dan`, `hanoi-pho-gia-truyen`, `hanoi-pho-bo` for pho comparison; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites MICHELIN Vietnam 2025 and MICHELIN Hanoi guide, plus legacy tendon/herbs/simple table detail; verify current guide status, hours, menu, and closure status before import.
* Score: 27/30 — clear texture-based ordering cue; capped for current venue checks and planned place-name audio.
* QA notes: Reader View has 3 ready-audio phrase cards, no unsupported dish-specific phrase card, no duplicate body, and visible claims kept stable; screenshot and production gates remain pending.

## Phở gà ở Hà Nội / Chicken pho — Hanoi — Dish

### Reader View

**A Lighter Pho Bowl**

Chicken pho keeps the comfort of Hanoi pho — broth, rice noodles, herbs, lime — but the bowl reads cleaner and gentler than beef. It is a good reset when you want steam and noodles without the heavier pull of beef broth.

**Useful phrase cards**

* **Làm ơn cho tôi một tô phở** — I’d like a bowl of phở, please.
* **Cho thêm rau** — More herbs, please.
* **Không cay nhé** — Not spicy, please.

**Taste Before The Lime**

Chicken broth can be delicate. Add lime slowly, then herbs, then chili only if you actually want heat.

**When Beef Feels Too Much**

This is the easier pho lane after several rich meals. Shredded chicken, rice noodles, and a cleaner broth can make the bowl feel restorative without becoming plain.

**Keep The Order Small**

A simple bowl is enough. The pleasure is in the steam, the chicken, and the small adjustments at the table.

### Implementation notes

* IDs: page_id `city-hanoi-place-pho-ga`; ledger_row `169`; hero `HeroCityHanoiPlacePhoGa`.
* Phrase/audio: `v500-food-drin-id-like-a-bowl-of-ph-please` / `v500-food-drin-id-like-a-bowl-of-ph-please` mapped; `food-4` / `food-4` mapped; `food-3` / `food-3` mapped.
* Name audio: `city-hanoi-place-pho-ga` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `food-pho-ga` Phở gà render; `food-pho-bo` Phở bò render only if comparison card is desired.
* Related place candidates: `hanoi-pho-bo` for beef pho contrast; `hanoi-pho-bat-dan`, `hanoi-pho-bo-lam`, `hanoi-pho-gia-truyen` only if cross-pho browsing is wanted; needs catalog QA before rendering.
* Source/freshness notes: supplied row is place-name only; Menu Catalog has `food-pho-ga`; dish-level claims are stable, but no venue-specific claims should be added without fresh checks.
* Score: 26/30 — useful dish contrast and restrained copy; capped for sparse source notes and planned place-name audio.
* QA notes: Reader View has 3 ready-audio reusable phrase cards, no text-only chicken-pho order line rendered, no duplicate body, and no unsupported current venue facts; screenshot and production gates remain pending.

## Phở Gia Truyền / Pho Gia Truyen — Hanoi — Restaurant

### Reader View

**Steam First, Seat Second**

Phở Gia Truyền is best treated as a quick broth-counter meal: see the steam, know the bowl you want, then let the table stay simple. The appeal is not decoration. It is sliced beef, herbs, hot broth, and a room that moves at meal speed.

**Useful phrase cards**

* **Làm ơn cho tôi một tô phở** — I’d like a bowl of phở, please.
* **Cho thêm rau** — More herbs, please.
* **Tính tiền giúp tôi** — Please let me pay.

**Know The Bowl Before The Rush**

Decide on a straightforward pho order before the room pulls your attention. A clear order keeps the first minute calm.

**Counter Pace Is Part Of It**

This kind of pho stop does not need lingering. Watch the rhythm, take the bowl seriously, and do not expect the table to slow the day down for you.

**Compare Without Turning It Into Homework**

If you are trying more than one Hanoi pho shop, compare broth, beef texture, herbs, and how the room moves. One or two bowls teach more than a checklist of names.

### Implementation notes

* IDs: page_id `city-hanoi-place-pho-gia-truyen`; ledger_row `170`; hero `HeroCityHanoiPlacePhoGiaTruyen`.
* Phrase/audio: `v500-food-drin-id-like-a-bowl-of-ph-please` / `v500-food-drin-id-like-a-bowl-of-ph-please` mapped; `food-4` / `food-4` mapped; `coffee-7` / `coffee-7` mapped.
* Name audio: `city-hanoi-place-pho-gia-truyen` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `food-pho-bo` Phở bò render; `hanoi-old-quarter` render only if catalog QA confirms visible neighborhood placement is appropriate.
* Related place candidates: `hanoi-pho-bat-dan`, `hanoi-pho-bo-lam`, `hanoi-pho-bo` for pho comparison; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites MICHELIN Hanoi guide and legacy sliced-beef/herbs/steam detail; verify current guide status, hours, menu, and closure status before import.
* Score: 27/30 — strong counter-meal moment; capped for current venue checks and planned place-name audio.
* QA notes: Reader View has 3 ready-audio phrase cards, no unsupported place-name phrase card, no duplicate body, and no exaggerated restaurant claims; screenshot and production gates remain pending.

## Đền Quán Thánh / Quan Thanh Temple — Hanoi — Landmark

### Reader View

**Traffic Outside, Incense Inside**

At Đền Quán Thánh, the shift is immediate: traffic outside, shade and incense inside, stone and temple architecture asking for a slower step. Give yourself a minute at the gate before treating it like another photo stop.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Hôm nay có mở cửa không?** — Is it open today?

**Pause At The Gate**

The entrance is part of the visit. Step in slowly, let your eyes adjust, and notice how the courtyard changes the sound of the street.

**Keep The Camera Secondary**

This is an active worship space, not just old architecture. Ask before taking photos close to altars or people praying, and put the phone away when the room asks for quiet.

**Pair It With The Lake Edge**

Quan Thanh sits well with a West Lake or Trúc Bạch walk. Keep the temple as a quiet pause, then let the water and nearby streets carry the rest of the route.

### Implementation notes

* IDs: page_id `city-hanoi-place-quan-thanh-temple`; ledger_row `171`; hero `HeroCityHanoiPlaceQuanThanhTemple`.
* Phrase/audio: `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` mapped; `sight-3` / `sight-3` mapped; `v500-time-date-book-is-it-open-today` / `v500-time-date-book-is-it-open-today` mapped.
* Name audio: `city-hanoi-place-quan-thanh-temple` / `audio-authored-den-quan-thanh-fbed2afa89` ready; render as pronunciation/name support only.
* Mentioned Here candidates: `hanoi-west-lake` West Lake render; `hanoi-truc-bach-lake` Truc Bach Lake render.
* Related place candidates: `hanoi-tran-quoc-pagoda`, `hanoi-west-lake-loop`, `hanoi-ba-dinh-district` for nearby route planning; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites Hanoi tourism portal; verify current hours, worship/photo expectations, entrance access, and any restoration notices before import.
* Score: 28/30 — calm place-specific visit behavior; capped for current access/photo checks.
* QA notes: Reader View has 3 ready-audio phrase cards, no place-name phrase card, no duplicate body, and respectful worship framing; screenshot and production gates remain pending.

## Chợ hoa Quảng Bá / Quang Ba Flower Market — Hanoi — Market

### Reader View

**Flowers Before Breakfast**

Quảng Bá is a market before it is a photo stop: bundles of roses and chrysanthemums, wet pavement, scooters, and vendors moving fast while much of Hanoi is still quiet. Go with your eyes open and your hands out of the way.

**Useful phrase cards**

* **Cái này bao nhiêu?** — How much is this?
* **Trả ở đâu?** — Where do I pay?
* **Tôi đang tìm một món quà** — I’m looking for a gift.

**Watch The Work Before Buying**

Stand aside for a minute before stepping into a stall lane. The market has its own rhythm, and the flowers are moving for real customers, not only for cameras.

**Buy Small And Carry Smart**

If you buy flowers, think about the rest of your morning. A small bundle is easier than trying to carry a fragile armful through scooters, cafés, and hotel lobbies.

**Fold It Into A Lake Morning**

The market makes the most sense with a West Lake-side morning, coffee after, or a slow ride back into the city. It does not need a full itinerary around it.

### Implementation notes

* IDs: page_id `city-hanoi-place-quang-ba-flower-market`; ledger_row `172`; hero `HeroCityHanoiPlaceQuangBaFlowerMarket`.
* Phrase/audio: `price-1` / `price-1` mapped; `shop-5` / `shop-5` mapped; `v900-shop-im-looking-for-a-gift` / `v900-shop-im-looking-for-a-gift` mapped.
* Name audio: `city-hanoi-place-quang-ba-flower-market` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `hanoi-west-lake` West Lake render; roses/chrysanthemums have no confirmed catalog rows, do_not_render.
* Related place candidates: `hanoi-long-bien-market`, `hanoi-west-lake`, `hanoi-west-lake-loop` for early-market or lake pairing; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites Hanoi tourism portal and legacy pre-dawn flower-market scene; verify current operating rhythm, best arrival window, access, and holiday-season crowd changes before import.
* Score: 27/30 — strong market moment and ready phrase fit; capped for time-sensitive market conditions and planned place-name audio.
* QA notes: Reader View has 3 ready-audio phrase cards, no unsupported flower-specific phrase card, no duplicate body, and no fixed hours or pricing claims; screenshot and production gates remain pending.

## Sông Hồng / Red River — Hanoi — River

### Reader View

**The City Opens At The Waterline**

The Red River gives Hanoi a wider edge: Long Bien Bridge above, sandy banks below, boats, reflections, and evening light stretching the city out. It is not polished scenery. It is working water, and that is why it holds the view.

**Useful phrase cards**

* **Đi bộ có xa quá không?** — Is it too far to walk?
* **Tôi có đi qua cầu không?** — Do I go over the bridge?
* **Cho tôi tới đây** — Take me here.

**Look From Long Bien First**

Long Bien Bridge gives the river shape. From there, the banks, boats, and distance make more sense than they do from a random road edge.

**Treat The Banks As Working Space**

Do not read every open patch as a promenade. The river edge can be practical, uneven, and local. Stay aware of footing, traffic, and where people are actually moving.

**Go For Light, Not A Long Walk**

Evening light is the reason to linger. Keep the plan simple: one bridge view, one waterline pause, then a clear way back.

### Implementation notes

* IDs: page_id `city-hanoi-place-red-river`; ledger_row `173`; hero `HeroCityHanoiPlaceRedRiver`.
* Phrase/audio: `v500-dire-navi-is-it-too-far-to-walk` / `v500-dire-navi-is-it-too-far-to-walk` mapped; `v500-dire-navi-do-i-go-over-the-bridge` / `v500-dire-navi-do-i-go-over-the-bridge` mapped; `taxi-1` / `taxi-1` mapped.
* Name audio: `city-hanoi-place-red-river` planned; hide place-name audio until audio is available.
* Mentioned Here candidates: `hanoi-long-bien-bridge` Long Bien Bridge render; `hanoi-red-river` self item do_not_render as a card.
* Related place candidates: `hanoi-long-bien-bridge`, `hanoi-long-bien-market`, `hanoi-old-quarter` for route pairing; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites Hanoi tourism portal and legacy Long Bien/sandy banks/boats scene; verify current public access, bank conditions, safety, and bridge-area routing before import.
* Score: 27/30 — clear waterline behavior and restrained claims; capped for access and condition checks plus planned place-name audio.
* QA notes: Reader View has 3 ready-audio phrase cards, no place-name phrase card, no duplicate body, and no fixed route or safety guarantee; screenshot and production gates remain pending.

## Nhà thờ Lớn Hà Nội / St. Joseph's Cathedral — Hanoi — Landmark

### Reader View

**Old Lanes, Big Facade**

St. Joseph's Cathedral sits where old lanes, scooters, cafe umbrellas, and a tall facade all press into one square. Look from outside first; the building changes the pace of the block even before you step in.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Hôm nay có mở cửa không?** — Is it open today?

**Read The Square Before Entering**

The outside is part of the stop: stone facade, passing scooters, people waiting, and cafés around the edges. Take that in before treating the cathedral as a quick interior check.

**Keep Worship Clear Of The Camera**

If the doors are open, enter gently. Ask before taking photos, avoid blocking anyone praying, and let the quiet inside stay quiet.

**Coffee Can Wait Ten Minutes**

The surrounding streets make it easy to turn the visit into a cafe plan. Give the cathedral its own short pause first, then walk toward Hoàn Kiếm or the old lanes.

### Implementation notes

* IDs: page_id `city-hanoi-place-st-joseph-cathedral`; ledger_row `174`; hero `HeroCityHanoiPlaceStJosephCathedral`.
* Phrase/audio: `v500-sigh-acti-where-is-the-entrance` / `v500-sigh-acti-where-is-the-entrance` mapped; `sight-3` / `sight-3` mapped; `v500-time-date-book-is-it-open-today` / `v500-time-date-book-is-it-open-today` mapped.
* Name audio: `city-hanoi-place-st-joseph-cathedral` / `audio-authored-nha-tho-lon-ha-noi-b724787e93` ready; render as pronunciation/name support only.
* Mentioned Here candidates: `hanoi-hoan-kiem-lake` Hoan Kiem Lake render; `hanoi-old-quarter` Old Quarter render.
* Related place candidates: `hanoi-loading-t-cafe`, `hanoi-dinh-cafe`, `hanoi-hoan-kiem-lake` for nearby route planning; needs catalog QA before rendering.
* Source/freshness notes: supplied row cites Hanoi tourism portal and legacy facade/scooters/cafe-umbrella scene; verify current church access, service-time limits, photo expectations, and any restoration notices before import.
* Score: 28/30 — specific first-screen scene and respectful visit behavior; capped for current access/photo checks.
* QA notes: Reader View has 3 ready-audio phrase cards, no unsupported name phrase card, no duplicate body, and no fixed opening or service-time claim; screenshot and production gates remain pending.

## Codex handoff block

* `batch_id: batch_038`
* `page_ids: city-hanoi-place-loading-t-cafe, city-hanoi-place-pho-bat-dan, city-hanoi-place-pho-bo, city-hanoi-place-pho-bo-lam, city-hanoi-place-pho-ga, city-hanoi-place-pho-gia-truyen, city-hanoi-place-quan-thanh-temple, city-hanoi-place-quang-ba-flower-market, city-hanoi-place-red-river, city-hanoi-place-st-joseph-cathedral`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none for visible cards; all visible cards use ready audio; dish-specific menu quick-say lines remain hidden until audio`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: Pho restaurant differentiation is intentionally restrained; Loading T and Pho Bat Dan are thin-source; Quang Ba timing is framed without fixed hours`
* `source_freshness_risks: verify current venue hours, entrances, worship/photo access, market operating rhythm, riverbank access, and restaurant menu/payment flow before Jojo voice approval and Codex import`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`





# BATCH_039


SpeakLocal v2.2 BATCH_039 - Hanoi - 2026-05-26

## Đi bộ ăn vặt Hà Nội / Hanoi street-food walk

### Reader View

**A Meal Across Short Stops**
A Hanoi street-food walk is less about chasing a list and more about letting the evening unfold in small plates: steam from a soup pot, herbs on a metal tray, low stools, a grill you smell before you see it. Keep the route loose and order lightly.

**Phrase cards**

* **Cái này bao nhiêu?** — How much is this?
* **Cho tôi một phần** — One portion, please.
* **Không cay nhé** — Not spicy, please.

**Small Orders Keep The Night Open**
One dish per stop is the cleanest rhythm. A bowl of phở bò, a plate of bánh cuốn, or a shared bún chả can be enough before the next corner asks for attention.

**Busy Tables Beat Loud Calls**
A row of people finishing bowls says more than a bright sign. Watch for fast turnover, fresh herbs, and cooks who are already in motion.

**Coffee Or Something Sweet Can Close The Loop**
Leave room at the end. Egg coffee, fruit, or a small dessert stop lets the walk slow down instead of ending with one more heavy order.

### Implementation notes

* `page_id: city-hanoi-place-street-food-walk`
* Phrase/audio: `price-1` / `price-1` ready; `food-1` / `food-1` ready; `food-3` / `food-3` ready.
* Place-name audio: `city-hanoi-place-street-food-walk` planned; hide until audio.
* Mentioned Here candidates: Bún chả `hanoi-bun-cha` / `food-bun-cha`; Bánh cuốn `hanoi-banh-cuon` / `food-banh-cuon`; Beef pho `hanoi-pho-bo` / `food-pho-bo`; Egg coffee `hanoi-egg-coffee` / `drink-ca-phe-trung`.
* Related place candidates: Old Quarter `hanoi-old-quarter`; Dong Xuan Market `hanoi-dong-xuan-market`; Hanoi Weekend Night Market `hanoi-weekend-night-market`.
* Source/freshness: Vietnam Travel Hanoi; MICHELIN Hanoi guide. Vendor mix, exact routes, prices, and opening patterns need late checks.
* Score: 27/30. QA: visible copy is specific and non-duplicative; phrase cards are ready-audio reusable; catalog/native and screenshot review still pending.

## Phố Tạ Hiện / Ta Hien Street

### Reader View

**One Lap Before A Stool**
Tạ Hiện is the Old Quarter at evening volume: low stools, warm signs, food smoke, small glasses of bia hơi, and groups deciding whether the night is one drink or several streets. Walk the block once before choosing a seat.

**Phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Cái này bao nhiêu?** — How much is this?
* **Không, cảm ơn** — No, thank you.

**Dusk Gives You More Choice**
Earlier evening is easier for a first read. You can see the lane, compare seats, and decide whether you want food, beer, music, or just the scene.

**Prices Before Bottles**
Menus and drink prices are worth checking before you sit. The street gets louder as the night goes on, so handle the simple money question while conversation is still easy.

**Leave Before It Turns Into Work**
The charm is the compression: old lanes, close tables, noise, and food smoke in one short stretch. When it stops feeling fun, step back toward the lake or another Old Quarter lane.

### Implementation notes

* `page_id: city-hanoi-place-ta-hien`
* Phrase/audio: `food-menu` / `food-menu` ready; `price-1` / `price-1` ready; `polite-4` / `polite-4` ready.
* Place-name audio: `city-hanoi-place-ta-hien` / `audio-authored-pho-ta-hien-fb695b0958` ready.
* Mentioned Here candidates: Bia hơi `hanoi-bia-hoi` / `drink-bia-hoi`; Old Quarter `hanoi-old-quarter`; Hoan Kiem Lake `hanoi-hoan-kiem-lake`.
* Related place candidates: Hanoi Weekend Night Market `hanoi-weekend-night-market`; Old Quarter walking route `hanoi-old-quarter-walking-tour`.
* Source/freshness: Vietnam Travel Hanoi. Current crowd controls, individual bar status, prices, and street conditions need late checks.
* Score: 27/30. QA: no numbered heading, no quote-wrapped phrase cards, ready audio mapped; nightlife details kept non-specific.

## Tầm Vị / Tam Vi

### Reader View

**Dinner With A Northern Table Rhythm**
Tầm Vị is the kind of Hanoi meal that asks you to slow down: warm wood, shared dishes, rice on the table, and a room that feels more like dinner than a quick refuel. Go when the meal can carry part of the evening.

**Phrase cards**

* **Cho tôi bàn cho hai người nhé** — A table for two, please.
* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Tôi có đặt chỗ** — I have a booking.

**Share More Than You Solo**
The room makes more sense with a table order than a single-bowl mindset. Choose a few dishes, keep rice in the center, and let the meal move at a quieter pace.

**Ask Early, Then Relax**
Questions about pork, shellfish, spice, or table size are easiest before the first dish arrives. Once the order is settled, the appeal is the slower rhythm.

**One Meal Can Be The Evening**
Do not squeeze it between too many sights. The memory here is not one dramatic plate; it is the room, the table, and the feeling that dinner had enough time.

### Implementation notes

* `page_id: city-hanoi-place-tam-vi`
* Phrase/audio: `food-need-table` / `food-need-table` ready; `food-menu` / `food-menu` ready; `time-4` / `time-4` ready.
* Place-name audio: `city-hanoi-place-tam-vi` / `audio-authored-tam-vi-1336abffcd` ready.
* Mentioned Here candidates: none visible; no dish-specific menu claims added.
* Related place candidates: none for this draft; restaurant comparisons can be added after Jojo review if desired.
* Source/freshness: MICHELIN Vietnam 2025. Current guide status, hours, booking pattern, menu, and holiday closures need late checks.
* Score: 26/30. QA: strong restaurant moment, but kept restrained because dish/menu specifics need confirmation; ready-audio phrase cards mapped.

## Tây Hồ / Tay Ho

### Reader View

**Lake Air After The Old Quarter**
Tây Hồ gives Hanoi a wider frame: lake glimpses, scooters under trees, cafes, small shops, and quieter residential edges. Think of it as one coffee, one short walk, and a clear ride back.

**Phrase cards**

* **Cho tôi một cà phê sữa đá** — One iced milk coffee, please.
* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Bạn có thể giúp tôi quay lại khách sạn được không?** — Can you help me get back to my hotel?

**Choose One Edge**
West Lake is too large for vague wandering. Pick a cafe street, a lake-view corner, or a short walk first, then let the rest of the area stay optional.

**Cafes Before A Long Wander**
A seat with a drink can make the neighborhood click faster than trying to cover every lane. After that, shops and side streets feel easier to read.

**The Return Ride Matters**
Tây Hồ can feel close on a map and longer on foot in heat or traffic. Decide your exit before the lake walk turns into a tired loop.

### Implementation notes

* `page_id: city-hanoi-place-tay-ho`
* Phrase/audio: `coffee-1` / `coffee-1` ready; `directions-3` / `directions-3` ready; `v500-dire-navi-can-you-help-me-get-back-to-my-hotel` ready.
* Place-name audio: `city-hanoi-place-tay-ho` / `audio-authored-tay-ho-e1feb07783` ready.
* Mentioned Here candidates: West Lake `hanoi-west-lake`; Hoan Kiem Lake `hanoi-hoan-kiem-lake`; Hanoi coffee hop `hanoi-coffee-hop`.
* Related place candidates: West Lake loop `hanoi-west-lake-loop`; Truc Bach Lake `hanoi-truc-bach-lake`; Trieu Viet Vuong Coffee Street `hanoi-trieu-viet-vuong-coffee-street`.
* Source/freshness: Hanoi tourism portal. Named cafes, shops, traffic patterns, and neighborhood business turnover need late checks.
* Score: 27/30. QA: clear neighborhood behavior, varied headings, and ready audio; business-specific claims avoided.

## Văn Miếu / Temple of Literature

### Reader View

**Courtyards Before The Stone Steles**
Văn Miếu rewards a slower pace. Pass through the gates, let the courtyards reset your eyes, then notice the stone steles, red wood, tiled roofs, and shaded pauses instead of treating it like one photo stop.

**Phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Nhà vệ sinh ở đâu?** — Where is the bathroom?

**Move Gate By Gate**
The visit has a natural sequence. Each courtyard changes the mood a little, so walking too quickly makes the place feel flatter than it is.

**Read Stone, Then Look Up**
The steles carry the memory, but the roofs, gates, trees, and red-painted wood carry the atmosphere. Give both kinds of detail a moment.

**Quiet Is Part Of The Visit**
Keep voices low, step aside for anyone praying or taking formal photos, and let the shade do some of the work. The place feels better when it is not rushed.

### Implementation notes

* `page_id: city-hanoi-place-temple-literature`
* Phrase/audio: `v500-sigh-acti-where-is-the-entrance` ready; `sight-3` / `sight-3` ready; `bath-1` / `bath-1` ready.
* Place-name audio: `city-hanoi-place-temple-literature` / `audio-authored-van-mieu-1cb0b15574` ready.
* Mentioned Here candidates: none beyond the page itself.
* Related place candidates: Vietnam Fine Arts Museum `hanoi-vietnam-fine-arts-museum`; Imperial Citadel of Thang Long `hanoi-imperial-citadel`; Ho Chi Minh Mausoleum `hanoi-ho-chi-minh-mausoleum`.
* Source/freshness: Vietnam Travel Hanoi; Hanoi tourism portal. Hours, ticketing, photo expectations, and event closures need late checks.
* Score: 28/30. QA: specific landmark rhythm, ready audio, no volatile claims in Reader View.

## The Note Coffee / The Note Coffee

### Reader View

**Order, Climb, Leave A Note**
The Note Coffee is touristy, but the ritual is simple enough to enjoy. Order a drink, climb to a seat, read a few handwritten messages, and leave one of your own before the Old Quarter pulls you back outside.

**Phrase cards**

* **Không đường nhé** — No sugar, please.
* **Tôi có lên lầu không?** — Do I go upstairs?
* **Tính tiền giúp tôi** — Please let me pay.

**The Crowd Is Part Of The Trade**
This is not the quiet Hanoi cafe fantasy. The notes, stairs, small tables, and people moving through the room are part of the memory.

**Read A Few, Not Every Wall**
Walls, ceilings, stairs, and tables can feel overloaded. Pick a few messages, write yours, and let the stop stay small.

**One Drink Near The Lake Is Enough**
Egg coffee or coconut coffee makes sense here, but the bigger point is the pause near Hoàn Kiếm. One drink and one note are plenty.

### Implementation notes

* `page_id: city-hanoi-place-the-note-coffee`
* Phrase/audio: `coffee-5` / `coffee-5` ready; `v500-dire-navi-do-i-go-upstairs` ready; `coffee-7` / `coffee-7` ready.
* Place-name audio: `city-hanoi-place-the-note-coffee` planned; hide until audio.
* Mentioned Here candidates: Egg coffee `hanoi-egg-coffee` / `drink-ca-phe-trung`; Coconut coffee `drink-ca-phe-cot-dua`; Hoan Kiem Lake `hanoi-hoan-kiem-lake`; Old Quarter `hanoi-old-quarter`.
* Related place candidates: Cafe Giang `hanoi-giang-cafe`; Dinh Cafe `hanoi-dinh-cafe`; Hanoi coffee hop `hanoi-coffee-hop`.
* Source/freshness: place-name only plus canonical v2.2 shape. Current address, branch status, hours, menu, stairs, and crowd pattern need late checks.
* Score: 27/30. QA: matches tourist-ritual pattern without scolding; egg-coffee order phrase kept out of visible cards until audio is mapped.

## Công viên Thống Nhất / Thong Nhat Park

### Reader View

**Breathing Room Around The Lake**
Công viên Thống Nhất gives Hanoi a simple open-air pause: paths, trees, lake edges, morning walkers, families, and shade after too many street crossings. It does not need to be grand to be useful.

**Phrase cards**

* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Nhà vệ sinh ở đâu?** — Where is the bathroom?
* **Cho tôi chai nước** — A bottle of water, please.

**Morning Shows The Park**
Earlier hours give the park its clearest rhythm: walkers, exercise groups, quiet benches, and the lake before the day gets heavy.

**A Short Lap Helps**
Choose a path and make one loop or partial loop. The park is better as a reset than as a checklist of features.

**Shade Is The Main Point**
On a hot day, the practical reward is simple: trees, a slower walking pace, and space to stop without buying another drink.

### Implementation notes

* `page_id: city-hanoi-place-thong-nhat-park`
* Phrase/audio: `directions-3` / `directions-3` ready; `bath-1` / `bath-1` ready; `store-1` / `store-1` ready.
* Place-name audio: `city-hanoi-place-thong-nhat-park` planned; hide until audio.
* Mentioned Here candidates: none visible by name.
* Related place candidates: Bay Mau Lake `hanoi-bay-mau-lake`; Lenin Park `hanoi-lenin-park`; Yen So Park `hanoi-yen-so-park`.
* Source/freshness: Hanoi tourism portal. Access points, facilities, maintenance, events, and park hours need late checks.
* Score: 27/30. QA: restrained park copy with concrete movement; no unsupported facility claims beyond general traveler needs.

## Phố đường tàu Hà Nội / Hanoi Train Street

### Reader View

**The View Stays On The Edge**
Hanoi Train Street is memorable because the space is so tight: rail line, walls, cafe edges, signs, and people moving carefully around a narrow corridor. The point is not proving how close you can stand to the tracks.

**Phrase cards**

* **Bây giờ nó có mở không?** — Is it open now?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Tôi nên tránh những gì?** — What should I avoid?

**Access Changes, Safety Does Not**
Rules and entry points can shift. Follow barriers, staff, and local instructions first; if the street is closed, do not turn the visit into an argument.

**Cafes Are The Frame**
When a permitted cafe seat is available, the better move is to stay back, keep bags off the rail area, and let the narrowness tell the story.

**Keep The Photo Brief**
A quick photo from a safe edge is enough. Crowding the track area makes the street worse for residents, cafe staff, and other travelers.

### Implementation notes

* `page_id: city-hanoi-place-train-street`
* Phrase/audio: `v500-dire-navi-is-it-open-now` ready; `sight-3` / `sight-3` ready; `v500-sigh-acti-what-should-i-avoid` ready.
* Place-name audio: `city-hanoi-place-train-street` / `audio-authored-pho-duong-tau-ha-noi-ee65be1d03` ready.
* Mentioned Here candidates: Old Quarter `hanoi-old-quarter`; Hanoi Railway Station `hanoi-hanoi-railway-station`.
* Related place candidates: Nguyen Huu Huan Street `hanoi-nguyen-huu-huan-street`; Old Quarter walking route `hanoi-old-quarter-walking-tour`.
* Source/freshness: Hanoi tourism portal. Access rules, cafe operations, enforcement, train timing, and safety guidance require same-week checks.
* Score: 26/30. QA: safety-forward without fear language; current access uncertainty keeps score lower.

## Chùa Trấn Quốc / Tran Quoc Pagoda

### Reader View

**A Lake-Edge Pagoda Pause**
Chùa Trấn Quốc sits where the lake changes the whole visit: red tower, water, trees, temple gates, and a quieter pocket beside the road. Come for a short, respectful pause rather than a long site plan.

**Phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Cảm ơn** — Thank you.

**Arrive Softly**
The shift from traffic to temple grounds is part of the experience. Slow down before the gate, then let the lake and courtyard set the pace.

**Photos Need Space**
The tower and water are easy to photograph, but this is also an active sacred place. Step aside, watch for prayer, and avoid making the camera the whole visit.

**Pair It With West Lake**
The pagoda makes the most sense as part of a West Lake or Trúc Bạch outing. Keep it short, then continue the lake edge while the light is still good.

### Implementation notes

* `page_id: city-hanoi-place-tran-quoc-pagoda`
* Phrase/audio: `v500-sigh-acti-where-is-the-entrance` ready; `sight-3` / `sight-3` ready; `polite-2` / `polite-2` ready.
* Place-name audio: `city-hanoi-place-tran-quoc-pagoda` / `audio-authored-chua-tran-quoc-cfe2d77d7b` ready.
* Mentioned Here candidates: West Lake `hanoi-west-lake`; Truc Bach Lake `hanoi-truc-bach-lake`.
* Related place candidates: Quan Thanh Temple `hanoi-quan-thanh-temple`; West Lake loop `hanoi-west-lake-loop`; Tay Ho `hanoi-tay-ho`.
* Source/freshness: Hanoi tourism portal. Hours, access, ceremony activity, photo expectations, and crowd patterns need late checks.
* Score: 28/30. QA: concise sacred-place behavior; no ticket/hour claims; ready phrase audio mapped.

## Tràng Tiền Plaza / Trang Tien Plaza

### Reader View

**Cool Air Between Street Moves**
Tràng Tiền Plaza is the polished indoor break Hanoi sometimes hands you at exactly the right moment: a known corner near the lake, scooters outside, cool air inside, and storefronts that ask less from you than another crowded sidewalk.

**Phrase cards**

* **Tôi chỉ xem thôi** — I’m just looking.
* **Trả ở đâu?** — Where do I pay?
* **Tôi quẹt thẻ được không?** — Can I pay by card?

**A Known Corner Helps**
The facade and central location make it an easy meetup point near Hoàn Kiếm, the French Quarter, and Tràng Tiền Street. That can matter more than buying anything.

**Browse Without Turning It Into A Mall Day**
Step inside, cool down, check a shop or two, and leave before the city-center energy disappears. Hanoi is still waiting outside.

**Heat And Rain Make The Case**
The plaza is most useful when weather or street movement has worn you down. Treat it as a reset before the next walk, meal, or lake stop.

### Implementation notes

* `page_id: city-hanoi-place-trang-tien-plaza`
* Phrase/audio: `shop-4` / `shop-4` ready; `shop-5` / `shop-5` ready; `store-6` / `store-6` ready.
* Place-name audio: `city-hanoi-place-trang-tien-plaza` planned; hide until audio.
* Mentioned Here candidates: Hoan Kiem Lake `hanoi-hoan-kiem-lake`; French Quarter `hanoi-french-quarter`; Trang Tien Street `hanoi-trang-tien-street`.
* Related place candidates: Hanoi Opera House `hanoi-opera-house`; Turtle Tower `hanoi-turtle-tower`; French Quarter walk `hanoi-french-quarter-walk`.
* Source/freshness: Hanoi tourism portal. Current tenants, hours, access, food counters, payment norms, and facade/entrance changes need late checks.
* Score: 26/30. QA: clear indoor-break behavior; retail specifics kept out until verified.

## Codex handoff block

* `batch_id: batch_039`
* `page_ids: city-hanoi-place-street-food-walk, city-hanoi-place-ta-hien, city-hanoi-place-tam-vi, city-hanoi-place-tay-ho, city-hanoi-place-temple-literature, city-hanoi-place-the-note-coffee, city-hanoi-place-thong-nhat-park, city-hanoi-place-train-street, city-hanoi-place-tran-quoc-pagoda, city-hanoi-place-trang-tien-plaza`
* `ready_to_import: no`
* `chat_output_is_canonical: yes`
* `google_doc_url: optional_or_missing`
* `phrase_cards_needing_catalog_check: none_visible; hidden_or_planned_only: egg coffee order for The Note Coffee if Jojo wants a drink-specific card, note-paper request if audio is created later`
* `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
* `visible_copy_risks: Train Street access can change; The Note Coffee details are source-thin; Tam Vi menu and guide status can change; Trang Tien Plaza tenants and food counters can change; Tay Ho business names intentionally omitted`
* `source_freshness_risks: same-week checks needed for Train Street access/safety, current restaurant/cafe hours and booking patterns, temple/pagoda access and photo expectations, park facilities/hours, and plaza tenant/payment details`
* `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`





# BATCH_040


SpeakLocal v2.2 BATCH_040 - Hanoi - 2026-05-26

## Phố Tràng Tiền / Trang Tien Street

### Reader View

**One Street For French Quarter Bearings**

Tràng Tiền is the kind of Hanoi street that makes the old center feel walkable: trees, shopfronts, book edges, scooters moving in waves, and crossings that ask for patience. Treat it as a short orientation line, not a shopping mission.

### Useful phrase cards

* **Cho hỏi, đi tới đó thế nào?** — Excuse me, how do I get there?
* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Tôi chỉ xem thôi** — I’m just looking.

### Sections

**Read It In One Pass**

The street is better after one slow walk. Notice the shade, the shop signs, the crossings, and where the pavement opens before deciding whether to stop.

**Crossings Set The Pace**

Do not rush the street just because it looks central. Scooters, curb edges, and parked bikes make the walk feel very Hanoi; pause, choose your gap, and keep the move simple.

**Pair It With The Lake Side**

Tràng Tiền makes sense before or after Hoàn Kiếm, the Opera House side, or a short French Quarter walk. It gives the area a spine instead of turning the old center into scattered pins.

### Implementation notes

* Page ID: `city-hanoi-place-trang-tien-street`
* Phrase/audio: `directions-how-to-get / directions-1` ready; `directions-how-long / directions-3` ready; `shopping-just-looking / shop-4` ready.
* Place-name audio: `Phố Tràng Tiền` planned; hide until ready audio.
* Mentioned Here candidates: Hoàn Kiếm Lake `hanoi-hoan-kiem-lake` render; Hanoi Opera House `hanoi-opera-house` render; French Quarter walk `hanoi-french-quarter-walk` render.
* Related place candidates: Trang Tien Plaza `hanoi-trang-tien-plaza` as nearby street context; French Quarter `hanoi-french-quarter` as area context.
* Freshness/source notes: Hanoi tourism portal plus legacy city-v1 source. Shopfronts and café edges may change; visible copy avoids exact business claims.
* Score: 26/30 draft. Strong street role and traveler movement; capped for thin evidence and place-name audio not ready.
* QA notes: Reader View avoids process terms; no numbered heading; phrase cards are ready reusable rows; no duplicate bodies; native render pending.

---

## Phố cà phê Triệu Việt Vương / Trieu Viet Vuong Coffee Street

### Reader View

**Coffee Street Before The Café Choice**

Triệu Việt Vương is easier when the street is the decision, not one must-find café. Walk past the signs, listen for the room you want, then choose a short coffee pause under the trees before the scooters pull your attention back.

### Useful phrase cards

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Cho tôi một cà phê sữa đá** — One iced milk coffee, please.
* **Tính tiền giúp tôi** — Please let me pay.

### Sections

**One Lap Changes The Order**

A first pass keeps you from sitting at the first open doorway. Look for shade, table height, fan noise, and whether the room feels like a quick cup or a longer pause.

**Small Order, Better Read**

A basic cà phê sữa đá is enough for the first stop. You can always add a second café later; the street is built for comparing moods, not proving loyalty to one address.

**Leave Before It Turns Into A Search**

Coffee streets can make choice feel endless. Pick a table, drink slowly, then move on while the pause still feels like part of the day rather than a research project.

### Implementation notes

* Page ID: `city-hanoi-place-trieu-viet-vuong-coffee-street`
* Phrase/audio: `food-menu / food-menu` ready; `food-coffee-milk / coffee-1` ready; `food-pay-now / coffee-7` ready.
* Place-name audio: `Phố cà phê Triệu Việt Vương` planned; hide until ready audio.
* Mentioned Here candidates: Iced milk coffee `hanoi-ca-phe-sua-da` render; Hanoi coffee hop `hanoi-coffee-hop` render.
* Related place candidates: Cộng Cà Phê `hanoi-cong-ca-phe-trieu-viet-vuong` render only if the app wants a named café card; Hanoi coffee hop `hanoi-coffee-hop` render.
* Freshness/source notes: Hanoi tourism portal plus legacy street source. Individual cafés and signs can change quickly; visible copy keeps the street behavior durable.
* Score: 27/30 draft. Clear traveler choice and ready phrases; capped for business turnover and place-name audio not ready.
* QA notes: No quote-wrapped phrase cards; no repeated heading scaffold; menu/catalog scan completed for coffee item; native render pending.

---

## Hồ Trúc Bạch / Truc Bach Lake

### Reader View

**Water First, Café After**

Trúc Bạch gives Hanoi a quieter shape: water close to the curb, lakeside tables, narrow crossings, and neighborhood views that feel slower than the traffic around it. Arrive for the edge first; sit only after you know which side feels calm.

### Useful phrase cards

* **Đi bộ mất bao lâu?** — How long does it take on foot?
* **Ở gần đây không?** — Is it near here?
* **Chỉ trên bản đồ giúp tôi được không?** — Can you show me on the map?

### Sections

**The Loop Can Stay Short**

You do not need to circle everything. A short lake-edge walk is enough to understand the mood: water, shade, scooters, small tables, and the city softening around the view.

**Cafés Belong To The Scene**

A lakeside café is not an escape from the place; it is part of how Trúc Bạch works. Choose the table after you see light, noise, and traffic from the edge.

**West Lake Makes The Pairing Bigger**

If the day is already on the north side, Trúc Bạch can sit beside West Lake, Trấn Quốc Pagoda, or a longer water walk. Keep the plan loose enough for weather and crossings.

### Implementation notes

* Page ID: `city-hanoi-place-truc-bach-lake`
* Phrase/audio: `directions-how-long / directions-3` ready; `directions-near / directions-2` ready; `repair-show-me / repair-5` ready.
* Place-name audio: `Hồ Trúc Bạch` ready, `audio-authored-ho-truc-bach-2d9fcbf59f`.
* Mentioned Here candidates: West Lake `hanoi-west-lake` render; Trấn Quốc Pagoda `hanoi-tran-quoc-pagoda` render.
* Related place candidates: West Lake loop `hanoi-west-lake-loop` render; Quan Thanh Temple `hanoi-quan-thanh-temple` render if nearby-route cards are wanted.
* Freshness/source notes: Hanoi tourism portal plus legacy lake source. Café names, seating, and exact walking conditions may change; visible copy stays non-volatile.
* Score: 28/30 draft. Strong physical traveler moment and ready place audio; capped for route/freshness checks.
* QA notes: Reader View keeps check/status language out; phrase cards are reusable; no duplicate bodies; native render pending.

---

## Tháp Rùa / Turtle Tower

### Reader View

**Find The Tower From The Lake Edge**

Turtle Tower is not a stop you enter. It is the small shape that holds Hoàn Kiếm together when the lake, trees, walkers, and old-center traffic are all moving around you. Stand back, let the water do the work, and keep it as an orientation point.

### Useful phrase cards

* **Cho hỏi, đi tới đó thế nào?** — Excuse me, how do I get there?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Đi bộ mất bao lâu?** — How long does it take on foot?

### Sections

**The View Is The Visit**

The tower sits apart on the water, so the useful move is choosing your angle. Look from different lake edges instead of treating it like a building with an entrance.

**Legend Without A Lecture**

You do not need the full story before the view works. The tower, the lake name, the reflections, and the old streets nearby already carry enough memory for a first look.

**A Short Loop Is Enough**

Pair the tower with a Hoàn Kiếm walk, Ngọc Sơn Temple, or the Old Quarter edge. It is a small moment, but it gives the center of Hanoi a clear mental picture.

### Implementation notes

* Page ID: `city-hanoi-place-turtle-tower`
* Phrase/audio: `directions-how-to-get / directions-1` ready; `sight-photos / sight-3` ready; `directions-how-long / directions-3` ready.
* Place-name audio: `Tháp Rùa` planned; hide until ready audio.
* Mentioned Here candidates: Hoàn Kiếm Lake `hanoi-hoan-kiem-lake` render; Ngọc Sơn Temple `hanoi-ngoc-son-temple` render; Old Quarter `hanoi-old-quarter` render.
* Related place candidates: Old Quarter walking route `hanoi-old-quarter-walking-tour` render; Hoàn Kiếm Lake `hanoi-hoan-kiem-lake` render.
* Freshness/source notes: Vietnam Travel Hanoi and Hanoi tourism portal plus legacy lake/legend source. Visible copy avoids hours, access rules, or event timing.
* Score: 28/30 draft. Clear landmark decision and grounded lake behavior; capped for place-name audio not ready and render review pending.
* QA notes: No banned opener; no unsupported one-off phrase; Mentioned Here scan completed; native render pending.

---

## Ưu Đàm / Uu Dam

### Reader View

**A Calm Vegetarian Table**

Ưu Đàm should feel like a meal chosen on purpose, not a compromise between sights. Expect a calmer room, herbs, clay bowls, and a slower table rhythm than the steam-and-stool meals outside.

### Useful phrase cards

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Cho tôi bàn cho hai người nhé** — A table for two, please.
* **Tôi ăn chay** — I am vegetarian.

### Sections

**Choose Fewer Dishes First**

A vegetarian meal can still spread wide. Begin with a few plates, see portion size, then add more only if the table still feels balanced.

**Vegetarian Does Not Mean Light**

Tofu, mushrooms, herbs, sauces, rice, and warm bowls can make the meal feel full without meat. Ask about heat or ingredients before assuming every dish will be gentle.

**Make The Meal The Pause**

This is the kind of restaurant to place after a dense walking day. Let the room slow the evening instead of squeezing it between two bigger plans.

### Implementation notes

* Page ID: `city-hanoi-place-udam`
* Phrase/audio: `food-menu / food-menu` ready; `food-need-table / food-need-table` ready; `food-vegetarian / food-vegetarian` ready.
* Place-name audio: `Ưu Đàm` planned; hide until ready audio.
* Mentioned Here candidates: none for visible copy; menu items are intentionally not named without current menu confirmation.
* Related place candidates: none recommended for first render; optional later comparison with other MICHELIN Hanoi restaurants after catalog review.
* Freshness/source notes: MICHELIN Vietnam 2025 plus legacy restaurant source. Current menu, hours, booking pattern, and holiday closures need a late check.
* Score: 26/30 draft. Good meal rhythm and safe phrase set; capped for current venue facts and menu specificity limits.
* QA notes: Food/menu catalog checked; no unsupported dish claims; phrase cards are ready reusable rows; native render pending.

---

## Vietnam Art Gallery / Vietnam Art Gallery

### Reader View

**A Gallery Stop Between Street Hours**

Vietnam Art Gallery works as a quiet reset inside a Hanoi day: white walls, framed work, softer light, and enough room to look slowly before going back to traffic and café corners.

### Useful phrase cards

* **Tôi chụp hình ở đây được không?** — Can I take photos here?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Dịch giúp tôi cái này được không?** — Can you translate this for me?

### Sections

**Choose A Few Works, Not Every Wall**

A small gallery visit is better when you give yourself a limit. Pick a few pieces to really see, then leave before the stop turns into polite label-reading.

**Lacquer And Local Materials Matter**

Look for surfaces, texture, and how the work handles light. The gallery is a useful counterpoint to street Hanoi because the pace changes so quickly once you step inside.

**Keep The Stop Light**

This does not need to become a full museum block. Pair it with a café pause or a nearby walk, then return to the city with your eyes reset.

### Implementation notes

* Page ID: `city-hanoi-place-vietnam-art-gallery`
* Phrase/audio: `sight-photos / sight-3` ready; `v900-sigh-acti-is-there-an-english-guide / v900-sigh-acti-is-there-an-english-guide` ready; `repair-translate-this / repair-translate-this` ready.
* Place-name audio: venue name planned; hide until ready audio.
* Mentioned Here candidates: none; visible copy names no catalogable artwork or artist.
* Related place candidates: Vietnam Fine Arts Museum `hanoi-vietnam-fine-arts-museum` render; Manzi Art Space `hanoi-manzi-art-space` render if gallery comparison cards are enabled.
* Freshness/source notes: Vietnam Travel Hanoi plus legacy gallery source. Current exhibitions, photo policy, and opening status require a late check.
* Score: 26/30 draft. Calm and specific enough for a thin-evidence gallery; capped for exhibit/photo freshness and place-name audio not ready.
* QA notes: No schema terms in Reader View; no forced Mentioned Here cards; phrase cards ready; native render pending.

---

## Rạp Xiếc Trung ương / Vietnam Central Circus

### Reader View

**A Live Night, Not Another Building**

Vietnam Central Circus is an evening switch: theatre doors, stage light, families moving through the entrance, and Hanoi street activity outside. Go for the performance energy, not for another exterior to photograph.

### Useful phrase cards

* **Vé bao nhiêu?** — How much is the ticket?
* **Mấy giờ?** — What time?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

### Sections

**Arrive With A Buffer**

Circus nights are easier when the first move is not rushed. Give yourself time for the entrance, tickets, seats, and the small confusion that comes with any live venue.

**Street Energy At The Door**

The building exterior is part of the memory: lights, traffic, people arriving, and the shift from pavement noise to stage focus. That transition is the reason to make it an evening stop.

**Keep The Night Uncrowded**

Do not stack too many cultural stops around it. Dinner, the show, and a simple ride back will usually feel better than trying to force one more landmark afterward.

### Implementation notes

* Page ID: `city-hanoi-place-vietnam-circus`
* Phrase/audio: `sight-ticket / sight-1` ready; `time-what-time / time-1` ready; `sight-photos / sight-3` ready.
* Place-name audio: `Rạp Xiếc Trung ương` planned; hide until ready audio.
* Mentioned Here candidates: none in visible copy.
* Related place candidates: Vietnam National Tuong Theatre `hanoi-vietnam-national-tuong-theatre` render; Thang Long Water Puppet Theatre `hanoi-water-puppet-theatre` render; Hanoi Opera House `hanoi-opera-house` render.
* Freshness/source notes: Hanoi tourism portal plus legacy performance-venue source. Current show schedule, ticketing, seating, and photo rules need a late check.
* Score: 26/30 draft. Clear live-event traveler moment; capped for schedule freshness and place-name audio not ready.
* QA notes: Phrase cards are reusable and not venue-specific; no repeated station/route scaffold; native render pending.

---

## Bảo tàng Mỹ thuật Việt Nam / Vietnam Fine Arts Museum

### Reader View

**Three Rooms Beat Every Label**

Vietnam Fine Arts Museum rewards a shorter, more deliberate visit. The yellow building and shaded courtyard give you a pause first; the galleries make more sense when you choose a few rooms instead of trying to absorb every case.

### Useful phrase cards

* **Vé bao nhiêu?** — How much is the ticket?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

### Sections

**The Building Slows The Day**

Arrive with enough time to notice the courtyard, stairs, banners, and quieter light before the galleries. The first shift is from street speed to museum pace.

**Follow Materials Across Rooms**

Rather than reading every label, look for lacquer, silk, sculpture, folk forms, and how Vietnamese art changes across periods. A few repeated materials will teach faster than a full sweep.

**A Real Indoor Break**

This is not just shelter from heat or rain. It gives Hanoi a quieter cultural layer, especially when your day has been mostly lakes, streets, and food.

### Implementation notes

* Page ID: `city-hanoi-place-vietnam-fine-arts-museum`
* Phrase/audio: `sight-ticket / sight-1` ready; `v900-sigh-acti-is-there-an-english-guide / v900-sigh-acti-is-there-an-english-guide` ready; `sight-photos / sight-3` ready.
* Place-name audio: `Bảo tàng Mỹ thuật Việt Nam` planned; hide until ready audio.
* Mentioned Here candidates: none for visible copy; art materials are not mapped as place cards.
* Related place candidates: Vietnam Art Gallery `hanoi-vietnam-art-gallery` render; Vietnam Museum of Ethnology `hanoi-ethnology-museum` render if museum comparison cards are enabled.
* Freshness/source notes: Vietnam Travel Hanoi and Hanoi tourism portal plus legacy museum source. Ticketing, hours, temporary exhibitions, and photo policy need a late check.
* Score: 27/30 draft. Strong museum-fatigue prevention and observed details; capped for current-operations checks and place-name audio not ready.
* QA notes: No duplicate bodies; phrase cards sit immediately after intro; Mentioned Here scan completed; native render pending.

---

## Bảo tàng Lịch sử Quân sự Việt Nam / Vietnam Military History Museum

### Reader View

**Outside First, Gallery After**

Vietnam Military History Museum is easier when you let the outdoor scale settle before the display cases: metal, open space, military objects, and the quieter rooms that carry the harder context. Keep the visit focused; this is not a light filler stop.

### Useful phrase cards

* **Vé bao nhiêu?** — How much is the ticket?
* **Có hướng dẫn tiếng Anh không?** — Is there an English guide?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

### Sections

**Outdoor Scale Comes First**

Begin with the large objects outside if that route is open. Size, weather, and open air change how the history lands before you move into smaller displays.

**Inside Needs A Slower Pace**

The rooms can carry more weight than the exterior suggests. Choose one period or theme to follow instead of trying to turn the visit into a complete history lesson.

**Leave Space Afterward**

This museum can make the rest of the day feel heavier. Plan something simple next: a walk, a quiet drink, or a ride back without another demanding stop.

### Implementation notes

* Page ID: `city-hanoi-place-vietnam-military-history-museum`
* Phrase/audio: `sight-ticket / sight-1` ready; `v900-sigh-acti-is-there-an-english-guide / v900-sigh-acti-is-there-an-english-guide` ready; `sight-photos / sight-3` ready.
* Place-name audio: `Bảo tàng Lịch sử Quân sự Việt Nam` planned; hide until ready audio.
* Mentioned Here candidates: Hanoi Flag Tower `hanoi-hanoi-flag-tower` hold for freshness review before render.
* Related place candidates: Hoa Lo Prison Relic `hanoi-hoa-lo-prison` render; Imperial Citadel of Thang Long `hanoi-imperial-citadel` render.
* Freshness/source notes: Hanoi tourism portal plus legacy museum source. Strong freshness risk around current site routing, exhibits, and any old Flag Tower framing; visible copy avoids naming the tower.
* Score: 25/30 draft. Safer voice and visit shape, but capped for source freshness risk and place-name audio not ready.
* QA notes: Visible copy avoids stale location-specific claims; phrase cards ready; Mentioned Here held to review; native render pending.

---

## Nhà hát Tuồng Việt Nam / Vietnam National Tuong Theatre

### Reader View

**One Traditional Stage For The Night**

Vietnam National Tuong Theatre gives Hanoi a different evening register: masks, red curtain, stage light, and a performance form that may feel unfamiliar before it clicks. Go for the form and the room, not for a museum-style explanation.

### Useful phrase cards

* **Vé bao nhiêu?** — How much is the ticket?
* **Mấy giờ?** — What time?
* **Tôi chụp hình ở đây được không?** — Can I take photos here?

### Sections

**Stylized Is The Point**

Tuồng can feel formal, loud, and symbolic if you arrive expecting naturalistic theatre. Watch the masks, gestures, music, and movement before worrying about catching every plot detail.

**Arrive Before The First Cue**

A short buffer helps with tickets, seats, and the first look at the room. The evening will feel better if you are not entering halfway through the atmosphere.

**A Quieter Pairing Helps**

Keep the rest of the night simple: an early dinner, the show, then a calm ride back. The performance should have room to stay strange, vivid, and specific.

### Implementation notes

* Page ID: `city-hanoi-place-vietnam-national-tuong-theatre`
* Phrase/audio: `sight-ticket / sight-1` ready; `time-what-time / time-1` ready; `sight-photos / sight-3` ready.
* Place-name audio: `Nhà hát Tuồng Việt Nam` planned; hide until ready audio.
* Mentioned Here candidates: none in visible copy.
* Related place candidates: Vietnam Central Circus `hanoi-vietnam-circus` render; Thang Long Water Puppet Theatre `hanoi-water-puppet-theatre` render; Hanoi Opera House `hanoi-opera-house` render.
* Freshness/source notes: Hanoi tourism portal plus legacy performance-venue source. Current schedule, ticketing, language support, and photo rules need a late check.
* Score: 27/30 draft. Strong expectation-setting for a traditional performance; capped for schedule freshness and place-name audio not ready.
* QA notes: No quote-wrapped phrase cards; no repeated intro scaffolds; performance copy stays practical without flattening the form; native render pending.

## Codex handoff block

```markdown
- `batch_id: batch_040`
- `page_ids: city-hanoi-place-trang-tien-street, city-hanoi-place-trieu-viet-vuong-coffee-street, city-hanoi-place-truc-bach-lake, city-hanoi-place-turtle-tower, city-hanoi-place-udam, city-hanoi-place-vietnam-art-gallery, city-hanoi-place-vietnam-circus, city-hanoi-place-vietnam-fine-arts-museum, city-hanoi-place-vietnam-military-history-museum, city-hanoi-place-vietnam-national-tuong-theatre`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none; visible phrase cards use ready-audio reusable traveler-action rows from Phrase Picker`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: Vietnam Military History Museum intentionally avoids old-site specifics; Uu Dam avoids current menu specifics; gallery and performance pages avoid current exhibitions/schedules`
- `source_freshness_risks: current hours, ticketing, photo rules, performance schedules, gallery exhibitions, restaurant menu/booking pattern, and Vietnam Military History Museum site routing need late checks`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```





# BATCH_041


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





# BATCH_042


SpeakLocal v2.2 BATCH_042 - Saigon - 2026-05-26

## Tòa nhà Bitexco / Bitexco Financial Tower

### Reader View

**A High Read On The Center**

Bitexco is the skyline cue you keep catching between District 1 streets: the rounded tower above scooter noise, glass catching weather, the river not far away. Go when you want one high look at Saigon before returning to the street.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Mấy giờ mở cửa?** — What time does it open?
* **Cái này bao nhiêu?** — How much is this?

**Street Level First**

Look at the tower from the sidewalk before going up. The contrast is the point: heat, honking, shopfronts, and then that sudden piece of glass above the old city grid.

**Views Need Clear Weather**

A high view is only as good as the day. If the sky is hazy or wet, keep the stop flexible and let the tower work as a landmark you pass rather than a paid-view commitment.

**Pair It With A Short Walk**

Bitexco sits well with a river edge, Nguyễn Huệ, or a District 1 coffee pause. Do the view, then come back down quickly enough that the city still feels close.

### Implementation notes

* Page ID: `city-hcmc-place-bitexco-tower`
* Phrase/audio:

  * `Lối vào ở đâu?` — `phraseId/audioId: v500-sigh-acti-where-is-the-entrance`; ready audio; mapped
  * `Mấy giờ mở cửa?` — `phraseId/audioId: time-5`; ready audio; mapped
  * `Cái này bao nhiêu?` — `phraseId/audioId: price-1`; ready audio; mapped
* Place-name audio: `Tòa nhà Bitexco` ready as `city-hcmc-place-bitexco-tower` / `audio-authored-toa-nha-bitexco-ce74d5e48b`
* Mentioned Here candidates: District 1 `hcmc-district-1`; Nguyễn Huệ Walking Street `hcmc-nguyen-hue-walking-street`; Saigon River `hcmc-saigon-river`
* Related place candidates: Saigon Skydeck `hcmc-saigon-skydeck`; Ben Thanh Market `hcmc-ben-thanh-market`
* Freshness notes: verify tower access, viewing-deck operations, ticket price, hours, and weather-dependent visibility before import
* Draft score: 27/30 — strong first-screen use and concrete scene; capped for current tower operations and rendered proof still pending
* QA notes: phrase cards are ready-audio reusable; no duplicate body; no volatile hours/prices in Reader View; Jojo voice review still needed

## Bò lá lốt ở Thành phố Hồ Chí Minh / Beef in betel leaves

### Reader View

**The Roll That Starts At The Grill**

Bò lá lốt is most memorable before it reaches the table: smoke, betel leaves, little beef rolls, herbs piled beside rice paper. Order small, watch how others wrap, then build one bite with the greens instead of treating it like plain grilled meat.

**Useful phrase cards**

* **Cho tôi một phần** — One portion please.
* **Không cay nhé** — Not spicy please.
* **Tính tiền giúp tôi** — Please let me pay.

**Herbs Carry The Plate**

The leaves, herbs, and dip are not decoration. Put a little of everything into the bite so the beef, smoke, and sweet-sour sauce land together.

**Rice Paper May Vary**

Some shops serve it as a wrap; others keep the rolls simpler. If rice paper appears, go slowly on the first one and copy the table rhythm.

**Keep Sauce In Control**

The dip can be sweet, salty, sour, and spicy at once. Start with a small dip, then add more once the herbs and rice paper are in the bite.

### Implementation notes

* Page ID: `city-hcmc-place-bo-la-lot`
* Phrase/audio:

  * `Cho tôi một phần` — `phraseId/audioId: food-1`; ready audio; mapped
  * `Không cay nhé` — `phraseId/audioId: food-3`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Menu/catalog: `food-bo-la-lot` exists; quick-say line is text-only and should not render as a visible phrase card unless Codex maps audio later
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Bò lá lốt `food-bo-la-lot`; bánh xèo `food-banh-xeo` only if comparison copy is later added
* Related place candidates: none required for this draft
* Freshness notes: dish availability and exact serving style vary by shop; keep visible copy general
* Draft score: 28/30 — specific food behavior and good catalog fit; capped for dish-name audio and native phrase QA
* QA notes: reusable phrase cards only; no one-off dish order phrase in Reader View; no duplicate body; Jojo voice review still needed

## Bột chiên ở Thành phố Hồ Chí Minh / Fried rice-flour cakes

### Reader View

**A Sizzle Before The First Bite**

Bột chiên is the Saigon snack you understand by hearing it: rice-flour cubes hitting a flat griddle, egg setting around the edges, green onion scattered at the end. It is greasy in the right small-dose way, better as a shared plate than a whole meal plan.

**Useful phrase cards**

* **Cho tôi một phần** — One portion please.
* **Không cay nhé** — Not spicy please.
* **Tính tiền giúp tôi** — Please let me pay.

**Watch The Griddle**

If you can see the pan, pause before ordering. The best cue is a plate coming off hot, with crisp edges and egg still soft enough to pull the pieces together.

**Share The First Plate**

This is a good first-order snack, not a table-filling commitment. Split one plate, then decide whether you want another round or a different stall.

**Sauce Wakes It Up**

The sauce and chili change the whole plate. Add a little first, especially if the griddle already smells rich from oil and egg.

### Implementation notes

* Page ID: `city-hcmc-place-bot-chien`
* Phrase/audio:

  * `Cho tôi một phần` — `phraseId/audioId: food-1`; ready audio; mapped
  * `Không cay nhé` — `phraseId/audioId: food-3`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Menu/catalog: no exact `bột chiên` item found in Menu Catalog; add or map before rendering a food card
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Bột chiên needs catalog creation or mapping before card render
* Related place candidates: none required for this draft
* Freshness notes: avoid fixed stall claims; exact sauce, egg, and serving style vary
* Draft score: 27/30 — strong observed food moment; capped for missing menu item and dish-name audio
* QA notes: phrase cards are reusable and ready; no one-off dish phrase; no duplicate body; Jojo voice review still needed

## Phố Bùi Viện / Bui Vien Street

### Reader View

**Walk Once Before Sitting**

Bùi Viện is loud before it is fun: bar doors open, music competes, stools press into the street, and offers come quickly. Make one uncommitted pass first. Then choose a seat, a snack, or an exit with your phone and bag close.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Cái này bao nhiêu?** — How much is this?
* **Gọi taxi giúp tôi được không?** — Can you call a taxi for me?

**Noise From Every Door**

This is the backpacker-nightlife version of Saigon in one tight strip. It can be funny for a short look and exhausting if you expected a relaxed evening walk.

**Prices Before Drinks**

Check the menu before ordering, especially when a pitch comes quickly. A clear price keeps the night lighter than trying to sort it out after the table fills.

**Leave While You Still Like It**

You do not need to stay late for Bùi Viện to count. Early evening is enough for a first read; later, the street gets louder and less forgiving.

### Implementation notes

* Page ID: `city-hcmc-place-bui-vien-street`
* Phrase/audio:

  * `Cho tôi xem thực đơn được không?` — `phraseId/audioId: food-menu`; ready audio; mapped
  * `Cái này bao nhiêu?` — `phraseId/audioId: price-1`; ready audio; mapped
  * `Gọi taxi giúp tôi được không?` — `phraseId/audioId: hotel-9`; ready audio; mapped
* Place-name audio: `Phố Bùi Viện` ready as `city-hcmc-place-bui-vien-street` / `audio-authored-pho-bui-vien-120e855cda`
* Mentioned Here candidates: Bùi Viện Street `hcmc-bui-vien-street`; Phạm Ngũ Lão Street `hcmc-pham-ngu-lao-street`; District 1 `hcmc-district-1`
* Related place candidates: Nguyễn Huệ Walking Street `hcmc-nguyen-hue-walking-street`; Chợ Lớn `hcmc-cho-lon`
* Freshness notes: verify current pedestrian-night pattern, safety advisories, and street access before import
* Draft score: 29/30 — matches the nightlife safety pattern without fear tone; capped for current-street checks and rendered proof
* QA notes: phrase cards are reusable and ready; first-screen copy is concrete; no duplicate body; Jojo voice review still needed

## Bún thịt nướng ở Thành phố Hồ Chí Minh / Grilled pork vermicelli

### Reader View

**Cool Noodles, Hot Pork**

A bowl of bún thịt nướng looks tidy until you start mixing: grilled pork over cool rice vermicelli, herbs, pickles, peanuts, and fish-sauce dressing waiting to be folded through. The first bite should have smoke, crunch, and cold noodles at once.

**Useful phrase cards**

* **Cho tôi một phần** — One portion please.
* **Cái này có đậu phộng không?** — Does this have peanuts?
* **Tính tiền giúp tôi** — Please let me pay.

**Mix Before Judging**

The pork on top is only the start. Turn the bowl so the herbs, noodles, dressing, and grilled edges all meet.

**Pour The Dressing Gradually**

The fish-sauce dressing is meant to season the bowl, but it can take over if you empty it all at once. Add some, mix, taste, then decide.

**Ask About Peanuts Early**

Peanuts are common here and easy to miss under herbs or fried shallots. Ask before the bowl is finished if allergies or texture matter.

### Implementation notes

* Page ID: `city-hcmc-place-bun-thit-nuong`
* Phrase/audio:

  * `Cho tôi một phần` — `phraseId/audioId: food-1`; ready audio; mapped
  * `Cái này có đậu phộng không?` — `phraseId/audioId: food-premium-has-peanuts`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Menu/catalog: `food-bun-thit-nuong` exists; quick-say line is text-only and should not render as a visible phrase card unless Codex maps audio later
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Bún thịt nướng `food-bun-thit-nuong`; peanuts handled through phrase card, not as a food card
* Related place candidates: Bò lá lốt `city-hcmc-place-bo-la-lot` only if food-item related cards are supported
* Freshness notes: shop ingredients and peanut use can vary; keep allergy phrase visible only with mapped audio
* Draft score: 28/30 — strong bowl behavior and catalog fit; capped for dish-name audio and ingredient variability
* QA notes: reusable phrase cards only; no one-off dish order phrase; no duplicate body; Jojo voice review still needed

## Cà phê sữa đá Sài Gòn ở Thành phố Hồ Chí Minh / Saigon iced milk coffee

### Reader View

**A Cold Glass Between Plans**

Cà phê sữa đá is a Saigon pause you can carry between bigger moves: dark coffee, condensed milk, ice, and the slow clink of a glass on a sidewalk table. It is sweet and strong, so ask early if you want less ice or a cleaner coffee taste.

**Useful phrase cards**

* **Cho tôi một cà phê sữa đá** — One iced milk coffee please.
* **Ít đá thôi** — Just a little ice.
* **Tính tiền giúp tôi** — Please let me pay.

**Sweetness Comes Built In**

Condensed milk is part of the drink, not an add-on. If you want less sweetness, it may be easier to choose cà phê đen đá than to turn milk coffee into something it is not.

**Sidewalk Tables Count**

The setting can be as simple as a plastic stool and a street corner. Let that be enough; this is a short pause, not a laptop session.

**Know The Softer Order**

Bạc xỉu is the milkier, gentler cousin if full-strength robusta feels too sharp. It keeps the coffee mood without the same bitter edge.

### Implementation notes

* Page ID: `city-hcmc-place-ca-phe-sua-da`
* Phrase/audio:

  * `Cho tôi một cà phê sữa đá` — `phraseId/audioId: coffee-1`; ready audio; mapped
  * `Ít đá thôi` — `phraseId/audioId: coffee-4`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Menu/catalog: `drink-ca-phe-sua-da`, `drink-ca-phe-den-da`, and `drink-bac-xiu` exist
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Cà phê sữa đá `drink-ca-phe-sua-da`; Cà phê đen đá `drink-ca-phe-den-da`; Bạc xỉu `drink-bac-xiu`
* Related place candidates: Nguyễn Huệ Walking Street `hcmc-nguyen-hue-walking-street`; Cafe Apartment on Nguyen Hue `hcmc-cafe-apartment-nguyen-hue`
* Freshness notes: no venue-specific claims; keep as drink-culture page with menu mapping
* Draft score: 29/30 — tight drink ritual and strong catalog/audio fit; capped for page-name audio and rendered proof
* QA notes: phrase cards are ready and reusable; named drink items have catalog rows; no duplicate body; Jojo voice review still needed

## Chung cư cà phê Nguyễn Huệ / Cafe Apartment on Nguyen Hue

### Reader View

**Look Up Before Choosing A Floor**

The Cafe Apartment is not one cafe hiding behind one sign. From Nguyễn Huệ, the old facade reads like a vertical menu: balcony plants, lit windows, small shop signs, and people leaning over the rail. Pick the building first, then let the floor choose the mood.

**Useful phrase cards**

* **Lối vào ở đâu?** — Where is the entrance?
* **Tôi có lên lầu không?** — Do I go upstairs?
* **Tôi có thể ngồi đây được không?** — Can I sit here?

**The Facade Is The First Step**

Stand across the walking street for a moment before going in. The stacked signs and balconies make more sense from outside than from the stairwell.

**Balcony Seats Change The Stop**

A small drink becomes better when the room opens toward Nguyễn Huệ. If the best seats are full, keep the visit short and choose another floor rather than waiting too long.

**Many Rooms, Many Rhythms**

This is a building full of small rooms, not a single cafe with one service rhythm. The fun is partly choosing, climbing, and finding your own corner above the street.

### Implementation notes

* Page ID: `city-hcmc-place-cafe-apartment-nguyen-hue`
* Phrase/audio:

  * `Lối vào ở đâu?` — `phraseId/audioId: v500-sigh-acti-where-is-the-entrance`; ready audio; mapped
  * `Tôi có lên lầu không?` — `phraseId/audioId: v500-dire-navi-do-i-go-upstairs`; ready audio; mapped
  * `Tôi có thể ngồi đây được không?` — `phraseId/audioId: v900-poli-basi-can-i-sit-here`; ready audio; mapped
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Cafe Apartment on Nguyen Hue `hcmc-cafe-apartment-nguyen-hue`; 42 Nguyen Hue apartment building `hcmc-42-nguyen-hue-apartment`; Nguyễn Huệ Walking Street `hcmc-nguyen-hue-walking-street`
* Related place candidates: Nguyen Hue cafe hop `hcmc-cafe-hop-nguyen-hue`; Cà phê sữa đá `city-hcmc-place-ca-phe-sua-da`
* Freshness notes: verify tenant mix, entrance, elevator/stair access, any building fee, and current opening patterns before import
* Draft score: 28/30 — strong upstairs-arrival copy; capped for tenant turnover and page-name audio
* QA notes: phrase cards are ready and reusable; no one-off building phrase; no duplicate body; Jojo voice review still needed

## Đi cà phê Nguyễn Huệ / Nguyen Hue cafe hop

### Reader View

**Two Cafes Is Enough**

A Nguyễn Huệ cafe hop is better kept light: one upstairs drink, one street-level reset, then a walk before every stop turns into the same iced glass and balcony photo. The fun is in moving through the building and the walking street, not proving you tried every cafe.

**Useful phrase cards**

* **Cho tôi xem thực đơn được không?** — Can I see the menu?
* **Tôi có lên lầu không?** — Do I go upstairs?
* **Tính tiền giúp tôi** — Please let me pay.

**Pick One Upstairs Room**

Start with one room above the street, not a list of cafes. Choose the view, the quietest table, or the easiest order, then let that be the first stop.

**Street Air Between Drinks**

Come back down between stops. Nguyễn Huệ gives the hop its rhythm: open space, families walking, city lights, and enough room to decide whether you actually want another coffee.

**End Before Coffee Becomes Work**

A good cafe hop should leave you more awake, not more tired. If the second drink feels forced, switch to a walk or dessert and keep the evening moving.

### Implementation notes

* Page ID: `city-hcmc-place-cafe-hop-nguyen-hue`
* Phrase/audio:

  * `Cho tôi xem thực đơn được không?` — `phraseId/audioId: food-menu`; ready audio; mapped
  * `Tôi có lên lầu không?` — `phraseId/audioId: v500-dire-navi-do-i-go-upstairs`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Nguyễn Huệ Walking Street `hcmc-nguyen-hue-walking-street`; Cafe Apartment on Nguyen Hue `hcmc-cafe-apartment-nguyen-hue`; Cà phê sữa đá `drink-ca-phe-sua-da`
* Related place candidates: 42 Nguyen Hue apartment building `hcmc-42-nguyen-hue-apartment`; Saigon River `hcmc-saigon-river`
* Freshness notes: avoid naming individual cafes until tenant mix and openings are verified
* Draft score: 28/30 — distinct from the building page and keeps the route compact; capped for tenant turnover and page-name audio
* QA notes: phrase cards are ready and reusable; no duplicate body with Cafe Apartment page; Jojo voice review still needed

## Cà phê vợt Phạm Ngọc Thạch / Pham Ngoc Thach cloth-filter coffee

### Reader View

**Wait For The Pour**

Cloth-filter coffee asks you to slow down before the caffeine arrives. The point is the old rhythm: coffee strained through cloth, ice waiting, condensed milk or sugar if you want it, and a table that gives the day a few quieter minutes.

**Useful phrase cards**

* **Cho tôi một cà phê sữa đá** — One iced milk coffee please.
* **Ít đá thôi** — Just a little ice.
* **Tính tiền giúp tôi** — Please let me pay.

**Old Method, Short Pause**

Cà phê vợt is about the method as much as the cup. Watch the pour if you can, then let the drink sit for a moment before rushing back into traffic.

**Choose Sweet Or Dark**

If you want the classic cold comfort, milk coffee is the easy order. If you want the filter taste sharper, cà phê đen đá keeps the cup cleaner and less creamy.

**Keep The Stop Unhurried**

This is not a cafe to overload with plans. One drink, a few minutes, and a slower look at the street are enough.

### Implementation notes

* Page ID: `city-hcmc-place-cafe-vot-pham-ngoc-thach`
* Phrase/audio:

  * `Cho tôi một cà phê sữa đá` — `phraseId/audioId: coffee-1`; ready audio; mapped
  * `Ít đá thôi` — `phraseId/audioId: coffee-4`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Menu/catalog: `drink-ca-phe-sua-da` and `drink-ca-phe-den-da` exist
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Cà phê sữa đá `drink-ca-phe-sua-da`; Cà phê đen đá `drink-ca-phe-den-da`
* Related place candidates: Saigon iced milk coffee page `city-hcmc-place-ca-phe-sua-da`; Nguyen Hue cafe hop `city-hcmc-place-cafe-hop-nguyen-hue`
* Freshness notes: verify named cafe status, address, hours, menu options, and current service pattern before import
* Draft score: 27/30 — strong coffee ritual; capped for named-cafe freshness and page-name audio
* QA notes: phrase cards are ready and reusable; no current hours/prices in Reader View; no duplicate body; Jojo voice review still needed

## Chè Sài Gòn ở Thành phố Hồ Chí Minh / Sweet soup dessert

### Reader View

**A Small Dessert Stop After Dark**

Chè is the sweet counter you understand by looking first: cups of beans, jellies, fruit, coconut milk, crushed ice, and syrups stacked in color. Start with one cup and let the textures do the work.

**Useful phrase cards**

* **Cho tôi một phần** — One portion please.
* **Ít đá thôi** — Just a little ice.
* **Tính tiền giúp tôi** — Please let me pay.

**Point Before Ordering**

A chè counter can move fast because the choices are visual. Point to the cup or ingredient mix that looks right, then keep the first order simple.

**Coconut Milk Makes It Rich**

Chè ba màu gives you the easy color-and-texture version. Chè Thái leans fruitier and creamier. Chè bắp is softer, warmer in mood, and less showy.

**One Cup Is Plenty**

This is a break between bigger plans, not a dessert challenge. Stop while the ice, coconut milk, and jelly still feel refreshing.

### Implementation notes

* Page ID: `city-hcmc-place-che`
* Phrase/audio:

  * `Cho tôi một phần` — `phraseId/audioId: food-1`; ready audio; mapped
  * `Ít đá thôi` — `phraseId/audioId: coffee-4`; ready audio; mapped
  * `Tính tiền giúp tôi` — `phraseId/audioId: coffee-7`; ready audio; mapped
* Menu/catalog: `food-che-ba-mau`, `food-che-thai`, and `food-che-bap` exist; generic Saigon chè page phrase audio is planned
* Place-name audio: page phrase exists but audio is planned; hide until audio
* Mentioned Here candidates: Chè ba màu `food-che-ba-mau`; Chè Thái `food-che-thai`; Chè bắp `food-che-bap`
* Related place candidates: Cà phê sữa đá `city-hcmc-place-ca-phe-sua-da`; Nguyễn Huệ Walking Street `hcmc-nguyen-hue-walking-street`
* Freshness notes: exact chè variants and stall availability vary; keep visible copy variant-based, not venue-specific
* Draft score: 28/30 — strong dessert behavior and catalog mapping; capped for generic page-name audio and variant availability
* QA notes: phrase cards are ready and reusable; catalog mentions are natural; no duplicate body; Jojo voice review still needed

## Codex handoff block

```markdown
- `batch_id: batch_042`
- `page_ids: city-hcmc-place-bitexco-tower, city-hcmc-place-bo-la-lot, city-hcmc-place-bot-chien, city-hcmc-place-bui-vien-street, city-hcmc-place-bun-thit-nuong, city-hcmc-place-ca-phe-sua-da, city-hcmc-place-cafe-apartment-nguyen-hue, city-hcmc-place-cafe-hop-nguyen-hue, city-hcmc-place-cafe-vot-pham-ngoc-thach, city-hcmc-place-che`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: none for visible cards; all visible cards use ready-audio reusable phrases, with Codex to confirm exact mapping before import`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio; ready for Tòa nhà Bitexco and Phố Bùi Viện; planned/hide for dish, drink, cafe-apartment, cafe-hop, cloth-filter coffee, and chè page-name phrases`
- `visible_copy_risks: Bùi Viện tone should stay safety-aware without fear; Cafe Apartment and Nguyen Hue cafe hop must stay distinct; named-cafe copy for Phạm Ngọc Thạch stays intentionally restrained`
- `source_freshness_risks: verify Bitexco operations/tickets, Bùi Viện pedestrian-night pattern and advisories, Cafe Apartment tenant/access details, Phạm Ngọc Thạch cafe status, and dish/stall availability; no volatile hours or prices are in Reader View`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```


