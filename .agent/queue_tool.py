#!/usr/bin/env py
from __future__ import annotations

import argparse
import ctypes
import json
import msvcrt
import os
import re
import subprocess
import sys
import tempfile
import time
import uuid
from contextlib import contextmanager
from ctypes import wintypes
from datetime import datetime, timedelta
from pathlib import Path
from typing import Any

OWNER_DEFAULT = "codex-desktop-automation"
DEFAULT_LEASE_MINUTES = 120
TASK_ID_RE = re.compile(r"^T-(\d+)$")

SCRIPT_PATH = Path(__file__).resolve()
AGENT_ROOT = SCRIPT_PATH.parent
REPO_ROOT = AGENT_ROOT.parent
TASKS_ROOT = AGENT_ROOT / "tasks"
INDEX_PATH = AGENT_ROOT / "coordination" / "queue-index.json"
LOCK_ROOT = AGENT_ROOT / "coordination" / ".queue-locks"
EVENT_LOG_PATH = AGENT_ROOT / "coordination" / "queue-events.jsonl"
RUNTIME_REVIEW_STATUS_PATH = AGENT_ROOT / "coordination" / "runtime-review-path.json"
DESKTOP_APP_RECOVERY_PATH = AGENT_ROOT / "coordination" / "desktop-app-recovery.json"
CANONICAL_REPO_ROOT = "E:\\AI\\SpeakLocal-App-Family"
COMPATIBILITY_REPO_ROOTS = {
    CANONICAL_REPO_ROOT,
    "E:\\AI\\Viet-Travel-Phrases",
    "C:\\Users\\Administrator\\.openclaw\\workspace\\projects\\speaklocal-app-family",
    "C:\\Users\\Administrator\\.openclaw\\workspace\\projects\\viet-travel-phrases",
}
DEFAULT_LOCK_TIMEOUT_SECONDS = 30
STALE_LOCK_SECONDS = 900
HEARTBEAT_STALE_SECONDS = 1800
DEFAULT_WRITE_RETRIES = 8
DEFAULT_WRITE_RETRY_DELAY_SECONDS = 0.1
WRITE_BLOCKED_WINERRORS = {5, 32}
REVIEW_RUNTIME_ENV_VAR = "SPEAKLOCAL_REVIEW_RUNTIME"
REVIEW_RUNTIME_REQUIRED_VALUE = "subagents"
ORPHAN_TEMP_FILE_STALE_SECONDS = 60.0
WAIT_OBJECT_0 = 0x00000000
WAIT_ABANDONED = 0x00000080
WAIT_TIMEOUT = 0x00000102
WAIT_FAILED = 0xFFFFFFFF
GENERIC_READ = 0x80000000
FILE_SHARE_READ = 0x00000001
FILE_SHARE_WRITE = 0x00000002
FILE_SHARE_DELETE = 0x00000004
OPEN_EXISTING = 3
FILE_ATTRIBUTE_NORMAL = 0x00000080
INVALID_HANDLE_VALUE = ctypes.c_void_p(-1).value


def normalize_root_value(raw_root: str) -> str:
    return raw_root.rstrip("\\/").lower()


def accepted_real_roots() -> set[str]:
    roots: set[str] = set()
    for raw_root in COMPATIBILITY_REPO_ROOTS:
        candidate = Path(raw_root)
        roots.add(normalize_root_value(str(candidate)))
        try:
            roots.add(normalize_root_value(str(candidate.resolve())))
        except OSError:
            continue
    return roots


ALLOWED_REAL_ROOTS = accepted_real_roots()

KERNEL32 = ctypes.WinDLL("kernel32", use_last_error=True)
KERNEL32.CreateMutexW.argtypes = [wintypes.LPVOID, wintypes.BOOL, wintypes.LPCWSTR]
KERNEL32.CreateMutexW.restype = wintypes.HANDLE
KERNEL32.CreateFileW.argtypes = [
    wintypes.LPCWSTR,
    wintypes.DWORD,
    wintypes.DWORD,
    wintypes.LPVOID,
    wintypes.DWORD,
    wintypes.DWORD,
    wintypes.HANDLE,
]
KERNEL32.CreateFileW.restype = wintypes.HANDLE
KERNEL32.WaitForSingleObject.argtypes = [wintypes.HANDLE, wintypes.DWORD]
KERNEL32.WaitForSingleObject.restype = wintypes.DWORD
KERNEL32.ReleaseMutex.argtypes = [wintypes.HANDLE]
KERNEL32.ReleaseMutex.restype = wintypes.BOOL
KERNEL32.CloseHandle.argtypes = [wintypes.HANDLE]
KERNEL32.CloseHandle.restype = wintypes.BOOL


def now_local() -> datetime:
    return datetime.now().astimezone()


def iso_timestamp(dt: datetime) -> str:
    return dt.isoformat()


def parse_iso(value: str | None) -> datetime | None:
    if not value:
        return None
    try:
        return datetime.fromisoformat(value)
    except ValueError:
        return None


def read_text_delete_shared(path: Path, encoding: str = "utf-8", errors: str = "strict") -> str:
    if os.name != "nt":
        return path.read_text(encoding=encoding, errors=errors)

    handle = KERNEL32.CreateFileW(
        str(path),
        GENERIC_READ,
        FILE_SHARE_READ | FILE_SHARE_WRITE | FILE_SHARE_DELETE,
        None,
        OPEN_EXISTING,
        FILE_ATTRIBUTE_NORMAL,
        None,
    )
    if handle == INVALID_HANDLE_VALUE:
        raise ctypes.WinError(ctypes.get_last_error())

    fd: int | None = None
    try:
        fd = msvcrt.open_osfhandle(int(handle), os.O_RDONLY)
        handle = None
        with os.fdopen(fd, "r", encoding=encoding, errors=errors) as stream:
            fd = None
            return stream.read()
    finally:
        if fd is not None:
            os.close(fd)
        if handle not in (None, INVALID_HANDLE_VALUE):
            KERNEL32.CloseHandle(handle)


def load_json(path: Path) -> dict[str, Any]:
    return json.loads(read_text_delete_shared(path, encoding="utf-8-sig"))


def load_json_if_exists(path: Path) -> dict[str, Any]:
    try:
        return load_json(path)
    except FileNotFoundError:
        return {}


def load_recovery_ledger() -> dict[str, Any]:
    ledger = load_json_if_exists(DESKTOP_APP_RECOVERY_PATH)
    if ledger:
        return ledger
    return {
        "version": 1,
        "lastRestartAt": "",
        "lastRestartReason": "",
        "lastObservedQueueState": {
            "queuedCount": 0,
            "inProgressCount": 0,
            "reclaimableCount": 0,
            "blockedCount": 0,
            "staleTaskIds": [],
        },
        "cooldownHours": 2,
        "stuckEpisodeActive": False,
        "notes": [
            "Used by hourly queue maintenance to avoid repeated Codex desktop restarts.",
            "Only perform one controlled desktop-app restart per stuck episode, then wait for the next hourly run to judge recovery.",
        ],
    }


def persist_recovery_ledger(ledger: dict[str, Any]) -> None:
    write_json_atomic(DESKTOP_APP_RECOVERY_PATH, ledger)


def runtime_review_path_proven() -> bool:
    status = load_json_if_exists(RUNTIME_REVIEW_STATUS_PATH)
    return bool(status.get("productionReady"))


def review_runtime_verified() -> bool:
    return os.environ.get(REVIEW_RUNTIME_ENV_VAR, "").strip().lower() == REVIEW_RUNTIME_REQUIRED_VALUE


def replace_with_retry(
    source: Path,
    destination: Path,
    retries: int = DEFAULT_WRITE_RETRIES,
    delay_seconds: float = DEFAULT_WRITE_RETRY_DELAY_SECONDS,
) -> None:
    last_error: OSError | None = None
    for _ in range(retries):
        try:
            os.replace(source, destination)
            return
        except OSError as error:
            last_error = error
            time.sleep(delay_seconds)
    resolved_destination = destination.resolve()
    if resolved_destination != destination:
        for _ in range(retries):
            try:
                os.replace(source, resolved_destination)
                return
            except OSError as error:
                last_error = error
                time.sleep(delay_seconds)
    if last_error is not None:
        raise last_error
    os.replace(source, destination)


def is_write_blocked_error(error: OSError) -> bool:
    return getattr(error, "winerror", None) in WRITE_BLOCKED_WINERRORS


def write_text_in_place_with_retry(
    path: Path,
    text: str,
    retries: int = DEFAULT_WRITE_RETRIES,
    delay_seconds: float = DEFAULT_WRITE_RETRY_DELAY_SECONDS,
) -> None:
    last_error: OSError | None = None
    for _ in range(retries):
        try:
            with path.open("w", encoding="utf-8", newline="\n") as handle:
                handle.write(text)
                handle.flush()
                os.fsync(handle.fileno())
            return
        except OSError as error:
            last_error = error
            time.sleep(delay_seconds)
    if last_error is not None:
        raise last_error
    with path.open("w", encoding="utf-8", newline="\n") as handle:
        handle.write(text)
        handle.flush()
        os.fsync(handle.fileno())


def cleanup_orphan_temp_files(path: Path, older_than_seconds: float = ORPHAN_TEMP_FILE_STALE_SECONDS) -> None:
    cutoff = time.time() - older_than_seconds
    pattern = f"{path.name}.*.tmp"
    for candidate in path.parent.glob(pattern):
        try:
            if candidate.stat().st_mtime > cutoff:
                continue
        except OSError:
            continue
        safe_unlink(candidate, retries=3, delay_seconds=0.1)


