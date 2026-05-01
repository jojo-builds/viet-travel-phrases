# Native Visual Reference

This is the first stop for any SpeakLocal native visual design, mascot, onboarding, Practice, or screenshot-composition task.

The goal is not "make something iOS-ish." The goal is to match the current SpeakLocal native app direction closely enough that a new screen or generated concept could plausibly sit beside the live app.

## Accepted Live References

Use these as the current visual baseline:

| Surface | Reference |
| --- | --- |
| Native Home | `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/home-normal-launch.png` |
| Native Browse | `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/browse-normal-launch.png` |
| Native Search | `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/search-normal-launch.png` |
| Current Home/admin chrome, iPhone 17 Pro simulator, 2026-05-01 | `docs/design/reference-shots/2026-05-01/native-home-chrome.png` |
| Current Browse-selected admin chrome, iPhone 17 Pro simulator, 2026-05-01 | `docs/design/reference-shots/2026-05-01/native-browse-chrome.png` |
| Current Search-expanded chrome, iPhone 17 Pro simulator, 2026-05-01 | `docs/design/reference-shots/2026-05-01/native-search-expanded-chrome.png` |
| Phrase listing/article page | `docs/task-results/assets/TASK-SQLITE-DEFAULT-RUNTIME-001/detail-alias-normal-launch.png` |
| SQLite alias launch proof | `docs/task-results/TASK-SQLITE-PROMOTION-001-sqlite-alias-launch.png` |

If a task needs fresher references, capture new simulator screenshots first and add them under `docs/design/reference-shots/YYYY-MM-DD/` or a task-result asset folder, then update this table.

## Current Visual Language

- Native iOS first: screens should feel like an iPhone app, not a responsive webpage, slide deck, or generic prototype.
- Liquid Glass chrome: bottom toolbar, search island, back/forward glass buttons, and playback dock should feel translucent, layered, and touchable.
- Chrome stays visually stable: page content animates beneath bottom chrome and top buttons instead of dragging the chrome layer around.
- Readability wins: text sits on clean white or near-white surfaces. Hero imagery should fade into white and never fight phrase text.
- Phrase pages use a strong editorial hero: large black high-contrast phrase title, subdued gray English/pronunciation, then a glass playback dock.
- Cards are soft, quiet, and useful. Avoid busy stacked panels, loud gradients, game-like reward clutter, and decorative blobs.
- Accent colors are restrained Vietnam cues: red for primary action/audio, small gold/yellow highlights, blue/jade only when it has a clear semantic role.
- Speaker icons mean playable audio. Chevron arrows mean navigation to a canonical phrase page.
- The app should feel premium and calm for a first-time traveler. Helpful can be warm; it should not become childish.

## Mascot-Specific Fit

The chameleon mascot is a restrained travel companion, not the product itself.

- It may appear in Practice, progress/completion, and friendly empty states.
- It should not live in bottom chrome, playback controls, search chrome, or phrase-reading surfaces where it competes with learning.
- It should be hidden or reduced to a neutral mark for medical, emergency, safety, police, harassment, or high-stress contexts.
- Vietnam progression should be subtle: jade/sea-glass tint, small motif details, warm completion light. Avoid costumes, flag body paint, coins, XP, confetti, streak pressure, or childish victory poses.

## Rejected Or Placeholder References

These are not accepted as final visual direction:

- `docs/design/mascot/assets/**`
- `docs/design/mascot/mascot-visual-system.html`
- `docs/design/practice-quiz-concepts/assets/prototype.html.png`

Those files can still be useful for rough behavior notes or copy/history, but they should not be treated as visual quality bars. Any future mascot or quiz visual task must produce production-ready raster images or real native screenshots before implementation.

## Visual Task Bar

Before a visual task is sent to Jojo for review:

- Use the accepted live references above.
- Produce actual screenshots or generated raster images, not only prose or code-native placeholders.
- Include a Jojo-readable contact sheet, local review page, or direct image paths.
- Run at least one focused peer review for native fit, placeholder text, busy layout, and whether the copy sounds human to a first-time traveler.
- If the worker cannot produce production-ready visuals with available tools, block honestly instead of filling the gap with rough diagrams.
