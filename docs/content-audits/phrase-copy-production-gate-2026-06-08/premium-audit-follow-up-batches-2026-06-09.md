# Premium Audit Follow-Up Batches

Date: 2026-06-09 / 2026-06-10

This receipt covers the follow-up source-authoring work after the stricter premium audit found the phrase/listing copy was still not production-ready.

## Current Audit Result

- rendered listing pages: `1793`
- `HARD_REVIEW`: `323`
- `WEAK_REVIEW`: `68`
- `WATCH`: `313`
- `PASS`: `1089`
- catalog-promoted split: `299` hard-review, `14` weak-review, `3` watch, `454` pass

The recommendation remains `REVISE_BEFORE_PRODUCTION`. The work below is meaningful progress, not a production-ready closeout.

## Batches Repaired In This Follow-Up

Four hundred thirty top hard-review or trust-blocker catalog-promoted phrase pages were edited in first-class source and regenerated into `native-ios/Resources/viet-authored-listing-pages.json`.

Batch 1 result:

- `viet-phrase-v500-unde-repa-can-you-repeat-the-last-part`: `PASS 0`
- `viet-phrase-v500-time-date-book-can-i-book-online`: `PASS 0`
- `viet-phrase-v500-tran-i-missed-my-stop`: `PASS 0`
- `viet-phrase-v500-tran-please-take-me-to-this-hotel`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-can-you-help-me-book-a-grab`: `PASS 0`
- `viet-phrase-v900-time-date-book-can-you-put-me-on-the-waiting-list`: `PASS 0`
- `viet-phrase-v500-hote-acco-can-i-check-out-late`: `PASS 0`
- `viet-phrase-v500-hote-acco-is-breakfast-included`: `PASS 0`
- `viet-phrase-v900-dire-navi-where-should-the-driver-stop`: moved from `HARD_REVIEW` to `WATCH 7`
- `viet-phrase-v900-hote-acco-can-i-have-a-room-with-a-window`: `PASS 0`

Batch 2 result:

- `viet-phrase-hotel-quiet-room`: `PASS 0`
- `viet-phrase-v500-hote-acco-can-i-have-an-iron`: `PASS 0`
- `viet-phrase-v500-time-date-book-is-re-entry-allowed`: `PASS 0`
- `viet-phrase-v900-tran-please-stop-near-the-entrance`: `PASS 0`
- `viet-phrase-v900-tran-this-is-not-the-place-i-meant`: `PASS 0`
- `viet-phrase-v500-time-date-book-can-i-change-the-date`: `PASS 0`
- `viet-phrase-v500-time-date-book-is-it-open-tomorrow`: `PASS 0`
- `viet-phrase-v900-time-date-book-do-you-have-anything-available-today`: `PASS 0`
- `viet-phrase-v900-time-date-book-please-write-down-the-address`: `PASS 0`
- `viet-phrase-v900-tran-please-tell-me-when-to-get-off`: `PASS 0`

Batch 3 result:

- `viet-phrase-v500-heal-phar-can-you-call-a-doctor`: `PASS 0`
- `viet-phrase-v500-hote-acco-do-you-need-a-deposit`: `PASS 0`
- `viet-phrase-v500-hote-acco-the-electricity-is-out`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-have-a-non-smoking-room`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-have-a-room-with-two-beds`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-clean-the-room-today`: `PASS 0`
- `viet-phrase-v900-hote-acco-the-reservation-is-under-this-name`: `PASS 0`
- `viet-phrase-v900-hote-acco-was-the-deposit-refunded`: `PASS 0`
- `viet-phrase-price-9`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-is-tax-included`: `PASS 0`

Batch 4 result:

- `viet-phrase-v900-hote-acco-can-you-recommend-a-nearby-restaurant`: `PASS 0`
- `viet-phrase-v500-hote-acco-i-booked-online`: `PASS 0`
- `viet-phrase-v500-time-date-book-can-i-choose-my-seat`: `PASS 0`
- `viet-phrase-v900-hote-acco-is-this-room-available-tonight`: `PASS 0`
- `viet-phrase-v900-hote-acco-there-are-insects-in-the-room`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-can-you-scan-this-document`: `PASS 0`
- `viet-phrase-v900-tran-is-there-an-airport-fee`: `PASS 0`
- `viet-phrase-repair-premium-text-me`: `PASS 0`
- `viet-phrase-repair-translate-this`: `PASS 0`
- `viet-phrase-v500-dire-navi-is-it-inside-the-mall`: `PASS 0`

Batch 5 result:

- `viet-phrase-v500-dire-navi-is-it-too-far-to-walk`: `PASS 0`
- `viet-phrase-v500-hote-acco-can-i-change-rooms`: `PASS 0`
- `viet-phrase-v500-shop-can-you-show-me-another-one`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bus-ticket-to-the-city`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-arrivals-hall`: `PASS 0`
- `viet-phrase-v900-dire-navi-where-is-the-main-entrance`: `PASS 0`
- `viet-phrase-v900-heal-phar-should-i-take-it-with-food`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-put-us-in-nearby-rooms`: `PASS 0`
- `viet-phrase-v900-hote-acco-the-shower-is-not-draining`: `PASS 0`
- `viet-phrase-v900-tran-is-this-seat-available`: `PASS 0`

Batch 5 also repaired clear phrase-semantics issues instead of preserving stale audio-backed text:

- `Can you show me another one?`: `Cho tôi xem cái khác được không?`
- `Should I take it with food?`: `Tôi có nên uống thuốc này cùng với đồ ăn không?`
- `Can you put us in nearby rooms?`: `Bạn có thể xếp phòng gần nhau cho chúng tôi không?`
- `The shower is not draining`: `Cống thoát nước chỗ vòi sen bị nghẹt`
- `Is this seat available?`: `Chỗ này còn trống không?`

Those five phrase-source/catalog rows were changed from `ready` audio to `planned` audio so old recordings are not treated as matching the repaired phrase text.

Batch 6 result:

- `viet-phrase-service-8`: `PASS 0`
- `viet-phrase-v500-unde-repa-can-you-show-me-a-picture`: `PASS 0`
- `viet-phrase-v900-heal-phar-can-you-email-the-report-to-me`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-can-you-email-the-receipt`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-is-the-service-charge-included`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-can-you-send-a-text-message-for-me`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-does-this-work-outside-the-city`: `PASS 0`
- `viet-phrase-v900-poli-basi-can-i-sit-here`: `PASS 0`
- `viet-phrase-v900-shop-do-you-have-a-better-quality-one`: `PASS 0`
- `viet-phrase-v900-time-date-book-do-i-need-to-arrive-early`: `PASS 0`

Batch 6 read-only subagent review:

- reviewer: `Hooke` (`019ea983-f4df-7182-8648-049199ff4c3a`)
- initial verdict: `PASS_WITH_RISKS`
- blocker status: no blockers, no thinning, no card deletion
- risk found: repeated `Use it...` at-glance opener across the batch
- main-thread follow-up: rewrote all ten at-glance lines away from the repeated opener, regenerated, reran premium audit, and confirmed all ten Batch 6 pages now score `PASS 0`

Batch 7 result:

- `viet-phrase-v900-tran-please-give-me-a-receipt`: `PASS 0`
- `viet-phrase-transport-2`: `PASS 0`
- `viet-phrase-v500-dire-navi-where-is-the-elevator`: `PASS 0`
- `viet-phrase-v500-loca-serv-ever-task-can-you-fix-this`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-is-there-a-card-fee`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-is-there-an-extra-fee`: `PASS 0`
- `viet-phrase-v500-prob-help-can-you-help-me-contact-my-hotel`: `PASS 0`
- `viet-phrase-v500-time-date-book-can-i-make-a-reservation`: `PASS 0`
- `viet-phrase-v500-tran-does-this-bus-go-there`: `PASS 0`
- `viet-phrase-v500-unde-repa-is-this-the-place-on-the-map`: `PASS 0`

Batch 7 read-only subagent review:

- reviewer: `Avicenna` (`019ea993-1f23-76e3-81fb-5003ffe775b7`)
- initial verdict: `REVISE_BEFORE_PRODUCTION`
- initial blocker status: rendered pages passed, but first-class source still had stale breakdown glosses and card-label risks
- main-thread follow-up: fixed source breakdowns for receipt, bus, map, reservation, and repair; removed app-ish receipt wording; replaced a duplicate hotel-help card with `help-premium-call-this-number`; made the second money price card visibly distinct as `How much money is this?`; regenerated native resources and SQLite
- second verdict: `PASS_WITH_RISKS` for one remaining source-only `sửa cái này` gloss
- final follow-up: corrected `sửa cái này` to `fix this item`, regenerated, reran validators, and received final `PASS`

Batch 8 result:

- `viet-phrase-v900-heal-phar-can-you-help-me-call-my-travel-insurance`: `PASS 0`
- `viet-phrase-v900-heal-phar-is-there-a-pharmacy-nearby`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-get-laundry-service`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-store-my-luggage-after-check-out`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-can-you-help-me-contact-the-bank`: `PASS 0`
- `viet-phrase-v900-time-date-book-please-call-my-name-when-it-is-ready`: `PASS 0`
- `viet-phrase-v900-tran-can-i-pay-the-fare-by-card`: `PASS 0`
- `viet-phrase-v900-tran-i-paid-in-the-app-already`: `PASS 3`
- `viet-phrase-v900-tran-please-open-the-window`: `PASS 0`
- `viet-phrase-v500-time-date-book-where-is-the-line`: `PASS 0`

Batch 8 semantic repair:

- `Where is the line?`: changed the incorrect live Vietnamese `Đường dây ở đâu?` / `Duong day o dau` to `Xếp hàng ở đâu?` / `Xep hang o dau`, retokenized the breakdown, moved the row to planned audio, and changed no-audio phrase cards to `text.bubble.fill`.
- `Please call my name when it is ready`: retokenized the rendered breakdown so `sẵn sàng` stays together as `ready` instead of the incorrect rendered split `sàng = morning`; the page now keeps `8` useful breakdown rows rather than preserving a wrong ninth row.

Batch 8 read-only subagent review:

- reviewer: `Rawls` (`019ea9b4-d9fa-75c3-9b3d-01d51a03ec48`)
- initial verdict: `REVISE_BEFORE_PRODUCTION`
- initial blocker status: rendered `Please call my name when it is ready` split `sẵn sàng` into `sẵn = ready / available` and `sàng = morning`; rendered `Where is the line?` quick-say still carried an unresolved generated `audio-authored-xep-hang-o-dau-*` key despite planned/no-audio source
- main-thread follow-up: repaired the breakdown-audit source for `sẵn sàng`, adjusted the generator to preserve explicit no-audio self phrase cards, regenerated native resources and SQLite, reran validators, and confirmed the focused Batch 8 probe passed
- final verdict: `PASS_WITH_RISKS`
- remaining risk: the old audio manifest still contains the stale `Đường dây ở đâu?` recording entry for `v500-time-date-book-where-is-the-line`, but the rendered page and catalog no longer reference it; treat as audio cleanup risk, not a copy blocker

Batch 9 result:

