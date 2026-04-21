# Rule-stripping audit

## Scope checked
- `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md`
- `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md`
- `E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py`
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md`
- active automation entry `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml`

## Commands
```powershell
Select-String -Path `
  'E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt',`
  'E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md',`
  'E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md',`
  'E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py',`
  'C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md' `
  -Pattern 'no-review-subagents|--review-runtime'
```

## Result
- No active queue-launch surfaces still advertise `no-review-subagents` or the old `--review-runtime` flag.
- The helper still contains the blocked-reason string `review-runtime-not-verified-in-worker-session`, but that is not a downgrade mode or an old launch flag.
- The shared automation entry now points directly to:
  - `Read and execute:`
  - `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`

## Hardening landed
- Startup surfaces now state there is no downgrade mode for meaningful queue work.
- The shared launcher prompt now requires an exact pre-claim check for a callable `functions.spawn_agent` recipient in the current worker session.
- Queue-start and automation guidance now require `SPEAKLOCAL_REVIEW_RUNTIME=subagents` in the same shell before meaningful `claim-next`.
- The helper now blocks meaningful claims when that current-shell affirmation is missing.

## Drift-override proof
- Broad-family startup drift no longer overrides the queue lane:
  - the shared launcher prompt says not to use `$orchestrate-speaklocal-family` during queue-run startup and to ignore that skill if it auto-loads anyway
  - the skill's queue-run exception says queue surfaces are the startup authority and explicitly forbids the broad family preflight for queue runs
- Automation-memory startup drift no longer overrides the queue lane:
  - the active automation entry points directly to the shared launcher prompt instead of free-form broad-family instructions
  - the shared launcher prompt explicitly says not to read automation `memory.md` during normal queue execution unless debugging a runner failure

## Conclusion
The old no-review downgrade path is no longer present as an operational queue-start, helper, skill, or automation instruction.
