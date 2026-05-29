# SpeakLocal City Pages 500-Listing Humanizer Progress

Date: 2026-05-26

Status: blocked by rendered phone review; previous production-ready claim revoked.

Latest checkpoint: 2026-05-26 19:21 ICT

## Scope

- 500 city-library listings across Da Nang, Hanoi, Ho Chi Minh City, Hoi An, and Hue
- Da Nang/Hanoi 200-entry baseline copied from the prior humanizer gate
- HCMC/Hoi An/Hue 300-entry repair ran through ChatGPT Project chunks, targeted cleanup prompts, and city-scoped local worker repair.
- The final promoted source is the 20 validated `chunks/*_humanized.json` files imported into `content-draft/viet/city-library/handwritten-copy/{danang,hanoi,hcmc,hoian,hue}.json`.

## Live ChatGPT Sessions

ChatGPT Project: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/project

Known submitted chunks:

- `hcmc_001_025`: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156af1-7134-83ea-b59f-c399259bbd66
- `hcmc_026_050`: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156b5a-bcd4-83ea-9bae-ada23829cd24
- `hcmc_051_075`: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156bb3-c158-83ea-92ea-70f1dd109442
- `hcmc_076_100`: https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a1574ba-07b8-83ea-8ce1-32a8c789acfe

Submitted chunk sessions to identify from output:

- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156c5d-4664-83ea-be31-0c8f171b264e
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156d34-07c4-83ea-8756-eaff4ff2f61b
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156d80-c0b4-83ea-ae13-72ae165a9d57
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156dba-a52c-83ea-b3fd-2025bc26e70b
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156df3-633c-83ea-85ab-ae741241e099
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156e31-ca28-83ea-bbb9-23f29f422184
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156e73-cba4-83ea-a345-1be7f546a40c
- https://chatgpt.com/g/g-p-6a13d31fe8308191a4fc612012775595-speaklocal-city-pages-v2-2-copy/c/6a156ebf-6dec-83ea-ae45-40852a58455e

Old Safari Project tabs were closed during the run. If Safari was locked during a later handoff, treat the local project-pack files as current and upload them to the live ChatGPT Project at the next browser-access boundary.

Targeted voice cleanup sessions submitted:

- `voice_cleanup_01`: Da Nang 001-050, 20 targeted entries
- `voice_cleanup_02`: Da Nang 051-100, 30 targeted entries
- `voice_cleanup_03`: Hanoi 001-050, 17 targeted entries
- `voice_cleanup_04`: Hanoi 051-100, 35 targeted entries
- `voice_cleanup_05`: HCMC 001-050, 36 targeted entries
- `voice_cleanup_06`: HCMC 051-100, 18 targeted entries
- `voice_cleanup_07`: Hoi An 001-050, 35 targeted entries
- `voice_cleanup_08`: Hoi An 051-100, 36 targeted entries
- `voice_cleanup_09`: Hue 001-050, 12 targeted entries
- `voice_cleanup_10`: Hue 051-100, 31 targeted entries

## Required Gate

For each ChatGPT output:

1. Capture the fenced JSON chunk and writer self-gate.
2. Save the JSON over the matching file in `chunks/`.
3. Run `node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/validate-humanizer-chunks.js`.
4. Repair or re-prompt any chunk with validation errors.
5. Only after all 500 entries pass, run the import script and native/content validators.

## Validator History

Initial run before ChatGPT repair failed as expected:

- entries: 500
- errors: 2193
- warnings: 0
- Da Nang: 0 errors
- Hanoi: 0 errors
- HCMC: 714 errors
- Hoi An: 723 errors
- Hue: 756 errors

This failure is the baseline drift proof, not a production blocker by itself.

Latest strict-prep run after HCMC 076-100 full repair:

- entries: 500
- errors: 15
- warnings: 450
- missing chunks: 0

Production import was blocked until `validate-humanizer-chunks.js --strict` reported `errors=0` and `warnings=0`.

## Merge Incident

`voice_cleanup_03` returned only 11 of the 17 required replacement entries while self-gating itself as `pass`. Codex rejected the handoff, restored the two touched Hanoi chunks from source truth, moved the file to `chatgpt-outputs/rejected/voice-cleanup/voice_cleanup_03_partial_11_of_17.json`, and fixed `merge-voice-cleanup-output.js` so future replacement merges are atomic before writing.

## Voice Cleanup Wave 1 Result

Captured ChatGPT outputs from the first broad cleanup wave showed a useful but dangerous pattern: ChatGPT can improve surface polish while still introducing new hard blockers. Self-gates are kept as drafting signal only; production approval now belongs to `safe-merge-voice-cleanup-output.js` plus the validator.

Accepted:

- `voice_cleanup_07`: kept because it improved the corpus from `errors=258 warnings=368` to `errors=257 warnings=328`.
- `voice_cleanup_09`: kept earlier as an accepted partial because it reduced warnings without increasing hard errors under the then-current validator.

Rejected or rolled back:

- `voice_cleanup_02`: full output, but regressed hard errors.
- `voice_cleanup_03`: partial 11/17 output and regressed when trialed.
- `voice_cleanup_04`: partial output and regressed hard errors.
- `voice_cleanup_06`: full output, but regressed hard errors.
- `voice_cleanup_08`: full output, but regressed hard errors.
- `voice_cleanup_10`: partial output and regressed hard errors.

