# Viet 2000 Full Listing Pages Audit 001

Date: 2026-04-29
Status: Authored checkpoint, not Task Done

## Summary

This checkpoint continues the durable authored-source lane for full-universe Viet listing pages and promotes natural page-by-page expansions from the existing `Xin chào`, `Cảm ơn`, and `Dạ` lessons.

- Source phrase rows after checkpoint: `943`.
- Canonical SQLite phrase pages after checkpoint: `935`.
- Net-new canonical pages in this checkpoint: `24`.
- Required final canonical page count: `2,911`.
- Remaining net-new pages needed for Task Done: `1,976`.
- Full-universe authored source pages: `31`.
- Full-universe rationale records: `31`.
- Missing audio queue rows: `0`.
- Exact existing audio reused in native resources and app assets: `24`.

The task is not complete. This is a safe production checkpoint that proves the authored-source lane, rationale ledger, canonical link handling, exact-audio reuse path, and validators before larger page-by-page authoring continues.

## Authored Source Lane

- Source directory: `content-draft/viet/full-listing-pages/`
- Index: `content-draft/viet/full-listing-pages/_full-universe-index.json`
- Rationale ledger: `content-draft/viet/full-listing-pages/_ai-authoring-rationale.jsonl`
- Source validator: `native-ios/scripts/validate-viet-full-universe-authoring.js`
- Missing audio queue: `docs/audio-queues/viet-missing-audio-TASK-VIET-2000-FULL-LISTING-PAGES-001.csv`

Scripts in this checkpoint only inventory, validate, package, and audit authored content. Phrase rows, page copy, variants, nearby links, and rationale records were written in source files.

## Checkpoint Page Audit

| Page ID | Phrase | Source lesson | Article contract | Breakdown | Links | Duplicate check | Audio |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `viet-hello-chao` | Chào | `Xin chào` casual form | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-ban` | Chào bạn | peer greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-da-chao-anh-chi` | Dạ, chào anh/chị | respectful staff greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-alo` | Alô | phone greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-good-morning` | Chào buổi sáng | morning greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-good-afternoon` | Chào buổi chiều | afternoon greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-anh` | Chào anh | older-man greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-chi` | Chào chị | older-woman greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-em` | Chào em | younger-person greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-ong` | Chào ông | elderly-man greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-ba` | Chào bà | elderly-woman greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-chu` | Chào chú | uncle-age greeting | pass | pass | pass | pass | exact reused |
| `viet-hello-chao-co` | Chào cô | aunt-age greeting | pass | pass | pass | pass | exact reused |
| `viet-smalltalk-di-dau-day` | Đi đâu đấy? | greeting follow-up | pass | pass | pass | pass | exact reused |
| `viet-smalltalk-nice-to-meet-you` | Rất vui được gặp bạn | first-meeting line | pass | pass | pass | pass | exact reused |
| `viet-thanks-cam-on-nhieu` | Cảm ơn nhiều | stronger gratitude | pass | pass | pass | pass | exact reused |
| `viet-thanks-khong-co-gi` | Không có gì | thank-you reply | pass | pass | pass | pass | exact reused |
| `viet-thanks-cam-on-toi-hieu-roi` | Cảm ơn, tôi hiểu rồi | directions closeout | pass | pass | pass | pass | exact reused |
| `viet-thanks-cam-on-ban-da-hieu` | Cảm ơn bạn đã hiểu | patient clarification thanks | pass | pass | pass | pass | exact reused |
| `viet-thanks-khong-cam-on` | Không, cảm ơn | polite refusal | pass | pass | pass | pass | exact reused |
| `viet-acknowledge-da` | Dạ | polite acknowledgment | pass | pass | pass | pass | exact reused |
| `viet-acknowledge-dung` | Đúng | correctness answer | pass | pass | pass | pass | exact reused |
| `viet-acknowledge-co` | Có | availability/existence yes | pass | pass | pass | pass | exact reused |
| `viet-acknowledge-khong` | Không | clear no answer | pass | pass | pass | pass | exact reused |
| `viet-acknowledge-duoc` | Được | okay/that works | pass | pass | pass | pass | exact reused |
| `viet-da-chao-anh` | Dạ, chào anh | respectful older-man greeting | pass | pass | pass | pass | exact reused |
| `viet-da-chao-chi` | Dạ, chào chị | respectful older-woman greeting | pass | pass | pass | pass | exact reused |
| `viet-da-chao-co` | Dạ, chào cô | respectful aunt-age greeting | pass | pass | pass | pass | exact reused |
| `viet-da-chao-chu` | Dạ, chào chú | respectful uncle-age greeting | pass | pass | pass | pass | exact reused |
| `viet-da-chao-ong` | Dạ, chào ông | respectful elderly-man greeting | pass | pass | pass | pass | exact reused |
| `viet-da-chao-ba` | Dạ, chào bà | respectful elderly-woman greeting | pass | pass | pass | pass | exact reused |

## Validation Evidence

Commands run for this checkpoint:

```bash
node --check native-ios/scripts/generate-authored-tier-one-pages.js
node --check native-ios/scripts/validate-viet-full-universe-authoring.js
node native-ios/scripts/validate-viet-full-universe-authoring.js
node native-ios/scripts/generate-viet-catalog.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/validate-tier-one-listing-pages.js
(cd app && npm exec --package=tsx -- tsx scripts/build-family-pack.ts --variant viet)
(cd app && npm exec --package=tsx -- tsx scripts/generate-audio-registry.ts --variant viet)
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js
(cd app && npm exec --package=tsx -- tsx scripts/validate-family-variants.ts)
```

Key results:

- Full-universe source validator: `24` task phrase rows, `31` authored pages, `31` rationale records.
- Tier 1 validator: `150` strong pages, `0` failure rows.
- Authored-page audio audit: `492` required rows, `0` missing.
- SQLite validator: `943` source phrases, `935` canonical pages, `943` resolved phrases, `0` missing audio rows, `0` banned wording matches.
- SQLite generator test: `1` pass, `0` fail.
- Family variant validation: passed.

## Review Gate

The review gate is not approved for final Task Done because only the first three natural expansion sets have been authored.

- First-time traveler UX: pass for the 31 checkpoint pages; final approval waits for the whole page universe.
- Copy and learning flow: pass for the 31 checkpoint pages; final approval waits for the whole page universe.
- Technical efficiency: pass for the checkpoint lane; final approval waits for the complete canonical graph, screenshots, and final audit.

## Remaining Work

Continue page-by-page from the existing source rows. The next recommended batch is the `Xin lỗi` page family, because it naturally expands into excuse-me, apology, passing-through, attention-getting, and small-mistake recovery pages.
