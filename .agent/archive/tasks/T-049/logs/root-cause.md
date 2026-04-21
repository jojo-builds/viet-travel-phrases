# T-049 Root Cause Proof

## Verified facts

### 1. The queue helper binds its repo root from the script path

Source: `E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py`

Relevant code:

```py
SCRIPT_PATH = Path(__file__).resolve()
AGENT_ROOT = SCRIPT_PATH.parent
REPO_ROOT = AGENT_ROOT.parent
```

Every queue-helper write surface is derived from that resolved script location:

- `TASKS_ROOT = AGENT_ROOT / "tasks"`
- `INDEX_PATH = AGENT_ROOT / "coordination" / "queue-index.json"`
- `LOCK_ROOT = AGENT_ROOT / "coordination" / ".queue-locks"`
- `EVENT_LOG_PATH = AGENT_ROOT / "coordination" / "queue-events.jsonl"`

### 2. The supposed canonical repo path is a junction to the compatibility alias

Command:

```powershell
Get-Item 'E:\AI\SpeakLocal-App-Family','E:\AI\Viet-Travel-Phrases' | Format-List FullName,LinkType,Target,Attributes
```

Observed outcome:

- `E:\AI\SpeakLocal-App-Family` has `LinkType : Junction`
- its `Target` is `E:\AI\Viet-Travel-Phrases`
- `E:\AI\Viet-Travel-Phrases` is the physical directory

So a naive filesystem resolve does not preserve the operator-chosen canonical spelling.

### 3. Direct helper launch collapses through the alias even when invoked through the canonical path

Command:

```powershell
@'
from pathlib import Path
import runpy
for raw in [r'E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py', r'E:\AI\Viet-Travel-Phrases\.agent\queue_tool.py']:
    ns = runpy.run_path(raw)
    print(raw)
    print(f"SCRIPT_PATH={ns['SCRIPT_PATH']}")
    print(f"REPO_ROOT={ns['REPO_ROOT']}")
    print(f"EVENT_LOG_PATH={ns['EVENT_LOG_PATH']}")
    print('---')
'@ | py -
```

Observed outcome:

- both invocations reported `SCRIPT_PATH=E:\AI\Viet-Travel-Phrases\.agent\queue_tool.py`
- both invocations reported `REPO_ROOT=E:\AI\Viet-Travel-Phrases`
- both invocations reported `EVENT_LOG_PATH=E:\AI\Viet-Travel-Phrases\.agent\coordination\queue-events.jsonl`

This is direct proof that `Path(__file__).resolve()` collapses the canonical junction spelling back to the alias.

### 4. The retained bad-run evidence matches the path-binding failure

Source: `C:\Users\Administrator\.codex\automations\task-queue-10-3\memory.md`

Recorded outcomes on April 19, 2026:

- a run reported `queue-index-write-failed` and `event-log-write-failed` warnings pointing at `E:\AI\Viet-Travel-Phrases\.agent\coordination\...`
- a later run timed out on `E:\AI\Viet-Travel-Phrases\.agent\coordination\.queue-locks\queue-mutation.lock`
- those same entries also said the run believed it was executing from `E:\AI\SpeakLocal-App-Family`

That proves the alias-path warnings and stale-lock behavior did not require the run to *knowingly* stay in the alias; direct helper path binding was enough.

### 5. The shared queue launch surfaces were the right in-scope repair point

The task allowed writes to:

- `.agent\CODEX_DESKTOP_AUTOMATION_PROMPT.txt`
- `.agent\QUEUE_START.md`
- `.agent\AUTOMATION.md`

The task did **not** allow edits to `.agent\queue_tool.py`.

So the durable in-scope repair had to happen in the startup authority that launches the helper, not in the helper itself.

### 6. A prompt-side canonical wrapper is feasible from an alias-born shell

Command run from `E:\AI\Viet-Travel-Phrases`:

