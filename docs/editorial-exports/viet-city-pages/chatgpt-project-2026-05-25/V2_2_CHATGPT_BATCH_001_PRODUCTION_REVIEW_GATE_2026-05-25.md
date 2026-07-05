# V2.2 ChatGPT Batch 001 Production Review Gate

Date: 2026-05-25
Reviewer: Codex
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-pages`
Decision: PASS

## Page IDs

- `city-danang-place-3d-art-in-paradise`
- `city-hanoi-place-bun-cha`
- `city-hcmc-place-ben-thanh-market`
- `city-hue-place-bach-ma-national-park`
- `city-hoian-place-ancient-town-ticket-booth`

## Source And Runtime Files

- Source doc: https://docs.google.com/document/d/1v941nwLRgxOfhTbm3B5oDmw_00GknzOHB576GmJow5c
- V2.2 artifact: `docs/editorial-exports/viet-city-pages/chatgpt-project-2026-05-25/V2_2_CHATGPT_BATCH_001_APP_DETAILS.json`
- Authored city source:
  - `content-draft/viet/city-library/handwritten-copy/danang.json`
  - `content-draft/viet/city-library/handwritten-copy/hanoi.json`
  - `content-draft/viet/city-library/handwritten-copy/hcmc.json`
  - `content-draft/viet/city-library/handwritten-copy/hue.json`
  - `content-draft/viet/city-library/handwritten-copy/hoian.json`
- Generated runtime:
  - `content-draft/viet/city-library/v1.json`
  - `native-ios/Resources/viet-authored-listing-pages.json`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet.sqlite`
  - `native-ios/Resources/LanguagePacks/viet/speaklocal-viet-report.json`
- Native card bridge/tests:
  - `native-ios/App/Models/VietnameseMenuCatalog.swift`
  - `native-ios/Tests/AppChromeTests.swift`
  - `native-ios/UITests/BrowseSearchUITests.swift`

## Commands Run

- `node native-ios/scripts/import-viet-city-handwritten-copy.js` -> PASS, 500 entries imported.
- `node native-ios/scripts/generate-authored-tier-one-pages.js` -> PASS, wrote `viet-authored-listing-pages.json`.
- `node native-ios/scripts/generate-viet-sqlite-fixture.js` -> PASS, SQLite `integrity_check: ok`.
- `node scripts/guard-native-only.js` -> PASS.
- `node native-ios/scripts/validate-viet-city-copy.js` -> PASS, 5 hubs and 500 city noun pages validated.
- `node native-ios/scripts/validate-viet-city-library.js` -> PASS.
- `node native-ios/scripts/validate-viet-hero-image-assets.js` -> PASS.
- `node native-ios/scripts/validate-viet-sqlite-fixture.js` -> PASS.
- Focused native tests on `SpeakLocal City Pages` iOS 26.5 simulator -> PASS, 4 tests, 0 failures.
- Screenshot UI proof on `SpeakLocal Browse` iOS 26.4 simulator -> PASS, 1 test, 0 failures, 20 screenshots.

## Screenshot Folder

`docs/design/city-pages/screenshots/v2-2-batch-001-production-2026-05-25`

## Freshness Sources Checked

- 3D Art in Paradise Da Nang: Da Nang Fantasticity confirms an interactive 3D museum/photo-room visit and photo-point behavior. https://danangfantasticity.com/en/art/art-in-paradise-danang and https://danangfantasticity.com/en/art-paradise-danang-nghe-thuat-danh-lua-thi-giac
- Bun cha: Vietnam Tourism confirms grilled pork, rice noodles, herbs, and dipping-sauce context. https://www.vietnam.travel/things-to-do/tour-hanoi-exploring-its-charm-street-food-and-historical-traces and https://www.vietnam.travel/node/1121
- Ben Thanh Market: Vietnam Tourism confirms Ben Thanh as a central HCMC marketplace; current visible copy avoids exact hours/prices. https://vietnam.travel/things-to-do/7-must-see-attractions-hcmc
- Bach Ma National Park: Vietnam Airlines Heritage source supports Five Lakes and Do Quyen nature-route context; visible copy avoids current fee/access claims. https://www.vietnamairlines.com/~/media/ContentImage/PlanBook/TheExperience/Heritage-publications/Heritage/1%20H256%20all%20pages%20single.pdf
- Hoi An ticket booth: Hoi An World Heritage and Hoi An Ancient Town sources support ticket/heritage-site context; visible copy avoids current price, booth-location, and rule claims. https://www.hoianworldheritage.org.vn/en/news/Hoi-An-24h/hoi-an-experimented-with-selling-sightseeing-tickets-to-the-old-quarter-by-digitization-577.hwh and https://www.hoianancienttown.vn/

## Per-Page Decision Table

| Page | Voice | Phrase/audio | Native cards | Freshness | Decision |
|---|---|---|---|---|---|
| 3D Art in Paradise | PASS | PASS | PASS | PASS | PASS |
| Bun cha | PASS | PASS | PASS | PASS | PASS |
| Ben Thanh Market | PASS | PASS | PASS | PASS | PASS |
| Bach Ma National Park | PASS | PASS | PASS | PASS with same-week caveat | PASS |
| Hoi An ticket booth | PASS | PASS | PASS | PASS with ticket-detail caveat | PASS |

## Notes

- ChatGPT Project produced the visible copy; Codex promoted, normalized phrase IDs, regenerated resources, added native related cards, and ran validation.
- Source summaries were rewritten so card/search summaries do not repeat the intro sentence.
- The Hoi An parent place is rendered once as a related card, not duplicated as Mentioned Here.
- iOS 26.5 simulator UI-runner preflight failed before app assertions; the same UI proof passed on the iOS 26.4 `SpeakLocal Browse` simulator.

Final status: PASS
