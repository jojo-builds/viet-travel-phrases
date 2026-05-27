# Da Nang 001-050 Final Integrity Review

Date: 2026-05-26
Reviewer: independent city-page integrity + humanizer reviewer
Scope: `danang 001-050`

Source reviewed:
- `content-draft/viet/city-library/handwritten-copy/danang.json`

Chunks reviewed:
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/danang_001_025_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/danang_026_050_humanized.json`

Reports reviewed:
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/humanizer_chunk_validation.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/danang_001_025_humanizer_report.md`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/danang_026_050_humanizer_report.md`

Guidance reviewed:
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/INTEGRITY_REVIEWER_PROMPT.md`
- `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`
- `docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md`

## Review Basis

This is a no-deletion / no-bloat / humanizer integrity gate. It is not a production review and does not call any page production-ready.

`pass_integrity_review` below means safe for Codex import into production-candidate source, with later catalog/audio mapping, native rendering, screenshot review, and production gates still required.

`revise_voice`, `revise_preservation`, and `blocked_source_too_thin` mean unsafe for Codex import into production-candidate source until fixed.

Mechanical checks:
- All 50 assigned page IDs are present.
- Required source sections are retained for all 50 pages. Some pages reorder `when-to-use` ahead of `place-brief`, but no required section is dropped.
- Phrase IDs match the original source exactly by `pageID` and section ID for all 50 pages.
- No phrase IDs were added where the original source section had none.
- Shared validation report currently records `errors: 0`, `warnings: 0`, `missingChunks: 0` across the humanizer gate.

## Summary Counts

| Decision | Count |
|---|---:|
| `pass_integrity_review` | 31 |
| `revise_voice` | 19 |
| `revise_preservation` | 0 |
| `blocked_source_too_thin` | 0 |
| Total | 50 |

Import safety:
- Safe for Codex import into production-candidate source: 31 pages.
- Unsafe for Codex import until revision: 19 pages.

## Per-Page Decision Table

