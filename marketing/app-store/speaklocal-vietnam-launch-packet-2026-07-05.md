# SpeakLocal Vietnam Launch Packet

Date: 2026-07-05
Status: launch-ready draft, pending final App Store screenshots and StoreKit proof
Audience: English-speaking travelers planning or seriously considering Vietnam
Product truth checked against: native iOS `main`, repo docs, current operations evidence

## Product Guardrails

- Position SpeakLocal Vietnam as a native iOS Vietnam travel companion for food, places, useful phrases, search, browse, saved items, Practice, and playable bundled audio.
- Do not position it as Google Translate, Apple Translate, an arbitrary AI translator, a full Vietnamese course, or a fluency product.
- Non-paywall app proof is current: full native UI sweep, audio coverage proof, and physical iPhone build/install/launch proof are recorded in operations docs.
- Paywall / StoreKit proof remains excluded from `main`; any trial/subscription wording below is marked `PAYWALL DEPENDENT`.
- Avoid customer-facing claims of perfect pronunciation, same-speaker audio uniformity, emergency reliability, legal/medical authority, or complete language coverage.

## Apple Product Page Constraints

- App name: up to 30 characters.
- Subtitle: up to 30 characters.
- Promotional text: up to 170 characters, editable without a new app version.
- Keywords: 100 characters total, comma-separated, no spaces after commas.
- Screenshots: 1 to 10 images, JPEG/JPG/PNG.
- App previews: optional, up to 3 per device size/language, up to 30 seconds.
- 6.9-inch screenshots: accepted portrait sizes include 1260 x 2736, 1290 x 2796, and 1320 x 2868.
- 6.5-inch screenshots: accepted portrait sizes include 1284 x 2778 and 1242 x 2688; required only if 6.9-inch screenshots are not provided.

Sources:
- Apple product page guidance: https://developer.apple.com/app-store/product-page/
- Apple screenshot/upload guidance: https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots/
- Apple screenshot specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications

## App Store Metadata Options

### Name Variants

Recommended:

| Variant | Characters | Notes |
| --- | ---: | --- |
| SpeakLocal Vietnam | 18 | Best brand fit; matches repo naming direction. |
| SpeakLocal: Vietnam | 19 | Slightly more App Store keyword-like; still clean. |
| Vietnam SpeakLocal | 18 | Search-forward, but weaker brand rhythm. |
| Vietnam Travel Phrases | 22 | Functional fallback if brand name cannot change yet. |
| SpeakLocal Viet Phrases | 23 | Stronger phrase keyword, less elegant. |

Primary recommendation: `SpeakLocal Vietnam`.

### Subtitle Variants

Recommended:

| Variant | Characters | Notes |
| --- | ---: | --- |
| Food, places, phrases | 21 | Best product wedge in one line. |
| Hear useful trip phrases | 24 | Strong audio and trip-use signal. |
| Vietnam trip phrases | 21 | Search-friendly and simple. |
| Eat, explore, speak | 19 | More emotional; less searchable. |
| Audio phrases for travel | 24 | Clear functional fallback. |

Primary recommendation: `Food, places, phrases`.

### Keyword Bank

Use one 100-character string per locale. Do not include competitor names or irrelevant travel terms.

Recommended keyword field:

`vietnam,travel,phrasebook,vietnamese,phrases,food,menu,audio,trip,coffee,hanoi,danang,saigon`

Character count: 93.

Alternates:

- `vietnam,travel,vietnamese,phrases,phrasebook,audio,food,menu,coffee,hotel,taxi,hanoi,saigon`
  - Character count: 97.
- `vietnam,trip,vietnamese,phrasebook,phrases,audio,food,menu,places,hotel,taxi,coffee,danang`
  - Character count: 97.

Terms intentionally avoided: `translate`, `translator`, `AI`, `duolingo`, `google`, `fluent`, `emergency`, competitor names, and broad category filler such as `app`.

### Promotional Text

Recommended:

> Plan Vietnam with food, places, useful phrases, and playable Vietnamese audio - ready before you land and useful during the trip.

Character count: 130.

Alternates:

> Hear the Vietnam phrases you will actually use, then save the food, places, and trip moments you want in your pocket.

Character count: 117.

