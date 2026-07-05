# Da Nang 001-100 Integrity Review

Date: 2026-05-26
Reviewer: Integrity Reviewer R1
Scope: `danang 001-100`
Source reviewed: `content-draft/viet/city-library/handwritten-copy/danang.json`
Chunks reviewed:
- `chunks/danang_001_025_humanized.json`
- `chunks/danang_026_050_humanized.json`
- `chunks/danang_051_075_humanized.json`
- `chunks/danang_076_100_humanized.json`
Writer reports reviewed:
- `reports/danang_001_025_humanizer_report.md`
- `reports/danang_026_050_humanizer_report.md`
- `reports/danang_051_075_humanizer_report.md`
- `reports/danang_076_100_humanizer_report.md`

## Review Basis

Read `INTEGRITY_REVIEWER_PROMPT.md`, `CURRENT_CITY_PAGE_STANDARD.md`, and `V2_2_PRODUCTION_REVIEW_GATE.md`.

This is an integrity/import-safety review only, not a final production gate. "Safe" below means safe for Codex import into production-candidate source, subject to later catalog/audio mapping, runtime generation, screenshot review, and production gates.

Mechanical checks found:
- All 100 target page IDs are present in order.
- No required top-level source fields were dropped.
- Existing source `phraseIDs` were preserved where the original source already had them.
- Chunk 001-025 added phrase IDs to 21 pages whose original source had no `phraseIDs`; those pages are unsafe until the added IDs are removed, mapped with explicit source authority, or otherwise approved.
- Several later pages leak reviewer/import/freshness notes into importable copy fields or visible sections. Those pages are unsafe until the notes are moved to internal QA fields or rewritten as traveler-facing copy.

## Summary

Safe for import into production-candidate source: 44 pages.

Unsafe until revision or source work: 56 pages.

Unsafe breakdown:
- `revise_preservation`: 21 pages, all from chunk 001-025 with added phrase IDs not present in original source.
- `revise_voice`: 32 pages with visible/importable QA language, command-schema leakage, or review-note text.
- `blocked_source_too_thin`: 3 pages where the chunk itself exposes thin or unchecked source as part of the page and the visible copy is not safe to import without fresh source work.

## Per-Page Decision Table

