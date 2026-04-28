# T-154 Gate 1 Plan

Status: pre-edit review artifact

## Planned sample delta

- Keep the flagship scope fixed at `15` targeted pages.
- Materially deepen `12` existing answer-page hubs:
  - `viet-polite-hello`
  - `viet-polite-thank-you`
  - `viet-polite-acknowledge`
  - `viet-polite-no-thanks`
  - `viet-repair-understand`
  - `viet-money-how-much`
  - `viet-transport-destination`
  - `viet-health-doctor`
  - `viet-hotel-reservation`
  - `viet-hotel-check-in`
  - `viet-polite-goodbye`
  - `viet-directions-how-to-get`
- Promote `3` guaranteed new full hubs into both sidecars:
  - `viet-polite-excuse-me`
  - `viet-bathroom-where`
  - `viet-service-card`
- Planned bounded-sample count move:
  - relation sample: `99` -> `102`
  - answer-page hubs: `80` -> `83`
  - relation-only clusters: stay `19`

## New hub skeletons

- `viet-polite-excuse-me`
  - cluster: `viet-greeting-excuse-me`
  - family: `polite-excuse-me`
  - class: `greetings-social`
  - mix: `greetings-social-v1`
- `viet-bathroom-where`
  - cluster: `viet-rel-bathroom-where`
  - family: `bathroom-where`
  - class: `practical-service-navigation`
  - mix: `practical-service-navigation-v1`
- `viet-service-card`
  - cluster: `viet-rel-service-card`
  - family: `service-card`
  - class: `money-transaction`
  - mix: `money-transaction-v1`

## Global de-dup rule

- One retained row per behavioral slot unless a second row changes politeness, hierarchy, or a clearly different traveler context.
- Before a row stays primary, compare it against adjacent existing hubs.
- If an adjacent hub already owns that traveler step, reject the candidate or demote it to support-only tracing instead of keeping it as another primary retained row.
- The `90+` retained/supporting-row goal must be met by distinct utility slots across the `15` pages, not by parallel wording for the same move.

## High-risk partitions

- Card hub allowed slots:
  - generic acceptance
  - fee
  - decline
  - retry with another card
  - cash fallback
  - terminal / reader issue
  - bounded cross-context exits
- Card hub reject / demote list:
  - `b2-money-two-cards`
  - transfer-fee rows
  - cancel-card-payment rows
  - `v1000-money-tip-by-card`
  - `v1000-money-debit-card`
- Bathroom hub allowed slots:
  - bathroom location
  - public bathroom nearby
  - ask to use the bathroom
  - fee
  - child urgency
  - immediate cleanup follow-on
- Bathroom hub reject / demote list:
  - shower
  - soap
  - water
  - general hygiene shopping
- Reservation vs check-in split:
  - reservation page owns booking identity and proof
  - check-in page owns front-desk execution
  - desk-flow rows may not be kept twice as primary retained rows across both hubs
- Acknowledge hub allowed slots:
  - respectful acknowledgment
  - plain yes
  - okay / accept
  - okay-now-I-understand
  - commitment / purchase acceptance
- Acknowledge hub reject / demote list:
  - reassurance rows such as `that's okay` / `that's fine`

## Slot maps

### `viet-polite-hello`

- Keep:
  - `polite-1` core hello
  - `polite-5` attention-getter bridge
  - `v500-poli-basi-excuse-me` cleaner attention-getter variant
  - `smalltalk-7` likely social reply
  - `social-9` ask-next social follow-up
  - `directions-1` practical cross-exit
- Reject / demote:
  - `polite-7` as a hello-side primary keep

### `viet-polite-thank-you`

- Keep:
  - `polite-2` core thanks
  - `polite-thank-you-polite` stronger gratitude
  - `polite-6` likely reassurance reply
  - `v900-time-date-book-great-see-you-then` warm close
  - `polite-7` graceful exit
- Reject / demote:
  - heavy apology rows as thank-you alternates

### `viet-polite-acknowledge`

- Keep:
  - `polite-3` respectful acknowledgment
  - `v500-poli-basi-yes` plain yes
  - `v500-poli-basi-okay` okay / accept
  - `v500-unde-repa-okay-now-i-understand` repair-exit acknowledgment
  - `v500-shop-okay-ill-take-it` commitment / decision acceptance
- Reject / demote:
  - `v500-poli-basi-thats-okay`
  - `v900-poli-basi-thats-fine`

### `viet-polite-no-thanks`

- Keep:
  - `polite-4` core refusal
  - `shop-4` just-looking fallback
  - `v900-shop-no-thank-you-ill-look-around-first` shopper-specific refusal
  - `polite-7` graceful close
  - `directions-1` practical exit after refusal
- Reject / demote:
  - generic no-only rows without politeness value

### `viet-polite-excuse-me`

- Keep:
  - `polite-5` mixed excuse-me / sorry anchor
  - `v500-poli-basi-excuse-me` pure attention-getter
  - `v500-poli-basi-sorry` lighter apology branch
  - `v900-poli-basi-im-very-sorry` stronger apology branch
  - `directions-1` high-frequency ask-next use
  - `polite-6` likely reassurance reply
- Reject / demote:
  - hello / goodbye rows as same-function keeps

### `viet-repair-understand`

- Keep:
  - `problems-2` core repair
  - `problems-3` slow-down branch
  - `repair-1` repeat branch
  - `repair-2` write-it-down branch
  - `repair-premium-simpler-words` simpler-language branch
  - `repair-premium-text-me` send-it-as-text branch
  - `v500-unde-repa-sorry-i-dont-speak-vietnamese` language-limit clarification
- Reject / demote:
  - duplicate slow / repeat phrasings that do not change the next move

