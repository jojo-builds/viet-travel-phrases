# SpeakLocal Vietnam Homepage Research

Status: T-164 recommendation packet
Date: 2026-04-29
Scope: product/design strategy only. No SwiftUI implementation is included here.

## Executive Recommendation

Build Home as **Start Speaking Now with graph-backed discovery shelves**.

The first real Home screen should not be a marketing page, a course dashboard, or a generic phrase list. It should answer one traveler question immediately: "What can I tap right now to say something useful in Vietnam?" Then it should make the phrase graph visible through calm shelves: situations, local relationship words, authored "Different ways to say..." pages, saved/recent items, and eventually short practice.

Primary direction:

1. Lead with immediate utility: country identity, search, and a short "Use now" strip.
2. Use shelves to expose the graph without explaining the graph: situations, relationship words, useful next phrases, and featured authored pages.
3. Keep the existing bottom search island central. Search is a product promise, not an afterthought.
4. Let practice and mascot progression appear only when they help the traveler rehearse a real phrase page. Do not make Home depend on streaks, XP, leagues, or daily pressure.

## First Viewport

The first viewport should contain only enough to orient the user and produce the next tap.

Recommended first viewport on first launch:

1. **Vietnam identity row**
   - Copy direction: "SpeakLocal Vietnam"
   - Small status copy: "Offline phrases, audio, and local ways to say it."
   - Visual: restrained Vietnam masthead or a quiet native color band, not a marketing hero.

2. **Search-first prompt**
   - A large native search affordance near the top: "What do you need to say?"
   - It should route into the current dedicated search surface and preserve the bottom search-island morph direction.
   - Suggested empty suggestions: "hello", "bathroom", "how much", "I don't understand", "doctor", "SIM card".

3. **Use now strip**
   - 3 to 5 audio-backed phrase cards:
     - `Xin chào` / Hello
     - `Cảm ơn` / Thank you
     - `Tôi không hiểu` / I don't understand
     - `Nhà vệ sinh ở đâu?` / Where is the bathroom?
     - `Tôi cần bác sĩ` / I need a doctor
   - Each card should open the canonical phrase page and expose a speaker action only when bundled audio resolves.

4. **Next row hint**
   - The top edge of the next shelf should be visible below the fold. The page should feel like there is useful content below without becoming busy.

If saved/recent data exists, the first viewport can replace one "Use now" card with "Continue: [last phrase page]". If there is no local state yet, do not show empty state copy in the first viewport.

## Alternatives Compared

### 1. Start Speaking Now

Home leads with search, continue/recent, saved phrases, and immediate audio-backed phrases.

Strengths:

- Best fit for a travel phrase app used under time pressure.
- Makes the app feel useful before the user understands the library.
- Aligns with Apple's search guidance: when search is important, make it primary and easy to reach.
- Keeps Home from feeling like a lesson path.

Tradeoffs:

- The graph can feel hidden unless the lower shelves are strong.
- Without recent/saved state, the top can feel static unless the "Use now" set is curated well.

Verdict: use this as the primary spine.

### 2. Explore The Phrase Graph

Home acts like a calm map of categories, relationship families, and phrase clusters.

Strengths:

- Best long-term match for T-160/T-163: every phrase is page-capable, categories and relations can route to canonical pages, and SQLite can support richer shelves.
- Highlights the product moat: SpeakLocal is not a flat phrase warehouse.
- Makes relationship/pronoun learning discoverable without a grammar lecture.

Tradeoffs:

- Too abstract for the first viewport.
- Risk of feeling like a taxonomy browser if search and immediate actions are not dominant.
- Full graph shelves want the SQLite runtime/read path, which is generated but not bundled into the app yet.

Verdict: use as the second-layer discovery system, not the first screen's lead idea.

### 3. Daily Local Companion

Home blends a daily phrase, mascot progress, quick practice, and next exploration.

Strengths:

- Can make the app feel alive after practice and mascot design are accepted.
- Works well for gentle retention if it stays contextual and offline.
- Can connect "Practice this page" to recent/saved phrases.

Tradeoffs:

- Not ready as the V1 homepage because mascot assets and practice runtime do not exist yet.
- High risk of drifting into streaks, XP, or a course dashboard.
- Less useful for urgent travel moments than search and "Use now".

