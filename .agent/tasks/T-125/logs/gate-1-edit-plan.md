# T-125 Gate 1 Edit Plan

## Contract preservation

- Keep the existing `16 / 1 / 5 / 2` Tagalog handoff intact.
- Keep the five-row direct-pickup contract intact as the ordered retrieval boundary:
  1. `tagalog-directions-1`
  2. `tagalog-hotel-hostel-1`
  3. `tagalog-hotel-hostel-2`
  4. `tagalog-hotel-hostel-5`
  5. `tagalog-convenience-store-6`
- Keep `tagalog-polite-basics-4` as the deferred refusal boundary.
- Keep `tagalog-simple-problems-7` and `tagalog-grab-taxi-7` as the later-only hold boundary.
- Keep the lane prep-only. Nothing in this task claims runtime-safe promotion or runtime wiring.

## Packet outcomes to add

Layer these exact per-row packet outcomes onto the existing five-row direct-pickup contract:

1. `tagalog-directions-1`
   Outcome: `promote now`
   Reason: strongest map-showing utility row and the cleanest direct bridge back into the existing starter directions pair.
2. `tagalog-hotel-hostel-1`
   Outcome: `promote now`
   Reason: highest-value hotel arrival row and the clearest booking-proof phrase for the next slice.
3. `tagalog-hotel-hostel-2`
   Outcome: `promote now`
   Reason: arrival pair stays adjacent to reservation and belongs in the same next slice.
4. `tagalog-hotel-hostel-5`
   Outcome: `defer for native/expert review`
   Reason: useful room-issue branch, but `aircon` wording still needs the stricter hotel-language review surface before it advances.
5. `tagalog-convenience-store-6`
   Outcome: `keep prep-only`
   Reason: useful payment follow-on that stays visible and retrievable, but it remains outside the immediate next slice so the handoff stays bounded to directions plus hotel arrival.

## Outcome wording rule

- `promote now` means advance into the next runtime/content working slice while the lane still stays prep-only.
- `promote now` does not mean runtime-safe promotion, device-proof readiness, or app wiring readiness.

## Compact audit to add

The final task log and synchronized Tagalog prep docs should make these three surfaces retrievable directly:

### Immediate trust

- The five-row direct-pickup contract is still the ordered retrieval boundary.
- The next slice should start with:
  - `tagalog-directions-1`
  - `tagalog-hotel-hostel-1`
  - `tagalog-hotel-hostel-2`
- `tagalog-hotel-hostel-5` stays visible but review-gated.
- `tagalog-convenience-store-6` stays visible but prep-only.

### Still needs validation

- refusal-tone review for `tagalog-polite-basics-4`
- directions confidence review for `tagalog-directions-1`
- hotel-language review for `tagalog-hotel-hostel-1`, `tagalog-hotel-hostel-2`, and `tagalog-hotel-hostel-5`
- payment-language review for `tagalog-convenience-store-6`
- escalation/register review for `tagalog-simple-problems-7`
- pronunciation posture review for the expanded Tagalog lane

### No longer needs rediscovery

- the exact five-row pickup order
- which rows advance now versus stay non-promoted
- that the refusal row remains a deferred boundary
- that the later-only hold boundary still contains only `tagalog-simple-problems-7` and `tagalog-grab-taxi-7`
- that Tagalog remains `prepared-next`, not live
