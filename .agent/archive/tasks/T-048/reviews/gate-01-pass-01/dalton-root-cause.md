APPROVE

- Root cause is broader than stale-lock recovery alone.
- The active duplicate automation entry is still stale and still authoritative in practice.
- `task-queue-10-2` memory shows both `queue-index.json` replace failure and `queue-events.jsonl` append failure.
- Current plan sequence is sound if it explicitly treats automation authority and coordination write-path hardening as mandatory root-cause work.

Reviewer note:
- Stale-lock involvement should be proven or falsified instead of assumed primary.
- Live proof after repair should run through the single authoritative automation posture, not just manual helper commands.
