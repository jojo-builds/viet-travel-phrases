# SpeakLocal Vietnam Paywall Offer And Positioning Audit

Date: 2026-07-07
Branch implementation target: `feature/paywall`
Recommended launch offer: 7-day free trial, then $4.99/month

## Recommendation

Ship the `Trip Companion Gate` narrative:

> Try the full Vietnam companion free for 7 days. Then keep food, coffee, city and place guides, phrase pages, supported playable audio, Search, Saved, and Practice for one Vietnam trip.

Why this is the best current lane:

- It matches Jojo's current product direction: paywall day one, working decision of 7-day free trial then $4.99/month.
- It grounds the offer in current native app truth: curated food/menu and place content, phrase pages, playable supported audio, Search, Saved, and Practice.
- It avoids the dangerous category trap: SpeakLocal is not positioned as a generic translator, AI chat box, or school language course.
- It lets StoreKit/App Store own exact eligibility, local price, billing date, and cancellation confirmation before purchase.

## Implemented Native Narrative

Current paywall headline:

- `Try the full Vietnam companion free for 7 days`

Current value line:

- `Food, coffee, city and place guides, phrase pages, supported playable audio, Search, Saved, and Practice for one Vietnam trip.`

Current proof/value rows:

- `Preview real trip moments`
- `Trip-first food and place guidance`
- `Phrase pages with playable audio`
- `Search, Browse, Saved, and Practice`

Current preview examples:

- `Coffee order` / `Cho toi ca phe sua da`
- `Hoi An place help` / `Pho co Hoi An o dau?`
- `When you get stuck` / `Noi cham giup toi duoc khong?`

Current disclosure:

- `Try 7 days free, then $4.99/month in the U.S. The App Store confirms eligibility, local pricing, renewal date, and cancellation before purchase.`

## Fallback Variants

Variant B: Planning-first

- Headline: `Plan Vietnam with the phrases, food, and places you will actually use`
- CTA framing: `Try 7 days free`
- Best if Jojo wants less hard revenue language and more pre-trip emotional pull.
- Risk: softer urgency than the recommended launch gate.

Variant C: Utility-first

- Headline: `Unlock the Vietnam phrasebook built for real trip moments`
- CTA framing: `Start trial`
- Best if screenshots show users respond more to direct utility than destination-companion language.
- Risk: can drift toward generic phrasebook positioning unless supported by food/place/audio visuals.

## Claim Ledger

Safe for branch/internal working copy now:

- Curated Vietnam travel companion.
- Food, coffee, city/place, phrase-page, Search, Saved, Practice, and supported playable-audio value.
- 7-day free trial then $4.99/month as the working U.S. configured offer, with App Store confirmation language.

Use with care:

- `offline` should only be used when the claim is about bundled phrase/content runtime, not purchase validation or account state.
- `playable audio` should stay scoped to supported/bundled phrases, not every phrase.
- `full access` is acceptable for the current whole-app gate, but the report must keep external purchase proof separate.
- Public launch copy must wait for App Store Connect product status, sandbox/TestFlight purchase proof, and Jojo's final approval.

Do not publish:

- Generic AI translator.
- Translate anything.
- Learn Vietnamese fast.
- Every phrase has audio.
- Real App Store purchase proof exists.

## Evidence And Sources

Repo evidence:

- `docs/DECISIONS.md` names the pricing direction and subscription framing.
- `docs/V2_BASELINE.md` and `docs/V2_CONTENT_MODEL.md` describe current native content and app-value truth.
- `docs/operations/CURRENT_BLOCKERS.md` keeps App Store/TestFlight proof as a remaining paywall blocker.
- Visual proof: `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07/assets/paywall-trip-companion-forced-2026-07-07.png`
- Scrolled proof with preview examples: `/Users/jojolim/Developer/products/speaklocal/app-family/marketing/projects/paywall-production-2026-07-07/assets/paywall-trip-companion-scrolled-2026-07-07.png`

External sources refreshed on 2026-07-07:

- Apple: https://developer.apple.com/help/app-store-connect/manage-subscriptions/set-up-introductory-offers-for-auto-renewable-subscriptions/
- Apple: https://developer.apple.com/help/app-store-connect/manage-subscriptions/offer-auto-renewable-subscriptions/
- Apple: https://developer.apple.com/help/app-store-connect/test-a-beta-version/testing-subscriptions-and-in-app-purchases-in-testflight/
- RevenueCat 2026 subscription report: https://www.revenuecat.com/state-of-subscription-apps/

Pricing concern:

- $4.99/month is defensible for a new focused travel utility, but long-term price packaging should be revisited after conversion, cancellation, review, and refund signals exist. A later annual or trip-pass offer may become clearer after TestFlight and first-user evidence.
