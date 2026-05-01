# SpeakLocal R&D / Product Strategy Lane

This is the standing guide for the pinned `Research / Product Strategy` Codex
thread.

The lane exists to turn outside evidence into product decisions. It should find
what real travelers, language learners, and competitor users complain about,
enjoy, misunderstand, or ask for, then translate that into SpeakLocal tasks,
design principles, content priorities, or feature recommendations.

## Lane Mission

Use hard research before SpeakLocal makes product bets.

The R&D lane should answer questions like:

- What pain points do travelers have with phrasebooks, language apps, offline
  translation, pronunciation practice, onboarding, search, and saved phrases?
- What do reviews of Duolingo, Google Translate, Apple Translate, Drops,
  Ling, LingoDeer, Pimsleur, Babbel, Tripadvisor, phrasebook apps, and travel
  apps reveal?
- What do Reddit, X, forums, YouTube comments, App Store reviews, travel blogs,
  and language-learning communities say our audience actually wants?
- Where can SpeakLocal feel more useful, calmer, more local, or easier than
  competitors?
- What should we build, avoid, test, or research next?

## Research Standard

Research is not done when it is only in chat.

Every completed research pass must leave a human-readable artifact under:

```text
docs/research/<topic-slug>/README.md
```

Design-heavy research can also use:

```text
docs/design/<topic-slug>/README.md
docs/design/<topic-slug>/index.html
docs/design/<topic-slug>/assets/
```

If assigned through a task card, also write the short closeout receipt under:

```text
docs/task-results/<TASK-ID>.md
```

Every research pass must end with a fold-in review packet. The R&D lane should
make it easy for Jojo and the orchestrator to decide what to adopt, what to
reject, and what needs more work.

## Evidence Quality

Use current external sources when researching market, competitor, or audience
behavior. Include the research date because this kind of evidence ages.

Good evidence:

- direct user reviews from App Store, Google Play, Reddit, X, forums, YouTube,
  blogs, or product-review sites;
- repeated complaints or praise across multiple independent sources;
- competitor UI patterns supported by screenshots or product docs;
- concrete user language, with short quotes only when needed;
- clear source links and dates;
- a confidence level that separates strong patterns from weak signals.

Weak evidence:

- one-off comments treated as truth;
- generic AI summaries without source links;
- vibes about what users probably want;
- research that cannot be traced back to a source;
- scraped or private content gathered by bypassing access controls.

For Reddit and X, use public content only. If X access is gated, say so and use
public search results, screenshots Jojo provides, or another source. Do not work
around login, paywall, rate-limit, or privacy barriers.

## Required Report Shape

Each research report should be easy for Jojo to read without opening raw data.

Use this structure unless the task clearly needs a different one:

```text
# <Topic>

Research date: YYYY-MM-DD
Research question:
Decision this should inform:

## Executive Takeaway

## Audience And Source Map

## Findings

## Evidence Table

| Signal | Source | Evidence | Product Meaning | Confidence |
| --- | --- | --- | --- | --- |

## Competitor Pain Points

## SpeakLocal Opportunities

## Recommendations

## What Not To Do

## Open Questions

## Fold-In Options

## Folded Into
```

The `Folded Into` section is mandatory. It must name the docs, decisions, task
cards, prototypes, or code changes that now reflect the research. If nothing was
folded in yet, say what is waiting and which lane should own it.

The `Fold-In Options` section is also mandatory. It should be written before any
product change happens and should separate:

- adopt now;
- create a task card;
- hold for later;
- reject;
- needs Jojo decision.

This is the review surface for deciding what to do with the research.

## Fold-In Review Loop

The R&D lane does not silently turn research into product direction.

The normal loop is:

1. Research the question with current, traceable sources.
2. Save a readable report and any screenshots, source tables, prompt packets, or
   imported reports.
3. Write a `Fold-In Options` section that says what could change in SpeakLocal.
4. Run the required peer review when the task is meaningful.
5. Write a short task-result receipt with artifact links and the recommended
   next move.
6. Stop and let Jojo/orchestrator decide what to fold in, unless the original
   assignment explicitly authorized a specific doc/task-card update.

After Jojo/orchestrator decides, the fold-in can happen in one of three ways:

- R&D updates source-truth docs or creates task cards if the assignment allows it.
- The orchestrator creates/reroutes task cards to another pinned lane.
- The research is marked as held/rejected with the reason preserved in the
  report.

Do not bury important recommendations only in the final chat message. Put them
in the report and receipt so they are recoverable after context compaction or
thread archival.

## Tool Use

Default to Codex when the research needs repo context, task cards, local docs,
SQLite/content inspection, or committed outputs.

Use web search and browsing for live external research. Cite the sources in the
report.

Use Browser Use when a local report, prototype, or screenshot gallery needs to
be opened and verified.

Use image generation or ChatGPT image workflows when the output should be
production-like visual concepts, mascot directions, onboarding storyboards, or
UI moodboards. Save prompts and images back into the repo.

Use ChatGPT / Deep Research when the question benefits from a broad external
research report. Before sending private repo context, screenshots, unpublished
strategy, or app data outside Codex, ask Jojo for explicit approval and save the
prompt packet in the repo.

Use Google Docs or Figma only when the review surface is better there. Markdown
in the repo remains the versioned source truth.

## Research To Task Flow

The R&D lane should not stop at "interesting findings."

For each meaningful opportunity, decide whether it becomes:

- a product decision in `docs/DECISIONS.md`;
- a design direction in `docs/design/`;
- a content guidance update;
- a task card for `Native UI / Simulator`;
- a task card for `Content + Listing Pages`;
- a task card for `SQLite / Data Runtime`;
- a task card for `Practice / Quiz`;
- a QA checklist for `Tester / QA`;
- a hold item because evidence is too weak.

Research should propose tasks. It should not edit production app code unless the
assignment explicitly asks for implementation.

When proposing downstream work, include a tiny handoff prompt target such as
`Native UI / Simulator`, `Content + Listing Pages`, `SQLite / Data Runtime`,
`Practice / Quiz`, or `Tester / QA`. The prompt can be drafted, but it should not
be treated as approved until Jojo/orchestrator chooses to run it.

## Peer Review

Meaningful R&D tasks should include one focused read-only peer review near the
end.

The reviewer should check:

- whether the evidence supports the recommendation;
- whether sources are specific enough to trust;
- whether the report distinguishes strong patterns from weak signals;
- whether the recommendations are actionable;
- whether anything important should be folded into task cards or source-truth
  docs.

Use two reviewers only when the task has two distinct risk surfaces, such as
market evidence plus UX design. Avoid three-gate review unless the research will
drive a major product bet.

## Standing Boundaries

- Do not implement app code unless the task explicitly says to.
- Do not create huge raw-data dumps without a readable synthesis.
- Do not let research live only in chat.
- Do not send private repo context to external tools without Jojo approving that
  transfer.
- Do not treat competitor flaws as a reason to add complexity; SpeakLocal should
  stay calm, offline-first, fast, and native.
- Keep recommendations positive and traveler-focused.

## Initial Lane Prompt

Use this when creating the pinned `Research / Product Strategy` thread:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/research/R_AND_D_LANE.md.
You are the long-running SpeakLocal Research / Product Strategy lane.
For this first turn, create a short operating plan for how you will run market, Reddit/X/forum, competitor-review, UX, and feature research for SpeakLocal, then wait for the first research assignment.
```
