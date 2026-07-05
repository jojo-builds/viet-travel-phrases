# SpeakLocal City Pages v2.2 Batch Workflow

Status: current operating model for scaling city/place listing copy

Authority: `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`

ChatGPT Project: `SpeakLocal City Pages v2.2 Copy`

Project URL: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/project

## Role Split

ChatGPT writes and self-revises small batches against the v2.2 source pack.

Codex does not treat ChatGPT copy as production-ready by itself. Codex packages approved drafts, verifies phrase/audio/catalog IDs, imports source files, regenerates native resources, and runs the v2.2 production gate.

V2.2 repo docs stay the source of truth. The ChatGPT Project is a better copywriting room, not a replacement standard.

2026-05-27 addition: the production gate now requires a story spine. Each listing must carry one truthful local/cultural/place story in the intro or an early section. The story can be history, local habit, food lineage, city geography, neighborhood use, or a modest observed pattern. It should not become a new visible section label unless the page naturally needs it.

Google Drive write access is not part of the critical path. ChatGPT should output the complete draft in the Project chat, and that chat output is the canonical draft handoff. Codex creates or updates Google Docs, ledger status, repo source files, and production gates after the draft exists.

## Batch Size

Default: 5 listings per chat.

Use 10 only when every row is easy, low-research, and has obvious reusable phrase cards.

Use 20 only for rough inventory coverage when Jojo explicitly asks for it.

Run at most 2 to 4 parallel drafting chats unless a reviewer is actively checking outputs. More parallelism usually hides voice drift instead of speeding approval.

For the city-library humanizer pass, use the separate 25-entry JSON chunk lane under `docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/`. That lane is for repairing existing city-library source copy while preserving the exact source shape, not for net-new v2.2 app-detail drafting. It can run more parallel ChatGPT sessions because Codex has a chunk validator and import gate, but every chunk still needs capture, self-gate, independent integrity review, and validator proof before import.

## Recommended ChatGPT Session Shape

1. Pick or claim 5 listing IDs from the live ledger.
2. Start a normal Project chat, not Agent mode.
3. Paste the new-chat prompt and the 5 listing rows.
4. Ask ChatGPT to draft Reader View first and implementation notes second.
5. Ask it to self-score and revise the weakest visible lines once or twice before final output.
6. Have it end with the Codex handoff block. Do not ask it to create or update a Google Doc unless Jojo specifically wants that convenience in the chat.
7. Codex creates or updates the readable review doc from the chat output, then marks the output as draft/review only until Jojo/Codex approves import.

Use ChatGPT Agent mode only for bounded source-research chores, such as checking current hours or official pages, when a normal chat lacks enough evidence. Do not use Agent mode as the default copy machine. In the current Project UI checked on 2026-05-26, the model picker exposed Instant, Thinking, and Pro under Extended Pro, not an obvious Agent mode inside the Project. If Agent mode is only available outside the Project, treat that as a research-only path because it may lose the Project source bundle and ledger context.

## Productionizer Pass

Every captured batch now needs a productionizer pass before Jojo voice review. This is an editorial gate over existing drafts, not another free generation round.

The productionizer returns one of:

- `ready_for_jojo_voice_review`
- `revise_before_review`
- `blocked_missing_source`

The pass checks:

- the canonical ChatGPT output was captured from the Project chat
- each page has an owned traveler moment and a specific first screen
- app-visible fields do not contain `Reader View`, `Sections`, `Phrase cards`, `Mentioned Here`, `QA`, `render`, `check_catalog`, scores, source/freshness labels, or readiness status
- heading cadence does not turn into a batch house style
- repeated three-card phrase sets are justified, varied, or marked for revision
- phrase cards are reusable traveler actions with ready audio, not one-off app bloat
- thin-source rows shrink, stay careful, or are blocked instead of filled with generic props
- implementation notes keep source, freshness, phrase/audio, Mentioned Here, and related-card decisions separate from visible copy

Only `ready_for_jojo_voice_review` pages should be put in front of Jojo as voice-review candidates. That still does not mean production-ready.

## Bulk Humanizer Pass

