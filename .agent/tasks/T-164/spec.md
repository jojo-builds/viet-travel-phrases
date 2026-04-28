# T-164: Research And Design SpeakLocal Homepage Strategy

## Outcome

Deliver a research-backed homepage strategy for SpeakLocal Vietnam that tells us what the first real Home screen should do, what sections belong there, how the page should use the current phrase graph/categories/relationship clusters, and how it should keep travelers exploring without feeling noisy, generic, or gamey.

This is research and product/design direction only. Do not implement SwiftUI, edit app runtime resources, change SQLite generation, or modify practice quiz concept files owned by `T-162`.

## Product Intent

Jojo wants SpeakLocal to feel like an offline AI-style phrase companion, not a static phrase list. The homepage should help a traveler quickly start using the app, then keep tapping into useful phrase pages, relationship/pronoun families, categories, practice, saved items, and next actions. It should support the Wikipedia-style phrase graph direction from `T-160`/`T-163`: every phrase is page-capable, relationships and categories connect pages, and the app remains fully offline.

The homepage should feel native iOS and Liquid Glass-aligned: useful immediately, visually calm, tactile, and easy to scan. It should not become a marketing page or a course dashboard that hides the phrasebook.

## Success Criteria

- Create `docs/design/homepage-research/README.md` as the main research and recommendation packet.
- Include a clear recommendation for the V1 homepage structure and the first viewport.
- Include `2` to `3` alternative homepage approaches with tradeoffs, then pick one primary direction.
- Map each recommended homepage section to current or near-future data sources:
  - phrase categories/scenarios;
  - relationship/pronoun clusters such as `anh`, `chị`, `em`, `ông`, `bà`, `chú`, `cô`;
  - authored listing pages and Tier 1 phrase pages;
  - search, saved, recent/continue, practice, and mascot/chameleon progression.
- Include design notes for how the homepage should look and feel inside the current native app.
- Include engagement strategy: how Home encourages useful clicks and exploration without dark patterns, punitive streaks, or clutter.
- Include a V1/V2 split:
  - what should ship before live;
  - what can wait for SQLite graph/runtime migration;
  - what should wait until practice/quiz design is accepted.
- Include implementation handoff notes for a later SwiftUI worker, but do not start implementation.
- Include digest-ready bullets in `.agent/tasks/T-164/result.md`: what changed, what was learned, decisions recommended, risks, and next task candidates.

## Research Questions

Answer these directly:

- What should Home do in an offline travel phrase app where every phrase can become a detailed page?
- How should Home balance immediate utility, exploration, search, browse, saved/recent, practice, and mascot progress?
- What belongs in the first viewport so the user immediately understands the app and has a next tap?
- How should relationship/pronoun families be surfaced without feeling like a grammar textbook?
- How should category/scenario shelves be shown when we have many categories and eventually thousands of phrase pages?
- How can Home connect to `Different ways to say [phrase] in Vietnam` article pages so users keep moving forward?
- What design patterns from native iOS apps are worth borrowing, and what should SpeakLocal avoid?
- What current assets/data are ready for Home today, and what requires SQLite graph or practice work first?

## Read First

