# Tagalog Rewrite Notes

## Purpose

This pass hardens the Tagalog v2 first wave into one bounded prep-only source pack.
It does not promote the lane into runtime truth.

## Structural changes

- `phrase-source.csv` remains the direct row-level filter surface for the next pass.
- `first-wave-priority.csv` now carries only the active handoff rows instead of mixing the core with an unresolved premium-follow-on tail, and it now includes explicit relation fields for each active row: `relation_cluster_id`, `family_role`, `primary_next_family`, `repair_family`, and `parked_follow_on_family`.
- `tagalog-v2-first-wave.csv` now merges the active ranked `17`-row handoff: `16` starter-core rows plus the lone deferred refusal row, with the same compact relation-link fields beside the phrase data.
- `README.md`, `source-notes.md`, `risk-review.md`, and `research-backlog.md` now all describe the same queue-cleared contract.
- `relation-sample-v1.json` and `relation-authoring-notes.md` now give the lane a lightweight phrase-family graph sample without changing runtime truth, including explicit parked or deferred candidate stubs so nearby follow-ons stay honest.
- `scenario-plan.json` remains aligned because its quick phrases still point only at current `first-wave-core` rows.

## Source rewrites and hardening

- `tagalog-grab-taxi-1`
  Source tightened from `Take me here` to `Please take me here` so the English source matches the polite ride-control intent already present in the draft target.
- `tagalog-directions-3`
  Source tightened from `How long on foot` to `How long if I walk?` so the prompt reads like a natural traveler question rather than a glossary fragment.
- `tagalog-street-food-7`
  Source tightened from `Pack it to go` to `Please pack this to go` so the takeaway request reads like an actual counter exchange.
- `tagalog-asking-price-6`
  Source tightened from `Show me another one` to `Please show me another one` so the comparison-shopping line keeps service-tone politeness.
- `tagalog-polite-basics-5`
  Source narrowed from `Excuse me / pardon me` to `Excuse me` so the main English source stops carrying a split intent; brief-apology use stays in the usage note.
- `tagalog-polite-basics-3`
  Source clarified from `Yes / respectful acknowledgment` to `Yes, respectfully / I understand` so `opo` stays narrow and does not read like an unrestricted generic yes.
- `tagalog-hotel-hostel-1`
  Source aligned from `I have a booking` to `I have a reservation` because the draft target already uses reservation wording; the row remains a holdout until borrowing posture is reviewed.
- `tagalog-convenience-store-6`
  Source tightened from `Can I pay with card` to `Can I pay by card?` while keeping the row outside the core until payment terminology is reviewed.
- `tagalog-simple-problems-7`
  Source tightened from `Can you make the call for me` to `Could you call them for me?` so the escalation request reads more directly before later pronoun/register review.
- `tagalog-directions-1`
  The generic map-showing line was tightened to `Paumanhin, paano po pumunta sa lugar na ito` so it is no longer blocked as a deferred rewrite; it now sits in premium follow-on with a narrower map-showing review note.
- `tagalog-polite-basics-4`
  The refusal rewrite was preserved with clearer punctuation, but it remains outside the direct authoring pack until refusal-tone review lands.
- `tagalog-directions-3`
  Target wording was tightened to `Gaano katagal kung maglalakad ako` so the walking-time question reads like a direct traveler request instead of an incomplete fragment.
- `tagalog-asking-price-6`
  Target wording was tightened to `Pakipakita po ang isa pa` so the comparison-shopping line carries a clearer polite request shape.
- `tagalog-convenience-store-1`
  Target wording was tightened to `Isang bote ng tubig, pakiusap` so the water-order line reads more naturally as a bottle request.
- `tagalog-hotel-hostel-2`
  Holdout wording was tightened to `Mag-check in po ako` while keeping the row outside the starter core until mixed-English arrival phrasing is reviewed.
- `tagalog-simple-problems-7`
  Holdout wording was tightened to `Puwede po ba ninyong tawagan sila para sa akin` so the escalation line reflects a clearer polite ask while still carrying a register-review caution.
- `tagalog-simple-problems-7`
  After T-082, this row was moved out of the active first-wave queue because the escalation register risk is still higher than the directions, hotel, and card-payment follow-on rows.
- `tagalog-grab-taxi-7`
  After T-082, this row was moved out of the active first-wave queue because the active follow-on pass keeps the broader card-payment check ahead of the narrower cash declaration.

## Queue resolution

- `tagalog-directions-1`
  Moved out of the active handoff and back into drafted backlog. It remains the strongest expansion candidate, but the current handoff no longer treats a map-showing line as runtime-adjacent without native confirmation.
- `tagalog-hotel-hostel-1`
  Moved out of the active handoff and back into drafted backlog because reservation borrowing is still useful but not honest enough to keep in a runtime-facing follow-on queue.
- `tagalog-hotel-hostel-2`
  Moved out of the active handoff and back into drafted backlog because mixed-English check-in wording still needs review before it should shadow the starter pack.
- `tagalog-hotel-hostel-5`
  Moved out of the active handoff and back into drafted backlog because preserved `aircon` borrowing is still a review dependency, not a cleared follow-on.
- `tagalog-convenience-store-6`
  Moved out of the active handoff and back into drafted backlog because the card-payment wording still needs normalization before promotion.
- `tagalog-polite-basics-4`
  Preserved as the lone deferred row so the refusal-tone boundary stays visible in the handoff instead of disappearing into prose.

## Relation-ready enrichment

- The `16` current core rows now map one-to-one to `16` relation-ready family clusters.
- Core movement patterns are now explicit instead of implied:
  - repair start -> slower speech -> polite closeout
  - excuse me -> directions or price ask
  - ask price -> compare -> commit -> payment or receipt follow-on
  - near here -> walk time -> ride control
  - food comfort -> takeaway or order follow-on
  - urgent medical need -> parked escalation branch
- Parked rows stay visible as relation targets only when their status is named clearly as drafted or deferred.
- The deferred refusal row remains outside the promoted cluster count so the model stays honest about review posture.

## Pack projection

- `16` current core rows are projected as `starter-core` / `starter` for the next bounded pack build.
- `1` deferred row is projected as `deferred-review` / `premium` because its rewrite exists but the refusal-tone caution remains unresolved.
- There are no active `premium-follow-on` rows after this pass.
- `7` useful rows now return to the broader drafted backlog because keeping them in an active follow-on queue would overstate runtime readiness.
- The new pack projection is prep-only guidance for the next execution pass, not runtime truth.

## Remaining non-core queue

- `first-wave-deferred`
  `tagalog-polite-basics-4`
- `later drafted backlog`
  `tagalog-directions-1`, `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, `tagalog-hotel-hostel-5`, `tagalog-convenience-store-6`, `tagalog-simple-problems-7`, `tagalog-grab-taxi-7`

## Confidence posture

- Core rows stay direct-authoring ready, but `tagalog-street-food-3`, `tagalog-simple-problems-6`, and `tagalog-polite-basics-3` keep explicit caution through review flags or narrowed notes.
- Later-review backlog rows remain visible because they are useful, not because they are cleared.
- `tagalog-directions-1` remains the strongest backlog row if a future task reopens expansion.
- `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` remain drafted, but they are no longer part of the active first-wave reduction target.
- Relation links now make those caution boundaries easier to carry forward into later detail/listing implementation without pretending the parked rows are approved.
- Pronunciation stays helper-only draft guidance across the entire lane.
