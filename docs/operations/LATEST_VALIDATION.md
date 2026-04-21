# Latest Validation

Last updated: 2026-04-21
Authority lane: live app operational truth

## Use this doc for

- the last durable validation evidence that already exists
- what had not yet been proven at the time of that snapshot

Do not use this doc as the next-step checklist. `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, and `TESTING_RUNBOOK.md` own the current handoff path.

## Latest durable validation snapshot

- Rescue-state repo-validation date: `2026-04-21`
- The `2026-04-21` repo rescue restored the missing family preflight helpers at `scripts/summarize-family-state.py` and `scripts/check-family-consistency.py`.
- The same rescue pass rebuilt the Tagalog generated pack from current draft truth, clearing the stale `tagalog-coffee-shop-7` usage-note drift that had been blocking `npm run validate:family`.
- The shared family/content scripts used in the rescue path now resolve repo/app roots from the live script location or the launched app root, and `app/scripts/build-family-pack.ts` no longer mirrors writes to a hardcoded `E:\AI\Viet-Travel-Phrases` path.
- Fresh repo-local proof captured on `2026-04-21`:
  - `npx --no-install tsc --noEmit`
  - `npm run validate:family`
  - `npm run validate:premium-boundary`
  - `npm run validate:premium-expansion`
- This rescue-state proof improves repo integrity and local validation truth, but it does **not** add newer device, installable-build, TestFlight, or purchase-lane proof than the broader `2026-04-16` operational snapshot below.
- Validation baseline date: `2026-04-16`
- Ops truth re-read date: `2026-04-21`
- The `2026-04-21` refresh still found no newer physical-device or installable-build proof than the `2026-04-16` snapshot below.
- The `2026-04-21` refresh tightened the required return evidence package and handoff wording only. It did not add new commands, installs, TestFlight proof, or device proof.
- The aligned handoff packet now stays explicit about six carry-forward items only: preview build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` installability, store build `5f61efeb-661d-426b-a280-aed866dcb5c2` TestFlight state, Apple-side purchase-lane readiness, physical purchase / restore / relaunch / gating proof, bounded shared-search smoke or explicit carry-forward, and cross-file sync if gate state or blocker wording changes.
- The post-snapshot follow-ons now carried here as bounded repo-side evidence only are the `2026-04-18` Viet purchase-surface clarity audit and the `2026-04-20` Tagalog search-copy rerun. They improved operator honesty but did not change build, install, purchase-lane, or device-proof status.
- A separate `2026-04-18` repo-side Viet purchase-surface audit did add bounded shell-copy clarity evidence in `app/family/presentation/vietPremium.ts`, but it did not change purchase/device-proof status.
- Canonical app path validated: `E:\AI\SpeakLocal-App-Family\app`
- Compatibility alias still present during transition: `E:\AI\Viet-Travel-Phrases\app`

## What was validated in this task

### Live Viet 900-family repo truth

- Live Viet source of truth remained `content-draft/viet/phrase-source.csv`.
- Current source-CSV proof:
  - `919` approved phrase rows
  - `919` approved rows marked `audioStatus=ready`
  - `0` approved rows marked `audioStatus=planned`
- Current pack/runtime proof:
  - `npm run build:viet-pack` rebuilt `app/family/packs/viet.generated.ts`
  - builder output reported `18 scenarios, 900 intent families, and 919 phrases`
  - `validate:premium-boundary` passed against the live `150 starter / 750 premium / 900 total` boundary
- The earlier Phase 1A / 1B manifests still validate as `promoted-live` historical lane records.
- Tagalog still rebuilt successfully on the shared family seam after the Viet audio completion pass.

### Viet audio artifact completion pass

- The audio-completion lane filled the clips that were still missing for the newly expanded 900-family pack, then promoted the source CSV only after the seam proof passed.
- Ran `node scripts/generate-audio-elevenlabs.js --variant viet` from `E:\AI\SpeakLocal-App-Family\app`.
- Because `E:\AI\SpeakLocal-App-Family` is a junction to `E:\AI\Viet-Travel-Phrases`, the physical write target resolved to `E:\AI\Viet-Travel-Phrases\app\assets\audio` while remaining accessible at `E:\AI\SpeakLocal-App-Family\app\assets\audio`.
- ElevenLabs run result during that completion step: `Generated: 406`, `Skipped: 513`, `Failed: 0`.
- Rebuilt the Viet audio mapping seam from current-pack truth:
  - `app/assets/audio/registry.ts`
  - `app/assets/audio/manifest.json`
