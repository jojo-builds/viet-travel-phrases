# Viet Relation Expansion Audit

Date: 2026-04-21
Task: `T-113`

## Expansion summary

- Expanded `content-draft/viet/relation-sample-v1.json` from `14` to `29` clusters.
- Preserved the original greeting, transport, food, money, hotel, and repair anchors from `T-107`.
- Added new starter-safe coverage for:
  - arrival: passport, visa, airport ATM
  - transport: meter, stop here
  - food: table for two, ready to pay
  - hotel: check-out time, AC not working
  - phone: local SIM, map not working
  - repair: speak slower, say that again, say the number again, English help
- Extended cross-linking so the sample reads more like a listing/detail handoff than a schema demo.

## Marker coverage

- `29` anchor rows in `content-draft/viet/phrase-source.csv`
- `6` variant rows with explicit relation markers
- Variant-marked clusters:
  - `viet-food-not-spicy` via `food-not-spicy-clearer`
  - `viet-hotel-check-in` via `hotel-check-in-polite`
  - `viet-transport-stop-here` via `transport-stop-here-clearer`
  - `viet-repair-slower` via `repair-slower-polite`
  - `viet-repair-number` via `repair-number-amount`
  - `viet-repair-english-help` via `repair-english-help-self-limit`

## Validation

- `relation-sample-v1.json` parses successfully with `clusterCount=29` and `actualClusterCount=29`.
- `phrase-source.csv` parses successfully with `919` total rows.
- Every cluster `anchorPhraseId` resolves to a real CSV row.
- Every cluster `familyId` resolves to a real CSV family in the same source CSV.
- Required docs updated to match the new bounded sample count and scope:
  - `docs/PHRASE_RELATIONSHIP_MODEL.md`
  - `docs/V2_CONTENT_MODEL.md`
  - `content-draft/viet/README.md`
  - `content-draft/viet/source-notes.md`
  - `content-draft/viet/relation-authoring-notes.md`

## Cluster list

- `viet-airport-passport`
- `viet-airport-visa`
- `viet-airport-atm`
- `viet-greeting-hello`
- `viet-greeting-acknowledge`
- `viet-transport-destination`
- `viet-transport-fare`
- `viet-transport-meter`
- `viet-transport-stop-here`
- `viet-food-need-table`
- `viet-food-menu`
- `viet-food-not-spicy`
- `viet-food-bottled-water`
- `viet-food-pay-now`
- `viet-money-how-much`
- `viet-money-final-price`
- `viet-hotel-reservation`
- `viet-hotel-check-in`
- `viet-hotel-checkout-time`
- `viet-hotel-room-hot`
- `viet-hotel-aircon-broken`
- `viet-phone-local-sim`
- `viet-phone-map-not-working`
- `viet-repair-understand`
- `viet-repair-slower`
- `viet-repair-repeat`
- `viet-repair-number`
- `viet-repair-english-help`
- `viet-repair-write-down`
