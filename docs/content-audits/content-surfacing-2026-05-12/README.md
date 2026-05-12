# Viet Content Coverage And Surfacing Audit

Date: 2026-05-12

## Why This Exists

This audit maps the shipped Viet phrase catalog into concrete surfaces:

- Tier 1 listing pages that are already fully built out.
- Quick, friendly homepage phrase candidates.
- Messages conversation seeds that reuse existing phrase IDs first.
- Audio coverage by scenario.
- Entity-first Browse gaps where nouns/entities should surface before long-tail phrases.
- Easy beginner essentials coverage.

## Headline Counts

- Runtime phrases: 3078
- Runtime families: 3059
- Runtime scenarios: 19
- Runtime listing pages: 3070
- Tier 1 inventory: 150
- Tier 1 xin-chao-like pages: 150
- Homepage candidates emitted: 120
- Message candidates emitted: 160
- Entity-first gaps emitted: 56
- Covered essentials: 25

Phrase audio status:
- planned: 1983
- ready: 1095

Listing page roles:
- practice-expansion: 1350
- catalog-promoted: 779
- city-v1: 750
- tier1: 145
- editorial-model-support: 32
- child: 14

## Homepage Surfacing Recommendation

Use the CSV `homepage-quick-phrase-candidates.csv` as the source list for expanding "Use now" and other beginner shelves. The top ranked phrases are short, audio-backed, starter-friendly, and high-frequency.

Top candidates:

| Rank | Phrase | English | Page | Band |
| --- | --- | --- | --- | --- |
| 1 | Xin lỗi | Excuse me / sorry | `viet-excuse-sorry` | homepage-now |
| 2 | Xin chào | Hello | `viet-polite-hello` | homepage-now |
| 3 | Cảm ơn | Thank you | `viet-thank-you` | homepage-now |
| 4 | Tôi không hiểu | I don’t understand | `viet-family-repair-understand` | homepage-now |
| 5 | Tôi cần nước | I need water | `viet-family-bathroom-water` | homepage-now |
| 6 | ATM ở đâu? | Where is the ATM? | `viet-family-v500-airp-bord-arri-where-is-the-atm` | homepage-now |
| 7 | Tôi cần một eSIM | I need an eSIM | `viet-family-v500-phon-inte-powe-i-need-an-esim` | homepage-now |
| 8 | Hãy nói từ từ nhé | Please say it slowly | `viet-family-v500-unde-repa-please-say-it-slowly` | homepage-now |
| 9 | Nhà vệ sinh ở đâu? | Where is the bathroom? | `viet-family-bathroom-where` | homepage-now |
| 10 | Tạm biệt | Goodbye | `viet-goodbye` | homepage-now |
| 11 | Mang đi | To go | `viet-family-food-to-go` | homepage-now |
| 12 | Mắc quá | Too expensive | `viet-family-money-too-expensive` | homepage-now |
| 13 | Đi quận 1 | Go to District 1 | `viet-family-transport-main-destination` | homepage-now |
| 14 | Tôi ăn chay | I am vegetarian | `viet-family-food-vegetarian` | homepage-now |
| 15 | Giúp tôi với | I need help | `viet-family-help-need-help` | homepage-now |
| 16 | Không sao đâu | It’s okay | `viet-family-polite-its-okay` | homepage-now |
| 17 | Ít đá thôi | Just a little ice | `viet-family-food-less-ice` | homepage-now |
| 18 | Cho thêm rau | More herbs please | `viet-family-food-more-herbs` | homepage-now |
| 19 | Không đường nhé | No sugar please | `viet-family-food-no-sugar` | homepage-now |
| 20 | Không cay nhé | Not spicy please | `viet-family-food-not-spicy` | homepage-now |
| 21 | Gói mang về | Pack it to go | `viet-family-food-pack-to-go` | homepage-now |
| 22 | Cho tôi chai nước | A bottle of water please | `viet-family-service-water` | homepage-now |
| 23 | Có nước suối không? | Do you have bottled water? | `viet-family-food-bottled-water` | homepage-now |
| 24 | Có bán SIM không? | Do you sell SIM cards? | `viet-family-phone-sim` | homepage-now |