- `viet-phrase-v900-loca-serv-ever-task-when-will-it-be-ready`: `PASS 0`
- `viet-phrase-hotel-premium-room-not-ready`: `PASS 0`
- `viet-phrase-v500-tran-where-do-i-return-it`: `PASS 0`
- `viet-phrase-v500-unde-repa-can-i-use-a-translation-app`: `PASS 0`
- `viet-phrase-v900-dire-navi-where-is-the-nearest-information-desk`: `PASS 0`
- `viet-phrase-v900-heal-phar-can-i-pay-the-clinic-bill-by-card`: `PASS 0`
- `viet-phrase-v900-heal-phar-do-i-need-to-come-back`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-book-a-car-to-the-airport`: `PASS 0`
- `viet-phrase-v900-time-date-book-can-i-move-it-to-tomorrow`: `PASS 0`
- `viet-phrase-v900-time-date-book-what-time-does-it-finish`: `PASS 0`
- `viet-phrase-v900-tran-the-driver-left-without-me`: `PASS 0`
- `viet-phrase-transport-1`: `PASS 0`

Batch 9 trust repairs:

- `When will it be ready?`: retokenized `sẵn sàng?` as one ready phrase instead of the false rendered split `sẵn = ready / available` and `sàng? = morning`.
- `The room is not ready yet.`: retokenized `chưa sẵn sàng.` as `not ready yet` instead of the false rendered split `sẵn = ready / available` and `sàng. = morning`.
- `Where do I return it?`, `Can I use a translation app?`, `Where is the nearest information desk?`, `Can I pay the clinic bill by card?`, `Do I need to come back?`, `Can you book a car to the airport?`, `Can I move it to tomorrow?`, `The driver left without me`, and `Is this the right platform?` had stale source breakdown glosses retokenized to keep real Vietnamese phrase chunks together.
- Read-only subagent `Meitner` initially returned `PASS_WITH_RISKS` for source-only canonical breakdown roughness on `Can I use a translation app?`, `When will it be ready?`, and `The room is not ready yet.` The main thread aligned those canonical breakdown rows with the rendered/audit rows, regenerated native resources and SQLite, reran premium audit, SQLite validation, breakdown audit, and `git diff --check`; Meitner then rechecked and returned final verdict `PASS`.

Batch 10 result:

- `viet-phrase-v500-phon-inte-powe-can-i-make-a-phone-call`: `PASS 0`
- `viet-phrase-v500-tran-are-you-my-driver`: `PASS 0`
- `viet-phrase-v500-tran-i-will-pay-the-driver-in-cash`: `PASS 0`
- `viet-phrase-v500-tran-is-this-train-delayed`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-currency-exchange`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-international-terminal`: `PASS 0`
- `viet-phrase-v900-dire-navi-is-it-behind-this-building`: `PASS 0`
- `viet-phrase-v900-heal-phar-can-i-get-a-receipt-for-insurance`: `PASS 0`
- `viet-phrase-v900-heal-phar-will-this-make-me-sleepy`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-have-a-higher-floor`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-can-you-refund-the-difference`: `PASS 0`
- `viet-phrase-v900-time-date-book-can-i-have-seats-together`: `PASS 0`

Batch 10 source/rendered trust repairs:

- Retokenized the source and breakdown-audit rows for `gọi điện thoại`, `tài xế của tôi`, `Tôi sẽ trả`, `tiền mặt`, `cho tài xế`, `Chuyến tàu này`, `có bị trễ`, `Nhà ga`, `quốc tế`, `phía sau`, `tòa nhà này`, `nhận được`, `biên nhận`, `bảo hiểm`, `buồn ngủ`, `tầng cao hơn`, `hoàn lại tiền`, `chênh lệch`, and `ngồi chung`.
- Removed the worst false chunks found in the starting source, including `go / move` for phone-call/sleepy pages, `hotel` / `fee` on the behind-building page, `call` for `ngồi chung`, and `price / money` for refund/payment chunks.
- Follow-up reviewer feedback found three audio-backed semantic risks. These were repaired after the first Batch 10 pass: `Can I have a room on a higher floor?` now uses `Cho tôi phòng ở tầng cao hơn được không?`; `Can we sit together?` now uses `Chúng tôi có thể ngồi cùng nhau được không?`; and `Can I get a receipt to submit to insurance?` now uses `Tôi có thể lấy biên nhận để nộp cho bảo hiểm không?`. All three changed self-phrases now render with `audioKey: null` / text-bubble treatment until matching audio is produced.

Remaining-corpus read-only sidecar review:

- reviewer: `Chandrasekhar` (`019ea9e9-0c0f-7412-bca2-64c277d6f080`)
- verdict: `REVISE_BEFORE_PRODUCTION`
- main findings: formulaic projection prose still dominates the remaining catalog-promoted hard-review pages; food, transport/mobility, and health-pharmacy should be prioritized next; semantic gates should be added for queue/line wording, literal `Can I have...` Vietnamese, source/rendered breakdown mismatches, stale audio manifest entries, compound keep-together checks, and related-card topicality.

Batch 11 result:

- `viet-phrase-v900-time-date-book-is-it-closed-on-mondays`: `PASS 0`
- `viet-phrase-v900-tran-can-i-pay-by-bank-transfer`: `PASS 0`
- `viet-phrase-v900-tran-the-motorbike-has-a-problem`: `PASS 0`
- `viet-phrase-v900-unde-repa-can-you-explain-it-in-english`: `PASS 2`
- `viet-phrase-money-premium-split-payment`: `PASS 0`
- `viet-phrase-transport-premium-wrong-pickup-point`: `PASS 0`
- `viet-phrase-v500-tran-do-you-have-a-helmet`: `PASS 0`
- `viet-phrase-v500-tran-is-this-my-car`: `WATCH 5`
- `viet-phrase-v500-tran-please-follow-the-map`: `PASS 0`
- `viet-phrase-v500-tran-please-wait-here`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-departure-hall`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point`: `PASS 0`

Batch 11 source/rendered trust repairs:

- Retokenized or aligned first-class source and breakdown-audit rows for Monday closures, bank transfer, motorbike problem, explain-in-English, split payment, wrong pickup point, helmet, ride identity, map-following, wait-here, departure hall, and Grab pickup pages.
- Preserved phrase cards and related/explore targets while replacing title-as-summary and repeated helper-module prose with concrete traveler moments.
- Follow-up reviewer feedback found a source/rendered `explore-next` card mismatch on the two pickup pages. The source was aligned with the richer rendered pickup/driver support cards, raising those source pages from `9` to `10` phrase cards rather than thinning the rendered experience.

Batch 11 read-only subagent review:

- reviewer: `Hegel` (`019eaa1d-349a-7d12-b91d-c024928715e5`)
- initial verdict: `PASS_WITH_RISKS`
- initial risk: `viet-phrase-transport-premium-wrong-pickup-point` and `viet-phrase-v900-airp-bord-arri-where-is-the-grab-pickup-point` had source/rendered `explore-next` card mismatch
- main-thread follow-up: aligned the first-class source `explore-next` card IDs, Vietnamese, English, pronunciation, symbol, tint, detail target, and audio key with the rendered native resource; regenerated native resources and SQLite; reran validators
- final verdict: `PASS`
- remaining note: benign generated punctuation normalization on the full-breakdown English question rows

Batch 12 result:

- `viet-phrase-v900-dire-navi-is-this-the-correct-pickup-point`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-have-a-cup-of-ice`: `PASS 0`
- `viet-phrase-v900-heal-phar-can-i-drink-alcohol-with-this`: `PASS 0`
- `viet-phrase-v900-heal-phar-can-i-get-a-medical-report`: `PASS 0`
- `viet-phrase-v900-heal-phar-should-i-take-it-before-bed`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-is-there-a-withdrawal-fee`: `PASS 0`
- `viet-phrase-v900-sigh-acti-is-there-an-english-guide`: `PASS 0`
- `viet-phrase-v900-tran-can-i-see-the-rental-agreement`: `PASS 0`
- `viet-phrase-v500-heal-phar-i-am-pregnant`: `PASS 0`
- `viet-phrase-v500-heal-phar-i-have-diarrhea`: `PASS 3`
- `viet-phrase-v500-hote-acco-the-toilet-is-not-working`: `PASS 0`
- `viet-phrase-v500-prob-help-can-i-leave-my-contact-information`: `PASS 0`

Batch 12 semantic/audio-aware repairs:

- `Can I have a cup of ice?`: changed `Tôi có thể có một cốc đá được không?` to `Cho tôi xin một ly đá được không?`.
- `Can I drink alcohol with this?`: changed the vague `với cái này` wording to `Tôi có thể uống rượu khi dùng thuốc này không?`.
- `Can I get a medical report?`: changed stiff `báo cáo y tế` wording to `Tôi có thể lấy giấy xác nhận y tế không?`.
- `Should I take it before bed?`: changed `dùng nó` to medicine-specific `Tôi có nên uống thuốc này trước khi đi ngủ không?`.
- `Is there an English guide?`: changed vague `hướng dẫn tiếng Anh` to person-specific `Có hướng dẫn viên tiếng Anh không?`.
- `The toilet is not working`: changed broad `Nhà vệ sinh không hoạt động` to room-fixture-specific `Bồn cầu không sử dụng được`.
- These six changed self-phrases now render with `audioKey: null` / text-bubble treatment until matching audio exists; SQLite planned missing-audio rows increased from `742` to `748`.

Batch 12 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for pickup points, cafe ice, medicine safety, medical paperwork, bedtime dosage, ATM fees, English guides, rental agreements, pregnancy disclosure, diarrhea, toilet repair, and contact handoff.
- Retokenized breakdown rows so compounds stay together: `điểm đón`, `một ly đá`, `uống rượu`, `khi dùng thuốc này`, `giấy xác nhận y tế`, `uống thuốc này`, `trước khi đi ngủ`, `phí rút tiền`, `hướng dẫn viên tiếng Anh`, `hợp đồng thuê`, `mang thai`, `tiêu chảy`, `Bồn cầu`, and `thông tin liên lạc`.
- Review-gate follow-up fixed six stale top-level hero pronunciations, aligned the pickup-point and cup-of-ice source `explore-next` cards with rendered proof, and replaced the duplicate contact-information source card with `Can you text it to me?` instead of deleting the card.
- Focused rendered probe confirmed `12 / 12` Batch 12 pages now score `PASS`, rendered phrase-card totals remain rich, duplicate card targets remain `0`, and zero-phrase pages remain `0`.

Batch 12 read-only subagent review:

- reviewer: `Bacon` (`019eaa35-7e03-7f70-b3df-49fa82b1f776`)
- initial verdict: `REVISE_BEFORE_PRODUCTION`
- initial risks: six stale hero pronunciations after semantic phrase repairs; source/rendered card mismatch on pickup point, cup of ice, and contact-information sections; two breakdown bodies still using awkward `có ... không` explanation prose
- main-thread follow-up: patched top-level source pronunciations, regenerated native resources and SQLite, aligned first-class source card lists to rendered proof, replaced a duplicate contact-information card with a text-me follow-up, and rewrote the withdrawal-fee and English-guide breakdown bodies
- final verdict: `PASS`
- remaining issue page IDs: none

Batch 13 result:

- `viet-phrase-v500-shop-can-i-touch-it`: `PASS 0`
- `viet-phrase-v500-time-date-book-can-i-change-the-time`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-can-i-charge-my-phone`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-arrange-a-taxi-for-me`: `PASS 0`
- `viet-phrase-v900-tran-please-avoid-toll-roads`: `PASS 0`
- `viet-phrase-v500-prob-help-where-is-the-police-station`: `PASS 0`
- `viet-phrase-v500-soci-smal-talk-where-can-i-wait-out-the-rain`: `PASS 0`
- `viet-phrase-v500-tran-i-left-something-in-the-car`: `PASS 0`
- `viet-phrase-v500-tran-please-lower-the-music`: `PASS 0`
- `viet-phrase-v500-unde-repa-can-you-spell-the-name`: `PASS 0`
- `viet-phrase-v500-unde-repa-do-you-mean-this-one`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-is-there-a-shuttle-between-terminals`: `PASS 0`

Batch 13 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for shop handling, booking time changes, airport phone charging, hotel taxi booking, toll avoidance, police-station directions, rain shelter, lost items in cars, lowering music, spelling names, pointing at the intended option, and terminal shuttles.
- Retokenized breakdown rows so compounds stay together: `chạm vào nó`, `thay đổi thời gian`, `sạc điện thoại`, `sắp xếp`, `một chiếc taxi cho tôi`, `đường thu phí`, `Đồn cảnh sát`, `chờ mưa`, `Tôi để quên`, `trong xe`, `giảm nhạc`, `đánh vần`, `Ý bạn là`, `cái này`, `xe đưa đón`, and `giữa các nhà ga`.
- Review-gate follow-up aligned `map location` source/rendered wording, replaced a duplicate police-station natural-variant card with `Can I leave my contact information?`, and preserved final `?` punctuation on all nine question full-breakdown rows.
- Focused rendered probe confirmed `12 / 12` Batch 13 pages now score `PASS 0`, duplicate card targets remain `0`, and zero-phrase pages remain `0`.

