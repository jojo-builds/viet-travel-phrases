# Release Submission Gap Report

Date: 2026-07-05
Repo: `/Users/jojolim/Developer/products/speaklocal/app-family`
Branch inspected: `main`
Current HEAD during this pass: `abd3f3a6e`
Scope: non-invasive release submission gap pass for SpeakLocal Vietnam

## Summary

Current `main` has enough local material to assemble a non-paywall App Store submission draft, but it is not submission-complete without Jojo/App Store Connect decisions.

Ready or mostly ready locally:

- App Store metadata draft exists.
- Seven raw 6.9-inch portrait screenshot candidates exist at `1320x2868`.
- Local support/privacy/terms/about/feedback source files exist.
- App icon asset exists at `1024x1024`.
- Non-paywall launch pack, screenshot receipt, audio audit, and focused QA receipts exist.

Still open:

- Jojo must choose final public name/subtitle/category and whether this release is non-paywall first or paywall-first.
- App Store Connect-only fields remain unfilled here: privacy labels, age rating, export compliance, build selection, screenshot slot assignment, pricing/availability, and app review submission.
- Physical-phone launch proof for exact-current `main` is still blocked by locked-phone launch, although current `main` built and installed on the phone and launched on simulator.
- Paywall/subscription submission metadata is conditional. If paywall ships in this release, `feature/paywall` still needs App Store Connect product-state confirmation plus real purchase/restore/relaunch proof before merge/submission.

No App Store Connect login was attempted.

## Gap Checklist

| Submission Area | Local State | Gap / Next Action |
| --- | --- | --- |
| Screenshots | `app-store-screenshot-proof/` has seven raw Pro Max PNGs plus contact sheet. Each candidate screenshot is `1320x2868`. Capture report says current `main` screenshot run passed on `iPhone 17 Pro Max` simulator. | Choose final screenshot order, decide whether to upload raw app screenshots or create framed/captioned final assets, and upload in App Store Connect. Contact sheet is review-only, not an upload asset. |
| Title / app name | `app-store-metadata.md` recommends `SpeakLocal Vietnam`; `native-ios/Config/apps/vietnam.json` display name is `SpeakLocal Vietnam`; operations docs still note live App Store app as `Viet Travel Phrasebook`. | Jojo decision needed: keep current live listing name for continuity or move to `SpeakLocal Vietnam`. |
| Subtitle | Draft recommendation: `Food, places, phrases`. | Jojo decision needed before App Store Connect entry. |
| Keywords | Draft 93-character field exists: `vietnam,travel,phrasebook,vietnamese,phrases,food,menu,audio,trip,coffee,hanoi,danang,saigon`. | Ready for review, then ASC entry. Do not add competitor names or unproven translator/AI positioning. |
| Description / promotional text | Draft description, promotional text, and release notes exist in `marketing/projects/vietnam-launch-readiness-2026-07-05/app-store-metadata.md`. | Final copy review needed against chosen screenshot set and release payload. Keep subscription/trial paragraph unpublished unless paywall proof clears. |
| Version notes | Draft release notes exist. | Update only after final build/payload decision, especially if paywall is excluded. |
| Support URL | Local support/feedback source exists at `site/feedback.html` and `site/feedback/index.html`; website docs say `https://speaklocal.app/` is the live domain. | Candidate support URL is `https://speaklocal.app/feedback/`, but final public URL choice/availability should be confirmed before ASC submission. |
| Privacy URL | Local source exists at `site/privacy.html` with canonical `https://speaklocal.app/privacy/`. | Use after final public URL confirmation. |
| Terms URL | Local source exists at `site/terms.html` with site footer linkage. | Use after final public URL confirmation. |
| Review notes | No final App Review note packet found. | Prepare a concise note for reviewers: native iOS app, no account required for non-paywall browsing, bundled content/audio, paywall excluded if shipping non-paywall. Include any demo state instructions only if needed. |
| Demo account notes | Current non-paywall app does not appear to require an account. | Mark no account required for non-paywall release. If paywall/TestFlight purchase proof is included later, add sandbox/test instructions as required by the final release path. |
| Category | Metadata draft marks category as `NEEDS_JOJO_DECISION`, likely Travel or Education. | Jojo decision needed. My local recommendation is Travel as primary if the final positioning remains destination companion. |
| Age rating inputs | Not representable locally without App Store Connect questionnaire. | Jojo/ASC step. Use truthful app-content answers; do not guess policy-sensitive fields here. |
| Privacy labels | Metadata draft marks this as `NEEDS_APP_STORE_CONNECT`. Local privacy page says no account required and optional support contact may use email/message contents. | App Store Connect privacy questionnaire still needs final review. Do not infer final labels from local docs alone. |
| Export compliance | Not decided locally. | App Store Connect step. Needs Jojo/Apple-side answer. |
| App icon | `native-ios/Resources/Assets.xcassets/AppIcon.appiconset/app-icon.png` exists at `1024x1024`. | Confirm this is the intended final public icon before submission. |
| App preview video | `app-preview-30s-shot-list.md` exists; no final recording found in this pass. | Optional. If used, capture/export final video and check current Apple specs before upload. |
| Paywall / subscription metadata | `native-ios/Config/apps/vietnam.json` has product ID `app.speaklocal.vietnam.subscription.monthly`; docs say `feature/paywall` has hosted StoreKit/XCTest readiness, but remains isolated and not merged. | If paywall ships: confirm ASC subscription product state, pricing, review screenshot, purchase, restore, relaunch persistence, and locked/unlocked gating. If shipping non-paywall first: keep all subscription/trial copy out of public metadata. |
| Final build / device proof | `phone-latest-retry-report.md` says current `main` built and installed on the physical iPhone; launch was blocked because the phone was locked. Simulator fallback launch succeeded. | Unlock phone and rerun physical launch/walkthrough before calling the payload release-ready. |

