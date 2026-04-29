# Melo Bucket List Concepts

Status: locked next-step concept packet for Speak Local / Speak Local Vietnam
Last updated: 2026-04-30

## Local Review

From the repo root:

```bash
python3 -m http.server 8787
```

Open:

```text
http://127.0.0.1:8787/docs/design/mascot/melo-bucket-list-concepts/index.html
```

## Locked Decisions

- Brand: **Speak Local**
- Current app: **Speak Local Vietnam**
- Mascot: **Melo**
- Mascot role: shared traveling chameleon across country packs
- Progress metaphor: **Bucket List**, not fixed-path travel
- Progress artifact: **Bucket List Stamp**
- Progress surface: **Bucket List Map**
- First country layer: Vietnam

Melo is not named from Vietnamese and should not be tied to Vietnam. Vietnam is the first country layer, with its own colors, city bucket lists, street-name practice, and tone-mark lessons. Later packs can use the same Melo base for Japan, the Philippines, Italy, and other languages.

## Product Direction

The Bucket List model should feel travel-native. Users may plan a country, a city, or a specific set of situations. The app should not imply that everyone follows the same path. It should let users work through destinations and practice needs at the level they care about.

For Speak Local Vietnam:

- country bucket list: Vietnam
- city bucket lists: Hanoi, Hue, Hoi An, Da Nang, Saigon, and others
- optional practice sets: phrase practice, street names, taxi destinations, saved phrases
- content source: content team owns phrase pages, street-name pages, and audio-ready rows
- design source: this packet owns where Melo appears, what the Bucket List Map looks like, and how Practice feedback uses mascot states

## Art Direction

Use the flat-brand Melo direction:

- stable silhouette, face, eye shape, smile, and corrected inward-curled tail
- tail must attach at the rear, taper continuously, and curl forward under the belly as an open C or hook
- tail must not read as a wheel, tire, target, bullseye, button, ring, snail shell, or separate circular disc
- no plush, fuzzy, clay, realistic, or 3D toy treatment
- no hats, costumes, flags, badges, coins, trophies, XP, confetti, or leaderboard framing
- small emotional states in Practice
- more dramatic visual state only for meaningful bucket-list completion moments

## Native Visual Fit

Any app screenshot or native handoff comp must use the Speak Local Liquid Glass system:

- photo masthead fading into clean white reading space when the surface needs travel context
- top profile/admin glass button on root Practice surfaces
- top-left Liquid Glass back button on map, city detail, and quiz screens
- pinned translucent bottom toolbar and raised search island
- red audio/action controls, jade progress, and white readable cards
- no generic black phone frames or web-dashboard styling

## Required Melo Base Sheet

Create the final production base sheet with:

- front, three-quarter, side, tiny icon size
- idle, listening, correct, gentle correction, bucket list updated, hidden/rest
- neutral base plus six shared unlock stages
- Vietnam country layer as the first concrete country variant
- transparent PNG/WebP export with consistent canvas and anchor point

After that, use the locked base as the reference for every future prompt or commissioned illustration.

## Design Concepts

- `assets/melo-base-sheet-tail-corrected.png`
- `assets/melo-tail-construction-v2.png`
- `assets/liquid-glass-bucket-list-v2.png`
- `assets/liquid-glass-quiz-states.png`
- `assets/melo-animation-storyboard.png`
- `assets/melo-base-sheet.png`
- `assets/bucket-list-map-concept.png`
- `assets/practice-quiz-melo-concept.png`

Related flow board:

- `../practice-flow-storyboard/index.html`

## Next Implementation Design Packet

The next packet should turn these into native handoff specs:

- `MascotState`: hidden, idle, listening, checking, selected, correct, gentleCorrection, bucketListUpdated, rest
- `MeloProgressionStage`: base, firstPhrases, cityRhythm, travelerConfidence, streetReady, countryAttuned, fullyUnlocked
- `BucketListScope`: country, city, practiceSet
- `BucketListStatus`: locked, inProgress, completed, savedForLater
- `BucketListStamp`: country, city, completion date, progression stage, mascot asset key
- `MascotAssetKey`: `melo/<countryLayer>/<state>/<stage>/<view>`
- `MascotCanvas`: transparent PNG/WebP, square canvas, stable baseline anchor, no cropped tail
- `MeloTailRule`: attached rear base, tapered open inward curl, clear gap, no wheel/bullseye/ring/disc silhouette
- `ChromeRequirement`: Liquid Glass top/back/profile controls and pinned bottom/search chrome in every app screenshot and native handoff comp
- `AnimationRig`: Rive or Lottie-style vector layers, 12-24 frame micro-loops, stable bottom-center anchor, reduced-motion fallback

The phrase/street-name content can arrive from the content side later. The UI should consume that content rather than invent it.
