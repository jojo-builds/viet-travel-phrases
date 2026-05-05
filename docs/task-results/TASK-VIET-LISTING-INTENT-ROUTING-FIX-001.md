# TASK-VIET-LISTING-INTENT-ROUTING-FIX-001

## Summary

Fixed the intent-routing issues found in the latest listing review:

- `Tôi không hiểu` no longer repeats the hero definition as the page context. It keeps one playable primary row and uses a short recovery-context sentence.
- `Bàn này còn trống` is now treated as something a traveler may hear, not a primary "say this" phrase.
- `Bàn` is corrected to `table`; `Bạn` remains `you`; `còn trống` stays together as `still available / open`.
- The table-availability page now routes to seating/menu/payment replies instead of pork, peanuts, spicy food, doctor, or hotel-room rows.
- `All Vietnam` now uses a country hub model instead of a generic phrase feed starting with restaurant/place child pages.
- Validators now understand likely-reply pages as a distinct role, so they are not forced to render `Quick say` / `standard-way`.

The durable listing-page skill was also updated outside the repo at:

- `/Users/jojolim/.codex/skills/speaklocal-listing-pages/SKILL.md`

## Page Excerpts

### Tôi không hiểu

- `Meaning`: `A simple recovery phrase for when Vietnamese is too fast or unclear.`
- `Say this`: `Tôi không hiểu` / `I don’t understand`
- `Common follow-ups`: slow down, say again, write it down

### Bàn này còn trống

- `You may hear`: `Staff may use this when a table is open.`
- `Break it down`: `Bàn = table`, `này = this`, `còn trống = still available / open`
- `Say next`: table for two, wait for a table, see the menu, bill/payment

### All Vietnam

- Hero: `All Vietnam`
- Subtitle: `Everyday phrases for cities, food, transport, hotels, and help.`
- `Start here`: first day, airport arrival, taxi/Grab, food & drink, hotel, help
- `City guides`: Hanoi, Ho Chi Minh City, Da Nang, Hoi An, Hue
- `Essential phrases`: hello, thank you, I don’t understand, English help, bathroom

## Validation

Passed:

- `node native-ios/scripts/validate-viet-listing-intent-routing.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -only-testing:SpeakLocalNativeTests/AppChromeTests/testDaNangCityDescriptorUsesTravelModeHubInsteadOfPhraseFeed -only-testing:SpeakLocalNativeTests/AppChromeTests/testAllVietnamDescriptorUsesCountryHubInsteadOfPhraseFeed`
- `git diff --check`

Runtime counts:

- Canonical pages: `3,070`
- Source phrases: `3,078`
- Incomplete article contracts: `0`
- Missing audio rows: `2,126 planned`
- Release-blocking missing audio rows: `0`

## Test On Device

Search and inspect:

- `Tôi không hiểu`
- `Bàn này còn trống`
- `All Vietnam`
- `Da Nang`

Expected behavior:

- `Tôi không hiểu` should feel like a recovery phrase, not a repeated definition page.
- `Bàn này còn trống` should feel like a "you may hear this" page with seating replies.
- `All Vietnam` should start as a country hub, not a restaurant/beach phrase feed.
- `Da Nang` should still behave as a city travel-mode hub.
