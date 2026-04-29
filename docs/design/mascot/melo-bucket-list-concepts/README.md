# Melo Bucket List Concepts

Status: locked next-step concept packet for Speak Local / Speak Local Vietnam
Last updated: 2026-04-29

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

- stable silhouette, face, eye shape, smile, and curled tail
- no plush, fuzzy, clay, realistic, or 3D toy treatment
- no hats, costumes, flags, badges, coins, trophies, XP, confetti, or leaderboard framing
- small emotional states in Practice
- more dramatic visual state only for meaningful bucket-list completion moments

## Required Melo Base Sheet

Create the final production base sheet with:

- front, three-quarter, side, tiny icon size
- idle, listening, correct, gentle correction, bucket list updated, hidden/rest
- neutral base plus six shared unlock stages
- Vietnam country layer as the first concrete country variant
- transparent PNG/WebP export with consistent canvas and anchor point

After that, use the locked base as the reference for every future prompt or commissioned illustration.

## Design Concepts

- `assets/melo-base-sheet.png`
- `assets/bucket-list-map-concept.png`
- `assets/practice-quiz-melo-concept.png`

## Next Implementation Design Packet

The next packet should turn these into native handoff specs:

- `MascotState`: hidden, idle, listening, correct, gentleCorrection, bucketListUpdated, rest
- `MeloProgressionStage`: base, firstPhrases, cityRhythm, travelerConfidence, streetReady, countryAttuned, fullyUnlocked
- `BucketListScope`: country, city, practiceSet
- `BucketListStatus`: locked, inProgress, completed, savedForLater
- `BucketListStamp`: country, city, completion date, progression stage, mascot asset key
- `MascotAssetKey`: `melo/<countryLayer>/<state>/<stage>/<view>`
- `MascotCanvas`: transparent PNG/WebP, square canvas, stable baseline anchor, no cropped tail

The phrase/street-name content can arrive from the content side later. The UI should consume that content rather than invent it.
