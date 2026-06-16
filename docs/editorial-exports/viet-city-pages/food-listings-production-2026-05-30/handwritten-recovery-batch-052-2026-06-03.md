# Handwritten Recovery Batch 052 - 2026-06-03

Status: PASS for authored copy import, native resource generation, validator guardrails, voice audit, signing hygiene scan, and Simulator render proof. Physical iPhone install was not retried for this batch because the earlier same-session phone install hung in `devicectl device install app`.

Progress after this batch: 259 / 520 recovered. Remaining: 261.

## Scope

- `viet-family-city-hue-place-nine-dynastic-urns` - Cửu Đỉnh / Nine Dynastic Urns
- `viet-family-city-hue-place-northern-bus-station` - Bến xe phía Bắc Huế / Hue Northern Bus Station
- `viet-family-city-hue-place-perfume-river` - Sông Hương / Perfume River
- `viet-family-city-hue-place-perfume-river-dragon-boat` - Thuyền rồng sông Hương / Perfume River dragon boat
- `viet-family-city-hue-place-pham-ngu-lao-street` - Đường Phạm Ngũ Lão / Pham Ngu Lao Street

## Authored Fixes

- Nine Dynastic Urns now introduces Cửu Đỉnh as the Nine Dynastic Urns, explains that they are nine huge bronze urns in the Thế Miếu courtyard of Hue's Imperial City, and says why Nguyễn imperial memory matters instead of assuming the reader already knows dynastic context.
- Hue Northern Bus Station now reads as a practical transfer point on the northern side of Hue, with pickup calls, taxi questions, and hotel directions. It avoids unstable schedule, price, and route claims.
- Perfume River now introduces Sông Hương as Hue's central river and explains why the river matters for orientation, landmarks, bridge views, and calmer city pacing.
- Perfume River dragon boat now explains the ride as a decorated Hue river boat experience, commonly used for a slower trip toward Thiên Mụ Pagoda or sunset river time, without implying a fixed performance package.
- Pham Ngu Lao Street now says this is Phạm Ngũ Lão Street in Hue, not the more famous Ho Chi Minh City backpacker street, and frames it as a compact visitor-service area for hotels, food, ride pickups, and easy returns.

## Sub-Agent QA

- Source-risk QA: `019e8c39-3935-7862-a599-80bb5c2b3e7e`
  - Flagged the need to define Cửu Đỉnh, Nguyễn, Thế Miếu, Sông Hương, Thiên Mụ, dragon boat boarding context, and Hue's Phạm Ngũ Lão identity.
  - Confirmed Hue Northern Bus Station was safer as a transfer/pickup listing with no schedule or fare promises.
  - Recommended keeping Perfume River and dragon boat pages distinct: the river page owns orientation; the boat page owns the ride.
- U.S.-traveler readability QA: `019e8c39-9b66-7f11-bddd-0d704187d6b9`
  - Flagged unexplained Vietnamese terms and culture labels as hard readability risks for first-time U.S. visitors.
  - Flagged vague phrases such as `performance plan`, repeated `opening image`, and generic route language; those were removed or rewritten.
  - Confirmed the final pass explains what each place is before asking the reader to care.

## Review Gate Update

`docs/design/city-pages/V2_2_PRODUCTION_REVIEW_GATE.md` now explicitly blocks copy that name-drops culture without onboarding the reader.

Added rule:

- If visible copy names a person or Vietnamese term, the same sentence or the next sentence must answer: who or what is this, why is it connected to Vietnam or this city, and why should someone new to Vietnam care?

Added hard blocker:

- Visible copy cannot use shorthand such as `one Vietnamese artist`, `royal`, `traditional`, `local`, `heritage`, or a Vietnamese proper noun as if the label itself creates value. The copy must translate the label into a concrete reason to visit or remember the place.

## Jojo Feedback Fold-In

After Simulator review, Jojo flagged the Nine Dynastic Urns lower sections as still reading too much like a checklist, with repeated `group` language and a template-like attempt to prove the page had object modules.

Fix applied:

- Replaced `A Focused Citadel Group` with `Inside The Royal Courtyard`.
- Replaced `Start With The Full Group` with `Step Back, Then Look Close`.
- Removed `one clear object group`, `full bronze group`, and `one dark bronze group`.
- Rewrote the lower sections so they explain the place naturally: where the urns sit, what the carvings show, and why the urns matter beyond decoration.

## Validation

Command chain:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production &&
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js &&
node native-ios/scripts/validate-viet-city-copy.js &&
node native-ios/scripts/validate-viet-city-library.js &&
node native-ios/scripts/validate-viet-sqlite-fixture.js &&
node native-ios/scripts/audit-viet-listing-production-qa.js &&
git diff --check
```

Result: PASS.

Key results:

- v2.2 projection: 520 entries
- strict production validation: 520 pass, 0 revise, 0 fail
- voice audit: 0 failures
- city production copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes
- city library validation: 826 pages
- SQLite validation: ok
- production QA: 0 blockers, 0 majors
- `git diff --check`: PASS

Additional hygiene:

- Repo signing scan: PASS.
- No repo-visible personal signing was detected in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Render Proof

Simulator profile: `city-listings-production-ready`

Rendered page left open on Simulator:

- `viet-family-city-hue-place-nine-dynastic-urns`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-052-screenshots/001-hue-nine-dynastic-urns-top.jpg`
- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-052-screenshots/004-hue-nine-dynastic-urns-final-detail.jpg`

Simulator build/run result: PASS.

## Phone Build

Physical iPhone build/install was not retried for this batch.

Reason:

- Batch 050 in this same session built successfully for the physical iPhone but hung during `devicectl device install app` after acquiring the device connection and usage assertion.
- The stuck install process was terminated cleanly then.
- Batch 052 changed content/resources only and was verified on the dedicated Simulator.

## Carry Forward

The named-reference rule is now a production blocker, not a taste preference. Future batches must introduce Vietnamese terms, artists, dynasties, awards, rituals, dishes, and place-specific history in plain American English before using those references as reasons to save, visit, or care.
