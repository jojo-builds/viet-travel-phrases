# Tagalog Relation Authoring Notes

## Purpose

This file defines the current bounded Tagalog relation-ready handoff.
It is additive to the current prep lane and does not replace the existing row-level authoring files.

## Current sample boundary

The current sample covers `16` core family-primary clusters, each mapped one-to-one to a current `first-wave-core` row:

1. `tagalog-simple-problems-2`
2. `tagalog-simple-problems-3`
3. `tagalog-grab-taxi-1`
4. `tagalog-grab-taxi-3`
5. `tagalog-asking-price-1`
6. `tagalog-convenience-store-1`
7. `tagalog-street-food-3`
8. `tagalog-directions-2`
9. `tagalog-directions-3`
10. `tagalog-polite-basics-5`
11. `tagalog-polite-basics-2`
12. `tagalog-simple-problems-6`
13. `tagalog-street-food-7`
14. `tagalog-asking-price-6`
15. `tagalog-asking-price-7`
16. `tagalog-polite-basics-3`

The sidecar also carries `8` explicit parked or deferred candidates:

- `5` recommended next-pass pickups
- `2` later-only holds
- `1` deferred refusal boundary

Those candidates stay linkable for future phrase-detail and listing work without being counted as promoted clusters.
The sidecar now also exposes one top-level `retrievalContract`, one `deferredBoundaryFamilies` surface, and one `rowOutcomeLedger` so downstream pickup can recover the full `24`-outcome handoff without rereading older task results.

## Authoring surfaces

- `phrase-source.csv`
  Owns phrase text, pronunciation, context, and the lightweight `relation-sample=...:<role>` markers for all `24` currently tracked outcomes.
- `first-wave-priority.csv`
  Owns ranked working order plus compact relation guidance for the full `24`-outcome handoff.
- `tagalog-v2-first-wave.csv`
  Owns the merged row-linked prep handoff with the same compact relation guidance columns beside the phrase data.
- `relation-sample-v1.json`
  Owns the family-level relation graph and the explicit parked/deferred candidate list.

## Compact CSV fields

`first-wave-priority.csv` and `tagalog-v2-first-wave.csv` now carry:

- `relation_cluster_id`
  Stable cluster slug for the current bounded sample.
- `family_role`
  `anchor` for the `16` promoted clusters, `deferred-boundary` for the refusal row, `pickup-candidate` for the ordered next-pass cluster, and `later-only-hold` for the two parked hold rows.
- `anchor_phrase_id`
  The authored anchor row for the family in the current prep handoff.
- `shortest_form_phrase_id`
  The safest shorter starting row when it exists; today this is usually the same as the anchor because no shorter alternate row is authored yet.
- `clearer_or_more_polite_phrase_id`
  Use only when an authored row actually gives the family a clearer or more respectful branch.
- `likely_reply_family`
  The family most likely to come back from the other side when that branch is specific enough to name.
- `primary_next_family`
  The most likely next traveler move from this family.
- `repair_family`
  The best immediate recovery branch when the family breaks down.
- `parked_follow_on_family`
  An adjacent drafted or deferred family worth keeping visible without promoting it.
- `parked_follow_on_class`
  `recommended-next-pass-pickup`, `later-only-hold`, or `deferred-review`.

Keep these fields boring and obvious. They are prep guidance, not a hidden runtime schema.

## Sidecar field rules

Inside `relation-sample-v1.json`:

- `shortestFormPhraseId`
  The shortest socially safe way to start the intent.
- `clearerFormPhraseId`
  Use only when an existing row genuinely adds disambiguation.
- `morePoliteFormPhraseId`
  Use only when an existing row genuinely adds service-safe or hierarchy-safe tone.
- `youMayHearSignals`
  Advisory only. These are hints, not promises.
- `possibleTravelerResponses`
  Advisory likely traveler follow-ups.
- `familyRelations`
  Family-to-family edges for next-step, repair, escalation, likely-reply, or nearby utility.
- `parkedFamilyCandidates`
  Explicit drafted or deferred families that may be linked from the active sample but must remain visibly non-promoted.
- `retrievalContract`
  Top-level `24`-outcome retrieval summary with normalized field names for CSV and relation targets.
- `deferredBoundaryFamilies`
  Explicit non-promoted family objects that stay visible as boundaries and route back into the main graph.
- `rowOutcomeLedger`
  Flat ordered list of the same `24` outcomes so downstream pickup can recover the row-linked contract without re-deriving it from several nested objects.

## Parked-family rules

When a cluster points at a parked or deferred candidate:

- include the target in `parkedFamilyCandidates`
- carry its `currentStatus`
- carry its `followOnClass`
- keep the note explicit about why it is parked
- do not count it toward `clusterCount`
- do not imply runtime readiness
- keep `targetStatus` and `targetFollowOnClass` separate so prepared-next links do not invent hybrid pseudo-status values

## Current relation types

- `reply_to`
- `likely_answer_to`
- `next_step_after`
- `repair_for`
- `escalation_for`
- `same_need_alt_context`
- `see_also`

## Authoring cautions

- Keep the sidecar additive. Phrase wording still belongs in `phrase-source.csv`.
- Prefer family-level links first.
- Keep drafted and deferred targets visible only when their status is spelled out.
- Normalize parked vocabulary: real row state belongs in `currentStatus` / `targetStatus`; promotion posture belongs in `followOnClass` / `targetFollowOnClass`.
- Do not turn the parked candidate list into an active second-pass queue.
- Keep the refusal row outside the promoted cluster count until refusal-tone review lands.
