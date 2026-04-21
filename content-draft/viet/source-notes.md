# Viet v2 Source Notes

- The first real Viet v2 pass keeps the old audio-backed starter phrases where they were still useful, then expands coverage across the new 18-category backbone.
- Scenario remains the runtime category container because the app shell, routes, premium cards, and website preview contract are still scenario-shaped.
- Intent families are authored in `phrase-source.csv` via `family_id`, `family_title`, and fixed variant roles.
- The relation-ready companion surfaces are `relation-sample-v1.json` and `relation-authoring-notes.md`.
- `phrase-source.csv` now uses lightweight `relation-sample=...` markers in the existing `notes` field for the bounded Viet relation sample only.
- `say-first` is the visible entry that counts toward starter/full entry totals.
- `more-polite`, `clearer`, and `also-common` stay compact and only appear when they materially change the traveler outcome.
- Emergency, pharmacy, and understanding/repair basics stay in starter access by design.
- Premium is being authored as Continue + Recover depth inside the same categories, not just as extra categories.
- Prepared premium expansion lanes may stay translation-empty and separate under `premium-expansion/` until a deliberate promotion pass is ready.
- The current relation sample maps `29` family clusters across arrival, greeting, transport, food, money, hotel, phone, and repair moments so frontend/runtime work can start from a concrete listing/detail handoff instead of a small schema demo.

## Current live boundary reminder

- `150` starter visible entries
- `750` premium visible entries
- `900` total visible entries
- `919` approved raw phrase rows
- `919` approved rows currently marked `audio_status=ready`

## Relation-ready authoring rule

- Keep phrase text, access, and variant-role truth in `phrase-source.csv`.
- Use the `notes` field only for lightweight relation markers such as `relation-sample=viet-hotel-check-in:anchor` or `relation-sample=viet-repair-slower:variant:more-polite`.
- Keep `you may hear` and `possible traveler response` language advisory-only in the sidecar and docs.
- Put family-to-family edges, likely-reply guidance, and next-step / repair guidance in `relation-sample-v1.json`, not in ad hoc prose.