> A Vietnam travel companion for food, places, culture, useful phrases, and audio you can play before the trip.

Character count: 111.

### Short Description

Recommended:

SpeakLocal Vietnam helps you plan a richer Vietnam trip with useful phrases, food and place discovery, saved trip moments, Practice, and playable Vietnamese audio.

Alternates:

- A native Vietnam travel companion for the food, places, phrases, and audio you want before and during the trip.
- Find what to eat, where to go, and what to say in Vietnam, with traveler-friendly phrases and playable Vietnamese audio.

### Long Description

Recommended App Store description:

SpeakLocal Vietnam helps you feel more oriented before you land, with food, places, useful phrases, and playable Vietnamese audio built around real trip moments.

Use it while planning, on the plane, or during the trip when you want a phrase, a menu clue, a city idea, or a better sense of what Vietnam will feel like.

What you can do:

- Browse useful Vietnam travel phrases by situation
- Hear bundled Vietnamese audio for supported phrase rows
- Search for hotel, taxi, food, coffee, payment, pharmacy, and everyday trip needs
- Explore food, coffee, drinks, menu items, cities, markets, landmarks, and things to do
- Open phrase pages with pronunciation, usage notes, variants, related next steps, and cultural context
- Save phrases and pages you want for your trip
- Practice selected trip phrases through native Practice flows
- Use beginner-friendly support surfaces for arrival, transport, hotel, food, payment, health, and help moments

SpeakLocal is not a live translator or a classroom course. It is a prepared Vietnam companion: the phrases, sounds, food names, places, and small travel decisions that make the country easier to picture and easier to enjoy.

PAYWALL DEPENDENT / DO NOT PUBLISH UNTIL STOREKIT PROOF:
Some deeper Vietnam content may require the planned Apple-native subscription. The intended offer is a 7-day free trial, then monthly access, but final App Store copy should use Apple's product page pricing display instead of hardcoding price in the description.

## Screenshot Plan

Target: 6.9-inch iPhone first. Use 6.5-inch fallback only if Media Manager needs device-specific uploads or if 6.9-inch crops make text feel too large/small after review.

Narrative rule: first three screenshots must carry the essence because Apple notes the first one to three may appear in search when no app preview is present.

| # | Caption | App screen to capture | Route/state | Required evidence | Claim risk |
| ---: | --- | --- | --- | --- | --- |
| 1 | Plan Vietnam with phrases you can hear | Native Home first launch with Essentials and destination feed visible | Launch `--home --reset-demo-state` | Current native app Home, bottom chrome, audio-ready cards | `NEEDS_SCREENSHOT` |
| 2 | Know what to eat and how to ask | Food/menu detail such as `viet-menu-food-pho-bo` or drink `viet-menu-drink-ca-phe-sua-da` | Launch `--detail-page viet-menu-food-pho-bo` | Menu/detail surface, food guidance, playable audio where present | `NEEDS_SCREENSHOT`; avoid implying every dish has same depth |
| 3 | Search the trip moment, not a grammar book | Search results for `hotel` or `Cà phê sữa đá` | Launch `--search-query hotel` or `--search-query "Cà phê sữa đá"` | Search page, results, audio affordances, Browse matches | `NEEDS_SCREENSHOT` |
| 4 | Explore cities, markets, and places | City/place page such as Dragon Bridge, Ben Thanh Market, or Bà Nà Hills | Launch `--detail-page viet-phrase-city-danang-place-dragon-bridge` | City V2.2 page with image/header, save, Useful Phrases | `NEEDS_SCREENSHOT`; avoid location completeness claims |
| 5 | Save what matters for your trip | Saved/Practice surface with seeded returning-user state | Launch `--saved --reset-demo-state --seed-returning-user-shelves` | Saved state is app-supported and validated | `NEEDS_SCREENSHOT`; do not imply cloud sync |
| 6 | Practice before you land | Native Practice round or scenario | Launch `--practice --reset-demo-state`, optionally `--practice-scenario danangFirstDay` | Practice native sheet and trip phrase round | `NEEDS_SCREENSHOT`; avoid course/fluency promises |
| 7 | Useful support stays easy to find | Health/pharmacy or help phrase page with calm framing | Launch a supported help/detail page from current catalog | Serious support reachable, no crisis-leading copy | `NEEDS_SCREENSHOT`; no emergency reliability claim |
| 8 | Keep the full Vietnam companion with you | PAYWALL DEPENDENT: native paywall / premium plan screen | Feature branch or approved `main` only after StoreKit proof | StoreKit purchase/restore/relaunch/gating proof | `FUTURE / DO NOT PUBLISH` until paywall merge and proof |

