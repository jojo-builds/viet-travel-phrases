# Parallel Claim Interruption Evidence

## Why this file exists
Batch 2 included one failed concurrent proof-task claim attempt. T-048 requires exact command, traceback/error text, and relevant queue-events evidence when a helper failure happens during verification.

## Failed command
```text
py .agent\queue_tool.py claim-next --session-id "t048-b2-jason" --label "T-048 proof burn-in batch 2" --review-runtime no-review-subagents
```

## Exact traceback
```text
Traceback (most recent call last):
  File "E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py", line 318, in queue_mutation_lock
    fd = os.open(lock_path, os.O_CREAT | os.O_EXCL | os.O_WRONLY)
FileExistsError: [Errno 17] File exists: 'E:\\AI\\Viet-Travel-Phrases\\.agent\\coordination\\.queue-locks\\queue-mutation.lock'

During handling of the above exception, another exception occurred:

Traceback (most recent call last):
  File "E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py", line 1239, in <module>
    raise SystemExit(main(sys.argv[1:]))
                     ~~~~^^^^^^^^^^^^^^
  File "E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py", line 1215, in main
    return args.func(args)
           ~~~~~~~~~^^^^^^
  File "E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py", line 967, in command_claim_next
    with queue_mutation_lock(timeout_seconds=args.lock_timeout_seconds):
         ~~~~~~~~~~~~~~~~~~~^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
  File "C:\Users\Administrator\AppData\Local\Programs\Python\Python313\Lib\contextlib.py", line 141, in __enter__
    return next(self.gen)
  File "E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py", line 357, in queue_mutation_lock
    time.sleep(0.25)
    ~~~~~~~~~~^^^^^^
KeyboardInterrupt
```

## Queue-events evidence
- `Select-String` for `t048-b2-jason` returned no matches in `.agent/coordination/queue-events.jsonl`.
- The nearest durable events show the other three concurrent claims succeeding and then heartbeating/finishing normally:

```json
{"timestamp": "2026-04-19T11:47:02.129042-05:00", "event": "claim-next-claimed", "taskId": "T-054", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b2-dalton", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:47:04.401875-05:00", "event": "claim-next-claimed", "taskId": "T-055", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b2-rawls", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:47:09.912948-05:00", "event": "claim-next-claimed", "taskId": "T-056", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b2-harvey", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:47:16.543553-05:00", "event": "heartbeat", "taskId": "T-054", "sessionId": "t048-b2-dalton", "phase": "proof-artifacts-writing"}
{"timestamp": "2026-04-19T11:47:22.647394-05:00", "event": "heartbeat", "taskId": "T-056", "sessionId": "t048-b2-harvey", "phase": "proof-run-documenting"}
{"timestamp": "2026-04-19T11:47:28.845475-05:00", "event": "heartbeat", "taskId": "T-055", "sessionId": "t048-b2-rawls", "phase": "writing-proof-artifacts"}
{"timestamp": "2026-04-19T11:47:46.801756-05:00", "event": "finish", "taskId": "T-054", "sessionId": "t048-b2-dalton", "state": "done", "phase": "completed", "blockers": []}
{"timestamp": "2026-04-19T11:47:49.541851-05:00", "event": "finish", "taskId": "T-056", "sessionId": "t048-b2-harvey", "state": "done", "phase": "completed", "blockers": []}
{"timestamp": "2026-04-19T11:48:02.925176-05:00", "event": "finish", "taskId": "T-055", "sessionId": "t048-b2-rawls", "state": "done", "phase": "completed", "blockers": []}
```

## Assessment
- This failed attempt did not corrupt queue state.
- Three parallel peers completed normally in the same burst.
- Because the failed run did not produce a pass, T-060 was added as a bounded buffer proof task so T-048 could still reach at least 10 successful end-to-end passes honestly.

## Clean rerun after the interruption
- The same four-worker bounded-parallel scenario was rerun in Batch 3 after adding `T-060`.
- All four workers then returned through the structured helper path and finished cleanly:

```json
{"timestamp": "2026-04-19T11:50:03.957097-05:00", "event": "claim-next-claimed", "taskId": "T-057", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b3-jason", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:50:06.597437-05:00", "event": "claim-next-claimed", "taskId": "T-058", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b3-rawls", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:50:08.748130-05:00", "event": "claim-next-claimed", "taskId": "T-059", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b3-dalton", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:50:09.185395-05:00", "event": "claim-next-claimed", "taskId": "T-060", "claimGroup": "queued", "taskClass": "proof", "proofTask": true, "sessionId": "t048-b3-harvey", "skippedIneligible": []}
{"timestamp": "2026-04-19T11:50:41.602174-05:00", "event": "finish", "taskId": "T-057", "sessionId": "t048-b3-jason", "state": "done", "phase": "completed", "blockers": []}
{"timestamp": "2026-04-19T11:50:48.942119-05:00", "event": "finish", "taskId": "T-058", "sessionId": "t048-b3-rawls", "state": "done", "phase": "completed", "blockers": []}
{"timestamp": "2026-04-19T11:50:52.727233-05:00", "event": "finish", "taskId": "T-060", "sessionId": "t048-b3-harvey", "state": "done", "phase": "completed", "blockers": []}
{"timestamp": "2026-04-19T11:50:54.093214-05:00", "event": "finish", "taskId": "T-059", "sessionId": "t048-b3-dalton", "state": "done", "phase": "completed", "blockers": []}
```

- Jason was the worker tied to the interrupted Batch-2 attempt, and his Batch-3 rerun succeeded cleanly on `T-057`.
- The interrupted attempt is therefore retained as honest failed verification evidence, but it did not reproduce on the next four-worker live burst.
