# Website Alignment Plan

Last updated: 2026-04-16
Status: source-of-truth direction reconciled; staging/live workflow unchanged; active external website implementation lanes still pending

## Purpose

Align the website to the current SpeakLocal product split without inventing a second monetization system.

## Durable direction

- SpeakLocal is a family of destination-specific travel phrasebook apps plus a supporting website.
- The website is a phone-forward, responsive gateway into the app.
- The website should feel aligned with the app in structure and flow, not like a disconnected marketing site.
- For each destination, the website should expose the same starter/free phrase layer that the app exposes for that destination.
- Destination articles should reinforce and route back into those same starter phrases.
- The app remains the fuller searchable/playable phrase library travelers keep and use.
- Premium stays app-first for now.
- Do not introduce website premium, login/account architecture, cross-platform entitlement sync, or code-redemption flow in the current direction.
- Short-term website success means stronger clarity, repeat usefulness, and app conversion, not a separate web revenue system.

Durable framing:

- free = get by
- premium = do not get stuck

## Verified live and workflow truth

- `https://speaklocal.app/` is the current live website domain.
- `http://speaklocal.app:8081/` is the real staging review lane for the current static artifact.
- The richer website now lives locally under `site/`.
- `site/` behaves like a static working artifact, not the live-serving root.
- Caddy now serves deployment copies from:
  - `E:\AI\Shared\Deployments\speaklocal-site\staging-current`
  - `E:\AI\Shared\Deployments\speaklocal-site\live-current`
- The last tracked website path in git history was the legacy `docs/*.html` support/GitHub Pages lane.
- In the current worktree, those legacy `docs/*.html` files are already pending deletion and should not be treated as an active rollback lane.
- This workflow truth becomes durable only when the `site/` artifact, scripts, and matching docs are committed together.

## What current live website truth already shows

- homepage is more clearly product-first and install-aware
- Vietnam now reads more like the live app install lane than a generic guide hub
- the strongest Vietnam phrase landing page now supports install motivation and practical value
- Philippines now previews future value in traveler language instead of internal roadmap language
- the countries index now routes more directly toward the live Vietnam install path
- the first live site consumer already reads exported starter phrase modules instead of duplicating phrase cards in page-local markup

## What remains direction, not landed site coverage

- full destination-by-destination starter-surface parity is not yet complete on the live website
- the live site is still Viet-first today
- exact future layout, article-template, and conversion refinements remain pending from active external website lanes
- website preview exports remain starter-only and separate from the app runtime contract
- phrase/audio modules should keep moving closer to app-aligned destination and scenario surfaces, but this sync does not claim that work is already complete

## What was intentionally not done

- no giant visual rebrand
- no new web stack or CMS
- no runtime fetch wiring for phrase-preview JSON
- no public claim that the Tagalog app is live
- no claim that the Viet premium flow is device-proven or operationally frozen
- no attempt to turn the website into the full phrase library
- no website premium, web checkout, cross-platform entitlement sync, login/account architecture, or code-redemption flow

## Best next website step

Keep using the explicit staging lane on every website pass, regenerate starter-layer exports from `app/` when preview data changes, and only promote the reviewed staged artifact to live after signoff. Treat active external website-lane outputs as pending until they are actually returned and ingested.
