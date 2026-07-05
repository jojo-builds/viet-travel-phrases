# Eight-Hour Front-End/Product-Language Closeout

Date: 2026-07-06 Asia/Manila
Branch: `main`
Paywall: isolated; not merged or tested as part of this closeout.

## Why This Run Existed

Jojo found a live mid-page label, `Quick conversations`, plus old local-greeting card names such as `Market Hello`. The label routed to Practice, but the wording belonged to the parked Messages/conversation feature. The earlier front-end runs missed it because they emphasized tappability, screenshots, audio, blank screens, and route success more than semantic product-language review through the middle and bottom of long pages.

## Root Cause

The Messages-era scenario model had been reused for Practice entry points, and tests treated the stale wording as expected behavior. The missing test layer was a semantic product-language crawler over representative routes, including mid-page and lower-page content.

## Repairs And Guardrails

- Renamed visible Browse/Practice wording to Practice-era copy, including `Practice moments`, `Market greeting`, `Hotel greeting`, and `Respectful greeting`.
- Removed nested Practice scenario leaks such as `MESSAGES`, `Conversation complete`, `Conversation break`, `Unread`, `Mark Unread`, `Open thread`, `Quick practice`, `My practice phrases`, `First day in Vietnam messages`, `thread drift`, and the `checkmark.message.fill` visual symbol.
- Hardened `native-ios/scripts/audit-visible-product-language.js` so it scans SwiftUI/accessibility literals and active source-backed JSON/resource inputs for retired labels.
- Added `ProductLanguageUITests/testRepresentativeRoutesDoNotExposeRetiredPracticeVocabularyWhileScrolling` so future runs scroll Home, Browse, Local Greetings, Eating Out, Airport, Hotel, Hoi An, Da Nang, Search, Saved, and Practice.

## Final Proof

- `BrowseSearchUITests`: `68` tests, `0` failures, `/tmp/speaklocal-eight-hour-browse-search.xcresult`.
- `AdminChromeUITests`: `30` tests, `1` intentional skip, `0` failures, `/tmp/speaklocal-eight-hour-admin-chrome.xcresult`.
- `PracticeUITests`: `13` tests, `0` failures, `/tmp/speaklocal-eight-hour-practice.xcresult`.
- Regression cluster: `18` tests, `0` failures, `/tmp/speaklocal-eight-hour-regression-cluster.xcresult`.

Final closeout total: `129` executed UI tests, `1` intentional skip, `0` failures.

Final product-language rerun after static gates: `ProductLanguageUITests/testRepresentativeRoutesDoNotExposeRetiredPracticeVocabularyWhileScrolling`, `1` test, `0` failures, `279.335` seconds, `/tmp/speaklocal-final-product-language.xcresult`.

## Static Gate Sweep

After the UI proof, the post-closeout native static/content gate sweep also passed:

- Native-only guard and native chrome guard.
- Visible product-language audit and visible audit unit test.
- SQLite fixture validation, audio manifest sync, Tier 1 listing pages, Vietnamese menu copy/images, search-only surfacing, production listing QA, V2.2 city strict validation, normal hero image assets, phrase backdrops, catalog-promoted authoring, breakdown audit, city library, city copy, and listing intent routing.
- Script tests for breakdown audit, V2.2 city validation, and production QA: `25` tests, `0` failures after repairing a stale test expectation for the app-facing `tôi = I / me` and `keepTogetherReason` contract.
- `git diff --check`.

## Remaining Honest Limits

- Physical iPhone build/install for app-code payload `521cdf883` succeeded, but exact-current physical launch proof is still pending because the phone was locked.
- Paywall remains outside `main` and still needs real purchase/restore/relaunch proof before merge.
- The strict unique city/place hero-image completion gate still has `20` page-specific owned images outstanding; current runtime falls back to shared city heroes and normal hero/render gates pass.
- Some internal type/test names still use legacy `Messages` terminology because the old scenario architecture is still the implementation substrate. Visible copy, accessibility labels, source-backed product copy, and the new UI guardrail now block user-facing leaks.
