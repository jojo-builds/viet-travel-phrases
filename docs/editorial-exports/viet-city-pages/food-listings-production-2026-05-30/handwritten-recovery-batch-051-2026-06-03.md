# Handwritten Recovery Batch 051 - 2026-06-03

Status: PASS for authored copy import, native resource generation, validator guardrails, voice audit, and Simulator render proof. Physical iPhone install was not retried for this batch because the immediately preceding batch already proved build success and repeatedly hung in `devicectl device install app`.

Progress after this batch: 254 / 520 recovered. Remaining: 266.

## Scope

- `viet-family-city-hue-place-ngo-mon-gate` - Ngọ Môn / Ngo Mon Gate
- `viet-family-city-hue-place-ngu-binh-mountain` - Núi Ngự Bình / Ngu Binh Mountain
- `viet-family-city-hue-place-nguyen-dinh-chieu-street` - Phố đi bộ Nguyễn Đình Chiểu / Nguyen Dinh Chieu Walking Street
- `viet-family-city-hue-place-nha-nhac-royal-court-music` - Nhã nhạc cung đình Huế / Hue Royal Court Music
- `viet-family-city-hue-place-night-market` - Chợ đêm Huế / Hue Night Market

## Authored Fixes

- Ngo Mon Gate now defines Ngọ Môn as Noon Gate and Hue's main ceremonial gate into the Imperial City, with concrete first-move guidance around photos, group orientation, tickets, and entering the Citadel walk.
- Ngu Binh Mountain now explains the mountain as Hue's symbolic skyline backdrop rather than a must-do hike, with plain viewing context from river views, tomb routes, and Vọng Cảnh Hill.
- Nguyen Dinh Chieu Walking Street now centers on the riverside pedestrian stretch near Trường Tiền Bridge: river views, bridge lights, public art, performers, and people-watching, with softer snack/stall claims.
- Hue Royal Court Music now introduces Nhã nhạc as UNESCO-recognized Vietnamese royal court music tied to Hue's Nguyễn emperors and frames the visit as a formal seated performance, not casual nightlife.
- Hue Night Market now avoids treating the market as one fixed official venue. It frames Chợ đêm Huế as a practical riverside night-browse area near the Perfume River and walking streets, with snacks, small gifts, bridge light, cash, and price questions.

## Sub-Agent QA

- Source-risk QA: `019e8c26-fa72-72b3-b449-76ad47baaa39`
  - Passed Ngo Mon Gate, Ngu Binh Mountain, and Hue Royal Court Music.
  - Flagged Nguyen Dinh Chieu Walking Street for venue-identity blur with night-market/stall language; copy was re-centered on river, bridge, public art, performers, photos, and nearby occasional stalls.
  - Flagged Hue Night Market for source/identity risk around one stable formal venue; copy now frames it as a riverside night-browse pattern and avoids fixed hours or stall inventory.
- U.S.-traveler readability QA: `019e8c27-6e95-7561-b1c8-c4ca06d3afd0`
  - Flagged Ngu Binh Mountain as truthful but abstract; copy now explains symbolic skyline value and concrete viewing contexts.
  - Flagged Nguyen Dinh Chieu Walking Street wording such as `named river-walk setting` and `night's mood`; those were removed.
  - Flagged Nhã nhạc headings such as `culture slot`, `museum silence`, and under-explained court music; copy now introduces UNESCO-recognized royal court music plainly.
  - Flagged Night Market `price phrases` wording and generic riverside mood; copy now uses natural buying advice.

## Validation

Command chain:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js &&
node native-ios/scripts/import-viet-city-handwritten-copy.js &&
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

Result: PASS.

Key results:

- v2.2 projection: 520 entries
- strict production validation: 520 pass, 0 revise, 0 fail
- voice audit: 0 failures
- city production copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes
- city library validation: 826 pages
- SQLite validation: ok
- production QA: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator profile: `city-listings-production-ready`

Rendered page left open on Simulator:

- `viet-family-city-hue-place-night-market`

Screenshot:

- `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-051-screenshots/001-hue-night-market-top.jpg`

Simulator build/run result: PASS.

## Phone Build

Physical iPhone build/install was not retried for this batch.

Reason:

- Batch 050 in this same session built successfully for the physical iPhone but hung during `devicectl device install app` after acquiring the device connection and usage assertion.
- The stuck install process was terminated cleanly then.
- Batch 051 changed content/resources only and was verified on the dedicated Simulator.

Signing hygiene:

- Repo signing scan: PASS.
- No repo-visible personal signing was detected in `native-ios/project.yml` or `native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`.

## Carry Forward

The named-reference rule from Batch 050 is now active in practice. Batch 051 adds a second lesson: when two Hue surfaces are adjacent in real life, such as a walking street and night-market browse, the copy must avoid merging their identities. One page should own the riverside walk; the other should own price questions, snacks, small gifts, and flexible browsing.