Use this lane only when the task is to humanize existing city-library source at scale.

- Source lane: `docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/`
- Prompt: `CHATGPT_BULK_HUMANIZER_PROMPT.md`
- Chunk size: 25 entries
- Output shape: one complete fenced JSON chunk plus a compact writer self-gate
- Hard rule: preserve page IDs, order, field names, section IDs, source sections, and existing `phraseIDs`
- Codex role: capture the JSON, save it over the matching chunk file, run `validate-humanizer-chunks.js`, repair or re-prompt failures, import only after all 500 entries pass

This lane may use ChatGPT heavily for prose, but it is not allowed to hide dropped content behind nicer voice. The local validator and an integrity review must catch deletion, phrase-card churn, process-language leakage, repeated heading cadence, and generic filler.

For targeted voice cleanup after the first draft chunks exist, switch from 25-entry chunks to five-entry-or-smaller `voice_cleanup_*` prompts. A cleanup output must return the exact target pageIDs and complete replacement count in its self-gate. Partial outputs, wrong pageIDs, risk-bearing self-gates, or outputs that reduce warnings while adding hard errors are rejected by Codex.

Final 500-listing update: the 2026-05-26 humanizer gate passed strict chunk validation, independent integrity review, source import, native city-copy import, resource regeneration, city-copy validation, city-library validation, SQLite validation, hero-image validation, practice deck check, focused Node tests, and `git diff --check`, then failed phone review for copy voice and top-chrome overlap. That production-ready label was revoked. The failed-pass receipt lives at `humanizer-gate-500-2026-05-26/reports/humanizer_gate_500_final_review_2026-05-26.md`.

Superseding 500-listing update: the 2026-05-27 story-spine pass is now the current production status for the 500 city-library listings. It repaired the source copy around truthful story spines, passed strict humanizer chunk validation, production voice audit, production story audit, native runtime validators, 20-screenshot native rendered proof, and physical iPhone build/install/launch. The passing receipt lives at `humanizer-gate-500-2026-05-26/reports/production_ready_500_story_gate_2026-05-27.md`.

## Draft Output Contract

Every listing draft needs:

- closest canonical anchor
- anchor behavior copied
- how this page differs
- one owned traveler moment
- clean Reader View with app-visible copy only
- useful phrase cards using existing ready-audio phrase IDs when possible
- Mentioned Here candidates with `displaySubtitle`, `reason`, `catalogId`, and `status`
- related place candidates only when comparison or route-planning helps
- freshness/source notes kept internal
- strict self-score for revision, not approval
- production review gate status set to `not_run`
- a final Codex handoff block with `batch_id`, `page_ids`, `ready_to_import: no`, `chat_output_is_canonical: yes`, phrase-card catalog risks, place-name phrase policy, visible-copy risks, source-freshness risks, and the next Codex action

Before final output, run one display sweep:

- visible listing headings are not numbered
- phrase-card Vietnamese is not wrapped in quotation marks
- Reader View contains no `check_catalog`, `not_run`, score, QA, source, freshness, or schema/process language
- app-visible fields do not contain generic export labels such as `Sections` or bare `Phrase cards`
- no source-grounding/setup paragraph appears before the batch title and first listing

## Production Gate

A page can move forward only after:

1. Jojo or Codex accepts the visible voice.
2. Codex maps phrase/audio/catalog IDs without one-off phrase bloat.
3. Codex imports the source object.
4. Native resources regenerate from source.
5. Rendered app review passes `V2_2_PRODUCTION_REVIEW_GATE.md`.

Until all five are true, the status is draft, revise, or approved_for_import. It is not production-ready.

## Pilot Run 2026-05-25

Readable review doc: https://docs.google.com/document/d/1v941nwLRgxOfhTbm3B5oDmw_00GknzOHB576GmJow5c

ChatGPT Project chat: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a14077f-1be0-83ea-80d8-d475b9cbc2ff

Listings drafted:

- `city-danang-place-3d-art-in-paradise`
- `city-hanoi-place-bun-cha`
- `city-hcmc-place-ben-thanh-market`
- `city-hue-place-bach-ma-national-park`
- `city-hoian-place-ancient-town-ticket-booth`

