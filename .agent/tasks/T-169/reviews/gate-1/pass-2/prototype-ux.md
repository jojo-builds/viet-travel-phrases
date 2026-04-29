# Gate 1 Pass 2 - Prototype UX

Reviewer: Beauvoir  
Lane: browser prototype UX

Findings:

- No blocking findings.
- Prototype still serves locally at `/prototypes/practice-quiz/` and `app.js` passes syntax check.
- `practice-deck.sample.json` parses cleanly: 70 items, 14 scenarios, 7 question types, 5 practice flows.
- All 5 flows resolve their item IDs with no missing references, and the choice/chunk data shapes match the UI code.
- The generated flows remain realistic: Starter essentials, Hotel desk, Food counter, Pronoun coach, Review missed.
- Non-blocking note: chunk rebuild existed and the UI supported it, but the old default session slice could hide chunk items just beyond the first 5 prompts.

Worker follow-up after review:

- Updated the `starter-essentials` flow so the first default session includes `phrase_chunk_rebuild` as prompt 5.
- Added a generator test that requires at least one default prototype flow to expose chunk rebuild without extending the session.

Approval: APPROVE

