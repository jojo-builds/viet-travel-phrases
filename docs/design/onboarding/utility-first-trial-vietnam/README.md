# SpeakLocal Vietnam Utility-First Trial Onboarding

Status: high-fidelity image-only design packet
Last updated: 2026-05-01

## Local Review

Open directly:

```text
file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/onboarding/utility-first-trial-vietnam/index.html
```

## Recommendation

Use the 6-screen utility-first flow as the native implementation target.

The old first-run packet showed the right product shape, but it still behaved like a setup flow first. This version follows the onboarding research direction more aggressively: let the traveler hear and save one useful phrase before the app asks setup questions or presents the trial.

The first value target is:

```text
Hear and save a useful Vietnamese phrase before the 7-day trial ask.
```

That makes the later destination, situation, and level questions feel earned because the user has already touched the product value.

## Accepted Jojo Decisions

- Trial screen uses no free-tier CTA. It shows `Start 7-day trial` plus `Restore purchase`, `Terms`, and `Privacy`.
- Melo appears as a subtle companion only, never as the guide or product centerpiece.
- First-run direction follows the onboarding research digest: utility before explanation, and personalization only when it visibly changes the next screen.

## Recommended Flow

| Step | Screen | User action | Why it earns its place | Local data |
| --- | --- | --- | --- | --- |
| 1 | `assets/recommended-01-arrival-phrase.png` | Hear one hotel-desk phrase. | Proves real traveler utility before setup. | None until user taps audio. |
| 2 | `assets/recommended-02-hear-save.png` | Keep the phrase for the trip. | Makes offline audio and saved phrases tangible. | Starter phrase saved flag. |
| 3 | `assets/recommended-03-trip-focus.png` | Pick destination and needs. | Personalization now has a visible reason. | Destination focus and selected situations. |
| 4 | `assets/recommended-04-tiny-check.png` | Answer or skip one phrase check. | Tunes practice without feeling like a test. | Optional placement level; skip stores Beginner default. |
| 5 | `assets/recommended-05-personalized-preview.png` | Review prepared phrases and shelves. | Shows what changed before the trial ask. | Uses saved phrase, destination, situations, and level. |
| 6 | `assets/recommended-06-trial-paywall.png` | Start the 7-day trial. | Presents paid product after demonstrated value. | Trial flow begins after CTA. |

Contact sheet:

- `assets/recommended-flow-contact-sheet.png`

## Compact Alternate Flow

The compact alternate is useful if first-run length becomes the top concern, but it is not the primary recommendation because it gives less breathing room between first utility, setup, and trial.

| Step | Screen | User action | Why it earns its place | Local data |
| --- | --- | --- | --- | --- |
| A1 | `assets/compact-01-phrase-first.png` | Hear a starter phrase and choose city lightly. | Combines welcome and first value. | Starter phrase interaction, destination if selected. |
| A2 | `assets/compact-02-trip-setup.png` | Pick a few needs. | Keeps setup to one utility-driven screen. | Selected situations. |
| A3 | `assets/compact-03-preview-check.png` | Preview prepared content and optionally tune practice. | Shows payoff before paywall while keeping the phrase check optional. | Level only if checked; skip stores Beginner default. |
| A4 | `assets/compact-04-trial-paywall.png` | Start the 7-day trial. | Same no-free-tier paywall model as the recommended flow. | Trial flow begins after CTA. |

Contact sheet:

- `assets/compact-flow-contact-sheet.png`

## Product Rules

- No account, notification, analytics, or permission prompt appears in this onboarding packet.
- No screen implies a permanent free tier or limited free product mode.
- The phrase check uses real Vietnamese phrase recognition, not generic travel trivia.
- Exact Vietnamese and English phrase copy should come from canonical content during implementation. The generated images are visual direction, not source text.
- Melo should stay small and optional. The mascot belongs near setup or preview moments, never inside controls, paywall benefits, bottom chrome, or dense phrase rows.

## Native Implementation Notes

- The first implementation should support a real pre-trial preview session: one bundled phrase/audio interaction, one local saved phrase state, lightweight setup, optional placement, then trial.
- Store onboarding choices locally until the user starts the trial. If they abandon the trial, do not imply that a permanent free tier exists.
- Use the current SpeakLocal native visual baseline from `docs/design/NATIVE_VISUAL_REFERENCE.md`, especially the 2026-05-01 simulator chrome references for spacing and Liquid Glass tone.
- Keep trial copy calm and native. Avoid urgency language, countdowns, discount framing, or aggressive subscription pressure.

## Next Native UI Task

Create `TASK-ONBOARDING-UTILITY-FIRST-NATIVE-UI-001`:

- implement the 6-screen recommended flow as a first-run native shell;
- wire one starter phrase/audio/save interaction from bundled content;
- persist destination, selected situations, saved starter phrase, and optional level locally;
- route the final CTA into the 7-day trial purchase flow;
- keep paywall secondary actions to restore/terms/privacy only.
