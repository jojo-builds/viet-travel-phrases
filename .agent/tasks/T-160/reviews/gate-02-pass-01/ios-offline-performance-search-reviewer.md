# Gate 2 Pass 1: iOS Offline Performance / Search Reviewer

No blocking findings.

The bundled read-only SQLite approach is sound: the plan keeps SQLite as generated runtime data, separates mutable progress into an app-container DB, and avoids writing into the bundled DB.

Search design is acceptable for offline iOS: exact fields plus FTS5 `unicode61 remove_diacritics 2` covers Vietnamese/accentless lookup, and the migration plan preserves current exact/priority/alias behavior verified in Swift search. The size/performance model is realistic for this stage: text/FTS remains manageable, audio is correctly treated as the dominant growth risk, and lazy open/prepared statements/indexing/device latency checks are called out.

Non-blocking note: implementation should make the accentless normalization deterministic in the generator and keep parity tests around exact Vietnamese vs accentless queries, since current Swift folding is locale-dependent. The validation gates are otherwise strong enough: count parity, alias/detail resolution, audio usage coverage, duplicate decisions, stable search IDs, page render smoke, repository tests, and simulator smoke are all listed.

Approval: APPROVE
