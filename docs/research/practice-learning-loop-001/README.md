# Practice Learning Loop R&D

Research date: 2026-05-03
Research question: What should SpeakLocal Practice teach, how should saved and selected phrases feed it, and which quiz modes are worth building for first-time travelers learning real Vietnamese phrases?
Decision this should inform: The next native Practice implementation pass and any follow-up Practice Core/content-data task cards.
Assignment source: `docs/task-cards/TASK-PRACTICE-LEARNING-LOOP-RD-001.md`
Owner lane: Research / Product Strategy

## Executive Takeaway

Practice should become a calm **phrase rehearsal loop**, not a general quiz area.

The current native Practice MVP already has useful parts: real phrase/page data, local missed/ready state, Saved Review, explicit Add to Practice, city modes, placement prompts, and Melo as a restrained companion hook. The weak part is product framing and session priority. The app still leads with city "Bucket List" practice and broad multiple-choice quiz cards, so the experience can feel like a language-app quiz instead of helping the traveler rehearse the exact Vietnamese phrases they saved, added, heard, missed, or need for a trip.

Recommended next direction: **Saved Phrase Rehearsal + Audio-First Trip Practice**.

For the next native pass, make Practice answer one user question: "Which real phrases am I more ready to say or recognize now?" The first screen should prioritize missed prompts due for calm review, phrases explicitly added to Practice, then saved/recent phrase pages, with city/category trip prep as a starter fallback when the user has no personal queue. The first session should be 3-5 prompts, audio-first when audio exists, source-linked, positive, and short enough to complete while standing in a hotel lobby or planning a day out.

Keep the tab label `Practice`, but use more specific in-flow language: `Rehearse saved phrases`, `Review missed`, and `Trip practice`. Avoid `Bucket List` as the main learning frame.

## Audience And Source Map

### Repo Truth Used

| Source | What It Proved |
| --- | --- |
| `docs/task-cards/TASK-PRACTICE-LEARNING-LOOP-RD-001.md` | Task contract, result requirements, boundaries, and research questions. |
| `docs/DECISIONS.md` | Practice must use local private state; Add to Practice should target the selected canonical phrase/page/row/token; Practice Core is prepared offline contract, not current runtime source. |
| `docs/practice/VIET_PRACTICE_CORE_PLAN.md` | Practice Core is phrase-sourced, offline, source-anchored, and currently defines 7,200 items, 8 question types, and 5 flows. |
| `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md` | Reward loop should be local readiness, not XP; missed prompts should become calm review; Melo is only a restrained Practice companion. |
| `native-ios/App/Views/PracticeView.swift` | Current native flow: hub, city paths, Saved Review, Missed Review, placement/session/completion surfaces, Melo hook, floating continue. |
| `native-ios/App/Models/PracticeModels.swift` | Current runtime model: city modes, four native prompt kinds, prompt generation, local progress, ready/missed IDs, SQLite-backed candidates. |
| `native-ios/Tests/PracticeNativeMVPTests.swift` | Current guarantees: real phrase/audio data, city metadata, saved review separation, missed review reappearance, placement prompt focus. |
| `native-ios/UITests/PracticeUITests.swift` | Current UI regression focus: wrong-answer continuation to next prompt. |
| `docs/task-results/TASK-PRACTICE-NATIVE-MVP-001.md` | Current native MVP decisions, screenshots, validation, and known design decisions. |
| `docs/task-results/TASK-PRACTICE-NATIVE-POLISH-001.md` | Current polish result: simplified hub, city chips, placement launch, Melo raster hook, phrase-sourced placement. |
| `docs/task-results/TASK-PRACTICE-REWARD-MASCOT-001.md` | Prior reward/mascot recommendation and risky game-pattern exclusions. |

### Public Sources Used

Access date for public sources: 2026-05-03.

