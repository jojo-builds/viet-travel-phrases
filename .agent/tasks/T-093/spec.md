# Task Spec: T-093

## Title
Desktop Codex automation pilot, Vietnam website starter export evidence ledger and validator hardening

## Objective
Harden the Vietnam website starter export seam so future workers can prove manifest, payload, and audio-link integrity from repo evidence without reopening brittle manual checks. Leave behind bounded validator or ledger improvements only where current repo truth shows they add real value.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-066/result.md` if present
- `.agent/tasks/T-067/result.md` if present
- `.agent/tasks/T-091/spec.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `content-draft/viet/website-preview.json`
- bounded export or validation code under `site/**` only as needed

## Task type
- bounded website export seam hardening
- evidence-ledger refresh
- validator or checklist improvement

## Scope
### Allowed write scopes
- `.agent/tasks/T-093/**`
- `docs/website/**`
- `site/data/phrase-previews/**`
- `site/public/data/phrase-previews/**`
- bounded export or validation surfaces under `site/**` only if required to make the seam easier to verify honestly

### Allowed read scopes
- `docs/**`
- `site/**`
- `content-draft/viet/**`
- `app/family/packs/**`
- `app/assets/audio/**`

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- release/build/TestFlight files
- unrelated marketing copy or route work that belongs in `website_content_conversion`
- broad strategy docs

## Source-of-truth notes
- Stay inside the export seam, not page-copy strategy.
- Prefer deterministic evidence or validator improvements over hand-written no-proof claims.
- Do not churn exported JSON unless the audit proves a concrete defect or a bounded validator-driven normalization is the cleanest fix.
- Keep claims limited to repo-verifiable manifest, payload, and audio-reference integrity.

## Required outputs
Create or update these files:
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `.agent/tasks/T-093/logs/export-evidence-audit.md`
- `.agent/tasks/T-093/result.md`
- `site/data/phrase-previews/manifest.json` only if a bounded seam fix is justified
- `site/public/data/phrase-previews/manifest.json` only if a bounded seam fix is justified
- any narrowly justified validator or export helper surface under `site/**`
- exactly 4 review artifacts under `.agent/tasks/T-093/reviews/` for each required gate

## Concrete requirement
- verify the two manifest copies still agree and still reflect the current Vietnam starter export truth
- verify the current export seam can be checked deterministically by a future worker without brittle manual inspection
- if the seam is already correct, improve the evidence trail or validator path instead of forcing JSON churn

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-export-integrity-review.md`
2. `02-audio-reference-review.md`
3. `03-validator-utility-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should close each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` agree after the pass
- verify any touched validator or helper surface actually checks the live export seam it claims to check
- verify no app, ops, or unrelated website conversion surfaces changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Vietnam website starter export seam is easier to verify honestly than before
- any repo changes stay bounded to export-seam evidence or validator surfaces
- future workers can confirm the seam without brittle hand edits or broad rereads
- all 3 mandatory review gates passed with unanimous 4-subagent approval
