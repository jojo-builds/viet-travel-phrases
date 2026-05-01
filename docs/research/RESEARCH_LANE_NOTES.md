# SpeakLocal Research Lane Notes

Last updated: 2026-05-01
Owner lane: Research / Product Strategy
Status: living lane notebook, not a product decision source

## Purpose

This file captures how the R&D lane actually runs repeatable research: source strategies, fallbacks, tool limits, workarounds, and skill candidates. It is deliberately operational. Product recommendations still belong in topic reports under `docs/research/<topic-slug>/README.md`.

Use this file to make the next research pass faster and less confusing.

## Research Strategy Notes

### Start From Repo Truth

Before external research, read the task card plus the narrow source-truth docs named by the card. For app-improvement work, the useful current anchors are:

- `docs/research/R_AND_D_LANE.md`
- `docs/research/REPORT_TEMPLATE.md`
- `docs/research/TOOLBOX.md`
- `docs/design/NATIVE_VISUAL_REFERENCE.md`
- `docs/V2_CONTENT_MODEL.md`
- `docs/PRACTICE_QUIZ_PRELIVE_PLAN.md`
- `docs/OFFLINE_SQLITE_PHRASE_GRAPH_PLAN.md`
- current `docs/task-cards/*.md`

Do not reread the whole repo unless a specific question needs it. The goal is to understand the current product shape, not to audit every implementation lane.

### External Source Mix

For broad app-improvement research, aim for at least five categories:

- official product pages and docs for competitor feature claims;
- App Store / Google Play / public review surfaces for user language;
- Reddit and forums for raw audience pain;
- travel forums for destination-specific friction;
- third-party app reviews for competitive positioning;
- academic or UX sources for learning/product principles;
- market/category sources only when prioritization needs scale context.

Do not let one category dominate. Reddit gives useful user language, but it should not be the only basis for product direction.

### Query Patterns That Worked

Useful query families:

- `Reddit travel offline translation app Google Translate screenshots common phrases`
- `Vietnam translator app Google Translate Vietnamese Reddit`
- `Tripadvisor Vietnam translator apps Google Translate Papago`
- `Duolingo repetitive personalized practice Reddit`
- `language learning app speech recognition pronunciation complaints Ling Pimsleur`
- `Google Translate offline phrasebook official`
- `Apple Translate offline favorites conversation official`
- `Microsoft Translator phrasebook pronunciation guides offline`
- `language learning apps reviews complaints 2026 Duolingo Babbel Pimsleur`
- `retrieval practice spaced repetition learning review`
- `gamification misuse language learning app Duolingo`

Phrase queries around a concrete traveler moment usually produced better evidence than broad "best language app" queries.

### Evidence Weighting

Use this rough weighting:

- High: repeated pattern across official docs, direct user posts/reviews, and independent review/UX evidence.
- Medium-high: repeated user pattern plus strong fit with SpeakLocal's repo direction.
- Medium: plausible pattern from several public anecdotes or one review surface.
- Low: one-off post, SEO article, or source with unclear methodology.

Record weak evidence instead of hiding it. Weak evidence can still be useful as a prompt for future research, but it should not become a product decision by itself.

## Tool Limitations And Fallbacks

### Reddit

Public Reddit pages can be opened and quoted lightly. Search results often surface enough snippets to decide whether to open a thread. Some Reddit content is noisy, self-promotional, archived, or low-vote. Treat it as directional user language unless the same point appears elsewhere.

Fallbacks:

- Use Reddit search results when a page opens poorly.
- Prefer threads with a clear traveler or learner problem over generic "what is best" posts.
- Avoid treating product-builder self-promotion as neutral evidence; it can still reveal a pain point.

### X

Public X access is often gated or rate-limited. Do not work around login or access barriers.

Fallbacks:

- Use public search snippets only if available.
- Substitute Reddit, forums, YouTube comments, review pages, or Jojo-provided screenshots.
- Record X as inaccessible instead of spending cycles trying to force it.

### App Store And Google Play Reviews

Official app pages are good for feature claims and sometimes expose a few reviews. Review pagination and country-specific review access can be inconsistent.

Fallbacks:

- Use official app listings for what competitors promise.
- Use public review mirrors only as weak-to-medium evidence and label them as such.
- Prefer direct App Store / Google Play pages when they expose review text.
- Do not scrape private or gated datasets.