Latest validator state after the accepted `voice_cleanup_07` merge:

- entries: 500
- errors: 257
- warnings: 328
- missing chunks: 0

Current blockers are mostly formula fragments that sound like app/database prose instead of travel copy:

- `fits when`
- `works when`
- `matters when`
- `gives <city> a`
- generic quick-say headings such as `Name To Recognize` / `Local Name To Recognize`
- visible QA/freshness/process language in body copy
- command-like `Check...` headings

## Next Process Change

Do not send broad 20-35-entry cleanup prompts for voice polish. The next ChatGPT wave should use smaller five-entry prompts built from the live validator report, with explicit banned-fragment and expected-count checks. Merge only through `safe-merge-voice-cleanup-output.js`; never paste directly into chunk files.

R2 prompt set:

- Generated `72` five-entry-or-smaller prompts in `prompts/voice-cleanup/voice_cleanup_r2_*.txt`.
- Default r2 safe merge now requires complete replacement count. Use `--allow-partial` only as an explicit salvage path, not the normal production path.
- Rejected outputs in `chatgpt-outputs/voice-cleanup/` are automatically moved into `chatgpt-outputs/rejected/voice-cleanup/` on rollback so stale failed files are not reprocessed accidentally.
- R2 manifest now records exact `targetPageIDs`, and `merge-voice-cleanup-output.js` rejects outputs that return the wrong page set even if the count matches.
- `safe-merge-voice-cleanup-output.js` now rolls back on merge command failure before judging validator improvement.

## Subagent Audit Teachings

Independent read-only audits agreed on the main drift cause: ChatGPT and Codex both drift when prompts ask for app-role explanation instead of the lived traveler moment. The remaining blockers are mostly visible system language, not missing information.

Use these as the working production lessons:

- Five-entry cleanup prompts are the reliable unit for this stage.
- ChatGPT self-score is useful for iteration, but it is not approval.
- Broad cleanup prompts can lower warnings while increasing hard errors.
- Chunk-level heading warnings can become stale after each merge, so avoid launching many prompts against the same chunk at once.
- Do not let freshness uncertainty become visible app copy. Stable role belongs in the listing; current checks belong in notes/gates.
- Non-playable quick-say sections cannot collapse into repeated name cards. If no reusable audio phrase fits, write a natural tiny briefing instead.

## Final Gate Result Revoked

After city-scoped worker repair, targeted independent-review blocker cleanup, and validator hardening, the import validators passed. A later phone review showed that this was not enough:

- `validate-humanizer-chunks.js --strict`: passed
- entries: 500
- errors: 0
- warnings: 0
- independent integrity review: `reports/independent_integrity_review_2026-05-26.md`
- final review gate: `reports/humanizer_gate_500_final_review_2026-05-26.md`
- source import: `reports/humanizer_import_receipt.json`
- native import: `node native-ios/scripts/import-viet-city-handwritten-copy.js`
- regenerated resources: `native-ios/Resources/viet-phrase-catalog.json`, `native-ios/Resources/viet-authored-listing-pages.json`, `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`

The import script now requires both review receipts to be present and marked `Status: PASS` before it writes the 500 humanized chunks into source. That import gate is still useful, but it is not sufficient for production-ready status.

## Validation Proof That Passed

All commands passed on 2026-05-26:

- `node docs/editorial-exports/viet-city-pages/humanizer-gate-500-2026-05-26/validate-humanizer-chunks.js --strict`
- `node scripts/guard-native-only.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node native-ios/scripts/validate-viet-city-copy.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-hero-image-assets.js`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `git diff --check`

Final validator counts:

- City production copy: `5` hubs, `500` city noun pages, `500` unique target heroes.
- City library: `806` pages, `706` beginner, `95` intermediate, `5` advanced.
- SQLite: `1758` pages, `500` city places, `806` city phrase tags, `680` planned missing-audio rows, `0` release-blocking missing-audio rows.

## Lessons Added To The Process

- The hard gate must include the native city-copy validator, city-library validator, SQLite validator, and fixture tests, not only the humanizer chunk validator.
- ChatGPT cleanup self-gates can still miss literal process phrasing, so `works because it`, `key word`, and `creamy top` were added to the humanizer validator after downstream gates caught them.
- Playable `Useful Phrases` sections must declare `sourceMode: "expanded-detail"` and carry ready-audio phrase IDs; prose-only quick-say sections must not use that title.
- Restaurant/cafe pages need at least two concrete table/menu/drink/counter/room cues in rendered copy so polish does not flatten them into abstract place notes.
- City-v1 place articles intentionally skip phrase breakdown sections. The SQLite fixture test now matches the validator by requiring breakdowns for phrase pages while allowing handwritten city articles to use place-detail sections.
- A validator pass cannot certify voice. Phone review of `city-danang-place-da-nang-museum` showed mechanical copy such as `The City Gets The First Word`, `counterweight`, `Pick One Thread`, and `Quiet Beats Completion`.
- Rendered phone review is mandatory before any future production-ready label. The phone screenshot showed the static back chrome overlapping content near `Useful Phrases`.
