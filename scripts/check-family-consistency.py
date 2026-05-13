#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check SpeakLocal native family contract drift.")
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


def normalize_variant_name(value: str) -> str:
    normalized = value.lower().strip()
    if normalized == "tagalog":
        return "philippines"
    if normalized == "viet":
        return "vietnam"
    if normalized == "japanese":
        return "japan"
    return normalized


def main() -> int:
    args = parse_args()
    repo_root = resolve_repo_root(args.repo_root)
    contract_path = repo_root / "ops" / "app-manifest-contract.json"
    contract = load_json(contract_path)
    project_meta = load_project_meta(repo_root / "docs" / "project-meta.yaml")
    errors: list[str] = []
    notes: list[str] = []

    for marker in contract["audit"]["repoMarkers"]:
        if not (repo_root / marker).exists():
            errors.append(f"Missing required repo marker: {marker}")

    if project_meta.get("authoritative_root") != contract["canonicalSessionRoot"]:
        errors.append(
            "docs/project-meta.yaml authoritative_root does not match "
            "ops/app-manifest-contract.json canonicalSessionRoot."
        )

    native_ios_root = project_meta.get("native_ios_root")
    if native_ios_root != f"{contract['canonicalSessionRoot']}/native-ios":
        errors.append("docs/project-meta.yaml native_ios_root does not point at the canonical native-ios root.")

    for surface_name, surface_path in contract.get("canonicalSurfaces", {}).items():
        if not (repo_root / surface_path).exists():
            errors.append(f"Missing canonical surface '{surface_name}': {surface_path}")

    manifest_dir = repo_root / contract["canonicalSurfaces"]["manifestDir"]
    config_dir = repo_root / contract["canonicalSurfaces"]["dynamicConfig"]
    manifests = sorted(manifest_dir.glob("*.json"))
    if not manifests:
        errors.append("No ops/apps/*.json manifests found.")

    for manifest_path in manifests:
        manifest = load_json(manifest_path)
        variant = manifest.get("variant")
        if manifest_path.stem != variant:
            notes.append(
                f"ops/apps/{manifest_path.name} filename differs from variant '{variant}'. "
                "This is allowed only for historical variant names."
            )

        for field in contract["requiredFields"]:
            if field not in manifest:
                errors.append(f"{manifest_path.relative_to(repo_root)} is missing required field '{field}'.")

        if manifest.get("sessionRoot") != contract["canonicalSessionRoot"]:
            errors.append(
                f"{manifest_path.relative_to(repo_root)} sessionRoot '{manifest.get('sessionRoot')}' "
                "does not match canonical session root."
            )

        for gate_key in contract["testingGateKeys"]:
            if gate_key not in manifest.get("testingGates", {}):
                errors.append(f"{manifest_path.relative_to(repo_root)} is missing testing gate '{gate_key}'.")

        expected_config = config_dir / f"{normalize_variant_name(str(variant))}.json"
        if not expected_config.exists():
            errors.append(
                f"{manifest_path.relative_to(repo_root)} has no native app config at "
                f"{expected_config.relative_to(repo_root)}."
            )

    actual_repo_root = str(repo_root)
    canonical_root = contract["canonicalSessionRoot"]
    if actual_repo_root != canonical_root:
        notes.append(
            f"Repo is operating from feature/worktree path '{actual_repo_root}' while canonical root is '{canonical_root}'."
        )

    if errors:
        print("SpeakLocal native family consistency check FAILED")
        for error in errors:
            print(f"- {error}")
        for note in notes:
            print(f"note: {note}")
        return 1

    print("SpeakLocal native family consistency check passed.")
    print(f"canonical_root: {canonical_root}")
    print(f"repo_root: {actual_repo_root}")
    print(f"manifest_count: {len(manifests)}")
    for note in notes:
        print(f"note: {note}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except json.JSONDecodeError as error:
        print(str(error), file=sys.stderr)
        raise
