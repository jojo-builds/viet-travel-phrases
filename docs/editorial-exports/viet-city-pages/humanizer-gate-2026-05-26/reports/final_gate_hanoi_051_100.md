# Final Gate: Hanoi 051-100 Humanized City Copy

Date: 2026-05-26
Reviewer: Codex read-only final production gate
Scope:
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_051_075_humanized.json`
- `docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/chunks/hanoi_076_100_humanized.json`
- Compared against `content-draft/viet/city-library/handwritten-copy/hanoi.json` indices 50-99

## Summary

Reviewed all 50 visible entries across summary, context, tip, rationale, and every section title/body.

safe_for_import count: 6
unsafe_for_import count: 44

Hanoi 051-100 does not pass the final production gate. The strongest traveler-facing section copy is often usable, but many visible `context` or `rationale` fields still expose editorial/process framing such as `The useful moment`, `The page`, `The entry`, `avoids`, `claims`, or `promise`. One phrase-backed entry also has an empty visible `quick-say` body.

## Preservation Checks

- Page order and pageIDs match source indices 50-99.
- All source section IDs are present in the humanized entries.
- Several entries in `hanoi_076_100_humanized.json` place `quick-say` before `place-brief`; this report treats that as ID-preserved, not deletion, because the requested section IDs remain present.
- PhraseIDs are preserved exactly for the one phrase-backed entry in this scope:
  - `city-hanoi-place-the-note-coffee`: `coffee-1`, `coffee-4`, `coffee-6`, `coffee-7`
- No page without source phraseIDs gained phraseIDs.

Validation command run:

```sh
node docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js
```

Result:

```txt
Humanizer chunk validation passed. entries=200 warnings=0
```

## Unsafe Entries

| pageID | snippet | reason |
|---|---|---|
| `city-hanoi-place-my-dinh-bus-station` | `context: "This is a travel-day handoff, not a sightseeing pitch. The useful moment is matching the station name, ticket, bay, and ride plan before the crowd starts moving."` | Visible process framing; `The useful moment` reads like an editorial note rather than mobile travel copy. |
| `city-hanoi-place-nang-cafe` | `context: "The entry should feel like a coffee stop, not a full cafe biography. The useful moment is choosing a classic drink, sitting briefly, then returning to the street."` | Visible process framing; `The entry should feel` and `The useful moment` are editor-facing. |
| `city-hanoi-place-national-museum-history` | `context: "The useful moment is museum pacing. Pick one lane through the collection instead of trying to absorb the whole country in a single visit."` | Visible process framing; `The useful moment` is not natural traveler copy. |
| `city-hanoi-place-nem-cua-be` | `context: "The useful moment is ordering one shared plate without overloading the meal. Shellfish awareness matters more here than adventurous guesswork."` | Visible process framing; `The useful moment` is not production-ready copy. |
| `city-hanoi-place-ngoc-son-temple` | `context: "The useful moment is crossing from Hoàn Kiếm Lake into a quiet temple space. The visit should feel respectful, short, and tied to the lake."` | Visible process framing; `The useful moment` and `should feel` read like review notes. |
| `city-hanoi-place-nguyen-huu-huan-street` | `context: "The useful moment is choosing one coffee room from the street instead of treating a famous cup as the whole story."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-night-market-walk` | `context: "The useful moment is making one lap before buying. Looking first keeps the night open and prevents one stall from swallowing the walk."` | Visible process framing; `The useful moment` is not natural mobile copy. |
| `city-hanoi-place-noi-bai-airport` | `context: "The useful moment is arrival discipline. Clear immigration, bags, pickup point, and hotel address before stepping into the public arrival area."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-nuoc-ngam-bus-station` | `context: "The useful moment is confirming the right bay and ticket before settling. The tone should stay operational and calm, not romantic."` | Visible process framing; `The useful moment` and `The tone should` expose copy direction. |
| `city-hanoi-place-old-quarter` | `context: "The useful moment is choosing one short spine through the neighborhood instead of trying to collect every lane."` | Visible process framing; `The useful moment` is not traveler-facing. |
| `city-hanoi-place-old-quarter-walking-tour` | `context: "The useful moment is planning a route short enough to stay enjoyable. Three stops can teach more than ten names."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-one-pillar-pagoda` | `context: "The useful moment is looking slowly at a small landmark instead of taking one quick photo and leaving."` | Visible process framing; `The useful moment` is not natural copy. |
| `city-hanoi-place-opera-house` | `context: "The useful moment is deciding whether the building is a pass-by landmark or an actual show night."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-phan-dinh-phung-street` | `context: "The useful moment is a short shaded walk that relieves Old Quarter compression without becoming a full itinerary."` | Visible process framing; `The useful moment` is not production-ready traveler copy. |
| `city-hanoi-place-pho-bat-dan` | `context: "The useful moment is ordering the bowl before the room starts moving around you. The stop is about broth, not a long sit."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-pho-bo` | `context: "The useful moment is restraint. Taste the broth first, then adjust the bowl instead of turning the table into a condiment project."` | Visible process framing; `The useful moment` is not natural mobile copy. |
| `city-hanoi-place-pho-bo-lam` | `context: "The useful moment is choosing texture on purpose. Tendon changes the bowl, so the order should not feel like a menu test."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-pho-ga` | `context: "The useful moment is picking the gentler pho lane after richer meals or when a cleaner bowl sounds better."` | Visible process framing; `The useful moment` is not traveler-facing. |
| `city-hanoi-place-pho-gia-truyen` | `context: "The useful moment is knowing the bowl before the rush. The appeal is not decoration; it is the counter pace and the broth."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-quan-thanh-temple` | `context: "The useful moment is pausing at the gate before treating the temple like another photo stop."` | Visible process framing; `The useful moment` is not natural copy. |
| `city-hanoi-place-quang-ba-flower-market` | `context: "The useful moment is observing a working market before stepping into its flow. The flowers are moving for real customers, not only photos."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-red-river` | `context: "The useful moment is looking from a safer, clearer frame before wandering toward uneven river edges."` | Visible process framing; `The useful moment` is not production-ready copy. |
| `city-hanoi-place-st-joseph-cathedral` | `context: "The useful moment is reading the square before entering. The outside atmosphere is part of the stop."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-street-food-walk` | `context: "The useful moment is keeping the route loose and the orders light enough for the evening to stay open."` | Visible process framing; `The useful moment` is not natural mobile copy. |
| `city-hanoi-place-ta-hien` | `context: "The useful moment is walking the block once before taking a stool. The scene is compressed, loud, and better with a small decision."` | Visible process framing; `The useful moment` is editor-facing. |
| `city-hanoi-place-tam-vi` | `context: "The page is strongest when the meal carries part of the evening. It avoids menu and guide-status promises."` | Visible process framing; `The page`, `avoids`, and `promises` expose review logic. |
| `city-hanoi-place-tay-ho` | `context: "This is a neighborhood-orientation entry, not a promise about any one cafe, shop, or current business cluster."` | Visible process framing; `entry` and `promise` read like internal classification. |
| `city-hanoi-place-the-note-coffee` | `[quick-say] Useful Phrases ::` | Visible section body is empty. This fails the no deletion or thin bodies gate, even though phraseIDs are preserved. |
| `city-hanoi-place-thong-nhat-park` | `context: "This is an everyday park pause, not a formal attraction or a facilities promise. The entry stays durable and low-claim."` | Visible process framing; `entry`, `promise`, and `low-claim` are editor-facing. |
| `city-hanoi-place-train-street` | `rationale: "The page gives a clear safety-forward version of a famous Hanoi scene without turning uncertainty into fear language."` | Visible process framing; `The page gives` and `fear language` expose copy strategy. |
| `city-hanoi-place-trang-tien-plaza` | `context: "The page frames a city-center break without promising tenants, food counters, hours, payment norms, or access details."` | Visible process framing; `The page frames` and `without promising` are review language. |
| `city-hanoi-place-trang-tien-street` | `context: "This is a street-orientation entry, not a shopping promise. Business mix can change, so the focus is movement and street feel."` | Visible process framing; `entry`, `promise`, and `the focus is` are editor-facing. |
| `city-hanoi-place-trieu-viet-vuong-coffee-street` | `rationale: "The page gives Hanoi's coffee culture a physical street moment instead of reducing it to one drink label."` | Visible process framing; `The page gives` exposes copy strategy. |
| `city-hanoi-place-truc-bach-lake` | `context: "The lake entry stays about a short edge walk and cafe pause, not a full-loop promise or named business guide."` | Visible process framing; `entry` and `promise` read like internal classification. |
| `city-hanoi-place-turtle-tower` | `context: "The landmark is framed as a view and orientation point, with no access, hour, or event claims."` | Visible process framing; `is framed` and `claims` are review language. |
| `city-hanoi-place-udam` | `context: "The restaurant entry avoids menu promises while still making the vegetarian meal feel substantial and specific."` | Visible process framing; `entry`, `avoids`, and `promises` are editor-facing. |
| `city-hanoi-place-vietnam-art-gallery` | `rationale: "The page keeps a gallery option in the city set while staying careful about changing exhibitions and opening details."` | Visible process framing; `The page keeps` exposes catalog strategy. |
| `city-hanoi-place-vietnam-circus` | `rationale: "The page adds a live-night option to Hanoi without reducing it to an exterior building or making unstable show claims."` | Visible process framing; `The page adds` and `claims` are editor-facing. |
| `city-hanoi-place-vietnam-fine-arts-museum` | `context: "The page avoids ticket, hour, exhibit, and photo-policy claims while keeping the cultural stop vivid."` | Visible process framing; `The page avoids` and `claims` are review language. |
| `city-hanoi-place-weekend-night-market` | `rationale: "The market page gives Hanoi night energy a practical shape without promising exact stalls, prices, routes, or current operations."` | Visible process framing; `page gives` and `without promising` expose copy strategy. |
| `city-hanoi-place-west-lake` | `context: "The lake entry avoids venue, event, parking, or access claims while giving readers a clear shoreline decision."` | Visible process framing; `entry avoids` and `claims` are review language. |
| `city-hanoi-place-west-lake-loop` | `context: "The route entry avoids transport-service, closure, rental, or traffic-rule claims while keeping the loop flexible."` | Visible process framing; `entry avoids` and `claims` are review language. |
| `city-hanoi-place-xoi-xeo` | `context: "This dish entry stays concrete without promising a vendor, price, topping set, or exact service style."` | Visible process framing; `entry` and `without promising` are editor-facing. |
| `city-hanoi-place-yen-so-park` | `rationale: "Yen So Park gives the Hanoi inventory a south-side open-air pause that can stay useful without detailed facility claims."` | Visible process framing; `inventory` and `claims` expose catalog/review language. |

## Safe Entries

The following 6 entries pass this final gate: `city-hanoi-place-temple-literature`, `city-hanoi-place-tran-quoc-pagoda`, `city-hanoi-place-vietnam-military-history-museum`, `city-hanoi-place-vietnam-national-tuong-theatre`, `city-hanoi-place-water-puppet-theatre`, and `city-hanoi-place-womens-museum`.

## Final Decision

Do not import Hanoi 051-100 as a complete production batch. Import only the 6 safe entries, or repair the 44 unsafe entries by replacing visible process/context/rationale language with natural mobile travel copy and filling the empty `quick-say` body for `city-hanoi-place-the-note-coffee`.
