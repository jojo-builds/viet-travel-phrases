# TASK-SQLITE-PROMOTION-001 Result

- status: done
- commit hash: final commit hash is reported in the worker closeout after this receipt is committed

## What Changed

- Promoted the Viet SQLite repository/runtime out of DEBUG-only compilation while keeping activation behind `--use-sqlite-phrase-graph` or `SPEAKLOCAL_USE_SQLITE_GRAPH=1`.
- Added canonical page ID resolution through SQLite aliases for detail routing, app launch detail arguments, search/detail lookups, saved IDs, practice-pool IDs, and recent-page history.
- Added relation lookup hardening with `idx_phrase_relation_source` and `idx_phrase_relation_target`, plus generator/report/validator checks that the source lookup index exists and is used.
- Regenerated the bundled Viet SQLite fixture/report with relation index readiness fields.
- Added focused native tests covering SQLite relation lookup plans, SQLite-backed search/detail/related navigation, browser-like history, and alias migration for local saved/practice/recent state.

## Default-Ready Status

SQLite is not default-ready yet. It is feature-flag ready for route/search/detail/local-state proof, but Home/Browse catalog shelves still come from the existing JSON/`GeneratedVietContent` path. The remaining default-promotion blocker is a deliberate catalog adapter/parity step so primary Home/Browse data can come from SQLite without regressing the current surfaced content.

## Remaining Blockers

- Default runtime switch remains gated until Home/Browse catalog shelves have a SQLite-backed primary data path or an explicit product decision accepts the current hybrid path.
- Full native test suite was attempted twice; the cleanest run reached 112 passed / 1 failed because `PhrasePageFixtureTests/testEveryTierOneArticleIsSearchableByExactTitleAndEnglish` was killed by the simulator test host. That exact test passed when rerun in isolation, so this is tracked as a full-suite stability caveat rather than a SQLite correctness failure.
- Unrelated practice reward/mascot files were already dirty in the worktree and were intentionally left unstaged.

## Validation

- `node native-ios/scripts/generate-viet-sqlite-fixture.js` - passed; regenerated the fixture/report with 18 scenarios, 900 clusters, 919 phrase rows, 911 canonical pages, and 3,438 relations.
- `node native-ios/scripts/generate-viet-sqlite-fixture.test.js` - passed.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` - passed with `ok: true`, `missingAudioAuditRows: 0`, `bannedFileMatches: 0`, and relation source index validation.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` - passed, 11 tests.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests` - passed, 36 tests.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/PhrasePageFixtureTests/testEveryTierOneArticleIsSearchableByExactTitleAndEnglish` - passed in isolation after the full-suite simulator kill.
- `xcodebuild build -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` - passed.
- `git diff --check` - passed.

## Peer Review

- Initial read-only peer review: blocked on root `Xin chao` route canonicalization, existing alias local-state migration, missing receipt, and unrelated practice reward/mascot worktree noise.
- Follow-up read-only peer review: approved. The reviewer confirmed the route-identity and local-state P1 blockers are resolved, relation/index validation still passes, and SQLite should remain gated until Home/Browse catalog surfaces are no longer hybrid.

## Simulator Proof

- `/Users/jojolim/Developer/products/speaklocal/app-family/docs/task-results/TASK-SQLITE-PROMOTION-001-sqlite-alias-launch.png`