Verdict: defer until the practice/mascot lane is accepted and implemented.

## Recommended V1 Structure

### 1. Home Header

Job:

- Tell the user where they are: SpeakLocal Vietnam.
- Signal the offline phrase companion promise.
- Avoid marketing-page copy.

Data source:

- App identity from current native config/planning files.
- Existing assets: `HeroVietnamMasthead`, `HeroXinChao`, app icon, accent color.

Design notes:

- Use native page background and static glass chrome direction already present in `AppShellView`.
- Keep text tight. The app should feel like a tool, not an onboarding slideshow.
- If using imagery, use it as a masthead texture. Do not let it compete with phrase cards.

### 2. Search Entry

Job:

- Give a traveler a single place to find any phrase by English, Vietnamese, situation, or next action.

Data source:

- V1: current `PhraseSearchIndex` and generated catalog/search fallback from `native-ios/Resources/viet-phrase-catalog.json`.
- V2: SQLite `search_document` and FTS rows generated by T-163.

Design notes:

- Keep search reachable from the bottom search island and visible in Home content.
- Apple HIG notes that important search can be a primary action and that bottom search is useful when search is a priority.
- Suggestions should be action-oriented, not internal categories: "When you don't understand", "Ask for directions", "Paying", "Food allergies".

### 3. Use Now

Job:

- Get the user to a playable phrase page in one tap.
- Cover the highest-frequency and highest-risk travel moments.

Recommended V1 cards:

| Phrase | Page/source | Why it belongs |
| --- | --- | --- |
| `Xin chào` | static flagship `PhrasePage.xinChao` | first safe hello and relationship-greeting doorway |
| `Cảm ơn` | authored Tier 1 page `viet-thank-you` | universal social exit |
| `Tôi không hiểu` | authored page `viet-family-repair-understand` | repair when conversation fails |
| `Nhà vệ sinh ở đâu?` | authored page `viet-family-bathroom-where` | practical immediate need |
| `Tôi cần bác sĩ` | authored page `viet-family-health-doctor` | high-stakes health need |

Data source:

- Current authored listing pages: `163` native authored pages, including `150` Tier 1 inventory entries.
- Current audio: `3,756` manifest entries, `2,427` MP3 files, and `0` missing authored-audio audit entries.

Design notes:

- Use compact phrase cards with phrase, English, small category icon, and one speaker button.
- Speaker icons are promises. If audio lookup fails, omit the speaker and create an audio audit follow-up.
- Keep emergency/health cards visually calm. No mascot cheer states.

### 4. Continue, Saved, And Recent

Job:

- Bring the user back to the phrase pages they actually care about.

Data source:

- V1 local app state can store canonical page IDs for recent and saved pages.
- V2 should use SQLite canonical page IDs and aliases so old family IDs do not create duplicate pages.

V1 recommendation:

- Ship "Continue" only if a local recent page exists.
- Ship "Saved" only after save/unsave exists. Do not show a dead saved shelf.
- Use page title, English title, category icon, and last action such as "Played audio" or "Opened from Search" if that data exists.

Design notes:

- Keep this shelf near the top for returning users.
- For first launch, replace it with "Start with essentials".

### 5. Situation Shelves

Job:

- Let users browse by travel context without feeling like they are opening a spreadsheet of categories.

Data source:

- Current catalog has `18` scenarios and `900` families:
  - Polite Basics
  - When You Don't Understand
  - Transport
  - Hotel Accommodation
  - Food & Drink
  - Money, Numbers & Prices
  - Directions & Navigation
  - Airport Border Arrival
  - Health & Pharmacy
  - Problems & Help
  - Time, Dates & Booking
  - Shopping
  - Phone, Internet & Power
  - Bathroom & Personal Needs
  - Emergency & Safety
  - Social Small Talk
  - Sightseeing & Activities
  - Local Services & Everyday Tasks

Recommended V1 shelves:

- "Arrival and getting around": airport, transport, directions, phone/SIM.
- "Food, money, and shopping": food, money, shopping.
- "Help and health": understanding, problems/help, health, emergency.
- "Everyday basics": polite basics, bathroom, time/booking, local services, sightseeing.

Design notes:

- Do not show all categories as equal full-width cards at once.
- Use horizontal shelves with 4 to 6 visible chips/cards and a "Browse all" row.
- Sort for travel urgency, not source-file order.
- Use traveler labels. Avoid internal terms such as "repair" in UI.

### 6. Relationship Words Shelf

Job:

- Make Vietnamese relationship/pronoun choices feel useful and tappable, not like a grammar lesson.

Data source:

- Current static native pages already model `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô` through `PhrasePage.xinChao` and local greeting detail pages.
- Audio manifest includes relationship greeting audio keys for forms such as `Chào anh`, `Chào chị`, `Chào em`, `Chào ông`, `Chào bà`, `Chào chú`, and `Chào cô`.
- V2 should move this into SQLite relation/cluster tables so relationship shelves are data-driven.

Recommended V1 shelf title:

- "Who are you speaking to?"

Recommended card copy:

| Card | Plain label | Opens |
| --- | --- | --- |
| `anh` | slightly older man | `viet-hello-anh` |
| `chị` | slightly older woman | `viet-hello-chi` |
| `em` | younger person | `viet-hello-em` |
| `ông` | elderly man | `viet-hello-ong` |
| `bà` | elderly woman | `viet-hello-ba` |
| `chú` | uncle-aged man | `viet-hello-chu` |
| `cô` | aunt-aged woman | `viet-hello-co` |
| `bạn` | friend / peer | `viet-local-greetings` or a future `Chào bạn` page |

Design notes:

- Frame this as a chooser for a real social moment: "Start with `Xin chào` when unsure."
- Cards should show the relationship word plus one human explanation. Do not lead with "pronoun".
- This shelf should link back to `Xin chào` and local greeting pages rather than create duplicate phrase pages.

### 7. "Different Ways To Say..." Feature

Job:

- Expose the authored article/listing value that makes SpeakLocal feel like an offline AI-style answer.

Data source:

- `native-ios/Resources/viet-authored-listing-pages.json`
- `content-draft/viet/listing-pages/**`
- Tier 1 index at `content-draft/viet/listing-pages/_tier-one-index.json`

Recommended V1 feature examples:

- "Different ways to say hello in Vietnam" -> `Xin chào` / local greeting pages.
- "Different ways to say I don't understand in Vietnam" -> understanding pages.
- "Different ways to say how much is this in Vietnam" -> money/prices pages.
- "Different ways to ask for a doctor in Vietnam" -> health pages.

Design notes:

- Treat these as editorial entry points, not blog cards.
- Use phrase title, English need, one sentence of utility, and 2 to 3 phrase chips.
- Make every row route to canonical page IDs.

### 8. Practice Entry

Job:

- Let users rehearse phrases they just cared about.

Data source:

- Current planning source: `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`.
- Future source: practice deck generator using phrase/page/audio IDs.

V1 recommendation:

- Do not ship a Home practice module until the practice design and deck generation are accepted.
- When ready, start with:
  - "Practice this page" from listing pages.
  - "Review missed" only after local missed state exists.
  - "Listen and choose" as the most Home-friendly entry.

Design notes:

- Practice should be short, local, and connected to a phrase page.
- Avoid streak pressure, hearts, leaderboards, daily guilt, and mystery XP.
- Mascot can appear as a restrained hint/guide only after the mascot lane has real assets and tone rules.

### 9. Browse All

Job:

- Provide a dependable fallback for users who want the full phrasebook.

Data source:

- V1: current scenarios/families from JSON.
- V2: SQLite categories, clusters, canonical pages, and aliases.

Design notes:

- This should be lower on Home than search and "Use now".
- The first screen should not become an alphabetical phrase dump.

## Engagement Strategy

Home should encourage useful clicks by showing real next actions, not by manufacturing pressure.

Use:

- immediate playable phrases;
- recent/saved return paths;
- category shelves based on travel situations;
- relationship-word cards that answer a clear social question;
- "Explore next" style links from authored pages;
- short practice only after it is tied to real phrase pages.

Avoid:

- punitive streaks;
- daily guilt copy;
- XP-first framing;
- leaderboards;
- random "word of the day" cards with no travel context;
- empty locked shelves that make the free app feel hollow;
- mascot celebration in emergency, health, safety, or money-dispute contexts.

Research signal:

- Gamification research reports that points, badges, leaderboards, and competitions can produce unwanted effects such as motivational issues, lack of understanding, irrelevance, and focus on the game layer instead of learning. For SpeakLocal, that means Home should reward forward motion into useful phrases, not abstract score accumulation.

## Native iOS Design Notes

The homepage should feel like it belongs in the current native app:

- Use the static glass chrome pattern from `AppShellView`.
- Keep the bottom search island visible and tactile.
- Treat Home content as the moving layer under stable navigation/search controls.
- Use SF Symbols for shelves and cards.
- Prefer compact sections and horizontal shelves over giant cards.
- Do not nest cards inside cards.
- Use readable white or near-white content surfaces over the existing calm background.
- Keep Vietnam accents restrained: red as an accent, not a full-screen theme.
- Maintain generous but not oversized spacing. Home is a tool surface, not a landing page.
- Relationship/pronoun cards should feel like contact cards or helpful chips, not grammar flashcards.
- Emergency and health entries should be calm, high-contrast, and direct.

Liquid Glass handoff:

- Use native glass only for the functional chrome layer and selected interactive controls.
- Do not apply glass to every content card.
- Ensure text remains readable over any masthead/asset.
- If targeting iOS 26 APIs, keep fallbacks consistent with the existing `.nativeGlass` pattern.

## External Reference Notes

