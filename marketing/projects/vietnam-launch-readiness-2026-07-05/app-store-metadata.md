# App Store Metadata Draft

Date: 2026-07-05
Status: draft ready for Jojo review
Primary locale assumed: English (U.S.)
Product truth: native iOS `main`, SpeakLocal Vietnam config, operations docs

## Spec Boundaries

Checked against Apple App Store Connect docs on 2026-07-05:

- App name: 2 to 30 characters.
- Subtitle: up to 30 characters.
- Promotional text: up to 170 characters.
- Description: up to 4000 characters, plain text.
- Keywords: up to 100 bytes, no competitor names, avoid duplicating app/company names.

## Recommended Metadata

Audience segment: English-speaking travelers planning or seriously considering Vietnam.
User problem or travel moment: Vietnam feels exciting but abstract; food names, places, and useful phrases are hard to choose before arrival.
Hook: `Food, places, phrases`
Channel: App Store product page
Offer or CTA: Download before Vietnam; subscription/trial CTA only after StoreKit proof.
Required app evidence: fresh native screenshots, current metadata entry, support/privacy/terms URLs.
Claim risk or feature dependency: `NEEDS_SCREENSHOT`, `NEEDS_APP_STORE_CONNECT`, `NEEDS_STOREKIT_PROOF` for trial/subscription text.
Success metric: App Store product page conversion rate, keyword impressions, first-open to first search/save/practice.
Next action: Jojo chooses final app name/subtitle, then screenshot capture begins.

### Name

Recommended: `SpeakLocal Vietnam`

Character count: 18

Rationale: It is the cleanest brand-country format and matches `native-ios/Config/apps/vietnam.json` display name.

Alternates:

| Name | Count | Use When |
| --- | ---: | --- |
| `SpeakLocal: Vietnam` | 19 | If App Store naming wants clearer brand/category separation. |
| `Vietnam Travel Phrases` | 22 | If Jojo keeps the current live-app phrasebook naming for continuity. |
| `SpeakLocal Viet Phrases` | 23 | If ASO needs stronger phrasebook signal and brand remains required. |

Status: `NEEDS_JOJO_DECISION`

### Subtitle

Recommended: `Food, places, phrases`

Character count: 21

Alternates:

| Subtitle | Count | Notes |
| --- | ---: | --- |
| `Hear useful trip phrases` | 24 | Stronger audio cue. |
| `Vietnam trip phrases` | 21 | More keyword-forward. |
| `Eat, explore, speak` | 19 | More emotional, less searchable. |
| `Audio phrases for travel` | 24 | Clear utility fallback. |

Status: `NEEDS_JOJO_DECISION`

### Keywords

Recommended keyword field:

`vietnam,travel,phrasebook,vietnamese,phrases,food,menu,audio,trip,coffee,hanoi,danang,saigon`

Character count: 93 ASCII characters.

Backup:

`vietnam,travel,vietnamese,phrases,phrasebook,audio,food,menu,coffee,hotel,taxi,hanoi,saigon`

Character count: 97 ASCII characters.

Avoid: `translator`, `translate anything`, `AI`, `fluent`, `duolingo`, `google`, competitor names, emergency/legal/medical terms.

Status: ready for App Store Connect, pending `NEEDS_JOJO_DECISION`.

### Promotional Text

Recommended:

Plan Vietnam with food, places, useful phrases, and playable Vietnamese audio - ready before you land and useful during the trip.

Character count: 130.

Alternates:

- Hear the Vietnam phrases you will actually use, then save the food, places, and trip moments you want in your pocket.
- A Vietnam travel companion for food, places, culture, useful phrases, and audio you can play before the trip.
- Search the trip moment, hear the phrase, and save what you want before Vietnam.

Status: ready, `NEEDS_SCREENSHOT` before final publish confidence.

## Description

SpeakLocal Vietnam helps you feel more oriented before you land, with food, places, useful phrases, and playable Vietnamese audio built around real trip moments.

Use it while planning, on the plane, or during the trip when you want a phrase, a menu clue, a city idea, or a better sense of what Vietnam will feel like.

What you can do:

- Browse useful Vietnam travel phrases by situation
- Hear bundled Vietnamese audio on supported phrase and detail pages
- Search for hotel, taxi, food, coffee, payment, pharmacy, and everyday trip needs
- Explore food, coffee, drinks, menu items, cities, markets, landmarks, and things to do
- Open phrase and place pages with pronunciation help, usage notes, related next steps, and cultural context
- Save the phrases and pages you want for your trip
- Practice selected trip phrases through native Practice flows
- Use beginner-friendly support surfaces for arrival, transport, hotel, food, payment, health, and help moments

SpeakLocal is not a live translator and not a classroom course. It is a prepared Vietnam companion: the phrases, sounds, food names, places, and small travel decisions that make the country easier to picture and easier to enjoy.

## Subscription Copy

Status: `NEEDS_STOREKIT_PROOF`, `NEEDS_APP_STORE_CONNECT`, `FUTURE / DO NOT PUBLISH` until Jojo approves paywall readiness.

Do not publish subscription/trial language until:

- App Store Connect subscription metadata is confirmed.
- StoreKit purchase succeeds on physical iOS hardware.
- Restore succeeds.
- Entitlement persists after relaunch.
- Starter/premium gating matches product policy.
- Terms, privacy, support, and restore copy are visible.

Draft only:

Try the full Vietnam companion before the trip. Start with the 7-day free trial, then continue monthly if it earns a place in your travel pocket.

## Release Notes Draft

Status: draft, `NEEDS_APP_STORE_CONNECT` and final build truth.

SpeakLocal Vietnam is now focused on a native iPhone experience for Vietnam travelers: curated trip phrases, food and menu discovery, city and place pages, saved items, Practice, search, Browse, and playable Vietnamese audio for supported content.

Use it before you land to explore Vietnam, hear useful phrases, save what matters, and feel more ready for the trip.

## App Review And Submission Fields

- Support URL: `NEEDS_SOURCE`
- Privacy Policy URL: `NEEDS_SOURCE`
- Terms URL: `NEEDS_SOURCE`
- Primary category: `NEEDS_JOJO_DECISION`, likely Travel or Education depending App Store strategy.
- Secondary category: `NEEDS_JOJO_DECISION`
- Age rating: `NEEDS_APP_STORE_CONNECT`
- App privacy labels: `NEEDS_APP_STORE_CONNECT`
- Export compliance: `NEEDS_APP_STORE_CONNECT`
- App icon final: `NEEDS_SOURCE`
- In-app purchase review screenshot: `NEEDS_STOREKIT_PROOF`
