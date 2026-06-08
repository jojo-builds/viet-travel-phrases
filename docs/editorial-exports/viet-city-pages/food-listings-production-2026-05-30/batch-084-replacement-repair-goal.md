# Batch 084 Replacement Repair Goal

## Objective

Repair Batch 084 only in `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`.

The previous Batch 084 worker `019e94b1-fab4-7201-9383-51282d5af496` wedged after a partial `hoian.json` source patch. Do not continue that thread and do not advance to Batch 085.

## Batch 084 Listings

- `city-hoian-place-faifo-coffee`
- `city-hoian-place-folk-culture-museum`
- `city-hoian-place-from-danang-airport`
- `city-hoian-place-from-danang-railway-station`
- `city-hoian-place-fujian-assembly-hall`
- `city-hoian-place-hainan-assembly-hall`
- `city-hoian-place-handicraft-workshop`
- `city-hoian-place-history-culture-museum`

## Repair Scope

Start from the current disk state. Preserve all useful phrase cards, related cards, page IDs, and links. Do not thin the copy just to pass scans.

Repair remaining visible/source/card-rationale/generated/intake leaks including:

- `the draw`, `behind`, `should`, `surfaces`, `stop`, `scale`, `comparison`, `contrast`, `pause`, `feel`, `works`, `why`, `clearer`, `context`, `helps`
- legacy labels such as `Why go`
- use-style instruction copy in active intake rows

Known false positives may be ignored only when they are metadata or substring-only and not visible/source/card prose:

- `stable-traveler-context`
- `content-role-*`
- `workshops` containing `works`

## Current Audit Findings

The orchestrator disk scan after the wedged worker found `TOTAL_STRICT_HITS 105` across:

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-authored-listing-pages.json`

Representative blockers:

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:4697` has `The draw is...`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:4775` has `An Indoor Side Behind The Streets`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:4925` has `should take`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:5146` has `red-and-gold surfaces`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:5226` and `:5258` have `yellow-red surfaces`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:5334` through `:5338` have `table height` / `behind`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json:5449` has `Ceramics Behind The Streets`
- `native-ios/Resources/viet-authored-listing-pages.json:278143` and nearby generated entries still contain the same leaked source copy, so regenerate projections after source repair.
- `docs/city-production/agent-inputs/hoian-nouns.md:23`, `:35`, `:38`, `:151`, and `:152` still have target-linked intake seed leaks such as `helps`, `context`, `stop`, and use-style copy.
- `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/City_Listing_Ledger.csv:341`, `:342`, `:343`, `:345`, `:346`, and `:347` still have `Why go`, `works`, `why`, `clearer`, `context`, `feel`, or `stop`.

Structure check before replacement:

- All eight target records still have 3 phrase cards.
- All eight target records still have 1 related card.

## Required Validation

Before reporting ready:

1. Re-run source/projection/generated scans for the eight Batch 084 targets.
2. Recheck target-linked intake rows in `hoian-nouns.md` and `City_Listing_Ledger.csv`.
3. Confirm phrase card and related card counts were preserved.
4. Regenerate source projections/generated native resource if source or handwritten copy changed.
5. Run `git diff --check`.
6. Produce the required screenshot proof for Batch 084 if the earlier worker did not already create a current proof.

## Required Report

Stop after Batch 084 and report exactly:

`**Batch 084 Replacement Repair Ready For Orchestrator Review**`

Include:

- files changed;
- scans run and counts;
- phrase card / related card preservation counts;
- screenshot proof path;
- any accepted false positives with reason.