Batch 13 read-only subagent review:

- reviewer: `Ohm` (`019eaa53-8488-7ce2-9add-20967905d1a3`)
- initial verdict: `PASS_WITH_RISKS`
- initial risks: source/render `map pin` vs `map location` normalization, police-station duplicate source card collapsed at render time, and full-breakdown question punctuation mismatch
- main-thread follow-up: fixed source wording, replaced the duplicate police-station card with contact-information, preserved full English question punctuation, regenerated native resources and SQLite, and reran focused probes and validators
- focused probe after cleanup: source/render body parity passed, police-station natural variants source/render IDs match exactly, all nine question full-breakdown rows keep final `?`, global phrase cards rose to `11733`, zero-phrase pages remain `0`, and duplicate-target pages remain `0`
- final verdict after recheck: `PASS`
- remaining issue page IDs: none

Batch 14 result:

- `viet-phrase-v900-dire-navi-please-point-me-in-the-right-direction`: `PASS 0`
- `viet-phrase-v900-dire-navi-where-is-the-nearest-convenience-store`: `PASS 0`
- `viet-phrase-v900-dire-navi-where-is-the-train-station`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-print-my-document-for-me`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-can-you-process-a-refund`: `PASS 0`
- `viet-phrase-v900-shop-can-you-show-me-the-inside`: `PASS 0`
- `viet-phrase-v900-shop-do-you-have-a-smaller-size`: `PASS 0`
- `viet-phrase-v900-time-date-book-can-i-have-a-window-seat`: `PASS 0`
- `viet-phrase-v900-tran-does-that-include-tolls`: `PASS 0`
- `viet-phrase-v900-tran-please-turn-right-here`: `PASS 0`
- `viet-phrase-v900-tran-this-is-the-correct-address`: `PASS 0`
- `viet-phrase-v500-dire-navi-is-it-on-the-corner`: `PASS 0`

Batch 14 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for pointing the right direction, finding a convenience store, finding the train station, hotel printing, refunds, seeing inside an item, smaller sizes, window seats, toll inclusion, turning right, confirming an address, and checking whether a place is on the corner.
- Retokenized breakdown rows so compounds stay together: `chỉ cho tôi`, `đi đúng hướng`, `Cửa hàng tiện lợi`, `gần nhất`, `Nhà ga xe lửa`, `in tài liệu`, `xử lý hoàn tiền`, `cho tôi xem`, `bên trong`, `kích thước nhỏ hơn`, `ngồi cạnh cửa sổ`, `phí cầu đường`, `rẽ phải`, `ở đây`, `địa chỉ`, `chính xác`, and `ở góc`.
- Focused rendered check confirmed `12 / 12` Batch 14 pages now score `PASS 0`, each renders phrase cards, duplicate card targets remain `0`, and zero-phrase pages remain `0`.
- Read-only subagent review is in progress with `Godel` (`019eaa6b-08a1-79d1-992e-a992a7c3a5fa`).

Batch 15 result:

- `12 / 12` repaired pages are out of `HARD_REVIEW` in the current premium audit.
- `8` pages are `PASS 0`; `4` pages are `PASS 2` or `PASS 3`.
- repaired page IDs: `viet-phrase-v500-food-drin-does-this-contain-peanuts`, `viet-phrase-v500-heal-phar-i-have-a-fever`, `viet-phrase-v500-heal-phar-i-have-asthma`, `viet-phrase-v500-hote-acco-can-someone-come-fix-it`, `viet-phrase-v500-phon-inte-powe-can-you-install-it-for-me`, `viet-phrase-v500-time-date-book-is-it-open-today`, `viet-phrase-v500-time-date-book-is-there-a-change-fee`, `viet-phrase-v500-tran-please-go-straight`, `viet-phrase-v900-emer-safe-can-you-help-me-cancel-my-card`, `viet-phrase-v900-food-drin-can-i-have-napkins`, `viet-phrase-v900-food-drin-is-there-a-wait-for-a-table`, `viet-phrase-v900-heal-phar-i-have-high-blood-pressure`.

Batch 16 result:

- `12 / 12` repaired pages are `PASS` in the current premium audit.
- semantic/audio-planned repairs now have aligned source self cards and final full-breakdown rows after the Batch 16 source-card/full-breakdown follow-up.
- repaired page IDs: `viet-phrase-v900-loca-serv-ever-task-can-you-print-this-for-me`, `viet-phrase-v900-phon-inte-powe-is-this-the-correct-location-pin`, `viet-phrase-v900-phon-inte-powe-the-wi-fi-keeps-disconnecting`, `viet-phrase-v900-time-date-book-please-send-it-by-text-message`, `viet-phrase-v900-time-date-book-please-write-down-the-time`, `viet-phrase-v900-tran-can-you-pick-me-up-here`, `viet-phrase-v900-tran-please-take-the-faster-route`, `viet-phrase-v900-tran-the-app-shows-a-different-route`, `viet-phrase-v900-tran-the-entrance-is-on-the-other-side`, `viet-phrase-v500-dire-navi-do-i-go-upstairs`, `viet-phrase-v500-dire-navi-is-it-open-now`, `viet-phrase-v500-emer-safe-someone-is-injured`.

Batch 17 result:

- `viet-phrase-v500-phon-inte-powe-how-many-days-is-it-valid`: `PASS 0`
- `viet-phrase-v500-phon-inte-powe-where-can-i-fix-my-phone`: `PASS 0`
- `viet-phrase-v500-prob-help-can-you-contact-the-driver`: `PASS 0`
- `viet-phrase-v500-time-date-book-do-i-need-a-deposit`: `PASS 0`
- `viet-phrase-v900-emer-safe-this-person-is-bothering-me`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-can-you-type-the-address-for-me`: `PASS 0`
- `viet-phrase-repair-5`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-information-desk`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-pay-the-bill-by-card`: `PASS 0`
- `viet-phrase-v900-food-drin-can-we-sit-by-the-fan`: `PASS 0`
- `viet-phrase-v900-heal-phar-do-you-have-this-medicine`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-get-a-refund-for-the-room`: `PASS 0`

Batch 17 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for validity checks, phone repair, driver contact, deposits, harassment/safety, address typing, map pointing, airport information desks, bill-by-card payment, fan seating, medicine matching, and room refunds.
- Retokenized breakdown rows so compounds stay together: `Có hiệu lực`, `trong bao nhiêu ngày`, `sửa điện thoại`, `liên hệ với`, `đặt cọc`, `làm phiền tôi`, `gõ địa chỉ`, `trên bản đồ`, `Bàn thông tin`, `thanh toán hóa đơn`, `bằng thẻ`, `ngồi cạnh quạt`, `thuốc này`, `được hoàn lại`, and `tiền phòng`.
- Focused rendered check confirmed `12 / 12` Batch 17 pages now score `PASS 0`, every repaired page still renders phrase cards, duplicate card targets remain `0`, and zero-phrase pages remain `0`.

Batch 18 result:

- `viet-phrase-v900-loca-serv-ever-task-can-you-sew-this`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-please-cancel-that-card-payment`: `PASS 0`
- `viet-phrase-v900-shop-do-you-have-a-cheaper-one`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-where-can-i-exchange-money`: `PASS 0`
- `viet-phrase-v900-food-drin-what-is-not-too-spicy`: `PASS 0`
- `viet-phrase-v900-hote-acco-where-can-i-pick-up-my-luggage`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-where-can-i-do-laundry`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-where-can-i-repair-my-bag`: `PASS 0`
- `viet-phrase-v900-poli-basi-may-i`: `PASS 0`
- `viet-phrase-v900-tran-please-stop-at-the-next-corner`: `PASS 0`
- `viet-phrase-phone-7`: `PASS 0`
- `viet-phrase-phone-premium-data-not-working`: `PASS 0`

Batch 18 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for sewing repairs, card-payment cancellation, cheaper shopping options, money exchange, mild food, luggage pickup, laundry, bag repair, permission checks, next-corner stopping, eSIM support, and mobile-data support.
- Treated `May I?` as a real semantic/audio risk instead of papering it over with copy: changed the phrase to `Tôi có thể làm vậy được không?`, aligned self cards, and moved the changed phrase to planned audio.
- Preserved the existing ready audio for `My data is not working.` by keeping its audio-backed punctuation and matching breakdown reconstruction, avoiding false release-blocking missing-audio rows.
- Fixed the mild-food source/rendered explore-card parity issue by making the source own the rendered five-card follow-up set.
- Focused rendered check confirmed `12 / 12` Batch 18 pages now score `PASS 0`, every repaired page still renders phrase cards, duplicate card targets remain `0`, and zero-phrase pages remain `0`.

Batch 19 result:

- `viet-phrase-repair-premium-spell-name`: `PASS 0`
- `viet-phrase-v500-prob-help-can-you-check-the-security-camera`: `PASS 0`
- `viet-phrase-v500-shop-can-i-return-it`: `PASS 0`
- `viet-phrase-v500-sigh-acti-where-is-the-exit`: `PASS 0`
- `viet-phrase-v500-unde-repa-can-you-write-the-time`: `PASS 0`
- `viet-phrase-v500-unde-repa-is-this-the-right-number`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-have-chili-sauce`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-order-this-without-meat`: `PASS 0`
- `viet-phrase-v900-food-drin-do-you-have-beer`: `PASS 0`
- `viet-phrase-v900-heal-phar-please-check-for-drug-interactions`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-where-can-i-print-this`: `PASS 0`
- `viet-phrase-v900-shop-can-you-wrap-it-carefully`: `PASS 0`

Batch 19 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for spelling names, checking security camera footage, returns, exits, written times, number confirmation, chili sauce, no-meat ordering, beer, drug interactions, printing, and careful wrapping.
- Retokenized source and breakdown-audit rows so compounds stay together: `đánh vần tên`, `kiểm tra`, `camera an ninh`, `trả lại`, `Lối ra`, `viết thời gian`, `là con số`, `dùng tương ớt`, `gọi món này`, `mà không có thịt`, `tương tác thuốc`, `in cái này`, `gói nó`, and `cẩn thận`.
- Read-only subagent `Mendel` (`019eaad0-dcd1-74f2-9e43-c8f05b6e2d69`) initially returned `REVISE_BEFORE_PRODUCTION` against the pre-fix candidate batch for wrong source glosses, bare summaries, and source/rendered card parity drift. After fixes, focused checks confirmed `12 / 12` Batch 19 pages score `PASS 0`, exact bad-gloss/template hits are `0`, and focused source/render card-parity hits are `0`.
- Card-parity follow-up aligned four first-class source pages with rendered proof: the security-camera page removed a duplicate source-only need-help card that already renders once in Explore Next; the chili-sauce, no-meat, and beer pages gained source cards to match the richer rendered food/drink follow-up sets instead of thinning rendered cards.

Batch 20 result:

- `viet-phrase-v900-shop-where-is-the-fitting-room`: `PASS 0`
- `viet-phrase-v900-tran-please-wait-while-i-get-in`: `PASS 0`
- `viet-phrase-food-premium-has-peanuts`: `PASS 0`
- `viet-phrase-food-premium-without-this-ingredient`: `PASS 0`
- `viet-phrase-help-premium-contact-embassy`: `PASS 2` (`use_it_when`)
- `viet-phrase-hotel-premium-late-checkout`: `PASS 0`
- `viet-phrase-v500-dire-navi-do-i-go-downstairs`: `PASS 0`
- `viet-phrase-v500-emer-safe-please-call-the-police`: `PASS 2` (`use_it_when`)
- `viet-phrase-v500-emer-safe-there-has-been-an-accident`: `PASS 2` (`use_it_when`)
- `viet-phrase-v500-prob-help-can-you-call-my-emergency-contact`: `PASS 2` (`use_it_when`)
- `viet-phrase-v500-shop-is-this-new`: `PASS 0`
- `viet-phrase-v500-sigh-acti-where-is-the-entrance`: `PASS 0`

Batch 20 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for fitting rooms, vehicle boarding, peanuts, ingredient removal, embassy contact, late checkout, downstairs navigation, police calls, accidents, emergency contacts, new-item checks, and entrances.
- Treated two phrase strings as semantic/audio-aware repairs instead of hiding them with prose: `Please wait while I get in` now uses `Vui lòng đợi tôi lên xe`; `Can you make it without this ingredient?` now uses `Bạn có thể làm món này không có nguyên liệu này được không?`. Both self phrases and related cards moved to planned audio/text-bubble state until matching recordings exist.
- Read-only subagent `Confucius` (`019eaae4-0bd2-7a41-a08c-e3cbdb6ac6b2`) initially returned `REVISE_BEFORE_PRODUCTION` against the pre-fix candidate batch for template/process language, emergency template leaks, source/render card parity risks, and semantic/audio concerns. After fixes, focused checks confirmed `12 / 12` original Batch 20 pages score `PASS`, exact template/bad-gloss hits are `0`, and focused source/render card-parity hits for those original twelve are `0`.
- Card-parity follow-up aligned `21` first-class source pages that link to `food-premium-without-this-ingredient`: the cards were preserved, retitled to the repaired Vietnamese, given the repaired pronunciation, and changed from stale speaker/audio cards to text-bubble planned-audio cards. A narrow generator fix then stopped rendered related cards from carrying stale generated `audio-authored-*` keys; rendered `food-premium-without-this-ingredient` occurrences now have `0` audio keys. The adjacent food/allergy source-render layout drift remains open on `16` pages / `32` parity rows and is part of the global parity backlog.

Batch 21 result:

- `viet-phrase-v900-airp-bord-arri-do-i-need-to-fill-out-this-form`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-is-the-smoking-area`: `PASS 0`
- `viet-phrase-v900-dire-navi-can-you-call-this-place-and-ask-for-directions`: `PASS 0`
- `viet-phrase-v900-food-drin-can-we-sit-inside`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-have-a-hair-dryer`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-can-you-print-the-receipt`: `PASS 0`
- `viet-phrase-v900-poli-basi-can-i-come-in`: `PASS 0`
- `viet-phrase-v900-shop-can-i-see-that-one`: `PASS 0`
- `viet-phrase-v900-shop-can-you-give-me-a-discount`: `PASS 0`
- `viet-phrase-v900-sigh-acti-is-photography-allowed`: `PASS 0`
- `viet-phrase-v900-tran-the-car-number-is-different`: `PASS 0`
- `viet-phrase-v900-tran-which-bus-goes-to-the-city-center`: `PASS 0`

