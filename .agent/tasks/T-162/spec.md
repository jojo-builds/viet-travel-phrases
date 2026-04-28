# T-162: Design Practice Quiz Visual Concepts And Chameleon Mascot Progression

## Objective

Create a visual/product design concept packet for SpeakLocal's pre-live Practice/Quiz area and chameleon mascot progression.

The outcome should let Jojo compare several native-feeling directions before implementation starts. This is design exploration and handoff work only: do not implement SwiftUI screens, edit app runtime resources, generate practice data, change SQLite architecture docs, or modify audio.

The designs must feel like they belong inside the current SpeakLocal native iOS app: Liquid Glass-style chrome, restrained Vietnam accent colors, white/readable content areas, audio-first phrase learning, and the same calm article/listing-page rhythm already established by `Xin chào`.

## Success Criteria

- Create `docs/design/practice-quiz-concepts/README.md` as the design packet.
- Include `5` distinct practice/quiz concept directions, each with:
  - a clear name;
  - target user feeling;
  - screen-flow sketch;
  - quiz question types it supports;
  - how it enters from Home, Search/Browse, Saved, and a listing page;
  - reward/progress model;
  - mascot role;
  - why it does or does not fit SpeakLocal.
- Include a recommendation that narrows the five concepts to `1` primary direction and `1` fallback/alternate direction.
- Include a chameleon mascot progression model:
  - base companion state;
  - Vietnam camouflage/motif progression;
  - what the user earns;
  - how rewards stay positive, low-pressure, and non-punitive;
  - how the mascot appears differently in practice, listing pages, completion, and cultural/local tips.
- Include a practice user flow:
  - deck selection;
  - prompt screen;
  - answer selection;
  - feedback/explanation;
  - reward/progress moment;
  - next prompt;
  - completion;
  - return to source listing page or continue exploring.
- Include at least one design direction for each MVP practice mode from `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`:
  - `Listen And Choose`;
  - `Situation Pick`;
  - `Pronoun Coach`;
  - `Practice This Page`;
  - `Review Missed`.
- Include image-generation prompts for the mascot and each of the five concept directions. If an image-generation tool is available and appropriate, the worker may generate visual concept images and save/reference them under `docs/design/practice-quiz-concepts/assets/`; otherwise, polished prompts are enough.
- Include implementation handoff notes for a future SwiftUI worker, but do not start implementation.

## Repo / Working Surface

- repo root: `/Users/jojolim/Developer/products/speaklocal/app-family`
- working cwd: `/Users/jojolim/Developer/products/speaklocal/app-family`

## Read First

- `AGENTS.md`
- `.agent/README.md`
- `.agent/TASK_PROMPTING.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/APP_FAMILY_STRUCTURE.md`
- `docs/PHRASE_RELATIONSHIP_MODEL.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRIORITIES.md`
- `native-ios/AGENTS.md`
- `native-ios/App/Views/PhraseListingView.swift`
- `native-ios/App/Views/PhraseDetailView.swift`
- `native-ios/App/Views/RootAppView.swift`
- `native-ios/App/Models/PhrasePage.swift`
- `native-ios/Resources/viet-authored-listing-pages.json`
- `native-ios/Resources/viet-phrase-catalog.json`
- `native-ios/Resources/Assets.xcassets`

## Worker Judgment

- Use GPT-5.5 reasoning to produce a designer-quality recommendation, not a generic quiz brainstorm.
- Think like a native iOS product designer and traveler-learning product owner.
- Inspect the current app structure and current resource/assets reality before proposing concepts.
- If the simulator or screenshots are available, use them for visual parity. If they are not available, inspect current SwiftUI views/resources and say what was used instead.
- Make the concepts feel seamless with the app. Do not create a marketing page, web app, Duolingo clone, classroom course, or game that fights the existing listing-page design.
- Prefer calm, tactile, delightful interaction over noisy gamification.
- Record decisions, tradeoffs, and evidence in `result.md`; do not dump hidden chain-of-thought.

## Concept Directions To Explore

Use these as starting points, then improve or rename them if better ideas emerge:

1. `Glass Flashcards`
   - Liquid Glass prompt cards, audio-first recognition, short sessions, soft feedback.
2. `Market Mission`
   - real-world travel situations such as taxi, hotel, food, airport, pharmacy, and shopping.
3. `Chameleon Passport`
   - country/culture progress where the mascot gradually camouflages into Vietnamese motifs.
4. `Ha Long Journey`
   - calm map/journey progression with phrase stops, no pressure timers or punitive lives.
5. `Conversation Rehearsal`
   - choose what to say next in a simple local interaction, then see why it fits.

The final packet may recommend combining pieces, but it must still show five comparable options.

## Design Constraints

- Native iOS feel comes first.
- Use the current app's visual language:
  - Liquid Glass-style surfaces;
  - static bottom/search/back chrome;
  - readable white content areas;
  - restrained Vietnam red/yellow accents;
  - audio buttons that imply real bundled audio;
  - phrase listing/article rhythm inspired by `Xin chào`.
- Keep all runtime behavior offline.
- No runtime AI dependency.
- Avoid negative travel framing. Do not use punitive language, lost lives, shame states, scary warnings, or "you failed" energy.
- Rewards should feel like progress, coverage, readiness, motif unlocks, or local confidence.
- Do not make the mascot childish or intrusive. The chameleon is a warm guide and visible progress companion.
- In sensitive contexts such as health, emergency, money dispute, or police/help, keep mascot use restrained or absent.

