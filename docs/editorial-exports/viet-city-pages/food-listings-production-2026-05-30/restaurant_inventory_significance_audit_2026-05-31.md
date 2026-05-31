# Restaurant Inventory Significance Audit

Date: 2026-05-31

Worktree / branch: `/Users/jojolim/Developer/products/speaklocal/app-family/.worktrees/city-listings-production-ready` / `feature/city-listings-production-ready`

Commit baseline before this audit: `1b332bf12 Fix pinned audio top shield`

## Scope

This is a repo-current food/listing judgment pass after Jojo's copy review. It is not a new external research refresh and it does not add new MICHELIN claims. Existing recognition copy remains date-bounded to 2025 where source notes already support it.

Food-ish inventory counted from current V2.2 source:

- Total food/drink pages reviewed by category: 175.
- Restaurants: 79.
- Cafes: 39.
- Dishes: 46.
- Desserts: 6.
- Drinks: 5.
- By city: Đà Nẵng 38, Hà Nội 37, Saigon 39, Hội An 32, Huế 29.
- Every food-ish page has at least one renderable Mentioned Here or Related card, so the current graph does support trip-building rather than dead-end reading.

## What Jojo's Critique Exposed

The app should make saving feel natural, not explain the save mechanic. Phrases like `counter to save`, `part of the stop`, or ambiguous headings like `Phượng Beside Madam` make the internal content strategy visible. They sound like the app is talking about its own database instead of helping someone choose a meal.

The better direction is:

- Let the page make the place feel worth remembering.
- Use `shop`, `stall`, `restaurant`, `table`, `room`, `food hall`, or `line` when those words are more natural than `counter`.
- Use comparison headings that explain the relationship: `Compare It With Madame Lân`, not `Beside Madame Lân`.
- Keep Vietnamese names, but immediately explain the role in English when the user may not know what the name represents.

## Targeted Copy Repairs Applied

Visible source copy was repaired across the V2.2 source and regenerated runtime resources.

Primary repairs:

- `city-danang-place-banh-mi`: changed broad counter language to sandwich/filling/line language.
- `city-danang-place-bep-hen`: changed `Beside Madame Lân` into an explicit restaurant comparison.
- `city-danang-place-moc-quan-seafood`: changed `Use it as...` and `Beside Bé Mặn` into natural seafood-table comparison copy.
- `city-danang-place-bun-cha-ca-109`: clarified that `Hờn` is another fish-cake soup comparison.
- `city-danang-place-bun-cha-ca-hon`: changed `Beside The Broader Dish` into a clear dish-guide comparison.
- `city-danang-place-kem-bo`: changed `Every Counter Is Different` to `Every Stall Is Different`.
- `city-danang-place-my-quang-dung`: changed compact counter fallback language to small noodle-shop language.
- `city-hanoi-place-banh-cuon-ba-xuan`, `city-hanoi-place-mien-luon-chan-cam`, `city-hanoi-place-pho-ga-nguyet`: changed generic pho-counter references to phở shop references where the page means a place, not a chef counter.
- `city-hcmc-place-anan-saigon`, `city-hcmc-place-banh-mi`, `city-hcmc-place-che`, `city-hcmc-place-com-tam-ba-ghien`, `city-hcmc-place-cuc-gach-quan`, `city-hcmc-place-man-moi`: removed counter-as-crutch language in favor of shop, ordering pace, display, order line, quick bite, or tasting-menu contrast.
- `city-hoian-place-banh-mi`, `city-hoian-place-bale-well`, `city-hoian-place-cao-lau-thanh`, `city-hoian-place-com-ga`, `city-hoian-place-com-ga-ba-buoi`, `city-hoian-place-cocobox`, `city-hoian-place-morning-glory`, `city-hoian-place-mot-herbal-drink`, `city-hoian-place-roastery`, `city-hoian-place-vys-market`: repaired sandwich-shop, market-stall, drink-stop, and food-hall language.
- `city-hue-place-ba-van-banh-loc`, `city-hue-place-banh-bot-loc`, `city-hue-place-che-hue`, `city-hue-place-me-xung`, `city-hue-place-thanh-cafe`: changed dumpling counter / dessert counter / market counter language to shop, order, stall, or table language.

Visible critique-pattern scan after repairs:

- `counter to save`: 0.
- `part of the stop`: 0.
- `Name Counter`: 0.
- `commoner identity`: 0.
- visible resource `save` / `saved` / `saving` / `route the user`: 0.

## Product Judgment

The food inventory is not one uniform class. It should be treated as three layers:

Lead food saves:

- These should carry high-visibility surfaces and city food routes.
- Typical proof: signature dish, strong local role, official recognition, or a vivid first-order moment.
- Examples already behaving like leads: Anăn Sài Gòn, Akuna, Gia, Hibana by Koki, Nén Đà Nẵng, La Maison 1888, Bánh xèo Bà Dưỡng, Bé Mặn, Bún Chả Cá Hờn, Bún Chả Cá 109, Mỳ Quảng Sứa Hồng Vân, Phở Lệ, Bò Kho Gánh, Bún Bò Huế 14B, Bánh mì Phượng, Madam Khánh, Cao Lầu Thanh, Cơm Gà Bà Buội.

Support / downrank but keep:

- These are useful as comparison cards, route fillers, calmer alternatives, or comfort stops.
- They should not be marketed as "why you came to Vietnam" unless their copy has a stronger source-backed food hook.
- Current support/downrank candidates: Fatfish, Boulevard Gelato & Coffee, Reply 1988 Cafe, Mỳ Quảng Bà Mua, Mỳ Quảng Dung, Nephele, Phở Hòa Pasteur, Cargo Club, Faifo Coffee, Ancient Space Restaurant, Đại Nam Restaurant, Les Jardins de la Carambole, Sông Hương Floating Restaurant.

No immediate delete:

- I do not see a strong reason to delete these support pages outright from the source inventory yet.
- The better product move is placement control: lead pages in city food routes; support pages in related cards, neighborhood route context, browse/search, and lower-intent shelves.
- A true drop/delete decision should wait until we see usage data or identify source claims that cannot be supported.

## Remaining Work

The next production step is rendered proof for this exact copy batch on representative pages:

- Đà Nẵng: `city-danang-place-banh-mi`, `city-danang-place-bep-hen`, `city-danang-place-moc-quan-seafood`.
- Hội An: `city-hoian-place-banh-mi`, `city-hoian-place-mot-herbal-drink`, `city-hoian-place-vys-market`.
- Huế: `city-hue-place-ba-van-banh-loc`, `city-hue-place-banh-bot-loc`, `city-hue-place-che-hue`.

After those render checks, the branch can claim this specific critique batch as productionized. It still should not claim all 175 food pages are globally perfect without broader screenshots and source freshness review.
