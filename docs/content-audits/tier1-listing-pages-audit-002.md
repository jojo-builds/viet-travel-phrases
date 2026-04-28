# Tier 1 Listing Pages Audit 002

Date: 2026-04-29

Status: completion audit after the broad Tier 1 enrichment pass. This supersedes `tier1-listing-pages-audit-001.md` as the current quality classification record.

## Summary

- Tier 1 family pages audited: 150.
- Final classification counts: strong 150, thin 0, awkward 0, placeholder-like 0, over-templated 0, negative/frictional 0, missing useful child links 0.
- Generated resource pages checked: 163.
- Generated child variant pages checked: 15.
- Banned wording check passed for `Watch out`, `repair phrase`, `Understanding Repair`, `question marker`, `warning-callout`, and `watch-out`.
- Canonical page IDs were preserved; no duplicate Tier 1 Vietnamese page titles were introduced.
- No audio was generated; the authored audio audit still resolves all assigned visible audio.

## What Changed In This Completion Pass

- The authored-page generator now builds every Tier 1 page around intent-pattern teaching: what the traveler is trying to do, why the phrase works, what answer to expect, and what to do next.
- Every generated Tier 1 page now includes `Why it matters` and `Traveler insight` sections, not only the previously deep pages.
- Generic language such as `version to learn first`, `After the first answer`, and `one clear sentence will work better` was removed from generated content.
- Question-style breakdowns now use traveler-facing wording such as `asks for a yes-or-no answer` instead of internal grammar labels.
- The previously thin discount, local SIM, and tour-booking pages received fuller phrase-specific teaching through generator override copy.
- `social-how-are-you` keeps relationship forms as audio-backed examples, but they are not Explore/nearby navigation rows and therefore do not create duplicate phrase pages.

## Validation Command

`node native-ios/scripts/validate-tier-one-listing-pages.js` now produces:

```json
{
  "tierOneFamilyCount": 150,
  "auditedPageCount": 150,
  "classificationCounts": {
    "strong": 150,
    "thin": 0,
    "awkward": 0,
    "placeholderLike": 0,
    "overTemplated": 0,
    "negativeFrictional": 0,
    "missingUsefulChildLinks": 0,
    "needsWork": 0
  },
  "resourcePageCount": 163,
  "childPageCount": 15,
  "resourceBannedMatches": [],
  "duplicateTierOneVietnameseTitles": [],
  "failingRows": []
}
```

## All 150 Tier 1 Pages

