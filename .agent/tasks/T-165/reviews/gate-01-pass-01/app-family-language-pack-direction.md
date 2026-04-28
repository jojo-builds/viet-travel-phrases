# Gate 1 Pass 1: App-Family Language-Pack Direction Review

No blocking findings for Gate 1.

The docs clearly preserve the boundary: SQLite is bundled/readable for the debug spike, while production still reads root JSON resources in `docs/APP_FAMILY_STRUCTURE.md` and `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`. The implementation matches: `project.yml` excludes `LanguagePacks` from broad resource copying, then includes it intentionally as a folder resource; the Swift repository is `#if DEBUG` and opens with `SQLITE_OPEN_READONLY`. Existing live loaders still read root JSON in `GeneratedVietContent.swift`, `AuthoredVietListingPages.swift`, and `AudioAssetManifest.swift`.

Approval: APPROVE
