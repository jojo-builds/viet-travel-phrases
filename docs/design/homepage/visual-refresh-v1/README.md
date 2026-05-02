# SpeakLocal Vietnam Homepage Visual Refresh V1

Status: design packet for review
Scope: visual/storyboard artifact only. No Swift, generated resources, SQLite, audio, or Xcode files were edited.

## Recommendation

Implement the **Hybrid Utility Home** direction first:

- Keep the first viewport focused on immediate utility: `Start speaking now`, the native Search card, and 3 to 5 playable starter phrases.
- Add real image-led category and city cards just below the starter phrases so the homepage feels more travel-specific without becoming Browse.
- Show Continue, Saved, Practice pool, and city-focus modules only after real local state exists. First launch should not show fake returning-user shelves.

This combines the safest part of Direction 1, the visual lift of Direction 2, and the state discipline of Direction 3.

## Accepted Jojo Decisions

- Primary visuals should be native comps from current screenshots/chrome and app assets.
- Recommended direction should bias toward Hybrid Utility.
- First-launch traveler clarity is the primary homepage story.

## Screen Set

| Artifact | Purpose |
| --- | --- |
| `assets/current-issue-resolution.png` | Shows the current phrase-card icon/audio/navigation confusion and the redesign rule. |
| `assets/direction-1-conservative-native-refresh.png` | Keeps the current Home structure while cleaning hierarchy, spacing, and controls. |
| `assets/direction-2-image-led-travel-gateway.png` | Shows category/city image cards as Browse collection entry points. |
| `assets/direction-3-personalized-utility-home.png` | Shows returning-user modules that appear only after real local actions. |
| `assets/homepage-refresh-contact-sheet.png` | Side-by-side recommendation sheet and locked homepage rules. |
| `assets/screens/direction-*-*.png` | Full-size iPhone screen comps for top, mid, and lower Home states. |

Open `index.html` for the local gallery.

## Direction Notes

### Direction 1: Conservative Native Refresh

Best for the lowest-risk native implementation. It keeps the current Home spine: masthead, Search, starter phrases, travel situations, relationship greetings, useful phrase pages, and Browse-all entry.

The meaningful change is hierarchy. The phrase card no longer presents a decorative icon, a speaker, and a chevron as equally important controls. Category context becomes a small label. Audio becomes one red speaker button. Navigation is expressed by card text plus chevron.

### Direction 2: Image-Led Travel Gateway

Best for making Home feel more clearly tied to Vietnam travel. Hanoi, Hotel, Airport, Food, and Shopping image cards open Browse collection pages. Search remains a separate intent-led surface.

The risk is busyness. This should not become a photo grid in the first viewport. In the recommended hybrid, images belong immediately below essentials rather than replacing the utility-first top.

### Direction 3: Personalized Utility Home

Best for returning users. It shows Continue, Saved for trip, Practice pool, and city-focused next shelves after the app has real local state.

The rule is state-gating. First launch should not show empty Continue/Saved/Practice shelves. If there is no saved or practice data, the homepage should stay focused on useful phrases, Search, and trip discovery.

## Phrase Card Audio And Navigation

Recommended control model:

- The phrase title/subtitle/card body opens the canonical phrase page.
- The red speaker button plays bundled audio and appears only when audio exists.
- The chevron reinforces navigation.
- Tiny chips can label context such as `HELLO`, `POLITE`, `REPAIR`, `CITY`, or `CATEGORY`, but they are not controls.
- Do not use a decorative speaker-like or category icon beside the real speaker button.

## Category And City Image Handling

- Image cards route to Browse collection pages, not Search results.
- Use existing native image assets first:
  - `BrowseCollectionHanoi`
  - `BrowseCollectionAirport`
  - `BrowseCollectionHotel`
  - `BrowseCollectionFood`
  - `BrowseCollectionShopping`
- Keep card count strict on Home. Use two strong image cards in the first image layer, then let Browse own the full collection grid.

## Implementation Notes

- Recommended follow-up: create a native homepage refresh task that updates `HomePhraseCard`, Home ordering, and image-led Browse collection cards while preserving the current route model.
- The current Home source already has most of the data sections needed. This is a visual/hierarchy pass, not a product reset.
- The bottom Home/admin dock and Search island should remain visually stable while content scrolls underneath.
- Melo should not lead the homepage. Keep mascot usage for Practice/progress/empty-state surfaces unless a later task proves a small companion cue improves clarity.
