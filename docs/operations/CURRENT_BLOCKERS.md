# Current Blockers

Last updated: 2026-04-21
Authority lane: live app operational truth

Use this doc for blocker state only. For the single ordered operator checklist, use `VIET_TESTFLIGHT_EXECUTION_PACKET.md`.

Truth-sync note: this `2026-04-21` refresh re-read the same blocker packet and did not add new App Store Connect, TestFlight, install, or physical-device proof. It keeps `VIET_TESTFLIGHT_EXECUTION_PACKET.md` as the sole ordered checklist and tightens this file to blocker state plus the same evidence boundary. The later `2026-04-18` Viet purchase-surface audit and `2026-04-20` Tagalog search-copy rerun remain bounded repo-side honesty evidence only.

## Current blockers to shipping Viet v2

1. Human App Store Connect setup and device proof are still missing for the Viet non-consumable:
   - bundle ID: `com.jojobuilds.viettravelphrases`
   - product ID: `com.jojobuilds.viettravelphrases.premiumunlock`
   - price: `$4.99`
   - latest known older installable preview build: `ae55c880-0d6b-49b5-ba5e-64d82787eb25`
   - build page: `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/ae55c880-0d6b-49b5-ba5e-64d82787eb25`
   - this older installable artifact predates the `2026-04-16` repo snapshot and does not count as proof for the current snapshot
   - fresh preview build already launched from the current repo snapshot:
     - build ID `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
     - build page `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
     - build `1.0.0 (4)`
     - last durable state seen `in queue`
   - fresh store/TestFlight build already launched from the same repo snapshot:
     - build ID `5f61efeb-661d-426b-a280-aed866dcb5c2`
     - build page `https://expo.dev/accounts/jayopsai/projects/viet-travel-phrases/builds/5f61efeb-661d-426b-a280-aed866dcb5c2`
     - build `1.0.0 (5)`
     - last durable state seen `new`
  - as of `2026-04-21`, repo truth still has no newer durable evidence that either build completed, became installable, or processed into TestFlight
   - required proof: real purchase, restore, restart persistence, premium gating behavior, and the refreshed situation-first home/search/premium flow for the current `150 starter / 750 premium / 900 total` boundary on physical iOS hardware
   - note: the canonical repo now contains the `2026-04-16` 900-family + audio completion pass, and the fresh preview/store build lane has been launched, but neither artifact is finished/installable/processed yet
   - standalone preview-build workaround remains required; use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the staged-root, build-number, preview-vs-TestFlight split, and no-VCS details
   - Expo/EAS is no longer the main unknown:
     - the current account is logged in as `jayopsai`
     - App Store Connect app ID `6761904350` is configured
     - EAS confirmed an App Store Connect API key is already set up for submit
   - exact Apple-side setup still missing or unconfirmed in a durable way: finished non-consumable metadata, review screenshot/notes, intentional availability state, paid-apps agreement readiness, dedicated Sandbox Apple Account, and enough sandbox propagation time after edits
   - safest documented purchase-proof lane: TestFlight plus a Sandbox Apple Account; the current EAS `preview` build is still useful for install/runtime preflight, but durable purchase evidence should not rely on the internal/ad hoc lane alone
   - still-missing evidence package before this blocker can clear:
     - preview-install state for build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`, including installable or exact failure state
     - store/TestFlight state for build `5f61efeb-661d-426b-a280-aed866dcb5c2`, including processed or exact failure state
     - Apple-side purchase-readiness state for the Viet non-consumable plus Sandbox lane, including ready or exact blocker state
     - physical iOS proof for App Store sheet, purchase, restore, relaunch persistence, and locked-vs-unlocked gating on the live `150 starter / 750 premium / 900 total` boundary
     - bounded shared-search smoke from the same manual lane if feasible, or one explicit note that the search blocker below still remains open
     - exact sync of any changed gate state or blocker wording back into `APP_STATUS.md`, `CURRENT_BLOCKERS.md`, `TESTING_RUNBOOK.md`, and `ops/apps/viet.json`, plus `LATEST_VALIDATION.md` only if fresh durable evidence changed the last validation snapshot
   - exact release-ops nuance now known:
     - `production.autoIncrement` is not usable with the current `app.config.js` setup in the disposable staging root
     - `--what-to-test` must stay out of the auto-submit command on the current Expo plan because EAS rejected it as an Enterprise-only changelog feature
2. Viet audio continuity is now benchmarked to a `CAUTION` result rather than blocked by missing coverage or a missing benchmark.
   - the `2026-04-15` sampled QA pass judged the new lane internally consistent enough to continue with conditions, but only `mixed` against the older in-app lane
   - the `2026-04-16` controlled continuity benchmark then ran across the current `919` mapped clips and a `36`-clip seam-heavy sample and judged the mixed lane acceptable for current product use and the next product/device phase
   - this is still not a clean same-speaker pass, so release wording must stay honest and should not imply perfect voice uniformity
   - if stronger release confidence is wanted later, keep follow-up limited to a tiny manual boundary watchlist beginning with `airport-4`, `health-1`, and `bath-1`
   - 2 legacy orphan MP3s (`problems-5.mp3`, `problems-7.mp3`) still sit on disk, but the runtime registry and manifest now ignore them
3. The earlier shared-search device-proof debt is still open, so the current family baseline is not fully frozen yet.
4. The current live repo is stronger than the older 128/158-era build that received the last negative iPhone pass, but the stronger repo truth has not yet been device-tested.
   - the repo now combines the focused wording/naming follow-up with the live 900-family content milestone and fully mapped audio seam
   - the repo now also includes a situation-first pre-build app pass for the home, quick-access, scenario, and premium surfaces
   - the next real question is whether the current 900-family pack plus the refreshed situation-first app shell feels understandable and believable on device, not whether the older thinner pack was good enough

## Current blockers to freezing the shared Viet + Tagalog search baseline

1. Shared search is implemented and locally validated, but no real runtime/manual search smoke is captured yet for the current Viet + Tagalog sessions.
   - repo-side truth is slightly stronger as of `2026-04-18`: the shared matcher now handles compact separator variants more safely, so queries like `wifi` / `wi-fi` / `wi fi` and `checkin` / `check in` no longer depend on the exact punctuation shape in the indexed phrase text
   - repo-side truth is slightly clearer as of `2026-04-20`: the Tagalog family-shell search copy now mirrors the shared traveler guidance more closely, but this was a presentation-only pass and not a matcher or device-proof update
   - this does not clear the blocker by itself because the current Viet + Tagalog search flow still lacks durable manual runtime proof
   - the preferred next lane is to capture bounded search smoke during the same human/device pass if feasible; otherwise the return package should say explicitly why the search blocker remains open
2. No fuller physical-device walkthrough is captured in the durable validation record for the current Viet + Tagalog setup.


## Current release-ops blockers beyond product work

1. Direct remote EAS builds from the canonical repo path still fail because of project-root packaging drift.
   - fresh confirmation: the `2026-04-15` Viet preview build succeeded only through the standalone-root workaround at `E:\AI\SpeakLocal-EAS-Build-20260415-viet-preview-r1`
2. Fresh standalone-root builds were launched for the current `2026-04-16` live repo state, but they are not finished/processed yet.
   - preview build `39b7fbfd-909c-48fe-9317-f8be2c5e6e02` is still not installable at last check
   - store/TestFlight build `5f61efeb-661d-426b-a280-aed866dcb5c2` is still not processed into TestFlight at last check
3. The production/store lane now requires an explicit staged build-number bump above the preview build because canonical `production.autoIncrement` is not usable with the current `app.config.js` setup inside the disposable staging root.
4. The current Expo plan rejected auto-submit when `--what-to-test` was passed, so submission must be run without that flag after the store build finishes unless EAS is retried with a clean auto-submit command first.
5. Tagalog still needs its own real v2 content-pack pass before it can reuse the Viet monetization pattern credibly.
6. Tagalog App Store Connect mapping and Tagalog device proof have not started yet. The family plumbing is ready, but the variant setup is not.
