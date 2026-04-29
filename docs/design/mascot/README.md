# Speak Local Chameleon Mascot Visual System

Status: design direction and visual review surface for `TASK-MASCOT-VISUAL-SYSTEM-001`
Last updated: 2026-04-29

## Review Surface

- Local board: `docs/design/mascot/mascot-visual-system.html`
- Locked Melo board: `docs/design/mascot/melo-bucket-list-concepts/index.html`
- Full board capture: `docs/design/mascot/assets/mascot-visual-system-board.png`
- App-flow composites:
  - `docs/design/mascot/assets/practice-hub-with-mascot.png`
  - `docs/design/mascot/assets/normal-prompt-mascot-progress.png`
  - `docs/design/mascot/assets/missed-review-no-mascot.png`
  - `docs/design/mascot/assets/completion-bucket-list-stamp.png`
  - `docs/design/mascot/assets/listing-add-to-practice-entry.png`
- Prompt packet: `docs/design/mascot/prompt-packet.md`

To review in a browser from the repo root:

```bash
python3 -m http.server 8787
```

Then open `http://127.0.0.1:8787/docs/design/mascot/mascot-visual-system.html`.

## Source References

- `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`
- `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md`
- `docs/research/TOOLBOX.md`
- `docs/design/practice-quiz-concepts/README.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/DECISIONS.md`
- `docs/PRIORITIES.md`
- `docs/V2_BASELINE.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `native-ios/App/Design/NativeGlass.swift`

## Art Direction Summary

The mascot is a chameleon traveler that gradually picks up local motif details as the user rehearses real Vietnamese phrase knowledge. It should feel like a calm companion for an offline travel phrasebook, not a course-game avatar.

The base character keeps a stable silhouette: sage body, cream underside, rounded chameleon eye, curled tail, and a small travel satchel. Vietnam adaptation starts with a restrained jade or sea-glass body tint. Mid-progress can add ceramic-scale hints, a small red/gold travel patch, or a soft lotus cue. Completion can add lantern warmth and a slightly richer motif density. The mascot should never become a flag, costume, badge, prize token, or progress economy.

## Keep

- Stable base silhouette across every destination.
- Jade and sea-glass as the main Vietnam progression cue.
- Small red/gold accents on travel details only.
- Ceramic, lotus, lantern, and travel-memory hints as subtle motif layers.
- Completion language tied to phrase readiness, source pages, and Bucket List Stamps.
- Mascot placement in Practice hub, optional eligible standard prompts, calm empty states, and completion.

## Avoid

- Flag body paint, costume hats, or country caricature.
- Confetti, coins, XP, level numbers, streak pressure, leaderboards, lives, or punitive "wrong" energy.
- Mascot takeover of phrase reading, search, playback, bottom chrome, monetization, or sensitive contexts.
- In-prompt mascots that compete with Vietnamese answer choices.
- A new mascot-first navigation system before Practice has native runtime proof.

## Sensitive Context Rule

Emergency, medical, police, harassment, safety, money-dispute, and high-stress prompts should hide the mascot or reduce it to a neutral progress marker. Missed feedback in those contexts should show the correct phrase, why it fits, and the source page link without cheerful mascot expression or red failure styling.

## Native SwiftUI Translation

Later native work should treat this as an asset and placement contract, not a complete implementation. Recommended native shape:

- `MascotAssetState`: `base`, `vietJadeTint`, `vietMotif`, `vietCompletion`, `subdued`.
- `MascotVisibilityContext`: `practiceHub`, `standardPrompt`, `completion`, `emptyState`, `listingEntry`, `sensitiveHidden`.
- Gate visibility from `tags.mascotEligible`, prompt sensitivity, and source context.
- Keep mascot views out of `AppChromeLayout` bottom/search chrome.
- Use SF typography and existing `NativeGlass` surfaces; do not carry the web mock's exact CSS sizing or phone frame literally into SwiftUI.
- Keep progress state local and keyed to source-anchored practice events, not app opens or streaks.

## Visual Decisions

- The Practice hub can show the largest mascot treatment, but still as one compact companion row next to a bucket-list card.
- Normal prompts should use a tiny mascot/progress mark only when the prompt is standard-sensitivity and layout has room.
- Missed feedback should use no mascot by default. It should say the item was saved for calm review.
- Completion can show a small reward reveal, but the copy should be "Vietnam Bucket List updated" and "Jade Bucket List Stamp unlocked" rather than "Level up."
- Listing pages can show `Add to practice` without adding the mascot. The page remains a reading and audio surface.

## Context Sent Outside Codex

None. This pass used repo-local docs, HTML/CSS/SVG-style composites, and local screenshot capture. No private screenshots, app code snippets, or repo files were sent to external ChatGPT or third-party image tools.
