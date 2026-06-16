# Handwritten Recovery Batch 047 - 2026-06-03

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered 5 Hue pages:

1. `viet-family-city-hue-place-imperial-city` - Hoàng thành Huế / Hue Imperial City
2. `viet-family-city-hue-place-incense-village-workshop` - Trải nghiệm làm hương Thủy Xuân / Incense village workshop
3. `viet-family-city-hue-place-khai-dinh-tomb` - Lăng Khải Định / Tomb of Khai Dinh
4. `viet-family-city-hue-place-khong-gian-hoai-co-coffee` - Không Gian Hoài Cổ Coffee / Khong Gian Hoai Co Coffee
5. `viet-family-city-hue-place-kim-long` - Kim Long / Kim Long

Progress: 234 / 520 recovered. Remaining: 286.

## Editorial Recovery Notes

- Imperial City now uses `Hoàng thành Huế` for the local display name and explains Citadel / Imperial City / Forbidden Purple City distinctions for first-time visitors.
- Thủy Xuân incense workshop now explains the workshop as process, not just a colorful roadside photo stop: bamboo, scented paste, rolling, drying, and makers.
- Khải Định Tomb now explains the steep dark climb, French-era materials, European-influenced details, mosaics/glass/ceramics, and contrast with greener tomb landscapes without superlative claims.
- Không Gian Hoài Cổ Coffee now explains `hoài cổ` naturally and removes unsupported photo/juice/cooler claims, using supported vintage room details instead.
- Kim Long now explains the garden-house neighborhood and softens broad aristocratic claims to source-safer garden-house tradition / older residential memory.

## Sub-Agent QA

Two read-only reviewers checked this batch before validation:

- Factual/source-risk QA: `019e8bb4-f86a-76c2-9321-8add88a39f1d`
  - REVISE: Imperial City local-name precision; cafe unsupported photos/juice/cooler claims; Kim Long broad aristocratic-memory phrasing.
  - PASS: Thủy Xuân incense workshop, Khải Định Tomb.
  - Feedback folded into source.
- U.S.-traveler readability/save-worthiness QA: `019e8bb5-51b5-7813-be81-e1031fee5c61`
  - REVISE: incense workshop heading / close-up photo wording; cafe literal name translation and photo-corners wording.
  - PASS: Imperial City, Khải Định Tomb, Kim Long.
  - Feedback folded into source.

## Sources Used By QA

- UNESCO: Complex of Hue Monuments
- Vietnam Tourism: Khai Dinh Tomb
- Hue Discovery: Thuy Xuan Incense Village
- Hue Discovery: Khong Gian Hoai Co Coffee
- Hue Discovery: Hue Garden House / Kim Long

## Validation

Command:

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

Key output:

- v2.2 projection: 520 entries
- strict production validation: 520 pass, 0 revise, 0 fail
- voice audit: 0 failures
- city production copy validation: 5 hubs, 520 city noun pages, 520 unique target heroes
- City library OK: 826 pages
- SQLite validation OK
- Production QA: 0 blockers, 0 majors
- `git diff --check`: PASS

## Simulator Proof

XcodeBuildMCP profile: `city-listings-production-ready`

- Simulator launch: PASS
- Left Simulator open on `viet-family-city-hue-place-imperial-city`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-047-screenshots/001-hue-imperial-city-top.jpg`

## Physical iPhone Proof

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: BLOCKED by locked iPhone (`FBSOpenApplicationErrorDomain error 7` / device locked)
- Helper post-build signing scan: PASS; repo signing files stayed clean

Explicit signing scan:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`.
