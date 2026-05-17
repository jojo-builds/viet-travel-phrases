# Practice And Quiz Pre-Live Plan

Last updated: 2026-04-29
Owner lane: SpeakLocal native app-family planning  
Status: implementation-ready planning source of truth

Alignment note: `T-160` is now the SQLite phrase-graph architecture task, not the practice deck generator. Any remaining practice generator, practice audio audit, skipped-candidate report, simulator proof, or device proof work belongs to follow-up queue tasks.

T-169 package note: the first Practice Core contract, Viet sample deck, deterministic generator, and browser prototype now live outside native runtime wiring:

- contract and native handoff: `docs/practice/VIET_PRACTICE_CORE_PLAN.md`
- generated sample deck: `content-draft/viet/practice/practice-deck.sample.json`
- clickable prototype: `prototypes/practice-quiz/index.html`
- generator and validation: `scripts/practice/generate-viet-practice-deck.js`

This package is prepared for later T-167/T-168 integration. It intentionally does not add native app resources, SwiftUI screens, SQLite tables, or runtime practice state in this task.

## Decision snapshot

SpeakLocal practice should be a traveler rehearsal layer, not a generic course game.

First version decisions:

- Keep practice fully offline and deterministic from bundled content. No runtime AI, network prompt generation, accounts, leagues, public leaderboards, hearts, or punitive lives.
- Start with compact native sessions that rehearse the exact phrase graph users are already browsing: authored listing pages, phrase rows, pronunciation audio, breakdown tokens, and category context.
- Practice is phrase-sourced. From any phrase listing page, the user can add that phrase to a local practice pool, then practice those chosen phrases by quiz mode, category, source page, saved/recent, or missed status.
- Every generated practice prompt must have a selected source phrase, row, or breakdown token as the correct answer. Multiple-choice distractors fill the other slots from graph-nearby phrases; the practiced phrase is never just decorative context.
- Saved phrase IDs, practice-selected phrase IDs, recently opened page IDs, practiced counts, missed items, and last-used filters are local user intent signals. Home, Explore shelves, category rows, and Practice should rank from those signals before falling back to generic global ordering.
- MVP modes are `Listen And Choose`, `Situation Pick`, `Pronoun Coach`, `Practice This Page`, and `Review Missed`.
- MVP active recall is deliberate but bounded: users must retrieve meaning, use-case, social role, or next action before seeing feedback. Hold full phrase-construction `Build It` for the first post-MVP iteration unless a follow-up deck/audio generator task proves token sequencing and token audio are release-clean.
- Use a `Practice` destination from home/quick access plus contextual `Practice this` actions on listing pages. Wait on a permanent fourth bottom-chrome item until simulator/device proof says it improves navigation instead of crowding the app shell.
- Use the mascot sparingly as a guide, hint, completion, or cultural-note layer. In health, emergency, safety, and money-dispute contexts, keep the mascot neutral or absent.
- Default sessions should be short and continuous: compact `4`-pair match rounds or `3` to `5` prompts from a single listing page, with `Next round` / `Keep going` after completion instead of a hard lesson stop.
- Missed-phrase review should be available as its own deck and also suggested after a session. It should never feel like punishment.

## Why this matters

The current native app is becoming a strong offline phrase library. Practice makes that library feel useful before a traveler is standing at a counter, in a taxi, or asking for help.

The practice area should help users rehearse:

- phrases by category, such as hotel, airport, money, food, health, and transport;
- social/pronoun choices, especially `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô`, and `bạn`;
- one listing page or phrase family they just read;
- the exact phrase pages they intentionally added to practice;
- saved, recent, or missed phrases;
- listening recognition with bundled audio;
- short real-world situations rather than abstract translation drills.

The first-launch experience has no local user state, so it should start from curated essentials, categories, and authored phrase pages. As soon as the user saves, opens, practices, misses, or adds a phrase to practice, that local state should become the strongest personalization input for future surfaces.

## Phrase-sourced practice pool

The core practice model is user intent first: if someone taps `Add to practice` on a phrase page, that phrase becomes part of their local practice pool. Later, the Practice area lets them choose how to rehearse the phrases they selected.

Required user flows:

- From a phrase listing page, add the hero phrase to practice.
- From row-level phrase surfaces, add that specific phrase row when it has canonical phrase identity.
- From a listing page, optionally start `Practice this page`, which uses the hero phrase plus high-value rows and breakdown tokens from that page.
- From the Practice area, view a manage screen for selected phrases and remove items without hunting back through the app.
- From any phrase page already in the pool, remove it or see that it is already selected.

Practice entry options should be mode-first but source-aware:

- choose a mode such as `Listen And Choose`, `Situation Pick`, `Pronoun Coach`, or `Review Missed`;
- choose a source such as `My practice phrases`, `This page`, `Saved`, `Recent`, `Category`, or `Pronouns`;
- let the app build a short session from the intersection.

This avoids generic quizzes that only test travel common sense. A prompt should always rehearse something the user selected, saved, missed, recently opened, or intentionally started from a listing page.

### Correct-answer anchoring

For every practice prompt, the correct answer must be anchored to one of:

- `sourcePhraseID`;
- `sourcePageID` plus a hero phrase;
- `sourcePhraseRowID`;
- `sourceBreakdownTokenID`;
- a future canonical relation target such as a reply, pronoun variant, or nearby phrase.

For multiple choice, the correct answer should be placed in a randomized answer slot. The other options are distractors, not arbitrary filler.

Distractor rules:

- Prefer same scenario/category, same relationship family, same intent type, or same phrase shape.
- Avoid choices that are too easy because their English translation gives the answer away before the user listens or thinks.
- Avoid unsafe ambiguity in health, emergency, payment, police, and safety contexts.
- Do not use unresolved aliases, missing audio, or phrases without canonical page identity.
- Keep distractors explainable: feedback should say why the correct phrase fits and why a tempting nearby phrase is different.

Conceptually, every phrase should be practice-capable. That does not mean hand-writing a separate quiz file for every phrase. The durable model should store generated practice templates keyed by canonical phrase/page IDs, then use local user-selected phrase IDs to assemble sessions.

### Local personalization contract

The mutable user-state model should stay local, private, and deterministic. It should not depend on accounts, cloud sync, remote ranking, analytics, or runtime AI.

T-167 implementation note: the native app now has a first local user-intent store for recent page IDs, saved page IDs, and practice-pool page IDs. It powers Home shelves and listing/detail page save/practice affordances only at page level; generated practice decks, prompt progress, missed/due state, and a full Practice destination remain follow-up work.

Local state should capture:

- saved canonical phrase/page IDs;
- practice-selected phrase IDs and optional page/deck selections;
- recently opened canonical page IDs with lightweight source context such as search, Home, category, or related row;
- practiced prompt/phrase history, including counts and last practiced time;
- missed/due prompt IDs plus the source phrase/page that taught them;
- last selected practice mode/filter when it helps resume the user's intent.

Ranking rules:

- Explicit user selections win: `Add to practice` and saved phrases are stronger than passive recency.
- Missed/due items can be suggested calmly, but they should not overwhelm new material or make Home feel punitive.
- Recently opened pages should influence `Continue`, related suggestions, and category ordering, but should decay behind saved/practice-selected items.
- Graph-nearby phrase suggestions should start from the user's saved, practice-selected, missed, or recently opened phrases, then use same scenario, relationship family, phrase cluster, likely reply, next-step, and repair edges as deterministic expansion candidates.
- When there is no local state, fall back to curated essentials and travel-urgency ordering.

## Research signals

These signals are directional. Reddit threads are anecdotal user discussion, not controlled evidence.

### User discussion signals

- A Reddit language-learning thread grouped pain points around answers/hints appearing too easily, mistakes being penalized without useful feedback, and static modules that do not prepare learners for messy real use: https://www.reddit.com/r/languagelearning/comments/1lze50r/what_are_your_biggest_problems_with_language/
- Reddit Duolingo users repeatedly complain about over-repetition, low-utility sentences, and not understanding the educational purpose of repeated prompts: https://www.reddit.com/r/duolingo/comments/1g3whea/duolingo_repetitive/
- A more recent Duolingo discussion describes the feeling that progress stalls into repetitive icon movement instead of communication practice: https://www.reddit.com/r/duolingo/comments/1rrsqpz/is_it_just_me_or_does_duolingo_eventually_just/
- Reddit streak discussions are split: streaks can help some users keep showing up, but many users report that streak protection can replace real learning motivation: https://www.reddit.com/r/languagelearning/comments/1hd7t0e/too_many_apps_rely_on_streaks/

