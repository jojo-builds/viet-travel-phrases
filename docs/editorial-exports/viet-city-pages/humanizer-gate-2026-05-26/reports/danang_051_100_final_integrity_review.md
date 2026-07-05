# Da Nang 051-100 Final Integrity Review

Reviewer: independent city-page integrity + humanizer review  
Date: 2026-05-26  
Scope: `danang` entries 051-100 only  
Source: `content-draft/viet/city-library/handwritten-copy/danang.json`  
Chunks reviewed:
- `chunks/danang_051_075_humanized.json`
- `chunks/danang_076_100_humanized.json`

This is a no-deletion/no-bloat/humanizer integrity gate. It does not mark anything production-ready. It only says whether the chunk copy is safe for Codex import into production-candidate source.

## Summary Counts

| Decision | Count |
|---|---:|
| `pass_integrity_review` | 42 |
| `revise_voice` | 7 |
| `revise_preservation` | 1 |
| `blocked_source_too_thin` | 0 |

Safe for Codex import into production-candidate source: 42 pages.

Unsafe for Codex import until revised: 8 pages.

Coordinator note, 2026-05-26: Repaired all 8 unsafe pages in the assigned 051-100 chunks. The 7 `revise_voice` pages had visible editor/process wording converted to traveler-facing copy; `city-danang-place-son-tra-night-market` had the extra `when-to-use` section removed while preserving phraseIDs and source sections. After the shared validator tightened, additional banned reviewer-language fragments in the assigned chunks were also converted to traveler-facing copy; both assigned chunks now validate as `pass`.

PhraseID check: safe. Existing phraseIDs were preserved exactly on `city-danang-place-lotte-mart`, `city-danang-place-love-bridge`, `city-danang-place-museum`, and `city-danang-place-son-tra-night-market`. No phraseIDs were added to pages whose source had none.

## Per-Page Decisions