- `AGENTS.md`
- `.agent/README.md`
- `.agent/TASK_PROMPTING.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/CURRENT_STATE.md`
- `docs/DECISIONS.md`
- `docs/START_SESSION.md`
- `docs/PRIORITIES.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `.agent/orchestrator/digests/T-160.md`
- `.agent/orchestrator/digests/T-163.md` if present
- `native-ios/AGENTS.md`
- `native-ios/App/Views/AppShellView.swift`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Views/PhraseDetailView.swift`
- `native-ios/App/Views/SearchPageView.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `content-draft/viet/_tier-one-index.json`
- relevant `content-draft/viet/listing-pages/**` examples only as needed

Also inspect current resource/assets reality enough to know what Home can honestly use:

- `native-ios/Resources/Assets.xcassets`
- `native-ios/Resources/LanguagePacks/viet/` if present
- audio/catalog/report files that summarize available counts

## External Research

Use current public references where useful, but keep this efficient and evidence-driven. Include links in the packet.

Prioritize:

- official Apple Human Interface Guidelines for navigation, search, tab bars, and discoverability;
- product observations from native iOS apps Jojo has referenced or clearly likes, especially ChatGPT iOS and App Store-style discovery surfaces;
- language-learning/phrasebook competitors only for lessons and anti-patterns, not cloning;
- user pain points around language app practice/homepage overload if you can find credible sources quickly.

Do not turn the packet into a generic market report. Every external reference should explain what it means for SpeakLocal Home.

## Homepage Directions To Compare

Explore and improve these directions:

1. `Start Speaking Now`
   - Home leads with the most useful next phrase/action: search, continue, saved, nearby situation, and one-tap audio.
2. `Explore The Phrase Graph`
   - Home acts like an elegant map of categories, relationship families, and phrase clusters.
3. `Daily Local Companion`
   - Home blends a friendly daily phrase, mascot progress, short practice, and next exploration.

The final recommendation may combine them, but show the tradeoffs clearly.

## Suggested Homepage Section Inventory

Evaluate these as possible sections. Do not include all of them just because they are listed.

- top hero / current country identity
- search island or search-first entry
- continue learning / recently viewed
- saved phrases
- essential phrases / Tier 1 starter set
- situation shelves: airport, hotel, food, transport, shopping, health, emergency, greetings, polite, directions, money, phone, bathroom, sightseeing, services
- relationship/pronoun family shelf: anh, chị, em, ông, bà, chú, cô, bạn
- "Different ways to say..." feature entry for flagship phrase pages
- practice entry: Practice this page, Listen and choose, Pronoun coach, review missed
- chameleon mascot progress, restrained and useful
- local/cultural tip card
- audio-first quick phrase cards
- all categories/browse entry

## Required Packet Shape

Create:

```text
docs/design/homepage-research/
  README.md
```

Optional if useful:

```text
docs/design/homepage-research/section-inventory.md
docs/design/homepage-research/concept-options.md
docs/design/homepage-research/wireframe-notes.md
docs/design/homepage-research/source-notes.md
```

The README should be good enough for Jojo and the orchestrator to read top-to-bottom without opening every sidecar.

## Review Gates

Use reviewer subagents if available. Reviewers must be read-only and return `Approval: APPROVE` or `Approval: BLOCK` with blocking findings.

Run `3` gates, each with `4` reviewer lanes:

### Gate 1: Research And Asset Reality

- native iOS/HIG/product-reference reviewer
- current app/resource inventory reviewer
- phrase graph/category/relationship reviewer
- engagement/competitor anti-pattern reviewer

### Gate 2: Homepage Product Architecture

- first-viewport/usefulness reviewer
- phrase graph exploration reviewer
- relationship/pronoun surfacing reviewer
- practice/mascot integration reviewer

### Gate 3: Handoff Readiness

- implementation sequencing reviewer
- V1/V2 scope reviewer
- source-truth and no-conflict reviewer
- Jojo taste/positive-native-feel reviewer

Repeat a gate if a reviewer blocks. Save review artifacts under `.agent/tasks/T-164/reviews/`.

## Scope

Expected worker size: `120` to `240` minutes.

### Allowed Write Scopes

- `docs/design/homepage-research/**`
- `.agent/tasks/T-164/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Resources/**`
- `native-ios/Config/**`
- `content-draft/viet/**`
- public web sources needed for homepage/product research

### Must Not Touch

- Swift implementation files.
- Generated native resources.
- Audio files.
- SQLite generator/schema/fixture files owned by `T-163`.
- Practice quiz concept files owned by `T-162`, especially `docs/design/practice-quiz-concepts/**`.
- Existing phrase-page source JSON.
- Existing task folders other than `.agent/tasks/T-164/**`.

## Required Validation

- `git diff --check`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- If JSON files are edited, validate each with `python3 -m json.tool <path> >/tmp/<safe-name>.json`
- If Markdown links to local files are added, spot-check the paths exist.

## Definition Of Done

- `docs/design/homepage-research/README.md` exists and answers the research questions.
- Recommended homepage structure is clear enough to become a SwiftUI implementation task.
- Research links are included and tied to concrete SpeakLocal decisions.
- V1/V2 implementation sequence is explicit.
- Review gates are documented and approved or any unresolved blockers are called out.
- `.agent/tasks/T-164/result.md` gives a compact evidence-based summary.
- The task is marked `done` and committed, or marked `blocked` with a precise blocker and recovery note.
