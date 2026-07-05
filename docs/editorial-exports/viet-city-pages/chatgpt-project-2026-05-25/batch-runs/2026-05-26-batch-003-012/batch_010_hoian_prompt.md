# SpeakLocal v2.2 BATCH_010 - Hoi An B - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_010` in the final handoff block. Put `SpeakLocal v2.2 BATCH_010 - Hoi An B - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

Take the time you need. Draft Reader View first, self-score, revise the weakest visible lines once or twice, then give the final full batch in this chat. Do not require Google Drive write access. Do not create a Google Doc unless it is effortless; the chat output is the canonical handoff.

Extra anti-drift constraints for this 50-listing test:
- Keep phrase cards to 2-3, and only use ready-audio reusable phrases unless a place-name phrase already has ready audio.
- Do not create one-off phrases for a single attraction, restaurant, or object. Mark them as hidden/planned instead.
- Visible copy must not say `useful because`, `reference line`, `destination`, `anchor`, `content role`, `this page helps`, or `the job is`.
- Write travel copy, not a database note. Short, observed, specific, calm.
- If current venue facts might be stale, keep that risk in internal source/freshness notes instead of visible copy.

# New Chat Prompt for This Project

Use the five city listings in the `Exact batch rows` section below. They have already been claimed for this batch; do not select different rows from the ledger.

Before writing, read:
- the v2.2 Source Bundle,
- the Copy Ledger and Catalogs spreadsheet,
- the Canonical 31 examples inside the source bundle,
- the Phrase Picker Ready Audio tab,
- the Menu Catalog tab if any listing is food, drink, cafe, restaurant, dessert, market, or shop related.

For each listing, write one v2.2 app-detail draft. Use existing ready-audio phrase IDs when possible. Use existing menu/catalog items when natural. Do not invent facts. Do not write like a QA form.

Output in a readable review format first, not JSON. Start with a clean reader view that contains only app-visible copy. Put schema fields, self-score, QA, source notes, freshness notes, phrase/audio status, and Mentioned Here mapping after the reader view.

Self-score each draft against v2.2 voice and revise the weakest visible lines before final output. The score is an internal drafting aid only; the output remains draft/review material for later Jojo/Codex approval, import, and production validation.

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

