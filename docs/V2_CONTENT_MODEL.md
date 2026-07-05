# V2 Content Model

Alignment note: `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` now owns the proposed long-term bundled SQLite read model for canonical phrase pages, clusters, search, audio, and practice hooks. This document remains the current content blueprint and live count/reference surface.

## Goal

Keep the current app shell shippable while moving the content system away from a phrase warehouse and toward curated trip fluency for an excited pre-trip traveler.

The content system should help travelers explore a destination before arrival through food, cities, menus, culture, pronunciation, and useful everyday phrases, then keep those phrases usable in-country. It should not optimize primarily for arbitrary live translation.

## Runtime shape

- scenario = category-level runtime truth
- intent family = visible traveler decision unit inside a category
- phrase row = one primary phrase or one nearby variant inside a family

## Terminology guardrail

To avoid mixing data-model terms with UI page types, use these meanings consistently:

- `category` / `scenario`
  - the browse bucket, folder, or filter group
  - not automatically a dedicated page by itself
- `scenario page`
  - an optional page that shows the phrase hubs inside one category/scenario
- `intent family`
  - the internal authored/runtime unit for one phrase hub
  - keep this mostly as a model term, not the preferred day-to-day product term
- `listing page` / `product page` / `listing detail page`
  - the dedicated page for one phrase hub
  - this is the page the user opens for a specific phrase experience
- `phrase row` / `variant`
  - one wording inside the listing page / product page

The hierarchy is:

1. category / scenario
2. optional scenario page
3. listing page / product page
4. phrase row / variant

## Phrase-family rules

Every family must have exactly one `say-first` phrase.

Allowed variant roles:

- `say-first`
- `more-polite`
- `clearer`
- `also-common`

Allowed warning-note types:

- `formal`
- `bookish`
- `harder-to-say`
- `recognition-only`

## Phrase-detail and relation rules

The product should not behave like a flat searchable phrase database.

Phrase/detail navigation should be modeled as a canonical page graph:
- every real traveler-facing phrase/listing page gets one stable canonical page ID
- links from search, browse, related rows, and answer-page variants resolve to that canonical page
- do not create duplicate pages for the same phrase text just because the phrase appears as a row on another page
- parent/child is route context, not content identity
- cyclic or sideways exploration is allowed when it has teaching value; duplicated page identity is not

Each visible phrase family should increasingly act like a detail/listing surface with:
- one shortest socially safe phrase the traveler can say first to just get by
- one main family-primary phrase that balances usability and safety
- optional extended/clearer/politer variants when they materially help
- related phrase families that let the user keep navigating sideways into the next likely need
- nearby follow-up phrases such as reply, repair, escalation, payment, timing, or clarification branches

Preferred interpretation of the family roles:
- `say-first` = the shortest socially safe version, often 1 to 2 words when that still works
- `clearer` = a slightly longer version that removes ambiguity
- `more-polite` = a more respectful version for higher-formality or hierarchy-sensitive contexts
- `also-common` = a genuinely common alternate phrasing, not decorative duplication

Relation modeling should not stop at shared category/scenario membership. Phrase families should also carry relation intent such as:
- same goal, shorter vs clearer
- same goal, casual vs polite
- greeting to follow-up small talk
- request to clarification or repair
- question to likely answer / what-you-may-hear
- problem to escalation or recovery

Listing/detail surfaces should be designed so a traveler can tap from one phrase into adjacent useful phrases, more like a dense utility listing page than a dead-end card.

This direction also means raw phrase-row growth should be expected when it materially improves the phrase hubs. As phrase-detail/listing pages become richer, the content system may need more shortest-form, clearer, polite, follow-up, repair, and adjacent next-step rows than a flatter phrase database would have carried.

Completeness should now be interpreted this way:
- not every listing page needs the same handcrafted depth on day one
- but when a major traveler intent genuinely has multiple useful ways to say it, likely replies, repair branches, or nearby next-step phrases, those rows should be saved into authored truth instead of left as temporary reasoning
- richer answer hubs should therefore be expected to create and preserve more real rows over time, not just more decorative page copy

