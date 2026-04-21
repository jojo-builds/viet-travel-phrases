# T-043 path alias and atomic-write audit

## Scope
- Task: T-043
- Session: `18398a0b-4014-4201-b8cf-afe7365d1651`
- Label: `queue-burnin-r2-recovery-20260419-0958`
- Audit time: 2026-04-19 morning CDT

## Commands run
1. `py -c "from pathlib import Path; import os; repo=Path(r'E:\AI\SpeakLocal-App-Family'); alias=Path(r'E:\AI\Viet-Travel-Phrases'); print('repo_resolved=', repo.resolve()); print('alias_resolved=', alias.resolve()); print('samefile=', os.path.samefile(repo, alias)); print('repo_exists=', repo.exists()); print('alias_exists=', alias.exists())"`
2. `py -c "import importlib.util, pathlib; ... load queue_tool ... print('REPO_ROOT=', mod.REPO_ROOT); print('ALLOWED_REAL_ROOTS=', sorted(mod.ALLOWED_REAL_ROOTS)); print('to_repo_relative_alias=', mod.to_repo_relative(repo / '.agent' / 'coordination' / 'queue-index.json')); print('path_from_relative=', mod.path_from_repo_reference('.agent\\tasks\\T-043\\result.md')); print('path_from_absolute=', mod.path_from_repo_reference(r'E:\AI\SpeakLocal-App-Family\\.agent\\tasks\\T-043\\result.md'));"`
3. `py -c "... mod.write_json_atomic(alias_target, payload) ... canonical_target.read_text() ..."`

## Evidence
### Path alias check
- `E:\AI\SpeakLocal-App-Family` resolved to `E:\AI\Viet-Travel-Phrases` in this runtime.
- `E:\AI\Viet-Travel-Phrases` resolved to `E:\AI\Viet-Travel-Phrases`.
- `os.path.samefile(repo, alias)` returned `True`.
- Both roots existed.

### queue_tool path behavior
- `queue_tool.py` loaded with `REPO_ROOT=E:\AI\Viet-Travel-Phrases` because `Path(__file__).resolve()` collapsed the junction/alias.
- `ALLOWED_REAL_ROOTS` includes both `e:\ai\speaklocal-app-family` and `e:\ai\viet-travel-phrases`, so startup gate accepted the resolved alias root.
- `to_repo_relative()` returned `.agent\coordination\queue-index.json` for the alias-path queue index, so relative reporting stayed stable.
- `path_from_repo_reference('.agent\\tasks\\T-043\\result.md')` expanded under `E:\AI\Viet-Travel-Phrases`, not the canonical `SpeakLocal-App-Family` spelling.
- `path_from_repo_reference()` preserved an absolute canonical path unchanged.

### Atomic write smoke check
- Wrote task-local JSON through alias path: `E:\AI\Viet-Travel-Phrases\.agent\tasks\T-043\logs\atomic-write-smoke.json`.
- Read back the same file through canonical path: `E:\AI\SpeakLocal-App-Family\.agent\tasks\T-043\logs\atomic-write-smoke.json`.
- `samefile=True` and the written probe value was readable immediately, so the helper's temp-file-plus-replace flow worked on this junctioned surface.

## Findings
1. The alias patch looks effective for this machine. The helper accepts the resolved alias root and still produces repo-relative paths cleanly.
2. Relative artifact expansion depends on resolved `REPO_ROOT`, so logs/output may appear under alias spelling in command output even when operators launched from the canonical spelling. That is recoverable, but mildly confusing during manual debugging.
3. Absolute artifact paths are safest for cross-operator breadcrumbs because they bypass alias-root ambiguity.
4. `replace_with_retry()` appears resilient enough for the tested alias/canonical same-file case. I did not reproduce a replace failure inside the allowed task scope.

## Remaining edge cases to watch
- If a future machine lacks the `E:\AI\Viet-Travel-Phrases` alias but still resolves `__file__` differently, relative artifact expansion could point at a valid-but-unexpected root spelling or fail the allowed-root gate.
- If two operators compare logs using different root spellings, event output may look inconsistent even when both point to the same file.
- The fallback `resolved_destination` retry path only helps when the destination can be resolved locally. Broken parent links or cross-volume temp destinations would still fail hard.

## Recommendation
- For future operator recovery, prefer recording both the repo-relative path and the fully resolved absolute path in failure or repair events when alias/junction handling matters.
- No shared-file patch was made in this proof task.