Batch 21 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for arrival forms, smoking areas, phone calls for directions, indoor restaurant seating, hotel hair dryers, printed receipts, doorway permission, pointing at shop items, discounts, photo rules, license-plate mismatches, and city-center buses.
- Treated two phrase strings as semantic/audio-aware repairs instead of hiding them with prose: `Can I have a hair dryer?` now uses `Tôi có thể mượn máy sấy tóc được không?`; `The license plate is different` now uses `Biển số xe không giống`. Both changed self phrases moved to planned audio/text-bubble state until matching recordings exist.
- `Can we sit inside?` was initially repaired to the more semantically precise `Chúng tôi...`, but SQLite validation caught that this phrase appears in city Useful Phrases, where bundled audio is required. The page now keeps the existing audio-backed `Chúng ta có thể ngồi bên trong được không?` as an accepted temporary copy/audio compromise while preserving the richer page prose.
- Card-parity follow-up mirrored the rendered five-card restaurant-flow `Explore next` set back into first-class source for `Can we sit inside?`, increasing that source section from `2` to `5` cards and aligning the body with the actual rendered cards. Focused checks now show `12 / 12` Batch 21 pages at `PASS 0`, focused source/render card-parity hits at `0`, and exact old validator/process phrase hits at `0`.
- Read-only reviewers Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) and Pauli (`019eab18-6b39-7202-a18f-1aef899a9f43`) returned `PASS_WITH_RISKS`: Batch 21 copy/card quality passed and no thinning was found, but they flagged minor source/render drift on the directions-call page and a stale anti-thinning ledger row for the earlier `Chúng tôi...` attempt. The main thread aligned the directions-call source with rendered proof, rewrote the twelve Batch 21 ledger rows from current source state, regenerated catalog/listing/SQLite resources, and reran validation. After the fix, the directions-call source/render check has `0` diffs for summary, `at-glance`, and `quick-say`; the `can-we-sit-inside` ledger row records `Chúng ta...`, `11` preserved phrase cards, and the bundled-audio compromise. Pauli rechecked the two fixes and returned `PASS`.

Batch 22 result:

- `viet-phrase-v500-bath-pers-need-where-can-i-wash-my-hands`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-ill-think-about-it`: `PASS 0`
- `viet-phrase-v500-soci-smal-talk-will-it-rain-today`: `PASS 0`
- `viet-phrase-v500-tran-please-drive-carefully`: `PASS 0`
- `viet-phrase-v500-tran-please-drive-slower`: `PASS 0`
- `viet-phrase-v500-unde-repa-please-mark-it-here`: `PASS 0`
- `viet-phrase-v500-unde-repa-that-is-not-what-i-meant`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-can-i-pay-the-driver-by-card`: `PASS 0`
- `viet-phrase-v900-dire-navi-is-it-across-from-the-cafe`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-order-half-a-portion`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-have-a-cough`: `PASS 0`
- `viet-phrase-v900-tran-i-think-the-fare-is-wrong`: `PASS 0`

Batch 22 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for hand-washing, pausing a purchase decision, checking rain, ride safety, marking forms/maps/screens, correcting misunderstandings, driver card payment, cafe landmarks, half portions, cough symptoms, and fare disputes.
- Fixed one validation-caught source breakdown issue on `That is not what I meant` by keeping `không phải là` together so non-final tokens reconstruct the full phrase.
- Kept the cough phrase on the same audio-backed Vietnamese while repairing the visible title casing from `tôi bị ho` to `Tôi bị ho`.
- Card-parity follow-up mirrored the rendered five-card food-order `Explore next` set back into first-class source for `Can I order half a portion?`, increasing that source section from `2` to `5` cards and replacing a non-rendered lime source-only mismatch with the actual rendered chili-sauce, napkins, two-of-these, one-more, and one-portion flow.
- Focused Batch 22 checks now show `12 / 12` pages at `PASS 0`, focused source/render card-parity hits at `0`, and exact old validator/process phrase hits at `0`.
- Read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `REVISE_BEFORE_PRODUCTION` for the full corpus, while confirming Batch 22 itself is clean and not thinned. The reviewer cited current global blockers: `520` hard-review pages, visible process-language phrases in rendered output, and `397` source/render card-parity rows across `240` pages.

Batch 23 result:

- `viet-phrase-v900-tran-please-avoid-the-highway`: `PASS 0`
- `viet-phrase-v900-tran-please-turn-left-at-the-next-street`: `PASS 0`
- `viet-phrase-food-17`: `PASS 0`
- `viet-phrase-money-premium-service-included`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-i-am-here-for-tourism`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-where-is-gate-10`: `PASS 0`
- `viet-phrase-v500-bath-pers-need-where-can-i-buy-shampoo`: `PASS 0`
- `viet-phrase-v500-dire-navi-is-it-near-the-market`: `PASS 0`
- `viet-phrase-v500-food-drin-i-ordered-this-without-peanuts`: `PASS 0`
- `viet-phrase-v500-heal-phar-i-have-food-poisoning`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-can-i-have-a-receipt`: `PASS 0`
- `viet-phrase-v500-phon-inte-powe-can-i-use-the-wi-fi`: `PASS 0`

Batch 23 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for highway avoidance, next-street turns, split bills, service-charge checks, tourism arrival, gate finding, shampoo, market landmarks, peanut-order repair, food poisoning, receipts, and Wi-Fi permission.
- Retokenized source and breakdown-audit rows where needed so the page explains the actual traveler phrase instead of keeping weak word-piece glosses.
- Card-parity follow-up mirrored two richer rendered `Explore next` sets back into first-class source: `Can we pay separately?` now carries the payment/change/cash follow-up cards, and `I ordered this without peanuts` now carries the no-meat/allergy/no-peanuts follow-up cards. Both source sections grew from `2` to `5` cards instead of thinning rendered cards.
- Focused Batch 23 checks now show `12 / 12` pages at `PASS 0`, focused source/render card-parity hits at `0`, and exact old validator/process phrase hits at `0`.
- Read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `REVISE_BEFORE_PRODUCTION` for the full corpus and flagged two Batch 23 body-parity risks: shampoo `quick-say` rendered as a generic fallback, and market-landmark `quick-say` / `good-to-know` drifted from source. The main thread rewrote those bodies in first-class source, regenerated catalog/listing/SQLite resources, and directly verified source/render bodies now match exactly on the flagged sections.

Batch 24 result:

- `viet-phrase-v900-dire-navi-should-i-cross-the-street`: `PASS 0`
- `viet-phrase-v900-food-drin-can-we-sit-outside`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-have-a-sore-throat`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-hurt-my-arm`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-stay-one-more-night`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-email-me-the-invoice`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-do-you-accept-us-dollars`: `PASS 4` (`body_repeated_8_plus`)
- `viet-phrase-v900-mone-numb-pric-is-there-an-atm-nearby`: `PASS 0`
- `viet-phrase-v900-time-date-book-is-this-the-right-line`: `PASS 0`
- `viet-phrase-repair-show-me`: `PASS 0`
- `viet-phrase-v500-emer-safe-please-call-an-ambulance`: `PASS 0`
- `viet-phrase-v500-emer-safe-please-leave-me-alone`: `PASS 0`

Batch 24 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for street-crossing safety, outdoor seating, sore throat, arm injury, extra-night stays, emailed invoices, US-dollar acceptance, nearby ATMs, queue-line confirmation, show-me repair, ambulance calls, and leave-me-alone safety.
- Repaired `Is this the right line?` from `Đây có phải là dòng đúng không?` to `Đây có phải là hàng đúng không?`, updated source/search/rendered resources, and moved the changed self phrase to planned audio/text-bubble state until matching audio exists.
- Replaced six renderer-fallback `when-to-use` bodies and one internal `repair phrase` taxonomy phrase in first-class source.
- Read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `REVISE_BEFORE_PRODUCTION` for the full corpus and initially flagged Batch 24 source/render drift: outdoor seating still had `2` source `Explore next` cards while rendered proof had `5`, ATM rendered summary fell back to generic money copy, and three source-only `when-to-use` bodies still carried fallback wording. The main thread grew outdoor seating from `2` to `5` source cards, rewrote the ATM summary, replaced the crossing/extra-night/invoice fallback bodies, regenerated catalog/listing/SQLite resources, and reran focused proof.
- Focused Batch 24 checks showed `12 / 12` pages at `PASS`, focused source/render card-parity hits at `0`, exact old validator/process phrase hits at `0`, and no active `dòng` queue-line wording in source/render/planned-audio artifacts. At that checkpoint, the main-thread recommendation remained `REVISE_BEFORE_PRODUCTION` for the full corpus until the remaining hard/weak pages and source/render parity rows were repaired or explicitly adjudicated.

Batch 25 result:

- `viet-phrase-v500-food-drin-does-this-contain-shrimp`: `PASS 0`
- `viet-phrase-v500-hote-acco-can-i-check-in-early`: `PASS 0`
- `viet-phrase-v500-hote-acco-what-time-is-breakfast`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-do-i-need-exact-change`: `PASS 0`
- `viet-phrase-v500-poli-basi-sorry`: `PASS 2` (`use_it_when`)
- `viet-phrase-v900-bath-pers-need-is-there-a-fee-for-the-bathroom`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-have-rice-with-this`: `PASS 0`
- `viet-phrase-v900-food-drin-that-was-very-good`: `PASS 0`
- `viet-phrase-v900-heal-phar-is-this-safe-with-my-medicine`: `PASS 0`
- `viet-phrase-v900-heal-phar-please-write-the-instructions`: `PASS 0`
- `viet-phrase-v900-poli-basi-im-in-a-hurry`: `PASS 0`
- `viet-phrase-v900-sigh-acti-is-this-included-in-the-ticket`: `PASS 0`

