# T-040 Result

## Summary
Completed the proof-canary audit of the desktop automation entry surfaces against the repo queue docs and helper behavior.

## What changed
- Wrote `.agent/tasks/T-040/logs/automation-entry-sync.md` with the audit evidence.

## Findings
- Found real drift in the claim command shown by `.agent/CODEX_DESKTOP_AUTOMATION_PROMPT.txt` and `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`.
- Repo queue docs require the desktop-safe claim form with `--review-runtime no-review-subagents` for this runtime.
- Stop conditions and crash/claim troubleshooting guidance were otherwise aligned.

## Verification
- Read the required repo docs, prompt, automation entry, and helper implementation.
- Confirmed `queue_tool.py` supports `--review-runtime` and enforces runtime eligibility.
- Confirmed the task-local audit log exists at the required path.

## Remaining work
- Main orchestrator should update the shared prompt and cron automation entry surfaces to carry the runtime-gated claim command.

## Process feedback
SUGGESTION: keep the live repo prompt text and the external automation.toml prompt sourced from one canonical template, or add a small parity check, so claim-command drift does not reappear.
