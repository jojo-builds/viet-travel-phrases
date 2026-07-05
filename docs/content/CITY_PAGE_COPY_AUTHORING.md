# City Page Copy Authoring

Status: active research and voice standard for Vietnam city and place pages

Companion voice research: `docs/content/CITY_PLACE_VOICE_RESEARCH.md`

Current app-detail contract: `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`

## Current App-Detail Contract

City/place app-detail work must route through `speaklocal.place.app-detail.v2.2`. This document owns the research and voice standard; the current source/render contract lives in `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md` and its V2.2 playbook, canonical examples, generation prompt, implementation audit prompt, and schema proposal.

Do not treat old city-v1, mobile-first/expanded-detail prose, fixed section IDs, or city-library section authoring as the current city/place page model. New city/place pages should be authored as app-detail experiences with an intro, playable useful phrase cards, practical sections, Mentioned Here candidates, related place candidates, and internal verification flags.

Legacy city-library copy can be research input or runtime projection, but it is not current approval authority. Production approval requires a first-class v2.2 app-detail source object plus the current voice, source, render, and production review gates.

## Product Aim

City pages should make a curious pre-trip visitor feel that Vietnam is specific, vivid, and worth exploring before they arrive. The page should not sound like a phrasebook explaining how to use a name, and it should not sound like copy poured into the same section mold as every other place.

Write the page so the reader can picture why this place exists in the trip. If the same paragraph could be reused for another cafe, restaurant, market, museum, bridge, street, or neighborhood, it is not ready.

Voice adequacy is a review gate, not a rewrite layer. The visible page must prove a concrete scene, a truthful why-here, and a useful first move in story-rich human copy, without sounding like a database row, process note, schema checklist, validator receipt, or internal QA log.

## Research First

Before rewriting a named place, gather current, stable signals from the best available sources:

- the venue's own site, menu, location page, or journal when available
- review consensus from Google Maps, TripAdvisor, local directories, booking platforms, or food/travel guides when available and allowed
- local directories, visitor photos, and review summaries for recurring patterns
- official tourism or city sources for civic landmarks, museums, transit stops, and public places
- traveler reports only as directional color, not as the sole factual basis

Capture the actual hook: what people come here for, what makes this location different from similar options, and what a visitor from the United States would be curious to know before saving it.

For restaurants, cafes, bars, dessert shops, markets, and food streets, look for review-backed patterns before writing final copy:

- what people repeatedly praise, not one isolated comment
- specific dishes, drinks, desserts, menu sections, views, service moments, or room details that recur across sources
- what kind of visit people choose it for: brunch, remote work, family meal, date night, late snack, cooling off, shopping break, first-day comfort, or destination meal
- what people compare it against, such as central District 1 cafes, sidewalk coffee stops, hotel restaurants, market stalls, or other branches

For review-led venue pages, target 25 recent positive Google reviews and treat 20 as the minimum before scaling the rewrite across a city. If Google does not expose enough review text through an approved path, record that limitation explicitly instead of pretending the target was met, then supplement with the best top review/travel sources available. Save the review evidence locally outside bundled app resources. The app may use review-backed details and concise proof language, but should not store or display raw review dumps.

Do not turn reviews into raw visible review dumps. The app copy should be opinionated because the research supports it, while still sounding like SpeakLocal. Short proof quotes can be used only when the source terms and attribution requirements are satisfied; otherwise paraphrase the consensus and keep the source notes internal.

## Outcome Over Template

Do not give the model a paragraph formula. Give it the desired reader outcome:

- the place feels distinct from close substitutes
- the reader can imagine the setting without being told what to feel
- the prose sounds like someone who has looked into the place, not like a validator pass
- the local name feels useful only after the place itself feels worth remembering

Do not preserve consistent city-page section titles just for app scanning on review-led places. The old `Why go / What you'll get / Say it locally / Worth it if / Good to know` rhythm is legacy structure, not a target. Use only the headings that the specific place earns, or make the page read like a short article with minimal headings.

Avoid field-label copy in visible prose. People do not usually write memorable restaurant or cafe copy with colon-driven summaries such as "The draw: ..." or "Order this: ..." unless the entire publication has intentionally chosen that format. SpeakLocal should sound less like a form and more like a compact travel note.

When using AI for a draft, the prompt should ask for research-backed copy and supply the desired reader outcome, not a list of nouns to weave into every section. The model should first find why locals, tourists, or regulars choose this specific place over similar options, then write from those findings in a human voice.

For GPT-5.5, keep the writing prompt short and outcome-first. Official prompt guidance says shorter outcome-first prompts usually work better than process-heavy prompt stacks, so city-page authoring should not replay this whole document into the model. Use the document as an editorial standard, then write from a compact prompt:

- reader: curious U.S.-based visitor deciding what to remember before Vietnam
- outcome: the place feels specific, vivid, and worth visiting
- evidence: review themes, venue-owned facts, menu details, neighborhood signals
- constraints: no raw review dumps, no template headings, no generic swap-test prose
- output: natural copy that can be mapped into the app fields after it reads well

For mobile place pages, cut harder than a travel article. The target is a premium editorial object: short observations, modular cards, useful phrases, and a few specific details that make the place stick. If the copy starts explaining itself, it is probably too long.

Use hard mobile limits for venue listings: no long paragraphs, no section body over two short sentences, no paragraph over 45 words, and no repeated section cadence. Do not ask the model to "write nice copy." Ask it to build a mobile listing page with short editorial fragments, utility modules, and phrase hooks.

Read the first two fields out loud. If the summary and first section say the same idea twice with slightly different phrasing, the page still feels templated. If a compressed phrase needs explanation, such as "turns coffee into a longer morning," rewrite it into the simpler human action underneath: someone came in for coffee, stayed for brunch, kept talking, browsed the shelves, and left with a clearer sense of the neighborhood.

Good prompting shape:

- reader: a curious visitor in the United States deciding what to save before a Vietnam trip
- outcome: the page makes the place feel specific enough to remember
- research: use the venue's own materials and stable local/travel signals before writing
- constraint: no sentence should survive unchanged if the place name is swapped with a similar venue
- structure: no default section template; the final shape should come from the research

## Copy Test

Before approving a page, ask:

- What is the one-sentence hook that only this place can own?
- Which detail came from research rather than a category template?
- Would this still be true if the title were replaced with another similar place?
- Is any sentence telling the reader how to feel instead of making the scene concrete?
- Does the page sound like a person describing an experience, not an app explaining its taxonomy?
- Are the headings specific to this place rather than inherited from an old template?

If the answer is weak, rewrite the page from research. Do not tune template output until it passes.

## Bad Pattern

Avoid copy that says a place is useful because of broad categories:

> L'Usine Thao Dien is worth saving when you want Saigon cafe culture, design details, soft pauses, and street energy.

That could describe many cafes and does not explain why this branch matters.

## Better Pattern

Use researched, place-owned details:

> L'Usine Thao Dien is the L'Usine branch for a slower Thao Dien morning: high ceilings, warm wood, retail shelves near the tables, and a brunch menu where recent guests keep naming Eggs Benedict, squid ink crab pasta, Premium Pho, and salt caramel coffee.

The better version gives the reader concrete, review-backed reasons to remember this location instead of any other cafe.
