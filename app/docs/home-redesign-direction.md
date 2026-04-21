# Home Redesign Direction

Last updated: 2026-04-21
Scope: Viet home-screen design lab before rolling changes to the rest of the SpeakLocal family

## Purpose

Capture the current preferred direction for the SpeakLocal home and phrase-detail experience so future design/code passes do not have to reconstruct it from chat history.

See also:

- `app/docs/phrase-page-blueprint.md` for the deeper phrase-detail product thesis, navigation model, and section blueprint

## Current reference inputs

- YouTube / transcript inspiration:
  - `C:\Users\Administrator\Downloads\UI UX Phrasebook.txt`
- User testing / live app notes:
  - `https://docs.google.com/document/d/111E7kPxDlT1V0hjtG5Hy7A6clNq2z-RnOuwuML9qHx0/edit?tab=t.0`
- Current favored concept screenshot:
  - `C:\Users\Administrator\Downloads\hf_20260420_160238_395b336a-1781-43b6-8b80-4a7fbd19816e.png`
- Grab filter-rail reference:
  - search bar fixed at top with horizontal filters directly underneath

## What feels right now

- The redesign direction is clearly better than the current sterile, card-heavy home.
- Situations should feel like lightweight filters, not a giant labeled content section.
- A very rounded iPhone-style search bar feels right and should be the dominant top element.
- Circular situation items help visually separate the filter layer from the phrase cards below.
- A two-row horizontal carousel of situations currently feels best.
- Pagination dots or another subtle cue that more items exist to the right is good.
- Compact phrase cards on home are good when they feel tappable and lead into a richer full page.
- Arrows / chevrons on compact phrase cards feel more intuitive than play buttons.
- Small icons inside compact phrase cards are good.
- The full phrase page should feel like the premium payoff.

## Home screen preferences

- Do not rely on a large persistent `SpeakLocal Vietnam` title inside the app header.
- Assume branding can live on a splash / loading screen instead.
- Keep search visible as a primary control on home and deeper screens.
- Avoid the current row of `Unlocked`, `Premium Features`, and `Offline Mode` status blocks.
- If premium messaging appears on home, test one subtle CTA only:
  - `7 days free`
  - `Try free`
  - similar single-pill treatment
- Situations should not need a section label like `Situations`.
- Situations are better framed as filters for the phrase content below.
- Default home flow should behave like `All` is selected.
- On scroll / filtered state, search should stay pinned at the top and the filter rail should sit directly beneath it.
- The filter rail behavior should feel closer to Grab:
  - sticky search
  - horizontally scrollable filter chips / items underneath
  - one active filter highlighted
- Phrase cards on home should be compact, fast to scan, and not overloaded.
- Compact phrase cards should not use a play button as the primary affordance.
- The whole compact phrase card should read as tappable and opening a deeper page.
- Homepage content should remain uncluttered even if the deeper phrase page is richer.

## Phrase detail page preferences

- Phrase detail must open as a full dedicated page.
- Do not use a bottom sheet, half card, or partial fold-up interaction.
- Keep the search bar available at the top of the phrase detail page too.
- A back arrow next to the search bar is desirable for one-level-back behavior.
- The upper half of the phrase page should be dominated by the main playback area.
- Save should be near the play controls for intuitive association.
- Use only `Save`, not a separate `Favorite` concept.
- Speed controls should be visible near playback:
  - `0.5x`
  - `0.75x`
  - `1.0x`
- The first variation should be the shortest `just get by` version.
- This shortest version is the minimum phrase needed for a local to understand the traveler.
- Examples:
  - `doctor`
  - `pharmacy`
- If more variations exist, show them after the shortest one in a horizontal carousel / mini-card lane.
- `When you'd say this` should be plain text, not inside a card.
- Related phrases should live near the bottom in a horizontal scrolling lane.
- Tapping related phrases should open another full phrase page, allowing the user to keep drilling deeper card-to-card.

## Product / monetization preferences now under consideration

- The earlier home-status concepts like `Unlocked` and `Offline Mode` may not be worth showing at all.
- Premium framing may be better as:
  - `7 days free`
  - then one-time charge of `$4.99`
- If that model is adopted, avoid repeating premium-state/status messaging all over home.

## Visual system reset

