# Tagalog Runtime Handoff Packet

## Contract preserved

- Keep the `16 / 1 / 5 / 2` handoff intact.
- Keep the five-row direct-pickup contract intact as the ordered retrieval boundary:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- Keep `tagalog-polite-basics-4` as the deferred refusal boundary.
- Keep `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` as the later-only hold boundary.
- Keep the lane prep-only. Nothing in this packet claims runtime-safe promotion or app wiring readiness.

## Packet outcomes

1. `tagalog-directions-1`
   Outcome: `promote now`
   Why: strongest map-showing bridge back into the starter directions pair.
2. `tagalog-hotel-hostel-1`
   Outcome: `promote now`
   Why: hotel-arrival anchor for the next prep-only slice.
3. `tagalog-hotel-hostel-2`
   Outcome: `promote now`
   Why: advance with reservation so the arrival pair stays intact.
4. `tagalog-hotel-hostel-5`
   Outcome: `defer for native/expert review`
   Why: keep visible, but `aircon` wording still needs the stricter hotel-language review surface before it advances.
5. `tagalog-convenience-store-6`
   Outcome: `keep prep-only`
   Why: useful payment follow-on that stays visible outside the immediate next slice while payment-language review remains open.

## Immediate trust

- Preserve the five-row direct-pickup contract exactly as the ordered retrieval boundary.
- When the lane expands beyond the `16` starter rows, advance only:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
- Keep `tagalog-hotel-hostel-5` visible but review-gated.
- Keep `tagalog-convenience-store-6` visible but prep-only.

## Still needs validation

- refusal-tone review for `tagalog-polite-basics-4`
- directions confidence review for `tagalog-directions-1`
- hotel-language review for `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, and `tagalog-hotel-hostel-5`
- payment-language review for `tagalog-convenience-store-6`
- escalation/register review for `tagalog-simple-problems-7`
- pronunciation posture review for the expanded Tagalog lane

## No longer needs rediscovery

- the exact five-row pickup order
- which three rows advance now
- which one row stays deferred for native/expert review
- which one row stays prep-only
- that `tagalog-polite-basics-4` remains the deferred refusal boundary
- that `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` remain the only later-only holds
- that Tagalog is still `prepared-next`, not live
