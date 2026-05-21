# Viet Audience And City Copy Drift Audit - 2026-05-18

Status: current source-of-truth audit and completion note for audience alignment, city-copy drift, and agent handoff clarity.

## Current Direction

SpeakLocal Vietnam is for English-speaking travelers who are excited to go to Vietnam and want the country to feel more vivid, familiar, and usable before they arrive.

The app is not a school-style Vietnamese course, not an arbitrary AI translator, and not a fear-led emergency phrasebook. Google Translate and general AI tools can translate what a traveler asks for; SpeakLocal earns belief by curating what Vietnam travelers should see, hear, save, and practice before and during the trip.

For city place pages, assume many readers are still planning from the United States. The copy should make the destination feel worth saving before arrival; do not center a map view, map pins, or ride logistics unless the page is actually about transit or orientation.

The current offer truth is a 7-day free trial, then `$4.99/month` through `app.speaklocal.vietnam.subscription.monthly`.

## Sources Of Truth

Use these first when future agents need direction:

| Question | Current Source |
| --- | --- |
| Audience, positioning, copy guardrails, and offer framing | `marketing/strategy/audience-positioning.md` |
| Durable product decisions | `docs/DECISIONS.md` |
| Shared app/product blueprint | `docs/V2_BASELINE.md` |
| Near-term roadmap and what not to do | `docs/PRIORITIES.md` |
| Marketing-agent lane rules | `marketing/AGENTS.md` |
| City source content | `content-draft/viet/city-library/v1.json` |
| Generated native listing-page runtime | `native-ios/Resources/viet-authored-listing-pages.json` |
| City copy production checklist report | `docs/content-audits/viet-city-copy-production-2026-05-17.json` |
| City copy structural validator | `native-ios/scripts/validate-viet-city-copy.js` |

Historical task logs, old `.agent` reviews, and archived app-surface notes can contain older one-time-purchase or survival-phrase language. Treat them as history, not instruction authority.

## Drift Cleared In This Pass

- Active docs now point to the positive travel-discovery audience: food, places, culture, playable audio, useful phrases, saving, and practice.
- Legacy fixed-price unlock framing has been removed from active product/marketing/operations docs.
- `docs/PRIORITIES.md` no longer says plain `subscriptions` are out of scope; it now only excludes account-required subscription features beyond the current StoreKit trial/monthly surface.
- First-run onboarding draft docs no longer present a limited-preview paywall CTA as a secondary action.
- Historical copy-review extraction softened older emergency-first wording to practical first-day language so agents do not copy the old emotional frame forward.
- All 500 approved city noun/place pages were rewritten from source around the accepted standard: reason to go first, factual or historical hook second, local-name/audio support third.
- The five source city hubs and the Swift-visible `All Vietnam` / city hub copy were brought into the same positive travel-discovery direction.
- The 500 city noun/place page `context`, `tip`, `rationale`, summaries, and editorial sections were normalized so older logistics-first or map-pin source copy does not re-seed future generator drift.
- The city production report and native authored listing resource were regenerated from the rewritten source copy.
- A dedicated audience-fit audit was added at `native-ios/scripts/audit-viet-city-audience-fit.js`.
- Final subagent review gates covered Hanoi, Ho Chi Minh City / Saigon, Da Nang, Hoi An, Hue, plus All Vietnam / Swift-visible hub copy. The reviewers initially flagged performance venues falling into museum copy, lake/canal/roundabout framing, prompt residue, plural-title grammar artifacts, and duplicated template sections; those classes were fixed in the source rewrite generator and revalidated.

## Live City Inventory

Current repo truth is:

| Metric | Current Count |
| --- | ---: |
| Source city hubs | 5 |
| Live city hub IDs | `hcmc`, `hanoi`, `danang`, `hoian`, `hue` |
| Extra country hub in Browse shortcuts | `all-vietnam` |
| Homepage city shortcuts | 5 |
| Approved city noun/place pages | 500 |
| Approved city noun/place pages per city | 100 |
| Additional city-library phrase pages | 307 |
| Total city-library runtime pages | 807 |
| Page kinds among 500 noun/place pages | 346 `place`, 97 `restaurant`, 57 `dish` |

Jojo mentioned seven city hubs. The native app currently exposes five city hubs plus an `All Vietnam` country hub. If seven city hubs are intended, that is a product/content expansion decision; it is not reflected in current source or native Browse routing.

## What The Phone Shows

There are two visible city-copy paths:

- City hub intro/subtitle copy is currently hardcoded in `native-ios/App/Models/BrowseSearchDestinations.swift` through `citySubtitle(for:)`, `cityIntro(for:)`, and the country hub descriptor.
- City noun detail paragraphs come from `native-ios/Resources/viet-authored-listing-pages.json`, generated from `content-draft/viet/city-library/v1.json`.

