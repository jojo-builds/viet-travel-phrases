# Hanoi 051-100 Post-Repair Integrity Review

Date: 2026-05-26
Reviewer: Codex read-only final post-repair integrity + humanizer reviewer
Scope: Hanoi entries 051-100 only
Output decision set: `pass_integrity_review`, `revise_voice`, `revise_preservation`, `blocked_source_too_thin`

## Import Safety Summary

safe_for_import_count: 47
unsafe_for_import_count: 3

This is not a production-ready approval. It is only the post-repair no-deletion / no-bloat / humanizer integrity gate for Codex import into production-candidate source.

## Checks Performed

- Read the assigned integrity prompt, shared validator report, current city-page standard, production review gate, Hanoi handwritten source, both scoped humanized chunks, and the previous Hanoi 051-100 final integrity review.
- Confirmed the shared chunk validator reports `pass` for `hanoi_051_075_humanized.json` and `hanoi_076_100_humanized.json`: 25 entries each, 0 errors, 0 warnings.
- Recompared all 50 scoped pages against `content-draft/viet/city-library/handwritten-copy/hanoi.json`.
- Confirmed phrase IDs are preserved exactly across the scope. No page without source phrase IDs gained phrase IDs. `city-hanoi-place-the-note-coffee` still preserves `coffee-1`, `coffee-4`, `coffee-6`, and `coffee-7`.
- Confirmed the previously unsafe `city-hanoi-place-vietnam-military-history-museum` repair restored the Flag Tower / outdoor display anchor in summary, context, and visible sections without adding unstable access, exhibit, ticket, or hour claims.
- Reviewed all fields and sections for deletion, phrase-card bloat, visible editor language, generic travel blur, repeated heading rhythm, awkward padding, and recently lengthened summary drift.

## Per-Page Decisions

