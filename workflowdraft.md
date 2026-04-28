# SpeakLocal Content And Audio Workflow

Last updated: 2026-04-15  
Status: working blueprint  
Scope: reusable content-to-translation-to-audio-to-app-to-website workflow for SpeakLocal language lanes. This blueprint governs the content, audio, reuse, and maintenance lane. It does not replace the live release-proof lane, App Store Connect steps, or device-validation runbook in `docs/operations/*`.

## Purpose

This document defines how SpeakLocal content should move from concept to live app and website reuse without mixing planning notes, prep artifacts, repo truth, or release-validation truth.

It exists to make the real Vietnam lane repeatable, not to create process theater. The workflow should stay light, operational, and honest about what is planned, what is prepared, what is live, and what is still blocked.

## Scope fork

Use this workflow when the active question is content architecture, inventory, cleanup, translation, audio, app integration, website reuse, or workflow maintenance.

If the active question is:

- App Store Connect setup
- preview build/install proof
- StoreKit purchase/restore proof
- device walkthrough evidence
- current release blockers

route through `E:\AI\SpeakLocal-App-Family\docs\operations\TESTING_RUNBOOK.md`, `LATEST_VALIDATION.md`, and `CURRENT_BLOCKERS.md` first. The current Viet lane is still carrying that release-proof work in parallel, so this blueprint should not be mistaken for the whole product-state sequence.

## Working principles

1. Build around real traveler moments, not grammar coverage.
2. Free is the survival spine. Paid is the follow-up, recovery, clarification, and confidence layer.
3. Do not discard a phrase just because it is not strong enough for paid. If it still solves a real first-step traveler need, move it to the free/survival layer instead of dropping it.
4. Drop phrases only when they are true noise: redundant, filler, too narrow to matter, or not meaningfully tied to a travel decision.
5. Do not default to Codex just because the task touches a repo. Jay should do direct editorial/process work when that is the right tool for the job.
6. Use the lean subagent review gate only for high-cost or workflow-shaping work. Keep it standing, but narrow.
7. Keep review gates lightweight. They should catch real quality or maintenance problems, not turn the work into bureaucracy.
8. Codex should write its own output files directly into the workspace when possible.
9. ChatGPT outputs must be saved manually by Jay into `C:\Users\Administrator\.openclaw\workspace\projects`.
10. Use canonical thread names as filename bases unless a better explicit filename is warranted.
11. Never let prepared-not-live work silently become live truth.
12. Never claim audio or validation confidence that the current artifacts do not support.

## Truth surfaces

### Workflow truth

This document owns the reusable operating model: phase order, gates, artifact rules, handoff rules, and maintenance rules.

### Planning truth

Planning truth is where a lane is designed before it becomes repo-prep truth. It includes:

- external planning artifacts saved into `C:\Users\Administrator\.openclaw\workspace\projects`
- architecture, inventory, cleanup, translation-review, and expansion-planning outputs
- lane-specific planning docs when a plan needs a durable repo home

Planning truth may live outside the repo because it often comes from ChatGPT/Codex external threads and needs a stable intake location before it is reconciled into prep truth.

### Prep truth

Prep truth is the language-lane source material that is ready to be reconciled, translated, merged, or built, but is not automatically live:

- `E:\AI\SpeakLocal-App-Family\content-draft\<variant>\scenario-plan.json`
- `E:\AI\SpeakLocal-App-Family\content-draft\<variant>\phrase-source.csv`
- `E:\AI\SpeakLocal-App-Family\content-draft\<variant>\premium-expansion\*`
- `E:\AI\SpeakLocal-App-Family\content-draft\<variant>\website-preview.json`

Prepared premium-expansion slices are prep truth, not live truth, until they are translated, merged into the main source, rebuilt, and revalidated.

### Repo truth

Repo truth is what the app and website actually build from:

- `E:\AI\SpeakLocal-App-Family\app\family\packs\*.generated.ts`
- `E:\AI\SpeakLocal-App-Family\app\family\presentation\*`
- `E:\AI\SpeakLocal-App-Family\app\family\appRegistry.js`
- build, validation, audio, and export scripts under `E:\AI\SpeakLocal-App-Family\app\scripts\`
- website-safe export output under `E:\AI\SpeakLocal-App-Family\site\data\phrase-previews\` and `E:\AI\SpeakLocal-App-Family\site\public\data\phrase-previews\`

### Release-validation truth

Release, blocker, build, and device-validation truth belongs in:

- `E:\AI\SpeakLocal-App-Family\docs\operations\APP_STATUS.md`
- `E:\AI\SpeakLocal-App-Family\docs\operations\VARIANT_MATRIX.md`
- `E:\AI\SpeakLocal-App-Family\docs\operations\TESTING_RUNBOOK.md`
- `E:\AI\SpeakLocal-App-Family\docs\operations\LATEST_VALIDATION.md`
- `E:\AI\SpeakLocal-App-Family\docs\operations\CURRENT_BLOCKERS.md`
- `E:\AI\SpeakLocal-App-Family\ops\apps\*.json` for compact dashboard-facing summary only

### Lane-board truth

`C:\Users\Administrator\.openclaw\workspace\ops\LANES.md` is orchestration truth only. It should track what is running, what is next, what is blocked, and where the durable artifacts live. It should not duplicate:

- content counts
- release status detail
- blocker detail that belongs in `docs/operations/*`
- repo truth that belongs in `content-draft/*`, `app/*`, or `ops/apps/*.json`

Use links and short summaries only.

## Tool split

### Jay directly

Jay should directly handle:

- prioritization and lane selection
- phrasebook product judgment
- free-vs-paid decisions when the answer depends on product taste, positioning, or value judgment
- deciding whether a weak paid candidate should move to free instead of being dropped
- approving or rejecting architecture and inventory direction
- saving ChatGPT outputs into the canonical projects intake folder
- human-only validation/release steps such as App Store Connect and device testing
- any direct editorial/process work that does not need repo automation

### Codex

Codex should handle:

- repo-grounded documentation and workflow consolidation
- cleanup, reconciliation, diffing, merge prep, and artifact generation
- editing `phrase-source.csv`, scenario-plan files, website-preview files, docs, and scripts when repo changes are needed
- generating its own workspace artifacts directly when asked
- pack building, validators, export flows, and repo-side sanity checks
- translation/backfill prep when the task requires comparing planning artifacts to repo source
- audio generation or registry steps when the source text is already stable enough

### ChatGPT

ChatGPT is best used for:

- architecture exploration
- large inventory drafting
- translation/backfill generation when the task benefits from high-volume language output
- editorial naming/copy rewrites
- structured ideation where breadth matters more than direct repo writes

ChatGPT should not be treated as the source of truth by itself. Its outputs become usable only after Jay saves them, and then they are reconciled against prep truth and repo truth.

## Default owner model

Use this default split unless a phase says otherwise:

- decision owner: Jay
- default execution owner: ChatGPT for large external ideation or language generation, Codex for repo-grounded reconciliation/integration/validation work
- save or record owner: Jay for ChatGPT outputs, Codex for Codex-generated artifacts and repo docs

Every phase should close with one concrete signal:

- a saved artifact
- an updated prep/repo file
- a validator result
- or a recorded yes/no checkpoint in the appropriate durable doc

## Standing lean review gate

The lean subagent review gate is required when the work would be painful to undo or will become reusable operating truth. Use it for:

- workflow edits like this blueprint
- major architecture changes
- large inventory or translation prompts that will become reusable source or drive multiple downstream batches
- reusable prompt-pattern changes
- batching or quality-gate changes
- runtime-graduation rules for a new language or script/search posture

It is optional for routine cleanup, small reconciliations, or straightforward repo integration once the upstream decisions are already stable.

Default reviewer angles:

1. process realism
2. reuse across languages and future lanes
3. overengineering and bureaucracy risk
4. truth surfaces and maintenance safety

Gate owner:

- Jay decides whether the trigger applies
- Codex runs the review pass when Codex owns the task

Required output:

- a short PASS/BLOCK review note with concrete edits or approval

## Phase sequence

The normal phase order is:

1. Phrase architecture
2. Phrase inventory
3. English quality cleanup
4. Repo reconciliation
5. Translation and backfill
6. Batch prep
7. Audio generation
8. Audio QA
9. App integration
10. Website export and reuse
11. Device validation
12. Release-confidence check

This is the default sequence, not a prison. The workflow can loop back when quality issues are found, but it should not skip the source-of-truth transitions.

## Phase owner matrix

| Phase | Decision owner | Default execution owner | Save or record owner |
| --- | --- | --- | --- |
| Phrase architecture | Jay | ChatGPT | Jay |
| Phrase inventory | Jay | ChatGPT | Jay |
| English quality cleanup | Jay | Codex | Codex |
| Repo reconciliation | Jay | Codex | Codex |
| Translation and backfill | Jay | ChatGPT or Codex, depending on whether the task is generation-first or merge-first | Jay for ChatGPT outputs, Codex for repo-integrated outputs |
| Batch prep | Jay | Codex | Codex |
| Audio generation | Jay | Codex or repo script | Codex |
| Audio QA | Jay | Jay with Codex support | Jay for listening judgment, Codex for status and registry updates |
| App integration | Jay | Codex | Codex |
| Website export and reuse | Jay | Codex | Codex |
| Device validation | Jay | Jay with Codex support | Jay in `docs/operations/*`, Codex if asked to record the evidence |
| Release-confidence check | Jay | Jay with Codex support | Codex in durable docs/manifests when the state changes |

## Phase detail

### 1. Phrase architecture

Purpose:
Define the category spine, free-vs-paid philosophy, density rules, and traveler-moment structure before a full inventory is drafted.

Entry criteria:

- a real language/app lane is selected
- product framing is clear enough to answer what free means, what paid means, and what the app is trying to help with
- Jay has enough context to approve or redirect the lane

Owner note:
See the phase owner matrix. Default to ChatGPT for the first architecture pass and use Codex only when repo-grounded comparison or structured consolidation is needed.

Required outputs:

- one architecture artifact in `C:\Users\Administrator\.openclaw\workspace\projects`
- category list
- subgroup/family logic
- free-vs-paid placement rules
- density and audio-priority rules

Exit criteria:

- a saved architecture artifact exists
- Jay has approved the category spine and free-vs-paid posture
- free and paid logic are explicit
- weak category overlaps are resolved enough to inventory against

Normal next step:
Draft the phrase inventory against the approved architecture.

### 2. Phrase inventory

Purpose:
Turn the approved architecture into a concrete row-level inventory with category/family/tier coverage.

Entry criteria:

- phrase architecture is approved
- category and family boundaries are stable enough to inventory against

Owner note:
See the phase owner matrix. Default to ChatGPT for the first large inventory pass unless the inventory must be generated directly from repo context.

Required outputs:

- inventory artifact in `C:\Users\Administrator\.openclaw\workspace\projects`
- rows mapped to categories and family/group logic
- preliminary free-vs-paid allocation

Exit criteria:

- a saved inventory artifact exists
- there are no obvious duplicate-English rows or hollow categories
- the free slice is explicit and usable enough to review as a survival spine
- Jay has approved the inventory to move into cleanup

Normal next step:
Run English quality cleanup before translating or merging anything.

### 3. English quality cleanup

Purpose:
Strengthen the English anchor inventory before translation and audio lock in weak wording.

Entry criteria:

- inventory exists as a saved artifact
- the team is ready to decide keep, rewrite, demote, or drop

Owner note:
See the phase owner matrix. Default to Codex because cleanup benefits from systematic review and artifact generation.

Required outputs:

- cleanup summary artifact
- optional cleanup CSV artifact
- disposition labels such as keep, rewrite, demote-to-free, or drop
- updated recommended free slice

Exit criteria:

- a cleanup artifact exists
- awkward, vague, redundant, or low-value English anchors are fixed or removed
- weaker paid candidates that still solve real first-step travel needs are moved to free instead of dropped
- only true noise is dropped
- the cleaned inventory is approved for reconciliation

Normal next step:
Reconcile the cleaned inventory against current repo/prep truth.

### 4. Repo reconciliation

Purpose:
Map planning truth onto prep truth and repo truth so the team knows what already exists, what should be preserved, and what still needs backfill.

Entry criteria:

- cleaned inventory is saved
- current lane prep truth exists or is about to be created
- existing repo/source material is available for comparison

Owner note:
See the phase owner matrix. Default to Codex. ChatGPT is not the primary tool for the reconciliation pass itself.

Required outputs:

- reconciliation artifact saved by Codex into the workspace when possible
- clear accounting of:
  - existing good rows to preserve
  - rows needing rewrite
  - rows needing translation/backfill
  - rows that remain prepared-not-live
- updated or prepared `content-draft/<variant>/` files when the repo is being advanced

Exit criteria:

- a reconciliation artifact or updated prep files exist
- the lane has a clean gap map between planning intent and repo/prep truth
- existing good translations/audio-backed rows are preserved instead of overwritten
- the next translation batch can be defined cleanly

Normal next step:
Translate and backfill only the unresolved rows.

### 5. Translation and backfill

Purpose:
Fill missing target text, canonical text, pronunciation, and context-ready row data without losing strong existing source material.

Entry criteria:

- reconciliation identifies exactly which rows need translation or repair
- family structure is stable enough that translation work will not be immediately invalidated

Owner note:
See the phase owner matrix. Default to ChatGPT for generation-first work and Codex for merge-and-backfill work.

Required outputs:

- saved translation artifact in `C:\Users\Administrator\.openclaw\workspace\projects` when ChatGPT is used
- direct repo/prep edits when Codex handles the merge
- completed target text and pronunciation fields for the chosen batch

Exit criteria:

- a saved translation artifact or updated prep file exists
- rows are translated or backfilled to the level needed for audio prep
- preserved translations remain intact where they are already strong
- unresolved language doubts are called out explicitly instead of being buried

Normal next step:
Prepare a clean batch for audio generation and QA.

### 6. Batch prep

Purpose:
Turn translated content into stable, reviewable batches that are small enough to validate and large enough to keep momentum.

Entry criteria:

- translation/backfill exists for the target rows
- each row has stable target text, pronunciation, access tier, family, and audio status posture

Owner note:
See the phase owner matrix. Default to Codex.

Required outputs:

- batch manifest or saved batch artifact
- explicit row/family list
- phase and priority label
- note of whether the batch is free-critical, premium-depth, website-candidate, or prep-only

Exit criteria:

- a saved batch artifact or manifest exists
- the batch is stable enough to send through audio generation without constant row churn
- family primaries and nearby variants stay together
- the batch order reflects product priority, not arbitrary file order

Normal next step:
Generate audio for that batch.

### 7. Audio generation

Purpose:
Create actual audio assets only after text and pronunciation are stable enough to avoid waste.

Entry criteria:

- target text and pronunciation are stable for the batch
- audio tool, voice, and output path are decided
- the batch has passed a quick sanity review

Owner note:
See the phase owner matrix. Default to Codex or the repo audio scripts.

Repo mechanisms currently in play:

- `E:\AI\SpeakLocal-App-Family\app\scripts\generate-audio.ts`
- `E:\AI\SpeakLocal-App-Family\app\scripts\generate-audio-elevenlabs.ts`
- `E:\AI\SpeakLocal-App-Family\app\scripts\generate-audio-registry.ts`

Current output pattern:

- bundled app audio lives under variant-owned paths beneath `E:\AI\SpeakLocal-App-Family\app\assets\audio\`
- the exact variant path and registry shape are owned by the active audio script and registry for that lane

Exit criteria:

- audio files exist for the batch
- registry or manifest state is updated when needed
- rows are not falsely marked ready before QA

Normal next step:
Run audio QA before treating the batch as live-ready.

### 8. Audio QA

Purpose:
Confirm the generated audio is usable, correctly matched, and honest in status.

Entry criteria:

- audio files exist
- the batch still maps cleanly to its source rows

Owner note:
See the phase owner matrix. Jay owns the listening judgment; Codex supports the file and status checks.

QA checks:

- right phrase matched to right audio key
- no missing files for rows marked `ready`
- no rows marked `ready` if the audio is still suspect
- pronunciation and delivery are usable enough for a travel phrasebook
- app and website honesty rules remain accurate

Exit criteria:

- a recorded QA decision exists
- rows truly ready for audio can stay `ready`
- rows that are not trustworthy stay `planned` or revert to `planned`
- the batch has an honest readiness posture

Normal next step:
Integrate the approved batch into the app/runtime path.

### 9. App integration

Purpose:
Move approved prep truth into repo truth and rebuild the runtime artifacts.

Entry criteria:

- phrase-source and scenario-plan truth are ready
- audio posture is honest
- translated batch is approved for merge

Owner note:
See the phase owner matrix. Default to Codex.

Repo actions typically include:

- update `content-draft/<variant>/phrase-source.csv`
- update `content-draft/<variant>/scenario-plan.json` if structure changed
- keep prepared-not-live premium lanes separate until intentionally promoted
- rebuild packs through `npm run build:pack -- --variant <variant>` or the variant-specific script
- run validators such as `npm run validate:family`, `npm run validate:premium-boundary`, and `npm run validate:premium-expansion` when relevant

Runtime-graduation gate for future languages:

- before touching `app/family/appRegistry.js`, `currentApp.ts`, or runtime-facing `ops/apps/*.json` for a newly promoted lane, require:
  - translation coverage for the promoted slice
  - pronunciation coverage for the promoted slice
  - an honest audio posture
  - localized presentation and shared-search handling
  - any script/search review needed for non-Latin or otherwise special-script lanes
  - a clear validation plan recorded in the operational docs

Exit criteria:

- updated prep or repo files exist
- generated pack output matches prep truth
- validators pass
- access-tier, audio-status, family structure, and runtime-graduation rules remain consistent

Normal next step:
Export approved website-safe reuse slices if the new content should surface on the site. Otherwise move straight to device validation for the changed runtime surface.

### 10. Website export and reuse

Purpose:
Project approved starter/default-first content into website-safe payloads without leaking app runtime internals or premium-only content.

Entry criteria:

- app integration is complete for the content being reused
- the website candidate slice is explicitly approved
- rows are starter-only and default-first

Owner note:
See the phase owner matrix. Default to Codex.

Current repo seam:

- source approval: `content-draft/<variant>/website-preview.json`
- export command: `npm run export:website-previews`
- output:
  - `E:\AI\SpeakLocal-App-Family\site\data\phrase-previews\manifest.json`
  - `E:\AI\SpeakLocal-App-Family\site\public\data\phrase-previews\manifest.json`
  - per-module JSON beside those manifests

Exit criteria:

- website payloads are regenerated
- premium-only or non-primary phrase rows are not exported
- audio honesty is preserved
- site consumers can reuse the content through the export seam
- website artifact validation or staging smoke is recorded when the website changed

Normal next step:
Run website artifact validation or staging smoke for the website surface. Only route to device validation from here if the app runtime or UI also changed and still needs proof.

### 11. Device validation

Purpose:
Prove the live experience, not just the repo shape.

Entry criteria:

- app build exists with the new content/audio boundary
- the right manual test lane is ready
- known blockers are documented

Owner note:
See the phase owner matrix. Jay handles the human/device pass; Codex supports evidence capture when needed.

Validation evidence belongs in:

- `E:\AI\SpeakLocal-App-Family\docs\operations\LATEST_VALIDATION.md`
- `E:\AI\SpeakLocal-App-Family\docs\operations\CURRENT_BLOCKERS.md`
- matching `ops/apps/*.json` summary fields when dashboard state changes

Exit criteria:

- exact pass/fail evidence is recorded
- missing confidence is stated honestly
- blockers are updated with the real next human step

Normal next step:
Make a release-confidence judgment from the evidence, not from hope.

### 12. Release-confidence check

Purpose:
Decide whether the lane is ready to ship, ready for the next content slice, or still blocked.

Entry criteria:

- device and validation evidence exists
- current blocker state is documented
- live counts and audio posture are known

Owner note:

- see the phase owner matrix
- Jay owns the judgment
- Codex records it when durable docs or manifests need updating
- lean review gate is useful if the team is about to turn one lane’s lessons into standing process

Exit criteria:

- a recorded ship-or-not-yet decision exists
- ship confidence is either supported or explicitly denied
- the next action is clear:
  - ship
  - fix blocker
  - expand content
  - run more validation
  - feed lessons back into workflow truth

Normal next step:
Either run the next highest-value lane or update workflow truth if the lane taught something reusable.

## Free vs paid handling rules

### Keep in free

Keep phrases in free when they are:

- the first thing a traveler says in a common situation
- core understanding/repair basics
- core transport, hotel, food, money, directions, airport, health, and emergency basics
- necessary for a believable survival-layer experience

### Keep in paid

Keep phrases in paid when they are:

- follow-up, clarification, recovery, dispute, correction, escalation, or confidence phrases
- the second or third sentence after the basic phrase stops being enough
- real traveler-value depth, not decorative politeness

### Move to free instead of dropping

Move a phrase from paid to free when:

- it is still a real traveler moment
- it feels too foundational to charge for
- it improves the survival spine more than it improves paid differentiation
- it is not premium-worthy depth but is still stronger than filler

### Drop only when justified

Drop a phrase only when it is:

- duplicate in meaning
- too narrow to matter
- low-signal filler
- a weak example of something the family already covers better
- not tied to a real traveler decision

## Batch sizing rules

These are defaults, not contracts. The only hard batching rule is: do not split an intent family unless there is no workable alternative.

### Translation batches

Typical translation batch:

- often `80 to 120` rows
- often around `12 to 20` intent families

Use smaller batches, often `40 to 80` rows, when:

- the language is new to the workflow
- the category is safety-critical
- the team is testing a new prompt pattern
- pronunciation quality risk is high

Rules:

- do not split an intent family across batches unless there is no alternative
- preserve scenario cohesion where possible
- start with the highest-value free and recovery families first
- when reconciling an existing lane, batch unresolved rows instead of retranslating the whole pack

### Audio batches

Typical audio batch:

- often `60 to 100` rows once text is stable

Use a pilot batch, often `15 to 25` rows, when:

- the voice, provider, or language posture is new
- pronunciation or pacing quality is still uncertain
- the batch introduces a new quality standard

Audio batch order should follow product value, not file order:

1. free survival layer that must sound trustworthy
2. high-stress categories such as repair, transport, hotel, food correction, money, health, safety, airport
3. next premium recovery depth
4. lower-stakes browsing or sightseeing layers

Do not generate the next big batch until the current one has cleared a quick audio QA pass.

## Artifact and saving rules

Create the minimum artifact needed to unblock the next step. Large named artifacts are for meaningful handoffs, reviewable external outputs, or durable process truth, not every tiny tweak.

### Default intake

Use `C:\Users\Administrator\.openclaw\workspace\projects` as the default long-output intake folder.

### Naming

Use the canonical thread name as the filename base unless a better explicit filename is warranted.

### Codex outputs

Codex should write its own output files directly when possible. Examples:

- workflow docs
- reconciliation summaries
- cleanup artifacts
- generated CSV or markdown support files

### ChatGPT outputs

Jay must save ChatGPT outputs manually after the run. They do not count as durable artifacts until they are saved into the canonical intake folder.

### Repo-prep outputs

When a planning artifact becomes prep truth, the durable home should move into:

- `content-draft/<variant>/`
- `docs/` when it changes durable repo explanation
- `docs/operations/` when it changes live validation/release truth

## How lane board, workflow docs, and repo docs should be used

### Lane board

Use `C:\Users\Administrator\.openclaw\workspace\ops\LANES.md` for:

- what is running now
- what is queued next
- what is waiting or blocked
- where output files were saved

Do not use it as a replacement for workflow docs, content docs, or validation evidence.

### Roadmap or workflow doc

Use the roadmap or workflow doc for:

- how the process works
- what the phases are
- who should do what
- how artifacts move from one truth surface to another
- what must update when the process changes

### Repo docs

Use repo docs for lane-specific durable truth:

- `docs/V2_CONTENT_MODEL.md` for runtime content model rules
- `docs/LANGUAGE_PREP_WORKFLOW.md` for prep-lane graduation boundaries
- `docs/VIET_PREMIUM_EXPANSION_PLAN.md` for Viet-specific planning truth
- `docs/operations/*` for build, blocker, validation, and release truth

## Normal next-step logic

After each phase, the default next move is:

1. architecture -> inventory
2. inventory -> cleanup
3. cleanup -> reconciliation
4. reconciliation -> translation/backfill
5. translation/backfill -> batch prep
6. batch prep -> audio generation
7. audio generation -> audio QA
8. audio QA -> app integration
9. app integration -> website export only if an approved website slice is needed; otherwise device validation
10. website export -> website artifact validation or staging smoke
11. device validation or website validation -> release-confidence check
12. release-confidence check -> either fix blocker, expand the next slice, or update workflow truth with reusable lessons

If a phase fails, return only to the most recent upstream phase that actually needs rework. Do not restart the entire lane unless the structure itself changed.

## Common failure modes and anti-patterns

1. Treating planning artifacts as live truth before they are reconciled into `content-draft` and rebuilt.
2. Letting `ops/LANES.md` or `ops/apps/*.json` become a dumping ground for details that belong in repo docs or operational evidence.
3. Defaulting to Codex for editorial or product judgment that Jay should make directly.
4. Running large ChatGPT prompts without saving the output durably afterward.
5. Skipping the lean review gate for meaningful external prompts that shape architecture, workflow, translation rules, or reusable prompts.
6. Dropping borderline phrases too early instead of first asking whether they belong in the free layer.
7. Treating family variants as count padding instead of meaningful traveler help.
8. Splitting families across translation or audio batches and making QA harder.
9. Generating audio before text and pronunciation are stable.
10. Marking rows as audio-ready because files exist, without listening or checking row-to-audio alignment.
11. Exporting premium-only or non-primary content to the website.
12. Reading website content directly from app runtime internals instead of the website-safe export seam.
13. Confusing live-build counts with planning targets, or planning targets with live-build truth.
14. Assuming device confidence from local validation alone.
15. Adding every lane-specific lesson into the workflow doc until it becomes stale and unreadable.

## Workflow maintenance rules

This workflow must stay alive. Update it when the team learns something repeatable, not when a task merely happened.

### What kinds of learning must update the workflow

Update the workflow when new learning changes:

- the repeatable phase sequence
- a recurring sub-step
- batching rules
- quality gates
- artifact/output handling
- Jay/Codex/ChatGPT tool split
- reviewer-gate usage
- website/app reuse seams
- release-validation habits future lanes should inherit

### When a completed lane should trigger a workflow update

A completed lane should trigger a workflow update when it taught a reusable lesson about:

- content planning
- translation/backfill
- audio generation or QA
- website reuse
- validation or release confidence
- truth-surface ownership

Do not wait for a full project retrospective if the lesson is already clear and likely to recur.

### How finishing Viet should feed back into the blueprint

Viet is the first proving lane for this blueprint, not the permanent template for every future lane. When the Viet app reaches a credible end of the current content/audio lane, run a short workflow feedback pass that asks:

1. Which steps were repeated enough to become standing process?
2. Which steps were missing and had to be invented mid-lane?
3. Which batching sizes actually worked?
4. Which review gates helped, and which would have been noise?
5. Which website/app reuse rules need to become default for the next language?
6. Which validation/release lessons must future lanes inherit?

Only the reusable answers belong in this workflow. Lane-specific history should stay in lane docs or validation logs.

### How future languages and features should extend the workflow

Extend this blueprint by:

- adding new reusable branches or notes only when they affect more than one future lane
- keeping language-specific details in lane docs, prep files, or planning docs
- avoiding one-off exceptions unless they recur

If a new language has a special script, search rule, or audio posture, capture only the reusable decision point here, then keep the language-specific execution details in that lane’s docs.

Before runtime promotion for lanes with special scripts, search rules, or unusual audio posture, require script/search review and localized presentation/shared-search handling, not just translated rows.

### How to keep the workflow from going stale

Use a simple maintenance loop:

1. consult the workflow at lane kickoff
2. use it while framing major external prompts and batch work
3. compare the finished lane against the workflow
4. add only reusable changes
5. keep examples and history outside the main blueprint unless they are essential

If any workflow update trigger is true, update this blueprint before closing the task, then update the matching lane or release doc in the same task.

## Required workflow update triggers

At minimum, update this workflow when any of the following becomes true:

1. a new repeatable phase or sub-step appears
2. sequencing rules change
3. batching rules change
4. a new quality gate becomes standard
5. artifact or output-saving rules change
6. the Jay/Codex/ChatGPT split changes
7. a recurring failure mode appears
8. a completed language/app lane produces a reusable lesson
9. a new website/app reuse seam becomes standard
10. a validation or release lesson should be inherited by future lanes

## Long-term living location and normal usage

Recommended long-term home:

- canonical home: a workspace-level ops/process document, because this workflow crosses repos, external threads, planning artifacts, and human-save rules
- mirror: a short repo doc in `E:\AI\SpeakLocal-App-Family\docs\` that points back to the canonical workflow and summarizes only the repo-specific seams
- optional later step: convert the most stable prompt-and-gate parts into a dedicated skill only after the workflow settles through at least one more full lane

Update order:

1. update the canonical workflow
2. update the repo mirror or pointer if needed
3. update the affected lane or release doc

### How Jay should use it in normal work

Jay should consult this workflow:

- at the start of a new language/app content lane
- before issuing large architecture, inventory, cleanup, translation, or workflow prompts
- before starting a translation/audio batch
- before promoting prepared-not-live content into repo truth
- before website reuse work
- when a lane finishes or gets blocked in a reusable way

### Immediate recommended follow-up after this workflow is accepted

1. Add a short reference from the workspace intake/process area so this becomes normal operating guidance.
2. Add a compact repo-facing pointer in `E:\AI\SpeakLocal-App-Family\docs\` after one more real lane proves the blueprint holds.
3. Update the family skill or add a narrow workflow skill only after the process has been used successfully again.
