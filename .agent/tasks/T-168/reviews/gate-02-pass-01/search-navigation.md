# Gate 2 Pass 1 - Search Navigation

Status: APPROVE

Reviewer lane: DEBUG runtime switch, search/detail navigation, and fallback behavior.

Findings:
- SQLite runtime is opt-in through `--use-sqlite-phrase-graph` or `SPEAKLOCAL_USE_SQLITE_GRAPH=1`.
- Release/default behavior falls back to the existing JSON-backed path.
- Simulator proof exercises Home/Search -> SQLite result/detail -> related page -> back/forward with the SQLite flag enabled.
- No blocker found.
