You are in the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. Use exactly the ten listings below. Do not choose replacements.

Set `batch_id: batch_042` in the final handoff block. Put `SpeakLocal v2.2 BATCH_042 - Saigon - 2026-05-26` as the first line of the final answer so Codex can identify this session later.

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

### 1. city-hcmc-place-bitexco-tower
- `ledger_row`: 217
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Tòa nhà Bitexco
- `english_name`: Bitexco Financial Tower
- `place_kind`: landmark
- `source_notes`: existing-city-library; Visit HCMC portal
- `target_hero_image`: HeroCityHcmcPlaceBitexcoTower
- `legacy_summary`: Bitexco Financial Tower is worth knowing in Saigon because it brings architecture, views, local pride, and history in visual form into the trip. Expect Bitexco tower rising over District 1 streets, scooters below.
- `legacy_context`: For Bitexco Financial Tower, Saigon's landmark story comes through landmark memory, architecture, views, and local pride, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Bitexco Financial Tower is worth knowing because it gives Saigon a specific landmark scene: views, local pride, history, and city light, alongside Ben Thanh market energy. | What you'll get: At Bitexco Financial Tower, you get architecture, views, local pride, and history in visual form: Bitexco tower rising over District 1 streets, scooters below, with history, city light, landmark memory, and architecture, alongside Ben Thanh market energy. | Say it locally: Say Tòa nhà Bitexco for Bitexco Financial Tower. The local name is easier to remember once it sits beside city light, landmark memory, architecture, and views, alongside Ben Thanh market energy. | Worth it if: Worth it if Bitexco Financial Tower gives your itinerary a clearer image: local pride, history, city light, and landmark memory, alongside Ben Thanh market energy. | Before you go: Bitexco Financial Tower works best when the name is tied to the reason for going, not memorized as an abstract label. Picture Bitexco tower rising over District 1 streets, scooters below with local pride, history, city light, and landmark memory, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 2. city-hcmc-place-bo-la-lot
- `ledger_row`: 218
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bò lá lốt ở Thành phố Hồ Chí Minh
- `english_name`: Beef in betel leaves
- `place_kind`: dish
- `source_notes`: local dish source
- `target_hero_image`: HeroCityHcmcPlaceBoLaLot
- `legacy_summary`: Beef in betel leaves is worth trying in Saigon because it gives the trip a flavor to imagine before arrival. Expect grilled bò lá lốt rolls with herbs and rice paper.
- `legacy_context`: For Beef in betel leaves, Saigon's food story comes through texture, small meal rituals, flavor, and herbs, alongside Saigon street energy.
- `legacy_sections_compact`: Why go: Beef in betel leaves is worth trying because it turns Saigon into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside Saigon street energy. | What you'll get: At Beef in betel leaves, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: grilled bò lá lốt rolls with herbs and rice paper, with sauce, steam, texture, and small meal rituals, alongside Saigon street energy. | Say it locally: Say Bò lá lốt ở Thành phố Hồ Chí Minh for Beef in betel leaves. The local name is easier to remember once it sits beside herbs, sauce, steam, and texture, alongside Saigon street energy. | Worth it if: Worth it if you want a food memory rather than only a label: small meal rituals, flavor, herbs, and sauce, alongside Saigon street energy. | Before you go: Beef in betel leaves works best when the name is tied to the reason for going, not memorized as an abstract label. Picture grilled bò lá lốt rolls with herbs and rice paper with small meal rituals, flavor, herbs, and sauce, alongside Saigon street energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 3. city-hcmc-place-bot-chien
- `ledger_row`: 219
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bột chiên ở Thành phố Hồ Chí Minh
- `english_name`: Fried rice-flour cakes
- `place_kind`: dish
- `source_notes`: local dish source
- `target_hero_image`: HeroCityHcmcPlaceBotChien
- `legacy_summary`: Fried rice-flour cakes is worth trying in Saigon because it gives the trip a flavor to imagine before arrival. Expect bột chiên sizzling on flat griddle with egg and green onions.
- `legacy_context`: For Fried rice-flour cakes, Saigon's food story comes through flavor, herbs, sauce, and steam, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Fried rice-flour cakes is worth trying because it turns Saigon into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside Ben Thanh market energy. | What you'll get: At Fried rice-flour cakes, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: bột chiên sizzling on flat griddle with egg and green onions, with texture, small meal rituals, flavor, and herbs, alongside Ben Thanh market energy. | Say it locally: Say Bột chiên ở Thành phố Hồ Chí Minh for Fried rice-flour cakes. The local name is easier to remember once it sits beside steam, texture, small meal rituals, and flavor, alongside Ben Thanh market energy. | Worth it if: Worth it if you want a food memory rather than only a label: herbs, sauce, steam, and texture, alongside Ben Thanh market energy. | Before you go: Fried rice-flour cakes works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bột chiên sizzling on flat griddle with egg and green onions with herbs, sauce, steam, and texture, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 4. city-hcmc-place-bui-vien-street
- `ledger_row`: 220
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Phố Bùi Viện
- `english_name`: Bui Vien Street
- `place_kind`: street
- `source_notes`: existing-city-library; Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceBuiVienStreet
- `legacy_summary`: Bùi Viện is Saigon’s concentrated backpacker-nightlife strip, best handled with one look-first pass, close phone and bag habits, and price checks before sitting down.
- `legacy_context`: Bùi Viện works when the first visit is observational before committed: walk once, read the noise, then decide whether a bar, food stall, or exit is right.
- `legacy_sections_compact`: Walk Once Before Sitting: Bùi Viện is useful when you want to see the backpacker-nightlife version of Ho Chi Minh City in one concentrated walk. Do one pass before choosing anything. | Music From Every Door: Bars push sound into the street, stools fill the pavement, and people move in slow clusters. It can be fun briefly and exhausting if you expected a relaxed night market. | Useful Phrases:  | Check Prices Before Ordering: Keep your phone and bag close, check prices before ordering, and ignore quick pitches that pressure a decision. Looking first keeps the visit lighter. | Backpacker District, Not All Saigon: Bùi Viện sits in the Phạm Ngũ Lão backpacker area near central District 1. See it if curious, then balance it with Nguyễn Huệ, Chợ Lớn, or a quieter dinner.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 5. city-hcmc-place-bun-thit-nuong
- `ledger_row`: 221
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Bún thịt nướng ở Thành phố Hồ Chí Minh
- `english_name`: Grilled pork vermicelli
- `place_kind`: dish
- `source_notes`: local dish source
- `target_hero_image`: HeroCityHcmcPlaceBunThitNuong
- `legacy_summary`: Grilled pork vermicelli is worth trying in Saigon because it gives the trip a flavor to imagine before arrival. Expect bowl of bún thịt nướng with herbs, peanuts, grilled pork.
- `legacy_context`: For Grilled pork vermicelli, Saigon's food story comes through texture, small meal rituals, flavor, and herbs, alongside District 1 movement.
- `legacy_sections_compact`: Why go: Grilled pork vermicelli is worth trying because it turns Saigon into flavor: local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember, with sauce, steam, texture, and small meal rituals, alongside District 1 movement. | What you'll get: At Grilled pork vermicelli, you get local flavor, texture, herbs, sauce, steam, and the small meal rituals visitors remember: bowl of bún thịt nướng with herbs, peanuts, grilled pork, with texture, small meal rituals, flavor, and herbs, alongside District 1 movement. | Say it locally: Say Bún thịt nướng ở Thành phố Hồ Chí Minh for Grilled pork vermicelli. The local name is easier to remember once it sits beside small meal rituals, flavor, herbs, and sauce, alongside District 1 movement. | Worth it if: Worth it if you want a food memory rather than only a label: small meal rituals, flavor, herbs, and sauce, alongside District 1 movement. | Before you go: Grilled pork vermicelli works best when the name is tied to the reason for going, not memorized as an abstract label. Picture bowl of bún thịt nướng with herbs, peanuts, grilled pork with herbs, sauce, steam, and texture, alongside District 1 movement.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 6. city-hcmc-place-ca-phe-sua-da
- `ledger_row`: 222
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Cà phê sữa đá Sài Gòn ở Thành phố Hồ Chí Minh
- `english_name`: Saigon iced milk coffee
- `place_kind`: drink
- `source_notes`: Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceCaPheSuaDa
- `legacy_summary`: Saigon iced milk coffee is worth knowing in Saigon because drink culture is part pause, part local rhythm. Expect iced Vietnamese milk coffee on Saigon sidewalk table, scooters softly behind.
- `legacy_context`: For Saigon iced milk coffee, Saigon's drink story comes through cafe counters, street stools, local refreshment, and sweetness, alongside Nguyen Hue city light.
- `legacy_sections_compact`: Why go: Saigon iced milk coffee is worth knowing because Vietnam's drink culture often carries the pause between bigger plans: local refreshment, sweetness, city pauses, and iced glasses, alongside Nguyen Hue city light. | What you'll get: At Saigon iced milk coffee, you get drink culture, street stools, cold glasses, local refreshment, and sidewalk pauses: iced Vietnamese milk coffee on Saigon sidewalk table, scooters softly behind, with local refreshment, sweetness, city pauses, and iced glasses, alongside Nguyen Hue city light. | Say it locally: Say Cà phê sữa đá Sài Gòn ở Thành phố Hồ Chí Minh for Saigon iced milk coffee. The local name is easier to remember once it sits beside iced glasses, cafe counters, street stools, and local refreshment, alongside Nguyen Hue city light. | Worth it if: Worth it if a cold glass, coffee pause, or sidewalk drink would make the day feel more local: sweetness, city pauses, iced glasses, and cafe counters, alongside Nguyen Hue city light. | Before you go: Saigon iced milk coffee works best when the name is tied to the reason for going, not memorized as an abstract label. Picture iced Vietnamese milk coffee on Saigon sidewalk table, scooters softly behind with iced glasses, cafe counters, street stools, and local refreshment, alongside Nguyen Hue city light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 7. city-hcmc-place-cafe-apartment-nguyen-hue
- `ledger_row`: 223
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Chung cư cà phê Nguyễn Huệ
- `english_name`: Cafe Apartment on Nguyen Hue
- `place_kind`: cafe
- `source_notes`: Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceCafeApartmentNguyenHue
- `legacy_summary`: Cafe Apartment on Nguyen Hue is not one cafe; it is an old apartment building turned into a vertical stack of cafes, boutiques, balconies, and tiny upstairs rooms above the walking street.
- `legacy_context`: Cafe Apartment on Nguyen Hue is Saigon cafe culture in building form: look up at the stacked facade, pick a floor, then settle into a small cafe room above Nguyen Hue Walking Street.
- `legacy_sections_compact`: Why go: Cafe Apartment on Nguyen Hue is worth saving because it is not one famous cafe. It is an old apartment building turned into a vertical cafe stop, with balconies, signs, small shops, and upstairs rooms facing the walking street. | What you'll get: At Cafe Apartment on Nguyen Hue, expect a small adventure before the coffee: looking up at the facade, finding the entrance, choosing a floor, and landing in a cafe with a balcony view over central Saigon. | Say it locally: Say Chung cư cà phê Nguyễn Huệ. Chung cư means apartment building, cà phê means coffee or cafe, and Nguyễn Huệ is the walking street, so the phrase tells locals you mean the cafe-filled building. | Worth it if: Worth it if you want a central Saigon stop that feels visual and easy to explore: coffee, balcony views, small boutiques, and a break from the heat without leaving District 1. | Before you go: Before you go, do not picture a single counter. Picture a stacked apartment facade where each floor can hold a different cafe, and where the fun is partly deciding which little room to try.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 8. city-hcmc-place-cafe-hop-nguyen-hue
- `ledger_row`: 224
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Đi cà phê Nguyễn Huệ
- `english_name`: Nguyen Hue cafe hop
- `place_kind`: experience
- `source_notes`: Vietnam Travel HCMC
- `target_hero_image`: HeroCityHcmcPlaceCafeHopNguyenHue
- `legacy_summary`: Nguyen Hue cafe hop is worth knowing in Saigon because it brings movement across the city as part of the discovery into the trip. Expect cafe-hopping scene inside Nguyen Hue apartment building, balcony city view.
- `legacy_context`: For Nguyen Hue cafe hop, Saigon's route story comes through food stops, cafe pauses, local movement, and the route between named places, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Nguyen Hue cafe hop is worth knowing because it gives Saigon a specific route scene: food stops, cafe pauses, local movement, and the route between named places, alongside Ben Thanh market energy. | What you'll get: At Nguyen Hue cafe hop, you get movement across the city as part of the discovery: cafe-hopping scene inside Nguyen Hue apartment building, balcony city view, with street corners, food stops, cafe pauses, and local movement, alongside Ben Thanh market energy. | Say it locally: Say Đi cà phê Nguyễn Huệ for Nguyen Hue cafe hop. The local name is easier to remember once it sits beside street corners, food stops, cafe pauses, and local movement, alongside Ben Thanh market energy. | Worth it if: Worth it if Nguyen Hue cafe hop gives your itinerary a clearer image: cafe pauses, local movement, the route between named places, and street corners, alongside Ben Thanh market energy. | Before you go: Nguyen Hue cafe hop works best when the name is tied to the reason for going, not memorized as an abstract label. Picture cafe-hopping scene inside Nguyen Hue apartment building, balcony city view with street corners, food stops, cafe pauses, and local movement, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 9. city-hcmc-place-cafe-vot-pham-ngoc-thach
- `ledger_row`: 225
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Cà phê vợt Phạm Ngọc Thạch
- `english_name`: Pham Ngoc Thach cloth-filter coffee
- `place_kind`: cafe
- `source_notes`: local named-cafe source
- `target_hero_image`: HeroCityHcmcPlaceCafeVotPhamNgocThach
- `legacy_summary`: Pham Ngoc Thach cloth-filter coffee is worth saving for Saigon's cafe rhythm: coffee, ice, sweetness, design, and a slower pause in the day. Expect cloth-filter coffee being poured in old Saigon cafe.
- `legacy_context`: For Pham Ngoc Thach cloth-filter coffee, Saigon's cafe story comes through coffee counters, iced glasses, street stools, and design details, alongside Ben Thanh market energy.
- `legacy_sections_compact`: Why go: Pham Ngoc Thach cloth-filter coffee is worth saving when you want Saigon's cafe culture, not just caffeine: soft pauses, cafe views, coffee counters, and iced glasses, alongside Ben Thanh market energy. | What you'll get: At Pham Ngoc Thach cloth-filter coffee, you get Vietnam's cafe culture and the slower rhythm between meals and sightseeing: cloth-filter coffee being poured in old Saigon cafe, with street stools, design details, soft pauses, and cafe views, alongside Ben Thanh market energy. | Say it locally: Say Cà phê vợt Phạm Ngọc Thạch for Pham Ngoc Thach cloth-filter coffee. The local name is easier to remember once it sits beside design details, soft pauses, cafe views, and coffee counters, alongside Ben Thanh market energy. | Worth it if: Worth it if the trip needs a slower pause between walks, markets, meals, or heat: iced glasses, street stools, design details, and soft pauses, alongside Ben Thanh market energy. | Before you go: Pham Ngoc Thach cloth-filter coffee works best when the name is tied to the reason for going, not memorized as an abstract label. Picture cloth-filter coffee being poured in old Saigon cafe with cafe views, coffee counters, iced glasses, and street stools, alongside Ben Thanh market energy.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.

