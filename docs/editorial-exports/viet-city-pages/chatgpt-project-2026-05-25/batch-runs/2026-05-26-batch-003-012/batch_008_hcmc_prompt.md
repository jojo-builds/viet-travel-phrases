# SpeakLocal v2.2 BATCH_008 - Saigon B - 2026-05-26

You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the five listings below. Do not choose replacements.

Set `batch_id: batch_008` in the final handoff block. Put `SpeakLocal v2.2 BATCH_008 - Saigon B - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hcmc-place-bach-dang-wharf
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bến Bạch Đằng
- `english_name`: Bach Dang Wharf
- `place_kind`: landmark
- `source_notes`: existing-city-library; Visit HCMC portal
- `target_hero_image`: HeroCityHcmcPlaceBachDangWharf
- `legacy_summary`: Bach Dang Wharf is worth knowing in Saigon because it brings architecture, views, local pride, and history in visual form into the trip. Expect Saigon River waterfront at Bach Dang Wharf with skyline and boats.
- `legacy_context`: For Bach Dang Wharf, Saigon's landmark story comes through views, local pride, history, and city light, alongside Saigon street energy.
- `legacy_sections_compact`: Why go: Bach Dang Wharf is worth knowing because it gives Saigon a specific landmark scene: history, city light, landmark memory, and architecture, alongside Saigon street energy. | What you'll get: At Bach Dang Wharf, you get architecture, views, local pride, and history in visual form: Saigon River waterfront at Bach Dang Wharf with skyline and boats, with views, local pride, history, and city light, alongside Saigon street energy. | Say it locally: Say Bến Bạch Đằng for Bach Dang Wharf. The local name is easier to remember once it sits beside city light, landmark memory, architecture, and views, alongside Saigon street energy. | Worth it if: Worth it if Bach Dang Wharf gives your itinerary a clearer image: local pride, history, city light, and landmark memory, alongside Saigon street energy. | Before you go: Bach Dang Wharf works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Saigon River waterfront at Bach Dang Wharf with skyline and boats with city light, landmark memory, architecture, and views, alongside Saigon street energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hcmc-place-banh-mi
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bánh mì ở Thành phố Hồ Chí Minh
- `english_name`: Banh mi
- `place_kind`: dish
- `source_notes`: Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceBanhMi
- `legacy_summary`: Banh mi in Saigon is fast, layered, and built for the street: crisp bread, pate, herbs, pickles, chili, and a vendor rhythm that feels instantly local.
- `legacy_context`: Banh mi matters in Saigon because it is both everyday food and a first taste of the city: portable, cheap, fragrant, and easy to find.
- `legacy_sections_compact`: Why go: Banh mi is worth trying because it shows Saigon at street speed: a crisp baguette, pate, herbs, pickled vegetables, chili, and a vendor who can build lunch in minutes. | What you'll get: Expect crunch first, then richness from pate or meat, freshness from herbs and pickles, and heat if chili goes in. It is small enough for a snack and satisfying enough for a meal. | Say it locally: Say Bánh mì for banh mi. The name is already the menu word, so keep it short unless you are naming a specific shop. | Worth it if: Worth it if you want a low-effort first bite of Saigon: quick, filling, inexpensive, and easy to compare from one shop to another. | Before you go: Before you go, decide whether chili is welcome. Many of the best sandwiches move fast, so it helps to know the basic word before you reach the counter.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hcmc-place-banh-mi-huynh-hoa
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bánh mì Huỳnh Hoa
- `english_name`: Banh Mi Huynh Hoa
- `place_kind`: restaurant
- `source_notes`: local named-restaurant source
- `target_hero_image`: HeroCityHcmcPlaceBanhMiHuynhHoa
- `legacy_summary`: Banh Mi Huynh Hoa is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect Banh mi counter with crusty baguettes and fillings, Saigon street shop.
- `legacy_context`: For Banh Mi Huynh Hoa, Saigon's restaurant story comes through evening meal energy, tables, house dishes, and menu details, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Banh Mi Huynh Hoa is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside Ben Thanh market energy. | What you'll get: At Banh Mi Huynh Hoa, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: Banh mi counter with crusty baguettes and fillings, Saigon street shop, with evening meal energy, tables, house dishes, and menu details, alongside Ben Thanh market energy. | Say it locally: Say Bánh mì Huỳnh Hoa for Banh Mi Huynh Hoa. The local name is easier to remember once it sits beside drinks, evening meal energy, tables, and house dishes, alongside Ben Thanh market energy. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Ben Thanh market energy. | Before you go: Banh Mi Huynh Hoa works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Banh mi counter with crusty baguettes and fillings, Saigon street shop with drinks, evening meal energy, tables, and house dishes, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hcmc-place-banh-xeo
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bánh xèo ở Thành phố Hồ Chí Minh
- `english_name`: Southern sizzling pancake
- `place_kind`: dish
- `source_notes`: Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceBanhXeo
- `legacy_summary`: Southern sizzling pancake is worth trying in Saigon because it gives the trip a flavor to imagine before arrival. Expect crispy bánh xèo with shrimp, pork, herbs, dipping sauce.
- `legacy_context`: For Southern sizzling pancake, Saigon's food story comes through steam, texture, small meal rituals, and flavor, alongside Saigon river lights.
- `legacy_sections_compact`: Why go: Southern sizzling pancake is worth trying because it turns Saigon into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with small meal rituals, flavor, herbs, and sauce, alongside Saigon river lights. | What you'll get: At Southern sizzling pancake, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: crispy bánh xèo with shrimp, pork, herbs, dipping sauce, with herbs, sauce, steam, and texture, alongside Saigon river lights. | Say it locally: Say Bánh xèo ở Thành phố Hồ Chí Minh for Southern sizzling pancake. The local name is easier to remember once it sits beside flavor, herbs, sauce, and steam, alongside Saigon river lights. | Worth it if: Worth it if you want a food memory rather than only a label: texture, small meal rituals, flavor, and herbs, alongside Saigon river lights. | Before you go: Southern sizzling pancake works best when the name is tied to the reason for going, not memorized as an abstract label. Picture crispy bánh xèo with shrimp, pork, herbs, dipping sauce with texture, small meal rituals, flavor, and herbs, alongside Saigon river lights.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hcmc-place-banh-xeo-46a
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bánh xèo 46A
- `english_name`: Banh Xeo 46A
- `place_kind`: restaurant
- `source_notes`: local named-restaurant source
- `target_hero_image`: HeroCityHcmcPlaceBanhXeo46a
- `legacy_summary`: Banh Xeo 46A is worth considering when a meal should feel like part of the itinerary, not just fuel between sights. Expect large crispy bánh xèo on metal tray with herbs, Saigon restaurant table.
- `legacy_context`: For Banh Xeo 46A, Saigon's restaurant story comes through staff rhythm, drinks, evening meal energy, and tables, alongside Nguyen Hue city light.
- `legacy_sections_compact`: Why go: Banh Xeo 46A is worth considering when a meal should feel like part of the itinerary: dining culture, house dishes, table rhythm, and the choice of where a meal happens, with staff rhythm, drinks, evening meal energy, and tables, alongside Nguyen Hue city light. | What you'll get: At Banh Xeo 46A, you get dining culture, house dishes, table rhythm, and the choice of where a meal happens: large crispy bánh xèo on metal tray with herbs, Saigon restaurant table, with staff rhythm, drinks, evening meal energy, and tables, alongside Nguyen Hue city light. | Say it locally: Say Bánh xèo 46A for Banh Xeo 46A. The local name is easier to remember once it sits beside drinks, evening meal energy, tables, and house dishes, alongside Nguyen Hue city light. | Worth it if: Worth it if the meal itself should be one of the day's memories: menu details, staff rhythm, drinks, and evening meal energy, alongside Nguyen Hue city light. | Before you go: Banh Xeo 46A works best when the name is tied to the reason for going, not memorized as an abstract label. Picture large crispy bánh xèo on metal tray with herbs, Saigon restaurant table with menu details, staff rhythm, drinks, and evening meal energy, alongside Nguyen Hue city light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
