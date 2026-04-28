# T-137 grouped listing-card notes

## What changed

- Reworked the lower half of the phrase product preview so it no longer reads like a stack of large rounded cards.
- Kept the hero shell and dedicated search page intact while changing only the lower content treatment.
- Shifted each lower section toward a lighter grouped system:
  - `Quick say` is now a compact in-place hero swap card.
  - `Break it down` is now a grouped mini-tile cluster.
  - `Other ways` is now a wrap grid of smaller same-family tiles.
  - `When to say` is now a light contextual inset.
  - `Next` is now a grouped forward-row list instead of another chunky card rail.

## Hierarchy decisions

- The hero remains the strongest playback surface; no new large play affordances were added lower on the page.
- Same-family options still update the hero in place rather than pushing a new page.
- `Next` keeps the deeper-navigation role and now uses a more directional row treatment to make that difference obvious.
- Every non-English lower item still keeps English directly underneath it.

## Supporting truth updates

- Updated `previewContent.ts` so `Preview 02` describes the grouped lower listing-card direction.
- Updated `phrase-page-blueprint.md` to describe compact hero-swap cards, grouped mini-cards, light contextual inset treatment, and grouped forward rows.

## Verification notes

- `npx --no-install tsc --noEmit` passed after the layout changes.
- `npx expo export --platform web --output-dir dist-task-T137-check` passed after the layout changes.
- Exported bundle checks confirmed the preview lane still includes the updated `Preview 02` copy and `design-preview` routes.