Batch 25 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for shrimp checks, early hotel arrival, breakfast timing, exact cash, apologies, restroom fees, side rice, food compliments, medicine interactions, written dosage instructions, hurry/time pressure, and ticket inclusions.
- Corrected seven semantically weak or literal Vietnamese phrases and moved those self-phrases to planned/no-audio state instead of reusing mismatched recordings: exact change, sorry, bathroom fee, rice with this, food compliment, medicine safety, and written medicine instructions. The hurry page kept its existing audio after casing and breakdown-gloss repair only.
- Grew two food `Explore next` source sections to the richer rendered sets instead of thinning: side-rice and food-compliment pages now preserve `11` phrase cards in rendered proof.
- Synced stale references after the semantic repairs: `18` canonical source files with related phrase cards, `6` search-only placements, and `8` internal rationale rows now agree with the repaired phrase source.
- Protected the already-passed city pages by replacing three HCMC city Useful Phrase cards that would otherwise point at planned/no-audio repaired phrases. Bep Me In and Cuc Gach Quan now use audio-backed `food-1` / `One portion please`; Mặn Mòi now uses audio-backed `smalltalk-5` / `The food is so good`. The same substitutions were synced into `content-draft/viet/city-library/v1.json` so the current native runtime/SQLite path matches v2.2 source.
- Focused Batch 25 checks showed `12 / 12` pages at `PASS`, focused source/render card-parity hits at `0`, exact old-text hits at `0` across active source/projection paths, city strict validation at `520 / 520` pass, and SQLite city Useful Phrase audio checks passing. At that checkpoint, the main-thread recommendation remained `REVISE_BEFORE_PRODUCTION` for the full corpus until the remaining hard/weak pages and source/render parity rows were repaired or explicitly adjudicated.

Batch 26 result:

- `viet-phrase-v900-time-date-book-can-i-get-a-ticket-refund`: `PASS 0`
- `viet-phrase-v900-time-date-book-can-you-send-a-confirmation-message`: `PASS 0`
- `viet-phrase-bath-6`: `PASS 0`
- `viet-phrase-emergency-6`: `PASS 0`
- `viet-phrase-emergency-premium-phone-stolen`: `PASS 0`
- `viet-phrase-v500-emer-safe-i-lost-my-credit-card`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-my-card-was-declined`: `PASS 0`
- `viet-phrase-v500-phon-inte-powe-can-i-borrow-a-charger`: `PASS 0`
- `viet-phrase-v500-soci-smal-talk-can-we-go-somewhere-cooler`: `PASS 0`
- `viet-phrase-v900-food-drin-i-have-been-waiting-a-long-time`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-need-rehydration-salts`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-leave-my-bags-until-check-in`: `PASS 0`

Batch 26 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for ticket refunds, confirmation messages, shower access, stolen bag/phone/card problems, declined card payment recovery, charger borrowing, cooler-place small talk, long restaurant waits, rehydration salts, and luggage hold before check-in.
- Retokenized misleading breakdown rows without changing the audio-backed phrase text, including `đã bị đánh cắp.`, `bị lấy mất`, `đã bị từ chối`, `được hoàn tiền vé`, `có chỗ tắm`, and `rất lâu rồi`.
- Preserved rendered phrase-card depth: `11 / 12` pages render `9` phrase cards, and the restaurant wait page renders `11` phrase cards.
- Focused Batch 26 checks showed `12 / 12` pages at `PASS 0`, exact tracked helper/process-language hits at `0` across those pages, catalog-promoted authoring validation passed after removing a banned `support` wording, SQLite passed, production QA stayed at `0` blockers / `0` majors, and `git diff --check` passed. A focused reviewer returned `PASS_WITH_RISKS` because the long-wait restaurant page's rendered `Explore next` set was richer than source; the main thread then aligned that source section to the five rendered cards, added one anti-thinning ledger row, regenerated, and improved source/render parity to `386` rows across `234` pages. At that checkpoint, the main-thread recommendation remained `REVISE_BEFORE_PRODUCTION` for the full corpus until the remaining hard/weak pages and source/render parity rows were repaired or explicitly adjudicated.

Batch 27 result:

- `viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me`: `PASS 0`
- `viet-phrase-v900-sigh-acti-is-lunch-included`: `PASS 0`
- `viet-phrase-help-premium-call-this-number`: `PASS 0`
- `viet-phrase-help-premium-come-with-me`: `PASS 0`
- `viet-phrase-hotel-8`: `PASS 0`
- `viet-phrase-time-6`: `PASS 0`
- `viet-phrase-v500-dire-navi-is-it-next-to-the-hotel`: `PASS 0`
- `viet-phrase-v500-heal-phar-i-have-chest-pain`: `PASS 0`
- `viet-phrase-v500-hote-acco-there-is-no-hot-water`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-can-you-give-me-change`: `PASS 0`
- `viet-phrase-v900-dire-navi-is-it-past-the-traffic-light`: `PASS 0`
- `viet-phrase-v900-dire-navi-is-this-the-correct-street`: `PASS 0`

Batch 27 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for service-counter email requests, lunch-included tour checks, help-call and come-with-me handoffs, key-card and hot-water front-desk problems, later booking changes, hotel-landmark and traffic-light direction checks, urgent chest-pain wording, cash change, and correct-street confirmation.
- Retokenized breakdown rows around real phrase chunks such as `gửi email`, `bao gồm`, `gọi số này`, `đi cùng tôi`, `không mở được`, `Dời lại`, `ở cạnh`, `đau ngực`, `chỉ có`, `tiền lẻ`, `đèn giao thông`, and `đường phố chính xác`.
- Preserved rendered phrase-card depth: `10 / 12` pages render `9` phrase cards, and the two help pages render `8` cards after removing only a duplicate, source-only natural-variant help target that already appears through the richer help handoff set.
- Focused Batch 27 proof showed `12 / 12` pages at `PASS 0`; the Batch 27 checkpoint audit reported `459` hard-review, `65` weak-review, `312` watch, and `957` pass pages. Source/render card parity improved to `382` mismatch rows across `232` pages (`86` unique source-card missing rows, `296` section layout diff rows, `0` hard-block rows). Read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `REVISE_BEFORE_PRODUCTION` for one visible process-language blocker on the correct-street page; the main thread replaced it with traveler-facing street-sign/map guidance, regenerated, verified the old wording had `0` source/rendered hits, and Carson rechecked with final Batch 27 verdict `PASS`. Full-corpus recommendation remains `REVISE_BEFORE_PRODUCTION` until the remaining hard/weak pages and parity backlog are repaired or explicitly adjudicated.

Batch 28 result:

- `viet-phrase-v900-dire-navi-where-is-the-back-entrance`: `PASS 0`
- `viet-phrase-v900-food-drin-can-you-clean-this-table`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-i-have-a-room-away-from-the-street`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-help-me-with-my-bags`: `PASS 0`
- `viet-phrase-v900-hote-acco-please-do-not-clean-the-room-today`: `PASS 0`
- `viet-phrase-v900-hote-acco-please-wake-me-up-at-six`: `PASS 0`
- `viet-phrase-v900-hote-acco-the-room-smells-like-smoke`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-where-can-i-buy-mosquito-repellent`: `PASS 0`
- `viet-phrase-v900-tran-does-the-rental-include-insurance`: `PASS 0`
- `viet-phrase-v900-tran-please-show-me-how-to-start-it`: `PASS 0`
- `viet-phrase-food-premium-too-spicy-now`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-i-dont-have-a-printed-copy`: `PASS 0`

Batch 28 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for rear entrances, table cleaning, quiet hotel rooms away from the street, luggage help, housekeeping skip requests, wake-up calls, smoke-smell reports, mosquito-repellent purchase, rental insurance, how-to-start demonstrations, too-spicy restaurant repair, and digital-document handoffs at counters.
- Retokenized breakdown rows around real phrase chunks such as `Lối vào`, `phía sau`, `lau`, `cái bàn này`, `cách xa`, `không dọn phòng`, `lúc sáu giờ`, `có mùi`, `thuốc chống muỗi`, `Giá thuê`, `bảo hiểm`, `cách bắt đầu`, `quá cay`, and `bản in`.
- Preserved rendered phrase-card depth: `10 / 12` pages render `9` phrase cards, the clean-table page renders `11` after source was grown to match the richer restaurant-flow card set, and the too-spicy page renders `7` after removing only a source-only card that the native renderer already omitted.
- Focused Batch 28 proof shows `12 / 12` pages at `PASS 0`; focused source/render card-parity rows for those page IDs are `0`. At the Batch 28 checkpoint, the full premium audit reported `446` hard-review, `66` weak-review, `312` watch, and `969` pass pages. Source/render card parity was `378` mismatch rows across `230` pages (`84` unique source-card missing rows, `294` section layout diff rows, `0` hard-block rows).
- Read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `PASS_WITH_RISKS` for two visible section bodies that referred to cards while the cards lived in adjacent sections. The main thread replaced both bodies with traveler-facing follow-up wording, regenerated source projections and native resources, verified the old strings had `0` active source/rendered/script hits, and recorded `2` reviewer-polish anti-thinning rows. Carson rechecked the two fixed pages and returned final Batch 28 verdict `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 29 result:

- `viet-phrase-v500-bath-pers-need-do-you-have-hand-sanitizer`: `PASS 0`
- `viet-phrase-v500-dire-navi-can-you-help-me-get-back-to-my-hotel`: `PASS 0`
- `viet-phrase-v500-shop-can-you-put-it-in-a-bag`: `PASS 0`
- `viet-phrase-v500-shop-do-you-have-this`: `PASS 0`
- `viet-phrase-v500-time-date-book-i-booked-the-wrong-time`: `PASS 2`
- `viet-phrase-v900-heal-phar-i-need-fever-medicine`: `PASS 4`
- `viet-phrase-v900-heal-phar-is-there-an-english-speaking-doctor-or-pharmacis`: `PASS 2`
- `viet-phrase-v900-phon-inte-powe-how-many-gigabytes-are-included`: `PASS 0`
- `viet-phrase-v900-time-date-book-do-i-need-to-bring-my-passport`: `PASS 0`
- `viet-phrase-v900-unde-repa-can-you-read-this-translation`: `PASS 2`
- `viet-phrase-service-9`: `PASS 2`
- `viet-phrase-transport-premium-turn-around`: `PASS 2`

Batch 29 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for sanitizer requests, getting back to a hotel, shop bag and availability checks, wrong booking times, fever medicine, English-speaking medical help, mobile data allowances, passport requirements, translation checks, bottle refills, and turn-around driver recovery.
- Preserved rendered phrase-card depth: all `12 / 12` Batch 29 pages render `9` phrase cards.
- Fixed one breakdown reconstruction issue on `How many gigabytes are included?` by keeping the punctuated final chunk `được bao gồm?`.
- Fixed one validator wording issue on `Can you put it in a bag?` by changing `very thin plastic` to `lightweight plastic`, preserving the bag-fee/material caveat instead of deleting it.
- Focused Batch 29 proof shows `12 / 12` pages at `PASS`, focused source/render card-parity rows at `0`, targeted process-language hits at `0`, and full premium audit now reports `434` hard-review, `66` weak-review, `312` watch, and `981` pass pages. Source/render card parity remains `378` mismatch rows across `230` pages (`84` unique source-card missing rows, `294` section layout diff rows, `0` hard-block rows).
- Read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) found two real Batch 29 source/render body-parity blockers: the hotel-return and fever-medicine pages had projection-safe source edits, but the rendered resource still showed generator fallback copy. The main thread rewrote those two source bodies to survive projection, regenerated authored listing pages, catalog, and SQLite, and verified `0` Batch 29 source/render body mismatch pages plus `0` targeted process/template hits. Carson's focused recheck returned final Batch 29 verdict `PASS`; hard blockers: none; remaining Batch 29 risks: none blocking; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 30 result:

- `viet-phrase-v500-food-drin-i-am-allergic-to-fish-sauce`: `PASS 0`
- `viet-phrase-v500-loca-serv-ever-task-is-there-a-ramp`: `PASS 0`
- `viet-phrase-v500-phon-inte-powe-can-you-activate-it-for-me`: `PASS 0`
- `viet-phrase-v500-shop-this-is-too-big`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-can-you-copy-this-document`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-how-long-will-the-repair-take`: `PASS 0`
- `viet-phrase-v900-time-date-book-please-send-the-refund-to-this-card`: `PASS 0`
- `viet-phrase-food-16`: `PASS 0`
- `viet-phrase-phone-premium-no-signal`: `PASS 0`
- `viet-phrase-phone-premium-otp-not-arriving`: `PASS 0`
- `viet-phrase-v500-food-drin-this-tastes-spoiled`: `PASS 0`
- `viet-phrase-v500-phon-inte-powe-please-write-the-password`: `PASS 0`

Batch 30 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for fish-sauce allergy disclosure, ramp access, SIM/eSIM activation, too-big sizing, copy-shop document copying, phone repair timing, card refunds, wrong food orders, no mobile signal, stuck verification codes, spoiled food, and written-password setup.
- Fixed one breakdown reconstruction issue on `Can you copy this document?` by keeping the punctuated final chunk `tài liệu này?`.
- Removed one banned/internal `support` wording from the OTP page by changing it to `app help chats`.
- Preserved rendered phrase-card depth: Batch 30 pages render `11/9/9/9/9/9/9/11/9/9/7/9` phrase cards.
- Initial read-only reviewer Carson returned `PASS_WITH_RISKS` for three food source/render card-parity rows. The main thread added `native-ios/scripts/apply-viet-premium-batch-30-card-parity.js`, aligned the three first-class source `Explore next` card lists to rendered proof, regenerated, and verified focused Batch 30 source/render card-parity hits at `0`.
- Focused Batch 30 proof shows `12 / 12` pages at `PASS 0`, targeted process-language hits at `0`, rendered proof failures at `0`, and `15` Batch 30 anti-thinning rows recorded. Full premium audit now reports `422` hard-review, `66` weak-review, `312` watch, and `993` pass pages. Source/render card parity improved to `372` mismatch rows across `227` pages (`81` unique source-card missing rows, `291` section layout diff rows, `0` hard-block rows).
- Carson's final Batch 30 recheck returned `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 31 result:

