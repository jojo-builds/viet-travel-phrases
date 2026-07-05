# City Copy Clean-Pass Anti-Thinning Addendum

Date: 2026-06-08

Branch: `codex/city-copy-final-production-gate`

Scope: final clean-pass cleanup after commit `44d9916d1`. This pass removes the last copy-production risks without thinning visible copy.

## Summary

- Source rationale prefixes normalized: 160 reason fields across 147 first-class V2.2 pages.
- Before/after pattern: `Related because: ...` or `Mentioned here because: ...` became the same rationale sentence without the visible-label prefix.
- Rendered user-facing card subtitles were not weakened; `displaySubtitle` stayed intact.
- Bà Nà Hills native projection now preserves authored V2.2 headings instead of generic compatibility labels.

## Anti-Thinning Invariants

- Useful phrase-card sets unchanged: 520 / 520 pages.
- Mentioned Here card targets/status/display subtitles unchanged: 520 / 520 pages.
- Related card targets/status/display subtitles unchanged: 520 / 520 pages.
- No phrase cards were removed.
- No Mentioned Here or Related cards were removed, hidden, or retargeted in this pass.
- No visible prose was shortened to satisfy validators.

## Bà Nà Hills Projection Preservation

- Source page: `viet-family-city-danang-place-ba-na-hills`.
- Rendered heading fix: `About` -> `More Park Than Viewpoint`; `Good to know` -> `Give It Room`.
- Traveler value improved: the rendered app now shows the authored V2.2 travel judgment instead of generic module labels.
- Journey utility rows preserved: getting there, tickets, cable car, photos, getting back, and food/cash phrase sections still render.

Rendered section/row snapshot:
- at-glance:More Park Than Viewpoint
- quick-say:Useful Phrases (sight-1, sight-3, sight-4)
- place-brief:Early, With Weather Checked
- use-it-with:Cable Car Arrival
- when-to-use:Bridge Before Wandering
- getting-there:Getting there (taxi-1, repair-5, transport-stop-here-clearer, ves-is-this-address-correct)
- tickets:Tickets (v500-time-date-book-two-tickets-please, v500-time-date-book-one-ticket-please, v500-sigh-acti-where-can-i-buy-tickets)
- cable-car:Cable car (ves-where-cable-car)
- photos:Photos (ves-take-photo-for-me)
- getting-back:Getting back (ves-call-taxi-for-me)
- good-to-know:Give It Room
- food-cash:Food & cash (store-1, airport-4)

## Prefix-Normalized Pages

