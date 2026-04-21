APPROVE

- The mutex serializer now has correct Win32 signatures and explicit `WAIT_FAILED` handling.
- Stale-main cleanup remains serialized and meaningful-task gating is unchanged.
- No remaining critical implementation finding.
