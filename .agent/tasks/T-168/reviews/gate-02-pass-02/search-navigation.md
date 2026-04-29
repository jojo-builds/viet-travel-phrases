# Gate 2 Pass 2 - Search Navigation

Status: APPROVE

Reviewer lane: DEBUG runtime, search/detail navigation, and fallback behavior.

Evidence:
- SQLite runtime is DEBUG opt-in through `--use-sqlite-phrase-graph` or `SPEAKLOCAL_USE_SQLITE_GRAPH=1`.
- Search/detail hooks fall through to the existing generated JSON path when the SQLite switch is not enabled.
- Direct DB checks and simulator proof agree that `hello` opens `viet-phrase-polite-1` / `Xin chào` and related navigation opens `viet-phrase-polite-2` / `Cảm ơn`.
- Related rows route to canonical `phrase_page` IDs.

Validation cited by reviewer:
- Targeted SQLite tests passed 8 tests.
- `git diff --check` passed.
- Release simulator build had no SQLite runtime switch strings.