def write_json_atomic(path: Path, data: dict[str, Any]) -> None:
    path.parent.mkdir(parents=True, exist_ok=True)
    cleanup_orphan_temp_files(path)
    serialized = json.dumps(data, indent=2, ensure_ascii=False) + "\n"
    temp_path: Path | None = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w",
            delete=False,
            dir=path.parent,
            prefix=f"{path.name}.",
            suffix=".tmp",
            encoding="utf-8",
        ) as temp_file:
            temp_file.write(serialized)
            temp_file.flush()
            os.fsync(temp_file.fileno())
            temp_path = Path(temp_file.name)
        try:
            replace_with_retry(temp_path, path)
        except OSError as error:
            # Hot queue files are protected by the queue mutex already. If Windows blocks
            # destination replacement because another reader omitted delete-share, fall back
            # to an in-place overwrite so claim/heartbeat/finish can still progress.
            if not is_write_blocked_error(error):
                raise
            write_text_in_place_with_retry(path, serialized)
            safe_unlink(temp_path)
            temp_path = None
        cleanup_orphan_temp_files(path)
    except OSError:
        if temp_path is not None:
            safe_unlink(temp_path)
        raise


def append_text_with_retry(
    path: Path,
    text: str,
    retries: int = DEFAULT_WRITE_RETRIES,
    delay_seconds: float = DEFAULT_WRITE_RETRY_DELAY_SECONDS,
) -> None:
    last_error: OSError | None = None
    for _ in range(retries):
        try:
            with path.open("a", encoding="utf-8") as handle:
                handle.write(text)
            return
        except OSError as error:
            last_error = error
            time.sleep(delay_seconds)
    if last_error is not None:
        raise last_error
    with path.open("a", encoding="utf-8") as handle:
        handle.write(text)


def append_event(event_type: str, **payload: Any) -> None:
    EVENT_LOG_PATH.parent.mkdir(parents=True, exist_ok=True)
    record = {
        "timestamp": iso_timestamp(now_local()),
        "event": event_type,
        **payload,
    }
    append_text_with_retry(EVENT_LOG_PATH, json.dumps(record, ensure_ascii=False) + "\n")


def append_event_quiet(event_type: str, **payload: Any) -> None:
    try:
        append_event(event_type, **payload)
    except OSError:
        return


def output_path_label(path: Path) -> str:
    try:
        return to_repo_relative(path)
    except ValueError:
        return str(path)


def warning_record(reason: str, path: Path, operation: str, error: OSError) -> dict[str, Any]:
    return {
        "reason": reason,
        "operation": operation,
        "path": output_path_label(path),
        "errorType": type(error).__name__,
        "detail": str(error),
    }


def claim_write_block_skip_record(task_id: str, claim_group: str, path: Path, error: OSError) -> dict[str, Any]:
    reason = "task-state-write-failed"
    detail = "Queue task state could not be written atomically during claim-next, so this candidate was skipped."
    if is_write_blocked_error(error):
        reason = "task-state-write-access-denied"
        detail = (
            "Windows denied the helper's atomic replace during claim-next, so this candidate was skipped and the helper continued to the next eligible task."
        )
    return {
        "taskId": task_id,
        "claimGroup": claim_group,
        "reason": reason,
        "path": to_repo_relative(path),
        "detail": detail,
        "errorType": type(error).__name__,
        "errorDetail": str(error),
    }


def task_state_write_retry_output(
    *,
    warnings: list[dict[str, Any]],
    task_id: str,
    operation: str,
    error: OSError,
) -> int:
    refreshed_states = load_all_states()
    refreshed_index = best_effort_write_index(refreshed_states, now_local(), warnings)
    reason = "task-state-write-failed"
    detail = "Queue task state could not be written atomically. Retry this command instead of hand-editing queue state."
    if getattr(error, "winerror", None) == 5:
        reason = "task-state-write-access-denied"
        detail = f"Windows denied the helper's atomic replace during {operation}."
        if operation == "claim-next":
            detail += " Avoid manually opening live candidate state.json files before claim, and retry after the blocking reader releases the file."
        else:
            detail += " Retry after the blocking reader releases the task state file."
    best_effort_append_event(
        warnings,
        "task-state-write-retry",
        taskId=task_id,
        operation=operation,
        reason=reason,
        detail=detail,
        errorType=type(error).__name__,
        errorDetail=str(error),
        indexStats=refreshed_index["stats"],
    )
    output = {
        "status": "retry",
        "reason": reason,
        "detail": detail,
        "operation": operation,
        "taskId": task_id,
        "path": to_repo_relative(task_state_path(task_id)),
        "indexStats": refreshed_index["stats"],
    }
    maybe_add_warnings(output, warnings)
    print(json.dumps(output, indent=2))
    return 3


def queue_state_write_retry_output(
    *,
    warnings: list[dict[str, Any]],
    operation: str,
    task_ids: list[str],
    error: OSError,
) -> int:
    refreshed_states = load_all_states()
    refreshed_index = best_effort_write_index(refreshed_states, now_local(), warnings)
    reason = "queue-state-write-failed"
    detail = f"Queue state could not be written atomically during {operation}. Retry this command instead of hand-editing queue state."
    if getattr(error, "winerror", None) == 5:
        reason = "queue-state-write-access-denied"
        detail = (
            f"Windows denied the helper's atomic replace during {operation}. "
            "Avoid manually opening live queue state files during queue mutation commands, and retry after the blocking reader releases the file."
        )
    best_effort_append_event(
        warnings,
        "queue-state-write-retry",
        operation=operation,
        taskIds=task_ids,
        reason=reason,
        detail=detail,
        errorType=type(error).__name__,
        errorDetail=str(error),
        indexStats=refreshed_index["stats"],
    )
    output = {
        "status": "retry",
        "reason": reason,
        "detail": detail,
        "operation": operation,
        "taskIds": task_ids,
        "indexStats": refreshed_index["stats"],
    }
    maybe_add_warnings(output, warnings)
    print(json.dumps(output, indent=2))
    return 3


def maybe_add_warnings(output: dict[str, Any], warnings: list[dict[str, Any]]) -> None:
    if warnings:
        output["warnings"] = warnings


def best_effort_append_event(warnings: list[dict[str, Any]], event_type: str, **payload: Any) -> None:
    try:
        append_event(event_type, **payload)
    except OSError as error:
        warnings.append(warning_record("event-log-write-failed", EVENT_LOG_PATH, "append-event", error))


def path_from_repo_reference(raw_path: str | None, default: Path | None = None) -> Path | None:
    if raw_path:
        normalized = raw_path.replace("\\", os.sep)
        candidate = Path(normalized)
        return candidate if candidate.is_absolute() else REPO_ROOT / candidate
    return default


def lock_is_stale(path: Path) -> bool:
    try:
        age_seconds = time.time() - path.stat().st_mtime
    except FileNotFoundError:
        return False
    return age_seconds > STALE_LOCK_SECONDS


def read_lock_metadata(path: Path) -> dict[str, Any]:
    try:
        return json.loads(read_text_delete_shared(path, encoding="utf-8"))
    except FileNotFoundError:
        return {}
    except json.JSONDecodeError:
        return {"invalid": True}
    except OSError:
        return {"unreadable": True}


def process_is_alive(pid: int | None) -> bool:
    if not pid or pid <= 0:
        return False
    try:
        os.kill(pid, 0)
    except OSError:
        return False
    return True


def safe_unlink(path: Path, retries: int = 12, delay_seconds: float = 0.2) -> bool:
    for _ in range(retries):
        try:
            path.unlink()
            return True
        except FileNotFoundError:
            return True
        except OSError:
            time.sleep(delay_seconds)
    return False


def stale_cleanup_mutex_name(name: str) -> str:
    sanitized = re.sub(r"[^A-Za-z0-9_.-]", "-", name)
    return f"Local\\SpeakLocalQueueCleanup-{sanitized}"


def queue_mutation_mutex_name(name: str) -> str:
    sanitized = re.sub(r"[^A-Za-z0-9_.-]", "-", name)
    repo_key = re.sub(r"[^A-Za-z0-9]+", "-", CANONICAL_REPO_ROOT.lower()).strip("-")
    return f"Local\\SpeakLocalQueueMutation-{repo_key}-{sanitized}"


def best_effort_write_lock_metadata(lock_path: Path, payload: dict[str, Any]) -> None:
    lock_path.parent.mkdir(parents=True, exist_ok=True)
    temp_path = lock_path.with_name(f"{lock_path.name}.{uuid.uuid4().hex}.tmp")
    try:
        temp_path.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")
        os.replace(temp_path, lock_path)
    except OSError:
        safe_unlink(temp_path)


def best_effort_remove_lock_metadata(lock_path: Path, expected_token: str) -> None:
    metadata = read_lock_metadata(lock_path)
    if metadata.get("token") != expected_token:
        return
    safe_unlink(lock_path)


@contextmanager
def stale_cleanup_mutex(name: str, timeout_seconds: int):
    mutex_name = stale_cleanup_mutex_name(name)
    handle = KERNEL32.CreateMutexW(None, False, mutex_name)
    if not handle:
        raise OSError(ctypes.get_last_error(), f"CreateMutexW failed for {mutex_name}")
    wait_millis = max(1, int(timeout_seconds * 1000))
    wait_result = KERNEL32.WaitForSingleObject(handle, wait_millis)
    if wait_result == WAIT_FAILED:
        raise OSError(ctypes.get_last_error(), f"WaitForSingleObject failed for {mutex_name}")
    acquired = wait_result in {WAIT_OBJECT_0, WAIT_ABANDONED}
    try:
        if not acquired:
            raise TimeoutError(f"timed out acquiring stale cleanup mutex: {mutex_name}")
        yield
    finally:
        if acquired:
            KERNEL32.ReleaseMutex(handle)
        KERNEL32.CloseHandle(handle)