| # | Page ID | Decision | Import safety | Exact issue or pass note |
|---:|---|---|---|---|
| 001 | `city-danang-place-3d-art-in-paradise` | `pass_integrity_review` | safe | Indoor optical-illusion role, cool-break moment, and original `quick-say` phrase IDs are preserved. |
| 002 | `city-danang-place-43-factory` | `pass_integrity_review` | safe | Specific cafe pause, no invented phrase IDs, and no visible editor language found. |
| 003 | `city-danang-place-airport` | `pass_integrity_review` | safe | Arrival threshold and pickup-decision moment are concrete; no phrase IDs added. |
| 004 | `city-danang-place-an-thuong-street-area` | `pass_integrity_review` | safe | Neighborhood-evening role is preserved without overclaiming current venues; no phrase IDs added. |
| 005 | `city-danang-place-apec-park` | `pass_integrity_review` | safe | Short riverside-pause role and canopy detail are preserved; no phrase IDs added. |
| 006 | `city-danang-place-asia-park` | `revise_voice` | unsafe | Rationale still leaks review language: "staying honest about the operations and ticketing that need fresh review." |
| 007 | `city-danang-place-ba-na-cable-car` | `pass_integrity_review` | safe | Cable-car climb, weather tradeoff, boarding/return moment, and no source-empty phrase additions are preserved. |
| 008 | `city-danang-place-ba-na-hills` | `pass_integrity_review` | safe | Full mountain-park expectation, weather risk, Golden Bridge priority, and original phrase IDs are preserved. |
| 009 | `city-danang-place-bac-my-an-market` | `pass_integrity_review` | safe | Small snack-market role and original market phrase IDs are preserved exactly. |
| 010 | `city-danang-place-bach-dang-street` | `pass_integrity_review` | safe | Riverfront-orientation role is specific and not hollow; no phrase IDs added. |
| 011 | `city-danang-place-ban-co-peak` | `pass_integrity_review` | safe | Viewpoint, road, weather, and return-plan details are preserved without unstable claims. |
| 012 | `city-danang-place-banh-mi` | `pass_integrity_review` | safe | Dish-ordering moment stays concrete; no phrase IDs added. |
| 013 | `city-danang-place-banh-trang-cuon-thit-heo` | `pass_integrity_review` | safe | Roll-and-dip ritual is specific; no source details or phrase state lost. |
| 014 | `city-danang-place-banh-xeo` | `pass_integrity_review` | safe | Hot/crisp/herb/sauce moment is concrete and not product metadata. |
| 015 | `city-danang-place-banh-xeo-ba-duong` | `pass_integrity_review` | safe | Named-restaurant dish frame is narrow and useful; no unstable menu claims added. |
| 016 | `city-danang-place-be-man` | `pass_integrity_review` | safe | Seafood selection, price clarity, and table rhythm are preserved without invented phrase IDs. |
| 017 | `city-danang-place-bep-cuon` | `pass_integrity_review` | safe | Calmer roll-meal frame is specific enough and not visibly editorial. |
| 018 | `city-danang-place-boulevard-gelato-coffee` | `revise_voice` | unsafe | Rationale leaks review posture: "staying cautious about current menu and venue specifics." |
| 019 | `city-danang-place-bun-cha-ca` | `revise_voice` | unsafe | `good-to-know` sounds like content taxonomy, not travel copy: "Think of the page as a dish guide, not a promise of one exact bowl." |
| 020 | `city-danang-place-bun-cha-ca-hon` | `revise_voice` | unsafe | Rationale leaks review posture: "keeping claims cautious around current menu, hours, and service." |
| 021 | `city-danang-place-cathedral` | `pass_integrity_review` | safe | Worship-space etiquette and local-name cue are preserved without turning into a command list. |
| 022 | `city-danang-place-central-bus-station` | `pass_integrity_review` | safe | Transport handoff remains practical, concrete, and non-generic. |
| 023 | `city-danang-place-cham-museum` | `pass_integrity_review` | safe | My Son / Tra Kieu / Dong Duong room route and original phrase IDs are preserved. |
| 024 | `city-danang-place-che-xoa-xoa-hat-luu` | `pass_integrity_review` | safe | Dessert texture is specific and no unsupported phrase IDs were added. |
| 025 | `city-danang-place-co-chu-nho` | `revise_voice` | unsafe | Rationale still sounds like editing policy: "when the page stays cautious: menu, recommendation, spice level, and a focused first dish." |
| 026 | `city-danang-place-con-market` | `pass_integrity_review` | safe | Food-first market role, Hàn comparison, and original phrase IDs are preserved. |
| 027 | `city-danang-place-cong-caphe-bach-dang` | `revise_voice` | unsafe | Rationale contains product-review language: "without needing the page to overclaim the branch." |
| 028 | `city-danang-place-domestic-terminal` | `revise_voice` | unsafe | Rationale is editor-facing: "This entry makes a simple airport sub-place useful..." |
| 029 | `city-danang-place-dong-dinh-museum` | `pass_integrity_review` | safe | Garden-house museum role and original phrase IDs are preserved. |
| 030 | `city-danang-place-dragon-bridge` | `pass_integrity_review` | safe | Static bridge moment is separated from the fire show; original phrase IDs, including `use-it-with`, are preserved. |
| 031 | `city-danang-place-dragon-bridge-fire-show` | `revise_voice` | unsafe | Rationale leaks writing/review language: "only if the copy avoids stale schedule claims." |
| 032 | `city-danang-place-dragon-carp-statue` | `pass_integrity_review` | safe | Small riverfront landmark role is clear and not inflated. |
| 033 | `city-danang-place-fatfish` | `revise_voice` | unsafe | Rationale exposes source weakness and review policy: "thin-source venue" and "without making unstable claims about menu, hours, or status." |
| 034 | `city-danang-place-fine-arts-museum` | `pass_integrity_review` | safe | Compact museum route and original phrase IDs are preserved. |
| 035 | `city-danang-place-golden-bridge` | `pass_integrity_review` | safe | Ba Na Hills containment, weather tradeoff, and photo-priority role are preserved without phrase additions. |
| 036 | `city-danang-place-hai-chau-district` | `revise_voice` | unsafe | Rationale is source-policy language: "without naming current businesses or unstable map claims." |
| 037 | `city-danang-place-hai-san` | `revise_voice` | unsafe | Context is app/content taxonomy: "This dish page is for the first ordering decision, not for one restaurant..." |
| 038 | `city-danang-place-hai-van-pass` | `pass_integrity_review` | safe | Scenic old-road versus faster-route decision is preserved and human-readable. |
| 039 | `city-danang-place-hai-van-pass-ride` | `revise_voice` | unsafe | Context exposes page mechanics: "This sibling entry is about ride format and pacing; the pass entry stays..." |
| 040 | `city-danang-place-han-market` | `pass_integrity_review` | safe | Central market role, Cồn comparison, and original phrase IDs are preserved. |
| 041 | `city-danang-place-han-river` | `revise_voice` | unsafe | Rationale exposes content function: "The river page turns broad scenery into a useful waterline route..." |
| 042 | `city-danang-place-han-river-cruise` | `revise_voice` | unsafe | Rationale exposes content function: "The cruise page makes the river usable by focusing..." |
| 043 | `city-danang-place-helio-night-market` | `pass_integrity_review` | safe | Controlled food-court night role and original phrase IDs are preserved. |
| 044 | `city-danang-place-hoa-phu-thanh` | `revise_voice` | unsafe | Rationale still sounds like review policy: "when the wording stays honest about weather and operations." |
| 045 | `city-danang-place-hoa-trung-lake` | `revise_voice` | unsafe | Rationale is editor-facing: "The lake page can be useful with restrained copy..." |
| 046 | `city-danang-place-international-terminal` | `pass_integrity_review` | safe | Arrival sequence and original airport phrase IDs are preserved. |
| 047 | `city-danang-place-kem-bo` | `revise_voice` | unsafe | `good-to-know` has visible editor language: "Visible copy avoids naming a vendor..." Rationale also says "stable enough for offline copy." |
| 048 | `city-danang-place-la-maison-1888` | `revise_voice` | unsafe | Rationale exposes source weakness and review posture: "thin-source fine-dining venue" and "current prestige claims." |
| 049 | `city-danang-place-lady-buddha` | `pass_integrity_review` | safe | Statue/pagoda/Son Tra relationship and respectful-visit moment are preserved. |
| 050 | `city-danang-place-le-duan-night-market` | `revise_voice` | unsafe | Rationale leaks review policy: "no unstable claims about current stalls or hours." |

