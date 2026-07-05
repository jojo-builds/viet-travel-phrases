# Main Validator Sweep Report

Date: 2026-07-05
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Branch: `main`
Head: `abd3f3a6e`

## Scope

Extra orchestrator validation after the three-hour push checkpoint commit. No app runtime code was edited during this sweep.

## Results

All commands below passed on current `main`:

```sh
node native-ios/scripts/validate-viet-sqlite-fixture.js
```

- `ok: true`
- `1782` clusters
- `1800` source phrases
- `1793` canonical pages
- `5353` audio assets in the generated fixture counts
- `0` missing-audio audit rows
- `0` release-blocking missing-audio audit rows
- `0` planned missing-audio rows

```sh
node native-ios/scripts/sync-viet-audio.js
```

- Validated `5353` native audio manifest entries in `native-ios/Resources/Audio`.

```sh
node native-ios/scripts/validate-tier-one-listing-pages.js
```

- `150` tier-one families checked.
- `150` strong.
- `0` thin, awkward, placeholder-like, over-templated, negative-frictional, or needs-work rows.

```sh
node native-ios/scripts/validate-vietnamese-menu-copy.js
```

- Validated `355` handwritten Vietnamese menu item pages.
- Ready helper phrases: `15`.

```sh
node native-ios/scripts/audit-viet-listing-production-qa.js --check
```

- Checked `1793` pages.
- `0` blockers.
- `0` majors.
- `0` missing-audio priority rows.
- `775` duplicate hero sections remain hidden at render time.

```sh
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
```

- `520` total city app-detail entries.
- `520` pass.
- `0` revise.
- `0` fail.

```sh
node native-ios/scripts/validate-viet-search-only-surfacing.js
```

- `ok: true`
- `315` search-only rows.
- `315` generated relations.
- `315` generated section items.

```sh
node --test ./native-ios/scripts/audit-viet-listing-production-qa.test.js ./native-ios/scripts/viet-practice-copy.test.js
```

- `2` tests.
- `2` pass.
- `0` fail.

## Recommendation

No new non-paywall launch blocker was found in this validator sweep. Remaining release risk is still concentrated in:

- unlocked physical-phone launch/walkthrough proof;
- paywall purchase/restore/relaunch proof if revenue gating must ship in the first release;
- human audio-quality listen spot-check before pronunciation/voice-quality marketing claims.
