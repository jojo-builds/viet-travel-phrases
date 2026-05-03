# Focused Peer Review

Review date: 2026-05-03
Scope: docs-only V3 native-locked homepage visual refresh packet.

## Checks

| Area | Outcome |
| --- | --- |
| Native match | Pass. V3 uses the locked 2026-05-01 native Home reference for the hero/search/bottom chrome instead of redrawing the app shell. |
| Chrome fidelity | Pass with caveat. The top hero/search pixels are preserved from the locked reference; the bottom admin/search layer is a masked live native chrome placeholder for raster review. Native implementation should use the real SwiftUI chrome directly. |
| Phrasebook utility first | Pass. Search remains first, starter phrases appear immediately after, and Browse discovery follows below. |
| Duplicate icon removal | Pass. Phrase cards use one speaker affordance plus a chevron; no decorative category/speaker icons compete with audio. |
| Copy clarity | Pass. Cards avoid implied action/type labels such as `Open`, `Play`, `City`, `Category`, and `Phrase page`. |
| Image discovery | Pass. Hanoi, Airport, Hotel, Food, and Shopping cards use existing image assets and are framed as Browse collection entries. |
| Implementation readiness | Pass. The work maps to Home ordering, `HomePhraseCard` cleanup, and a small Browse collection shelf. It should not require route-model or native chrome changes. |
| Mascot restraint | Pass. Melo does not appear on Home. |
| Scope containment | Pass. Packet changes are docs/design only. |

## Review Notes

- The fresh simulator reference was captured, but the dirty worktree included unrelated native chrome changes. The final packet therefore uses the durable locked reference to avoid baking in another task's unfinished chrome state.
- The bottom chrome in the PNG comps is a raster placeholder, not a final implementation target. The native task should keep the live SwiftUI bottom admin/search chrome.
- First launch should not show fake Continue, Saved, or Practice-pool modules. Those belong behind real local state.

## Recommendation

Proceed with a Native UI implementation task for V3. Start with compact phrase card cleanup, then Home section ordering, then image-led Browse collection cards.
