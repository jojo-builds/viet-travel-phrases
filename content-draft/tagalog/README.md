# Tagalog Content Draft

This folder is the prep-only authoring surface for the next Tagalog v2 pass.
It is not runtime truth and it does not graduate the current live Tagalog pack by itself.

## Authoring entrypoint

- Start from `phrase-source.csv`.
  Filter rows by `status=first-wave-core` for the direct authoring-ready set.
- Use `tagalog-v2-first-wave.csv` as the merged `24`-outcome prep handoff when the next runtime/content task needs one file with rank, translation, pronunciation, confidence, and the current relation-link guidance together.
  Rows `1-16` stay the starter-core anchors, row `17` stays the deferred refusal boundary, rows `18-22` stay the ordered direct-pickup contract, and rows `23-24` stay later-only holds.
- Use `first-wave-priority.csv` for the same `24`-outcome order in a lighter ranked handoff surface.
- Use `source-notes.md` for the pack contract, inclusion rules, and why unresolved rows now sit outside the active handoff instead of living in a premium follow-on tail.
- Use `risk-review.md` for the unresolved loanword, register, pronunciation, and later-review cautions.
- Use `rewrite-notes.md` for the queue-clearing and row-level hardening decisions made in this pass.
- Use `relation-sample-v1.json` for the lightweight relation-ready family sample across the current `16` core clusters plus `8` explicit parked or deferred follow-on candidates whose status stays visible.
  It now also carries a top-level `retrievalContract` and `deferredBoundaryFamilies` surface so downstream pickup can recover the full `24`-outcome relation handoff without stitching together older task notes.
- Use `relation-authoring-notes.md` for the authoring contract behind the sample schema, link types, and follow-on backlog posture.
- Use `scenario-plan.json` for the scenario spine, the aligned quick-phrase snapshot, and the retrieval-ready `handoffContract` object that names the starter, deferred, direct-pickup, later-only, graduation-boundary, packet-outcome, and runtime-handoff-audit rules in one place.

## Current starter contract

- The active retrieval contract now accounts for `24` row outcomes in one bounded model:
  - `16` `starter-core` rows for the direct next-pass handoff
  - `1` deferred refusal row kept visible but outside promotion
  - `5` ordered next-pass expansion rows
  - `2` later-only hold rows that stay parked behind the expansion cluster
- Those same `16` starter rows double as `16` relation-ready phrase-family anchors for future phrase-detail and listing work.
- The lone deferred row is still `tagalog-polite-basics-4`.
  Keep it visible as a refusal boundary, not as a promoted family.
- The direct-pickup contract is one explicit ordered review lane rather than a loose parked queue:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- The current packet outcomes layer onto that same five-row contract without changing the contract itself:
  1. `tagalog-directions-1` - `promote now` for the next prep-only runtime/content slice
  2. `tagalog-hotel-hostel-1` - `promote now` for the same slice
  3. `tagalog-hotel-hostel-2` - `promote now` for the same slice
  4. `tagalog-hotel-hostel-5` - `defer for native/expert review`
  5. `tagalog-convenience-store-6` - `keep prep-only`
- The later-only hold boundary remains:
  1. `tagalog-simple-problems-7`
  2. `tagalog-grab-taxi-7`
- Inside `tagalog-v2-first-wave.csv`, the row-linked handoff now keeps all `24` outcomes in one file while still making the active promotion boundary explicit: `16` `starter-core` rows, `1` `deferred-review` refusal row, `5` ordered direct-pickup rows, and `2` later-only holds.
- Inside `scenario-plan.json`, `handoffContract.graduationBoundary` now names the exact stop condition for runtime-safe promotion, while `handoffContract.directPickupContract.packetOutcomeRows` and `handoffContract.runtimeHandoffAudit` give the downstream lane one exact next-slice packet plus one compact trust audit.

## Current graduation boundary

- The current handoff is still prep-only.
- Reopening later-only holds is not the same as safe promotion.
- Keep the lane outside runtime-safe promotion until all of these remain explicit and resolved together:
  - refusal-tone review for `tagalog-polite-basics-4`
  - directions confidence review for `tagalog-directions-1`
  - hotel-language review for `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, and `tagalog-hotel-hostel-5`
  - payment-language review for `tagalog-convenience-store-6`
  - escalation and register review for `tagalog-simple-problems-7`
  - pronunciation posture review for the expanded Tagalog lane
- The stop condition is simple: keep the lane prep-only until the deferred refusal row and the five direct-pickup rows either clear review or are explicitly rejected, and do not reopen the later-only hold set until that direct-pickup contract is settled.
- Inside `relation-sample-v1.json`, those `16` starter-core rows stay connected by shortest-form guidance, polite or clearer notes when honest, and next-step or repair links that stay explicit about drafted versus deferred follow-ons.
- Inside `relation-sample-v1.json`, parked and deferred links now keep `targetStatus` separate from `targetFollowOnClass` so the prep lane does not invent hybrid pseudo-status labels.
- Pronunciation remains helper-only draft guidance, not a frozen romanization contract.

## Runtime handoff audit

- Immediate trust:
  - preserve the five-row direct-pickup contract exactly as the ordered retrieval boundary
  - when the next runtime/content lane expands beyond the `16` starter-core rows, advance only:
    1. `tagalog-directions-1`
    2. `tagalog-hotel-hostel-1`
    3. `tagalog-hotel-hostel-2`
  - keep `tagalog-hotel-hostel-5` visible but `defer for native/expert review`
  - keep `tagalog-convenience-store-6` visible but `keep prep-only`
- Still validate:
  - refusal-tone review for `tagalog-polite-basics-4`
  - directions confidence review for `tagalog-directions-1`
  - hotel-language review for `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, and `tagalog-hotel-hostel-5`
  - payment-language review for `tagalog-convenience-store-6`
  - escalation and register review for `tagalog-simple-problems-7`
  - pronunciation posture review for the expanded Tagalog lane
- No longer needs rediscovery:
  - the exact five-row pickup order
  - which three rows advance now
  - which one row stays deferred for native/expert review
  - which one row stays prep-only
  - that `tagalog-polite-basics-4` remains the deferred refusal boundary
  - that `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` remain the only later-only holds
  - that Tagalog is still `prepared-next`, not live

## Working rule

- Keep this lane prep-only until a later task explicitly promotes reviewed content into runtime truth.
- Do not infer runtime readiness from the existence of a cleaner first-wave pack.
- Treat `tagalog-v2-first-wave.csv` as a prep-ready handoff artifact, not as runtime truth by itself.
- Start the next runtime/content task from the `16` starter-core rows and, when the lane expands beyond that boundary, add only the current `promote now` trio from the direct-pickup contract:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
- Use `scenario-plan.json` as the quickest retrieval surface when a downstream worker needs the starter rows, the deferred refusal boundary, the five-row direct-pickup contract, the row-by-row packet outcomes, the two-row later-only hold rule, the runtime handoff audit, and the explicit promotion blockers without rereading older task results.
- Use `relation-sample-v1.json` when a later task needs a compact graph-ready sample instead of inferring relations ad hoc from prose.
  The deferred refusal row now has its own visible boundary contract there and routes back into thanks or the direct repair lane rather than floating as a dead-end note.
- Keep the direct-pickup contract order intact even when using the packet outcomes above; the packet outcomes sit on top of the same five-row contract instead of replacing it.
- Keep this exact later-only hold set out of the next pass unless the direct-pickup set above is either promoted or explicitly rejected first:
  1. `tagalog-simple-problems-7`
  2. `tagalog-grab-taxi-7`
