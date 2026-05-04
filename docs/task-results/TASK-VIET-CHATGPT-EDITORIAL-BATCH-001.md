# TASK-VIET-CHATGPT-EDITORIAL-BATCH-001 Result

Status: complete. Commit hash: `PENDING_COMMIT`.

## Accepted Steers

- Add `batch_001_*` tabs to the existing Google Sheet instead of overwriting old snapshot tabs.
- Mirror the Sheet-ready batch packet back to repo CSV/JSON.
- Default every patch row to `REVIEW_ONLY`.
- Include known hard pages from the prior editorial pilot unless blocked.
- Include Bà Nà Hills as a completed/model reference, not as an active re-import target.
- Add a schema/version manifest so future batches can follow the same contract.

## Packet And Sheets

- Packet folder: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/`
- Existing review Sheet: https://docs.google.com/spreadsheets/d/1mxsk9O6kuUhekBWhaNlbKH_n4innteBXtYZ4qmu1SOU/edit
- Batch backing Sheet: https://docs.google.com/spreadsheets/d/1nhomn1B9H8vNgCr9TntBAgxF5zvy37WZP_PImX79n4g/edit
- ChatGPT prompt: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/CHATGPT_PROMPT.md`
- Import README: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/IMPORT_README.md`
- Schema/version manifest: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/schema-version.json`
- Sheet readback proof: `docs/editorial-exports/viet-canonical-pages/chatgpt-batch-001/sheet-readback.json`

The existing Sheet keeps the old snapshot tab intact and now has 19 `batch_001_*` tabs. Those tabs pull from the native backing Sheet after the `Allow access` gate was approved in Google Sheets.

## Selected Pages

| # | Phrase ID | Role | Group | Why selected |
|---:|---|---|---|---|
| 1 | `city-hanoi-place-bun-cha-huong-lien` | active | restaurant | Prior hard restaurant page; ordering/drinks/payment/ride-back model. |
| 2 | `city-hanoi-place-pho-bat-dan` | active | restaurant | Prior hard restaurant page; source-aware traveler tasks. |
| 3 | `city-hoian-place-cao-lau-city` | active | dish identity | Remaining unresolved Cao lầu identity page. |
| 4 | `city-hue-place-bun-bo-city` | active | dish | Dish ordering, spice, ingredient, diet support. |
| 5 | `city-danang-place-ba-na-hills` | reference | journey place | Completed Bà Nà Hills model page. |
| 6 | `city-danang-place-dragon-bridge` | active | place navigation | Dragon Bridge place/photo/pickup recovery model. |
| 7 | `city-danang-place-marble-mountains` | active | place journey | Stable-fact attraction and ticket/entrance flow. |
| 8 | `city-danang-place-son-tra` | active | place navigation | Route-area and exact-stop support. |
| 9 | `city-danang-place-bach-dang-street` | active | street pronouncer | Street-name and driver-facing model. |
| 10 | `city-danang-place-nguyen-van-linh-street` | active | street pronouncer | Confirm-location/drop-off/wrong-place model. |
| 11 | `city-danang-place-vo-nguyen-giap-street` | active | street pronouncer | Beach-side street pickup/drop-off flow. |
| 12 | `city-danang-go-ba-na-hills` | active | route/ticket | Title-preserving route phrase support. |
| 13 | `city-danang-where-ba-na-hills` | active | place navigation | Bà Nà direction/recovery question. |
| 14 | `city-danang-ticket-marble-mountains` | active | route/ticket | Ticket-counter phrase support. |
| 15 | `city-danang-go-dragon-bridge` | active | route/ticket | Route phrase support with canonical title preserved. |
| 16 | `city-danang-near-nguyen-van-linh-street` | active | street driver | Near-here street driver flow. |
| 17 | `acknowledge-da-chao-anh` | active | relationship politeness | Deferred tone cleanup path. |
| 18 | `v500-airp-bord-arri-where-is-the-taxi-counter` | active | airport taxi | First-arrival taxi-counter flow. |
| 19 | `v900-airp-bord-arri-can-you-help-me-track-my-bag` | active | airport baggage | High-stress baggage help page. |
| 20 | `hotel-9` | active | hotel taxi | Hotel desk taxi call page. |
| 21 | `v900-hote-acco-can-you-arrange-a-taxi-for-me` | active | hotel taxi | Longer taxi arrangement variant. |
| 22 | `food-peanut-allergy` | active | food allergy | Safety-forward allergy copy. |
| 23 | `v500-food-drin-i-am-allergic-to-shellfish` | active | food allergy | Seafood allergy and diet support. |
| 24 | `emergency-hospital` | active | emergency help | Sensitive hospital navigation page. |
| 25 | `emergency-3` | active | emergency passport | Lost-passport travel flow. |