- `viet-phrase-v500-poli-basi-okay`: `PASS 0`
- `viet-phrase-v500-sigh-acti-can-i-have-a-map`: `PASS 0`
- `viet-phrase-v500-unde-repa-can-you-write-the-address`: `PASS 0`
- `viet-phrase-v500-unde-repa-is-this-translation-correct`: `PASS 0`
- `viet-phrase-v900-food-drin-i-think-there-is-a-mistake-on-the-bill`: `PASS 0`
- `viet-phrase-v900-food-drin-ill-have-what-they-are-having`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-can-we-sit-somewhere-quieter`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-please-print-it-in-black-and-white`: `PASS 0`
- `viet-phrase-v900-shop-do-you-have-this-in-black`: `PASS 0`
- `viet-phrase-v900-time-date-book-id-like-to-book-for-tomorrow`: `PASS 0`
- `viet-phrase-v900-time-date-book-is-this-ticket-for-today`: `PASS 0`
- `viet-phrase-emergency-7`: `PASS 0`

Batch 31 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for agreement, map requests, written addresses, translation checks, bill mistakes, same-dish ordering, quieter seating, black-and-white printing, black item color checks, tomorrow bookings, ticket-date checks, and embassy help.
- Repaired bad or misleading breakdown glosses, including the old `đen và trắng = pay` and ticket-date gloss drift, while keeping final full-phrase rows.
- Replaced unrelated service/shop follow-up card clusters on the quieter-seat, print, bill, same-dish, and embassy pages with more relevant existing target cards. The fix preserved or expanded rendered depth rather than deleting cards.
- Focused Batch 31 proof shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` hard blocks, and no visible process-language hits in the repaired rendered bodies.
- Full premium audit now reports `410` hard-review, `66` weak-review, `312` watch, and `1005` pass pages. Catalog-promoted split is `386` hard-review, `12` weak-review, `2` watch, and `370` pass pages. Source/render card parity improved to `369` mismatch rows across `225` pages (`80` unique source-card missing rows, `289` section layout diff rows, `0` hard-block rows).
- Read-only reviewer Lagrange (`019ead98-e047-7c71-be7a-4b4f31c2c113`) returned `PASS_WITH_RISKS`: no hard copy blockers for the 12 pages, anti-thinning satisfied, and the main remaining risk is native-speaker phrase fit for the audio-backed same-dish page (`Tôi sẽ có những gì họ đang có`) before treating it as production-natural. Minor native review is also worthwhile for the map and black-and-white print phrases.

Batch 32 result:

- `viet-phrase-social-9`: `PASS 0`
- `viet-phrase-v500-dire-navi-where-is-the-bus-stop`: `PASS 0`
- `viet-phrase-v500-food-drin-please-make-it-without-peanuts`: `PASS 0`
- `viet-phrase-v500-heal-phar-how-many-times-per-day`: `PASS 0`
- `viet-phrase-v500-loca-serv-ever-task-i-need-bottled-water`: `PASS 4`
- `viet-phrase-v500-loca-serv-ever-task-is-there-an-elevator`: `PASS 0`
- `viet-phrase-v500-prob-help-my-phone-is-missing`: `PASS 0`
- `viet-phrase-v500-soci-smal-talk-where-can-i-buy-a-raincoat`: `PASS 0`
- `viet-phrase-v500-tran-please-open-the-trunk`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-is-this-the-correct-immigration-line`: `PASS 0`
- `viet-phrase-v900-dire-navi-can-you-point-out-a-nearby-landmark`: `PASS 2`
- `viet-phrase-v900-food-drin-can-you-remove-this-from-the-bill`: `PASS 0`

Batch 32 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for recommendations, bus stops, peanut requests, medicine frequency, bottled water, elevator access, missing phones, raincoats, trunk access, immigration queues, landmarks, and bill corrections.
- Repaired misleading breakdown glosses, including bus stop, phone missing, nearby landmark, immigration line, bill removal, recommendation, and medicine frequency chunks.
- Full-CSV focused parity initially found two Batch 32 source/render card drifts even though JSON top rows were clean. The main thread aligned the peanut page `Explore next` source to the richer rendered allergy set and removed only a source-only duplicate helper-family card from the missing-phone page while keeping the visible direct need-help recovery path.
- Focused Batch 32 proof now shows `12 / 12` pages at `PASS`, `0` focused source/render card-parity rows, `0` visible process-language hits, and rendered phrase-card counts preserved at `9/9/9/11/11/9/9/9/8/9/9/9`.
- Full premium audit now reports `396` hard-review, `68` weak-review, `312` watch, and `1017` pass pages. Catalog-promoted split is `372` hard-review, `14` weak-review, `2` watch, and `382` pass pages. Source/render card parity improved to `364` mismatch rows across `222` pages (`78` unique source-card missing rows, `286` section layout diff rows, `0` hard-block rows).
- Read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) returned `PASS_WITH_RISKS`: no hard copy blockers for the 12 pages, anti-thinning passed, and the remaining risks are low-level phrase-fit/style items on the bottled-water and nearby-landmark audit scores plus formal-literal immigration-line / landmark wording.

Batch 33 result:

- `viet-phrase-v900-food-drin-this-is-undercooked`: `PASS 0`
- `viet-phrase-v900-heal-phar-can-you-call-an-ambulance`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-am-allergic-to-penicillin`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-need-mosquito-repellent`: `PASS 0`
- `viet-phrase-v900-heal-phar-please-write-the-address-of-the-clinic`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-can-you-dry-these-clothes`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-can-you-wash-these-clothes`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-can-i-pay-by-qr-code`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-the-sim-card-is-not-working`: `PASS 0`
- `viet-phrase-v900-shop-can-you-make-it-a-round-number`: `PASS 0`
- `viet-phrase-v900-shop-im-looking-for-a-gift`: `PASS 0`
- `viet-phrase-v900-sigh-acti-can-you-write-the-name-for-me`: `PASS 0`

Batch 33 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for undercooked food, ambulance calls, penicillin allergy, mosquito repellent, written clinic addresses, laundry wash/dry requests, QR payment, SIM troubleshooting, round-number bargaining, gift shopping, and written-name sightseeing help.
- Repaired misleading breakdown glosses, including `chưa được nấu chín kỹ`, ambulance, penicillin allergy, mosquito repellent, clinic address, laundry wash/dry, QR payment, round number, gift shopping, and written-name chunks.
- Removed one source-only undercooked `Explore next` target that the app did not render, while preserving the rendered correction card and five visible food-problem cards. This was ledgered as an accepted non-thinning parity repair.
- Read-only reviewer Archimedes (`019eadbf-d9b5-7f52-baff-d5eb7e0e07c6`) initially returned `REVISE_BEFORE_PRODUCTION` for two source/rendered body-card mismatches. The main thread fixed both: the penicillin page now renders the intended medicine availability, interaction, alcohol, sleepiness, and regular-medicine safety cards; the SIM page body now names the rendered data-top-up card.
- Focused Batch 33 proof after the review-gate fix shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, and rendered phrase-card counts preserved at `7/9/9/9/9/9/9/9/9/9/9/9`.
- Full premium audit now reports `384` hard-review, `68` weak-review, `312` watch, and `1029` pass pages. Catalog-promoted split is `360` hard-review, `14` weak-review, `2` watch, and `394` pass pages. Source/render card parity improved to `362` mismatch rows across `221` pages (`77` unique source-card missing rows, `285` section layout diff rows, `0` hard-block rows).
- Archimedes rechecked with final verdict `PASS`: no remaining hard blockers, anti-thinning ledger rows accurate, and the two medication cards with `audioKey: null` render as text bubbles while remaining covered by planned missing-audio rows.

Batch 34 result:

- `viet-phrase-help-5`: `PASS 0`
- `viet-phrase-sight-6`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-i-need-to-report-lost-luggage`: `PASS 0`
- `viet-phrase-v500-bath-pers-need-where-can-i-buy-toothpaste`: `PASS 0`
- `viet-phrase-v500-prob-help-can-you-help-me-look-for-it`: `PASS 0`
- `viet-phrase-v500-unde-repa-can-you-write-the-price`: `PASS 0`
- `viet-phrase-v500-unde-repa-i-understand-a-little`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-where-can-i-buy-a-bottle-of-water`: `PASS 0`
- `viet-phrase-v900-food-drin-does-this-contain-fish-sauce`: `PASS 0`
- `viet-phrase-v900-heal-phar-how-many-pills-each-time`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-have-trouble-breathing`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-need-allergy-medicine`: `PASS 0`

Batch 34 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for official reports, booking lookup, lost luggage, toothpaste errands, lost-item search help, written prices, partial understanding, bottled-water errands, fish-sauce checks, pill dosage, breathing trouble, and allergy medicine.
- Repaired misleading breakdown glosses and mechanical labels, including official-report, map-location, lost-luggage, toothpaste, written-price, partial-understanding, bottled-water, fish-sauce, pill-dosage, breathing, and allergy-medicine chunks.
- Read-only reviewer Descartes (`019eaddb-223c-7500-b523-77f4e632c760`) initially returned `PASS_WITH_RISKS` for fish-sauce section/card placement, source `map pin` drift, and one doctor-card alias. The main thread moved fish-sauce dietary variant cards into the rendered Natural Variants section, aligned the booking source text to `map location`, retargeted the allergy-medicine doctor card to the canonical health-doctor page, regenerated, and received final `PASS`.
- Focused Batch 34 proof after the review-gate fixes shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, and rendered phrase-card counts preserved at `8/9/9/9/8/9/9/9/10/9/9/9`.
- Full premium audit now reports `371` hard-review, `69` weak-review, `312` watch, and `1041` pass pages. Catalog-promoted split is `347` hard-review, `15` weak-review, `2` watch, and `406` pass pages. Source/render card parity improved to `358` mismatch rows across `219` pages (`75` unique source-card missing rows, `283` section layout diff rows, `0` hard-block rows).

