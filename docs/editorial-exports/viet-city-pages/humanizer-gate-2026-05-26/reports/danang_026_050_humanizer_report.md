# Da Nang 026-050 Humanizer Report

Date: 2026-05-26
Worker: D2
Output chunk: `chunks/danang_026_050_humanized.json`

## Scope

Rewrote Da Nang source entries 026-050 only:

- `city-danang-place-con-market` through `city-danang-place-le-duan-night-market`
- 25 complete city-library entries
- Existing source `phraseIDs` preserved exactly where present
- No source/runtime files edited

## Changed Themes

- Replaced generator-like headings such as "Why go," "What you'll get," "Worth it if," and "Before you go" with natural traveler moments.
- Revised the stricter-gate command headings that began with `Use`, `Keep`, `Choose`, `Ask`, or `Confirm`.
- Removed visible meta phrasing such as "this page," "map pin," "helps ...," and "works best ..." from app-facing entry text.
- Repair pass removed remaining visible QA/import language such as freshness checks, same-week checks, current review, needs review, and copy-should notes.
- Replaced unstable operational notes with traveler-facing cautions about checking schedules, weather, tickets, routes, seating, boarding, or market conditions before committing a plan.
- Replaced those lines with observed travel notes: market laps, pickup flow, river framing, weather tradeoffs, coffee pauses, and table rhythm.
- Split close sibling pages by job:
  - Dragon Bridge = where to stand and how to read the landmark.
  - Dragon Bridge fire show = timed crowd ritual and exit choice.
  - Hai Van Pass = scenic old road.
  - Hai Van Pass ride = driver/pace/weather decision.
  - Han River = waterline orientation.
  - Han River cruise = boarding and boat clarity.
- Kept thin-source pages restrained instead of inflating them:
  - `city-danang-place-hoa-trung-lake`
  - `city-danang-place-hoa-phu-thanh`
  - `city-danang-place-hai-chau-district`
  - `city-danang-place-le-duan-night-market`
- Removed unstable visible claims around hours, ticket prices, exact doors, current pickup zones, menu availability, show schedules, venue recognition, and access rules.
- Preserved the stronger existing market and airport frames where they were already close, then tightened paragraph rhythm and voice.

## Revise Pages

No page needs another visible-copy revision from the stricter D2 pass.

Integrity review should still treat these as source candidates, not import approval. Several pages need phrase/audio mapping because the current source entry had no `phraseIDs` array to preserve.

## 2026-05-26 Coordinator Voice Repair

- Repaired the fourteen D2 pages flagged `revise_voice` by the final integrity review: `city-danang-place-cong-caphe-bach-dang`, `city-danang-place-domestic-terminal`, `city-danang-place-dragon-bridge-fire-show`, `city-danang-place-fatfish`, `city-danang-place-hai-chau-district`, `city-danang-place-hai-san`, `city-danang-place-hai-van-pass-ride`, `city-danang-place-han-river`, `city-danang-place-han-river-cruise`, `city-danang-place-hoa-phu-thanh`, `city-danang-place-hoa-trung-lake`, `city-danang-place-kem-bo`, `city-danang-place-la-maison-1888`, and `city-danang-place-le-duan-night-market`.
- Also cleared the tightened validator's added reviewer-language hits inside the assigned D2 range, including `works best` families on Fatfish, Golden Bridge, and Hàn River cruise.
- Replaced editor-facing review language with traveler-facing caution or purpose; phrase IDs, section IDs, and source order were preserved.
- Current validator result for `danang_026_050_humanized.json`: `status: pass`, `errors: 0`, `warnings: 0`.

## Validation

Command run:

```sh
node /Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages/docs/editorial-exports/viet-city-pages/humanizer-gate-2026-05-26/validate-humanizer-chunks.js || true
```

Repair rerun still reports failures from other chunks, but D2 is clean:

- `danang_026_050_humanized.json`
- status: `pass`
- entries: `25`
- errors: `0`
- warnings: `0`
- overall validator errors in shared report: `2` from non-assigned Hanoi chunks

## Phrase / Audio Risks

Existing `phraseIDs` were preserved on:

- `city-danang-place-con-market`
- `city-danang-place-dong-dinh-museum`
- `city-danang-place-dragon-bridge`
- `city-danang-place-fine-arts-museum`
- `city-danang-place-han-market`
- `city-danang-place-helio-night-market`
- `city-danang-place-international-terminal`

The following pages have no preserved `phraseIDs` in the source entry and need phrase/audio mapping before import:

- `city-danang-place-cong-caphe-bach-dang`
- `city-danang-place-domestic-terminal`
- `city-danang-place-dragon-bridge-fire-show`
- `city-danang-place-dragon-carp-statue`
- `city-danang-place-fatfish`
- `city-danang-place-golden-bridge`
- `city-danang-place-hai-chau-district`
- `city-danang-place-hai-san`
- `city-danang-place-hai-van-pass`
- `city-danang-place-hai-van-pass-ride`
- `city-danang-place-han-river`
- `city-danang-place-han-river-cruise`
- `city-danang-place-hoa-phu-thanh`
- `city-danang-place-hoa-trung-lake`
- `city-danang-place-kem-bo`
- `city-danang-place-la-maison-1888`
- `city-danang-place-lady-buddha`
- `city-danang-place-le-duan-night-market`

Special risk:

- `city-danang-place-dragon-bridge` has a secondary `phraseIDs` array on the `use-it-with` section in the source. It was preserved unchanged and should be checked by the importer/integrity script.

## Freshness Risks To Keep Internal

- Airport terminal pickup flows, doors, signage, SIM/ATM counters, and ride-app pickup points.
- Dragon Bridge fire-show schedule, weather, crowd controls, and traffic restrictions.
- River cruise operators, boarding points, routes, ticketing, and safety equipment.
- Market hours, stall mix, seafood pricing, payment norms, and current operating status.
- Restaurant/cafe hours, venue status, menu availability, terrace/seating claims, chef/award claims, and holiday closures.
- Outdoor/nature access, road conditions, lake conditions, water activity availability, gear rules, and weather.

## Notes For Importer / Next Gate

- This chunk is old city-library source shape, not a v2.2 app-detail object.
- Visible prose was written toward the v2.2 voice gate, but catalog cards, related candidates, and app-detail phrase cards are not normalized here.
- Run an integrity pass before import to verify:
  - 25 expected page IDs are present in order.
  - JSON parses cleanly.
  - Preserved phrase IDs exist in the catalog/audio runtime.
  - Pages without source phrase IDs get mapped or explicitly queued.
  - No internal decision notes render in app-visible copy.
