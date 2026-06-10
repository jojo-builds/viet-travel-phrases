# Final Phrase Listing Copy Audit Addendum - 2026-06-10

Branch: `codex/phrase-copy-production-gate`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/phrase-copy-production-gate`
Head: `b3574a3ca`
Base: `0a503335c`

## Current Verdict

Copy recommendation: `PASS_WITH_RISKS`

The phrase/listing copy is now production-acceptable from a copy standpoint. The final premium visible-copy audit has no hard or weak rows:

- pages audited: `1793`
- `HARD_REVIEW`: `0`
- `WEAK_REVIEW`: `0`
- `WATCH`: `327`
- `PASS`: `1466`

This is not a clean `PASS` because some visible formula residue remains in `WATCH`, and source/render card parity still recommends `REVISE_BEFORE_PRODUCTION` even though it has `0` hard-block rows. The remaining risk is polish and bookkeeping, not a hard copy blocker.

## Final Repair Pass

Batch 46 repaired these catalog-promoted social pages:

- `viet-how-are-you-em`
- `viet-how-are-you-anh`

Batch 47 repaired these catalog-promoted weak pages without changing card inventory:

- `viet-phrase-v900-tran-can-you-break-this-bill`
- `viet-thanks-khong-co-gi`
- `viet-phrase-v500-bath-pers-need-is-there-a-public-bathroom-nearby`
- `viet-how-are-you`
- `viet-how-are-you-chi`
- `viet-phrase-v500-unde-repa-please-type-it-into-my-phone`
- `viet-da-chao-ba`
- `viet-da-chao-chi`
- `viet-da-chao-chu`
- `viet-da-chao-ong`
- `viet-phrase-v500-airp-bord-arri-can-i-show-it-on-my-phone`
- `viet-phrase-v500-heal-phar-i-feel-nauseous`
- `viet-phrase-v500-heal-phar-i-have-diabetes`
- `viet-phrase-v900-heal-phar-i-take-this-medicine-every-day`
- `viet-phrase-v500-tran-i-feel-unsafe-please-stop`
- `viet-phrase-v500-tran-i-got-on-the-wrong-bus`
- `viet-phrase-v500-tran-please-let-me-out-here`
- `viet-phrase-v500-tran-please-turn-around`
- `viet-phrase-v900-tran-id-like-to-rent-a-motorbike`
- `viet-phrase-v900-tran-one-ticket-to-da-nang-please`
- `viet-phrase-v900-tran-pick-me-up-at-this-entrance`
- `viet-phrase-v900-tran-this-is-the-wrong-address`
- `viet-phrase-v900-food-drin-can-i-have-soup-on-the-side`
- `viet-phrase-v900-food-drin-please-pack-it-to-go`
- `viet-phrase-v900-hote-acco-can-i-have-more-drinking-water`
- `viet-acknowledge-co`
- `viet-acknowledge-khong`
- `viet-hello-chao-anh`
- `viet-hello-chao-ba`
- `viet-hello-chao-ban`
- `viet-hello-chao-chi`
- `viet-hello-chao-chu`
- `viet-hello-chao-co`
- `viet-hello-chao-em`
- `viet-hello-chao-ong`
- `viet-smalltalk-di-dau-day`
- `viet-smalltalk-nice-to-meet-you`
- `viet-thanks-cam-on-nhieu`
- `viet-thanks-khong-cam-on`
- `viet-phrase-food-premium-which-dish-safe`

The final generator override pass repaired the remaining tier-one weak cluster:

- `emergency-ambulance`
- `emergency-not-safe`
- `emergency-passport`
- `emergency-police`
- `v500-emer-safe-do-not-touch-me`
- `v500-emer-safe-i-cannot-move`
- `food-one-portion`
- `food-pay-now`
- `health-pharmacy`
- `hotel-aircon-broken`
- `hotel-checkout`
- `hotel-room-hot`
- `transport-lost`
- `transport-meter`
- `transport-route`
- `transport-stop-here`

The SQLite projection was also fixed so how-are-you relationship-form pages do not receive the generic `relationship-words` shelf in addition to their custom relationship-form section.

## Anti-Thinning

The final anti-thinning ledger has:

- ledger rows: `858`
- unique edited page IDs: `600`
- Batch 46 ledger rows added: `2`
- Batch 47 ledger rows added: `40`

The broad pattern is preservation, not thinning. The comparable ledger rows mostly preserve or increase card counts. Ten ledger rows record card-count drops, but the recorded reasons are non-thinning source/render alignment: source-only duplicate helper cards, source-only cards already omitted by the native renderer, or moving cards out of a prose-only section while preserving the rendered card path elsewhere.

Rendered production QA still reports `0` zero-phrase pages and `0` duplicate card-target pages.

## Review Gate

Fresh read-only reviewer `019eaec5-575b-7571-8504-467f8b14ae20` initially returned `REVISE_BEFORE_PRODUCTION` at `0 HARD_REVIEW / 82 WEAK_REVIEW / 377 WATCH / 1334 PASS`.

After Batch 47 and the tier-one override pass, the same reviewer rechecked current rendered output and returned `PASS_WITH_RISKS`:

- copy is no longer blocked
- remaining `WATCH` rows are acceptable utility-copy risks
- visible formula residue remains, so this is not a clean `PASS`
- anti-thinning looks acceptable
- source/render card parity should be triaged before merge bookkeeping

## Validation

Passed:

```sh
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-catalog-promoted-authoring.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-premium-listing-copy.js
node native-ios/scripts/audit-viet-listing-production-qa.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-breakdown-audit.js
node native-ios/scripts/validate-viet-editorial-model-support.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/audit-viet-city-listing-what-why.js
git diff --check
```

Key outputs:

- catalog-promoted authoring: `ok: true`, `770` authored pages
- SQLite: `1793` pages, `11724` relations, `0` release-blocking missing-audio rows, `778` planned missing-audio rows
- production QA: `1793` pages, `0` blockers, `0` majors, `775` duplicate hero sections hidden at render time, `500` missing-audio priority rows
- tier-one listing pages: `150 / 150` strong
- breakdown audit: `PASS`
- city V2.2: `520` pass, `0` revise, `0` fail
- city what/why: `520` entries, `0` findings, `0` hard-review pages
- city library: `826` pages
- `git diff --check`: passed

Non-blocking audit output:

```sh
node native-ios/scripts/audit-viet-source-render-card-parity.js
```

Output:

- source pages: `933`
- mismatch rows: `322`
- page mismatch count: `201`
- unique source-card missing rows: `57`
- section layout diff rows: `265`
- hard-block rows: `0`
- recommendation: `REVISE_BEFORE_PRODUCTION`

This parity result is the main remaining merge-bookkeeping risk. It does not currently identify hard copy blockers, but it should either be allowlisted/documented as expected runtime curation or reduced before a clean merge story.

## Remaining Risks

- Branch is not merged to `main`.
- Branch has not been built to the physical iPhone.
- Source/render card parity still recommends `REVISE_BEFORE_PRODUCTION` with `0` hard-block rows.
- `327` premium audit `WATCH` rows remain, mostly utility-copy repetition and derived city helper pages.
- `500` missing-audio priority rows remain; SQLite has `0` release-blocking missing-audio rows.
- `775` duplicate hero sections are hidden at render time.
