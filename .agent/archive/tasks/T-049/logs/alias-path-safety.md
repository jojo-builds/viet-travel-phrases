# T-049 Alias-Path Safety Proof

## Goal

Prove alias-path cwd no longer causes queue writes or locks to route through `E:\AI\Viet-Travel-Phrases`.

## Ordinary-flow proof

From `E:\AI\Viet-Travel-Phrases`, the hardened wrapper printed these active helper paths before running a real `claim-next`:

- `REPO_ROOT=E:\AI\SpeakLocal-App-Family`
- `INDEX_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-index.json`
- `LOCK_ROOT=E:\AI\SpeakLocal-App-Family\.agent\coordination\.queue-locks`
- `EVENT_LOG_PATH=E:\AI\SpeakLocal-App-Family\.agent\coordination\queue-events.jsonl`

That invocation is recorded in [canonical-root-proof.md](E:\AI\SpeakLocal-App-Family\.agent\tasks\T-049\logs\canonical-root-proof.md).

Because the real unsupported-runtime `claim-next` completed with `result: "no_task"` under that binding, the lock, event, and index paths used by the hardened helper in the ordinary queue flow were canonical rather than alias-spelled.

## Degraded retry proof

The earlier wrapper shape still allowed `replace_with_retry(... destination.resolve())` to re-collapse a canonical lexical destination back to `E:\AI\Viet-Travel-Phrases` under forced failure.

After adding the wrapper-local canonical-only `replace_with_retry` override, ran this bounded synthetic check from `E:\AI\Viet-Travel-Phrases`:

```powershell
@'
from pathlib import Path
import os

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

coord = agent_root / "coordination"
coord.mkdir(parents=True, exist_ok=True)
source = coord / "t049-replace-source.tmp"
destination = coord / "t049-replace-destination.tmp"
source.write_text("source", encoding="utf-8")
destination.write_text("destination", encoding="utf-8")

calls = []
real_replace = ns["os"].replace
canonical_destination = str(destination)
alias_destination = str(destination.resolve())

def fake_replace(src, dst):
    calls.append(str(dst))
    if str(dst) == canonical_destination:
        raise OSError("forced canonical replace failure")
    return real_replace(src, dst)

ns["os"].replace = fake_replace
try:
    try:
        ns["replace_with_retry"](source, destination, retries=1, delay_seconds=0)
    except OSError as error:
        print(f"replace_error={error}")
finally:
    ns["os"].replace = real_replace
    for path in [source, destination, Path(alias_destination)]:
        try:
            path.unlink()
        except FileNotFoundError:
            pass
print(f"canonical_destination={canonical_destination}")
print(f"alias_destination={alias_destination}")
print("calls=")
for call in calls:
    print(call)
'@ | py -
```

## Degraded retry outcome

- Printed `replace_error=forced canonical replace failure`
- Printed canonical destination `E:\AI\SpeakLocal-App-Family\.agent\coordination\t049-replace-destination.tmp`
- Printed alias destination `E:\AI\Viet-Travel-Phrases\.agent\coordination\t049-replace-destination.tmp`
- Recorded only one attempted destination in `calls`:
  - `E:\AI\SpeakLocal-App-Family\.agent\coordination\t049-replace-destination.tmp`

There was **no** fallback call to the alias destination after the wrapper override.

## Conclusion

After the final wrapper hardening, alias-born cwd no longer redirects ordinary queue lock/write paths or degraded replace retries through `E:\AI\Viet-Travel-Phrases`.
