# Phrase Copy Production Gate - 2026-06-09

Branch: `codex/phrase-copy-production-gate`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/phrase-copy-production-gate`
Base: `0a503335c` (`Implement compact more admin chrome`)

## 2026-06-10 Zero-Watch Superseding Final Addendum

Current receipt: `final-copy-audit-zero-watch-addendum-2026-06-10.md`

Visible copy recommendation: `PASS`

Merge/release recommendation: `PASS_WITH_RISKS`

This supersedes the earlier in-file verdict below. After Batch 48, Batch 49, regeneration, and focused subagent recheck, the premium visible-copy audit is:

- total rendered listing pages: `1793`
- `HARD_REVIEW`: `0`
- `WEAK_REVIEW`: `0`
- `WATCH`: `0`
- `PASS`: `1793`

Tier-one listing validation is now `150 / 150` strong, city app-detail V2.2 validation remains `520 / 520` pass, production QA remains `0` blockers / `0` majors, and the final focused read-only subagent review returned `PASS`. This is a visible-copy `PASS`: the pages no longer have hard, weak, or watch rows. It is still a merge/release `PASS_WITH_RISKS` because source/render card parity recommends `REVISE_BEFORE_PRODUCTION` with `0` hard-block rows, missing-audio and hidden-duplicate-hero follow-ups remain, and physical iPhone proof was not run from this feature branch.

## Historical Verdict Before Final Addendum

Premium copy audit recommendation: `REVISE_BEFORE_PRODUCTION`

Validator / schema recommendation: `PASS_WITH_COPY_RISKS`

The existing production QA and schema validators still pass, but a colder visible-copy audit now shows the phrase/listing copy is not yet premium enough to merge as final. The main issue is not thinness or deleted cards; it is repeated projection prose that still feels templated across many phrase pages.

Fresh premium audit after the June 9/10 follow-up repair batches:

- total rendered listing pages: `1793`
- `HARD_REVIEW`: `297`
- `WEAK_REVIEW`: `70`
- `WATCH`: `312`
- `PASS`: `1114`

The strongest surfaces are the city pages, menu copy, editorial support pages, and hand-authored flagship/tier-one examples. The weakest surface is catalog-promoted phrase pages: `275 / 770` are still hard-review because summaries often repeat the English title and section bodies reuse phrases such as `lead with the question`, `next detail`, `first phrase leads`, or repeated connector copy.

Batch 29 moved another `12 / 12` repaired catalog-promoted pages to `PASS`, including sanitizer, hotel-return directions, shop bag/availability, wrong-time booking, fever medicine, English-speaking medical help, SIM/eSIM gigabytes, passport requirements, translation checking, water-bottle refills, and driver turn-around pages. The focused Batch 29 proof has `0` source/render parity rows for the twelve page IDs, `0` targeted process-language hits, and `9` phrase cards preserved on every page. The two validator follow-ups were non-thinning: the gigabytes breakdown token now reconstructs the full punctuated phrase, and the bag page keeps the bag-fee/material caveat as `lightweight plastic`.

Batch 30 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including fish-sauce allergy, ramp access, SIM/eSIM activation, too-big sizing, copy-shop documents, phone repair timing, card refunds, wrong food orders, no signal, missing OTP codes, spoiled food, and written-password setup. A follow-up aligned three food `Explore next` source card lists to the richer rendered app surface, improving source/render card parity without thinning rendered cards.

Batch 31 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including agreement, map requests, written addresses, translation checks, bill mistakes, same-dish ordering, quieter seating, black-and-white printing, black item color checks, tomorrow bookings, ticket-date checks, and embassy help. It also replaced unrelated follow-up card clusters with relevant existing cards and repaired breakdown gloss drift without thinning rendered card depth.

Batch 32 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS`, including recommendation, bus-stop, peanut-request, medicine-frequency, bottled-water, elevator, missing-phone, raincoat, trunk, immigration-line, landmark, and bill-removal pages. The follow-up full-CSV parity check fixed two source/render card drifts without thinning: peanut `Explore next` now mirrors the richer rendered allergy follow-up set, and the missing-phone page removed only a source-only duplicate helper-family card that the app did not render while keeping direct need-help recovery cards.

Batch 33 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including undercooked food, ambulance calls, penicillin allergy, mosquito repellent, clinic-address writing, laundry wash/dry requests, QR payment, SIM troubleshooting, round-number bargaining, gift shopping, and written-name sightseeing help. Archimedes (`019eadbf-d9b5-7f52-baff-d5eb7e0e07c6`) initially returned `REVISE_BEFORE_PRODUCTION` for two source/rendered body-card mismatches; the review-gate fix matched the penicillin page to five medication-safety cards and corrected the SIM page body to name the rendered data-top-up card. Archimedes rechecked with final `PASS`.

