# TASK-PRACTICE-LEARNING-LOOP-RD-001 Result

Status: done
Date: 2026-05-03
Lane: Research / Product Strategy

## Commit Hash

Report commit: `c6efea816aba108bca57e95f899e0873f5cb0e1f`

Receipt commit: recorded in final chat after this receipt is committed.

## Jojo Plan Steering

None. Jojo approved the implementation plan as written.

## Research Sources And Artifacts

Main report:

- `docs/research/practice-learning-loop-001/README.md`

External evidence:

- 42 distinct public links in the report.
- Source categories: competitor practice systems, review/spaced-repetition tools, audio/travel phrase comparators, translation/phrasebook utilities, app-store/review surfaces, public Reddit/forum pain, and learning-science references.
- No X sources used because public access was not needed and often adds login/rate-limit friction.
- No new video digest created because written public evidence plus existing repo screenshots/results were sufficient.

Repo evidence:

- `docs/task-cards/TASK-PRACTICE-LEARNING-LOOP-RD-001.md`
- `docs/DECISIONS.md`
- `docs/practice/VIET_PRACTICE_CORE_PLAN.md`
- `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`
- `native-ios/App/Views/PracticeView.swift`
- `native-ios/App/Models/PracticeModels.swift`
- `native-ios/Tests/PracticeNativeMVPTests.swift`
- `native-ios/UITests/PracticeUITests.swift`
- prior Practice task results and screenshot artifacts

## Current Practice Diagnosis

Current strengths:

- Native Practice already uses real bundled phrase/page data.
- Local state supports ready and missed prompts privately and offline.
- Saved Review stays separate from the explicit practice pool.
- Add to Practice exists as the correct user-intent hook.
- Missed Review can turn wrong answers into calm review.
- Placement prompts are phrase-learning focused.
- City metadata exists for trip-prep modes.

Current weakness:

- The hub still leads city-first through `Hanoi Bucket List`, so personal phrase rehearsal can feel secondary.
- `Bucket List` sounds like sightseeing/trivia rather than phrase readiness.
- The current four native prompt kinds are a useful MVP set, but need sequencing so Practice does not feel like random multiple choice.
- Missing-token prompts should be gated to authored useful breakdowns and later exposure.
- Completion copy should name phrase readiness, not implementation hooks or mascot mechanics.
- Future readiness should aggregate by `source.phraseID` / `source.pageID`, not only prompt ID.

## Recommended Practice Direction

Primary direction: **Saved Phrase Rehearsal + Audio-First Trip Practice**.

Practice should answer: "Which real phrases am I more ready to say or recognize now?"

Recommended priority order:

1. Missed prompts due for calm review.
2. Phrases explicitly added to Practice.
3. Saved/recent phrase pages.
4. A small confidence mix from partly ready phrases.
5. City/category trip practice when the personal queue is empty or chosen.
6. Graph-nearby recommendations from the same canonical page family.

Keep the bottom-tab label `Practice`, but use in-flow labels like `Rehearse saved phrases`, `Review missed`, and `Trip practice`.

## Rejected Or Risky Quiz Patterns

- Generic travel trivia.
- Timed/race quiz mechanics.
- Hearts, lives, energy loss, streak anxiety, XP, leaderboards, or public ranking.
- Mascot rewards detached from phrase readiness.
- Scored speaking/pronunciation until reliability and offline/local behavior are proven.
- Missing-token prompts built from weak or fake breakdown tokens.
- SRS dashboard language before the product has a simple trusted rehearsal loop.

## Proposed Question Types

Keep and promote:

- `listening_choice`
- `english_to_vietnamese`
- `vietnamese_to_english`

Change:

- `missingToken` / `phrase_chunk_rebuild`: use after exposure and only with authored useful breakdown tokens.
- `situation_pick`: use only with concrete authored traveler situations.

Later / gated:

- `pronoun_variant_choice`
- `natural_phrase_choice`
- `likely_reply_choice`

