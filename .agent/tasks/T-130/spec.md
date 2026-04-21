# Task Spec: T-130

## Title
Desktop Codex automation pilot, Viet arrival relation coverage and starter export parity packet

## Objective
Close the last obvious honest gap in the live Viet starter website relation seam. Try to relation-back the exported `vietnam-arrival-basics` module from bounded authored truth, not by inventing new full-library graph claims. If full arrival coverage is not honest, leave a validator-backed parity packet that makes the gap explicit across source notes, docs, manifests, and module payloads so future website or phrase-detail work does not have to rediscover it.

## Repo / Working Surface
- repo root: `E:\AI\SpeakLocal-App-Family`
- working cwd: `E:\AI\SpeakLocal-App-Family`

## Read first
- `AGENTS.md`
- `.agent/README.md`
- `.agent/QUEUE_START.md`
- `.agent/AUTOMATION.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `.agent/tasks/T-113/result.md`
- `.agent/tasks/T-124/result.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-arrival-basics.json`
- `site/public/data/phrase-previews/vietnam-arrival-basics.json`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`

## Task type
- Viet relation/export parity hardening
- arrival starter-module coverage pass
- website phrase-detail handoff packet

## Scope
### Allowed write scopes
- `.agent/tasks/T-130/**`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-arrival-basics.json`
- `site/public/data/phrase-previews/vietnam-arrival-basics.json`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `site/**`
- `app/family/packs/**` as read-only starter-shape reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- unrelated country-page conversion copy outside the bounded Viet arrival relation/export seam
- premium-only or non-exported target-family rails
- release/build/TestFlight files
- manual patching of generated surfaces when deterministic export or relation-transform truth should drive the fix instead

## Source-of-truth notes
- The current live manifest still reports `currentCoveredClusterCount: 14`, `coveredModuleCount: 6`, and `vietnam-arrival-basics` with `relationCoverage.status = none`.
- `T-113` left a bounded `29`-cluster starter-safe Viet relation sample and `T-124` hardened the validator so sample identity, source boundary, docs, and manifest truth fail together.
- The website seam is still starter-only and advisory. Do not invent full-library arrival graphs, synthetic replies, or premium leakage.
- Arrival relation coverage is only honest if any added airport or arrival family can anchor to existing authored truth and point only at starter-safe targets that are already exported in the website seam.
- If honest arrival coverage cannot clear that bar, the task should still leave a tighter explicit no-go packet instead of a vague uncovered gap.

## Required outputs
Create or update these files:
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/source-notes.md`
- `content-draft/viet/phrase-source.csv` when row-level anchor markers or notes must change to support the honest arrival packet
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `site/data/phrase-previews/vietnam-arrival-basics.json`
- `site/public/data/phrase-previews/vietnam-arrival-basics.json`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- `.agent/tasks/T-130/logs/viet-arrival-relation-parity.md`
- `.agent/tasks/T-130/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-130/reviews/` for each required gate

## Concrete requirement
- either bring the exported `vietnam-arrival-basics` module to an honest starter-safe relation posture by mapping at least `3` of its `4` exported families into the bounded sidecar with valid exported-target rails, or prove with repo evidence why the current arrival slice cannot honestly cross that bar yet
- whatever conclusion the repo supports, make `docs/PHRASE_RELATIONSHIP_MODEL.md`, `docs/V2_CONTENT_MODEL.md`, the relation sidecar and authoring notes, manifest `relationExport`, and both arrival-module payloads tell the same covered-versus-uncovered story
- tighten validator checks so sample identity, covered-module summary, and arrival-module coverage fail together instead of drifting silently
- leave one compact audit explaining whether the Viet starter website seam is now seven-module relation-backed or why the arrival gap remains intentionally visible
- keep the work meaningful and synthesis-heavy, not a thin wording cleanup

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-website-relation-export-review.md`
2. `02-arrival-traveler-utility-review.md`
3. `03-starter-boundary-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify `content-draft/viet/relation-sample-v1.json` still parses as JSON
- verify both manifest files and both `vietnam-arrival-basics.json` payloads still parse as JSON
- run `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- verify every required output file physically exists
- verify no `app/**`, `ops/**`, `docs/operations/**`, release/build/TestFlight files, or unrelated country-page files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate
- verify the final manifest-level and module-level relation coverage story agrees with the source sidecar and docs

## Definition of done
- the Viet arrival module either gains an honest starter-safe relation packet or an equally honest explicit no-go packet
- future website phrase-detail or article work can trust one current arrival relation/export contract without reopening `T-113` or `T-124`
- the website seam stays starter-only, advisory, and validator-backed
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no premium leak, fake full-library claim, or unrelated website-copy churn was introduced
