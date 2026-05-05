# TASK-VIET-CANONICAL-EDITORIAL-FINISH-ALL-001 Result

## Summary

Completed the Viet canonical listing reset across the current runtime universe. The pass moves listing pages away from content-architecture prose and toward adult first-time traveler utility: shorter context, page-type-specific sections, practical phrase rows, and no dead missing-audio speaker controls.

This was a deterministic source/generator/resource migration. It did not call an LLM at runtime, generate new audio, or hand-edit generated runtime resources directly.

Implementation commit: `7326032f`

## What Changed

- Reworked listing generation by page profile:
  - `singlePhrase`: `Meaning`, `Say this`, `Common follow-ups`, `Next phrases`.
  - `landmark`: `About`, `Hear the name`, `Getting there`, `At the place`, `Meeting or pickup`, `What the name means`, `Good to know`, `Nearby needs`.
  - `streetDriver`: `About`, `Hear the street`, `Driver phrases`, `Check the street`, `If it looks wrong`.
  - `restaurant`: `About`, `Hear the restaurant`, `Order`, `Drinks`, `Pay and get back`, `Getting there`, `Good to know`.
  - `dish`: `About`, `Hear the dish`, `Order it`, `Adjust it`, `Diet / allergy`, `Good to know`.
- Added strict row grouping so dishes do not behave like destinations, restaurant drink rows do not pull allergy rows, landmarks prioritize travel/photo/pickup rows, and phrase pages stay lightweight.
- Added listing-derived Practice/Scenario metadata without changing the visible Practice UI:
  - `3,070` practice seeds.
  - `7,796` practice steps.
  - Phrase pages use `phrase_audio_review` and are saved/recent-only by default.
  - Scenario-capable pages expose step groups from existing canonical phrase IDs.
- Hid missing-audio controls in production rows and hero playback controls. Missing audio is still tracked in the audio production queue.
- Added the finish-all audit packet:
  - `docs/content-audits/viet-canonical-editorial-finish-all-001/summary.json`
  - `docs/content-audits/viet-canonical-editorial-finish-all-001/representative-page-excerpts.md`
  - `docs/content-audits/viet-canonical-editorial-finish-all-001/practice-metadata-samples.json`
  - `docs/content-audits/viet-canonical-editorial-finish-all-001/missing-audio-priority.csv`
  - `docs/content-audits/viet-canonical-editorial-finish-all-001/hero-image-followups.csv`
  - `docs/content-audits/viet-canonical-editorial-finish-all-001/fallback-template-report.json`

## Runtime Counts

- Canonical pages: `3,070`
- Source phrases: `3,078`
- Relations: `21,126`
- Practice seeds: `3,070`
- Practice steps: `7,796`
- Missing audio rows: `2,126`
- Release-blocking missing audio rows: `0`
- Duplicate canonical groups: `0`

Profile counts:

- `singlePhrase`: `2,320`
- `cityPhrase`: `601`
- `landmark`: `115`
- `streetDriver`: `19`
- `restaurant`: `13`
- `dish`: `2`

## Review Proof

Representative rendered-text excerpts were generated for:

- `Cầu Rồng`
- `Bà Nà Hills`
- `Ngũ Hành Sơn`
- `Chùa Linh Ứng`
- `Đường Nguyễn Văn Linh`
- `Đường Bạch Đằng`
- `Bún chả Hương Liên`
- `Phở Bát Đàn`
- `Bún bò Huế`
- `Cao lầu`
- `Nhà vệ sinh ở đâu?`
- hotel check-in
- airport arrival
- taxi / Grab pickup

Reviewer outcome: `APPROVE`.

The reviewer found one final `SAFE_FIX_NOW` wording issue, `anchors the dish`; it was fixed in source, regenerated into runtime outputs, and re-reviewed.

## Validation

Passed:

- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/audit-viet-editorial-finish-all.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- Runtime user-facing wording scan: `34,084` fields checked, `0` banned/internal wording matches.
- Missing-audio UI scan: `0` matches for `speaker.slash`, `Audio not available`, or disabled speaker language in checked runtime/app surfaces.
- `git diff --check`
- Simulator build on `iPhone 17 Pro`: passed.

## Device Build

Physical iPhone build and install completed with local signing overrides.

- Build: passed.
- Install: passed.
- Launch: blocked because the phone was locked. Unlock the phone and tap SpeakLocal.
- Repo-visible signing files stayed clean.
- `git status --short native-ios/project.yml native-ios/SpeakLocalNative.xcodeproj/project.pbxproj`: clean.
- Precise signing scan found no repo-visible `DEVELOPMENT_TEAM`, provisioning profile, provisioning style, or Apple Development signing strings.

## Known Follow-Ups

- `2,126` missing-audio rows remain planned; the priority queue is now in `docs/content-audits/viet-canonical-editorial-finish-all-001/missing-audio-priority.csv`.
- `147` name/place pages still use generic hero fallback imagery; the follow-up list is in `docs/content-audits/viet-canonical-editorial-finish-all-001/hero-image-followups.csv`.
- Full Scenario Mode UI was intentionally not rebuilt in this task. The listing pages now expose metadata/seeds for that future work.

## Phone Review Search Terms

- `Cầu Rồng`
- `Bà Nà Hills`
- `Ngũ Hành Sơn`
- `Chùa Linh Ứng`
- `Đường Nguyễn Văn Linh`
- `Đường Bạch Đằng`
- `Bún chả Hương Liên`
- `Phở Bát Đàn`
- `Bún bò Huế`
- `Cao lầu`
- `Nhà vệ sinh ở đâu?`
- `Cho tôi nhận phòng`
- `Nhập cảnh ở đâu?`
- `Cho tôi tới đây`

## Final Status

Checkpoint committed. Final `git status --short` was clean after the closeout commit.
