# Hanoi 051-075 Humanizer Report

Date: 2026-05-26
Worker: H3
Output chunk: `chunks/hanoi_051_075_humanized.json`

## Scope

Rewrote the 25 Hanoi source entries numbered 051-075 in `target-ranges.md` as complete city-library source entries. Existing repo and source files were not edited.

Inputs read:
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/target-ranges.md`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js`
- ChatGPT batch handoffs 036, 037, 038, and 039

## Changed Themes

- Replaced repeated source scaffolding with page-specific traveler moments: station handoffs, coffee pauses, temple pace, pho ordering, night walking, and river viewing.
- Kept visible copy under the voice gate: no command-start headings, no app-internal wording, no database/process vocabulary, and no paragraphs over 45 words.
- Preserved stable source substance while avoiding volatile claims about hours, prices, access rules, current menus, terminal pickup zones, current route bays, service timing, or venue status.
- Retained practical travel judgment for transport pages: ticket checks, pickup clarity, bag handling, station names, and departure margin.
- Differentiated the pho/dish cluster with table behavior and texture rather than repeated generic restaurant copy.
- Added `sourceMode: "expanded-detail"` to every rewritten entry in this chunk.

## Revise Pages

No pages are marked for revision in this humanizer chunk. All 25 entries are marked `ready_for_integrity_review`.

Integrity review should still check:
- Whether the downstream importer expects the legacy six-section set or only the five required section IDs.
- Whether `sourceMode: "expanded-detail"` should be retained for every humanized entry or only entries that already had it upstream.
- Whether place-name audio should remain hidden unless manifest-ready.
- Whether Unicode punctuation and Vietnamese accents need a normalization pass during source promotion.

## Phrase And Audio Risks

- The original Hanoi 051-075 source entries had no `quick-say.phraseIDs` arrays, so no phrase IDs were invented.
- V2.2 phrase/audio mapping still needs a separate pass for traveler-action phrase cards if these entries are promoted beyond city-library source shape.
- Place-name audio should only render when the audio manifest confirms ready audio.
- Food and venue pages should avoid adding dish-specific spoken lines unless matching reusable audio already exists or a new audio item is explicitly queued.

## Freshness Risks

- Transport: My Dinh, Nuoc Ngam, and Noi Bai keep traveler-facing cautions for pickup points, route or bay flow, terminal rules, signage, and access.
- Worship/cultural sites: Ngoc Son, One Pillar, Quan Thanh, St. Joseph's Cathedral, Vietnam National Museum of History, and the Opera House keep hours, entry, photo expectations, services, events, and restoration notices flexible.
- Food and drink: Nang Cafe, Pho Bat Dan, Pho Bo Lam, Pho Gia Truyen, Ta Hien, Nguyen Huu Huan Street, and street-food pages keep venue/menu/status or price details flexible.
- Outdoor and market pages: Old Quarter routes, Phan Dinh Phung, Quang Ba Flower Market, Red River, and night-market walking keep street works, crowd control, access, safety, and market timing flexible.

## Validation

Completed after file write:
- JSON parse passed with `node`.
- Entry count equals 25.
- Page IDs match `target-ranges.md` order for Hanoi 051-075.
- No source phrase IDs were present for this range; none were added.
- Shared validator status for this chunk: `pass`, `errors: 0`, `warnings: 0`.
- The overall shared validator command currently passes across all chunks: `entries=200`, `warnings=0`.
