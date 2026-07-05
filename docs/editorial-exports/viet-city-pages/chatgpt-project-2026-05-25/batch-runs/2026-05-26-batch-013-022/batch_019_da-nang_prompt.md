# SpeakLocal v2.2 BATCH_019 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_019` in the final handoff block. Put `SpeakLocal v2.2 BATCH_019 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 003-012 audit tightening for this run:
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Vary headings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- Write travel copy, not a database note. Short, observed, specific, calm.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.
- If you cannot produce the full batch, output `BLOCKED_STUB` and the blocker instead of a partial response.

# New Chat Prompt for This Project

Pick 5 city listings from the ledger whose status is `not_started` or `voice_rejected_rewrite`. Use 10 only when Jojo asks or all listings are easy/low-research. If Codex provides an exact claimed batch list, use those rows only and do not pick replacements.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

Batch 003-012 audit tightening:
- Phrase cards are for reusable traveler actions, not place-name recognition. Even if a place-name audio row exists, keep it as pronunciation/name support unless the traveler would naturally say that exact name to staff or a driver in this moment and no reusable ready-audio phrase fits.
- Vary headings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in a batch share that scaffold, revise one before final.
- If a score is below 28/30, or if the first screen sounds like a planning database, revise the visible heading and first paragraph once before outputting the final answer.
- Keep public URLs and `utm_source=chatgpt.com` links out of the final batch unless explicitly requested. Source labels are enough for review.
- If the session cannot output the full batch, say `BLOCKED_STUB` and why instead of giving a partial response.

Do not rely on Google Drive write access. Output the full batch directly in this chat. A Google Doc is optional; Codex will create or update the readable review doc from the chat output.

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

