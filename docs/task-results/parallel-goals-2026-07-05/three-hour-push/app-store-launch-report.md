# App Store And Launch Prep Report

Date: 2026-07-05
Worker: Codex app-store-launch goal thread
Scope: SpeakLocal Vietnam marketing lane
Status: launch pack materially improved; screenshot/App Store Connect/StoreKit dependencies remain explicit

## Work Completed

Created a project launch pack under:

`marketing/projects/vietnam-launch-readiness-2026-07-05/`

Files created:

- `README.md`
- `app-store-metadata.md`
- `screenshot-storyboard.md`
- `app-preview-30s-shot-list.md`
- `two-week-launch-channel-plan.md`
- `claim-risk-checklist.md`
- `source-and-evidence-register.md`

Files updated:

- `marketing/app-store/speaklocal-vietnam-launch-packet-2026-07-05.md`
- `marketing/campaigns/speaklocal-vietnam-7-day-launch-plan-2026-07-05.md`

The pack includes:

- App Store metadata draft with name, subtitle, keywords, promotional text, description, release notes, and submission fields.
- Screenshot storyboard tied to current native app routes and marked `NEEDS_SCREENSHOT`.
- 30-second App Preview shot list marked `NEEDS_SCREEN_RECORDING`.
- Two-week launch channel plan with audience, travel moment, hook, channel, CTA, evidence, claim risk, metric, and next action for each asset.
- Claim-risk checklist separating safe claims, careful claims, blocked claims, and forbidden claims.
- Source/evidence register with repo docs and official Apple specs checked.

## Product Truth Used

- Current shipping/product surface is native iOS under `native-ios/`.
- `native-ios/Config/apps/vietnam.json` confirms display name `SpeakLocal Vietnam`, Viet language pack, native development bundle ID, and premium product ID.
- `docs/operations/APP_STATUS.md` confirms native shell, listing/detail pages, Search, Browse, Home, Practice, local audio playback, bottom chrome, bundled offline Viet resources, and current proof boundaries.
- `docs/operations/LATEST_VALIDATION.md` confirms current validation evidence and remaining proof needs.
- `docs/V2_BASELINE.md` confirms audience/product positioning, while newer operations docs are treated as fresher for validation and resource counts.

## Current App Store Readiness Gaps

- `NEEDS_SCREENSHOT`: fresh 6.9-inch App Store screenshots from current native `main`.
- `NEEDS_SCREEN_RECORDING`: current native screen recordings before producing App Preview or paid/organic video.
- `NEEDS_STOREKIT_PROOF`: paywall, trial, purchase, restore, relaunch, and gating proof before publishing subscription/trial claims.
- `NEEDS_APP_STORE_CONNECT`: final metadata entry, privacy labels, age rating, export compliance, build selection, in-app purchase review screenshot, and analytics access.
- `NEEDS_SOURCE`: support URL, privacy URL, terms URL, App Store/TestFlight link, final icon source.
- `NEEDS_JOJO_DECISION`: final public app name, subtitle, category, release timing, paid-test budget, and whether to keep or change the current live app naming.

## Highest-Leverage Next Marketing Action

Capture and QA the 6.9-inch App Store screenshot set from current native `main`.

Reason: the metadata, storyboard, App Preview, organic posts, paid tests, and App Store assembly all depend on fresh native visuals. The first six captures should be Home, food/menu detail with supported audio, Search results, city/place detail, Saved seeded state, and Practice.

## External Specs Checked

Official Apple App Store Connect docs checked on 2026-07-05:

- App information: https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/
- Platform version information: https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/
- Screenshot specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/
- App preview specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/app-preview-specifications

## Notes And Risk Controls

- No app code was changed.
- No old Expo/React/web app surface was used as product truth.
- No customer-facing copy claims arbitrary AI translation, fluency, perfect pronunciation, emergency reliability, or full language/course coverage.
- Paywall/trial copy remains draft-only and marked `NEEDS_STOREKIT_PROOF`.
- Existing marketing files outside the project folder were lightly updated to point future workers to the new project pack and avoid stale count-heavy evidence.
