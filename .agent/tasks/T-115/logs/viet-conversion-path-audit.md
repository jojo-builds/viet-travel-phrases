# Vietnam Conversion Path Audit

## Scope
- Task: `T-115`
- Surface: `site/countries/vietnam.html` and `site/countries/vietnam/index.html`
- Goal: make the Vietnam country-page path more situation-first and clearer about when the starter-safe website preview ends and the app backup begins

## Starting truth
- The approved on-hub Viet starter subset remained unchanged: arrival, transport, money, and phone.
- Off-hub starter support remained unchanged: essentials, repair, and food stay on the phrase/article path and app handoff.
- The pre-edit route pair was already honest, but several sections still leaned on broader conversion framing and library-size language that pulled attention away from the traveler's next live problem.

## Working changes
- Retitled metadata to foreground the site-first to app-backup path instead of generic starter-copy framing.
- Rewrote the hero support copy around four concrete pressure points: arrival handoff, ride trouble, totals or ATM confusion, and getting back online.
- Changed the head-panel from product-tier wording into usage guidance: start here, go deeper, carry the app.
- Tightened the three offer cards so they read like decision support for the next live problem, then escalation guidance for repair and follow-up moments.
- Reframed the library-depth section so the `150 / 750 / 900` counts are stated as app depth explicitly, not implied website scope.
- Tightened the starter-preview and app-handoff notes so the page says more clearly that the preview stops on purpose and the app is the next step when the situation grows.
- Preserved flat-route and routed-page parity.

## Why this is more useful
- A traveler now gets a clearer answer to "where do I start?" before being asked to install anything.
- The page now names the escalation boundary in practical terms: repair, clarification, address fixes, order cleanup, and deeper backup move to the app.
- The install pitch is framed as safer backup after the preview runs out, not as a vague larger-library promise.

## Why this stays honest
- No new starter modules were added to the hub.
- No claim was added that the website exposes the full starter layer or the full app library.
- The page still matches the approved Viet website contract documented in `docs/website/PHRASE_AUDIO_DELIVERY.md` and `content-draft/viet/website-preview.json`.

## Validation
- Route-pair parity passed via file-hash comparison between the flat and routed Vietnam pages.
- `powershell -ExecutionPolicy Bypass -File scripts/website/Test-SpeakLocalWebsiteArtifact.ps1` passed after the copy changes.
- No `app/**`, `ops/**`, or unrelated country pages were edited.
