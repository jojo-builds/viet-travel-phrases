# Break It Down Visual Spot Check

Date: 2026-05-15

Simulator: iPhone 17 Pro (`45430432-6E67-495B-8A1F-A0086D721315`)

Launch pattern: `--detail-page <pageID> --detail-scroll first-breakdown`

Rendered samples:

- Screenshot issue page: `viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me` -> `screenshots/email-breakdown.jpg`
- Screenshot issue page, later cards: `viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me` -> `screenshots/email-breakdown-later-cards.jpg`
- Screenshot issue page, final card range: `viet-phrase-v900-loca-serv-ever-task-can-you-email-it-to-me` -> `screenshots/email-breakdown-question-gloss.jpg`
- Tier 1: `viet-phrase-bath-2` -> `screenshots/tier1-bathroom-paper-breakdown.jpg`
- City/place: `viet-phrase-city-danang-place-marble-mountains` -> `screenshots/city-marble-mountains-breakdown.jpg`
- Editorial/menu support: `viet-phrase-ves-order-bun-cha-portion` -> `screenshots/editorial-bun-cha-breakdown.jpg`
- Practice expansion: `viet-family-vpe-have-item-co-nuoc-khong-duong-khong` -> `screenshots/practice-expansion-unsweetened-breakdown.jpg`
- Practice expansion, post-review compound blocker: `viet-family-vpe-price-item-so-co-la-viet-nam-bao-nhieu-tien` -> `screenshots/practice-expansion-vietnamese-chocolate-breakdown.jpg`
- Emergency, post-review compound blocker: `viet-phrase-v500-emer-safe-please-call-the-police` -> `screenshots/emergency-call-police-breakdown.jpg`
- Food allergy, post-review compound blocker: `viet-family-food-peanut-allergy` -> `screenshots/food-peanut-allergy-breakdown.jpg`

The screenshots were captured after regenerating authored resources and the Viet SQLite fixture from the reviewed ledger.

Post-blocker rerun notes:

- The screenshot page runtime tokens now include `cho = to / for` and `được không? = is that possible?`.
- The post-review compound blocker now renders `sô cô la = chocolate` and `Việt Nam = Vietnamese` instead of split literal pieces.
- A follow-up compound pass removed split cards for public-safety, food allergy, health, travel, booking, and transport compounds including `cảnh sát`, `đậu phộng`, `tiêu chảy`, `say xe`, `bạc xỉu`, `bưu điện`, `xe buýt`, and `xe máy`.
- `node native-ios/scripts/validate-viet-breakdown-audit.js --require-all-reviewed --json` reports `ok: true`, `runtimePages: 2770`, `reviewedEntries: 2770`, and `errorCount: 0`.
- `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json` reports `badBreakdownGlossCount: 0`, `duplicateBreakdownGlossCount: 0`, and `bannedUserFacingMatchCount: 0`.
- Focused native tests passed on the same simulator: `185` passed, `0` failed.
