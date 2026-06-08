# Batch 084 Replacement 3 Direct Patch Goal

## Objective

Patch Batch 084 only in `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`.

Replacement workers `019e94b1-fab4-7201-9383-51282d5af496`, `019e9512-3769-7662-8e8e-d8c6bce99c38`, and `019e9578-e66b-76d1-a4aa-6334cc66ff62` wedged or made no disk progress and have been told to hold.

Do not advance to Batch 085. Do not run feature-flow, lane sync, merge, rebase, or cleanup. The worktree is intentionally dirty.

## First Action

Do not do a long planning turn. Read this file, then immediately patch the named Batch 084 source/intake rows below.

## Current Disk State

The latest orchestrator audit found no progress from Replacement 2:

- `TOTAL_STRICT_HITS 105`
- `INTAKE_HIT_ROWS 11`
- all eight target records still have `phraseCards=3 related=1`
- `git diff --check` is clean

## Batch 084 Target IDs

- `city-hoian-place-faifo-coffee`
- `city-hoian-place-folk-culture-museum`
- `city-hoian-place-from-danang-airport`
- `city-hoian-place-from-danang-railway-station`
- `city-hoian-place-fujian-assembly-hall`
- `city-hoian-place-hainan-assembly-hall`
- `city-hoian-place-handicraft-workshop`
- `city-hoian-place-history-culture-museum`

## Edit Roots

Patch these roots first:

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `docs/city-production/agent-inputs/hoian-nouns.md`
- `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/City_Listing_Ledger.csv`

Then regenerate/update:

- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- generated SQLite/report files if required by the existing generator

## Required Rewrite Targets

Remove or rewrite these visible/source/card-rationale/intake leaks while preserving concrete place proof:

- Faifo Coffee: replace `The draw is...`; keep Tran Phu, tiled roofs, yellow walls, rooftop/cafe detail.
- Folk Culture Museum: remove `behind`; keep lanterns, textiles, wooden beams, household/craft displays.
- Da Nang Airport route: remove `should`; keep pickup door/lane, driver name, hotel address, road into Hội An.
- Railway Station route: preserve phrase card `You can stop here` and page ID `transport-stop-here` as accepted phrase false positives; remove `context`/process leakage elsewhere.
- Fujian Assembly Hall: remove `surfaces` and `the draw`; keep incense, tiled roofs, carved detail, courtyard, altars, worship areas.
- Hainan Assembly Hall: remove `surfaces`; keep incense coils, yellow/red facade, courtyard, altars, smaller hall.
- Handicraft Workshop: remove `behind`; avoid relying on `table height` if it keeps tripping scans; keep tools, hands, textiles, lanterns, craft tables, finished objects.
- History and Culture Museum: remove `behind`; keep ceramics, trade memory, maps, display cases, older objects.
- Related cards: preserve targets, but rewrite `comparison`, `compare`, `contrast`, `pause`, and `scale` out of relationship/subtitle/reason text.
- Intake rows: remove `helps`, `context`, `Why go`, `works`, `why`, `clearer`, `feel`, and `stop` from target-linked prose unless it is a legitimate title substring like `Workshop`.

## Validation

Run:

- target-only strict source/generated scan;
- target-linked intake scan;
- phrase-card and related-card count check;
- `git diff --check`;
- generated resource / SQLite scan if regenerated;
- Batch 084 screenshot proof or cite the current proof path if already created during this repair.

## Report

Stop after Batch 084 and report:

`**Batch 084 Replacement 3 Direct Patch Ready For Orchestrator Review**`

Include changed files, scan counts, preserved card counts, screenshot proof path, and accepted false positives.