Recommended depth tiers:
- `deep` = flagship answer hubs with rich module content, real relation rails, and meaningful variant/support coverage
- `support` = nearby hubs with lighter module payloads but still real phrase rows and relation truth
- `baseline` = long-tail hubs that may start lighter, but should still preserve useful phrase-row truth so they can be promoted later without rediscovery

Practical triage rule:
- `deep` when the traveler moment branches in `3+` meaningful ways, for example:
  - politeness or hierarchy meaningfully changes the correct phrase
  - context changes the best wording (`restaurant`, `hotel`, `taxi`, `market`, `medical`)
  - the traveler is likely to need a repair, escalation, or next-step phrase immediately after
  - the moment is high-risk for money, safety, health, or social friction
  - locals often use something different from the obvious textbook default
- `support` when the page has `1-2` meaningful branch points and benefits from saved variants or linked helpers, but does not yet justify a flagship-sized answer surface
- `baseline` when the page is low-branching, low-risk, and mostly solved by one strong default plus maybe one nearby helper

Examples:
- `deep`: `hello`, `yes`, `I need a doctor`, `how much is this?`, `take me here`, `I don't understand`
- `support`: `thank you`, `where is the bathroom?`, `I have a reservation`, `can I pay by card?`
- `baseline`: `one`, `two`, `today`, `tomorrow`, `here`, `there`

Important nuance:
- phrase length does not determine depth
- branching social utility does
- a short word like `yes` can still be `support` or `deep` if it changes by politeness, situation, or confirmation type

## Relation authoring seam

The current relation-ready handoff is additive rather than a replacement model.

Authoring truth is split this way:
- `phrase-source.csv` still owns phrase rows, variant roles, access, context, and `you_may_hear`
- the existing `notes` field now carries lightweight `relation-sample=...` markers used only to identify which rows participate in the current bounded relation sample and which role they play inside it
- `relation-sample-v1.json` owns family-level relation edges plus advisory reply / next-step hints for the current `29`-cluster starter-safe sample
- when a prepared-next sample needs to point at adjacent drafted or deferred families outside the promoted cluster count, carry those in explicit parked/deferred candidate arrays with clear `currentStatus` labels rather than treating them as silent family variants

Use these sidecar fields when the family needs relation-ready behavior:
- `shortestFormPhraseId`
- `clearerFormPhraseId`
- `morePoliteFormPhraseId`
- `youMayHearSignals`
- `possibleTravelerResponses`
- `familyRelations`

The sidecar is allowed to enrich phrase-detail and listing behavior, but it must not become a second source of phrase text truth. Phrase text and access still come from the base family/row model.

Implication for variants and related rows:
- if the system learns that a phrase family needs a shorter, clearer, more polite, more common, likely-reply, repair, escalation, or adjacent next-step row, the preferred outcome is to save that row into the authored phrase source when it is genuinely useful
- do not rely on repeated future rediscovery of those rows from memory or ad hoc model output
- answer-page sidecars should point at saved row truth, not silently invent unsaved phrase variants

AI-assisted harvesting rule:
- prompts like `Different ways to say [PHRASE] in Vietnam` are useful candidate generators, not automatic truth
- candidate rows should be retained when they introduce one of these:
  - a genuinely different politeness or hierarchy-safe option
  - a distinct confirmation or agreement function
  - a distinct traveler context
  - a likely reply, repair, escalation, or next-step move
  - a locally common form that differs from the obvious learner default
- candidate rows should usually be rejected or demoted to a note when they are:
  - decorative paraphrases with no real traveler utility difference
  - duplicates of the same function with only cosmetic wording changes
  - overly bookish or formal unless that warning itself is useful
  - weakly supported forms that do not improve the traveler's actual decision surface

