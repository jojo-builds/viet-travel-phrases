# App Store Marketing Packet Report

Date: 2026-07-05
Worker scope: marketing packet only
Write scope: `marketing/` and `docs/task-results/parallel-goals-2026-07-05/`
Native app code edited: no

## Files Produced

- `marketing/app-store/speaklocal-vietnam-launch-packet-2026-07-05.md`
- `marketing/campaigns/speaklocal-vietnam-7-day-launch-plan-2026-07-05.md`
- `docs/task-results/parallel-goals-2026-07-05/app-store-marketing-packet-report.md`

## Product Truth Used

- `marketing/AGENTS.md`
- `marketing/README.md`
- `marketing/strategy/audience-positioning.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/VIET_PREMIUM_EXPANSION_PLAN.md`
- `docs/operations/APP_STATUS.md`
- `docs/operations/CURRENT_BLOCKERS.md`
- `docs/operations/LATEST_VALIDATION.md`
- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- `docs/design/homepage/HOMEPAGE_SHELVES.md`
- native launch-argument evidence in `native-ios/App/Views/AppShellView.swift` and UI tests

## Apple Sources Checked

- Apple product page guidance: https://developer.apple.com/app-store/product-page/
- Apple screenshot/upload guidance: https://developer.apple.com/help/app-store-connect/manage-app-information/upload-app-previews-and-screenshots/
- Apple screenshot specifications: https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications

## Claim Checks

Safe to use:

- Native iOS app for SpeakLocal Vietnam.
- Vietnam-focused travel companion for food, places, useful phrases, search, Browse, Saved, Practice, and playable bundled audio.
- Current native non-paywall app has fresh validation and physical iPhone proof in operations docs.
- Current live Viet content boundary from product docs: 19 runtime scenarios, 177 starter visible intent families, 1605 premium visible intent families, 1782 visible clusters, 1800 source phrase rows, 1793 canonical phrase pages, 11728 relation rows, and 4318 bundled audio assets.

Use with qualifiers:

- `Playable audio` should be phrased as supported/bundled audio, not every possible line.
- `Offline` should refer to bundled resources/content unless a final release audit approves a broader offline claim.
- `Practice` should stay trip-prep oriented, not course or fluency oriented.

## Claims Intentionally Avoided

- Arbitrary AI translation.
- Live translator replacement.
- Google Translate or Apple Translate comparison claims beyond internal positioning.
- Learn Vietnamese fast.
- Become fluent.
- Perfect pronunciation.
- Same-speaker audio uniformity.
- Medical, legal, safety, or emergency reliability.
- Complete Vietnam coverage.
- Permanent free tier.
- Paywall/subscription live in `main`.

## Paywall-Dependent Copy Notes

Paywall copy is included only as `PAYWALL DEPENDENT / DO NOT PUBLISH UNTIL STOREKIT PROOF`.

Required proof before publishing paywall claims:

- App Store Connect product state confirmed.
- Purchase succeeds on physical iOS hardware.
- Restore succeeds.
- Entitlement persists after relaunch.
- Locked/unlocked premium gating matches product policy.
- Support, terms, privacy, and restore copy are visible and tappable.

Repo pricing direction used internally:

- 7-day free trial.
- Then `$4.99/month`.
- Product ID: `app.speaklocal.vietnam.subscription.monthly`.

App Store description copy avoids hardcoding price because Apple recommends not placing specific prices in the description.

## Next Assets / Screenshots Needed

- 6.9-inch iPhone screenshot set from current native `main`.
- Optional 6.5-inch fallback if Media Manager scaling is not acceptable.
- Home first-launch screenshot.
- Food/menu detail screenshot, preferably `viet-menu-food-pho-bo` or `viet-menu-drink-ca-phe-sua-da`.
- Search screenshot for `hotel` or `Cà phê sữa đá`.
- City/place screenshot such as Dragon Bridge, Ben Thanh Market, or Bà Nà Hills.
- Saved/Practice seeded-state screenshot.
- Native Practice screenshot.
- Paywall screenshot only after StoreKit proof.
- Support URL, Privacy URL, and Terms URL confirmation.
- Optional 30-second app preview plan after screenshots are accepted.

## Validation

- `git diff --check` passed.
- App Store name/subtitle/promotional text/keyword candidates were length-checked against the packet's Apple constraints.
- Risky-claim scan found blocked terms only in guardrail, objection, or intentionally-avoided sections.

## Notes

- The repo had substantial preexisting dirty/untracked app, content, resource, and operations changes before this packet. This task only adds the requested marketing/report files and does not modify app code.
- The packet is executable but not final-submission complete until screenshots and paywall proof are supplied.
