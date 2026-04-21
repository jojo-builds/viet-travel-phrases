# Gate 2 review history

## Outcome
- Gate 2 passed unanimously on pass 7.

## Why it took multiple passes
- Pass 1 accepted the write-path hardening and automation retirement, but blocked on stale-lock cleanup deleting by path without compare-safe coordination.
- Passes 2 through 4 kept tightening stale-lock cleanup until the unsafe recovery-lock fallback was removed.
- Pass 5 switched stale cleanup serialization from a file-based recovery lock to a Windows named mutex so the cleanup serializer could not itself become another stale lock.
- Pass 6 fixed the 64-bit Win32 interop bug by declaring explicit `ctypes` signatures for the mutex APIs.
- Pass 7 split `WAIT_FAILED` from `WAIT_TIMEOUT`, so low-level mutex failure no longer gets mislabeled as normal contention.

## Final approved implementation themes
- Auxiliary coordination writes now degrade to structured warnings instead of tracebacks.
- Queue-index temp-file residue is cleaned after successful writes, and failed replace attempts clean up their temp file.
- Fresh malformed lock files are handled conservatively instead of being deleted blindly.
- Dead/stale main-lock cleanup is serialized under a Windows named mutex and still revalidates lock metadata before unlinking.
- Direct-task-contract tasks no longer get reclaimed by the queue helper.
- `task-queue-10` is the sole active authoritative automation entry.
- `task-queue-10-2` is an explicitly retired duplicate.
