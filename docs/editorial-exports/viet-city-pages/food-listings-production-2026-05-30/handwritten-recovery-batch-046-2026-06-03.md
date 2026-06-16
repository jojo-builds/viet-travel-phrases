# Handwritten Recovery Batch 046 - 2026-06-03

Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Scope

Recovered 5 Hue pages:

1. `viet-family-city-hue-place-gia-hoi` - Gia Hội / Gia Hoi
2. `viet-family-city-hue-place-gia-long-tomb` - Lăng Gia Long / Tomb of Gia Long
3. `viet-family-city-hue-place-hen-island` - Cồn Hến / Hen Island
4. `viet-family-city-hue-place-hon-chen-temple` - Điện Hòn Chén / Hon Chen Temple
5. `viet-family-city-hue-place-huyen-tran-temple` - Đền Huyền Trân / Huyen Tran Princess Temple

Progress: 229 / 520 recovered. Remaining: 291.

## Editorial Recovery Notes

- Gia Hội now explains the old Chi Lăng/Gia Hội neighborhood as lived-in streets east of the Citadel, not a generic orientation area.
- Gia Long Tomb now explains Gia Long as the first Nguyễn emperor and anchors the remote tomb visit in the 1802 imperial-capital context.
- Cồn Hến now defines `hến` as tiny river clams and connects the island to cơm hến / bún hến before asking readers to care about the neighborhood.
- Hòn Chén now explains Vietnamese Mother Goddess worship and keeps the active sacred-space frame ahead of scenic river language.
- Huyền Trân now explains the princess and King Chế Mân / Champa historical context with cautious wording around Đại Việt's southward expansion.

## Sub-Agent QA

Two read-only reviewers checked this batch before validation:

- Factual/source-risk QA: `019e8ba3-45a7-7e61-942f-4c6d0ae46cae`
  - PASS: Gia Hội
  - REVISE: Gia Long wording around Nguyễn dynasty/Hue capital; Cồn Hến diacritic/literal translation; Hòn Chén sacred-space framing; Huyền Trân sensitive history and diacritic consistency.
  - Feedback folded into source.
- U.S.-traveler readability/save-worthiness QA: `019e8ba3-d04a-7293-913c-4fe76c6a4434`
  - PASS: Gia Hội, Gia Long Tomb, Cồn Hến
  - REVISE: Hòn Chén vague worship/festival wording; Huyền Trân weak first-time-visitor framing and bossy temple etiquette.
  - Feedback folded into source.

## Sources Used By QA

- Hue Discovery: Gia Hội / Chi Lăng
- Hue Discovery: cơm hến
- UNESCO: Complex of Hue Monuments
- Vietnam National Authority of Tourism: Gia Long Mausoleum
- Hue Discovery: Điện Hòn Chén / Huệ Nam
- Hue Discovery: Huyền Trân Culture Center
- Hue Discovery: Huyền Trân Temple Festival/history

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

- Build/run simulator: PASS
- Left Simulator open on `viet-family-city-hue-place-huyen-tran-temple`
- Screenshot: `docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-046-screenshots/001-hue-huyen-tran-temple-top.jpg`

## Physical iPhone Proof

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: PASS
- Helper post-build signing scan: PASS; repo signing files stayed clean

Explicit signing scan:

```sh
git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj &&
if rg -q "DEVELOPMENT_TEAM|DevelopmentTeam|PROVISIONING_PROFILE|ProvisioningStyle|ALEXIUS|F7MH7N9445|H92L56XQ86|A650F54E|5fd7a2a0" native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj; then echo SIGNING_SCAN_FAIL; else echo SIGNING_SCAN_PASS; fi &&
git diff --check
```

Result: `SIGNING_SCAN_PASS`.