| # | Scenario | Family ID | Page ID | Phrase | Coverage | Final classification | Source |
| --- | --- | --- | --- | --- | --- | --- | --- |
| 1 | polite-basics | `polite-hello` | `viet-polite-hello` | Xin chào | root | strong | `native-ios/App/** root page, not modified in this pass` |
| 2 | polite-basics | `polite-thank-you` | `viet-thank-you` | Cảm ơn | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/polite-thank-you.json` |
| 3 | polite-basics | `polite-acknowledge` | `viet-family-polite-acknowledge` | Dạ | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/polite-acknowledge.json` |
| 4 | polite-basics | `polite-no-thanks` | `viet-family-polite-no-thanks` | Không, cảm ơn | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/polite-no-thanks.json` |
| 5 | polite-basics | `polite-excuse-me` | `viet-excuse-sorry` | Xin lỗi | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/polite-excuse-me.json` |
| 6 | polite-basics | `polite-its-okay` | `viet-family-polite-its-okay` | Không sao đâu | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/polite-its-okay.json` |
| 7 | polite-basics | `polite-goodbye` | `viet-goodbye` | Tạm biệt | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/polite-goodbye.json` |
| 8 | understanding-repair | `repair-understand` | `viet-family-repair-understand` | Tôi không hiểu | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/repair-understand.json` |
| 9 | understanding-repair | `repair-slower` | `viet-family-repair-slower` | Nói chậm chút được không? | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/repair-slower.json` |
| 10 | understanding-repair | `repair-repeat` | `viet-family-repair-repeat` | Làm ơn nói lại | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/repair-repeat.json` |
| 11 | understanding-repair | `repair-write-down` | `viet-family-repair-write-down` | Viết xuống giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/repair-write-down.json` |
| 12 | understanding-repair | `repair-meaning` | `viet-family-repair-meaning` | Cái đó nghĩa là gì? | manual-swift | strong | `content-draft/viet/listing-pages/understanding-repair/repair-meaning.json` |
| 13 | understanding-repair | `repair-number` | `viet-family-repair-number` | Làm ơn nói lại số đó | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/repair-number.json` |
| 14 | understanding-repair | `repair-english-help` | `viet-family-repair-english-help` | Anh/chị nói tiếng Anh không? | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/repair-english-help.json` |
| 15 | transport | `transport-destination` | `viet-family-transport-destination` | Cho tôi tới đây | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-destination.json` |
| 16 | transport | `transport-main-destination` | `viet-family-transport-main-destination` | Đi quận 1 | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-main-destination.json` |
| 17 | transport | `transport-stop-here` | `viet-family-transport-stop-here` | Dừng ở đây được rồi | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-stop-here.json` |
| 18 | transport | `transport-route` | `viet-family-transport-route` | Đi đường này đi | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-route.json` |
| 19 | transport | `transport-aircon` | `viet-family-transport-aircon` | Mở máy lạnh giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-aircon.json` |
| 20 | transport | `transport-wait` | `viet-family-transport-wait` | Chờ tôi năm phút | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-wait.json` |
| 21 | transport | `transport-cash` | `viet-family-transport-cash` | Tôi trả bằng tiền mặt | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-cash.json` |
| 22 | transport | `transport-fare` | `viet-family-transport-fare` | Tiền xe bao nhiêu? | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-fare.json` |
| 23 | transport | `transport-meter` | `viet-family-transport-meter` | Làm ơn bật đồng hồ giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-meter.json` |
| 24 | transport | `transport-lost` | `viet-family-transport-lost` | Tôi nghĩ chúng ta bị lạc rồi | authored-resource | strong | `content-draft/viet/listing-pages/transport/transport-lost.json` |
| 25 | hotel-accommodation | `hotel-reservation` | `viet-family-hotel-reservation` | Tôi có đặt phòng | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-reservation.json` |
| 26 | hotel-accommodation | `hotel-check-in` | `viet-family-hotel-check-in` | Cho tôi nhận phòng | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-check-in.json` |
| 27 | hotel-accommodation | `hotel-checkout-time` | `viet-family-hotel-checkout-time` | Mấy giờ trả phòng? | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-checkout-time.json` |
| 28 | hotel-accommodation | `hotel-checkout` | `viet-family-hotel-checkout` | Cho tôi trả phòng | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-checkout.json` |
| 29 | hotel-accommodation | `hotel-room-hot` | `viet-family-hotel-room-hot` | Phòng này nóng quá | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-room-hot.json` |
| 30 | hotel-accommodation | `hotel-aircon-broken` | `viet-family-hotel-aircon-broken` | Máy lạnh không chạy | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-aircon-broken.json` |
| 31 | hotel-accommodation | `hotel-more-supplies` | `viet-family-hotel-more-supplies` | Cho tôi thêm khăn | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-more-supplies.json` |
| 32 | hotel-accommodation | `hotel-luggage` | `viet-family-hotel-luggage` | Giữ hành lý giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/hotel-luggage.json` |
| 33 | food-drink | `food-coffee-milk` | `viet-family-food-coffee-milk` | Cho tôi một cà phê sữa đá | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-coffee-milk.json` |
| 34 | food-drink | `food-coffee-black` | `viet-family-food-coffee-black` | Cho tôi cà phê đen đá | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-coffee-black.json` |
| 35 | food-drink | `food-coffee-bac-xiu` | `viet-family-food-coffee-bac-xiu` | Cho tôi bạc xỉu đá | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-coffee-bac-xiu.json` |
| 36 | food-drink | `food-less-ice` | `viet-family-food-less-ice` | Ít đá thôi | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-less-ice.json` |
| 37 | food-drink | `food-no-sugar` | `viet-family-food-no-sugar` | Không đường nhé | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-no-sugar.json` |
| 38 | food-drink | `food-to-go` | `viet-family-food-to-go` | Mang đi | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-to-go.json` |
| 39 | food-drink | `food-pay-now` | `viet-family-food-pay-now` | Tính tiền giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-pay-now.json` |
| 40 | food-drink | `food-need-table` | `viet-family-food-need-table` | Cho tôi bàn cho hai người nhé | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-need-table.json` |
| 41 | food-drink | `food-menu` | `viet-family-food-menu` | Cho tôi xem thực đơn được không? | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-menu.json` |
| 42 | food-drink | `food-one-portion` | `viet-family-food-one-portion` | Cho tôi một phần | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-one-portion.json` |
| 43 | food-drink | `food-this-bowl` | `viet-family-food-this-bowl` | Cho tôi tô này | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-this-bowl.json` |
| 44 | food-drink | `food-not-spicy` | `viet-family-food-not-spicy` | Không cay nhé | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-not-spicy.json` |
| 45 | food-drink | `food-more-herbs` | `viet-family-food-more-herbs` | Cho thêm rau | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-more-herbs.json` |
| 46 | food-drink | `food-bottled-water` | `viet-family-food-bottled-water` | Có nước suối không? | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-bottled-water.json` |
| 47 | food-drink | `food-utensils` | `viet-family-food-utensils` | Cho tôi muỗng với đũa | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-utensils.json` |
| 48 | food-drink | `food-pack-to-go` | `viet-family-food-pack-to-go` | Gói mang về | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-pack-to-go.json` |
| 49 | food-drink | `food-vegetarian` | `viet-family-food-vegetarian` | Tôi ăn chay | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-vegetarian.json` |
| 50 | food-drink | `food-peanut-allergy` | `viet-family-food-peanut-allergy` | Tôi bị dị ứng đậu phộng | authored-resource | strong | `content-draft/viet/listing-pages/food-drink/food-peanut-allergy.json` |
| 51 | money-numbers-prices | `money-how-much` | `viet-family-money-how-much` | Cái này bao nhiêu? | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-how-much.json` |
| 52 | money-numbers-prices | `money-per-kilo` | `viet-family-money-per-kilo` | Bao nhiêu một ký? | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-per-kilo.json` |
| 53 | money-numbers-prices | `money-too-expensive` | `viet-family-money-too-expensive` | Mắc quá | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-too-expensive.json` |
| 54 | money-numbers-prices | `money-lower-price` | `viet-family-money-lower-price` | Bớt chút được không? | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-lower-price.json` |
| 55 | money-numbers-prices | `money-final-price` | `viet-family-money-final-price` | Giá cuối bao nhiêu? | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-final-price.json` |
| 56 | money-numbers-prices | `money-another-one` | `viet-family-money-another-one` | Cho tôi xem cái khác | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-another-one.json` |
| 57 | money-numbers-prices | `money-take-this` | `viet-family-money-take-this` | Tôi lấy cái này | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-take-this.json` |
| 58 | money-numbers-prices | `money-find-atm` | `viet-family-money-find-atm` | ATM gần nhất ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/money-find-atm.json` |
| 59 | directions-navigation | `directions-how-to-get` | `viet-family-directions-how-to-get` | Cho hỏi, đi tới đó thế nào? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-how-to-get.json` |
| 60 | directions-navigation | `directions-near` | `viet-family-directions-near` | Ở gần đây không? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-near.json` |
| 61 | directions-navigation | `directions-how-long` | `viet-family-directions-how-long` | Đi bộ mất bao lâu? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-how-long.json` |
| 62 | directions-navigation | `directions-turn-left` | `viet-family-directions-turn-left` | Rẽ trái ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-turn-left.json` |
| 63 | directions-navigation | `directions-turn-right` | `viet-family-directions-turn-right` | Tôi rẽ phải đúng không? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-turn-right.json` |
| 64 | directions-navigation | `directions-go-straight` | `viet-family-directions-go-straight` | Tôi đi thẳng phải không? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-go-straight.json` |
| 65 | directions-navigation | `directions-understand-now` | `viet-family-directions-understand-now` | Cảm ơn, tôi hiểu rồi | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/directions-understand-now.json` |
| 66 | airport-border-arrival | `airport-immigration` | `viet-family-airport-immigration` | Nhập cảnh ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/airport-immigration.json` |
| 67 | airport-border-arrival | `airport-baggage` | `viet-family-airport-baggage` | Lấy hành lý ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/airport-baggage.json` |
| 68 | airport-border-arrival | `airport-sim` | `viet-family-airport-sim` | Mua SIM ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/airport-sim.json` |
| 69 | airport-border-arrival | `airport-pickup` | `viet-family-airport-pickup` | Khu đón ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/airport-pickup.json` |
| 70 | airport-border-arrival | `airport-bag-missing` | `viet-family-airport-bag-missing` | Hành lý của tôi chưa tới | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/airport-bag-missing.json` |
| 71 | health-pharmacy | `health-doctor` | `viet-family-health-doctor` | Tôi cần bác sĩ | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-doctor.json` |
| 72 | health-pharmacy | `health-pharmacy` | `viet-family-health-pharmacy` | Nhà thuốc gần nhất ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-pharmacy.json` |
| 73 | health-pharmacy | `health-headache` | `viet-family-health-headache` | Tôi bị đau đầu | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-headache.json` |
| 74 | health-pharmacy | `health-stomach` | `viet-family-health-stomach` | Tôi đau bụng | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-stomach.json` |
| 75 | health-pharmacy | `health-motion-sickness` | `viet-family-health-motion-sickness` | Có thuốc say xe không? | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-motion-sickness.json` |
| 76 | health-pharmacy | `health-allergy` | `viet-family-health-allergy` | Tôi bị dị ứng cái này | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-allergy.json` |
| 77 | health-pharmacy | `health-diarrhea` | `viet-family-health-diarrhea` | Tôi cần thuốc tiêu chảy | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/health-diarrhea.json` |
| 78 | problems-help | `help-lost` | `viet-family-help-lost` | Tôi bị lạc đường | authored-resource | strong | `content-draft/viet/listing-pages/problems-help/help-lost.json` |
| 79 | problems-help | `help-left-something` | `viet-family-help-left-something` | Tôi quên đồ rồi | authored-resource | strong | `content-draft/viet/listing-pages/problems-help/help-left-something.json` |
| 80 | problems-help | `help-need-help` | `viet-family-help-need-help` | Giúp tôi với | authored-resource | strong | `content-draft/viet/listing-pages/problems-help/help-need-help.json` |
| 81 | problems-help | `help-call-hotel` | `viet-family-help-call-hotel` | Gọi khách sạn giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/problems-help/help-call-hotel.json` |
| 82 | problems-help | `help-manager` | `viet-family-help-manager` | Tôi cần quản lý | authored-resource | strong | `content-draft/viet/listing-pages/problems-help/help-manager.json` |
| 83 | time-dates-booking | `time-what-time` | `viet-family-time-what-time` | Mấy giờ? | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/time-what-time.json` |
| 84 | time-dates-booking | `time-today` | `viet-family-time-today` | Hôm nay | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/time-today.json` |
| 85 | time-dates-booking | `time-tomorrow-morning` | `viet-family-time-tomorrow-morning` | Sáng mai | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/time-tomorrow-morning.json` |
| 86 | time-dates-booking | `time-have-booking` | `viet-family-time-have-booking` | Tôi có đặt chỗ | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/time-have-booking.json` |
| 87 | time-dates-booking | `time-open` | `viet-family-time-open` | Mấy giờ mở cửa? | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/time-open.json` |
| 88 | shopping | `shopping-size` | `viet-family-shopping-size` | Tôi muốn cỡ này | authored-resource | strong | `content-draft/viet/listing-pages/shopping/shopping-size.json` |
| 89 | shopping | `shopping-color` | `viet-family-shopping-color` | Có màu khác không? | authored-resource | strong | `content-draft/viet/listing-pages/shopping/shopping-color.json` |
| 90 | shopping | `shopping-try-on` | `viet-family-shopping-try-on` | Tôi thử cái này được không? | authored-resource | strong | `content-draft/viet/listing-pages/shopping/shopping-try-on.json` |
| 91 | shopping | `shopping-just-looking` | `viet-family-shopping-just-looking` | Tôi chỉ xem thôi | authored-resource | strong | `content-draft/viet/listing-pages/shopping/shopping-just-looking.json` |
| 92 | shopping | `shopping-pay-where` | `viet-family-shopping-pay-where` | Trả ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/shopping/shopping-pay-where.json` |
| 93 | phone-internet-power | `phone-wifi-password` | `viet-family-phone-wifi-password` | Mật khẩu Wi-Fi là gì? | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/phone-wifi-password.json` |
| 94 | phone-internet-power | `phone-sim` | `viet-family-phone-sim` | Có bán SIM không? | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/phone-sim.json` |
| 95 | phone-internet-power | `phone-battery-dead` | `viet-family-phone-battery-dead` | Điện thoại tôi hết pin rồi | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/phone-battery-dead.json` |
| 96 | phone-internet-power | `phone-charger` | `viet-family-phone-charger` | Có sạc không? | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/phone-charger.json` |
| 97 | phone-internet-power | `phone-charge-here` | `viet-family-phone-charge-here` | Tôi sạc điện thoại ở đây được không? | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/phone-charge-here.json` |
| 98 | bathroom-personal-needs | `bathroom-where` | `viet-family-bathroom-where` | Nhà vệ sinh ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/bathroom-personal-needs/bathroom-where.json` |
| 99 | bathroom-personal-needs | `bathroom-paper` | `viet-family-bathroom-paper` | Có giấy vệ sinh không? | authored-resource | strong | `content-draft/viet/listing-pages/bathroom-personal-needs/bathroom-paper.json` |
| 100 | bathroom-personal-needs | `bathroom-use` | `viet-family-bathroom-use` | Tôi dùng nhà vệ sinh được không? | authored-resource | strong | `content-draft/viet/listing-pages/bathroom-personal-needs/bathroom-use.json` |
| 101 | bathroom-personal-needs | `bathroom-soap` | `viet-family-bathroom-soap` | Có xà phòng không? | authored-resource | strong | `content-draft/viet/listing-pages/bathroom-personal-needs/bathroom-soap.json` |
| 102 | bathroom-personal-needs | `bathroom-wash-hands` | `viet-family-bathroom-wash-hands` | Tôi rửa tay ở đây được không? | authored-resource | strong | `content-draft/viet/listing-pages/bathroom-personal-needs/bathroom-wash-hands.json` |
| 103 | bathroom-personal-needs | `bathroom-water` | `viet-family-bathroom-water` | Tôi cần nước | authored-resource | strong | `content-draft/viet/listing-pages/bathroom-personal-needs/bathroom-water.json` |
| 104 | emergency-safety | `emergency-police` | `viet-family-emergency-police` | Gọi công an | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/emergency-police.json` |
| 105 | emergency-safety | `emergency-ambulance` | `viet-family-emergency-ambulance` | Gọi xe cứu thương | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/emergency-ambulance.json` |
| 106 | emergency-safety | `emergency-passport` | `viet-family-emergency-passport` | Tôi mất hộ chiếu | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/emergency-passport.json` |
| 107 | emergency-safety | `emergency-not-safe` | `viet-family-emergency-not-safe` | Tôi cảm thấy không an toàn | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/emergency-not-safe.json` |
| 108 | emergency-safety | `emergency-emergency` | `viet-family-emergency-emergency` | Đây là trường hợp khẩn cấp | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/emergency-emergency.json` |
| 109 | emergency-safety | `emergency-hospital` | `viet-family-emergency-hospital` | Bệnh viện gần nhất ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/emergency-hospital.json` |
| 110 | social-small-talk | `social-from-us` | `viet-family-social-from-us` | Tôi đến từ Mỹ | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-from-us.json` |
| 111 | social-small-talk | `social-from-uk` | `viet-family-social-from-uk` | Tôi từ Anh | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-from-uk.json` |
| 112 | social-small-talk | `social-first-time` | `viet-family-social-first-time` | Đây là lần đầu của tôi | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-first-time.json` |
| 113 | social-small-talk | `social-like-vietnam` | `viet-family-social-like-vietnam` | Tôi thích Việt Nam | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-like-vietnam.json` |
| 114 | social-small-talk | `social-food-good` | `viet-family-social-food-good` | Đồ ăn ngon quá | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-food-good.json` |
| 115 | social-small-talk | `social-weather-hot` | `viet-family-social-weather-hot` | Thời tiết nóng quá | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-weather-hot.json` |
| 116 | social-small-talk | `social-how-are-you` | `viet-how-are-you` | Bạn khỏe không? | authored-resource | strong | `content-draft/viet/listing-pages/social-small-talk/social-how-are-you.json` |
| 117 | sightseeing-activities | `sight-ticket` | `viet-family-sight-ticket` | Vé bao nhiêu? | authored-resource | strong | `content-draft/viet/listing-pages/sightseeing-activities/sight-ticket.json` |
| 118 | sightseeing-activities | `sight-start` | `viet-family-sight-start` | Bắt đầu ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/sightseeing-activities/sight-start.json` |
| 119 | sightseeing-activities | `sight-photos` | `viet-family-sight-photos` | Tôi chụp hình ở đây được không? | authored-resource | strong | `content-draft/viet/listing-pages/sightseeing-activities/sight-photos.json` |
| 120 | sightseeing-activities | `sight-close` | `viet-family-sight-close` | Mấy giờ đóng cửa? | authored-resource | strong | `content-draft/viet/listing-pages/sightseeing-activities/sight-close.json` |
| 121 | sightseeing-activities | `sight-meeting-point` | `viet-family-sight-meeting-point` | Điểm gặp ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/sightseeing-activities/sight-meeting-point.json` |
| 122 | local-services-everyday-tasks | `service-water` | `viet-family-service-water` | Cho tôi chai nước | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-water.json` |
| 123 | local-services-everyday-tasks | `service-bag` | `viet-family-service-bag` | Có túi không? | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-bag.json` |
| 124 | local-services-everyday-tasks | `service-tissues` | `viet-family-service-tissues` | Cho tôi khăn giấy | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-tissues.json` |
| 125 | local-services-everyday-tasks | `service-sunscreen` | `viet-family-service-sunscreen` | Ở đâu có kem chống nắng? | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-sunscreen.json` |
| 126 | local-services-everyday-tasks | `service-open-this` | `viet-family-service-open-this` | Mở cái này giúp tôi | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-open-this.json` |
| 127 | local-services-everyday-tasks | `service-card` | `viet-family-service-card` | Tôi quẹt thẻ được không? | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-card.json` |
| 128 | local-services-everyday-tasks | `service-receipt` | `viet-family-service-receipt` | Cho tôi hóa đơn | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/service-receipt.json` |
| 129 | polite-basics | `v500-poli-basi-yes` | `viet-family-v500-poli-basi-yes` | Đúng | authored-resource | strong | `content-draft/viet/listing-pages/polite-basics/v500-poli-basi-yes.json` |
| 130 | understanding-repair | `v500-unde-repa-please-say-it-slowly` | `viet-family-v500-unde-repa-please-say-it-slowly` | Hãy nói từ từ nhé | authored-resource | strong | `content-draft/viet/listing-pages/understanding-repair/v500-unde-repa-please-say-it-slowly.json` |
| 131 | hotel-accommodation | `v500-hote-acco-the-door-does-not-lock` | `viet-family-v500-hote-acco-the-door-does-not-lock` | Cửa không khóa | authored-resource | strong | `content-draft/viet/listing-pages/hotel-accommodation/v500-hote-acco-the-door-does-not-lock.json` |
| 132 | money-numbers-prices | `v500-mone-numb-pric-the-atm-kept-my-card` | `viet-family-v500-mone-numb-pric-the-atm-kept-my-card` | ATM đã giữ thẻ của tôi | authored-resource | strong | `content-draft/viet/listing-pages/money-numbers-prices/v500-mone-numb-pric-the-atm-kept-my-card.json` |
| 133 | directions-navigation | `v500-dire-navi-where-is-the-nearest-restroom` | `viet-family-v500-dire-navi-where-is-the-nearest-restroom` | Nhà vệ sinh gần nhất ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/directions-navigation/v500-dire-navi-where-is-the-nearest-restroom.json` |
| 134 | airport-border-arrival | `v500-airp-bord-arri-here-is-my-visa` | `viet-family-v500-airp-bord-arri-here-is-my-visa` | Đây là thị thực của tôi | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/v500-airp-bord-arri-here-is-my-visa.json` |
| 135 | airport-border-arrival | `v500-airp-bord-arri-where-is-the-atm` | `viet-family-v500-airp-bord-arri-where-is-the-atm` | ATM ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/v500-airp-bord-arri-where-is-the-atm.json` |
| 136 | airport-border-arrival | `v500-airp-bord-arri-here-is-my-passport` | `viet-family-v500-airp-bord-arri-here-is-my-passport` | Đây là hộ chiếu của tôi | authored-resource | strong | `content-draft/viet/listing-pages/airport-border-arrival/v500-airp-bord-arri-here-is-my-passport.json` |
| 137 | health-pharmacy | `v500-heal-phar-i-feel-dizzy` | `viet-family-v500-heal-phar-i-feel-dizzy` | Tôi cảm thấy chóng mặt | authored-resource | strong | `content-draft/viet/listing-pages/health-pharmacy/v500-heal-phar-i-feel-dizzy.json` |
| 138 | problems-help | `v500-prob-help-i-need-help-now` | `viet-family-v500-prob-help-i-need-help-now` | Tôi cần giúp đỡ bây giờ | authored-resource | strong | `content-draft/viet/listing-pages/problems-help/v500-prob-help-i-need-help-now.json` |
| 139 | time-dates-booking | `v500-time-date-book-is-there-a-wait` | `viet-family-v500-time-date-book-is-there-a-wait` | Có chờ đợi không? | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/v500-time-date-book-is-there-a-wait.json` |
| 140 | time-dates-booking | `v500-time-date-book-one-ticket-please` | `viet-family-v500-time-date-book-one-ticket-please` | Xin một vé | authored-resource | strong | `content-draft/viet/listing-pages/time-dates-booking/v500-time-date-book-one-ticket-please.json` |
| 141 | shopping | `v500-shop-how-much-is-this-item` | `viet-family-v500-shop-how-much-is-this-item` | Mặt hàng này giá bao nhiêu? | authored-resource | strong | `content-draft/viet/listing-pages/shopping/v500-shop-how-much-is-this-item.json` |
| 142 | shopping | `v500-shop-can-you-lower-the-price` | `viet-family-v500-shop-can-you-lower-the-price` | Giảm giá chút được không? | authored-resource | strong | `content-draft/viet/listing-pages/shopping/v500-shop-can-you-lower-the-price.json` |
| 143 | phone-internet-power | `v500-phon-inte-powe-my-map-is-not-working` | `viet-family-v500-phon-inte-powe-my-map-is-not-working` | Bản đồ của tôi không hoạt động | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/v500-phon-inte-powe-my-map-is-not-working.json` |
| 144 | phone-internet-power | `v500-phon-inte-powe-where-can-i-get-a-local-sim-card` | `viet-family-v500-phon-inte-powe-where-can-i-get-a-local-sim-card` | Tôi có thể mua SIM ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/v500-phon-inte-powe-where-can-i-get-a-local-sim-card.json` |
| 145 | phone-internet-power | `v500-phon-inte-powe-i-need-an-esim` | `viet-family-v500-phon-inte-powe-i-need-an-esim` | Tôi cần một eSIM | authored-resource | strong | `content-draft/viet/listing-pages/phone-internet-power/v500-phon-inte-powe-i-need-an-esim.json` |
| 146 | emergency-safety | `v500-emer-safe-i-am-injured` | `viet-family-v500-emer-safe-i-am-injured` | tôi bị thương | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/v500-emer-safe-i-am-injured.json` |
| 147 | emergency-safety | `v500-emer-safe-i-cannot-move` | `viet-family-v500-emer-safe-i-cannot-move` | Tôi không thể di chuyển | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/v500-emer-safe-i-cannot-move.json` |
| 148 | emergency-safety | `v500-emer-safe-do-not-touch-me` | `viet-family-v500-emer-safe-do-not-touch-me` | Đừng chạm vào tôi | authored-resource | strong | `content-draft/viet/listing-pages/emergency-safety/v500-emer-safe-do-not-touch-me.json` |
| 149 | sightseeing-activities | `v500-sigh-acti-i-have-a-tour-booking` | `viet-family-v500-sigh-acti-i-have-a-tour-booking` | Tôi có đặt tour | authored-resource | strong | `content-draft/viet/listing-pages/sightseeing-activities/v500-sigh-acti-i-have-a-tour-booking.json` |
| 150 | local-services-everyday-tasks | `v500-loca-serv-ever-task-where-can-i-buy-water` | `viet-family-v500-loca-serv-ever-task-where-can-i-buy-water` | Tôi có thể mua nước ở đâu? | authored-resource | strong | `content-draft/viet/listing-pages/local-services-everyday-tasks/v500-loca-serv-ever-task-where-can-i-buy-water.json` |

## Generated Child Variant Pages

These child pages remain support pages under Tier 1 families, not additional Tier 1 family pages. They were regenerated with the same positive framing and validated for banned wording/resource integrity.

| # | Parent family | Child page ID | Phrase | English | Source |
| --- | --- | --- | --- | --- | --- |
| 1 | `airport-pickup` | `viet-phrase-airport-pickup-clearer` | Tôi gặp tài xế ở đâu? | Where do I meet the driver? | `content-draft/viet/listing-pages/airport-border-arrival/airport-pickup--airport-pickup-clearer.json` |
| 2 | `emergency-emergency` | `viet-phrase-emergency-5` | Cứu tôi với! | Help! | `content-draft/viet/listing-pages/emergency-safety/emergency-emergency--emergency-5.json` |
| 3 | `food-not-spicy` | `viet-phrase-food-not-spicy-clearer` | Ít cay thôi | Less spicy, please | `content-draft/viet/listing-pages/food-drink/food-not-spicy--food-not-spicy-clearer.json` |
| 4 | `food-peanut-allergy` | `viet-phrase-food-15` | Món này có trứng hay đậu phộng không? | Does this have egg or peanuts? | `content-draft/viet/listing-pages/food-drink/food-peanut-allergy--food-15.json` |
| 5 | `health-pharmacy` | `viet-phrase-health-1` | Nhà thuốc ở đâu? | Where is the pharmacy? | `content-draft/viet/listing-pages/health-pharmacy/health-pharmacy--health-1.json` |
| 6 | `hotel-check-in` | `viet-phrase-hotel-check-in-polite` | Cho tôi nhận phòng nhé | I’d like to check in, please | `content-draft/viet/listing-pages/hotel-accommodation/hotel-check-in--hotel-check-in-polite.json` |
| 7 | `hotel-more-supplies` | `viet-phrase-hotel-more-supplies-paper` | Cho tôi thêm giấy vệ sinh được không? | Can I have more toilet paper? | `content-draft/viet/listing-pages/hotel-accommodation/hotel-more-supplies--hotel-more-supplies-paper.json` |
| 8 | `money-how-much` | `viet-phrase-money-how-much-common` | Cái này nhiêu tiền? | How much is this? | `content-draft/viet/listing-pages/money-numbers-prices/money-how-much--money-how-much-common.json` |
| 9 | `phone-wifi-password` | `viet-phrase-phone-wifi-common` | Pass Wi-Fi là gì? | What is the Wi-Fi password? | `content-draft/viet/listing-pages/phone-internet-power/phone-wifi-password--phone-wifi-common.json` |
| 10 | `polite-thank-you` | `viet-phrase-polite-thank-you-polite` | Cảm ơn nhiều | Thank you very much | `content-draft/viet/listing-pages/polite-basics/polite-thank-you--polite-thank-you-polite.json` |
| 11 | `help-need-help` | `viet-phrase-help-1` | Anh/chị giúp tôi với | Can you help me? | `content-draft/viet/listing-pages/problems-help/help-need-help--help-1.json` |
| 12 | `transport-stop-here` | `viet-phrase-transport-stop-here-clearer` | Cho tôi xuống ngay đây | Please stop right here | `content-draft/viet/listing-pages/transport/transport-stop-here--transport-stop-here-clearer.json` |
| 13 | `repair-english-help` | `viet-phrase-repair-english-help-self-limit` | Xin lỗi, tôi không nói tiếng Việt | Sorry, I don’t speak Vietnamese | `content-draft/viet/listing-pages/understanding-repair/repair-english-help--repair-english-help-self-limit.json` |
| 14 | `repair-number` | `viet-phrase-repair-number-amount` | Anh/chị vừa nói bao nhiêu? | How much did you say? | `content-draft/viet/listing-pages/understanding-repair/repair-number--repair-number-amount.json` |
| 15 | `repair-slower` | `viet-phrase-repair-slower-polite` | Nói chậm giúp tôi được không? | Could you speak a little slower, please? | `content-draft/viet/listing-pages/understanding-repair/repair-slower--repair-slower-polite.json` |

## Remaining Work

- No content-quality blocker remains for the current 150 Tier 1 pages.
- A later app-side task can inspect the flagship Swift-rendered root page and manual Swift render parity after T-167, but this content pass did not touch `native-ios/App/**`.
