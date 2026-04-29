# Melo Practice Flow Image Storyboards

Status: image-only Practice UX storyboard for Speak Local Vietnam
Last updated: 2026-04-30

## Local Review

Open directly:

```text
file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/mascot/practice-flow-storyboard/index.html
```

Or from the repo root:

```bash
python3 -m http.server 8787
```

Then open:

```text
http://127.0.0.1:8787/docs/design/mascot/practice-flow-storyboard/index.html
```

## Purpose

This board shows how Practice should work from a user-flow perspective before native implementation. It is intentionally a gallery of raster design sheets, not a built HTML/CSS prototype:

- Practice home
- Bucket List and city scope selection
- practice-type selection
- quiz loop states
- feedback and review
- Bucket List completion
- Melo animation placement and unlock intensity

It uses the accepted Melo tail direction from `../melo-bucket-list-concepts/` and keeps the native Liquid Glass chrome visible in the app screenshots.

## Image Assets

- `assets/practice-flow-overview.png`: eight-screen Practice flow overview
- `assets/practice-mode-screens.png`: six-screen Practice mode concepts
- `assets/melo-progression-unlock.png`: seven-stage Melo progression and unlock flow
- `../melo-bucket-list-concepts/assets/melo-animation-storyboard.png`: pose and animation reference

## Design Decisions

- Melo stays small in normal quiz flow and never enters answer hit targets or bottom chrome.
- The tail rule stays locked: attached rear base, tapered open inward curl, no wheel/ring/bullseye/disc silhouette.
- Unlocks should become more dramatic at completion than normal quiz feedback, with richer country pattern coverage and warmer glow.
- The app chrome should match Speak Local Vietnam's native Liquid Glass direction: translucent bottom bar, raised Search island, red Practice active state, circular glass back/profile controls, and readable white content surfaces.
- City/street-name content is represented as placeholder destinations only. The content team owns final phrase rows, street names, explanations, and audio.
- Sensitive or high-stress practice hides Melo or reduces it to a neutral mark.

## New Surfaces Included

- empty or low-progress Practice home
- Bucket List Map
- city Bucket List detail
- practice type picker
- listen-and-choose quiz
- street-name sign match
- tone-mark repair
- speak aloud rehearsal
- answer checking
- correct feedback
- gentle correction
- saved review queue
- Bucket List updated completion
- post-completion city map

## Prompt Direction Locked

Future image prompts should keep Melo flat-brand and app-native: not fuzzy, not plush, not a realistic lizard, and not a toy render. The Practice boards should be requested as high-fidelity raster screenshots arranged on a review sheet, with no functioning prototype behavior implied.
