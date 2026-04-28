# T-165 Result: Bundle Viet SQLite Fixture And Add Swift Read-Only Repository Spike

## Status

done

## Summary

Bundled the generated Viet SQLite fixture into the native iOS app as a `Resources/LanguagePacks` folder resource and added a debug-only Swift read path that opens `LanguagePacks/viet/speaklocal-viet.sqlite` read-only from `Bundle.main`.

Current production behavior remains JSON-backed. The new SQLite repository is compiled only under `#if DEBUG`, is not referenced by production views/loaders, and maps only a representative sanity slice toward existing `PhraseCatalogItem` and `PhraseSearchResult` concepts.

## Files Changed

- `.agent/tasks/T-165/result.md`
- `.agent/tasks/T-165/reviews/gate-01-pass-01/*.md`
- `.agent/tasks/T-165/reviews/gate-02-pass-01/*.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `native-ios/App/Models/VietSQLiteLanguagePackRepository.swift`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`
- `native-ios/Tests/SQLiteLanguagePackRepositoryTests.swift`
- `native-ios/project.yml`
- `native-ios/scripts/generate-viet-sqlite-fixture.js`
- `native-ios/scripts/generate-viet-sqlite-fixture.test.js`

## Packaging And Read Path

- `native-ios/project.yml` keeps broad `Resources` inclusion but excludes `Audio` and `LanguagePacks`, then re-adds `Resources/Audio` and `Resources/LanguagePacks` as explicit folder resources.
- `libsqlite3.tbd` is linked for the app target.
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json` now reports `bundlePackaging.isIncludedInXcodeResources: true` and `status: "bundle-ready"`.
- `VietSQLiteLanguagePackRepository` locates `speaklocal-viet.sqlite` in `Bundle.main` under `LanguagePacks/viet`, opens with `SQLITE_OPEN_READONLY | SQLITE_OPEN_NOMUTEX`, verifies `sqlite3_db_readonly`, finalizes prepared statements, and closes the database handle.
- The sanity snapshot reads language-pack metadata, `PRAGMA integrity_check`, table counts, and a representative `polite-1` phrase preview.

## Runtime Boundary

- SQLite is now bundle-addressable for debug validation.
- Swift can open the fixture read-only through the debug repository.
- JSON remains the production runtime path through `GeneratedVietContent`, `AuthoredVietListingPages`, and `AudioAssetManifest`.
- No runtime UI, navigation, search, page rendering, or audio path was switched to SQLite.

## Validation

- `python3 .agent/queue_tool.py heartbeat --task-id T-165 --session-id "491a0ab9-cb54-4201-a510-9c3a0dc6e36c" --phase "post-claim-heartbeat" --lease-minutes 180` passed.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` regenerated the SQLite fixture/report and returned `SQLite integrity_check: ok`.
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed, 1 test, 0 failures.
- `cd native-ios && xcodegen generate` passed and regenerated `SpeakLocalNative.xcodeproj`.
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' build` passed. Build output showed `LanguagePacks` copied into `SpeakLocalNative.app` and `-lsqlite3` linked.
- `cd native-ios && xcodebuild -project SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' test -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` passed, 3 tests, 0 failures.
- `sqlite3 native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite "PRAGMA integrity_check;"` returned `ok`.
- `python3 -m json.tool native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json >/tmp/speaklocal-viet-report.json` passed.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy` passed with `status: ok` and no changes.
- Scoped whitespace check for T-165-owned files passed: `git diff --check -- .agent/tasks/T-165 docs/APP_FAMILY_STRUCTURE.md docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md native-ios/project.yml native-ios/App/Models/VietSQLiteLanguagePackRepository.swift native-ios/Tests/SQLiteLanguagePackRepositoryTests.swift native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json native-ios/scripts/generate-viet-sqlite-fixture.js native-ios/scripts/generate-viet-sqlite-fixture.test.js`.
- Full `git diff --check` passed on the final validation pass.

## Review Gates

- Gate 1, resource packaging: latest pass `gate-01-pass-01`, 4/4 approvals.
- Gate 2, Swift read-only spike: latest pass `gate-02-pass-01`, 4/4 approvals.
- Gate 3, handoff readiness: latest pass `gate-03-pass-01`, 4/4 approvals.

## Remaining Risks

- `loadPhrasePreview` treats any non-row result as a missing preview phrase; this is acceptable for the debug sanity spike but should become more precise if expanded into a fuller repository.
- SQLite relation/practice tables remain schema-ready but unpopulated from T-163; this task does not change that.
- The debug repository proves a representative phrase path, not full search/page-renderer parity.
- The shared worktree still contains unrelated dirty files from other lanes; final staging/commit must stay scoped to T-165-owned files plus helper-managed queue state.

## Recommended Next Tasks

- Add SQLite search parity behind a debug path using exact/FTS/ranking snapshots.
- Add page-renderer mapping tests for authored and baseline pages before switching any visible route to SQLite.
- Keep the broad JSON/audio language-pack migration separate from this spike.

## Process Feedback

- NONE: Helper-backed claim, heartbeat, implementation validation, and review gates are working; the only validation wrinkle is unrelated dirty whitespace outside this task's write scope.
