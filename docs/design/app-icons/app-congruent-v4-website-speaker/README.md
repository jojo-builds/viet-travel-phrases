# SpeakLocal App Icon V4: Website Speaker Mark

This pass replaces the previous red waveform circle and the SF-style speaker mark with a website-style `volume-high` speaker cue, matching the legacy/web `AudioPlayButton` direction in `app/components/AudioPlayButton.tsx`.

The goal is to test whether the icon feels more like a real SpeakLocal phrasebook control: a phrase card with an audio button, not a generic sound-wave app.

## Recommendation

Use **A Subtle** or **B Subtle** for the next decision:

- **A Subtle:** best pure product fit. It reads as an audio phrasebook card.
- **B Subtle:** best if we want Melo’s tail/progress cue to be part of the long-term family identity.
- **B Solid:** more legible, but it brings back a strong red button block.
- **B Glyph:** cleaner, but it loses the clear tappable audio-button feeling.

## Country Family Model

The foreground system stays fixed:

- white phrase card;
- website-style `volume-high` speaker button;
- jade saved/progress cue;
- optional Melo tail only in the B row.

The country layer still changes behind it:

- Vietnam: lotus/red-jade travel layer.
- Philippines: blue island/sun layer.
- Italy: green arch/landscape layer.
- Germany: charcoal rail/forest layer.
- Japan: indigo wave/blossom layer.

## Files

- `index.html` - review gallery.
- `assets/website-speaker-country-family.png` - family comparison across countries.
- `assets/website-speaker-treatment-vietnam-comparison.png` - waveform vs website speaker treatments.
- `assets/website-speaker-home-context-vietnam.png` - Vietnam candidate context.
- `assets/website-speaker-small-size-vietnam.png` - compression check.
- `assets/option-*-website-speaker-subtle.png` - annotated country sheets.
- `assets/source-derived/*.png` - derived source sheets.
- `assets/icon-crops/*.png` - cropped candidates used in the review sheets.

## Design Read

This direction is closer to the website/legacy phrase-card audio control than v3. The subtle white-button variant is the best match to the app direction, while the solid red button is useful only if tiny-size testing shows the subtle icon is too quiet.