- Apple HIG: [Searching](https://developer.apple.com/design/human-interface-guidelines/searching) and [Search fields](https://developer.apple.com/design/human-interface-guidelines/search-fields) support making important app search visible, using suggestions, and placing search at the bottom when it is a priority.
- Apple HIG: [Tab bars](https://developer.apple.com/design/human-interface-guidelines/tab-bars/) supports stable top-level navigation with a small number of predictable sections; tab bars should navigate, not act as action dumping grounds.
- Apple HIG: [Materials](https://developer.apple.com/design/human-interface-guidelines/materials) frames Liquid Glass as a functional layer for controls/navigation over content, which matches SpeakLocal's static chrome direction.
- Apple App Store: [ChatGPT iOS listing](https://apps.apple.com/us/app/chatgpt/id6448311069) shows the value of a mobile AI-style utility being immediately action-oriented: chat, search, voice, image, and learning tools are presented as things the user can do now. SpeakLocal should borrow immediacy, not a chat UI.
- OpenAI: [Introducing the ChatGPT app for iOS](https://openai.com/blog/introducing-the-chatgpt-app-for-ios) reinforces the mobile utility pattern: answers, advice, travel help, and learning on the go.
- Language-learning caution: [Gamification in mobile-assisted language learning: a systematic review of Duolingo literature](https://www.tandfonline.com/doi/full/10.1080/09588221.2021.1933540) notes repetition, translation-heavy design, and competition-vs-learning tensions in the Duolingo literature.
- Gamification caution: [Negative Effects of Gamification in Education Software](https://arxiv.org/abs/2305.08346) and [When Gamification Spoils Your Learning](https://arxiv.org/abs/2203.16175) support avoiding leaderboards, points, and over-playful mechanics as the center of Home.

## V1 / V2 Split

### Ship Before Live

- Real Home route/screen in the native app.
- First viewport with Vietnam identity, search entry, and "Use now".
- Situation shelves driven by current catalog scenarios and authored page links.
- Relationship shelf using existing static local greeting pages.
- Featured authored listing pages from Tier 1 inventory.
- Browse all categories.
- Local recent page IDs if quick to implement; otherwise omit until persistence exists.

### Wait For SQLite Graph Runtime

- Fully data-driven phrase graph shelves.
- Universal "every phrase page" routing in Home.
- Strong alias/dedup handling for duplicate normalized text groups.
- Search ranking from SQLite FTS/search documents.
- Relationship clusters beyond the current greeting pages.
- Practice decks seeded directly from canonical phrase/page/audio IDs.

T-163 has generated `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite` and a report with `919` canonical phrase pages, but `native-ios/project.yml` does not bundle `LanguagePacks` yet. Home V1 should not assume `Bundle.main` can open the SQLite fixture.

### Wait For Practice/Mascot Acceptance

- Daily companion module.
- Mascot progress surface.
- Practice streak/progress visualization.
- Review missed shelf.
- Pronoun coach module.
- Any "daily phrase" mechanic that affects retention or progress.

## Implementation Handoff Notes

Suggested later SwiftUI task:

1. Add `HomeView` as the root route instead of using `PhraseListingView(page: .xinChao)` as Home.
2. Keep `Xin chào` as a featured phrase/page, not the whole Home screen.
3. Add a `HomeSection` / `HomeCard` model layer that can be backed first by JSON/catalog helpers and later by SQLite.
4. Route every phrase card through existing `openDetail(_:)` with canonical page IDs.
5. Reuse `PlaybackDockView` or a compact audio button only when `AudioAssetManifest` resolves.
6. Reuse `AccentTint` and current symbol names from scenarios.
7. Keep search integration aligned with `SearchPageView` and the bottom chrome morph.
8. Store recent/saved as canonical page IDs so the future alias layer can migrate cleanly.
9. Do not edit generated JSON resources by hand for Home. Build data selectors over current resources.
10. Do not add runtime AI/network calls.

Recommended follow-up tasks:

1. Implement native `HomeView` V1 with search, use-now, situations, relationship shelf, and featured authored pages.
2. Add local recent/saved page ID persistence and Home shelves.
3. Add XcodeGen resource rules for `Resources/LanguagePacks/**`, then build a debug-gated SQLite repository spike.
4. After practice concept acceptance, create a practice deck generator and Home practice entry.
5. Audit relationship greeting pages/audio into the SQLite graph so `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô`, and `bạn` become data-driven shelves.

## Risks

- **Overcrowding:** Home can become a pile of shelves. Keep V1 to search, use-now, situations, relationships, featured pages, and browse.
- **False data promises:** Do not show saved/recent/practice/mascot modules before the runtime state/assets exist.
- **Duplicate routing:** Relationship and authored rows must route to one canonical page ID. The SQLite report still flags six duplicate normalized target-text groups for later audit.
- **Search weakness:** If search results remain limited to current in-memory indexes, Home must compensate with strong curated cards until SQLite search is bundled.
- **Tone drift:** Mascot/progress should not make serious travel moments playful.

## Direct Answers To The Research Questions

**What should Home do in an offline travel phrase app where every phrase can become a detailed page?**
Home should be the shortest path to a useful phrase and the calm front door into the phrase graph. It should route search, immediate phrase cards, category shelves, relationship cards, and authored article entries to canonical phrase pages.

**How should Home balance immediate utility, exploration, search, browse, saved/recent, practice, and mascot progress?**
Immediate utility and search lead. Exploration follows through shelves. Saved/recent appears when local state exists. Practice appears only after deck design and local progress exist. Mascot progress waits until there is a real mascot asset/tone system.

**What belongs in the first viewport?**
Vietnam identity, search prompt, 3 to 5 use-now phrases, and a visible hint of the first shelf below.

**How should relationship/pronoun families be surfaced without feeling like a grammar textbook?**
Use the question "Who are you speaking to?" and show cards for `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô`, and eventually `bạn`. Explain each as a social choice in one phrase, not as a grammar term.

**How should category/scenario shelves be shown when we have many categories and eventually thousands of phrase pages?**
Group scenarios into travel task shelves and keep "Browse all" as a fallback. Do not show every category as a top-level equal card. Sort by urgency and travel flow.

**How can Home connect to `Different ways to say...` article pages so users keep moving forward?**
Feature a few authored Tier 1 pages as editorial utility cards with phrase chips and canonical links. Rotate/curate by usefulness, not randomness.

**What design patterns from native iOS apps are worth borrowing, and what should SpeakLocal avoid?**
Borrow stable bottom navigation/search, visible search suggestions, compact discovery shelves, and content moving under functional glass chrome. Avoid marketing hero pages, overloaded tab bars, hidden search, heavy gamification, and cards that are decorative rather than actionable.

**What current assets/data are ready for Home today, and what requires SQLite graph or practice work first?**
Ready today: 18 scenarios, 900 families, 919 catalog phrases, 163 authored listing pages, 150 Tier 1 inventory target, local greeting relationship pages, 3,756 audio manifest entries, and 2,427 MP3 assets. Requires later work: bundled SQLite runtime, full graph-driven shelves, robust alias/dedup routing, saved/recent persistence if not already present, practice decks, mascot assets, and practice progress.