| # | Page ID | Decision | Import status | Notes / snippets needing revision |
|---:|---|---|---|---|
| 051 | `city-danang-place-linh-ung-pagoda` | `pass_integrity_review` | safe | Preserves pagoda, Son Tra, Lady Buddha, temple manners, and no phraseIDs added. |
| 052 | `city-danang-place-long-coffee` | `pass_integrity_review` | safe | Concrete old-school cafe details preserved; no phraseIDs added. |
| 053 | `city-danang-place-lotte-mart` | `pass_integrity_review` | safe | PhraseIDs preserved exactly: `price-1`, `shop-5`, `store-2`, `store-7`. |
| 054 | `city-danang-place-love-bridge` | `pass_integrity_review` | safe | PhraseIDs preserved exactly: `directions-1`, `sight-3`, `sight-4`, `taxi-3`. |
| 055 | `city-danang-place-madame-lan` | `pass_integrity_review` | safe | Restaurant role and courtyard/shared-plate moment survive without menu overclaiming. |
| 056 | `city-danang-place-man-thai-beach` | `pass_integrity_review` | safe | Preserves working beach, boats, Son Tra hills, and early coastal pause. |
| 057 | `city-danang-place-marble-mountain-cave-walk` | `pass_integrity_review` | safe | Preserves cave/shrine/stair pace and respectful behavior. |
| 058 | `city-danang-place-marble-mountains` | `pass_integrity_review` | safe | Preserves broader Ngu Hanh Son cluster, caves, pagodas, viewpoints, and stone shops. |
| 059 | `city-danang-place-mi-quang` | `pass_integrity_review` | safe | Dish-specific, textured, and not hollow; no phraseIDs added. |
| 060 | `city-danang-place-mi-quang-1a` | `revise_voice` | unsafe | Visible/process-flavored context: "A focused noodle-stop note, not a broad dinner pitch" and "without promising exact menu details." Revise into traveler-facing meal guidance. |
| 061 | `city-danang-place-museum` | `revise_voice` | unsafe | Visible editor language in context: "Current entrance, hours, tickets, and exhibits need verification before publication." PhraseIDs preserved exactly, but this line should become traveler-facing or internal-only. |
| 062 | `city-danang-place-museum-branch-2` | `pass_integrity_review` | safe | Small culture-pause role is intact; no phraseIDs added. |
| 063 | `city-danang-place-my-an` | `pass_integrity_review` | safe | Neighborhood copy feels specific enough: cafes, hotel edges, lanes, return point. |
| 064 | `city-danang-place-my-an-beach` | `pass_integrity_review` | safe | Preserves quieter beach-entry role and condition-aware water language. |
| 065 | `city-danang-place-my-khe` | `pass_integrity_review` | safe | Strong coastal-scale page; no unsupported service/safety claims. |
| 066 | `city-danang-place-my-quang-ba-mua` | `revise_voice` | unsafe | Context sounds like QA/process copy: "without promising branch, price, hour, or menu-variant details." Sections are usable, but visible framing should be humanized. |
| 067 | `city-danang-place-my-quang-dung` | `revise_voice` | unsafe | Context/rationale expose review language: "exact menu or branch claims" and "without inventing current menu specifics." Revise out of metadata tone. |
| 068 | `city-danang-place-nam-danh-seafood` | `pass_integrity_review` | safe | Table rhythm, shared rounds, and seafood setting preserved without price/menu invention. |
| 069 | `city-danang-place-nam-house` | `pass_integrity_review` | safe | Cafe room details and short reset moment survive. |
| 070 | `city-danang-place-nam-o-fish-sauce-village` | `pass_integrity_review` | safe | Strong preservation of craft, barrels, anchovies, salty air, and Nam O specificity. |
| 071 | `city-danang-place-nam-o-reef` | `pass_integrity_review` | safe | Tide/weather/access caution is traveler-facing, not editor-facing. |
| 072 | `city-danang-place-nem-lui` | `pass_integrity_review` | safe | Dish ritual is concrete; no phraseIDs added. |
| 073 | `city-danang-place-nen` | `revise_voice` | unsafe | Visible editor instruction in context: "Keep the copy restrained until current menu, booking, hours, dietary handling, and service details are checked." Move this to internal QA or rewrite as natural planning copy. |
| 074 | `city-danang-place-ngu-hanh-son-district` | `pass_integrity_review` | safe | District orientation, Marble Mountains marker, and south-beach role are intact. |
| 075 | `city-danang-place-nguyen-hien-dinh-tuong-theatre` | `revise_voice` | unsafe | Repeats the same program/start-time/ticket warning across `place-brief`, `when-to-use`, and `good-to-know`; reduce duplication so it reads like a travel note, not repeated QA gating. |
| 076 | `city-danang-place-nguyen-van-linh-street` | `pass_integrity_review` | safe | Street-orientation copy is practical and concrete; no phraseIDs added. |
| 077 | `city-danang-place-non-nuoc-beach` | `pass_integrity_review` | safe | Preserves sand, limestone, Marble Mountains pairing, and weather margin. |
| 078 | `city-danang-place-non-nuoc-stone-village` | `pass_integrity_review` | safe | Craft process and Marble Mountains relationship are preserved. |
| 079 | `city-danang-place-oc-hut` | `pass_integrity_review` | safe | Dish copy is concrete: shells, lemongrass, chili, sauce, first-order rhythm. |
| 080 | `city-danang-place-pham-van-dong-beach` | `pass_integrity_review` | safe | Beach reset is restrained and not overclaimed. |
| 081 | `city-danang-place-phap-lam-pagoda` | `pass_integrity_review` | safe | Pagoda etiquette and central-city quiet are preserved. |
| 082 | `city-danang-place-phuoc-my` | `pass_integrity_review` | safe | Neighborhood identity feels traveler-useful, not hollow. |
| 083 | `city-danang-place-railway-station` | `pass_integrity_review` | safe | Station handoff, boards, bags, curb, and Vietnamese name are intact. |
| 084 | `city-danang-place-reply-1988` | `pass_integrity_review` | safe | Cafe copy is modest but concrete enough; no added phraseIDs. |
| 085 | `city-danang-place-six-on-six` | `pass_integrity_review` | safe | Leafy cafe pause and shade/seat moment are clear. |
| 086 | `city-danang-place-son-tra` | `pass_integrity_review` | safe | Peninsula route/weather/return decision is preserved. |
| 087 | `city-danang-place-son-tra-district` | `pass_integrity_review` | safe | District-vs-peninsula distinction is useful and preserved. |
| 088 | `city-danang-place-son-tra-night-market` | `revise_preservation` | unsafe | Source sections were `at-glance`, `place-brief`, `quick-say`, `use-it-with`, `good-to-know`; humanized chunk adds a new `when-to-use` section. PhraseIDs are preserved exactly, but this is bloat relative to source. |
| 089 | `city-danang-place-son-tra-wildlife-drive` | `pass_integrity_review` | safe | Wildlife is framed as a possible bonus, not a promise; no phraseIDs added. |
| 090 | `city-danang-place-thanh-binh-beach` | `pass_integrity_review` | safe | Sparse source is handled cautiously; not blocked because the copy stays small and condition-aware. |
| 091 | `city-danang-place-the-temptation` | `pass_integrity_review` | safe | Slower dinner role is preserved without menu/hour/booking invention. |
| 092 | `city-danang-place-thuan-phuoc-bridge` | `pass_integrity_review` | safe | Bridge, river-mouth, wind, and route-marker role are concrete. |
| 093 | `city-danang-place-tien-sa-port` | `pass_integrity_review` | safe | Working-port caution is traveler-facing and does not invent access rules. |
| 094 | `city-danang-place-tran-hung-dao-street` | `pass_integrity_review` | safe | East-bank river orientation and bridge-side decision survive. |
| 095 | `city-danang-place-tran-thi-ly-bridge` | `pass_integrity_review` | safe | Clear distinction from Dragon Bridge; no phraseIDs added. |
| 096 | `city-danang-place-trung-vuong-theatre` | `pass_integrity_review` | safe | Program-check language is traveler-facing and less repetitive than page 075. |
| 097 | `city-danang-place-vincom-plaza` | `pass_integrity_review` | safe | Mall/reset/meetup role is practical and not overclaimed. |
| 098 | `city-danang-place-vo-nguyen-giap-street` | `pass_integrity_review` | safe | Beach-road pickup/crossing utility is concrete. |
| 099 | `city-danang-place-wonderlust` | `revise_voice` | unsafe | Context exposes QA language: "not a long agenda with unsupported venue claims." Replace with a natural cafe-use line. |
| 100 | `city-danang-place-yen-retreat` | `pass_integrity_review` | safe | Thin source remains usable because copy stays weather/return-margin aware without inventing operations. |

## Unsafe For Import Until Revised

`revise_voice`:
- `city-danang-place-mi-quang-1a`
- `city-danang-place-museum`
- `city-danang-place-my-quang-ba-mua`
- `city-danang-place-my-quang-dung`
- `city-danang-place-nen`
- `city-danang-place-nguyen-hien-dinh-tuong-theatre`
- `city-danang-place-wonderlust`

`revise_preservation`:
- `city-danang-place-son-tra-night-market`

## Safe For Import

All other scoped pages are safe for Codex import into production-candidate source, subject to the later normal catalog/audio mapping, rendered screenshot review, and production review gates. This review does not call them production-ready.
