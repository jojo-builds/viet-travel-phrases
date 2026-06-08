# Duplicate Card Demotion Adjudication - 2026-06-08

Branch: `codex/city-copy-final-production-gate`

This addendum adjudicates the full-branch `render` -> `do_not_render` card status changes that remain when comparing this branch against current local `main`. These changes are from the earlier final copy gate, not from the clean-pass prefix normalization.

## Finding

- `12` cards changed from `render` to `do_not_render` versus `main`.
- All `12 / 12` are duplicate target appearances on the same page.
- In every case, the same `catalogId` still renders elsewhere on the same page, either as a Mentioned Here card or a Related card.
- No target disappears from the reader's visible card graph.
- The traveler value is preserved through the remaining rendered card subtitle; the demotion removes duplicate clutter rather than thinning useful coverage.

## Adjudication

Classification: `SAFE_FIX_NOW` already resolved in branch.

Production-copy impact: non-blocking. These demotions should not be treated as copy thinning because they do not remove a destination, phrase, dish, market, or place from the visible page experience. They collapse duplicate card appearances into one clearer rendered module.

## Evidence Table

| Page | Demoted card | Target | Still rendered as | Traveler value preserved |
|---|---|---|---|---|
| Chợ Cồn (`viet-family-city-danang-place-con-market`) | `mentionedHereCandidates`: Chợ Hàn | `viet-family-city-danang-place-han-market` | `relatedPlaceCandidates`: Chợ Hàn | The easier first market for bearings and gifts before a deeper food run. |
| Chợ Hàn (`viet-family-city-danang-place-han-market`) | `mentionedHereCandidates`: Chợ Cồn | `viet-family-city-danang-place-con-market` | `relatedPlaceCandidates`: Chợ Cồn | Da Nang's louder snack-market choice for stools, steam, and dessert cups. |
| Bia hơi Hà Nội (`viet-family-city-hanoi-place-bia-hoi`) | `mentionedHereCandidates`: Phố Tạ Hiện | `viet-family-city-hanoi-place-ta-hien` | `relatedPlaceCandidates`: Phố Tạ Hiện | The louder beer-street option when the group wants more night energy. |
| Phở Minh (`viet-family-city-hcmc-place-pho-minh`) | `mentionedHereCandidates`: Đường Pasteur | `viet-family-city-hcmc-place-pasteur-street` | `relatedPlaceCandidates`: Đường Pasteur | The street to recognize before looking for the smaller alley entrance. |
| Cao Lầu Thanh (`viet-family-city-hoian-place-cao-lau-thanh`) | `relatedPlaceCandidates`: Cao lầu ở Hội An | `viet-family-city-hoian-place-cao-lau-city` | `mentionedHereCandidates`: Cao lầu ở Hội An | The dish page for reading cao lầu before a named Hội An shop. |
| Cơm gà Hội An (`viet-family-city-hoian-place-com-ga`) | `relatedPlaceCandidates`: Cơm Gà Bà Buội | `viet-family-city-hoian-place-com-ga-ba-buoi` | `mentionedHereCandidates`: Cơm Gà Bà Buội | The named old-town chicken-rice shop for turning the dish into a real meal. |
| Cơm Gà Bà Buội (`viet-family-city-hoian-place-com-ga-ba-buoi`) | `relatedPlaceCandidates`: Cơm gà Hội An | `viet-family-city-hoian-place-com-ga` | `mentionedHereCandidates`: Cơm gà Hội An | The dish guide for yellow rice, shredded chicken, herbs, papaya, soup, and sauce. |
| Morning Glory Hội An (`viet-family-city-hoian-place-morning-glory`) | `relatedPlaceCandidates`: Giếng Bà Lễ | `viet-family-city-hoian-place-bale-well` | `mentionedHereCandidates`: Giếng Bà Lễ | The hands-on set-meal table after a broader central-coast dinner. |
| Bánh khoái ở Huế (`viet-family-city-hue-place-banh-khoai`) | `relatedPlaceCandidates`: Bánh bèo ở Huế | `viet-family-city-hue-place-banh-beo` | `mentionedHereCandidates`: Bánh bèo ở Huế | A softer Hue snack to compare with bánh khoái's crunch. |
| Bún bò Huế (`viet-family-city-hue-place-bun-bo-city`) | `relatedPlaceCandidates`: Bún bò chợ Đông Ba ở Huế | `viet-family-city-hue-place-dong-ba-bun-bo` | `mentionedHereCandidates`: Bún bò chợ Đông Ba ở Huế | A market-linked bowl when Dong Ba context matters. |
| Chợ Đông Ba (`viet-family-city-hue-place-dong-ba`) | `relatedPlaceCandidates`: Bún bò Huế | `viet-family-city-hue-place-bun-bo-city` | `mentionedHereCandidates`: Bún bò Huế | The city bowl to recognize before or after a central market lap. |
| Bún bò chợ Đông Ba ở Huế (`viet-family-city-hue-place-dong-ba-bun-bo`) | `relatedPlaceCandidates`: Chợ Đông Ba | `viet-family-city-hue-place-dong-ba` | `mentionedHereCandidates`: Chợ Đông Ba | The market setting that makes this bowl specific. |
