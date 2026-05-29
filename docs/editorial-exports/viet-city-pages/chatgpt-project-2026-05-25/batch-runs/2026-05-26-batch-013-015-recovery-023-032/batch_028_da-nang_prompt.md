# SpeakLocal v2.2 BATCH_028 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_028` in the final handoff block. Put `SpeakLocal v2.2 BATCH_028 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need, even 10+ minutes. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Batch 013-022 audit tightening for this run:
- Start the final answer with the batch title and then the first listing. Do not add a `Source basis`, `Source grounding`, `Grounding note`, citation, or setup paragraph before the first listing.
- Do not include Markdown links, source chips, citation cards, pasted-text chips, clickable Google Doc/Sheet references, or `utm_source=chatgpt.com` links anywhere in final output, including implementation notes.
- Keep phrase cards to 2-3, and only use ready-audio reusable traveler-action phrases. Place-name audio is pronunciation/name support by default, not a visible phrase card.
- Do not create one-off phrases for a single attraction, restaurant, dish, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Vary headings. Do not default to `Let...`, `Start with...`, `Good when...`, `Still worth...`, or `works best`. If two headings in this batch share that scaffold, revise one before final.
- Write travel copy, not a database note. Short, observed, specific, calm.
- Keep implementation notes compact and import-facing: IDs, phrase/audio status, mention candidates, freshness risks, and handoff block only. Do not turn notes into a schema dump.
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
- Do not include Markdown links, citation/source chips, pasted-text chips, or clickable Google Doc/Sheet references anywhere in the final batch output, including implementation notes. Start with the batch title, not a "source grounding" paragraph.
- Keep implementation notes compact and import-facing. Use plain source labels only.
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

