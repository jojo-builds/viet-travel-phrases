# Tagalog Risk Review

## Summary

- The Tagalog first wave is cleaner than the inherited shortlist because it no longer pretends the unresolved hotel, payment, and map-showing rows belong in an active runtime-adjacent queue.
- A `16`-row promoted core now exists for the next writing pass.
- The active handoff now carries only `1` deferred rewrite instead of a `5`-row premium-follow-on tail plus a deferred row.
- `7` useful rows remain outside the active handoff as explicit parked backlog: `3` `promote now` additions for the next prep-only slice, `1` native/expert-review defer, `1` prep-only follow-on, and `2` later-only holds.
- The lane now has a relation-ready sample, and that sample keeps `8` parked or deferred follow-on candidates explicit instead of treating them as approved family variants.
- The lane now has a sharper relation retrieval contract too: parked and deferred links keep real row status separate from follow-on class, the deferred refusal row now routes back into thanks or the direct repair lane instead of sitting as a thin side note, and the same `24` outcomes now exist in one row-linked CSV order instead of only in split prose plus sidecar notes.
- `scenario-plan.json` now mirrors the same `24`-outcome split in one structured `handoffContract` object so downstream pickup no longer depends on rereading old task results.
- `scenario-plan.json` now also names one compact `graduationBoundary` plus one `runtimeHandoffAudit` so runtime-safe promotion blockers and next-slice trust rules are readable in the main handoff itself rather than only in the backlog and risk prose.

## Cleaner first-wave core

- Courtesy and repair:
  - `tagalog-polite-basics-5`
  - `tagalog-polite-basics-2`
  - `tagalog-polite-basics-3`
  - `tagalog-simple-problems-2`
  - `tagalog-simple-problems-3`
  - `tagalog-simple-problems-6`
- Transport and directions:
  - `tagalog-grab-taxi-1`
  - `tagalog-grab-taxi-3`
  - `tagalog-directions-2`
  - `tagalog-directions-3`
- Buying and food:
  - `tagalog-asking-price-1`
  - `tagalog-asking-price-6`
  - `tagalog-asking-price-7`
  - `tagalog-convenience-store-1`
  - `tagalog-street-food-3`
  - `tagalog-street-food-7`

## Main remaining risk clusters

### 1. Direct-pickup packet: promote-now trio plus non-promoted hotel/payment follow-ons

- Pickup rows in contract order with packet outcomes:
  1. `tagalog-directions-1`
     - `promote now`
  2. `tagalog-hotel-hostel-1`
     - `promote now`
  3. `tagalog-hotel-hostel-2`
     - `promote now`
  4. `tagalog-hotel-hostel-5`
     - `defer for native/expert review`
  5. `tagalog-convenience-store-6`
     - `keep prep-only`
- Why they are still risky:
  - the map-showing line is useful enough to enter the next slice, but it still deserves native confirmation before any runtime-safe promotion
  - the hotel arrival pair is useful enough to advance together, but both rows still carry hotel-language review debt
  - the room-issue branch remains visible on purpose, but `aircon` wording still needs the stricter hotel-language review surface before it advances
  - the card-payment row remains useful and retrievable, but it stays prep-only so the immediate next slice does not sprawl across too many follow-on moments
  - the directions, hotel, and payment rows are still one ordered expansion cluster, not three separate backlog lanes

### 2. Refusal baseline still needs rewrite review

- Deferred rows:
  - `tagalog-polite-basics-4`
- Why they are still risky:
  - the refusal line needed a more natural source and target draft
  - it now has a stronger draft wording, but the decision in this pass is still to keep it deferred until native review confirms it works as a polite decline in sales or offer contexts
  - the row is now relation-visible on purpose, so downstream work must keep treating it as a non-promoted boundary instead of a starter family

### 3. Later-only hold set still has unresolved escalation and cash wording

- Later-only hold rows after the stronger five-row pickup set:
  - `tagalog-simple-problems-7`
  - `tagalog-grab-taxi-7`
- Why they are still risky:
  - the escalation line still needs register and pronoun review
  - the cash declaration is useful, but it is weaker than the broader card-payment check for the current follow-on pass
  - neither row should reopen until the directions, hotel, and card-payment rows are either promoted or explicitly rejected

### 4. Pronunciation is still draft-only

- The current pronunciation remains a helper layer, not a locked contract.
- Mixed-English and loanword-heavy rows stay outside the promoted core until that posture is stronger.

### 5. Relation links can overstate readiness if status is hidden

- The new relation-ready sample is useful only if nearby drafted or deferred phrases are labeled clearly.
- That now means using real row status (`drafted` or `first-wave-deferred`) separately from follow-on class (`recommended-next-pass-pickup`, `later-only-hold`, `deferred-review`) instead of inventing hybrid pseudo-status labels.
- Hotel, payment, map-showing, escalation, and refusal branches should stay visible as next-step candidates, not as silent promotions.
- The current sample should prefer family-level links and honest notes over speculative variant inflation.

## Recommended handling

- Start the next Tagalog content pass from the `16` promoted-core rows.
- When the next pass expands past the `16` promoted-core rows, add only `tagalog-directions-1`, `tagalog-hotel-hostel-1`, and `tagalog-hotel-hostel-2` first.
- Pull the current contract from `scenario-plan.json` first when a downstream worker needs the ordered starter, deferred, direct-pickup, later-only, packet-outcome, and promotion-boundary rules in one place.
- Use `tagalog-v2-first-wave.csv` when that same downstream worker needs the exact row-level order and relation fields for all `24` visible outcomes, not just the promoted starter rows.
- Do not treat the parked backlog as an active premium queue.
- Use the relation-ready sample to keep phrase-detail and listing work moving without reopening every parked row.
- If a future task needs expansion, preserve this exact five-row pickup set first and pull the current packet outcomes from the handoff instead of inferring them from older queue results.
- Revisit the later-only hold rows `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` only after the stronger five-row pickup set is settled.
- Keep the lone deferred refusal rewrite out of promotion until the refusal-tone pattern is reviewed.
- Do not claim that pronunciation or mixed-English posture is settled yet.
- Keep `handoffContract.graduationBoundary` and `runtimeHandoffAudit` aligned with those same blocker calls so a runtime-facing lane can read one compact stop condition plus one trust audit before it promotes anything.
