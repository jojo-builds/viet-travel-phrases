# Da Nang 051-075 Humanizer Report

Worker: D3  
Range: `danang 051-075`  
Output: `chunks/danang_051_075_humanized.json`

## Changed Themes

- Replaced repeated `Why go` / `What you'll get` / `Worth it if` cadence with page-specific traveler moments: temple manners, cafe pause, supermarket restock, short river photo stop, cave pace, shallow noodle bowl, seafood rounds, craft village, tide-dependent reef, and theatre arrival.
- Revised the stricter-gate misses from the first D3 pass: command-start headings and templated utility phrasing.
- Replaced those with more observed headings and prose, such as `Son Tra Can Wait`, `One Coffee, Then Back Out`, `Cave Pace Before Photos`, `Protein Before Extras`, `Counter First, Bowl Next`, `Space Around The Booking`, and `Food Limits Before Courses`.
- Restored humanized `when-to-use` sections for every 051-075 source entry that has one, without copying the old mechanical source wording.
- Rewrote visible QA/reviewer language into traveler-facing context on the remaining flagged pages, including Mi Quang 1A, Museum Branch 2, My Khe, My Quang Ba Mua, My Quang Dung, Nam Danh Seafood, Nam House, Nam O fish sauce village, Nam O Reef, Ngu Hanh Son District, and Nguyen Hien Dinh Tuong Theatre.
- Kept volatile claims out of visible copy: no exact hours, prices, ticket amounts, current menus, bookings guarantees, venue status, beach services, swimming safety, lock availability, theatre schedules, or exhibit details.
- Preserved existing city-library shape and existing phraseIDs only. The only entries with source `phraseIDs` in this range remain Lotte Mart, Love Bridge, and Da Nang Museum.
- Used ChatGPT batch drafts where useful for pages 051-075, but compressed them back into city-library source entries instead of importing V2.2 notes or app-internal labels.
- Separated nearby same-site concepts where possible: Linh Ung Pagoda vs Lady Buddha, Marble Mountain cave walk vs Marble Mountains, My An vs My An Beach, Nam O village vs Nam O Reef.

## Revise Pages

No page is marked `revise_before_import` in this chunk. All 25 are labeled `ready_for_integrity_review`.

Pages with the highest date-sensitive follow-up:

- `city-danang-place-nguyen-hien-dinh-tuong-theatre`: show program, start time, tickets, access, photo policy, and English support.
- `city-danang-place-museum` and `city-danang-place-museum-branch-2`: entrance, ticketing, exhibits, access, interpretation, and branch status.
- `city-danang-place-nen`, `city-danang-place-madame-lan`, `city-danang-place-mi-quang-1a`, `city-danang-place-my-quang-ba-mua`, `city-danang-place-my-quang-dung`, `city-danang-place-nam-danh-seafood`: current venue status, hours, menus, reservations, pricing style, holiday closures, and dietary handling.
- `city-danang-place-my-an-beach`, `city-danang-place-my-khe`, `city-danang-place-man-thai-beach`, `city-danang-place-nam-o-reef`: access, tide/weather, water conditions, services, restroom availability, safety, and pickup assumptions.
- `city-danang-place-lotte-mart` and `city-danang-place-love-bridge`: current store/payment/layout details for Lotte; lock rules, lighting, access, and route crowding for Love Bridge.

## Phrase / Audio Risks

- Preserved phraseIDs exactly where present:
  - `city-danang-place-lotte-mart`: `price-1`, `shop-5`, `store-2`, `store-7`
  - `city-danang-place-love-bridge`: `directions-1`, `sight-3`, `sight-4`, `taxi-3`
  - `city-danang-place-museum`: `v500-sigh-acti-where-is-the-entrance`, `v500-sigh-acti-where-can-i-buy-tickets`, `sight-3`, `sight-4`
- Did not add phraseIDs to the other 22 entries because the source entries do not contain them.
- Place-name pronunciation/audio remains later integrity-review work. Several ChatGPT drafts indicated planned or missing place-name audio; this chunk does not render those as useful phrase cards.
- Catalog/audio follow-up likely needed for natural mentions such as Lady Buddha, Son Tra, Han River, Dragon Bridge, Marble Mountains, Da Nang Museum Branch 2, Mi Quang variants, nuoc mam, peanut sauce, and tuong.

## Integrity Notes

- Shared validator run:
  - Command: `node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true`
  - Aggregate result: still fails because other chunks/ranges have errors.
  - D3 result: `danang 051-075` status `pass`, 25 entries, 0 errors, 0 warnings.
- All visible section bodies were kept under 45 words.
- Copy avoids app-internal labels such as anchor, content contract, catalog QA, displaySubtitle, and reason.
- Stricter gate terms are absent from visible D3 copy, including command-start blocked headings, app-internal labels, and templated utility phrasing.
- This is a source-copy humanizer chunk only. It is not a rendered-page production PASS and does not replace the V2.2 production review gate.
