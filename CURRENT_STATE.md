# SpeakLocal App - Current State
_Last updated: 2026-04-09. Read this file first before any new build, review, or submission work._

## Current posture

The app is in pre-submission hardening, not blank-slate development.

Opus completed a cold pre-submission review on 2026-04-07 and identified the real blockers. The interrupted follow-up implementation work has now been recovered and reconciled.

Reference files:
- `reviews/pre-submission-review-opus-2026-04-07.md`
- `reviews/RECOVERED-HANDOFF-2026-04-08.md`
- `reviews/PRE-SUBMISSION-CHECKLIST-2026-04-08.md`

## What is done in the working tree

- App scaffold, all 10 scenarios, 70 phrases, and bundled audio are in place
- NativeWind v4 styling, Expo Router, tab navigation, favorites, settings, and feedback modal are in place
- App runs on iPhone via Expo Go from prior verification
- EAS build config exists for `development`, `preview`, and `production`
- A new iOS internal preview build finished from EAS on 2026-04-08:
  - `6467e106-a6d6-4973-9de7-b8e381f0aec6`
- A new iOS store-signed build finished from EAS on 2026-04-09 01:09 UTC:
  - `0db6c21a-703a-433b-a10f-626ef4fc9507`
- App Store Connect app record now exists:
  - Apple app ID `6761904350`
- `app/eas.json` now includes the iOS submit `ascAppId`
- Store build `0db6c21a-703a-433b-a10f-626ef4fc9507` has been uploaded to App Store Connect / TestFlight
- App Privacy has been configured and published in App Store Connect
- TestFlight build `1.0.0 (2)` is now installed on iPhone
- In-app privacy and terms screens exist
- Public privacy, terms, and landing docs exist
- App Store listing copy exists
- In-app placeholder "Rate this App" row has been removed
- Privacy copy now discloses the optional Formspree feedback flow
- App Store listing copy no longer claims native-speaker audio
- In-app naming has been aligned around `Viet Travel Phrasebook` for long-form copy
- Both icon files are now opaque RGB 1024x1024 with no alpha
- TypeScript passes in `app/`
- Expo doctor passes in `app/`
- Local iOS export bundles successfully from `app/`
- `expo-font` has been added directly so the app is safer outside Expo Go
- The stale OpenAI TTS script has been removed from the shipping repo path

## What is still not done

1. **Commit and push the current working tree**
   - The repo still has important uncommitted changes

2. **Run the TestFlight device validation pass**
   - The TestFlight build is available and installed on iPhone
   - The next step is to run the on-device checklist and capture any bugs or submission risks

3. **App Store Connect privacy disclosure**
   - Privacy disclosure is now published
   - The remaining task is just to keep it aligned with the shipping app behavior

4. **Screenshots**
   - Screenshot status is still unresolved
   - Jojo must confirm they are already in App Store Connect or re-create/upload them

5. **Real feedback-path verification**
   - A live end-to-end feedback submission test should be done before submission

6. **Final pre-submit review**
   - One more final pass should happen against the updated working tree before store submission

## Submission blockers now

### Repo-side blockers
- Uncommitted working tree

### Manual / Apple-side blockers
- Screenshots not yet confirmed
- Feedback flow not yet tested end-to-end

## Icon status

- The old icon transparency issue has been corrected in the working tree
- Both:
  - `app/assets/icon.png`
  - `app/assets/images/icon.png`
  are now opaque RGB assets
- The next build should verify the icon also looks visually right on device/TestFlight

## Product naming

- Springboard / short app name:
  - `Viet Phrases`
- Long-form in-app / store-facing name:
  - `Viet Travel Phrasebook`

This split is intentional and should stay consistent.

## Immediate next step

Run the TestFlight phone checklist on build `1.0.0 (2)`, especially audio, favorites persistence, legal links, icon rendering, and the real feedback submission path.
