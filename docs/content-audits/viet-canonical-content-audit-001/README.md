# Viet Canonical Content Audit 001

Task: `TASK-VIET-CANONICAL-CONTENT-AUDIT-001`
Generated: 2026-05-01T05:24:55.983Z

## Summary

- Canonical pages audited: 3038
- Source phrase rows: 3046
- Duplicate normalized canonical Vietnamese groups: 0
- Missing audio queue rows: 2100
- Release-blocking missing audio rows: 0

## Verdict Counts

| Verdict | Pages |
| --- | ---: |
| NEEDS_AUTHORED_REPAIR | 1350 |
| NEEDS_REVIEW | 744 |
| PASS | 944 |

## Source Lane Counts

| Source lane | Pages |
| --- | ---: |
| catalog-built | 744 |
| child | 14 |
| city-v1 | 750 |
| full-universe | 35 |
| practice-expansion | 1350 |
| tier1 | 145 |

## Top Issue Counts

| Issue | Pages |
| --- | ---: |
| pattern_heavy_copy | 1350 |
| catalog_built_no_authored_source | 744 |
| weak_breakdown_label | 241 |

## Artifacts

- `per-page-audit.jsonl`: full page-level reasoning record.
- `per-page-audit.csv`: spreadsheet-friendly page audit.
- `issue-summary.json`: machine-readable rollup.
- `jojo-review-queue.csv`: pages needing Jojo/native/content judgment.
- `repair-ledger.md`: safe repairs made during this task.

## First 50 Non-Pass Pages

