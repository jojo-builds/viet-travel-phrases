# Viet Relation Authoring Notes

## Purpose

This file explains the current bounded Viet relation-ready handoff.
It is a sidecar authoring seam for phrase-detail and listing work.
It does not replace the current scenario -> family -> phrase-row model.

## Current sample boundary

The current sample covers `29` family-primary clusters:

- arrival: `v500-airp-bord-arri-here-is-my-passport`, `v500-airp-bord-arri-here-is-my-visa`, `v500-airp-bord-arri-where-is-the-atm`
- greeting: `polite-hello`, `polite-acknowledge`
- transport: `transport-destination`, `transport-fare`, `transport-meter`, `transport-stop-here`
- food: `food-need-table`, `food-menu`, `food-not-spicy`, `food-bottled-water`, `food-pay-now`
- money: `money-how-much`, `money-final-price`
- hotel: `hotel-reservation`, `hotel-check-in`, `hotel-checkout-time`, `hotel-room-hot`, `hotel-aircon-broken`
- phone: `v500-phon-inte-powe-where-can-i-get-a-local-sim-card`, `v500-phon-inte-powe-my-map-is-not-working`
- repair: `repair-understand`, `repair-slower`, `repair-repeat`, `repair-number`, `repair-english-help`, `repair-write-down`

That keeps the sample concrete across arrival, greeting, transport, food, money, hotel, phone, and repair moments without pretending the whole Viet pack is relation-authored yet.

## Authoring surfaces

- `phrase-source.csv`
  Owns phrase text, pronunciation, access, variant role, context, and `you_may_hear`.
- `notes`
  The current pass keeps lightweight `relation-sample=...` markers in the existing `notes` field rather than adding a fragile JSON-in-CSV column.
- `relation-sample-v1.json`
  Owns family-level relation edges and phrase-detail guidance for the current sample.

## Membership marker format

Use one of these token shapes inside `notes`:
- `<clusterId>:anchor`
- `<clusterId>:variant:clearer`
- `<clusterId>:variant:more-polite`
- `<clusterId>:variant:also-common`

Examples:
- `relation-sample=viet-food-not-spicy:anchor`
- `relation-sample=viet-transport-stop-here:variant:clearer`
- `relation-sample=viet-repair-slower:variant:more-polite`
- `relation-sample=viet-repair-number:variant:also-common`

Keep the tokens boring and parseable. Do not turn the notes field into a mini graph database.

## Sidecar field rules

Inside `relation-sample-v1.json`:

- `shortestFormPhraseId`
  The shortest socially safe way to start the intent.
- `clearerFormPhraseId`
  Use only when an existing row genuinely adds disambiguation.
- `morePoliteFormPhraseId`
  Use only when an existing row genuinely adds service-safe or hierarchy-safe tone.
- `youMayHearSignals`
  Advisory only. These are hints or recurring response patterns, not promises.
- `possibleTravelerResponses`
  Advisory only. These are likely follow-up moves the traveler may need next.
- `familyRelations`
  Family-to-family edges for next-step, repair, likely-reply, or same-need navigation.

## Precedence rules

- Phrase text and access still come from `phrase-source.csv`.
- The generated pack remains runtime truth.
- The sidecar can add relation behavior but must not override phrase wording.
- If a sidecar edge points to a missing family or phrase id, fix the authored truth instead of patching around it in code.

## Current relation types

- `reply_to`
- `likely_answer_to`
- `next_step_after`
- `repair_for`
- `same_need_alt_context`
- `see_also`

## Authoring cautions

- Keep likely-reply language advisory-only.
- Do not imply that one reply is guaranteed.
- Prefer family-level links first. Only add row-level nuance when a family has a real clearer or more-polite variant worth naming.
- Keep the sample app-safe and website-safe. The current `29`-cluster pack is a starter-safe handoff, not a giant public graph dump or a claim that all `900` live Viet families are relation-authored.
- Keep new follow-on ideas outside this sample unless they are anchored to real approved Viet rows.
