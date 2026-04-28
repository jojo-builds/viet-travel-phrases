# T-162 Result

## Status

Done.

## Summary

Created the practice quiz concept packet and static browser prototype under `docs/design/practice-quiz-concepts/`.

The final direction is language-first: every quiz prompt requires Vietnamese listening recognition or Vietnamese phrase choice, choices show Vietnamese first, and English meanings/explanations reveal only after selection. The prototype now feels like an interactive phrasebook extension rather than a travel etiquette quiz.

## Files Changed

- `docs/design/practice-quiz-concepts/README.md`
- `docs/design/practice-quiz-concepts/prototype.html`
- `docs/design/practice-quiz-concepts/assets/.gitkeep`
- `docs/design/practice-quiz-concepts/assets/prototype.html.png`
- `.agent/tasks/T-162/state.json`
- `.agent/tasks/T-162/result.md`
- `.agent/tasks/T-162/reviews/**`

## Visual / Source References Inspected

- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `native-ios/AGENTS.md`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Views/PhraseDetailView.swift`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/App/Design/NativeGlass.swift`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-audio-manifest.json`
- `native-ios/Resources/Assets.xcassets`

## Recommendation

Primary: `Glass Rehearsal Deck`.

Fallback: `Market Mission`.

Keep `Chameleon Passport` as the quiet progression layer, not the main practice navigation model.

## Verification

- `node --check` on the extracted prototype script: pass.
- Python `HTMLParser` feed for `prototype.html`: pass.
- `qlmanage -t -s 390` generated `assets/prototype.html.png`: pass.
- Local static preview served with `python3 -m http.server 8792 -d docs/design/practice-quiz-concepts` and verified by `curl`: pass; server stopped afterward.
- `git diff --check`: pass before closeout.
- `git diff --cached --check`: pass for the T-162 staged scope before closeout.
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`: pass.
- JSON validation for `.agent/tasks/T-162/state.json`: pass before finish; final validation repeated after finish.

Preview note: Codex in-app browser backend was unavailable and local Playwright/Chrome were not installed, so browser validation used Quick Look thumbnail generation, local static server, `curl`, and read-only reviewer browser checks where available.

## Review Gates

Gate 1 latest approved pass: `gate-01-pass-03`.

- Native iOS / Liquid Glass parity: approve.
- Traveler learning utility: approve.
- Mascot / reward tone: approve.
- Current app fit: approve.

Gate 2 latest approved pass: `gate-02-pass-07`.

- SwiftUI implementation readiness: approve.
- Offline practice-data fit: approve.
- Source truth / queue scope: approve.
- Accessibility / readability: approve.

Gate 3 latest approved pass: `gate-03-pass-02`.

- Five-concept comparison: approve.
- Browser prototype usability: approve.
- Chameleon progression: approve.
- Jojo-reviewability: approve.

## Process Feedback

- BUG: Early prototype/review iterations drifted toward travel-common-sense prompts and visible design-handoff copy. Corrected by making the prototype Vietnamese-first, hiding English answer detail before selection, rewriting user-facing feedback, and showing mascot progress without crowding the answer area.

Concurrency note: another desktop automation was working T-164 in the same repository during closeout. T-162 commit scope should use explicit paths and exclude `.agent/coordination/queue-index.json`, `.agent/tasks/T-164/**`, `docs/design/homepage-research/**`, and other unrelated staged files.