### `viet-money-how-much`

- Keep:
  - `price-1` core price ask
  - `money-how-much-common` common alternate
  - `price-8` total
  - `money-premium-what-fee` fee check
  - `money-premium-write-total` write-the-total repair
  - `money-premium-price-changed` changed-price challenge
  - `money-premium-total-wrong` wrong-total challenge
  - `v500-mone-numb-pric-how-much-for-one` one-item branch
  - `v900-mone-numb-pric-how-much-for-two-of-them` quantity branch
  - `price-9` small-bills fallback
  - `b2-money-count-together` count-together follow-up
  - `airport-4` ATM exit
- Reject / demote:
  - per-kilo rows as same-function keeps on the flagship price page unless used as support-only market context

### `viet-transport-destination`

- Keep:
  - `taxi-1` core destination ask
  - `taxi-2` area-level destination fallback
  - `transport-fare` likely-reply / price branch
  - `taxi-7` cash-payment follow-up
  - `transport-premium-route-wrong` route-correction branch
  - `directions-map-pin` map rescue
  - `taxi-3` stop-here next step
  - `transport-premium-turn-around` route repair
  - `taxi-6` wait branch
  - `transport-premium-wrong-pickup-point` pickup confirmation
- Reject / demote:
  - hotel taxi booking rows as primary destination keeps

### `viet-health-doctor`

- Keep:
  - `problems-6` core doctor ask
  - `v500-heal-phar-can-you-call-a-doctor` call branch
  - `v500-heal-phar-i-need-a-clinic` clinic branch
  - `v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis` English-capable care branch
  - `v900-heal-phar-how-long-is-the-clinic-wait` wait-time branch
  - `v900-heal-phar-can-i-pay-the-clinic-bill-by-card` clinic-payment branch
  - `v500-heal-phar-i-need-a-hospital` stronger escalation branch
- Reject / demote:
  - symptom sprawl that belongs on symptom-specific pages

### `viet-bathroom-where`

- Keep:
  - `bath-1` core bathroom location
  - `bathroom-use` access / can-I-use-it
  - `v500-bath-pers-need-where-is-the-toilet` toilet wording support
  - `v500-bath-pers-need-is-there-a-public-bathroom-nearby` public-nearby branch
  - `v900-bath-pers-need-is-there-a-fee-for-the-bathroom` fee branch
  - `v900-loca-serv-ever-task-my-child-needs-a-bathroom` urgency branch
  - `bath-4` wash-hands follow-up
  - `bath-2` toilet-paper follow-up
- Reject / demote:
  - `bathroom-shower`
  - `bathroom-soap`
  - `bathroom-water`

### `viet-service-card`

- Keep:
  - `store-6` generic card acceptance
  - `v500-mone-numb-pric-is-there-a-card-fee` fee branch
  - `v500-mone-numb-pric-my-card-was-declined` failure branch
  - `v500-mone-numb-pric-can-i-try-another-card` retry branch
  - `v1000-money-cash-only` cash fallback
  - `b2-money-card-reader` reader / terminal issue
  - `v900-airp-bord-arri-can-i-pay-the-driver-by-card` transport cross-context exit
  - `v900-food-drin-can-i-pay-the-bill-by-card` food cross-context exit
  - `v900-heal-phar-can-i-pay-the-clinic-bill-by-card` clinic cross-context exit
- Reject / demote:
  - `b2-money-two-cards`
  - transfer-fee rows
  - cancel-card-payment rows
  - tip-by-card rows
  - debit-card noun rows

### `viet-hotel-reservation`

- Keep:
  - `hotel-1` core reservation proof
  - `v900-hote-acco-the-reservation-is-under-this-name` booking identity
  - `v500-hote-acco-i-booked-online` booking source proof
  - `v900-time-date-book-can-you-confirm-my-booking` confirmation request
  - `b3-repair-booking-code` booking-code branch
  - `b2-airport-hotel-booking-proof` proof-on-screen branch
  - `hotel-premium-booking-wrong` booking-problem escalation
- Reject / demote:
  - check-in execution rows that belong on `viet-hotel-check-in`

### `viet-hotel-check-in`

- Keep:
  - `hotel-2` core check-in ask
  - `hotel-check-in-polite` polite variant
  - `v500-hote-acco-here-is-my-passport-for-check-in` document handover
  - `v500-hote-acco-do-you-need-a-deposit` deposit branch
  - `hotel-premium-booking-wrong` ask-next trouble branch
  - `b2-airport-hotel-booking-proof-clearer` proof handoff support
- Reject / demote:
  - reservation-identity rows already owned by `viet-hotel-reservation`

### `viet-polite-goodbye`

- Keep:
  - `polite-7` core goodbye
  - `polite-2` thanks-before-close pattern
  - `polite-6` reassurance close
  - `v900-time-date-book-great-see-you-then` future-meet close
  - `v900-shop-no-thank-you-ill-look-around-first` polite-exit shopping branch
- Reject / demote:
  - hello / excuse-me rows as goodbye-side primaries

### `viet-directions-how-to-get`

- Keep:
  - `directions-1` core route ask
  - `directions-map-pin` map branch
  - `directions-map-pin-clearer` clearer map branch
  - `directions-5` turn-right confirmation
  - `transport-1` right-platform branch
  - `transport-premium-wrong-pickup-point` pickup-location clarification
  - `hotel-9` taxi-booking exit
- Reject / demote:
  - destination rows already owned by `viet-transport-destination`

## Planned audit outputs

- Write a keep/reject triage ledger keyed by targeted page and behavioral slot.
- Count retained/supporting rows by newly touched `phrase_id`, not by repeated synonym examples.
- Note every rejected family that lost on same-function comparison so the `90+` target stays auditable.
