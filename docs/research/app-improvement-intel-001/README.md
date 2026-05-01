# SpeakLocal App Improvement Intel 001

Research date: 2026-05-01
Research question: What should SpeakLocal Vietnam improve next, based on current traveler, language-learner, competitor-review, UX, and product evidence?
Decision this should inform: Which product improvements should be adopted, turned into task cards, held, rejected, or escalated for Jojo decision across Native UI, Content, SQLite/Data, Practice, and QA.
Assignment source: `docs/task-cards/TASK-RESEARCH-APP-IMPROVEMENT-INTEL-001.md`
Research owner: Research / Product Strategy lane

## Executive Takeaway

SpeakLocal's strongest product lane is not "beat Google Translate" or "be a smaller Duolingo." It is a calmer offline phrase companion that makes repeat travel moments fast, trustworthy, and learnable.

The most immediately actionable external pattern is that travelers already improvise around translation apps by saving, screenshotting, or retyping the same phrases. At the same time, language-app users complain when practice becomes repetitive, game-led, subscription-led, or disconnected from real speaking. SpeakLocal should use this gap: fast reusable phrase cards, authored context, clear audio, canonical phrase pages, and phrase-sourced practice that rehearses real local moments.

Top recommendations:

1. Prioritize "repeatable travel phrases in two taps" across Home, Search, Saved, and listing pages.
2. Treat translation apps as the fallback competitor, not the model: SpeakLocal should win on pre-authored social safety, likely replies, and offline reliability.
3. Make Practice prove communication readiness, not app loyalty. Avoid streak anxiety, hearts, leaderboards, and generic travel trivia.
4. Add a traveler-facing "show/play this phrase" path for saved and high-frequency phrases, including clear audio expectations.
5. Build search and browse around user language such as "bathroom," "doctor," "how much," "vegetarian," "SIM card," and "I don't understand," while preserving canonical page routing under the hood.

## Audience And Source Map

Primary audience:

- First-time Vietnam travelers who need immediate polite survival phrases.
- Beginner language learners who want to recognize and say practical phrases.
- Travelers in low-connectivity moments who need offline confidence.
- Users who are willing to practice only if it is short, useful, and tied to real phrases.

Repo context used:

- SpeakLocal is native iOS, offline-first, Vietnam-focused, and moving toward a bundled SQLite phrase graph.
- Current content direction is a canonical phrase page graph with authored listing/detail pages, relation rails, audio-backed rows, and phrase-sourced Practice.
- Existing task cards already cover Browse/Search visual design, native Practice MVP, onboarding placement, mascot/reward, native visual QA, SQLite default runtime, and canonical content audit.

External source categories:

| Category | Source records in this pass | Research role |
| --- | ---: | --- |
| Official product docs / app listings | 6 | Establish what large competitors promise: offline, camera, conversation, phrasebook, favorites, review practice. |
| App-store and public review surfaces | 4 | Identify user pain around subscriptions, speech recognition, bugs, thin content, and repetitive practice. |
| Reddit / public social discussion | 10 | Capture traveler and learner language, including phrase screenshots, repetitive drills, Vietnamese translation doubts, and streak/fake-progress concerns. |
| Travel forums | 1 | Check Vietnam-specific translation expectations and practical traveler friction. |
| Third-party competitor / travel review pages | 3 | Compare feature positioning and practical gaps for Drops, travel translators, and language apps. |
| Academic / UX / learning science | 5 | Separate durable learning/product principles from app-review noise. |
| Market / category context | 1 | Confirm that this is a crowded category where differentiation must be sharp. |

X and YouTube were not used as weighted sources in this pass. Public X access is
often gated, and the search pass did not surface traceable YouTube-comment
evidence that was stronger than the direct Reddit/forum/review sources above.

Public source inventory:

| # | Source | Category | Date observed or published | Notes |
| ---: | --- | --- | --- | --- |
| 1 | [Google Translate on Google Play](https://play.google.com/store/apps/details?id=com.google.android.apps.translate&view=zertifikate%2F1000) | Official listing | Crawled 2026-05-01 | Promises offline, instant camera, conversations, phrasebook, and cross-device sync. |
| 2 | [Apple Support: Translate conversations](https://support.apple.com/en-nz/guide/iphone/iphd74cb450f/ios) | Official docs | Retrieved 2026-05-01 | Favorites, conversation mode, offline downloaded-language support, alternate meanings. |
| 3 | [Apple Support: Translate settings](https://support.apple.com/en-euro/guide/iphone/iphddb6e7264/ios) | Official docs | Retrieved 2026-05-01 | Offline requires downloaded languages; Apple notes offline translation may be less accurate. |
| 4 | [Microsoft Translator app features](https://www.microsoft.com/en-us/translator/apps/features/?msockid=100dd9d9903c65af376ecf8591fc64c2) | Official docs | Retrieved 2026-05-01 | Offers pinned translations, travel/business phrasebook, pronunciation guides, offline camera/text. |
| 5 | [Duolingo: Spaced repetition](https://blog.duolingo.com/spaced-repetition-for-learning/) | Official blog | Retrieved 2026-05-01 | Frames mistake review and personalized practice as spaced repetition. |
| 6 | [Duolingo: Practice tab](https://blog.duolingo.com/guide-to-duolingo-practice-hub/) | Official blog | Retrieved 2026-05-01 | Practice hub includes mistakes, words, speaking, and listening practice. |
| 7 | [Ling App Store reviews](https://apps.apple.com/us/app/learn-languages-easily-ling/id1403783779?platform=iphone&see-all=reviews) | App Store reviews | Crawled 2026-04/05 | Users value rare-language coverage and free/ad-light access. |
| 8 | [Grand-screen Ling reviews](https://grand-screen.com/apps/ling-language-learning-app/reviews/) | Review surface | Crawled 2025-12 | Highlights speech-to-text issues, limited content, and praise for clear pronunciation. |
| 9 | [Pimsleur Trustpilot reviews](https://www.trustpilot.com/review/pimsleur.com) | Review surface | Retrieved 2026-05-01 | Recent reviews complain about cancellation/customer support and dated app feel; some content/pronunciation concerns. |
| 10 | [Pimsleur ComplaintsBoard](https://www.complaintsboard.com/pimsleur-b149175) | Review surface | Crawled 2026-04 | Users praise method but complain about bugs, flashcard mismatch, and pronunciation scoring. |
| 11 | [FluentU Drops review](https://www.fluentu.com/blog/reviews/drops-language-app/) | Competitor review | Updated 2025-04-08 | Drops is bite-size vocabulary but weak for conversation or extended real use. |
| 12 | [Reddit: Vietnam phrase screenshot workaround](https://www.reddit.com/r/SideProject/comments/1sfybxy/how_my_first_trip_to_vietnam_helped_me_create_the/) | Reddit / traveler | 2026-04 | Traveler reports screenshotting Google Translate for repeated phrases in Vietnam. |
| 13 | [Reddit: Best phrase book for travelling](https://www.reddit.com/r/languagelearning/comments/1n3hsb5/best_phrase_book_for_travelling/) | Reddit / language learning | 2025 | Discussion values offline phrase sections but warns that phrasebooks fail if users cannot understand replies. |
| 14 | [Tripadvisor Vietnam translator apps thread](https://www.tripadvisor.co.uk/ShowTopic-g293921-i8432-k15486693-First_time_in_Vietnam_translator_apps_cultural_norms_etc-Vietnam.html) | Travel forum | 2026-01-20 | First-time Vietnam traveler asks about Google vs Papago after conflicting translations; replies say Google is often enough but words and prices can confuse. |
| 15 | [Reddit r/VietNam translator app](https://www.reddit.com/r/VietNam/comments/1obt32j/translator_app/) | Reddit / Vietnam | 2025 | Users report Google Translate reliability problems and discuss using ChatGPT for context/pronouns. |
| 16 | [Reddit r/VietNam Google Translate accuracy](https://www.reddit.com/r/VietNam/comments/xyg82s) | Reddit / Vietnam | 2022 | User reports confusion when English-to-Vietnamese translations are shown to locals. |
| 17 | [Reddit r/Vietnamese Google Translate reliability](https://www.reddit.com/r/Vietnamese/comments/vtvtzb) | Reddit / Vietnamese | 2022 | Thread distinguishes English-to-Vietnamese from Vietnamese-to-English reliability and tonal-mark sensitivity. |
| 18 | [Reddit: Duolingo units repetitive](https://www.reddit.com/r/duolingo/comments/1mbs5l8/are_duolingo_units_too_long_and_repetitive/) | Reddit / language app | 2025 | User complains units repeat the same material inefficiently and listening exercises are weak. |
| 19 | [Reddit: same personalized practice](https://www.reddit.com/r/duolingo/comments/17mwxj0/same_personalized_practice_over_and_over/) | Reddit / language app | 2023 | User reports "personalized practice" recycling the same phrases until predictive text knows them. |
| 20 | [Reddit: how do you prepare where people do not speak your language](https://www.reddit.com/r/femaletravels/comments/1shvjb0/how_do_you_prepare_to_go_to_countries_where_they/) | Reddit / travel prep | 2026-04 | Travelers combine polite phrases, Google Translate offline packs, camera translation, Pimsleur, and basic phrase learning. |
| 21 | [Gamification misuse in Duolingo](https://arxiv.org/abs/2203.16175) | HCI research | 2022 | Qualitative study finds points, badges, leaderboards can distract from learning and harm learning focus. |
| 22 | [Where is Your App Frustrating Users?](https://arxiv.org/abs/2204.09310) | App review research | 2022 | Review mining can reveal fine-grained problematic features buried in user reviews. |
| 23 | [Retrieval Practice Consistently Benefits Student Learning](https://link.springer.com/article/10.1007/s10648-021-09595-9) | Learning science | 2021 | Systematic review supports retrieval practice benefits in applied education settings. |
| 24 | [Spacing and retrieval practice review](https://www.nature.com/articles/s44159-022-00089-1) | Learning science | 2022 | Summarizes combined evidence for spacing and retrieval practice. |
| 25 | [Unmet Needs and Opportunities for Mobile Translation AI](https://arxiv.org/abs/2002.12387) | HCI / translation research | 2020 | Finds mobile translation tools do not fully meet needs across travelers and low-proficiency users. |
| 26 | [Best Translation Apps for Travel in 2026](https://nllb.com/best-translation-apps-travel-2026/) | Third-party travel app review | 2026-03 | Compares offline, camera, conversation, language coverage, speed, and cost. |
| 27 | [Language Learning Apps Statistics 2026](https://www.quantumrun.com/consulting/language-learning-apps/) | Market context | 2026-02-23 | Reports category scale, Duolingo growth, revenue concentration, and retention challenges. |
| 28 | [Language learning app complaints 2026](https://unstar.app/ar/blog/language-learning-app-reviews-duolingo-babbel-rosetta-stone-2026) | Review aggregation | 2026-04-17 | Weak-to-medium support only; useful as a complaint taxonomy, not as primary evidence. |
| 29 | [Reddit travel advice: translating app for travelling](https://www.reddit.com/r/traveladvice/comments/1kk7ib1/translating_app_for_travelling/) | Reddit / traveler | 2025 | Traveler describes saving quick translation phrases in notes/screenshots and wanting tagging/folders. |
| 30 | [Reddit language learning: too many apps rely on streaks](https://www.reddit.com/r/languagelearning/comments/1hd7t0e) | Reddit / language learning | 2024 | Users debate streaks, including concern that streaks distract from content quality or become FOMO. |

## Findings

### 1. Repeatable travel phrases are a real pain, not a hypothetical feature

Evidence: A Vietnam traveler described screenshotting Google Translate because typing the same phrases repeatedly was too slow; this source is self-promotional, so it is treated as directional rather than neutral proof. A separate travel-advice thread describes dumping quick translation phrases into notes or screenshots, then struggling to find them again. Official competitor listings confirm phrasebook/favorites exist in Google, Apple, and Microsoft, so the stronger conclusion is that fast phrase recovery is a validated utility job even if the exact "screenshot workaround" evidence is still anecdotal.

Product meaning: Saved phrases should not be a passive library. They should become a fast "show, play, practice, and recover" surface.

Confidence: Medium-high. The user-workaround evidence is public but anecdotal; confidence is strengthened by official competitor phrasebook/favorites features and SpeakLocal's own current Saved/Practice direction.

### 2. Translation apps are broad, but Vietnamese social context remains fragile

Evidence: Google Translate and Apple Translate promise broad text, camera, conversation, and offline support. But Apple explicitly notes offline translations may be less accurate, and Vietnam-specific discussions show users comparing Google/Papago outputs, worrying that locals are confused, or preferring contextual AI because Vietnamese pronouns and social roles matter.

Product meaning: SpeakLocal should not sell "translation accuracy" against Google. It should sell pre-authored, socially safe phrases for concrete traveler moments: correct pronouns, tone, likely replies, price conventions, and repair phrases.

Confidence: High for the strategic direction; medium for exact Vietnamese error categories because public anecdotal evidence is uneven.

### 3. Phrasebooks alone fail when users cannot understand the reply

Evidence: A language-learning phrasebook thread explicitly warns that repeating a phrasebook phrase is insufficient if the traveler cannot understand the answer. This aligns with SpeakLocal's existing relation model: likely replies, what-you-may-hear, repair branches, and next-step links are not decorative. They are what turns a phrase page into a usable travel tool.

Product meaning: Every high-traffic page should answer: what do I say, what might I hear, what do I do next, and how do I recover?

Confidence: Medium-high. The pattern is repeated less often than offline/repetition, but it is directly supported by SpeakLocal's product model and traveler logic.

### 4. Practice should use retrieval and review, but avoid "personalized" repetition that feels dumb

Evidence: Duolingo's own docs present spaced repetition, mistake review, word practice, speaking, and listening as core practice features. User complaints do not reject repetition itself; they reject repeated low-value prompts, recycled "personalized" practice, and weak listening/audio. Learning-science reviews support retrieval and spacing, so the product lesson is not "less repetition." It is "better, explainable, phrase-anchored repetition."

Product meaning: Practice MVP should prioritize selected/saved/recent phrases, source pages, missed prompts, and graph-nearby distractors. Feedback should explain the distinction and link back to the phrase page.

Confidence: High.

### 5. Gamification can motivate, but streak/XP pressure is a poor default for SpeakLocal

Evidence: Reddit language-learning threads show users debating whether streaks become FOMO, fake progress, or a distraction from content quality. HCI research on gamification misuse identifies fixation on points, badges, and leaderboards as a learning-risk pattern. SpeakLocal's existing reward/mascot handoff already points toward local readiness marks rather than XP loops.

Product meaning: Keep rewards quiet: "ready phrases," "review later," and route readiness. Avoid leaderboards, hearts, pressure timers, daily guilt, and public ranking.

Confidence: High.

### 6. Speech recognition and pronunciation scoring are risky as an MVP promise

Evidence: Ling and Pimsleur review surfaces include complaints about speech-to-text, speech recognition, pronunciation scoring, or mismatch between audio and review materials. Users praise clear pronunciation and audio-first learning, but automated scoring often creates frustration when it fails.

Product meaning: MVP Practice should emphasize listening recognition, audio playback, phrase-choice recall, and optional self-speaking prompts before shipping strict pronunciation scoring.

Confidence: Medium-high. Evidence is consistent but spread across public review surfaces rather than controlled studies.

### 7. Competitor features worth borrowing are mostly boring utility features

Evidence: Google has phrasebook, offline packs, camera, conversation, and cross-device sync. Apple has favorites, conversation view, face-to-face orientation, offline/on-device mode, and alternate meanings. Microsoft has pinned translations, phrasebook categories, pronunciation guides, alternate translations, slower playback, and group conversation. These are utility patterns, not brand fantasies.

Product meaning: SpeakLocal should borrow small utility primitives: pinned/saved phrase actions, slower playback, face-to-face/show-card mode, phrase-category shortcuts, and alternate/meaning disambiguation when useful.

Confidence: High.

## Evidence Table

| Signal | Source | Evidence | Product Meaning | Confidence |
| --- | --- | --- | --- | --- |
| Travelers repeat the same phrases and do not want to retype them | Reddit SideProject Vietnam phrase tool, Reddit travel-advice thread, official phrasebook/favorites docs | Users describe screenshotting or saving quick translation phrases; official apps already expose phrasebook/favorites. | Build fast saved/show/play phrase access; do not bury saved phrases. | Medium-high |
| Offline and low-connectivity behavior is table stakes | Google Play, Apple Support, Microsoft Translator, NLLB | Competitors all advertise offline language packs or offline text/camera support. | SpeakLocal's offline promise is correct, but must be visible and reliable. | High |
| Offline translation has accuracy limits | Apple Support Translate settings, travel app reviews | Apple says offline translations can be less accurate; travel reviews rank offline as a separate quality dimension. | Pre-authored phrase pages can be more trustworthy than freeform offline translation for common moments. | High |
| Vietnamese translation needs context | Tripadvisor Vietnam, Reddit r/VietNam, Reddit r/Vietnamese | Users compare Google/Papago differences, note locals can be confused, and mention contextual pronoun/social-role handling. | Content should teach socially safe forms, pronouns, likely replies, and context-specific variants. | Medium-high |
| Phrasebooks need reply/recovery support | Reddit phrasebook thread | Users warn that a phrasebook phrase does not help if the traveler cannot understand the answer. | Add "what you may hear," likely replies, and repair paths to high-traffic pages. | Medium-high |
| Users dislike repetitive practice when it feels non-adaptive | Reddit Duolingo repetitive, Reddit personalized practice | Users complain the same prompts recur inefficiently and do not match actual difficulty. | Practice repetition must be source-anchored, varied by prompt type, and explainable. | High |
| Review/mistake practice is still valuable | Duolingo official docs, retrieval practice review, spacing/retrieval review | Official practice docs emphasize mistake/word/speaking/listening review; research supports retrieval and spacing. | Use local missed/due state and short review decks without punishment framing. | High |
| Gamification can displace learning | Gamification misuse paper, Reddit streak thread, Unstar complaint taxonomy | HCI paper describes fixation on game mechanics; user discussions worry that streaks and fake progress can replace learning focus. | Avoid hearts, leagues, streak pressure, and public ranking. | High |
| Pronunciation scoring is fragile | Ling reviews, Pimsleur review surfaces | Users report speech-to-text or pronunciation recognition issues even when they value audio. | Defer strict pronunciation scoring; ship audio-first recognition and self-practice affordances first. | Medium-high |
| Broad-market language apps leave room for focused traveler tools | Quantumrun, FluentU Drops review, NLLB travel app review | Category is huge and crowded; generic apps are strong on engagement, broad translation, or vocab, weaker on focused Vietnam travel utility. | SpeakLocal should differentiate with Vietnam specificity and offline traveler moments, not broad course breadth. | Medium |

## Competitor Pain Points

Translation apps:

- Powerful but too general. They are built for arbitrary text, not for "say this safely in a hotel lobby now."
- Offline modes need preparation, can be less accurate, and may degrade feature quality.
- Vietnamese can require pronoun/context/social-role choices that general translation UI does not make obvious.
- Phrasebook/favorites exist, but users still create screenshots and notes when retrieval is too slow.

Language-learning apps:

- Repetition can feel inefficient when "personalized" practice repeats easy or stale prompts.
- Streaks, hearts, XP, leaderboards, gems, and daily-pressure loops can become the user's goal instead of communication.
- Vocabulary-only apps can be fun but leave users unable to handle conversation.
- Speech recognition and pronunciation scoring can frustrate users when the app rejects valid speech or accepts bad speech.
- Subscriptions, trials, ads, and cancellation problems are a recurring source of negative sentiment.

Phrasebooks:

- Static phrasebooks help with common phrases but often fail on replies, follow-up needs, pronunciation, and local nuance.
- Users distrust phrasebook quality when they cannot validate content.
- Offline phrase lists can become hard to navigate if they are just categories and rows.

## SpeakLocal Opportunities

1. **Fast phrase recovery**: saved/recent/practice phrases should be surfaced as "show/play/practice" utilities, not just bookmarked content.
2. **Vietnam-safe authored context**: emphasize pronouns, politeness, likely replies, price conventions, and recovery phrases.
3. **Practice from real phrase pages**: use the existing phrase graph, audio, breakdown tokens, and local state instead of generic quiz inventory.
4. **Calm readiness reward**: use local readiness marks and missed review, not streak pressure or public gamification.
5. **Search as a travel-command line**: support plain English needs and route to canonical pages, variants, and next-step phrases.
6. **Show-card / face-to-face mode**: borrow the idea of a phrase display meant to be shown to another person, with speaker and large text.
7. **Slower/repeat audio**: provide playback ergonomics for travelers practicing or showing a phrase.
8. **Offline confidence messaging**: make it obvious which phrases/audio are bundled and ready without internet.
9. **Reply-aware content QA**: QA high-traffic pages for "what might come back at me?" and "what do I tap next?"
10. **Skill-backed repeat research loop**: preserve search strategies, source fallbacks, and limitations so future research does not restart from scratch.

## Recommendations

### Covered By Existing Docs Or Task Cards

| Recommendation | Existing coverage | Lane |
| --- | --- | --- |
| Native Browse/Search should distinguish deliberate exploration from intent-led search. | `docs/task-cards/TASK-BROWSE-SEARCH-VISUAL-DESIGN-001.md` | Native UI / Simulator |
| Practice should be phrase-sourced and avoid generic travel trivia. | `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`, `docs/practice/VIET_PRACTICE_CORE_PLAN.md`, `docs/task-cards/TASK-PRACTICE-NATIVE-MVP-001.md` | Practice / Quiz |
| Rewards should be local readiness, not XP/streak pressure. | `docs/practice/VIET_PRACTICE_REWARD_MASCOT_HANDOFF.md`, `docs/task-cards/TASK-PRACTICE-REWARD-MASCOT-001.md` | Practice / Quiz |
| SQLite should support canonical phrase pages, search, audio, and practice hooks. | `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`, `docs/task-cards/TASK-SQLITE-DEFAULT-RUNTIME-001.md` | SQLite / Data Runtime |
| Canonical content should be audited for human traveler usefulness. | `docs/task-cards/TASK-VIET-CANONICAL-CONTENT-AUDIT-001.md` | Content + Listing Pages |
| User-facing changes should go through first-time traveler QA. | `docs/task-cards/TASK-TESTER-QA-GATE-001.md` | Tester / QA |

### New Or Sharper Follow-Up Candidates

1. **Native UI / Simulator: Saved Phrase Show/Play Mode**
   - Add a large, traveler-facing phrase card state for saved/recent/practice phrases.
   - Include large Vietnamese, English, pronunciation, speaker, slow/repeat playback, and "show to local" orientation.
   - Keep this offline and local; no translation generation.

2. **Content + Listing Pages: Reply And Recovery Coverage Audit**
   - For top starter pages, verify each has likely replies, what-you-may-hear, and recovery/next-step links.
   - This can be folded into `TASK-VIET-CANONICAL-CONTENT-AUDIT-001` if that task is run soon.

3. **SQLite / Data Runtime: Offline Confidence And Audio Availability Contract**
   - Expose deterministic flags for bundled phrase/audio readiness so UI can avoid implying unavailable playback.
   - Likely covered by existing SQLite/audio plans, but the UI-facing contract should be explicit.

4. **Practice / Quiz: Anti-Repetition Practice Heuristic**
   - Ensure practice does not repeat the same easy prompt back-to-back.
   - Rotate prompt type, source page, difficulty, and missed status while preserving local deterministic behavior.

5. **Research / Product Strategy: Create `speaklocal-research-lane` Skill**
   - Only after this report and `docs/research/RESEARCH_LANE_NOTES.md` are reviewed.
   - The skill should encode source categories, fallback hierarchy, report shape, review rules, and "do not overfit Reddit" guardrails.

## What Not To Do

- Do not compete with Google Translate on arbitrary freeform translation.
- Do not add runtime AI translation to make SpeakLocal feel smarter.
- Do not copy Duolingo's streak/XP/league pressure loop.
- Do not ship pronunciation scoring as a core promise until recognition quality is proven across realistic noise and accents.
- Do not make saved phrases a passive bookmark list without a fast action path.
- Do not use "AI companion" or "chat with a bot" as the main differentiation unless Jojo explicitly changes the product stance.
- Do not make onboarding explain everything. First-run should get users to useful phrases quickly.
- Do not treat public Reddit/X/forum posts as truth unless the signal repeats elsewhere.

## Open Questions

1. Should "show to local" be a first-class Saved surface, a phrase-page action, or both?
2. Should SpeakLocal visibly name "offline ready" on phrase cards, or keep that as background trust?
3. How much of the future Practice area should live in bottom chrome versus Home/contextual entry points?
4. Should SpeakLocal support user-created custom phrases later, or stay entirely authored for v1?
5. Is Jojo comfortable using public app-review aggregators such as Unstar/Grand-screen as weak evidence, or should future passes prefer only first-party review pages and direct forums?

## Fold-In Options

### Adopt Now

- Keep "calm offline phrase companion" as the research-backed positioning for near-term product decisions.
- Treat fast saved/recent/practice phrase recovery as a first-order UX requirement.
- Keep Practice source-anchored, low-pressure, local, and explanation-forward.
- Keep runtime AI and generic translation outside v1 product direction.
- Use this report's source categories and `docs/research/RESEARCH_LANE_NOTES.md` as the v1 research lane loop.

### Create Task Card

- `Native UI / Simulator`: Saved Phrase Show/Play Mode.
- `Practice / Quiz`: Anti-Repetition Practice Heuristic and Missed Review Tuning.
- `Content + Listing Pages`: Reply And Recovery Coverage Audit if it is not folded into `TASK-VIET-CANONICAL-CONTENT-AUDIT-001`.
- `SQLite / Data Runtime`: Offline Confidence And Audio Availability Contract if current SQLite/default-runtime tasks do not already expose UI-ready phrase/audio readiness flags.
- `Research / Product Strategy`: Create and validate a `speaklocal-research-lane` skill from this pass and one more research task.

### Hold For Later

- Strict pronunciation scoring.
- User-created custom phrase storage.
- Face-to-face conversation mode beyond a single phrase show/play card.
- Cross-device sync for saved phrases or practice state.
- AI chat or live translation features.

### Reject

- Streak pressure as a main retention mechanic.
- Hearts/lives, leaderboards, public competition, gems, or streak repairs.
- Generic travel trivia in Practice.
- Broad freeform machine translation as a SpeakLocal core feature.
- Unverified scraped/private review datasets.

### Needs Jojo Decision

- Whether "show to local" should become a named feature in the native app.
- Whether to create the `speaklocal-research-lane` skill immediately after this task or wait for one more research pass.
- Whether to broaden research collection into Google Docs/Figma for visual review, or keep Markdown as the only required review surface for now.

## Peer Review

Focused read-only peer review completed on 2026-05-01.

Initial outcome: repair required, not approved as-drafted.

Reviewer findings addressed:

- Removed an unlisted TechRadar reference and replaced it with sources already present in the inventory.
- Added an independent travel-advice source for notes/screenshots phrase-saving, labeled the Vietnam SideProject source as self-promotional/directional, and downgraded the repeat-phrase confidence to medium-high.
- Added a concrete Reddit streak source and softened the gamification claim to match the evidence.
- Added missing Content + Listing Pages and SQLite / Data Runtime fold-in options.
- Preserved the lane-notes artifact; reviewer found it useful and not too cluttered.

Post-repair outcome: self-reviewed against the peer findings and ready for Jojo/orchestrator review.

## Folded Into

Pending Jojo/orchestrator review. No product changes, task cards, code, generated resources, or source-truth direction docs have been adopted from this research yet.