### Learning-science and product-design signals

- Retrieval practice has strong evidence across applied classroom studies; a 2021 review screened nearly 2,000 abstracts, coded 50 experiments, and found most reported medium or large benefits: https://link.springer.com/article/10.1007/s10648-021-09595-9
- Spacing and retrieval practice work best together; a 2022 Nature Reviews Psychology review summarizes the combined evidence base: https://www.nature.com/articles/s44159-022-00089-1
- Duolingo's own learning article describes spaced repetition as reviewing newer and harder items sooner, older/easier items later, and pairing review with active recall: https://blog.duolingo.com/spaced-repetition-for-learning/
- Apple's feedback guidance emphasizes clear, consistent, accessible feedback that matches the significance of the moment: https://developer.apple.com/design/human-interface-guidelines/feedback
- HCI research on gamification misuse warns that points, badges, and leaderboards can distract learners from the underlying learning task when users become fixated on the game layer: https://arxiv.org/abs/2203.16175
- A 2023 mapping study of gamification in educational software found reported negative effects tied most often to badges, leaderboards, competitions, and points, including motivational issues and lack of understanding: https://arxiv.org/abs/2305.08346

### SpeakLocal implication

Practice should be:

- low-pressure;
- contextual;
- audio-first;
- explanation-forward;
- connected back to listing pages;
- useful in one real travel moment;
- honest about what the user can now recognize, choose, or say.

It should avoid naked XP loops, streak anxiety, random sentence repetition, and unexplained "wrong" states.

## Current asset inventory

### Catalog scenarios and phrase rows

Current checkout reality: `content-draft/viet/viet-phrase-catalog.json` is not present. The live generated native catalog is `native-ios/Resources/viet-phrase-catalog.json`, with metadata pointing back to `content-draft/viet/phrase-source.csv`.

`native-ios/Resources/viet-phrase-catalog.json` currently contains:

- `18` base scenarios;
- `900` phrase families;
- `919` phrase rows.

Scenario IDs:

- `polite-basics`
- `understanding-repair`
- `transport`
- `hotel-accommodation`
- `food-drink`
- `money-numbers-prices`
- `directions-navigation`
- `airport-border-arrival`
- `health-pharmacy`
- `problems-help`
- `time-dates-booking`
- `shopping`
- `phone-internet-power`
- `bathroom-personal-needs`
- `emergency-safety`
- `social-small-talk`
- `sightseeing-activities`
- `local-services-everyday-tasks`

### Authored listing pages

`native-ios/Resources/viet-authored-listing-pages.json` currently contains:

- `163` authored native listing/detail pages;
- `150` Tier 1 family count in metadata;
- `148` resource main pages;
- `15` child pages;
- `1,363` authored phrase rows inside page sections;
- `720` breakdown tokens;
- `23` category IDs represented, including auxiliary categories such as greetings, gratitude, goodbyes, repair, and small talk.

Useful authored section presentations for practice:

- `breakdown-strip`: `163`
- `phrase-list`: `312`
- `horizontal-phrase-cards`: `94`
- `plain-text`: `424`
- `tip-callout`: `148`
- `warning-callout`: `163`

Practice should treat these pages as teaching surfaces. A prompt can ask recall, but the explanation should link back to the specific page, section, phrase row, or breakdown token that taught the idea.

### Audio

`native-ios/Resources/viet-authored-audio-audit.json` currently contains:

- `458` required authored audio entries;
- `458` resolved entries;
- `0` missing entries;
- `23` hero audio entries;
- `145` phrase audio entries;
- `290` breakdown audio entries.

This clears the current authored-page audio audit, but it does not automatically clear practice. A follow-up practice-generator task must create a practice-specific audio audit because practice prompts can expose audio in new combinations.

### Current native app surface

There is a legacy `Practice it` label in `native-ios/App/Views/PhraseDetailView.swift` for fallback detail pages. This is not a practice system. The native app does not yet have:

- a practice destination;
- practice deck resources;
- local practice progress;
- missed/retry queue;
- practice audio audit;
- mascot runtime surface.

### Mascot assets

No usable native mascot asset is present in `native-ios/Resources/Assets.xcassets`.