## Screenshot Verification

Command:

```sh
sips -g pixelWidth -g pixelHeight docs/task-results/parallel-goals-2026-07-05/three-hour-push/app-store-screenshot-proof/*.png
```

Outcome:

- `01-home-first-screen.png`: `1320 x 2868`
- `02-browse-root.png`: `1320 x 2868`
- `03-eating-out-food-menu-page.png`: `1320 x 2868`
- `04-city-danang-browse-by.png`: `1320 x 2868`
- `05-search-results-food-allergies.png`: `1320 x 2868`
- `06-saved-danang.png`: `1320 x 2868`
- `07-practice-essentials-round-sheet.png`: `1320 x 2868`
- `contact-sheet.png`: `880 x 1024`

Use the seven numbered screenshots as candidate upload/composition sources. Treat `contact-sheet.png` as a review helper only.

## Local File Verification

Command:

```sh
for f in site/privacy.html site/terms.html site/feedback.html site/about/index.html marketing/projects/vietnam-launch-readiness-2026-07-05/app-store-metadata.md marketing/projects/vietnam-launch-readiness-2026-07-05/screenshot-storyboard.md marketing/projects/vietnam-launch-readiness-2026-07-05/app-preview-30s-shot-list.md marketing/projects/vietnam-launch-readiness-2026-07-05/claim-risk-checklist.md marketing/projects/vietnam-launch-readiness-2026-07-05/source-and-evidence-register.md marketing/app-store/speaklocal-vietnam-launch-packet-2026-07-05.md; do if [ -f "$f" ]; then echo "OK $f"; else echo "MISSING $f"; fi; done
```

Outcome:

- `OK site/privacy.html`
- `OK site/terms.html`
- `OK site/feedback.html`
- `OK site/about/index.html`
- `OK marketing/projects/vietnam-launch-readiness-2026-07-05/app-store-metadata.md`
- `OK marketing/projects/vietnam-launch-readiness-2026-07-05/screenshot-storyboard.md`
- `OK marketing/projects/vietnam-launch-readiness-2026-07-05/app-preview-30s-shot-list.md`
- `OK marketing/projects/vietnam-launch-readiness-2026-07-05/claim-risk-checklist.md`
- `OK marketing/projects/vietnam-launch-readiness-2026-07-05/source-and-evidence-register.md`
- `OK marketing/app-store/speaklocal-vietnam-launch-packet-2026-07-05.md`

Icon check:

```sh
sips -g pixelWidth -g pixelHeight native-ios/Resources/Assets.xcassets/AppIcon.appiconset/app-icon.png
```

Outcome: `1024 x 1024`.

## Evidence Read

- `docs/operations/APP_STATUS.md`: confirms native iOS `main` is current product truth, paywall remains excluded, and the 2026-07-05 parallel push produced App Store screenshot proof and current-main phone build/install proof.
- `docs/operations/CURRENT_BLOCKERS.md`: confirms paywall is only a blocker if the release must include paywall, and exact-current physical launch proof still needs an unlocked-phone rerun.
- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/app-store-screenshot-capture-report.md`: confirms screenshot capture context, dimensions, and caveats.
- `docs/task-results/parallel-goals-2026-07-05/three-hour-push/phone-latest-retry-report.md`: confirms physical build/install success and locked-phone launch blocker.
- `marketing/projects/vietnam-launch-readiness-2026-07-05/*`: contains metadata, storyboard, preview plan, claim-risk checklist, and evidence register.
- `docs/website/ALIGNMENT_PLAN.md`: records `https://speaklocal.app/` as the current live website domain and `site/` as the local static artifact.

## Follow-Ups

1. Jojo decides release strategy: non-paywall first or paywall-first.
2. Jojo decides final public app name, subtitle, primary category, and whether to use raw screenshots or final framed/captioned screenshots.
3. Unlock current iPhone and rerun physical launch/walkthrough for exact-current `main`.
4. Confirm final public support/privacy/terms URLs are live and acceptable for App Store Connect.
5. Prepare final App Review notes and privacy/age/export-compliance answers inside App Store Connect.
6. If paywall ships in the first release, finish App Store Connect subscription setup and real StoreKit purchase/restore/relaunch proof before public metadata mentions trial/subscription.

## Policy Boundary

This pass did not browse current Apple policy and did not log into App Store Connect. The local launch pack says Apple App Store Connect references were checked on 2026-07-05, but any submission-time policy-sensitive field should be confirmed in App Store Connect or current Apple documentation before final upload.