### SEO Review Pages

SEO review pages can help with competitor taxonomy, but many are thin or affiliate-shaped.

Fallbacks:

- Use them for feature comparison and weak triangulation.
- Do not rely on them for strong user pain unless they quote specific reviews or match direct user evidence.
- Prefer official docs, direct user reviews, and public forum threads.

### Academic Sources

Academic sources are useful for learning-science and HCI guardrails, not for exact SpeakLocal feature priority.

Fallbacks:

- Use abstracts when full text is not needed.
- Pair learning-science claims with product/user evidence before recommending features.
- Avoid over-translating classroom research into mobile UX certainty.

## Workarounds Used In App Improvement Intel 001

- Used official Google/Apple/Microsoft docs to establish competitor utility primitives rather than relying on app-store marketing screenshots.
- Used Reddit and Tripadvisor for concrete Vietnam/travel language, but marked it directional where sample sizes were small.
- Used Duolingo's own practice/spaced repetition docs as a counterweight to Reddit complaints, because users dislike bad repetition, not repetition itself.
- Used HCI gamification research to support the existing SpeakLocal decision to avoid XP/streak pressure.
- Treated review aggregators and SEO review posts as weak support, not primary evidence.
- Did not use ChatGPT/Deep Research because the task could be handled with public web sources and repo-local synthesis without sending private repo context out.

## Repeated Mistakes To Avoid

- Do not start with market-size reports. They are useful only after the product question is clear.
- Do not over-index on competitor feature lists. A feature only matters if users need it or if SpeakLocal's current architecture can express it cleanly.
- Do not turn "Google Translate has X" into "SpeakLocal needs X." Translate it into the traveler job.
- Do not let recommendations live only in chat. Put them in the report and result receipt.
- Do not create task cards during a research pass unless Jojo explicitly authorizes it.
- Do not use "research says" when the evidence is actually one Reddit post.

## Next-Time Faster Checklist

1. Read the task card and `docs/research/R_AND_D_LANE.md`.
2. Read only the named source-truth docs and `docs/task-cards/README.md`.
3. Draft the research question, decision, source categories, and source target count.
4. Collect official competitor feature sources first.
5. Collect direct user pain from Reddit/forums/reviews second.
6. Add learning-science/UX sources only where they clarify a design principle.
7. Build the evidence table before writing recommendations.
8. Map every recommendation to existing coverage, new task card, hold, reject, or Jojo decision.
9. Write or update this notes file with fallbacks and process discoveries.
10. Run one read-only peer review and repair the report before closeout.

## Research Loop V1

Use this as the compact loop until a dedicated skill exists:

```text
1. Ground in repo truth.
2. Define decision and audience.
3. Collect balanced public sources.
4. Weight evidence by repeatability and source quality.
5. Translate findings into SpeakLocal-specific opportunities.
6. Separate adopt now, task card, hold, reject, and Jojo decision.
7. Peer review for overreach and actionability.
8. Save report, lane notes, and result receipt.
```

## Skill Seed: `speaklocal-research-lane`

Create this only after Jojo approves a follow-up skill task. The skill should live under the user's Codex skills folder, not as a repo-only document, after it has enough repeated evidence to be worth loading in future sessions.

Candidate trigger description:

```yaml
name: speaklocal-research-lane
description: Use when running SpeakLocal market, competitor, Reddit/forum, UX, feature, or app-improvement research that must become a repo artifact with fold-in options.
```

Candidate core behavior:

- Read `docs/research/R_AND_D_LANE.md` and this notes file first.
- Keep source collection balanced across official docs, direct users, reviews, forums, UX/academic sources, and market context.
- Never bypass gated/private/rate-limited content.
- Save a report under `docs/research/<topic-slug>/README.md`.
- Update `docs/research/RESEARCH_LANE_NOTES.md` with new strategies, fallbacks, and limits.
- Use one focused peer review for meaningful research.
- Stop at fold-in options unless the assignment explicitly authorizes task-card or source-truth updates.

Possible supporting resources:

- `references/source-quality.md`: evidence weighting and fallback hierarchy.
- `references/query-patterns.md`: reusable search query families by research type.
- `templates/report.md`: same shape as `docs/research/REPORT_TEMPLATE.md`, kept short.

Do not create the skill from this file alone if the next pass reveals a different workflow. The point is to let the lane improve from repeated use, not to fossilize the first run.
