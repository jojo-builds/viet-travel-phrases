# ChatGPT Batch 001 Import README

This folder is an editorial staging packet. It is not a source import and it does not change app content by itself.

## Later Import Flow

1. Jojo sends the packet or Google Sheet tabs to ChatGPT 5.5 Pro.
2. ChatGPT fills exact patch rows and keeps unresolved questions in `questions_for_jojo`.
3. If ChatGPT edits the Google Sheet, Codex exports the versioned `batch_001_*` tabs back into this repo packet.
4. Jojo approves a subset by setting `import_approval` to `APPROVED_FOR_IMPORT` in a future task.
5. Codex runs a dry-run import against only explicit approvals.
6. Codex validates no unresolved targets, no duplicate canonical pages, no internal/meta copy, no wrong-template leakage, and no unapproved import rows.
7. Codex writes source-owned files only, then regenerates and validates generated JSON, SQLite, and practice resources.

## Non-Import Defaults

- `review_status` defaults to `REVIEW_ONLY`.
- `import_approval` defaults to `REVIEW_ONLY`.
- Bà Nà Hills is a completed reference page for this batch.
- Audio/image generation is outside this batch.

## Google Sheet

- Spreadsheet: https://docs.google.com/spreadsheets/d/1mxsk9O6kuUhekBWhaNlbKH_n4innteBXtYZ4qmu1SOU/edit
- Batch backing spreadsheet: https://docs.google.com/spreadsheets/d/1nhomn1B9H8vNgCr9TntBAgxF5zvy37WZP_PImX79n4g/edit
- Old snapshot tabs must remain untouched.
- Batch tabs use the `batch_001_*` prefix.