```powershell
@'
import importlib.util
import pathlib
import sys
repo_root = pathlib.Path(r"E:\AI\SpeakLocal-App-Family")
queue_tool_path = repo_root / ".agent" / "queue_tool.py"
spec = importlib.util.spec_from_file_location("speaklocal_queue_tool", queue_tool_path)
module = importlib.util.module_from_spec(spec)
sys.modules[spec.name] = module
spec.loader.exec_module(module)
module.SCRIPT_PATH = queue_tool_path
module.AGENT_ROOT = queue_tool_path.parent
module.REPO_ROOT = repo_root
module.TASKS_ROOT = module.AGENT_ROOT / "tasks"
module.INDEX_PATH = module.AGENT_ROOT / "coordination" / "queue-index.json"
module.LOCK_ROOT = module.AGENT_ROOT / "coordination" / ".queue-locks"
module.EVENT_LOG_PATH = module.AGENT_ROOT / "coordination" / "queue-events.jsonl"
module.RUNTIME_REVIEW_STATUS_PATH = module.AGENT_ROOT / "coordination" / "runtime-review-path.json"
print(f"REPO_ROOT={module.REPO_ROOT}")
print(f"INDEX_PATH={module.INDEX_PATH}")
print(f"LOCK_ROOT={module.LOCK_ROOT}")
print(f"EVENT_LOG_PATH={module.EVENT_LOG_PATH}")
raise SystemExit(module.main(["health"]))
'@ | py -
```

Observed outcome:

- `REPO_ROOT=E:\AI\SpeakLocal-App-Family`
- `INDEX_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-index.json`
- `LOCK_ROOT=E:\AI\SpeakLocal-App-Family\.agent\coordination\.queue-locks`
- `EVENT_LOG_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-events.jsonl`
- the helper still ran successfully and returned `health.repoRoot = "E:\\AI\\SpeakLocal-App-Family"`

That proved the fix could live in the shared prompt/docs layer without touching `queue_tool.py`.

## Ruled-out or unproven primary causes

- `automation memory.md` is corroborating evidence, not the primary cause. The direct `runpy` proof reproduces alias-root binding without using automation memory at all.
- stale broad-family startup drift is not required to reproduce the bug. The path collapse happens before any family-preflight decision matters.
- alias startup cwd may still be a practical trigger for bad runs when the prompt uses direct relative helper calls, but the retained `task-queue-10-3` evidence does not prove cwd was necessary. The stronger fact is that direct helper launch is unsafe even when the run believes it started from the canonical spelling.
- a simple "use the canonical path in the prompt" instruction is not sufficient because `Path(__file__).resolve()` still converts the canonical junction path back to the alias.

## Root cause statement

The bad `task-queue-10-3` behavior was caused by launch-time path binding:

1. `queue_tool.py` derives queue write, lock, and event paths from `Path(__file__).resolve()`,
2. `E:\AI\SpeakLocal-App-Family` is a junction whose resolved path is `E:\AI\Viet-Travel-Phrases`,
3. the shared queue launch surfaces were still invoking the helper directly instead of rebinding it to canonical lexical paths first.

So the proven primary cause is the helper's resolved-script path collapse, not stale automation memory or broad-family startup drift.

## Smallest durable in-scope fix chosen

Because this task could not edit `queue_tool.py`, the smallest durable repair inside scope was:

1. make the shared prompt the true startup authority by defining a canonical-root wrapper that loads `queue_tool.py`,
2. immediately override the module globals (`SCRIPT_PATH`, `AGENT_ROOT`, `REPO_ROOT`, `TASKS_ROOT`, `INDEX_PATH`, `LOCK_ROOT`, `EVENT_LOG_PATH`, `RUNTIME_REVIEW_STATUS_PATH`) to the canonical lexical root `E:\AI\SpeakLocal-App-Family`,
3. override `replace_with_retry` inside that wrapper so degraded write retries stay on the canonical lexical path instead of falling back through `destination.resolve()`,
4. update `QUEUE_START.md` and `AUTOMATION.md` to require that wrapper instead of direct helper calls,
5. keep the existing queue safety contract unchanged.

That fix is small, avoids out-of-scope helper edits, and removes dependence on automation cwd, stale automation memory, or broad-family startup drift for new disposable clones.

## Explicit verification required after patch

The wrapper prototype above proved the approach was feasible, but the final implementation still needed verification that:

1. the shared prompt and supporting docs use the same canonical wrapper for `claim-next`, `heartbeat`, and `finish`,
2. unsupported-runtime behavior still fails closed,
3. meaningful-capable dry run still surfaces eligible meaningful work,
4. an alias-born shell no longer routes ordinary queue writes and lock paths through `E:\AI\Viet-Travel-Phrases`,
5. the wrapper-local `replace_with_retry` override keeps degraded write retries on the canonical lexical path for the bounded verification flows used here.
