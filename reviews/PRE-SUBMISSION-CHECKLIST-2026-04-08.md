# Pre-Submission Checklist - 2026-04-08

Use this before any new TestFlight build or App Store submission attempt.

## Code and repo

- [x] Privacy policy updated to disclose optional Formspree feedback flow
- [x] In-app placeholder "Rate this App" removed
- [x] App Store listing copy no longer claims native-speaker audio
- [x] In-app naming aligned to `Viet Travel Phrasebook`
- [x] Public privacy page updated
- [x] Public terms page updated
- [x] Public landing page no longer claims native audio
- [x] App icon files are opaque RGB 1024x1024 with no alpha
- [x] TypeScript passes: `cd app && npx tsc --noEmit`
- [x] Expo doctor passes: `cd app && npx expo-doctor`
- [x] Local iOS export bundles successfully: `cd app && npx expo export --platform ios`
- [ ] Commit and push the current working tree before the next EAS build

## Manual Apple / release checks

- [x] In App Store Connect, set App Privacy to disclose optional feedback collection via Formspree
- [x] Confirm the bundle ID `com.jojobuilds.viettravelphrases` is the one being submitted
- [x] Confirm screenshots are already uploaded to App Store Connect, or recreate/upload them
- [x] Confirm the privacy policy URL used in App Store Connect matches the updated public policy
- [ ] Confirm the support email `feedback@jayopsai.com` is monitored

## Device / build validation

- [ ] Run one real feedback submission test and verify the message arrives through Formspree
  Note: the Formspree endpoint itself has already returned success from a VPS verification request; inbox receipt is the remaining proof step.
- [ ] Do one more preview/TestFlight validation pass after the current fixes
- [ ] Verify icon rendering on device looks full-bleed and not washed out
- [ ] Re-check privacy, terms, settings, favorites, and audio playback on device

## TestFlight handoff

- [x] Confirm the App Store Connect app record exists for `com.jojobuilds.viettravelphrases`
- [x] Add the App Store Connect `ascAppId` to `app/eas.json` submit profile
- [x] Submit EAS store build `0db6c21a-703a-433b-a10f-626ef4fc9507` to App Store Connect / TestFlight
- [x] Wait for Apple processing to finish in TestFlight
- [x] Add internal tester access and verify the app appears in TestFlight on iPhone

## Submission gate

Do not submit until every unchecked item above is either complete or deliberately waived with a written reason.

Submission status:
- Submitted to Apple App Review on 2026-04-09
- Current status: `Waiting for Review`