@contextmanager
def queue_mutation_lock(name: str = "queue-mutation", timeout_seconds: int = DEFAULT_LOCK_TIMEOUT_SECONDS):
    LOCK_ROOT.mkdir(parents=True, exist_ok=True)
    lock_path = LOCK_ROOT / f"{name}.lock"
    lock_token = uuid.uuid4().hex
    mutex_name = queue_mutation_mutex_name(name)
    handle = KERNEL32.CreateMutexW(None, False, mutex_name)
    if not handle:
        raise OSError(ctypes.get_last_error(), f"CreateMutexW failed for {mutex_name}")
    wait_millis = max(1, int(timeout_seconds * 1000))
    wait_result = KERNEL32.WaitForSingleObject(handle, wait_millis)
    if wait_result == WAIT_FAILED:
        error = ctypes.get_last_error()
        KERNEL32.CloseHandle(handle)
        raise OSError(error, f"WaitForSingleObject failed for {mutex_name}")
    if wait_result == WAIT_TIMEOUT:
        metadata = read_lock_metadata(lock_path)
        KERNEL32.CloseHandle(handle)
        raise TimeoutError(f"timed out acquiring queue mutation lock: {lock_path} metadata={metadata}")
    acquired = wait_result in {WAIT_OBJECT_0, WAIT_ABANDONED}
    if not acquired:
        KERNEL32.CloseHandle(handle)
        metadata = read_lock_metadata(lock_path)
        raise TimeoutError(f"unexpected wait result acquiring queue mutation lock: {lock_path} metadata={metadata} waitResult={wait_result}")
    best_effort_write_lock_metadata(lock_path, {
        "pid": os.getpid(),
        "token": lock_token,
        "createdAt": iso_timestamp(now_local()),
        "mutexName": mutex_name,
    })
    try:
        yield
    finally:
        best_effort_remove_lock_metadata(lock_path, lock_token)
        if acquired:
            KERNEL32.ReleaseMutex(handle)
        KERNEL32.CloseHandle(handle)


def task_number(task_id: str) -> int:
    match = TASK_ID_RE.match(task_id)
    if not match:
        return 10**9
    return int(match.group(1))


def iter_task_state_paths() -> list[Path]:
    paths: list[Path] = []
    for child in TASKS_ROOT.iterdir():
        if not child.is_dir() or child.name == "TEMPLATE":
            continue
        state_path = child / "state.json"
        if state_path.exists():
            paths.append(state_path)
    return sorted(paths, key=lambda p: task_number(p.parent.name))


def task_entry(state: dict[str, Any], state_path: Path) -> dict[str, Any]:
    write_locks = state.get("locks", {}).get("write", []) or []
    automation = state.get("automation", {}) or {}
    entry: dict[str, Any] = {
        "taskId": state.get("taskId", state_path.parent.name),
        "title": state.get("title", state_path.parent.name),
        "state": to_repo_relative(state_path),
        "selectionOrder": int(automation.get("selectionOrder") or 0),
    }
    if write_locks:
        entry["writeLock"] = write_locks[0]
    return entry


def to_repo_relative(path: Path) -> str:
    return str(path.relative_to(REPO_ROOT)).replace("/", "\\")


def active_owner(state: dict[str, Any], now: datetime) -> bool:
    if state.get("status") != "in_progress":
        return False
    session = state.get("session", {}) or {}
    execution = state.get("execution", {}) or {}
    owner = session.get("owner") or ""
    session_id = session.get("sessionId") or ""
    lease_expires = parse_iso(execution.get("leaseExpiresAt"))
    last_heartbeat = parse_iso(execution.get("lastHeartbeatAt"))
    if owner != OWNER_DEFAULT or not session_id or not lease_expires or not last_heartbeat:
        return False
    if lease_expires <= now:
        return False
    heartbeat_age_seconds = (now - last_heartbeat).total_seconds()
    return heartbeat_age_seconds <= HEARTBEAT_STALE_SECONDS


def classify_task(state: dict[str, Any], now: datetime) -> tuple[str, list[str]]:
    status = state.get("status")
    phase = state.get("phase") or ""
    session = state.get("session", {}) or {}
    execution = state.get("execution", {}) or {}
    issues: list[str] = []

    if status == "done":
        return "recently_completed", issues
    if status == "blocked":
        return "blocked", issues
    if is_direct_task_contract(state):
        return "draft", issues
    if status in {"draft", "planning"}:
        return "draft", issues
    if status == "queued" and phase == "queued-for-desktop-codex":
        return "queued", issues
    if status == "in_progress":
        if active_owner(state, now):
            return "in_progress", issues
        lease_expires = parse_iso(execution.get("leaseExpiresAt"))
        last_heartbeat = parse_iso(execution.get("lastHeartbeatAt"))
        if phase == "stale-awaiting-reclaim":
            issues.append("phase-stale-awaiting-reclaim")
            return "reclaimable", issues
        if lease_expires and lease_expires <= now:
            issues.append("lease-expired")
            return "reclaimable", issues
        if last_heartbeat and (now - last_heartbeat).total_seconds() > HEARTBEAT_STALE_SECONDS:
            issues.append("heartbeat-stale")
            return "reclaimable", issues
        if not lease_expires:
            issues.append("missing-lease")
            return "reclaimable", issues
        if not last_heartbeat:
            issues.append("missing-heartbeat")
            return "reclaimable", issues
        if (session.get("owner") or "") != OWNER_DEFAULT:
            issues.append("unexpected-owner")
            return "reclaimable", issues
        if not (session.get("sessionId") or ""):
            issues.append("missing-session-id")
            return "reclaimable", issues
        if phase == "queued-for-desktop-codex":
            issues.append("queued-phase-leftover")
            return "reclaimable", issues
        issues.append("inactive-in-progress")
        return "reclaimable", issues
    return "draft", issues


def load_all_states() -> dict[str, dict[str, Any]]:
    states: dict[str, dict[str, Any]] = {}
    for state_path in iter_task_state_paths():
        state = load_json(state_path)
        task_id = state.get("taskId", state_path.parent.name)
        states[task_id] = state
    return states


def task_state_path(task_id: str) -> Path:
    return TASKS_ROOT / task_id / "state.json"


def task_result_path(task_id: str, state: dict[str, Any]) -> Path:
    return path_from_repo_reference(state.get("artifacts", {}).get("result"), task_state_path(task_id).with_name("result.md")) or task_state_path(task_id).with_name("result.md")


def task_reviews_root(task_id: str, state: dict[str, Any]) -> Path:
    return path_from_repo_reference(state.get("artifacts", {}).get("reviews"), task_state_path(task_id).parent / "reviews") or task_state_path(task_id).parent / "reviews"


def task_recovery_notes_path(task_id: str, state: dict[str, Any]) -> Path:
    return path_from_repo_reference(state.get("artifacts", {}).get("recoveryNotes"), task_state_path(task_id).with_name("recovery-notes.md")) or task_state_path(task_id).with_name("recovery-notes.md")


def latest_gate_dir(reviews_root: Path, gate_number: int) -> Path | None:
    candidates = sorted(reviews_root.glob(f"gate-{gate_number:02d}-pass-*"))
    return candidates[-1] if candidates else None


def review_artifact_files(gate_dir: Path) -> list[Path]:
    return sorted([path for path in gate_dir.iterdir() if path.is_file()])


def artifact_records_approval(path: Path) -> bool:
    try:
        text = read_text_delete_shared(path, encoding="utf-8", errors="ignore")
    except OSError:
        return False
    explicit = re.search(r"^\s*(?:[-*]\s*)?approval\s*:\s*(approve|approved|block|blocked)\b", text, flags=re.IGNORECASE | re.MULTILINE)
    if explicit:
        decision = explicit.group(1).lower()
        return decision in {"approve", "approved"}
    text = text.lower()
    approval_tokens = ("approved", "approve", "explicitly agree", "agrees", "consensus pass", "pass")
    rejection_tokens = ("reject", "rejected", "blocked", "fail", "not approved", "disagree")
    has_approval = any(token in text for token in approval_tokens)
    has_rejection = any(token in text for token in rejection_tokens)
    return has_approval and not has_rejection


def task_class(state: dict[str, Any]) -> str:
    automation = state.get("automation", {}) or {}
    return str(automation.get("taskClass") or "meaningful").strip().lower()


def is_proof_task(state: dict[str, Any]) -> bool:
    if task_class(state) in {"runtime-proof", "meaningful-runtime-proof", "production-readiness-proof"}:
        return False
    return bool((state.get("automation", {}) or {}).get("proofTask")) or task_class(state) in {"proof", "synthetic", "proof-task", "synthetic-proof"}


def is_runtime_proof_task(state: dict[str, Any]) -> bool:
    return task_class(state) in {"runtime-proof", "meaningful-runtime-proof", "production-readiness-proof"}


def is_direct_task_contract(state: dict[str, Any]) -> bool:
    automation = state.get("automation", {}) or {}
    return str(automation.get("mode") or "").strip().lower() == "direct-task-contract"


def meaningful_contract_errors(state: dict[str, Any]) -> list[str]:
    automation = state.get("automation", {}) or {}
    declared_task_class = str(automation.get("taskClass") or "").strip().lower()
    declares_proof_flag = "proofTask" in automation
    proof_flag = bool(automation.get("proofTask"))
    gates_required = int(automation.get("reviewGatesRequired") or 0)
    reviewers_required = int(automation.get("reviewersRequired") or 0)
    consensus_required = int(automation.get("reviewGateConsensusRequired") or 0)
    errors: list[str] = []
    if is_runtime_proof_task(state):
        if not declares_proof_flag or proof_flag:
            errors.append("runtime-proof task must declare automation.proofTask as false")
    else:
        if declared_task_class != "meaningful":
            errors.append("meaningful task must declare automation.taskClass as meaningful")
        if not declares_proof_flag or proof_flag:
            errors.append("meaningful task must declare automation.proofTask as false")
    if gates_required != 3:
        errors.append(f"meaningful task must require 3 review gates, found {gates_required}")
    if reviewers_required != 4:
        errors.append(f"meaningful task must require exactly 4 reviewers, found {reviewers_required}")
    if consensus_required != 4:
        errors.append(f"meaningful task must require unanimous 4-reviewer consensus, found {consensus_required}")
    return errors


