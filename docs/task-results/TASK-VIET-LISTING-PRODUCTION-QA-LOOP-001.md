# TASK-VIET-LISTING-PRODUCTION-QA-LOOP-001

## Summary

Implemented a production QA checkpoint for Viet listing pages that uses rendered-page proof, not just green validators.

This pass fixed systemic issues found during simulator review:

- Simple phrase pages now hide duplicated hero-repeat sections such as redundant `Meaning` / `Quick say` blocks.
- Authored listing pages no longer append the generic catalog browse shelf after their page-owned sections. This removes random `Browse more` / city-feed rows from pages such as Bà Nà Hills and Central Post Office child phrases.
- Pinned audio speed controls reserve top scroll clearance when the main player is offscreen, so section headings and rows do not sit under the speed control.
- Bà Nà Hills proof now ends on deliberate `Food & cash` / `Name guide` content instead of unrelated Da Nang browse carousels.

No audio was generated.

## Artifacts

- QA audit packet: `docs/content-audits/viet-listing-production-qa-001/`
- Representative screenshot proof: `native-ios/artifacts/TASK-VIET-LISTING-PRODUCTION-QA-LOOP-001/`
- Key rendered excerpts: `docs/content-audits/viet-listing-production-qa-001/representative-rendered-excerpts.md`
- Missing audio priority queue: `docs/content-audits/viet-listing-production-qa-001/missing-audio-priority.csv`
- Hero image report: `docs/content-audits/viet-listing-production-qa-001/hero-image-report.csv`
- Practice metadata samples: `docs/content-audits/viet-listing-production-qa-001/practice-metadata-samples.json`

## Representative Pages Captured

- `Tôi không hiểu`
- `Bàn này còn trống`
- `Bà Nà Hills`
- `Cầu Rồng`
- `Đường Nguyễn Văn Linh`
- `Anăn Sài Gòn`
- `Bưu điện Thành phố ở đâu?`

Each page has top, middle, and bottom simulator screenshots.

## Validation

Passed:

- `node native-ios/scripts/generate-viet-catalog.js`
- `node native-ios/scripts/generate-authored-tier-one-pages.js`
- `node native-ios/scripts/generate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-listing-production-qa.js --check`
- `node native-ios/scripts/validate-viet-listing-intent-routing.js`
- `node native-ios/scripts/validate-viet-city-library.js`
- `node native-ios/scripts/validate-viet-sqlite-fixture.js`
- `node native-ios/scripts/audit-viet-canonical-content.js --check`
- `node native-ios/scripts/audit-viet-page-quality.js`
- `node native-ios/scripts/validate-tier-one-listing-pages.js`
- `node scripts/practice/generate-viet-practice-deck.js --check`
- `node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js`
- `node --test scripts/practice/generate-viet-practice-deck.test.js`
- `git diff --check`
- Focused native unit tests for rendered duplicate suppression
- Simulator UI screenshot proof for representative listing pages

Static QA audit result:

- `3070` pages checked
- `0` blockers
- `0` majors
- `4483` duplicate hero-repeat sections hidden at render time
- `500` top-priority missing-audio rows exported

Canonical content audit result:

- `3070` canonical pages
- `3078` source phrases
- `0` duplicate canonical page groups
- `2126` planned missing-audio rows
- `0` release-blocking missing-audio rows

## Remaining Follow-Ups

- The missing-audio queue still matters. Hidden/missing audio should become production work, especially for top names and top scenario phrases.
- The hero image report still lists pages that need page-specific or neutral-image review.
- City/country hub surfaces still need a dedicated hub renderer QA pass beyond authored listing-page detail screenshots.
- If Bà Nà Hills still feels laggy on the physical phone, run a focused scroll performance trace against that page now that the generic appended carousel is removed.

## Scope Proof

No `native-ios/Resources/Audio/**`, signing, provisioning, or Xcode project settings were intentionally changed.
