# Gate 2 Pass 1: Swift API/Design Review

No blocking findings.

The Swift spike is small and debug-gated: `VietSQLiteLanguagePackRepository.swift` is entirely under `#if DEBUG`, opens SQLite with `SQLITE_OPEN_READONLY`, verifies `sqlite3_db_readonly`, exposes only bundle lookup, integrity/count checks, and one phrase preview mapper. It is inspectable and does not appear wired into app runtime; search found only test usage.

The mapping stays pointed at existing concepts: the preview produces `PhraseCatalogItem` and `PhraseSearchResult` from a single representative phrase, while `PhrasePage.swift` remains the existing model surface. `project.yml` includes `Resources/LanguagePacks` as a resource folder and adds `libsqlite3.tbd`; broad `Resources` still excludes `LanguagePacks`, so it avoids duplicating that folder through the generic resource entry.

Approval: APPROVE
