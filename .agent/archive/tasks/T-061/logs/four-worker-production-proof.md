# Four-worker production proof

## Launch contract used
Each proof worker was launched with the shared opener:

```text
Read and execute:
E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt
```

The live proof batch also included a narrow scoping sentence so workers stayed inside their claimed queue task and did not edit T-061 directly.
These four runs used the launcher file at that path before the later pre-claim `SPEAKLOCAL_REVIEW_RUNTIME=subagents` hardening was added in response to the proof.
Queue-event timestamps for each proof worker:
- `Pascal` / `T-030`
  - claim: `2026-04-19T16:03:52.675392-05:00`
  - blocked finish: `2026-04-19T16:06:47.859078-05:00`
- `Confucius` / `T-031`
  - claim: `2026-04-19T16:04:01.386013-05:00`
  - blocked finish: `2026-04-19T16:11:10.863950-05:00`
- `Hume` / `T-032`
  - claim: `2026-04-19T16:04:15.382044-05:00`
  - blocked finish: `2026-04-19T16:10:34.786720-05:00`
- `Cicero` / `T-033`
  - claim: `2026-04-19T16:05:09.446354-05:00`
  - blocked finish: `2026-04-19T16:10:21.427638-05:00`

## Workers and outcomes
- `Pascal` (`019da78d-75e7-7b40-b1d5-64ddcd7f8d24`)
  - claimed task: `T-030`
  - finish state: `blocked`
  - evidence: `.agent/tasks/T-030/state.json`, `.agent/tasks/T-030/result.md`, `.agent/tasks/T-030/recovery-notes.md`, `.agent/tasks/T-030/logs/review-runtime-capability-check.md`
- `Confucius` (`019da78d-7a05-79c2-a759-e16aa6313007`)
  - claimed task: `T-031`
  - finish state: `blocked`
  - evidence: `.agent/tasks/T-031/state.json`, `.agent/tasks/T-031/result.md`
- `Hume` (`019da78d-7868-7d12-9253-64de6e64d9c0`)
  - claimed task: `T-032`
  - finish state: `blocked`
  - evidence: `.agent/tasks/T-032/state.json`, `.agent/tasks/T-032/result.md`, `.agent/tasks/T-032/logs/spawn-agent-surface-check.md`
- `Cicero` (`019da78d-7654-7d01-bbac-076f28aabb7c`)
  - claimed task: `T-033`
  - finish state: `blocked`
  - evidence: `.agent/tasks/T-033/state.json`, `.agent/tasks/T-033/result.md`

## Shared blocker
- All four workers claimed real meaningful tasks through the normal helper path.
- All four workers independently reported that their spawned worker runtime did not expose a callable `spawn_agent` surface.
- Because the meaningful-task contract requires 3 review gates with exactly 4 Codex subagents per gate, none of the four tasks could be completed honestly as `done`.

## Queue-event proof
- `T-030` claim and finish were recorded in `.agent/coordination/queue-events.jsonl`.
- `T-031`, `T-032`, and `T-033` claim events were recorded in `.agent/coordination/queue-events.jsonl`.
- `T-031`, `T-032`, and `T-033` blocked finish events were also recorded in `.agent/coordination/queue-events.jsonl`.
- The proof therefore demonstrates real live worker execution through the helper path, but it does not satisfy the T-061 definition of done because all four tasks ended `blocked`, not `done`.

## Conclusion
The hardening proof is real and production-shaped, but it falsified the final success criterion: this spawned worker runtime is still not a valid lane for meaningful queue work because nested review spawning is unavailable.
There is also no live worker evidence yet for the stricter post-proof launcher requirement that each worker explicitly confirm a callable `functions.spawn_agent` recipient before claim; that requirement was added after the four-worker run failed and is one reason T-061 remains blocked instead of done.
