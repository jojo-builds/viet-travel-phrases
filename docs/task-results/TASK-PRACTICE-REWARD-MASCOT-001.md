# TASK-PRACTICE-REWARD-MASCOT-001 Result

## Status

done

## Commit Hash

Recorded in the worker final reply after commit creation. The committed result file cannot know its own final Git hash before it is staged and committed.

## Reward Loop Summary

The first Practice reward loop is a local readiness route, not XP. Users earn ready prompt marks by answering source-anchored Vietnamese practice prompts correctly, and missed prompts become calm review prompts rather than penalties. A Viet route mark unlocks when enough ready prompt marks are earned across more than one canonical phrase page; the first visual unlock is a restrained Jade route tint.

The loop stays tied to language learning because progress is keyed to `items[].id`, `source.phraseID`, `source.pageID`, `source.familyID`, `questionType`, and local ready/review results. Opening Practice, tapping through screens, or maintaining streaks does not award progress.

## Mascot Usage Rules

The chameleon traveler appears only as a compact Practice companion on the hub, eligible standard prompts, completion, and gentle empty states. It stays absent or subdued for emergency, safety, medical, harassment, police, high-stress, search, source reading, playback, bottom chrome, and monetization surfaces.

For Vietnam, the mascot adapts through restrained jade/sea-glass tinting, a small travel-satchel motif, soft lotus/ceramic pattern language, and warm completion light. Final art should avoid flag-like stars, costumes, public ranking energy, confetti, or childish game-token treatment.

## Prototype And Mock Artifact Paths

- `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`
- `prototypes/practice-quiz/index.html`
- `prototypes/practice-quiz/app.js`
- `prototypes/practice-quiz/styles.css`
- `docs/task-results/assets/TASK-PRACTICE-REWARD-MASCOT-001/practice-reward-hub.png`
- `docs/task-results/assets/TASK-PRACTICE-REWARD-MASCOT-001/practice-reward-missed-feedback.png`
- `docs/task-results/assets/TASK-PRACTICE-REWARD-MASCOT-001/practice-reward-completion.png`

## Implementation Handoff

For the `Practice / Quiz` lane:

- Store local readiness outside the read-only bundled deck, keyed by `items[].id` and `source.phraseID`.
- Rank return-to-practice by missed prompts, explicitly practice-selected phrases, saved/recent phrases, confidence-building ready prompts, then graph-nearby recommendations.
- Keep selected phrases as the correct-answer targets; use related phrases only as distractors or recommendations.
- Gate mascot visibility through both `tags.mascotEligible` and sensitivity.
- Build native Practice as one prompt surface, one answer area, one compact readiness strip, and static glass chrome.
- Use route-mark copy and local source counts instead of XP, streak anxiety, lives, public leaderboards, or currency.
- Treat the CSS chameleon as a behavior/layout placeholder only; final mascot art needs a separate asset-direction task.

## Peer Review Outcome

CONCERNS, addressed before closeout.

The read-only reviewer found that the core loop supports language learning and that the mascot direction is compact and not too busy. The reviewer flagged three polish concerns: ready prompts were being described too loosely as source phrases, the missed-feedback mock needed the correct Vietnamese explanation visible above the fold, and the red/gold satchel patch risked reading like a flag/game token. The closeout patch changed the prototype copy to distinguish ready prompts from phrase pages, regenerated the missed-feedback mock with the Vietnamese explanation visible, and simplified the satchel motif.

Residual native note from review: do not carry the web phone frame, serif hero styling, or heavy red CTA literally into SwiftUI. Map the contract to native materials, SF typography, and calmer primary actions.

## Validation Commands And Outcomes

- `node scripts/practice/generate-viet-practice-deck.test.js` -> passed; 70 items, 14 scenarios, 7 question types.
- `node scripts/practice/generate-viet-practice-deck.js --check` -> passed; generated deck stayed deterministic.
- `node --check prototypes/practice-quiz/app.js` -> passed.
- `python3 -m http.server 8787` plus `curl -I http://127.0.0.1:8787/prototypes/practice-quiz/` -> passed with HTTP 200.
- In-app browser DOM check of the prototype -> passed; reward hub loaded, standard prompt showed route mark eligibility, missed feedback showed `0 ready prompts / 1 review` and calm review copy.
- Native-ready mock screenshots regenerated and visually checked.
- `git diff --check` -> passed.

## Recommended Next Task

`TASK-PRACTICE-NATIVE-MVP-001`: implement the native offline Practice MVP with local readiness state, saved/practice-selected phrase entry points, missed-review ordering, and sensitivity-gated mascot placeholder surfaces.
