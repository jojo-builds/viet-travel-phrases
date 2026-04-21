# Task Spec: T-001

## Title
Repo-local workflow pilot dry run

## Objective
Prove the phase-1 OpenClaw ↔ Codex repo-local contract/result workflow on SpeakLocal without making meaningful product-code changes.
Create and complete a dry-run task lifecycle that exercises task contract reading, state updates, lock ownership, and result handoff using the new `.agent/` protocol.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/coordination/locks.yaml`
- `.agent/tasks/TEMPLATE/spec.md`
- `.agent/tasks/TEMPLATE/state.json`
- `.agent/tasks/TEMPLATE/result.md`

## Scope
### Allowed write scopes
- `.agent/coordination/locks.yaml`
- `.agent/tasks/T-001/**`

### Allowed read scopes
- repo root and docs only as needed for orientation

### Must not touch
- `app/**`
- `site/**`
- `content-draft/**`
- `docs/operations/**`
- `ops/apps/**`
- any production code, content, or release files

## Source-of-truth notes
- This task changes workflow-prep truth only.
- It does not change live app, website, content, build, or release truth.
- Any conclusion from this run should be recorded as planning truth, not live product truth.

## Required checks
- verify that `state.json` can move through a minimal lifecycle: `draft` -> `running` -> `done`
- verify that `locks.yaml` can record task ownership without becoming noisy
- verify that `result.md` stays compact and useful
- verify that the task can complete without needing long prompt prose

## Review gate
- lightweight self-check only for this dry run
- reviewer should challenge whether the protocol stayed lean, inspectable, and token-conscious

## Definition of done
- task folder contains a meaningful `state.json` and final `result.md`
- `locks.yaml` records and then releases the dry-run ownership cleanly
- no product-code or ops-truth files changed
- output clearly states what worked, what felt awkward, and what should change before the first real implementation pilot

## Blocker rule
- do not invent extra infrastructure if the dry run can be completed with the current phase-1 files
- if the protocol feels awkward, record the awkwardness rather than expanding scope mid-task

## Token discipline
- treat this file as the main task contract
- do not paste full files, full diffs, or long logs into `result.md`
- use concise notes and direct artifact references only

## Required result contract
Before stopping, write `result.md` using the repo template shape.
