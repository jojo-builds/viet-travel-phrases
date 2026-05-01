# Browse/Search Visual Design Packet

This packet defines the recommended high-fidelity visual direction for SpeakLocal Vietnam Browse and Search. It is a design artifact only: no SwiftUI was implemented.

## Recommendation

Build Browse as deliberate exploration and Search as intent-led discovery.

Browse should start with the travel situations people recognize before they know what phrase they need: Airport, Hotel, Food, Getting Around, Shopping, Emergency, and Local greetings. City shortcuts, phrase families, level shelves, and practice-informed shelves belong below that first situation layer.

Search should open to a useful page before typing. The bottom Search icon should present Search without focusing the field or showing the keyboard. Keyboard appears only after the user taps into the field. Before typing, Search should offer suggested needs, common traveler queries, city/category shortcuts, and likely next phrases.

No Melo appears in these concepts. Browse/Search are utility surfaces, and the mascot would add personality without improving wayfinding.

## Screen Set

| State | Asset | Purpose |
| --- | --- | --- |
| Browse default | `assets/browse-default-situations.png` | Shows situations first, then city shortcuts and start-here shelves. |
| Browse scrolled | `assets/browse-scrolled-state.png` | Shows the lower exploration model: phrase families, by-city, and next shelves. |
| Search default | `assets/search-default-no-keyboard.png` | Search after tapping the bottom icon, with no keyboard and useful shelves. |
| Search focused | `assets/search-focused-keyboard.png` | Field tap state with keyboard and compact suggestions. |
| Search results | `assets/search-results-hotel.png` | Query-led phrase and situation results for `hotel`. |
| Search empty | `assets/search-empty-recovery.png` | No-match recovery that routes to nearby needs instead of dead-ending. |

## Native UI Notes

- Add a dedicated Browse destination route/page. The current Browse-selected reference is still a phrase/detail surface, so Native UI should not keep Browse as only a selected state on phrase pages.
- Change Search presentation so tapping the bottom Search island opens the Search page without immediately focusing the field. The current native chrome reference shows the expanded field, but the recommended first state is unfocused/no keyboard.
- Preserve the stable bottom admin chrome: frosted dock for Home/Browse/Saved/Practice, separate raised Search island, and enough bottom content padding for scrollable pages.
- Keep content sections tappable without typing. Browse routes through situations and shelves; Search routes through suggested needs, chips, and likely next phrase rows.
- Do not treat generated text in the raster images as canonical copy. Use the UX structure and final copy direction here; content-side phrase data should supply exact localized strings.

## First Implementation Task

Create a Native UI task for `BrowseSearchDestinations`:

- introduce `BrowsePageView` as a real route;
- wire bottom Browse to that route instead of piggybacking on phrase/detail selection;
- update Search presentation so initial open is not auto-focused;
- implement Search default shelves, focused keyboard behavior, results, and no-match recovery using the existing phrase catalog/search services.

## Local Review

Open `index.html` in a browser for the visual gallery. The simulator chrome reference files live at `../reference-shots/2026-05-01/`.
