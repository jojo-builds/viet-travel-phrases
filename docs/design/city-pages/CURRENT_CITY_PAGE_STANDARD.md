# Current City Page Standard

Status: current routing authority for SpeakLocal city/place app-detail work

Current standard: `speaklocal.place.app-detail.v2.2`

Start here before writing, reviewing, importing, validating, or implementing city/place listing copy. Skills may route agents to this file, but repo-owned docs are the authority for the current standard.

## Authoring Split

For city/place copy batches, the preferred authoring workspace is the ChatGPT Project `SpeakLocal City Pages v2.2 Copy`. ChatGPT writes and self-revises small batches against the v2.2 source pack; Codex packages approved drafts, maps catalog/audio IDs, imports source files, regenerates runtime resources, and runs the native production gates.

V2.2 repo docs remain the source of truth. The ChatGPT Project is a copywriting harness, not a newer authority layer. Keep batches small by default: 5 listings per chat, 10 only for easy/low-research rows, and 20 only when Jojo explicitly asks for a rough pass. Self-scores are useful for revision loops, but they are not approval.

Do not make ChatGPT Google Drive write access part of the critical path. The canonical draft handoff from a Project chat is the full batch output in the chat itself, ending with a Codex handoff block. A Google Doc is useful for reading, but Codex owns creating or updating review docs, ledger rows, source imports, and production gates after the chat draft exists.

Operational handoff lives in `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/SpeakLocal_City_Pages_v2_2_Batch_Workflow.md`.

Captured ChatGPT drafts must pass a productionizer review before Jojo voice review. The productionizer pass is still pre-import: it cleans visible-copy leaks, repeated heading cadence, repeated phrase-card sets, and thin-source filler, then labels each page `ready_for_jojo_voice_review`, `revise_before_review`, or `blocked_missing_source`. None of those labels means production-ready.

Bulk city-library cleanup note: the 2026-05-26 `humanizer-gate-500` pass imported all 500 Viet city-library listings into the current native runtime after ChatGPT-assisted drafting, local worker repair, independent integrity review, strict chunk validation, source import, native resource regeneration, and content/runtime validators. Its receipt lives at `docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/reports/humanizer_gate_500_final_review_2026-05-26.md`. That production-ready label was revoked after phone review exposed unacceptable copy voice and top-chrome overlap.

Hard-reset status: earlier 500-listing story-pass and humanizer-gate production labels are revoked. The current approval route is first-class `speaklocal.place.app-detail.v2.2` source in `content-draft/viet/city-library/app-detail-v2-2/`, strict validation, voice/render proof, runtime projection, and the four final gates recorded in `docs/editorial-exports/viet-city-pages/hard-reset-v2-2-2026-05-27/HARD_RESET_V2_2_FINAL_RECEIPT.md`. Legacy-compatible city-library/runtime files are projection evidence only, not approval authority. The old `humanizer-gate-500-2026-05-26` scripts are historical/revoked by default and must not be used as current city-page approval gates unless explicitly run in legacy mode.

## V2.2 Operating Gate

For current city/place app-detail work, do not stop at good prose.

Before drafting fields, choose the one traveler moment the page owns. This can be an arrival sequence, upstairs pause, crossing decision, indoor restock, route pairing, ordering moment, or other concrete situation. Let that moment choose the intro and section shape, then map the finished copy into the app-detail contract.

Production-ready copy also needs a story spine. This is not a new section label and not a long history paragraph. It is the small truthful reason the place belongs in Vietnam, that city, that neighborhood, that food habit, that river/street/market pattern, or that cultural memory. Travelers are not only asking what to do there; they want to feel why the place exists and why it is worth remembering.

The story spine can be origin or history, a local habit or ritual, a city-shape detail, a food lineage, a cultural object, or a modest observed pattern when evidence is thin. Do not invent a backstory to satisfy this requirement. If evidence is thin, keep the story smaller and observable. A generic utility note without a story spine is not production-ready even if the grammar is clean.

A page is not V2.2-complete until it proves five things:

