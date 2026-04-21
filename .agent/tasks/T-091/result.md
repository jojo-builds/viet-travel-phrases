# Result: T-091

## Status
- done

## Truth changed
- live

## Changed files
- `docs/website/PHRASE_AUDIO_DELIVERY.md` - aligned the durable website seam doc with the current static Vietnam hub surface, documented that the hub exposes 4 of the 7 exported Viet starter modules, and corrected the module field name from `articleReference` to `articleUrl`.
- `.agent/tasks/T-091/logs/website-starter-audit.md` - recorded the bounded audit evidence showing the static Vietnam hub, trust-panel loader, manifest parity, module subset, and phrase-audio reachability without inventing missing `site/src/**` source surfaces.
- `.agent/tasks/T-091/reviews/gate-01-pass-01/*.md` - recorded the initial mixed Gate 1 outcome where the contract review blocked on missing `site/src/**` source paths.
- `.agent/tasks/T-091/reviews/gate-01-pass-02/*.md` - recorded unanimous Gate 1 approval after clarifying the spec's own no-churn fallback path.
- `.agent/tasks/T-091/reviews/gate-02-pass-01/*.md` - recorded unanimous Gate 2 approval on the implemented docs-plus-audit artifact set.

## Validation
- Confirmed `site/countries/vietnam.html` is the current Vietnam hub surface and that it loads:
  - trust copy from `/data/trust-panels.json`
  - phrase modules from `/data/phrase-previews/manifest.json`
- Verified `site/data/phrase-previews/manifest.json` and `site/public/data/phrase-previews/manifest.json` still agree.
- Verified `content-draft/viet/website-preview.json` matches the committed manifest on the same 7 approved `moduleId` / `scenarioId` pairs.
- Verified the Vietnam hub surfaces 4 starter modules while the committed manifest exposes 7, so the hub is a bounded subset rather than a full-library claim.
- Verified all 16 audio URLs referenced by the 4 surfaced hub modules exist in both:
  - `site/data/phrase-audio/vietnam/**`
  - `site/public/data/phrase-audio/vietnam/**`
- Safe-directory `git status --short` showed a heavily dirty repo with extensive unrelated changes; this task remained limited to `docs/website/**` and `.agent/tasks/T-091/**`.
- Gate 1 review pass 01 with 4 reviewers - not unanimous; contract-scope review blocked on the stale source-path assumption.
- Gate 1 review pass 02 with 4 reviewers - passed unanimously.
- Gate 2 review pass 01 with 4 reviewers - passed unanimously.
- Gate 3 review pass 01 with 4 reviewers - passed unanimously.

## Notes
- No change was made to `site/src/data/phrasePreviewManifest.ts` or `site/src/routes/(marketing)/vietnamese/+page.svelte` because those source paths are absent in this repo snapshot and the static artifact already matched the honest export posture.
- No export JSON, trust-panel JSON, or route HTML was edited in this pass.
- This task strengthened doc truth and audit evidence only; it did not add browser-runtime, deploy, CDN, simulator, or real-device proof.

## Blockers
- none

## Reviews
- `.agent/tasks/T-091/reviews/gate-01-pass-01/01-trust-honesty-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-01/02-starter-route-utility-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-01/03-export-seam-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-02/01-trust-honesty-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-02/02-starter-route-utility-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-02/03-export-seam-review.md`
- `.agent/tasks/T-091/reviews/gate-01-pass-02/04-contract-scope-review.md`
- `.agent/tasks/T-091/reviews/gate-02-pass-01/01-trust-honesty-review.md`
- `.agent/tasks/T-091/reviews/gate-02-pass-01/02-starter-route-utility-review.md`
- `.agent/tasks/T-091/reviews/gate-02-pass-01/03-export-seam-review.md`
- `.agent/tasks/T-091/reviews/gate-02-pass-01/04-contract-scope-review.md`
- `.agent/tasks/T-091/reviews/gate-03-pass-01/01-trust-honesty-review.md`
- `.agent/tasks/T-091/reviews/gate-03-pass-01/02-starter-route-utility-review.md`
- `.agent/tasks/T-091/reviews/gate-03-pass-01/03-export-seam-review.md`
- `.agent/tasks/T-091/reviews/gate-03-pass-01/04-contract-scope-review.md`

## Logs
- `.agent/tasks/T-091/logs/website-starter-audit.md`

## Process feedback
- BUG: queue task specs that name optional source files as "read first" without stating whether the static artifact is acceptable can cause avoidable mixed Gate 1 outcomes when the repo snapshot only contains generated site surfaces.
- SUGGESTION: website-seam audit specs should declare the primary runtime surface explicitly, for example "static `site/countries/*.html` artifact" versus `site/src/**` source route, before asking reviewers to judge route-scope fixes.

## Recommended next step
If the website team wants source-backed route work later, re-queue this seam against the actual `site/src/**` project surface; otherwise treat the current Vietnam hub as an evidence-backed static-export seam and only revisit it when the export manifest, trust-panel contract, or surfaced module subset changes.