| # | Page ID | Decision | Import safety | Notes / snippets |
|---:|---|---|---|---|
| 051 | `city-hanoi-place-my-dinh-bus-station` | `pass_integrity_review` | Safe | Preserves station role, route/bay/pickup caution, luggage pressure, and Vietnamese station name. |
| 052 | `city-hanoi-place-nang-cafe` | `pass_integrity_review` | Safe | Keeps a concrete coffee pause with iced milk / iced black contrast and no unstable branch or seating promises. |
| 053 | `city-hanoi-place-national-museum-history` | `pass_integrity_review` | Safe | Keeps museum pacing, objects, ochre building, and flexible ticket/photo/access language. |
| 054 | `city-hanoi-place-nem-cua-be` | `pass_integrity_review` | Safe | Keeps square crab-roll identity, herbs, dip, richness, and shellfish caution. |
| 055 | `city-hanoi-place-ngoc-son-temple` | `pass_integrity_review` | Safe | Preserves red bridge, lake island, incense, sacred-space etiquette, and local name. |
| 056 | `city-hanoi-place-nguyen-huu-huan-street` | `pass_integrity_review` | Safe | Keeps coffee-street role and Cà phê Giảng as one anchor without making one shop the whole page. |
| 057 | `city-hanoi-place-night-market-walk` | `pass_integrity_review` | Safe | Keeps Old Quarter night walk, stalls, snack smoke, small-purchase behavior, and flexible market rhythm. |
| 058 | `city-hanoi-place-noi-bai-airport` | `pass_integrity_review` | Safe | Preserves arrival threshold, bags/signs/ride pickup, and avoids unstable pickup-zone specifics. |
| 059 | `city-hanoi-place-nuoc-ngam-bus-station` | `pass_integrity_review` | Safe | Keeps onward station behavior, route/bay/ticket caution, and Vietnamese station name. |
| 060 | `city-hanoi-place-old-quarter` | `pass_integrity_review` | Safe | Keeps tight lanes, scooters, stools, coffee rooms, crossings, and route flexibility. |
| 061 | `city-hanoi-place-old-quarter-walking-tour` | `pass_integrity_review` | Safe | Preserves loose-route planning without turning into a fixed itinerary or hollow walking copy. |
| 062 | `city-hanoi-place-one-pillar-pagoda` | `pass_integrity_review` | Safe | Keeps raised structure, pond, courtyard, Ba Đình pairing, and quiet/photo etiquette. |
| 063 | `city-hanoi-place-opera-house` | `pass_integrity_review` | Safe | Preserves facade, square, performance possibility, and current-program caution. |
| 064 | `city-hanoi-place-phan-dinh-phung-street` | `pass_integrity_review` | Safe | Keeps tree shade, villa facades, bikes, Ba Đình / Citadel pairing, and sidewalk caution. |
| 065 | `city-hanoi-place-pho-bat-dan` | `pass_integrity_review` | Safe | Keeps named pho stop, broth/herbs/table rhythm, and avoids volatile line/menu/payment claims. |
| 066 | `city-hanoi-place-pho-bo` | `pass_integrity_review` | Safe | Keeps beef pho role, broth/noodles/beef/herbs, and useful `tái` / `chín` distinction. |
| 067 | `city-hanoi-place-pho-bo-lam` | `pass_integrity_review` | Safe | Keeps named pho stop and tendon texture without overclaiming guide status, hours, or menu. |
| 068 | `city-hanoi-place-pho-ga` | `pass_integrity_review` | Safe | Keeps chicken pho as the lighter lane and avoids unstable restaurant examples. |
| 069 | `city-hanoi-place-pho-gia-truyen` | `pass_integrity_review` | Safe | Keeps counter-meal pace, broth/beef/herbs, and flexible venue status. |
| 070 | `city-hanoi-place-quan-thanh-temple` | `pass_integrity_review` | Safe | Preserves worship-space quality, gate/courtyard/incense/shade, and West Lake / Trúc Bạch fit. |
| 071 | `city-hanoi-place-quang-ba-flower-market` | `pass_integrity_review` | Safe | Keeps early working-market reality, wet pavement, scooters, vendors, and etiquette. |
| 072 | `city-hanoi-place-red-river` | `pass_integrity_review` | Safe | Preserves river/bridge/bank scene, Long Bien orientation, and access/footing caution. |
| 073 | `city-hanoi-place-st-joseph-cathedral` | `pass_integrity_review` | Safe | Keeps cathedral square, stone/cafes/scooters, worship access caution, and local name. |
| 074 | `city-hanoi-place-street-food-walk` | `revise_voice` | Unsafe | Visible section copy still says: `Vendor mix, exact routes, prices, and opening patterns need late review before any specific route is promoted.` This is editor/process language, not traveler-facing copy. |
| 075 | `city-hanoi-place-ta-hien` | `pass_integrity_review` | Safe | Keeps low stools, bia hơi/nightlife lane, price-check caution, and crowd-control flexibility. |
| 076 | `city-hanoi-place-tam-vi` | `pass_integrity_review` | Safe | Preserves shared northern meal, warm wood, rice, table dishes, booking/allergy questions, and avoids menu specifics. |
| 077 | `city-hanoi-place-tay-ho` | `pass_integrity_review` | Safe | Keeps lake-side neighborhood role, cafe/lane/shoreline choices, heat, and exit caution. |
| 078 | `city-hanoi-place-temple-literature` | `pass_integrity_review` | Safe | Preserves gates, courtyards, steles, shade, red-painted wood, and quiet visitor behavior. |
| 079 | `city-hanoi-place-the-note-coffee` | `pass_integrity_review` | Safe | Preserves source phrase IDs exactly and keeps the drink/stairs/notes ritual without phrase-card bloat. |
| 080 | `city-hanoi-place-thong-nhat-park` | `pass_integrity_review` | Safe | Keeps park reset, paths/trees/lake/walkers/families, and heat/weather practicality. |
| 081 | `city-hanoi-place-train-street` | `pass_integrity_review` | Safe | Keeps narrow rail corridor and access-safety caution without inventing current access rules. |
| 082 | `city-hanoi-place-tran-quoc-pagoda` | `pass_integrity_review` | Safe | Preserves lake-edge approach, red tower, sacred-site etiquette, and West Lake / Trúc Bạch pairing. |
| 083 | `city-hanoi-place-trang-tien-plaza` | `pass_integrity_review` | Safe | Keeps polished indoor pause, central facade, meeting/weather-break function, and avoids tenant claims. |
| 084 | `city-hanoi-place-trang-tien-street` | `pass_integrity_review` | Safe | Keeps trees, shopfronts, book edges, crossings, and French Quarter line. |
| 085 | `city-hanoi-place-trieu-viet-vuong-coffee-street` | `pass_integrity_review` | Safe | Keeps coffee-street comparison moment, shade/table/fan details, and avoids claiming a specific best cafe. |
| 086 | `city-hanoi-place-truc-bach-lake` | `pass_integrity_review` | Safe | Keeps quieter lake edge, curb-side water, small tables, cafe pause, and West Lake / pagoda pairing. |
| 087 | `city-hanoi-place-turtle-tower` | `pass_integrity_review` | Safe | Preserves lake-view-only nature, reflections/trees/old-center traffic, and no false entry plan. |
| 088 | `city-hanoi-place-udam` | `pass_integrity_review` | Safe | Keeps vegetarian restaurant role, herbs/warm bowls/sauces, table balance, spice caution, and no unstable menu claims. |
| 089 | `city-hanoi-place-vietnam-art-gallery` | `revise_voice` | Unsafe | Importable `context` field still says: `The source is thin, so this entry avoids exhibition, artist, photo-policy, or opening-status claims.` That exposes source/review language in app-copy-shaped content. |
| 090 | `city-hanoi-place-vietnam-circus` | `pass_integrity_review` | Safe | Preserves evening performance venue, stage light/families/entrance, and ticket/performance-plan caution. |
| 091 | `city-hanoi-place-vietnam-fine-arts-museum` | `pass_integrity_review` | Safe | Keeps courtyard, galleries, lacquer/silk/sculpture/folk forms, and avoids exhaustive museum claims. |
| 092 | `city-hanoi-place-vietnam-military-history-museum` | `pass_integrity_review` | Safe | Post-repair copy restores the Flag Tower / outdoor display anchor and keeps exhibit, ticket, hour, and routing claims flexible. |
| 093 | `city-hanoi-place-vietnam-national-tuong-theatre` | `pass_integrity_review` | Safe | Keeps masks, red curtain, music, symbolic movement, tickets/seats caution, and no unsupported show schedule. |
| 094 | `city-hanoi-place-water-puppet-theatre` | `pass_integrity_review` | Safe | Keeps Hoàn Kiếm theatre setting, water puppets, live music, entrance timing, and phone/photo caution. |
| 095 | `city-hanoi-place-weekend-night-market` | `pass_integrity_review` | Safe | Preserves Old Quarter market shift, stalls/food smoke/warm lights, crowd and phone caution. |
| 096 | `city-hanoi-place-west-lake` | `pass_integrity_review` | Safe | Keeps wide lake horizon, cafe edges, temple silhouettes, weather, and one-edge planning. |
| 097 | `city-hanoi-place-west-lake-loop` | `pass_integrity_review` | Safe | Keeps route/loop identity, scooters/shoreline/sidewalk gaps, and short-section advice. |
| 098 | `city-hanoi-place-womens-museum` | `pass_integrity_review` | Safe | Keeps clothing, family life, wartime memory, everyday labor, objects, and post-visit breathing room. |
| 099 | `city-hanoi-place-xoi-xeo` | `pass_integrity_review` | Safe | Keeps yellow sticky rice, mung bean, fried shallots, breakfast rhythm, and topping/order caution. |
| 100 | `city-hanoi-place-yen-so-park` | `revise_voice` | Unsafe | Importable `context` field still says: `The source is sparse and access can vary, so this entry centers durable park behavior, weather, and exit planning.` This is editor-facing explanation rather than traveler copy. |

