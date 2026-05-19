# Viet Canonical Content Audit 001

Task: `TASK-VIET-CANONICAL-CONTENT-AUDIT-001`
Generated: 2026-05-19T10:36:33.444Z

## Summary

- Canonical pages audited: 1758
- Source phrase rows: 1765
- Duplicate normalized canonical Vietnamese groups: 0
- Missing audio queue rows: 680
- Release-blocking missing audio rows: 0
- Missing audio rows with exact reusable assets: 0
- Missing audio rows with exact target usages: 0

## Verdict Counts

| Verdict | Pages |
| --- | ---: |
| FAIL | 500 |
| NEEDS_REVIEW | 7 |
| PASS | 1251 |

## Source Lane Counts

| Source lane | Pages |
| --- | ---: |
| catalog-promoted | 770 |
| child | 13 |
| city-v1 | 806 |
| editorial-model-support | 24 |
| tier1 | 145 |

## Top Issue Counts

| Issue | Pages |
| --- | ---: |
| missing_breakdown | 500 |
| missing_breakdown_tokens | 500 |
| three_text_only_sections | 181 |
| single_card_multiword_breakdown | 7 |

## Artifacts

- `per-page-audit.jsonl`: full page-level reasoning record.
- `per-page-audit.csv`: spreadsheet-friendly page audit.
- `issue-summary.json`: machine-readable rollup.
- `jojo-review-queue.csv`: pages needing Jojo/native/content judgment.
- `repair-ledger.md`: safe repairs made during this task.

## First 50 Non-Pass Pages

