BLOCK

- Dry-run still depends on shared event-log writes that can raise `PermissionError`.
- Claim/heartbeat/finish can still crash after partial state mutation because `main()` does not catch `OSError`.
- Failed atomic replace attempts currently leave `.tmp` residue under `.agent/coordination/`.
- Malformed lock metadata can be treated as dead-owner state too aggressively.

Reviewer note:
- Production-ready proof needs forced-denial testing for event append and queue-index replacement.
- Temp-file cleanup and safer lock-owner validation belong in scope before readiness claims.
