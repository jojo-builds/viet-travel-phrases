# SpeakLocal Vietnam Homepage Visual Refresh V3

Status: design packet for review
Scope: docs/design artifact only. No Swift, Xcode project, generated resources, native assets, SQLite, or audio files were edited.

## Recommendation

Implement the **Native-Locked Utility Home** system.

The V3 direction keeps the current SpeakLocal native Home chrome as the product frame and changes only the Home content hierarchy:

1. Keep the live hero, identity, headline, and Search entry treatment.
2. Put starter phrase utility immediately after Search.
3. Add a small image-led Browse collection shelf below starter phrases.
4. Keep lower shelves calm, row-based, and phrasebook-specific.
5. Keep returning-user modules state-gated and out of first-launch Home unless real local state exists.

This is not a new app shell. It is a content/card hierarchy refresh inside the existing native SwiftUI/Liquid Glass frame.

## Native Chrome Source

Final V3 comps use the durable locked reference:

- `assets/reference/locked-native-home-chrome-reference.png`
- Source: `docs/design/reference-shots/2026-05-01/native-home-chrome.png`

A fresh simulator Home reference was also captured during implementation:

- `assets/reference/fresh-simulator-home-reference.png`

The fresh capture reflected unrelated native chrome work already present in the dirty worktree, so the final V3 packet uses the 2026-05-01 locked reference for the established four-item bottom admin bar and Search island. The bottom admin/search layer in these raster comps should be treated as a live native chrome placeholder. Native implementation should reuse the real SwiftUI chrome directly.

## Screen Set

| Artifact | Purpose |
| --- | --- |
| `assets/screens/home-v3-top.png` | First viewport: live hero/search treatment plus starter phrase utility. |
| `assets/screens/home-v3-discovery.png` | Mid Home: starter phrases followed by image-led city/category discovery. |
| `assets/screens/home-v3-lower.png` | Lower Home: calmer row and phrase-page shelves. |
| `assets/home-v3-content-rules.png` | Design rules for what changed and what stays locked. |
| `assets/homepage-v3-contact-sheet.png` | Review sheet with the recommended V3 system. |

Open `index.html` for the local gallery.

## Content Rules

- No user-facing labels like `Open`, `Play`, `City`, `Category`, or `Phrase page`.
- Phrase cards use title, subtitle, one speaker button when audio exists, and a chevron for navigation.
- Image cards use existing Browse collection assets only: `BrowseCollectionHanoi`, `BrowseCollectionAirport`, `BrowseCollectionHotel`, `BrowseCollectionFood`, and `BrowseCollectionShopping`.
- Image cards route to rich Browse collection pages, not Search results.
- Melo stays off Home.

## Native UI Implementation Notes

- Update Home content ordering and card affordances only.
- Do not redesign `AppChrome`, the bottom admin bar, the bottom Search island, status chrome, or the Home hero treatment.
- `HomePhraseCard` should drop the decorative `symbolName` icon in compact phrase cards.
- `AudioSpeakerButton` remains the only audio affordance.
- Add a small image-led Browse collection shelf below starter phrases.
- Keep returning-user modules out of first-launch screenshots and state-gate them behind saved/recent/practice state.

## Recommended Follow-Up

Create a Native UI implementation task for the V3 Home refresh:

- refactor compact Home phrase cards;
- reorder first-launch Home sections;
- add image-led Browse collection cards routed to collection pages;
- preserve existing chrome and route model;
- verify in simulator with screenshots against this packet.
