# Task Spec: T-091

## Title
Desktop Codex automation pilot, Vietnam website starter trust-panel and reachability evidence refresh

## Objective
Tighten the Vietnam website starter experience so the user-facing trust and audio-availability story matches the actual exported starter data, current site loader behavior, and known evidence limits. Leave behind bounded fixes or doc truth only if they are directly justified by repo evidence.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `.agent/tasks/T-066/result.md`
- `.agent/tasks/T-067/result.md`
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/src/routes/(marketing)/vietnamese/+page.svelte`
- `site/src/data/phrasePreviewManifest.ts`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `content-draft/viet/website-preview.json`

## Task type
- bounded website seam audit
- trust-copy hardening
- reachability evidence refresh

## Scope
### Allowed write scopes
- `.agent/tasks/T-091/**`
- `docs/website/**`
- `site/src/routes/(marketing)/vietnamese/**`
- `site/src/data/**`

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
- unrelated website routes outside the bounded Vietnam starter seam
- export JSON payloads unless the audit proves a concrete seam defect that cannot be fixed in docs or route logic

## Source-of-truth notes
- Keep this task bounded to the Vietnam starter website seam.
- Be honest about what repo evidence can prove. Do not claim browser runtime, deploy, CDN, or real-device success that the repo cannot show.
- Prefer copy, presentation, and loader-surface repairs over churn in generated export JSON.
- If the current repo already matches the best honest posture, leave code unchanged and strengthen the audit evidence instead.

## Required outputs
Create or update these files:
- `docs/website/PHRASE_AUDIO_DELIVERY.md`
- `site/src/data/phrasePreviewManifest.ts` only if a bounded manifest/loader truth fix is justified
- `site/src/routes/(marketing)/vietnamese/+page.svelte` only if a bounded trust-panel or audio-availability fix is justified
- `.agent/tasks/T-091/logs/website-starter-audit.md`
- `.agent/tasks/T-091/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-091/reviews/` for each required gate

## Concrete requirement
- verify the Vietnam starter route does not overclaim audio or readiness relative to the current exported starter data
- verify the route still consumes the export seam in a way that matches `site/data/phrase-previews/**`
- if a bounded fix is needed, keep it inside the Vietnam starter route or website docs, not broad site strategy

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-trust-honesty-review.md`
2. `02-starter-route-utility-review.md`
3. `03-export-seam-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.
- Reviewers are fully read-only; they must not edit repo files or write review artifacts themselves.
- Each reviewer must return judgment text with explicit `Approval: APPROVE` or `Approval: BLOCK`.
- The parent worker writes all 4 review artifacts for the current gate/pass in one `apply_patch` after collecting the reviewer responses.
- The parent worker should `close_agent` each harvested reviewer promptly after its result is recorded.
- Draft `result.md` before Gate 3 with status `in_review`; switch it to `done` only after the latest Gate 3 pass is unanimous and `state.json` is finalized too.

## Required checks
- verify all required output files exist
- verify `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` still agree if touched indirectly
- verify the Vietnam route does not overstate audio/trust posture relative to export truth
- verify no app, ops, or unrelated route files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Vietnam website starter seam is at least as honest as the underlying export truth and preferably clearer
- any bounded fix stays inside website-safe surfaces
- audit evidence exists even if the correct outcome is mostly no-churn
- all 3 mandatory review gates passed with unanimous 4-subagent approval
