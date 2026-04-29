# TASK-SQLITE-DEFAULT-RUNTIME-001 Result

## Status

done

## Commit Hash

Implementation commit: `c2661ed` (`Make Viet SQLite the default runtime`).

## Default Runtime Path

The bundled Viet SQLite phrase graph is now the normal native runtime path. `VietSQLitePhraseGraphRuntime.isEnabled` defaults to `true` without `--use-sqlite-phrase-graph` or `SPEAKLOCAL_USE_SQLITE_GRAPH=1`.

The only explicit opt-outs are `--disable-sqlite-phrase-graph` and `SPEAKLOCAL_DISABLE_SQLITE_GRAPH=1`.

## JSON Still In Use

- Generated/authored JSON remains as a fallback if the bundled SQLite repository cannot be opened or snapshot loading fails.
- Legacy authored fixture tests explicitly disable SQLite so they continue to prove the JSON fallback contract.
- Home shelf definitions still use curated Swift ID lists, but those IDs now resolve through `PhraseCatalog.catalogItem(forOpenablePageID:)` into canonical SQLite catalog rows under the normal runtime.
- The audio manifest remains JSON-backed for bundled file playback; SQLite supplies the catalog/detail audio keys and tests validate those keys still resolve to bundled audio.

## Home/Browse/Search/Detail Proof

- Home: normal app launch uses SQLite-backed `PhraseCatalog` snapshots for catalog rows and canonicalizes legacy Home IDs into SQLite page IDs.
- Browse: `PhraseCatalog.Cache` now hydrates scenario categories and catalog items from `VietSQLitePhraseGraphRuntime.catalogSnapshot()`.
- Search: default runtime search resolves through SQLite without any launch flag.
- Detail: `PhraseDetailPage.page(withID:)`, related links, route aliases, saved IDs, recent IDs, and practice IDs resolve through the same SQLite canonical ID model.
- `Xin chào`: the legacy root ID still opens, but it canonicalizes to `viet-phrase-polite-1` in the default SQLite runtime.

## Validation

- `node native-ios/scripts/generate-viet-sqlite-fixture.js` passed; regenerated the bundled fixture/report with `integrity_check: ok`.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with `ok: true`, `canonicalPages: 911`, `resolvedPhrases: 919`, `missingAudioAuditRows: 0`, and `bannedFileMatches: 0`.
- `node native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` passed: 14 tests, 0 failures.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests -only-testing:SpeakLocalNativeTests/LocalUserIntentStoreTests` passed: 39 tests, 0 failures.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/PhrasePageFixtureTests` passed: 63 tests, 0 failures.
- `xcodebuild test -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` passed: 116 tests, 0 failures.
- `xcodebuild build -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` passed.
- `git diff --check` passed.

## Simulator Screenshots

- `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/home-normal-launch.png`
- `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/browse-normal-launch.png`
- `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/search-normal-launch.png`
- `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/detail-alias-normal-launch.png`

All screenshots were captured from a normal simulator app path without the old SQLite enable flag. The detail screenshot used `--detail-page viet-family-repair-meaning` only, proving alias navigation without `--use-sqlite-phrase-graph`.

## Peer Review

Approval: APPROVE.

Reviewer evidence: SQLite is enabled by default, Home/Browse hydrate from the SQLite catalog snapshot, Search/detail/local-state canonicalization still route through SQLite IDs, and audio behavior is covered by catalog item audio keys plus visible-audio tests.

Reviewer risk noted: JSON fallback remains intentionally broad and silent when the bundled repository or snapshot load fails. This is documented above as the remaining fallback path.

## Remaining Blockers

None for making bundled Viet SQLite the normal native runtime source.

## Recommended Next Task

Move the remaining curated Home shelf definitions into a database-backed or app-config-backed surface, then add lightweight runtime observability so fallback-to-JSON is visible during internal validation instead of silent.
