# Phrase Relationship Model

Status: active direction for content-system and phrase-detail design
Last updated: 2026-04-26
Scope: phrase-family structure, related-phrase modeling, listing/detail behavior, and scaling implications for app plus website

Alignment note: `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md` now owns the proposed long-term bundled SQLite read model. This document remains the product/content relationship model; the SQLite plan maps `family` into `phrase_cluster` while making phrase pages canonical per phrase.

## Why this exists

SpeakLocal should not feel like a dead-end searchable phrase database.

The user experience should keep moving forward:
- tap a phrase
- play it
- understand the shortest useful form
- see the clearer or more polite form
- see what reply may come back
- jump into the next likely phrase they need
- keep scrolling/tapping without feeling forced to back out to start over

The target interaction is closer to a utility-rich listing/detail graph than a flat phrase table.

## Canonical page graph rule

Phrase/listing navigation is a graph, not a strict parent-child tree.

Each traveler-facing phrase page must have one canonical page identity:
- one stable page ID per real phrase/listing page
- one canonical page title per phrase page, such as `Chào anh`
- search, browse, related rows, answer-page variants, and "ways to say it" links all point to that same canonical page
- never create a duplicate page just because the same phrase appears inside another page's row list

Example:
- `Chào anh` owns canonical page ID `viet-hello-anh`
- any link whose visible phrase is `Chào anh` should open `viet-hello-anh`
- the system should not also create `viet-hello-anh-way-standard` with the same title

Forward progress still matters. Pages should link onward when the next target teaches something real, including sideways or looping links, just like a useful Wikipedia graph. The anti-pattern is duplicated pages with the same phrase identity, not cyclic exploration.

Back behavior is navigation context only. A page may know where the user came from for the current session, but page identity must not depend on that route.

Native iOS navigation implementation note:
- the native shell should preserve browser-like back and forward history across phrase pages and search
- swipe back and swipe forward should be available where the route stack supports it
- if the user goes back and then opens a new page, forward history should clear
- glass chrome such as the back button, forward button, bottom toolbar, and search island should stay visually stable while page content animates under it
- the search affordance should feel like the bottom search island morphing into the search page's search field
- a visible arrow on a phrase row means it opens that phrase's canonical page ID
- a visible speaker icon means the phrase or token should play bundled audio or be captured by the missing-audio audit

That product direction should be expected to grow the content graph over time. More useful phrase-detail/listing pages will often require additional rows and connected families for shortest forms, clearer forms, polite/service-safe forms, follow-ups, repair branches, and likely next-step phrases.

Completeness therefore means more than "do we have one phrase for this need?"

For major traveler intents, the stronger question is:
- do we have the real cluster of useful ways to say it?
- do we know what someone may say back?
- do we know what the traveler should say next if the first try is not enough?
- and have we saved those useful rows into durable authored truth so they can carry audio and future runtime behavior?

Practical depth heuristic:
- a hub should usually be treated as `deep` when the moment branches by social register, context, likely reply, repair path, or next-step need in `3+` meaningful ways
- a hub should usually be treated as `support` when it has `1-2` meaningful branches that improve traveler utility but do not require a flagship-sized answer surface
- a hub can remain `baseline` when it is low-risk and low-branching, but even baseline hubs should preserve genuinely useful row truth for future promotion

Examples:
- `hello` and `yes` are not automatically shallow just because they are short
- `hello` becomes deep because it branches into social hierarchy, relationship language, situational greeting forms, and what to say next
- `yes` becomes support-to-deep because it branches into respectful assent, casual assent, confirmation, agreement, and traveler context like hotel, taxi, or restaurant interactions

## Terminology note

This doc keeps `family` because it is still the current internal model term, but product discussion should now read it this way:

- `category` / `scenario` = browse bucket or folder
- `scenario page` = optional page listing phrase hubs inside one category
- `listing page` / `product page` / `listing detail page` = the dedicated phrase-hub page the user opens
- `family` = the internal authored/runtime grouping behind one listing page
- `variant` / `phrase row` = one wording inside that listing page

Do not assume every category/scenario must become a dedicated page, and do not assume every app must share identical scenario lists just because the runtime contract is shared.

## Product direction

A phrase family is no longer just a category member. It should become a small traveler decision surface.

Each phrase-detail/listing surface should aim to expose:
- a shortest socially safe phrase for "just get by"
- a family-primary phrase that balances safety, clarity, and default usefulness
- optional clearer / more polite / also-common variants
- likely replies or what the traveler may hear back
- related phrase families for the next likely action
- nearby recovery branches when the first attempt fails

The goal is forward motion, not dead ends.

## Core family roles

