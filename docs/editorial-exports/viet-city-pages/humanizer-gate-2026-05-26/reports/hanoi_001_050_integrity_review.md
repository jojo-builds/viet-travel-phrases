# Hanoi 001-050 Integrity Review

Date: 2026-05-26
Reviewer: Integrity Reviewer R2
Scope: Hanoi chunks 001-050 only. Hanoi 051-100 were not reviewed.

Read:
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/INTEGRITY_REVIEWER_PROMPT.md`
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `chunks/hanoi_001_025_humanized.json`
- `chunks/hanoi_026_050_humanized.json`
- `reports/hanoi_001_025_humanizer_report.md`
- `reports/hanoi_026_050_humanizer_report.md`

## Summary

Safe for import into production-candidate source: 24 pages.

Unsafe for import into production-candidate source: 26 pages.

No page is being called production-ready. This review only decides whether the rewritten source is safe to import into the production-candidate source for later V2.2 mapping, render proof, and production review.

PhraseID preservation passed for all pages with source phraseIDs: `city-hanoi-place-bun-cha`, `city-hanoi-place-dinh-cafe`, `city-hanoi-place-giang-cafe`, and `city-hanoi-place-loading-t-cafe`.

Current chunk validation state: `hanoi_001_025_humanized.json` and `hanoi_026_050_humanized.json` both report `status: pass`, `entries: 25`, `errors: 0`, `warnings: 0` in the aggregate validation report. The aggregate report still marks Hanoi 051-100 missing, which is outside this review scope.

H2 coordinator note: I found no current script-level errors in the scoped H2 chunk, but the manual mechanical pass still flags three visible voice/mechanical remnants in pages 030, 037, and 043.

## Per-Page Decision Table

| # | Page ID | Decision | Import | Integrity notes |
|---:|---|---|---|---|
| 001 | `city-hanoi-place-ba-dinh-district` | `revise_preservation` | unsafe | Voice is stronger and concrete, but source section `when-to-use` was deleted. |
| 002 | `city-hanoi-place-ba-dinh-square` | `revise_preservation` | unsafe | Good freshness caution and civic voice, but source section `when-to-use` was deleted. |
| 003 | `city-hanoi-place-banh-cuon` | `revise_preservation` | unsafe | Dish details preserved well, but source section `when-to-use` was deleted. |
| 004 | `city-hanoi-place-bay-mau-lake` | `revise_preservation` | unsafe | Lake/park moment is specific enough, but source section `when-to-use` was deleted. |
| 005 | `city-hanoi-place-bia-hoi` | `revise_preservation` | unsafe | Strong stool-height beer scene; source section `when-to-use` was deleted. |
| 006 | `city-hanoi-place-botanical-garden` | `revise_preservation` | unsafe | Green-pause framing works, but source section `when-to-use` was deleted. |
| 007 | `city-hanoi-place-bun-cha` | `pass_integrity_review` | safe | Details and quick-say phraseIDs preserved; no deletion found. |
| 008 | `city-hanoi-place-bun-cha-huong-lien` | `revise_preservation` | unsafe | Meal rhythm preserved, but source section `when-to-use` was deleted. |
| 009 | `city-hanoi-place-bun-cha-ta` | `revise_preservation` | unsafe | Copy stays dish-specific; source section `when-to-use` was deleted. |
| 010 | `city-hanoi-place-bun-thang` | `revise_preservation` | unsafe | Ingredient caution is useful, but source section `when-to-use` was deleted. |
| 011 | `city-hanoi-place-ca-phe-sua-da` | `revise_preservation` | unsafe | Coffee ritual is specific; source section `when-to-use` was deleted. |
| 012 | `city-hanoi-place-cha-ca` | `revise_preservation` | unsafe | Hot-pan ritual preserved, but source section `when-to-use` was deleted. |
| 013 | `city-hanoi-place-cha-ca-thang-long` | `revise_preservation` | unsafe | Restaurant-specific table motion works; source section `when-to-use` was deleted. |
| 014 | `city-hanoi-place-cho-buoi-market` | `revise_preservation` | unsafe | Market details preserved; source section `when-to-use` was deleted. |
| 015 | `city-hanoi-place-coffee-hop` | `revise_preservation` | unsafe | Route voice is good; source section `when-to-use` was deleted. |
| 016 | `city-hanoi-place-cong-ca-phe-trieu-viet-vuong` | `revise_preservation` | unsafe | Branch copy avoids unstable menu claims; source section `when-to-use` was deleted. |
| 017 | `city-hanoi-place-cyclo-old-quarter` | `revise_preservation` | unsafe | Fare/route caution is good; source section `when-to-use` was deleted. |
| 018 | `city-hanoi-place-dinh-cafe` | `pass_integrity_review` | safe | Physical arrival sequence and quick-say phraseIDs preserved; no deletion found. |
| 019 | `city-hanoi-place-dong-da` | `revise_preservation` | unsafe | Ordinary-district voice works; source section `when-to-use` was deleted. |
| 020 | `city-hanoi-place-dong-xuan` | `revise_preservation` | unsafe | Market movement preserved; source section `when-to-use` was deleted. |
| 021 | `city-hanoi-place-egg-coffee` | `revise_preservation` | unsafe | Drink specificity is strong; source section `when-to-use` was deleted. |
| 022 | `city-hanoi-place-ethnology-museum` | `revise_preservation` | unsafe | Museum framing is useful; source section `when-to-use` was deleted. |
| 023 | `city-hanoi-place-french-quarter` | `revise_preservation` | unsafe | Area mood is preserved; source section `when-to-use` was deleted. |
| 024 | `city-hanoi-place-french-quarter-walk` | `revise_preservation` | unsafe | Walking-route copy is non-generic; source section `when-to-use` was deleted. |
| 025 | `city-hanoi-place-gia` | `revise_preservation` | unsafe | Fine-dining freshness caution is good; source section `when-to-use` was deleted. |
| 026 | `city-hanoi-place-gia-lam-station` | `pass_integrity_review` | safe | Thin transport source stays narrow; no invented route or platform claim found. |
| 027 | `city-hanoi-place-giang-cafe` | `pass_integrity_review` | safe | PhraseIDs preserved exactly; narrow entrance, close tables, and hot egg coffee remain intact. |
| 028 | `city-hanoi-place-giap-bat-bus-station` | `pass_integrity_review` | safe | Practical transfer framing stays stable and non-promissory. |
| 029 | `city-hanoi-place-hang-bac-street` | `pass_integrity_review` | safe | Silver-shop street thread is preserved and specific. |
| 030 | `city-hanoi-place-hang-da-market` | `revise_voice` | unsafe | Remaining mechanical command opener in quick-say body: `Use it for signs, ride pins, and quick price questions around the market.` |
| 031 | `city-hanoi-place-hang-gai-street` | `pass_integrity_review` | safe | Silk-window walking-spine copy is concrete and stable. |
| 032 | `city-hanoi-place-hanoi-flag-tower` | `pass_integrity_review` | safe | Landmark details preserved; rules are kept as review risk, not visible claims. |
| 033 | `city-hanoi-place-hanoi-railway-station` | `pass_integrity_review` | safe | Station details preserved without invented access or schedule claims. |
| 034 | `city-hanoi-place-hibana-by-koki` | `pass_integrity_review` | safe | Counter/grill details come from source; no menu, booking, price, or hour claim added. |
| 035 | `city-hanoi-place-ho-chi-minh-mausoleum` | `pass_integrity_review` | safe | Formal civic tone preserved; rules are signposted as freshness risk. |
| 036 | `city-hanoi-place-ho-chi-minh-museum` | `pass_integrity_review` | safe | Museum pacing and indoor-context role are preserved. |
| 037 | `city-hanoi-place-hoa-lo-prison` | `revise_voice` | unsafe | Mostly strong, but remaining mechanical helper wording appears in heading: `A Quieter Next Stop Helps`. |
| 038 | `city-hanoi-place-hoan-kiem` | `pass_integrity_review` | safe | Lake details, red bridge, Turtle Tower, and reset role preserved without overclaiming. |
| 039 | `city-hanoi-place-hom-market` | `pass_integrity_review` | safe | Fabric-market behavior is concrete and not generic. |
| 040 | `city-hanoi-place-imperial-citadel` | `pass_integrity_review` | safe | Gates, courtyards, walls, and history-loop context are preserved without ticket/hour claims. |
| 041 | `city-hanoi-place-lam-cafe` | `pass_integrity_review` | safe | Old coffee-room voice is specific; no unstable menu claim added. |
| 042 | `city-hanoi-place-lamai-garden` | `pass_integrity_review` | safe | Garden-side dinner source detail preserved; no booking/hour/menu claim added. |
| 043 | `city-hanoi-place-lenin-park` | `revise_voice` | unsafe | Remaining command opener in first-screen tip: `Use the park before or after heavier nearby stops.` |
| 044 | `city-hanoi-place-literature-museum` | `pass_integrity_review` | safe | Literary-cultural role stays specific and calm. |
| 045 | `city-hanoi-place-loading-t-cafe` | `pass_integrity_review` | safe | PhraseIDs preserved exactly; upstairs-room and cinnamon-leaning coffee details preserved. |
| 046 | `city-hanoi-place-long-bien-bridge` | `pass_integrity_review` | safe | Bridge/river/market-edge framing is vivid and does not invent access rules. |
| 047 | `city-hanoi-place-long-bien-market` | `pass_integrity_review` | safe | Wholesale-market motion is preserved; timing kept flexible. |
| 048 | `city-hanoi-place-manzi-art-space` | `pass_integrity_review` | safe | Current-show variability is handled safely; copy is specific enough. |
| 049 | `city-hanoi-place-mien-luon` | `pass_integrity_review` | safe | Dish variation is preserved without overclaiming one shop style. |
| 050 | `city-hanoi-place-mien-luon-chan-cam` | `pass_integrity_review` | safe | Noodle-shop rhythm and dish identity are preserved; no unstable venue details added. |

## Focused Revision Notes

### Preservation blocker in Hanoi 001-025

These pages are unsafe for import because the rewritten chunk drops the source `when-to-use` section: 001-006, 008-017, 019-025.

Original section inventory for these pages includes:

`at-glance`, `place-brief`, `quick-say`, `use-it-with`, `when-to-use`, `good-to-know`

Rewritten section inventory is:

`at-glance`, `quick-say`, `place-brief`, `use-it-with`, `good-to-know`

The visible prose is often much better than the original generated scaffold, but this is still a no-deletion integrity failure. Restore a non-mechanical `when-to-use` section for each affected page, or get an explicit coordinator/importer exception before import.

### H2 remaining mechanical voice flags

- `city-hanoi-place-hang-da-market`: quick-say body starts with `Use it for signs...`; revise away from command phrasing.
- `city-hanoi-place-hoa-lo-prison`: heading `A Quieter Next Stop Helps` still has helper/gate language; revise to a natural traveler note.
- `city-hanoi-place-lenin-park`: tip starts with `Use the park...`; revise away from command phrasing.

### PhraseID preservation

The nested quick-say phraseID arrays match source exactly:

- `city-hanoi-place-bun-cha`: `food-menu`, `food-3`, `coffee-7`
- `city-hanoi-place-dinh-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
- `city-hanoi-place-giang-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
- `city-hanoi-place-loading-t-cafe`: `coffee-1`, `v500-dire-navi-do-i-go-upstairs`, `coffee-4`, `coffee-7`

### Blocked source too thin

No page is labeled `blocked_source_too_thin` in this pass. Thin transport and market pages in 026-050 were kept narrow enough for source import rather than inflated with unsupported operational claims.

## Safe For Import Into Production-Candidate Source

`city-hanoi-place-bun-cha`, `city-hanoi-place-dinh-cafe`, `city-hanoi-place-gia-lam-station`, `city-hanoi-place-giang-cafe`, `city-hanoi-place-giap-bat-bus-station`, `city-hanoi-place-hang-bac-street`, `city-hanoi-place-hang-gai-street`, `city-hanoi-place-hanoi-flag-tower`, `city-hanoi-place-hanoi-railway-station`, `city-hanoi-place-hibana-by-koki`, `city-hanoi-place-ho-chi-minh-mausoleum`, `city-hanoi-place-ho-chi-minh-museum`, `city-hanoi-place-hoan-kiem`, `city-hanoi-place-hom-market`, `city-hanoi-place-imperial-citadel`, `city-hanoi-place-lam-cafe`, `city-hanoi-place-lamai-garden`, `city-hanoi-place-literature-museum`, `city-hanoi-place-loading-t-cafe`, `city-hanoi-place-long-bien-bridge`, `city-hanoi-place-long-bien-market`, `city-hanoi-place-manzi-art-space`, `city-hanoi-place-mien-luon`, `city-hanoi-place-mien-luon-chan-cam`

## Unsafe For Import Into Production-Candidate Source

`city-hanoi-place-ba-dinh-district`, `city-hanoi-place-ba-dinh-square`, `city-hanoi-place-banh-cuon`, `city-hanoi-place-bay-mau-lake`, `city-hanoi-place-bia-hoi`, `city-hanoi-place-botanical-garden`, `city-hanoi-place-bun-cha-huong-lien`, `city-hanoi-place-bun-cha-ta`, `city-hanoi-place-bun-thang`, `city-hanoi-place-ca-phe-sua-da`, `city-hanoi-place-cha-ca`, `city-hanoi-place-cha-ca-thang-long`, `city-hanoi-place-cho-buoi-market`, `city-hanoi-place-coffee-hop`, `city-hanoi-place-cong-ca-phe-trieu-viet-vuong`, `city-hanoi-place-cyclo-old-quarter`, `city-hanoi-place-dong-da`, `city-hanoi-place-dong-xuan`, `city-hanoi-place-egg-coffee`, `city-hanoi-place-ethnology-museum`, `city-hanoi-place-french-quarter`, `city-hanoi-place-french-quarter-walk`, `city-hanoi-place-gia`, `city-hanoi-place-hang-da-market`, `city-hanoi-place-hoa-lo-prison`, `city-hanoi-place-lenin-park`
