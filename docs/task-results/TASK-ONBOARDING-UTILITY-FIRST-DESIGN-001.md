# TASK-ONBOARDING-UTILITY-FIRST-DESIGN-001 Result

## Status

Done.

## Commit Hash

- Design packet commit: `36619f4346768720b0fcde5f7bdaa37f372e5f4f`

## Design Packet

- Packet path: `docs/design/onboarding/utility-first-trial-vietnam/README.md`
- Gallery path: `docs/design/onboarding/utility-first-trial-vietnam/index.html`
- Gallery URL: `file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/onboarding/utility-first-trial-vietnam/index.html`
- Prompt packet: `docs/design/onboarding/utility-first-trial-vietnam/prompt-packet.md`
- Peer review: `docs/design/onboarding/utility-first-trial-vietnam/peer-review.md`

## Flow Recommendation

Use the 6-screen utility-first flow for native implementation.

The flow follows the onboarding research direction by proving traveler value before setup and before payment. The first value target is hearing and saving a useful Vietnamese phrase. Destination, situation, and placement questions appear only after that value is visible and only because they change the personalized preview.

## Screens Included

Recommended flow:

- `assets/recommended-01-arrival-phrase.png`
- `assets/recommended-02-hear-save.png`
- `assets/recommended-03-trip-focus.png`
- `assets/recommended-04-tiny-check.png`
- `assets/recommended-05-personalized-preview.png`
- `assets/recommended-06-trial-paywall.png`
- `assets/recommended-flow-contact-sheet.png`

Compact alternate:

- `assets/compact-01-phrase-first.png`
- `assets/compact-02-trip-setup.png`
- `assets/compact-03-preview-check.png`
- `assets/compact-04-trial-paywall.png`
- `assets/compact-flow-contact-sheet.png`

## Accepted Jojo Decisions

- Trial screen uses no free-tier CTA: primary `Start 7-day trial` plus restore/terms/privacy only.
- Melo appears as a subtle companion, not a guide or product centerpiece.
- First-value direction follows `docs/research/video-digests/onboarding-flows-1460-001/README.md`: utility before explanation, and personalization only when it visibly changes what the user sees next.

These accepted decisions are recorded in the packet README and prompt packet. The task card did not need an expanded-scope edit.

## Trial Handling

The paywall appears after the personalized preview. It does not show `Continue limited preview`, `Maybe later`, `Skip`, `Continue free`, or any ongoing free-tier language. The only secondary actions shown are restore purchase, terms, and privacy.

The design may support a short pre-trial preview/demo of value, but it does not imply an ongoing free product mode.

## Destination, Level, And Practice Personalization

- Destination focus stores a local destination signal, with Hanoi shown as the example.
- Situation focus stores selected needs such as hotel, getting around, and local greetings.
- The saved starter phrase stores a local saved phrase flag and demonstrates offline audio.
- The phrase check is optional and uses real Vietnamese phrase recognition. If skipped, the flow sets Beginner as the default rather than punishing the user.
- The personalized preview shows how saved phrase, destination, situations, and level change the prepared first phrases and practice recommendation.

## Peer Review Outcome

Pass with implementation notes.

The focused review checked native iOS/Liquid Glass fit, first-time traveler clarity, no free-tier ambiguity, no generic feature tour, Vietnamese phrase/practice relevance, and Melo restraint. Main notes:

- Use canonical content strings and bundled audio during native implementation.
- Keep paywall skip/free-tier wording out of the shipped UI.
- Keep Melo outside controls, paywall benefits, and dense phrase rows.
- The compact flow is acceptable, but the 6-screen flow better earns the trial ask.

## Validation Results

- Opened the gallery locally in the in-app browser.
- Browser-reported gallery title: `SpeakLocal Utility-First Onboarding`.
- Browser-reported gallery image count: 12.
- Confirmed all 12 local `src` references in `index.html` resolve.
- Confirmed all PNG assets report valid dimensions with `sips`.
- Ran `git diff --check` with no whitespace errors.
- Ran `git diff --cached --check` before the design packet commit.

## Recommended Native Implementation Task

Create `TASK-ONBOARDING-UTILITY-FIRST-NATIVE-UI-001`:

- implement the 6-screen recommended flow as native first-run UI;
- wire one starter phrase/audio/save interaction from bundled phrase content;
- persist local onboarding choices for saved starter phrase, destination, selected situations, and optional level;
- route the final CTA into the 7-day trial purchase flow;
- keep paywall secondary actions limited to restore purchase, terms, and privacy.
