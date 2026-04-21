# Gate 02 Pass 03 - Harvey

Status: APPROVE

The live patch now cleanly removes stale queue-start drift: the queue surfaces suppress `$orchestrate-speaklocal-family`, suppress `memory.md` during normal runs, require canonical cwd normalization, and the skill metadata is explicitly non-queue only.

It also removes direct helper-launch dependence in the published startup path by replacing `py .agent\queue_tool.py ...` with `Invoke-SpeakLocalQueueTool` across the queue prompt, queue docs, and active runner.

`canonical-root-proof.md` and `alias-path-safety.md` now certify the same live wrapper shape, including the canonical-only degraded retry behavior, so I do not see a remaining blocking safety drift in the current patch surface.