Batch 34 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including official-report filing, advance booking, lost-luggage reports, toothpaste errands, lost-item search help, written prices, partial understanding, bottled-water errands, fish-sauce checks, pill dosage, breathing trouble, and allergy-medicine pages. Descartes (`019eaddb-223c-7500-b523-77f4e632c760`) initially returned `PASS_WITH_RISKS`; the main thread moved fish-sauce dietary variant cards into the rendered Natural Variants section, aligned the booking source text to `map location`, retargeted the allergy-medicine doctor card to the canonical health-doctor page, regenerated, and Descartes rechecked with final `PASS`.

Batch 35 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including wrong-bill handoff, airline contact help, total-price confirmation, exit directions, double-charge recovery, canceled airport driver, baggage-tag handoff, lost room key, show-instead repair, tap-screen help, driver-call help, and counter-versus-table ordering pages. The main thread also cleaned the reviewer-flagged tap-page duplicate source target, refreshed stale Batch 35 ledger rows, removed visible slug-like shorthand, regenerated native resources and SQLite, and verified `0` focused source/render parity rows.

Batch 36 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including not-spicy correction, no-meat ordering, hotel total checks, app-card failure, photo permission, missing tour guide, English-speaker handoff, pickup points, stolen wallets, wrong hotel rooms, exit directions, and trunk luggage pages. The main thread also made the card helper audio-manifest-aware so cards only show speaker icons when the bundled audio text exactly matches the visible Vietnamese, fixed one banned/internal `fallback` wording, regenerated resources and SQLite, and verified `0` focused source/render parity rows.

Batch 37 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including walkability checks, first aid, shellfish allergy, passport check-in, large-bill/change handoffs, showing a cash limit, embassy contact help, same-day activity availability, photo boundaries, airport taxi booking, safe-now reassurance, and lime table requests. The main thread repaired the reviewer-flagged walk-page templated rendered line, aligned the shellfish source cards to the rendered allergy flow, repaired the lime source/render card mismatch by preserving the rendered one-portion card, cleaned two minor `Use it when...` at-glance residues, then regenerated resources and SQLite and verified `0` focused source/render parity rows. Helmholtz (`019eae32-ce2c-7622-ad8d-373b91ca2441`) rechecked the final source/render proof and returned Batch 37 verdict `PASS`.

