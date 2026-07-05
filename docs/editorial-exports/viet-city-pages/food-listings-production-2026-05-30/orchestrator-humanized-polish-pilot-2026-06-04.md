# Humanized Listing Polish Pilot - Batch 063

## Objective

Polish exactly one five-listing batch in the live city listings production worktree, then stop and report back for orchestrator review.

This is a pilot for Jojo's preferred direction: copy should make a U.S.-based traveler picture the place, food, table, doorway, curb, route, room, or timing clearly enough to want to remember it. Do not write template copy. Do not chase validators by making copy thin.

## Worktree

Use this worktree only:

`/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch:

`feature/city-listings-production-ready`

Important: the worktree is already dirty with prior listing-production work and orchestrator edits. Do not revert, reset, checkout, clean, or discard unrelated changes. Edit only the target batch fields needed for this pilot, plus generated outputs from the standard pipeline.

## Target Batch

Batch 063 only:

1. `city-hcmc-place-thien-hau-pagoda` / `viet-family-city-hcmc-place-thien-hau-pagoda` - Thien Hau Pagoda
2. `city-hcmc-place-thu-thiem-riverfront` / `viet-family-city-hcmc-place-thu-thiem-riverfront` - Thu Thiem riverfront
3. `city-hcmc-place-ton-duc-thang-museum` / `viet-family-city-hcmc-place-ton-duc-thang-museum` - Ton Duc Thang Museum
4. `city-hcmc-place-turtle-lake` / `viet-family-city-hcmc-place-turtle-lake` - Turtle Lake
5. `city-hcmc-place-vincom-dong-khoi` / `viet-family-city-hcmc-place-vincom-dong-khoi` - Vincom Center Dong Khoi

Source file:

`content-draft/viet/city-library/app-detail-v2-2/hcmc.json`

## Editorial Standard

Follow the direction from Jojo's approved examples:

- Preserve useful phrase cards and related/mentioned cards by default.
- Do not delete useful context just to avoid validator words.
- Edit visible prose toward concrete traveler moments.
- Make the page feel written for a first-time U.S. traveler, not for a reviewer or validator.
- Prefer physical details and decisions: doorway, table, bank, bridge, ticket counter, room, curb, shade, incense, roof, fountain edge, exit, bathroom, pickup point.
- For cultural pages, define unfamiliar religious, historical, or local terms at first mention when useful.
- For mall/airport/transport pages, give the traveler the actual sequence and why the listing is worth remembering without using checklist language.

Do not use visible copy such as:

- `the scene`, `the value`, `the stop`, `this listing`, `meaningful when`, `useful as`, `helps travelers`
- `save it for`, `save this if`, `why save it`
- planner/reviewer headings like `Arrival Planning`, `Crowd Expectations`, `Modest Scope`, `Group Table Reality`
- internal role copy such as `this page`, `content role`, `audience cue`, `place significance`, `the listing owns`
- abstract seams such as `belongs`, `lands better`, `works as`, `works well`, `best`, `stronger`, `layer`, `anchor`, or repeated `feel/feels/feeling`

Use examples only as evidence, not a formula.

Example direction:

Before:

`The exact office or hotel matters more than simply reaching the street. The name and number can save a bag-heavy loop around the block.`

After:

`A bus office, hostel lobby, or cafe pickup can be only a few doors apart. Keep the name and number handy before walking the block with bags.`

Before:

`Phở Lệ is the bigger District 5 meal. Phở Hòa Pasteur is the easier central room. Phở Minh is the older alley breakfast.`

After:

`The narrow entrance, small tables, older room, beef cuts, herbs, and pâté chaud make this feel different from a central lunch bowl or a District 5 phở run.`

## Required Method

For each of the five listings:

1. Read the existing listing fields from `hcmc.json`: displayName, englishName, pronunciation, intro, `usefulPhraseCards`, sections, related/mentioned cards, travelerMoment, storySpine, sourceNotes, and verificationFlags.
2. Identify 1-3 visible lines that still smell like reviewer/planner/template copy or thin safe copy.
3. Patch those exact visible prose fields only. Keep phrase cards and related/mentioned cards unless they are clearly wrong.
4. Do a cold read of the edited visible text without source notes. Ask: would a first-time traveler understand what this is, picture it, and know why to remember it?
5. If the validator asks for a cue, satisfy it naturally with concrete place language. Do not stuff keywords or add label copy.

## Validation

After editing, run:

```sh
jq empty content-draft/viet/city-library/app-detail-v2-2/hcmc.json &&
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-authored-tier-one-pages.js &&
node native-ios/scripts/generate-viet-sqlite-fixture.js &&
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production &&
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js &&
node native-ios/scripts/validate-viet-city-copy.js &&
node native-ios/scripts/validate-viet-city-library.js &&
node native-ios/scripts/validate-viet-sqlite-fixture.js &&
node native-ios/scripts/audit-viet-listing-production-qa.js &&
git diff --check
```

Then run simulator proof for the fifth page:

`viet-family-city-hcmc-place-vincom-dong-khoi`

Use XcodeBuildMCP if available. Save a screenshot under:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/orchestrator-worker-batch-063-test-screenshots/`

## Stop Conditions

Stop after Batch 063. Do not continue to Batch 064 until the orchestrator reviews your work.

Stop and report if:

- validation fails twice after concrete fixes;
- you are tempted to delete phrase cards or related links instead of improving visible prose;
- the copy is getting thinner;
- the source facts are too weak to write confidently;
- a git conflict, merge state, signing issue, or unrelated dirty change blocks safe work.

## Required Report Back

When done, send a message in your thread with this exact heading:

`**Batch 063 Pilot Ready For Orchestrator Review**`

Include:

1. The five listings in order.
2. For each listing: listing/display name, English name, pronunciation, phrase cards, related/mentioned cards preserved, before lines changed, after lines changed.
3. A concise editorial read: what improved, what still worries you.
4. Validation commands run and pass/fail.
5. Screenshot path.
6. Files changed.
7. Whether you recommend allowing the worker to continue to Batch 064.

Do not stage or commit.
