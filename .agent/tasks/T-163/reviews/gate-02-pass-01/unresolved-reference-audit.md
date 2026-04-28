# Gate 2 Pass 1: Unresolved-Reference/Audit Review

Gate: generator and validation
Reviewer lane: unresolved-reference/audit
Judgment: approve.

Evidence:
- The report lists `0` unresolved `detailPageID` refs.
- An independent source-to-SQLite check found `1212` detail refs, `161` distinct detail IDs, and `0` unresolved in `phrase_page`/`page_alias`.
- The report lists `3` authored phrase items not in catalog: `how-are-you-anh`, `how-are-you-chi`, `how-are-you-em`; all are preserved as `authored_phrase` section items.
- Duplicate/canonical warnings are not hidden: the report lists `6` duplicate normalized target-text groups, matching direct SQLite grouping.
- Audio mapping gaps are not silently hidden: independent source scan found `3165` audio candidates and `0` manifest/text mismatches.
- SQLite has `3756` audio assets, `3165` audio usages, and `0` orphan audio usages.
- Missing audio audit rows are honestly empty for current data: `missing_audio_audit` exists, the report says `0`, SQLite says `0`, and direct audio validation also says `0`.
- `PRAGMA integrity_check` returned `ok`; foreign key checks returned `0` rows.

Approval: APPROVE
