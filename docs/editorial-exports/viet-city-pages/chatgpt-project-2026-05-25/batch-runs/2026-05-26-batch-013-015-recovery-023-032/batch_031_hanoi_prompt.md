# SpeakLocal v2.2 BATCH_031 - Hanoi - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_031` in the final handoff block. Put `SpeakLocal v2.2 BATCH_031 - Hanoi - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hanoi-place-banh-cuon
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bánh cuốn ở Hà Nội
- `english_name`: Steamed rice rolls
- `place_kind`: dish
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceBanhCuon
- `legacy_summary`: Steamed rice rolls is worth trying in Hanoi because it gives the trip a flavor to imagine before arrival. Expect plate of bánh cuốn with herbs and dipping sauce, Hanoi breakfast shop.
- `legacy_context`: For Steamed rice rolls, Hanoi's food story comes through flavor, herbs, sauce, and steam, alongside old-quarter noodle tables.
- `legacy_sections_compact`: Why go: Steamed rice rolls is worth trying because it turns Hanoi into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with flavor, herbs, sauce, and steam, alongside old-quarter noodle tables. | What you'll get: At Steamed rice rolls, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: plate of bánh cuốn with herbs and dipping sauce, Hanoi breakfast shop, with sauce, steam, texture, and small meal rituals, alongside old-quarter noodle tables. | Say it locally: Say Bánh cuốn ở Hà Nội for Steamed rice rolls. The local name is easier to remember once it sits beside steam, texture, small meal rituals, and flavor, alongside old-quarter noodle tables. | Worth it if: Worth it if you want a food memory rather than only a label: herbs, sauce, steam, and texture, alongside old-quarter noodle tables. | Before you go: Steamed rice rolls works best when the name is tied to the reason for going, not memorized as an abstract label. Picture plate of bánh cuốn with herbs and dipping sauce, Hanoi breakfast shop with small meal rituals, flavor, herbs, and sauce, alongside old-quarter noodle tables.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hanoi-place-bay-mau-lake
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Hồ Bảy Mẫu
- `english_name`: Bay Mau Lake
- `place_kind`: nature
- `source_notes`: place-name only
- `target_hero_image`: HeroCityHanoiPlaceBayMauLake
- `legacy_summary`: Bay Mau Lake is worth knowing in Hanoi because it brings the city turning walkable around water instead of only traffic and streets into the trip. Expect calm lake inside Hanoi park with pedal boats and trees.
- `legacy_context`: For Bay Mau Lake, Hanoi's lake story comes through walking paths, cafe edges, shade, and bridges, alongside Hanoi's lake-and-temple side.
- `legacy_sections_compact`: Why go: Bay Mau Lake is worth knowing because it gives Hanoi a specific lake scene: walking paths, cafe edges, shade, and bridges, alongside Hanoi's lake-and-temple side. | What you'll get: At Bay Mau Lake, you get the city turning walkable around water instead of only traffic and streets: calm lake inside Hanoi park with pedal boats and trees, with shade, bridges, neighborhood views, and water, alongside Hanoi's lake-and-temple side. | Say it locally: Say Hồ Bảy Mẫu for Bay Mau Lake. The local name is easier to remember once it sits beside cafe edges, shade, bridges, and neighborhood views, alongside Hanoi's lake-and-temple side. | Worth it if: Worth it if Bay Mau Lake gives your itinerary a clearer image: water, walking paths, cafe edges, and shade, alongside Hanoi's lake-and-temple side. | Before you go: Bay Mau Lake works best when the name is tied to the reason for going, not memorized as an abstract label. Picture calm lake inside Hanoi park with pedal boats and trees with bridges, neighborhood views, water, and walking paths, alongside Hanoi's lake-and-temple side.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hanoi-place-bia-hoi
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bia hơi Hà Nội
- `english_name`: Fresh beer
- `place_kind`: drink
- `source_notes`: Vietnam Travel Hanoi
- `target_hero_image`: HeroCityHanoiPlaceBiaHoi
- `legacy_summary`: Bia hoi is Hanoi's fresh-beer sidewalk ritual: small stools, light beer, shared snacks, street corners, and the easy social pause between one walk and the next.
- `legacy_context`: For Fresh beer, Hanoi's drink story comes through shared snacks, Hanoi sidewalk rhythm, fresh beer glasses, and small stools, alongside old-lane Hanoi.
- `legacy_sections_compact`: Why go: This is Hanoi at stool height, where cold glasses, quick pours, neighborhood corners, and low tables make the city feel relaxed and social. | What you'll get: Bia hoi matters because it shows Hanoi's casual social side, where the drink is simple but the street-corner ritual is memorable. | Say it locally: Hear Bia hơi Hà Nội with the sidewalk scene in mind: small stools, cold glasses, shared snacks, and evening street life. | Worth it if: Worth it if a cold glass, coffee pause, or sidewalk drink would make the day feel more local: small stools, corner tables, evening street light, and shared snacks, alongside old-lane Hanoi. | Before you go: Fresh beer works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi bia hơi street corner with small stools and glasses, evening with evening street light, shared snacks, Hanoi sidewalk rhythm, and fresh beer glasses, alongside old-lane Hanoi.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hanoi-place-botanical-garden
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Vườn Bách Thảo Hà Nội
- `english_name`: Hanoi Botanical Garden
- `place_kind`: park
- `source_notes`: Hanoi tourism portal
- `target_hero_image`: HeroCityHanoiPlaceBotanicalGarden
- `legacy_summary`: Hanoi Botanical Garden is worth knowing in Hanoi because it brings everyday city life in open air without a formal attraction into the trip. Expect shaded botanical garden path in Hanoi with palms and benches.
- `legacy_context`: For Hanoi Botanical Garden, Hanoi's park story comes through family time, shade, open lawns, and evening light, alongside Hanoi's garden-side calm.
- `legacy_sections_compact`: Why go: Hanoi Botanical Garden is worth knowing because it gives Hanoi a specific park scene: open lawns, evening light, walking paths, and trees, alongside Hanoi's garden-side calm. | What you'll get: At Hanoi Botanical Garden, you get everyday city life in open air without a formal attraction: shaded botanical garden path in Hanoi with palms and benches, with walking paths, trees, family time, and shade, alongside Hanoi's garden-side calm. | Say it locally: Say Vườn Bách Thảo Hà Nội for Hanoi Botanical Garden. The local name is easier to remember once it sits beside evening light, walking paths, trees, and family time, alongside Hanoi's garden-side calm. | Worth it if: Worth it if Hanoi Botanical Garden gives your itinerary a clearer image: shade, open lawns, evening light, and walking paths, alongside Hanoi's garden-side calm. | Before you go: Hanoi Botanical Garden works best when the name is tied to the reason for going, not memorized as an abstract label. Picture shaded botanical garden path in Hanoi with palms and benches with shade, open lawns, evening light, and walking paths, alongside Hanoi's garden-side calm.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hanoi-place-bun-cha-huong-lien
- `city_id`: hanoi
- `city_name`: Hanoi
- `vietnamese_name`: Bún chả Hương Liên
- `english_name`: Bun Cha Huong Lien
- `place_kind`: restaurant
- `source_notes`: MICHELIN Hanoi guide
- `target_hero_image`: HeroCityHanoiPlaceBunChaHuongLien
- `legacy_summary`: Bun Cha Huong Lien is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Hanoi bun cha shop table with grilled pork, noodles, herbs.
- `legacy_context`: For Bun Cha Huong Lien, Hanoi's restaurant story comes through tables, house dishes, menu details, and staff rhythm, alongside Hanoi's steam-and-herb food streets.
- `legacy_sections_compact`: Why go: Bun Cha Huong Lien is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with drinks, evening meal energy, tables, and house dishes, alongside Hanoi's steam-and-herb food streets. | What you'll get: At Bun Cha Huong Lien, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Hanoi bun cha shop table with grilled pork, noodles, herbs, with tables, house dishes, menu details, and staff rhythm, alongside Hanoi's steam-and-herb food streets. | Say it locally: Say Bún chả Hương Liên for Bun Cha Huong Lien. The local name is easier to remember once it sits beside staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets. | Worth it if: Worth it if the meal itself should be one of the day's memories: house dishes, menu details, staff rhythm, and drinks, alongside Hanoi's steam-and-herb food streets. | Before you go: Bun Cha Huong Lien works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hanoi bun cha shop table with grilled pork, noodles, herbs with staff rhythm, drinks, evening meal energy, and tables, alongside Hanoi's steam-and-herb food streets.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
