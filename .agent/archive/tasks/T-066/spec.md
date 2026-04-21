# Task Spec: T-066

## Title
Desktop Codex automation pilot, Vietnam website starter runtime fetch and audio reachability audit

## Objective
Run the next bounded website validation pass after the export-seam audit by checking runtime-facing fetch paths, starter-module loading assumptions, and website-safe audio reachability for the current Vietnam starter surfaces, then fix only genuinely bounded website/content issues if needed.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/coordination/queue-index.json`
- `.agent/coordination/locks.yaml`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- relevant Vietnam starter surfaces under `site/**`
- `site/data/phrase-previews/**`
- `site/public/data/phrase-previews/**`
- `content-draft/viet/website-preview.json`
- `.agent/tasks/T-015/result.md`

## Task type
- website runtime audit
- starter-surface validation
- bounded seam repair if needed

## Scope
### Allowed write scopes
- `.agent/tasks/T-066/**`
- `.agent/coordination/queue-index.json`
- `site/**`
- `docs/**` within website-facing truth only

### Allowed read scopes
- `content-draft/viet/**`
- `app/family/packs/**`
- `app/assets/audio/**`

### Must not touch
- `app/**` as a broad write surface outside website-safe seams
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- unrelated content-draft lanes

## Source-of-truth notes
- This task extends the already-complete export-seam audit; do not reopen that no-repair conclusion unless runtime-facing evidence requires it.
- Keep scope on Vietnam starter website behavior and website-safe audio reachability.
- Do not introduce premium-on-web or broad website strategy drift.

## Required outputs
Create or update these files:
- `.agent/tasks/T-066/logs/runtime-audit.md`
- `.agent/tasks/T-066/result.md`
- any bounded `site/**` or website-facing `docs/**` files only if the audit finds a real defect worth fixing
- exactly 4 review artifacts for each required review gate under `.agent/tasks/T-066/reviews/`

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-runtime-fetch-review.md`
2. `02-audio-reachability-review.md`
3. `03-website-scope-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the audit/fix pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify the runtime audit artifact exists
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify any touched website files stay inside the current starter-on-web boundary

## Definition of done
- Vietnam website runtime-facing starter truth is either improved or more honestly documented in a bounded way
- required outputs exist
- all 3 review gates passed with unanimous 4-subagent approval
- task state and result artifact agree on completion status

## Required result contract
Before stopping, write `.agent/tasks/T-066/result.md` with the standard task result shape.
