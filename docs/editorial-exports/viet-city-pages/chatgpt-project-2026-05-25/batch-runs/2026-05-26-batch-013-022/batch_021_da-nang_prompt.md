# SpeakLocal v2.2 BATCH_021 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_021` in the final handoff block. Put `SpeakLocal v2.2 BATCH_021 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-lotte-mart
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Lotte Mart Đà Nẵng
- `english_name`: Lotte Mart Da Nang
- `place_kind`: market
- `source_notes`: Local map.
- `target_hero_image`: HeroCityDanangPlaceLotteMart
- `legacy_summary`: Lotte Mart Da Nang is the easy indoor reset for hot, rainy, or low-supply days: water, sunscreen, toiletries, snacks, groceries, and predictable shelves.
- `legacy_context`: When the day is hot, rainy, or low on supplies, Lotte Mart gives you an easy indoor reset. Come here for water, sunscreen, toiletries, snacks, basic groceries, and predictable shelves instead of market bargaining.
- `legacy_sections_compact`: The Easy Indoor Reset: When the day is hot, rainy, or low on supplies, Lotte Mart gives you an easy indoor reset. Come here for water, sunscreen, toiletries, snacks, basic groceries, and predictable shelves instead of market bargaining. | Useful Phrases:  | Restock Before You Move On: Buy the ordinary things that make the next few hours easier: water, sunscreen, tissues, snacks, basic clothes, or small gifts. It is especially useful before the beach, a long ride, or a hotel reset. | Regroup Before The Taxi: If everyone is tired, regroup inside before calling the car. It is easier to choose a pickup point once everyone has water, bags, and a plan. | Hàn For Texture, Lotte For Ease: Go to Hàn Market for bargaining, souvenirs, fabric, food stalls, and local-market texture. Come here for posted prices, cool air, receipts, and lower decision pressure.
- `notes`: 2026-05-24 pilot was mechanically/native validated, but Jojo rejected the voice; rewrite before import.

### 2. city-danang-place-love-bridge
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cầu Tình Yêu
- `english_name`: Love Bridge
- `place_kind`: landmark
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceLoveBridge
- `legacy_summary`: Cầu Tình Yêu is a short Hàn River pause near Dragon Bridge, with heart lanterns, love locks, the Carp-Dragon statue nearby, and an easy evening photo frame.
- `legacy_context`: Love Bridge fits as one small link in a Hàn River evening route, not as a main Đà Nẵng attraction.
- `legacy_sections_compact`: Make It A Short River Pause: Cầu Tình Yêu is not a major stop by itself. It works as a short Hàn River pause with heart lanterns, lock-covered railings, and Dragon Bridge nearby. | Sentimental, But Simple: The bridge is openly romantic and photo-oriented. That can feel staged, but the lights and riverfront setting make it easy to enjoy briefly. | Useful Phrases:  | Lock Or Just Look: If you want a lock, check where to buy one and whether current rules allow it. Otherwise, walk the railing, take the angle, and keep moving. | Pair It, Do Not Center It: Pair Love Bridge with Dragon Bridge, Sơn Trà Night Market, APEC Park, or a Hàn River walk. It works best as a small evening link.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-madame-lan
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Madame Lân
- `english_name`: Madame Lan
- `place_kind`: restaurant
- `source_notes`: Da Nang tourism and venue sources.
- `target_hero_image`: HeroCityDanangPlaceMadameLan
- `legacy_summary`: Madame Lan is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Vietnamese restaurant courtyard with lanterns and family-style dishes.
- `legacy_context`: For Madame Lan, Da Nang's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside Han River light.
- `legacy_sections_compact`: Why go: Madame Lan is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with tables, house dishes, menu details, and staff rhythm, alongside Han River light. | What you'll get: At Madame Lan, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Vietnamese restaurant courtyard with lanterns and family-style dishes, with tables, house dishes, menu details, and staff rhythm, alongside Han River light. | Say it locally: Say Madame Lân for Madame Lan. The local name is easier to remember once it sits beside staff rhythm, drinks, evening meal energy, and tables, alongside Han River light. | Worth it if: Worth it if the meal itself should be one of the day's memories: house dishes, menu details, staff rhythm, and drinks, alongside Han River light. | Before you go: Madame Lan works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Vietnamese restaurant courtyard with lanterns and family-style dishes with evening meal energy, tables, house dishes, and menu details, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-man-thai-beach
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Biển Mân Thái
- `english_name`: Man Thai Beach
- `place_kind`: beach
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceManThaiBeach
- `legacy_summary`: Man Thai Beach is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect fishing boats on a quiet beach with Son Tra hills behind, early morning.
- `legacy_context`: For Man Thai Beach, Da Nang's beach story comes through seafood stops, central-Vietnam day trips, beaches, and bridges.
- `legacy_sections_compact`: Why go: Man Thai Beach is worth picturing because it changes the trip into coastal Vietnam: seafood stops, central-Vietnam day trips, beaches, and bridges. | What you'll get: At Man Thai Beach, you get coastal Vietnam changing the pace of the trip: fishing boats on a quiet beach with Son Tra hills behind, early morning, with markets, mountain roads, seafood stops, and central-Vietnam day trips. | Say it locally: Say Biển Mân Thái for Man Thai Beach. The local name is easier to remember once it sits beside bridges, markets, mountain roads, and seafood stops. | Worth it if: Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: central-Vietnam day trips, beaches, bridges, and markets. | Before you go: Man Thai Beach works best when the name is tied to the reason for going, not memorized as an abstract label. Picture fishing boats on a quiet beach with Son Tra hills behind, early morning with central-Vietnam day trips, beaches, bridges, and markets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-marble-mountain-cave-walk
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Hang động Ngũ Hành Sơn
- `english_name`: Marble Mountain cave walk
- `place_kind`: experience
- `source_notes`: Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlaceMarbleMountainCaveWalk
- `legacy_summary`: Marble Mountain cave walk is worth knowing in Da Nang because it brings movement across the city as part of the discovery into the trip. Expect limestone cave entry area with shrine light and stone steps, respectful.
- `legacy_context`: For Marble Mountain cave walk, Da Nang's route story comes through the route between named places, street corners, food stops, and cafe pauses, alongside central-Vietnam beach rhythm.
- `legacy_sections_compact`: Why go: Marble Mountain cave walk is worth knowing because it gives Da Nang a specific route scene: cafe pauses, local movement, the route between named places, and street corners, alongside central-Vietnam beach rhythm. | What you'll get: At Marble Mountain cave walk, you get movement across the city as part of the discovery: limestone cave entry area with shrine light and stone steps, respectful, with local movement, the route between named places, street corners, and food stops, alongside central-Vietnam beach rhythm. | Say it locally: Say Hang động Ngũ Hành Sơn for Marble Mountain cave walk. The local name is easier to remember once it sits beside street corners, food stops, cafe pauses, and local movement, alongside central-Vietnam beach rhythm. | Worth it if: Worth it if Marble Mountain cave walk gives your itinerary a clearer image: cafe pauses, local movement, the route between named places, and street corners, alongside central-Vietnam beach rhythm. | Before you go: Marble Mountain cave walk works best when the name is tied to the reason for going, not memorized as an abstract label. Picture limestone cave entry area with shrine light and stone steps, respectful with the route between named places, street corners, food stops, and cafe pauses, alongside central-Vietnam beach rhythm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