### 1. city-hoian-place-bale-well
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Giếng Bà Lễ
- `english_name`: Bale Well
- `place_kind`: restaurant
- `source_notes`: Local food and venue references; local-name spelling kept conservative.
- `target_hero_image`: HeroCityHoianPlaceBaleWell
- `legacy_summary`: Bale Well is the hands-on Hội An meal where pork skewers, bánh xèo, spring rolls, herbs, rice paper, and sauce arrive as a shared set, so price and portion questions matter first.
- `legacy_context`: Bale Well works when the meal is lively, messy, and social, with staff often showing the first roll rather than leaving the table to decode everything alone.
- `legacy_sections_compact`: Confirm The Set First: Bale Well is built around a roll-it-yourself spread: pork skewers, bánh xèo, spring rolls, herbs, rice paper, and sauce. Ask the set price before the table fills. | Fast, Messy, Social: Food can arrive quickly, which is both charm and caution. Let the staff show the first roll, then expect herbs, sauce, and pork juices on your fingers. | Useful Phrases:  | Check Portion Size: The usual spread is better for sharing than nibbling. The stop is still worth it when you want a lively, filling meal and a little instruction. | Close To The Old Core: The restaurant is close enough to pair with an Ancient Town walk. It works better as a food detour than as a slow tasting menu.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hoian-place-banh-dap-hen-xao
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Bánh đập hến xào ở Hội An
- `english_name`: Cracked rice paper and clams
- `place_kind`: dish
- `source_notes`: Hoi An and Cam Nam food references.
- `target_hero_image`: HeroCityHoianPlaceBanhDapHenXao
- `legacy_summary`: Cracked rice paper and clams is worth trying in Hoi An because it gives the trip a flavor to imagine before arrival. Expect rice crackers with stir-fried clams and herbs on rustic table.
- `legacy_context`: For Cracked rice paper and clams, Hoi An's food story comes through steam, texture, small meal rituals, and flavor, alongside Thu Bon river light.
- `legacy_sections_compact`: Why go: Cracked rice paper and clams is worth trying because it turns Hoi An into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with small meal rituals, flavor, herbs, and sauce, alongside Thu Bon river light. | What you'll get: At Cracked rice paper and clams, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: rice crackers with stir-fried clams and herbs on rustic table, with steam, texture, small meal rituals, and flavor, alongside Thu Bon river light. | Say it locally: Say Bánh đập hến xào ở Hội An for Cracked rice paper and clams. The local name is easier to remember once it sits beside texture, small meal rituals, flavor, and herbs, alongside Thu Bon river light. | Worth it if: Worth it if you want a food memory rather than only a label: texture, small meal rituals, flavor, and herbs, alongside Thu Bon river light. | Before you go: Cracked rice paper and clams works best when the name is tied to the reason for going, not memorized as an abstract label. Picture rice crackers with stir-fried clams and herbs on rustic table with flavor, herbs, sauce, and steam, alongside Thu Bon river light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hoian-place-banh-mi
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Bánh mì Hội An
- `english_name`: Banh mi in Hoi An
- `place_kind`: dish
- `source_notes`: Vietnam food and Hoi An local references.
- `target_hero_image`: HeroCityHoianPlaceBanhMi
- `legacy_summary`: Banh mi in Hoi An is worth trying in Hoi An because it gives the trip a flavor to imagine before arrival. Expect Hoi An-style banh mi with fresh herbs on paper wrapper, street counter.
- `legacy_context`: For Banh mi in Hoi An, Hoi An's food story comes through steam, texture, small meal rituals, and flavor, alongside yellow-wall old town.
- `legacy_sections_compact`: Why go: Banh mi in Hoi An is worth trying because it turns Hoi An into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with steam, texture, small meal rituals, and flavor, alongside yellow-wall old town. | What you'll get: At Banh mi in Hoi An, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: Hoi An-style banh mi with fresh herbs on paper wrapper, street counter, with steam, texture, small meal rituals, and flavor, alongside yellow-wall old town. | Say it locally: Say Bánh mì Hội An for Banh mi in Hoi An. The local name is easier to remember once it sits beside texture, small meal rituals, flavor, and herbs, alongside yellow-wall old town. | Worth it if: Worth it if you want a food memory rather than only a label: sauce, steam, texture, and small meal rituals, alongside yellow-wall old town. | Before you go: Banh mi in Hoi An works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Hoi An-style banh mi with fresh herbs on paper wrapper, street counter with sauce, steam, texture, and small meal rituals, alongside yellow-wall old town.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hoian-place-banh-mi-phuong
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Bánh mì Phượng
- `english_name`: Banh Mi Phuong
- `place_kind`: restaurant
- `source_notes`: Existing city-library; Vietnam Tourism and local food references.
- `target_hero_image`: HeroCityHoianPlaceBanhMiPhuong
- `legacy_summary`: Bánh Mì Phượng is a fast Hội An sandwich-counter meal where the useful move is deciding filling, chili, sauce, and takeaway before the line reaches the glass case.
- `legacy_context`: Bánh Mì Phượng makes sense as a short counter-meal stop, with the fame kept smaller than the actual ordering task.
- `legacy_sections_compact`: Choose Before The Counter Moves: Bánh Mì Phượng moves fast, so decide the meal details: filling, chili, sauce, and takeaway before the line reaches the glass case. | Fast Bread, Many Hands: Expect crisp rolls, pâté, herbs, pickles, meat or chicken, sauce, and heat built in layers. The counter-meal rhythm rewards a clear order before the menu moment passes. | Useful Phrases:  | Earlier Keeps It Human: Before peak queue time, the sandwich matters more than the crowd. The fame can feel large, but the best version is still a quick, confident food stop. | A Quick Old Town Detour: Phan Châu Trinh is close enough to fold into an Ancient Town walk. Order, eat nearby, and move on rather than making the fame story the whole plan.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hoian-place-banh-xeo
- `city_id`: hoian
- `city_name`: Hoi An
- `vietnamese_name`: Bánh xèo Hội An
- `english_name`: Hoi An banh xeo
- `place_kind`: dish
- `source_notes`: Central Vietnam food references.
- `target_hero_image`: HeroCityHoianPlaceBanhXeo
- `legacy_summary`: Hoi An banh xeo is worth trying in Hoi An because it gives the trip a flavor to imagine before arrival. Expect small crispy pancakes with herbs and dipping sauce, warm street-food light.
- `legacy_context`: For Hoi An banh xeo, Hoi An's food story comes through herbs, sauce, steam, and texture, alongside Thu Bon river light.
- `legacy_sections_compact`: Why go: Hoi An banh xeo is worth trying because it turns Hoi An into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with herbs, sauce, steam, and texture, alongside Thu Bon river light. | What you'll get: At Hoi An banh xeo, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: small crispy pancakes with herbs and dipping sauce, warm street-food light, with small meal rituals, flavor, herbs, and sauce, alongside Thu Bon river light. | Say it locally: Say Bánh xèo Hội An for Hoi An banh xeo. The local name is easier to remember once it sits beside flavor, herbs, sauce, and steam, alongside Thu Bon river light. | Worth it if: Worth it if you want a food memory rather than only a label: texture, small meal rituals, flavor, and herbs, alongside Thu Bon river light. | Before you go: Hoi An banh xeo works best when the name is tied to the reason for going, not memorized as an abstract label. Picture small crispy pancakes with herbs and dipping sauce, warm street-food light with sauce, steam, texture, and small meal rituals, alongside Thu Bon river light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
