# TASK-RESEARCH-APP-IMPROVEMENT-INTEL-001 Result

Status: done

Commit hash: `51f59fd9e8a7be25cb71451e38449aeafc96e15f`

Report path: `docs/research/app-improvement-intel-001/README.md`

Reusable lane notes: `docs/research/RESEARCH_LANE_NOTES.md`

## Source Count And Categories

Source count: `30` public source records.

Source categories:

- official product docs / app listings;
- App Store and public review surfaces;
- Reddit / public social discussion;
- travel forums;
- third-party competitor / travel review pages;
- academic / UX / learning science;
- market / category context.

X and YouTube were not used as weighted sources because accessible, traceable
public evidence from those surfaces was weaker than the direct forum, review,
official-doc, and research sources gathered in this pass.

## Top 5 Findings

1. Travelers already work around translation apps by saving, screenshotting, or
   retyping repeat phrases; SpeakLocal should make saved/recent/practice phrase
   recovery fast and action-oriented.
2. Translation apps are broad, but Vietnamese social context remains fragile;
   SpeakLocal should win on authored, socially safe, likely-reply-aware phrases
   rather than arbitrary freeform translation.
3. Phrasebooks fail when users cannot understand replies; high-traffic pages
   should include what-you-may-hear, likely replies, and recovery paths.
4. Practice should use retrieval and review, but avoid low-value recycled
   repetition; prompts should stay source-anchored to real phrase/page/audio
   data.
5. Gamification can motivate, but streak/XP/leaderboard pressure is a poor fit;
   local readiness marks and calm missed review fit SpeakLocal better.

## Top 5 Recommended Fold-In Options

1. Adopt fast saved/recent/practice phrase recovery as a first-order Native UI
   requirement.
2. Create or fold in a `Saved Phrase Show/Play Mode` task for Native UI /
   Simulator.
3. Fold reply/recovery coverage into the canonical content audit, or create a
   narrow Content + Listing Pages follow-up if that audit is delayed.
4. Make the SQLite/Data lane expose UI-ready phrase/audio readiness flags if
   current SQLite/default-runtime tasks do not already cover them.
5. Create the future `speaklocal-research-lane` skill only after Jojo approves a
   follow-up skill task, using this report plus the lane notes as seed evidence.

## What Needs Jojo Decision

- Whether "show to local" should become a named native feature.
- Whether to create the `speaklocal-research-lane` skill immediately after this
  task or wait for one more research pass.
- Whether future broad research should stay Markdown-only or also produce a
  Google Doc/Figma-style review surface when the topic is visual or strategic.
- Whether public review aggregators should remain acceptable as weak supporting
  evidence, or whether future passes should restrict evidence to direct
  first-party reviews and forums.

## Peer Review Outcome

Focused read-only peer review completed.

Initial outcome: repair required.

Repairs made:

- removed an unlisted TechRadar reference;
- added an independent travel-advice source for phrase notes/screenshots;
- labeled the Vietnam SideProject source as self-promotional/directional and
  downgraded that finding's confidence to medium-high;
- added a concrete Reddit streak source and softened the gamification claim;
- added missing Content + Listing Pages and SQLite / Data Runtime fold-in
  options.

The reviewer also found `docs/research/RESEARCH_LANE_NOTES.md` useful and not too
cluttered.

## Validation

Passed:

- `git diff --check`
- `git diff --check -- docs/research/app-improvement-intel-001/README.md docs/research/RESEARCH_LANE_NOTES.md`

No app build or tests were run because this was a docs-only research task.

## Recommended Next Prompt Or Task

Recommended next prompt:

```text
Open /Users/jojolim/Developer/products/speaklocal/app-family.
Read docs/research/app-improvement-intel-001/README.md and docs/research/RESEARCH_LANE_NOTES.md.
Create a lightweight task card for Native UI / Simulator that implements Saved Phrase Show/Play Mode if Jojo approves that fold-in.
Do not edit native-ios/App/** yet; prepare the task card and stop.
```