Current native image assets are:

- app icon;
- accent color;
- `HeroXinChao`;
- `HeroVietnamMasthead`.

`native-ios/Resources/LanguagePacks/viet/` now contains the bundled T-165 SQLite fixture and report for DEBUG read-only validation. Production Viet resources still sit at `native-ios/Resources/*.json`, and visible runtime reads remain JSON-backed until SQLite search/page rendering reaches parity.

## Product principles

1. Practice is traveler rehearsal, not a course replacement.
2. Every prompt needs a real-world use case.
3. Audio is first-class. If a speaker control appears, it must resolve to bundled audio or enter a missing-audio audit before release.
4. Listing pages remain the source of meaning. Practice should reuse their phrase rows, breakdown tokens, local tips, warnings, and related phrase graph.
5. Wrong-answer feedback should teach the distinction, not just reveal the answer.
6. Keep the stakes low. Do not use lost lives, shame states, pressure timers, or streak protection as primary motivation.
7. Progress is local and private in the MVP.
8. The mascot adds warmth and clarity; it does not own the learning loop.
9. Sensitive categories need restrained UX. Emergency, safety, health, payment dispute, and police contexts should privilege clarity over play.
10. Runtime copy and question generation stay offline.

## MVP practice modes

The MVP uses recognition-style prompts because they are safer for a pre-live travel app with no speech recognition or typed-answer parser. To keep this from becoming passive multiple choice, every prompt must require the user to retrieve one meaningful cue before feedback appears:

- `Listen And Choose` retrieves meaning from audio.
- `Situation Pick` retrieves the right phrase for a travel context.
- `Pronoun Coach` retrieves the social relationship cue.
- `Practice This Page` retrieves a distinction the listing page taught.
- `Review Missed` retrieves previously missed items on a spaced schedule.

Full productive recall, such as ordering tokens or typing Vietnamese, is post-MVP unless the generator and UI can validate it without fragile parsing or unsafe feedback.

### 1. Listen And Choose

The app plays a Vietnamese phrase. The user chooses the English meaning from `3` to `4` options.

Best source data:

- hero phrases;
- authored phrase rows;
- category siblings;
- likely replies when they are modeled later.

Generator rules:

- Require resolved audio for the prompt phrase.
- Prefer distractors from the same broad category so the choice is meaningful.
- Avoid distractors that could be dangerously close in health, emergency, payment, or safety contexts.
- Explain why the correct option fits the travel moment.

Why this belongs in MVP: it uses existing offline audio, helps travelers recognize speech, and avoids typing.

### 2. Situation Pick

The app gives a short travel context, such as "You are checking in and need your room key." The user chooses the best Vietnamese phrase.

Best source data:

- scenario IDs;
- page summaries;
- `At a glance`;
- `When to use it`;
- local tips and warnings;
- phrase rows within the same authored page.

Generator rules:

- Write the situation in traveler language, not internal category language.
- Make the wrong options plausible but not unsafe.
- Include one sentence of feedback that names the situation cue.

Why this belongs in MVP: it tests use, not isolated translation.

### 3. Pronoun Coach

The app asks which greeting or phrase fits a relationship cue: older man, older woman, someone younger, elderly woman, peer, or service worker.

Best source data:

- authored rows that already contain social-role language, such as `Anh/chị nói tiếng Anh không?` and `Anh/chị giúp tôi với`;
- social/local greeting pages that exist today, especially `Bạn khỏe không?`;
- future authored greeting/pronoun pages only after they exist in `viet-authored-listing-pages.json`.

Generator rules:

- Keep the first release bounded to authored evidence. If the current page set does not contain enough explicit pronoun teaching for a safe deck, the follow-up generator should emit a skipped-candidate report instead of inventing `Chào anh`, `Chào chị`, `Chào em`, `Chào ông`, `Chào bà`, `Chào chú`, or `Chào cô` pages.
- Use explanations that describe social relationship plainly.
- Do not overgeneralize Vietnamese kinship terms beyond the authored page evidence.

Why this belongs in MVP: Vietnamese pronoun/social role choice is one of the highest-value SpeakLocal teaching points.

### 4. Practice This Page

From a listing page, the user starts a focused mini deck for that phrase family.

Best entry points:

