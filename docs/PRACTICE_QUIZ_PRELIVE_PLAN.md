# Practice And Quiz Pre-Live Plan

Last updated: 2026-04-28  
Owner lane: SpeakLocal native app-family planning  
Status: planning source of truth

## Why this matters

SpeakLocal should not feel like a generic language-course game. The practice area should feel like traveler rehearsal: short, audio-forward, context-rich drills that help someone use the exact phrase they just learned on a listing page.

This is a pre-live lane. The app can look strong as a phrase library, but it will feel much more useful if users can immediately practice:

- phrases by category, such as hotel, airport, money, food, health, and transport;
- social/pronoun choices, especially `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô`, and `bạn`;
- a specific phrase or phrase family from a listing page;
- saved or recently viewed phrases;
- missed phrases, fully offline.

## Current asset inventory

Current repo scan shows enough material for a useful MVP without adding runtime AI:

- `18` base catalog scenarios in `content-draft/viet/viet-phrase-catalog.json`.
- `900` phrase families and `919` phrase rows in the Viet catalog.
- `163` authored native listing pages in `native-ios/Resources/viet-authored-listing-pages.json`.
- `23` category IDs represented in authored pages, including auxiliary categories like greetings, repair, gratitude, goodbyes, and small talk.
- `1,363` authored phrase rows that can become practice prompts.
- `720` breakdown tokens that can power phrase-building questions.
- `428` visible authored audio keys and `458` required visible audio entries in the audit.
- `0` missing authored audio entries in `native-ios/Resources/viet-authored-audio-audit.json`.
- No real mascot asset was found in the native asset catalog yet. The mascot is still a design/asset task, not an implementation-ready resource.

## Research signals

Use these as direction, not as a command to copy Duolingo or any single product.

- Reddit language learners repeatedly complain when practice feels repetitive, lacks grammar/context explanation, or rewards streak behavior more than real progress.
- Reddit Duolingo threads specifically call out repetition fatigue and weak teaching value when exercises repeat forms without explaining why they are useful.
- Duolingo's own public learning material emphasizes spaced repetition and bringing words back before the learner forgets them.
- Learning science supports retrieval practice: asking learners to recall information, then giving feedback, generally improves retention more than passive rereading.

Working implication: SpeakLocal practice should be contextual, explanatory, and useful in a real travel moment. It should avoid naked XP loops, random sentences, or unclear "wrong" answers.

Reference links:

- Reddit language-learning pain points: https://www.reddit.com/r/languagelearning/comments/1lze50r/what_are_your_biggest_problems_with_language/
- Reddit Duolingo repetition complaint: https://www.reddit.com/r/duolingo/comments/1g3whea/duolingo_repetitive/
- Reddit Duolingo annoyance thread: https://www.reddit.com/r/duolingo/comments/184axoq/whats_the_most_annoying_thing_about_duolingo/
- Duolingo on spaced repetition: https://blog.duolingo.com/spaced-repetition-for-learning/
- Retrieval practice review: https://link.springer.com/article/10.1007/s10648-021-09595-9

## Product principles

1. Practice is a rehearsal layer, not a second course app.
2. Every drill should answer: "When would a traveler actually use this?"
3. Audio is first-class. If a button looks playable, it must play bundled offline audio or be tracked as missing before release.
4. Listing pages remain the source of meaning. Practice should reuse their phrase rows, breakdown tokens, related phrases, and cultural notes.
5. Explanations should be short but real. A wrong answer should tell the user what confused them.
6. Mascot use should be light: a guide, hint, cultural note, or gentle retry state. It should not become noisy or childish.
7. No runtime AI dependency. Question generation must be deterministic/offline from bundled content.

## MVP practice modes

### 1. Listen And Choose

The app plays a Vietnamese phrase. The user chooses the English meaning from 3-4 options.

Best source data:

- hero phrases;
- authored phrase rows;
- category siblings;
- likely replies.

Why this belongs in MVP: It uses existing audio, helps travelers recognize phrases, and avoids needing text input.

### 2. Situation Pick

The app gives a short travel context, such as "You are checking in and need your room key." The user chooses the best Vietnamese phrase.

Best source data:

- category IDs;
- `At a glance`;
- `When to use it`;
- nearby forms.

Why this belongs in MVP: It tests real use, not isolated translation.

### 3. Pronoun Coach

The app asks which greeting or phrase fits a relationship cue, such as older man, older woman, someone younger, elderly woman, or peer.

Best source data:

- greeting pages;
- pronoun sections;
- social/local greeting rows;
- child pages like `Chào anh`, `Chào chị`, `Chào em`, `Chào ông`, `Chào bà`, `Chào chú`, `Chào cô`.

Why this belongs in MVP: Pronouns are one of the highest-value Vietnamese-specific teaching points.

### 4. Build It

The app shows shuffled breakdown cards and asks the user to put them in phrase order, then plays the full phrase.

Best source data:

- breakdown tokens;
- hero phrase;
- visible audio keys for tokens and full phrase.

Why this belongs in MVP: It reinforces phrase structure without requiring typing Vietnamese.

### 5. Practice This Page

From a listing page, the user can start a focused mini deck for that phrase family.

Best entry points:

- near the hero/player area as a small glass action;
- near meaningful sections like variants, pronoun swap, likely replies, or Explore next;
- from Saved.

Why this belongs in MVP: It connects the article-style pages to actual memory work.

### 6. Review Missed

The app keeps a local missed/retry list and surfaces those phrases again later.

Best source data:

- local-only progress state;
- missed item IDs;
- last practiced timestamp;
- category and phrase page links.

Why this belongs in MVP: It adds retention without accounts, cloud sync, or pressure-heavy streak mechanics.

## Navigation shape

Recommended first version:

- Add a `Practice` area as a first-class destination in the native app chrome once the home/search/listing rhythm is stable.
- Add `Practice this` on listing pages as a contextual entrypoint.
- Let users choose:
  - All starter Tier 1;
  - category;
  - pronouns/social;
  - saved phrases;
  - current listing page;
  - missed/retry.
- After a short session, show:
  - phrases practiced;
  - phrases missed;
  - one next page to open;
  - one category to continue.

Do not make the first version a large game world. The native app is already dense and article-like; practice should feel like a compact Apple-native exercise surface with a little mascot personality.

## Data model direction

Add generated offline practice resources under the language pack lane, not hard-coded one-off Swift arrays:

```text
native-ios/Resources/LanguagePacks/viet/
  practice-decks.json
  practice-audio-audit.json
```

The generator should produce stable IDs from canonical phrase/page IDs:

- `PracticeDeck`
- `PracticePrompt`
- `PracticeOption`
- `PracticeSkillTag`
- `PracticeSource`

Suggested tags:

- `listening`
- `meaning`
- `situation`
- `pronoun`
- `breakdown`
- `reply`
- `saved`
- `missed`

Local device state can stay simple:

- practiced count;
- correct/incorrect;
- last seen;
- next suggested review;
- source page ID.

## Mascot lane

No usable mascot asset is currently present in the native app resources.

Create a small mascot system before implementation:

- one final character direction;
- transparent PNG or layered raster source;
- app icon-safe color palette compatibility;
- poses:
  - neutral guide;
  - listening;
  - correct;
  - try again;
  - hint;
  - local/cultural note;
  - completed mini session.

Mascot behavior rules:

- use sparingly;
- never block a quick answer;
- avoid childish copy;
- use it most where feedback or cultural nuance needs warmth.

## Go-live to-do list

Pre-live product tasks now include:

- Prove the Mac queue with `T-157`.
- Promote the native app branch to `main` once Jojo is ready.
- Finish Tier 1 article-page quality and copy pass.
- Create the Practice/Quiz research and design spec (`T-159`).
- Implement offline practice deck generation from current authored content.
- Implement the native Practice UI and listing-page `Practice this` entrypoint.
- Add local-only practice progress and missed/retry behavior.
- Add mascot art direction and native asset integration.
- Audit practice audio so every visible speaker control resolves offline.
- Simulator-check practice on the main iPhone 17 Pro viewport.
- Device-proof the native app before any TestFlight/App Store claim.

## Initial implementation tasks

Recommended queue sequence after the queue smoke test:

1. `T-159`: Research and design the pre-live Practice/Quiz + mascot lane.
2. `T-160`: Generate offline Viet practice deck resources from authored pages and catalog data.
3. `T-161`: Build native SwiftUI Practice surfaces and listing-page entrypoints.
4. `T-162`: Create and integrate mascot asset system.
5. `T-163`: Practice audio/progress/search/navigation validation pass.

## Open product decisions

These should be answered during `T-159`, not guessed during implementation:

- Should `Practice` be a fourth chrome item, a Browse subpage, or a floating page-level action first?
- How visible should the mascot be in serious contexts like emergency/health?
- Should practice sessions be fixed length, user-selected length, or just "keep going"?
- Should missed phrase review be automatic after a session, or available as a separate deck?
- Which practice modes are MVP versus post-live?

