from __future__ import annotations

import contextlib
import importlib.util
import io
import json
import tempfile
import unittest
from datetime import datetime, timedelta
from pathlib import Path
from types import SimpleNamespace


QUEUE_TOOL_PATH = Path(__file__).resolve().parents[1] / "queue_tool.py"


def load_queue_tool():
    spec = importlib.util.spec_from_file_location("queue_tool_under_test", QUEUE_TOOL_PATH)
    module = importlib.util.module_from_spec(spec)
    assert spec.loader is not None
    spec.loader.exec_module(module)
    return module


def proof_state(task_id: str, status: str, phase: str, locks: list[str], selection_order: int) -> dict:
    return {
        "taskId": task_id,
        "title": task_id,
        "status": status,
        "phase": phase,
        "repoRoot": "",
        "cwd": "",
        "session": {"owner": "codex-desktop-automation", "sessionId": "", "label": ""},
        "execution": {
            "attempt": 0,
            "claimedAt": "",
            "lastHeartbeatAt": "",
            "heartbeatEveryMinutes": 10,
            "leaseDurationMinutes": 120,
            "leaseExpiresAt": "",
            "reclaimReason": "",
        },
        "locks": {"write": locks, "read": [], "blockedBy": []},
        "truthClassification": {"target": "test"},
        "blockers": [],
        "artifacts": {"result": f".agent/tasks/{task_id}/result.md", "reviews": f".agent/tasks/{task_id}/reviews/"},
        "lastUpdated": "2026-04-29T00:00:00+00:00",
        "automation": {
            "runner": "desktop-codex",
            "mode": "single-task",
            "taskClass": "proof",
            "proofTask": True,
            "selectionOrder": selection_order,
        },
    }


