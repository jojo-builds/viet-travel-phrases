# Five Whys: `Quick conversations` Miss

Timestamp: 2026-07-05 23:59 Asia/Manila local
Surface: Browse category mid-page scenario rail

## Symptom

Jojo found a Browse mid-page rail labeled `Quick conversations` with cards such as `Market Hello`, `Hotel Hello`, and `Respectful Hello`. The cards route into Practice scenario flows, but the label reads like the retired Messages/conversation feature.

## Five Whys

1. Why did the app show `Quick conversations`?
   - `BrowseCollectionDescriptor.messageSectionDisplayTitle` was hardcoded to `Quick conversations`.

2. Why was old conversation language still on the active Browse page?
   - The scenario rail was originally modeled as `message` UI and later routed into Practice without a product-language cleanup of the visible section labels.

3. Why did tests not catch it?
   - Unit tests asserted the stale string as expected behavior, so automated validation preserved the wrong product language.

4. Why did visual/front-end QA not catch it?
   - The previous broad passes emphasized route success, audio, blank screens, chrome, and screenshot existence. They did not include a semantic copy pass over mid-page and lower-page labels.

5. Why was there no semantic copy pass?
   - The launch-readiness checklist had no explicit gate for retired feature vocabulary such as `Messages`, `Quick conversations`, or old contact-like scenario names on active Practice-era surfaces.

## Root Cause

The old Messages/scenario implementation names leaked into visible Practice-era UI, and our validation treated them as stable instead of checking them against current product truth.

## Fix Applied

- Browse scenario rail title changed from `Quick conversations` to `Practice moments`.
- Local greeting scenario card names changed from `Market Hello`, `Hotel Hello`, and `Respectful Hello` to `Market greeting`, `Hotel greeting`, and `Respectful greeting`.
- Visible Practice labels changed from `Messages` / `Messages thread` / `Back to Messages` / `Restart conversation` to Practice-oriented wording.
- Focused tests were updated first, observed red, then passed after the production copy fix.

## New Audit Rule

Future front-end QA must include a mid-page and bottom-page product-language pass. It is not enough to prove a page is nonblank and tappable; labels must still make sense for the current app direction.