- a small glass action near the hero/player area;
- a secondary action near variants, pronoun, likely-reply, or Explore-next sections;
- Saved/recent phrase surfaces later.

Generator rules:

- Prefer `3` to `5` prompts.
- Mix one listening prompt, one situation prompt, and one page-specific distinction when enough data exists.
- Finish with a link back to the source page and, only when the target resolves, one related page to open next.
- Validate any related/Explore `detailPageID` against authored `pages[].id` before using it in practice. If a target is unresolved, omit it from practice output and record a skipped-candidate reason.

Why this belongs in MVP: it connects article-style explanation to memory work at the moment of interest.

### 5. Review Missed

The app keeps a local missed/retry list and surfaces those items later.

Best source data:

- local-only progress state;
- prompt ID;
- source phrase/page ID;
- last practiced timestamp;
- last result;
- category and phrase page links.

Generator/runtime rules:

- Review missed prompts sooner than correct prompts using the MVP spacing rules below.
- The review deck is due-first: show due missed prompts first, then due low-confidence prompts, then new prompts from the selected deck.
- Let users start the deck intentionally; do not make the app feel punitive.
- Keep the state local for MVP.

Why this belongs in MVP: it adds retention without accounts, sync, or pressure-heavy streak mechanics.

### MVP spacing rules

The first scheduler should be simple enough to inspect and deterministic enough to test.

Suggested local state per prompt:

- `seenCount`;
- `correctStreak`;
- `missedCount`;
- `lastSeenAt`;
- `nextDueAt`;
- `lastResult`;
- `sourceDeckID`;
- `sourcePageID`.

Initial update rules:

- First correct result: `nextDueAt = now + 1 day`.
- Second consecutive correct result: `nextDueAt = now + 3 days`.
- Third and later consecutive correct result: `nextDueAt = now + 7 days`, capped there for MVP.
- Incorrect result: reset `correctStreak` to `0`, increment `missedCount`, and set `nextDueAt = now + 10 minutes`.
- Correct after a miss: set `correctStreak = 1` and `nextDueAt = now + 1 day`.
- User taps `Try again` and then answers correctly in the same session: keep the item in missed/retry until the next short due interval has passed; do not treat same-session correction as durable mastery.

Due-selection rules:

- A dedicated `Review Missed` deck shows prompts where `nextDueAt <= now`, sorted by oldest due first, then highest `missedCount`.
- If fewer than `5` prompts are due, fill the session with low-confidence prompts from the same selected context, then new prompts.
- Regular category/page practice may include at most `2` due missed prompts before new material, so practice does not feel like a penalty loop.

This is not a full spaced-repetition engine. It is a transparent MVP schedule that gives missed items another retrieval attempt without adding accounts, sync, streak debt, or confusing daily workload.

### Post-MVP mode: Build It

The app shows shuffled breakdown cards and asks the user to put them in phrase order, then plays the full phrase.

This is high value but should wait unless follow-up generator and UI proof show the data is clean enough. It needs a more custom UI, stricter token ordering, and careful audio behavior for tokens plus full phrases.

## Navigation and UX shape

Recommended first version:

- Add a `Practice` card or quick-access destination from home.
- Add `Practice this` on authored listing pages.
- Let users choose:
  - my practice phrases;
  - starter Tier 1;
  - category;
  - pronouns/social;
  - current listing page;
  - saved;
  - recent;
  - missed/retry.
- Add Saved/recent phrase decks once saved/recent page ID persistence exists; add `My practice phrases` as soon as the add/remove pool exists.
- End a compact round with a restrained success moment, a recap of what was matched, and `Next round` as the primary action. Avoid dead-end copy such as `Back to Practice` after a successful round.
- Let contextual Practice starts dismiss cleanly back to the originating Home, Browse, Saved, city, menu, or phrase surface. Inside an active Practice layer, the close button exits the layer; any back affordance inside the layer should mean previous round/card, not app-level navigation.

Session design:

- Default match length: `4` pairs.
- Default deck length: `5` prompts when using prompt-based decks.
- Listing page deck length: `3` to `5` prompts.
- Match rounds use controlled random selection from the full eligible source, avoid immediate repeats when enough items exist, and softly cycle through the pool. Do not expose `80 remaining`, mastery percentages, XP, streaks, lives, or course-map progress.
- Use subtle progress indicators, such as small dots or the solved card state itself. Avoid visible `0 of 4` text when the board already communicates completion.
- No visible countdown timer in MVP.
- No lives, hearts, or streak-blocking UI.
- Let users stop after any prompt without penalty.

