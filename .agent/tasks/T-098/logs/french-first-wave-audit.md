# French First-Wave Audit

## Scope

- Task: `T-098`
- Lane: `content-draft/french/**`
- Task artifacts: `.agent/tasks/T-098/**`
- Prep-only boundary preserved; no runtime wiring was added.

## Content outcome

- Translated the top `30` ranked rows in `content-draft/french/first-wave-priority.csv`.
- Added compact ASCII pronunciation helpers to the same `30` rows in `content-draft/french/phrase-source.csv`.
- Kept `french-simple-problems-6` explicitly sensitive as `first-wave-translated-sensitive`.
- Left `french-coffee-shop-4` deferred and untranslated as the known weak-fit row.

## Ledger outcome

- `content-draft/french/phrase-source.csv` now parses with `70` total rows.
- Status split after this pass:
  - `29` rows: `first-wave-translated`
  - `1` row: `first-wave-translated-sensitive`
  - `40` rows: remaining queued or deferred statuses
- `content-draft/french/first-wave-priority.csv` now parses with `70` ranked rows.
- The top `30` ranked rows now all carry `first-wave-translated*` execution states.

## Handoff outcome

- `content-draft/french/README.md` now states that the top `30` rows are translated and that the next pass should start from rank `31`.
- `content-draft/french/source-notes.md` now reflects translated top-wave coverage rather than scaffold-only posture.
- `content-draft/french/research-backlog.md` now marks the top-30 translation and pronunciation steps complete and narrows the remaining work.

## Verification

- `Import-Csv content-draft/french/phrase-source.csv` - passed.
- `Import-Csv content-draft/french/first-wave-priority.csv` - passed.
- Required French outputs and Gate 1 plus Gate 2 review artifacts - present.
- Latest Gate 1 pass: `gate-01-pass-02` with exactly `4` review files and all `Approval: APPROVE`.
- Latest Gate 2 pass: `gate-02-pass-01` with exactly `4` review files and all `Approval: APPROVE`.
- `git status --short -- .agent/tasks/T-098 content-draft/french` shows only task-local and French-lane surfaces for this task.
- Full-repo status remains noisy from unrelated pre-existing work, so forbidden-surface cleanliness can only be asserted for this task's write scope, not for the entire repository.
