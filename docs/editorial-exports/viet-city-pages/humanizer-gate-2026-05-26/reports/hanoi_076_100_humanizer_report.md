# Hanoi 076-100 Humanizer Report

Worker: H4  
Date: 2026-05-26  
Output chunk: `chunks/hanoi_076_100_humanized.json`

## Changed Themes

- Reworked the range from generated city-library scaffolding into observed traveler moments: dinner rhythm, lake edge, courtyard sequence, cafe ritual, park reset, safety edge, indoor break, performance night, museum fatigue, and handheld breakfast.
- Restored humanized `when-to-use` sections for every source entry in this slice that carried one, without reusing the old mechanical scaffold.
- Removed repeated legacy headings such as `Why go`, `What you'll get`, `Worth it if`, and command-like first-screen language.
- Replaced internal status wording with traveler-facing cautions around access, tickets, schedules, weather, safety, and route planning.
- Avoided unstable claims about hours, prices, ticketing, access, payment, tenants, schedules, vendor status, routes, and menu details.
- Preserved source phrase IDs exactly. Only `city-hanoi-place-the-note-coffee` carried source phrase IDs in this slice, and those remain unchanged.
- Kept each visible paragraph under 45 words and removed banned internal fragments from the chunk.

## Revise Pages

- `city-hanoi-place-vietnam-military-history-museum` is marked `revise_for_integrity`. The copy is voice-clean, with museum routing and exhibit specifics left out of the visible promise.

All other pages are marked `ready_for_integrity_review`, not production approved. Integrity review should still verify source fit, downstream mapping, and rendered behavior before promotion.

## Phrase / Audio Risks

- Most source entries in Hanoi 076-100 do not currently expose `quick-say.phraseIDs`; no new phrase IDs were invented.
- `city-hanoi-place-the-note-coffee` preserves the exact source IDs: `coffee-1`, `coffee-4`, `coffee-6`, `coffee-7`.
- ChatGPT batch drafts suggested stronger playable phrase cards for many pages, but those were not used because the worker contract required preserving source phrase IDs exactly.
- Place-name audio readiness from the draft handoffs remains uneven. Treat planned place-name audio as a downstream integrity concern rather than visible copy proof.

## Source / Freshness Risks To Check Later

- Same-week access/safety review: `city-hanoi-place-train-street`.
- Restaurant/menu/booking review: `city-hanoi-place-tam-vi`, `city-hanoi-place-udam`.
- Tenant/payment/access review: `city-hanoi-place-trang-tien-plaza`.
- Schedule/ticket/photo-policy review: `city-hanoi-place-vietnam-circus`, `city-hanoi-place-vietnam-national-tuong-theatre`, `city-hanoi-place-water-puppet-theatre`.
- Museum operations/photo/interpretation review: `city-hanoi-place-vietnam-art-gallery`, `city-hanoi-place-vietnam-fine-arts-museum`, `city-hanoi-place-vietnam-military-history-museum`, `city-hanoi-place-womens-museum`.
- Market and park access/timing review: `city-hanoi-place-weekend-night-market`, `city-hanoi-place-thong-nhat-park`, `city-hanoi-place-yen-so-park`.

## Validation

- Ran: `node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true`.
- Result for `hanoi_076_100_humanized.json`: pass, 25 entries, 0 errors, 0 warnings.
- Global validator result at run time: passed, 200 entries, 0 warnings.