## Safe For Codex Import Into Production-Candidate Source

`city-danang-place-3d-art-in-paradise`, `city-danang-place-43-factory`, `city-danang-place-airport`, `city-danang-place-an-thuong-street-area`, `city-danang-place-apec-park`, `city-danang-place-ba-na-cable-car`, `city-danang-place-ba-na-hills`, `city-danang-place-bac-my-an-market`, `city-danang-place-bach-dang-street`, `city-danang-place-ban-co-peak`, `city-danang-place-banh-mi`, `city-danang-place-banh-trang-cuon-thit-heo`, `city-danang-place-banh-xeo`, `city-danang-place-banh-xeo-ba-duong`, `city-danang-place-be-man`, `city-danang-place-bep-cuon`, `city-danang-place-cathedral`, `city-danang-place-central-bus-station`, `city-danang-place-cham-museum`, `city-danang-place-che-xoa-xoa-hat-luu`, `city-danang-place-con-market`, `city-danang-place-dong-dinh-museum`, `city-danang-place-dragon-bridge`, `city-danang-place-dragon-carp-statue`, `city-danang-place-fine-arts-museum`, `city-danang-place-golden-bridge`, `city-danang-place-hai-van-pass`, `city-danang-place-han-market`, `city-danang-place-helio-night-market`, `city-danang-place-international-terminal`, `city-danang-place-lady-buddha`

## Unsafe For Codex Import Until Revised

`city-danang-place-asia-park`, `city-danang-place-boulevard-gelato-coffee`, `city-danang-place-bun-cha-ca`, `city-danang-place-bun-cha-ca-hon`, `city-danang-place-co-chu-nho`, `city-danang-place-cong-caphe-bach-dang`, `city-danang-place-domestic-terminal`, `city-danang-place-dragon-bridge-fire-show`, `city-danang-place-fatfish`, `city-danang-place-hai-chau-district`, `city-danang-place-hai-san`, `city-danang-place-hai-van-pass-ride`, `city-danang-place-han-river`, `city-danang-place-han-river-cruise`, `city-danang-place-hoa-phu-thanh`, `city-danang-place-hoa-trung-lake`, `city-danang-place-kem-bo`, `city-danang-place-la-maison-1888`, `city-danang-place-le-duan-night-market`

## Focused Fix Guidance

The unsafe pages do not need structural rebuilds. Phrase preservation is already clean. The fix is to remove app-internal or editor-facing language from app-facing/importable fields, especially words and constructions such as:

- "page", "entry", or "copy" when describing the content object instead of the travel moment
- "thin-source", "stable enough for offline copy", "fresh review", "current claims", "unstable claims", or similar review-policy language
- source-policy rationales that explain why the writer avoided claims rather than giving the traveler a natural caution

Keep the underlying traveler moments. Most unsafe pages can likely become safe with one targeted voice pass, not new research.

Report path: `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/reports/danang_001_050_final_integrity_review.md`
