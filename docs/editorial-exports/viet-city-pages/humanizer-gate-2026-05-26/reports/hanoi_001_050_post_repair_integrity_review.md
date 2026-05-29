# Hanoi 001-050 Post-Repair Integrity Review

Date: 2026-05-26
Reviewer: Independent SpeakLocal city-page integrity + humanizer reviewer
Scope: Hanoi entries 001-050 only

This review does not call any page production-ready. It decides only whether each repaired humanized entry is safe or unsafe for Codex import into production-candidate source before later v2.2 mapping, render proof, screenshot review, and production review gates.

## Inputs Read

- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/INTEGRITY_REVIEWER_PROMPT.md`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/humanizer_chunk_validation.json`
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_001_025_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_026_050_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/hanoi_001_050_final_integrity_review.md`

## Summary Counts

safe_for_import_count: 50

| Decision | Count |
|---|---:|
| `pass_integrity_review` | 50 |
| `revise_voice` | 0 |
| `revise_preservation` | 0 |
| `blocked_source_too_thin` | 0 |

Safe for Codex import into production-candidate source: 50 pages.

Unsafe for Codex import into production-candidate source: 0 pages.

The chunk validator reports `entries=200`, `errors=0`, `warnings=0`, and both scoped Hanoi chunks pass. Manual post-repair review found all 50 Hanoi entries present in order. The repaired pages preserve the full source section-ID set and preserve exact source phraseIDs on the four phrase-card pages. No repaired page adds new phraseIDs, turns local-name prose into fake playable cards, or deletes the place-specific traveler moment to sound cleaner.

## Post-Repair Findings

The nine pages previously blocked for visible editor/review headings now read as traveler-facing copy:

- `city-hanoi-place-gia`: `Details Can Shift` is now a user-safe caution about menus, reservations, closures, and service format.
- `city-hanoi-place-hanoi-railway-station`: `Plain Transfer Choices` is now a traveler-facing station note.
- `city-hanoi-place-hibana-by-koki`: `Counter Time Needs Room` is now a natural dinner-pacing note.
- `city-hanoi-place-ho-chi-minh-mausoleum`: `Formal Space, Simple Plan` is now a user-facing behavior cue.
- `city-hanoi-place-ho-chi-minh-museum`: `Focused Museum Time` is now a natural visit-length cue.
- `city-hanoi-place-lam-cafe`: `The Room Leads` is now a calm cafe note.
- `city-hanoi-place-lamai-garden`: `Slow Start, Simple Plan` is now a traveler-facing dinner cue.
- `city-hanoi-place-literature-museum`: `Carry The Quiet Forward` is now a natural post-visit note.
- `city-hanoi-place-mien-luon-chan-cam`: `The Bowl Is Enough` is now a focused food-stop note.

No visible page copy in the 50-page scope now exposes `freshness`, `review`, `source`, `import`, `copy should`, `copy stays`, or similar editor-facing language. Internal chunk metadata still contains integrity-review labels and notes, but those are outside visible page fields.

## PhraseID Preservation

PhraseID preservation passed:

- `city-hanoi-place-bun-cha`: `food-menu`, `food-3`, `coffee-7`
- `city-hanoi-place-dinh-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
- `city-hanoi-place-giang-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
- `city-hanoi-place-loading-t-cafe`: `coffee-1`, `v500-dire-navi-do-i-go-upstairs`, `coffee-4`, `coffee-7`

## Per-Page Decision Table

| # | Page ID | Decision | Import Safety | Integrity Notes |
|---:|---|---|---|---|
| 001 | `city-hanoi-place-ba-dinh-district` | `pass_integrity_review` | safe | District/civic-neighborhood contrast is preserved; no hollow blur or phrase-card drift. |
| 002 | `city-hanoi-place-ba-dinh-square` | `pass_integrity_review` | safe | Formal civic-space copy stays specific and avoids unstable access claims. |
| 003 | `city-hanoi-place-banh-cuon` | `pass_integrity_review` | safe | Dish texture, sauce behavior, and morning role are intact. |
| 004 | `city-hanoi-place-bay-mau-lake` | `pass_integrity_review` | safe | Lake/park reset stays modest, with facilities kept out of claims. |
| 005 | `city-hanoi-place-bia-hoi` | `pass_integrity_review` | safe | Sidewalk beer scene is concrete without price or venue overclaiming. |
| 006 | `city-hanoi-place-botanical-garden` | `pass_integrity_review` | safe | Green pause near the formal city is preserved without padding. |
| 007 | `city-hanoi-place-bun-cha` | `pass_integrity_review` | safe | Table rhythm and exact phraseIDs are preserved. |
| 008 | `city-hanoi-place-bun-cha-huong-lien` | `pass_integrity_review` | safe | Fame is kept secondary to the meal; no unstable menu or hour claim. |
| 009 | `city-hanoi-place-bun-cha-ta` | `pass_integrity_review` | safe | Small-table bun cha specificity holds. |
| 010 | `city-hanoi-place-bun-thang` | `pass_integrity_review` | safe | Light-bowl role and ingredient caution remain useful. |
| 011 | `city-hanoi-place-ca-phe-sua-da` | `pass_integrity_review` | safe | Coffee ritual reads naturally; no visible editor language. |
| 012 | `city-hanoi-place-cha-ca` | `pass_integrity_review` | safe | Hot-pan fish ritual and sauce caution are preserved. |
| 013 | `city-hanoi-place-cha-ca-thang-long` | `pass_integrity_review` | safe | One-dish house rhythm stays clear and stable. |
| 014 | `city-hanoi-place-cho-buoi-market` | `pass_integrity_review` | safe | Plants, housewares, and local-market texture remain specific. |
| 015 | `city-hanoi-place-coffee-hop` | `pass_integrity_review` | safe | Route-of-pauses voice stays human and non-checklist-like. |
| 016 | `city-hanoi-place-cong-ca-phe-trieu-viet-vuong` | `pass_integrity_review` | safe | Branch page stays narrow and practical without current-menu claims. |
| 017 | `city-hanoi-place-cyclo-old-quarter` | `pass_integrity_review` | safe | Fare/route caution remains practical and non-numeric. |
| 018 | `city-hanoi-place-dinh-cafe` | `pass_integrity_review` | safe | Upstairs arrival sequence and exact phraseIDs are preserved. |
| 019 | `city-hanoi-place-dong-da` | `pass_integrity_review` | safe | Ordinary-district framing avoids brochure blur. |
| 020 | `city-hanoi-place-dong-xuan` | `pass_integrity_review` | safe | Working-market movement and aisle behavior remain concrete. |
| 021 | `city-hanoi-place-egg-coffee` | `pass_integrity_review` | safe | Drink specificity and slow-cup moment are preserved. |
| 022 | `city-hanoi-place-ethnology-museum` | `pass_integrity_review` | safe | Museum value is specific enough without ticket/hour claims. |
| 023 | `city-hanoi-place-french-quarter` | `pass_integrity_review` | safe | Area mood, scale shift, and walking role remain clear. |
| 024 | `city-hanoi-place-french-quarter-walk` | `pass_integrity_review` | safe | Walking-route copy avoids fixed route promises. |
| 025 | `city-hanoi-place-gia` | `pass_integrity_review` | safe | Previous review-language heading repaired; refined dinner mood and caution are intact. |
| 026 | `city-hanoi-place-gia-lam-station` | `pass_integrity_review` | safe | Thin transport source stays narrow; no invented route/platform details. |
| 027 | `city-hanoi-place-giang-cafe` | `pass_integrity_review` | safe | Narrow entrance, close tables, egg coffee, and exact phraseIDs are preserved. |
| 028 | `city-hanoi-place-giap-bat-bus-station` | `pass_integrity_review` | safe | Practical transfer behavior is clear without bloat. |
| 029 | `city-hanoi-place-hang-bac-street` | `pass_integrity_review` | safe | Silver-shop street thread is concrete. |
| 030 | `city-hanoi-place-hang-da-market` | `pass_integrity_review` | safe | Compact market browse and price rhythm are specific. |
| 031 | `city-hanoi-place-hang-gai-street` | `pass_integrity_review` | safe | Silk-window walking spine remains clear and stable. |
| 032 | `city-hanoi-place-hanoi-flag-tower` | `pass_integrity_review` | safe | Landmark scale, base, flag, and Ba Dinh context are preserved. |
| 033 | `city-hanoi-place-hanoi-railway-station` | `pass_integrity_review` | safe | Previous review-language heading repaired; station threshold and transfer behavior are intact. |
| 034 | `city-hanoi-place-hibana-by-koki` | `pass_integrity_review` | safe | Previous review-language heading repaired; counter dinner pacing stays human. |
| 035 | `city-hanoi-place-ho-chi-minh-mausoleum` | `pass_integrity_review` | safe | Previous review-language heading repaired; formal public-memory tone is preserved. |
| 036 | `city-hanoi-place-ho-chi-minh-museum` | `pass_integrity_review` | safe | Previous review-language heading repaired; focused museum cue reads naturally. |
| 037 | `city-hanoi-place-hoa-lo-prison` | `pass_integrity_review` | safe | Heavy-site tone is specific and not sensationalized. |
| 038 | `city-hanoi-place-hoan-kiem` | `pass_integrity_review` | safe | Lake, bridge, Turtle Tower, and reset role are preserved. |
| 039 | `city-hanoi-place-hom-market` | `pass_integrity_review` | safe | Fabric-market behavior and aisle movement remain concrete. |
| 040 | `city-hanoi-place-imperial-citadel` | `pass_integrity_review` | safe | Gates, courtyards, walls, and history-loop role are preserved. |
| 041 | `city-hanoi-place-lam-cafe` | `pass_integrity_review` | safe | Previous review-language heading repaired; old-cafe room note is natural. |
| 042 | `city-hanoi-place-lamai-garden` | `pass_integrity_review` | safe | Previous review-language heading repaired; garden-edge dinner cue is traveler-facing. |
| 043 | `city-hanoi-place-lenin-park` | `pass_integrity_review` | safe | Small open-air pause reads naturally and avoids facility claims. |
| 044 | `city-hanoi-place-literature-museum` | `pass_integrity_review` | safe | Previous review-language heading repaired; literary museum quiet stays specific. |
| 045 | `city-hanoi-place-loading-t-cafe` | `pass_integrity_review` | safe | Upstairs-room/cinnamon coffee details and exact phraseIDs are preserved. |
| 046 | `city-hanoi-place-long-bien-bridge` | `pass_integrity_review` | safe | Bridge, river, market edge, and access caution are vivid and stable. |
| 047 | `city-hanoi-place-long-bien-market` | `pass_integrity_review` | safe | Wholesale-market motion is preserved without romanticizing. |
| 048 | `city-hanoi-place-manzi-art-space` | `pass_integrity_review` | safe | Small art-space variability is expressed naturally; no current-show claim. |
| 049 | `city-hanoi-place-mien-luon` | `pass_integrity_review` | safe | Dish variation and texture are preserved. |
| 050 | `city-hanoi-place-mien-luon-chan-cam` | `pass_integrity_review` | safe | Previous review-language heading repaired; focused noodle-shop behavior is intact. |

## Safe For Codex Import Into Production-Candidate Source

All Hanoi entries 001-050 are safe for Codex import into production-candidate source:

`city-hanoi-place-ba-dinh-district`, `city-hanoi-place-ba-dinh-square`, `city-hanoi-place-banh-cuon`, `city-hanoi-place-bay-mau-lake`, `city-hanoi-place-bia-hoi`, `city-hanoi-place-botanical-garden`, `city-hanoi-place-bun-cha`, `city-hanoi-place-bun-cha-huong-lien`, `city-hanoi-place-bun-cha-ta`, `city-hanoi-place-bun-thang`, `city-hanoi-place-ca-phe-sua-da`, `city-hanoi-place-cha-ca`, `city-hanoi-place-cha-ca-thang-long`, `city-hanoi-place-cho-buoi-market`, `city-hanoi-place-coffee-hop`, `city-hanoi-place-cong-ca-phe-trieu-viet-vuong`, `city-hanoi-place-cyclo-old-quarter`, `city-hanoi-place-dinh-cafe`, `city-hanoi-place-dong-da`, `city-hanoi-place-dong-xuan`, `city-hanoi-place-egg-coffee`, `city-hanoi-place-ethnology-museum`, `city-hanoi-place-french-quarter`, `city-hanoi-place-french-quarter-walk`, `city-hanoi-place-gia`, `city-hanoi-place-gia-lam-station`, `city-hanoi-place-giang-cafe`, `city-hanoi-place-giap-bat-bus-station`, `city-hanoi-place-hang-bac-street`, `city-hanoi-place-hang-da-market`, `city-hanoi-place-hang-gai-street`, `city-hanoi-place-hanoi-flag-tower`, `city-hanoi-place-hanoi-railway-station`, `city-hanoi-place-hibana-by-koki`, `city-hanoi-place-ho-chi-minh-mausoleum`, `city-hanoi-place-ho-chi-minh-museum`, `city-hanoi-place-hoa-lo-prison`, `city-hanoi-place-hoan-kiem`, `city-hanoi-place-hom-market`, `city-hanoi-place-imperial-citadel`, `city-hanoi-place-lam-cafe`, `city-hanoi-place-lamai-garden`, `city-hanoi-place-lenin-park`, `city-hanoi-place-literature-museum`, `city-hanoi-place-loading-t-cafe`, `city-hanoi-place-long-bien-bridge`, `city-hanoi-place-long-bien-market`, `city-hanoi-place-manzi-art-space`, `city-hanoi-place-mien-luon`, `city-hanoi-place-mien-luon-chan-cam`

## Unsafe For Codex Import Into Production-Candidate Source

None.

## Final Import Safety

Hanoi 001-050 is safe for Codex import into production-candidate source: 50 safe, 0 unsafe.

Do not call any of these pages production-ready from this report alone. They still need the later v2.2 mapping, render proof, screenshot review, and production review gates before any production-ready claim.
