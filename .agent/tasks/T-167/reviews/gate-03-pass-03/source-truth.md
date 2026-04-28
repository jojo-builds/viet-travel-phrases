# Gate 3 Pass 3: Source Truth

Findings:

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` still carried a stale follow-up asking to add local saved/recent/practice-pool state and Home shelves already implemented by T-167.
- JSON/SQLite/LanguagePacks wording was otherwise aligned: production remains JSON-backed, T-165 is DEBUG-only bundled SQLite validation, and `LanguagePacks/viet` is no longer described as empty.

Required correction before approval: rewrite the follow-up to extend the T-167 store with practiced/missed/due/session-progress state and Practice UI/deck integration instead of duplicating T-167.

Approval: BLOCK