Prepared-next lanes may also carry:
- a top-level `retrievalContract` object that summarizes starter, deferred, pickup, and later-only outcomes in one place
- explicit `deferredBoundaryFamilies` when a non-promoted row should stay visible as a relation boundary
- a `rowOutcomeLedger` when downstream pickup needs the same bounded outcome order in one flat retrievable surface
- relation-level `targetFollowOnClass` labels so parked promotion posture stays separate from the real underlying row status

## Counting rules

- visible entry count = number of family primaries
- starter visible entry = family primary with `accessTier=starter`
- full visible entry count = all family primaries after unlock
- raw phrase row count = primary rows plus variants
- future prepared-not-live premium expansion lanes can define future family structure without changing current live counts
- promoted-live lane manifests may stay under `content-draft/viet/premium-expansion/` as historical records of how a lane entered runtime truth

Current Viet counts:

- 19 runtime scenarios
- 177 starter visible intent families
- 1605 premium visible intent families
- 1782 total visible intent families / clusters
- 1800 source phrase rows
- 1793 canonical phrase pages
- 11728 relation rows
- 4318 bundled audio assets
- 778 planned missing-audio phrase rows
- 0 release-blocking missing-audio rows
- The live-completion audits now live in `content-draft/viet/autonomous-500/` and `content-draft/viet/autonomous-900/`.
- Future Vietnam expansion planning beyond the current live pack now lives in `docs/VIET_PREMIUM_EXPANSION_PLAN.md`.
- Do not infer older `150 / 750 / 900` or `200 / 1000` planning counts from historical docs when generated native resources disagree.

## Authoring surfaces

Viet:

- `content-draft/viet/scenario-plan.json`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `content-draft/viet/canonical-pages/tier-one/_tier-one-index.json` for the current computed Tier 1 source-origin inventory
- `content-draft/viet/canonical-pages/<lane>/<scenario>/<page-id>.json` for authored offline canonical phrase-page articles
- `content-draft/viet/menu/_menu-index.json`, `content-draft/viet/menu/items/**`, and `content-draft/viet/menu/menu-helper-phrases.json` for the handwritten Food Menu and Drink Menu detail-page source
  - each menu item carries text-only `howLocalsOrder` guidance so the page teaches the local ordering move, customization choice, sauce/dip/broth behavior, or drink flavor/ice/sweetness decision without creating one-off audio requirements
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md` for the current city/place app-detail contract: `speaklocal.place.app-detail.v2.2`
- `docs/content/CITY_PAGE_COPY_AUTHORING.md` for city/place research and voice guidance that feeds that V2.2 app-detail contract
- `content-draft/viet/premium-expansion/` for future lane scaffolds and promoted-live historical manifests
- `content-draft/viet/website-preview.json` for article-module selection and ordering only

Viet Tier 1 listing-page quality standard:

- Use the installed `speaklocal-listing-pages` skill for canonical phrase-page authoring and review. For city/place app-detail pages, use `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`; `speaklocal-listing-pages` is mechanics-only for phrase/audio/routing/rendering.
- Treat source lanes as provenance only. `tier-one`, `catalog-promoted`, city, editorial-support, and menu-owned pages compile into one full-depth canonical phrase graph.
- Pages should feel like thoughtful offline answers to "Different ways to say [phrase] in Vietnam."
- Each page should carry phrase-specific explanation, useful variants, tone/register guidance, positively framed local/cultural/travel notes, canonical links, and audio-backed rows.
- Avoid visible internal terms such as `repair` when they are not traveler-friendly; for example, use "When You Don't Understand" in UI copy instead of "Understanding Repair."
- Runtime remains offline. AI-style means editorial structure and usefulness, not runtime AI calls.
- Speaker icons imply bundled audio or a missing-audio audit item; exact normalized audio should be reused before generating new files.

Tagalog prep sample:

- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/relation-authoring-notes.md`

Generated native runtime output:

- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-audio-manifest.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- `docs/audio-queues/viet-planned-missing-audio.csv`

Native generation scripts:

- `native-ios/scripts/generate-viet-catalog.js`
- `native-ios/scripts/generate-authored-tier-one-pages.js`
- `native-ios/scripts/generate-vietnamese-menu-copy.js` compiles the handwritten per-item menu source into the bundled runtime JSON and CSV export
- `native-ios/scripts/validate-vietnamese-menu-copy.js` validates menu source/runtime parity, one-by-one review status, text-only order lines, text-only `How locals order` sections, sauce/drink specificity, and audio-ready reusable helper phrases
- `native-ios/scripts/sync-viet-audio.js` validates and normalizes native audio manifest coverage
- `native-ios/scripts/generate-breakdown-audio-elevenlabs.js`
- `native-ios/scripts/generate-vietnamese-menu-audio-elevenlabs.js`

Website export output:

- `site/public/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/vietnam-*.json`
- `site/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-*.json`

## Website-safe phrase/audio seam

- the website consumes the exported JSON manifest and module payloads, not app runtime internals directly
- `content-draft/*/website-preview.json` remains the article-module selection layer
- website preview exports should be regenerated from native/content source paths, not from a React Native app pack
- each exported module now carries website-safe module metadata plus phrase-level fields needed for reuse:
  - destination, language, languageCode, country, variant
  - scenarioId / scenarioName
  - familyId / familyTitle / familySummary
  - article-module metadata such as travelerStage, difficulty, and formality when the website-preview config supplies real editorial labels
  - phraseId, accessTier, variantRole, variantLabel
  - englishText, targetText, canonicalTargetText, pronunciation, context, youMayHear, warningNoteType
  - phrase-level audio status plus a website-safe audio reference and URL when the row is actually audio-ready
  - module-level audio coverage counts so articles can stay honest about mixed or missing audio
- the current site consumer is the Vietnam phrase article, loaded from the manifest-driven module seam
- the current live site is still Viet-first; broader destination-surface starter parity is current direction, not completed website coverage yet
- module-level `travelerStage`, `difficulty`, and `formality` can now come from `content-draft/*/website-preview.json` as article-layer metadata without crossing the app/runtime boundary
- fields such as `audioDurationMs`, `transcriptChecked`, `interactionType`, and `modality` still have no durable source-of-truth in the current authored lane and should stay null/omitted until that changes
- the current Viet website seam now also carries a bounded relation-safe packet derived from `content-draft/viet/relation-sample-v1.json` after the base phrase/audio export is generated
- manifest-level `relationExport` and module-level `relationCoverage` summarize how much of the current starter export is relation-backed, including the source sample identity and current `29`-cluster sidecar boundary
- covered phrases now carry `relationContext` with `shortestFormPhraseId`, `clearerFormPhraseId`, `morePoliteFormPhraseId`, `youMayHearSignals`, `possibleTravelerResponses`, and `familyRelations`
- relation edges in the website seam must stay advisory-only and filtered to starter-safe targets that are already inside the exported website family set
- the current live Viet website subset covers `14` exported starter-safe clusters; uncovered exported families remain honest starter phrase/audio rows without synthetic relation rails

## Audio rule

- the current live Viet pack has `4318` bundled audio assets and `0` release-blocking missing-audio rows, but still carries `778` planned missing-audio phrase rows
- future newly authored rows may still stay `audioStatus=planned` until app audio catches up
- approved traveler-facing phrase rows should remain auditable against audio coverage, even when content grows faster than generation
- the long-term product target is that useful retained phrase rows receive audio rather than remaining a permanent text-only shadow layer
- website preview audio, when exported as ready, must be copied into the site-owned static artifact and served from the same staging/live deployment root

## Website rule

- website exports must stay starter/default-first
- each destination website surface should expose the same starter/free phrase layer that the app exposes for that destination
- destination articles should reinforce and route back into those same starter phrases
- website should stay phone-forward and app-aligned in flow while remaining responsive on desktop
- website preview approval is separate from app runtime truth
- website phrase/audio modules should be embedded into destination, article, and scenario surfaces rather than exposed as a giant public phrase directory
- premium remains app-first for now; do not add website premium, login/account architecture, cross-platform entitlement sync, or code-redemption flow here
- do not expose premium-only slices or full-library dumps through the website export
