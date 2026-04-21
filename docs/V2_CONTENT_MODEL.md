# V2 Content Model

## Goal

Keep the current app shell shippable while moving the content system away from a phrase warehouse and toward a traveler decision engine.

## Runtime shape

- scenario = category-level runtime truth
- intent family = visible traveler decision unit inside a category
- phrase row = one primary phrase or one nearby variant inside a family

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

- 150 starter visible entries
- 750 premium visible entries
- 900 total visible entries
- 919 approved raw phrase rows
- 919 approved rows currently marked `audioStatus=ready`
- 0 approved rows currently marked `audioStatus=planned`
- The live-completion audits now live in `content-draft/viet/autonomous-500/` and `content-draft/viet/autonomous-900/`.
- Future Vietnam expansion planning beyond the current live pack now lives in `docs/VIET_PREMIUM_EXPANSION_PLAN.md`.
- Do not infer future `200 / 1000` planning counts from the current runtime presentation config or the current boundary validator.

## Authoring surfaces

Viet:

- `content-draft/viet/scenario-plan.json`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `content-draft/viet/premium-expansion/` for future lane scaffolds and promoted-live historical manifests
- `content-draft/viet/website-preview.json` for article-module selection and ordering only

Tagalog prep sample:

- `content-draft/tagalog/phrase-source.csv`
- `content-draft/tagalog/first-wave-priority.csv`
- `content-draft/tagalog/tagalog-v2-first-wave.csv`
- `content-draft/tagalog/relation-sample-v1.json`
- `content-draft/tagalog/relation-authoring-notes.md`

Generated runtime output:

- `app/family/packs/viet.generated.ts`

Website export output:

- `site/public/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/vietnam-*.json`
- `site/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-*.json`

## Website-safe phrase/audio seam

- the website consumes the exported JSON manifest and module payloads, not app runtime internals directly
- `content-draft/*/website-preview.json` remains the article-module selection layer
- `npm run export:website-previews` projects starter/default-first phrase/audio modules from the generated app-family pack into site-owned data paths
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

- the current live Viet pack now has all `919` approved rows audio-backed in the app seam
- future newly authored rows may still stay `audioStatus=planned` until app audio catches up
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
