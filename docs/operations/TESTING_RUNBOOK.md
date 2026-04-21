# Testing Runbook

Last updated: 2026-04-21
Authority lane: live app operational truth

## Use this doc for

- repo-owned validation commands
- the repo-owned build/test handoff order
- lane split and post-run sync targets

Do not maintain a second literal copy of the human iPhone execution checklist here. `VIET_TESTFLIGHT_EXECUTION_PACKET.md` now owns the single ordered operator checklist for the next Viet pass.

Truth-sync note: this `2026-04-21` refresh did not add new build or device evidence. It keeps the literal next-operator checklist and exact six-item return packet in `VIET_TESTFLIGHT_EXECUTION_PACKET.md`, including the stable field labels and fold-in order, while narrowing this file to repo-owned sequencing, retry rules, and sync targets. The later `2026-04-18` Viet purchase-surface audit and `2026-04-20` Tagalog search-copy rerun remain bounded repo-side honesty evidence only and do not change the human/device lane.

## Working directories

- Canonical repo root: `E:\AI\SpeakLocal-App-Family`
- Preferred app root: `E:\AI\SpeakLocal-App-Family\app`

## Current local validation commands

From `E:\AI\SpeakLocal-App-Family\app`:

1. `npm run build:viet-pack`
2. `npm run build:tagalog-pack`
3. `npm run validate:family`
4. `npm run validate:premium-boundary`
5. `npm run validate:premium-expansion`
6. `npm run export:website-previews`
7. `npx --no-install tsc --noEmit`

## Validation interpretation

- `build:viet-pack` rebuilds the live Viet v2 content pack from `content-draft/viet/`.
- `build:tagalog-pack` confirms Tagalog still rebuilds on the shared generated-pack path.
- `validate:family` validates structural integrity, starter/premium boundaries, search access behavior, and ready-vs-planned audio expectations.
- `validate:premium-boundary` validates the live Viet `150 starter / 750 premium / 900 total` boundary, starter/premium search gating, unique product IDs, and Tagalog inheritance for the current premium surface.
- `validate:premium-expansion` validates future lane scaffolds plus promoted-live lane manifests.
- `export:website-previews` regenerates the approved Viet starter-only website phrase/audio module JSON exports.

## Private phone preview for live UI passes

From `E:\AI\SpeakLocal-App-Family\app`:

1. Start the authenticated Expo web lane:
   - `cmd.exe /c "set EXPO_PUBLIC_APP_VARIANT=viet&& set BROWSER=none&& npx expo start --web --port 19008 --clear"`
2. Sign into `https://dashboard.jayopsai.com`
3. Open:
   - `https://dashboard.jayopsai.com/design/viet`

Notes:

- This route embeds the live Expo web app behind the existing dashboard auth wall.
- Fast Refresh now reaches the dashboard canvas, so preview-only text and layout changes should appear without rebuilding a native iPhone app.
- Use `/design-live/<preset>` routes when you need deterministic real-app states like search results, saved-filled, premium-unlocked, or scenario-locked instead of tapping through the app by hand.
- If the frame ever stalls after a larger change, use the canvas `Reload frame` button before treating the route as broken.

Optional screenshot verification from `E:\AI\SpeakLocal-App-Family\app`:

1. Set dashboard auth in the shell if you are targeting the hosted domain:
   - `$env:DASHBOARD_AUTH_TOKEN='<dashboard token>'`
2. Capture the exact hosted canvas state:
   - `npm run capture:design -- --dashboard-url https://dashboard.jayopsai.com --route /design-live/home-search-results --device iphone-15-pro`

Notes:

- The capture script uses the same authenticated dashboard surface rather than a separate local-only page.
- Default output lands under `artifacts/design-captures/`.
- For loopback-only validation on the server, you can swap `https://dashboard.jayopsai.com` for `http://127.0.0.1:18790`.

## Website bundle checks for `site/` passes

When a task edits the richer website bundle under `site/`, also validate:

1. route-pair parity for any edited `foo.html` and `foo/index.html` pages
2. local link integrity across `site/**/*.html`
3. direct-serve preview-data parity:
   - `site/data/phrase-previews/manifest.json`
   - `site/public/data/phrase-previews/manifest.json`
   - no stale source-unbacked preview JSON files
   - manifest and module JSON shape stays valid for the website-safe phrase/audio seam
4. run the repo validator from `E:\AI\SpeakLocal-App-Family`:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Test-SpeakLocalWebsiteArtifact.ps1`
5. manual smoke on the pages actually changed before calling the website pass complete
   - confirm the page fetches the exported module JSON over HTTP rather than relying on hardcoded phrase markup

## Website staging-first publish flow

From `E:\AI\SpeakLocal-App-Family`:

1. Edit `site/`
2. If preview data changed, regenerate it from `app\`:
   - `npm run export:website-previews`
3. Validate the artifact:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Test-SpeakLocalWebsiteArtifact.ps1`
4. Review the working artifact locally:
   - `py -m http.server 4173 --directory site`
   - review `http://127.0.0.1:4173/`