- Post-pass artifact proof:
  - `919` approved Viet rows now have matching on-disk file + registry + manifest coverage
  - `919` current-pack Viet clips are mapped for runtime playback in the app seam
  - machine-checked reconciliation found `0` missing approved audio keys, `0` unexpected mapped registry keys, `0` unexpected manifest keys, and `2` ignored physical extras on disk
  - `921` Viet MP3 files physically exist in the folder, including `2` legacy unreferenced extras (`problems-5.mp3`, `problems-7.mp3`) that runtime mapping now ignores
  - folder users can open immediately: `E:\AI\SpeakLocal-App-Family\app\assets\audio`
- The live source CSV now records the proved final audio posture: `919 ready / 0 planned`.
- Refreshed the website preview/audio export seam from the new ready state and revalidated the site artifact from the canonical repo root.

### Operational truth reconciliation

- Updated the current durable project docs, operational docs, and onboarding truth to match the live `150 / 750 / 900` boundary.
- Kept the live audio posture at the proved `919 ready / 0 planned` state while keeping device-proof and broader continuity-QA debt separate from artifact completion.

### Fresh Viet preview-build preflight prep

- Re-ran the canonical app-root preflight from `E:\AI\SpeakLocal-App-Family\app`:
  - `node scripts/generate-audio-elevenlabs.js --variant viet`
  - `npx --no-install tsx scripts/generate-audio-registry.ts --variant viet`
  - `npx --no-install tsx scripts/generate-audio-manifest.ts --variant viet`
  - `npm run build:viet-pack`
  - `npm run build:tagalog-pack`
  - `npm run validate:family`
  - `npm run validate:premium-boundary`
  - `npm run validate:premium-expansion`
  - `npm run export:website-previews`
- `npx --no-install tsc --noEmit`
- Ran `$env:EXPO_PUBLIC_APP_VARIANT='viet'; npx expo config --json` from the canonical app root and confirmed the repo still resolves Viet as `SpeakLocal Vietnam` with `ios.buildNumber = "2"`.
- Created fresh standalone root `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1` by copying the canonical app root without `.expo` or `node_modules`.
- Installed the staged dependencies with `npm ci`.
- Confirmed staged Expo identity twice from that standalone root:
  - first at `1.0.0 (4)` for the internal preview build
  - then at `1.0.0 (5)` for the separate store/TestFlight build
- Because the disposable standalone root did not carry git metadata, used `EAS_NO_VCS=1` for the EAS calls rather than mutating canonical repo state.
- Preview-build execution result:
  - launched internal preview build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
  - build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
  - app version / build: `1.0.0 (4)`
  - last seen state during this task: `in queue`
- First store/TestFlight attempt found a real build-path constraint:
  - canonical `production.autoIncrement` is not supported with the current `app.config.js` setup in the disposable staging root
  - resolved by keeping the store/TestFlight build number explicit and removing the staged `autoIncrement` flag in the disposable `eas.json` copy only