Batch 38 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`, including pork-free ordering, written cancellation policies, sheet changes, low water pressure, wrong-room booking mismatch, apologies, larger sizes, wrong-size returns, damaged items, two-person reservations, student discounts, and email document delivery. Raman (`019eae44-1b5f-7332-95d9-2261c5b6a721`) initially returned `PASS_WITH_RISKS`, then `REVISE_BEFORE_PRODUCTION` for visible shorthand in `Explore next` bodies; the main thread rewrote those lines into natural traveler copy, replayed the batch, regenerated resources and SQLite, and Raman rechecked with final `PASS`.

Batch 39 moved another `12 / 12` top hard-review/trust-risk pages to `PASS`, including ride-app booking, bottled water, no-meat ordering, mobile-data top-up, Wi-Fi login pages, written airport reports, bridge crossing, object-in-food problems, service timing, charging cables, pointing requests, and written-address handoffs. Darwin (`019eae6e-7798-70e1-bc02-9c8cfa15b916`) reviewed source and rendered proof with final Batch 39 verdict `PASS`; focused proof showed `0` source/render parity rows, `0` duplicate rendered targets, and `14` Batch 39 anti-thinning rows.

Batch 40 moved another `12 / 12` top hard-review catalog-promoted pages to `PASS`, including entrance choice, pain medicine, emergency-help escalation, sunscreen errands, duplicate payment taps, nighttime safety, right-side entrance checks, security calls, written-name reports, driver calls, good/bad clarification, and final-total payment checks. The main thread also aligned two help-page source-only natural-variant cards to the rendered lost/left-behind cards without reducing visible rendered cards. Focused proof shows `12 / 12` Batch 40 pages at `PASS`, `0` focused source/render parity rows, `0` duplicate rendered targets, `14` Batch 40 anti-thinning rows, and rendered phrase-card counts preserved at `9/9/9/9/9/9/9/8/8/9/9/9`.

The targeted repair batches prove the right fix path. They preserved phrase cards, moved source copy away from projection formulas, regenerated the native resource, and brought the latest `454 / 454` repaired hard-review/trust-blocker pages out of `HARD_REVIEW`. Batch 8 moved `10 / 10` pages to `PASS`, including a semantic repair for the queue phrase `Where is the line?` from the incorrect `Đường dây ở đâu?` to `Xếp hàng ở đâu?`. Batch 9 moved another `12 / 12` repaired pages to `PASS 0`, including the remaining rendered `sẵn sàng` trust blockers. Batch 10 moved another `12 / 12` top hard-review pages to `PASS 0`, including phone-call, pickup-driver, train-delay, airport-terminal, health/pharmacy, hotel-floor, refund, and seat-together pages. A Batch 10 reviewer follow-up then made three audio-aware semantic repairs (`higher floor`, `seats together`, and `receipt to submit to insurance`) and moved those changed self-phrases to planned audio. Batch 11 moved another `12 / 12` top hard-review pages out of `HARD_REVIEW` (`11` to `PASS`, `1` to `WATCH`), then a review-gate follow-up aligned two pickup pages' first-class source cards with the richer rendered pickup/driver card set. Batch 12 moved another `12 / 12` hard-review pages to `PASS`, including six semantic/audio-aware phrase repairs moved to planned audio instead of reusing stale recordings; a review-gate follow-up then fixed six stale hero pronunciations, aligned two source card lists with rendered proof, and replaced one duplicate source card with a text-me follow-up instead of thinning the page. Batch 13 moved another `12 / 12` top hard-review pages to `PASS 0`; a review-gate follow-up aligned source/rendered wording, restored one police-station card by replacing a duplicate, and matched full-breakdown question punctuation. Batch 14 moved another `12 / 12` top hard-review pages to `PASS 0`, including direction, hotel printing, refund, shopping, window-seat, toll, and address-confirmation pages. Batch 15 moved another `12 / 12` pages out of hard-review. Batch 16 moved another `12 / 12` pages to `PASS`, then fixed source self-card/full-breakdown validation drift for semantic/audio-planned repairs. Batch 17 moved the next `12 / 12` top hard-review pages to `PASS 0`, including validity-period, phone repair, driver contact, deposit, safety, address-typing, map, airport information-desk, bill-by-card, fan-seat, medicine, and room-refund pages. Batch 18 moved another `12 / 12` top hard-review pages to `PASS 0`, including sewing, card-payment cancellation, cheaper-option, exchange-money, mild-food, luggage-pickup, laundry, bag-repair, next-corner, eSIM, data, and a semantic/audio-safe permission repair. Batch 19 moved another `12 / 12` top hard-review pages to `PASS 0`, including spelling names, security-camera help, returns, exits, written times, number confirmation, chili sauce, no-meat ordering, beer, drug interactions, printing, and careful wrapping; the reviewer addendum also aligned four source/rendered card-parity risks without thinning rendered cards. Batch 20 moved another `12 / 12` top hard-review pages to `PASS`, fixed emergency/template leakage, and aligned related ingredient-removal card audio state. Batch 21 moved another `12 / 12` top hard-review pages to `PASS 0`, restored a validation-safe bundled-audio compromise for `Can we sit inside?`, and mirrored its richer five-card restaurant follow-up set into source without thinning. Batch 22 moved another `12 / 12` top hard-review pages to `PASS 0`, including hand-washing, purchase-pausing, rain, driver safety, map/form marking, misunderstandings, driver card payment, cafe landmarks, half portions, cough, and fare-dispute pages; its card-parity addendum grew the half-portion `Explore next` source section from `2` to `5` cards to match rendered proof. Batch 23 moved another `12 / 12` top hard-review pages to `PASS 0`, including highway avoidance, next-street turns, split bills, service-charge checks, tourism arrival, gate finding, shampoo, market landmarks, peanut-order repair, food poisoning, receipts, and Wi-Fi permission; its card-parity addendum grew two food/payment `Explore next` source sections from `2` to `5` cards each to match rendered proof. Batch 24 moved another `12 / 12` top hard-review pages to `PASS`, including street-crossing safety, outdoor seating, sore throat, arm injury, extra-night stays, emailed invoices, US-dollar acceptance, nearby ATMs, queue-line confirmation, show-me repair, ambulance calls, and leave-me-alone safety. The Batch 24 review-gate fix grew the outdoor-seating `Explore next` source from `2` to `5` cards, repaired ATM rendered-summary fallback, replaced three source-only fallback bodies, and kept the queue-line semantic repair on planned audio. Batch 25 moved another `12 / 12` top hard-review pages to `PASS`, repaired eight phrase/title or pronunciation issues without reusing mismatched audio, synced stale related-card references, and replaced three HCMC city Useful Phrase cards with bundled-audio alternatives so city validation and SQLite still pass. Batch 26 moved another `12 / 12` top hard-review pages to `PASS 0`, including ticket refunds, confirmation messages, shower access, stolen bag/phone/card problems, declined cards, charger borrowing, cooler-place small talk, long restaurant waits, rehydration salts, and luggage hold before check-in. Batch 27 moved another `12 / 12` top hard-review pages to `PASS 0`, including service-counter email requests, lunch-included checks, help-call and come-with-me handoffs, key-card and hot-water hotel issues, moving bookings later, hotel-landmark and traffic-light direction checks, chest-pain safety wording, cash change, and correct-street confirmation. Batch 28 moved another `12 / 12` top hard-review pages to `PASS 0`, including rear-entrance directions, table-cleaning, quiet-room-away-from-street, luggage help, housekeeping skip, wake-up call, smoke-smell reporting, mosquito-repellent purchase, rental-insurance checks, show-me-start-it, too-spicy restaurant repair, and no-printed-copy counter handoff.

## What Improved

- Preserved rich phrase listings instead of thinning them into `Vietnamese means English` shells.
- Kept phrase cards, related/explore cards, and breakdown strips; validation was fixed by improving copy/source, not by deleting useful cards.
- Repaired stale food support-card leakage so food pages no longer drift into unrelated coffee cards.
- Cleaned first-class source and rendered output for process/scaffolding language such as `atomic`, `this row`, `move here`, `these cards stay`, `keep these close`, `next exchange close`, `reply points toward`, and `likely follow-up`.
- Repaired the `Mang di` takeaway breakdown as a keep-together phrase rather than splitting it into misleading word pieces.
- Rebuilt native resources and SQLite from source after edits.

## Current Counts

- Generated phrase catalog: `1782` families, `1800` phrases
- Generated authored listing pages: `1793`
- Generated listing scope: `145` main tier-one pages, `13` child pages, `770` catalog-promoted pages, `826` city library pages, `39` editorial model support pages
- SQLite projection: `19` scenarios, `1782` clusters, `1800` phrases, `1793` canonical pages, `11724` relations
- Static production QA: `1793` pages, `0` blockers, `0` majors
- Planned missing-audio rows: `772`; release-blocking missing-audio rows: `0`
- Duplicate hero sections hidden at render time: `775`
- Missing-audio priority rows: `500`

## Final Copy Scans

Final source/rendered blocker scan over `content-draft/viet/phrase-source.csv`, first-class canonical page source, editorial support source, city app-detail source, `viet-authored-listing-pages.json`, and `viet-phrase-catalog.json`:

- `0` hits for `atomic`
- `0` hits for `this row`
- `0` hits for `move here`
- `0` hits for `these cards stay`
- `0` hits for `keep these close`
- `0` hits for `next exchange close`
- `0` hits for `reply points toward`
- `0` hits for `likely follow-up`
- `0` hits for `after the first answer`

Rendered visible-copy scan:

- pages: `1793`
- phrase cards: `11736`
- breakdown cards: `6022`
- blocker hits: `0`
- empty learning sections: `0`
- duplicate card-target pages: `0`
- zero-phrase pages: `0`
- zero-learning pages: `0`
- long bodies over 55 words: `0`
- visible word count: min `54`, p10 `114`, median `245`, p90 `319`, max `511`

## Anti-Thinning Evidence

Comparison against base `0a503335c`:

- base pages: `1778`
- current pages: `1793`
- shared phrase-ID pages checked: `1778`
- shared phrase-card drops: `0`
- shared pages with phrase-card gains: `945`
- shared pages with same phrase-card count: `833`
- shared phrase-ID page phrase cards: `8101` -> `11610`
- shared phrase-ID page breakdown cards: `6900` -> `5972`

The breakdown-card reduction is from semantic retokenization, not thinning: repaired pages keep the full phrase and merge misleading word-piece chunks such as queue/ready compounds. Additional rendered total across all pages is `11736` phrase cards and `6022` breakdown cards.

Final source cleanup receipt:

- `native-ios/scripts/apply-viet-phrase-copy-cleanup-to-source.js`
- `docs/content-audits/phrase-copy-production-gate-2026-06-08/anti-thinning-ledger.jsonl`: `740` JSONL rows total, including Batch 39's `14` rows and Batch 40's `14` visible-copy/card-parity rows across `12` pages. The ledger parses as JSONL after the addenda.
- `docs/content-audits/phrase-copy-production-gate-2026-06-08/phrase-source-cleanup-summary.json`: `933` source pages checked, `38` summaries updated, `80` sections updated, `106` files changed

## Validation Commands

Passed after the final source cleanup and regeneration:

```sh
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/apply-viet-premium-batch-27.js
node native-ios/scripts/apply-viet-premium-batch-28.js
node native-ios/scripts/apply-viet-premium-batch-31.js
node native-ios/scripts/apply-viet-premium-batch-32.js
node native-ios/scripts/apply-viet-premium-batch-33.js
node native-ios/scripts/apply-viet-premium-batch-33-review-fixes.js
node native-ios/scripts/apply-viet-premium-batch-34.js
node native-ios/scripts/apply-viet-premium-batch-35.js
node native-ios/scripts/apply-viet-premium-batch-36.js
node native-ios/scripts/apply-viet-premium-batch-37.js
node native-ios/scripts/apply-viet-premium-batch-38.js
node native-ios/scripts/apply-viet-premium-batch-39.js
node native-ios/scripts/apply-viet-premium-batch-40.js
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/sync-viet-premium-batch-25-references.js
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
node native-ios/scripts/audit-viet-city-listing-what-why.js
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node scripts/guard-native-only.js
git diff --check
```

Key outputs:

- `validate-tier-one-listing-pages.js`: `150 / 150` strong, `0` thin, `0` over-templated, `0` needs work
- `validate-viet-catalog-promoted-authoring.js`: `ok: true`, `770` authored pages
- `validate-viet-sqlite-fixture.js`: `ok: true`, `1793` canonical pages, `11724` relations, `772` planned missing-audio rows, `0` release-blocking missing-audio rows
- `audit-viet-listing-production-qa.js`: `1793` pages, `0` blockers, `0` majors
- `audit-viet-premium-listing-copy.js`: `1793` pages, `297` hard-review, `70` weak-review, `312` watch, `1114` pass
- `audit-viet-source-render-card-parity.js`: `328` mismatch rows, `204` page mismatches, `60` unique source-card missing rows, `268` section layout diff rows, `0` hard-block rows
- `validate-viet-city-app-detail-v2-2.js --strict-production`: `520` pass, `0` revise, `0` fail
- `audit-viet-city-listing-what-why.js`: `520` entries, `0` findings, `0` hard-review pages
- `validate-vietnamese-menu-copy.js`: `355` handwritten Vietnamese menu item pages, `15` ready helper phrases
- `git diff --check`: passed

## Review Gate

Read-only subagent `019ea901-ce25-7353-ba6e-463c8f427e68` final verdict: `PASS`.

The earlier source-scaffolding subagent initially returned `REVISE_BEFORE_PRODUCTION` because first-class source still contained `78` scaffolding hits even though rendered output was clean. Those source hits were repaired, the exact source/rendered scan returned no hits, and the reviewer rechecked with no hard blockers.

Batch 6 read-only subagent `Hooke` (`019ea983-f4df-7182-8648-049199ff4c3a`) returned `PASS_WITH_RISKS` for repeated `Use it...` openers; the main thread fixed the risk and re-audited all ten pages at `PASS 0`.

Batch 7 read-only subagent `Avicenna` (`019ea993-1f23-76e3-81fb-5003ffe775b7`) initially returned `REVISE_BEFORE_PRODUCTION` for source breakdown/card-label risks, then `PASS_WITH_RISKS` for one source-only breakdown gloss, then final `PASS` after the source was corrected and regenerated.

Batch 8 read-only subagent `Rawls` (`019ea9b4-d9fa-75c3-9b3d-01d51a03ec48`) initially returned `REVISE_BEFORE_PRODUCTION` for a rendered `sẵn sàng` breakdown error and an unresolved generated audio key on the repaired queue phrase. The main thread fixed the breakdown-audit source, adjusted the generator to preserve explicit planned/no-audio self cards, regenerated, reran validators, and received final `PASS_WITH_RISKS`.

Batch 9 repaired ten more premium hard-review catalog-promoted pages plus two rendered breakdown trust blockers. The focused rendered probe confirmed `12 / 12` pages now score `PASS 0`, each still renders `9` phrase cards, duplicate card targets remain `0`, and the `sẵn sàng` pages now keep the ready phrase together instead of rendering `sàng = morning`. Read-only subagent `Meitner` initially returned `PASS_WITH_RISKS` for three source-only canonical breakdown rough edges; those source rows were aligned with the rendered rows, regenerated, and rechecked with final verdict `PASS`.

Batch 10 repaired twelve more top hard-review catalog-promoted pages. The focused rendered probe confirmed `12 / 12` pages now score `PASS 0`, each still renders `9` phrase cards, duplicate card targets remain `0`, and scaffold/process-language hits remain `0`. The batch also aligned first-class source and breakdown-audit rows for risky chunks such as `gọi điện thoại`, `Chuyến tàu này`, `có bị trễ`, `phía sau`, `tòa nhà này`, `nhận được`, `biên nhận`, `bảo hiểm`, `buồn ngủ`, `hoàn lại tiền`, and `ngồi chung`. After reviewer feedback, the three audio-backed semantic risks were corrected to `Cho tôi phòng ở tầng cao hơn được không?`, `Chúng tôi có thể ngồi cùng nhau được không?`, and `Tôi có thể lấy biên nhận để nộp cho bảo hiểm không?`; their self-phrase audio keys are now `null` until matching recordings exist.

Batch 11 repaired twelve more top hard-review catalog-promoted pages. The focused rendered probe confirmed `11 / 12` pages now score `PASS`, `1 / 12` scores `WATCH` for a soft `bare_summary` flag, and `0 / 12` remain hard-review. Each Batch 11 page preserves phrase cards; the two pickup pages now render `10` phrase cards, the other ten render `9`, duplicate card targets remain `0`, and source/rendered `explore-next` cards now match for the pickup pages after review-gate cleanup.

Batch 11 read-only subagent `Hegel` (`019eaa1d-349a-7d12-b91d-c024928715e5`) initially returned `PASS_WITH_RISKS`: prose quality passed, but two pickup pages had source/rendered `explore-next` card mismatch. The main thread aligned first-class source with the richer rendered pickup/driver card set, regenerated native resources and SQLite, reran validators, and Hegel rechecked with final `PASS`. The only remaining note is benign generated punctuation on full-breakdown English question rows.

Batch 12 read-only subagent `Bacon` (`019eaa35-7e03-7f70-b3df-49fa82b1f776`) initially returned `REVISE_BEFORE_PRODUCTION` for stale top-level hero pronunciations on six semantically repaired pages, source/rendered card mismatches on pickup point, cup of ice, and contact-information sections, and two awkward breakdown-body explanations. The main thread fixed the source pronunciation fields, regenerated rendered resources, aligned card lists without thinning, replaced the duplicate contact card with `Can you text it to me?`, and rewrote the two breakdown bodies. Bacon rechecked source and rendered proof with final verdict `PASS`; remaining issue page IDs: none.

Batch 13 read-only subagent `Ohm` (`019eaa53-8488-7ce2-9add-20967905d1a3`) initially returned `PASS_WITH_RISKS`: rendered copy and audio references passed, but source/render exactness had three cleanup risks. The main thread changed `map pin` to `map location`, replaced a duplicate police-station source card with `Can I leave my contact information?`, preserved the full English question mark in Batch 13 breakdown rows, regenerated, and reran focused probes plus validators. Ohm rechecked with final verdict `PASS`; remaining issue page IDs: none.

Batch 14 read-only subagent `Godel` (`019eaa6b-08a1-79d1-992e-a992a7c3a5fa`) reviewed the batch after main-thread validation. The final recommendation for the broader phrase-copy branch remains `REVISE_BEFORE_PRODUCTION` until the remaining hard-review corpus is authored and rechecked.

Batch 27 read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `REVISE_BEFORE_PRODUCTION` for one visible process-language blocker on `viet-phrase-v900-dire-navi-is-this-the-correct-street`: the page exposed an internal review note to users. The main thread replaced that with traveler-facing street-sign/map guidance, regenerated, verified the old process wording had `0` source/rendered hits, and reran focused proof. Carson rechecked source and rendered proof with final Batch 27 verdict `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 28 read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) initially returned `PASS_WITH_RISKS`: all `12 / 12` pages were `PASS 0`, focused source/render card-parity rows were `0`, and anti-thinning passed, but two visible bodies referred to cards while the cards lived in adjacent sections. The main thread rewrote those two bodies as traveler-facing follow-up guidance, regenerated native resources and SQLite, verified the old strings had `0` active source/rendered/script hits, and recorded `2` reviewer-polish anti-thinning rows. Carson rechecked the two fixed pages and returned final Batch 28 verdict `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 29 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS`. Focused proof after the review-gate fix shows `0` source/render body mismatch pages, `0` source/render card-parity rows for the twelve page IDs, `0` targeted process-language hits, and `9` phrase cards preserved on every Batch 29 page. Carson's read-only Batch 29 recheck returned `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 30 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`. Focused proof after the card-parity follow-up shows `0` source/render card-parity rows for the twelve page IDs, `0` targeted process-language hits, rendered card counts preserved at `11/9/9/9/9/9/9/11/9/9/7/9`, and `15` Batch 30 anti-thinning rows recorded. Carson's read-only Batch 30 final verdict returned `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus: `REVISE_BEFORE_PRODUCTION`.

Batch 31 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`. Focused proof shows `0` source/render card-parity rows for the twelve page IDs, `0` hard blocks, and no visible process-language hits in the repaired rendered bodies. Lagrange (`019ead98-e047-7c71-be7a-4b4f31c2c113`) returned `PASS_WITH_RISKS`: no hard copy blockers for the batch, anti-thinning satisfied, and the remaining risk is native-speaker phrase fit for the audio-backed same-dish, map, and black-and-white print wording before treating those phrases as production-natural.

