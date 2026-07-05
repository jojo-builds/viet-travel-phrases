# Handwritten Recovery Batch 039 - 2026-06-03

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered and validated 5 Hue listing pages:

1. `viet-family-city-hue-place-an-cuu-market` - Chợ An Cựu / An Cuu Market
2. `viet-family-city-hue-place-an-dinh-palace` - Cung An Định / An Dinh Palace
3. `viet-family-city-hue-place-an-hien-garden-house` - Nhà vườn An Hiên / An Hien Garden House
4. `viet-family-city-hue-place-ancient-hue-gallery-cuisine` - Ancient Hue Gallery Cuisine
5. `viet-family-city-hue-place-ancient-hue-restaurant` - Ancient Hue Restaurant

Progress after this batch: **194 / 520 recovered**, **326 remaining**.

## Human-Readable Repair Notes

- An Cuu Market now reads as a neighborhood market with produce, snacks, scooters, small purchases, and everyday errands instead of abstract “market speed” language.
- An Dinh Palace now explains the gate, courtyard, stone path, smaller royal-residence feeling, and old walls without directive or label-like phrasing.
- An Hien Garden House kept its house-and-garden identity but removed “Do not expect” and “the point” phrasing.
- Ancient Hue Gallery Cuisine now reads as a polished Hue dinner room, and its Ancient Hue Restaurant related card is framed as a same-complex sibling rather than a separate unrelated comparison.
- Ancient Hue Restaurant now explains the traditional wooden garden-house setting without the unverified `ruong-house` term, and its menu guidance is less stale-list dependent.

## QA Review

Read-only source/factual QA:
- `019e8b1c-5590-76a3-a9f1-567ee4776675`
- Result: 3 pass, 2 revise.
- Main fixes requested: same-complex sibling treatment for Gallery Cuisine / Ancient Hue Restaurant; remove unverified `ruong-house` wording.

Read-only human-readability QA:
- `019e8b1c-6472-72b1-91c7-a73dbc4f0d14`
- Result: 1 pass with light polish, 4 revise.
- Main fixes requested: replace app-copy-ish phrases such as “market speed,” “less staged,” “facts to land,” and non-human restaurant language.

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
- Voice audit: 0 failures after replacing one `Use ...` opening and reducing `stop` crutch usage back under the corpus threshold.
- City copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes.
- City library validation: 826 pages OK.
- SQLite fixture validation: `ok: true`, 520 city places.
- Production QA audit: 0 blockers, 0 majors.
- Focused visible-copy scan for Batch 039: `PASS`.
- Signing scan after phone build: `SIGNING_SCAN_PASS`.

## Rendered Proof

Simulator profile: `city-listings-production-ready`
Simulator: `SpeakLocal City Listings`
Rendered page left open for review: `city-hue-place-ancient-hue-gallery-cuisine`

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-039-screenshots/001-hue-ancient-hue-gallery-cuisine-top.jpg`

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

Batch 039 passed the current source, readability, rendered, and native validation gates. The overall goal remains active: 194 / 520 recovered, 326 remaining.
