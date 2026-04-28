# Viet Flagship Cluster Triage Ledger

Compact keep / reject ledger keyed to the 15 targeted flagship pages.

## viet-polite-hello

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core hello | `polite-1` | keep | Keep the clean default greeting as the flagship anchor. |
| attention getter bridge | `polite-5`, `v500-poli-basi-excuse-me` | keep | Retain both brief opener variants because they change how you start the interaction when attention still has to be won. |
| likely social reply | `smalltalk-7` | keep | Keep the friendly social reply because it reflects a common real-world answer before the practical ask. |
| follow-on utility | `social-9`, `directions-1`, `taxi-1` | keep | Keep the practical exits because hello is only useful when it hands off to the real request. |
| goodbye overlap | `polite-7` | reject | Reject goodbye as a hello-side primary keep because it belongs to the closing page instead. |

## viet-polite-thank-you

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core thanks | `polite-2` | keep | Keep the default thank-you as the everyday flagship anchor. |
| stronger gratitude | `polite-thank-you-polite` | keep | Keep the more-polite form because it changes the warmth level for meaningful help. |
| reassurance reply | `polite-6` | keep | Keep the common no-problem style reply because it is what many travelers will hear back. |
| warm close | `polite-7`, `v900-time-date-book-great-see-you-then` | keep | Keep both exit branches because they complete the real-world thank-you flow. |
| apology overlap | `polite-5`, `v500-poli-basi-sorry` | reject | Reject apology rows here because they solve a different traveler problem. |

## viet-polite-acknowledge

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| respectful acknowledgment | `polite-3` | keep | Keep the respectful default because it is still the safest first response. |
| plain yes / okay | `v500-poli-basi-yes`, `v500-poli-basi-okay` | keep | Keep the plainer variants because they shift tone and context in ways the traveler actually notices. |
| understanding exit | `v500-unde-repa-okay-now-i-understand` | keep | Keep the repair-exit branch because it resolves a different moment than a generic yes. |
| commitment acceptance | `v500-shop-okay-ill-take-it` | keep | Keep the acceptance line because it moves from acknowledgment into decision. |
| reassurance overlap | `v500-poli-basi-thats-okay`, `v900-poli-basi-thats-fine` | reject | Reject reassurance rows here because they belong to calming / dismissing, not acknowledging. |

## viet-polite-no-thanks

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core refusal | `polite-4` | keep | Keep the universal polite refusal as the primary anchor. |
| shop refusal branch | `shop-4`, `v900-shop-no-thank-you-ill-look-around-first` | keep | Keep both browsing-specific branches because they stop vendor pressure without sounding hostile. |
| graceful close | `polite-7` | keep | Keep the close because many refusals end with an immediate exit. |
| bare no overlap | `v500-poli-basi-no` | reject | Reject generic no-only wording because it loses the politeness that makes the flagship page useful. |

## viet-polite-excuse-me

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| anchor excuse me | `polite-5` | keep | Promote the mixed excuse-me / sorry line into a full flagship hub because it is the real first-step anchor. |
| pure attention getter | `v500-poli-basi-excuse-me` | keep | Keep the cleaner attention-only version because it changes the traveler's intent from apology to simple contact. |
| lighter apology | `v500-poli-basi-sorry` | keep | Keep the lighter apology branch because it is more specific than the mixed anchor. |
| stronger apology | `v900-poli-basi-im-very-sorry` | keep | Keep the stronger apology because it changes tone and severity in a real way. |
| hello / goodbye overlap | `polite-1`, `polite-7` | reject | Reject hello and goodbye rows here because they solve different traveler moments. |

## viet-repair-understand

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core repair | `problems-2` | keep | Keep the anchor because it still owns the main repair moment. |
| slower / repeat split | `problems-3`, `repair-1` | keep | Keep both because speed trouble and full repetition are different rescue moves. |
| simpler wording / text | `repair-premium-simpler-words`, `repair-premium-text-me` | keep | Keep both because they solve different repair failures. |
| language-limit clarification | `v500-unde-repa-sorry-i-dont-speak-vietnamese` | keep | Keep the broader language-limit branch because it resets the whole exchange when necessary. |
| duplicate repeat phrasing | `repair-repeat-alt` | reject | Reject decorative repeat variants that do not change the next move. |

