# Gate 2 Pass 1: SQLite Safety/Read-Only Review

Findings: no blocking issues for Gate 2.

The SQLite path is debug-gated and only referenced by tests. It opens with `SQLITE_OPEN_READONLY | SQLITE_OPEN_NOMUTEX`, verifies `sqlite3_db_readonly(..., "main")`, and closes the handle in `deinit`.

Statements prepared through `withPreparedStatement` are finalized with `defer`. Open, prepare, bind, scalar step, empty-result, and missing-bundle errors are surfaced with typed errors.

Runtime write/WAL risk looks acceptable: `project.yml` bundles `Resources/LanguagePacks` intentionally, the report marks the fixture bundle-ready, runtime notes still keep JSON as production truth, and no bundled `-wal`, `-shm`, or `-journal` sidecars were found.

Minor non-blocking issue: `loadPhrasePreview` maps any non-`SQLITE_ROW` step result to `missingPreviewPhrase`, so a rare SQLite step error would be less precise there.

Approval: APPROVE