Native feel:

- Practice should use compact SwiftUI-native surfaces, large tap targets, clear audio controls, and stable glass chrome.
- Prompt cards should not sit inside decorative card stacks. Keep the main prompt surface readable and let controls feel like native app controls.
- Feedback should appear near the answer and be available through text plus sound/haptics where implementation chooses to support them.
- Long English options must wrap instead of shrinking into unreadability.

## Feedback model

Correct answer:

- confirm with a restrained success state;
- offer audio replay;
- show one line explaining the real-world cue;
- optionally let the mascot appear in non-sensitive contexts.

Wrong answer:

- avoid punitive language;
- show the correct answer;
- explain the distinction that matters;
- add the prompt to local missed/retry;
- offer `Try again` or `Next`.

Hints:

- reveal the category or situation cue before revealing the answer;
- avoid instant answer leakage;
- do not reduce the session to speed tapping.

Sensitive categories:

- emergency, safety, health, police, payment dispute, and scam contexts should use calm feedback and minimal personality.
- the mascot can be absent or neutral in these prompts.

## Data model direction

Target generated resources:

```text
native-ios/Resources/LanguagePacks/viet/
  practice-decks.json
  practice-audio-audit.json
```

Current resource reality: live Viet loaders still use root-level `native-ios/Resources/*.json`. If the follow-up practice-generator task starts before the language-pack migration, it may generate:

```text
native-ios/Resources/viet-practice-decks.json
native-ios/Resources/viet-practice-audio-audit.json
```

That should be treated as a temporary native resource location and migrated into `LanguagePacks/viet/` when the loader/resource migration lands.

Suggested JSON concepts:

- `PracticeDeck`
- `PracticePrompt`
- `PracticeOption`
- `PracticeExplanation`
- `PracticeSkillTag`
- `PracticeSource`
- `PracticeSensitivity`
- `PracticePoolSelection`
- `PracticeDistractorSet`

Prompt fields should include:

- stable `id`;
- `mode`;
- `language`;
- `targetPhraseID`;
- `sourcePageID`;
- `sourceFamilyID`;
- `sourcePhraseID`;
- `sourceSectionID`;
- optional `sourcePhraseRowID`;
- optional `sourceBreakdownTokenID`;
- `scenarioID`;
- `selectionEligibility`, such as `my-practice`, `this-page`, `saved`, `recent`, `missed`, `category`, or `pronoun`;
- `questionText`;
- optional `audioKey`;
- `options`;
- `correctOptionID`;
- `explanation`;
- `skillTags`;
- `sensitivity`;
- `requiresAudio`;
- `generatorVersion`.

Each option should include:

- stable `id`;
- optional `phraseID`;
- display Vietnamese text;
- optional pronunciation/audio key;
- optional English shown only after selection when the prompt mode needs active recall;
- `isCorrect`.

For SQLite, the bundled read model should be able to represent:

- generated practice items keyed to canonical phrase/page IDs;
- generated option/distractor sets;
- phrase-to-practice-mode eligibility;
- audio usage for prompt and option playback.

Mutable local user data should stay outside the bundled read-only SQLite file:

- saved phrase/page IDs;
- selected practice phrase IDs;
- removed/hidden phrase IDs;
- recently opened page IDs;
- practiced/missed/due state;
- last selected quiz modes and filters;
- lightweight ranking timestamps such as savedAt, addedToPracticeAt, openedAt, practicedAt, and missedAt.

Suggested skill tags:

- `listening`
- `meaning`
- `situation`
- `pronoun`
- `breakdown`
- `reply`
- `saved`
- `missed`

Local device state can stay simple:

- saved phrase/page IDs;
- selected practice phrase IDs;
- selected practice page IDs if the user adds a full page/deck later;
- recent canonical page IDs;
- prompt ID;
- practiced count;
- correct count;
- missed count;
- seen count;
- correct streak;
- last result;
- last seen;
- next suggested review;
- source deck ID;
- source page ID.

The first implementation should avoid cloud sync, accounts, social state, and remote analytics.

