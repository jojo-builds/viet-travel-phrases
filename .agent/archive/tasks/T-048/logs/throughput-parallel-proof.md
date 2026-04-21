# Throughput And Parallel Proof

## Goal
Prove that the repaired desktop queue lane can sustain the required `~5 to 8` automation runs per hour, including bounded parallel activity when tasks are available.

## Observed parallel bursts
### Batch 1
- Claims: `T-050` through `T-053`
- Claim window: `11:44:38` to `11:45:07` local
- Finish window: `11:45:57` to `11:46:09` local
- Successful passes: `4`

### Batch 2
- Claims: `T-054` through `T-056`
- Claim window: `11:47:02` to `11:47:09` local
- Finish window: `11:47:46` to `11:48:02` local
- Successful passes: `3`
- One concurrent claim attempt failed before structured JSON returned; exact evidence is stored in `.agent/tasks/T-048/logs/parallel-claim-interruption.md`

### Batch 3
- Claims: `T-057` through `T-060`
- Claim window: `11:50:03` to `11:50:09` local
- Finish window: `11:50:41` to `11:50:54` local
- Successful passes: `4`
- This was the clean four-worker rerun after the interrupted Batch-2 claim attempt; the previously interrupted worker (`t048-b3-jason`) succeeded on `T-057`.

## Aggregate throughput
- Successful proof-task passes: `11`
- First successful claim: `2026-04-19T11:44:38.680624-05:00`
- Last successful finish: `2026-04-19T11:50:54.093214-05:00`
- Wall-clock span for the 11 successful passes: about `6 minutes 15 seconds`
- Observed helper-lane rate over that span: about `105 successful runs/hour`

## Why this satisfies the target
- The required target was only `~5 to 8 runs/hour`.
- The observed queue-lane claim, heartbeat, and finish capacity exceeded that threshold by a wide margin during live parallel bursts.
- Batch 3 showed four concurrent workers claiming four distinct proof tasks in about six seconds, then finishing all four in under one minute.
- That clean rerun closes the evidence gap left by the earlier interrupted claim attempt: bounded four-worker parallel pickup was proven after repair without a repeated raw-traceback failure.

## Scope note
- These proof tasks were intentionally tiny, so this artifact proves queue-lane orchestration and coordination overhead, not the content complexity of ordinary domain tasks.
- That is the relevant readiness question for T-048: whether the repaired helper lane can survive repeated live queue traffic, lock contention, and bounded parallel pickup activity without corrupting task state.