def result_has_process_feedback(result_path: Path) -> bool:
    try:
        text = read_text_delete_shared(result_path, encoding="utf-8", errors="ignore")
    except OSError:
        return False
    match = re.search(r"^##\s+Process feedback\s*$([\s\S]*?)(?=^##\s+|\Z)", text, flags=re.IGNORECASE | re.MULTILINE)
    if not match:
        return False
    section = match.group(1)
    return bool(re.search(r"^\s*-\s*(BUG|SUGGESTION|NONE)\b", section, flags=re.IGNORECASE | re.MULTILINE))


def required_done_artifact_paths(task_id: str, state: dict[str, Any]) -> list[Path]:
    artifacts = state.get("artifacts", {}) or {}
    raw_paths = artifacts.get("requiredForDone", []) or []
    resolved: list[Path] = []
    for raw_path in raw_paths:
        path = path_from_repo_reference(str(raw_path), None)
        if path is not None:
            resolved.append(path)
    return resolved


def heartbeat_after_claim(state: dict[str, Any]) -> bool:
    execution = state.get("execution", {}) or {}
    claimed_at = parse_iso(execution.get("claimedAt"))
    last_heartbeat_at = parse_iso(execution.get("lastHeartbeatAt"))
    if not claimed_at or not last_heartbeat_at:
        return False
    return last_heartbeat_at > claimed_at


def done_prereq_errors(task_id: str, state: dict[str, Any]) -> list[str]:
    errors: list[str] = []
    result_path = task_result_path(task_id, state)
    if not result_path.exists():
        errors.append(f"missing result artifact: {to_repo_relative(result_path)}")
    else:
        if not result_has_process_feedback(result_path):
            errors.append(f"result artifact missing usable Process feedback section (expected at least one bullet starting with BUG, SUGGESTION, or NONE): {to_repo_relative(result_path)}")

    if not heartbeat_after_claim(state):
        errors.append("missing heartbeat after claim")

    execution = state.get("execution", {}) or {}
    if execution.get("reclaimReason"):
        recovery_notes_path = task_recovery_notes_path(task_id, state)
        if not recovery_notes_path.exists():
            errors.append(f"missing recovery notes for reclaimed task: {to_repo_relative(recovery_notes_path)}")

    for required_path in required_done_artifact_paths(task_id, state):
        if not required_path.exists():
            errors.append(f"missing required done artifact: {to_repo_relative(required_path)}")

    automation = state.get("automation", {}) or {}
    proof_task = is_proof_task(state)
    if not proof_task:
        errors.extend(meaningful_contract_errors(state))

    required_gates = int(automation.get("reviewGatesRequired") or 0)
    required_reviewers = int(
        automation.get("reviewGateConsensusRequired")
        or automation.get("reviewersRequired")
        or 0
    )
    if required_gates <= 0:
        if proof_task:
            return errors
        errors.append("meaningful task cannot finish done with zero review gates; use an explicit proof/synthetic task flag only for proof tasks")
        return errors

    reviews_root = task_reviews_root(task_id, state)
    if not reviews_root.exists():
        errors.append(f"missing reviews root: {to_repo_relative(reviews_root)}")
        return errors

    for gate_number in range(1, required_gates + 1):
        gate_dir = latest_gate_dir(reviews_root, gate_number)
        if gate_dir is None:
            errors.append(f"missing gate directory for gate {gate_number:02d}")
            continue
        artifacts = review_artifact_files(gate_dir)
        if len(artifacts) != required_reviewers:
            errors.append(
                f"gate {gate_number:02d} expected {required_reviewers} review artifacts, found {len(artifacts)}"
            )
            continue
        approvals = sum(1 for artifact in artifacts if artifact_records_approval(artifact))
        if approvals != required_reviewers:
            errors.append(
                f"gate {gate_number:02d} expected {required_reviewers} explicit approvals, found {approvals}"
            )
    return errors


def latest_completed_entries(states: dict[str, dict[str, Any]]) -> list[dict[str, Any]]:
    completed: list[tuple[datetime, int, dict[str, Any], Path]] = []
    for task_id, state in states.items():
        if state.get("status") != "done":
            continue
        state_path = task_state_path(task_id)
        updated = parse_iso(state.get("lastUpdated")) or datetime.fromtimestamp(0).astimezone()
        completed.append((updated, task_number(task_id), state, state_path))
    completed.sort(key=lambda item: (item[0], item[1]), reverse=True)
    return [task_entry(state, path) for _, _, state, path in completed]


def entry_sort_key(entry: dict[str, Any]) -> tuple[int, int]:
    return int(entry.get("selectionOrder") or 0), task_number(entry["taskId"])


def build_queue_index(states: dict[str, dict[str, Any]], now: datetime) -> dict[str, Any]:
    grouped: dict[str, list[dict[str, Any]]] = {
        "reclaimable": [],
        "queued": [],
        "in_progress": [],
        "blocked": [],
        "draft": [],
        "recently_completed": latest_completed_entries(states),
    }

    ordered_ids = sorted(states.keys(), key=task_number)
    for task_id in ordered_ids:
        state = states[task_id]
        state_path = task_state_path(task_id)
        group, _issues = classify_task(state, now)
        if group == "recently_completed":
            continue
        if group not in grouped:
            group = "draft"
        grouped[group].append(task_entry(state, state_path))

    for group_name in ("reclaimable", "queued", "in_progress", "blocked", "draft"):
        grouped[group_name].sort(key=entry_sort_key)

    index = {
        "version": 1,
        "updatedAt": iso_timestamp(now),
        "repoRoot": CANONICAL_REPO_ROOT,
        "selectionPolicy": {
            "preferredGroups": ["reclaimable", "queued"],
            "lifecycleTruth": ".agent/tasks/T-xxx/state.json",
            "indexRole": "fast-selection-aid",
            "rebuildRule": "If queue-index.json is missing, stale, or disagrees materially with task state, trust state.json and rebuild the index from task folders.",
            "orderingRule": "Across preferred groups, group preference wins first, then lower automation.selectionOrder, then task id.",
        },
        "groups": {
            **grouped,
            "completed_archive_hint": "Archive older completed tasks out of the hot queue path before this surface grows into high hundreds or thousands.",
        },
        "stats": {
            "queuedCount": len(grouped["queued"]),
            "reclaimableCount": len(grouped["reclaimable"]),
            "inProgressCount": len(grouped["in_progress"]),
            "blockedCount": len(grouped["blocked"]),
            "draftCount": len(grouped["draft"]),
            "recentlyCompletedCount": len(grouped["recently_completed"]),
        },
        "notes": [
            "This index is intentionally small and selection-focused.",
            "Workers should read this file before task states, then verify only the referenced candidate states until one task is selected.",
            "Queue order is explicit here; do not linear-scan the full task tree when the index is healthy.",
            "Use automation.selectionOrder for intentional proof-task or hotfix prioritization without renumbering task ids.",
        ],
    }
    return index


def summarize_health(states: dict[str, dict[str, Any]], now: datetime) -> dict[str, Any]:
    reclaimable: list[dict[str, Any]] = []
    malformed: list[dict[str, Any]] = []
    for task_id, state in sorted(states.items(), key=lambda item: task_number(item[0])):
        group, issues = classify_task(state, now)
        if group == "reclaimable":
            reclaimable.append({"taskId": task_id, "issues": issues, "phase": state.get("phase"), "status": state.get("status")})
        if any(issue in {"missing-session-id", "unexpected-owner", "queued-phase-leftover", "missing-lease"} for issue in issues):
            malformed.append({"taskId": task_id, "issues": issues, "phase": state.get("phase"), "status": state.get("status")})
    return {
        "repoRoot": CANONICAL_REPO_ROOT,
        "reclaimable": reclaimable,
        "malformedInProgress": malformed,
        "counts": {
            "taskCount": len(states),
            "reclaimableCount": len(reclaimable),
            "malformedInProgressCount": len(malformed),
        },
    }


def normalize_reclaimable_states(states: dict[str, dict[str, Any]], now: datetime) -> list[dict[str, Any]]:
    changes: list[dict[str, Any]] = []
    for task_id in sorted(states.keys(), key=task_number):
        state = states[task_id]
        if is_direct_task_contract(state):
            continue
        if state.get("status") != "in_progress":
            continue
        if active_owner(state, now):
            continue
        session = state.setdefault("session", {})
        execution = state.setdefault("execution", {})
        attempt = execution.get("attempt") or 0
        claimed_at = execution.get("claimedAt") or ""
        missing_session = not (session.get("owner") or "") and not (session.get("sessionId") or "")
        missing_claim = not claimed_at and int(attempt) == 0
        previous_phase = state.get("phase")
        previous_status = state.get("status")
        previous_reclaim_reason = execution.get("reclaimReason") or ""

        if previous_phase == "queued-for-desktop-codex" and missing_session and missing_claim:
            changed = previous_status != "queued" or previous_reclaim_reason != ""
            state["status"] = "queued"
            state["phase"] = "queued-for-desktop-codex"
            execution["reclaimReason"] = ""
            if changed:
                state["lastUpdated"] = iso_timestamp(now)
                changes.append({
                    "taskId": task_id,
                    "action": "reverted-invalid-partial-claim",
                    "fromPhase": previous_phase,
                    "toStatus": state["status"],
                    "toPhase": state["phase"],
                })
            continue

        reason_parts: list[str] = []
        lease_expires = parse_iso(execution.get("leaseExpiresAt"))
        if lease_expires and lease_expires <= now:
            reason_parts.append("lease-expired")
        if not lease_expires:
            reason_parts.append("missing-lease")
        if (session.get("owner") or "") != OWNER_DEFAULT:
            reason_parts.append("unexpected-owner")
        if not (session.get("sessionId") or ""):
            reason_parts.append("missing-session-id")
        if previous_phase == "queued-for-desktop-codex":
            reason_parts.append("queued-phase-leftover")
        if not reason_parts:
            reason_parts.append("inactive-in-progress")

        new_reclaim_reason = ",".join(reason_parts)
        changed = previous_phase != "stale-awaiting-reclaim" or previous_reclaim_reason != new_reclaim_reason
        state["phase"] = "stale-awaiting-reclaim"
        execution["reclaimReason"] = new_reclaim_reason
        if changed:
            state["lastUpdated"] = iso_timestamp(now)
            changes.append({
                "taskId": task_id,
                "action": "normalized-reclaimable",
                "fromPhase": previous_phase,
                "toStatus": state["status"],
                "toPhase": state["phase"],
                "reason": execution["reclaimReason"],
            })
    return changes


