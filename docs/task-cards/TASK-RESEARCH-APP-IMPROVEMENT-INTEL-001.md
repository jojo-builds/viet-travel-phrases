# TASK-RESEARCH-APP-IMPROVEMENT-INTEL-001: SpeakLocal Product Improvement Research Pass

## Task Done

Jojo has a hard-research-backed improvement report for the current SpeakLocal
Vietnam app: what users in our audience appear to need, what competitor apps are
missing, what SpeakLocal should improve next, and what should be folded into
Native UI, Content, SQLite/Data, Practice, QA, or held for later.

## Context

This is the first real assignment for the pinned `Research / Product Strategy`
lane. The goal is not to implement changes. The goal is to give Jojo and the
orchestrator a useful product-improvement map based on current SpeakLocal state
and external evidence.

SpeakLocal current direction:

- native iOS / Liquid Glass feel;
- offline-first phrasebook plus phrase graph;
- Vietnam traveler focus;
- first-time traveler and beginner-language learner friendly;
- AI-answer-like authored phrase pages without runtime AI;
- large canonical phrase universe backed by SQLite;
- Practice/Quiz emerging as a phrase-learning system;
- Browse/Search/Home/Onboarding still being designed or refined.

Source truth to inspect first:

- `docs/research/R_AND_D_LANE.md`
- `docs/research/REPORT_TEMPLATE.md`
- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- `docs/task-results/TASK-VIET-CONTENT-PRACTICE-EXPANSION-001.md`
- current design/task artifacts under `docs/design/`, `docs/practice/`,
  `docs/content-audits/`, and `docs/task-cards/`

## Worker Judgment

Use hard external research and product judgment. Search public places where our
audience and competitor users talk: App Store/Google Play reviews, Reddit,
public X/search results when accessible, YouTube comments, language-learning
forums, travel forums, product blogs, and competitor help/review pages.

Do not turn this into generic advice. Tie findings back to SpeakLocal's actual
app shape and current roadmap.

If a source is inaccessible, gated, or weak, say so. Use only public content and
cite sources. Include research date and confidence levels.

## Required Outcome

Create:

```text
docs/research/app-improvement-intel-001/README.md
docs/task-results/TASK-RESEARCH-APP-IMPROVEMENT-INTEL-001.md
```

The research report must answer:

- What pain points do travelers and beginner language learners report with
  phrasebooks, translation apps, language apps, offline use, pronunciation,
  search, saved phrases, onboarding, and practice/quiz systems?
- Which pain points are repeated enough to matter?
- Which competitor patterns should SpeakLocal avoid because they frustrate users?
- Which competitor patterns should SpeakLocal borrow or adapt?
- What are the top product improvements SpeakLocal should consider next?
- Which improvements are already covered by current task cards or docs?
- Which improvements need new task cards?
- Which ideas sound attractive but should be held or rejected for now?

The report must include a `Fold-In Options` section with:

- adopt now;
- create task card;
- hold for later;
- reject;
- needs Jojo decision.

Do not silently update product direction beyond the report and task-result
receipt unless Jojo explicitly approves.

## Boundaries

- Work in `/Users/jojolim/Developer/products/speaklocal/app-family` on `main`.
- Own `docs/research/app-improvement-intel-001/**` and
  `docs/task-results/TASK-RESEARCH-APP-IMPROVEMENT-INTEL-001.md`.
- Do not edit `native-ios/**`.
- Do not edit `content-draft/**`.
- Do not edit generated data, SQLite, audio, or app code.
- Do not create implementation task cards unless Jojo/orchestrator explicitly
  asks after reviewing the report.
- Do not send private repo files or screenshots to external ChatGPT/Deep
  Research unless Jojo explicitly approves that transfer.

## Validation

- Cite sources with links and dates.
- Include confidence levels for findings.
- Use one focused read-only peer reviewer to check evidence quality,
  bias/overreach, actionability, and whether fold-in options are clear.
- Run `git diff --check`.

## Result Contract

Write `docs/task-results/TASK-RESEARCH-APP-IMPROVEMENT-INTEL-001.md` with:

- status: done or blocked;
- commit hash;
- report path;
- source count and source categories;
- top 5 findings;
- top 5 recommended fold-in options;
- what needs Jojo decision;
- peer review outcome;
- recommended next prompt or task.
