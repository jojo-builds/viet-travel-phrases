# Gate 2 Pass 1: SQLite Integrity/Schema Review

Gate: generator and validation
Reviewer lane: SQLite integrity/schema
Judgment: approve.

Evidence:
- The generated database opens with `sqlite3`.
- `PRAGMA integrity_check` returns `ok`.
- `PRAGMA foreign_key_check` returns no rows.
- Sampled required-reference checks returned `0` bad refs.
- Required coverage is present: `language_pack` `1`, `scenario` `18`, `phrase` `919`, `phrase_page` `919`, `page_alias` `920`, `phrase_cluster` `900`, `phrase_cluster_member` `919`, `page_section` `1304`, `page_section_item` `2083`, `search_document` `919`, and `search_document_fts` `919`.
- FTS is populated and searchable; a `passport` MATCH query returned expected phrase-page rows.
- Constraints are reasonable for this first fixture: primary keys, uniqueness, not-null required fields, foreign keys for concrete refs, and honest unpopulated relation/practice tables.

Non-blocking note:
- Polymorphic fields like `page_section_item.target_id`, `audio_usage.target_id`, and `phrase_relation.source_id`/`target_id` are not FK-enforced. This is acceptable for the initial read-model fixture and is partly covered by generator/report validation.

Approval: APPROVE
