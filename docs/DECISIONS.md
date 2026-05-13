# Decisions

## Durable repo and product decisions

- `/Users/jojolim/Developer/products/speaklocal/app-family` is the canonical Mac implementation root for the SpeakLocal app family.
- `/Users/jojolim/Developer/products/speaklocal/app-family/native-ios` is the active native iOS app-session root in Codex for SwiftUI/Xcode work.
- Legacy Windows roots such as `E:\AI\SpeakLocal-App-Family` are migration/archive references, not the preferred active workspace. Older Windows desktop-agent paths may appear in historical logs only.
- The preferred native family architecture is one shared SwiftUI/Xcode shell plus per-app config and language packs. SpeakLocal Vietnam is the active proof app; future destinations should inherit the shell rather than become separate rewrites.
- Current live Viet native resources remain at `native-ios/Resources/*.json` plus `native-ios/Resources/Audio/` until a coordinated language-pack migration updates Swift loaders, generators, XcodeGen resource rules, tests, and docs together.
- `app/` remains the canonical shared content/pipeline workspace during the transition, but the ship-facing app-shell direction is now a native SwiftUI/Xcode family shell. Expo is the bridge/reference lane, not the final premium UX destination.
- `app/family/appRegistry.js` remains the canonical shared runtime/build registry.
- Hidden Expo web/native preview routes under `app/app/design-preview/*` and `app/app/app-preview-wireframes/*` are the preferred fast visual review surface for UI iteration; they are sidecar review tools, not ship-facing product routes.
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

- Paywall feature lane (`feature/paywall`) is testing a native Apple subscription foundation before any merge to `main`:
  - StoreKit 2 is the entitlement authority.
  - The initial placeholder product is `app.speaklocal.vietnam.subscription.monthly`.
  - The intended App Store Connect setup is a monthly auto-renewable subscription with a 7-day introductory free trial and `$4.99` placeholder pricing.
  - Paywall design, final copy, pricing, product IDs, and exact premium benefit framing remain unfinalized product decisions until Jojo approves them.
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
- Shared traveler/runtime structure does not require every destination app to use identical scenario/category lists. A "shared backbone" should mean shared traveler coverage goals plus shared runtime/schema contracts, not forced scenario symmetry across all countries.
- Product/UI terminology should now be interpreted this way:
  - `category` / `scenario` = browse bucket, folder, or filter group
  - `scenario page` = optional page that lists phrase hubs inside a category
  - `listing page` / `product page` / `listing detail page` = the dedicated page for one phrase hub
  - `intent family` = internal authored/runtime grouping behind one listing page
  - `phrase row` / `variant` = one wording inside that listing page
- Compact variant roles are fixed to:
  - `say-first`
  - `more-polite`
  - `clearer`
  - `also-common`
- `say-first` should be the shortest socially safe phrase that still gets the traveler by, often 1 to 2 words when honest and usable.
- Phrase families should be authored as navigable detail surfaces, not isolated database rows.
- Listing/detail pages are now product-defined as AI-shaped answer pages: they should answer traveler intent with modular sections, linked follow-ons, and audio-backed phrasing instead of acting like a flat phrase record.
- Related-phrase modeling should exist both within a scenario and across nearby traveler intents such as follow-up, repair, escalation, likely reply, and clearer/politer forms.
- Listing/detail pages should increasingly behave like utility-rich phrase hubs where users can tap deeper into adjacent useful phrases, not just view one phrase and stop.
- The phrase-page product direction now assumes richer phrase hubs will increase raw row density and adjacent-family coverage over time; future content/database growth is an expected consequence of better phrase-detail/listing surfaces, not accidental library bloat.
- Product completeness for a destination app should now be interpreted as saving the real phrase graph behind the major traveler intents, not merely publishing one primary phrase per listing page. When meaningful alternate phrasings, relation branches, likely replies, repair paths, or adjacent next-step phrases exist, they should be authored and retained as durable content truth rather than improvised later from memory.
- The content system should increasingly distinguish between richly enriched answer hubs for the highest-value traveler pages, medium-depth support hubs that still carry real relation truth, and baseline long-tail families that may start lighter but should still preserve useful row truth for future promotion.
- Audio is part of the durable phrase-graph contract. Newly authored rows may temporarily remain `audioStatus=planned`, but the long-term expectation for approved traveler-facing phrase rows is that they will eventually receive audio coverage instead of being treated as throwaway text-only variants.
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
- The dashboard/authenticated Expo web lane is the default review surface for routine UI and copy iteration; paid native iPhone builds should be treated as milestone validation, not the default loop for small design tweaks.
- Build/release workflow should follow a simple branch policy:
  - `main` = current accepted baseline
  - one active feature branch per major feature or workstream
  - do not advance the same feature on multiple active branches in parallel once a winner is clear
  - when multiple approved features need one paid iPhone test pass, bundle them into a single integration candidate branch/build instead of paying for isolated builds per feature
