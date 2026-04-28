# T-152 Implementation Notes

## What changed

- Expanded the Viet answer-page sample from `50` to `80` answer-page-ready hubs while keeping the relation sample bounded at `99` total clusters.
- Reduced relation-only remainder from `49` clusters to `19` by promoting `30` high-value clusters into answer-page-ready hubs.
- Broadened active answer-page classes from `4` to `7`.
- Split high-value traveler moments into dedicated `money-transaction`, `hotel-accommodation`, and `food-drink` class handling instead of routing those pages through one broad `practical-service-navigation` shape.
- Regenerated `21` existing flagship hubs across greeting/social, urgent help / medical, repair, transport, money, hotel, and food so the top pages now carry richer module mixes and stronger cross-link structure.

## Promotion packet

- New urgent-help / medical hubs: `emergency-manager-now`, `emergency-call-help`, `emergency-get-away`, `emergency-police`, `health-doctor`, `health-allergy`, `emergency-wallet-stolen`
- New repair / clarification hubs: `v900-heal-phar-please-write-the-instructions`, `repair-translate-this`, `v500-unde-repa-can-you-write-the-price`, `repair-which-one`, `repair-time-exact`, `repair-type-phone`
- New money / transaction hubs: `v900-tran-is-that-the-total-price`, `money-total`, `money-what-fee`, `money-service-included`, `b2-money-itemized-bill`
- New hotel / accommodation hubs: `v500-hote-acco-here-is-my-passport-for-check-in`, `hotel-booking-wrong`, `hotel-room-not-ready`, `v500-hote-acco-do-you-need-a-deposit`, `hotel-quiet-room`, `v500-hote-acco-can-someone-come-fix-it`, `hotel-no-hot-water`, `v500-hote-acco-can-i-change-rooms`, `hotel-late-checkout`
- New practical service / navigation hubs: `service-water`, `service-receipt`, `directions-right-route`

## Marker / support strategy

- Added a support-pool rotation so promoted hubs draw additional nearby useful families from low-density support pools instead of repeatedly reusing the same saturated legacy rows.
- Reserved promoted hub anchors and variants before writing support markers so support traces cannot crowd out a hub's own claim markers.
- Kept the note-density guardrail active:
  - no new answer-page markers on legacy rows already carrying `6+` answer-page tokens
  - newly touched rows stay below the `8`-token cap
  - saturated legacy rows receive no new answer-page markers in this pass

## Final validated metrics

- `80` answer-page-ready hubs
- `7` active phrase classes
- `19` relation-only clusters remaining inside the `99`-cluster sample
- `158` total rows in `phrase-source.csv` carrying answer-page markers
- `134` rows in `phrase-source.csv` carrying explicit answer-page support markers
- `80` hubs exposing relation-backed next-step / repair / escalation / nearby-useful paths
- `21` existing flagship hubs explicitly regenerated in this pass
- `134` linked target family ids resolved cleanly during validation

## Validation run

Validated from `E:\AI\SpeakLocal-App-Family-worktrees\viet-1000-row-expansion`:

- JSON parse and shape checks passed for `content-draft/viet/answer-page-sample-v1.json`
- JSON parse and shape checks passed for `content-draft/viet/relation-sample-v1.json`
- CSV audit confirmed `1377` rows total with `158` answer-marked rows and `134` support-marked rows
- Cross-link audit confirmed all relation bucket targets and traveler-response family / phrase ids resolve cleanly
