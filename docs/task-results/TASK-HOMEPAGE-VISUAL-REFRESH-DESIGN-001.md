# TASK-HOMEPAGE-VISUAL-REFRESH-DESIGN-001

## Status

Complete. V2 revision added after Jojo browser review comments.

## Commit Hash

Design packet commit: `dcf955950bb925740b1d6713c7ced84bb27c09ac`

V2 revision commit: `0e35dfc0`

## Paths

- Design packet: `docs/design/homepage/visual-refresh-v1/`
- Gallery: `docs/design/homepage/visual-refresh-v1/index.html`
- README: `docs/design/homepage/visual-refresh-v1/README.md`
- Prompt packet: `docs/design/homepage/visual-refresh-v1/prompt-packet.md`
- Peer review: `docs/design/homepage/visual-refresh-v1/peer-review.md`

## Accepted Jojo Decisions

- Primary visuals should be native comps from current screenshots/chrome and app assets.
- Recommended direction should bias toward Hybrid Utility.
- First-launch traveler clarity is the primary homepage story.
- Jojo V2 feedback accepted: remove implied-action card labels, fix the hard hero image seam, keep phrasebook utility first, and make chrome/admin/search presentation closer to the locked native reference.

## Included Screens And Assets

- `assets/current-issue-resolution.png`
- `assets/direction-1-conservative-native-refresh.png`
- `assets/direction-2-image-led-travel-gateway.png`
- `assets/direction-3-personalized-utility-home.png`
- `assets/homepage-refresh-contact-sheet.png`
- `assets/screens/direction-1-top.png`
- `assets/screens/direction-1-mid.png`
- `assets/screens/direction-1-bottom.png`
- `assets/screens/direction-2-top.png`
- `assets/screens/direction-2-mid.png`
- `assets/screens/direction-2-bottom.png`
- `assets/screens/direction-3-top.png`
- `assets/screens/direction-3-mid.png`
- `assets/screens/direction-3-bottom.png`

## Recommended Direction

Implement the **Cleaner Hybrid Utility Home** first:

- Direction 1 structure as the implementation baseline.
- Direction 2 image cards below starter essentials for travel-specific discovery.
- Direction 3 returning-user modules only after real saved, recent, or practice state exists.

This keeps the first launch useful and calm while giving the homepage more visual travel texture. V2 specifically removes UI copy that explains actions already implied by speaker buttons, chevrons, images, or tab chrome.

## Category And City Image Handling

- Category and city image cards should open Browse collection pages, not Search results.
- Use existing native image assets first: Hanoi, Airport, Hotel, Food, and Shopping.
- Keep image cards below immediate utility on first launch. Do not let a photo grid replace Search or starter phrase playback.

## Phrase Card Audio And Navigation

- Phrase title/subtitle/card body opens the canonical phrase page.
- One red speaker button plays bundled audio.
- Chevron reinforces navigation.
- Do not use implied-action or object-type tags such as `Open page`, `Phrase page`, `Play`, `City`, or `Category` inside user-facing cards.
- Context labels should appear only when they add meaning the title/subtitle cannot carry.
- Avoid the current double-icon pattern where a decorative icon competes with the real audio speaker.

## Research Fold-In

- Apple Liquid Glass overview: use layered native materials/chrome without making content harder to read.
- Apple design tips: keep layouts readable, touch controls clear, and controls near the content they affect.
- NN/g aesthetic and minimalist heuristic: remove extra information because it competes with relevant information.

## Peer Review Summary

Peer review passed for:

- first-time traveler clarity;
- native iOS / Liquid Glass fit;
- reduced clutter;
- audio versus navigation clarity;
- category/city image handling;
- realistic SwiftUI implementation;
- mascot restraint.
- V2 annotation handling: no implied-action tags, cleaner hero fade, cleaner bottom chrome artifact.

Main caution: keep the image card layer small so Home does not become Browse.

## Validation Run

- Verified all `index.html` image and document references resolve locally: 14 images, 3 links, 0 missing.
- Verified required native references and image assets exist.
- Verified raster output dimensions with `sips`.
- Ran `git diff --check`.
- Ran `git diff --cached --check` before the design packet commit.

No app build or simulator test was run because this was a docs-only visual design artifact task.

## Implementation Follow-Up Suggestions

Create a native UI task for `HomeView` that:

- refactors `HomePhraseCard` to separate audio and navigation affordances visually;
- adds a small image-led Browse collection layer below `Start with essentials`;
- keeps Continue, Saved, Practice pool, and city-focus shelves state-gated;
- preserves the current Home/admin dock and Search island behavior;
- includes simulator screenshots for first-launch Home top, Home scrolled state, and returning-user Home if local state fixtures exist.