Batch 32 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS`. Focused proof after the full-CSV card-parity follow-up shows `0` focused source/render card-parity rows, `0` visible process-language hits, and rendered card counts preserved at `9/9/9/11/11/9/9/9/8/9/9/9` across the twelve pages. The missing-phone page renders `8` cards because a duplicate helper-family card existed only in source and was already omitted by the app; the direct need-help recovery path remains visible.

Batch 32 read-only reviewer Carson (`019eaaa2-e4be-74a2-bbfe-9ea5771bfe68`) returned `PASS_WITH_RISKS`: hard copy blockers: none; anti-thinning: `PASS`; remaining risks are low-level phrase-fit/style items on the bottled-water and nearby-landmark audit scores plus formal-literal immigration-line / landmark wording. Whole corpus remains `REVISE_BEFORE_PRODUCTION`.

Batch 33 read-only reviewer Archimedes (`019eadbf-d9b5-7f52-baff-d5eb7e0e07c6`) initially returned `REVISE_BEFORE_PRODUCTION` for two body/card mismatch fixes, then rechecked with final `PASS`; hard blockers: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.

Batch 34 read-only reviewer Descartes (`019eaddb-223c-7500-b523-77f4e632c760`) initially returned `PASS_WITH_RISKS` for fish-sauce section/card placement, source `map pin` drift, and a canonical doctor-card risk. The main thread fixed all three, regenerated native resources and SQLite, reran focused proof plus validators, and Descartes rechecked with final `PASS`; hard blockers: none; safe-fix items: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`.

