# T-169: Practice Core Decks And Browser Prototype

## Task Done

SpeakLocal has a parallel-safe Practice Core package for Vietnam: a phrase-based quiz data contract, generated practice deck samples from real repo phrases, and a clickable browser prototype Jojo can test locally. The work must be ready for later native SwiftUI integration after `T-168`, but it must not touch native runtime files now.

## Context

Jojo rejected generic travel-scenario quiz questions that do not require knowing Vietnamese. Practice must be based on actual phrases a user saves/adds from listing pages. A quiz answer should usually be a Vietnamese phrase, English meaning, audio cue, pronoun variant, or phrase chunk from the phrase universe.

Relevant prior truth:

- `T-159`, `T-162`, `T-166`, `T-167`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/DECISIONS.md`
- `content-draft/viet/phrase-source.csv`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-authored-audio-audit.json`
- content-data receipt at `/Users/jojolim/Developer/products/speaklocal/app-family-content-data/docs/worker-results/2026-04-29-content-data-universe.md`

## Worker Judgment

Use GPT-5.5 reasoning to design the best Practice Core system. Do not wait for step-by-step instructions. Inspect the repo, choose the implementation path, and make the result usable.

The key product standard: Practice should teach Vietnamese phrases, not ask generic travel trivia. It should feel native to SpeakLocal: positive, polished, offline-first, phrasebook-centered, and compatible with the chameleon mascot idea without becoming childish.

## Required Outcome

- A documented Practice Core contract covering phrase identity, source page, question type, prompt, answer, distractors, audio key, feedback, category/pronoun/situation tags, and future progress fields.
- A generated sample practice deck with at least `60` real phrase-derived items, at least `8` scenarios/categories, and at least `6` useful question types.
- Question types must test language knowledge, such as listening, English-to-Vietnamese, Vietnamese-to-English, pronoun/social variant choice, phrase chunk rebuild, and local/natural phrase choice.
- A clickable browser prototype under `prototypes/practice-quiz/` that uses the generated deck data and has 3-5 realistic practice flows.
- A native handoff explaining how this will later connect to `T-167` local saved/practice state and `T-168` SQLite phrase graph.
- A compact `result.md` with what changed, how to run the prototype, validation, review results, and the next recommended task.

## Boundaries

Work in:

- `/Users/jojolim/Developer/products/speaklocal/app-family-practice-core`

Allowed writes:

- `.agent/tasks/T-169/**`
- `docs/practice/**`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/DECISIONS.md`
- `content-draft/viet/practice/**`
- `prototypes/practice-quiz/**`
- `scripts/practice/**` or `tools/practice/**`
- `package.json` only if needed for a focused practice/prototype command

Do not touch:

- `native-ios/App/**`
- `native-ios/Tests/**`
- `native-ios/project.yml`
- `native-ios/Resources/LanguagePacks/**`
- `native-ios/Resources/Audio/**`
- existing task folders other than `.agent/tasks/T-169/**`
- secrets or machine-local credentials

## Validation

Run enough validation to prove the result. At minimum:

- queue repair/health
- generated deck JSON parses
- any new generator/prototype script checks
- a local prototype run instruction works
- `git diff --check`

Use 3 review gates with 4 read-only reviewer subagents each. Let the worker choose reviewer lanes based on the actual risks, but they must cover learning value, data contract, prototype UX, native handoff, validation, and scope safety. All latest-pass reviewers must approve before marking done.

## Result Contract

Before stopping, commit the work and write `.agent/tasks/T-169/result.md` with:

- status and commit hash
- files changed
- deck item/category/question-type counts
- prototype run instructions
- how this avoids the rejected generic-scenario quiz direction
- validation results
- review artifact paths
- remaining risks and next task
- `Process feedback` bullets beginning with `NONE`, `BUG`, or `SUGGESTION`
