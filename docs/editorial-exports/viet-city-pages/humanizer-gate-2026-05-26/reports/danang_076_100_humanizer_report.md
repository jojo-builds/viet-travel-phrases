# Da Nang 076-100 Humanizer Report

Worker: D4  
Date: 2026-05-26  
Output chunk: `chunks/danang_076_100_humanized.json`

## Scope

Rewrote the 25 Da Nang source entries from `target-ranges.md`, covering:

- 076-100, from `city-danang-place-nguyen-van-linh-street` through `city-danang-place-yen-retreat`
- Source file read: `content-draft/viet/city-library/handwritten-copy/danang.json`
- Guidance read: `CURRENT_CITY_PAGE_STANDARD.md` and `V2_2_PRODUCTION_REVIEW_GATE.md`
- Draft support consulted: ChatGPT batch outputs 025-030 where they covered these same Da Nang pages

## Changed Themes

- Replaced generic "worth it / what you'll get" cadence with specific traveler moments: ride pickup, river crossing, beach reset, cafe pause, theatre night, port gate, and return transport.
- Revised the stricter-gate blockers in visible entry copy: removed app-internal phrasing and sentence starts that sounded like database instructions.
- Repair pass restored a humanized `when-to-use` section for every source entry in this slice.
- Repair pass removed remaining visible reviewer/import language from `city-danang-place-the-temptation` and `city-danang-place-yen-retreat`.
- Replaced command-like headings beginning with Use, Keep, Choose, Confirm, Leave, and Start with observed place/moment headings.
- Reduced repeated local-name paragraphs into page-specific name support: street, beach, bridge, port, cafe, district, and retreat names.
- Removed thin generated texture such as repeated "alongside bridge-and-beach Da Nang" phrasing.
- Kept unstable operational claims out of visible copy: no fixed hours, prices, schedules, current menus, access rules, swimming safety, parking, or active venue status.
- Made sparse-source pages more restrained instead of more confident, especially Thanh Binh Beach, broad streets, cafe venues, Tien Sa Port, and Yen Retreat.
- Preserved the one existing source phraseID set on Son Tra Night Market and did not add phraseIDs to any other page.

## Revise Pages

No pages are marked `revise_before_import` in this chunk. All 25 are labeled `ready_for_integrity_review`, and the repair validator now reports this assigned chunk as pass.

Pages that should get extra attention during integrity review:

- `city-danang-place-thanh-binh-beach`: sparse evidence; beach access, cleanliness, drop-off, and condition claims remain later QA points.
- `city-danang-place-the-temptation`: restaurant page intentionally avoids menu claims; open status, booking path, menu format, and hours remain later QA points.
- `city-danang-place-tien-sa-port`: port access, gates, pickup rules, and security language need current verification.
- `city-danang-place-son-tra-wildlife-drive`: road access, weather, and wildlife guidance are condition-sensitive.
- `city-danang-place-yen-retreat`: venue access, booking expectations, weather exposure, and transport practicality remain later QA points.
- Cafe pages `reply-1988`, `six-on-six`, and `wonderlust`: status, address, hours, and menu remain later QA points.

## Phrase And Audio Risks

- Only `city-danang-place-son-tra-night-market` carries preserved phraseIDs: `price-1`, `food-1`, `food-3`, `food-7`.
- No new phraseIDs were invented.
- All other entries use prose-only name support in the legacy `quick-say` section, so audio/catalog mapping is still a later integrity-review task.
- Place-name audio readiness varies in the ChatGPT drafts. Ready name support was noted there for items such as Nguyễn Văn Linh, Non Nước, Ga Đà Nẵng, Sơn Trà, Tiên Sa, and Trần Thị Lý, but this chunk does not assert playback readiness.
- Before import, check that any rendered speaker icon has bundled audio or is hidden/queued.

## Validation

- JSON parse and high-level shape check passed.
- Entry count: 25.
- Decision count: 25.
- Target page order matches `target-ranges.md`.
- Paragraph word check passed: no summary, context, tip, rationale, or section body over 45 words.
- PhraseID preservation check passed against the source slice.
- Requested repair validator run: `node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true`.
- Overall validator result still fails because other chunks are failing.
- D4 chunk result from the validator: `danang 076-100` passed with 25 entries, 0 errors, and 0 warnings.

## Import Note

This is a production-candidate humanized source chunk, not a final gate pass. It still needs integrity review, catalog/audio mapping, and the normal app screenshot checks before promotion.
