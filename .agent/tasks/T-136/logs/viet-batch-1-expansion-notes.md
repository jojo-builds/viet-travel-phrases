# Viet Batch 1 Expansion Notes

## What changed

- Added `14` new Viet high-friction families / `28` new rows at `content-draft/viet/phrase-source.csv:1351-1378`.
- Kept the compact variant model intact with one `say-first` row plus one clearer same-intent row for each new family.
- Opened `2` new starter families:
  - `b3-health-vomiting`
  - `b3-health-dehydrated`
- Added `12` new premium families across booking recovery, ride recovery, medication follow-up, bank/phone security recovery, lost-and-found recovery, and connectivity rescue.

## Scenario spread

- `understanding-repair`: `2` families / `4` rows
- `transport`: `2` families / `4` rows
- `health-pharmacy`: `3` families / `6` rows
- `problems-help`: `5` families / `10` rows
- `phone-internet-power`: `2` families / `4` rows

## Family set

- `b3-repair-booking-code`
- `b3-repair-screenshot`
- `b3-tran-end-ride-safely`
- `b3-tran-wait-cash`
- `b3-health-vomiting`
- `b3-health-dehydrated`
- `b3-health-medicine-not-helping`
- `b3-help-block-bank-card`
- `b3-help-contact-bank`
- `b3-help-lock-phone`
- `b3-help-lost-and-found-desk`
- `b3-help-call-lost-and-found`
- `b3-phone-share-hotspot`
- `b3-phone-qr-wont-scan`

## Why it improves listing/detail depth

- Booking recovery now has a cleaner ladder from code capture into screenshot sharing and QR-scan failure.
- Ride recovery now covers both safer stop language and the cash-delay handoff instead of stopping at a generic stop request.
- Health escalation now moves from acute symptom disclosure into dehydration and post-medicine follow-up instead of stopping at generic pharmacy basics.
- Security recovery now supports card blocking, bank contact, phone locking, and lost-property follow-up as adjacent next steps rather than isolated help rows.
- Connectivity recovery now includes both brief hotspot rescue and QR failure wording for modern booking/payment flows.

## Validation

- CSV parse check passed with `28` new `b3` rows, `14` unique new family ids, and no duplicate phrase ids or family-role collisions.
- `npm run build:viet-pack` passed and built `18` scenarios, `1196` intent families, and `1377` phrases.
- `npm run validate:family` passed.
- `npm run validate:premium-boundary` passed.
- `npm run validate:premium-expansion` passed.
