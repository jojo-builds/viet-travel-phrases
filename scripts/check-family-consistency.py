#!/usr/bin/env python3
from __future__ import annotations

import argparse
import json
import subprocess
import sys
from pathlib import Path


def parse_args() -> argparse.Namespace:
    parser = argparse.ArgumentParser(description="Check the SpeakLocal family repo for contract drift.")
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


def run_node_json(repo_root: Path, script: str, *args: str) -> dict:
    completed = subprocess.run(
        ["node", "-e", script, *args],
        cwd=repo_root,
        text=True,
        capture_output=True,
        check=True,
    )
    return json.loads(completed.stdout)


def path_from_registry_runtime(app_family_root: Path, runtime_value: str) -> Path:
    trimmed = runtime_value.removeprefix("./")
    return app_family_root / f"{trimmed}.ts"


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

    registry = run_node_json(
        repo_root,
        (
            "const { appRegistry, supportedAppVariants } = require(process.argv[1]);"
            "console.log(JSON.stringify({ appRegistry, supportedAppVariants }));"
        ),
        str(repo_root / "app" / "family" / "appRegistry.js"),
    )

    app_family_root = repo_root / "app" / "family"
    supported_variants = registry["supportedAppVariants"]
    if not supported_variants:
        errors.append("appRegistry.js returned no supported variants.")

    for variant in supported_variants:
        definition = registry["appRegistry"][variant]
        manifest_path = repo_root / "ops" / "apps" / f"{variant}.json"
        if not manifest_path.exists():
            errors.append(f"Missing operator manifest for variant '{variant}'.")
            continue

        manifest = load_json(manifest_path)
        if manifest.get("variant") != variant:
            errors.append(f"ops/apps/{variant}.json has mismatched variant '{manifest.get('variant')}'.")
        if manifest.get("displayName") != definition["build"]["name"]:
            errors.append(
                f"ops/apps/{variant}.json displayName '{manifest.get('displayName')}' "
                f"does not match appRegistry name '{definition['build']['name']}'."
            )
        if manifest.get("appId") != definition["build"]["slug"]:
            errors.append(
                f"ops/apps/{variant}.json appId '{manifest.get('appId')}' "
                f"does not match appRegistry slug '{definition['build']['slug']}'."
            )
        if manifest.get("sessionRoot") != contract["canonicalSessionRoot"]:
            errors.append(
                f"ops/apps/{variant}.json sessionRoot '{manifest.get('sessionRoot')}' "
                f"does not match canonical session root."
            )

        for field in contract["requiredFields"]:
            if field not in manifest:
                errors.append(f"ops/apps/{variant}.json is missing required field '{field}'.")
        for gate_key in contract["testingGateKeys"]:
            if gate_key not in manifest.get("testingGates", {}):
                errors.append(f"ops/apps/{variant}.json is missing testing gate '{gate_key}'.")

        for runtime_key in ("packModule", "presentationModule", "audioModule", "storageModule"):
            runtime_path = path_from_registry_runtime(app_family_root, definition["runtime"][runtime_key])
            if not runtime_path.exists():
                errors.append(
                    f"Runtime module for variant '{variant}' is missing: {runtime_path.relative_to(repo_root)}"
                )

        app_config = run_node_json(
            repo_root,
            (
                "process.env.EXPO_PUBLIC_APP_VARIANT = process.argv[2];"
                "const loadConfig = require(process.argv[1]);"
                "const config = loadConfig();"
                "console.log(JSON.stringify({"
                "name: config.expo.name,"
                "slug: config.expo.slug,"
                "scheme: config.expo.scheme,"
                "bundleIdentifier: config.expo.ios.bundleIdentifier,"
                "packageName: config.expo.android.package,"
                "appVariant: config.expo.extra.appVariant,"
                "easProjectId: config.expo.extra.eas ? config.expo.extra.eas.projectId : ''"
                "}));"
            ),
            str(repo_root / "app" / "app.config.js"),
            variant,
        )

        expected = definition["build"]
        for key, expected_value in (
            ("name", expected["name"]),
            ("slug", expected["slug"]),
            ("scheme", expected["scheme"]),
            ("bundleIdentifier", expected["bundleIdentifier"]),
            ("packageName", expected["packageName"]),
            ("appVariant", expected["appVariant"]),
        ):
            if app_config.get(key) != expected_value:
                errors.append(
                    f"app.config.js for variant '{variant}' returned {key}='{app_config.get(key)}' "
                    f"but appRegistry expects '{expected_value}'."
                )

        expected_eas_project = expected.get("easProjectId", "")
        if app_config.get("easProjectId", "") != expected_eas_project:
            errors.append(
                f"app.config.js for variant '{variant}' returned easProjectId='{app_config.get('easProjectId')}' "
                f"but appRegistry expects '{expected_eas_project}'."
            )

    actual_repo_root = str(repo_root)
    canonical_root = contract["canonicalSessionRoot"]
    if actual_repo_root != canonical_root:
        notes.append(
            f"Repo is operating from compatibility path '{actual_repo_root}' while canonical root is '{canonical_root}'."
        )

    if errors:
        print("SpeakLocal family consistency check FAILED")
        for error in errors:
            print(f"- {error}")
        for note in notes:
            print(f"note: {note}")
        return 1

    print("SpeakLocal family consistency check passed.")
    print(f"canonical_root: {canonical_root}")
    print(f"repo_root: {actual_repo_root}")
    print(f"supported_variants: {', '.join(supported_variants)}")
    for note in notes:
        print(f"note: {note}")
    return 0


if __name__ == "__main__":
    try:
        raise SystemExit(main())
    except subprocess.CalledProcessError as error:
        if error.stderr:
            print(error.stderr.strip(), file=sys.stderr)
        raise
