# Video-Informed Mascot Concepts

Status: second-pass visual and product direction after transcribing the four referenced mascot/design videos
Last updated: 2026-04-29

## Local Review

From the repo root:

```bash
python3 -m http.server 8787
```

Open:

```text
http://127.0.0.1:8787/docs/design/mascot/video-informed-concepts/index.html
```

## Transcript Coverage

Full working transcripts were extracted from YouTube auto captions with `yt-dlp` in an isolated local venv at `tmp/mascot-youtube-research/.venv`.

- `tmp/mascot-youtube-research/transcripts/full/app-branding-masterclass.timestamped.txt`: 3,942 words, 100% duration coverage
- `tmp/mascot-youtube-research/transcripts/full/design-apps-10x-better.timestamped.txt`: 9,690 words, 100% duration coverage
- `tmp/mascot-youtube-research/transcripts/full/ai-replaced-lottie.timestamped.txt`: 1,897 words, 100% duration coverage
- `tmp/mascot-youtube-research/transcripts/full/weirdly-addictive-apps.timestamped.txt`: 1,745 words, 100% duration coverage

The durable app-facing notes below are paraphrased from those transcripts rather than copying the full transcripts into this design packet.

## What The Videos Change

The first high-fidelity packet treated the mascot mostly as static art. The videos push us toward a stronger product idea: the mascot should be a small emotional feedback system, with repeatable poses, micro-reactions, and a clear app role.

The main changes for SpeakLocal:

- Make the mascot softer and more plush than reptile-realistic. The chameleon metaphor is still strong, but it needs rounded proportions, soft material, and zero sharp/wet reptile cues.
- Treat the first accepted mascot as a base asset, then generate controlled variations from it. Do not one-shot every future pose.
- Use the mascot in empty states, onboarding, Practice route cards, and completion moments. Keep it out of phrase reading chrome, search chrome, bottom chrome, and sensitive contexts.
- Build a small emotion set before coding animations: idle, listening, correct, gentle correction, route updated, quiet rest.
- Make progress feel like the chameleon is becoming locally attuned through color, route marks, and tiny material details. Do not use costumes, hats, flag markings, XP, coins, streak pressure, trophies, or big game panels.
- Design the character for animation from day one: stable canvas, consistent scale, clear silhouette, enough padding for bounce/idle/listen loops.

## Recommended Mascot Direction

Keep the chameleon, but make it less like a polished lizard and more like a soft language companion. The color-change metaphor is too perfect for language learning to throw away: the user practices, the mascot subtly adapts, and the app gets a visible memory of progress.

The revised direction is:

- Base: soft sage/cream chameleon, plush material, curled tail, big calm eyes, canvas satchel.
- Early Vietnam: sea-glass/jade tint and one small route charm.
- Mid Vietnam: ceramic-blue scale patches and subtle lotus-red stitch.
- High progress: warm lantern glow and small jade/gold route mark, with less ornament than the prior completion concept.
- Motion states: small eye/posture/tail changes rather than big cartoon acting.

## Alternative Species

The alternate animals are useful, but they mostly prove why the chameleon remains the best core direction.

- Chameleon: best metaphor and strongest product story. Risk is lizard fear, solved by plush abstraction.
- House gecko: closest backup. Friendlier, familiar, nimble, but less magical as a progress metaphor.
- Pangolin: gentle and Vietnam-relevant, good if we want non-lizard safety, but harder to animate expressively and may feel too conservation-coded.
- Water buffalo: culturally warm and calm, but too heavy for phrase-practice micro-reactions and less app-like.
- Douc-inspired monkey: expressive and local, but high risk of feeling childish or too active for serious travel phrases.

Recommendation: commit to soft chameleon as primary, keep gecko as backup, and leave the others as reference only.

## Implementation Plan

1. Define a `MascotState` model:
   - `hidden`
   - `idle`
   - `listening`
   - `correct`
   - `gentleCorrection`
   - `routeUpdated`
   - `emptyPractice`

2. Define a `MascotProgression` model:
   - `base`
   - `earlyVietnam`
   - `midVietnam`
   - `highProgress`

3. Gate visibility:
   - show in Practice hub, empty Practice state, eligible prompt feedback, and route completion
   - hide on listing pages except maybe a tiny neutral route mark
   - hide for medical, emergency, police, harassment, safety, and other high-stress contexts

4. Start static, then animate:
   - ship static PNG/WebP assets first
   - add SwiftUI motion with subtle scale, bob, blink, glow, and color transitions
   - use haptics only for tiny confirmation moments
   - avoid streak pressure or addictive reward loops

5. Create the final art production brief:
   - commission or draw one unique base mascot sheet
   - use that base as the reference for AI variants
   - generate transparent-background final assets
   - export each state in consistent aspect ratio and canvas position

## Images

- `assets/soft-chameleon-base.png`
- `assets/chameleon-vietnam-progression-lineup.png`
- `assets/chameleon-emotion-motion-sheet.png`
- `assets/screen-empty-practice-guide.png`
- `assets/screen-practice-hub-progression.png`
- `assets/screen-route-updated.png`
- `assets/alternate-house-gecko.png`
- `assets/alternate-pangolin.png`
- `assets/alternate-water-buffalo.png`
- `assets/alternate-douc-monkey.png`
- `assets/alternate-species-comparison.png`

## Verdict

Change the current mascot work from "nice mascot art" into a reusable mascot system. The app should keep the mascot quiet, premium, and helpful. The character's job is not to entertain the user all the time; it is to make Practice feel warmer, make progress feel earned, and make empty/completion states memorable without compromising the phrasebook's seriousness.
