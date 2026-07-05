# SpeakLocal Vietnam Launch Candidate Reconciliation Goal

## Objective

Turn the current dirty `main` launch payload into a trustworthy, reviewable launch-candidate map. Do not try to make product decisions for Jojo. Classify what exists, prove what is reproducible, and produce a commit-ready staging plan.

## Workspace

- Canonical repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
- Branch: `main`
- Current `main` is dirty and ahead of `origin/main`.
- This is primarily a read-only reconciliation/audit lane.
- Do not revert, reset, checkout away, clean generated files, stage, commit, pull, rebase, or merge.

## Required Context

Read first:

1. `/Users/jojolim/Developer/products/speaklocal/app-family/orchestrator/AGENTS.md`
2. `/Users/jojolim/Developer/products/speaklocal/app-family/AGENTS.md`
3. `docs/operations/LATEST_VALIDATION.md`
4. `docs/operations/CURRENT_BLOCKERS.md`
5. `docs/task-results/deep-visual-qa-2026-07-05/BUG_LEDGER.md`
6. `docs/task-results/launch-readiness-audit-2026-07-04/orchestrator-receipt.md`
7. `docs/task-results/frontend-qa-2026-07-04/BUG_LEDGER.md`

## Work

1. Capture current repo state:
   - branch/ahead status
   - dirty tracked files grouped by domain
   - untracked files grouped by domain
   - generated resources vs source edits vs docs vs build/test artifacts
2. Identify which changes appear to belong to:
   - launch-readiness audit
   - deep visual QA fixes
   - audio remediation
   - generated resource updates
   - unrelated or stale artifacts
3. Check reproducibility for generated resources where practical:
   - run existing validators instead of hand-editing generated files
   - do not regenerate unless the command is known safe and the output target is already dirty
4. Produce a staging plan:
   - must-stage for current launch candidate
   - review-before-stage
   - likely generated collateral
   - leave-untracked / archive / ignore candidates
   - hard blockers before commit
5. Run cheap validation only:
   - `git diff --check`
   - `node scripts/guard-native-only.js`
   - native resource/content validators that do not require credentials
6. Write the report at:
   - `docs/task-results/parallel-goals-2026-07-05/launch-candidate-reconciliation-report.md`

## Stop Conditions

Stop if:

- validation fails after one focused attempt to understand the failure
- a requested cleanup would delete or overwrite user work
- the staging plan depends on a product decision from Jojo

## Reporting

Send compact updates using:

- `**Status Update**`
- `**Decision Needed**`

Final report must include:

- exact dirty tree classification
- validators run and result
- recommended staging groups
- risks before committing
- whether this launch candidate is coherent enough to checkpoint