### 10. city-hcmc-place-che
- `ledger_row`: 226
- `current_status`: not_started
- `city_id`: hcmc
- `city_name`: Saigon
- `vietnamese_name`: Chè Sài Gòn ở Thành phố Hồ Chí Minh
- `english_name`: Sweet soup dessert
- `place_kind`: dessert
- `source_notes`: local dish source
- `target_hero_image`: HeroCityHcmcPlaceChe
- `legacy_summary`: Sweet soup dessert is worth trying in Saigon for sweetness, texture, color, and a small break between bigger plans. Expect colorful Vietnamese chè cups with coconut milk and jelly, Saigon dessert stall.
- `legacy_context`: For Sweet soup dessert, Saigon's sweet story comes through color, evening snack counters, dessert cups, and coconut milk, alongside Nguyen Hue city light.
- `legacy_sections_compact`: Why go: Sweet soup dessert is worth trying for the sweet side of Saigon: the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters, with fruit, color, evening snack counters, and dessert cups, alongside Nguyen Hue city light. | What you'll get: At Sweet soup dessert, you get the sweet side of the city through cups, ice, fruit, jelly, coconut milk, and evening snack counters: colorful Vietnamese chè cups with coconut milk and jelly, Saigon dessert stall, with color, evening snack counters, dessert cups, and coconut milk, alongside Nguyen Hue city light. | Say it locally: Say Chè Sài Gòn ở Thành phố Hồ Chí Minh for Sweet soup dessert. The local name is easier to remember once it sits beside fruit, color, evening snack counters, and dessert cups, alongside Nguyen Hue city light. | Worth it if: Worth it if you want the sweet, textural side of the city: fruit, color, evening snack counters, and dessert cups, alongside Nguyen Hue city light. | Before you go: Sweet soup dessert works best when the name is tied to the reason for going, not memorized as an abstract label. Picture colorful Vietnamese chè cups with coconut milk and jelly, Saigon dessert stall with shaved ice, fruit, color, and evening snack counters, alongside Nguyen Hue city light.
- `notes`: Legacy city-v1 handwritten source; needs v2.2 authoring before production.
