# Viet City Pages Cleanup Audit - 2026-05-18

## Scope

This pass cleaned the existing city page inventory. It did not add another batch of city listings.

- Source: `content-draft/viet/city-library/v1.json`
- Runtime: `native-ios/Resources/viet-authored-listing-pages.json`
- Cities: Da Nang, Hanoi, Ho Chi Minh City, Hoi An, Hue
- Approved city noun pages: 500 total, 100 per city
- Unique city noun hero targets: 500

## What Changed

The useful work to keep is the 500 existing city noun pages and the 500 unique city-place hero assets. The part to remove from the traveler-facing experience was the formulaic/repeated copy pattern that came from the earlier image/copy production pass.

The earlier bad state had 500 noun pages and 500 hero references, but 461 pages still contained formula fragments such as "shown here", "English meaning to keep in mind", or "Play the name first". The follow-up city-copy lane removed those obvious fragments, but the rendered city noun pages still repeated visible sentences across Summary, About, Hear the name, and Good to know.

This cleanup keeps the inventory and image wiring, changes the production-copy pass to build a distinct summary, removes exact repeated visible sentences inside each city noun page, and regenerates the native resource and SQLite fixture from the cleaned source.

The review gate blocked the first cleanup because it still sounded templated. The follow-up pass removed the repeated quick-say scaffolding phrases from source and runtime copy:

- `Keep the name ready for this job`
- `Keep this in mind`
- `Keep that job in mind`
- `After the name lands`
- `then keep the questions concrete`
- visible `noun` / `nouns`
- `name to keep ready`

## Current Checks

- `node native-ios/scripts/validate-viet-city-copy.js`
  - `Validated city production copy: 5 hubs, 500 city noun pages, 500 unique target heroes`
- `node native-ios/scripts/validate-viet-city-library.js`
  - `City library OK: 807 pages, 707 beginner, 95 intermediate, 5 advanced`
- `node native-ios/scripts/validate-viet-hero-image-assets.js --require-unique-city-place-assets`
  - `approved city-library places checked: 500`
  - `active premium hero assets checked: 524`
  - `Viet hero image asset validation passed`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `cityPlaces: 500`
  - `cityPhraseTags: 807`
  - `bannedFileMatches: 0`

## Guardrails Added

The city-copy validator now fails if a city noun page repeats the same visible sentence across its summary and editorial sections. It also bans the internal phrase "image-led tile" from visible city copy.

The validator also bans the review-blocked template phrases listed above, so the cleanup cannot silently regress back into that voice.