6.5-inch fallback sequence:

- Use the same sequence and captions.
- Prefer screenshots 1 through 6 if only six slots are produced.
- If the 6.9-inch set is accepted and the UI scales cleanly, skip custom 6.5-inch uploads and let App Store Connect scaling handle smaller sizes.

Caption style:

- Keep overlays short, high contrast, and specific to visible UI.
- Do not write feature claims that are not visible in the screenshot.
- Do not place caption text over Vietnamese phrase text, audio buttons, bottom chrome, or search controls.

## Paywall Value Proposition

Status: `PAYWALL DEPENDENT / DO NOT PUBLISH UNTIL STOREKIT PROOF`.

Current repo pricing direction:

- 7-day free trial
- then `$4.99/month`
- product ID: `app.speaklocal.vietnam.subscription.monthly`

Proof required before publish:

- App Store Connect product state confirmed
- purchase succeeds on physical iOS hardware
- restore succeeds
- entitlement persists after relaunch
- locked/unlocked premium gating matches product policy
- support/legal/restore copy visible and tappable

Headline options:

- Keep the full Vietnam companion with you
- Unlock the richer Vietnam trip guide
- Save, hear, and practice more of Vietnam
- Try the full Vietnam companion first
- Go deeper on food, places, and phrases

Benefits:

- Full food, drink, menu, city, place, and phrase depth for Vietnam
- Playable audio where the app has bundled recordings
- Search and browse paths for real trip moments
- Saved phrases and Practice loops for the trip
- Calm support for hotel, transport, payment, pharmacy, and help situations

Trial language:

- Start with a 7-day free trial. Continue monthly if it earns a place in your trip.
- Try the full Vietnam companion before the trip. Cancel anytime in App Store subscriptions.
- Seven days to explore the phrases, food, places, and audio you want for Vietnam.

Restore/support/legal copy notes:

- Required visible action: `Restore Purchases`.
- Required support note: link to app support URL once confirmed.
- Required legal note: include Terms and Privacy links.
- Avoid hardcoding price in App Store description; use price on paywall and App Store commerce surfaces after App Store Connect proof.
- Do not imply permanent access, family sharing, account sync, web unlock, or cross-device entitlement sync unless implemented and validated.

## Claim Ledger

Safe claims:

- Native iOS app for SpeakLocal Vietnam.
- Food, places, useful phrases, search, Browse, Saved, Practice, and playable bundled audio are current app truths.
- Current live Viet pack has 19 runtime scenarios, 177 starter visible intent families, 1605 premium visible intent families, 1782 visible clusters, 1800 source phrase rows, 1793 canonical phrase pages, 11728 relation rows, and 4318 bundled audio assets in the cited product docs.
- Non-paywall native app has fresh simulator and physical iPhone proof in operations docs.

Use carefully:

- `offline` can describe bundled content/audio, but do not imply every possible function works with no network unless the release build has been reviewed for that exact claim.
- `audio-backed` is safe for supported/bundled audio rows, not as a blanket guarantee on every line unless the final build proof says so.
- `Practice` is safe as a native app surface, but avoid course-like claims.

Avoid:

- Learn Vietnamese fast.
- Become fluent.
- Translate anything instantly.
- AI translator.
- Perfect pronunciation.
- Same-speaker audio.
- Emergency/legal/medical reliability.
- Complete Vietnam coverage.
- Permanent free tier.
- Paywall is live, unless StoreKit proof is complete.

## Next Assets Needed

- Fresh 6.9-inch App Store screenshot captures from current native `main`.
- Optional 6.5-inch fallback captures if Media Manager does not scale the 6.9-inch set cleanly.
- Final App Store icon and any alternate icon test plan.
- Paywall screenshots only after StoreKit proof.
- Support URL, Privacy URL, and Terms URL confirmation for final App Store submission.
- Optional 30-second app preview after screenshots are approved.
