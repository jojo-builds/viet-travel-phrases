# Handwritten Recovery Batch 037 - 2026-06-03

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered and validated 5 HCMC listing pages:

1. `viet-family-city-hcmc-place-turtle-lake` - Hồ Con Rùa / Turtle Lake
2. `viet-family-city-hcmc-place-vincom-dong-khoi` - Vincom Đồng Khởi / Vincom Center Dong Khoi
3. `viet-family-city-hcmc-place-vinhomes-central-park` - Công viên Vinhomes Central Park / Vinhomes Central Park
4. `viet-family-city-hcmc-place-war-remnants-museum` - Bảo tàng Chứng tích Chiến tranh / War Remnants Museum
5. `viet-family-city-hcmc-place-workshop-coffee` - The Workshop Coffee

Progress after this batch: **184 / 520 recovered**, **336 remaining**.

## Human-Readable Repair Notes

- Turtle Lake now explains the place as a District 3 traffic-circle landmark, not a vague named attraction. Removed the duplicate District 3 related card and softened the visit guidance into suggestion-style copy.
- Vincom Đồng Khởi now carries the correct `Shopping` category and keeps the visible copy plainly mall-specific: cooling off, bathrooms, snacks, card-friendly shopping, and meetups.
- Vinhomes Central Park now connects the park to modern riverside Saigon, Landmark 81, skyline scale, and evening river atmosphere. Replaced the weak Gia Định Park related card with Landmark 81.
- War Remnants Museum passed both source-risk and readability review; copy stays serious, direct, and emotionally paced for U.S. first-time visitors.
- The Workshop Coffee passed both reviews; optional heading polish changed `Why This One` to `Why Coffee People Save It`.

## QA Review

Read-only source/factual QA:
- `019e8afd-c2f9-7051-9431-bf3582021d25`
- Result: 2 required revisions, 3 passes.

Read-only human-readability QA:
- `019e8afd-d2f8-7192-90e3-d57579840754`
- Result: 2 required revisions, 3 passes.

Both QA passes independently flagged Turtle Lake duplicate related cards and the weak Vinhomes related-card choice. Those were fixed in source before projection.

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
- Voice audit: 0 failures after replacing the rejected `Best In The Evening` heading.
- City copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library validation: 826 pages OK.
- SQLite fixture validation: `ok: true`, 520 city places.
- Production QA audit: 0 blockers, 0 majors.
- Signing scan after phone build: `SIGNING_SCAN_PASS`.

## Rendered Proof

Simulator profile: `city-listings-production-ready`
Simulator: `SpeakLocal City Listings`
Rendered page left open for review: `city-hcmc-place-vinhomes-central-park`

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-037-screenshots/001-hcmc-vinhomes-central-park-top.jpg`

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

Batch 037 has passed the current source, readability, rendered, and native validation gates. As with prior batches, this does not mean all 520 pages are production-ready yet; the recovered count is 184 / 520.