## Anti-Thinning Notes

The edits changed source summaries, visible section bodies, selected phrase strings, and source/render card parity rows. They did not remove phrase cards or explore/related cards.

Batch 6 changed only source summaries and section bodies. It did not remove cards, related/explore targets, phrase rows, or breakdown rows. Each Batch 6 page still renders `9` phrase cards after regeneration.

Batch 7 changed source summaries, section bodies, several source breakdown glosses, one duplicate source help card, and two duplicate-visible English labels on money cards. It did not remove useful cards or reduce page depth. Each Batch 7 page renders `9` phrase cards after regeneration, including the hotel-contact page after the duplicate-card source repair.

Batch 8 changed source summaries, section bodies, several source breakdown glosses, one duplicate-visible money card label, and one semantically wrong queue phrase. It did not remove useful cards or reduce page depth. Each Batch 8 page renders `9` section phrase cards after regeneration.

Batch 9 changed source summaries, section bodies, and source breakdown glosses. It did not remove useful cards, related/explore targets, or phrase rows. Each Batch 9 page renders `9` phrase cards after regeneration. Breakdown row count reductions came only from semantic retokenization, such as keeping `sẵn sàng`, `trả lại`, `Bàn thông tin`, `thanh toán hóa đơn`, `cần quay lại`, `sang ngày mai`, and `mà không có tôi` together instead of preserving misleading word-piece rows.

Batch 10 changed source summaries, section bodies, phrase text for three semantic/audio-aware reviewer fixes, and source/breakdown-audit glosses. It did not remove useful cards, related/explore targets, or phrase rows. Each Batch 10 page renders `9` phrase cards after regeneration. Breakdown row count reductions came from semantic retokenization, such as keeping `gọi điện thoại`, `Chuyến tàu này`, `có bị trễ`, `phía sau`, `tòa nhà này`, `buồn ngủ`, `hoàn lại tiền`, `ở tầng cao hơn`, `ngồi cùng nhau`, and `để nộp cho bảo hiểm` together instead of preserving weaker word-piece rows.

Batch 11 changed source summaries, section bodies, and source/breakdown-audit glosses. It did not remove useful cards, related/explore targets, or phrase rows. Ten Batch 11 pages render `9` phrase cards after regeneration; the two pickup pages render `10` phrase cards after the review-gate source/rendered parity fix. Breakdown row count reductions came from semantic retokenization, not deletion.

Batch 12 changed source summaries, section bodies, six phrase strings, and source/breakdown-audit glosses. It did not remove useful rendered cards, related/explore targets, or phrase rows. Rendered Batch 12 phrase cards after review-gate regeneration: one page renders `11`, one renders `10`, and ten render `9`; the contact-information page regained a ninth rendered phrase card by replacing a duplicate with a text-me handoff. Breakdown row count reductions came from semantic retokenization, not deletion.

For the six semantic phrase repairs, breakdown rows were retokenized to match the corrected Vietnamese. That reduces the global rendered breakdown-card total, but it is not a thinning shortcut: each repaired page still keeps a real breakdown and a final full-phrase row.

For the Batch 8 queue semantic repair, audio was intentionally moved from ready to planned because the previous recording matches the wrong `Đường dây ở đâu?` phrase, not the corrected queue wording.

Batch 34 changed source summaries, section bodies, source/render card placement, one canonical related target, and source/breakdown-audit glosses. It did not remove useful rendered cards, related/explore targets, or phrase rows. Batch 34 adds `23` anti-thinning rows across visible-copy polish, card parity, and review-gate fixes, bringing the ledger to `610` rows total.

Representative rendered preservation:

- repaired pages still render at least `9` phrase cards each
- Batch 11 pickup parity pages render `10` phrase cards each after source/rendered card alignment
- repaired pages still render their breakdown rows after regeneration
- Batch 18 pages still render at least `9` phrase cards each; the mild-food page renders `11` phrase cards with source/rendered explore-card parity
- Batch 24 pages still render at least `9` phrase cards each; the outdoor-seating page renders `11` phrase cards after the review-gate card-parity source expansion
- the latest rendered bundle reports `11733` phrase cards and `6152` breakdown cards across all listing pages
- Batch 6 through Batch 33 brought the anti-thinning ledger to `587` rows. Batch 34 added `23` rows across visible-copy polish, card parity, and review-gate fixes, bringing the ledger to `610` rows total.

## Validation

Passed after regeneration:

```sh
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/apply-viet-premium-batch-26.js
node native-ios/scripts/apply-viet-premium-batch-27.js
node native-ios/scripts/apply-viet-premium-batch-28.js
node native-ios/scripts/apply-viet-premium-batch-29.js
node native-ios/scripts/apply-viet-premium-batch-30.js
node native-ios/scripts/apply-viet-premium-batch-30-card-parity.js
node native-ios/scripts/apply-viet-premium-batch-31.js
node native-ios/scripts/apply-viet-premium-batch-32.js
node native-ios/scripts/apply-viet-premium-batch-33.js
node native-ios/scripts/apply-viet-premium-batch-33-review-fixes.js
node native-ios/scripts/apply-viet-premium-batch-34.js
node native-ios/scripts/apply-viet-premium-batch-35.js
node native-ios/scripts/apply-viet-premium-batch-36.js
node native-ios/scripts/apply-viet-premium-batch-37.js
node native-ios/scripts/apply-viet-premium-batch-38.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/sync-viet-premium-batch-25-references.js
node native-ios/scripts/audit-viet-premium-listing-copy.js
node native-ios/scripts/audit-viet-source-render-card-parity.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-catalog-promoted-authoring.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
node native-ios/scripts/validate-viet-editorial-model-support.js
node native-ios/scripts/validate-viet-breakdown-audit.js --write-export
node native-ios/scripts/validate-viet-phrase-backdrops.js
node native-ios/scripts/validate-viet-search-only-surfacing.js
node native-ios/scripts/validate-vietnamese-menu-copy.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/audit-viet-city-listing-what-why.js
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node scripts/guard-native-only.js
git diff --check
```

`generate-viet-sqlite-fixture.js` hit one transient `sqlite3 EAGAIN` when run in parallel, then passed when retried alone.

Latest validator highlights:

- `validate-tier-one-listing-pages.js`: `150 / 150` strong, no banned rendered matches
- `validate-viet-catalog-promoted-authoring.js`: `ok: true`, `770` authored pages
- `validate-viet-sqlite-fixture.js`: `1793` canonical pages, `11724` relations, `772` planned missing-audio rows, `0` release-blocking missing-audio rows
- `audit-viet-listing-production-qa.js`: `1793` pages, `0` blockers, `0` majors, `775` duplicate hero sections hidden at render time, `500` missing-audio priority rows
- `audit-viet-premium-listing-copy.js`: `1793` pages, `323` hard-review, `68` weak-review, `313` watch, `1089` pass
- `audit-viet-source-render-card-parity.js`: `336` mismatch rows, `208` page mismatches, `64` unique source-card missing rows, `272` section layout diff rows, `0` hard-block rows

Batch 35 result:

- `viet-phrase-v900-mone-numb-pric-i-gave-you-the-wrong-bill`: `PASS 0`
- `viet-phrase-v900-prob-help-can-you-help-me-contact-my-airline`: `PASS 0`
- `viet-phrase-v900-tran-is-that-the-total-price`: `PASS 0`
- `viet-phrase-directions-9`: `PASS 0`
- `viet-phrase-help-4`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-my-driver-canceled`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-this-is-my-baggage-tag`: `PASS 0`
- `viet-phrase-v500-prob-help-i-lost-my-room-key`: `PASS 0`
- `viet-phrase-v500-unde-repa-let-me-show-you-instead`: `PASS 0`
- `viet-phrase-v500-unde-repa-please-show-me-where-to-tap`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-please-call-this-driver-for-me`: `PASS 0`
- `viet-phrase-v900-food-drin-do-we-order-here-or-at-the-counter`: `PASS 0`

Batch 35 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for wrong bills, airline contact help, total-price checks, station exits, double charges, canceled airport drivers, baggage tags, lost room keys, show-instead repair, tap-screen help, driver calls, and counter/table ordering.
- Repaired misleading breakdown glosses and mechanical labels, including wrong-bill handoff, airline contact, total price, exit choice, double charge, canceled driver, baggage tag, lost key, show-instead, tap-screen, driver-call, and counter-choice chunks.
- Fixed the review-flagged tap-page duplicate source target, refreshed the stale Batch 35 anti-thinning ledger rows, and replaced visible slug-like shorthand with natural section-body prose.
- Focused Batch 35 proof after the review-gate fixes shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` duplicate rendered targets, `0` visible shorthand hits, and rendered phrase-card counts preserved at `9/9/9/9/9/9/9/8/9/9/9/11`.
- Read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned final `PASS`: hard blockers: none; safe-fix items: none; accepted Batch 35 risks: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Read-only reviewer Pascal (`019eadf6-c082-7bd2-a589-ca74dca0163b`) returned `PASS_WITH_RISKS`: no hard blockers; the 8-card room-key page is accepted because source/render/ledger agree; a few section bodies still read as compressed phrase lists, but not as Batch 35 blockers.
- Full premium audit now reports `359` hard-review, `69` weak-review, `312` watch, and `1053` pass pages. Catalog-promoted split is `335` hard-review, `15` weak-review, `2` watch, and `418` pass pages. Source/render card parity improved to `350` mismatch rows across `215` pages (`71` unique source-card missing rows, `279` section layout diff rows, `0` hard-block rows).

Batch 36 result:

- `viet-phrase-v900-food-drin-i-asked-for-this-not-spicy`: `PASS 0`
- `viet-phrase-v900-food-drin-please-make-it-without-meat`: `PASS 0`
- `viet-phrase-v900-hote-acco-is-this-the-total-amount`: `PASS 0`
- `viet-phrase-v900-phon-inte-powe-the-app-will-not-accept-my-card`: `PASS 0`
- `viet-phrase-v900-sigh-acti-can-i-take-a-photo-here`: `PASS 0`
- `viet-phrase-v900-sigh-acti-i-cannot-find-the-tour-guide`: `PASS 0`
- `viet-phrase-v900-unde-repa-is-there-someone-who-speaks-english`: `PASS 0`
- `viet-phrase-directions-8`: `PASS 0`
- `viet-phrase-emergency-premium-wallet-stolen`: `PASS 0`
- `viet-phrase-hotel-premium-different-room`: `PASS 0`
- `viet-phrase-repair-premium-which-exit`: `PASS 0`
- `viet-phrase-transport-premium-luggage-trunk`: `PASS 0`

Batch 36 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for not-spicy corrections, meat-free ordering, hotel totals, app-card failures, photo permission, missing tour guides, English-speaker handoffs, pickup points, stolen wallets, wrong hotel rooms, exit choice, and luggage-in-trunk recovery.
- Retargeted weak or unrelated follow-up card clusters to richer rendered traveler paths, including spice/allergy follow-ups, hotel bill/refund checks, app-payment recovery, permission/ticket boundaries, tour meeting points, English/translation repair paths, pickup/driver cards, police/card-cancel recovery, room-change support, exit/stair/street directions, and driver/company recovery.
- Made the shared batch helper audio-manifest-aware, so generated phrase cards use speaker icons only when the bundled audio manifest text exactly matches the visible Vietnamese; otherwise they render as text-bubble cards instead of implying playable matching audio.
- Removed one internal/processy `fallback` wording from the English-speaker page, regenerated native resources and SQLite, and replayed Batch 36 after removing old Batch 36 ledger rows so the anti-thinning ledger stayed current.
- Focused Batch 36 proof shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` duplicate rendered targets, `0` suspicious visible process-language hits, `32` Batch 36 anti-thinning rows, and rendered phrase-card counts preserved at `11/11/9/9/9/9/9/10/9/9/9/9`.
- Read-only reviewer Erdos (`019eae1f-83e6-7312-a99c-cf631bbfacba`) returned `PASS_WITH_RISKS`: no hard blockers, no safe-fix items, anti-thinning passed, and the only accepted risk is that some support-card targets rely on native route canonicalization / SQLite authored `phrase_page` rows rather than simplified source IDs.
- Full premium audit now reports `347` hard-review, `69` weak-review, `312` watch, and `1065` pass pages. Catalog-promoted split is `323` hard-review, `15` weak-review, `2` watch, and `430` pass pages. Source/render card parity improved to `344` mismatch rows across `212` pages (`68` unique source-card missing rows, `276` section layout diff rows, `0` hard-block rows).

Batch 37 result:

- `viet-phrase-v500-dire-navi-can-i-walk-there`: `PASS 0`
- `viet-phrase-v500-emer-safe-i-need-first-aid`: `PASS 0`
- `viet-phrase-v500-food-drin-i-am-allergic-to-shellfish`: `PASS 0`
- `viet-phrase-v500-hote-acco-here-is-my-passport-for-check-in`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-i-only-have-large-bills`: `PASS 0`
- `viet-phrase-v500-mone-numb-pric-i-only-have-this-much`: `PASS 0`
- `viet-phrase-v500-prob-help-please-help-me-contact-my-embassy`: `PASS 0`
- `viet-phrase-v500-sigh-acti-can-i-join-today`: `PASS 0`
- `viet-phrase-v500-soci-smal-talk-please-do-not-take-my-photo`: `PASS 0`
- `viet-phrase-v900-airp-bord-arri-can-you-help-me-book-a-taxi`: `PASS 0`
- `viet-phrase-v900-emer-safe-i-am-safe-now`: `PASS 0`
- `viet-phrase-v900-food-drin-can-i-have-lime`: `PASS 0`