| Category | Sources | How Used |
| --- | --- | --- |
| Competitor practice systems | [Duolingo Practice tab](https://blog.duolingo.com/guide-to-duolingo-practice-hub/), [Duolingo learner research / Practice Hub](https://blog.duolingo.com/how-duolingo-works-with-learners/), [Duolingo learning method](https://blog.duolingo.com/duolingo-teaching-method/), [Duolingo spaced repetition / HLR](https://blog.duolingo.com/how-we-learn-how-you-learn/), [Duolingo ways to practice](https://blog.duolingo.com/ways-to-practice-in-duolingo/) | Confirmed strong apps separate mistakes, words, listening, speaking, stories/content review, and personalized practice. |
| Review/spaced repetition tools | [Babbel Review](https://support.babbel.com/hc/en-gb/articles/205600228-Vocab-workout-Review), [Babbel memorizing vocabulary](https://support.babbel.com/hc/en-us/articles/360037496932-Memorizing-vocabulary), [Quizlet Learn](https://help.quizlet.com/hc/en-us/articles/360030986971-Studying-with-Learn), [Quizlet spaced repetition](https://quizlet.com/se/features/spaced-repetition), [Anki filtered decks](https://docs.ankiweb.net/filtered-decks.html?highlight=%3Adue) | Confirmed due review, user-selected sets, starred/custom items, wrong-answer review, and cram/trip-prep modes are established patterns. |
| Audio/travel phrase comparators | [Pimsleur FAQ](https://www.pimsleur.com/pimsleur-faq/), [Pimsleur Method](https://www.pimsleur.com/the-pimsleur-method), [Pimsleur graduated interval recall blog](https://www.pimsleur.com/blog/why-graduated-interval-recall-is-the-key-to-mastering-a-new-language/), [Rosetta Stone Phrasebook](https://www.rosettastone.com/features/phrasebook/), [Rosetta Stone mobile apps](https://www.rosettastone.com/product/mobile-apps/) | Supported audio-first recall, pronunciation practice, offline lessons/phrasebook access, and travel phrase utility. |
| Translation/phrasebook utility | [Apple Translate iPhone guide](https://support.apple.com/en-sg/guide/iphone/iphd74cb450f/ios), [Google Translate App Store](https://apps.apple.com/us/app/google-translate/id414706506), [Google Translate tips](https://support.google.com/translate/answer/10421057?hl=en), [Microsoft Translator features](https://www.microsoft.com/en-us/translator/apps/features/?msockid=2897e2a916d96b8c09c1f4c817476a32), [Microsoft Translator Android FAQ](https://www.microsoft.com/en-us/translator/help/android/) | Confirmed favorites, offline packs, playback speed, phrasebook, and travel categories matter more than game mechanics for travelers. |
| App-store/review surfaces | [Drops Google Play](https://play.google.com/store/apps/details?hl=en-US&id=com.languagedrops.drops.international), [Drops App Store reviews](https://apps.apple.com/us/app/drops-language-learning-games/id939540371?see-all=reviews), [Pimsleur App Store](https://apps.apple.com/us/app/pimsleur-language-learning/id1405735469), [Rosetta Stone App Store](https://apps.apple.com/gb/app/learn-languages-rosetta-stone/id435588892), [Quizlet App Store](https://apps.apple.com/us/app/quizlet-study-with-flashcards/id546473125?l=en) | Triangulated how products describe offline access, audio, review, question formats, and user-customized study. |
| Public user/forum pain | [r/travel offline translator](https://www.reddit.com/r/travel/comments/vdx722/translator_app_that_doesnt_need_internet/), [basic travel phrases are hard to find](https://www.reddit.com/r/SideProject/comments/1so530t/looking_up_basic_phrases_while_traveling_is_way/), [Duolingo streak/XP thread](https://www.reddit.com/r/duolingo/comments/xf0y5s), [Duolingo practice-to-earn-hearts thread](https://www.reddit.com/r/duolingo/comments/1h108kl), [Babbel reviews getting too much](https://www.reddit.com/r/babbel/comments/1izlr93/reviews_are_getting_too_much/), [Memrise spaced repetition thread](https://www.reddit.com/r/memrise/comments/1e5ei86/spaced_repetition/), [language app biggest problems](https://www.reddit.com/r/languagelearning/comments/1lze50r), [speaking app comparison](https://www.reddit.com/r/Spanish/comments/1rtbowc/i_tried_every_speaking_app_so_you_dont_have_to/), [AI language app skepticism](https://www.reddit.com/r/languagelearning/comments/1qlapi8/are_all_ai_language_learning_apps_garbage/) | Directional evidence for offline confusion, exact phrase lookup, review overload, weak pronunciation scoring, and resentment toward XP/streak/heart pressure. |
| Learning science | [Duolingo HLR paper listing](https://research.duolingo.com/), [Duolingo HLR paper](https://research.duolingo.com/papers/settles.acl16.pdf), [Retrieval practice overview](https://journals.sagepub.com/doi/10.1177/1475725720976462), [Teaching science of learning](https://pmc.ncbi.nlm.nih.gov/articles/PMC5780548/), [Systematic review of distributed and retrieval practice](https://link.springer.com/article/10.1007/s10459-023-10274-3), [Spaced repetition meta-analysis](https://pubmed.ncbi.nlm.nih.gov/41601436/), [Interleaving retrieval practice](https://journals.sagepub.com/doi/10.1177/09567976211057507), [Testing effect / pre-testing study](https://www.nature.com/articles/s41539-019-0053-1) | Supported retrieval practice, spacing, feedback, manageable challenge, and the need to avoid recognition-only review as the whole learning loop. |

X was not used. Public X access is noisy/gated, and the source mix above was sufficient without bypassing login or rate limits.

No new video digest was created. Existing repo screenshots/results and written public sources were enough for this decision.

## Current Practice Diagnosis

### What Is Strong

| Current Behavior | Product Value |
| --- | --- |
| SQLite-backed phrase/page candidates | Practice is already grounded in the bundled phrase graph rather than invented trivia. |
| Local progress state | Missed and ready prompt state can stay private and offline. |
| Saved Review separation | Saved pages are not automatically mixed into the city path, which keeps intent clearer. |
| Add to Practice state | The product has the right hook for explicit learner intent. |
| Missed Review | Wrong answers can become a calm follow-up instead of a penalty. |
| Placement mode | A short phrase-based onboarding check is possible without grammar exams. |
| City metadata | Practice can support trip-prep modes by destination. |
| Melo hook | Reward/companion behavior can stay in Practice only and not pollute phrase pages/search/playback. |

### What Feels Weak Or Confusing

| Issue | Evidence | Product Meaning |
| --- | --- | --- |
| The first-screen priority still reads city-first, not learner-intent-first | `PracticeHubSurface` leads with `Hanoi Bucket List`, then other city chips, then Saved/Missed rows. | Jojo's saved/add-to-practice intent should feel like the center of Practice, not secondary utilities below a city path. |
| `Bucket List` is the wrong mental model | Current `PracticeMode.hanoiBucketList` title and completion copy use bucket-list framing. | It sounds like destination trivia or sightseeing progress, not phrase rehearsal. |
| Prompt kinds are broad but shallow | Native currently has listen/pick, English-to-Vietnamese, Vietnamese-to-English, and missing-token. | This is a solid MVP set, but the session needs a teaching sequence so it does not feel like random multiple choice. |
| Missing-token can feel artificial if used too early | The token prompt blanks a piece of the Vietnamese phrase. | Better after the user has heard/seen the phrase, and only when breakdown tokens are authored and useful. |
| Completion copy over-indexes on mascot/reward hook | `A phrase reached ready status... mascot hook...` is implementation-facing. | User copy should say what phrase is more ready, not explain the mascot system. |
| Local readiness threshold is prompt-based | Current `isReady` becomes true after two correct answers on the same prompt ID. | The product goal is phrase readiness. Future state should also aggregate by `source.phraseID` or canonical page. |
| Review due timing is too raw | Missed prompts become due after 10 minutes, correct prompts after 1 day, ready after 2 correct. | Good enough as a state hook, but the user-facing loop should describe "review next" and "ready" without exposing schedule mechanics. |
| Personal queues are not yet the default session | The snapshot includes explicit, saved, missed, city, audio starter, and general candidates, but the hub still starts with city mode. | Reorder the product around missed -> added -> saved/recent -> trip starter. |

### Current Validators Prove Useful But Narrow Things

The native Practice tests show important guardrails:

- generated prompts use real phrase/page/audio data;
- city metadata is preserved;
- city modes cover the expanded city library;
- city modes start from city-specific prompts;
- Vietnamese-to-English options do not leak answer subtitles;
- placement prompts stay phrase-learning focused;
- Saved Review stays separate from the explicit practice pool;
- empty Saved Review does not fall back to general candidates;
- missed prompts reappear in Missed Review;
- local progress persists in isolated `UserDefaults`.

Those tests are good. The next implementation needs product-flow tests around session ordering and copy, not a replacement of these tests.

## Findings

### 1. The strongest products separate "what to practice" from "how to practice"

Duolingo's Practice tab separates mistakes, words, speaking, listening, stories/content review, and other targeted options. Babbel separates due vocabulary review, weak/medium/strong states, and custom collections. Quizlet lets a learner choose a set, star terms, choose question types, and retype missed answers. Anki filtered decks support custom study, forgotten cards, due cards, tags, and trip/test cramming.

SpeakLocal implication: Practice needs two clear layers:

- Queue: missed, added to Practice, saved, recent, trip/city/category.
- Mode: listen, recognize, say from English cue, rebuild chunk, likely reply.

Do not make "Hanoi Bucket List" carry both layers.

Confidence: high.

### 2. Audio-first is the best fit for travel readiness

Pimsleur, Rosetta Stone Phrasebook, Microsoft Translator, Apple Translate, and Google Translate all signal the same traveler reality: hearing and playback matter. Pimsleur's method is built around listening and recall; Rosetta Stone Phrasebook pairs native speaker pronunciation with practice; Microsoft emphasizes pronunciation guides and audio speed; Apple exposes audio playback and playback speed for translations.

SpeakLocal implication: the first Practice prompt for an audio-backed saved phrase should usually be listening recognition or listen-then-repeat guidance, not a text-only quiz. Speaker icons are already a product promise in the repo.

Confidence: high.

### 3. Missed review is useful only when it feels like help, not punishment

Duolingo's own learner research says users wanted mistakes made visible and practiced. But public Duolingo threads show resentment when mistakes interact with hearts, energy, streaks, or progress blocking. The Babbel Reddit thread shows review backlog can become grind when users cannot focus on what is actually hard.

SpeakLocal implication: missed prompts should be "Saved for review" with the correct phrase, audio, and source link visible. No hearts, lives, red failure loop, XP, leaderboard, or streak pressure.

Confidence: high.

### 4. Personal selection is a stronger signal than generic recommendations

Babbel custom collections, Quizlet starred terms/sets, Anki filtered decks, Google phrasebook/favorites, Apple favorites, Microsoft favorites, and SpeakLocal's own Add to Practice all point to the same pattern: users expect saved/selected items to become reviewable.

SpeakLocal implication: an explicit Add to Practice phrase should outrank city recommendations. Saved pages should become a lighter review source, especially if the user has not built a practice pool yet.

Confidence: high.

### 5. Spacing and retrieval matter, but the app should not expose SRS machinery

Learning-science sources support retrieval practice, spacing/distributed practice, interleaving, feedback, and desirable difficulty. But traveler Practice is not a school SRS dashboard. Anki's trip/cram guidance is useful because it admits special sessions exist, but also cautions against repeated review-ahead loops.

SpeakLocal implication: use local due/missed/ready ranking quietly. The UI should say "2 saved hotel phrases to review" or "3 missed phrases ready for a calm pass," not "spaced repetition due queue."

Confidence: high.

### 6. Pronunciation scoring is risky for this app right now

Public speaking-app and Pimsleur Voice Coach discussions repeatedly complain about speech recognition leniency, delay, or false feedback. Some products can do this well, but high-quality pronunciation scoring is a specialized model/product problem. SpeakLocal is offline-first and has no runtime AI direction.

SpeakLocal implication: do not build a scored speaking mode yet. Build audio-first self-rehearsal: hear native audio, optionally record/replay locally later if approved, and encourage the user to say it out loud without grading them.

Confidence: medium-high.

### 7. City/category trip prep belongs as a fallback and second path, not the main personal loop

City trip prep is valuable because first-time travelers may have no saved phrases. Current city modes and city metadata are useful. But if Practice always begins from a city bucket list, it can feel like generated itinerary trivia rather than phrase learning.

SpeakLocal implication: keep trip prep, but rename/reframe as `Trip practice` or `City phrase prep`, and use it when the personal queue is empty or when the user chooses a destination/category.

Confidence: high.

### 8. The product should keep Practice as the tab label

`Practice` is clear, native, and broadly understood. `Rehearse` is more exact for phrases, but weaker as a bottom-tab label. `Review` is too narrow because the surface also starts new trip-prep sessions. `Trip practice` is strong as a mode but too specific for all practice.

SpeakLocal implication: keep `Practice` in chrome. Use more exact CTAs and section names inside: `Rehearse saved phrases`, `Review missed`, `Trip practice`, `Audio warm-up`, `Ready phrases`.

Confidence: medium-high.

## Evidence Table

| Signal | Source | Evidence | Product Meaning | Confidence |
| --- | --- | --- | --- | --- |
| Practice surfaces work best when split by user job | [Duolingo Practice tab](https://blog.duolingo.com/guide-to-duolingo-practice-hub/) | Duolingo exposes mistakes, words, speak, listen, stories/radio, roleplay/video call where available. | Split SpeakLocal Practice into queue and mode; do not overload one city card. | High |
| Mistake review came from learner frustration | [Duolingo learner research](https://blog.duolingo.com/how-duolingo-works-with-learners/) | Duolingo says Practice Hub was inspired by learners wanting to review weak areas and past mistakes. | Missed prompts should be visible and easy to re-enter. | High |
| Personalized practice can be based on forgetting/strength | [Duolingo HLR blog](https://blog.duolingo.com/how-we-learn-how-you-learn/), [Duolingo HLR paper](https://research.duolingo.com/papers/settles.acl16.pdf) | Duolingo models recall and practice timing from learner history. | Use local ranking by missed/ready/last result, but keep UI calm. | Medium-high |
| Due review should be performance-based | [Babbel Review](https://support.babbel.com/hc/en-gb/articles/205600228-Vocab-workout-Review) | Babbel classifies review strength and changes intervals based on answers. | Keep local progress and phrase-readiness aggregation. | High |
| Learners want custom focused review | [Quizlet Learn](https://help.quizlet.com/hc/en-us/articles/360030986971-Studying-with-Learn) | Quizlet lets users pick sets, starred terms, question types, audio settings, and retype missed answers. | Add-to-Practice and saved phrases should drive custom sessions. | High |
| Trip/cram modes are valid but should not replace due review | [Anki filtered decks](https://docs.ankiweb.net/filtered-decks.html?highlight=%3Adue) | Anki supports custom study/filter decks and review ahead, with caveats about repeated early review. | City/category trip prep is useful but should be separate from due personal review. | High |
| Audio recall is central to speaking readiness | [Pimsleur FAQ](https://www.pimsleur.com/pimsleur-faq/), [Pimsleur Method](https://www.pimsleur.com/the-pimsleur-method) | Pimsleur emphasizes listening, recall, anticipation, and offline audio lessons. | Audio-first prompts should be first-class in SpeakLocal Practice. | High |
| Phrasebooks support in-the-moment and study use | [Rosetta Stone Phrasebook](https://www.rosettastone.com/features/phrasebook/) | Rosetta frames phrasebook as both situation guide and pronunciation practice. | Practice should always link back to phrase pages and real traveler context. | High |
| Translation utilities emphasize favorites/offline/audio | [Apple Translate](https://support.apple.com/en-sg/guide/iphone/iphd74cb450f/ios), [Microsoft Translator](https://www.microsoft.com/en-us/translator/apps/features/?msockid=2897e2a916d96b8c09c1f4c817476a32), [Google Translate](https://apps.apple.com/us/app/google-translate/id414706506) | Favorites, phrasebook, audio playback, offline packs, and speed controls are common utility promises. | Practice should feel like utility preparation, not lesson-game decoration. | High |
| Travelers struggle with offline setup and trust | [r/travel offline translator](https://www.reddit.com/r/travel/comments/vdx722/translator_app_that_doesnt_need_internet/) | Users ask how offline translation works and report confusion even after downloads. | SpeakLocal can win by making offline phrase readiness obvious. | Medium |
| Exact travel phrase lookup is still painful | [Travel phrase Reddit thread](https://www.reddit.com/r/SideProject/comments/1so530t/looking_up_basic_phrases_while_traveling_is_way/) | Public user language complains about clutter, missing audio, mobile friction, and data use. | Add-to-Practice should be one tap from exact phrase pages; Practice should not bury source links. | Medium |
| Game pressure can distort learning | [Duolingo streak/XP Reddit thread](https://www.reddit.com/r/duolingo/comments/xf0y5s), [Duolingo hearts thread](https://www.reddit.com/r/duolingo/comments/1h108kl) | Users describe optimizing for streak/XP/hearts instead of language learning. | Reject XP, lives, hearts, streak anxiety, and leaderboards. | Medium-high |
| Review backlog becomes grind if poorly scoped | [Babbel review thread](https://www.reddit.com/r/babbel/comments/1izlr93/reviews_are_getting_too_much/) | Users complain review piles up and known items keep returning. | Limit sessions, explain why each queue is suggested, and let users focus saved/added items. | Medium |
| SRS value can disappear if review is hidden | [Memrise spaced repetition thread](https://www.reddit.com/r/memrise/comments/1e5ei86/spaced_repetition/) | Users ask for due review to be prompted again instead of hidden under new features. | Practice should surface due/missed review plainly. | Medium |
| Speech/pronunciation scoring is fragile | [Speaking apps Reddit comparison](https://www.reddit.com/r/Spanish/comments/1rtbowc/i_tried_every_speaking_app_so_you_dont_have_to/), [AI language app skepticism](https://www.reddit.com/r/languagelearning/comments/1qlapi8/are_all_ai_language_learning_apps_garbage/) | Users report lag, lenient feedback, and speech-to-text masking pronunciation errors. | Do not build scored speaking until the model/UX can be trusted. | Medium-high |
| Retrieval practice and spacing are durable learning principles | [Retrieval practice issue](https://journals.sagepub.com/doi/10.1177/1475725720976462), [Science of learning overview](https://pmc.ncbi.nlm.nih.gov/articles/PMC5780548/), [distributed/retrieval review](https://link.springer.com/article/10.1007/s10459-023-10274-3) | Research supports retrieval, spacing, feedback, and distributed practice. | Practice should ask the user to retrieve, not only reread; sessions should be short and repeated. | High |
| Interleaving and desirable difficulty help, but only when difficulty is manageable | [Interleaving retrieval practice](https://journals.sagepub.com/doi/10.1177/09567976211057507), [testing effect study](https://www.nature.com/articles/s41539-019-0053-1) | Harder practice can help long-term learning when it follows exposure and feedback. | Use chunk rebuild and likely replies after the phrase has been introduced, not as first contact. | Medium-high |

## Competitor Pain Points

- Duolingo-style systems can make practice useful, but hearts, XP, streaks, and timed challenges can make users optimize for retention mechanics instead of language readiness.
- Babbel-style review can become a backlog if users cannot focus on what is actually hard or useful now.
- Memrise-style product shifts can frustrate users when due review disappears behind new content or AI features.
- AI/speech apps often overpromise pronunciation feedback; lag or lenient speech-to-text can break trust.
- Translation utilities are powerful but make offline setup, saved phrase retrieval, and exact phrase confidence too unclear.
- Phrasebook apps can be useful but often stop at lookup; they do not turn saved phrases into a private practice loop.

## Practice Directions Considered

| Direction | What It Is | Strengths | Risks | Recommendation |
| --- | --- | --- | --- | --- |
| Minimal Useful MVP | Keep current hub, polish copy, keep four prompt kinds, tune completion feedback. | Lowest implementation cost; preserves existing tests. | Does not solve Jojo's core "confusing / not useful enough" reaction. | Hold as fallback only. |
| Saved Phrase Rehearsal | Personal queue from Add to Practice, saved pages, missed prompts, and recent source pages. | Directly fits SpeakLocal phrasebook behavior; makes user intent primary. | Needs stronger phrase-readiness aggregation and empty state. | Adopt as core. |
| Audio-First Travel Phrase Practice | Start sessions with listening/playback and recall, then recognition/English cue/chunk rebuild. | Best fit for first-time travelers who need to hear and say phrases. | Requires missing-audio handling and careful fallback for no-audio phrases. | Adopt with saved rehearsal. |
| City/Category Trip Prep | User picks Da Nang, hotel, food, transport, emergency, or another route. | Useful when no phrases are saved; uses city metadata. | Can feel like generic itinerary trivia if it leads the product. | Keep as secondary `Trip practice`. |
| Onboarding Placement/Leveling | Short phrase-based pace check sets beginner/intermediate/advanced ranking. | Good for personalization without accounts. | Bad if it blocks the phrasebook or feels like school placement. | Use lightly; do not make it required. |

Primary recommendation: **Saved Phrase Rehearsal + Audio-First Trip Practice**, with city/category trip prep as a clear fallback and onboarding placement as a local preference signal only.

## Recommended Practice Model

### Priority Order

Practice should rank session entry points in this order:

1. Missed prompts due for review.
2. Phrases explicitly added to Practice.
3. Saved phrase pages, especially recently saved/opened.
4. A short confidence mix from phrases already partly ready.
5. City/category trip prep chosen by the user.
6. Graph-nearby recommendations from the same canonical family.

### Session Size

- Default session: 3-5 prompts.
- Long session: 8 prompts only when the user chooses a city/category route.
- Placement session: 3 prompts.
- Missed review: cap at 5 prompts, oldest or most recent misses first depending on local due state.

### Phrase Readiness

Future readiness should aggregate by phrase/page, not only prompt ID:

- `seen`: user has opened or practiced the phrase.
- `rehearsing`: phrase is in saved/add-to-practice or has one correct prompt.
- `ready`: at least two distinct prompt types for the phrase are correct, preferably one audio/recognition and one production cue.
- `review`: last result was missed or confidence is stale.

This can be implemented later as local state over `source.phraseID` and `source.pageID`; the bundled graph remains read-only.

## Question-Type Decisions

| Question Type | Decision | How It Should Work |
| --- | --- | --- |
| `listening_choice` | Keep and promote | First-class for audio-backed phrases. Play phrase, choose meaning or phrase. Include replay. |
| `english_to_vietnamese` | Keep | Use for retrieval after the phrase has been exposed. Good for "what do I say?" traveler moments. |
| `vietnamese_to_english` | Keep | Useful for recognition and signs/speech. Keep existing anti-answer-leak test. |
| `missingToken` / `phrase_chunk_rebuild` | Change | Use after exposure and only with authored useful breakdown tokens. Avoid fake word puzzle energy. |
| `situation_pick` | Change | Use only when the situation is authored and concrete, e.g. "hotel desk asks for your passport." No generic travel trivia. |
| `pronoun_variant_choice` | Later / gated | Useful for `anh/chị/em/tôi/bạn` pages, but needs relationship/person guidance and sensitivity guardrails. |
| `natural_phrase_choice` | Later / gated | Useful for "more polite / clearer / also common" authored variants; not needed in first native polish pass. |
| `likely_reply_choice` | Later | Valuable for comprehension, but should follow a source page's likely-reply section and audio when possible. |
| Scored speaking/pronunciation | Reject for now | Too easy to overpromise and conflicts with offline/no-runtime-AI direction. Consider unscored self-rehearsal later. |
| Timed match/race | Reject | Adds pressure without improving travel readiness. |
| Hearts/lives/streak/XP | Reject | Conflicts with calm premium utility and user evidence. |

## Flow Recommendations

### First Session

If the user has Add-to-Practice phrases:

1. Show `Rehearse saved phrases` / `3 added phrases ready`.
2. Start with audio recognition if audio exists.
3. Follow with English-to-Vietnamese or Vietnamese-to-English.
4. If missed, show correct phrase, audio, and source link.
5. End with phrase readiness summary and one next action.

If the user has no personal queue:

1. Show `Trip practice` as a starter fallback.
2. Offer 2-3 choices: `First day`, `Hotel desk`, `Food counter`, or selected city if known.
3. Keep the first starter session to 3 prompts.
4. End by inviting the user to add real phrases from source pages.

### Returning Session

1. If missed prompts exist, show `Review missed` first.
2. If added/saved phrases exist, show `Rehearse saved phrases` next.
3. If neither exists, show city/category `Trip practice`.
4. Explain why the session is suggested: "2 hotel phrases you added" beats "Daily practice."

### Missed Answer

1. Show the correct Vietnamese phrase prominently.
2. Offer replay if audio exists.
3. Explain why the answer fits in one sentence.
4. Link to source page.
5. Add to missed review automatically.
6. Use calm copy: `Saved for review`, not `Wrong`.

### End Of Session

Show:

- phrases practiced;
- phrases now ready;
- prompts saved for review;
- source page or route updated;
- one next action.

Avoid:

- XP totals;
- streak warnings;
- mascot-as-pressure;
- confetti-heavy game rewards;
- "you failed" wording.

## Wording Recommendations

| Surface | Recommended Wording | Avoid |
| --- | --- | --- |
| Bottom tab | `Practice` | `Quiz`, `Game`, `Coach` |
| Primary personal CTA | `Rehearse saved phrases` | `Continue practicing` when the source is unclear |
| Missed queue | `Review missed` / `Saved for calm review` | `Wrong answers`, `Failed`, `Lost hearts` |
| City/category mode | `Trip practice` / `Da Nang phrase prep` | `Bucket List` as the main label |
| Completion | `3 phrases more ready` / `2 saved for review` | `Level up`, `XP earned`, `You won` |
| Empty state | `Add phrases from source pages` | `Nothing to practice` as a dead end |
| Placement | `Phrase pace check` | `Test`, `Exam`, `Placement score` |

Keep `Practice` as the tab and docs term. Use `Rehearse` for the user's chosen phrases and `Review` for due/missed material.

## SpeakLocal Opportunities

1. Make saved/add-to-practice phrases the center of Practice instead of city routes.
2. Use audio as the primary rehearsal surface because SpeakLocal already has bundled audio and speaker-icon trust.
3. Turn missed prompts into private, calm review without shame.
4. Use city/category trip prep for empty personal queues and planning moments.
5. Use source page links as the bridge between phrase reading and practice.
6. Aggregate progress by real phrase/page readiness, not only prompt ID.
7. Keep Melo as a small Practice companion only after phrase utility is clear.

## Recommendations

The recommendation is to make the next Practice pass personal and audio-first: missed prompts, explicitly added phrases, saved/recent phrase pages, then trip-prep fallback. That direction preserves current repo truth while making Practice feel like phrase rehearsal instead of broad quiz mode.

## Open Questions

- Should the next native task rename `Hanoi Bucket List` to `Hanoi trip practice`, `Hanoi phrase prep`, or remove city-first naming entirely from the main card?
- Should first-run Practice start from `First day`, `Hotel desk`, or a destination selected during onboarding when the user has no saved phrases?
- Should saved pages automatically count as practice candidates, or should only `Add to Practice` create the primary personal queue?
- Should a later self-rehearsal mode support local record/replay without scoring, or should all speaking support stay as native-audio listen-and-repeat guidance for now?

## Fold-In Options

### Adopt Now

- Reframe Practice around personal phrase rehearsal.
- Keep the tab label `Practice`.
- Make `Rehearse saved phrases`, `Review missed`, and `Trip practice` the visible user jobs.
- Keep audio-first prompts as the flagship mode when audio exists.
- Keep missed review calm and automatic.
- Keep city/category practice as secondary starter/trip prep.

### Create Task Card

- `TASK-PRACTICE-PERSONAL-QUEUE-NATIVE-001`: native pass to reorder the Practice hub around missed -> added -> saved/recent -> trip practice, adjust copy, and update tests/screenshots.
- `TASK-PRACTICE-PHRASE-READINESS-STATE-001`: local state pass to aggregate readiness by `source.phraseID` and `source.pageID`, while preserving prompt-level progress.
- `TASK-PRACTICE-QUESTION-TYPE-SEQUENCING-001`: generator/runtime pass to sequence listening, recognition, production, chunk rebuild, situation, and likely-reply prompts by phrase familiarity.

### Hold For Later

- Scored speaking/pronunciation.
- Full spaced-repetition scheduler UI.
- AI roleplay or runtime conversation practice.
- Streaks, daily goals, and habit notifications.
- New Practice prototype unless the native task needs a visual review surface.

### Reject

- Generic travel trivia.
- Timed/race quiz mechanics.
- Hearts/lives/energy loss.
- XP/leaderboard/streak pressure.
- Mascot-driven rewards detached from phrase readiness.
- Missing-token prompts built from weak or fake breakdown tokens.

### Needs Jojo Decision

- Should the next native task rename `Hanoi Bucket List` to `Hanoi trip practice`, `Hanoi phrase prep`, or remove city-first naming entirely from the main card?
- Should first-run Practice start from `First day`, `Hotel desk`, or a destination selected during onboarding when the user has no saved phrases?
- Should saved pages automatically count as practice candidates, or should only `Add to Practice` create the primary personal queue?

## Native Implementation Handoff

Target lane: `Practice / Quiz`.

Tiny prompt:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/research/practice-learning-loop-001/README.md.
Create a native Practice task that reorders the Practice hub around personal phrase rehearsal: missed prompts, Add-to-Practice phrases, saved/recent phrase pages, then Trip practice fallback.
Keep Practice offline and source-anchored. Do not add XP, streaks, lives, leaderboards, runtime AI, or scored pronunciation.
Commit when done and write the result.
```

## What Not To Do

- Do not copy Duolingo's retention economy. Copy the idea of targeted practice, not hearts, streak pressure, or leaderboard energy.
- Do not make Practice a generic city trivia quiz.
- Do not make speech scoring unless the product can prove reliable offline/local behavior.
- Do not hide personal review behind city routes.
- Do not make Melo explain the Practice system. The phrase, audio, and source link should carry the learning.
- Do not expose SRS mechanics as a dashboard before the product has a trustworthy simple loop.

## Peer Review

Focused read-only review completed on 2026-05-03.

Verdict: approve the research recommendation with closure concerns.

Findings:

- Blocking for final task closeout: the required task-result receipt was not present at review time. This will be resolved by `docs/task-results/TASK-PRACTICE-LEARNING-LOOP-RD-001.md` after the report commit hash exists.
- Non-blocking concern: the native handoff is actionable as R&D, but before `Native UI / Simulator` implements it, the recommendation should become a concrete task card with acceptance checks.
- Research content passed review for evidence breadth, phrase-learning focus, first-time traveler usefulness, anti-trivia/game-mechanic guardrails, question-type specificity, and Native UI direction.

## Folded Into

This report is the source brief for the next `Practice / Quiz` task card. No native Swift, generated content, SQLite resources, audio, prototype files, or app code were changed in this R&D pass.