## viet-money-how-much

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core price ask | `price-1` | keep | Keep the anchor because it still owns the first money question. |
| quantity branches | `v500-mone-numb-pric-how-much-for-one`, `v900-mone-numb-pric-how-much-for-two-of-them` | keep | Keep both because quantity changes the actual traveler move. |
| fee / total / challenge | `price-8`, `money-premium-what-fee`, `money-premium-price-changed`, `money-premium-total-wrong` | keep | Keep the real numeric follow-ons because they create the value moat on the flagship page. |
| written / count rescue | `money-premium-write-total`, `b2-money-count-together` | keep | Keep both because written-price repair and counting-together solve different trust failures. |
| cash exits | `price-9`, `airport-4` | keep | Keep the cash exits because price talk often ends with payment-format friction. |
| per-kilo duplicates | `market-price-per-kilo` | reject | Reject same-function price rows that do not add a distinct traveler slot on the flagship page. |

## viet-transport-destination

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| destination anchor | `taxi-1` | keep | Keep the core destination anchor because it still owns the ride-start moment. |
| area fallback | `taxi-2` | keep | Keep the area-level destination fallback because drivers often need it when the exact place name is not enough. |
| fare reply | `transport-fare` | keep | Keep the fare branch because it is a common first answer after the destination. |
| route / stop / wait repairs | `taxi-3`, `taxi-6`, `transport-premium-route-wrong`, `transport-premium-turn-around`, `v500-tran-please-turn-around`, `transport-premium-wait-here` | keep | Keep these branches because they are the real ride-control moves once the car is in motion or briefly paused. |
| payment / reset exits | `taxi-7`, `b2-airport-taxi-desk`, `v900-airp-bord-arri-can-you-help-me-book-a-taxi` | keep | Keep the fare-payment and taxi-reset exits because they are common next utility moves around the same ride cluster. |
| pickup clarification | `transport-premium-wrong-pickup-point` | keep | Keep pickup clarification because many failures happen before the ride starts, not during it. |
| hotel taxi booking overlap | `hotel-9` | reject | Reject hotel taxi-booking rows as primary destination keeps because they belong on the directions / hotel help side. |

## viet-health-doctor

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core doctor ask | `problems-6` | keep | Keep the doctor anchor because it still owns the immediate medical help moment. |
| call / clinic / language | `v500-heal-phar-can-you-call-a-doctor`, `v500-heal-phar-i-need-a-clinic`, `v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis` | keep | Keep these because they are the real next-step branches once the traveler asks for a doctor. |
| wait / payment reality | `v900-heal-phar-how-long-is-the-clinic-wait`, `v900-heal-phar-can-i-pay-the-clinic-bill-by-card` | keep | Keep these because they reflect the practical shape of actually getting care. |
| hospital escalation | `v500-heal-phar-i-need-a-hospital` | keep | Keep the hospital branch because it materially changes urgency. |
| symptom sprawl | `health-fever-alt`, `health-headache-alt` | reject | Reject symptom sprawl here because symptom-specific pages should own those details. |

## viet-bathroom-where

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core bathroom ask | `bath-1` | keep | Promote the bathroom location ask into a flagship hub. |
| toilet wording repair | `v500-bath-pers-need-where-is-the-toilet` | keep | Keep the toilet wording because it is the cleanest rescue when bathroom phrasing misses. |
| public-nearby fallback | `v500-bath-pers-need-is-there-a-public-bathroom-nearby` | keep | Keep the nearby-public branch because many first bathroom answers immediately redirect the traveler outside the current venue. |
| access / fee / urgency | `bathroom-use`, `v900-bath-pers-need-is-there-a-fee-for-the-bathroom`, `v900-loca-serv-ever-task-my-child-needs-a-bathroom` | keep | Keep these because they are the real next constraints once a bathroom option is in play. |
| cleanup follow-ons | `bath-4`, `bath-2` | keep | Keep wash-hands and toilet-paper as immediate follow-ons tied to the same task. |
| hygiene shopping | `bathroom-shower`, `bathroom-soap`, `bathroom-water` | reject | Reject generic hygiene shopping rows because they do not belong on the flagship bathroom-location page. |

