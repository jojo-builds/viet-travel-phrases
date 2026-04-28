# T-152 feature brief

## Source
- Follow-on after completed `T-151`
- Orchestrator-approved overnight packet on `2026-04-23`

## Feature
Deepen the Viet answer-page system into a stronger core traveler library by expanding coverage, adding missing phrase-class patterns, and materially enriching the highest-value flagship listing pages.

## Intent
- move Viet beyond a proof-of-concept answer-page sample and toward a core set that actually feels useful and monetizable
- stop treating the current `50` enriched hubs as enough when the product needs richer listing pages and stronger phrase-to-phrase navigation
- deepen the top flagship pages like `Hello`, `Thank you`, `Sorry / I don't understand`, urgent help, pharmacy, transport, money, and hotel service so they feel more like traveler answers and less like thin records
- add missing phrase-class/module patterns so the app knows what belongs on more kinds of listing pages

## Locked product principle
- Listing pages are AI-shaped answer pages, not simple phrase detail pages.
- Not every listing page should use the same section mix.
- The app should increasingly feel like a curated answer engine with audio, follow-ons, likely replies, and tap-forward utility rather than a static phrase database.

## Required behavior from the source direction
- do not stop at bookkeeping or schema-only work
- add real phrase depth where the current graph is thin
- widen coverage and deepen flagship hubs in the same pass
- preserve the additive sidecar model:
  - phrase wording truth stays in `phrase-source.csv`
  - answer-page structure stays in `answer-page-sample-v1.json`
  - relation truth stays in `relation-sample-v1.json`

## Product constraints from orchestrator
- this belongs on the Viet content branch/worktree, not the UI shell branch
- this should be a large overnight content/database task, not a tiny cleanup
- the task must push the listing-page system materially closer to the product vision
- this is a meaningful task and must use the full 3-gate / 4-reviewer contract