## Messages Reuse Recommendation

Use `message-conversation-candidates.csv` as the first pass for Messages. Each row includes a short conversation name, source page, entry pattern, and existing phrase IDs. The rule is: build the chat around those IDs before creating any new phrase.

Top message seeds:

| Rank | Name | Source | Entry | Existing phrase IDs |
| --- | --- | --- | --- | --- |
| 1 | Buy SIM | `viet-family-airport-sim` | traveler-first | `airport-3`, `airport-1`, `airport-6`, `airport-2`, `airport-5` |
| 2 | Check in | `viet-family-hotel-check-in` | traveler-first | `hotel-2`, `hotel-check-in-polite`, `hotel-1`, `hotel-4`, `hotel-3` |
| 3 | Check out | `viet-family-hotel-checkout` | traveler-first | `hotel-checkout`, `hotel-1`, `hotel-4`, `hotel-2`, `hotel-3` |
| 4 | Check-out time | `viet-family-hotel-checkout-time` | traveler-first | `hotel-3`, `hotel-1`, `hotel-4`, `hotel-2`, `hotel-checkout` |
| 5 | Door lock | `viet-family-v500-hote-acco-the-door-does-not-lock` | traveler-first | `v500-hote-acco-the-door-does-not-lock`, `hotel-1`, `hotel-checkout`, `hotel-2`, `hotel-3` |
| 6 | Find ATM | `viet-family-v500-airp-bord-arri-where-is-the-atm` | traveler-first | `v500-airp-bord-arri-where-is-the-atm`, `airport-1`, `airport-5`, `airport-2`, `airport-3` |
| 7 | Find baggage | `viet-family-airport-baggage` | traveler-first | `airport-2`, `airport-1`, `airport-6`, `airport-3`, `airport-5` |
| 8 | Find immigration | `viet-family-airport-immigration` | traveler-first | `airport-1`, `airport-2`, `airport-6`, `airport-3`, `airport-5` |
| 9 | Find pickup | `viet-family-airport-pickup` | local-first | `airport-5`, `airport-pickup-clearer`, `airport-1`, `airport-6`, `airport-2` |
| 10 | First hello | `viet-polite-hello` | traveler-first | `polite-1`, `polite-2`, `polite-5`, `polite-7` |
| 11 | Fix AC | `viet-family-hotel-aircon-broken` | traveler-first | `hotel-5`, `hotel-1`, `hotel-checkout`, `hotel-2`, `hotel-3` |
| 12 | Hold bags | `viet-family-hotel-luggage` | traveler-first | `hotel-7`, `hotel-1`, `hotel-checkout`, `hotel-2`, `hotel-3` |
| 13 | Hotel booking | `viet-family-hotel-reservation` | traveler-first | `hotel-1`, `hotel-2`, `hotel-4`, `hotel-3`, `hotel-checkout` |
| 14 | More towels | `viet-family-hotel-more-supplies` | traveler-first | `hotel-6`, `hotel-more-supplies-paper`, `hotel-1`, `hotel-checkout`, `hotel-2` |
| 15 | Room hot | `viet-family-hotel-room-hot` | traveler-first | `hotel-4`, `hotel-1`, `hotel-checkout`, `hotel-2`, `hotel-3` |
| 16 | Ask fare | `viet-family-transport-fare` | local-first | `transport-fare`, `taxi-1`, `taxi-4`, `taxi-2`, `taxi-3` |
| 17 | District 1 | `viet-family-transport-main-destination` | traveler-first | `taxi-2`, `taxi-1`, `ves-call-taxi-for-me`, `taxi-3`, `taxi-4` |
| 18 | Pay cash | `viet-family-transport-cash` | traveler-first | `taxi-7`, `taxi-1`, `ves-call-taxi-for-me`, `taxi-2`, `taxi-3` |
| 19 | Show address | `viet-family-transport-destination` | local-first | `taxi-1`, `taxi-2`, `ves-call-taxi-for-me`, `taxi-3`, `taxi-4` |
| 20 | Stop here | `viet-family-transport-stop-here` | traveler-first | `taxi-3`, `transport-stop-here-clearer`, `taxi-1`, `ves-call-taxi-for-me`, `taxi-2` |
| 21 | Take route | `viet-family-transport-route` | traveler-first | `taxi-4`, `taxi-1`, `ves-call-taxi-for-me`, `taxi-2`, `taxi-3` |
| 22 | Turn AC | `viet-family-transport-aircon` | traveler-first | `taxi-5`, `taxi-1`, `ves-call-taxi-for-me`, `taxi-2`, `taxi-3` |
| 23 | Wait please | `viet-family-transport-wait` | traveler-first | `taxi-6`, `taxi-1`, `ves-call-taxi-for-me`, `taxi-2`, `taxi-3` |
| 24 | Find bathroom | `viet-family-bathroom-where` | traveler-first | `bath-1`, `bath-2`, `bath-4`, `bathroom-use`, `bath-3` |
| 25 | Find soap | `viet-family-bathroom-soap` | traveler-first | `bath-3`, `bath-1`, `bath-4`, `bath-2`, `bathroom-use` |
| 26 | Missing bag | `viet-family-airport-bag-missing` | traveler-first | `airport-6`, `airport-1`, `airport-5`, `airport-2`, `airport-3` |
| 27 | Need water | `viet-family-bathroom-water` | traveler-first | `bath-5`, `bath-1`, `bath-3`, `bath-2`, `bathroom-use` |
| 28 | Show passport | `viet-family-v500-airp-bord-arri-here-is-my-passport` | traveler-first | `v500-airp-bord-arri-here-is-my-passport`, `airport-1`, `airport-5`, `airport-2`, `airport-3` |
| 29 | Show visa | `viet-family-v500-airp-bord-arri-here-is-my-visa` | traveler-first | `v500-airp-bord-arri-here-is-my-visa`, `airport-1`, `airport-5`, `airport-2`, `airport-3` |
| 30 | Toilet paper | `viet-family-bathroom-paper` | traveler-first | `bath-2`, `bath-1`, `bath-4`, `bathroom-use`, `bath-3` |

