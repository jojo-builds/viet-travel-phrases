# Humanized Listing Polish Continuation

## Objective

Continue Jojo's humanized listing polish across the remaining city listing batches, currently Batch 085 only, then stop for orchestrator review.

The goal is not to make validators green. The goal is production-ready visible copy: a first-time U.S. traveler should understand what the place or food is, picture the real traveler moment, and want to remember it without being told to save it.

## Worktree

Use this worktree only:

`/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

Branch:

`feature/city-listings-production-ready`

The worktree is already dirty with prior listing-production work, orchestrator edits, generated outputs, and screenshot receipts. Do not revert, reset, checkout, clean, or discard unrelated changes. Edit only the target batch source fields needed for this polish pass, plus generated outputs from the standard pipeline and the requested proof screenshot.

## Current Target Batch

Batch 085 only:

1. `city-hoian-place-hoai-river` / `viet-family-city-hoian-place-hoai-river` - Hoai River
2. `city-hoian-place-japanese-bridge` / `viet-family-city-hoian-place-japanese-bridge` - Japanese Bridge
3. `city-hoian-place-kim-bong-carpentry-village` / `viet-family-city-hoian-place-kim-bong-carpentry-village` - Kim Bong Carpentry Village
4. `city-hoian-place-lantern-boat` / `viet-family-city-hoian-place-lantern-boat` - Lantern boat
5. `city-hoian-place-lantern-making-class` / `viet-family-city-hoian-place-lantern-making-class` - Lantern-making class
6. `city-hoian-place-lune-center` / `viet-family-city-hoian-place-lune-center` - Lune Center
7. `city-hoian-place-madam-khanh` / `viet-family-city-hoian-place-madam-khanh` - Madam Khanh
8. `city-hoian-place-mai-fish` / `viet-family-city-hoian-place-mai-fish` - Mai Fish

Source file:

`content-draft/viet/city-library/app-detail-v2-2/hoian.json`

Existing batch receipt, useful as before/context only:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/handwritten-recovery-batch-085-2026-06-03.md`

Important: the old PASS receipt does not mean this batch passes Jojo's current humanized standard. Treat it as prior work to audit and polish. Batches 070 through 084 needed repair after validator-green copy still leaked source IDs, source notes, card reasons, negative-guardrail phrasing, command/verdict headings, relationship IDs, section IDs, reviewer/comparison language, generated propagation, SQLite rows, and active intake seed rows. Batch 084 passed only after repeated replacement repairs for V2.2 source, handwritten/v1/native generated projection, SQLite exact page rows, and active intake seed false positives around `Workshop` / workbench. Cold-read Batch 085 across visible prose, source IDs, sourceNotes, traveler/story fields, section IDs, relationship IDs, score reasons, QA notes, generated outputs, phrase catalog, SQLite rows, card reasons, and any target-linked intake seed rows before validation.

## Editorial Standard

Follow the direction Jojo approved in the orchestrator examples:

- Preserve useful phrase cards and related/mentioned cards by default.
- Do not delete useful context to pass validators or avoid bad phrases.
- Make the copy richer and more concrete, not thinner.
- Write for a traveler who has never been to Vietnam and does not know the Vietnamese name yet.
- Show the room, table, doorway, curb, route, tree shade, ticket counter, bridge, river edge, dish setup, sauce, or timing that makes the listing worth remembering.
- For city-specific food, explain why the city version is different through table setup, texture, sauce, garnish, timing, named-shop pattern, neighborhood role, or traveler decision.
- For serious history pages, keep the emotional weight and factual clarity without turning the copy into commands.
- For parks/gardens, make the factual hook legible: park, garden, river, old trees, family rhythm, heat, shade, walking path, landmark, or exit planning.
- For cafes, make the room and ordering moment do the work: upstairs entrance, counter, brew method, seat, pace, noise, plugs, street view, or group decision.

Do not use visible copy such as:

- `the scene`, `the value`, `the stop`, `this listing`, `meaningful when`, `useful as`, `helps travelers`
- `save it for`, `save this if`, `why save it`
- planner/reviewer headings like `Arrival Planning`, `Crowd Expectations`, `Modest Scope`, `Group Table Reality`, `A Clearer Day Around It`
- internal role copy such as `this page`, `content role`, `audience cue`, `place significance`, `the listing owns`
- abstract review words such as `belongs`, `lands better`, `works as`, `works well`, `best`, `stronger`, `layer`, `anchor`, `appeal`, `scale`, `clearer`, `practical`, or repeated `feel/feels/feeling`

These are not just banned words. They are symptoms. If one appears, diagnose the authoring move that produced it and replace that move with concrete traveler-facing proof.

## Required Method

For each listing in the current batch:

1. Read the existing visible fields from source: displayName, englishName, pronunciation, intro, `usefulPhraseCards`, sections, related/mentioned cards, travelerMoment, storySpine, sourceNotes, and verificationFlags.
2. Snapshot the before copy for any fields you may edit.
3. Name the recurring pattern if one appears: module-job heading, reviewer shorthand, source-reason leakage, city-food genericness, negative-guardrail thinning, direct saved-list instruction, or phrase-card deletion pressure.
4. If a recurring pattern appears, use a real chained Five Whys only while each why drills into the previous answer. Stop early when the root cause is actionable. If the evidence is too thin, call it mechanism analysis instead.
5. Write the positive traveler proof before thinking about validators. The proof should be physical, specific, and human-facing.
6. Patch only visible prose fields that need it. Keep phrase cards and related/mentioned cards unless they are factually wrong.
7. Cold-read only the visible app copy. Ask: would a first-time traveler understand what this is, picture it, and know why to remember it?
8. Run a local bad-pattern scan on the edited source for the target records.
9. Only after the cold read passes, run the validation pipeline.

The worker should not continue by silently applying a formula. Each listing should remain authored page by page.

## Validation

After editing, run:

```sh
jq empty content-draft/viet/city-library/app-detail-v2-2/hcmc.json &&
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
node native-ios/scripts/generate-viet-catalog.js &&
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

Then run simulator/render proof for the last page in the batch:

`viet-family-city-hoian-place-mai-fish`

Save proof under:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/orchestrator-worker-batch-085-test-screenshots/`

If the UI-test harness uses stale DerivedData, rerun through the fresh app build or XcodeBuildMCP launch args and keep only current-copy screenshots.

## Stop Conditions

Stop after Batch 085. Do not continue to Batch 086 until the orchestrator reviews the batch.

Stop and report if:

- validation fails twice after concrete fixes;
- the copy starts getting thinner;
- you are tempted to delete phrase cards or related links instead of improving visible prose;
- the source facts are too weak to write confidently;
- a recurring pattern appears and you cannot identify the workflow cause;
- a git conflict, merge state, signing issue, or unrelated dirty change blocks safe work.
- the Codex thread enters repeated remote compact errors, system-error behavior, or stays active with no new visible turn items for more than 10 minutes after the last progress message; in that case stop relying on the thread and let the orchestrator recover from the worktree.

## Required Report Back

When done, send a message in your thread with this exact heading:

`**Batch 085 Ready For Orchestrator Review**`

Include:

1. The eight Batch 085 listings in app/source order.
2. For each listing: listing/display name, English name, pronunciation when present, phrase cards, related/mentioned cards preserved, before lines changed, after lines changed.
3. A concise editorial read: what improved, what still worries you.
4. Any root-cause diagnosis used, with a real chained Five Whys only if the chain is evidence-backed.
5. Validation commands run and pass/fail.
6. Screenshot path.
7. Files changed.
8. Whether you recommend continuing to Batch 086.

Do not stage or commit.

## Continuation Rule

If the orchestrator approves Batch 085, expect the same brief to be updated or referenced for Batch 086. Do not self-advance.
