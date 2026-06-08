# Handwritten Recovery Batch 021

Date: 2026-06-03
Worktree: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready`
Branch: `feature/city-listings-production-ready`

## Pages Recovered

1. `viet-family-city-hcmc-place-bitexco-tower`
2. `viet-family-city-hcmc-place-bo-kho-ganh`
3. `viet-family-city-hcmc-place-bo-la-lot`
4. `viet-family-city-hcmc-place-bot-chien`
5. `viet-family-city-hcmc-place-bui-vien-street`

## Count

- Previous recovered count: 99 / 520
- Batch 021 recovered: 5
- Current recovered count: 104 / 520
- Remaining: 416

## Copy Recovery Notes

- Rewrote the batch from first-class V2.2 source in `content-draft/viet/city-library/app-detail-v2-2/hcmc.json`.
- Clarified Bitexco as the lotus-shaped District 1 skyline marker, useful for orienting downtown Saigon and pairing with Nguyễn Huệ / Bạch Đằng Wharf.
- Strengthened Bò Kho Gánh from generic named-place copy into a concrete beef-stew stop: bread for dipping, noodles or rice for a fuller bowl, and condiments at the table.
- Shortened generated-looking dish display names from city-taxonomy titles to readable dish names: `Bò lá lốt` and `Bột chiên`.
- Reworked Bùi Viện phrase cards to use mapped transport/drop-off phrases instead of event/entrance phrases that did not fit a street.
- Removed label-like or app-internal phrasing caught in review, including "one clear place name to remember," "ticket steps," "riverward movement," "small corrections," "night-snack path," and the meta line "The reason to remember this stop is..."

## QA Loop

- Read-only readability QA reviewed all five pages and classified all five as `REVISE`.
- Read-only save-worthiness / fact-risk QA classified Bitexco, bò lá lốt, bột chiên, and Bùi Viện as `PASS`; Bò Kho Gánh as `REVISE`.
- Integrated the concrete QA fixes, then performed a rendered simulator read. The simulator read caught one remaining meta sentence on Bò Kho Gánh, which was revised before final validation.

## Freshness Sources Checked

- Bitexco official site: https://bitexcofinancialtower.com/?page_id=468
- Michelin Guide, Bò Kho Gánh: https://guide.michelin.com/en/ho-chi-minh/ho-chi-minh_2978179/restaurant/bo-kho-ganh
- NGON Vietnam, Bò Lá Lốt: https://ngon-vietnam.com/bo-la-lot/
- Vietnam Tourism HCMC cuisine / street eats: https://image.vietnam.travel/things-to-do/ho-chi-minh-city-cuisine-street-eats-fine-dining

Visible copy avoids hours, prices, access guarantees, current ticket details, award-year claims, and universal vendor ingredient claims.

## Validation

Commands run:

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

Results:

- V2.2 strict validation: PASS, 520 entries, 520 pass / 0 revise / 0 fail.
- V2.2 voice audit: PASS, 0 failures after source fixes.
- City production copy validation: PASS, 520 city noun pages.
- City library validation: PASS, 826 pages.
- SQLite fixture validation: PASS, `ok: true`, 0 banned file matches.
- Listing production QA audit: PASS, 0 blockers, 0 majors.
- `git diff --check`: PASS.

## Render Proof

Simulator profile: `city-listings-production-ready`
Simulator: `SpeakLocal City Listings`
Rendered page: `viet-family-city-hcmc-place-bo-kho-ganh`

Screenshots:

- `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-021-screenshots/bo-kho-ganh-hero.jpg`
- `render-proof-2026-06-01-v2-2-global/handwritten-recovery-batch-021-screenshots/bo-kho-ganh-sections.jpg`

Simulator was left open on the repaired Bò Kho Gánh body sections for Jojo review.

## Phone Build

Command:

```sh
SPEAKLOCAL_REPO_ROOT=/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready /Users/jojolim/.codex/skills/speaklocal-ios-device-build/scripts/build_on_phone.sh
```

Result:

- Build: PASS
- Install: PASS
- Launch: blocked because the phone was locked. The app installed successfully; iOS denied launch until the device is unlocked.
- Repo signing hygiene: PASS. Project signing files stayed clean; no personal signing settings were written to tracked project files.

## Status

Batch 021 is recovered and projected into native runtime resources. The overall goal remains active: 104 / 520 pages recovered, 416 remaining.