5. Publish the reviewed bytes to staging:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Publish-SpeakLocalWebsiteStaging.ps1`
6. Review the real staging surface:
   - `http://speaklocal.app:8081/`
   - fallback: `http://38.247.143.2:8081/`
   - inspect `/__deployment.json` if you need to confirm which artifact is staged
7. Promote only after signoff:
   - `powershell -ExecutionPolicy Bypass -File .\scripts\website\Promote-SpeakLocalWebsiteLive.ps1`
8. Verify live:
   - `https://speaklocal.app/`
   - `https://www.speaklocal.app/`
9. Roll back from the latest live backup under `E:\AI\Shared\Backups\speaklocal-site\` if a promotion needs to be undone

## Exact next Viet iPhone validation pass

Use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the literal next-operator checklist.
The older OpenClaw docs remain reference inputs only and should not compete with the repo-owned execution packet.

### Repo-owned handoff order

1. Confirm the current snapshot and latest installable artifact in `APP_STATUS.md`.
2. Confirm the still-open gates in `CURRENT_BLOCKERS.md`.
3. Follow `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the exact preview/TestFlight/App Store Connect/device-proof sequence.
   - if the disposable staging root does not carry git metadata, either set `EAS_NO_VCS=1` or initialize git there before calling `eas`
4. First try to reuse the tracked in-flight preview/store builds from that packet.
5. Rebuild the same repo snapshot again only if Step 2 of the execution packet says the current preview or store/TestFlight builds are still not ready.
6. If a rebuild is required, keep store/TestFlight distribution on the same staged snapshot at a higher explicit staged build number and submit the finished store build without `--what-to-test`.
7. Run the exact device pass from `VIET_TESTFLIGHT_EXECUTION_PACKET.md` only after the packet's readiness gates are satisfied.
8. Treat the older OpenClaw docs as historical references only if reconciliation is needed.
9. After evidence arrives, fold it back in this order:
   - update Step 6 in `VIET_TESTFLIGHT_EXECUTION_PACKET.md` first
   - then mirror `APP_STATUS.md`
   - then mirror `TESTING_RUNBOOK.md` if build-lane facts, retry posture, or repo sync instructions changed
   - then mirror `ops/apps/viet.json` if gate status, hard-block wording, or handoff wording changed
   - update `CURRENT_BLOCKERS.md` only if blocker truth changed
   - update `LATEST_VALIDATION.md` only if fresh durable evidence changed the last validation snapshot

### Current truth that the execution packet must preserve

- `150 starter / 750 premium / 900 total`
- `919` approved rows
- `919 ready / 0 planned`
- bundle ID: `com.jojobuilds.viettravelphrases`
- product ID: `com.jojobuilds.viettravelphrases.premiumunlock`
- fixed locked-state queries: `hello`, `xin chao`, `pharmacy`, `charged twice`, `zzzzz`

### Current `2026-04-16` build-lane facts

- standalone root used for the current execution lane:
  - `E:\AI\SpeakLocal-EAS-Build-20260416-viet-preview-r1`
- current in-flight internal preview build:
  - `39b7fbfd-909c-48fe-9317-f8be2c5e6e02`
  - `1.0.0 (4)`
- current in-flight store/TestFlight build:
  - `5f61efeb-661d-426b-a280-aed866dcb5c2`
  - `1.0.0 (5)`
- canonical `app.config.js` still resolves Viet as build `2`, so both preview and store lanes require explicit staged build-number control rather than trusting canonical config
- canonical `production.autoIncrement` is not usable with the current `app.config.js` setup inside the disposable staging root; future retries should keep the store/TestFlight build number explicit
- if using EAS auto-submit on the current Expo plan, do not pass `--what-to-test`
- as of `2026-04-21`, repo truth still does not show either in-flight build as installable or TestFlight-processed

### Lane split that remains in force

- internal preview build = install and locked-state preflight only
- TestFlight plus Sandbox Apple Account = durable purchase / restore / restart proof
- if the internal preview snapshot does not load the product or never shows a real App Store sheet, record the blocker and move the same snapshot into TestFlight before escalating it as a repo defect

### Evidence minimum

Use `VIET_TESTFLIGHT_EXECUTION_PACKET.md` for the exact six-item return packet and run-end capture template. The packet owner there is authoritative for these six headings, in this order: `Preview-install state`, `Store/TestFlight state`, `Apple-side purchase readiness`, `Physical device proof`, `Shared-search carry-forward`, and `Repo sync decision`. This runbook should not maintain a second copy of that packet.

## Current operational limits

- no dedicated automated UI test suite exists
- no lint script exists
- no server-side receipt verification exists in this pass
- the live Viet pack now has `919` approved rows marked `audioStatus=ready`, but broader continuity benchmarking on the mixed lane is still outstanding
- direct remote EAS builds from the canonical repo path still fail because of project-root packaging drift
