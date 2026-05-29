# Hanoi 001-050 Final Integrity Review

Date: 2026-05-26
Reviewer: Independent SpeakLocal city-page integrity + humanizer reviewer
Scope: Hanoi entries 001-050 only

This review does not call any page production-ready. It decides only whether each current humanized entry is safe or unsafe for Codex import into production-candidate source before later v2.2 mapping, render proof, screenshot review, and production review gates.

## Inputs Read

- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/INTEGRITY_REVIEWER_PROMPT.md`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/humanizer_chunk_validation.json`
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_001_025_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_026_050_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/hanoi_001_025_humanizer_report.md`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/hanoi_026_050_humanizer_report.md`

## Summary Counts

| Decision | Count |
|---|---:|
| `pass_integrity_review` | 41 |
| `revise_voice` | 9 |
| `revise_preservation` | 0 |
| `blocked_source_too_thin` | 0 |

Safe for Codex import into production-candidate source: 41 pages.

Unsafe for Codex import into production-candidate source: 9 pages.

The chunk validator passes for the full 200-entry export and reports `entries=200 warnings=0`. For this scoped manual review, Hanoi 001-050 also preserves page order, all required source section IDs, and all source phraseIDs. The unsafe pages are voice/humanizer issues, not structural deletion issues.

## PhraseID Preservation

PhraseID preservation passed. No phraseIDs were added where the source had none, and exact source phraseIDs were preserved where present:

- `city-hanoi-place-bun-cha`: `food-menu`, `food-3`, `coffee-7`
- `city-hanoi-place-dinh-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
- `city-hanoi-place-giang-cafe`: `coffee-1`, `v900-food-drin-one-hot-coffee-please`, `v900-food-drin-less-sugar-please`, `coffee-7`
- `city-hanoi-place-loading-t-cafe`: `coffee-1`, `v500-dire-navi-do-i-go-upstairs`, `coffee-4`, `coffee-7`

## Per-Page Decision Table

| # | Page ID | Decision | Import Safety | Integrity Notes |
|---:|---|---|---|---|
| 001 | `city-hanoi-place-ba-dinh-district` | `pass_integrity_review` | safe | Preserves district/civic-neighborhood source details; restored section set is intact; no phraseIDs added. |
| 002 | `city-hanoi-place-ba-dinh-square` | `pass_integrity_review` | safe | Formal civic-space copy is specific and avoids unstable ceremony/access claims. |
| 003 | `city-hanoi-place-banh-cuon` | `pass_integrity_review` | safe | Dish texture, sauce, timing, and morning role are preserved without hollow travel blur. |
| 004 | `city-hanoi-place-bay-mau-lake` | `pass_integrity_review` | safe | Lake/park reset stays modest and concrete; no invented facilities claim. |
| 005 | `city-hanoi-place-bia-hoi` | `pass_integrity_review` | safe | Stool-height beer scene is specific; avoids price/street/venue claims. |
| 006 | `city-hanoi-place-botanical-garden` | `pass_integrity_review` | safe | Green pause near Ba Dinh is preserved; entrance/hour uncertainty is kept out of claims. |
| 007 | `city-hanoi-place-bun-cha` | `pass_integrity_review` | safe | Table rhythm and exact phraseIDs preserved. |
| 008 | `city-hanoi-place-bun-cha-huong-lien` | `pass_integrity_review` | safe | Restaurant fame is kept smaller than the meal; no unsupported menu/hour claim. |
| 009 | `city-hanoi-place-bun-cha-ta` | `pass_integrity_review` | safe | Small-table bun cha specificity preserved; no phraseIDs added. |
| 010 | `city-hanoi-place-bun-thang` | `pass_integrity_review` | safe | Ingredient caution and light-bowl role are useful and grounded. |
| 011 | `city-hanoi-place-ca-phe-sua-da` | `pass_integrity_review` | safe | Coffee ritual reads naturally; no editor-facing terms or phraseID drift. |
| 012 | `city-hanoi-place-cha-ca` | `pass_integrity_review` | safe | Hot-pan fish ritual and sauce caution preserved without overclaiming. |
| 013 | `city-hanoi-place-cha-ca-thang-long` | `pass_integrity_review` | safe | Venue copy stays focused on the pan/table rhythm and avoids unstable details. |
| 014 | `city-hanoi-place-cho-buoi-market` | `pass_integrity_review` | safe | Plant/housewares/local-market texture is preserved; section set intact. |
| 015 | `city-hanoi-place-coffee-hop` | `pass_integrity_review` | safe | Route-of-pauses voice is human and not a checklist. |
| 016 | `city-hanoi-place-cong-ca-phe-trieu-viet-vuong` | `pass_integrity_review` | safe | Branch page is narrow and practical; no current menu/operations claim. |
| 017 | `city-hanoi-place-cyclo-old-quarter` | `pass_integrity_review` | safe | Fare/route caution is practical and does not invent fixed numbers. |
| 018 | `city-hanoi-place-dinh-cafe` | `pass_integrity_review` | safe | Upstairs arrival sequence and exact phraseIDs preserved. |
| 019 | `city-hanoi-place-dong-da` | `pass_integrity_review` | safe | Ordinary-district framing avoids tourist-brochure blur. |
| 020 | `city-hanoi-place-dong-xuan` | `pass_integrity_review` | safe | Working-market movement and aisle behavior are concrete. |
| 021 | `city-hanoi-place-egg-coffee` | `pass_integrity_review` | safe | Drink specificity and slow-cup moment are preserved. |
| 022 | `city-hanoi-place-ethnology-museum` | `pass_integrity_review` | safe | Museum value is specific enough and does not invent ticket/hour details. |
| 023 | `city-hanoi-place-french-quarter` | `pass_integrity_review` | safe | Area mood, scale change, and walking role are clear. |
| 024 | `city-hanoi-place-french-quarter-walk` | `pass_integrity_review` | safe | Walking-route copy stays short and avoids fixed route promises. |
| 025 | `city-hanoi-place-gia` | `revise_voice` | unsafe | Visible heading `Freshness Matters Here` exposes review-gate language. |
| 026 | `city-hanoi-place-gia-lam-station` | `pass_integrity_review` | safe | Thin transport source stays narrow; no invented route/platform claim. |
| 027 | `city-hanoi-place-giang-cafe` | `pass_integrity_review` | safe | Narrow entrance, close tables, egg coffee, and exact phraseIDs preserved. |
| 028 | `city-hanoi-place-giap-bat-bus-station` | `pass_integrity_review` | safe | Practical transfer behavior is clear and not bloated. |
| 029 | `city-hanoi-place-hang-bac-street` | `pass_integrity_review` | safe | Silver-shop street thread is concrete and human. |
| 030 | `city-hanoi-place-hang-da-market` | `pass_integrity_review` | safe | Current text has removed the older command opener; market browse is specific. |
| 031 | `city-hanoi-place-hang-gai-street` | `pass_integrity_review` | safe | Silk-window walking spine is clear and stable. |
| 032 | `city-hanoi-place-hanoi-flag-tower` | `pass_integrity_review` | safe | Landmark scale, base, flag, and Ba Dinh context are preserved. |
| 033 | `city-hanoi-place-hanoi-railway-station` | `revise_voice` | unsafe | Visible heading `Live Checks Later` sounds like an editorial QA note. |
| 034 | `city-hanoi-place-hibana-by-koki` | `revise_voice` | unsafe | Visible heading `Current Venue Check` sounds like reviewer metadata. |
| 035 | `city-hanoi-place-ho-chi-minh-mausoleum` | `revise_voice` | unsafe | Visible heading `Rules Are Freshness Risks` exposes review-gate language. |
| 036 | `city-hanoi-place-ho-chi-minh-museum` | `revise_voice` | unsafe | Visible heading `Check Museum Logistics` reads like an internal review task. |
| 037 | `city-hanoi-place-hoa-lo-prison` | `pass_integrity_review` | safe | Current copy is heavier, specific, and no longer uses the older helper-style heading. |
| 038 | `city-hanoi-place-hoan-kiem` | `pass_integrity_review` | safe | Lake, bridge, Turtle Tower, and reset role are preserved without overclaiming. |
| 039 | `city-hanoi-place-hom-market` | `pass_integrity_review` | safe | Fabric-market behavior and practical aisle movement are concrete. |
| 040 | `city-hanoi-place-imperial-citadel` | `pass_integrity_review` | safe | Gates, courtyards, walls, and history-loop role are preserved. |
| 041 | `city-hanoi-place-lam-cafe` | `revise_voice` | unsafe | Visible heading `Venue Check` sounds like an editor note, not travel copy. |
| 042 | `city-hanoi-place-lamai-garden` | `revise_voice` | unsafe | Visible heading `Current Details Needed` is import/review language. |
| 043 | `city-hanoi-place-lenin-park` | `pass_integrity_review` | safe | Current text removed the older `Use the park...` command opener; park pause reads naturally. |
| 044 | `city-hanoi-place-literature-museum` | `revise_voice` | unsafe | Visible heading `Museum Freshness` exposes review-gate language. |
| 045 | `city-hanoi-place-loading-t-cafe` | `pass_integrity_review` | safe | Upstairs-room/cinnamon coffee details and exact phraseIDs preserved. |
| 046 | `city-hanoi-place-long-bien-bridge` | `pass_integrity_review` | safe | Bridge/river/market-edge framing is vivid; access caution does not overclaim. |
| 047 | `city-hanoi-place-long-bien-market` | `pass_integrity_review` | safe | Wholesale-market motion is preserved without romanticizing or overexplaining. |
| 048 | `city-hanoi-place-manzi-art-space` | `pass_integrity_review` | safe | Small art-space variability is expressed naturally; no current-show claim added. |
| 049 | `city-hanoi-place-mien-luon` | `pass_integrity_review` | safe | Dish variation and texture are preserved without pretending every shop is the same. |
| 050 | `city-hanoi-place-mien-luon-chan-cam` | `revise_voice` | unsafe | Visible heading `Venue Freshness` exposes review-gate language. |

## Focused Revision Notes

These pages should not be imported until the visible editor/review headings are rewritten into traveler-facing copy:

- `city-hanoi-place-gia`: `Freshness Matters Here`
- `city-hanoi-place-hanoi-railway-station`: `Live Checks Later`
- `city-hanoi-place-hibana-by-koki`: `Current Venue Check`
- `city-hanoi-place-ho-chi-minh-mausoleum`: `Rules Are Freshness Risks`
- `city-hanoi-place-ho-chi-minh-museum`: `Check Museum Logistics`
- `city-hanoi-place-lam-cafe`: `Venue Check`
- `city-hanoi-place-lamai-garden`: `Current Details Needed`
- `city-hanoi-place-literature-museum`: `Museum Freshness`
- `city-hanoi-place-mien-luon-chan-cam`: `Venue Freshness`

These are not preservation blockers. The pages generally keep the source place, traveler moment, and section structure. The issue is that visible section labels still sound like production-review notes rather than calm travel writing.

## Safe For Codex Import Into Production-Candidate Source

`city-hanoi-place-ba-dinh-district`, `city-hanoi-place-ba-dinh-square`, `city-hanoi-place-banh-cuon`, `city-hanoi-place-bay-mau-lake`, `city-hanoi-place-bia-hoi`, `city-hanoi-place-botanical-garden`, `city-hanoi-place-bun-cha`, `city-hanoi-place-bun-cha-huong-lien`, `city-hanoi-place-bun-cha-ta`, `city-hanoi-place-bun-thang`, `city-hanoi-place-ca-phe-sua-da`, `city-hanoi-place-cha-ca`, `city-hanoi-place-cha-ca-thang-long`, `city-hanoi-place-cho-buoi-market`, `city-hanoi-place-coffee-hop`, `city-hanoi-place-cong-ca-phe-trieu-viet-vuong`, `city-hanoi-place-cyclo-old-quarter`, `city-hanoi-place-dinh-cafe`, `city-hanoi-place-dong-da`, `city-hanoi-place-dong-xuan`, `city-hanoi-place-egg-coffee`, `city-hanoi-place-ethnology-museum`, `city-hanoi-place-french-quarter`, `city-hanoi-place-french-quarter-walk`, `city-hanoi-place-gia-lam-station`, `city-hanoi-place-giang-cafe`, `city-hanoi-place-giap-bat-bus-station`, `city-hanoi-place-hang-bac-street`, `city-hanoi-place-hang-da-market`, `city-hanoi-place-hang-gai-street`, `city-hanoi-place-hanoi-flag-tower`, `city-hanoi-place-hoa-lo-prison`, `city-hanoi-place-hoan-kiem`, `city-hanoi-place-hom-market`, `city-hanoi-place-imperial-citadel`, `city-hanoi-place-lenin-park`, `city-hanoi-place-loading-t-cafe`, `city-hanoi-place-long-bien-bridge`, `city-hanoi-place-long-bien-market`, `city-hanoi-place-manzi-art-space`, `city-hanoi-place-mien-luon`

## Unsafe For Codex Import Into Production-Candidate Source

`city-hanoi-place-gia`, `city-hanoi-place-hanoi-railway-station`, `city-hanoi-place-hibana-by-koki`, `city-hanoi-place-ho-chi-minh-mausoleum`, `city-hanoi-place-ho-chi-minh-museum`, `city-hanoi-place-lam-cafe`, `city-hanoi-place-lamai-garden`, `city-hanoi-place-literature-museum`, `city-hanoi-place-mien-luon-chan-cam`

## Final Import Safety

Hanoi 001-050 is partially safe for Codex import into production-candidate source: 41 safe, 9 unsafe.

Do not import the unsafe pages until the visible review-language headings are revised. Do not call any of these pages production-ready from this report alone.