## Chameleon Direction

Jojo's original mascot idea is important:

- the chameleon travels country by country;
- it learns to "speak local" by practicing phrases;
- as users master a country pack, the chameleon camouflages into that country's motif and colors;
- for Vietnam, the chameleon gradually gains classy Vietnamese red/yellow accents and subtle motifs such as star, lotus, lantern, wave, Ha Long limestone, or áo dài pattern cues;
- mastery should feel like "the chameleon belongs here now," not like collecting loud game loot.

Design this as a progression system that can later generalize to other country apps/language packs.

## Suggested Artifact Shape

Create:

```text
docs/design/practice-quiz-concepts/
  README.md
  assets/
    .gitkeep
```

Optional if useful:

```text
docs/design/practice-quiz-concepts/concept-board.html
docs/design/practice-quiz-concepts/mascot-prompts.md
docs/design/practice-quiz-concepts/flow-diagram.mmd
```

Keep the packet polished enough that Jojo can review it directly.

## Scope

- expected worker size: `90` to `180` minutes

### Allowed Write Scopes

- `docs/design/practice-quiz-concepts/**`
- `.agent/tasks/T-162/**`
- `.agent/coordination/queue-index.json` through queue helper repair/finish only

### Allowed Read Scopes

- `docs/**`
- `.agent/**`
- `native-ios/App/**`
- `native-ios/Resources/**`
- `native-ios/Config/**`
- `content-draft/viet/**`
- screenshots or simulator captures generated by the worker for design inspection
- public design/product references if needed, with links summarized in the packet

### Must Not Touch

- Swift implementation files.
- Generated native resources.
- Audio files.
- SQLite architecture docs owned by `T-160`, including `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`.
- Existing phrase-page source JSON.
- Existing task folders other than `.agent/tasks/T-162/**`.

## Required Checks

- `git diff --check`
- `python3 .agent/queue_tool.py repair --fail-on-unhealthy`
- If JSON files are edited, validate each with `python3 -m json.tool <path> >/tmp/<safe-name>.json`
- If an HTML concept board is created, open/read it enough to catch obvious broken paths or malformed markup.

## Relevant Skills

- `superpowers:brainstorming` for product/design exploration.
- `build-ios-apps:swiftui-liquid-glass` for native Liquid Glass design vocabulary.
- `build-ios-apps:swiftui-ui-patterns` for native SwiftUI interaction patterns.
- `speaklocal-listing-pages` for how practice should connect back into article/listing pages.
- `imagegen` only if available and helpful for optional concept imagery or mascot prompts/assets.

## Heartbeat And Recovery Contract

- keep `session.owner` as `codex-desktop-automation`; put `manual-*` or `automation-*` in `session.label`
- heartbeat immediately after claim, every `10` to `15` minutes during active work, before/after visual inspection, before/after spawned subagent waits, and before finish
- preferred heartbeat:

```bash
python3 .agent/queue_tool.py heartbeat --task-id T-162 --session-id "<session-id>" --phase "<short-phase>" --lease-minutes 180
```

- if helper heartbeat is blocked, patch the claimed `state.json` directly and explain the helper failure in `result.md`

## Review Gate

Review is mandatory. Use 3 gates. Each gate uses exactly 4 read-only Codex subagents and must loop until all 4 explicitly return `Approval: APPROVE`.

Gate 1, visual/product concept quality:

- native iOS/Liquid Glass parity reviewer;
- traveler learning utility reviewer;
- mascot/reward tone reviewer;
- current app fit reviewer.

Gate 2, handoff readiness:

- SwiftUI implementation-readiness reviewer;
- offline practice-data fit reviewer;
- accessibility/readability reviewer;
- source-of-truth/queue-scope reviewer.

Gate 3, visual packet readiness:

- five-concept comparison reviewer;
- chameleon progression reviewer;
- image-prompt/concept-art reviewer;
- Jojo-reviewability reviewer.

Review artifacts should be stored under `.agent/tasks/T-162/reviews/gate-XX-pass-YY/`.

## Automation State Contract

This task is a meaningful design task:

- `automation.taskClass`: `meaningful`
- `automation.proofTask`: `false`
- `automation.reviewersRequired`: `4`
- `automation.reviewGatesRequired`: `3`
- `automation.reviewGateConsensusRequired`: `4`
- all 3 gates require unanimous approval in the latest pass before the task can finish

## Definition Of Done

- The design packet exists under `docs/design/practice-quiz-concepts/`.
- It gives Jojo five clear, native-feeling options to compare.
- It recommends one direction and one backup direction.
- It makes the chameleon/camouflage progression concrete enough for a future visual asset task.
- It maps the design into the current app entrypoints and MVP practice modes.
- It includes polished image-generation prompts or generated concept imagery if available.
- It includes a future implementation handoff with likely screens/components and known dependencies.
- `result.md` exists and includes:
  - status;
  - summary;
  - files changed;
  - visual/source references inspected;
  - recommendation;
  - verification;
  - review gates;
  - process feedback.
- All 3 review gates pass with unanimous 4-subagent approval.
- `state.json` is finalized through the helper if run by a worker.
- The worker commits its changes if it owns the task.

## Blocker Rule

Do not block just because final mascot art is not available. This task can finish with strong design direction, visual prompts, and implementation-ready UX flow. Block only if the worker cannot inspect enough of the current app to make a seamless recommendation.

## Token Discipline

Do not paste long Swift files, full JSON resources, or full design-reference articles into `result.md`. Summarize evidence and link to local files.