| # | Page ID | Decision | Import safety | Reason or exact issue |
|---:|---|---|---|---|
| 001 | `city-danang-place-3d-art-in-paradise` | `pass_integrity_review` | safe | Place role, weather-break moment, and source phrase IDs preserved. |
| 002 | `city-danang-place-43-factory` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `coffee-1,coffee-5,coffee-7`. |
| 003 | `city-danang-place-airport` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `airport-5,airport-pickup-clearer,v900-airp-bord-arri-how-long-does-it-take-to-get-downtown`. |
| 004 | `city-danang-place-an-thuong-street-area` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `shop-4,social-9,v500-dire-navi-can-i-walk-there`. |
| 005 | `city-danang-place-apec-park` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `v900-poli-basi-can-i-sit-here,sight-3,directions-3`. |
| 006 | `city-danang-place-asia-park` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `sight-1,sight-4,sight-2`. |
| 007 | `city-danang-place-ba-na-cable-car` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `sight-1,sight-5,sight-4`. |
| 008 | `city-danang-place-ba-na-hills` | `pass_integrity_review` | safe | Full-park expectation, weather risk, and original phrase IDs preserved. |
| 009 | `city-danang-place-bac-my-an-market` | `pass_integrity_review` | safe | Smaller snack-market role and original market phrase IDs preserved. |
| 010 | `city-danang-place-bach-dang-street` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `v500-dire-navi-can-i-walk-there,directions-3,directions-1`. |
| 011 | `city-danang-place-ban-co-peak` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `v500-dire-navi-how-far-is-it,v500-sigh-acti-where-is-the-entrance,v500-dire-navi-can-you-help-me-get-back-to-my-hotel`. |
| 012 | `city-danang-place-banh-mi` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-1,food-not-spicy-clearer,coffee-6`. |
| 013 | `city-danang-place-banh-trang-cuon-thit-heo` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-1,food-4,repair-show-me`. |
| 014 | `city-danang-place-banh-xeo` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-1,food-4,food-not-spicy-clearer`. |
| 015 | `city-danang-place-banh-xeo-ba-duong` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-need-table,food-1,coffee-7`. |
| 016 | `city-danang-place-be-man` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-menu,price-1,social-9`. |
| 017 | `city-danang-place-bep-cuon` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-menu,food-1,repair-show-me`. |
| 018 | `city-danang-place-boulevard-gelato-coffee` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `coffee-1,coffee-5,coffee-7`. |
| 019 | `city-danang-place-bun-cha-ca` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-2,food-3,food-6`; visible issue also remains: `The page should stay about the dish, not one fixed bowl.` |
| 020 | `city-danang-place-bun-cha-ca-hon` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-2,food-not-spicy-clearer,coffee-7`; visible issue also remains: `Visible copy should avoid hours, queues, exact menu range, and address claims until the venue is reviewed close to import.` |
| 021 | `city-danang-place-cathedral` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `sight-3,sight-4,polite-2`. |
| 022 | `city-danang-place-central-bus-station` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `transport-1,transport-2,transport-fare`. |
| 023 | `city-danang-place-cham-museum` | `pass_integrity_review` | safe | Specific museum rooms and original phrase IDs preserved. |
| 024 | `city-danang-place-che-xoa-xoa-hat-luu` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `price-1,v900-food-drin-less-sugar-please,coffee-4`. |
| 025 | `city-danang-place-co-chu-nho` | `revise_preservation` | unsafe | Original source had no `phraseIDs`; chunk adds `food-menu,social-9,food-3`; visible issue also remains: `Current menu, hours, address, and mention status should be checked before import.` |
| 026 | `city-danang-place-con-market` | `pass_integrity_review` | safe | Food-first market role and original phrase IDs preserved. |
| 027 | `city-danang-place-cong-caphe-bach-dang` | `revise_voice` | unsafe | Importable section leaks QA: `Freshness Check Before Import` and `Current seating, river-view claims, hours, and drink menu should be checked before publishing.` |
| 028 | `city-danang-place-domestic-terminal` | `pass_integrity_review` | safe | Arrival sequence is concrete and avoids exact pickup-zone claims. |
| 029 | `city-danang-place-dong-dinh-museum` | `pass_integrity_review` | safe | Garden-house museum role and original phrase IDs preserved. |
| 030 | `city-danang-place-dragon-bridge` | `revise_voice` | unsafe | Context leaks page mechanics: `The page should stay separate from the timed fire-show listing.` |
| 031 | `city-danang-place-dragon-bridge-fire-show` | `revise_voice` | unsafe | Importable section leaks QA: `Schedule Stays Freshness-Gated` and `Exact days, times, crowd controls, traffic changes, and weather effects need same-week checking.` |
| 032 | `city-danang-place-dragon-carp-statue` | `revise_voice` | unsafe | Importable section leaks QA: `Do Not Promise The Fountain` and `Keep visible copy about the statue and river frame.` |
| 033 | `city-danang-place-fatfish` | `revise_voice` | unsafe | Importable section leaks QA: `Venue Details Need Review` and `Current hours, menu, terrace availability, and operating status need checking before import.` |
| 034 | `city-danang-place-fine-arts-museum` | `pass_integrity_review` | safe | Compact art-museum route and original phrase IDs preserved. |
| 035 | `city-danang-place-golden-bridge` | `revise_voice` | unsafe | Importable section leaks QA: `Operations Stay Freshness-Gated` and `Do not add exact operating claims without that check.` |
| 036 | `city-danang-place-hai-chau-district` | `revise_voice` | unsafe | Importable section leaks QA: `Visible copy avoids exact boundaries and named current venues.` |
| 037 | `city-danang-place-hai-san` | `revise_voice` | unsafe | Context/section exposes content mechanics: `Use the dish page for the first ordering decision` and `Keep restaurant-specific claims behind review.` |
| 038 | `city-danang-place-hai-van-pass` | `revise_voice` | unsafe | Importable section leaks QA: `Keep current operational details out of visible copy until checked.` |
| 039 | `city-danang-place-hai-van-pass-ride` | `revise_voice` | unsafe | Context leaks page mechanics: `Use this sibling page for the ride format`; section also says `Safety Details Need Review`. |
| 040 | `city-danang-place-han-market` | `pass_integrity_review` | safe | Central-market bearings and original phrase IDs preserved. |
| 041 | `city-danang-place-han-river` | `revise_voice` | unsafe | Importable section leaks QA: `Promenade access, riverfront works, lighting, event disruptions, and bridge-side crowd controls need current review before specific claims.` |
| 042 | `city-danang-place-han-river-cruise` | `revise_voice` | unsafe | Importable section leaks QA: `Schedules Need Same-Week Proof` and `need current verification before import.` |
| 043 | `city-danang-place-helio-night-market` | `pass_integrity_review` | safe | Controlled night-market role and original phrase IDs preserved. |
| 044 | `city-danang-place-hoa-phu-thanh` | `revise_voice` | unsafe | Context and section leak QA: `freshness-gated`, `Activity Claims Need Current Review`, and `need same-week checking before import.` |
| 045 | `city-danang-place-hoa-trung-lake` | `revise_voice` | unsafe | Importable section leaks QA: `Access Needs Review` and `need checking before import.` |
| 046 | `city-danang-place-international-terminal` | `pass_integrity_review` | safe | Arrival process and original airport phrase IDs preserved. |
| 047 | `city-danang-place-kem-bo` | `revise_voice` | unsafe | Importable copy leaks internal audio/source policy: `dish-specific order line should stay hidden until audio policy and mapping are confirmed.` |
| 048 | `city-danang-place-la-maison-1888` | `revise_voice` | unsafe | Importable section leaks QA: `Current venue status, menu, chef, recognition, booking pattern, and holiday closures need review.` |
| 049 | `city-danang-place-lady-buddha` | `revise_voice` | unsafe | Context leaks page mechanics: `Use the page to connect the English nickname`; section also says `Access Claims Need Review`. |
| 050 | `city-danang-place-le-duan-night-market` | `revise_voice` | unsafe | Importable section leaks QA: `Operating status, hours, stall mix, exact lane footprint, and map status need same-week review.` |
| 051 | `city-danang-place-linh-ung-pagoda` | `pass_integrity_review` | safe | Pagoda/statue distinction preserved without unstable claims. |
| 052 | `city-danang-place-long-coffee` | `pass_integrity_review` | safe | Old-school coffee pause remains specific and non-generic. |
| 053 | `city-danang-place-lotte-mart` | `pass_integrity_review` | safe | Indoor-errand role and original phrase IDs preserved. |
| 054 | `city-danang-place-love-bridge` | `pass_integrity_review` | safe | Small river-pause role and original phrase IDs preserved. |
| 055 | `city-danang-place-madame-lan` | `revise_voice` | unsafe | Context leaks review caution into copy: `Keep dish claims flexible until the current menu is checked.` |
| 056 | `city-danang-place-man-thai-beach` | `pass_integrity_review` | safe | Fishing-edge beach role preserved without service claims. |
| 057 | `city-danang-place-marble-mountain-cave-walk` | `pass_integrity_review` | safe | Cave/shrine pace preserved and non-generic. |
| 058 | `city-danang-place-marble-mountains` | `pass_integrity_review` | safe | Climb/cave/pagoda/stone-shop details preserved. |
| 059 | `city-danang-place-mi-quang` | `pass_integrity_review` | safe | Dish shape is concrete and not venue-dependent. |
| 060 | `city-danang-place-mi-quang-1a` | `revise_voice` | unsafe | Context leaks QA: `Current menu and venue details still need a late check before import.` |
| 061 | `city-danang-place-museum` | `revise_voice` | unsafe | Context leaks publication QA: `Current entrance, hours, tickets, and exhibits need verification before publication.` |
| 062 | `city-danang-place-museum-branch-2` | `blocked_source_too_thin` | unsafe | Source thinness is exposed in the page: `Evidence is thinner than for the main museum, so the copy should stay restrained.` |
| 063 | `city-danang-place-my-an` | `pass_integrity_review` | safe | Neighborhood block rhythm preserved and specific. |
| 064 | `city-danang-place-my-an-beach` | `revise_voice` | unsafe | Context leaks writer instruction: `This beach entry should stay condition-aware.` |
| 065 | `city-danang-place-my-khe` | `revise_voice` | unsafe | Context leaks writer instruction: `the copy should still be weather- and water-aware.` |
| 066 | `city-danang-place-my-quang-ba-mua` | `revise_voice` | unsafe | Context leaks QA: `Avoid current branch, price, hour, and menu-variant claims until checked.` |
| 067 | `city-danang-place-my-quang-dung` | `blocked_source_too_thin` | unsafe | Source thinness is exposed in the page: `The current-source evidence is thin, so keep the copy about the ordering moment and bowl rhythm.` |
| 068 | `city-danang-place-nam-danh-seafood` | `revise_voice` | unsafe | Context leaks QA: `Seafood pricing, hours, address, and holiday closures need a late check.` |
| 069 | `city-danang-place-nam-house` | `pass_integrity_review` | safe | Cafe-room details are concrete and restrained. |
| 070 | `city-danang-place-nam-o-fish-sauce-village` | `revise_voice` | unsafe | Context leaks writer instruction and QA: `The entry should feel like a craft village` and `need checking.` |
| 071 | `city-danang-place-nam-o-reef` | `revise_voice` | unsafe | Context leaks QA: `Tide, weather, access, safety, and route assumptions need late checks before import.` |
| 072 | `city-danang-place-nem-lui` | `revise_voice` | unsafe | Context leaks page mechanics: `The dish entry should explain how to eat`. |
| 073 | `city-danang-place-nen` | `revise_voice` | unsafe | Context leaks QA: `Keep the copy restrained until current menu, booking, hours, dietary handling, and service details are checked.` |
| 074 | `city-danang-place-ngu-hanh-son-district` | `revise_voice` | unsafe | Context leaks writer instruction and QA: `The district entry should help someone orient after check-in` and `need review.` |
| 075 | `city-danang-place-nguyen-hien-dinh-tuong-theatre` | `revise_voice` | unsafe | Context leaks QA: `needs same-week verification before import: program, show time, tickets, access, photo policy, and English support`. |
| 076 | `city-danang-place-nguyen-van-linh-street` | `pass_integrity_review` | safe | Street-orientation role is concrete and non-generic. |
| 077 | `city-danang-place-non-nuoc-beach` | `pass_integrity_review` | safe | Sand/Marble Mountains pairing preserved without service claims. |
| 078 | `city-danang-place-non-nuoc-stone-village` | `pass_integrity_review` | safe | Craft-process details preserved and specific. |
| 079 | `city-danang-place-oc-hut` | `pass_integrity_review` | safe | Dish motion, shells, heat, and sauce preserved. |
| 080 | `city-danang-place-pham-van-dong-beach` | `pass_integrity_review` | safe | Simple beach-air reset preserved without service claims. |
| 081 | `city-danang-place-phap-lam-pagoda` | `pass_integrity_review` | safe | Temple etiquette and central-pause role preserved. |
| 082 | `city-danang-place-phuoc-my` | `pass_integrity_review` | safe | Beach-side area role is specific and not overclaimed. |
| 083 | `city-danang-place-railway-station` | `pass_integrity_review` | safe | Transport handoff remains practical and stable. |
| 084 | `city-danang-place-reply-1988` | `pass_integrity_review` | safe | Retro cafe pause remains concrete and restrained. |
| 085 | `city-danang-place-six-on-six` | `pass_integrity_review` | safe | Leafy cafe pause remains specific and restrained. |
| 086 | `city-danang-place-son-tra` | `pass_integrity_review` | safe | Peninsula route decision preserved without wildlife promises. |
| 087 | `city-danang-place-son-tra-district` | `pass_integrity_review` | safe | District-vs-peninsula distinction preserved. |
| 088 | `city-danang-place-son-tra-night-market` | `pass_integrity_review` | safe | Night-market add-on role and original phrase IDs preserved. |
| 089 | `city-danang-place-son-tra-wildlife-drive` | `pass_integrity_review` | safe | Wildlife treated as unscheduled bonus, not promise. |
| 090 | `city-danang-place-thanh-binh-beach` | `pass_integrity_review` | safe | Sparse source handled cautiously; bay/fishing-boat details preserved. |
| 091 | `city-danang-place-the-temptation` | `blocked_source_too_thin` | unsafe | Page exposes unchecked source limits: `The copy stays menu-light until current venue facts are checked`; venue-specific dinner claims need fresh source before import. |
| 092 | `city-danang-place-thuan-phuoc-bridge` | `pass_integrity_review` | safe | River-mouth bridge role is concrete and stable. |
| 093 | `city-danang-place-tien-sa-port` | `pass_integrity_review` | safe | Port role is practical and avoids access-rule claims. |
| 094 | `city-danang-place-tran-hung-dao-street` | `pass_integrity_review` | safe | East-bank river-street role preserved. |
| 095 | `city-danang-place-tran-thi-ly-bridge` | `pass_integrity_review` | safe | Quieter bridge/skyline contrast preserved. |
| 096 | `city-danang-place-trung-vuong-theatre` | `pass_integrity_review` | safe | Theatre role preserved without program or ticket claims. |
| 097 | `city-danang-place-vincom-plaza` | `pass_integrity_review` | safe | Indoor-errand/mall role preserved without tenant claims. |
| 098 | `city-danang-place-vo-nguyen-giap-street` | `pass_integrity_review` | safe | Beach-road orientation role preserved. |
| 099 | `city-danang-place-wonderlust` | `pass_integrity_review` | safe | Cafe reset remains specific and restrained. |
| 100 | `city-danang-place-yen-retreat` | `revise_voice` | unsafe | Context leaks writer/review language: `The copy stays weather-aware and transport-aware, with no fixed booking, hour, access, or facility claims.` |