Status: production validated after Codex promotion, phrase/audio/catalog mapping, source import, native resource regeneration, focused native tests, screenshot proof, and review gate.

## Batch Run 2026-05-26

Run manifest: `batch-runs/2026-05-26-batch-003-012/RUN_MANIFEST.md`

Scope: 50 claimed city listings, split into ten five-listing Project chats (`batch_003` through `batch_012`).

Status: ChatGPT drafting sessions started. Treat every output as draft until Jojo/Codex voice review, phrase/audio/catalog mapping, source import, native regeneration, rendered review, and production gate.

Recovery: open the session URL from the run manifest, find the final Codex handoff block, then publish a readable review document from the chat output. Do not ask Jojo to copy/paste the chat response.

## Anti-Drift Notes

Do not let process notes leak into visible copy. Phrases such as "useful because", "reference line", "the job is", "destination", "content role", and "this page helps" belong in no Reader View.

Do not force a phrase card just because the page mentions something. Prefer universal travel phrases with ready audio. If the only phrase would be one-off or attraction-specific, mark it as `new_phrase_needed` or leave it out. Place-name audio is pronunciation/name support by default, not a reason to surface a visible phrase card.

Do not let a good heading scaffold become a house style. The Batch 003-012 audit showed overuse of `Let...`, `Start with...`, `Good when...`, `Still worth...`, and `works best`. Future prompts should ask ChatGPT to revise repeated starters before final output, while still letting the evidence choose the actual wording.

Do not replace one scaffold with another. The 500-listing humanizer gate exposed a second wave of polished-but-database phrases: `fits when`, `works when`, `matters when`, `worth saving`, `worth knowing`, `gives [city] a`, `safe frame`, `stable role`, `source detail`, `verified`, and visible `current details/details can shift/check before` language. These phrases read like reviewer notes, not travel copy, and should be removed from visible fields.

The final import exposed a third, smaller wave through downstream validators: `works because it`, `key word`, ranking-like `top/best` wording in role notes, and abstract `row`/`surface` phrasing where it sounds like object metadata. Keep those out of visible copy too.

For restaurant and cafe pages, keep sensory/room evidence in the visible text. At least two concrete cues should survive the polish pass: table, menu, drink, coffee, counter, staff, meal, dining, setting, courtyard, tile floor, natural light, or narrow lane. Do not let cleanup turn a cafe or restaurant into a generic "pause" page.

For the current city-library runtime, city-v1 place articles do not need phrase breakdown sections. Phrase pages still do. Do not add fake breakdowns to city place pages just to satisfy an old test assumption.

Do not let self-scores become approval. Scores are only a way to make ChatGPT revise itself before human/native review.

Do not let Drive connector state decide whether a batch exists. Blank Google Docs, missing links, or sandbox DOCX fallbacks are handoff failures, not copy failures. Recover from the chat output and let Codex publish the readable review doc.

Do not let Project-source citation UI leak into handoff output. Final batch text should not include Markdown links, citation/source chips, pasted-text chips, or clickable Google Doc/Sheet references, even in implementation notes. Source labels are enough. Start with the batch title and first listing, not a source-grounding paragraph.

Keep implementation notes compact and import-facing. They should preserve IDs, phrase/audio status, mention candidates, freshness risks, and the handoff block without becoming a schema dump that drowns the review copy.

Batch 033-037 added one more lesson: 10-listing chats can keep pace, but they need a stronger display sweep because small formatting habits compound across ten pages. The recurring drift was not a total voice failure; it was numbered headings, quote-wrapped phrase cards, repeated station/route command language, and too many `check_catalog` candidates. For the next batch, keep the model reasoning freely about the place, then make it clean the final answer as a readable app draft before handing it to Codex.

Batch 038-042 confirmed the next gate: draft capture is not enough. One batch exposed a visible `Sections` label, several batches used bare `Phrase cards`, and the safer reusable phrase-card strategy sometimes flattened similar food pages into the same card set. These are productionizer issues, not reasons to abandon the ChatGPT Project workflow.
