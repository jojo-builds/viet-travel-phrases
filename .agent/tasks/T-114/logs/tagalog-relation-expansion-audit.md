# Tagalog Relation Expansion Audit

## Scope

- Task: `T-114`
- Surface: Tagalog prep-only relation handoff
- Goal: turn the prior split starter-plus-sidecar retrieval story into one sharper `24`-outcome row-linked contract without promoting parked rows into runtime truth

## Changes landed

- Added role-bearing `relation-sample=...:<role>` markers in [`content-draft/tagalog/phrase-source.csv`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/phrase-source.csv) for the `8` non-core outcomes:
  - `tagalog-polite-basics-4` as `deferred-boundary`
  - `tagalog-directions-1`, `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, `tagalog-hotel-hostel-5`, `tagalog-convenience-store-6` as `pickup-candidate`
  - `tagalog-simple-problems-7`, `tagalog-grab-taxi-7` as `later-only-hold`
- Expanded [`content-draft/tagalog/first-wave-priority.csv`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/first-wave-priority.csv) from `17` rows to `24` rows so the full starter, deferred, pickup, and later-only contract is recoverable in one ranked surface.
- Expanded [`content-draft/tagalog/tagalog-v2-first-wave.csv`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/tagalog-v2-first-wave.csv) from `17` rows to `24` rows with row-linked relation fields for the same visible outcome set.
- Added `relationClusterId` and `familyRole` metadata to parked and deferred candidates in [`content-draft/tagalog/relation-sample-v1.json`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/relation-sample-v1.json).
- Added a top-level `rowOutcomeLedger` plus related retrieval metadata in [`content-draft/tagalog/relation-sample-v1.json`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/relation-sample-v1.json) so downstream work can recover the exact `24`-row handoff without stitching prose back together.
- Added row-outcome retrieval metadata in [`content-draft/tagalog/scenario-plan.json`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/scenario-plan.json) so the scenario handoff points directly at the row-linked CSV surfaces.
- Updated [`content-draft/tagalog/README.md`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/README.md), [`content-draft/tagalog/source-notes.md`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/source-notes.md), [`content-draft/tagalog/relation-authoring-notes.md`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/relation-authoring-notes.md), and [`content-draft/tagalog/risk-review.md`](E:/AI/SpeakLocal-App-Family/content-draft/tagalog/risk-review.md) to describe the new retrieval seam honestly.
- Updated shared blueprint docs [`docs/V2_CONTENT_MODEL.md`](E:/AI/SpeakLocal-App-Family/docs/V2_CONTENT_MODEL.md) and [`docs/PHRASE_RELATIONSHIP_MODEL.md`](E:/AI/SpeakLocal-App-Family/docs/PHRASE_RELATIONSHIP_MODEL.md) to recognize prepared-next `rowOutcomeLedger` usage and role-bearing `relation-sample` markers.

## Validation

- `first-wave-priority.csv` parses with `24` rows.
- `tagalog-v2-first-wave.csv` parses with `24` rows.
- `relation-sample-v1.json` parses with:
  - `clusterCount = 16`
  - `parkedFamilyCandidates = 8`
  - `deferredBoundaryFamilies = 1`
  - `rowOutcomeLedger = 24`
- `scenario-plan.json` parses with:
  - `starterRows = 16`
  - `deferredRows = 1`
  - `nextPassExpansionCluster.rows = 5`
  - `laterOnlyHold.rows = 2`
- Gate 1 pass 1: APPROVE x4.
- Gate 2 pass 1: APPROVE x4.
- Gate 3 pass 1: APPROVE x4.

## Notes

- The promoted starter boundary remains unchanged at `16` rows.
- The deferred refusal row remains non-promoted and explicitly routes back into thanks or repair.
- The `5` pickup rows and `2` later-only rows are now row-linked and relation-labeled, but they remain `drafted` and non-promoted.
