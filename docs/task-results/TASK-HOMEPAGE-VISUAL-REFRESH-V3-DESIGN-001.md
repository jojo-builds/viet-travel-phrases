# TASK-HOMEPAGE-VISUAL-REFRESH-V3-DESIGN-001

Status: complete

## Commit

- Design packet commit: `9f50a0a91cacc467a00a7ff2e2f2db207e80b110`

## Artifacts

- Packet: `docs/design/homepage/visual-refresh-v3/`
- Gallery: `docs/design/homepage/visual-refresh-v3/index.html`
- README: `docs/design/homepage/visual-refresh-v3/README.md`
- Peer review: `docs/design/homepage/visual-refresh-v3/peer-review.md`
- Contact sheet: `docs/design/homepage/visual-refresh-v3/assets/homepage-v3-contact-sheet.png`
- Content rules: `docs/design/homepage/visual-refresh-v3/assets/home-v3-content-rules.png`

## Screens Included

- `docs/design/homepage/visual-refresh-v3/assets/screens/home-v3-top.png`
- `docs/design/homepage/visual-refresh-v3/assets/screens/home-v3-discovery.png`
- `docs/design/homepage/visual-refresh-v3/assets/screens/home-v3-lower.png`

## Native References

- Final locked chrome reference: `docs/design/homepage/visual-refresh-v3/assets/reference/locked-native-home-chrome-reference.png`
- Fresh simulator capture: `docs/design/homepage/visual-refresh-v3/assets/reference/fresh-simulator-home-reference.png`

The fresh simulator reference was captured during the task, but the worktree had unrelated native chrome changes at the time. The final V3 comps use the durable 2026-05-01 locked reference so the packet stays aligned with the established four-item bottom admin bar and bottom Search island.

## Recommendation

Implement the **Native-Locked Utility Home**:

- preserve current Home hero, native Search entry, bottom admin bar, and bottom Search island;
- order Home content as Search, starter phrases, image-led city/category discovery, then lower shelves;
- remove duplicate decorative card icons;
- keep one speaker affordance for audio and chevrons for navigation;
- route image cards to Browse collection pages, not Search;
- keep returning-user modules state-gated;
- keep Melo off Home.

## Native UI Implementation Notes

- Update Home content ordering and card affordances only.
- Do not redesign `AppChrome`, bottom admin/search chrome, status chrome, or hero treatment.
- `HomePhraseCard` should drop decorative `symbolName` in compact phrase cards.
- `AudioSpeakerButton` remains the only audio affordance.
- Add a small image-led Browse collection shelf below starter phrases using existing assets:
  - `BrowseCollectionHanoi`
  - `BrowseCollectionAirport`
  - `BrowseCollectionHotel`
  - `BrowseCollectionFood`
  - `BrowseCollectionShopping`

## Peer Review

Focused peer review passed for:

- native match;
- chrome fidelity, with the bottom chrome documented as a raster placeholder;
- phrasebook utility first;
- duplicate icon removal;
- copy clarity;
- image discovery;
- implementation readiness;
- mascot restraint;
- docs-only scope containment.

## Validation

- Gallery references resolved locally: `refs=9 missing=0`.
- Phone screenshot dimensions match native reference dimensions: `1206 x 2622`.
- Contact sheet dimensions: `5600 x 3600`.
- Content rules dimensions: `3600 x 2050`.
- Pixel/crop check passed against locked native reference:
  - top hero/status/search region exact for `home-v3-top.png`;
  - bottom admin dock inner crop exact for all three phone screens;
  - bottom Search island inner crop exact for all three phone screens;
  - home indicator crop exact for all three phone screens.
- `git diff --check` passed.
- Staged files for the design commit were limited to `docs/design/homepage/visual-refresh-v3/**`.

No Swift build or app test suite was run because this was a docs/design packet only.

## Recommended Next Task

Create a Native UI task to implement V3 Home:

- clean compact Home phrase cards;
- reorder first-launch Home sections;
- add the image-led Browse collection shelf;
- preserve current chrome and route model;
- verify with simulator screenshots against this packet.