## viet-service-card

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core card question | `store-6` | keep | Promote pay by card into a full flagship hub. |
| fee / decline / retry | `v500-mone-numb-pric-is-there-a-card-fee`, `v500-mone-numb-pric-my-card-was-declined`, `v500-mone-numb-pric-can-i-try-another-card` | keep | Keep these because they are the real card-payment branches, not decorative alternates. |
| cash fallback / reader issue | `v1000-money-cash-only`, `b2-money-card-reader`, `b2-money-card-reader-clearer` | keep | Keep these because they rescue payment when card acceptance is partial or broken. |
| bounded context exits | `v900-airp-bord-arri-can-i-pay-the-driver-by-card`, `v900-food-drin-can-i-pay-the-bill-by-card`, `v900-heal-phar-can-i-pay-the-clinic-bill-by-card` | keep | Keep these because transport, food, and clinic card moments are common enough to justify a bounded exit rail. |
| transfer / debit sprawl | `b2-money-transfer-fee`, `v1000-money-debit-card`, `v1000-money-tip-by-card` | reject | Reject card-adjacent sprawl that belongs on narrower payment pages instead of the flagship card hub. |

## viet-hotel-reservation

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| reservation identity | `hotel-1`, `v900-hote-acco-the-reservation-is-under-this-name`, `v900-time-date-book-the-booking-is-under-this-name` | keep | Keep these because reservation owns booking identity proof. |
| booking source / confirmation | `v500-hote-acco-i-booked-online`, `v900-time-date-book-can-you-confirm-my-booking` | keep | Keep these because they help the desk find and confirm the booking. |
| proof rescue | `b3-repair-booking-code`, `b2-airport-hotel-booking-proof` | keep | Keep these because they rescue the exact reservation failure mode. |
| booking wrong escalation | `hotel-premium-booking-wrong` | keep | Keep booking wrong here because it still belongs to reservation truth before it becomes a room-execution problem. |
| check-in execution rows | `v500-hote-acco-here-is-my-passport-for-check-in`, `v500-hote-acco-do-you-need-a-deposit` | reject | Reject these as reservation primaries because they belong on check-in execution instead. |

## viet-hotel-check-in

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| core check-in line | `hotel-2`, `hotel-check-in-polite` | keep | Keep both because they are the same desk action with distinct tone. |
| passport / deposit execution | `v500-hote-acco-here-is-my-passport-for-check-in`, `v500-hote-acco-do-you-need-a-deposit` | keep | Keep these because they define front-desk execution after reservation identity is already settled. |
| proof handoff rescue | `b2-airport-hotel-booking-proof-clearer` | keep | Keep the clearer proof handoff because it often rescues a stuck desk flow. |
| reservation identity overlap | `v900-hote-acco-the-reservation-is-under-this-name`, `v500-hote-acco-i-booked-online` | reject | Reject these as check-in primaries because reservation should own booking identity. |

## viet-polite-goodbye

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| plain goodbye | `polite-7` | keep | Keep the direct close as the flagship anchor. |
| thanks-before-close | `polite-2`, `polite-thank-you-polite` | keep | Keep the gratitude branch because many real goodbyes still pass through it. |
| future meet close | `v900-time-date-book-great-see-you-then` | keep | Keep see-you-then because it closes a different kind of interaction than plain goodbye. |
| shopping exit | `v900-shop-no-thank-you-ill-look-around-first` | keep | Keep the polite browsing exit because it solves a common real-world close branch. |
| hello overlap | `polite-1`, `polite-5` | reject | Reject hello and excuse-me rows as goodbye primaries because they belong to opening moments. |

## viet-directions-how-to-get

| Slot | Rows | Decision | Rationale |
| --- | --- | --- | --- |
| map rescue | `directions-map-pin`, `directions-map-pin-clearer` | keep | Keep the map rescue because route help often becomes visual immediately. |
| turn / platform / stop | `directions-5`, `transport-1`, `transport-stop-here-clearer` | keep | Keep these because they are the real next route slots after the first directions question. |
| pickup clarification | `transport-premium-wrong-pickup-point` | keep | Keep pickup clarification because route problems often start with the wrong meeting point. |
| taxi exit | `hotel-9` | keep | Keep the taxi exit because sometimes the right route answer is to stop walking and book a ride. |
| destination overlap | `taxi-1` | reject | Reject destination rows as primary directions keeps because the destination page already owns that anchor. |

