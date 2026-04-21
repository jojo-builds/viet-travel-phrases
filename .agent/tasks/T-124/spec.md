# Task Spec: T-124

## Title
Desktop Codex automation pilot, Viet relation-safe starter export and phrase-detail module packet

## Objective
Build on the bounded Viet relation sample and the hardened website export seam so starter-safe website surfaces can carry useful next-step and likely-reply context without exposing premium or full-library data. Leave one validator-backed relation-export packet that future website work can use directly without reopening `T-113`, `T-117`, or `T-110`.

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
- `.agent/tasks/T-117/result.md`
- `.agent/tasks/T-110/result.md`
- `content-draft/viet/relation-sample-v1.json`
- `content-draft/viet/relation-authoring-notes.md`
- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`

## Task type
- website starter-export hardening
- relation-safe phrase-detail packet
- Viet live-seam contract work

## Scope
### Allowed write scopes
- `.agent/tasks/T-124/**`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/website-preview.json`
- `site/data/phrase-previews/**`
- `site/public/data/phrase-previews/**`
- `scripts/website/**`

### Allowed read scopes
- `docs/**`
- `content-draft/viet/**`
- `site/**`
- `app/family/packs/**` as read-only starter-shape reference only

### Must not touch
- `app/**` as a write surface
- `ops/**`
- `docs/operations/**`
- unrelated country-page conversion copy outside the starter export seam
- premium-only or full-library relation data that the current website boundary should not expose
- manual patching of generated surfaces when source truth or deterministic export logic should drive the fix instead

## Source-of-truth notes
- The live website seam is still starter-only, with a seven-module Viet export surface and a four-module on-hub / three-module off-hub split.
- `T-113` left a bounded `29`-cluster Viet relation sample. It is relation-ready handoff truth, not a claim that the full Viet library is relation-modeled.
- The website should only receive a bounded starter-safe relation subset, with likely-reply and next-step hints kept advisory rather than deterministic.
- Keep the relation layer additive to the current phrase-source plus export model.

## Required outputs
Create or update these files:
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `content-draft/viet/website-preview.json` if export selection or editorial metadata needs a bounded relation-safe update
- `site/data/phrase-previews/manifest.json`
- `site/public/data/phrase-previews/manifest.json`
- bounded `site/data/phrase-previews/vietnam-*.json` and mirrored public copies only where relation-safe export fields are genuinely needed
- `scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- `.agent/tasks/T-124/logs/viet-relation-export-packet.md`
- `.agent/tasks/T-124/result.md`
- exactly 4 review artifacts under `.agent/tasks/T-124/reviews/` for each required gate

## Concrete requirement
- expose enough website-safe relation metadata for at least `12` high-value starter-safe Viet family clusters, unless repo truth proves a smaller honest website-safe subset, so future phrase/article surfaces can show likely reply or next-step rails without reopening `T-113`
- keep the starter boundary explicit and do not leak premium-only or non-exported relation edges
- make manifest, public-copy export payloads, validator checks, and durable docs fail together instead of drifting silently
- leave one compact audit explaining which relation-safe fields now exist in the website seam and what remains app-only or future-only

## Mandatory 3-review-gate workflow
Use exactly 4 Codex subagent review roles in every gate:
1. `01-website-relation-export-review.md`
2. `02-starter-boundary-review.md`
3. `03-listing-detail-utility-review.md`
4. `04-contract-scope-review.md`

Gate 1 before edits, Gate 2 after the main working pass, Gate 3 before done. All 3 gates require unanimous approval from all 4 subagents.

## Required checks
- verify both manifest files still parse as JSON
- verify any touched Viet module payloads still parse and public/private copies stay aligned
- run `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1`
- verify every required output file physically exists
- verify no `app/**`, `ops/**`, `docs/operations/**`, or unrelated country-page files changed
- verify the latest pass for each gate contains exactly 4 review files
- verify all 4 subagents explicitly approved advancement in the latest pass of each gate

## Definition of done
- the Viet website export seam carries a bounded starter-safe relation packet that a later website lane can consume without reopening concept design
- starter-only website truth stays honest and validator-backed
- docs, export payloads, and validator checks describe the same relation-safe boundary
- all 3 mandatory review gates passed with unanimous 4-subagent approval
- no premium leak or fake full-library relation claim was introduced
