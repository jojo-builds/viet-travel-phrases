# SpeakLocal Vietnam Homepage Visual Refresh V2

Status: design packet for review
Scope: visual/storyboard artifact only. No Swift, generated resources, SQLite, audio, or Xcode files were edited.

## V2 Revision Notes

This pass responds to Jojo browser annotations on the first packet:

- Removed implied-action labels from user-facing cards. No `open`, `page`, `play`, `city`, or `category` tags inside cards.
- Rebuilt the top Home comps around the live Home masthead crop so the Ha Long Bay image fades into content without a hard seam and the boat remains visible.
- Kept Home as a phrasebook utility first: Search and useful phrases answer the immediate user need; travel imagery supports orientation below that.
- Reworked the visual chrome composition to preserve the stable bottom admin/search relationship while avoiding copied playback-row artifacts.

## Research Fold-In

- Apple Liquid Glass guidance frames the material as a system-level refresh for controls and app interfaces; here that means chrome should feel layered and native while content remains readable: <https://developer.apple.com/documentation/TechnologyOverviews/liquid-glass>.
- Apple UI design tips emphasize readable layouts, touch-ready controls, spacing, and keeping controls close to the content they affect: <https://developer.apple.com/design/tips/>.
- NN/g's aesthetic and minimalist heuristic says extra information competes with relevant information; that is the rationale for removing implied labels like `Open page`, `Play`, and `Phrase page`: <https://www.nngroup.com/articles/ten-usability-heuristics/>.

## Recommendation

Implement the **Cleaner Hybrid Utility Home** direction first:

- Keep the first viewport focused on immediate utility: `Start speaking now`, the native Search card, and 3 to 5 playable starter phrases.
- Add real image-led category and city cards just below the starter phrases so the homepage feels more travel-specific without becoming Browse.
- Show Continue, Saved, Practice pool, and city-focus modules only after real local state exists. First launch should not show fake returning-user shelves.

This combines the safest part of Direction 1, the visual lift of Direction 2, and the state discipline of Direction 3 without adding labels that explain controls the user can already infer.

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

### Direction 1: Cleaner Native Home

Best for the lowest-risk native implementation. It keeps the current Home spine: masthead, Search, starter phrases, travel situations, relationship greetings, useful phrase pages, and Browse-all entry.

The meaningful change is hierarchy. The phrase card no longer presents a decorative icon, a speaker, text labels, and a chevron as equally important controls. Audio becomes one red speaker button. Navigation is expressed by card text plus chevron.

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
- Do not add implied-action or object-type tags such as `Open page`, `Phrase page`, `Play`, `City`, or `Category`.
- If context labels are needed later, keep them out of first-viewport utility cards unless they add meaning the title/subtitle cannot carry.
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