Every family still has exactly one `say-first` primary, but interpretation is tightened:
- `say-first` = shortest socially safe usable phrase, often 1 to 2 words when honest
- `clearer` = longer or more explicit version that reduces ambiguity
- `more-polite` = hierarchy-safe or service-safe wording when respect matters
- `also-common` = a genuinely common alternate form

This means the app can show multiple useful layers of the same intent instead of a single isolated phrase.

## Relation types

Phrase relationships should extend beyond shared category membership.

Useful relation types include:
- `shorter_than`
- `clearer_than`
- `more_polite_than`
- `reply_to`
- `next_step_after`
- `repair_for`
- `escalation_for`
- `same_need_alt_context`
- `likely_answer_to`
- `see_also`

These do not all need to ship in one backend pass, but the model should support them.

## Suggested data-shape direction

Keep the current family/row model, but add a relation layer rather than replacing the whole content system.

Practical direction:
- keep `scenario` as the browse container
- keep `intent family` as the visible counting unit
- keep phrase rows/variants inside families
- add relation metadata that can connect:
  - phrase row to phrase row
  - family to family
  - family to likely-reply family
  - family to repair/escalation family

Preferred first implementation shape:
- family-level relation arrays in source/authored truth
- optional row-level relation overrides only when needed
- relation types that are website-safe and app-safe
- no full graph-database dependency required to start

## Current authored handoff contract

The first concrete Viet handoff stays additive to the current model:
- `content-draft/viet/phrase-source.csv` remains the row-level authoring truth
- `native-ios/Resources/LanguagePacks/` and generated SQLite/native resources remain the app runtime truth
- `content-draft/viet/relation-sample-v1.json` carries a bounded `29`-cluster starter-safe family-level relation sidecar for phrase-detail and listing work
- `content-draft/viet/relation-authoring-notes.md` explains how to extend the sidecar without turning it into a second content system

Prepared-next lanes such as Tagalog can use the same additive seam earlier:
- `content-draft/tagalog/phrase-source.csv` stays the row-level prep truth
- `content-draft/tagalog/first-wave-priority.csv` and `content-draft/tagalog/tagalog-v2-first-wave.csv` can carry compact relation guidance columns for the current bounded handoff
- `content-draft/tagalog/relation-sample-v1.json` can carry the family-level relation graph plus explicit parked or deferred follow-on candidates whose status stays visible

The current sidecar contract uses:
- `shortestFormPhraseId`
- `clearerFormPhraseId`
- `morePoliteFormPhraseId`
- `youMayHearSignals`
- `possibleTravelerResponses`
- `familyRelations`

When a prepared-next sample needs to keep adjacent drafted or deferred follow-ons visible without promoting them, the sidecar may also carry:
- `parkedFamilyCandidates`
- `retrievalContract`
- `deferredBoundaryFamilies`
- `rowOutcomeLedger`
- optional relation-level `targetStatus` labels when a family edge points at one of those non-promoted candidates
- optional relation-level `targetFollowOnClass` labels so promotion posture stays separate from the real underlying row status

The current row-level anchor seam is intentionally lighter than a new CSV schema column:
- the existing `notes` field carries relation membership markers such as `relation-sample=viet-hotel-check-in:anchor` or `relation-sample=tagalog-polite-decline-boundary:deferred-boundary`
- those markers only identify which approved Viet rows participate in the bounded relation sample and what role they play inside it

This anchor seam does not replace family structure, runtime pack generation, or scenario browse truth.

## Current Viet website export subset

The live website seam now projects a bounded relation-safe subset from the Viet sidecar into the starter export surface.

Current website-safe rules:
- the website relation packet is derived from `content-draft/viet/relation-sample-v1.json` after the base phrase/audio preview export is generated
- only exported Viet starter families receive relation metadata in the website seam
- relation edges and possible-traveler-response links are filtered to targets that are also inside the current exported website family set
- own-family variant pointers such as `shortestFormPhraseId`, `clearerFormPhraseId`, and `morePoliteFormPhraseId` may stay visible as lightweight detail/listing hints, but the website still does not receive premium text or non-exported target-family rails
- the current live subset covers `14` exported starter-safe Viet clusters across essentials, transport, food, money, phone, and repair
- arrival starter phrases currently remain relation-unbacked in the website export because the bounded sidecar does not yet map those exported airport families

Website payload fields for covered phrases:
- `relationContext.sampleId`
- `relationContext.clusterId`
- `relationContext.coverageMoment`
- `relationContext.shortestFormPhraseId`
- `relationContext.clearerFormPhraseId`
- `relationContext.morePoliteFormPhraseId`
- `relationContext.youMayHearSignals`
- `relationContext.possibleTravelerResponses`
- `relationContext.familyRelations`

Module and manifest summary fields:
- `relationCoverage`
- `relationExport`

### Canonical Viet website relation export contract

The website validator reads this block back and compares it against the live manifest plus module payloads.

