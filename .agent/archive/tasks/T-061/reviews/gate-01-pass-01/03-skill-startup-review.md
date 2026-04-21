APPROVED

- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md:16` and `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\agents\openai.yaml:4` fence `$orchestrate-speaklocal-family` to non-queue work and defer queue runs to the repo-local queue surfaces.
- `E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md`, `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`, and `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md` all say queue workers must not run broad family startup and must stop, not downgrade, if the runtime cannot satisfy the real `3-gate / 4-subagent / unanimous` review contract.
- `E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py` no longer advertises a `--review-runtime` argument, and `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml:5` points only to the shared launcher prompt.

Residual non-blocking drift: `E:\AI\SpeakLocal-App-Family\.agent\README.md:33` still says workers should use direct `py .agent\queue_tool.py`, while `QUEUE_START.md` and `AUTOMATION.md` require `Invoke-SpeakLocalQueueTool`. That inconsistency did not reopen the old downgrade posture or weaken the full-subagent rule.
