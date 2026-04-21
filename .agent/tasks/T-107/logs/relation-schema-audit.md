# Relation Schema Audit

Date: 2026-04-21
Task: T-107

## Sample boundary

- Selected `14` family-primary Viet clusters.
- Coverage moments included:
  - greeting
  - transport
  - food
  - money
  - hotel
  - repair

## Selected cluster anchors

- `polite-hello` -> `polite-1`
- `polite-acknowledge` -> `polite-3`
- `transport-destination` -> `taxi-1`
- `transport-fare` -> `transport-fare`
- `food-menu` -> `food-menu`
- `food-not-spicy` -> `food-3`
- `food-bottled-water` -> `food-5`
- `money-how-much` -> `price-1`
- `money-final-price` -> `price-5`
- `hotel-reservation` -> `hotel-1`
- `hotel-check-in` -> `hotel-2`
- `hotel-room-hot` -> `hotel-4`
- `repair-understand` -> `problems-2`
- `repair-write-down` -> `repair-2`

## Explicit variant coverage

- `food-not-spicy-clearer` is linked as the clearer form for `food-not-spicy`.
- `hotel-check-in-polite` is linked as the more-polite form for `hotel-check-in`.

## Advisory reply / hear-back sources

- `taxi-1` supplies the destination follow-up prompt in `you_may_hear`.
- `transport-fare` supplies the ride-price hear-back prompt in `you_may_hear`.
- `price-1` supplies the general-price hear-back prompt in `you_may_hear`.
- `repair-2` supplies the written-confirmation hear-back prompt in `you_may_hear`.

## Contract checks

- The sidecar keeps the current scenario -> family -> phrase-row model intact.
- Relation data lives in the new sidecar and lightweight `notes` markers rather than runtime code.
- No runtime app code was edited in this pass.
