# Claim Risk Checklist

Date: 2026-07-05
Status: active marketing guardrail
Product truth: native iOS `main`, current operations docs, and config evidence

## Safe Claims

Use these in App Store, screenshots, video, social, and landing copy when paired with fresh current-app visuals.

| Claim | Evidence | Usage Notes |
| --- | --- | --- |
| SpeakLocal Vietnam is a native iOS app. | `docs/operations/APP_STATUS.md`, `native-ios/Config/apps/vietnam.json` | Safe. |
| The app helps with food, places, useful phrases, Search, Browse, Saved, Practice, and playable bundled audio. | `docs/operations/APP_STATUS.md`, current native resources | Safe when not implying every row has audio. |
| It is for English-speaking Vietnam travelers before and during the trip. | `marketing/AGENTS.md`, `docs/V2_BASELINE.md` | Safe. |
| It is not a live translator or classroom course. | Product positioning docs | Safe and strategically useful. |
| Travelers can hear supported Vietnamese audio. | Audio manifest validation in operations docs | Say `supported` or `bundled`, not perfect or universal. |
| Travelers can save and practice trip phrases. | Native app proof in operations docs | Avoid course/fluency framing. |

## Use Carefully

| Claim | Risk | Safer Wording | Status |
| --- | --- | --- | --- |
| Offline | Could imply every app behavior works without network. | `bundled phrases and audio` or `prepared before the trip` | `NEEDS_APP_PROOF` before broad offline claim |
| Full Vietnam guide | Could imply comprehensive travel guide coverage. | `curated Vietnam companion` | Safe with careful wording |
| Audio-backed | Could imply all rows/pages have audio. | `playable audio on supported content` | Safe with qualifier |
| Emergency/help | Could imply reliability in serious situations. | `calm help, health, pharmacy, and support phrases` | Avoid as lead |
| Subscription/trial | StoreKit and App Store Connect dependent. | `FUTURE / DO NOT PUBLISH` until proof | `NEEDS_STOREKIT_PROOF` |

## Blocked Until Proof

| Claim Or Asset | Required Proof |
| --- | --- |
| 7-day free trial customer-facing CTA | App Store Connect subscription state, StoreKit purchase/restore/relaunch proof, Jojo approval |
| Paywall screenshot | Current native paywall on approved branch/main, App Store Connect terms matched |
| Price in App Store description | Jojo approval and App Store Connect terms; preferably avoid hardcoding |
| Final App Store screenshots | Fresh capture from current native `main` |
| App Preview | Fresh screen recordings from current native `main` |
| Privacy labels | App Store Connect review |
| Support URL | Real support/contact page source |
| Category selection | Jojo decision after App Store strategy review |

## Forbidden Claims

Do not publish:

- `Learn Vietnamese fast`
- `Become fluent`
- `Translate anything instantly`
- `AI translator`
- `Perfect pronunciation`
- `Same-speaker audio`
- `Emergency translator`
- `Medical/legal authority`
- `Complete Vietnam coverage`
- `Every phrase has audio`
- `Works fully offline` unless proven for the exact release and phrased narrowly
- `Free forever` or any permanent free-tier promise unless Jojo changes product direction

## Pre-Publish Review Checklist

- Does the claim appear visibly supported by the screenshot or video?
- Does the claim match current native `main`, not a feature branch?
- Does it avoid unreleased paywall, Messages, StoreKit, or future language-pack assumptions?
- Does it avoid old Expo/React/web surfaces?
- Does it avoid competitor names in App Store metadata?
- Does it use `NEEDS_*` if it depends on screenshots, App Store Connect, StoreKit, or Jojo decisions?
