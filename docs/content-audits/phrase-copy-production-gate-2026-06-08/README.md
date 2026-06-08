# Phrase Copy Production Gate - 2026-06-08

Branch: `codex/phrase-copy-production-gate`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/phrase-copy-production-gate`
Base: `0a503335c` (`Implement compact more admin chrome`)

## Verdict

Copy recommendation: `PASS`

Branch merge recommendation: `PASS_WITH_RISKS`

The phrase listing copy is ready to merge as production copy. The branch preserves rich authored phrase pages instead of thinning them into `Vietnamese means English` shells, repairs formula-ish rendered wording, keeps phrase cards and related/explore cards intact, and passes the static production QA gate with `0` blockers and `0` majors.

The remaining risks are not copy blockers: missing/planned audio rows, duplicate hero rows hidden at render time, and a small amount of non-blocking support/navigation polish. No production-ready claim depends on deleting sections, deleting phrase cards, or weakening validators.

## What Improved

- Preserved authored phrase editorial for `tier1`, `child`, `catalog-promoted`, and `editorial-model-support` pages in the generated native payload.
- Preserved phrase cards and related/explore cards instead of deleting cards to satisfy validators.
- Preserved existing child-page source copy instead of regenerating generic child copy.
- Repaired bad driver wording from `trinh dieu khien` to `tai xe` in the two live driver-related phrase pages.
- Changed those repaired exact-audio rows to planned/missing audio behavior instead of keeping stale speaker icons and wrong audio keys.
- Repaired stale support/deferred pilot rows without importing dead pilot IDs as duplicate phrases.
- Replaced internal/developer wording such as `pilot row`, `canonical title`, and `question marker` with user-facing copy.
- Reworked repeated formula bodies such as `Say ... for`, `Use it when ... is the next thing you need to say`, `is the line for`, and `Use these nearby pages when...`.
- Post-review polish replaced `733` repeated nearby-navigation bodies with `Use these nearby phrases if the conversation shifts toward another ... need.`

## Current Counts

- Generated authored listing pages: `1793`
- Generated phrase catalog: `1782` families, `1800` phrases
- Generated source scope: `145` main tier-one pages, `13` child pages, `770` catalog-promoted pages, `826` city library pages, `39` editorial model support pages
- SQLite projection: `19` scenarios, `1782` clusters, `1800` phrases, `1793` pages
- Static production QA: `0` blockers, `0` majors, `98` minors, `3` info
- Duplicate hero sections hidden at render time: `775`
- Missing-audio priority rows: `500`
- Planned missing-audio rows in SQLite validation: `717`
- Release-blocking missing-audio rows: `0`

## Production QA Result

Latest command:

```sh
node native-ios/scripts/audit-viet-listing-production-qa.js
```

Result:

- `1793` pages
- `0` blockers
- `0` majors
- `98` minors
- `3` info
- `775` duplicate hero sections hidden at render time
- `500` missing-audio priority rows
- verdict: `NO_BLOCKER_OR_MAJOR_ISSUES_IN_STATIC_RENDER_MODEL`

Production QA no longer reports the earlier `61` `section_body_too_long` majors.

## Copy Formula Scan

The final local rendered-copy scan found `0` hits for these blocker patterns:

- `is the line for`
- `Say ... when you need`
- `Say ... for`
- `Use ... for`
- `Start with ..., then pause`
- `This is for when`
- generic `Expect a confirmation, a handoff, a price, or follow-up question`
- `The reply may be a short reply`
- `Say ... once, then watch for the reply`
- duplicate `Use the full phrase before adding details`
- `Use it when "English" is the next thing you need to say`
- internal/process language
- malformed `if the price is.`
- banned generic copy such as `this page helps`, `perfect for`, `must-visit`, `hidden gem`, `vibrant`, `bustling`, `curated`, or `nestled`

One safe non-formula `nearby pages` phrase remains in a good-to-know body on `viet-family-ves-order-bun-cha-portion`. The repeated navigation formula was removed.

Local post-polish overlong-body scan across phrase-family roles found `136` bodies over `40` words, `18` over `45`, and `0` over `55`. The final visible-copy reviewer used a broader rendered scope and counted `164` over `40`, `23` over `45`, and `0` over `55`. Neither scan found a production-blocking long-body issue after the final cleanup.

## Anti-Thinning Evidence

Branch-level card comparison against base `0a503335c`:

- source pages checked: `935`
- sections checked: `6884`
- phrase-card drops: `0`
- same-count target swaps: `0`

Ledger files in this receipt directory:

- `formula-repair-ledger.jsonl`: `81` sections updated in `21` files
- `formula-rendered-backfill-ledger.jsonl`: `1768` sections updated in `764` files
- `nearby-pages-language-cleanup-ledger.jsonl`: `733` sections updated in `733` files
- `card-restoration-ledger.jsonl`: `17` sections restored in `14` files, `45` phrase-card occurrences restored
- `card-restoration-rerun-ledger.jsonl`: `4` sections restored in `1` file, `7` phrase-card occurrences restored
- `anti-thinning-ledger.jsonl`: `5` targeted phrase-source cleanup entries in `4` files

Total ledger rows: `2608`.

The ledger split is intentional: the late post-review cleanup writes its own ledger instead of overwriting the earlier formula and restoration ledgers. The durable anti-thinning proof is the combination of these ledgers plus the final card graph comparison and subagent review.

## Validation Commands

Passed after the final copy cleanup:

```sh
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-editorial-model-support.js
node native-ios/scripts/validate-viet-catalog-promoted-authoring.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node native-ios/scripts/validate-viet-phrase-backdrops.js
node native-ios/scripts/validate-viet-search-only-surfacing.js
node native-ios/scripts/validate-viet-breakdown-audit.js --write-export
node native-ios/scripts/audit-viet-listing-production-qa.js
node scripts/guard-native-only.js
git diff --check
```

Key validation outputs:

- `generate-viet-catalog`: `1782` families, `1800` phrases
- `generate-authored-tier-one-pages`: `145` main tier-one, `13` child, `770` catalog-promoted, `826` city library, `39` support; missing assigned audio `718`
- `generate-viet-sqlite-fixture`: SQLite integrity OK, `19` scenarios, `1782` clusters, `1800` phrases, `1793` pages
- `validate-viet-sqlite-fixture.js`: `ok: true`, `1793` canonical pages, `1800` resolved phrases, `12017` relations, `0` release-blocking missing-audio rows, `717` planned missing-audio rows
- `validate-viet-editorial-model-support.js`: `17` deferred rows checked, `13` ready for Jojo approval, `2` ready with title-preserving import, `2` blocked title identity, `39` support pages
- `validate-viet-catalog-promoted-authoring.js`: `ok: true`, `770` authored pages
- `validate-tier-one-listing-pages.js`: `150` audited tier-one families, `150` strong, `0` needs work, `0` thin, `0` awkward, `0` over-templated
- `validate-viet-phrase-backdrops.js`: `952` placements
- `validate-viet-search-only-surfacing.js`: `315` generated relations
- `validate-viet-breakdown-audit.js --write-export`: `PASS`
- `audit-viet-listing-production-qa.js`: `1793` pages, `0` blockers, `0` majors
- `git diff --check`: passed with no output

## Subagent Review

Completed read-only reviews against actual source/rendered output:

- Visible prose / anti-thinning reviewer `019ea83f-75ad-70e2-9400-8fa8354221e3`: initial `PASS_WITH_RISKS`, final post-polish recheck `PASS`. The reviewer found no hard blockers, verified the 733 nearby-language replacements, verified `0` old `Use these nearby pages when...` bodies, `0` card drops, `0` section drops, and `0` same-count target changes versus `0a503335c`.
- Phrase graph / audio / support reviewer `019ea83f-9e07-7a73-8fdb-1ccf424b0e6e`: `PASS_WITH_RISKS`. The reviewer found `0` unresolved phrase-card targets after SQLite/alias resolution, confirmed the transport-cash card graph repair, and confirmed there are no speaker-icon rows falsely using planned/missing audio.

Combined copy recommendation: `PASS`.

Combined branch recommendation: `PASS_WITH_RISKS`, because audio completion and duplicate hidden hero rows remain non-copy follow-ups.

## Remaining Risks

- `500` missing-audio priority rows remain in production QA.
- SQLite validation tracks `717` planned missing-audio rows and `0` release-blocking missing-audio rows.
- `native-ios/Resources/viet-authored-audio-audit.json` reports `718` missing rows; the extra JSON-only row is the pre-existing nonblocking `viet-family-food-to-go` breakdown audio row for `Mang di`, not a false playable speaker.
- `775` duplicate `sayThis` hero sections are hidden at render time.
- `98` production QA minors remain.
- Some non-blocking support/navigation helper copy remains, including `50` rendered instances of `Use the full phrase before adding details`.
- This branch has static render-model proof and source/rendered-copy review proof. It has not been merged to `main` or built to the physical iPhone.
