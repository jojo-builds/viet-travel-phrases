# Decisions

## Durable repo and product decisions

- `E:\AI\SpeakLocal-App-Family` is the canonical implementation root for the SpeakLocal app family.
- `app\` remains the permanent Expo workspace for now. No broad repo refactor is part of the Viet v2 monetization pass.
- `app\family\appRegistry.js` remains the canonical shared runtime/build registry.
- Hidden Expo web/native preview routes under `app\app\design-preview\*` and `app\app\app-preview-wireframes\*` are the preferred fast visual review surface for UI iteration; they are sidecar review tools, not ship-facing product routes.
- SpeakLocal v2 is being framed as a travel phrasebook, not an academic language-learning app.
- Current repo naming and pricing direction is now:
  - `SpeakLocal Vietnam`
  - `SpeakLocal Philippines`
  - `$4.99` one-time unlock
- Current premium framing across app and website copy now follows:
  - free = get by
  - premium = do not get stuck

## Website and app role decisions

- The website is a phone-forward, responsive gateway into the app, not a disconnected marketing site or a second product.
- The website should feel aligned with the app in structure and flow.
- Each destination website surface should expose the same starter/free phrase layer that the app exposes for that destination.
- Destination articles should reinforce and route back into those same starter phrases.
- The app remains the fuller searchable/playable phrase library and the first premium sales surface.
- The short-term website goal is clarity, repeat usefulness, and app conversion, not a second monetization system.

## Monetization decisions

- Viet v2 uses a single non-consumable iOS unlock through `expo-iap` and StoreKit.
- Viet v2 does not add a custom backend for purchase verification in this pass. Repo truth should describe that as a deliberate v2 simplicity tradeoff, not hidden completeness.
- Premium access truth is:
  - real StoreKit entitlement when the iOS native store path is available
  - persisted on-device purchase state for restart continuity
  - no fake success state in user-facing purchase or restore flows
- The dev validation unlock may still exist, but only as a clearly labeled local validation aid when the real store path is unavailable.
- Premium remains app-first for now.
- Do not introduce website premium, cross-platform entitlement sync, login/account architecture, or code-redemption flow in the current direction.
- Any future web monetization idea remains deferred until app sales prove it is worth revisiting.

## Content-model decisions

- Scenario remains the category-level runtime truth for the current app shell, routes, premium cards, and website module contract.
- Intent family is the authored decision unit inside each scenario/category.
- The visible entry count is the family primary (`say-first`) phrase, not every raw phrase row.
- Compact variant roles are fixed to:
  - `say-first`
  - `more-polite`
  - `clearer`
  - `also-common`
- `say-first` should be the shortest socially safe phrase that still gets the traveler by, often 1 to 2 words when honest and usable.
- Phrase families should be authored as navigable detail surfaces, not isolated database rows.
- Related-phrase modeling should exist both within a scenario and across nearby traveler intents such as follow-up, repair, escalation, likely reply, and clearer/politer forms.
- Listing/detail pages should increasingly behave like utility-rich phrase hubs where users can tap deeper into adjacent useful phrases, not just view one phrase and stop.
- The preferred architecture for phrase relationships is to extend the current authored family/row model with relation metadata first, not to jump immediately to a separate graph database.
- Vietnam is the first runtime-priority lane where relation-ready phrase/detail modeling should be hardened intentionally; Tagalog and future languages should adopt that model earlier in authoring.
- The hourly queue-maintenance cron is also the preferred place for guarded Codex desktop recovery when the queue appears stalled; do not create a separate rapid restart loop. If Codex is not running at all while actionable queued/reclaimable work exists, the same hourly lane should start it back up before considering a restart path.
- Warning-note types are notes, not ordinary variant buttons:
  - `formal`
  - `bookish`
  - `harder-to-say`
  - `recognition-only`
- Starter vs premium depth should happen inside the same categories whenever possible.
- Emergency, pharmacy, and understanding/repair basics stay in starter access.
- Viet is authored from `content-draft/viet/` and built through the same generated-pack path Tagalog already used.
- New phrases may ship with `audioStatus=planned` while existing bundled audio stays intact for already-generated rows.

## Website export and deployment decisions

- Website preview export stays separate from the app runtime contract:
  - source approval lives in `content-draft/*/website-preview.json`
  - output lives under `site/public/data/phrase-previews/`
  - the website should only receive approved starter/default-first slices that match the app's starter/free layer for that destination
- Website deployment now uses explicit staging/live surfaces outside the repo working tree:
  - local artifact: `site/`
  - staging review URL: `http://speaklocal.app:8081/`
  - raw-IP staging fallback: `http://38.247.143.2:8081/`
  - live URL: `https://speaklocal.app/`
  - deployment roots:
    - `E:\AI\Shared\Deployments\speaklocal-site\staging-current`
    - `E:\AI\Shared\Deployments\speaklocal-site\live-current`
  - promote live only from the staged deployment copy
- Legacy tracked `docs/*.html` is not the intended staging lane for the richer site.

## Design review surface decisions

- The fastest private review lane for live UI changes is now the authenticated dashboard canvas at `https://dashboard.jayopsai.com/design/viet`, backed by the Expo web preview for the live app repo rather than a separate mock shell.
- The Expo app keeps hidden review routes under `app/app/design-preview/*`, and the dashboard proxies those routes so phone review can happen without building or installing a fresh iPhone binary for every visual pass.
- Exact deterministic real-app review states now live under `app/app/design-live/*`, with preset truth owned by `app/lib/designReviewPresets.ts` and state overrides owned by `app/lib/designReview.tsx`.
- Dashboard review should prefer `design-live` preset routes for repeatable frontend work, and the repo now ships `npm run capture:design` so the same authenticated dashboard surface can be screenshot-verified with Playwright instead of relying on manual visual memory alone.

## Current live Viet boundary decisions

- The current Viet live reality is now:
  - 150 starter visible entries
  - 750 premium visible entries
  - 900 total visible entries
  - 919 approved phrase rows
  - 919 approved rows currently marked `audioStatus=ready`
  - 0 approved rows currently marked `audioStatus=planned`
- The autonomous completion audits for the live Viet pack now live under:
  - `content-draft/viet/autonomous-500/`
  - `content-draft/viet/autonomous-900/`

## Future boundary decisions

- Any future expansion beyond the live `150 / 750 / 900` boundary is now an explicit future-only `200 / 1000` decision, not the current planning default.
- Viet premium expansion planning authority now lives in `docs/VIET_PREMIUM_EXPANSION_PLAN.md`.
- Viet premium expansion lanes under `content-draft/viet/premium-expansion/` may now be either:
  - future prepared-not-live lanes
  - or promoted-live historical manifests that document how a lane entered runtime truth
- A later `200 / 1000` shape is an explicit future option only, not the default.