## Safe To Import Into Production-Candidate Source

The following pages are safe for Codex import into production-candidate source after this integrity pass:

`city-danang-place-3d-art-in-paradise`, `city-danang-place-ba-na-hills`, `city-danang-place-bac-my-an-market`, `city-danang-place-cham-museum`, `city-danang-place-con-market`, `city-danang-place-domestic-terminal`, `city-danang-place-dong-dinh-museum`, `city-danang-place-fine-arts-museum`, `city-danang-place-han-market`, `city-danang-place-helio-night-market`, `city-danang-place-international-terminal`, `city-danang-place-linh-ung-pagoda`, `city-danang-place-long-coffee`, `city-danang-place-lotte-mart`, `city-danang-place-love-bridge`, `city-danang-place-man-thai-beach`, `city-danang-place-marble-mountain-cave-walk`, `city-danang-place-marble-mountains`, `city-danang-place-mi-quang`, `city-danang-place-my-an`, `city-danang-place-nam-house`, `city-danang-place-nguyen-van-linh-street`, `city-danang-place-non-nuoc-beach`, `city-danang-place-non-nuoc-stone-village`, `city-danang-place-oc-hut`, `city-danang-place-pham-van-dong-beach`, `city-danang-place-phap-lam-pagoda`, `city-danang-place-phuoc-my`, `city-danang-place-railway-station`, `city-danang-place-reply-1988`, `city-danang-place-six-on-six`, `city-danang-place-son-tra`, `city-danang-place-son-tra-district`, `city-danang-place-son-tra-night-market`, `city-danang-place-son-tra-wildlife-drive`, `city-danang-place-thanh-binh-beach`, `city-danang-place-thuan-phuoc-bridge`, `city-danang-place-tien-sa-port`, `city-danang-place-tran-hung-dao-street`, `city-danang-place-tran-thi-ly-bridge`, `city-danang-place-trung-vuong-theatre`, `city-danang-place-vincom-plaza`, `city-danang-place-vo-nguyen-giap-street`, `city-danang-place-wonderlust`.

