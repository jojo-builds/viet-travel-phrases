# Gate 1 Pass 2 Website Scope Review

- reviewer: Gate 1 website scope role
Approval: APPROVE
- scope: bounded Vietnam website runtime audit before edits

## Decision summary

The bounded website audit scope is sound and should proceed. `T-066` stays constrained to task-local artifacts, bounded `site/**`, and website-facing docs, while the live runtime seam already evidenced in this task stays narrow: Vietnam host pages load `site/scripts/phrase-module-loader.js`, which fetches `/data/phrase-previews/manifest.json`, which resolves to the 7 Vietnam preview payloads and their site-owned audio URLs.

## Findings

- The audit should cover every live Vietnam module-host surface already identified, not just a single article page.
- Every exported `audioUrl` should be verified, not a spot sample, because the same manifest-driven modules are reused across multiple pages and currently advertise full readiness.
- Paired `.html` and routed `index.html` outputs should be treated as duplicate runtime surfaces to compare for drift, not as a reason to widen scope.
- If a defect proves to be rooted in `content-draft/viet/**` or `app/assets/audio/**`, this task should record that as an upstream blocker instead of widening into non-website repair.
