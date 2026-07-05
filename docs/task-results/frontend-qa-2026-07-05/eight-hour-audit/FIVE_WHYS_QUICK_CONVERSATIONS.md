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

## Follow-Up Miss Found During The Eight-Hour Pass

After the first fix, a worker found two more Practice-scenario strings that explained why the first gate was still too weak:

- `MESSAGES` appeared as an uppercase caption in the scenario header.
- `Conversation complete` appeared on the scenario completion card.

The immediate why: the static audit blocked exact `Messages`, but did not treat case variants as retired labels and did not include the completion headline. The deeper why: the earlier front-end pass did not enter and complete the Practice scenario flow, so top/middle/bottom page review still missed nested states.

Follow-up fix:

- scenario header caption changed to `PRACTICE`
- completion headline changed to `Practice complete`
- completion body changed from `thread` wording to `practice run`
- story transcript accessibility fallback changed from `Conversation break` to `Practice beat`
- local greeting scenario titles and scene titles changed to `Market greeting`, `Hotel greeting`, and `Respectful greeting`
- top-level Browse card changed from `Respectful hellos` / `hello` subtitle to `Respectful greetings` / `greeting` subtitle
- unknown city practice fallback changed from `messages` to `practice`
- stale Browse UI test expectation changed from `Quick conversations` to `Practice moments`
- trip fallback subtitle changed from `Practical travel conversations...` to `Practical travel moments to practice first.`

Additional harness-prevention follow-up on 2026-07-06:
- UI-test tab helpers now navigate to `Practice` instead of the retired `Messages` alias.
- Local-greetings proof expectations now use `Hotel greeting` and `Respectful greeting` instead of the old `Hotel Hello` / `Respectful Hello` card labels.
- Exact stale-term scan now finds no `openDock("Messages")`, `case "Messages"`, `Hotel Hello`, `Respectful Hello`, or `Quick conversations` references in `native-ios/UITests` or `native-ios/Tests`.
- the visible-language audit now catches case variants of exact retired labels, `Conversation complete`, and `Conversation break` accessibility fallbacks
