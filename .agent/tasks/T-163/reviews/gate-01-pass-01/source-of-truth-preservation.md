# Gate 1 Pass 1: Source-Of-Truth Preservation Review

Gate: schema and identity
Reviewer lane: source-of-truth preservation
Judgment: approve.

Evidence:
- Candidate changes are confined to allowed T-163 surfaces: `native-ios/scripts/**`, `native-ios/Resources/LanguagePacks/viet/**`, and `.agent/tasks/T-163/**`.
- No Swift runtime files or existing root Viet JSON resources show as modified.
- The generator reads the root JSON sources and schema, records their hashes in the report, and emits SQLite/report artifacts as compiled outputs.
- The report explicitly says the native Swift runtime still reads existing root-level JSON resources.
- SQLite checks passed: `PRAGMA integrity_check` returned `ok`.
- Counts match `18` scenarios, `900` clusters, `919` phrases, `919` pages, `920` aliases, `1304` sections, and `2083` section items.
- Empty `phrase_relation` and practice tables are schema-ready but unpopulated, which is honest for this gate.

Caveat:
- The worktree also contains unrelated T-162/design dirty files. These are not T-163 candidate output and must remain out of the T-163 commit.

Approval: APPROVE
