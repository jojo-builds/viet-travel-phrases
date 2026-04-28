# T-163 Result: Build SQLite Schema And Viet Fixture Generator

## Status

done

## Summary

Built the first deterministic Vietnam SQLite fixture beside the current JSON resources. The native app runtime remains JSON-backed; this task only adds the schema, generator, generated fixture, validation report, task review artifacts, and a small SQLite-plan implementation note.

Packaging note: `native-ios/project.yml` still excludes `LanguagePacks`, so the generated fixture is not yet app-bundle-addressable through `Bundle.main`. The validation report records this as `bundlePackaging.status: generated-not-bundled`; a follow-up Swift read-path task must update XcodeGen resource rules before using the fixture as a bundled resource.

## Files Changed

- `.agent/tasks/T-163/result.md`
- `.agent/tasks/T-163/reviews/gate-01-pass-01/*.md`
- `.agent/tasks/T-163/reviews/gate-02-pass-01/*.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- `native-ios/scripts/generate-viet-sqlite-fixture.js`
- `native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `native-ios/scripts/sqlite/001_initial.sql`

## Schema And Generator Decisions

- SQLite is a compiled offline read model, not an authoring surface.
- `phrase` is the atomic learner-facing unit; every catalog phrase gets one canonical `phrase_page`.
- Current `family` maps to `phrase_cluster`; legacy family page IDs become `page_alias` rows instead of competing page identity.
- Authored page IDs and section `detailPageID` references resolve through canonical phrase pages or aliases.
- Search is represented by `search_document` plus FTS5 for the first fixture.
- Audio manifest entries become `audio_asset`; renderable phrase/page/breakdown references become `audio_usage`; exact normalized text dedupe is captured in `audio_text_dedupe`; current missing-audio audit is empty because all checked usages resolve.
- `phrase_relation`, `practice_deck`, and `practice_item` tables are schema-ready but intentionally unpopulated in this fixture step.
- Deterministic metadata uses source hashes instead of wall-clock timestamps, and the generator recreates the database from scratch.

## Generated Counts

- `18` scenarios
- `900` phrase clusters / source families
- `919` phrases
- `919` canonical phrase pages
- `920` page aliases
- `1304` page sections
- `2083` page section items
- `720` breakdown tokens
- `919` search documents and `919` FTS rows
- `3756` audio assets
- `3165` audio usages
- `2343` audio text dedupe rows
- `0` missing-audio audit rows
- Bundle packaging audit: `generated-not-bundled`; `native-ios/project.yml` must include `LanguagePacks` before Swift can open the fixture from `Bundle.main`.

Report findings:

- `163/163` authored pages are covered by canonical phrase pages or explicit aliases.
- `0` unresolved `detailPageID` references.
- `3` authored phrase items are not catalog phrases and are preserved as `authored_phrase` section items: `how-are-you-anh`, `how-are-you-chi`, `how-are-you-em`.
- `6` duplicate normalized target-text groups are reported as canonical identity warnings.

## Validation

- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js` passed; the test runs the generator twice and verifies byte-for-byte stable database/report hashes.
- `sqlite3 native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite "PRAGMA integrity_check;"` returned `ok`.
- `python3 -m json.tool native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json >/tmp/speaklocal-viet-report.json` passed.
- `git diff --check` passed before Gate 3.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy` passed with `status: ok` and no changes.

## Review Gates

- Gate 1, schema and identity: latest pass `gate-01-pass-01`, 4/4 approvals.
- Gate 2, generator and validation: latest pass `gate-02-pass-01`, 4/4 approvals.
- Gate 3, migration readiness: pass 1 had 3/4 approvals and one block on unreported bundle packaging state; pass 2 latest pass `gate-03-pass-02`, 4/4 approvals after adding the deterministic packaging audit/report/result note.

## Remaining Risks

- Polymorphic references such as `page_section_item.target_id` and `audio_usage.target_id` are validated by generator/report logic, not database foreign keys.
- Relation and practice tables exist but are not populated yet.
- The `3` authored relationship-form rows not in the catalog should be resolved by a future content graph cleanup if they need full phrase identity.
- `native-ios/project.yml` currently excludes `LanguagePacks`, so the fixture is generated at the future language-pack path but not included in the app bundle yet.
- Current app behavior is intentionally unchanged; Swift read-path work remains a separate follow-up.

## Recommended Next Task

Update XcodeGen resource rules so `Resources/LanguagePacks/viet/speaklocal-viet.sqlite` is bundle-addressable, then add a debug-gated Swift read-only repository spike that maps selected rows back to existing Swift model contracts while keeping JSON as the default runtime path.

## Process Feedback

- NONE: Helper-backed claim, heartbeat, review, and validation flow worked for this task.