Batch 37 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for walkability checks, first aid, shellfish allergy, passport check-in, cash/change limits, embassy contact help, same-day activity availability, photo boundaries, airport taxi booking, safe-now updates, and lime requests.
- Retargeted weak follow-up clusters to rendered traveler paths, including allergy follow-ups, front-desk paperwork, cash/change cards, emergency report/copy cards, activity timing/entrance cards, photo-consent boundaries, airport pickup/taxi support, and table-side food requests.
- Repaired the reviewer-flagged walk-page templated rendered line, aligned shellfish source cards to the rendered allergy flow, repaired the lime source/render card mismatch by preserving the rendered one-portion card, and cleaned two minor `Use it when...` at-glance residues.
- Replayed Batch 37 after removing old Batch 37 ledger rows so the anti-thinning ledger reflects the final reviewer-follow-up fixes.
- Focused Batch 37 proof shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` duplicate rendered targets, `0` suspicious visible process-language hits, `25` Batch 37 anti-thinning rows, and rendered phrase-card counts preserved at `9/9/11/9/9/9/9/9/9/9/9/11`.
- Read-only reviewer Helmholtz (`019eae32-ce2c-7622-ad8d-373b91ca2441`) initially returned `PASS_WITH_RISKS` for the walk rendered line and shellfish source/render card drift; after the fixes above plus the lime and at-glance cleanup, Helmholtz rechecked the final proof with verdict `PASS`.
- Full premium audit now reports `335` hard-review, `69` weak-review, `312` watch, and `1077` pass pages. Catalog-promoted split is `311` hard-review, `15` weak-review, `2` watch, and `442` pass pages. Source/render card parity improved to `338` mismatch rows across `209` pages (`65` unique source-card missing rows, `273` section layout diff rows, `0` hard-block rows).

Batch 38 result:

- `viet-phrase-v900-food-drin-i-do-not-eat-pork`: `PASS 0`
- `viet-phrase-v900-hote-acco-can-you-write-down-the-cancellation-policy`: `PASS 0`
- `viet-phrase-v900-hote-acco-please-change-the-sheets`: `PASS 0`
- `viet-phrase-v900-hote-acco-the-water-pressure-is-too-low`: `PASS 0`
- `viet-phrase-v900-hote-acco-this-is-not-the-room-i-booked`: `PASS 0`
- `viet-phrase-v900-poli-basi-im-very-sorry`: `PASS 0`
- `viet-phrase-v900-shop-do-you-have-a-larger-size`: `PASS 0`
- `viet-phrase-v900-shop-i-bought-the-wrong-size`: `PASS 0`
- `viet-phrase-v900-shop-this-one-is-damaged`: `PASS 0`
- `viet-phrase-v900-time-date-book-id-like-to-book-for-two-people`: `PASS 0`
- `viet-phrase-v900-time-date-book-is-there-a-student-discount`: `PASS 0`
- `viet-phrase-v900-time-date-book-please-send-it-by-email`: `PASS 0`

Batch 38 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for pork-free ordering, cancellation-policy writing, sheet changes, low water pressure, wrong-room booking mismatch, apologies, larger-size checks, wrong-size returns, damaged items, two-person reservations, student discounts, and email document delivery.
- Retargeted weak follow-up clusters to richer rendered traveler paths, including food-safety follow-ups, cancellation/deposit/refund flows, room-service and room-repair cards, booking-mismatch desk replies, ticket-price/refund/scan paths, and invoice/receipt/report email requests.
- Repaired reviewer-flagged visible shorthand in `Explore next` bodies, including cancellation/refund, room-service, ticket, document-email, and wrong-room follow-up copy, then replayed Batch 38 after removing old Batch 38 ledger rows so the anti-thinning ledger reflects the final reviewer-follow-up fixes.
- Focused Batch 38 proof shows `12 / 12` pages at `PASS 0`, `0` focused source/render card-parity rows, `0` duplicate rendered targets, `0` suspicious visible shorthand/process-language hits, `19` Batch 38 anti-thinning rows, and rendered phrase-card counts preserved at `11/9/9/9/9/9/9/9/9/9/9/9`.
- Read-only reviewer Raman (`019eae44-1b5f-7332-95d9-2261c5b6a721`) initially returned `PASS_WITH_RISKS`, then `REVISE_BEFORE_PRODUCTION` for one remaining wrong-room shorthand body. After the final visible-copy polish, Raman rechecked with verdict `PASS`; hard blockers: none; safe-fix items: none; anti-thinning: `PASS`.
- Full premium audit now reports `323` hard-review, `68` weak-review, `313` watch, and `1089` pass pages. Catalog-promoted split is `299` hard-review, `14` weak-review, `3` watch, and `454` pass pages. Source/render card parity improved to `336` mismatch rows across `208` pages (`64` unique source-card missing rows, `272` section layout diff rows, `0` hard-block rows).

Batch 39 result:

- `viet-phrase-v900-tran-i-booked-through-the-app`: `PASS 0`
- `viet-family-food-bottled-water`: `PASS 0`
- `viet-phrase-food-premium-no-meat`: `PASS 0`
- `viet-phrase-phone-6`: `PASS 0`
- `viet-phrase-phone-premium-login-page-not-loading`: `PASS 0`
- `viet-phrase-v500-airp-bord-arri-can-i-get-a-written-report`: `PASS 0`
- `viet-phrase-v500-dire-navi-do-i-go-over-the-bridge`: `PASS 0`
- `viet-phrase-v500-food-drin-there-is-something-in-my-food`: `PASS 0`
- `viet-phrase-v500-loca-serv-ever-task-how-long-will-it-take`: `PASS 0`
- `viet-phrase-v500-phon-inte-powe-i-need-a-charging-cable`: `PASS 0`
- `viet-phrase-v500-poli-basi-i-need-this`: `PASS 0`
- `viet-phrase-v900-dire-navi-please-write-the-address-for-me`: `PASS 0`

Batch 39 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for app-booking handoffs, sealed bottled water, no-meat limits, data top-ups, Wi-Fi login-page failures, written airport reports, bridge crossings, visible object-in-food problems, service timing, charging cables, pointing requests, and written-address handoffs.
- Repaired breakdown trust issues including Wi-Fi login page, mobile data top-up, no-meat phrasing, written reports, bridge crossings, service timing, and object-in-food chunks.
- Aligned two source/render card risks without thinning rendered proof: no-meat grew the first-class source to the rendered five-card food-safety flow, and object-in-food aligned source to the single rendered change-this card.
- Focused Batch 39 proof shows `12 / 12` pages at `PASS 0`, `0` focused source/render parity rows, `0` duplicate rendered targets, `0` visible internal/process-language hits, `14` Batch 39 anti-thinning rows, and rendered phrase-card counts preserved at `9/14/11/9/9/9/9/7/9/9/9/9`.
- Read-only reviewer Darwin (`019eae6e-7798-70e1-bc02-9c8cfa15b916`) returned final Batch 39 verdict `PASS`; hard blockers: none; safe-fix items: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.
- Full premium audit after Batch 39 reported `309` hard-review, `70` weak-review, `312` watch, and `1102` pass pages. Source/render card parity improved to `332` mismatch rows across `206` pages (`62` unique source-card missing rows, `270` section layout diff rows, `0` hard-block rows).

Batch 40 result:

- `viet-phrase-v900-dire-navi-which-entrance-should-i-use`: `PASS 0`
- `viet-phrase-v900-heal-phar-i-need-pain-medicine`: `PASS 0`
- `viet-phrase-v900-heal-phar-when-should-i-seek-emergency-help`: `PASS 0`
- `viet-phrase-v900-loca-serv-ever-task-where-can-i-buy-sunscreen`: `PASS 0`
- `viet-phrase-v900-mone-numb-pric-please-do-not-tap-again`: `PASS 2` (`use_it_when`, accepted soft flag)
- `viet-phrase-v900-sigh-acti-is-this-area-safe-at-night`: `PASS 0`
- `viet-phrase-v900-sigh-acti-is-this-the-right-entrance`: `PASS 0`
- `viet-phrase-v500-prob-help-can-you-call-security`: `PASS 2` (`use_it_when`, accepted soft flag)
- `viet-phrase-v500-prob-help-please-write-down-your-name`: `PASS 0`
- `viet-phrase-v500-tran-please-call-the-driver`: `PASS 0`
- `viet-phrase-v500-unde-repa-is-that-good-or-bad`: `PASS 0`
- `viet-phrase-v500-unde-repa-is-that-the-final-total`: `PASS 0`

Batch 40 source/rendered trust repairs:

- Rewrote title-as-summary pages into concrete traveler moments for multi-door entrance choice, pain-medicine pharmacy requests, emergency-help escalation, sunscreen errands, duplicate payment taps, nighttime safety, right-side entrance checks, security calls, written-name reports, driver calls, good/bad clarification, and final-total payment checks.
- Repaired breakdown trust issues including `vào ban đêm` as at-night, `tổng số cuối cùng` as final total, `lối vào bên phải` as right-side entrance, `gõ nữa` as tap/type again, and emergency-help chunks that had previously read like generic date/ticket confirmation.
- Aligned two help-page natural-variant source sections to the rendered lost/left-behind cards without thinning visible rendered cards; the source-only need-help card was already omitted by the app.
- Focused Batch 40 proof shows `12 / 12` pages at `PASS`, `0` focused source/render parity rows, `0` duplicate rendered targets, `14` Batch 40 anti-thinning rows, and rendered phrase-card counts preserved at `9/9/9/9/9/9/9/8/8/9/9/9`.
- Full premium audit after Batch 40 reports `297` hard-review, `70` weak-review, `312` watch, and `1114` pass pages. Catalog-promoted split is `275` hard-review, `15` weak-review, `3` watch, and `477` pass pages. Source/render card parity improved to `328` mismatch rows across `204` pages (`60` unique source-card missing rows, `268` section layout diff rows, `0` hard-block rows).
- Validation passed after regeneration: `generate-authored-tier-one-pages.js`, `generate-viet-catalog.js`, `generate-viet-sqlite-fixture.js`, `audit-viet-premium-listing-copy.js`, `audit-viet-source-render-card-parity.js`, `validate-viet-sqlite-fixture.js`, `validate-tier-one-listing-pages.js`, `validate-viet-catalog-promoted-authoring.js`, `audit-viet-listing-production-qa.js`, `validate-viet-breakdown-audit.js --write-export`, `node scripts/guard-native-only.js`, and `git diff --check`.
- Whole corpus remains `REVISE_BEFORE_PRODUCTION` until the remaining `297` hard-review pages and `70` weak-review pages are authored and rechecked.
