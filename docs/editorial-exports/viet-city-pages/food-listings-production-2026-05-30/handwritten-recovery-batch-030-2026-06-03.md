# Handwritten Recovery Batch 030

Date: 2026-06-03
Branch: `feature/city-listings-production-ready`
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`

## Scope

Recovered five HCMC V2.2 source listings:

- `viet-family-city-hcmc-place-le-van-tam-park`
- `viet-family-city-hcmc-place-little-hanoi-egg-coffee`
- `viet-family-city-hcmc-place-long-trieu`
- `viet-family-city-hcmc-place-lusine-thao-dien`
- `viet-family-city-hcmc-place-man-moi`

Progress after this batch: 149 / 520 recovered, 371 remaining.

## Human Rewrite Notes

- Lê Văn Tám Park now explains the practical park role and the former Mạc Đĩnh Chi Cemetery backstory without making the stop sound bigger than it is.
- Little HaNoi Egg Coffee now defines egg coffee plainly for U.S. readers and explains why a Hanoi-associated drink matters inside a Saigon cafe day.
- Long Triều now reads as a polished Cantonese restaurant inside The Reverie Saigon, with lunch dim sum, seafood, hotel service, private rooms, and a clear Chợ Lớn comparison.
- L'Usine Thảo Điền now explains why this branch is different: a roomier Thao Dien brunch/cafe/concept-store stop with specific menu signals.
- Mặn Mòi now defines Bib Gourmand in the intro and frames the restaurant as a calmer Thao Dien / Thu Duc shared Vietnamese dinner, not a vague "recommended" restaurant.

## Review Loop

Two sub-agent reviews were used:

- Factual/source-risk QA: `019e8a6b-28af-7971-a3ce-d7a52f8fd7de`
- Human-readability QA: `019e8a6f-d239-7ef3-a622-64b25f9320d8`

Reviewer-driven fixes applied:

- Replaced Le Van Tam command-like and inflated park language with nearby-break language.
- Kept the former cemetery context factual and modest.
- Replaced Long Triều's weak pork/beef/chicken phrase card with the audio-backed seafood dietary phrase.
- Replaced vague Long Triều `food world` language with a clearer Chinese-Vietnamese / Cantonese dining story.
- Restored L'Usine's researched menu signals after production QA caught the line becoming too generic.
- Defined Bib Gourmand as Michelin's good-value category for cooking worth seeking out.
- Removed local formula hits such as `it fits`, `Best...`, visible `not a`, and related-card `feel` language before final validation.

## Validation

Command chain passed:

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

Result:

- V2.2 strict production validation: PASS
- Voice audit failures: none
- City copy validation: PASS
- City library validation: PASS
- SQLite fixture validation: PASS
- Production QA audit: 0 blockers, 0 majors
- `git diff --check`: PASS

## Render Proof

Simulator build/run succeeded on `SpeakLocal City Listings` with launch arg:

```sh
--detail-page viet-family-city-hcmc-place-man-moi
```

Screenshot:

`docs/editorial-exports/viet-city-pages/food-listings-production-2026-05-30/render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-030-screenshots/001-hcmc-man-moi-top.jpg`

The Simulator was left open on the revised Mặn Mòi listing for Jojo review.

## Phone Build

Physical iPhone build and install were run via the SpeakLocal device-build helper with `SPEAKLOCAL_REPO_ROOT` pointed at this worktree.

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the phone was locked
- Signing hygiene: repo project files stayed clean
