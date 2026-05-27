# SpeakLocal City Pages v2.2 ChatGPT Project Pack

Generated: 2026-05-25 11:39

Purpose: make a ChatGPT Project that can write SpeakLocal Vietnam city/page listing copy while Codex remains responsible for import, validation, and native runtime proof.

Ownership: the ChatGPT Project writes and self-revises small copy batches; Codex imports only Jojo/Codex-approved batches, maps phrase/audio/catalog IDs, regenerates resources, and reviews native render proof. This export pack is project context, not a newer authority than `docs/design/city-pages/CURRENT_CITY_PAGE_STANDARD.md`.

Files in this pack:
- SpeakLocal_City_Pages_v2_2_Project_Instructions.txt
- SpeakLocal_City_Pages_v2_2_Source_Bundle.txt
- SpeakLocal_City_Pages_v2_2_New_Chat_Prompt.md
- SpeakLocal_City_Pages_v2_2_Batch_Workflow.md
- SpeakLocal_City_Pages_v2_2_Copy_Ledger_and_Catalogs.xlsx
- City_Listing_Ledger.csv
- Phrase_Picker_Ready_Audio.csv
- Phrase_Catalog_All.csv
- Native_Phrase_Catalog_All.csv
- City_Places_Catalog.csv
- Menu_Catalog.csv
- Canonical_31_Example_Index.csv

Recommended ChatGPT Project setup:
1. Create a Project named `SpeakLocal City Pages v2.2 Copy`.
2. Paste `SpeakLocal_City_Pages_v2_2_Project_Instructions.txt` into Project instructions.
3. Add/upload the Source Bundle text file as Project knowledge.
4. Add/upload the Batch Workflow markdown file as Project knowledge.
5. Add/upload the Copy Ledger and Catalogs spreadsheet as Project knowledge.
6. Keep the Google Sheet as the live ledger for batch claiming and review status.
7. Start new chats with the prompt in `SpeakLocal_City_Pages_v2_2_New_Chat_Prompt.md`.

Drive-write note: do not require every ChatGPT Project chat to create or edit Google Docs. The full chat output is the canonical draft handoff. Codex creates or updates review docs and source artifacts after the draft is available, so one-off connector approvals, blank Docs, or sandbox DOCX fallbacks do not block copy production.

Batch rule: default to 5 listings per chat. Use 10 only for easy/low-research rows. Do not do 20 unless Jojo explicitly asks for rough coverage.

Humanizer cleanup rule: for `humanizer-gate-500` voice cleanup, use five targeted listings or fewer per chat. ChatGPT must return the exact requested pageIDs, complete replacement count, no extra pageIDs, no partial self-pass, and no visible database/reviewer language such as `fits when`, `works when`, `matters when`, `gives [city] a`, `source detail`, or `current details`.

Humanizer gate 500 result:
- Gate folder: `docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26`
- Failed-pass receipt: `reports/humanizer_gate_500_final_review_2026-05-26.md`
- Current status: the superseding 2026-05-27 story-spine pass is production-ready for copy, runtime projection, rendered native chrome, and physical-device install.
- Passing receipt: `reports/production_ready_500_story_gate_2026-05-27.md`
- Important lessons: every page needs a truthful story spine, not only clean utility; keep `works because it`, `key word`, ranking-like `top/best` notes, and metadata-ish `row`/`surface` phrasing out of visible copy; keep restaurant/cafe sensory cues; preserve ready-audio phrase IDs; do not invent one-off phrase cards.

Pilot run:
- Review doc: https://docs.google.com/document/d/1v941nwLRgxOfhTbm3B5oDmw_00GknzOHB576GmJow5c
- Project chat: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a14077f-1be0-83ea-80d8-d475b9cbc2ff
- Status: production_ready_native_passed after Codex promotion, validators, focused native tests, screenshot proof, and review gate.
- Production gate: `V2_2_CHATGPT_BATCH_001_PRODUCTION_REVIEW_GATE_2026-05-25.md`
- V2.2 app-detail artifact: `V2_2_CHATGPT_BATCH_001_APP_DETAILS.json`
- Screenshot proof: `docs/design/city-pages/screenshots/v2-2-batch-001-production-2026-05-25`

Batch 002:
- Project chat: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a143916-03a8-83ea-9070-71dafb5826e9
- Review doc: https://docs.google.com/document/d/11cYGu1I6W2BjKcVh_17SE3bsHXaQklhxxPAkYI6WOXA
- Target page IDs: `city-danang-place-43-factory`, `city-hanoi-place-ba-dinh-square`, `city-hcmc-place-42-nguyen-hue-apartment`, `city-hoian-place-an-hoi-bridge`, `city-hue-place-an-dinh-palace`
- Status: needs Jojo voice review. This is draft/review only until Jojo/Codex approval, source import, native validation, screenshots, and production gate.

Batch 003-012 run:
- Manifest: `batch-runs/2026-05-26-batch-003-012/RUN_MANIFEST.md`
- Target page IDs: 50 claimed rows across Da Nang, Hanoi, Saigon, Hoi An, and Hue.
- Status: ChatGPT drafting sessions started. Recover output from the linked Project chats, not Google Docs.
- Import status: not approved / not imported until Jojo voice review and Codex production gate.

Counts:
- City listing rows: 500
- Ready-audio phrase rows: 935
- All human phrase-source rows: 935
- Native phrase catalog rows: 1765
- City place catalog rows: 500
- Menu catalog rows: 355
- Canonical examples indexed: 31
