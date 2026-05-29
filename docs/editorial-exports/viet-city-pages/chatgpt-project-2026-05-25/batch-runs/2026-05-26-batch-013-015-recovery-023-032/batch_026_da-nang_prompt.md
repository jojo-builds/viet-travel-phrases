# SpeakLocal v2.2 BATCH_026 - Da Nang - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_026` in the final handoff block. Put `SpeakLocal v2.2 BATCH_026 - Da Nang - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-danang-place-non-nuoc-stone-village
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Làng đá Non Nước
- `english_name`: Non Nuoc Stone Carving Village
- `place_kind`: village
- `source_notes`: City library; Da Nang Fantasticity.
- `target_hero_image`: HeroCityDanangPlaceNonNuocStoneVillage
- `legacy_summary`: Non Nuoc sits near the Marble Mountains, where Da Nang's stone-carving tradition becomes visible in Buddhas, lions, garden pieces, and polished marble shaped by local workshops.
- `legacy_context`: For Non Nuoc Stone Carving Village, Da Nang's village story comes through bridges, markets, mountain roads, and seafood stops.
- `legacy_sections_compact`: Why go: This is craft Da Nang at the foot of the mountains: stone dust, carved figures, polished marble, and workshops that turn a scenic stop into a living artisan district. | What you'll get: Non Nuoc matters because it gives the Marble Mountains area a craft story: mountain, worship, workshop, and local livelihood meet in one place. | Say it locally: Say Làng đá Non Nước for Non Nuoc Stone Carving Village. The local name is easier to remember once it sits beside beaches, bridges, markets, and mountain roads. | Worth it if: Worth it if Non Nuoc Stone Carving Village gives your itinerary a clearer image: seafood stops, central-Vietnam day trips, beaches, and bridges. | Before you go: Non Nuoc Stone Carving Village works best when the name is tied to the reason for going, not memorized as an abstract label. Picture stone-carving workshop lane with marble statues softly behind, artisan tools with seafood stops, central-Vietnam day trips, beaches, and bridges.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-danang-place-oc-hut
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Ốc hút ở Đà Nẵng
- `english_name`: Stirred snails
- `place_kind`: dish
- `source_notes`: Da Nang local food sources; spelling/use source.
- `target_hero_image`: HeroCityDanangPlaceOcHut
- `legacy_summary`: Stirred snails is worth trying in Da Nang because it gives the trip a flavor to imagine before arrival. Expect bowl of snails with lemongrass and chili, street-stall table, warm light.
- `legacy_context`: For Stirred snails, Da Nang's food story comes through herbs, sauce, steam, and texture, alongside bridge-and-beach Da Nang.
- `legacy_sections_compact`: Why go: Stirred snails is worth trying because it turns Da Nang into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with steam, texture, small meal rituals, and flavor, alongside bridge-and-beach Da Nang. | What you'll get: At Stirred snails, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: bowl of snails with lemongrass and chili, street-stall table, warm light, with small meal rituals, flavor, herbs, and sauce, alongside bridge-and-beach Da Nang. | Say it locally: Say Ốc hút ở Đà Nẵng for Stirred snails. The local name is easier to remember once it sits beside sauce, steam, texture, and small meal rituals, alongside bridge-and-beach Da Nang. | Worth it if: Worth it if you want a food memory rather than only a label: flavor, herbs, sauce, and steam, alongside bridge-and-beach Da Nang. | Before you go: Stirred snails works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bowl of snails with lemongrass and chili, street-stall table, warm light with flavor, herbs, sauce, and steam, alongside bridge-and-beach Da Nang.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-danang-place-pham-van-dong-beach
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Biển Phạm Văn Đồng
- `english_name`: Pham Van Dong Beach
- `place_kind`: beach
- `source_notes`: Vietnam Tourism Da Nang.
- `target_hero_image`: HeroCityDanangPlacePhamVanDongBeach
- `legacy_summary`: Pham Van Dong Beach is worth picturing because it changes the trip into coastal Vietnam: sea air, sand, seafood, and open light. Expect urban beach park with palms and sand, bright morning.
- `legacy_context`: For Pham Van Dong Beach, Da Nang's beach story comes through seafood stops, central-Vietnam day trips, beaches, and bridges.
- `legacy_sections_compact`: Why go: Pham Van Dong Beach is worth picturing because it changes the trip into coastal Vietnam: seafood stops, central-Vietnam day trips, beaches, and bridges. | What you'll get: At Pham Van Dong Beach, you get coastal Vietnam changing the pace of the trip: urban beach park with palms and sand, bright morning, with seafood stops, central-Vietnam day trips, beaches, and bridges. | Say it locally: Say Biển Phạm Văn Đồng for Pham Van Dong Beach. The local name is easier to remember once it sits beside mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Worth it if: Worth it if the Vietnam image in your head includes sea air, sand, seafood, and coastal mornings: mountain roads, seafood stops, central-Vietnam day trips, and beaches. | Before you go: Pham Van Dong Beach works best when the name is tied to the reason for going, not memorized as an abstract label. Picture urban beach park with palms and sand, bright morning with mountain roads, seafood stops, central-Vietnam day trips, and beaches.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-danang-place-phap-lam-pagoda
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Chùa Pháp Lâm
- `english_name`: Phap Lam Pagoda
- `place_kind`: landmark
- `source_notes`: Da Nang Fantasticity; local map.
- `target_hero_image`: HeroCityDanangPlacePhapLamPagoda
- `legacy_summary`: Phap Lam Pagoda is a calm Buddhist stop in central Da Nang, good for a slower hour between beaches, bridges, markets, and traffic.
- `legacy_context`: Phap Lam Pagoda gives central Da Nang a quieter register: yellow temple walls, shaded courtyards, incense, Buddhist imagery, and a visit that asks for a gentle pace.
- `legacy_sections_compact`: Why go: Phap Lam Pagoda is worth a stop when you want central Da Nang to slow down for a moment. It is a Buddhist pagoda with yellow walls, shaded courtyards, incense, and a quieter pace than the streets outside. | What you'll get: Expect a compact pagoda visit rather than a big sightseeing complex. The draw is the atmosphere: temple gates, tiled roofs, incense smoke, Buddhist imagery, and courtyard shade. | Say it locally: Say Chùa Pháp Lâm for Phap Lam Pagoda. Chùa means pagoda or temple, so hearing that first word helps you recognize other temple names around Vietnam. | Worth it if: Worth it if you like small cultural stops, quiet architecture, and places that make Da Nang feel less like only beaches and bridges. | Before you go: Before you go, keep the visit respectful and simple. Covered shoulders are a good idea, voices stay low, and photos should not make worshippers the subject.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-danang-place-phuoc-my
- `city_id`: danang
- `city_name`: Da Nang
- `vietnamese_name`: Phước Mỹ
- `english_name`: Phuoc My
- `place_kind`: neighborhood
- `source_notes`: Local map.
- `target_hero_image`: HeroCityDanangPlacePhuocMy
- `legacy_summary`: Phuoc My is worth recognizing because neighborhoods turn Da Nang from landmarks into lived-in areas. Expect residential beach ward street with palms and apartment balconies, neutral daylight.
- `legacy_context`: For Phuoc My, Da Nang's neighborhood story comes through hotel edges, evening walks, neighborhood identity, and cafes, alongside Han River light.
- `legacy_sections_compact`: Why go: Phuoc My is worth recognizing because neighborhoods give hotels, cafes, shops, and evening walks a real identity: lanes, small shops, hotel edges, and evening walks, alongside Han River light. | What you'll get: At Phuoc My, you get the area identity behind cafes, streets, hotels, shops, and evening rhythm: residential beach ward street with palms and apartment balconies, neutral daylight, with lanes, small shops, hotel edges, and evening walks, alongside Han River light. | Say it locally: Say Phước Mỹ for Phuoc My. The local name is easier to remember once it sits beside evening walks, neighborhood identity, cafes, and lanes, alongside Han River light. | Worth it if: Worth it if you want the city to feel like lived-in areas, not only landmarks: small shops, hotel edges, evening walks, and neighborhood identity, alongside Han River light. | Before you go: Phuoc My works best when the name is tied to the reason for going, not memorized as an abstract label. Picture residential beach ward street with palms and apartment balconies, neutral daylight with evening walks, neighborhood identity, cafes, and lanes, alongside Han River light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