Reject for now:

- scored speaking/pronunciation
- timed match/race modes
- XP/lives/streak mechanics

## Saved, Add-To-Practice, And Missed-Phrase Flow

First session:

- If Add-to-Practice phrases exist, start with those and use audio-first prompts when possible.
- If no personal queue exists, offer short `Trip practice` starter choices such as `First day`, `Hotel desk`, `Food counter`, or selected destination.

Returning session:

- Show `Review missed` first when missed prompts exist.
- Show `Rehearse saved phrases` when added or saved phrases exist.
- Show `Trip practice` only when personal queues are empty or intentionally selected.

Missed answer:

- Show the correct Vietnamese phrase.
- Replay audio if available.
- Explain why it fits.
- Link to the source page.
- Add to missed review automatically.
- Use calm copy such as `Saved for review`.

End of session:

- Show phrases practiced, phrases ready, prompts saved for review, and one next action.

## Onboarding, Destination, And Level Recommendation

- Keep onboarding placement lightweight and optional: a short phrase pace check, not an exam.
- Store level/destination as local preference/ranking signals only.
- Do not hide content, shame the user, or require placement before phrasebook use.
- When the user has no personal Practice queue, destination/category trip practice is the best fallback.

## Native Implementation Handoff

Target lane: `Practice / Quiz`.

Recommended next task: `TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001`.

Tiny prompt:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/research/practice-learning-loop-001/README.md.
Create a native Practice task that reorders the Practice hub around personal phrase rehearsal: missed prompts, Add-to-Practice phrases, saved/recent phrase pages, then Trip practice fallback.
Keep Practice offline and source-anchored. Do not add XP, streaks, lives, leaderboards, runtime AI, or scored pronunciation.
Commit when done and write the result.
```

## Peer Review Outcome

Focused read-only peer review completed.

Verdict: approve the research recommendation with closure concerns.

Reviewer findings:

- Blocking at review time: the required result receipt was absent. This receipt resolves that closeout blocker.
- Non-blocking concern: the native handoff is actionable as R&D, but should become a concrete task card with acceptance checks before Native UI implements it.
- Report content passed for evidence breadth, phrase-learning focus, first-time traveler usefulness, anti-trivia/game-mechanic guardrails, question-type specificity, and Native UI direction.

## Validation Commands And Outcomes

- `git diff --check -- docs/research/practice-learning-loop-001/README.md` -> passed.
- `rg -o "https?://[^) ]+" docs/research/practice-learning-loop-001/README.md | sort -u | wc -l` -> `42`.
- `git diff --cached --check` before report commit -> passed.
- `git diff --cached --name-only | rg '^(native-ios/|content-draft/|scripts/practice/|docs/content-audits/|docs/task-results/assets/)'` before report commit -> no matches.

- `git diff --check` after receipt draft -> passed.

## Open Questions For Jojo

- Should the next native task rename `Hanoi Bucket List` to `Hanoi trip practice`, `Hanoi phrase prep`, or remove city-first naming entirely from the main card?
- Should first-run Practice start from `First day`, `Hotel desk`, or a destination selected during onboarding when the user has no saved phrases?
- Should saved pages automatically count as practice candidates, or should only `Add to Practice` create the primary personal queue?
- Should a later self-rehearsal mode support local record/replay without scoring, or should all speaking support stay as native-audio listen-and-repeat guidance for now?

## Scope Proof

Docs-only task output:

- `docs/research/practice-learning-loop-001/README.md`
- `docs/task-results/TASK-PRACTICE-LEARNING-LOOP-RD-001.md`

Not edited or staged by this task:

- native Swift app code
- generated content
- SQLite resources
- audio files
- Xcode project files
- existing Practice prototype files
- unrelated dirty files under `docs/content-audits/**`, `native-ios/**`, `scripts/practice/**`, or `docs/task-results/assets/**`