No required hard page was excluded.

## Schema Summary

- Snapshot files: `pages`, `sections`, `phrase_rows`, `breakdowns`, `relationships`, `renderer_directives`, `asset_directives`, `validator_rules`, `review_notes`, `schema_version`.
- Patch templates: `page_patch`, `section_patch`, `phrase_row_patch`, `breakdown_patch`, `relationship_reorder_patch`, `renderer_directives_patch`, `asset_directives_patch`, `validator_rules_patch`, `questions_for_jojo`.
- Required patch columns include `patch_id`, `page_id`, `phrase_id`, `review_status`, `import_approval`, `operation`, `target_id`, `target_order`, `current_value`, `proposed_value`, `reason_for_change`, `new_linked_phrase_required`, `canonical_target_id`, `audio_policy`, `asset_policy`, `validator_rule`, and `jojo_question`.
- All patch/template rows are non-importable: `review_status=REVIEW_ONLY`, `import_approval=REVIEW_ONLY`.

## Counts

- Selected pages: `25`
- Sections: `216`
- Phrase rows: `261`
- Breakdown rows: `88`
- Relationships: `223`
- Renderer directive rows: `25`
- Asset directive rows: `25`
- Validator rule rows: `10`
- Review note rows: `25`
- Sheet tabs verified: `19`

## Validation

- `node --check native-ios/scripts/export-viet-chatgpt-editorial-batch.js`: PASS
- `node native-ios/scripts/export-viet-chatgpt-editorial-batch.js --check`: PASS
- `node --check native-ios/scripts/validate-viet-chatgpt-editorial-batch.js`: PASS
- `node native-ios/scripts/validate-viet-chatgpt-editorial-batch.js`: PASS
- `git diff --check`: PASS
- Forbidden path diff check for `native-ios/App/**`, `native-ios/Resources/Audio/**`, generated Viet runtime JSON, language-pack SQLite/resources, signing, and Xcode project settings: PASS, no paths changed.
- `node native-ios/scripts/export-viet-editorial-review.js --check`: FAIL, existing broad `latest/` export is stale. I did not regenerate that old snapshot in this task because the approved scope was versioned `chatgpt-batch-001` artifacts and old Sheet snapshot tabs must remain untouched.

## Reviewer Gate

Read-only reviewer gate: APPROVED.

- Packet completeness: approved. The selected pages carry page metadata, sections, visible rows, breakdowns, relationships, renderer/asset rules, validator rules, and review notes.
- Deterministic importability: approved. Patch templates have stable IDs, current values, target IDs/order, canonical target columns, and `REVIEW_ONLY` defaults.
- Anti-slop workflow safety: approved. `CHATGPT_PROMPT.md` forces exact rows, no vague notes, no volatile facts, no internal user-facing terms, and Jojo questions for uncertainty.
- Hard-page coverage: approved. All prior pilot hard pages are included; Bà Nà Hills is marked `reference_completed`.
- Future-batch schema clarity: approved. `schema-version.json` and `sheet-tabs-manifest.json` define reusable file/tab contracts.

## No Import Proof

- No `APPROVED_FOR_IMPORT` values exist in patch row `import_approval` fields.
- No canonical page source was edited.
- No app runtime resource regeneration was run.
- No audio or images were generated.
- No native Swift UI was edited.

## Recommended Next Step

Send the existing Sheet’s `batch_001_*` tabs or the batch backing Sheet to ChatGPT 5.5 Pro with `CHATGPT_PROMPT.md`. After ChatGPT fills exact patch rows, run a separate Jojo approval/import task that imports only rows explicitly set to `APPROVED_FOR_IMPORT`.

## Final Git Status

`PENDING_FINAL_STATUS`
