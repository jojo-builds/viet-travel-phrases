# TASK-BROWSE-SEARCH-VISUAL-DESIGN-001 Result

## Status

Done.

## Commit Hash

- Design packet commit: `58e0485cdf17dd7c346e8b5c8967eab7355146be`

## Artifact Paths

- Browse/Search packet: `docs/design/browse-search/README.md`
- Gallery: `docs/design/browse-search/index.html`
- Prompt packet: `docs/design/browse-search/prompt-packet.md`
- Focused peer review: `docs/design/browse-search/peer-review.md`
- Mockup assets:
  - `docs/design/browse-search/assets/browse-default-situations.png`
  - `docs/design/browse-search/assets/browse-scrolled-state.png`
  - `docs/design/browse-search/assets/search-default-no-keyboard.png`
  - `docs/design/browse-search/assets/search-focused-keyboard.png`
  - `docs/design/browse-search/assets/search-results-hotel.png`
  - `docs/design/browse-search/assets/search-empty-recovery.png`

## Simulator Chrome References

Saved under `docs/design/reference-shots/2026-05-01/` and added to `docs/design/NATIVE_VISUAL_REFERENCE.md`:

- `native-home-chrome.png`
- `native-browse-chrome.png`
- `native-search-expanded-chrome.png`

## Accepted Jojo Decisions

- Use real simulator chrome/admin/search references before generating Browse/Search concepts.
- Save those references durably so future visual packets do not guess the bottom admin bar.
- Browse/Search should keep Melo out of these utility surfaces.
- Browse is deliberate exploration, with traveler situations first.
- Search is intent-led discovery and must be useful before typing.
- Tapping Search should not force the keyboard; the keyboard appears only after tapping into the field.

The task card did not need an expanded-scope edit; the accepted steering is recorded in this result and the design packet.

## Design Recommendation

Implement Browse as a real native destination with a situations-first hierarchy:

- Airport
- Hotel
- Food
- Getting Around
- Shopping
- Emergency
- Local greetings

Layer city shortcuts, phrase families, level shelves, saved/practice-informed shelves, and recently viewed pages below that first situation layer.

Implement Search as a useful no-keyboard landing page first. The default page should show suggested needs, popular traveler queries, city/category shortcuts, and likely next phrases. Field focus should then bring up the keyboard and compact suggestions. Results should mix exact phrases, situations, and related searches. Empty/no-match should route to nearby traveler needs instead of feeling like an error.

## Peer Review Outcome

Pass with implementation notes.

The packet passed the focused review for native fit, clarity, visual busyness, copy quality, Search behavior, and mascot restraint. The main watchouts are:

- Replace generated Vietnamese copy with canonical content-side phrase data.
- Keep the Search default state unfocused.
- Keep bottom padding generous so content never collides with the stable Liquid Glass chrome.
- Treat generated back/home affordances in result states as visual direction, not fixed navigation architecture.

## Validation

- Captured simulator references from the booted iPhone 17 Pro simulator.
- Confirmed all mockup and reference PNGs exist and report valid dimensions.
- Opened gallery in the in-app browser at `file:///Users/jojolim/Developer/products/speaklocal/app-family/docs/design/browse-search/index.html`.
- Confirmed gallery has 6 mockup images and 3 reference links.
- Confirmed all local `src`/`href` references in the gallery resolve.
- Ran `git diff --check` and `git diff --cached --check` with no errors before the design packet commit.

## Recommended Native UI Implementation Task

Create `TASK-BROWSE-SEARCH-NATIVE-UI-001`:

- Add a dedicated `BrowsePageView` route and wire the bottom Browse icon to it.
- Implement Browse default and scrolled structures from the packet using native SwiftUI/Liquid Glass components.
- Change Search presentation so initial open is not auto-focused.
- Implement Search default shelves, focused keyboard behavior, query results, and no-match recovery from existing phrase catalog/search services.
- Preserve the current bottom admin chrome and Search island placement from the 2026-05-01 simulator reference shots.