class QueueToolLockConflictTests(unittest.TestCase):
    def test_write_lock_conflicts_cover_exact_and_path_descendants(self):
        queue_tool = load_queue_tool()

        self.assertTrue(queue_tool.write_locks_conflict("ios_family_shared_ui", "ios_family_shared_ui"))
        self.assertTrue(queue_tool.write_locks_conflict("native-ios/App/**", "native-ios/App/Models/PhrasePage.swift"))
        self.assertTrue(queue_tool.write_locks_conflict("native-ios/App/Models/PhrasePage.swift", "native-ios/App/**"))
        self.assertFalse(queue_tool.write_locks_conflict("native-ios/App/**", "native-ios/Resources/viet-phrase-catalog.json"))
        self.assertFalse(queue_tool.write_locks_conflict("agent_task_T-161", "agent_task_T-160"))

    def test_claim_next_dry_run_skips_conflicting_candidate_then_reports_next_claimable(self):
        queue_tool = load_queue_tool()

        with tempfile.TemporaryDirectory() as tmp_dir:
            repo_root = Path(tmp_dir)
            agent_root = repo_root / ".agent"
            tasks_root = agent_root / "tasks"
            coordination_root = agent_root / "coordination"
            tasks_root.mkdir(parents=True)
            coordination_root.mkdir(parents=True)

            originals = {
                "REPO_ROOT": queue_tool.REPO_ROOT,
                "AGENT_ROOT": queue_tool.AGENT_ROOT,
                "TASKS_ROOT": queue_tool.TASKS_ROOT,
                "INDEX_PATH": queue_tool.INDEX_PATH,
                "LOCK_ROOT": queue_tool.LOCK_ROOT,
                "EVENT_LOG_PATH": queue_tool.EVENT_LOG_PATH,
                "RUNTIME_REVIEW_STATUS_PATH": queue_tool.RUNTIME_REVIEW_STATUS_PATH,
                "CANONICAL_REPO_ROOT": queue_tool.CANONICAL_REPO_ROOT,
            }
            queue_tool.REPO_ROOT = repo_root
            queue_tool.AGENT_ROOT = agent_root
            queue_tool.TASKS_ROOT = tasks_root
            queue_tool.INDEX_PATH = coordination_root / "queue-index.json"
            queue_tool.LOCK_ROOT = coordination_root / ".queue-locks"
            queue_tool.EVENT_LOG_PATH = coordination_root / "queue-events.jsonl"
            queue_tool.RUNTIME_REVIEW_STATUS_PATH = coordination_root / "runtime-review-path.json"
            queue_tool.CANONICAL_REPO_ROOT = str(repo_root)

            try:
                now = datetime.now().astimezone()
                active = proof_state("T-001", "in_progress", "working", ["native-ios/App/**", "agent_task_T-001"], 0)
                active["session"]["sessionId"] = "active-session"
                active["execution"]["claimedAt"] = queue_tool.iso_timestamp(now - timedelta(minutes=5))
                active["execution"]["lastHeartbeatAt"] = queue_tool.iso_timestamp(now)
                active["execution"]["leaseExpiresAt"] = queue_tool.iso_timestamp(now + timedelta(minutes=120))

                conflicting = proof_state(
                    "T-002",
                    "queued",
                    "queued-for-desktop-codex",
                    ["native-ios/App/Models/PhrasePage.swift", "agent_task_T-002"],
                    1,
                )
                non_conflicting = proof_state(
                    "T-003",
                    "queued",
                    "queued-for-desktop-codex",
                    ["docs/queue.md", "agent_task_T-003"],
                    2,
                )

                for state in [active, conflicting, non_conflicting]:
                    task_dir = tasks_root / state["taskId"]
                    task_dir.mkdir()
                    (task_dir / "state.json").write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")

                args = SimpleNamespace(
                    dry_run=True,
                    owner=queue_tool.OWNER_DEFAULT,
                    session_id="dry-run-session",
                    label="test",
                    lease_minutes=120,
                    lock_timeout_seconds=1,
                )
                output = io.StringIO()
                with contextlib.redirect_stdout(output):
                    exit_code = queue_tool.command_claim_next(args)

                self.assertEqual(exit_code, 0)
                payload = json.loads(output.getvalue())
                self.assertEqual(payload["result"], "dry-run-claimable")
                self.assertEqual(payload["taskId"], "T-003")
                self.assertEqual(payload["skippedLockConflicts"][0]["taskId"], "T-002")
                self.assertEqual(payload["skippedLockConflicts"][0]["conflicts"][0]["activeTaskId"], "T-001")
            finally:
                for name, value in originals.items():
                    setattr(queue_tool, name, value)

    def test_real_claim_write_block_does_not_create_phantom_active_conflict(self):
        queue_tool = load_queue_tool()

        with tempfile.TemporaryDirectory() as tmp_dir:
            repo_root = Path(tmp_dir)
            agent_root = repo_root / ".agent"
            tasks_root = agent_root / "tasks"
            coordination_root = agent_root / "coordination"
            tasks_root.mkdir(parents=True)
            coordination_root.mkdir(parents=True)

            originals = {
                "REPO_ROOT": queue_tool.REPO_ROOT,
                "AGENT_ROOT": queue_tool.AGENT_ROOT,
                "TASKS_ROOT": queue_tool.TASKS_ROOT,
                "INDEX_PATH": queue_tool.INDEX_PATH,
                "LOCK_ROOT": queue_tool.LOCK_ROOT,
                "EVENT_LOG_PATH": queue_tool.EVENT_LOG_PATH,
                "RUNTIME_REVIEW_STATUS_PATH": queue_tool.RUNTIME_REVIEW_STATUS_PATH,
                "CANONICAL_REPO_ROOT": queue_tool.CANONICAL_REPO_ROOT,
                "write_json_atomic": queue_tool.write_json_atomic,
            }
            queue_tool.REPO_ROOT = repo_root
            queue_tool.AGENT_ROOT = agent_root
            queue_tool.TASKS_ROOT = tasks_root
            queue_tool.INDEX_PATH = coordination_root / "queue-index.json"
            queue_tool.LOCK_ROOT = coordination_root / ".queue-locks"
            queue_tool.EVENT_LOG_PATH = coordination_root / "queue-events.jsonl"
            queue_tool.RUNTIME_REVIEW_STATUS_PATH = coordination_root / "runtime-review-path.json"
            queue_tool.CANONICAL_REPO_ROOT = str(repo_root)

            class FakeWriteBlocked(OSError):
                @property
                def winerror(self):
                    return 5

            def write_json_atomic_with_first_claim_block(path: Path, data: dict):
                if path == queue_tool.task_state_path("T-002") and data.get("status") == "in_progress":
                    raise FakeWriteBlocked("simulated task-state write block")
                originals["write_json_atomic"](path, data)

            queue_tool.write_json_atomic = write_json_atomic_with_first_claim_block

            try:
                blocked_candidate = proof_state(
                    "T-002",
                    "queued",
                    "queued-for-desktop-codex",
                    ["docs/shared.md", "agent_task_T-002"],
                    1,
                )
                next_candidate = proof_state(
                    "T-003",
                    "queued",
                    "queued-for-desktop-codex",
                    ["docs/shared.md", "agent_task_T-003"],
                    2,
                )

                for state in [blocked_candidate, next_candidate]:
                    task_dir = tasks_root / state["taskId"]
                    task_dir.mkdir()
                    (task_dir / "state.json").write_text(json.dumps(state, indent=2) + "\n", encoding="utf-8")

                args = SimpleNamespace(
                    dry_run=False,
                    owner=queue_tool.OWNER_DEFAULT,
                    session_id="real-claim-session",
                    label="test",
                    lease_minutes=120,
                    lock_timeout_seconds=1,
                )
                output = io.StringIO()
                with contextlib.redirect_stdout(output):
                    exit_code = queue_tool.command_claim_next(args)

                self.assertEqual(exit_code, 0)
                payload = json.loads(output.getvalue())
                self.assertEqual(payload["result"], "claimed")
                self.assertEqual(payload["taskId"], "T-003")
                self.assertEqual(payload["skippedWriteBlocked"][0]["taskId"], "T-002")
                self.assertEqual(payload["skippedLockConflicts"], [])

                first_candidate = json.loads((tasks_root / "T-002" / "state.json").read_text(encoding="utf-8"))
                self.assertEqual(first_candidate["status"], "queued")
                self.assertEqual(first_candidate["session"]["sessionId"], "")
            finally:
                for name, value in originals.items():
                    setattr(queue_tool, name, value)


if __name__ == "__main__":
    unittest.main()