| Page ID | Display | City | Mentioned reasons | Related reasons | Phrase cards | Rendered Mentioned | Rendered Related |
|---|---|---:|---:|---:|---:|---:|---:|
| viet-family-city-danang-place-3d-art-in-paradise | Bảo tàng 3D Art in Paradise Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-airport | Sân bay Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-an-thuong-street-area | Khu An Thượng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-apec-park | Công viên APEC | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-asia-park | Công viên Châu Á | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-ba-na-cable-car | Cáp treo Bà Nà | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-ba-na-hills | Bà Nà Hills | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-bach-dang-street | Đường Bạch Đằng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-ban-co-peak | Đỉnh Bàn Cờ | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-banh-canh-yen | Bánh Canh Yến | Đà Nẵng | 0 | 2 | 3 | 0 | 2 |
| viet-family-city-danang-place-banh-xeo-ba-duong | Bánh xèo Bà Dưỡng | Đà Nẵng | 1 | 1 | 3 | 2 | 1 |
| viet-family-city-danang-place-be-man | Hải sản Bé Mặn | Đà Nẵng | 0 | 1 | 3 | 1 | 1 |
| viet-family-city-danang-place-bun-cha-ca-109 | Bún Chả Cá 109 | Đà Nẵng | 1 | 0 | 3 | 1 | 2 |
| viet-family-city-danang-place-bun-rieu-cua-39 | Bún Riêu Cua 39 | Đà Nẵng | 0 | 1 | 3 | 0 | 2 |
| viet-family-city-danang-place-cathedral | Nhà thờ Con Gà Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-central-bus-station | Bến xe Trung tâm Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-cham-museum | Bảo tàng Điêu khắc Chăm | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-domestic-terminal | Nhà ga quốc nội Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-dragon-bridge | Cầu Rồng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-dragon-bridge-fire-show | Màn phun lửa Cầu Rồng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-dragon-carp-statue | Tượng Cá Chép Hóa Rồng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-fine-arts-museum | Bảo tàng Mỹ thuật Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-golden-bridge | Cầu Vàng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-hai-chau-district | Quận Hải Châu | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-hai-van-pass | Đèo Hải Vân | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-hai-van-pass-ride | Chuyến đi đèo Hải Vân | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-han-market | Chợ Hàn | Đà Nẵng | 0 | 1 | 3 | 2 | 1 |
| viet-family-city-danang-place-han-river-cruise | Du thuyền sông Hàn | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-hoa-phu-thanh | Khu du lịch Hòa Phú Thành | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-hoa-trung-lake | Hồ Hòa Trung | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-lady-buddha | Tượng Phật Bà | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-linh-ung-pagoda | Chùa Linh Ứng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-lotte-mart | Lotte Mart Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-love-bridge | Cầu Tình Yêu | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-man-thai-beach | Biển Mân Thái | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-marble-mountain-cave-walk | Hang động Ngũ Hành Sơn | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-marble-mountains | Ngũ Hành Sơn | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-mi-quang-1a | Mì Quảng 1A | Đà Nẵng | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-danang-place-moc-quan-seafood | MỘC Quán Seafood | Đà Nẵng | 1 | 0 | 3 | 1 | 2 |
| viet-family-city-danang-place-museum | Bảo tàng Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-museum-branch-2 | Bảo tàng Đà Nẵng - Cơ sở 2 | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-my-an | Mỹ An | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-my-an-beach | Biển Mỹ An | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-my-khe | Biển Mỹ Khê | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-my-quang-ba-mua | Mỳ Quảng Bà Mua | Đà Nẵng | 1 | 1 | 3 | 1 | 2 |
| viet-family-city-danang-place-my-quang-dung | Mỳ Quảng Dung | Đà Nẵng | 1 | 1 | 3 | 1 | 2 |
| viet-family-city-danang-place-my-quang-sua-hong-van | Mỳ Quảng Sứa Hồng Vân | Đà Nẵng | 1 | 1 | 3 | 1 | 2 |
| viet-family-city-danang-place-nam-danh-seafood | Hải sản Năm Đảnh | Đà Nẵng | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-danang-place-nam-o-fish-sauce-village | Làng nghề nước mắm Nam Ô | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-nam-o-reef | Rạn Nam Ô | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-ngu-hanh-son-district | Quận Ngũ Hành Sơn | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-nguyen-hien-dinh-tuong-theatre | Nhà hát Tuồng Nguyễn Hiển Dĩnh | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-nguyen-van-linh-street | Đường Nguyễn Văn Linh | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-non-nuoc-beach | Biển Non Nước | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-non-nuoc-stone-village | Làng đá Non Nước | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-pham-van-dong-beach | Biển Phạm Văn Đồng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-phap-lam-pagoda | Chùa Pháp Lâm | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-phuoc-my | Phước Mỹ | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-railway-station | Ga Đà Nẵng | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-son-tra | Bán đảo Sơn Trà | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-son-tra-district | Quận Sơn Trà | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-son-tra-wildlife-drive | Chuyến đi Sơn Trà | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-thanh-binh-beach | Biển Thanh Bình | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-thuan-phuoc-bridge | Cầu Thuận Phước | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-tran-hung-dao-street | Đường Trần Hưng Đạo | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-tran-thi-ly-bridge | Cầu Trần Thị Lý | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-trung-vuong-theatre | Nhà hát Trưng Vương | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-vo-nguyen-giap-street | Đường Võ Nguyên Giáp | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-wonderlust | Wonderlust | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-danang-place-yen-retreat | Yên Retreat | Đà Nẵng | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-ba-dinh-district | Quận Ba Đình | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-ba-dinh-square | Quảng trường Ba Đình | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-banh-cuon | Bánh cuốn ở Hà Nội | Hà Nội | 0 | 2 | 3 | 0 | 3 |
| viet-family-city-hanoi-place-banh-cuon-ba-hoanh | Bánh Cuốn Bà Hoành | Hà Nội | 1 | 2 | 3 | 1 | 3 |
| viet-family-city-hanoi-place-banh-cuon-ba-xuan | Bánh Cuốn Bà Xuân | Hà Nội | 1 | 2 | 3 | 1 | 3 |
| viet-family-city-hanoi-place-bay-mau-lake | Hồ Bảy Mẫu | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-botanical-garden | Vườn Bách Thảo Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-bun-cha | Bún chả ở Hà Nội | Hà Nội | 0 | 3 | 3 | 0 | 3 |
| viet-family-city-hanoi-place-bun-cha-dac-kim | Bún Chả Đắc Kim | Hà Nội | 1 | 0 | 3 | 1 | 4 |
| viet-family-city-hanoi-place-bun-cha-huong-lien | Bún chả Hương Liên | Hà Nội | 1 | 0 | 3 | 1 | 3 |
| viet-family-city-hanoi-place-bun-cha-ta | Bún Chả Ta | Hà Nội | 1 | 0 | 3 | 1 | 3 |
| viet-family-city-hanoi-place-cha-ca | Chả cá ở Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-cha-ca-thang-long | Chả cá Thăng Long | Hà Nội | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-hanoi-place-coffee-hop | Đi cà phê Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-cyclo-old-quarter | Xích lô phố cổ | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-dinh-cafe | Cà phê Đinh | Hà Nội | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-hanoi-place-ethnology-museum | Bảo tàng Dân tộc học | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-french-quarter | Khu phố Pháp | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-french-quarter-walk | Đi bộ khu phố Pháp | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-gia-lam-station | Ga Gia Lâm | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-giap-bat-bus-station | Bến xe Giáp Bát | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hang-bac-street | Phố Hàng Bạc | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hang-gai-street | Phố Hàng Gai | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hanoi-flag-tower | Cột cờ Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hanoi-railway-station | Ga Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-ho-chi-minh-mausoleum | Lăng Bác | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-ho-chi-minh-museum | Bảo tàng Hồ Chí Minh | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hoa-lo-prison | Nhà tù Hỏa Lò | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hoan-kiem | Hồ Hoàn Kiếm | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-hom-market | Chợ Hôm | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-imperial-citadel | Hoàng thành Thăng Long | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-lenin-park | Công viên Lê Nin | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-literature-museum | Bảo tàng Văn học Việt Nam | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-long-bien-bridge | Cầu Long Biên | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-manzi-art-space | Manzi | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-mien-luon | Miến lươn ở Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-mien-luon-chan-cam | Miến lươn Chân Cầm | Hà Nội | 1 | 1 | 3 | 1 | 1 |
| viet-family-city-hanoi-place-my-dinh-bus-station | Bến xe Mỹ Đình | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-national-museum-history | Bảo tàng Lịch sử Quốc gia | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-ngoc-son-temple | Đền Ngọc Sơn | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-nguyen-huu-huan-street | Phố Nguyễn Hữu Huân | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-nuoc-ngam-bus-station | Bến xe Nước Ngầm | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-old-quarter | Phố cổ Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-old-quarter-walking-tour | Tuyến đi bộ Phố cổ | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-one-pillar-pagoda | Chùa Một Cột | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-opera-house | Nhà hát Lớn Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-pho-10-ly-quoc-su | Phở 10 Lý Quốc Sư | Hà Nội | 1 | 0 | 3 | 1 | 2 |
| viet-family-city-hanoi-place-pho-bat-dan | Phở Bát Đàn | Hà Nội | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-hanoi-place-pho-bo | Phở bò ở Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 2 |
| viet-family-city-hanoi-place-pho-bo-lam | Phở Bò Lâm | Hà Nội | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-hanoi-place-pho-ga-nguyet | Phở Gà Nguyệt | Hà Nội | 1 | 0 | 3 | 1 | 2 |
| viet-family-city-hanoi-place-pho-gia-truyen | Phở Gia Truyền | Hà Nội | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-hanoi-place-quan-thanh-temple | Đền Quán Thánh | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-st-joseph-cathedral | Nhà thờ Lớn Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-street-food-walk | Đi bộ ăn vặt Hà Nội | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-ta-hien | Phố Tạ Hiện | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-tay-ho | Tây Hồ | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-temple-literature | Văn Miếu | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-thong-nhat-park | Công viên Thống Nhất | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-tran-quoc-pagoda | Chùa Trấn Quốc | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-trang-tien-street | Phố Tràng Tiền | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-trieu-viet-vuong-coffee-street | Phố cà phê Triệu Việt Vương | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-truc-bach-lake | Hồ Trúc Bạch | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-turtle-tower | Tháp Rùa | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-tuyet-bun-cha-34 | Tuyết Bún Chả 34 | Hà Nội | 1 | 0 | 3 | 1 | 3 |
| viet-family-city-hanoi-place-vietnam-art-gallery | Vietnam Art Gallery | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-vietnam-circus | Rạp Xiếc Trung ương | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-vietnam-fine-arts-museum | Bảo tàng Mỹ thuật Việt Nam | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-vietnam-military-history-museum | Bảo tàng Lịch sử Quân sự Việt Nam | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-vietnam-national-tuong-theatre | Nhà hát Tuồng Việt Nam | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-water-puppet-theatre | Nhà hát Múa rối Thăng Long | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-west-lake | Hồ Tây | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-west-lake-loop | Vòng Hồ Tây | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-womens-museum | Bảo tàng Phụ nữ Việt Nam | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hanoi-place-yen-so-park | Công viên Yên Sở | Hà Nội | 0 | 1 | 3 | 0 | 1 |
| viet-family-city-hoian-place-white-rose-restaurant | Nhà hàng White Rose | Hội An | 1 | 0 | 3 | 1 | 1 |
| viet-family-city-hue-place-bun-bo-city | Bún bò Huế | Huế | 1 | 0 | 3 | 1 | 0 |
