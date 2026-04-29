# Result: T-169

## Status
- done
- Implementation commit hash: `e29ee3c`

## What changed
- Added the Viet Practice Core contract and native handoff doc at `docs/practice/VIET_PRACTICE_CORE_PLAN.md`.
- Added a deterministic deck generator and contract test in `scripts/practice/`.
- Generated the sample deck to `content-draft/viet/practice/practice-deck.sample.json` and mirrored it for the prototype at `prototypes/practice-quiz/practice-deck.sample.json`.
- Added a clickable browser prototype under `prototypes/practice-quiz/` with 5 realistic flows.
- Updated `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md` and `docs/DECISIONS.md` with the prepared Practice Core package note.

## Files changed
- `.agent/tasks/T-169/state.json`
- `.agent/tasks/T-169/result.md`
- `.agent/tasks/T-169/reviews/gate-1/pass-1/*.md`
- `.agent/tasks/T-169/reviews/gate-1/pass-2/*.md`
- `.agent/tasks/T-169/reviews/gate-2/pass-1/*.md`
- `.agent/tasks/T-169/reviews/gate-2/pass-2/*.md`
- `.agent/tasks/T-169/reviews/gate-2/pass-3/*.md`
- `docs/practice/VIET_PRACTICE_CORE_PLAN.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/DECISIONS.md`
- `content-draft/viet/practice/practice-deck.sample.json`
- `prototypes/practice-quiz/index.html`
- `prototypes/practice-quiz/styles.css`
- `prototypes/practice-quiz/app.js`
- `prototypes/practice-quiz/practice-deck.sample.json`
- `scripts/practice/generate-viet-practice-deck.js`
- `scripts/practice/generate-viet-practice-deck.test.js`

## Deck counts
- Items: `70`
- Scenarios/categories: `14`
- Question types: `7`
- Flows: `5`
- Per-type counts: `10` each for `listening_choice`, `english_to_vietnamese`, `vietnamese_to_english`, `situation_pick`, `pronoun_variant_choice`, `phrase_chunk_rebuild`, and `natural_phrase_choice`.

## Prototype run instructions
Run from the repo root:

```bash
python3 -m http.server 8787
```

Open:

```text
http://127.0.0.1:8787/prototypes/practice-quiz/
```

Serving from the repo root also lets the prototype resolve the local Vietnam masthead image and bundled audio paths.

## How this avoids generic-scenario quiz direction
- Every item anchors the correct answer to a real source phrase, source page, phrase row, or authored breakdown token.
- Prompts test Vietnamese recognition/recall: audio meaning, English-to-Vietnamese, Vietnamese-to-English, situation fit, authored pronoun/self-reference, phrase chunks, and authored natural variants.
- Distractors come from nearby source phrases instead of invented trivia answers.
- Feedback points back to the source page and explains the phrase/context distinction.
- Sensitive scenarios are tagged and mascot-ineligible.

## Validation
- `python3 .agent/queue_tool.py health`: passed.
- `node scripts/practice/generate-viet-practice-deck.test.js`: passed.
- `node scripts/practice/generate-viet-practice-deck.js --check`: passed.
- `node --check scripts/practice/generate-viet-practice-deck.js`: passed.
- `node --check scripts/practice/generate-viet-practice-deck.test.js`: passed.
- `node --check prototypes/practice-quiz/app.js`: passed.
- JSON parse for both generated deck copies: passed.
- Resolver check for `source.pageID#source.sectionID`: `0` unresolved.
- Local prototype serve check: `/prototypes/practice-quiz/`, deck JSON, and masthead image returned `200 OK`.
- `git diff --check`: passed.
- Scope check: native runtime and `.agent/coordination/queue-index.json` stayed clean.

## Review artifacts
- Gate 1 pass 1: `.agent/tasks/T-169/reviews/gate-1/pass-1/` blocked on chunk rebuild gloss/sequence and queue-index side effect.
- Gate 1 pass 2: `.agent/tasks/T-169/reviews/gate-1/pass-2/` all approved.
- Gate 2 pass 1: `.agent/tasks/T-169/reviews/gate-2/pass-1/` blocked on non-resolving `source.sectionID: "hero"`.
- Gate 2 pass 2: `.agent/tasks/T-169/reviews/gate-2/pass-2/` blocked on validator not catching mutated bad section IDs.
- Gate 2 pass 3: `.agent/tasks/T-169/reviews/gate-2/pass-3/` all approved.
- Gate 3 pass 1: `.agent/tasks/T-169/reviews/gate-3/pass-1/` all approved.

## Remaining risks and next task
- This is a prepared deck/prototype package only; it intentionally does not wire native SwiftUI runtime, SQLite tables, or local progress storage.
- Next recommended task: after T-167/T-168 land, create a native Practice integration task that reads this contract from the SQLite phrase graph or generated native resource, maps local practice pool state to `items[].id`, and proves one simulator flow.

## Process feedback
- NONE: Task scope was clear, and the review gates caught real data-contract issues before closeout.
- SUGGESTION: Keep future generated practice resources validating source page and section resolution against authored pages, not just checking local JSON shape.