## Implementation readiness contract

Keep the first implementation split into four layers so Home, Practice, Search/Browse, and future SQLite work do not duplicate product decisions.

### Bundled read-only phrase graph data

Bundled content owns:

- phrase, page, cluster, scenario, relation, section, breakdown-token, and audio IDs;
- generated practice prompt templates and distractor pools keyed to canonical phrase/page IDs;
- speaker-control eligibility and missing-audio audit output;
- search/routing aliases that keep every phrase on one canonical page.

The app must not mutate this bundled content at runtime. JSON remains the current production live source while the T-165 DEBUG SQLite read path proves bundle packaging/read-only access; SQLite is the planned read model, not the user-state store.

### Mutable local user state

Local app-container state owns:

- saved and unsaved page/phrase IDs;
- practice-pool add/remove choices;
- recent page history;
- practiced, missed, due, and last-result fields;
- last mode/filter choices that help resume a session.

This state can later migrate between storage implementations, but the product contract stays the same: it is private, offline, deterministic, and device-local for MVP.

### Recommendation and ranking rules

Ranking should combine deterministic bundled graph signals with local intent:

- saved and practice-selected phrases first;
- due/missed practice items next when the user is in Practice or a calm review shelf;
- recent pages for `Continue`, related rows, and category reordering;
- graph-nearby phrases from the same scenario, phrase cluster, social/relationship family, likely reply, next-step, repair, or escalation relation;
- curated essentials when local state is empty.

These are deterministic rules, not AI recommendations.

### User-facing surfaces

The consuming surfaces are:

- Home: first launch shows essentials; returning Home can show `Continue`, saved/practice-pool shelves, and calm "Because you practiced..." recommendations.
- Practice: `My practice phrases`, `Saved`, `Recent`, `This page`, `Review missed`, category, and pronoun/social filters all assemble sessions from the same prompt templates.
- Search/Browse/Explore: category rows and related shelves can favor saved/practiced/recent graph neighborhoods without hiding the full library.
- Listing pages: phrase pages and row surfaces offer `Add to practice`, remove/manage state, `Practice this page`, and source-page return after a session.

## Generator direction

A follow-up practice-generator task should produce a deterministic generator that:

- reads the generated Viet phrase catalog;
- reads authored listing pages;
- reads the authored audio audit;
- reads canonical phrase IDs and phrase-page aliases from the SQLite phrase graph once that path is available;
- builds an authored-page ID set and validates every practice source/related target against it;
- builds per-page section, phrase-row, and breakdown-token ID sets from authored listing-page sections;
- emits practice prompts keyed by `targetPhraseID` so user-selected phrases can drive session construction;
- emits distractor pools that can fill answer slots around a selected target phrase;
- emits practice decks and a practice-specific audio audit;
- creates stable IDs from canonical page/family/phrase IDs;
- skips prompts that cannot be made safe and explainable;
- skips any prompt whose `sourceSectionID`, `sourcePhraseRowID`, or `sourceBreakdownTokenID` does not resolve inside the declared `sourcePageID`;
- skips any related-page or Explore-next practice action whose `detailPageID` does not resolve to an authored page ID;
- logs skipped prompt candidates by reason.

Prompt generation quality rules:

- Every prompt needs a source pointer back to authored content truth.
- Every prompt needs a target phrase, row, relation, or breakdown token that can be the correct answer when a user selected that phrase for practice.
- Every source page, source section, source family, source phrase, phrase-row anchor, breakdown-token anchor, and related page pointer must resolve before it appears in practice output.
- Practice explanations may summarize authored page teaching, but they must not invent new phrase-page facts. If a prompt needs a nuance that is not anchored to an authored section, skip the prompt or add that authored content in a separate content task first.
- Every prompt with audio must have a resolved audio key.
- Distractors should be plausible enough to teach, not random.
- Distractors should come from graph-nearby candidates whenever possible: same category, same pronoun/relationship family, same intent, same phrase shape, or same source page.
- Emergency/safety/health distractors require extra caution.
- Pronoun prompts require explicit authored evidence.
- Prompt explanations should be short, concrete, and traveler-facing.

Known current graph cleanup issue:

- Gate 2 review found unresolved authored-page `detailPageID` targets including `viet-polite-hello` and `viet-family-repair-meaning`. This planning task does not edit generated authored resources, so the follow-up practice-generator task must protect practice output by validating and skipping unresolved targets, while a separate content/graph task can repair the underlying authored links.

## Mascot lane

No usable native mascot asset exists yet, so mascot work must start as an asset/design task.

Required mascot package before native integration:

- one final character direction;
- transparent PNG or layered raster source;
- app-icon-safe palette compatibility;
- light and dark background checks;
- pose/export sheet:
  - neutral guide;
  - listening;
  - correct;
  - try again;
  - hint;
  - local/cultural note;
  - completed mini session.

Behavior rules:

- use sparingly;
- never block answering;
- never cover phrase text or audio controls;
- avoid childish copy;
- avoid celebratory or comic treatment in serious contexts;
- keep the mascot outside core chrome unless a future design pass proves otherwise;
- make it optional to hide from a prompt without changing the learning flow.

Mascot copy should sound like a calm local guide, not a game announcer.

## Go-live to-do list

Before any go-live claim involving practice:

- complete T-159 and let Jojo review this product plan;
- implement offline practice deck generation from current authored content;
- implement a native Practice destination and listing-page `Practice this` entrypoint;
- add local-only practice progress and missed/retry behavior;
- create final mascot art direction and native asset integration;
- audit practice audio so every visible speaker control resolves offline;
- simulator-check practice on the main iPhone 17 Pro viewport;
- device-proof the native app before any TestFlight/App Store claim;
- keep release docs honest that practice exists only after the generator, UI, audio audit, simulator proof, and device proof land.

## Follow-up task recommendations

These are draft recommendations. Do not queue them until Jojo reviews this plan.

### Follow-up: Offline Viet practice deck generator

Outcome: Generate deterministic practice deck resources from the Viet catalog, authored listing pages, and audio audit.

Write scope:

- native generator scripts;
- generated practice JSON/audit resources;
- focused docs/result artifacts.

Validation:

- JSON validation;
- generator rerun stability;
- practice audio audit;
- small sample readback of each prompt mode.

### Follow-up: Native Practice UI and listing-page entrypoints

Outcome: Build the SwiftUI Practice destination, session flow, feedback states, and `Practice this` listing-page entrypoint against generated resources.

Write scope:

- `native-ios/App/**`;
- `native-ios/project.yml` only if resources or files need registration;
- native documentation/results.

Validation:

- XcodeGen if project files change;
- iPhone 17 Pro simulator build;
- manual simulator smoke of home entry, page entry, answer feedback, missed review, and back/search chrome behavior.

### Follow-up: Mascot art direction and asset integration

Outcome: Choose and integrate the first mascot asset sheet with usage rules and native render points.

Write scope:

- mascot design spec;
- native asset catalog additions;
- small SwiftUI render surface if T-161 has already landed.

Validation:

- asset catalog validity;
- light/dark/background checks;
- serious-context absence/neutrality check.

### Follow-up: Practice progress state and personalized shelves

Outcome: Extend the T-167 local intent store with practiced, missed, due, and session-progress contracts, then expose only the Home/Practice shelves whose state exists.

Write scope:

- native local-state model extensions/storage migrations;
- Practice selectors and any Home shelf extensions beyond T-167's saved/recent/practice-pool shelves;
- tests or focused validation logs;
- operational docs only if release truth changes.

Validation:

- local state persists across restart;
- removing from practice or unsaving updates Home/Practice surfaces;
- no shelf appears as a dead empty promise on first launch;
- all stored IDs are canonical page/phrase IDs or explicit aliases.

### Follow-up: Practice validation and release-readiness pass

Outcome: Validate practice data, audio, navigation, local progress, simulator behavior, and device-proof checklist before any go-live claim.

Write scope:

- validation logs;
- operational docs if live truth changes;
- bugfixes only if tightly scoped and allowed by the task.

Validation:

- `git diff --check`;
- queue repair;
- JSON validation;
- simulator proof;
- physical-device proof or explicit blocker state.

## Deferred decisions

These are intentionally not first-release blockers:

- cloud sync for practice progress;
- account-backed personalization;
- speech recognition;
- typed Vietnamese answers;
- public streaks, leagues, achievements, or leaderboards;
- a large game map/world;
- remote prompt generation;
- practice analytics beyond local state.
