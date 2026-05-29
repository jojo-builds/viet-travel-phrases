# Hanoi 026-050 Humanizer Report

Date: 2026-05-26
Worker: H2
Output chunk: `chunks/hanoi_026_050_humanized.json`

## Scope

Rewrote the 25 Hanoi source entries numbered 026-050 in `target-ranges.md` as complete city-library source entries. Source files were not edited.

Inputs read:
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`
- `content-draft/viet/city-library/handwritten-copy/hanoi.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/target-ranges.md`
- Relevant ChatGPT batch handoffs from batch 034, 035, and 036

## Changed Themes

- Replaced repeated `Why go`, `What you'll get`, `Worth it if`, and `Before you go` scaffolding with observed page-specific headings.
- Kept thin-source transport pages narrow and practical: ticket/name checks, pickup clarity, bags, and transfer behavior.
- Gave streets and markets concrete roles: Hàng Bạc as a silver-shop thread, Hàng Gai as a silk-window walking spine, Chợ Hôm as fabric-first, Long Biên Market as wholesale movement.
- Kept restaurants and cafes grounded in setting and pace instead of unstable menu, booking, price, award, or hour claims.
- Reframed civic and museum pages around tone, pacing, and visit shape while leaving rules, tickets, photos, and guide availability for later freshness review.
- Preserved existing `phraseIDs` exactly for `city-hanoi-place-giang-cafe` and `city-hanoi-place-loading-t-cafe`.

## Revise Pages

No pages are marked `revise_before_import` in this humanizer chunk. All 25 entries are marked `ready_for_integrity_review`.

Integrity review should still check:
- Whether import expects the exact legacy six-section set for non-expanded entries.
- Whether any source-only rationale fields should be stripped or retained during import.
- Whether Unicode punctuation/accent normalization is desired for generated app copy.

## Phrase And Audio Risks

- PhraseIDs were only present in the original source for Giang Cafe and Loading T Cafe, and those arrays were preserved unchanged.
- Most entries in this range still have no source-level phraseIDs. Later V2.2 mapping should use ready reusable traveler-action phrases rather than new one-off place-name phrases.
- Place-name audio should render only when the existing audio manifest confirms ready audio.
- Attraction and station name phrases should stay pronunciation support, not visible phrase cards, unless the V2.2 mapper explicitly approves them.

## Freshness Risks

- Transport nodes: Gia Lam, Giap Bat, and Hanoi Railway Station need current route, signage, pickup, and access checks.
- Restaurants and cafes: Hibana by Koki, Lamai Garden, Lam Cafe, Giang Cafe, Loading T, Manzi, and Mien Luon Chan Cam need current venue/menu/hour/booking or program checks before promotion.
- Museums and civic sites: Ho Chi Minh Mausoleum, Ho Chi Minh Museum, Hoa Lo Prison, Imperial Citadel, Literature Museum, and Hanoi Flag Tower need current access, ticket, photo, exhibit, and guide checks.
- Markets and bridge pages: Hang Da, Hom, Long Bien Market, and Long Bien Bridge need current access, safety, stall mix, and construction checks.

## Validation

Completed after file write:
- JSON parse passed with `jq empty`
- Entry count equals 25
- Page IDs match `target-ranges.md` order for Hanoi 026-050
- No paragraph over 45 words
- PhraseID preservation check passed for the two source entries with phraseIDs
- No ChatGPT export labels, QA labels, render/check labels, or visible app-internal headings found in the chunk entries

Coordinator stricter-gate cleanup:
- Replaced remaining command-style headings.
- Removed visible `works best` and `helps` phrasing.
- Preserved page order and phrase IDs.
- Shared validator status for this chunk: `pass`, `errors: 0`, `warnings: 0`.

Repair pass 2026-05-26:
- Removed remaining visible freshness/review labels from Gia Lam Station, Hang Da Market, Hanoi Flag Tower, Hoan Kiem, Imperial Citadel, and Lenin Park.
- Reworded Hang Da Market and Lenin Park command-style visible copy while preserving section IDs and source phraseID behavior.
- Reran `node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true`; assigned chunk status is `pass`, `errors: 0`, `warnings: 0`. Other chunks still fail outside this scope.

Coordinator repair note 2026-05-26:
- Replaced the eight flagged visible review-style headings in Hanoi 026-050 with traveler-facing headings while preserving section IDs and phraseIDs.
- Re-ran `node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true`; `hanoi_026_050_humanized.json` reports `status: pass`, `entries: 25`, `errors: 0`, `warnings: 0`. Remaining aggregate failures are outside this assigned range.
