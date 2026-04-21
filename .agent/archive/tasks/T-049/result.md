# Result: T-049

## Status
- done

## Truth changed
- live

## Changed files
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\SKILL.md` - narrowed the skill to non-queue work and made queue runs ignore broad-family preflight and automation memory by default.
- `C:\Users\Administrator\.codex\skills\orchestrate-speaklocal-family\agents\openai.yaml` - narrowed the auto-load description and default prompt to non-queue orchestration only.
- `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt` - made queue startup explicitly suppress the broad family skill, avoid automation memory, and use the canonical helper wrapper.
- `E:\AI\SpeakLocal-App-Family\.agent\QUEUE_START.md` - made queue-start authority explicit and replaced direct helper commands with the canonical wrapper.
- `E:\AI\SpeakLocal-App-Family\.agent\AUTOMATION.md` - aligned the queue rules with the canonical wrapper and queue-only startup authority.
- `C:\Users\Administrator\.codex\automations\task-queue-10\automation.toml` - kept the active runner on canonical cwd, removed direct helper examples, and pointed it at the documented wrapper flow.
- `C:\Users\Administrator\.codex\automations\task-queue-10\memory.md` - marked automation memory as debug-only rather than queue-start authority.
- `C:\Users\Administrator\.codex\automations\task-queue-10-3\automation.toml` - retired the duplicate stale automation entry and paused it.
- `C:\Users\Administrator\.codex\automations\task-queue-10-3\memory.md` - recorded that the duplicate runner is retired and not startup authority.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\state.json` - moved the task into active verification and then final done state.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\logs\root-cause.md` - recorded the proven multi-surface trigger path.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\logs\canonical-root-proof.md` - recorded canonical-root wrapper proof from the alias workspace.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\logs\unsupported-runtime-proof.md` - recorded the bounded unsupported-runtime no-task proof.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\logs\meaningful-capable-proof.md` - recorded the meaningful-capable dry-run proof.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\logs\alias-path-safety.md` - recorded both ordinary-flow and degraded-retry alias-path safety proof.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\reviews\gate-01-pass-03\**` - recorded unanimous root-cause approval on the final precise package.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\reviews\gate-02-pass-03\**` - recorded unanimous patch approval on the live wrapper shape.
- `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\reviews\gate-03-pass-02\**` - recorded unanimous verification approval on the final evidence set.

## Validation
- `Get-Content -Raw 'C:\Users\Administrator\.codex\.codex-global-state.json'` - passed; confirmed the desktop config still retains `E:\AI\Viet-Travel-Phrases` as a compatibility workspace surface even though the current active root is back on `E:\AI\SpeakLocal-App-Family`.
- `@' ... runpy.run_path(r'E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py') ... '@ | py -` - passed; confirmed direct helper launch still resolves to alias paths without the wrapper.
- `Get-ChildItem 'E:\AI\SpeakLocal-App-Family\.agent' -Recurse -File | Where-Object { $_.FullName -match '\\(CODEX_DESKTOP_AUTOMATION_PROMPT\.txt|QUEUE_START\.md|AUTOMATION\.md)$' } | Select-String -Pattern 'replace_with_retry|_canonical_replace_with_retry'` - passed; confirmed the live queue surfaces all ship the same canonical-only degraded retry override.
- `Get-ChildItem 'E:\AI\SpeakLocal-App-Family\.agent' -Recurse -File | Select-String -Pattern 'py \.agent\\queue_tool\.py|Invoke-SpeakLocalQueueTool'` - passed; confirmed the queue-facing startup surfaces now hand out the wrapper instead of direct helper commands.
- `Set-Location 'E:\AI\Viet-Travel-Phrases'; Invoke-SpeakLocalQueueTool claim-next --dry-run --review-runtime no-review-subagents --session-id 't049-doc-wrapper-unsupported' --label 'T-049 documented unsupported proof'` - passed; returned structured `no_task` with ineligible meaningful-task evidence.
- `Set-Location 'E:\AI\Viet-Travel-Phrases'; Invoke-SpeakLocalQueueTool claim-next --dry-run --review-runtime meaningful-capable --session-id 't049-doc-wrapper-meaningful' --label 'T-049 documented meaningful proof'` - passed; surfaced meaningful task `T-030` as `dry-run-claimable`.
- `Set-Location 'E:\AI\Viet-Travel-Phrases'; Invoke-SpeakLocalQueueTool repair` - passed; real mutation path completed cleanly from alias cwd with canonical-root override active.
- `Set-Location 'E:\AI\Viet-Travel-Phrases'; @' ... forced canonical replace failure through ns["replace_with_retry"] ... '@ | py -` - passed; degraded retry stayed on the canonical lexical destination and never fell back to the alias-spelled destination.

## Notes
- The exact root cause was a combination: duplicate automation authority, automation-memory drift, broad skill trigger shape, retained alias compatibility context, and direct relative helper launch guidance.
- The skill was not removed globally. It was narrowed so non-queue SpeakLocal orchestration still works while queue runs now ignore it by default.
- The active queue runner is now `task-queue-10`; `task-queue-10-3` is retained only as a paused retired duplicate so the stale surface is explicit instead of silently lingering.
- The queue helper itself was not edited in this task. The durable in-scope fix was to make the shared prompt and queue docs use a canonical wrapper before `main()` runs, plus a canonical-only retry override for degraded writes.
- The wrapper is intentionally duplicated in the queue surfaces because those files are the startup authority for disposable automation clones.

## Blockers
- None.

## Reviews
- `.agent/tasks/T-049/reviews/gate-01-pass-03/`
- `.agent/tasks/T-049/reviews/gate-02-pass-03/`
- `.agent/tasks/T-049/reviews/gate-03-pass-02/`

## Logs
- `.agent/tasks/T-049/logs/root-cause.md`
- `.agent/tasks/T-049/logs/canonical-root-proof.md`
- `.agent/tasks/T-049/logs/unsupported-runtime-proof.md`
- `.agent/tasks/T-049/logs/meaningful-capable-proof.md`
- `.agent/tasks/T-049/logs/alias-path-safety.md`

## Process feedback
- BUG: stale prior-pass artifacts inside `T-049/reviews/` and `T-049/result.md` made it easy to misread which review pass was actually authoritative.
- SUGGESTION: keep the canonical queue wrapper in one repo-owned snippet and reference it from the prompt/docs, so future launcher hardening does not need synchronized edits in multiple startup surfaces plus proof artifacts.

## Recommended next step
Future disposable automation clones should point at `E:\AI\SpeakLocal-App-Family\.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`, keep their cwd on `E:\AI\SpeakLocal-App-Family` when possible, and follow the documented `Invoke-SpeakLocalQueueTool` wrapper exactly. If helper internals become in-scope later, fold the canonical-root and degraded-retry behavior into `queue_tool.py` itself and then remove the duplicated wrapper text from the queue surfaces.
