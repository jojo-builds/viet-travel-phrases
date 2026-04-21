#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Summarize the current SpeakLocal family repo state.")
    parser.add_argument("--repo-root", type=Path, default=None, help="Repo root to inspect.")
    return parser.parse_args()


def resolve_repo_root(raw_root: Path | None) -> Path:
    if raw_root is not None:
      return raw_root.resolve()
    return Path(__file__).resolve().parents[1]


def load_json(path: Path) -> dict:
    return json.loads(path.read_text(encoding="utf-8-sig"))


def load_project_meta(path: Path) -> dict[str, str]:
    values: dict[str, str] = {}
    for raw_line in path.read_text(encoding="utf-8").splitlines():
        line = raw_line.strip()
        if not line or line.startswith("#") or ":" not in line:
            continue
        key, value = line.split(":", 1)
        values[key.strip()] = value.strip().strip("'\"")
    return values


def extract_numbered_items(markdown_path: Path, heading: str) -> list[str]:
    lines = markdown_path.read_text(encoding="utf-8").splitlines()
    in_section = False
    items: list[str] = []

    for line in lines:
        stripped = line.strip()
        if stripped == heading:
            in_section = True
            continue
        if in_section and stripped.startswith("## "):
            break
        if in_section and stripped and stripped[0].isdigit() and ". " in stripped:
            _, item = stripped.split(". ", 1)
            items.append(item.strip())

    return items


def extract_bullets(markdown_path: Path, heading: str) -> list[str]:
    lines = markdown_path.read_text(encoding="utf-8").splitlines()
    in_section = False
    items: list[str] = []

    for line in lines:
        stripped = line.strip()
        if stripped == heading:
            in_section = True
            continue
        if in_section and stripped.startswith("## "):
            break
        if in_section and stripped.startswith("- "):
            items.append(stripped[2:].strip())

    return items


def main() -> int:
    args = parse_args()
    repo_root = resolve_repo_root(args.repo_root)
    priorities_path = repo_root / "docs" / "PRIORITIES.md"
    blockers_path = repo_root / "docs" / "operations" / "CURRENT_BLOCKERS.md"
    project_meta_path = repo_root / "docs" / "project-meta.yaml"
    contract_path = repo_root / "ops" / "app-manifest-contract.json"
    ops_dir = repo_root / "ops" / "apps"

    contract = load_json(contract_path)
    project_meta = load_project_meta(project_meta_path)
    active_focus = extract_numbered_items(priorities_path, "## Active focus")
    deferred_items = extract_bullets(priorities_path, "## Not doing right now")
    current_blockers = extract_numbered_items(blockers_path, "## Current blockers to shipping Viet v2")

    app_summaries = []
    for manifest_path in sorted(ops_dir.glob("*.json")):
        manifest = load_json(manifest_path)
        app_summaries.append(
            {
                "variant": manifest["variant"],
                "stage": manifest["stage"],
                "releaseStatus": manifest["releaseStatus"],
                "blockerTag": manifest["blockerTag"],
                "hardBlockActive": manifest["hardBlock"]["active"],
                "nextStep": manifest["nextStep"],
            }
        )

    print("SpeakLocal family summary")
    print(f"repo_root: {repo_root}")
    print(f"canonical_root: {contract['canonicalSessionRoot']}")
    print(f"project: {project_meta.get('project', 'unknown')}")
    print(f"lane: {project_meta.get('lane', 'unknown')}")
    print(f"priority: {project_meta.get('priority', 'unknown')}")
    print()

    if active_focus:
        print(f"current_family_priority: {active_focus[0]}")
        print("legal_next_actions:")
        for item in active_focus[:4]:
            print(f"- {item}")
        print()

    if current_blockers:
        print(f"current_blocked_item: {current_blockers[0]}")
        print()

    print("variant_summary:")
    for summary in app_summaries:
        print(
            f"- {summary['variant']}: stage={summary['stage']}, "
            f"release={summary['releaseStatus']}, blocker={summary['blockerTag']}, "
            f"hardBlockActive={str(summary['hardBlockActive']).lower()}"
        )
        print(f"  nextStep: {summary['nextStep']}")
    print()

    if deferred_items:
        print("deferred_actions:")
        for item in deferred_items:
            print(f"- {item}")

    return 0


if __name__ == "__main__":
    raise SystemExit(main())
