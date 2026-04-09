# TestFlight Handoff - 2026-04-09

This note captures the current reality for getting the latest iOS build into TestFlight.

## What exists already

- Internal preview iOS build finished from EAS:
  - `6467e106-a6d6-4973-9de7-b8e381f0aec6`
- Store-signed iOS build finished from EAS:
  - `0db6c21a-703a-433b-a10f-626ef4fc9507`
- App Store Connect app record exists:
  - Apple app ID `6761904350`
- `app/eas.json` includes:
  - `ascAppId: 6761904350`
- Interactive EAS submit completed successfully
- Local validation still passes in `app/`:
  - `npx tsc --noEmit`
  - `npx expo-doctor`
- App Privacy is published in App Store Connect
- TestFlight build `1.0.0 (2)` is installed on iPhone
- VPS verification of the Formspree endpoint succeeded:
  - response: `{"next":"/thanks","ok":true}`

## What happened

- The first non-interactive submit attempt failed because `ascAppId` was missing from `app/eas.json`
- The App Store Connect app was created in Apple:
  - `https://appstoreconnect.apple.com/apps/6761904350/distribution/ios/version/inflight`
- `app/eas.json` was updated with:
  - `ascAppId: "6761904350"`
- Interactive submit then succeeded for build:
  - `0db6c21a-703a-433b-a10f-626ef4fc9507`
- Apple upload confirmation:
  - the binary was successfully uploaded to App Store Connect
  - Apple finished processing the build for TestFlight
  - the build is available in TestFlight and installed on iPhone

## After submit succeeds

1. Run the device checklist in `reviews/IOS-TESTING-INSTRUCTIONS-2026-04-08.md`
2. Verify the feedback submission path end-to-end, including inbox receipt
3. Confirm screenshots and remaining App Store metadata

## Meanwhile

Use the internal preview build for immediate on-device validation while TestFlight distribution is being completed.
