# Handwritten Recovery Batch 042 - 2026-06-03

## Scope

- `viet-family-city-hue-place-ben-trang-cafe-bistro` - Bến Trắng Cafe & Bistro / Ben Trang Cafe & Bistro
- `viet-family-city-hue-place-bun-bo-city` - Bún bò Huế / Bun bo Hue
- `viet-family-city-hue-place-bun-hen` - Bún hến ở Huế / Bun hen
- `viet-family-city-hue-place-bun-thit-nuong` - Bún thịt nướng ở Huế / Bun thit nuong
- `viet-family-city-hue-place-che-hue` - Chè Huế / Hue sweet soup

## Editorial Recovery

- Rewrote Ben Trang Cafe & Bistro around its marina / Le Loi Street / Perfume River context instead of vague river-movement language.
- Rewrote bún bò Huế as the city’s famous spicy noodle soup and added practical pork, shrimp paste, chili, and blood-curd context.
- Rewrote bún hến as Hue’s tiny-clam noodle bowl, with shellfish and peanut context plus the river/lagoons reason.
- Rewrote bún thịt nướng as a clear non-soup Hue lunch and strengthened the peanut warning from “may include” to common roasted peanuts or peanut sauce.
- Rewrote chè Huế as a broad dessert-glass category, with beans, jelly, lotus seed, coconut milk, ice, fruit, and many possible combinations.
- Removed repeated validator/voice issues from the batch: `anchor`, `it fits`, `stop`, `layer`, duplicate hero/summary copy, and vague “doing the work” phrasing.

## Subagent QA

- Factual/source-risk QA: `019e8b54-b875-7920-b667-eadae76981b8`
- Human-readability QA: `019e8b54-dcaf-78f2-a03f-1355bbd42545`
- Both reviews were folded into the source before projection and validation.

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

Validation results:

- V2.2 strict production validation: pass, 520 entries, 520 `FINAL_PASS`
- Voice audit: pass, no failures
- City production copy: pass, 520 city noun pages
- City library: pass, 826 pages
- SQLite fixture: pass, `integrity_check: ok`
- Listing production QA: 0 blockers, 0 majors

## Render Proof

- Simulator profile: `city-listings-production-ready`
- Simulator: `SpeakLocal City Listings`
- Rendered page left open: `viet-family-city-hue-place-bun-thit-nuong`
- Screenshot: `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-042-screenshots/001-hue-bun-thit-nuong-top.jpg`

## Phone Build

- Worktree build source: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
- Build: succeeded
- Install: succeeded
- Launch: blocked because the phone was locked
- Repo-visible signing scan: pass

## Progress

- Recovered so far: 209 / 520
- Remaining: 311
