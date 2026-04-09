# iPhone Testing Instructions - 2026-04-08

Use this for the next iOS testing round.

## Two possible install paths

### Path A - Internal preview build

This is an Expo internal distribution build, not TestFlight.

Use this when:
- an internal preview build has completed
- you have the install link from Expo

On iPhone:
1. Open the Expo build link on the phone.
2. If iOS asks, allow the profile or app install flow.
3. On iOS 16+, enable Developer Mode if prompted.
4. Finish installation and open the app.

Important:
- Expo documents that internal distribution builds on iOS 16+ require Developer Mode.
- Source: [Expo iOS Developer Mode](https://docs.expo.dev/guides/ios-developer-mode/)

### Path B - TestFlight

Use this when:
- a store-signed iOS build has been uploaded to App Store Connect / TestFlight
- your Apple ID has access as an internal or external tester

Current status as of 2026-04-09:
- Store build exists in EAS:
  - `0db6c21a-703a-433b-a10f-626ef4fc9507`
- Internal preview build exists in EAS:
  - `6467e106-a6d6-4973-9de7-b8e381f0aec6`
- If TestFlight shows no app yet, the likely blocker is that the store build has not been fully submitted into App Store Connect / TestFlight yet

On iPhone:
1. Install the TestFlight app from the App Store.
2. Accept the invite or open the test link.
3. In TestFlight, tap Install for the latest build.
4. Open the app and test the checklist below.

Apple references:
- [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview)
- [Add internal testers](https://developer.apple.com/help/app-store-connect/test-a-beta-version/add-internal-testers)

## What to test on the phone

### Core app behavior
- Home screen loads correctly
- All 10 scenarios open
- Phrase cards render correctly
- Audio playback works for multiple phrases
- Favorites save and remain after reopening the app
- Saved tab shows favorited phrases correctly

### Settings and legal
- Settings screen opens
- About dialog shows the correct name
- Privacy Policy opens and reads correctly
- Terms of Use opens and reads correctly
- Send Feedback modal opens

### Feedback path
- Type a short test message
- Tap Send
- Confirm the success state appears
- Confirm the support inbox / Formspree receives the message

### Submission-specific checks
- App icon looks full-bleed and not washed out
- No obvious placeholder text remains
- No broken links in legal screens
- No crash on first launch

## If using TestFlight

After the build appears in TestFlight:
- install it from the TestFlight app
- test the items above
- write down anything that feels misleading, unfinished, or unstable before App Store submission

If TestFlight is still empty:
- that does not mean the EAS store build failed
- it usually means the App Store Connect upload / tester access step is still missing
- use the internal preview build in the meantime so device testing can continue
