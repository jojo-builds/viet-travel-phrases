# SpeakLocal Category Page System Design Packet

This packet designs Browse-owned category and city collection pages for SpeakLocal Vietnam. It is a visual design artifact only: no SwiftUI app code was changed.

## Recommendation

Browse city and category cards should open rich collection pages, not Search results. Search can still surface a category result, but tapping it should hand off to the Browse collection page.

The corrected visual direction intentionally reuses the approved Browse/Search packet style: Ha Long Bay hero treatment, large serif page titles, soft white Liquid Glass cards, restrained Vietnam red/green accents, and the locked bottom admin/search chrome.

## Screen Set

| Screen | Asset | Purpose |
| --- | --- | --- |
| Hanoi city hub | `assets/hanoi-city-hub.png` | Shows a city Browse page with first-day shelves, street-name entry, and practice entry. |
| Airport category | `assets/airport-category.png` | Shows subcategories, starter phrase group, and Practice Airport placement. |
| Food category | `assets/food-category.png` | Shows ordering/allergy/payment grouping and Practice Food. |
| Hotel category | `assets/hotel-category.png` | Shows hotel desk phrases, subcategories, saved state, and Practice Hotel. |
| Generic template | `assets/generic-category-template.png` | Uses Shopping as the concrete example for the reusable category template. |
| Search category result | `assets/search-category-result.png` | Shows Search finding a category without replacing Browse as the category surface. |
| Contact sheet | `assets/category-page-system-contact-sheet.png` | One-page overview of the system. |

## Implementation Notes

- Add a Browse collection route for category and city hubs. Bottom Browse remains selected on these pages.
- Browse cards should push the collection route for `airport`, `hotel`, `food`, city IDs like `hanoi`, and future categories.
- Category pages should group phrase rows by subcategory, then open canonical phrase pages for individual rows.
- Place "Practice this category" after the starter phrase group so users understand the practice pool before starting.
- Search should add a category result card type above phrase matches when a query strongly matches a category or city.
- Tapping a Search category result should open the Browse collection route, preserving Search as discovery rather than the category page itself.
- The Vietnamese phrase copy in the mockups is illustrative design copy. Content-side phrase data should supply canonical strings.

## Visual Guardrails

- Use `docs/design/NATIVE_VISUAL_REFERENCE.md` before implementation.
- Preserve the locked bottom admin/search chrome from the 2026-05-01 references and the approved Browse/Search packet.
- Keep Melo out of category/search utility surfaces for now.
- Keep category pages calm and useful for first-time travelers: phrase groups first, dense-but-readable rows, and no generic feature-tour copy.

## Local Review

Open `index.html` to review the gallery. Re-render the PNGs with:

```bash
NODE_PATH=/Users/jojolim/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/node_modules /Users/jojolim/.cache/codex-runtimes/codex-primary-runtime/dependencies/node/bin/node docs/design/category-pages/render-storyboards.js
```