- Windows-server history should now be used only for archive/migration lookup. Current hardening of portable content/model/export seams and design references happens from the Mac repo.

## Native iOS transition decisions

- SpeakLocal is now committing to a native SwiftUI/Xcode family-shell direction for the premium iOS experience across the app family.
- The Mac/Xcode cutover has happened for day-to-day native work. The active app lane is `native-ios/` on the Mac.
- The first native milestone should continue proving one reusable family shell plus three flagship surfaces:
  - home
  - dedicated search
  - listing/answer page
- Native proof should start with `Xin chào` as the flagship greeting page and `I need a doctor` as the flagship urgent-help page.
- `Xin chào` is the flagship visual/content rhythm for listing pages: strong hero phrase, native player, breakdown, useful variants, relationship/local guidance, follow-ups, cultural note, and Explore next.
- Tier 1 listing pages should read like offline AI-answer articles for "Different ways to say [phrase] in Vietnam," while staying fully authored and bundled offline.
- The native chrome direction is static Liquid Glass-style navigation and playback chrome, with page content animating under it rather than moving the chrome layer itself.
- Search should feel like the bottom search island morphing into the dedicated search field; avoid hard swaps when a native transition is feasible.
- Back and forward navigation should behave like a browser-style page graph: swipe back/forward is desirable, a forward button may appear when forward history exists, and opening a new route after going back clears forward history.
- Speaker icons are promises of playable bundled audio. Missing visible audio should be handled through a deduped audio audit/generation queue, not by silently removing expected audio controls.
- Arrows mean navigation to canonical page IDs. Search, browse, Explore shelves, row links, and variants must resolve to one canonical page per phrase, not duplicate pages.
- The shared repo remains the single source of truth during the native transition. Do not fork content, relation data, audio manifests, or premium-boundary logic into a separate planning repo.
- The preferred native transition shape is one shared native family shell that future destination apps inherit, not ten separate app rewrites done independently.
- `content-draft/viet/canonical-pages/**` is the current authored source for native Viet canonical phrase pages, with `native-ios/scripts/generate-authored-tier-one-pages.js` projecting that content into the bundled native JSON resource.
- Native Home V1 is the default launch route. `Xin chào` remains the flagship listing page reachable from Home, Browse, search, and relationship shelves rather than standing in as the whole home screen.
- Saved phrases, practice-selected phrases, recently opened pages, practiced prompts, and missed items are local private user-state signals. They should personalize Home, Explore, category rows, and Practice through deterministic offline ranking while the bundled phrase graph remains read-only.
- `Add to practice` should be available from phrase pages and eligible phrase rows once local practice-pool state exists. The selected phrase/row/token remains the correct-answer target for generated practice prompts; graph-nearby phrases are distractors or recommendations, not replacement targets.
- Onboarding may include a short phrase-based placement check that sets a local editable level (`beginner`, `intermediate`, or `advanced`). This should personalize rankings/defaults without locking content, shaming the user, or sending data off device.
- Mutable user preferences and progress, including onboarding level, saved IDs, practice IDs, missed prompts, and route marks, belong in local private app state rather than the read-only bundled phrase graph.
- The first Viet Practice Core package lives in `docs/practice/VIET_PRACTICE_CORE_PLAN.md`, `content-draft/viet/practice/practice-deck.sample.json`, `scripts/practice/generate-viet-practice-deck.js`, and `prototypes/practice-quiz/`. It is a prepared offline contract/prototype for later T-167/T-168 native integration, not current native runtime wiring.
- The first Practice reward/mascot contract lives in `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`: rewards are local ready/review route marks tied to source-anchored phrase practice, and the chameleon appears only as a restrained Practice companion gated by sensitivity and `mascotEligible` signals.
- The first mascot visual board from `TASK-MASCOT-VISUAL-SYSTEM-001` is rejected for implementation. It may remain as rough process history, but future mascot direction must be production-ready generated raster imagery and app-like native screen comps before SwiftUI implementation.
- Mascot visual tasks should use Codex image generation first and should block rather than substitute HTML/CSS/SVG doodles when the requested output is production-ready image concepts.

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

