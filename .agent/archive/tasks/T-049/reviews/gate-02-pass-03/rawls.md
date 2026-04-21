# Gate 02 Pass 03 - Rawls

Status: APPROVE

The live patch now cleanly removes both stale queue-start drift and direct helper-launch dependence: the queue surfaces and `task-queue-10/automation.toml` all suppress `$orchestrate-speaklocal-family`, suppress `memory.md`, require canonical cwd, and require `Invoke-SpeakLocalQueueTool` instead of direct `py .agent\queue_tool.py ...` launches.

`canonical-root-proof.md` shows the live wrapper matches the shipped docs, rewrites the helper globals back to `E:\AI\SpeakLocal-App-Family`, and successfully runs a real `repair` from the alias workspace.

Queue safety is still preserved because the wrapper enters the helper’s normal `main()` path, keeps the existing claim/heartbeat/finish/retry rules intact, and the non-queue skill behavior remains available but explicitly out of scope for queue runs.
