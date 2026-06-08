# Handwritten Recovery Batch 038 - 2026-06-03

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered and validated the final 5 unrecovered HCMC listing pages:

1. `viet-family-city-hcmc-place-nguyen-hue` - Phố đi bộ Nguyễn Huệ / Nguyen Hue Walking Street
2. `viet-family-city-hcmc-place-nguyen-trai-street` - Đường Nguyễn Trãi / Nguyen Trai Street
3. `viet-family-city-hcmc-place-nhieu-loc-canal` - Kênh Nhiêu Lộc - Thị Nghè / Nhieu Loc - Thi Nghe Canal
4. `viet-family-city-hcmc-place-notre-dame` - Nhà thờ Đức Bà Sài Gòn / Notre Dame Cathedral Basilica of Saigon
5. `viet-family-city-hcmc-place-zoo-botanical-gardens` - Thảo Cầm Viên Sài Gòn / Saigon Zoo and Botanical Gardens

Progress after this batch: **189 / 520 recovered**, **331 remaining**.
HCMC/Saigon remaining from receipt-derived unrecovered set: **0**.

## Human-Readable Repair Notes

- Nguyễn Huệ now says plainly that it is the broad central pedestrian boulevard, with City Hall orientation, cafe frontage, dusk crowds, and a City Hall related card instead of a random Bùi Viện contrast.
- Nguyễn Trãi now reads as a long shopping/address corridor rather than a vague street label. Related card changed from Bùi Viện to Saigon Square.
- Nhiêu Lộc - Thị Nghè Canal now avoids abstract phrases like “landmark pressure” and “the appeal is,” while keeping the everyday waterway, bridge, cafe, and bank-side walk logic.
- Notre-Dame now avoids entrance-directed phrase guidance because tourist interior access can be limited during restoration. It uses meeting-point/photo/directions phrases and pairs with the Central Post Office.
- Saigon Zoo and Botanical Gardens kept the old-trees, family-day, shaded-garden framing and softened the directive line about visit length.

## QA Review

Read-only source/factual QA:
- `019e8b0f-113a-7f31-9655-f8009a5b6c87`
- Result: 3 pass, 2 revise.
- Main fixes requested: replace Nguyễn Trãi related card; replace Notre-Dame entrance phrase and use Post Office pairing.

Read-only human-readability QA:
- `019e8b0f-2dbf-73a2-9c92-0c30663ea3c6`
- Result: 2 pass, 3 revise.
- Main fixes requested: humanize Nguyễn Trãi, Nhiêu Lộc Canal, and Notre-Dame; polish Nguyễn Huệ wording.

## Validation

Passed:

```sh
node native-ios/scripts/project-viet-city-app-detail-v2-2-to-handwritten-copy.js
node native-ios/scripts/import-viet-city-handwritten-copy.js
node native-ios/scripts/generate-authored-tier-one-pages.js
node native-ios/scripts/generate-viet-sqlite-fixture.js
node native-ios/scripts/validate-viet-city-app-detail-v2-2.js --strict-production
node native-ios/scripts/audit-viet-city-app-detail-v2-2-voice.js
node native-ios/scripts/validate-viet-city-copy.js
node native-ios/scripts/validate-viet-city-library.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-listing-production-qa.js
git diff --check
```

Important outputs:

- v2.2 strict production validation: `PASS`, 520 entries, 0 revise, 0 fail.
- Voice audit: 0 failures after replacing the rejected `strongest` wording.
- City copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library validation: 826 pages OK.
- SQLite fixture validation: `ok: true`, 520 city places.
- Production QA audit: 0 blockers, 0 majors.
- Focused visible-copy scan for Batch 038: `PASS`.
- Signing scan after phone build: `SIGNING_SCAN_PASS`.

## Rendered Proof

Simulator profile: `city-listings-production-ready`
Simulator: `SpeakLocal City Listings`
Rendered page left open for review: `city-hcmc-place-notre-dame`

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-038-screenshots/001-hcmc-notre-dame-top.jpg`

## Phone Build

Command used:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: succeeded.
- Install: succeeded.
- Launch: blocked because the iPhone was locked.
- Repo signing hygiene: passed; personal signing values were not written to repo project files.

## Remaining Risk

Batch 038 passed the current source, readability, rendered, and native validation gates. The overall goal remains active: 189 / 520 recovered, 331 remaining.