## Execution-tracking decisions

- High-level pre-v2 feature intake and progress should live in the external visual tracker (`SpeakLocal V2 Feature Tracker` Google Sheet), not in the repo-local queue by default.
- The repo-local `.agent/` queue remains useful only for execution-grade tasks with a clear deliverable, clear write scope, a recoverable heartbeat trail, and a prompt packet worth autonomous pickup. Tasks do not need to be tiny; the preferred worker shape is the largest coherent packet a single Codex session can complete, validate, and commit, often `30` minutes to several hours.
- Queue task specs should be outcome-driven for GPT-5.5 workers: describe the desired end state, success criteria, constraints, validation, recovery, and review gates, then let the worker reason about the implementation path. `.agent/TASK_PROMPTING.md` owns that prompting standard.
- Do not use the queue as the main roadmap, idea backlog, or product-brain surface; use it only after the orchestrator has already shaped a feature into a real implementation task.
- Research is only considered reusable when it lands as a readable repo artifact with a `Folded Into` section. Research findings should not live only in worker chat context; task-card research should also leave a short receipt under `docs/task-results/`.
- Research and design tasks should also pick a Jojo-readable review surface: Markdown for source truth, plus local browser preview, screenshots, Figma, Google Docs, or imported ChatGPT/Deep Research output when that makes the work easier to inspect. `docs/research/TOOLBOX.md` owns the tool-selection rule.
- This pinned Codex thread is the orchestrator lane. Its default behavior is to shape Jojo's ideas into queue-ready task packets, preserve source-of-truth decisions, keep the queue clean, and stay available for new direction. Long research, implementation, simulator/device proof, broad copy/content audits, and audio work should normally run in fresh worker threads on explicit feature/recovery tasks unless Jojo explicitly asks the pinned thread to execute the task itself.
- When Codex desktop starts showing the recurring `loading model` / reauthentication pattern on long-running worker or reviewer threads, the preferred operator recovery is:
  - restart the Codex desktop app
  - reopen the repo
  - resume from the task files in a fresh worker thread instead of trusting the old thread to self-heal cleanly
- The active Codex machine is now this Mac; Windows Codex install/update notes are archive-only unless the old server is intentionally reopened.
- Queue recovery should prefer explicit recovery tasks over silently reusing interrupted tasks. If a meaningful task is materially complete but the app/runtime interrupted the closeout, keep the original task as historical interruption truth and finish the salvage path in a fresh recovery task.
- For machine transitions, repo-persisted docs plus `.agent` task state are the primary continuity source, not any single live Codex thread.
- Preferred Codex carryover into a new machine is:
  - clone the repo
  - keep `.agent\` and `.codex\` from the repo
  - reinstall and reauthenticate the Codex app
  - selectively migrate `$CODEX_HOME` assets such as skills, automations, config, and optional archived sessions if historical transcripts are worth carrying over

## Future boundary decisions

- Any future expansion beyond the live `150 / 750 / 900` boundary is now an explicit future-only `200 / 1000` decision, not the current planning default.
- Viet premium expansion planning authority now lives in `docs/VIET_PREMIUM_EXPANSION_PLAN.md`.
- Viet premium expansion lanes under `content-draft/viet/premium-expansion/` may now be either:
  - future prepared-not-live lanes
  - or promoted-live historical manifests that document how a lane entered runtime truth
- A later `200 / 1000` shape is an explicit future option only, not the default.
