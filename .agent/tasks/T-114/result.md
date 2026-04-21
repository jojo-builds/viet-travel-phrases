# T-114 Result

Status: done

## Summary

- Expanded the Tagalog relation handoff from a mostly `17`-row active surface plus prose-only parked notes into one explicit `24`-outcome retrieval contract.
- Added role-bearing relation markers in `phrase-source.csv` for the deferred, pickup, and later-only rows so the row-level prep truth matches the sidecar boundary story.
- Expanded `first-wave-priority.csv` and `tagalog-v2-first-wave.csv` to carry the full ordered `16 / 1 / 5 / 2` contract with row-linked relation fields.
- Added a `rowOutcomeLedger` and matching retrieval metadata to `relation-sample-v1.json` and aligned `scenario-plan.json` to the same contract.
- Updated Tagalog and shared relation-model docs so the new seam is explicit and still prep-only.

## Validation

- `content-draft/tagalog/first-wave-priority.csv` parses with `24` rows.
- `content-draft/tagalog/tagalog-v2-first-wave.csv` parses with `24` rows.
- `content-draft/tagalog/relation-sample-v1.json` parses with `16` promoted clusters, `8` parked/deferred candidates, and `24` ledger outcomes.
- `content-draft/tagalog/scenario-plan.json` still reflects `16` starter rows, `1` deferred row, `5` pickup rows, and `2` later-only rows.
- Gate 1 pass 1: APPROVE x4.
- Gate 2 pass 1: APPROVE x4.
- Gate 3 pass 1: APPROVE x4.

## Process feedback

- SUGGESTION: Future relation-lane tasks should say upfront whether parked and later-only rows should become row-linked CSV outcomes, because that decision changes the whole handoff shape more than it changes individual row wording.
