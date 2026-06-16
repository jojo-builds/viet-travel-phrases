# Batch 084 Replacement 4 Projection And Intake Goal

## Objective

Finish Batch 084 only in `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`.

Replacement 3 `019e9611-cd89-7591-8890-7c76e7874441` made partial hidden disk progress but did not complete or report. It has been told to hold. Previous Batch 084 workers also wedged and must not advance.

Do not advance to Batch 085. Do not run feature-flow, lane sync, merge, rebase, or cleanup. The worktree is intentionally dirty.

## Current Disk State After Replacement 3

Keep the partial V2.2 source improvements already on disk. The latest orchestrator recovery audit found:

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `9` strict hits left across Batch 084 target records.
- `content-draft/viet/city-library/handwritten-copy/hoian.json`: `23` strict hits left and now stale versus V2.2 source.
- `content-draft/viet/city-library/v1.json`: `27` strict hits left and stale.
- `native-ios/Resources/viet-authored-listing-pages.json`: `19` strict hits left and stale.
- target-linked intake rows: `3` hit rows left.
- all eight target records still have `phraseCards=3 related=1`.
- `git diff --check` is clean.

## Batch 084 Target IDs

- `city-hoian-place-faifo-coffee`
- `city-hoian-place-folk-culture-museum`
- `city-hoian-place-from-danang-airport`
- `city-hoian-place-from-danang-railway-station`
- `city-hoian-place-fujian-assembly-hall`
- `city-hoian-place-hainan-assembly-hall`
- `city-hoian-place-handicraft-workshop`
- `city-hoian-place-history-culture-museum`

## First Action

Do not do a broad discovery turn. Patch the remaining current blockers, then propagate.

## Remaining V2.2 Source Blockers

Patch `content-draft/viet/city-library/app-detail-v2-2/hoian.json` remaining hits:

- `city-hoian-place-handicraft-workshop` `storySpine` contains `enough`: rewrite without `enough` while keeping tools/hands/textiles/lanterns/craft-table proof.
- Related-card text still has `comparison`, `compare`, `contrast`, `pause`, and `scale`. Preserve all related-card targets, but rewrite `relationship`, `displaySubtitle`, and `reason` to concrete non-process language.

Accepted false positives only if they are legitimate phrase text/page IDs:

- `You can stop here`
- `transport-stop-here`
- `workshop` / `workshops` as a title substring, not prose using `works`

## Remaining Intake Blockers

Patch target-linked intake rows:

- `docs/city-production/agent-inputs/hoian-nouns.md:33` `hoian-history-culture-museum` has `enough`.
- `docs/city-production/agent-inputs/hoian-nouns.md:38` `hoian-handicraft-workshop` has `works,enough`; preserve the actual title `Hoi An Handicraft Workshop`.
- `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/City_Listing_Ledger.csv:346` `city-hoian-place-handicraft-workshop` has `works,enough`; preserve the title substring `Workshop`.

## Propagation

After the V2.2 source and intake rows are clean, propagate the repaired target copy to:

- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-authored-listing-pages.json`

Use existing project scripts if they are the established path. If manual propagation is safer for these exact records, keep it target-only and preserve all unrelated content.

## Validation

Run:

- target-only strict scan across V2.2 source, handwritten projection, v1 projection, and native generated listing pages;
- target-linked intake scan;
- phrase-card and related-card count check;
- `git diff --check`;
- generated resource / SQLite scan if SQLite was regenerated;
- Batch 084 screenshot proof or cite the current proof path if already produced in this repair sequence.

## Report

Stop after Batch 084 and report:

`**Batch 084 Replacement 4 Projection/Intake Ready For Orchestrator Review**`

Include changed files, scan counts, preserved card counts, screenshot proof path, and accepted false positives.