Batch 35 read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `PASS`: hard blockers: none; safe-fix items: none; accepted Batch 35 temporary risks: none; anti-thinning: `PASS`; whole corpus remains `REVISE_BEFORE_PRODUCTION`. Pascal (`019eadf6-c082-7bd2-a589-ca74dca0163b`) also rechecked after the source/render fixes and returned `PASS_WITH_RISKS`: no hard blockers, one accepted 8-card room-key page because source/render/ledger agree, and a non-blocking note that a few section bodies still read as compressed phrase lists.

Batch 36 read-only reviewer Erdos (`019eae1f-83e6-7312-a99c-cf631bbfacba`) returned `PASS_WITH_RISKS`: hard blockers: none; safe-fix items: none; anti-thinning: `PASS`; focused proof shows `12 / 12` Batch 36 pages at `PASS 0`, `0` focused source/render parity rows, `0` duplicate rendered targets, `32` Batch 36 anti-thinning rows, and rendered phrase-card counts preserved at `11/11/9/9/9/9/9/10/9/9/9/9`. The accepted temporary risk is routing/canonicalization for some support-card targets, which SQLite and native route canonicalization resolve; whole corpus remains `REVISE_BEFORE_PRODUCTION`.

Batch 37 read-only reviewer Helmholtz (`019eae32-ce2c-7622-ad8d-373b91ca2441`) initially returned `PASS_WITH_RISKS` for the walk rendered line and shellfish source/render card drift. The main thread fixed both, repaired one lime card-parity drift, cleaned two minor at-glance residues, regenerated resources and SQLite, and Helmholtz rechecked with final `PASS`. Focused proof shows `12 / 12` Batch 37 pages at `PASS 0`, `0` focused source/render parity rows after the reviewer follow-up fixes, `0` duplicate rendered targets, `0` suspicious visible process-language hits, `25` Batch 37 anti-thinning rows, and rendered phrase-card counts preserved at `9/9/11/9/9/9/9/9/9/9/9/11`. Whole corpus remains `REVISE_BEFORE_PRODUCTION`.

