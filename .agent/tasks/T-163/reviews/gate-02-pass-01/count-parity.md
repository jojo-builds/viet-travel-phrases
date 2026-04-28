# Gate 2 Pass 1: Count Parity Review

Gate: generator and validation
Reviewer lane: count parity
Judgment: count parity passes.

Evidence:
- Core parity matches: `18` scenarios, `900` source families/clusters, `919` phrases, and `163` authored pages-or-aliases.
- SQLite counts match meaningful generated surfaces: `919` pages, `920` aliases, `1304` sections, `2083` section items, `919` search documents and FTS rows, `3756` audio assets, `3165` audio usages, `2343` audio dedupe rows, and `0` missing-audio audit rows.
- `PRAGMA integrity_check` returned `ok`.
- `PRAGMA foreign_key_check` returned no rows.
- Source authored sections/items match the generated counts.
- Search rows point at existing pages.
- Audio usage rows point at existing assets.
- Section phrase/breakdown targets are internally consistent.

Non-blocking note:
- The report discloses `3` authored phrase items not in the catalog. They are represented as `authored_phrase` rows/items and do not break the Gate 2 count-parity focus.

Approval: APPROVE