1. Process provenance complete
   - current V2.2 read order used
   - closest canonical anchor and page-specific difference recorded
   - one owned traveler moment chosen before fields
   - one truthful story spine identified before fields
   - source/evidence limits and freshness risks known

2. Source object complete
   - intro heading/body
   - playable useful phrase cards
   - two to four practical sections
   - Mentioned Here candidates evaluated
   - related place candidates evaluated when comparison or route planning helps
   - verification flags
   - QA notes and strict score

3. Catalog/audio mapping complete
   - every useful phrase has phrase/audio status
   - no Useful Phrases prose block is accepted
   - every natural catalog mention is listed as render/check/do_not_render
   - related places are listed only when comparison or route planning helps
   - Mentioned Here / related cards separate user-facing `displaySubtitle` from internal `reason`

4. Rendered page reviewed
   - phrase cards appear immediately after intro
   - no duplicate body or duplicate section
   - Mentioned Here / related modules render when status is render
   - Mentioned Here / related modules render user-facing `displaySubtitle`, not internal QA `reason`
   - bottom chrome does not cover content
   - sticky audio controls do not hide text
   - long phrase rows wrap or use shorter canonical phrases

5. Screenshot and production review gates passed or explicitly marked revise
   - use `V2_2_PRODUCTION_REVIEW_GATE.md` before any page is called production-ready
   - use `V2_2_SCREENSHOT_REVIEW_GATE.md` after source and render checks
   - separate contract status from voice status
   - traveler-use cue does not mean command language
   - headings and first sentences should reveal the place's role in natural English, not sound like software instructions
   - final review classifies each page as `PASS`, `REVISE`, or `FAIL`; only all-`PASS` pages can lose `do_not_publish`/pilot status language

Do not bulk-generate city/place prose with scripts. Scripts may validate, map IDs, detect duplicates, and project approved source into runtime. Scripts are not the copywriter.

If source copy passes but rendered output drops phrase cards, Mentioned Here, related cards, or duplicates text, the page is not production-ready.

## Source Authority

V2.2 approval authority starts from first-class app-detail source objects shaped by `speaklocal.place.app-detail.v2.2`. A page can use legacy city-library/runtime material as evidence or migration input, but legacy `city-v1` fields, generated runtime resources, SQLite rows, and validator receipts are projection only.

A city/place page is not approved because it exists in `content-draft/viet/city-library/v1.json`, bundled native JSON, SQLite, screenshots, or a 500-page story pass receipt. Those artifacts can prove that projection happened; they cannot replace v2.2 source-object approval, voice review, catalog/audio mapping, rendered proof, and `V2_2_PRODUCTION_REVIEW_GATE.md`.

When legacy city-library fields and a first-class app-detail source object disagree, the app-detail source object wins for approval. If no first-class object exists yet, the page status is `needs_v2_2_source_re_gate`.

## Voice Adequacy Gate

Run this as review mode, not a rewrite layer. The gate decides whether a page can proceed, needs a focused revise, or must return to source; it does not bulk-humanize or add a second writing system over v2.2.

Each reviewed page must prove three voice facts in the visible copy:

- scene proof: the reader can picture a specific physical or situational moment
- why-here proof: the page gives a truthful reason this place belongs in this city, neighborhood, route, food habit, cultural memory, or local pattern
- first-move proof: the traveler knows the first useful action, choice, or expectation after arriving

Passing voice sounds story-rich, human, specific, and calm. It does not sound like a database row, process log, QA receipt, import status, validator output, schema checklist, or prompt scaffold. If terms like `process`, `database`, `schema`, `runtime`, `score`, `validator`, `sourceNotes`, or internal status labels would make sense in the visible sentence, the sentence needs revision before approval.

## Read Order

1. `SpeakLocal_Editorial_Playbook_v2_2_Portable.md`
2. `SpeakLocal_Canonical_31_Example_Set_V2_2_App_Ready.md`
3. `speaklocal.place.app-detail.v2.2.schema.json`
4. `SpeakLocal_V2_2_New_Session_Generation_Prompt.md`
5. `SpeakLocal_V2_2_App_Implementation_Audit_Prompt.md`
6. `V2_2_SCREENSHOT_REVIEW_GATE.md`
7. `V2_2_PRODUCTION_REVIEW_GATE.md`