### 1. city-danang-place-helio-night-market
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chợ đêm Helio
- `english_name`: Helio Night Market
- `place_kind`: market
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceHelioNightMarket
- `legacy_summary`: Helio Night Market is the organized outdoor food-court night in Đà Nẵng: food stalls, seating, music, lights, and less vendor pressure than tighter working markets.
- `legacy_context`: Helio works when the night needs food, music, and seating more than a traditional market or riverfront landmark add-on.
- `legacy_sections_compact`: Treat It Like A Food Court Night: Helio is easier if you stop expecting a working market. Treat it as an organized outdoor food court with stalls, seating, and music. | Clean, Curated, Less Chaotic: Compared with tighter markets, Helio gives more space, clearer zones, and less pressure from vendors. It may feel less local, but lower friction can help. | Useful Phrases:  | Order In Rounds: Start with one local dish or snack, then add a skewer, drink, or dessert after seeing portion size. Seafood pricing should be checked before agreeing. | Different Job Than Sơn Trà: Sơn Trà is the Dragon Bridge add-on. Helio is the more controlled food-and-seating night when options and music matter.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-hoa-phu-thanh
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Khu du lịch Hòa Phú Thành
- `english_name`: Hoa Phu Thanh
- `place_kind`: attraction
- `source_notes`: Da Nang Fantasticity; venue source.
- `target_hero_image`: HeroCityDanangPlaceHoaPhuThanh
- `legacy_summary`: Hoa Phu Thanh is worth knowing in Da Nang because it brings a named sight or experience that gives the trip a clear image into the trip. Expect forested stream recreation area with simple rafting gear.
- `legacy_context`: For Hoa Phu Thanh, Da Nang's attraction story comes through central-Vietnam day trips, beaches, bridges, and markets.
- `legacy_sections_compact`: Why go: Hoa Phu Thanh is worth knowing because it gives Da Nang a specific attraction scene: central-Vietnam day trips, beaches, bridges, and markets. | What you'll get: At Hoa Phu Thanh, you get a named sight or experience that gives the trip a clear image: forested stream recreation area with simple rafting gear, with mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Say it locally: Say Khu du lịch Hòa Phú Thành for Hoa Phu Thanh. The local name is easier to remember once it sits beside markets, mountain roads, seafood stops, and central-Vietnam day trips. | Worth it if: Worth it if Hoa Phu Thanh gives your itinerary a clearer image: markets, mountain roads, seafood stops, and central-Vietnam day trips. | Before you go: Hoa Phu Thanh works best when the name is tied to the reason for going, not memorized as an abstract label. Picture forested stream recreation area with simple rafting gear with seafood stops, central-Vietnam day trips, beaches, and bridges.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-hoa-trung-lake
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Hồ Hòa Trung
- `english_name`: Hoa Trung Lake
- `place_kind`: nature
- `source_notes`: Da Nang tourism source; local map.
- `target_hero_image`: HeroCityDanangPlaceHoaTrungLake
- `legacy_summary`: Hoa Trung Lake is worth knowing in Da Nang because it brings the city turning walkable around water instead of only traffic and streets into the trip. Expect broad lake with grassy banks and distant hills, soft sunrise.
- `legacy_context`: For Hoa Trung Lake, Da Nang's lake story comes through bridges, neighborhood views, water, and walking paths, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Hoa Trung Lake is worth knowing because it gives Da Nang a specific lake scene: cafe edges, shade, bridges, and neighborhood views, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Hoa Trung Lake, you get the city turning walkable around water instead of only traffic and streets: broad lake with grassy banks and distant hills, soft sunrise, with cafe edges, shade, bridges, and neighborhood views, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Hồ Hòa Trung for Hoa Trung Lake. The local name is easier to remember once it sits beside neighborhood views, water, walking paths, and cafe edges, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if Hoa Trung Lake gives your itinerary a clearer image: shade, bridges, neighborhood views, and water, alongside Da Nang's seafood-and-mountain day. | Before you go: Hoa Trung Lake works best when the name is tied to the reason for going, not memorized as an abstract label. Picture broad lake with grassy banks and distant hills, soft sunrise with neighborhood views, water, walking paths, and cafe edges, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-international-terminal
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Nhà ga quốc tế Đà Nẵng
- `english_name`: Da Nang International Terminal
- `place_kind`: airport
- `source_notes`: Airport and transport sources.
- `target_hero_image`: HeroCityDanangPlaceInternationalTerminal
- `legacy_summary`: Da Nang International Terminal turns the first hour in central Vietnam into a practical sequence: immigration, baggage, SIM, cash, pickup, then the ride into the city.
- `legacy_context`: Da Nang International Terminal is the first practical hour of central Vietnam: immigration, baggage, SIMs, cash, pickup doors, and the ride into the city. Keep the order simple and do not start solving pickup before you are through the public hall.
- `legacy_sections_compact`: The Arrival Sequence Matters: Da Nang International Terminal is the first practical hour of central Vietnam: immigration, baggage, SIMs, cash, pickup doors, and the ride into the city. Keep the order simple and do not start solving pickup before you are through the public hall. | Useful Phrases:  | Arrival Works In Order: Move through immigration, baggage, customs, then into the public hall. SIM counters, ATMs, hotel drivers, and ride-app exits make more sense once you are past the doors. | Pickup Gets Easier With One Pin: Before leaving the hall, open the pickup pin and check which door or column the driver means. Da Nang is close, but airport exits can split a group quickly. | Know Which Car Is Yours: If the next stop is Hội An, confirm the driver name, car plate, and hotel area while you still have light, space, and Wi-Fi. The ride is simple once the car is clearly yours.
- `notes`: 2026-05-24 pilot was mechanically/native validated, but Jojo rejected the voice; rewrite before import.

### 5. city-danang-place-kem-bo
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Kem bơ ở Đà Nẵng
- `english_name`: Avocado ice cream
- `place_kind`: dessert
- `source_notes`: Da Nang local food sources.
- `target_hero_image`: HeroCityDanangPlaceKemBo
- `legacy_summary`: Avocado ice cream is worth trying in Da Nang for sweetness, texture, color, and a small break between bigger plans. Expect Avocado ice cream cup with coconut flakes and spoon, bright cafe table.
- `legacy_context`: For Avocado ice cream, Da Nang's sweet story comes through fruit, color, evening snack counters, and dessert cups, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Avocado ice cream is worth trying for the sweet side of Da Nang: the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters, with jelly, shaved ice, fruit, and color, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Avocado ice cream, you get the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters: Avocado ice cream cup with coconut flakes and spoon, bright cafe table, with jelly, shaved ice, fruit, and color, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Kem bơ ở Đà Nẵng for Avocado ice cream. The local name is easier to remember once it sits beside color, evening snack counters, dessert cups, and coconut milk, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if you want the sweet, textural side of the city: color, evening snack counters, dessert cups, and coconut milk, alongside Da Nang's seafood-and-mountain day. | Before you go: Avocado ice cream works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Avocado ice cream cup with coconut flakes and spoon, bright cafe table with jelly, shaved ice, fruit, and color, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