- The current app color direction feels too scoped and too colored for the desired product tone.
- Preferred direction now is:
  - mostly white
  - very light gray structure
  - dark readable text
  - country colors used as accents only, not the main surface color
- For Vietnam specifically, use the country colors as restrained accents:
  - red
  - yellow
- Avoid heavy cream, overly warm beige, or large tinted surfaces dominating the UI.
- The goal is a simpler, cleaner, more iPhone-native visual base with localized accent personality.
- Dark mode can exist later as a mirror system, but should not drive the current design direction.

## Liquid Glass direction

- The app should now lean much more heavily into a native iOS feel informed by Apple's Liquid Glass design system.
- Treat Liquid Glass as a navigation-and-controls layer, not as the main content surface.
- Follow the Apple separation:
  - content layer = mostly white / very light gray / standard material structure
  - functional layer = glass for navigation, search, tab bars, floating controls, and important control groups
- Do not turn every card, section, or content block into glass.
- Use glass sparingly and only where it improves hierarchy, focus, and touch affordance.
- Favor rounded, floating forms that feel concentric with modern iPhone hardware.
- Search should follow Apple conventions instead of a one-rule-only placement:
  - search can live in a tab bar, toolbar, or inline with content depending on the flow
  - do not force bottom search everywhere just because some Apple apps use it
- For SpeakLocal, current likely pattern is:
  - global search should stay highly accessible and may become a bottom/tab-bar-led or floating control in the broader browsing experience
  - phrase-detail search can remain in the top shell when that is clearer and calmer
- Motion should feel fluid and relationship-based:
  - taps should expand from the touched element when possible
  - controls should feel like they live on one floating plane
  - avoid generic slide-only transitions when a tighter relationship can be shown
- Vietnam red and yellow should remain restrained accent tints inside the system, not full-surface colors.
- The white / light-gray base remains correct; Liquid Glass is an interaction layer on top of that base, not a replacement for it.
- The website should borrow the spirit of this system, not mimic native iOS literally everywhere:
  - light neutral base
  - selective frosted navigation / action surfaces
  - strong clarity first
  - avoid turning the website into a fake iPhone UI

## Mascot direction now under consideration

- New strongest mascot candidate is a single adaptive `SpeakLocal` mascot rather than a fixed main-plus-sidekick system.
- Current preferred mascot concept:
  - a chameleon / cultural-adaptation mascot
  - one canonical base character for the whole brand
  - each country app applies localized accent colors, patterning, and visual motifs to the same mascot
- This mascot should visually communicate:
  - travel
  - adaptation
  - communication across cultures
  - learning and unlocking over time
- Preferred product behavior:
  - mascot begins in a simpler base state
  - localized markings / tattoo-like pattern details can evolve as the user uses the app more
  - progression should feel like character growth, not aggressive game clutter
- The country-specific treatment should not rely on full costume changes or tourist-postcard stereotypes.
- Instead, country identity should come from restrained:
  - accent colors
  - pattern language
  - subtle cultural motifs
- For Vietnam specifically, keep the new white / light-gray UI base and use restrained red and yellow accent treatment on the mascot variant.
- The mascot should stay anatomically clean and consistent:
  - no extra legs
  - no broken tail placement
  - no anatomy drift between poses
- The mascot should usually live as content or illustration near the glass layer, not inside glass controls themselves.
- If used with Liquid Glass, prefer:
  - peeking from behind a glass search/control cluster
  - subtle parallax / progress moments
  - supportive empty-state or onboarding presence
- Avoid:
  - putting the mascot inside the main chrome in a way that hurts legibility
  - overanimating the mascot in high-stress utility moments
- Reference-sheet work should now focus on:
  - a canonical base mascot sheet first
  - then country variant sheets such as Vietnam
  - then later scene sheets and UI placements

## Open questions still worth testing visually

- Two-row circle carousel vs. a tighter hybrid filter treatment after scroll.
- Exact premium CTA wording on home.
- Whether the bottom nav should shrink / hide during downward scroll in the same motion family as the sticky search.
- Exact visual treatment of the shortest `just get by` phrase versus other alternate versions.

## Current design principle

Make the app feel like:

- search-first
- situation-filtered
- card-to-card exploration
- fast under stress
- premium through calm hierarchy and depth, not through more labels or more chrome