This means the backend city hub editorial is not the only authority for what appears on the phone. The current source and Swift city hub direction have been synced manually in this pass, but future cleanup should either render hub copy from source or add a parity check.

## City Copy Fit

Completed alignment:

- The city hub intros are in the current emotional lane: food, coffee, markets, lakes, bridges, old streets, lanterns, rivers, royal history, and exact names that make places easier to recognize.
- The 500 city noun/place pages now lead with why someone would want to go, what they will get from the stop, and a factual/cultural hook before the local-name/audio support.
- The source-owned rewrite script is `scripts/rewrite-viet-city-audience-copy.js`; rerun it before regeneration if the copy standard changes.
- Food, coffee, markets, culture, place specificity, and sensory terms are present at meaningful volume across the rewritten corpus.

Known drift risk:

- The generated copy is still template-assisted across 500 pages. The review gate should focus on flagship/high-risk pages and any page where the visual cue comes from an image prompt rather than richer local notes.
- Transit and ticket-booth pages are intentionally more practical, but they should still open as arrival/gateway scenes rather than errands.
- The older `viet-city-place-page-model-001` audit is now partially stale: it was useful for diagnosing the flat model, but its inventory counts and "current state" no longer match the 807-page page-kind-aware library.

## Recommendations

### P0 - Keep Agents Aligned

- Treat `marketing/strategy/audience-positioning.md` as the current audience spine.
- Do not use historical `.agent` task reviews as current monetization or audience truth.
- Preserve the current offer wording: 7-day free trial, then `$4.99/month`.
- Keep serious help surfaces calm and findable, but do not make them the emotional center of the app.

### P1 - Resolve City Hub Truth

- Decide whether the app should intentionally have five city hubs plus `All Vietnam`, or whether two more city hubs are planned.
- Move hardcoded city hub intro/subtitle copy into generated/source-backed data, or add a parity validator that fails when source hub editorial and Swift-visible city copy diverge.
- Reframe the `All Vietnam` hub toward discovery: food and coffee, places to visit, city names, local objects, and useful phrases before "help" language.

### P2 - Maintain The Rewritten City Copy

The first sentence of a city noun page should continue to answer: "Why would someone planning a Vietnam trip care about going here?" Practical phrase support should come after the place has a real reason to exist.

When copy changes, update source first, rerun:

- `node scripts/rewrite-viet-city-audience-copy.js`
- `node native-ios/scripts/audit-viet-city-audience-fit.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/build-viet-city-copy-review-report.js`

### P3 - Keep Audience-Fit Validation Active

The lightweight city-copy audience audit now checks:

- source city hub count vs Swift route count;
- source hub and All Vietnam rewrite evidence;
- repeated generic logistics-first openings;
- utility-to-discovery ratio by page kind;
- pages whose summary has no place/food/culture/sensory reason to care;
- old template phrases such as `useful when`, `save by name`, `map pin`, and `not just another dot on a map`.

## Page-Type Copy Standard

| Page Type | Lead With | Then Support With |
| --- | --- | --- |
| City hub | What this city feels like and what the traveler can discover there | Names to know, food/place clusters, practice entry |
| Landmark/place | What it is and why the traveler would recognize or visit it | How to say/show it, ticket/photo/entrance only when relevant |
| Restaurant/cafe | Taste, vibe, dish/drink reason, and why to save the name | Table, menu, order, bill, pickup |
| Dish | What it tastes like, where it appears, and how to order it | Ingredients, spice/sauce/ice/allergy adjustments |
| Market/street/neighborhood | What the traveler can browse, eat, buy, or use for orientation | Saved place, cross street, price, meeting point |
| Transit | Arrival confidence and orientation | Terminal, luggage, ticket, pickup; practical language can be the lead here |

## Current Validation Snapshot

- `node native-ios/scripts/build-viet-city-copy-review-report.js`
  - `approved: 500`
  - `fixNow: 0`
- `node native-ios/scripts/audit-viet-city-audience-fit.js`
  - `Audience fit OK: 5 city hubs plus All Vietnam, 500 city noun/place pages`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
  - regenerated `native-ios/Resources/viet-authored-listing-pages.json`
- `node native-ios/scripts/validate-viet-city-copy.js`
  - `Validated city production copy: 5 hubs, 500 city noun pages, 500 unique target heroes`
- `node native-ios/scripts/validate-viet-city-library.js`
  - `City library OK: 807 pages, 707 beginner, 95 intermediate, 5 advanced`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `ok: true`
  - `cities: 5`
  - `cityPlaces: 500`
  - `cityPhraseTags: 807`
- `node scripts/practice/generate-viet-practice-deck.js --check`
  - `Practice deck check OK: 8267 items, 18 scenarios, 8 question types`
- `node scripts/guard-native-only.js`
  - `Native-only guard passed: no active Expo/React Native app surface found.`
- `git diff --check`
  - passed
