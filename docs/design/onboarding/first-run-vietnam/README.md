# SpeakLocal Vietnam First-Run Onboarding Storyboards

Status: high-fidelity image-only design packet
Last updated: 2026-04-30

## Local Review

Open directly:

```text
file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/onboarding/first-run-vietnam/index.html
```

Or from the repo root:

```bash
python3 -m http.server 8787
```

Then open:

```text
http://127.0.0.1:8787/docs/design/onboarding/first-run-vietnam/index.html
```

## Design Goal

This packet explores first-run onboarding for SpeakLocal Vietnam as production-style screenshots, not implementation code. The goal is to make the first launch feel calm, premium, and immediately useful:

- orient the traveler around a personalized Vietnam phrase map
- ask only enough questions to personalize the start
- frame placement as helpful pacing, not a test
- show value before the 7-day trial paywall
- keep Melo subtle and optional

## Image Assets

- `assets/onboarding-flow-main.png`: full 8-screen onboarding flow
- `assets/onboarding-compact-alternate.png`: shorter 5-screen alternate
- `assets/melo-onboarding-placement-options.png`: mascot usage options

## Main 8-Screen Flow

1. **Welcome / Promise**
   Sets the product promise: offline phrase guidance for real Vietnam travel moments. The screen should feel like the live app's scenic Home direction, not a marketing splash.

2. **Destination Focus**
   Asks where the traveler is going first. This personalizes the starting set while explicitly preserving access to all Vietnam phrases.

3. **Travel Focus / Interests**
   Uses lightweight multi-select cards for practical needs such as Airport, Hotel, Food, Getting Around, Shopping, Emergency, and Local greetings. It should feel like setup help, not a survey.

4. **Placement Quiz Intro**
   Frames the check positively: the goal is pacing. A skip path keeps trust high for users who want everything immediately.

5. **Placement Quiz Question**
   Uses a real phrase prompt, not generic travel trivia. The audio button makes it feel like the product is already teaching.

6. **Level Result**
   Shows Beginner, Intermediate, and Advanced outcomes with a selected result and a reminder that the level can change anytime.

7. **Personalized Preview**
   Shows what SpeakLocal prepared for the user's trip before asking for the trial: Hotel check-in, Local greetings, Practice before you land, and similar useful starts.

8. **Trial / Paywall**
   Presents the 7-day free trial in the same calm native language as the app: offline phrase map, city guidance, audio, practice, and personalized recommendations. The secondary action stays available through Continue limited preview.

## Recommended Direction

Use the 8-screen flow for the first visual handoff because it best explains the product value before the paywall. The only risk is setup length, so the production version should keep transitions quick and allow skip on the placement check.

The compact alternate is useful if we decide onboarding must be shorter. It combines destination setup with welcome and moves from interests into a single phrase check, but it gives the user less time to understand why the app is personalized before the paywall.

## Melo Guidance

Melo should be treated as a restrained travel companion:

- useful on interests, quiz intro, and personalized preview
- absent or minimal on the paywall
- never placed inside controls, bottom chrome, or dense phrase rows
- flat-brand, not plush, not fuzzy, not realistic
- tail always attached with an open inward curl toward the belly, never a wheel or ring

## UX Tradeoffs

- **More personalization vs. more friction:** the 8-screen version is clearer but longer. The alternate is faster but less explanatory.
- **Placement quiz vs. skip:** the quiz makes recommendations feel earned, but skip must remain visible so onboarding does not feel like a gate.
- **Mascot warmth vs. premium restraint:** Melo helps soften setup, but too much mascot presence would make onboarding feel childish.
- **Paywall timing:** the preview-before-paywall screen is important. It gives the trial ask a reason to exist instead of appearing before the user has seen value.

## Next Art Step

If this direction is approved, create locked individual PNG/WebP exports for each screen at iPhone Pro Max aspect ratio and a separate clean paywall variation for trial-copy testing.
