# Gate 02 Pass 03 - Jason

Status: APPROVE

The live patch now cleanly removes the stale startup path: the queue-facing surfaces suppress `$orchestrate-speaklocal-family`, suppress `memory.md`, require canonical-root normalization, and replace direct `py .agent\queue_tool.py ...` launch guidance with `Invoke-SpeakLocalQueueTool`.

`task-queue-10\automation.toml` matches that flow, while the skill surfaces are narrowed to non-queue orchestration instead of being broadly disabled.

`canonical-root-proof.md` and `result.md` also show the live wrapper now drives the real helper through the canonical root from the alias workspace, including the canonical-only retry override that closes the degraded-write edge.
