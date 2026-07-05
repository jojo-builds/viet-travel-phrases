# Source And Evidence Register

Date: 2026-07-05
Status: evidence register for launch pack

## Repo Evidence Used

| Source | What It Supports | Notes |
| --- | --- | --- |
| `marketing/AGENTS.md` | Marketing lane rules, audience lens, copy rules, output shape | Primary marketing guardrail. |
| `marketing/README.md` | Folder structure and positioning starting point | Confirms project folder approach. |
| `docs/operations/APP_STATUS.md` | Current native app surface, latest operational truth, active iPhone proof boundaries, paywall exclusion | Avoids old Expo/React and overclaiming readiness. |
| `docs/operations/LATEST_VALIDATION.md` | Current validation evidence, resource/audio proof, screenshot/proof references, remaining proof needs | Use internally; do not turn counts into customer claims. |
| `docs/V2_BASELINE.md` | Product audience baseline and product shape | Some counts are older than operations docs, so use for positioning more than current numeric proof. |
| `docs/design/NATIVE_VISUAL_REFERENCE.md` | Native screenshot and visual composition guardrails | Use for screenshot/storyboard style. |
| `native-ios/Config/apps/vietnam.json` | Display name, Viet language pack, native bundle IDs, premium product ID | Confirms SpeakLocal Vietnam config. |
| Existing `marketing/app-store/speaklocal-vietnam-launch-packet-2026-07-05.md` | Prior metadata and screenshot draft | Reused structure, corrected caution around stale counts. |
| Existing `marketing/campaigns/speaklocal-vietnam-7-day-launch-plan-2026-07-05.md` | Prior 7-day plan and channel hooks | Extended into a two-week plan. |

## Apple Sources Checked

Checked on 2026-07-05.

| Source | Used For |
| --- | --- |
| https://developer.apple.com/help/app-store-connect/reference/app-information/app-information/ | App name and subtitle limits, privacy URL, bundle/app information fields. |
| https://developer.apple.com/help/app-store-connect/reference/app-information/platform-version-information/ | Promotional text, description, keywords, screenshot/app preview field behavior. |
| https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/ | Screenshot count, file types, and iPhone screenshot dimensions. |
| https://developer.apple.com/help/app-store-connect/reference/app-information/app-preview-specifications | App Preview duration, file size, formats, frame rate, extensions, and accepted resolutions. |

## Current App Evidence To Capture Next

- `NEEDS_SCREENSHOT`: Home.
- `NEEDS_SCREENSHOT`: Food/menu detail with supported audio.
- `NEEDS_SCREENSHOT`: Search result for a real trip query.
- `NEEDS_SCREENSHOT`: City/place detail page.
- `NEEDS_SCREENSHOT`: Saved seeded state.
- `NEEDS_SCREENSHOT`: Practice state.
- `NEEDS_SCREENSHOT`: Calm help/health/pharmacy/support phrase page.
- `NEEDS_SCREEN_RECORDING`: Home to Search to phrase detail.
- `NEEDS_SCREEN_RECORDING`: Food/menu audio tap.
- `NEEDS_SCREEN_RECORDING`: Save to Practice flow.
- `NEEDS_STOREKIT_PROOF`: Paywall, trial, purchase, restore, relaunch, gating.
- `NEEDS_SOURCE`: Support URL, Privacy URL, Terms URL, final App Store link/TestFlight link.
