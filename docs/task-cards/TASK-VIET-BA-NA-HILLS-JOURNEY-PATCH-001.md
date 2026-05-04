# TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001

## Task Done

The Bà Nà Hills listing page reads and renders like a day-trip journey page for a first-time traveler, using an exact editorial patch contract instead of generated rewrite logic. The page must no longer feel like a generic place article with editorial notes leaking into user-facing copy.

## Context

This task follows the ChatGPT/Jojo editorial review of the current Bà Nà Hills listing screenshots. The current implementation is directionally right but not production-ready: it still shows article-like section flow, generic/meta copy, weak row priority, and missing renderer proof.

The larger process correction is the important part:

- The repo remains source of truth.
- CSV/XLSX/JSON review files are staging surfaces.
- Content workers should import exact approved patch rows and add validators.
- Scripts may import, validate, reorder, and flag issues.
- Scripts must not author final listing copy or make broad generative rewrites.

Existing editorial infrastructure:

- `docs/editorial-exports/viet-canonical-pages/latest/import-contract.md`
- `docs/editorial-exports/viet-canonical-pages/chatgpt-pilot-2026-05-03/`
- `native-ios/scripts/import-viet-editorial-pilot.js`
- `native-ios/scripts/validate-viet-editorial-ready-import.js`
- `native-ios/scripts/validate-viet-editorial-model-support.js`
- `docs/task-results/TASK-VIET-EDITORIAL-READY-IMPORT-001.md`

If Jojo has dropped a newer Bà Nà Hills v2 workbook/CSV/JSON patch into the repo or local project folder, use it as the preferred import contract. If it is not present, create a task-owned structured patch contract from the requirements below, under `docs/editorial-exports/viet-canonical-pages/ba-na-hills-journey-v2/`.

## Worker Judgment

This is a page-specific editorial patch pilot, not a new universal authoring generator. Make the import contract deterministic and auditable. If a requirement needs native Swift renderer work, do not fake it in content; document the gap and create a precise follow-up task recommendation for Native UI.

## Required Outcome

For page `viet-phrase-city-danang-place-ba-na-hills`, implement the approved journey-flow direction:

- Use a Bà Nà Hills-specific hero image or page/image metadata. Acceptable visual direction: Golden Bridge, cable car/mountains, Bà Nà Hills entrance, or misty mountain attraction scene. Do not use the generic Ha Long Bay boat/karst image for this page.
- Required page order:
  1. Hero
  2. At a glance
  3. Quick say
  4. Journey flow
  5. Key phrases
  6. Good to know
  7. Explore next
- Move the journey flow near the top. The user should see the day-trip steps before lower-priority explanatory article sections.
- Replace the current `At a glance` copy exactly with:
  `Treat Bà Nà Hills as a day-trip flow, not just a place name. The useful moments are pickup, tickets, cable car, photos, food or drinks, and the return ride.`
- Use practical `Quick say` copy such as:
  `Use this at the ticket counter or when asking staff for help.`
- Prioritize this primary quick-say phrase if canonical support exists or can be source-owned safely:
  `Dạ, cho tôi hai vé lên Bà Nà Hills.` / `Two tickets to Bà Nà Hills, please.`
- Render journey flow as steps, not a paragraph-only article blob:
  `Pickup`, `Tickets`, `Cable car`, `Photos`, `Food/drinks`, `Return ride`.
- Remove slash-separated key phrase text. Key phrases must render as standard app rows: speaker/play affordance on the left when audio exists, Vietnamese + English copy, chevron on the right when the row opens a canonical listing page.
- Prioritize visible key phrase rows:
  - `Đi Bà Nà Hills` — `Go to Bà Nà Hills`
  - `Dạ, cho tôi hai vé lên Bà Nà Hills.` — `Two tickets to Bà Nà Hills, please.`
  - `Cáp treo ở đâu?` — `Where is the cable car?`
  - `Bạn chụp giúp tôi được không?` — `Can you take a photo for me?`
  - `Gọi giúp tôi taxi được không?` — `Can you call me a taxi?`
- Demote `ATM near Bà Nà Hills` and `Eat near Bà Nà Hills`. They can remain related rows, but they must not be the first relationship rows for this journey page.
- Replace current `Good to know` copy exactly with:
  `Ticket rules, hours, and pickup details can change. Keep your ticket or booking screen visible, and confirm where your return ride will meet you.`
- Replace current `Explore next` copy exactly with:
  `Practice the next phrases for getting there, finding the cable car, asking for photos, buying food or drinks, and getting back.`
- Remove user-facing editorial/meta language such as:
  - `This is not a single place-name card`
  - `Keep the page focused`
  - `Connect to:`
  - database/import phrasing
- Preserve canonical page IDs and existing canonical Vietnamese titles unless there is already explicit source support and validator coverage.

## Boundaries

- Do not create a broad generator that rewrites all listing pages.
- Do not use runtime AI or generate new copy beyond the exact approved Bà Nà Hills patch contract.
- Do not import rows still marked `REVIEW_ONLY` unless this task creates an explicit Jojo-approved overlay for this exact page.
- Do not generate audio files.
- Do not edit `native-ios/App/**` unless you first prove the renderer requirement cannot be satisfied through source/generator/resource data and you keep the Swift change tightly scoped to listing-page rendering.
- Do not edit signing/project files.

## Validation

- Add or update a task-owned patch/import contract proving the Bà Nà Hills page is driven by exact approved rows.
- Dry-run the import and prove only the Bà Nà Hills patch rows apply.
- Regenerate the Viet catalog, authored pages, SQLite fixture, page audits, and practice deck if needed.
- Run the relevant existing validators plus any new task validator:
  - `node native-ios/scripts/validate-viet-sqlite-fixture.js`
  - `node native-ios/scripts/audit-viet-canonical-content.js --check`
  - `node native-ios/scripts/audit-viet-page-quality.js`
  - `node native-ios/scripts/validate-tier-one-listing-pages.js`
  - editorial import/model validators touched by this task
  - `node scripts/practice/generate-viet-practice-deck.js --check`
  - `git diff --check`
- Prove the final page does not contain editorial/meta wording or slash-separated key phrase text.
- Capture or produce a Jojo-readable page preview/screenshot artifact if native/simulator proof is practical.
- One focused read-only peer review: check traveler usefulness, exact patch adherence, row priority, page-kind fit, and no broad generator slop.

## Result Contract

Write `docs/task-results/TASK-VIET-BA-NA-HILLS-JOURNEY-PATCH-001.md` with:

- commit hash;
- whether a Jojo/ChatGPT v2 patch file was found or recreated from this task card;
- exact patch rows/sections imported;
- page order proof;
- key phrase row priority proof;
- meta-wording/slash-text scan result;
- hero image handling;
- audio-missing handling decision;
- whether any Native UI follow-up is required for safe-area or disabled-audio rendering;
- validation results;
- reviewer outcome;
- final `git status --short`.