### 1. city-danang-place-son-tra-night-market
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chợ đêm Sơn Trà
- `english_name`: Son Tra Night Market
- `place_kind`: market
- `source_notes`: City library; Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceSonTraNightMarket
- `legacy_summary`: Sơn Trà Night Market is an easy snack-and-walk near Dragon Bridge and Love Bridge, better as a riverfront evening add-on than a serious food-market mission.
- `legacy_context`: Sơn Trà works when paired with the Hàn River, Dragon Bridge show, Love Bridge, or nearby evening lights.
- `legacy_sections_compact`: Snack Before The Bridge Show: Sơn Trà Night Market is useful because it sits near the Dragon Bridge side of the river. Treat it as an easy snack-and-walk, not a serious shopping mission. | Lights, Smoke, Small Decisions: Expect seafood grills, snacks, drinks, souvenirs, clothes, and visitors moving between stalls. The first lap is for reading prices and smoke. | Useful Phrases:  | Best When It Connects A Night: The market works around the lively middle of the evening, especially when Dragon Bridge, Love Bridge, or the river walk is already part of the plan. | Different Job Than Cồn: Cồn is the stronger food-first daytime market. Sơn Trà is the convenient night-market add-on near riverfront lights.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-son-tra-wildlife-drive
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chuyến đi Sơn Trà
- `english_name`: Son Tra wildlife drive
- `place_kind`: experience
- `source_notes`: Vietnam Tourism Da Nang; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceSonTraWildlifeDrive
- `legacy_summary`: Son Tra wildlife drive is worth knowing in Da Nang because it brings taking part in the place through movement, sound, scenery, and local texture into the trip. Expect winding forest road on Son Tra with distant sea.
- `legacy_context`: For Son Tra wildlife drive, Da Nang's experience story comes through bridges, markets, mountain roads, and seafood stops.
- `legacy_sections_compact`: Why go: Son Tra wildlife drive is worth knowing because it gives Da Nang a specific experience scene: mountain roads, seafood stops, central-Vietnam day trips, and beaches. | What you'll get: At Son Tra wildlife drive, you get taking part in the place through movement, sound, scenery, and local texture: winding forest road on Son Tra with distant sea, with bridges, markets, mountain roads, and seafood stops. | Say it locally: Say Chuyến đi Sơn Trà for Son Tra wildlife drive. The local name is easier to remember once it sits beside beaches, bridges, markets, and mountain roads. | Worth it if: Worth it if Son Tra wildlife drive gives your itinerary a clearer image: seafood stops, central-Vietnam day trips, beaches, and bridges. | Before you go: Son Tra wildlife drive works best when the name is tied to the reason for going, not memorized as an abstract label. Picture winding forest road on Son Tra with distant sea with beaches, bridges, markets, and mountain roads.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-thanh-binh-beach
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Biển Thanh Bình
- `english_name`: Thanh Binh Beach
- `place_kind`: beach
- `source_notes`: Local map.
- `target_hero_image`: HeroCityDanangPlaceThanhBinhBeach
- `legacy_summary`: Thanh Binh Beach is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect calm bay beach near city buildings with fishing boats, overcast morning.
- `legacy_context`: For Thanh Binh Beach, Da Nang's beach story comes through markets, mountain roads, seafood stops, and central-Vietnam day trips.
- `legacy_sections_compact`: Why go: Thanh Binh Beach is worth picturing because it changes the trip into coastal Vietnam: beaches, bridges, markets, and mountain roads. | What you'll get: At Thanh Binh Beach, you get coastal Vietnam changing the pace of the trip: calm bay beach near city buildings with fishing boats, overcast morning, with markets, mountain roads, seafood stops, and central-Vietnam day trips. | Say it locally: Say Biển Thanh Bình for Thanh Binh Beach. The local name is easier to remember once it sits beside central-Vietnam day trips, beaches, bridges, and markets. | Worth it if: Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Before you go: Thanh Binh Beach works best when the name is tied to the reason for going, not memorized as an abstract label. Picture calm bay beach near city buildings with fishing boats, overcast morning with mountain roads, seafood stops, central-Vietnam day trips, and beaches.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-the-temptation
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: The Temptation
- `english_name`: The Temptation
- `place_kind`: restaurant
- `source_notes`: MICHELIN search source; venue source.
- `target_hero_image`: HeroCityDanangPlaceTheTemptation
- `legacy_summary`: The Temptation is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect refined small restaurant exterior at dusk, street-side details.
- `legacy_context`: For The Temptation, Da Nang's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: The Temptation is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Da Nang's seafood-and-mountain day. | What you'll get: At The Temptation, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: refined small restaurant exterior at dusk, street-side details, with tables, house dishes, menu details, and staff rhythm, alongside Da Nang's seafood-and-mountain day. | Say it locally: The Temptation usually stays as the venue name. Say it slowly and connect it to the scene around it: evening meal energy, tables, house dishes, and menu details, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if the meal itself should be one of the day's memories: staff rhythm, drinks, evening meal energy, and tables, alongside Da Nang's seafood-and-mountain day. | Before you go: The Temptation works best when the name is tied to the reason for going, not memorized as an abstract label. Picture refined small restaurant exterior at dusk, street-side details with staff rhythm, drinks, evening meal energy, and tables, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-thuan-phuoc-bridge
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Cầu Thuận Phước
- `english_name`: Thuan Phuoc Bridge
- `place_kind`: landmark
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlaceThuanPhuocBridge
- `legacy_summary`: Thuan Phuoc Bridge is worth knowing in Da Nang because it brings architecture, views, local pride, and history in visual form into the trip. Expect broad suspension bridge at the river mouth, cloudy coastal light.
- `legacy_context`: For Thuan Phuoc Bridge, Da Nang's landmark story comes through landmark memory, architecture, views, and local pride, alongside Da Nang's seafood-and-mountain day.
- `legacy_sections_compact`: Why go: Thuan Phuoc Bridge is worth knowing because it gives Da Nang a specific landmark scene: landmark memory, architecture, views, and local pride, alongside Da Nang's seafood-and-mountain day. | What you'll get: At Thuan Phuoc Bridge, you get architecture, views, local pride, and history in visual form: broad suspension bridge at the river mouth, cloudy coastal light, with views, local pride, history, and city light, alongside Da Nang's seafood-and-mountain day. | Say it locally: Say Cầu Thuận Phước for Thuan Phuoc Bridge. The local name is easier to remember once it sits beside architecture, views, local pride, and history, alongside Da Nang's seafood-and-mountain day. | Worth it if: Worth it if Thuan Phuoc Bridge gives your itinerary a clearer image: city light, landmark memory, architecture, and views, alongside Da Nang's seafood-and-mountain day. | Before you go: Thuan Phuoc Bridge works best when the name is tied to the reason for going, not memorized as an abstract label. Picture broad suspension bridge at the river mouth, cloudy coastal light with city light, landmark memory, architecture, and views, alongside Da Nang's seafood-and-mountain day.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