## Blocked From Import Until Fixed

The following pages are unsafe for import into production-candidate source:

`city-danang-place-43-factory`, `city-danang-place-airport`, `city-danang-place-an-thuong-street-area`, `city-danang-place-apec-park`, `city-danang-place-asia-park`, `city-danang-place-ba-na-cable-car`, `city-danang-place-bach-dang-street`, `city-danang-place-ban-co-peak`, `city-danang-place-banh-mi`, `city-danang-place-banh-trang-cuon-thit-heo`, `city-danang-place-banh-xeo`, `city-danang-place-banh-xeo-ba-duong`, `city-danang-place-be-man`, `city-danang-place-bep-cuon`, `city-danang-place-boulevard-gelato-coffee`, `city-danang-place-bun-cha-ca`, `city-danang-place-bun-cha-ca-hon`, `city-danang-place-cathedral`, `city-danang-place-central-bus-station`, `city-danang-place-che-xoa-xoa-hat-luu`, `city-danang-place-co-chu-nho`, `city-danang-place-cong-caphe-bach-dang`, `city-danang-place-dragon-bridge`, `city-danang-place-dragon-bridge-fire-show`, `city-danang-place-dragon-carp-statue`, `city-danang-place-fatfish`, `city-danang-place-golden-bridge`, `city-danang-place-hai-chau-district`, `city-danang-place-hai-san`, `city-danang-place-hai-van-pass`, `city-danang-place-hai-van-pass-ride`, `city-danang-place-han-river`, `city-danang-place-han-river-cruise`, `city-danang-place-hoa-phu-thanh`, `city-danang-place-hoa-trung-lake`, `city-danang-place-kem-bo`, `city-danang-place-la-maison-1888`, `city-danang-place-lady-buddha`, `city-danang-place-le-duan-night-market`, `city-danang-place-madame-lan`, `city-danang-place-mi-quang-1a`, `city-danang-place-museum`, `city-danang-place-museum-branch-2`, `city-danang-place-my-an-beach`, `city-danang-place-my-khe`, `city-danang-place-my-quang-ba-mua`, `city-danang-place-my-quang-dung`, `city-danang-place-nam-danh-seafood`, `city-danang-place-nam-o-fish-sauce-village`, `city-danang-place-nam-o-reef`, `city-danang-place-nem-lui`, `city-danang-place-nen`, `city-danang-place-ngu-hanh-son-district`, `city-danang-place-nguyen-hien-dinh-tuong-theatre`, `city-danang-place-the-temptation`, `city-danang-place-yen-retreat`.

## Fix Guidance

For `revise_preservation` pages, preserve the rewritten voice if desired, but either remove added `phraseIDs` or document/move the phrase mapping through the proper catalog/audio mapping gate. The original Da Nang source did not contain those IDs.

For `revise_voice` pages, move review/freshness/import notes out of visible/importable fields. Replace them with traveler-facing cautions only when they naturally belong in the page, for example "check the program before crossing town" instead of "needs same-week verification before import."

For `blocked_source_too_thin` pages, do not patch around the problem with softer prose alone. Add or verify source facts first, then rewrite the page from the actual place evidence.
