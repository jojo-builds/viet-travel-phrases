# App Preview Wireframes

Native-first App Preview wireframes now live inside the Expo app as hidden routes, and the same deck is also exposed through a `/design-preview` entrypoint for faster visual review on Expo web.

## Open the deck

- index: `/app-preview-wireframes`
- slide 1: `/app-preview-wireframes/home`
- slide 2: `/app-preview-wireframes/phrase`
- slide 3: `/app-preview-wireframes/search`
- slide 4: `/app-preview-wireframes/saved`
- slide 5: `/app-preview-wireframes/premium`
- design preview index: `/design-preview`
- design preview slide 1: `/design-preview/home`
- design preview slide 2: `/design-preview/phrase`
- design preview slide 3: `/design-preview/search`
- design preview slide 4: `/design-preview/saved`
- design preview slide 5: `/design-preview/premium`

## Intent

- These routes are wireframe concepts for native review and capture.
- They inherit the current SpeakLocal Vietnam design language instead of introducing a separate marketing-only visual system.
- They are safe sidecar artifacts: no premium logic, build config, or release wiring changed.

## Slide story

- `home`
  - situation-first landing with live free-vs-full counts
- `phrase`
  - interactive phrase product page with hero playback, in-place variant swaps, and deeper `Next` navigation
- `search`
  - fast retrieval with situation context still visible
- `saved`
  - quick-access favorites and offline reassurance
- `premium`
  - one-time unlock depth without subscription framing

## Capture note

- Open a slide route on device and use the platform back gesture to return to the deck index.
- For the quickest Windows review loop, run Expo web and open `/design-preview`.
- Treat these as composition references first; final App Store screenshot polish can strip or refine any preview-only labels after review.
