# Viet Practice Reward And Mascot Handoff

Last updated: 2026-04-29
Status: native-ready design contract for later implementation
Task: TASK-PRACTICE-REWARD-MASCOT-001

## Outcome

Practice rewards should answer one question: "Which real Vietnamese phrases am I more ready to use now?" The first MVP reward loop is therefore a local readiness route, not an XP economy. The chameleon traveler supports that loop as a restrained companion whose Vietnam details grow only when the user has rehearsed source-anchored phrase knowledge.

This handoff extends the existing Practice Core package:

- Practice deck contract: `docs/practice/VIET_PRACTICE_CORE_PLAN.md`
- Prototype: `prototypes/practice-quiz/`
- Generated sample deck: `content-draft/viet/practice/practice-deck.sample.json`

No account, network, paid currency, public ranking, runtime AI, or final mascot art is required.

## First Reward Loop

### Earned Object

The user earns **ready prompt marks** for source-anchored answers and an aggregate **route mark** for a short practice session.

- A ready prompt mark is earned when a prompt tied to a canonical phrase/page is answered correctly.
- A review prompt mark is added when the user misses a prompt. It is not a loss, a life, or a punishment.
- A distinct phrase becomes "ready" when at least one source-anchored prompt for that `source.phraseID` is answered correctly.
- A stronger personal phrase mark can require two different prompt types for the same phrase, such as listening plus English-to-Vietnamese.
- A route mark unlocks when a short session reaches enough ready prompt marks across more than one source phrase, initially `3` ready prompts across at least `2` phrase pages in a `5` prompt session.
- Missed prompts can complete the same route later by returning through the local missed-review queue.

### Unlock

The first Viet route mark unlock is **Jade route tint**:

- native meaning: the user has moved a small set of Vietnam travel phrases from "seen" to "ready";
- visual meaning: a subtle jade/sea-glass tint appears on the chameleon traveler and the route card;
- content requirement: the unlock copy names the practiced phrase area, such as Hotel desk or Food counter, rather than using generic XP language.

Future route marks can add restrained Vietnam-coded details:

- lotus-red collar stripe;
- tiny red/gold travel satchel patch;
- blue ceramic scale pattern;
- coffee-ticket or market-ticket tag;
- lantern-warm completion glow.

These are motif details, not costumes. Avoid turning the mascot into a flag, caricature, or game avatar.

### Why It Stays Tied To Learning

Every reward must be derived from source-anchored practice events:

- `item.id`
- `source.phraseID`
- `source.pageID`
- `source.familyID`
- `questionType`
- `tags.skillTags`
- local result: `ready`, `review`, or `reviewed`

The app should never award route progress for opening Practice, tapping through feedback, maintaining a streak, or answering trivia that does not require Vietnamese phrase knowledge.

## Mascot Usage Rules

### Use The Chameleon

- Practice hub: one compact route companion near the selected practice mode.
- Friendly standard prompts: a small "route mark available" note only when `tags.mascotEligible === true` and sensitivity is standard.
- Completion: a small reward reveal that shows the currently unlocked Viet motif.
- Empty states: saved/practice queue is empty, missed queue is clear, or all selected phrases are ready.
- Onboarding for Practice only: one short line that the companion changes as phrase readiness grows.

### Keep It Absent Or Subdued

- Emergency, safety, medical, harassment, police, or high-stress prompts.
- Wrong-answer feedback for sensitive phrases.
- Source phrase pages where the user is trying to read, play audio, or compare variants.
- Bottom chrome, search, playback controls, and any surface where the mascot would compete with a phrase or action.
- Monetization, subscription, or unlock messaging.

### Vietnam Adaptation

Use Vietnam-coded restraint:

- jade/sea-glass body tint;
- small red/gold satchel patch;
- avoid flag-like stars or achievement-badge shapes in final art;
- soft lotus or ceramic scale pattern;
- warm lantern highlight on completion;
- no loud game palette, costume hat, flag body paint, fireworks, or confetti shower.

