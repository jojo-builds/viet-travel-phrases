# Gate 3 Pass 1: Future Swift Read-Path Review

Gate: migration readiness
Reviewer lane: future Swift read path
Judgment: blocked.

Positive findings:
- The schema/report/generator preserve current JSON-backed runtime behavior.
- `phrase` / `phrase_page` / `page_alias` boundaries are clean.
- Authored sections/items are exposed.
- FTS search rows are included.
- SQLite queries returned `919` phrase pages, `920` aliases, `1304` sections, `2083` section items, `0` invalid phrase targets, and `0` invalid breakdown targets.
- `PRAGMA integrity_check` is reported as `ok`.

Blocking issue:
- The generated SQLite file is not actually bundle-addressable for the next debug-gated Swift read-only repository.
- The generator writes the database under `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`, and the report describes that as the fixture output.
- `native-ios/project.yml` explicitly excludes `LanguagePacks` from app resources.
- `native-ios/Resources/LanguagePacks/README.md` says the `LanguagePacks/<language>/` migration still requires XcodeGen resource-rule updates in a coordinated task.
- The next Swift repository cannot simply open the claimed bundled fixture via `Bundle.main` without first changing resource packaging.

Approval: BLOCK
