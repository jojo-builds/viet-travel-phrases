# Speak Local Mascot High-Fidelity Concepts

Status: production-ready raster concept review packet for `TASK-MASCOT-HIGH-FIDELITY-CONCEPTS-001`
Last updated: 2026-04-29

## Review Surface

- Contact sheet PNG: `docs/design/mascot/high-fidelity/contact-sheet.png`
- Local browser review page: `docs/design/mascot/high-fidelity/index.html`
- Prompt packet: `docs/design/mascot/high-fidelity/prompt-packet.md`

To review locally from the repo root:

```bash
python3 -m http.server 8787
```

Then open `http://127.0.0.1:8787/docs/design/mascot/high-fidelity/index.html`.

## Final Image Artifacts

Required mascot progression:

- `docs/design/mascot/high-fidelity/assets/mascot-base-traveler.png`
- `docs/design/mascot/high-fidelity/assets/mascot-early-vietnam-jade.png`
- `docs/design/mascot/high-fidelity/assets/mascot-mid-vietnam-motif.png`
- `docs/design/mascot/high-fidelity/assets/mascot-completion-lantern.png`

Required native app screen comps:

- `docs/design/mascot/high-fidelity/assets/screen-practice-hub.png`
- `docs/design/mascot/high-fidelity/assets/screen-normal-prompt.png`
- `docs/design/mascot/high-fidelity/assets/screen-practice-completion.png`
- `docs/design/mascot/high-fidelity/assets/screen-listing-add-to-practice.png`

Optional sensitive-context comp:

- `docs/design/mascot/high-fidelity/assets/screen-sensitive-no-mascot.png`

## Source References Preserved

- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`
- `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md`
- `docs/design/mascot/prompt-packet.md` as starting prompts only
- Accepted current app screenshots under `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/`

## Visual Verdict

Keep the 3D tactile chameleon direction. It is a large quality jump over the rejected placeholder board: the mascot now has material texture, a stable silhouette, app-asset depth, and a warmer premium travel-companion posture. The base and early jade states are the strongest production candidates because they feel adult, calm, and usable inside a native phrasebook.

Use the mid and completion states as direction, not final export. The mid state lands the ceramic-scale and lotus-satchel idea well. The completion mascot is visually rich and reviewable, but future production art should simplify the lotus/gold ornament density so the mascot does not become a collectible character.

Keep the Practice hub and listing-page comps as the native integration direction. They are closest to the accepted Speak Local app language: Ha Long masthead, large black editorial type, white readable cards, red action accents, and Liquid Glass-style bottom chrome. The normal prompt comp is useful for spacing and "tiny mascot progress mark" direction, though native implementation should use SF typography rather than inheriting the generated serif look wholesale. The completion comp is directionally good but should reduce mascot/card visual weight in SwiftUI. The sensitive-context comp is the clearest rule proof: no mascot, calm review copy, source link, and phrase clarity first.

Reject the two discarded generated variants from this pass:

- A Practice hub variant where the chameleon sat too close to cute-game territory.
- A completion variant where the mascot wore/evoked tourist-costume energy and the reward card felt too game-like.

## Native Translation Notes

- Build future native assets from the `mascot-base-traveler`, `mascot-early-vietnam-jade`, and `mascot-mid-vietnam-motif` direction first.
- Keep the chameleon out of source phrase reading, playback chrome, search chrome, and bottom chrome.
- Use the mascot at Practice hub scale, tiny eligible-prompt Bucket List Stamp scale, and compact completion-card scale.
- For medical, emergency, police, harassment, safety, or high-stress contexts, use the no-mascot treatment from `screen-sensitive-no-mascot.png`.
- The screen comps are concept images, not exact UI specs. Native SwiftUI should preserve the accepted app structure, SF typography, source-anchored readiness language, and calm red/jade accent system.

## Tool And Context Notes

- Generated with Codex built-in image generation.
- Contact sheet generated locally from imported PNGs.
- External context sent: none.
- No ChatGPT browser, external image site, external manual prompt handoff, SwiftUI implementation, SQLite/runtime/content edit, or placeholder HTML/SVG final asset was used.
