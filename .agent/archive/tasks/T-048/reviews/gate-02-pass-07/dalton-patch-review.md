APPROVE

- The final mutex wait fix separates `WAIT_FAILED` from `WAIT_TIMEOUT`.
- The stale-main cleanup path still serializes deletion under the mutex and revalidates metadata before unlink.
- No remaining critical implementation finding.
