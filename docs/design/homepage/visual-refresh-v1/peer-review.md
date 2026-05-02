# Focused Peer Review

Review date: 2026-05-03
Scope: docs-only homepage visual refresh packet, V2 revision after Jojo browser annotations.

## Checks

| Area | Outcome |
| --- | --- |
| First-time traveler clarity | Pass. The recommended hybrid keeps Search and starter phrases in the first viewport and avoids fake returning-user shelves. |
| Native iOS / Liquid Glass fit | Pass with note. The comps use the current masthead, white glass cards, stable bottom dock/search island relationship, and restrained red/green accents. Native implementation should use real SwiftUI materials and live app chrome rather than copying the raster effects exactly. |
| Reduced visual clutter | Pass. The revision removes implied-action labels from cards and keeps speaker/chevron behavior implicit. |
| Audio versus navigation behavior | Pass. Speaker is clearly audio-only; chevron/text/card area handles navigation. Image cards do not show audio controls. |
| Category/city image handling | Pass. Image cards are Browse collection entry points and do not replace Search. |
| Realistic SwiftUI implementation | Pass. Most changes map to existing Home sections plus card styling/order changes. The image cards can reuse Browse collection asset-catalog images. |
| Mascot restraint | Pass. No mascot-led Home surface is recommended. |
| Jojo annotations | Pass. V2 addresses the called-out tags, the hard hero image seam, and the rough copied-toolbar artifact. |

## Concerns Addressed

- **Risk: image cards make Home too busy.** The packet recommends only a small image layer below essentials, not a full image grid as the lead.
- **Risk: first launch feels empty without saved/recent/practice.** The recommended first-launch state uses essentials, Search, and trip discovery; returning shelves remain state-gated.
- **Risk: speaker icons promise missing audio.** The implementation notes require speaker buttons only where bundled audio resolves.
- **Risk: raster chrome still differs from live SwiftUI chrome.** The packet now treats the raster chrome as a visual composition reference only; native implementation should reuse the live bottom/admin/search chrome directly.

## Recommendation

Proceed with a native implementation task for the Cleaner Hybrid Utility Home. The implementation should start by refactoring phrase-card affordances, then add a small image-led Browse collection layer, and only then add returning-user module refinements.
