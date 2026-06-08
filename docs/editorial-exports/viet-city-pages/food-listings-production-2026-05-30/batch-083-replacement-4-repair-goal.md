# Batch 083 Replacement 4 Repair Goal

Repair Batch 083 source/generated leaks only in this worktree:

`/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Do not advance to Batch 084. Previous worker `019e940d-7e67-7613-a861-5e350b335c5a` hit `systemError` before the repair landed.

## Exact Blockers

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:3734` and generated `native-ios/Resources/viet-authored-listing-pages.json:276713`: Com Ga Ba Buoi uses `coffee stops`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:3988`, `4022`, `4024`, `4048`, `4049` and generated `native-ios/Resources/viet-authored-listing-pages.json:277026`, `277115`: Countryside bicycle loop uses `named stops`, `fields-between-stops`, and `craft stops`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:4251`: Cua Dai Estuary section id uses `short-water-edge-stop`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:4482` and generated `native-ios/Resources/viet-authored-listing-pages.json:277815`: Duc An Old House uses `surfaces`.

## Constraints

- Patch authored source first.
- Preserve concrete place/food details and useful related-card value.
- Regenerate only required outputs.
- Do not touch Batch 084 or unrelated rows.
- Do not thin copy just to satisfy scans.

## Verification

Rerun a target-only scan for the eight Batch 083 listings:

- `com-ga-ba-buoi`
- `cooking-class`
- `countryside-bicycle-loop`
- `cua-dai-beach`
- `cua-dai-estuary`
- `cua-dai-pier`
- `duc-an-old-house`
- `espresso-station`

Also run `git diff --check`.

Report exactly:

`**Batch 083 Replacement 4 Source/Generated Repair Ready For Orchestrator Review**`

Then stop.
