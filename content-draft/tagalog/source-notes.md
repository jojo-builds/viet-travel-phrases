# Tagalog Source Notes

## Current reality

- The runtime Tagalog pack is still a seed proof set, not release-grade v2 content truth.
- This lane now has one bounded first-wave source contract instead of a broad shortlist that has to be reinterpreted.
- The direct row-level filter surface is `phrase-source.csv`.
- The ranked companion surface is `first-wave-priority.csv`.
- The relation-ready companion surfaces are `tagalog-v2-first-wave.csv`, `relation-sample-v1.json`, and `relation-authoring-notes.md`.
- `phrase-source.csv` now uses lightweight `relation-sample=...:<role>` markers in the existing `notes` field for the full `24`-outcome relation handoff: `anchor`, `deferred-boundary`, `pickup-candidate`, and `later-only-hold`.
  The five pickup rows now also carry explicit packet-outcome wording in those same row notes.

## Retrieval-ready handoff contract

- Treat the current lane as one `24`-outcome prep contract:
  - `16` starter-handoff rows
  - `1` deferred refusal boundary
  - `5` ordered next-pass expansion rows
  - `2` later-only hold rows
- The starter handoff is still the only direct authoring surface for the next pass.
  The extra `8` rows stay visible so downstream retrieval does not have to reconstruct the pickup and hold boundary from prose alone.
- The next-pass expansion rows are one cluster, not a generic parked pool:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- The current packet outcomes layer onto that same cluster:
  1. `tagalog-directions-1` - `promote now`
  2. `tagalog-hotel-hostel-1` - `promote now`
  3. `tagalog-hotel-hostel-2` - `promote now`
  4. `tagalog-hotel-hostel-5` - `defer for native/expert review`
  5. `tagalog-convenience-store-6` - `keep prep-only`
- The later-only hold boundary stays explicit:
  1. `tagalog-simple-problems-7`
  2. `tagalog-grab-taxi-7`
- `scenario-plan.json` now carries the same split inside `handoffContract`, plus one explicit `graduationBoundary`, one row-level packet-outcome layer, and one `runtimeHandoffAudit`, so downstream runtime or content work can lift one structured object instead of reconstructing the contract from multiple prose files.

## First-wave status contract

- `first-wave-core`: direct authoring-ready rows for the next pass.
- `first-wave-deferred`: rewritten baseline rows kept outside promotion until pattern review lands.
  For this pass, that means keep `tagalog-polite-basics-4` visible but still outside promotion.
- No rows currently use `first-wave-holdout`; that active tail was cleared in this pass so unresolved rows stop masquerading as near-ready runtime follow-ons.

## Graduation boundary contract

