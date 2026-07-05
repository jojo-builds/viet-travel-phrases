You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_038` in the final handoff block. Put `SpeakLocal v2.2 BATCH_038 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need, even 10+ minutes. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 033-037 audit tightening for this 10-listing run:
- Start the final answer with the batch title and then the first listing. Do not add a `Source basis`, `Source grounding`, `Grounding note`, citation, or setup paragraph before the first listing.
- Do not include Markdown links, source chips, citation cards, pasted-text chips, clickable Google Doc/Sheet references, or `utm_source=chatgpt.com` links anywhere in final output, including implementation notes.
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, object, or transportation node. Mark them as hidden/planned instead.
- Do not number visible listing headings. Use the place heading directly, not `1. Place Name`.
- Do not wrap phrase-card Vietnamese in quotation marks unless the phrase itself truly contains a quote.
- Visible copy and implementation notes must not say `useful because`, `reference line`, `destination`, `anchor`, `canonical model`, `content role`, `this page helps`, or `the job is`.
- Keep `check_catalog`, `not_run`, scores, source notes, freshness risks, QA notes, and schema/process terms out of Reader View.
- Vary headings across all ten listings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- For station, airport, route, and street pages, choose the exact traveler moment first so the copy does not collapse into repeated command headings.
- Write travel copy, not a database note. Short, observed, specific, calm. The first paragraph should sound like a person at the place or table, not a catalog deciding where a page belongs.
- Keep implementation notes compact and import-facing: IDs, phrase/audio status, mention candidates, freshness risks, and handoff block only. Do not turn notes into a schema dump.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.
- Because this batch has 10 listings, avoid over-explaining. Each listing should be readable for Jojo review without screenshots.
- Before final output, do one display sweep for numbered headings, quote-wrapped phrase cards, process terms in Reader View, and repeated station/route scaffolds.
- If you cannot produce the full batch, output `BLOCKED_STUB` and the blocker instead of a partial response.

# New Chat Prompt for This Project

Pick city listings from the ledger whose status is `not_started` or `voice_rejected_rewrite`. Codex has provided an exact claimed batch list, so use those rows only and do not pick replacements.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

End with this Codex handoff block:

```markdown
## Codex handoff block

- `batch_id: ...`
- `page_ids: ...`
- `ready_to_import: no`
- `chat_output_is_canonical: yes`
- `google_doc_url: optional_or_missing`
- `phrase_cards_needing_catalog_check: ...`
- `place_name_phrases: render_only_if_ready_audio_else_hide_until_audio`
- `visible_copy_risks: ...`
- `source_freshness_risks: ...`
- `next_action_for_codex: create/readable review doc, map audio/catalog IDs, import only after Jojo voice approval`
```


## Exact batch rows

### 1. city-hanoi-place-loading-t-cafe
- `ledger_row`: 146
- `current_status`: voice_rejected_rewrite
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Loading T Cafe
- `english_name`: Loading T Cafe
- `place_kind`: cafe
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceLoadingTCafe
- `legacy_summary`: Loading T is an Old Quarter coffee pause with a Chân Cầm address, stairs to a second-floor room, patterned tiles, vintage corners, and cinnamon-leaning egg coffee.
- `legacy_context`: Loading T is an Old Quarter coffee pause with a real arrival moment: Chân Cầm address, stairs to a second-floor room, patterned tiles, vintage corners, and cinnamon-leaning egg coffee.
- `legacy_sections_compact`: Find The Upstairs Pause: Loading T is an Old Quarter coffee pause with a real arrival moment: Chân Cầm address, stairs to a second-floor room, patterned tiles, vintage corners, and cinnamon-leaning egg coffee. | Useful Phrases:  | The Drink Comes First: Choose the drink first, especially if egg coffee or a cinnamon note is the reason you came. The room is small, and the visit feels better once the order is out of the way. | The Room Is The Pause: The appeal is not a long work session. It is a short reset: old building details, tile, collected objects, and a window back into Old Quarter movement. | The Door Is Worth Checking: Cafe hours and address signals can drift across guide sites. If this is the coffee stop you care about, check it before crossing town.
- `notes`: 2026-05-24 pilot was mechanically/native validated, but Jojo rejected the voice; rewrite before import.

