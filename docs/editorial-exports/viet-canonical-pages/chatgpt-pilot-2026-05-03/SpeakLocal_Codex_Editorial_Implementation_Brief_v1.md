# SpeakLocal Vietnam Editorial Pilot — Codex Implementation Brief

This pilot is a human-edited staging patch for the Google Sheet export. Do not treat it as a generator output.

## Import policy

- The repo remains source of truth.
- The spreadsheet/patch is staging only.
- Import only rows marked `APPROVED_FOR_IMPORT` after Jojo review.
- This v1 file leaves rows as `REVIEW_ONLY` so Codex can review before implementation.

## Key content models

### restaurant-live-interaction
- Page kinds: restaurant
- Intent: Make named restaurant pages feel like the user just walked in or is showing the place to a driver.
- Structure: at-glance → quick-say → breakdown → before-you-go → inside-the-place → paying/leaving → good-to-know → explore-next
- Avoid: Reviews, ratings, awards, changing hours/prices, generic 'place name helps staff' boilerplate.

### dish-order-and-diet
- Page kinds: dish
- Intent: Make dish pages about hearing, ordering, and safely checking ingredients.
- Structure: at-glance → quick-say → breakdown → how-to-order → ingredients-diet → when-to-use → good-to-know → explore-next
- Avoid: Treating dishes as landmarks; fake literal breakdowns; route/ticket language.

### place-journey
- Page kinds: place / landmark / attraction
- Intent: Make big attractions multi-step journeys rather than static place cards.
- Structure: at-glance → quick-say → breakdown → journey-flow → key-phrases → what-happens-next/recovery → good-to-know → explore-next
- Avoid: Wikipedia-style descriptions, history, hours/prices without research, generic map-anchor copy.

### place-navigation-photo
- Page kinds: place / landmark
- Intent: Make landmarks useful for pickup, photos, and nearby navigation.
- Structure: at-glance → quick-say → breakdown → place-brief → use-it-with → when-to-use → good-to-know → explore-next
- Avoid: Generic 'ride, ticket, entrance, route' if tickets are not relevant.

### street-pronouncer
- Page kinds: place / street
- Intent: Make street-name pages audio-first and driver-ready.
- Structure: at-glance → quick-say → breakdown → show-driver → confirm → drop-off/wrong-place → good-to-know → explore-next
- Avoid: Treating street as landmark; fake name meanings; burying street names in vocabulary.

### driver-ready-phrase
- Page kinds: phrase / route
- Intent: Turn clipped route labels into phrases the traveler can actually say.
- Structure: at-glance → quick-say → breakdown → driver-mode → when-to-use → good-to-know → explore-next
- Avoid: Using only clipped labels like 'Đi Bà Nà Hills' as the main spoken phrase.

### direction-question-with-recovery
- Page kinds: phrase / where-question
- Intent: Make where-questions include likely replies and recovery phrases.
- Structure: at-glance → quick-say → breakdown → what-happens-next → recovery → when-to-use → good-to-know → explore-next
- Avoid: Only showing the sentence with no next-step help.

### ticket-counter
- Page kinds: phrase / ticket
- Intent: Make ticket phrases polite and variants-ready.
- Structure: at-glance → quick-say → breakdown → natural-variants → when-to-use → good-to-know → explore-next
- Avoid: Volatile pricing or policy claims without research.

## Validator upgrades

### wrong_breakdown_dictionary_context (P0)
Breakdown cards that map Vietnamese tokens to wrong English meanings based on unrelated homographs or bad generation.

Examples: cô -> have / yes on Dạ, chào cô; chưa -> pagoda on Hành lý của tôi chưa tới; vệ -> ticket on Có giấy vệ sinh không?

Suggested logic: Create protected mappings for high-frequency words and multiword phrases; flag any breakdown not in approved context dictionary. Prefer multiword chunks when word-by-word is misleading.

### template_mismatch_by_pageKind (P0)
Restaurant/dish/street/place pages using the wrong content model.

Examples: Dish pages mentioning route/ticket/shopping; restaurants using generic named-place copy; streets using landmark pages.

Suggested logic: Map pageKind/placeKind/contentRole to allowed section_ids. Flag if pageKind=dish has place-brief route language or pageKind=restaurant lacks inside-the-place/order sections.

### generic_boilerplate_density (P1)
Pages that pass structural validation but are boring or generic.

Examples: Repeated copy: 'Learn the anchor on its own...' and 'route, ticket, shopping, or help phrases branch from it.'

Suggested logic: Compute n-gram reuse across current_section_copy. Flag pages with high boilerplate overlap unless section is deliberately standardized.

### relationship_words_irrelevant (P1)
Relationship-word sections added to pages where the user is not greeting or addressing a person.

Examples: Bà Nà Hills route/ATM pages showing relationship-words rows.

Suggested logic: Allow relationship-words only in greeting/politeness pages or phrase rows requiring anh/chị. Suppress for place/street/dish/route pages.

### clipped_phrase_needs_full_sentence (P1)
Route/ticket phrases that are labels rather than speakable traveler sentences.

Examples: Đi Bà Nà Hills; Đi cầu Rồng; Một vé vào Ngũ Hành Sơn.

Suggested logic: For route/ticket intents, add proposed full sentence when primary phrase starts with bare verb/noun and lacks polite/request frame.

### volatile_fact_claim (P1)
Claims about hours, prices, awards, queue rules, current policies, or schedules that may change.

Examples: Any future Bà Nà Hills pricing/hours or restaurant hours/awards.

Suggested logic: Require source_url + researched_at for volatile facts, or mark NEEDS_RESEARCH.

### street_pronouncer_missing_full_sentence (P1)
Street pages without both street-only and full-sentence audio targets.

Examples: Đường Nguyễn Văn Linh, Đường Võ Nguyên Giáp, Đường Bạch Đằng.

Suggested logic: For placeKind=street, require street_only_audio_key and at least one 'Cho tôi đến đường...' phrase.

## Codex tasks

### TASK-VIET-EDITORIAL-IMPORT-001
Build importer that reads approved rows from this patch or the Google Sheet, updates authored source JSON, regenerates resources/SQLite/practice artifacts, validates, and commits.

### TASK-VIET-VALIDATORS-002
Implement validators from Validator Upgrades sheet: wrong breakdowns, template mismatch, boilerplate density, irrelevant relationship sections, clipped phrases, volatile facts, street pronouncer requirements.

### TASK-VIET-CONTENT-MODELS-003
Add section model routing based on pageKind/placeKind/contentRole: restaurant-live-interaction, dish-order-and-diet, place-journey, place-navigation-photo, street-pronouncer, driver-ready-phrase.

### TASK-VIET-STREET-PRONOUNCER-004
Add UX/content support for Say This Street: street-only audio, full phrase audio, Show Driver mode, confirmation/drop-off/wrong-place phrases.

### TASK-VIET-SCENARIO-MODE-CONTENT-005
Use the same models as seed content for Scenario Mode: restaurant walk-in, driver pickup, attraction journey, street pronouncer, baggage problem, bathroom survival.

