# T-049 Canonical Root Proof

## Goal

Demonstrate that the live documented wrapper can start from the compatibility alias and still drive the helper through the canonical repo root, including the canonical-only degraded retry override needed to avoid `destination.resolve()` alias collapse.

## Exact commands and outcomes

### 1. Confirm the live queue surfaces all ship the same canonical-only retry override

Command:

```powershell
Get-ChildItem 'E:\AI\SpeakLocal-App-Family\.agent' -Recurse -File |
  Where-Object { $_.FullName -match '\\(CODEX_DESKTOP_AUTOMATION_PROMPT\.txt|QUEUE_START\.md|AUTOMATION\.md)$' } |
  Select-String -Pattern 'replace_with_retry|_canonical_replace_with_retry'
```

Observed outcome:

- all three queue-start surfaces contain the same `_canonical_replace_with_retry` definition and `ns["replace_with_retry"] = _canonical_replace_with_retry`
- the live wrapper therefore intentionally keeps degraded write retries on the canonical lexical destination instead of falling back through `destination.resolve()`

### 2. Prove the wrapper rewrites the helper globals to the canonical lexical root

Working directory:

- `E:\AI\Viet-Travel-Phrases`

Command:

```powershell
@'
from pathlib import Path

CANONICAL_ROOT = Path(r"E:\AI\SpeakLocal-App-Family")
SCRIPT_PATH = CANONICAL_ROOT / ".agent" / "queue_tool.py"
ns = {"__name__": "__codex_queue_wrapper__", "__file__": str(SCRIPT_PATH)}
exec(compile(SCRIPT_PATH.read_text(encoding="utf-8"), str(SCRIPT_PATH), "exec"), ns)
agent_root = CANONICAL_ROOT / ".agent"
for key, value in {
    "SCRIPT_PATH": SCRIPT_PATH,
    "AGENT_ROOT": agent_root,
    "REPO_ROOT": CANONICAL_ROOT,
    "TASKS_ROOT": agent_root / "tasks",
    "INDEX_PATH": agent_root / "coordination" / "queue-index.json",
    "LOCK_ROOT": agent_root / "coordination" / ".queue-locks",
    "EVENT_LOG_PATH": agent_root / "coordination" / "queue-events.jsonl",
    "RUNTIME_REVIEW_STATUS_PATH": agent_root / "coordination" / "runtime-review-path.json",
}.items():
    ns[key] = value
for key in ["SCRIPT_PATH", "REPO_ROOT", "INDEX_PATH", "LOCK_ROOT", "EVENT_LOG_PATH", "RUNTIME_REVIEW_STATUS_PATH"]:
    print(f"{key}={ns[key]}")
'@ | py -
```

Observed outcome:

- `SCRIPT_PATH=E:\AI\SpeakLocal-App-Family\.agent\queue_tool.py`
- `REPO_ROOT=E:\AI\SpeakLocal-App-Family`
- `INDEX_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-index.json`
- `LOCK_ROOT=E:\AI\SpeakLocal-App-Family\.agent\coordination\.queue-locks`
- `EVENT_LOG_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-events.jsonl`
- `RUNTIME_REVIEW_STATUS_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\runtime-review-path.json`

### 3. Run the live documented wrapper from the alias workspace and confirm helper success

Command:

```powershell
function Invoke-SpeakLocalQueueTool {
    param([Parameter(ValueFromRemainingArguments = $true)][string[]]$QueueArgs)
    $root = 'E:\AI\SpeakLocal-App-Family'
    Set-Location $root
    @'
from pathlib import Path
import sys

CANONICAL_ROOT = Path(r"E:\AI\SpeakLocal-App-Family")
SCRIPT_PATH = CANONICAL_ROOT / ".agent" / "queue_tool.py"
ns = {"__name__": "__codex_queue_wrapper__", "__file__": str(SCRIPT_PATH)}
exec(compile(SCRIPT_PATH.read_text(encoding="utf-8"), str(SCRIPT_PATH), "exec"), ns)
agent_root = CANONICAL_ROOT / ".agent"
ns["SCRIPT_PATH"] = SCRIPT_PATH
ns["AGENT_ROOT"] = agent_root
ns["REPO_ROOT"] = CANONICAL_ROOT
ns["TASKS_ROOT"] = agent_root / "tasks"
ns["INDEX_PATH"] = agent_root / "coordination" / "queue-index.json"
ns["LOCK_ROOT"] = agent_root / "coordination" / ".queue-locks"
ns["EVENT_LOG_PATH"] = agent_root / "coordination" / "queue-events.jsonl"
ns["RUNTIME_REVIEW_STATUS_PATH"] = agent_root / "coordination" / "runtime-review-path.json"

def _canonical_replace_with_retry(source, destination, retries=ns["DEFAULT_WRITE_RETRIES"], delay_seconds=ns["DEFAULT_WRITE_RETRY_DELAY_SECONDS"]):
    last_error = None
    for _ in range(retries):
        try:
            ns["os"].replace(source, destination)
            return
        except OSError as error:
            last_error = error
            ns["time"].sleep(delay_seconds)
    if last_error is not None:
        raise last_error
    ns["os"].replace(source, destination)

ns["replace_with_retry"] = _canonical_replace_with_retry
raise SystemExit(ns["main"](sys.argv[1:]))
'@ | py - @QueueArgs
}

Set-Location 'E:\AI\Viet-Travel-Phrases'
Invoke-SpeakLocalQueueTool repair
```

Observed outcome:

```json
{
  "status": "ok",
  "changes": [],
  "indexStats": {
    "queuedCount": 7,
    "reclaimableCount": 1,
    "inProgressCount": 0,
    "blockedCount": 13,
    "draftCount": 2,
    "recentlyCompletedCount": 37
  }
}
```

## Conclusion

- the live wrapper can be launched from `E:\AI\Viet-Travel-Phrases`
- it forces the helper back onto the canonical lexical root before `main()` runs
- the proof artifact now matches the live queue-surface wrapper exactly, including the canonical-only retry override
- the queue-start path no longer depends on direct `py .agent\queue_tool.py ...` calls in the queue surfaces or active runner
