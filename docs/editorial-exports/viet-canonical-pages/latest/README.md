# Viet Canonical Pages Editorial Export

This folder is a Google-Sheet-ready editorial staging export for the current Viet canonical page universe.

The repo remains the source of truth. Do not hand-edit generated runtime resources from Sheet feedback; approved rows should be imported back into source-owned files, then generators should rebuild JSON, SQLite, and practice artifacts.

## Files

- `pages.csv`: one row per canonical page, with page/phrase IDs, page kind metadata, current copy, tags, source location, audio state, audit flags, and blank review/import columns.
- `sections.csv`: one row per page section for section-level rewrite review.
- `breakdowns.csv`: one row per breakdown token/label.
- `phrase-rows.csv`: one row per visible phrase row inside sections.
- `relationships.csv`: one row per canonical relation edge.
- `import-contract.md` and `import-contract.json`: design-only import contract for a future approved-row importer.
- `manifest.json`: row counts and export metadata.

## Current Counts

- Pages: 3038
- Sections: 21883
- Breakdown rows: 11254
- Visible phrase rows: 32013
- Relationship rows: 27949
- Flagged pages: 0

## Regenerate

```bash
node native-ios/scripts/export-viet-editorial-review.js
node native-ios/scripts/export-viet-editorial-review.js --check
```