- Store/TestFlight execution result after that stage-only fix:
  - launched store build `5f61efeb-661d-426b-a280-aed866dcb5c2`
  - build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/5f61efeb-661d-426b-a280-aed866dcb5c2`
  - app version / build: `1.0.0 (5)`
  - EAS confirmed ASC app ID `6761904350` and an App Store Connect API key already configured for submit
  - last seen state during this task: `new`
- Auto-submit scheduling did not complete in this task:
  - EAS rejected the `--what-to-test` attempt because changelog submission is Enterprise-plan-only
  - no successful TestFlight submission was recorded yet
- No fresh installable artifact, purchase proof, restore proof, or post-expansion device walkthrough was captured in this task.

### Viet audio continuity benchmark

- Captured the first controlled benchmark on the fully mapped but still mixed old/new Viet audio lane.
- Benchmark evidence path:
  - `E:\AI\OpenClaw\workspace\projects\SpeakLocal Viet Audio Continuity Benchmark.md`
- Method used in this task:
  - full-inventory machine-assisted acoustic scan across all `919` approved mapped clips
  - seam bucket split by on-disk modified date:
    - `64` legacy bundled clips from `2026-04-02`
    - `61` earlier refreshed/new clips from `2026-04-15`
    - `794` completion-wave clips from `2026-04-16`
  - seam-heavy sample of `36` clips with `30` purposeful stress clips plus `6` seeded random holdout clips
  - explicit risky-key coverage for `airport-4`, `health-1`, and `bath-1`
  - duplicate-hash sweep across all mapped clips
  - rough ASR proxy on the `36` sample clips only
- Benchmark result:
  - overall conclusion `CAUTION`
  - acceptable for current product use and the next product/device phase
  - not a clean same-speaker-continuity pass
  - not a justification for broad regeneration
- Key evidence:
  - `0` duplicate hashes across the `919` mapped clips
  - required risky clips were not acoustic seam outliers
  - full-lane acoustic overlap was substantial enough that the mixed lane did not separate into a clear old/new cliff
  - legacy clips still differ on average from newer clips in pacing, loudness, and timbre, so stronger same-speaker claims remain unsupported
- Reviewer gate result:
  - benchmark reviewer: `CAUTION`
  - product-risk reviewer: `CAUTION`
  - scope reviewer: `CAUTION`
- Bounded follow-up posture:
  - keep future audio follow-up limited to a tiny manual-review watchlist if stronger release confidence is wanted later
  - do not reopen broad audio generation from this benchmark alone

### Situation-first app-side pre-build readiness pass

- Updated the repo-side Viet app presentation so the next native preview build can test the current product direction instead of the older thinner-pack shape:
  - visible `Situations` labeling on the main tab and home discovery flow
  - high-stress home priority grid for arrival, transport, money, food, pharmacy, emergencies, phone/SIM trouble, and misunderstanding repair
  - pressure-safe quick phrases tied to those same starter situations
  - scenario metrics showing free-vs-total depth plus live audio coverage cues
  - premium and settings surfaces aligned to the live `150 starter / 750 premium / 900 total` truth, one-time purchase framing, and clearer restore/store-unavailable messaging
- Synced the Viet draft-plan truth in `content-draft/viet/scenario-plan.json` to the same home order and quick-phrase defaults so validator-owned source of truth matches the shipped presentation.
- Rebuilt the Viet pack and re-ran the current local validation set from `E:\AI\SpeakLocal-App-Family\app` after the app-side changes:
  - `npm run build:viet-pack`
  - `npm run build:tagalog-pack`
  - `npm run validate:family`
  - `npm run validate:premium-boundary`
  - `npm run validate:premium-expansion`
  - `npm run export:website-previews`
  - `npx --no-install tsc --noEmit`
- Validation result for this pass:
  - all commands above passed
  - no fresh preview build was produced in this task
  - no new iPhone install, purchase, restore, or restart-persistence proof was captured in this task
  - this left the next build-worthy question as the on-device value of the refreshed situation-first home/search/premium surfaces plus the real purchase lane, not raw content depth

### Shared search normalization audit and bounded fix pass

- Re-audited the shared search matcher against the current Viet and Tagalog repo truth with a focus on separator-heavy traveler queries.
- Found a real repo-side normalization gap before the fix:
  - compact queries like `wifi` and `checkin` could miss phrases whose searchable text only appeared as `Wi-Fi`, `wi fi`, or `check in`
  - captured one concrete pre-fix example during the audit run: `searchPhrases(vietPack, 'wifi', true)` returned `3` top matches while `searchPhrases(vietPack, 'wi-fi', true)` returned `5`
- Applied a bounded shared-shell fix in `app/lib/searchPhrases.ts`:
  - kept the existing accent/punctuation normalization path
  - added a compact no-space comparison so separator variants can still match the same underlying phrase family
- Local validation captured in this task:
  - `npx --no-install tsc --noEmit`
  - deterministic Node proof of the normalization rule now passes for representative repo-real strings such as `Wi-Fi`, `eSIM`, `check in`, and `air conditioning`
- Validation limit that still remains honest:
  - the pack-backed interactive query probe that worked earlier in the audit could not be rerun after the edit because the current sandbox blocked the `tsx`/`esbuild` child-process path with `spawn EPERM`
  - no new simulator, device, or manual runtime search smoke was captured in this task
- `2026-04-20` queue rerun truth:
  - re-audited the same shared-search seam inside the narrower `T-073` write scope
  - confirmed the compact-separator matcher fix already lives in `app/lib/searchPhrases.ts` and did not change in this rerun
  - captured deterministic normalization proof for representative repo-real strings such as `Wi-Fi`, `wi fi`, `wifi`, `check-in`, `check in`, `checkin`, `eSIM`, `e-sim`, and `esim`; the normalized/compacted forms still converge as expected
  - `npx --no-install tsc --noEmit` still passed from `E:\AI\SpeakLocal-App-Family\app`
  - `npm run validate:family` still could not run in this sandbox because `tsx`/`esbuild` failed with `spawn EPERM`, so there is still no fresh pack-backed interactive or runtime search proof from this rerun
  - applied one bounded family-shell UX fix only in `app/family/presentation/tagalog.ts` so the Tagalog search placeholder, results title, empty state, and clear label now better match the shared traveler-search guidance already present on Viet
  - this rerun does not count as a new matcher change, simulator proof, or physical-device search proof

### Viet purchase-surface clarity audit

- Ran a bounded repo-side audit on `2026-04-18` against the current Viet purchase and locked-state presentation seam only.
- Verified the current purchase-state logic already stays honest about App Store dependence through:
  - `app/lib/premiumStoreMessages.ts`
  - `app/app/premium.tsx`
  - `app/app/settings.tsx`
- Found a smaller repo-side UX issue instead:
  - the Viet locked/unlocked badge copy was too vague at a glance
  - the home teaser and premium/settings body copy was denser than necessary for smaller phones
- Applied bounded Viet-only copy tightening in `app/family/presentation/vietPremium.ts`:
  - clearer locked/unlocked labels
  - shorter teaser, screen, manage, and scenario-preview copy
  - more explicit store-unavailable placeholder wording
  - no purchase logic, pricing, entitlement logic, or App Store wiring changed
- `2026-04-20` rerun truth:
  - re-audited the same Viet purchase seam to close the queue successor task
  - confirmed the bounded `app/family/presentation/vietPremium.ts` clarity fix is still present in repo truth
  - found no additional Viet-only `app/family/**` edit that was justified from repo inspection
  - kept the result honest as validation-only evidence, not new purchase/device proof
  - for this rerun, only the bullets inside this Viet purchase-surface subsection are part of the task claim set; the rest of this document remains broader historical ops context
- This audit does **not** count as physical-device purchase proof, restore proof, or small-iPhone walkthrough proof.

### Website starter alignment and high-stress expansion pass

- Expanded the Viet website preview source truth from `3` to `7` export-driven starter modules by adding:
  - `vietnam-arrival-basics`
  - `vietnam-transport-basics`
  - `vietnam-money-basics`
  - `vietnam-phone-basics`
- Kept those new modules aligned to app-real scenario seams and starter `say-first` rows only; no website-only phrase families or blended website-only arrival taxonomy were introduced.
- Added a tiny likely-reply pilot in the shared Viet source CSV on exported starter rows only:
  - `airport-5`
  - `taxi-1`
  - `transport-fare`
  - `price-1`
  - `phone-2`
  - `repair-2`
- Rebuilt `app/family/packs/viet.generated.ts` and regenerated both site-owned phrase/audio export trees:
  - `site/data/phrase-previews/*`
  - `site/public/data/phrase-previews/*`
  - matching `site/data/phrase-audio/*`
  - matching `site/public/data/phrase-audio/*`
- Updated the touched Vietnam website surfaces so high-stress starter modules now appear early on:
  - `site/index.html`
  - `site/countries/vietnam/index.html`
  - `site/blog/phrases-tourists-actually-need-in-vietnam/index.html`
  - `site/blog/vietnam-first-24-hours/index.html`
  - `site/blog/vietnam-grab-taxi-confusion/index.html`
  - `site/blog/vietnam-sim-esim-offline-setup/index.html`
  - plus their flat-route `.html` twins
- Removed the stale Viet `150 / 350 / 500` website truth from the `site/` tree and replaced it with the live `150 / 750 / 900` boundary, while keeping the website wording honest that it shows selected starter preview modules rather than the full starter layer in web form.
- Extra website proof captured in this pass:
  - route-pair parity passed
  - website artifact validation passed
  - explicit source-to-export freshness checks confirmed changed module `headline`, `summary`, `phraseIds`, and starter `say-first` posture in both `site/data/phrase-previews` and `site/public/data/phrase-previews`
  - explicit stale-truth sweep over `site/` found no remaining `150 / 350 / 500`, `350 premium`, or `500 total` website copy
  - local HTTP smoke passed for the touched Vietnam pages plus module JSON delivery through `py -m http.server 4173 --directory site`
  - staging publish passed through `Publish-SpeakLocalWebsiteStaging.ps1`
  - staging smoke passed at `http://speaklocal.app:8081/` on both clean-route and slash-route forms for the key touched Vietnam pages

### Latest device / preview-build truth

- The latest installable Viet preview build still remains the `2026-04-15` preview artifact:
  - EAS build ID: `ae55c880-0d6b-49b5-ba5e-64d82787eb25`
  - build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/ae55c880-0d6b-49b5-ba5e-64d82787eb25`
- That installable build predates the `2026-04-16` live 900-family + audio completion pass.
- Fresh current-repo builds are now in flight but not installable yet:
  - internal preview build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` at `1.0.0 (4)`
  - store/TestFlight build `5f61efeb-661d-426b-a280-aed866dcb5c2` at `1.0.0 (5)`
- No fresh iPhone install, purchase, restore, or post-expansion walkthrough was captured in this task.

## Commands that passed

- `node scripts/generate-audio-elevenlabs.js --variant viet`
- `npx --no-install tsx scripts/generate-audio-registry.ts --variant viet`
- `npx --no-install tsx scripts/generate-audio-manifest.ts --variant viet`
- `npm run build:viet-pack`
- `npm run build:tagalog-pack`
- `npm run validate:family`
- `npm run validate:premium-boundary`
- `npm run validate:premium-expansion`
- `npm run export:website-previews`
- `npx --no-install tsc --noEmit`
- `$env:EXPO_PUBLIC_APP_VARIANT='viet'; npx expo config --json`
- staged `npm ci` from `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1`
- staged `$env:EXPO_PUBLIC_APP_VARIANT='viet'; npx expo config --json` from `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1`
- `powershell -ExecutionPolicy Bypass -File .\scripts\website\Test-SpeakLocalWebsiteArtifact.ps1`
- `powershell -ExecutionPolicy Bypass -File .\scripts\website\Publish-SpeakLocalWebsiteStaging.ps1`

## What was not yet validated in a durable way

- As of `2026-04-21`, repo truth still does not add newer durable proof beyond this `2026-04-16` snapshot.

- a finished installable preview build that includes the new 900-family Viet pack and completed audio seam
- a processed TestFlight build from the current `2026-04-16` repo snapshot
- a durable record of whether the Viet non-consumable plus Sandbox Apple Account lane is purchase-ready, or which exact Apple-side blocker still prevents it
- physical-device purchase flow for the Viet non-consumable
- physical-device restore flow for the Viet non-consumable
- restart persistence on physical iOS hardware after a real purchase
- shared-search runtime/manual smoke on Viet and Tagalog
- fuller device walkthrough evidence on Viet and Tagalog
- a blind human boundary listen of `10-12` old/new seam clips only if the team later wants to upgrade the current audio benchmark from `CAUTION` to a stronger `PASS`
- a physical-device or real-browser interaction spot-check of the current `0.5x / 0.75x / 1.0x` playback-speed controls
- live promotion of the current staged website artifact to `https://speaklocal.app/`