### 2. city-hanoi-place-pho-bat-dan
- `ledger_row`: 166
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phở Bát Đàn
- `english_name`: Pho Bat Dan
- `place_kind`: restaurant
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlacePhoBatDan
- `legacy_summary`: Pho Bat Dan is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect steaming bowl of Hanoi beef pho on simple metal table, Old Quarter shop backdrop.
- `legacy_context`: For Pho Bat Dan, Hanoi's restaurant story comes through drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Pho Bat Dan is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Pho Bat Dan, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: steaming bowl of Hanoi beef pho on simple metal table, Old Quarter shop backdrop, with tables, house dishes, menu details, and staff rhythm, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Phở Bát Đàn for Pho Bat Dan. The local name is easier to remember once it sits beside house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: evening meal energy, tables, house dishes, and menu details, alongside Hanoi's steam-and-herb food streets. | Before you go: Pho Bat Dan works best when the name is tied to the reason for going, not memorized as an abstract label. Picture steaming bowl of Hanoi beef pho on simple metal table, Old Quarter shop backdrop with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-pho-bo
- `ledger_row`: 167
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phở bò ở Hà Nội
- `english_name`: Beef pho
- `place_kind`: dish
- `source_notes`: Vietnam Travel Hanoi; MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlacePhoBo
- `legacy_summary`: Beef pho is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect steaming Hanoi beef pho with sliced beef, green onions, herbs.
- `legacy_context`: For Beef pho, Hanoi's food story comes through flavor, herbs, sauce, and steam, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Beef pho is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Beef pho, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: steaming Hanoi beef pho with sliced beef, green onions, herbs, with texture, small meal rituals, flavor, and herbs, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Phở bò ở Hà Nội for Beef pho. The local name is easier to remember once it sits beside small meal rituals, flavor, herbs, and sauce, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if you want a food memory rather than only a label: small meal rituals, flavor, herbs, and sauce, alongside Hanoi's steam-and-herb food streets. | Before you go: Beef pho works best when the name is tied to the reason for going, not memorized as an abstract label. Picture steaming Hanoi beef pho with sliced beef, green onions, herbs with steam, texture, small meal rituals, and flavor, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-pho-bo-lam
- `ledger_row`: 168
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phở Bò Lâm
- `english_name`: Pho Bo Lam
- `place_kind`: restaurant
- `source_notes`: MICHELIN Vietnam 2025; MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlacePhoBoLam
- `legacy_summary`: Pho Bo Lam is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect beef pho bowl with tendon and herbs, simple Hanoi shop table.
- `legacy_context`: For Pho Bo Lam, Hanoi's restaurant story comes through evening meal energy, tables, house dishes, and menu details, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Pho Bo Lam is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Pho Bo Lam, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: beef pho bowl with tendon and herbs, simple Hanoi shop table, with staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Phở Bò Lâm for Pho Bo Lam. The local name is easier to remember once it sits beside menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: tables, house dishes, menu details, and staff rhythm, alongside Hanoi's steam-and-herb food streets. | Before you go: Pho Bo Lam works best when the name is tied to the reason for going, not memorized as an abstract label. Picture beef pho bowl with tendon and herbs, simple Hanoi shop table with drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-pho-ga
- `ledger_row`: 169
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phở gà ở Hà Nội
- `english_name`: Chicken pho
- `place_kind`: dish
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlacePhoGa
- `legacy_summary`: Chicken pho is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect Chicken pho bowl with shredded chicken and lime, Hanoi shop table.
- `legacy_context`: For Chicken pho, Hanoi's food story comes through steam, texture, small meal rituals, and flavor, alongside the first roads into Hanoi.
- `legacy_sections_compact`: Why go: Chicken pho is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with small meal rituals, flavor, herbs, and sauce, alongside the first roads into Hanoi. | What you'll get: At Chicken pho, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: Chicken pho bowl with shredded chicken and lime, Hanoi shop table, with small meal rituals, flavor, herbs, and sauce, alongside the first roads into Hanoi. | Say it locally: Say Phở gà ở Hà Nội for Chicken pho. The local name is easier to remember once it sits beside sauce, steam, texture, and small meal rituals, alongside the first roads into Hanoi. | Worth it if: Worth it if you want a food memory rather than only a label: flavor, herbs, sauce, and steam, alongside the first roads into Hanoi. | Before you go: Chicken pho works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Chicken pho bowl with shredded chicken and lime, Hanoi shop table with texture, small meal rituals, flavor, and herbs, alongside the first roads into Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hanoi-place-pho-gia-truyen
- `ledger_row`: 170
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Phở Gia Truyền
- `english_name`: Pho Gia Truyen
- `place_kind`: restaurant
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlacePhoGiaTruyen
- `legacy_summary`: Pho Gia Truyen is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Hanoi pho counter with sliced beef and herbs, steam.
- `legacy_context`: For Pho Gia Truyen, Hanoi's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside Hanoi grill smoke and broth counters.
- `legacy_sections_compact`: Why go: Pho Gia Truyen is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Hanoi grill smoke and broth counters. | What you'll get: At Pho Gia Truyen, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Hanoi pho counter with sliced beef and herbs, steam, with menu details, staff rhythm, drinks, and evening meal energy, alongside Hanoi grill smoke and broth counters. | Say it locally: Say Phở Gia Truyền for Pho Gia Truyen. The local name is easier to remember once it sits beside evening meal energy, tables, house dishes, and menu details, alongside Hanoi grill smoke and broth counters. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi grill smoke and broth counters. | Before you go: Pho Gia Truyen works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi pho counter with sliced beef and herbs, steam with house dishes, menu details, staff rhythm, and drinks, alongside Hanoi grill smoke and broth counters.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hanoi-place-quan-thanh-temple
- `ledger_row`: 171
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Đền Quán Thánh
- `english_name`: Quan Thanh Temple
- `place_kind`: landmark
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceQuanThanhTemple
- `legacy_summary`: Quan Thanh Temple is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect stone gate of Quan Thanh Temple, incense smoke, green trees, Vietnam.
- `legacy_context`: For Quan Thanh Temple, Hanoi's sacred place story comes through shade, respectful pauses, incense, and courtyards, alongside Hoan Kiem and West Lake calm.
- `legacy_sections_compact`: Why go: Quan Thanh Temple is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: shade, respectful pauses, incense, and courtyards, alongside Hoan Kiem and West Lake calm. | What you'll get: At Quan Thanh Temple, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: stone gate of Quan Thanh Temple, incense smoke, green trees, Vietnam, with shade, respectful pauses, incense, and courtyards, alongside Hoan Kiem and West Lake calm. | Say it locally: Say Đền Quán Thánh for Quan Thanh Temple. The local name is easier to remember once it sits beside respectful pauses, incense, courtyards, and tiled roofs, alongside Hoan Kiem and West Lake calm. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: temple gates, shade, respectful pauses, and incense, alongside Hoan Kiem and West Lake calm. | Before you go: Quan Thanh Temple works best when the name is tied to the reason for going, not memorized as an abstract label. Picture stone gate of Quan Thanh Temple, incense smoke, green trees, Vietnam with courtyards, tiled roofs, temple gates, and shade, alongside Hoan Kiem and West Lake calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hanoi-place-quang-ba-flower-market
- `ledger_row`: 172
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Chợ hoa Quảng Bá
- `english_name`: Quang Ba Flower Market
- `place_kind`: market
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceQuangBaFlowerMarket
- `legacy_summary`: Quang Ba Flower Market is worth knowing in Hanoi because it brings the city showing itself through flowers, gifts, color, and everyday street trade into the trip. Expect Flower market piles of roses and chrysanthemums, pre-dawn Hanoi light.
- `legacy_context`: For Quang Ba Flower Market, Hanoi's flower market story comes through scooters, gift stalls, flower bundles, and street color, alongside Hanoi market-morning energy.
- `legacy_sections_compact`: Why go: Quang Ba Flower Market is worth knowing because it gives Hanoi a specific flower market scene: wet pavement, vendors, scooters, and gift stalls, alongside Hanoi market-morning energy. | What you'll get: At Quang Ba Flower Market, you get the city showing itself through flowers, gifts, color, and everyday street trade: Flower market piles of roses and chrysanthemums, pre-dawn Hanoi light, with flower bundles, street color, wet pavement, and vendors, alongside Hanoi market-morning energy. | Say it locally: Say Chợ hoa Quảng Bá for Quang Ba Flower Market. The local name is easier to remember once it sits beside vendors, scooters, gift stalls, and flower bundles, alongside Hanoi market-morning energy. | Worth it if: Worth it if Quang Ba Flower Market gives your itinerary a clearer image: street color, wet pavement, vendors, and scooters, alongside Hanoi market-morning energy. | Before you go: Quang Ba Flower Market works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Flower market piles of roses and chrysanthemums, pre-dawn Hanoi light with vendors, scooters, gift stalls, and flower bundles, alongside Hanoi market-morning energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hanoi-place-red-river
- `ledger_row`: 173
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Sông Hồng
- `english_name`: Red River
- `place_kind`: river
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceRedRiver
- `legacy_summary`: Red River is worth knowing because water helps organize Hanoi: bridges, reflections, banks, boats, and evening light. Expect Red River under Long Bien Bridge with sandy banks and boats.
- `legacy_context`: For Red River, Hanoi's river story comes through evening light, boats, bridges, and reflections, alongside Hanoi's food-and-cafe rhythm.
- `legacy_sections_compact`: Why go: Red River is worth knowing because the water helps organize the city: bridges, reflections, river walks, and waterline views, alongside Hanoi's food-and-cafe rhythm. | What you'll get: At Red River, you get geography, history, and everyday movement meeting: Red River under Long Bien Bridge with sandy banks and boats, with evening light, boats, bridges, and reflections, alongside Hanoi's food-and-cafe rhythm. | Say it locally: Say Sông Hồng for Red River. The local name is easier to remember once it sits beside waterline views, evening light, boats, and bridges, alongside Hanoi's food-and-cafe rhythm. | Worth it if: Worth it if Red River gives your itinerary a clearer image: reflections, river walks, waterline views, and evening light, alongside Hanoi's food-and-cafe rhythm. | Before you go: Red River works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Red River under Long Bien Bridge with sandy banks and boats with waterline views, evening light, boats, and bridges, alongside Hanoi's food-and-cafe rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hanoi-place-st-joseph-cathedral
- `ledger_row`: 174
- `current_status`: not_started
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Nhà thờ Lớn Hà Nội
- `english_name`: St. Joseph's Cathedral
- `place_kind`: landmark
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceStJosephCathedral
- `legacy_summary`: Saint Joseph's Cathedral is worth approaching slowly because worship, architecture, incense, and local memory shape the visit. Expect gothic cathedral facade with scooters and cafe umbrellas, overcast Hanoi light.
- `legacy_context`: For Saint Joseph's Cathedral, Hanoi's sacred place story comes through Hanoi worship, cathedral facades, quiet pews, and stained-glass light, alongside Hanoi old-lane texture.
- `legacy_sections_compact`: Why go: Saint Joseph's Cathedral is worth approaching slowly because worship, architecture, incense, and local memory all shape the visit: Hanoi worship, cathedral facades, quiet pews, and stained-glass light, alongside Hanoi old-lane texture. | What you'll get: At Saint Joseph's Cathedral, you get worship, architecture, local memory, and the quieter rhythm of a spiritual stop: gothic cathedral facade with scooters and cafe umbrellas, overcast Hanoi light, with courtyard shade, bells, Hanoi worship, and cathedral facades, alongside Hanoi old-lane texture. | Say it locally: Say Nhà thờ Lớn Hà Nội for Saint Joseph's Cathedral. The local name is easier to remember once it sits beside cathedral facades, quiet pews, stained-glass light, and courtyard shade, alongside Hanoi old-lane texture. | Worth it if: Worth it if temples, incense, worship, and quiet architecture help the place feel deeper: bells, Hanoi worship, cathedral facades, and quiet pews, alongside Hanoi old-lane texture. | Before you go: Saint Joseph's Cathedral works best when the name is tied to the reason for going, not memorized as an abstract label. Picture gothic cathedral facade with scooters and cafe umbrellas, overcast Hanoi light with stained-glass light, courtyard shade, bells, and Hanoi worship, alongside Hanoi old-lane texture.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
