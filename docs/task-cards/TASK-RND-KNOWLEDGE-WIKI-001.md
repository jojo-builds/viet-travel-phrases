Task Done
Research and design a durable SpeakLocal R&D knowledge wiki system that prevents research, video digests, product decisions, and feature ideas from getting lost. The result should include a Jojo-readable recommendation, a small repo-native pilot that links existing research/video-digest artifacts together, and clear fold-in options for whether we should use a Mac/local app, external app, repo-native markdown, or a hybrid.

Context
Jojo wants the Research / Product Strategy lane to become reusable connected knowledge, not isolated Markdown reports. When R&D watches YouTube videos, reviews competitor apps, studies Reddit/user pain, or explores a feature idea, the output should connect back to SpeakLocal apps, app surfaces, decisions, open questions, and future tasks.

Current source truth:
- `docs/research/README.md`
- `docs/research/R_AND_D_LANE.md`
- `docs/research/RESEARCH_LANE_NOTES.md`
- `docs/research/TOOLBOX.md`
- `docs/research/REPORT_TEMPLATE.md`
- `docs/research/video-digests/`
- existing research folders under `docs/research/`
- current product/source-truth docs only as needed to understand how findings should connect back to SpeakLocal.

Worker Judgment
Use frontier-model judgment. Do not just list tools. Decide what would actually make Jojo's workflow better.

Compare at least these directions:
- repo-native Markdown plus indexes;
- Obsidian or another local graph/wiki app;
- Notion or another external collaborative wiki;
- a lightweight custom static HTML/JSON knowledge graph inside `docs/research/`;
- a later native Mac/internal app, if justified.

Consider the real workflow:
- Jojo gives brain dumps, YouTube links, screenshots, competitor notes, and app ideas.
- R&D researches and writes artifacts.
- The orchestrator and Jojo need to revisit old findings and see what connects.
- Findings need to fold into task cards, design docs, app surfaces, and future app-family language/country variants.

Required Outcome
Create a research artifact under:

```text
docs/research/knowledge-wiki-001/README.md
```

It must include:
- the problem this system solves;
- the recommended first version;
- options considered and why each was accepted, held, or rejected;
- what metadata every future research artifact should include;
- how video digests, app-improvement reports, mascot research, onboarding research, category-page research, and future competitor research should link together;
- how this connects to SpeakLocal app surfaces such as onboarding, Practice, Browse/Search, category pages, listing pages, app icons, paywall/trial, and future country apps;
- how human-readable review should work for Jojo;
- what should be automated later and what should stay human-reviewed;
- a small pilot index over existing research artifacts, especially the existing video digests.

If reasonable, also create a tiny local review surface such as:

```text
docs/research/knowledge-wiki-001/index.html
docs/research/knowledge-wiki-001/knowledge-graph.json
```

The pilot does not need to be beautiful. It needs to prove whether the connection model is useful.

Boundaries
- Docs/research only unless a tiny script is clearly useful for producing the pilot.
- Do not edit native app code.
- Do not create accounts, paid subscriptions, or move repo-private content into a third-party app.
- Do not choose a third-party tool as final without explaining the privacy, portability, maintenance, and cost tradeoffs.
- Do not leave findings only in chat.

Validation
- Open/read the existing research/video-digest artifacts before recommending the model.
- Run `git diff --check`.
- If a static HTML/JSON pilot is created, verify the files exist and link to real local artifacts.
- Run one focused read-only peer review near the end. The reviewer should check whether the recommendation is practical for Jojo's actual orchestrator/R&D workflow and whether the pilot would prevent lost research.

Result Contract
Write:

```text
docs/task-results/TASK-RND-KNOWLEDGE-WIKI-001.md
```

Include:
- final recommendation;
- what artifacts were created;
- what existing research was linked in the pilot;
- what should become a follow-up task card;
- what should wait;
- peer review outcome;
- validation run;
- final git status.
