# Batch 084 Replacement 2 Repair Goal

## Objective

Repair Batch 084 only in `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`.

Replacement worker `019e9512-3769-7662-8e8e-d8c6bce99c38` wedged after planning and made no disk progress. Previous Batch 084 worker `019e94b1-fab4-7201-9383-51282d5af496` also wedged after a partial source patch. Both have been told to hold.

Do not advance to Batch 085. Do not run a lane sync or rebase. The worktree is dirty; preserve unrelated churn.

## Start Immediately From Current Disk Audit

Do not spend a long turn re-planning. Read this file, inspect the named target records, then patch the source/intake roots.

Current audit after Replacement 1:

- `TOTAL_STRICT_HITS 105`
- intake hit rows: `11`
- `git diff --check`: clean
- all eight target records still have `phraseCards=3 related=1`

## Batch 084 Listings

- `city-hoian-place-faifo-coffee`
- `city-hoian-place-folk-culture-museum`
- `city-hoian-place-from-danang-airport`
- `city-hoian-place-from-danang-railway-station`
- `city-hoian-place-fujian-assembly-hall`
- `city-hoian-place-hainan-assembly-hall`
- `city-hoian-place-handicraft-workshop`
- `city-hoian-place-history-culture-museum`

## Patch These Roots

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`
- `content-draft/viet/city-library/handwritten-copy/hoian.json`
- `docs/city-production/agent-inputs/hoian-nouns.md`
- `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/City_Listing_Ledger.csv`

Then regenerate the downstream projections/resources that carry these records:

- `content-draft/viet/city-library/v1.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- any native generated SQLite/report files required by the existing project scripts

## Exact Current Blockers

Representative source/generated blockers:

- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-faifo-coffee` section body has `The draw is...`
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-folk-culture-museum` has `behind` in `storySpine`, `intro.heading`, `intro.body`, section body, related subtitle, and related reason.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-from-danang-airport` section body has `should`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-from-danang-railway-station` phrase card contains legitimate phrase text `You can stop here`; preserve the card and treat phrase text/page IDs as an accepted false positive if needed, but do not let `stop` leak into metadata/rationale.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-fujian-assembly-hall` has `surfaces` and `the draw`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-hainan-assembly-hall` has `surfaces`.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-handicraft-workshop` has `behind` / `table height` style copy.
- `content-draft/viet/city-library/app-detail-v2-2/hoian.json`: `city-hoian-place-history-culture-museum` has `behind` in summary/rationale/heading copy.
- Related-card/rationale leaks include `comparison`, `compare`, `contrast`, `pause`, and `scale`; preserve the related card targets and rewrite only labels/subtitles/reasons/relationships.
- `sourceNotes` with `context` can remain only if not visible/source/card prose according to the orchestrator rules; otherwise rewrite narrowly.

Representative intake blockers:

- `docs/city-production/agent-inputs/hoian-nouns.md:23` has `helps`.
- `docs/city-production/agent-inputs/hoian-nouns.md:35` has `helps`, `context`, and `stop`.
- `docs/city-production/agent-inputs/hoian-nouns.md:38` has `works` as a seed leak; avoid breaking the actual place title `Hoi An Handicraft Workshop`.
- `docs/city-production/agent-inputs/hoian-nouns.md:151` has `context`.
- `docs/city-production/agent-inputs/hoian-nouns.md:152` has `helps` and `context`.
- `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/City_Listing_Ledger.csv:341` has `feel`, `works`, `why`, `context`, and `stop`.
- `City_Listing_Ledger.csv:342` and `:343` have `works`, `why`, `clearer`, and `context`.
- `City_Listing_Ledger.csv:345` has `works` and `why`.
- `City_Listing_Ledger.csv:346` has `works`, `why`, and `clearer`.
- `City_Listing_Ledger.csv:347` has `feel`, `works`, `why`, `context`, and `stop`.

## Required Prose Standard

Preserve concrete place proof:

- Faifo Coffee: Tran Phu view, tiled roofs, yellow walls, rooftop/cafe detail.
- Museum of Folk Culture: lanterns, textiles, wooden beams, household/craft displays.
- Da Nang airport/station transfer: pickup doors/lanes, luggage, road into Hội An, hotel address/driver details.
- Fujian/Hainan assembly halls: incense, courtyards, altars, tiled roofs, red/yellow color, active worship areas.
- Handicraft Workshop: tools, hands, textiles, lanterns, craft tables, finished objects.
- History and Culture Museum: ceramics, trade memory, maps, display cases, older objects.

Do not delete phrase cards, related cards, or target links. Do not thin copy to pass scans.

## Validation Before Reporting

Run:

- target-only strict source/generated scan;
- target-linked intake scan;
- phrase-card and related-card count check;
- `git diff --check`;
- generated resource/SQLite scan if regenerated;
- Batch 084 screenshot proof if no current proof exists.

## Report

Stop after Batch 084 and report:

`**Batch 084 Replacement 2 Ready For Orchestrator Review**`

Include changed files, scan counts, preserved card counts, screenshot proof path, and any accepted false positives.