Batch 38 read-only reviewer Raman (`019eae44-1b5f-7332-95d9-2261c5b6a721`) initially returned `PASS_WITH_RISKS` for visible shorthand in `Explore next` copy, then `REVISE_BEFORE_PRODUCTION` for one remaining wrong-room shorthand body. The main thread rewrote those bodies into natural traveler copy, regenerated resources and SQLite, reran focused proof and validators, and Raman rechecked with final `PASS`. Focused proof shows `12 / 12` Batch 38 pages at `PASS 0`, `0` focused source/render parity rows, `0` duplicate rendered targets, `0` suspicious visible shorthand/process hits, `19` Batch 38 anti-thinning rows, and rendered phrase-card counts preserved at `11/9/9/9/9/9/9/9/9/9/9/9`. Whole corpus remains `REVISE_BEFORE_PRODUCTION`.

Batch 19 read-only subagent `Mendel` (`019eaad0-dcd1-74f2-9e43-c8f05b6e2d69`) initially returned `REVISE_BEFORE_PRODUCTION` against the pre-fix candidate batch, flagging bad source breakdown glosses, bare summaries, and source/rendered card parity drift. The main thread repaired all twelve pages, regenerated native resources and SQLite, aligned four source/render card parity risks without thinning rendered cards, and reran focused checks. Final Batch 19 result: `12 / 12` pages score `PASS 0`, focused source/render card-parity hits are `0`, and exact bad-gloss/template checks are `0`.

