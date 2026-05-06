# TASK-VIET-LISTING-HUB-RANDOM-LOOP-001

## Summary

Ran another simulator-backed QA loop focused on city, country, topic hubs, and fresh diverse listing pages that had not been part of the earlier fixed probe set.

The loop did not stop at green validators. It found and fixed systemic issues in generator routing, breakdown glosses, duplicate section headings, street-page row leakage, and the Food topic hub's starter rows. The final simulator proof covered 21 rendered pages and passed with 0 UI test failures.

Starting commit: `b6be531f6ec1988b49e0687c5b0f3a030f32bb7a`

## Root-Cause Fixes

- Added tone/diacritic-sensitive breakdown coverage for `chỉ`, `chị`, `nhận`, `mặt`, `cổng`, `đổi`, and `đợi`.
- Added may-hear lane routing for cash-only and gate-changed pages so they stay in payment and airport/gate contexts.
- Preserved exact table-availability routing before generic may-hear lanes, so `Bàn này còn trống` keeps seating/table next phrases.
- Merged duplicate visible section titles after section normalization so pages cannot render two `Next phrases` blocks.
- Reordered simple phrase sections so `Good to know` does not create duplicate follow-up shelves after nearby/explore rows.
- Filtered street page driver/confirm sections to rows that match the current street name.
- Rewrote the visible breakdown gloss `street name to keep together` to `name to keep together`.
- Updated the Food topic hub preferred starter rows to traveler actions: table, menu, water/payment flow, instead of a may-hear staff reply.
- Added audit checks for duplicate rendered section headings, cash-only row leakage, and gate-changed row leakage.
- Added a focused simulator proof UI test for hub pages plus a fresh diverse listing set.

The SpeakLocal listing-page skill was also updated outside the repo with these guardrails:

- no duplicate visible section headings;
- no source labels like `street name to keep together` in rendered breakdowns;
- topic hubs should start with traveler-action rows, not may-hear replies.

## Final Simulator Proof

Command:

```bash
SPEAKLOCAL_LISTING_HUB_RANDOM_LOOP_PROOF_DIR=/Users/jojolim/Developer/products/speaklocal/app-family/native-ios/artifacts/TASK-VIET-LISTING-HUB-RANDOM-LOOP-001 \
xcodebuild test \
  -project native-ios/SpeakLocalNative.xcodeproj \
  -scheme SpeakLocalNative \
  -destination 'id=91BDCCB0-0728-40AB-8150-B6DCB96BE799' \
  -only-testing:SpeakLocalNativeUITests/ListingHubRandomLoopProofUITests
```

Result: passed, 2 tests, 0 failures, 209.828 seconds.

Screenshot folder:

`native-ios/artifacts/TASK-VIET-LISTING-HUB-RANDOM-LOOP-001/`

Screenshots captured: 42.

## Pages Tested

Hub pages:

- All Vietnam
- Hanoi
- Saigon
- Hoi An
- Hue
- Airport
- Hotel
- Food
- Getting Around
- Local Greetings

Fresh diverse listing pages:

- `Xin lỗi`
- `Chỉ nhận tiền mặt`
- `Cổng đổi rồi`
- `Có ATM gần Nhà thờ Con Gà Đà Nẵng không?`
- `Đường Võ Nguyên Giáp`
- `Phố Hàng Bạc`
- `Cầu Vàng`
- `Phở Hòa Pasteur`
- `Bánh mì Phượng`
- `Cho tôi tới đây`
- `Tiền xe bao nhiêu?`

## Five Clean In A Row

The final proof includes at least five hub pages in a row with correct copy/order and no random phrase-feed behavior:

1. All Vietnam: `Start here`, `City guides`, `Practice Vietnam basics`
2. Hanoi: `What are you doing?`, `Practice a Hanoi day`, `Names to know`, `Quick phrases`
3. Saigon: `What are you doing?`, `Practice a Saigon day`, `Names to know`, `Quick phrases`
4. Hoi An: `What are you doing?`, `Practice a Hoi An day`, `Names to know`, `Quick phrases`
5. Hue: `What are you doing?`, `Practice a Hue day`, `Names to know`, `Quick phrases`

The diverse listing proof also starts with five clean pages:

1. `Xin lỗi`: `Meaning > Break it down > Common follow-ups > Good to know > Next phrases`
2. `Chỉ nhận tiền mặt`: `You may hear > Break it down > Related replies > Good to know > Related phrases`
3. `Cổng đổi rồi`: `You may hear > Break it down > Related replies > Good to know`
4. `Có ATM gần Nhà thờ Con Gà Đà Nẵng không?`: `Break it down > Related phrases > Tip`
5. `Đường Võ Nguyên Giáp`: street page structure with street-specific driver/confirm rows and no unrelated street leakage

## Validation

Passed:

```bash
node native-ios/scripts/audit-viet-listing-production-qa.js --check
node native-ios/scripts/validate-viet-listing-intent-routing.js
node native-ios/scripts/validate-viet-sqlite-fixture.js
node native-ios/scripts/audit-viet-canonical-content.js --check
node native-ios/scripts/audit-viet-page-quality.js
node native-ios/scripts/validate-tier-one-listing-pages.js
node scripts/practice/generate-viet-practice-deck.js --check
node --test native-ios/scripts/generate-viet-sqlite-fixture.test.js
node --test scripts/practice/generate-viet-practice-deck.test.js
git diff --check
```

Additional scan passed:

```bash
rg "street name to keep together|Practice nearby|Nearby needs" \
  native-ios/Resources/viet-authored-listing-pages.json \
  docs/content-audits/viet-listing-production-qa-001/representative-rendered-excerpts.md
```

No matches.

## Notes

- Missing assigned audio count remains `2126`; this task did not generate audio.
- Production QA still reports `500` missing-audio priority rows; this remains a content-production queue, not a regression from this loop.
- I did not normalize display text like `Đi Đường Võ Nguyên Giáp` to lowercase `đường` because that increased missing-audio matching regressions. That should be handled in a dedicated display-vs-audio canonicalization task.
- The bottom chrome still visibly overlays low page content in some screenshots. That is a separate UI chrome follow-up, not solved by this copy/order loop.
