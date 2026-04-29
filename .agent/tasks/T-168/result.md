# T-168 Result

Status: done

Commit hash: `c7c6e15` (`Wire Viet SQLite phrase graph runtime`)

## Database Resource Path Changes

- Merged the content-data universe into `codex/native-sqlite-runtime`, preserving the T-167 Home/local-state lane and bringing in the generated Viet SQLite fixture.
- The native database resource remains at `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`, with its report at `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`.
- The live Viet JSON resources remain present at `native-ios/Resources/*.json`; this task creates a DEBUG SQLite bridge, not a JSON removal.
- Fresh generator output proved 18 scenarios, 900 clusters, 919 source phrase rows, 911 canonical pages, 919 search docs, and 3,438 relation edges.

## Swift Runtime And Read Model Changes

- Expanded `VietSQLiteLanguagePackRepository` into a DEBUG-only read model for:
  - search documents and ranked canonical search results;
  - canonical lookup by page ID, alias, and phrase ID;
  - detail page section rendering inputs;
  - related-page relation edges;
  - visible audio usage checks for hero phrases, section rows, authored phrase rows, and breakdown tokens.
- Added `VietSQLitePhraseGraphRuntime` behind `--use-sqlite-phrase-graph` or `SPEAKLOCAL_USE_SQLITE_GRAPH=1`.
- Wired DEBUG search/detail/openability hooks through `PhrasePage.swift`; default/release behavior falls back to the existing generated JSON path.
- Kept all runtime copy offline and deterministic; no runtime AI or network path was added.

## Test Changes

- Added SQLite coverage tests proving every current source phrase resolves to a canonical page, aliases/duplicates resolve, SQLite search opens database-backed article sections, related pages resolve, and visible audio keys are playable.
- Added regression coverage for authored phrase audio rows on `viet-phrase-smalltalk-7`; the Gate 2 audio review found this gap and the fix now maps authored phrase `audio_usage` rows into visible playback keys.
- Repaired stale phrase fixture tests by replacing obsolete `watch out` / `warningCallout` assumptions with the current positive article standard (`good-to-know`, local/traveler tip roles, and caution-free usage guidance) while keeping canonical uniqueness, link, search, duplicate, banned-term, and visible-audio quality bars.

## Live Versus DEBUG/Fallback

- Live/default app path remains JSON-backed.
- SQLite graph reads are DEBUG opt-in only through launch argument or environment variable.
- Release fallback stays intact until a later task promotes SQLite after broader simulator/product parity.

## Validation

- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`: passed, no changes required.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`: passed; SQLite integrity check `ok`; 18 scenarios, 900 clusters, 919 phrases, 911 pages.
- `node native-ios/scripts/generate-viet-sqlite-fixture.test.js`: passed 1/1.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`: passed with `ok: true`, 919 resolved phrases, 919 search docs, 3,438 relations, 0 missing-audio audit rows, and 0 banned file matches.
- `node native-ios/scripts/validate-tier-one-listing-pages.js`: passed with 150/150 strong Tier 1 families and no failing rows.
- `cd native-ios && xcodegen generate`: passed.
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build`: passed.
- `cd native-ios && xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'`: passed 110 tests, 0 failures.
- `git diff --check`: passed.

## Simulator Proof

Proof lives under `.agent/tasks/T-168/proof/`.

Flow exercised with `SIMCTL_CHILD_SPEAKLOCAL_USE_SQLITE_GRAPH=1` and `--use-sqlite-phrase-graph`:

1. Home opened with the DEBUG SQLite graph enabled.
2. Search for `hello` opened the SQLite-backed `Xin chao` page (`viet-phrase-polite-1`).
3. The page rendered database-backed sections and visible audio controls.
4. Search for `thank you` opened `Cam on` (`viet-phrase-polite-2`), a SQLite relation target from the first page.
5. Back returned to the first page and forward returned to the related page.

Screenshots:

- `.agent/tasks/T-168/proof/01-sqlite-search-hello.png`
- `.agent/tasks/T-168/proof/02-sqlite-detail-xin-chao.png`
- `.agent/tasks/T-168/proof/03-sqlite-search-related-thank-you.png`
- `.agent/tasks/T-168/proof/04-sqlite-related-thank-you-detail.png`
- `.agent/tasks/T-168/proof/05-back-to-xin-chao-forward-available.png`
- `.agent/tasks/T-168/proof/06-forward-to-thank-you.png`
- `.agent/tasks/T-168/proof/simulator-proof.md`

## Review Artifacts

- Gate 1 latest unanimous approval: `.agent/tasks/T-168/reviews/gate-01-pass-02/`
- Gate 2 pass 1 blocker and evidence: `.agent/tasks/T-168/reviews/gate-02-pass-01/`
- Gate 2 latest unanimous approval after the audio fix: `.agent/tasks/T-168/reviews/gate-02-pass-02/`
- Gate 3 latest unanimous approval: `.agent/tasks/T-168/reviews/gate-03-pass-01/`

## Remaining Risks

- SQLite remains DEBUG-only; JSON is still the live default until a follow-up task promotes it deliberately.
- `relatedPages(forPageID:)` is acceptable for the current 3,438 relation rows, but should get a composite source-field index before materially larger graph expansion.
- The implementation commit landed cleanly, but Git preserved an autostash copy of queue metadata after the merge commit warning. The working tree contains the intended queue state and no conflict markers.

## Recommended Next Task

Promote the SQLite bridge toward product parity with a dedicated task that adds route-level smoke coverage for the DEBUG graph, introduces the relation-source index, and defines the criteria for switching the Viet app from JSON default to SQLite default.

## Process feedback

- NONE - The manual queue process worked; the required review gates caught and documented the authored-phrase audio gap before closeout.