Batch 20 read-only subagent `Confucius` (`019eaae4-0bd2-7a41-a08c-e3cbdb6ac6b2`) returned `REVISE_BEFORE_PRODUCTION` against the pre-fix candidate batch, flagging template language, emergency template leaks, source/render card parity risks, and two semantic/audio risks. The main thread repaired all twelve pages, moved `Please wait while I get in` and `Can you make it without this ingredient?` to planned audio after semantic repairs, regenerated native resources and SQLite, and aligned `21` related ingredient-removal cards to the repaired text-bubble state instead of deleting them. Final focused Batch 20 checks: `12 / 12` original batch pages score `PASS`, focused source/render card-parity hits for those original twelve are `0`, exact template/bad-gloss hits are `0`, and rendered `food-premium-without-this-ingredient` related cards now have `0` stale generated audio keys. Remaining related food/allergy source-render parity work still exists on `16` adjacent food pages (`32` rows) and is tracked under the global `REVISE_BEFORE_PRODUCTION` parity report.

Batch 21 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`. The main-thread follow-up kept `Can we sit inside?` on its existing bundled-audio Vietnamese (`Chúng ta...`) instead of moving to the more semantically ideal `Chúng tôi...`, because city Useful Phrases require playable audio; this is accepted as a temporary audio-backed copy risk until a replacement recording exists. The same follow-up mirrored the rendered five-card restaurant-flow `Explore next` set into first-class source, raising that source section from `2` to `5` cards and clearing focused source/render card-parity rows without thinning.

Batch 21 read-only reviewers Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) and Pauli (`019eab18-6b39-7202-a18f-1aef899a9f43`) both returned `PASS_WITH_RISKS`: Batch 21 copy/card quality passed, no thinning was found, and the two remaining fixable risks were a directions-call source/render text drift and a stale anti-thinning ledger row for the earlier `Chúng tôi...` attempt. The main thread then aligned the directions-call first-class source with rendered proof, rewrote the twelve Batch 21 ledger rows from the current source state, regenerated native resources and SQLite, and revalidated. Pauli rechecked the two fixes and returned `PASS`. The known remaining Batch 21 risk is the audio-backed `Can we sit inside?` compromise until matching `Chúng tôi...` audio exists.

Batch 22 read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `REVISE_BEFORE_PRODUCTION` for the full corpus while confirming Batch 22 itself is clean: `12 / 12` Batch 22 pages are `PASS 0`, no Batch 22 source/render card-parity rows remain, and the half-portion card repair grows the source set from `2` to `5` cards instead of thinning.

Batch 23 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS 0`. The focused source/render card-parity scan is `0` rows, exact rendered process-language hits across the twelve pages are `0`, and two source `Explore next` sections grew from `2` to `5` cards to match rendered proof instead of thinning the app experience. Read-only reviewer Plato (`019eab18-20a9-7803-85de-b466feda0ebb`) returned `REVISE_BEFORE_PRODUCTION` for the full corpus and flagged two Batch 23 source/render body drifts; the main thread rewrote the shampoo and market-landmark bodies, regenerated, and directly verified the relevant `quick-say` / `good-to-know` bodies now match source and rendered proof exactly.