def persist_states(states: dict[str, dict[str, Any]], task_ids: list[str]) -> None:
    for task_id in task_ids:
        write_json_atomic(task_state_path(task_id), states[task_id])


def write_index(states: dict[str, dict[str, Any]], now: datetime) -> dict[str, Any]:
    index = build_queue_index(states, now)
    write_json_atomic(INDEX_PATH, index)
    return index


def best_effort_write_index(states: dict[str, dict[str, Any]], now: datetime, warnings: list[dict[str, Any]]) -> dict[str, Any]:
    index = build_queue_index(states, now)
    try:
        write_json_atomic(INDEX_PATH, index)
    except OSError as error:
        warnings.append(warning_record("queue-index-write-failed", INDEX_PATH, "write-index", error))
    return index


def recent_queue_events(limit: int = 200) -> list[dict[str, Any]]:
    if not EVENT_LOG_PATH.exists():
        return []
    try:
        lines = read_text_delete_shared(EVENT_LOG_PATH, encoding="utf-8").splitlines()
    except OSError:
        return []
    events: list[dict[str, Any]] = []
    for line in lines[-limit:]:
        try:
            events.append(json.loads(line))
        except json.JSONDecodeError:
            continue
    return events


def queue_counts(index: dict[str, Any]) -> dict[str, int]:
    stats = index.get("stats", {}) or {}
    return {
        "queuedCount": int(stats.get("queuedCount") or 0),
        "inProgressCount": int(stats.get("inProgressCount") or 0),
        "reclaimableCount": int(stats.get("reclaimableCount") or 0),
        "blockedCount": int(stats.get("blockedCount") or 0),
        "recentlyCompletedCount": int(stats.get("recentlyCompletedCount") or 0),
    }


def stale_meaningful_task_ids(states: dict[str, dict[str, Any]]) -> list[str]:
    stale_task_ids: list[str] = []
    for task_id, state in states.items():
        automation = state.get("automation", {}) or {}
        if automation.get("taskClass", "meaningful") != "meaningful":
            continue
        phase = str(state.get("phase") or "")
        reclaim_reason = str((state.get("execution", {}) or {}).get("reclaimReason") or "")
        if phase == "stale-awaiting-reclaim" or reclaim_reason == "inactive-in-progress":
            stale_task_ids.append(task_id)
    return sorted(stale_task_ids, key=task_number)


def latest_progress_event(events: list[dict[str, Any]]) -> dict[str, Any] | None:
    interesting = {"claim-next-claimed", "claim-next-reclaimed", "finish"}
    for event in reversed(events):
        if str(event.get("event") or "") in interesting:
            return event
    return None


def latest_repair_with_changes(events: list[dict[str, Any]]) -> dict[str, Any] | None:
    for event in reversed(events):
        if str(event.get("event") or "") != "repair":
            continue
        changes = event.get("changes") or []
        if changes:
            return event
    return None


