APPROVED

No blocking findings in the requested launcher chain.

- `E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md:92-99` now uses plain `Invoke-SpeakLocalQueueTool claim-next ...` and explicitly says a runtime that cannot execute the real `3-gate / 4-subagent / unanimous` workflow must stop; it also says there is no downgrade mode and forbids inventing an alternate review mode.
- `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md:127-129` and `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md:227-241` carry the same rule at the desktop automation layer: block instead of skip/downgrade, no meaningful-task downgrade mode, and only a full-review `runtime-proof` task can bridge readiness.
- `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt:67-70` follows the standing rule literally: the shared launcher tells workers to run plain `claim-next`, and if the runtime cannot do the real `3-gate / 4-subagent / unanimous` workflow, it must stop because the lane has no downgrade mode.
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml:5` now points only to `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`, so the live automation entry inherits the hardened shared launcher instead of an older direct helper invocation.
- Literal token audit across the four inspected files found no remaining `--review-runtime` or `no-review-subagents` hits.

Residual scope note: this approval is limited to the requested queue-start, wrapper, and launcher surfaces; it did not re-audit `E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py`.