## Tier 1 Listing Pages

The Tier 1 inventory still resolves to 150 rows. This audit scores whether each page is "Xin chào-like" from the runtime resource itself: deep page, multiple sections, breakdown, related phrase rows, useful note/insight, practice metadata, and audio.

- Xin-chao-like: 150
- Solid: 0
- Needs review: 0

See `tier1-listings.csv` for the full page map.

## Entity-First Browse Direction

The app has a strong city entity layer, but long-tail city phrase volume is much larger than the noun/entity layer. That is fine for search and entity detail pages, but city/category browse should keep showing noun/entity rows first.

Use:

- `city-entity-vs-derived-phrases.csv` for city/entity volume.
- `entity-first-browse-gaps.csv` for rows that should not be promoted as top-level Browse cards.

## Easy Beginner Essentials

All audited beginner essentials have at least one existing phrase match.

See `easy-beginner-essential-coverage.csv` for phrase IDs by intent.

## Generated Artifacts

- `tier1-listings.csv`
- `homepage-quick-phrase-candidates.csv`
- `message-conversation-candidates.csv`
- `audio-coverage-by-scenario.csv`
- `city-entity-vs-derived-phrases.csv`
- `entity-first-browse-gaps.csv`
- `easy-beginner-essential-coverage.csv`

## Next Product Moves

1. Homepage can expand "Use now" from the first 24-48 rows in `homepage-quick-phrase-candidates.csv`.
2. Messages can start with the `ready-thread` and `ready-short-thread` rows from `message-conversation-candidates.csv`.
3. Browse/category work should use `entity-first-browse-gaps.csv` to avoid resurfacing long-tail phrase rows where an entity page should come first.
4. Audio planning should focus on `planned` rows in city and premium phrase coverage, not on the already audio-backed starter rows.