The mascot should read as a traveler who is gradually learning the local motif, not as a children's game character.

## Key Moments

### Completion

The completion screen should show:

- ready count;
- review count;
- route mark status;
- next best action: review this route, practice saved phrases, or choose another route.

Tone: "Vietnam route updated" and "Jade route mark unlocked" rather than "Level up" or "You won."

### Missed Answer

Missed-answer feedback should:

- show the correct Vietnamese phrase and why it fits;
- preserve the source page link;
- add the item to local review;
- avoid red failure language, lives, or streak loss;
- use "Saved for calm review" or similar copy.

### Return To Practice

Practice entry points should rank local queues in this order:

1. missed prompts due for review;
2. phrases the user explicitly added to practice;
3. saved phrases from recently opened pages;
4. a small confidence-building mix from previously ready phrases;
5. graph-nearby recommendations from the same canonical page family.

The app should show why the session is suggested: "2 saved hotel phrases due" is better than "Daily challenge."

## Saved And Practice-Selected Phrases

Saved and `Add to practice` phrases are local private signals.

- Selecting a phrase adds its canonical `phraseID`, `pageID`, and row/token context to the local practice pool.
- The selected phrase remains the correct-answer target. Related phrases can be distractors or recommendations, not replacements.
- A selected phrase earns its first ready mark after one correct source-anchored prompt.
- It earns a stronger personal route mark after being answered correctly in two different prompt types, such as listening plus English-to-Vietnamese.
- Missed selected phrases should return before unrelated new recommendations.

## Native Contract Sketch

Runtime can keep reward state outside the read-only bundled phrase graph:

```json
{
  "schemaVersion": "speaklocal.practice-reward.v0.1",
  "language": "vi",
  "routeMarks": [
    {
      "id": "viet-route-jade-tint",
      "flowID": "starter-essentials",
      "sourcePhraseIDs": ["airport-1"],
      "readyPromptCount": 3,
      "readyPhraseCount": 2,
      "reviewCount": 1,
      "unlockedAt": "local timestamp"
    }
  ],
  "phraseReadiness": {
    "airport-1": {
      "readyPromptIDs": ["viet-practice-listen-airport-1"],
      "reviewPromptIDs": [],
      "lastResult": "ready",
      "nextDueAt": "local timestamp"
    }
  },
  "mascot": {
    "activeMotifID": "viet-route-jade-tint",
    "visibleContexts": ["practiceHub", "standardPrompt", "completion"]
  }
}
```

Implementation should store only local progress and rewards here. Bundled deck items, source phrases, and authored listing pages remain read-only.

## Prototype Update

`prototypes/practice-quiz/` now demonstrates the simpler native direction:

- one compact route companion on the hub;
- one calm readiness strip in session;
- optional mascot note only on eligible standard prompts;
- "Ready mark added" and "Saved for calm review" feedback;
- completion reward copy with a Jade route mark.
- route completion copy distinguishes ready prompts from distinct ready phrase pages.

The chameleon is a CSS placeholder for layout and behavior only. It is not final art.

## Implementation Handoff

For the `Practice / Quiz` lane:

- Add local readiness state keyed by `items[].id` and `source.phraseID`.
- Add `Add to practice` entry points only after native local state exists.
- Build native Practice with static glass chrome, one prompt surface, one answer area, and a compact readiness strip.
- Gate mascot visibility through `tags.mascotEligible` plus sensitivity checks.
- Keep sensitive prompts mascot-free except for neutral completion summaries.
- Use route-mark copy and local source phrase counts instead of XP, streaks, lives, or leaderboards.
- Treat the CSS mascot as a placeholder contract; final mascot art should be a separate asset-direction task.

## Validation Notes

Validation for this handoff should include:

- prototype loads from a local server;
- screenshots cover hub, prompt feedback, and completion;
- peer review confirms the reward loop supports phrase learning, is not too busy, and is native/Liquid Glass-ready;
- `git diff --check` passes.