## Current Product Model

City/place pages are app-detail experiences, not generic article sections. A current entry should produce one `appDetail` record with:

- intro / traveler briefing
- playable useful phrase cards
- two to four practical sections
- Mentioned Here catalog candidates
- related place candidates when comparison or route planning is useful
- internal verification flags
- audio/catalog validation status

## Fresh-Agent Done Checklist

A fresh session can pick any city/place page from the catalog, but the output is only a draft until it clears this checklist:

- schema-shaped source object exists or the markdown output can normalize cleanly to `speaklocal.place.app-detail.v2.2`
- phrase/audio statuses are mapped, close-matched, queued, or blocked explicitly
- natural catalog mentions are scanned and marked render/check/do_not_render
- first screen passes the natural-voice read-aloud check
- first screen or one early section carries the story spine in natural copy
- productionizer pass has removed app-visible export labels, repeated batch cadence, unjustified repeated phrase-card sets, and thin-source filler
- fresh rendered screenshots are reviewed for the scoped page IDs, not only the five pilot pages
- final status remains `not_run` or `REVISE` until `V2_2_PRODUCTION_REVIEW_GATE.md` records `PASS`

Reference pages for the first implementation pass:

- Hàn Market / Chợ Hàn
- Ba Na Hills / Bà Nà Hills

## Superseded Models

Do not use these models for new city/place app-detail work:

- `city-v1` as the approval model for current city/place app-detail pages
- mobile-first plus expanded-detail prose as the rendered content model
- fixed old section IDs such as `at-glance`, `quick-say`, `place-brief`, and `use-it-with` as authoring requirements
- old city-library section authoring as the source of current app-detail truth
- useful phrase prose blocks instead of playable phrase cards
- hardcoded Mentioned Here cards as the long-term source of catalog links

Older files in this folder are retained for historical reference only. If an older V1, V2, or V2.1 file conflicts with the V2.2 files above, V2.2 wins.

## Source Contract

Use `speaklocal.place.app-detail.v2.2.schema.json` as the source-owned app-detail contract. Current first-class source lives in `content-draft/viet/city-library/app-detail-v2-2/`, is validated by `native-ios/scripts/validate-viet-city-app-detail-v2-2.js`, and is projected into legacy runtime compatibility only after `FINAL_PASS`.

When a markdown prompt uses shorthand, the schema field names and enums win for source objects. For example, phrase cards should normalize to `usefulPhraseCards[].phraseId`, `audioId`, and `status`, and link candidates should normalize to `mentionedHereCandidates[].status` / `relatedPlaceCandidates[].status`.

Before any bulk source claim, also run `native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js`. It is a drift guard for repeated batch cadence only; it does not replace human reading or the Voice Adequacy Gate.

## Legacy Script Inventory

These scripts remain in the repo for existing city-v1/runtime work, but they are not the current approval authority for V2.2 city/place app-detail pages:

- `native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js`: approved v2.2 source to legacy-runtime projection; not an approval authority.
- `native-ios/scripts/generate-authored-tier-one-pages.js`: mixed live generator; current city/place approval must happen before this projection step.
- `native-ios/scripts/import-viet-city-handwritten-copy.js`: legacy city-v1 importer used only after v2.2 projection.
- `native-ios/scripts/validate-viet-city-copy.js`: legacy runtime compatibility validator; useful for shipped-output checks, not v2.2 approval.
- `native-ios/scripts/build-viet-city-copy-review-report.js`: legacy city copy review report builder.
- `native-ios/scripts/apply-viet-city-production-copy.js`: already legacy-guarded; leave it in place.
- `native-ios/scripts/validate-viet-city-library.js`: city-library validator; legacy for V2.2 app-detail approval.

## Current Execution State

The 2026-05-27 hard reset did generate and migrate the current Viet city/place inventory into first-class V2.2 source objects, then projected that approved source back into the legacy runtime compatibility files. Future city/page work should edit the first-class V2.2 source objects, rerun projection and validators, and treat legacy city-library/runtime files as generated compatibility evidence only.
