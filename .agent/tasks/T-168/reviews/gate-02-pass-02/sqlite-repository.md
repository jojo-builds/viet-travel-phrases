# Gate 2 Pass 2 - SQLite Repository

Status: APPROVE

Reviewer lane: SQLite repository/read model.

Evidence:
- Search/ranking, page/alias and phrase-ID canonical lookup, article section rendering, relation edges, and visible audio usages are covered by the Swift read model.
- The previous authored-phrase audio blocker is fixed: `authored_phrase` joins now populate visible row audio keys, and `testSQLiteAuthoredPhraseRowsKeepVisibleAudioKeys` covers `viet-phrase-smalltalk-7`.
- SQLite remains read-only/offline through the bundled fixture.

Validation cited by reviewer:
- `xcodebuild test ... -only-testing:SpeakLocalNativeTests/SQLiteLanguagePackRepositoryTests` passed 8 tests.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` passed with 919 source phrases, 911 canonical pages, 919 resolved phrases, 919 search docs, 3,438 relations, and 0 missing-audio audit rows.