| # | Page ID | Vietnamese | English | Source | Verdict | Issues |
| ---: | --- | --- | --- | --- | --- | --- |
| 52 | `viet-phrase-city-danang-place-3d-art-in-paradise` | Bảo tàng 3D Art in Paradise Đà Nẵng | 3D Art in Paradise Da Nang | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 53 | `viet-phrase-city-danang-place-43-factory` | 43 Factory Coffee Roaster | 43 Factory Coffee Roaster | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 54 | `viet-phrase-city-danang-place-airport` | Sân bay Đà Nẵng | Da Nang Airport | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 55 | `viet-phrase-city-danang-place-an-thuong-street-area` | Khu An Thượng | An Thuong Area | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 56 | `viet-phrase-city-danang-place-apec-park` | Công viên APEC | APEC Park | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 57 | `viet-phrase-city-danang-place-asia-park` | Công viên Châu Á | Asia Park | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 58 | `viet-phrase-city-danang-place-ba-na-cable-car` | Cáp treo Bà Nà | Ba Na cable car | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 59 | `viet-phrase-city-danang-place-ba-na-hills` | Bà Nà Hills | Ba Na Hills | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 60 | `viet-phrase-city-danang-place-bac-my-an-market` | Chợ Bắc Mỹ An | Bac My An Market | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 61 | `viet-phrase-city-danang-place-bach-dang-street` | Đường Bạch Đằng | Bach Dang Street | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 62 | `viet-phrase-city-danang-place-ban-co-peak` | Đỉnh Bàn Cờ | Ban Co Peak | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 63 | `viet-phrase-city-danang-place-banh-mi` | Bánh mì ở Đà Nẵng | Banh mi | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 64 | `viet-phrase-city-danang-place-banh-trang-cuon-thit-heo` | Bánh tráng cuốn thịt heo ở Đà Nẵng | Pork rice-paper rolls | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 65 | `viet-phrase-city-danang-place-banh-xeo` | Bánh xèo ở Đà Nẵng | Banh xeo | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 66 | `viet-phrase-city-danang-place-banh-xeo-ba-duong` | Bánh xèo Bà Dưỡng | Banh Xeo Ba Duong | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 67 | `viet-phrase-city-danang-place-be-man` | Hải sản Bé Mặn | Be Man Seafood | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 68 | `viet-phrase-city-danang-place-bep-cuon` | Bếp Cuốn Đà Nẵng | Bep Cuon Da Nang | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 69 | `viet-phrase-city-danang-place-boulevard-gelato-coffee` | Boulevard Gelato & Coffee | Boulevard Gelato & Coffee | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 70 | `viet-phrase-city-danang-place-bun-cha-ca` | Bún chả cá ở Đà Nẵng | Fish-cake noodle soup | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 71 | `viet-phrase-city-danang-place-bun-cha-ca-hon` | Bún Chả Cá Hờn | Bun Cha Ca Hon | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 72 | `viet-phrase-city-danang-place-cathedral` | Nhà thờ Con Gà Đà Nẵng | Da Nang Cathedral | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 73 | `viet-phrase-city-danang-place-central-bus-station` | Bến xe Trung tâm Đà Nẵng | Da Nang Central Bus Station | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 74 | `viet-phrase-city-danang-place-cham-museum` | Bảo tàng Điêu khắc Chăm | Museum of Cham Sculpture | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 75 | `viet-phrase-city-danang-place-che-xoa-xoa-hat-luu` | Chè xoa xoa hạt lựu ở Đà Nẵng | Da Nang sweet soup | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 76 | `viet-phrase-city-danang-place-co-chu-nho` | Cô Chủ Nhỏ | Co Chu Nho | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 77 | `viet-phrase-city-danang-place-con-market` | Chợ Cồn | Con Market | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 78 | `viet-phrase-city-danang-place-cong-caphe-bach-dang` | Cộng Cà Phê Bạch Đằng | Cong Caphe Bach Dang | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 79 | `viet-phrase-city-danang-place-domestic-terminal` | Nhà ga quốc nội Đà Nẵng | Da Nang Domestic Terminal | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 80 | `viet-phrase-city-danang-place-dong-dinh-museum` | Bảo tàng Đồng Đình | Dong Dinh Museum | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 81 | `viet-phrase-city-danang-place-dragon-bridge` | Cầu Rồng | Dragon Bridge | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 82 | `viet-phrase-city-danang-place-dragon-bridge-fire-show` | Màn phun lửa Cầu Rồng | Dragon Bridge fire show | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 83 | `viet-phrase-city-danang-place-dragon-carp-statue` | Tượng Cá Chép Hóa Rồng | Dragon Carp Statue | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 84 | `viet-phrase-city-danang-place-fatfish` | Fatfish | Fatfish Restaurant & Lounge Bar | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 85 | `viet-phrase-city-danang-place-fine-arts-museum` | Bảo tàng Mỹ thuật Đà Nẵng | Da Nang Fine Arts Museum | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 86 | `viet-phrase-city-danang-place-golden-bridge` | Cầu Vàng | Golden Bridge | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 87 | `viet-phrase-city-danang-place-hai-chau-district` | Quận Hải Châu | Hai Chau District | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 88 | `viet-phrase-city-danang-place-hai-san` | Hải sản ở Đà Nẵng | Seafood | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 89 | `viet-phrase-city-danang-place-hai-van-pass` | Đèo Hải Vân | Hai Van Pass | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 90 | `viet-phrase-city-danang-place-hai-van-pass-ride` | Chuyến đi đèo Hải Vân | Hai Van Pass ride | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 91 | `viet-phrase-city-danang-place-han-market` | Chợ Hàn | Han Market | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 92 | `viet-phrase-city-danang-place-han-river` | Sông Hàn | Han River | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 93 | `viet-phrase-city-danang-place-han-river-cruise` | Du thuyền sông Hàn | Han River cruise | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 94 | `viet-phrase-city-danang-place-helio-night-market` | Chợ đêm Helio | Helio Night Market | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 95 | `viet-phrase-city-danang-place-hoa-phu-thanh` | Khu du lịch Hòa Phú Thành | Hoa Phu Thanh | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 96 | `viet-phrase-city-danang-place-hoa-trung-lake` | Hồ Hòa Trung | Hoa Trung Lake | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 97 | `viet-phrase-city-danang-place-international-terminal` | Nhà ga quốc tế Đà Nẵng | Da Nang International Terminal | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 98 | `viet-phrase-city-danang-place-kem-bo` | Kem bơ ở Đà Nẵng | Avocado ice cream | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
| 99 | `viet-phrase-city-danang-place-la-maison-1888` | La Maison 1888 | La Maison 1888 | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 100 | `viet-phrase-city-danang-place-lady-buddha` | Tượng Phật Bà | Lady Buddha | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens |
| 101 | `viet-phrase-city-danang-place-le-duan-night-market` | Chợ đêm Lê Duẩn | Le Duan Night Market | city-v1 | FAIL | missing_breakdown, missing_breakdown_tokens, three_text_only_sections |