## Required Revisions Before Import

### `city-hanoi-place-street-food-walk`

Decision: `revise_voice`

Unsafe for Codex import into production-candidate source until fixed.

Exact issue:

- `good-to-know` body says: `Vendor mix, exact routes, prices, and opening patterns need late review before any specific route is promoted.`

Why it blocks import:

- The line exposes review/process language in visible section copy. The underlying caution is valid, but it needs to read as traveler-facing flexibility rather than an editor note.

### `city-hanoi-place-vietnam-art-gallery`

Decision: `revise_voice`

Unsafe for Codex import into production-candidate source until fixed.

Exact issue:

- `context` says: `The source is thin, so this entry avoids exhibition, artist, photo-policy, or opening-status claims.`

Why it blocks import:

- The field names `source` and the explanation of avoided claims belong in QA notes, not importable app-copy-shaped content.

### `city-hanoi-place-yen-so-park`

Decision: `revise_voice`

Unsafe for Codex import into production-candidate source until fixed.

Exact issue:

- `context` says: `The source is sparse and access can vary, so this entry centers durable park behavior, weather, and exit planning.`

Why it blocks import:

- The line exposes source-quality commentary in a traveler-copy field. The practical warning is recoverable, but the wording is not safe for import.

## Post-Repair Result For Previously Unsafe ID

`city-hanoi-place-vietnam-military-history-museum` now passes this integrity gate. The repaired copy restores the source-specific Flag Tower / outdoor display detail in the first screen and sections, and it does not invent unstable current exhibit, access, ticket, route, or hour claims.

## Safe To Import

The 47 pages marked `pass_integrity_review` are safe for Codex import into production-candidate source from this integrity gate only.

## Blocked From Import

- `city-hanoi-place-street-food-walk` — unsafe until visible review/process language is rewritten as traveler-facing copy.
- `city-hanoi-place-vietnam-art-gallery` — unsafe until `source is thin` language is removed from the importable copy field.
- `city-hanoi-place-yen-so-park` — unsafe until `source is sparse` language is removed from the importable copy field.

No pages were classified `revise_preservation`.

No pages were classified `blocked_source_too_thin`.