<!-- canonical-viet-website-relation-export:start -->
```json
{
  "version": 1,
  "sampleId": "viet-relation-sample-v1",
  "sampleClusterCount": 29,
  "minimumCoveredClusterCount": 12,
  "currentCoveredClusterCount": 14,
  "coveredModuleIds": [
    "vietnam-essential-basics",
    "vietnam-transport-basics",
    "vietnam-money-basics",
    "vietnam-phone-basics",
    "vietnam-understanding-repair",
    "vietnam-food-drink-basics"
  ],
  "advisoryOnly": true,
  "starterOnly": true,
  "edgeTargetRule": "starter-safe and exported-target-only",
  "phraseRelationFieldNames": [
    "shortestFormPhraseId",
    "clearerFormPhraseId",
    "morePoliteFormPhraseId",
    "youMayHearSignals",
    "possibleTravelerResponses",
    "familyRelations"
  ]
}
```
<!-- canonical-viet-website-relation-export:end -->

The canonical block above intentionally pins both the source relation sample identity and its current `29`-cluster boundary so the validator can fail if the sidecar, docs, or exported manifest drift apart.

## Precedence rules

Use these rules when sidecar data and the existing pack model meet:
- phrase text, pronunciation, access tier, scenario membership, and variant role still come from `phrase-source.csv` and the generated pack
- the `notes` marker only declares which rows participate in a bounded relation sample and what role they play inside that sample
- `relation-sample-v1.json` owns the family-level relation edges, advisory likely-reply hints, and next-step / repair guidance
- if a sidecar relation points at a family or phrase id that does not exist in the base authored truth, treat that as an authoring bug
- `youMayHearSignals` and `possibleTravelerResponses` are advisory only and must not be rendered as deterministic promises about what another speaker will say next

## App implications

The app should eventually support phrase-detail/listing pages that:
- show the shortest form first
- let the user play variants inline
- show likely replies and what to say next
- surface related phrases beneath the main phrase instead of ending the flow
- encourage tap-forward behavior rather than forcing constant back-navigation

This creates a stronger product moat than generic translation utilities.

## Website implications

The website should not dump the full graph publicly, but it can use the same relation model for:
- richer starter phrase pages
- article-tool hybrid pages
- "what to say next" modules
- likely-reply modules
- related phrase suggestions

Current live website behavior is narrower than the full sidecar:
- only the exported starter families that intersect the bounded sidecar get relation metadata today
- relation edges stay advisory and filtered to exported-target families only
- non-exported target rails, premium rails, and broader full-library graph coverage stay app-only or future-only for now

The website and app should share relation truth where possible, even if the website gets only a starter-safe subset.

## Scale implications

The current live Viet boundary is 900 visible families, but the long-term system should be comfortable growing toward 2000+ visible families if quality and retrieval remain strong.

That means:
- relation modeling matters more as count grows
- simple category browse becomes less sufficient
- listing/detail quality and cross-linking become more important than raw phrase count alone
- expansion should favor usable connected families over flat library inflation

## Authoring implications

New language tasks should not only translate rows. They should increasingly:
- identify the shortest usable default
- identify when a clearer form is needed
- identify polite/service-safe alternatives
- identify likely reply branches
- identify next-step or repair connections
- identify genuinely useful additional rows that should be retained instead of rediscovered later
- leave behind relation-ready truth for future app/runtime consumption

When AI is used to brainstorm phrase clusters, treat the output as a candidate set to be triaged:
- keep rows that create real traveler utility differences
- keep rows that change social safety or likely conversation flow
- keep rows that create a better relation graph around the listing page
- do not automatically keep every plausible synonym just because the model can produce one

Vietnam should be the first language where this model is intentionally hardened, because it is the active runtime priority.
Tagalog and future languages should start with the model earlier so they do not need as much retrofitting later.

## Near-term implementation recommendation

Phase 1:
- define relation-ready authored fields and a lightweight schema
- harden Viet sample clusters across arrival, greetings, transport, food, money, hotel, phone, and repair
- create queue tasks that enrich phrase families into relation-ready listing/detail units

Phase 2:
- expose relation-safe starter slices to website export surfaces
- support phrase-detail modules and related-phrase rails in app/UI work
- validate that users can keep tapping forward without dead-end feeling

Phase 3:
- expand the relation model across more languages and deeper libraries
- decide later whether a dedicated graph store is warranted based on retrieval and authoring pressure

## Current architectural recommendation

Do not jump to a separate graph database yet.

Start with source-truth relation metadata inside the existing content system and generated outputs.
That keeps website and app alignment simpler, keeps authoring grounded, and avoids premature infrastructure cost.

Revisit dedicated graph storage only if:
- authoring becomes too tangled in flat files
- relation queries become too expensive or awkward in the app/site build path
- or cross-language relation tooling clearly needs a stronger backend service