Batch 24 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS`. Focused proof after the review-gate fixes shows `12 / 12` Batch 24 pages at `PASS`, focused source/render card-parity rows at `0`, exact old process-language hits at `0`, and no active `dòng` queue-line wording in source/render/planned-audio artifacts. Plato returned `REVISE_BEFORE_PRODUCTION` for the full corpus and initially found four Batch 24 risks: outdoor-seating source/render card parity, ATM rendered-summary fallback, and three source-only fallback bodies. The main thread fixed those by growing outdoor seating from `2` to `5` source `Explore next` cards, rewriting the ATM summary so rendered proof preserves it, replacing the crossing/extra-night/invoice fallback bodies, regenerating, and rerunning focused proof.

Batch 25 repaired another `12 / 12` top hard-review catalog-promoted pages to `PASS`. It covered shrimp checks, early check-in, breakfast time, exact-change payment, apology wording, restroom fee, side-rice request, food compliment, medicine safety, written medicine instructions, hurry/casing, and ticket inclusion. Semantic repairs moved seven changed phrases to planned/no-audio instead of reusing mismatched recordings; the hurry page kept its existing audio after casing-only repair. The follow-up reference sync updated `18` stale related phrase-card source files, `6` search-only placements, and `8` internal rationale rows, then substituted three HCMC city Useful Phrase cards with bundled-audio alternatives (`food-1`, `smalltalk-5`) and synced `city-library/v1.json` so SQLite still passes city Useful Phrases audio checks. Focused Batch 25 proof shows `12 / 12` pages at `PASS`, focused source/render card-parity rows at `0`, and exact old text hits at `0` in active source/projection paths.

Read-only sidecar subagent `Chandrasekhar` (`019ea9e9-0c0f-7412-bca2-64c277d6f080`) reviewed the remaining corpus earlier in this branch and returned `REVISE_BEFORE_PRODUCTION`. The current main-thread audit after Batches 1-38 still agrees with that recommendation: formulaic projection prose remains widespread, `299 / 770` catalog-promoted pages are still hard-review, and semantic follow-up gates remain needed for literal `Can I have...` Vietnamese, stale audio manifest entries, compound keep-together checks, and source/rendered parity mismatches.

## Remaining Risks

- This branch is not merged to `main`.
- This branch has not been built to the physical iPhone.
- `772` planned missing-audio rows remain, with `0` release-blocking missing-audio rows.
- Phrase-listing premium copy audit still has `323` hard-review pages and `68` weak-review pages.
- Source/render card-parity still has `336` mismatch rows across `208` pages (`64` unique source-card missing rows, `272` section layout diff rows, `0` hard-block rows).
- `500` missing-audio priority rows remain in production QA.
- `775` duplicate hero sections are hidden at render time.
- The old audio manifest still contains the stale `Đường dây ở đâu?` recording entry for `v500-time-date-book-where-is-the-line`, but the rendered page and catalog no longer reference it.
- The literal `Can I have...` Vietnamese family remains a corpus-level semantic/audio risk. Batch 10 now fixed the `higher floor` and `seats together` reviewer examples and moved their changed self-phrases to planned audio, but the broader family still needs an audio-aware semantic pass.
- The Batch 27 `correct street` page keeps its audio-backed formal Vietnamese (`Đây có phải là đường phố chính xác không?`) as an accepted temporary wording risk until an audio-aware native-speaker replacement can be recorded.
- The Batch 31 same-dish page still uses the audio-backed literal Vietnamese `Tôi sẽ có những gì họ đang có`; it passed the copy gate for visible prose, but native-speaker phrase fit should be reviewed before calling that wording production-natural.
- City voice audit passes, but `first` sits exactly at its max threshold (`175 / 175` entries), so it is a watch item.
- Validators and subagent review catch production-copy defects; they do not replace a native-speaker linguistic review.