| # | Page ID | Vietnamese | English | Source | Verdict | Issues |
| ---: | --- | --- | --- | --- | --- | --- |
| 16 | `viet-phrase-airport-7` | Nhà ga nội địa ở đâu? | Where is the domestic terminal? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 23 | `viet-phrase-bath-6` | Ở đây có chỗ tắm không? | Is there a shower here? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 789 | `viet-phrase-directions-8` | Điểm đón ở đâu? | Where is the pickup point? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 790 | `viet-phrase-directions-9` | Lối ra nào? | Which exit? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 796 | `viet-phrase-emergency-6` | Túi của tôi bị lấy mất | My bag was stolen | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 797 | `viet-phrase-emergency-7` | Tôi cần đại sứ quán | I need the embassy | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 800 | `viet-phrase-emergency-premium-passport-report` | Tôi cần một báo cáo về hộ chiếu bị mất của tôi. | I need a report for my lost passport. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 801 | `viet-phrase-emergency-premium-phone-stolen` | Điện thoại của tôi đã bị đánh cắp. | My phone was stolen. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 802 | `viet-phrase-emergency-premium-police-station` | Làm ơn đưa tôi đến đồn cảnh sát. | Please take me to the police station. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 803 | `viet-phrase-emergency-premium-take-me-safe` | Làm ơn đưa tôi đến nơi nào đó an toàn. | Please take me somewhere safe. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 804 | `viet-phrase-emergency-premium-tourist-police` | Tôi cần cảnh sát du lịch. | I need the tourist police. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 805 | `viet-phrase-emergency-premium-wallet-stolen` | Ví của tôi đã bị đánh cắp. | My wallet was stolen. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 808 | `viet-phrase-food-16` | Đây không phải món tôi gọi | This isn’t what I ordered | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 809 | `viet-phrase-food-17` | Trả riêng được không? | Can we pay separately? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 820 | `viet-phrase-food-premium-has-meat-in-it` | Cái này có thịt trong đó. | This has meat in it. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 821 | `viet-phrase-food-premium-has-peanuts` | Cái này có đậu phộng không? | Does this have peanuts? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 822 | `viet-phrase-food-premium-no-meat` | Làm ơn đừng có thịt. | No meat, please. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 823 | `viet-phrase-food-premium-too-spicy-now` | Món này quá cay đối với tôi. | This is too spicy for me. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 824 | `viet-phrase-food-premium-which-dish-safe` | Món ăn nào an toàn nhất cho người bị dị ứng này? | Which dish is safest for this allergy? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 825 | `viet-phrase-food-premium-without-this-ingredient` | Bạn có thể làm nó mà không cần thành phần này? | Can you make it without this ingredient? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 850 | `viet-phrase-help-4` | Tôi bị tính tiền hai lần | I was charged twice | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 851 | `viet-phrase-help-5` | Tôi cần làm biên bản | I need to file a report | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 853 | `viet-phrase-help-premium-call-this-number` | Bạn có thể gọi số này hộ tôi được không? | Can you call this number for me? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 854 | `viet-phrase-help-premium-come-with-me` | Bạn có thể đi cùng tôi được không? | Can you come with me? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 855 | `viet-phrase-help-premium-contact-embassy` | Bạn có thể giúp tôi liên hệ với đại sứ quán được không? | Can you help me contact the embassy? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 856 | `viet-phrase-help-premium-print-document` | Tôi cần một bản in của tài liệu này. | I need a printed copy of this document. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 857 | `viet-phrase-help-premium-translate-for-me` | Bạn có thể dịch giúp tôi được không? | Can you help translate for me? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 865 | `viet-phrase-hotel-8` | Thẻ phòng không mở được | The key card doesn’t work | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 866 | `viet-phrase-hotel-9` | Gọi taxi giúp tôi được không? | Can you call a taxi for me? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 870 | `viet-phrase-hotel-premium-booking-wrong` | Tôi nghĩ có vấn đề với việc đặt phòng của tôi. | I think there is a problem with my booking. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 871 | `viet-phrase-hotel-premium-different-room` | Tôi đã đặt một phòng khác. | I booked a different room. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 872 | `viet-phrase-hotel-premium-late-checkout` | Tôi có thể trả phòng sau được không? | Can I check out later? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 873 | `viet-phrase-hotel-premium-no-hot-water` | Ở đây không có nước nóng. | There is no hot water. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 874 | `viet-phrase-hotel-premium-room-not-ready` | Căn phòng vẫn chưa sẵn sàng. | The room is not ready yet. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 875 | `viet-phrase-hotel-premium-too-noisy` | Căn phòng quá ồn ào. | The room is too noisy. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 876 | `viet-phrase-hotel-quiet-room` | Cho tôi phòng yên tĩnh được không? | Can I have a quiet room? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 881 | `viet-phrase-money-premium-price-changed` | Sao bây giờ giá lại khác thế? | Why is the price different now? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 882 | `viet-phrase-money-premium-service-included` | Dịch vụ đã được bao gồm chưa? | Is service already included? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 883 | `viet-phrase-money-premium-split-payment` | Chúng ta có thể chia tiền thanh toán được không? | Can we split the payment? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 884 | `viet-phrase-money-premium-total-wrong` | Tổng số này là sai. | This total is wrong. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 885 | `viet-phrase-money-premium-what-fee` | Khoản phí này dùng để làm gì? | What is this fee for? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 886 | `viet-phrase-money-premium-write-total` | Hãy viết tổng số ra. | Please write the total down. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 892 | `viet-phrase-phone-6` | Tôi cần nạp thêm dữ liệu | I need a data top-up | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 893 | `viet-phrase-phone-7` | eSIM của tôi không hoạt động | My eSIM is not working | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 894 | `viet-phrase-phone-premium-activate-sim` | Bạn có thể giúp tôi kích hoạt SIM được không? | Can you help me activate the SIM? | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 895 | `viet-phrase-phone-premium-data-not-working` | Dữ liệu của tôi không hoạt động. | My data is not working. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 896 | `viet-phrase-phone-premium-login-page-not-loading` | Trang đăng nhập Wi-Fi không tải. | The Wi-Fi login page is not loading. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 897 | `viet-phrase-phone-premium-no-signal` | Không có tín hiệu ở đây. | There is no signal here. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 898 | `viet-phrase-phone-premium-otp-not-arriving` | Mã xác minh không đến. | The verification code is not arriving. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
| 899 | `viet-phrase-phone-premium-password-not-working` | Mật khẩu Wi-Fi không hoạt động. | The Wi-Fi password is not working. | catalog-built | NEEDS_REVIEW | catalog_built_no_authored_source |