def desktop_restart_candidates() -> list[dict[str, str]]:
    script = r"""
$targets = Get-CimInstance Win32_Process |
  Where-Object { $_.Name -eq 'Codex.exe' -and $_.ExecutablePath -like 'C:\Program Files\WindowsApps\OpenAI.Codex_*\Codex.exe' }
$main = $targets |
  Where-Object { ($_.CommandLine -replace '"','').Trim() -eq $_.ExecutablePath } |
  Sort-Object ProcessId |
  Select-Object -First 1
if (-not $main) {
  Write-Output '{}'
  exit 0
}
$payload = [ordered]@{
  processId = $main.ProcessId
  executablePath = $main.ExecutablePath
  commandLine = $main.CommandLine
}
$payload | ConvertTo-Json -Compress
"""
    completed = subprocess.run(
        ["powershell", "-NoProfile", "-Command", script],
        capture_output=True,
        text=True,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError((completed.stderr or completed.stdout or "Unable to inspect Codex desktop processes").strip())
    raw = (completed.stdout or "").strip()
    if not raw or raw == "{}":
        return []
    parsed = json.loads(raw)
    if isinstance(parsed, list):
        return [candidate for candidate in parsed if candidate.get("executablePath")]
    if isinstance(parsed, dict) and parsed.get("executablePath"):
        return [parsed]
    return []


def resolve_codex_desktop_executable_path() -> str:
    candidates = desktop_restart_candidates()
    if candidates:
        executable_path = str(candidates[0].get("executablePath") or "").strip()
        if executable_path:
            return executable_path
    script = r"""
$pkg = Get-AppxPackage -Name OpenAI.Codex | Sort-Object Version -Descending | Select-Object -First 1
if (-not $pkg) {
  Write-Output ''
  exit 0
}
$exe = Join-Path $pkg.InstallLocation 'app\Codex.exe'
if (-not (Test-Path $exe)) {
  Write-Output ''
  exit 0
}
Write-Output $exe
"""
    completed = subprocess.run(
        ["powershell", "-NoProfile", "-Command", script],
        capture_output=True,
        text=True,
        check=False,
    )
    if completed.returncode != 0:
        raise RuntimeError((completed.stderr or completed.stdout or "Unable to resolve Codex desktop executable path").strip())
    return (completed.stdout or "").strip()


def start_codex_desktop_app(executable_path: str | None = None) -> dict[str, Any]:
    resolved_path = (executable_path or "").strip() or resolve_codex_desktop_executable_path()
    if not resolved_path:
        return {"status": "blocked", "reason": "codex-desktop-executable-not-found"}
    start_result = subprocess.run(["powershell", "-NoProfile", "-Command", f"Start-Process -FilePath '{resolved_path}'"], capture_output=True, text=True, check=False)
    if start_result.returncode != 0:
        return {
            "status": "retry",
            "reason": "codex-desktop-start-failed",
            "detail": (start_result.stderr or start_result.stdout or "").strip(),
            "executablePath": resolved_path,
        }
    time.sleep(4)
    detected = desktop_restart_candidates()
    return {
        "status": "ok" if detected else "retry",
        "reason": "codex-desktop-started" if detected else "codex-desktop-start-not-detected",
        "executablePath": resolved_path,
        "detectedAfterStart": bool(detected),
    }


def restart_codex_desktop_app() -> dict[str, Any]:
    candidates = desktop_restart_candidates()
    if not candidates:
        return start_codex_desktop_app()
    candidate = candidates[0]
    executable_path = str(candidate.get("executablePath") or "").strip()
    process_id = int(candidate.get("processId") or 0)
    if not executable_path or process_id <= 0:
        return start_codex_desktop_app(executable_path)
    stop_script = f"Stop-Process -Id {process_id} -Force"
    stop_result = subprocess.run(["powershell", "-NoProfile", "-Command", stop_script], capture_output=True, text=True, check=False)
    if stop_result.returncode != 0:
        return {
            "status": "retry",
            "reason": "codex-desktop-stop-failed",
            "detail": (stop_result.stderr or stop_result.stdout or "").strip(),
            "processId": process_id,
            "executablePath": executable_path,
        }
    time.sleep(2)
    start_result = start_codex_desktop_app(executable_path)
    if start_result.get("status") != "ok":
        start_result["processId"] = process_id
        return start_result
    start_result["processId"] = process_id
    start_result["reason"] = "codex-desktop-restarted"
    return start_result


def command_health(_args: argparse.Namespace) -> int:
    now = now_local()
    states = load_all_states()
    index = build_queue_index(states, now)
    output = {
        "status": "ok",
        "health": summarize_health(states, now),
        "indexPreview": index["stats"],
    }
    print(json.dumps(output, indent=2))
    return 0


def command_repair(args: argparse.Namespace) -> int:
    with queue_mutation_lock(timeout_seconds=args.lock_timeout_seconds):
        warnings: list[dict[str, Any]] = []
        now = now_local()
        states = load_all_states()
        changes = normalize_reclaimable_states(states, now)
        change_task_ids = [change["taskId"] for change in changes]
        try:
            persist_states(states, change_task_ids)
        except OSError as error:
            return queue_state_write_retry_output(
                warnings=warnings,
                operation="repair",
                task_ids=change_task_ids,
                error=error,
            )
        index = best_effort_write_index(states, now, warnings)
        output = {
            "status": "ok",
            "changes": changes,
            "indexStats": index["stats"],
        }
        best_effort_append_event(warnings, "repair", changes=changes, indexStats=index["stats"], status=output["status"])
        if args.fail_on_unhealthy:
            health = summarize_health(states, now)
            if health["counts"]["malformedInProgressCount"] > 0:
                output["status"] = "blocked"
                maybe_add_warnings(output, warnings)
                print(json.dumps(output, indent=2))
                return 2
        maybe_add_warnings(output, warnings)
        print(json.dumps(output, indent=2))
        return 0


def command_desktop_recover(args: argparse.Namespace) -> int:
    with queue_mutation_lock(timeout_seconds=args.lock_timeout_seconds):
        warnings: list[dict[str, Any]] = []
        now = now_local()
        states = load_all_states()
        index = best_effort_write_index(states, now, warnings)
        counts = queue_counts(index)
        stale_task_ids = stale_meaningful_task_ids(states)
        ledger = load_recovery_ledger()
        last_restart_at = parse_iso(str(ledger.get("lastRestartAt") or ""))
        cooldown_hours = int(ledger.get("cooldownHours") or 2)
        recovery_cooldown_active = last_restart_at is not None and now < last_restart_at + timedelta(hours=cooldown_hours)
        events = recent_queue_events(limit=300)
        latest_changed_repair = latest_repair_with_changes(events)
        latest_progress = latest_progress_event(events)
        latest_progress_time = parse_iso(str((latest_progress or {}).get("timestamp") or ""))
        would_otherwise_idle = counts["queuedCount"] >= args.min_queued_depth and counts["recentlyCompletedCount"] >= 0
        stale_signal_present = bool(stale_task_ids)
        fresh_repair_signal = False
        fresh_repair_time: datetime | None = None
        if latest_changed_repair is not None:
            repair_time = parse_iso(str(latest_changed_repair.get("timestamp") or ""))
            if repair_time is not None and repair_time > now - timedelta(hours=args.stale_window_hours):
                changed_ids = {str(change.get("taskId") or "") for change in (latest_changed_repair.get("changes") or [])}
                if any(task_id in changed_ids for task_id in stale_task_ids):
                    fresh_repair_signal = True
                    fresh_repair_time = repair_time
        progress_after_stale_signal = False
        if fresh_repair_time is not None and latest_progress_time is not None and latest_progress_time > fresh_repair_time:
            progress_after_stale_signal = True
        if last_restart_at is not None and latest_progress_time is not None and latest_progress_time > last_restart_at:
            progress_after_stale_signal = True
        should_restart = would_otherwise_idle and stale_signal_present and fresh_repair_signal and not progress_after_stale_signal
        pending_work_count = counts["queuedCount"] + counts["reclaimableCount"] + counts["inProgressCount"]
        desktop_running = bool(desktop_restart_candidates())
        ledger["lastObservedQueueState"] = {
            "queuedCount": counts["queuedCount"],
            "inProgressCount": counts["inProgressCount"],
            "reclaimableCount": counts["reclaimableCount"],
            "blockedCount": counts["blockedCount"],
            "staleTaskIds": stale_task_ids,
        }
        if not desktop_running and pending_work_count > 0:
            start_result = start_codex_desktop_app()
            ledger["stuckEpisodeActive"] = start_result.get("status") == "ok"
            ledger["lastRestartAt"] = iso_timestamp(now)
            ledger["lastRestartReason"] = "codex-desktop-was-not-running"
            if args.write_ledger:
                persist_recovery_ledger(ledger)
            best_effort_append_event(warnings, "desktop-recovery-start", queueState=ledger["lastObservedQueueState"], startResult=start_result, reason=ledger["lastRestartReason"])
            output = {
                "status": start_result.get("status", "retry"),
                "reason": start_result.get("reason", "desktop-recovery-start-attempted"),
                "indexStats": index["stats"],
                "staleTaskIds": stale_task_ids,
                "restart": start_result,
                "lastRestartAt": ledger["lastRestartAt"],
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 0 if output["status"] == "ok" else 3
        if progress_after_stale_signal:
            ledger["stuckEpisodeActive"] = False
            if args.write_ledger:
                persist_recovery_ledger(ledger)
            best_effort_append_event(warnings, "desktop-recovery-skip", reason="progress-resumed-after-stale-signal", queueState=ledger["lastObservedQueueState"])
            output = {
                "status": "ok",
                "result": "no_restart_progress_resumed",
                "indexStats": index["stats"],
                "staleTaskIds": stale_task_ids,
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 0
        if not should_restart:
            ledger["stuckEpisodeActive"] = bool(stale_task_ids)
            if args.write_ledger:
                persist_recovery_ledger(ledger)
            best_effort_append_event(warnings, "desktop-recovery-skip", reason="stall-signal-not-met", queueState=ledger["lastObservedQueueState"])
            output = {
                "status": "ok",
                "result": "no_restart_signal_not_met",
                "indexStats": index["stats"],
                "staleTaskIds": stale_task_ids,
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 0
        if recovery_cooldown_active:
            ledger["stuckEpisodeActive"] = True
            if args.write_ledger:
                persist_recovery_ledger(ledger)
            best_effort_append_event(warnings, "desktop-recovery-blocked", reason="restart-cooldown-active", queueState=ledger["lastObservedQueueState"], cooldownHours=cooldown_hours, lastRestartAt=ledger.get("lastRestartAt") or "")
            output = {
                "status": "blocked",
                "reason": "restart-cooldown-active",
                "detail": "A recent Codex desktop restart was already attempted for this stuck episode. Wait for the next hourly cycle instead of thrashing.",
                "indexStats": index["stats"],
                "staleTaskIds": stale_task_ids,
                "lastRestartAt": ledger.get("lastRestartAt") or "",
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 6
        restart_result = restart_codex_desktop_app()
        ledger["stuckEpisodeActive"] = restart_result.get("status") == "ok"
        ledger["lastRestartAt"] = iso_timestamp(now)
        ledger["lastRestartReason"] = "healthy-queue-depth-but-stalled-claims-or-completions"
        if args.write_ledger:
            persist_recovery_ledger(ledger)
        best_effort_append_event(warnings, "desktop-recovery-restart", queueState=ledger["lastObservedQueueState"], restartResult=restart_result, reason=ledger["lastRestartReason"])
        output = {
            "status": restart_result.get("status", "retry"),
            "reason": restart_result.get("reason", "desktop-recovery-restart-attempted"),
            "indexStats": index["stats"],
            "staleTaskIds": stale_task_ids,
            "restart": restart_result,
            "lastRestartAt": ledger["lastRestartAt"],
        }
        maybe_add_warnings(output, warnings)
        print(json.dumps(output, indent=2))
        return 0 if output["status"] == "ok" else 3


def ordered_candidates(index: dict[str, Any]) -> list[tuple[str, str]]:
    groups = index.get("groups", {}) or {}
    preferred_groups = ((index.get("selectionPolicy", {}) or {}).get("preferredGroups") or ["reclaimable", "queued"])
    candidates: list[tuple[int, int, int, str, str]] = []
    for group_rank, group_name in enumerate(preferred_groups):
        for entry in groups.get(group_name, []) or []:
            candidates.append((
                group_rank,
                int(entry.get("selectionOrder") or 0),
                task_number(entry["taskId"]),
                group_name,
                entry["taskId"],
            ))
    return [(group_name, task_id) for _group_rank, _selection_order, _task_number, group_name, task_id in sorted(candidates)]


def claim_eligibility_errors(state: dict[str, Any]) -> list[str]:
    if is_proof_task(state):
        return []
    errors = meaningful_contract_errors(state)
    if not review_runtime_verified():
        errors.append(
            "meaningful task is not eligible for this queue lane until "
            f"{REVIEW_RUNTIME_ENV_VAR}={REVIEW_RUNTIME_REQUIRED_VALUE} is set in the current worker session"
        )
    if is_runtime_proof_task(state):
        return errors
    if not runtime_review_path_proven():
        errors.append(
            "ordinary meaningful task is not eligible for this queue lane until "
            "runtime-review-path.json marks the full subagent review path production-ready"
        )
    return errors


def lane_requires_production_ready(skipped_ineligible: list[dict[str, Any]]) -> bool:
    needle = "runtime-review-path.json marks the full subagent review path production-ready"
    for skipped in skipped_ineligible:
        for error in skipped.get("errors", []):
            if needle in str(error):
                return True
    return False


def lane_requires_verified_review_runtime(skipped_ineligible: list[dict[str, Any]]) -> bool:
    needle = f"{REVIEW_RUNTIME_ENV_VAR}={REVIEW_RUNTIME_REQUIRED_VALUE}"
    for skipped in skipped_ineligible:
        for error in skipped.get("errors", []):
            if needle in str(error):
                return True
    return False


def claim_block_details(skipped_ineligible: list[dict[str, Any]]) -> tuple[str, str] | None:
    if not skipped_ineligible:
        return None
    if lane_requires_verified_review_runtime(skipped_ineligible):
        return (
            "review-runtime-not-verified-in-worker-session",
            "This queue lane only admits meaningful work after the current worker session exports "
            f"{REVIEW_RUNTIME_ENV_VAR}={REVIEW_RUNTIME_REQUIRED_VALUE}.",
        )
    if lane_requires_production_ready(skipped_ineligible):
        return (
            "runtime-review-path-not-production-ready",
            "This queue lane only admits ordinary meaningful work after the full subagent review path is production-ready.",
        )
    return (
        "meaningful-task-contract-invalid",
        "Active queue candidates exist, but their meaningful-task contract is not honest or complete enough to claim in this lane.",
    )


def command_claim_next(args: argparse.Namespace) -> int:
    if args.dry_run:
        warnings: list[dict[str, Any]] = []
        now = now_local()
        states = load_all_states()
        repair_changes = normalize_reclaimable_states(states, now)
        index = build_queue_index(states, now)
        skipped_ineligible: list[dict[str, Any]] = []
        for candidate_group, candidate_task_id in ordered_candidates(index):
            current = load_json(task_state_path(candidate_task_id))
            current_group, _issues = classify_task(current, now_local())
            if current_group != candidate_group:
                refreshed_states = load_all_states()
                refreshed_index = build_queue_index(refreshed_states, now_local())
                best_effort_append_event(warnings, "claim-next-retry", reason="candidate-changed-before-claim", expectedGroup=candidate_group, actualGroup=current_group, taskId=candidate_task_id, dryRun=True, indexStats=refreshed_index["stats"])
                output = {
                    "status": "retry",
                    "reason": "candidate-changed-before-claim",
                    "expectedGroup": candidate_group,
                    "actualGroup": current_group,
                    "taskId": candidate_task_id,
                    "indexStats": refreshed_index["stats"],
                }
                maybe_add_warnings(output, warnings)
                print(json.dumps(output, indent=2))
                return 3
            eligibility_errors = claim_eligibility_errors(current)
            if eligibility_errors:
                skipped_ineligible.append({
                    "taskId": candidate_task_id,
                    "claimGroup": candidate_group,
                    "errors": eligibility_errors,
                })
                continue
            output = {
                "status": "ok",
                "result": "dry-run-claimable",
                "taskId": candidate_task_id,
                "claimGroup": candidate_group,
                "taskClass": (current.get("automation", {}) or {}).get("taskClass", "meaningful"),
                "proofTask": is_proof_task(current),
                "statePath": to_repo_relative(task_state_path(candidate_task_id)),
                "specPath": f".agent\\tasks\\{candidate_task_id}\\spec.md",
                "resultPath": f".agent\\tasks\\{candidate_task_id}\\result.md",
                "repairChanges": repair_changes,
                "skippedIneligible": skipped_ineligible,
                "indexStats": index["stats"],
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 0
        block_details = claim_block_details(skipped_ineligible)
        if block_details is not None:
            reason, detail = block_details
            best_effort_append_event(
                warnings,
                "claim-next-blocked",
                dryRun=True,
                reason=reason,
                repairChanges=repair_changes,
                skippedIneligible=skipped_ineligible,
                indexStats=index["stats"],
            )
            output = {
                "status": "blocked",
                "reason": reason,
                "detail": detail,
                "repairChanges": repair_changes,
                "skippedIneligible": skipped_ineligible,
                "indexStats": index["stats"],
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 6
        best_effort_append_event(warnings, "claim-next-no-task", dryRun=True, repairChanges=repair_changes, skippedIneligible=skipped_ineligible, indexStats=index["stats"])
        output = {
            "status": "ok",
            "result": "no_task",
            "repairChanges": repair_changes,
            "skippedIneligible": skipped_ineligible,
            "indexStats": index["stats"],
        }
        maybe_add_warnings(output, warnings)
        print(json.dumps(output, indent=2))
        return 0

    with queue_mutation_lock(timeout_seconds=args.lock_timeout_seconds):
        warnings: list[dict[str, Any]] = []
        now = now_local()
        states = load_all_states()
        repair_changes = normalize_reclaimable_states(states, now)
        if repair_changes:
            repair_task_ids = [change["taskId"] for change in repair_changes]
            try:
                persist_states(states, repair_task_ids)
            except OSError as error:
                return queue_state_write_retry_output(
                    warnings=warnings,
                    operation="claim-next-repair",
                    task_ids=repair_task_ids,
                    error=error,
                )
        index = best_effort_write_index(states, now, warnings)
        skipped_ineligible: list[dict[str, Any]] = []
        skipped_write_blocked: list[dict[str, Any]] = []
        for candidate_group, candidate_task_id in ordered_candidates(index):
            current = load_json(task_state_path(candidate_task_id))
            current_group, _issues = classify_task(current, now_local())
            if current_group != candidate_group:
                refreshed_states = load_all_states()
                refreshed_index = best_effort_write_index(refreshed_states, now_local(), warnings)
                best_effort_append_event(warnings, "claim-next-retry", reason="candidate-changed-before-claim", expectedGroup=candidate_group, actualGroup=current_group, taskId=candidate_task_id, dryRun=False, indexStats=refreshed_index["stats"])
                output = {
                    "status": "retry",
                    "reason": "candidate-changed-before-claim",
                    "expectedGroup": candidate_group,
                    "actualGroup": current_group,
                    "taskId": candidate_task_id,
                    "indexStats": refreshed_index["stats"],
                }
                maybe_add_warnings(output, warnings)
                print(json.dumps(output, indent=2))
                return 3
            eligibility_errors = claim_eligibility_errors(current)
            if eligibility_errors:
                skipped_ineligible.append({
                    "taskId": candidate_task_id,
                    "claimGroup": candidate_group,
                    "errors": eligibility_errors,
                })
                continue

            preview = {
                "status": "ok",
                "result": "claimed",
                "taskId": candidate_task_id,
                "claimGroup": candidate_group,
                "taskClass": (current.get("automation", {}) or {}).get("taskClass", "meaningful"),
                "proofTask": is_proof_task(current),
                "statePath": to_repo_relative(task_state_path(candidate_task_id)),
                "specPath": f".agent\\tasks\\{candidate_task_id}\\spec.md",
                "resultPath": f".agent\\tasks\\{candidate_task_id}\\result.md",
                "repairChanges": repair_changes,
                "skippedIneligible": skipped_ineligible,
                "skippedWriteBlocked": skipped_write_blocked,
                "indexStats": index["stats"],
            }

            claim_time = now_local()
            execution = current.setdefault("execution", {})
            session = current.setdefault("session", {})
            prior_attempt = int(execution.get("attempt") or 0)
            reclaim_reason = execution.get("reclaimReason") or ""
            current["status"] = "in_progress"
            current["phase"] = "automation-claimed"
            session["owner"] = args.owner
            session["sessionId"] = args.session_id
            session["label"] = args.label
            execution["attempt"] = prior_attempt + 1
            execution["claimedAt"] = iso_timestamp(claim_time)
            execution["lastHeartbeatAt"] = iso_timestamp(claim_time)
            execution["leaseDurationMinutes"] = args.lease_minutes
            execution["leaseExpiresAt"] = iso_timestamp(claim_time + timedelta(minutes=args.lease_minutes))
            execution["reclaimReason"] = reclaim_reason if candidate_group == "reclaimable" else ""
            current["lastUpdated"] = iso_timestamp(claim_time)

            try:
                write_json_atomic(task_state_path(candidate_task_id), current)
            except OSError as error:
                if is_write_blocked_error(error):
                    skipped = claim_write_block_skip_record(candidate_task_id, candidate_group, task_state_path(candidate_task_id), error)
                    skipped_write_blocked.append(skipped)
                    warnings.append(warning_record(skipped["reason"], task_state_path(candidate_task_id), "claim-next-skip-candidate", error))
                    best_effort_append_event(
                        warnings,
                        "claim-next-skip-write-blocked",
                        taskId=candidate_task_id,
                        claimGroup=candidate_group,
                        reason=skipped["reason"],
                        detail=skipped["detail"],
                        path=skipped["path"],
                        errorType=skipped["errorType"],
                        errorDetail=skipped["errorDetail"],
                        sessionId=args.session_id,
                    )
                    continue
                return task_state_write_retry_output(
                    warnings=warnings,
                    task_id=candidate_task_id,
                    operation="claim-next",
                    error=error,
                )
            if candidate_group == "reclaimable":
                best_effort_append_event(warnings, "claim-next-reclaimed", taskId=candidate_task_id, priorAttempt=prior_attempt, reclaimReason=reclaim_reason or "reclaimable", sessionId=args.session_id)
            best_effort_append_event(warnings, "claim-next-claimed", taskId=candidate_task_id, claimGroup=candidate_group, taskClass=preview["taskClass"], proofTask=preview["proofTask"], sessionId=args.session_id, skippedIneligible=skipped_ineligible)
            confirmed = load_json(task_state_path(candidate_task_id))
            if confirmed.get("session", {}).get("sessionId") != args.session_id:
                refreshed_states = load_all_states()
                refreshed_index = best_effort_write_index(refreshed_states, now_local(), warnings)
                best_effort_append_event(warnings, "claim-next-lost-claim", taskId=candidate_task_id, sessionId=args.session_id, indexStats=refreshed_index["stats"])
                output = {
                    "status": "lost-claim",
                    "taskId": candidate_task_id,
                    "indexStats": refreshed_index["stats"],
                }
                maybe_add_warnings(output, warnings)
                print(json.dumps(output, indent=2))
                return 4

            updated_states = load_all_states()
            updated_index = best_effort_write_index(updated_states, now_local(), warnings)
            preview["indexStats"] = updated_index["stats"]
            maybe_add_warnings(preview, warnings)
            print(json.dumps(preview, indent=2))
            return 0

        block_details = claim_block_details(skipped_ineligible)
        if block_details is not None:
            reason, detail = block_details
            best_effort_append_event(
                warnings,
                "claim-next-blocked",
                dryRun=False,
                reason=reason,
                repairChanges=repair_changes,
                skippedIneligible=skipped_ineligible,
                indexStats=index["stats"],
            )
            output = {
                "status": "blocked",
                "reason": reason,
                "detail": detail,
                "repairChanges": repair_changes,
                "skippedIneligible": skipped_ineligible,
                "indexStats": index["stats"],
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 6

        if skipped_write_blocked:
            refreshed_states = load_all_states()
            refreshed_index = best_effort_write_index(refreshed_states, now_local(), warnings)
            detail = (
                "Every otherwise-eligible claim candidate hit a Windows task-state write block during claim-next. "
                "Retry after the blocking readers release those task state files, or let the automation self-heal the runner surfaces before retrying."
            )
            best_effort_append_event(
                warnings,
                "claim-next-retry",
                reason="task-state-write-access-denied",
                detail=detail,
                skippedWriteBlocked=skipped_write_blocked,
                indexStats=refreshed_index["stats"],
            )
            output = {
                "status": "retry",
                "reason": "task-state-write-access-denied",
                "detail": detail,
                "skippedWriteBlocked": skipped_write_blocked,
                "indexStats": refreshed_index["stats"],
            }
            maybe_add_warnings(output, warnings)
            print(json.dumps(output, indent=2))
            return 3

        refreshed_states = load_all_states()
        refreshed_index = best_effort_write_index(refreshed_states, now_local(), warnings)
        best_effort_append_event(warnings, "claim-next-no-task", dryRun=False, repairChanges=repair_changes, skippedIneligible=skipped_ineligible, indexStats=refreshed_index["stats"])
        output = {
            "status": "ok",
            "result": "no_task",
            "repairChanges": repair_changes,
            "skippedIneligible": skipped_ineligible,
            "skippedWriteBlocked": skipped_write_blocked,
            "indexStats": refreshed_index["stats"],
        }
        maybe_add_warnings(output, warnings)
        print(json.dumps(output, indent=2))
        return 0


def verify_session(current: dict[str, Any], expected_session_id: str | None) -> None:
    if not expected_session_id:
        raise RuntimeError(f"session id is required for {current.get('taskId')}")
    session = current.get("session", {}) or {}
    owner = session.get("owner") or ""
    actual = session.get("sessionId") or ""
    if owner != OWNER_DEFAULT:
        raise RuntimeError(f"unexpected session owner for {current.get('taskId')}: expected {OWNER_DEFAULT}, found {owner or '<empty>'}")
    if actual != expected_session_id:
        raise RuntimeError(f"session mismatch for {current.get('taskId')}: expected {expected_session_id}, found {actual}")


def command_heartbeat(args: argparse.Namespace) -> int:
    with queue_mutation_lock(timeout_seconds=args.lock_timeout_seconds):
        warnings: list[dict[str, Any]] = []
        now = now_local()
        current = load_json(task_state_path(args.task_id))
        verify_session(current, args.session_id)
        execution = current.setdefault("execution", {})
        if args.phase:
            current["phase"] = args.phase
        execution["lastHeartbeatAt"] = iso_timestamp(now)
        execution["leaseDurationMinutes"] = args.lease_minutes
        execution["leaseExpiresAt"] = iso_timestamp(now + timedelta(minutes=args.lease_minutes))
        current["lastUpdated"] = iso_timestamp(now)
        try:
            write_json_atomic(task_state_path(args.task_id), current)
        except OSError as error:
            return task_state_write_retry_output(
                warnings=warnings,
                task_id=args.task_id,
                operation="heartbeat",
                error=error,
            )
        best_effort_append_event(warnings, "heartbeat", taskId=args.task_id, sessionId=args.session_id, phase=current.get("phase"))
        states = load_all_states()
        index = best_effort_write_index(states, now_local(), warnings)
        output = {
            "status": "ok",
            "taskId": args.task_id,
            "phase": current.get("phase"),
            "indexStats": index["stats"],
        }
        maybe_add_warnings(output, warnings)
        print(json.dumps(output, indent=2))
        return 0


def command_finish(args: argparse.Namespace) -> int:
    with queue_mutation_lock(timeout_seconds=args.lock_timeout_seconds):
        warnings: list[dict[str, Any]] = []
        now = now_local()
        current = load_json(task_state_path(args.task_id))
        verify_session(current, args.session_id)
        if args.status == "done":
            prereq_errors = done_prereq_errors(args.task_id, current)
            if prereq_errors:
                best_effort_append_event(warnings, "finish-prereq-blocked", taskId=args.task_id, sessionId=args.session_id, errors=prereq_errors)
                output = {
                    "status": "blocked",
                    "reason": "done-prerequisites-missing",
                    "taskId": args.task_id,
                    "errors": prereq_errors,
                }
                maybe_add_warnings(output, warnings)
                print(json.dumps(output, indent=2))
                return 6
        execution = current.setdefault("execution", {})
        current["status"] = args.status
        current["phase"] = args.phase or ("completed" if args.status == "done" else "blocked")
        execution["lastHeartbeatAt"] = iso_timestamp(now)
        execution["leaseExpiresAt"] = iso_timestamp(now)
        current["lastUpdated"] = iso_timestamp(now)
        if args.status == "blocked":
            current["blockers"] = [{"summary": text} for text in args.blocker]
        try:
            write_json_atomic(task_state_path(args.task_id), current)
        except OSError as error:
            return task_state_write_retry_output(
                warnings=warnings,
                task_id=args.task_id,
                operation="finish",
                error=error,
            )
        best_effort_append_event(warnings, "finish", taskId=args.task_id, sessionId=args.session_id, state=args.status, phase=current.get("phase"), blockers=current.get("blockers", []))
        states = load_all_states()
        index = best_effort_write_index(states, now_local(), warnings)
        output = {
            "status": "ok",
            "taskId": args.task_id,
            "state": args.status,
            "phase": current.get("phase"),
            "indexStats": index["stats"],
        }
        maybe_add_warnings(output, warnings)
        print(json.dumps(output, indent=2))
        return 0


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description="SpeakLocal repo-local queue helper")
    subparsers = parser.add_subparsers(dest="command", required=True)

    health_parser = subparsers.add_parser("health", help="Show queue health without writing")
    health_parser.set_defaults(func=command_health)

    repair_parser = subparsers.add_parser("repair", help="Normalize reclaimable states and rewrite queue-index")
    repair_parser.add_argument("--fail-on-unhealthy", action="store_true")
    repair_parser.add_argument("--lock-timeout-seconds", type=int, default=DEFAULT_LOCK_TIMEOUT_SECONDS)
    repair_parser.set_defaults(func=command_repair)

    desktop_recover_parser = subparsers.add_parser("desktop-recover", help="Detect a stuck desktop queue episode and restart Codex desktop once when safe")
    desktop_recover_parser.add_argument("--min-queued-depth", type=int, default=6)
    desktop_recover_parser.add_argument("--stale-window-hours", type=int, default=2)
    desktop_recover_parser.add_argument("--write-ledger", action="store_true")
    desktop_recover_parser.add_argument("--lock-timeout-seconds", type=int, default=DEFAULT_LOCK_TIMEOUT_SECONDS)
    desktop_recover_parser.set_defaults(func=command_desktop_recover)

    claim_parser = subparsers.add_parser("claim-next", help="Repair, rebuild, then claim the next eligible task")
    claim_parser.add_argument("--owner", default=OWNER_DEFAULT)
    claim_parser.add_argument("--session-id", required=True)
    claim_parser.add_argument("--label", default="Codex desktop queue")
    claim_parser.add_argument("--lease-minutes", type=int, default=DEFAULT_LEASE_MINUTES)
    claim_parser.add_argument("--dry-run", action="store_true")
    claim_parser.add_argument("--lock-timeout-seconds", type=int, default=DEFAULT_LOCK_TIMEOUT_SECONDS)
    claim_parser.set_defaults(func=command_claim_next)

    heartbeat_parser = subparsers.add_parser("heartbeat", help="Refresh task heartbeat and optionally change phase")
    heartbeat_parser.add_argument("--task-id", required=True)
    heartbeat_parser.add_argument("--phase")
    heartbeat_parser.add_argument("--session-id", required=True)
    heartbeat_parser.add_argument("--lease-minutes", type=int, default=DEFAULT_LEASE_MINUTES)
    heartbeat_parser.add_argument("--lock-timeout-seconds", type=int, default=DEFAULT_LOCK_TIMEOUT_SECONDS)
    heartbeat_parser.set_defaults(func=command_heartbeat)

    finish_parser = subparsers.add_parser("finish", help="Mark a task done or blocked and rebuild queue-index")
    finish_parser.add_argument("--task-id", required=True)
    finish_parser.add_argument("--status", required=True, choices=["done", "blocked"])
    finish_parser.add_argument("--phase")
    finish_parser.add_argument("--session-id", required=True)
    finish_parser.add_argument("--blocker", action="append", default=[])
    finish_parser.add_argument("--lock-timeout-seconds", type=int, default=DEFAULT_LOCK_TIMEOUT_SECONDS)
    finish_parser.set_defaults(func=command_finish)

    return parser


def main(argv: list[str]) -> int:
    if globals().get("__name__") == "__main__":
        print(json.dumps({
            "status": "error",
            "reason": "queue-tool-direct-launch-not-supported",
            "expectedLauncher": "Invoke-SpeakLocalQueueTool",
            "expectedRepoRoot": CANONICAL_REPO_ROOT,
        }, indent=2))
        return 5
    resolved_root = normalize_root_value(str(REPO_ROOT))
    if resolved_root not in ALLOWED_REAL_ROOTS:
        print(json.dumps({
            "status": "error",
            "reason": "queue-tool-not-running-from-allowed-repo-root",
            "resolvedRepoRoot": str(REPO_ROOT),
            "expectedRepoRoot": CANONICAL_REPO_ROOT,
            "allowedRealRoots": sorted(ALLOWED_REAL_ROOTS),
        }, indent=2))
        return 5
    parser = build_parser()
    args = parser.parse_args(argv)
    try:
        return args.func(args)
    except TimeoutError as exc:
        append_event_quiet("lock-timeout", detail=str(exc), argv=argv)
        print(json.dumps({"status": "retry", "reason": "lock-timeout", "detail": str(exc)}, indent=2))
        return 7
    except RuntimeError as exc:
        append_event_quiet("session-validation-failed", detail=str(exc), argv=argv)
        print(json.dumps({"status": "blocked", "reason": "session-validation-failed", "detail": str(exc)}, indent=2))
        return 8
    except OSError as exc:
        payload = {
            "status": "retry",
            "reason": "os-error",
            "errorType": type(exc).__name__,
            "detail": str(exc),
        }
        if exc.filename:
            payload["path"] = output_path_label(Path(exc.filename))
        append_event_quiet("os-error", detail=str(exc), errorType=type(exc).__name__, path=payload.get("path"), argv=argv)
        print(json.dumps(payload, indent=2))
        return 9


if __name__ == "__main__":
    raise SystemExit(main(sys.argv[1:]))
