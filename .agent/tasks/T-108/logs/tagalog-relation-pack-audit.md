# Tagalog Relation Pack Audit

Date: 2026-04-21
Task: `T-108`

## Output existence

- Verified required Tagalog outputs exist:
  - `content-draft/tagalog/README.md`
  - `content-draft/tagalog/source-notes.md`
  - `content-draft/tagalog/phrase-source.csv`
  - `content-draft/tagalog/first-wave-priority.csv`
  - `content-draft/tagalog/tagalog-v2-first-wave.csv`
  - `content-draft/tagalog/rewrite-notes.md`
  - `content-draft/tagalog/risk-review.md`
  - `content-draft/tagalog/relation-sample-v1.json`
  - `content-draft/tagalog/relation-authoring-notes.md`

## Data checks

- `first-wave-priority.csv` parses with `17` rows.
- `tagalog-v2-first-wave.csv` parses with `17` rows.
- `relation-sample-v1.json` parses successfully.
- The relation sidecar declares `clusterCount=16` and `parkedFamilyCandidateCount=8`.
- The parsed relation sidecar contains `16` clusters and `8` parked-family candidates.
- The Tagalog first-wave core still contains `16` rows.
- All `16` first-wave-core rows in `first-wave-priority.csv` now carry non-empty `relation_cluster_id` values.
- All `16` first-wave-core rows in `phrase-source.csv` now carry `relation-sample=...` markers in `notes`.

## Scope checks

- Session edits were confined to:
  - `content-draft/tagalog/**`
  - `docs/V2_CONTENT_MODEL.md`
  - `docs/PHRASE_RELATIONSHIP_MODEL.md`
  - `.agent/tasks/T-108/**`
- No app runtime, site, ops, or build files were edited in this session.

## Content posture

- The relation sample now maps the `16` promoted core rows one-to-one to relation-ready clusters.
- The sidecar keeps `8` non-promoted candidates explicit:
  - `5` recommended next-pass pickups
  - `2` later-only holds
  - `1` deferred refusal boundary
- The deferred refusal row remains outside the promoted cluster count.
