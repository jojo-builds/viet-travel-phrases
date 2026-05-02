# SpeakLocal App Icon V3: Speaker Mark

This pass swaps the previous waveform badge for the audio cue used throughout the app: a red `speaker.wave.2.fill`-style speaker inside a glass button.

The goal is to make the icon feel like SpeakLocal Vietnam itself: a premium offline audio phrasebook, not a generic audio app or a video/play app.

## Recommendation

Move forward with **A Glass** and **B Glass**:

- **A Glass:** safest and most product-faithful. It reads as phrasebook/audio utility first.
- **B Glass:** best if Melo should remain part of the app-family identity. Melo is still only a tail/progress cue, not a mascot takeover.
- **B Red Alt:** keep only as a tiny-size alternate. It is more legible at small sizes, but less faithful to the native app speaker button.

## Country Family Model

Keep the foreground stable:

- white phrase card;
- glass speaker button;
- red speaker glyph;
- jade saved/progress cue.

Then vary the country background:

- Vietnam: lotus/coast/Hanoi or Ha Long references.
- Philippines: island, sun, water, palms.
- Italy: green landscape, arches, old-city/cypress cues.
- Germany: charcoal forest, rail, mountain/route cues.
- Japan: indigo, wave, sun, blossom/mountain cues.

This keeps the apps related while letting each country feel local.

## Files

- `index.html` - review gallery.
- `assets/speaker-country-family-glass.png` - family comparison across countries.
- `assets/speaker-treatment-vietnam-comparison.png` - waveform vs glass speaker vs red-disc speaker.
- `assets/speaker-home-context-vietnam.png` - Vietnam candidates in context.
- `assets/speaker-small-size-vietnam-candidates.png` - compression check.
- `assets/option-*-speaker-glass.png` - annotated option sheets.
- `assets/source-derived/*.png` - derived source sheets from the previous v2 concepts.
- `assets/icon-crops/*.png` - cropped icon candidates used in the review sheets.

## Method

No new app code was edited. These are visual-direction assets derived from the v2 icon sheets with a deterministic speaker-mark overlay based on the current native `AudioSpeakerButton` cue.
