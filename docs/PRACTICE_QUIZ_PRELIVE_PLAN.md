# Practice And Quiz Pre-Live Plan

Last updated: 2026-04-28  
Owner lane: SpeakLocal native app-family planning  
Status: implementation-ready planning source of truth

Alignment note: `T-160` is now the SQLite phrase-graph architecture task, not the practice deck generator. Any remaining practice generator, practice audio audit, skipped-candidate report, simulator proof, or device proof work belongs to follow-up queue tasks.

## Decision snapshot

SpeakLocal practice should be a traveler rehearsal layer, not a generic course game.

First version decisions:

- Keep practice fully offline and deterministic from bundled content. No runtime AI, network prompt generation, accounts, leagues, public leaderboards, hearts, or punitive lives.
- Start with compact native sessions that rehearse the exact phrase graph users are already browsing: authored listing pages, phrase rows, pronunciation audio, breakdown tokens, and category context.
- MVP modes are `Listen And Choose`, `Situation Pick`, `Pronoun Coach`, `Practice This Page`, and `Review Missed`.
- MVP active recall is deliberate but bounded: users must retrieve meaning, use-case, social role, or next action before seeing feedback. Hold full phrase-construction `Build It` for the first post-MVP iteration unless a follow-up deck/audio generator task proves token sequencing and token audio are release-clean.
- Use a `Practice` destination from home/quick access plus contextual `Practice this` actions on listing pages. Wait on a permanent fourth bottom-chrome item until simulator/device proof says it improves navigation instead of crowding the app shell.
- Use the mascot sparingly as a guide, hint, completion, or cultural-note layer. In health, emergency, safety, and money-dispute contexts, keep the mascot neutral or absent.
- Default sessions should be short: `5` prompts for a deck, `3` to `5` prompts from a single listing page, with `Keep going` after completion.
- Missed-phrase review should be available as its own deck and also suggested after a session. It should never feel like punishment.

## Why this matters

The current native app is becoming a strong offline phrase library. Practice makes that library feel useful before a traveler is standing at a counter, in a taxi, or asking for help.

The practice area should help users rehearse:

- phrases by category, such as hotel, airport, money, food, health, and transport;
- social/pronoun choices, especially `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô`, and `bạn`;
- one listing page or phrase family they just read;
- saved, recent, or missed phrases;
- listening recognition with bundled audio;
- short real-world situations rather than abstract translation drills.

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

`native-ios/Resources/LanguagePacks/viet/` exists but currently contains only `.gitkeep`. Per `docs/APP_FAMILY_STRUCTURE.md`, the language-pack folder is the target resource direction, while current live Viet resources still sit at `native-ios/Resources/*.json`.

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
  - starter Tier 1;
  - category;
  - pronouns/social;
  - current listing page;
  - missed/retry.
- Add Saved/recent phrase decks after the basic local progress model exists.
- End every session with:
  - practiced count;
  - missed count;
  - replay missed;
  - open source page;
  - continue category.

Session design:

- Default deck length: `5` prompts.
- Listing page deck length: `3` to `5` prompts.
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

Prompt fields should include:

- stable `id`;
- `mode`;
- `language`;
- `sourcePageID`;
- `sourceFamilyID`;
- `sourcePhraseID`;
- `sourceSectionID`;
- optional `sourcePhraseRowID`;
- optional `sourceBreakdownTokenID`;
- `scenarioID`;
- `questionText`;
- optional `audioKey`;
- `options`;
- `correctOptionID`;
- `explanation`;
- `skillTags`;
- `sensitivity`;
- `requiresAudio`;
- `generatorVersion`.

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

## Generator direction

A follow-up practice-generator task should produce a deterministic generator that:

- reads the generated Viet phrase catalog;
- reads authored listing pages;
- reads the authored audio audit;
- builds an authored-page ID set and validates every practice source/related target against it;
- builds per-page section, phrase-row, and breakdown-token ID sets from authored listing-page sections;
- emits practice decks and a practice-specific audio audit;
- creates stable IDs from canonical page/family/phrase IDs;
- skips prompts that cannot be made safe and explainable;
- skips any prompt whose `sourceSectionID`, `sourcePhraseRowID`, or `sourceBreakdownTokenID` does not resolve inside the declared `sourcePageID`;
- skips any related-page or Explore-next practice action whose `detailPageID` does not resolve to an authored page ID;
- logs skipped prompt candidates by reason.

Prompt generation quality rules:

- Every prompt needs a source pointer back to authored content truth.
- Every source page, source section, source family, source phrase, phrase-row anchor, breakdown-token anchor, and related page pointer must resolve before it appears in practice output.
- Practice explanations may summarize authored page teaching, but they must not invent new phrase-page facts. If a prompt needs a nuance that is not anchored to an authored section, skip the prompt or add that authored content in a separate content task first.
- Every prompt with audio must have a resolved audio key.
- Distractors should be plausible enough to teach, not random.
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

### T-161: Native Practice UI and listing-page entrypoints

Outcome: Build the SwiftUI Practice destination, session flow, feedback states, and `Practice this` listing-page entrypoint against generated resources.

Write scope:

- `native-ios/App/**`;
- `native-ios/project.yml` only if resources or files need registration;
- native documentation/results.

Validation:

- XcodeGen if project files change;
- iPhone 17 Pro simulator build;
- manual simulator smoke of home entry, page entry, answer feedback, missed review, and back/search chrome behavior.

### T-162: Mascot art direction and asset integration

Outcome: Choose and integrate the first mascot asset sheet with usage rules and native render points.

Write scope:

- mascot design spec;
- native asset catalog additions;
- small SwiftUI render surface if T-161 has already landed.

Validation:

- asset catalog validity;
- light/dark/background checks;
- serious-context absence/neutrality check.

### T-163: Practice validation and release-readiness pass

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