- Treat the five-row direct-pickup set as the only non-starter review lane that can move before later-only holds.
- Treat the two later-only rows as visible backlog only; their reopen rule is separate from safe promotion.
- `scenario-plan.json` now names the current promotion stop condition in `handoffContract.graduationBoundary`.
- The lane is not runtime-safe to promote until these blocker surfaces are explicitly cleared or rejected together:
  - refusal-tone review for `tagalog-polite-basics-4`
  - directions confidence review for `tagalog-directions-1`
  - hotel-language review for `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, and `tagalog-hotel-hostel-5`
  - payment-language review for `tagalog-convenience-store-6`
  - escalation and register review for `tagalog-simple-problems-7`
  - pronunciation posture review for the expanded Tagalog lane
- Keep the lane prep-only until the deferred refusal row and all five direct-pickup rows are either promoted or explicitly rejected in order.
- Reopening `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` later is a separate decision after that direct-pickup contract is settled.

## What this pass hardened

- The active working set is now explicitly bounded to the `16` `first-wave-core` rows plus the lone deferred refusal row.
- The deferred refusal row was rechecked in this pass and stays deferred: the rewrite is usable as an honesty boundary, but the sales-decline tone still needs native confirmation before promotion.
- `phrase-source.csv`, `first-wave-priority.csv`, and `tagalog-v2-first-wave.csv` now point at the same `24`-outcome relation contract instead of splitting the parked boundary across prose-only notes.
- `first-wave-priority.csv` and `tagalog-v2-first-wave.csv` now expose the same row-linked retrieval fields for all `24` outcomes: `relation_cluster_id`, `family_role`, `anchor_phrase_id`, `shortest_form_phrase_id`, `clearer_or_more_polite_phrase_id`, `likely_reply_family`, `primary_next_family`, `repair_family`, `parked_follow_on_family`, and `parked_follow_on_class`.
- The same `16` core rows now have a lightweight relation-ready sample so the lane can move toward phrase-detail and listing behavior before runtime wiring starts.
- The five former follow-on rows now keep the same ordered contract while also carrying explicit packet outcomes: `3` advance-now rows, `1` native/expert-review defer, and `1` prep-only follow-on.
- `quickPhraseIds` still reference only rows that remain inside the current core.

## Current pack boundary

- `tagalog-v2-first-wave.csv` is now the merged handoff surface for the full ranked `24`-outcome set.
- `tagalog-v2-first-wave.csv` is also the fastest row-linked retrieval surface when a downstream worker needs anchor, shortest-form, likely-reply, next-step, repair, and parked-follow-on guidance without rereading the sidecar first.
- `16` rows project to `starter-core` / `starter` and are the bounded pack rows ready for the next content-building pass.
- `1` row projects to `deferred-review` / `premium` because its baseline rewrite exists, but the refusal-tone pattern is still unsettled.
- `relation-sample-v1.json` maps those `16` starter-core rows to `16` phrase-family clusters with explicit next-step, repair, and nearby-reply links.
- `relation-sample-v1.json` now also carries a top-level `retrievalContract` plus a `deferredBoundaryFamilies` section so the refusal row stops reading like a thin side note.
- The same sidecar also carries `8` explicit parked-family candidates so drafted or deferred follow-ons stay linkable without silently becoming promoted clusters.
- Parked and deferred relation links now keep `targetStatus` separate from `targetFollowOnClass`.
  Use `targetStatus` for the real row status (`drafted` or `first-wave-deferred`) and `targetFollowOnClass` for `recommended-next-pass-pickup`, `later-only-hold`, or `deferred-review`.
- The deferred refusal row stays outside the cluster count as a visible relation boundary, not as a promoted family.
- `7` useful rows now sit outside the active starter handoff and remain visible through `phrase-source.csv`, `scenario-plan.json`, and the backlog notes, split into `5` direct-pickup contract rows and `2` later-only holds.
- Inside those `5` pickup rows, the current packet is `3` `promote now`, `1` `defer for native/expert review`, and `1` `keep prep-only`.
- This boundary is prep-only guidance for the next pass, not runtime entitlement truth.

## Relation-ready contract

- Count each `first-wave-core` row as one family-primary cluster for the current Tagalog sample.
- Keep `say-first` interpretation honest:
  - shortest socially safe phrasing first
  - clearer or more polite guidance only when the current source truth actually supports it
- Use relation links to show forward motion:
  - next likely phrase
  - repair path
  - likely reply or acknowledgment
  - parked follow-on candidate when the nearby phrase exists but is still drafted or deferred
- Keep parked backlog rows visible as relation targets only when their status is named plainly.
- Do not imply that a linked drafted or deferred row is ready for runtime promotion.

## Draft posture

### Register

- Keep only neutral or clearly useful polite forms in the core.
- `Opo` stays narrow: respectful yes or acknowledgment only.
- Rows that still depend on unresolved `po`, `ninyo`, or indirect-request posture stay outside the core.

### Loanwords

- Reservation, check-in, aircon, and card wording remain visible, but they now live in later-review backlog rather than in an active first-wave queue.
- Cash and call-for-me wording remain parked because their unresolved review posture is weaker than the directions, hotel, and card backlog rows.
- The current handoff does not treat loanword-heavy rows as runtime-adjacent until later review clears them.

### Pronunciation

- Pronunciation remains helper-only draft guidance.
- This pass does not lock a final romanization contract.
- Mixed-English or borrowing-heavy rows keep cautionary posture rather than pretending they are settled.

## Ordered authoring-ready set

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

## Visible but non-core rows

### Deferred rewrite

- `tagalog-polite-basics-4`
  Keep deferred. The draft is clearer than the older refusal wording, but it still needs native review to confirm that it reads like a polite decline to an offer or sales approach instead of a generic reassurance line.

### Direct-pickup packet outcomes

1. `tagalog-directions-1`
   `promote now`. Strongest parked row; map-showing utility is real, and it is the cleanest bridge back into the current starter directions pair.
2. `tagalog-hotel-hostel-1`
   `promote now`. Reservation wording is useful enough to enter the next slice as the hotel-arrival anchor while still carrying hotel-language review forward.
3. `tagalog-hotel-hostel-2`
   `promote now`. Check-in stays adjacent to reservation because the arrival pair should advance together into the same next slice.
4. `tagalog-hotel-hostel-5`
   `defer for native/expert review`. Room-issue usefulness is real, but `aircon` borrowing still needs the stricter hotel-language review surface before it advances.
5. `tagalog-convenience-store-6`
   `keep prep-only`. Card-payment wording remains the strongest non-hotel follow-on, but it stays visible outside the immediate next slice so the packet stays bounded to directions plus hotel arrival.

### Later-only hold set

1. `tagalog-simple-problems-7`
   Keep parked until the stronger five-row pickup set is resolved; escalation register risk is still higher than the current map, hotel, and payment rows.
2. `tagalog-grab-taxi-7`
   Keep parked after the escalation row too; the cash declaration is narrower than the broader card-payment check and should not jump ahead of it.

## Next authoring rule

- Start the next Tagalog pass from the `16`-row core and, when the lane expands beyond it, add only the current `promote now` trio from the direct-pickup packet.
- Use `tagalog-v2-first-wave.csv` when the next pass needs one row-linked handoff file instead of bouncing between `phrase-source.csv` and `first-wave-priority.csv`.
  Keep rows `1-17` as the direct working boundary and treat rows `18-24` as visible but non-promoted retrieval outcomes.
- Use `scenario-plan.json` when the next pass needs one structured retrieval object with counts, row ids, the direct-pickup contract, the exact packet outcomes, the later-only unlock rule, the runtime handoff audit, and the explicit promotion blockers.
- Use `relation-sample-v1.json` when the next pass needs a compact family graph for phrase-detail, listing, or website-safe relationship modeling.
  The deferred refusal row now has its own visible boundary contract there and routes back into thanks or the direct repair lane rather than floating as a dead-end note.
- Do not treat the parked backlog as an active second pass.
  The ordered pickup cluster and the later-only hold set are relation-visible on purpose, but they are still non-promoted outcomes.
- If a future task reopens direct-pickup rows, preserve the exact five-row set listed above and pull the packet outcomes from `scenario-plan.json` instead of inferring intent from older queue history.
- Revisit `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` only after the five-row pickup set is either promoted or explicitly rejected in order.
- Keep the deferred rewrite out of promotion until the refusal-tone pattern is reviewed.
