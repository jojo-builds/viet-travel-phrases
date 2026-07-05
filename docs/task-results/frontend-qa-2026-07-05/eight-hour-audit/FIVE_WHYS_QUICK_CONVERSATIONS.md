# Five Whys: `Quick conversations` Miss

Timestamp: 2026-07-05 23:59 Asia/Manila local
Surface: Browse category mid-page scenario rail

## Symptom

Jojo found a Browse mid-page rail labeled `Quick conversations` with cards such as `Market Hello`, `Hotel Hello`, and `Respectful Hello`. The cards route into Practice scenario flows, but the label reads like the retired Messages/conversation feature.

## Five Whys

1. Why did the app show `Quick conversations`?
   - `BrowseCollectionDescriptor.messageSectionDisplayTitle` was hardcoded to `Quick conversations`.

2. Why was old conversation language still on the active Browse page?
   - The scenario rail was originally modeled as `message` UI and later routed into Practice without a product-language cleanup of the visible section labels.

3. Why did tests not catch it?
   - Unit tests asserted the stale string as expected behavior, so automated validation preserved the wrong product language.

4. Why did visual/front-end QA not catch it?
   - The previous broad passes emphasized route success, audio, blank screens, chrome, and screenshot existence. They did not include a semantic copy pass over mid-page and lower-page labels.

5. Why was there no semantic copy pass?
   - The launch-readiness checklist had no explicit gate for retired feature vocabulary such as `Messages`, `Quick conversations`, or old contact-like scenario names on active Practice-era surfaces.

## Root Cause

The old Messages/scenario implementation names leaked into visible Practice-era UI, and our validation treated them as stable instead of checking them against current product truth.

## Fix Applied

- Browse scenario rail title changed from `Quick conversations` to `Practice moments`.
- Local greeting scenario card names changed from `Market Hello`, `Hotel Hello`, and `Respectful Hello` to `Market greeting`, `Hotel greeting`, and `Respectful greeting`.
- Visible Practice labels changed from `Messages` / `Messages thread` / `Back to Messages` / `Restart conversation` to Practice-oriented wording.
- Focused tests were updated first, observed red, then passed after the production copy fix.

## New Audit Rule

Future front-end QA must include a mid-page and bottom-page product-language pass. It is not enough to prove a page is nonblank and tappable; labels must still make sense for the current app direction.

## Follow-Up Miss Found During The Eight-Hour Pass

After the first fix, a worker found two more Practice-scenario strings that explained why the first gate was still too weak:

- `MESSAGES` appeared as an uppercase caption in the scenario header.
- `Conversation complete` appeared on the scenario completion card.

The immediate why: the static audit blocked exact `Messages`, but did not treat case variants as retired labels and did not include the completion headline. The deeper why: the earlier front-end pass did not enter and complete the Practice scenario flow, so top/middle/bottom page review still missed nested states.

Follow-up fix:

- scenario header caption changed to `PRACTICE`
- completion headline changed to `Practice complete`
- completion body changed from `thread` wording to `practice run`
- story transcript accessibility fallback changed from `Conversation break` to `Practice beat`
- local greeting scenario titles and scene titles changed to `Market greeting`, `Hotel greeting`, and `Respectful greeting`
- top-level Browse card changed from `Respectful hellos` / `hello` subtitle to `Respectful greetings` / `greeting` subtitle
- unknown city practice fallback changed from `messages` to `practice`
- stale Browse UI test expectation changed from `Quick conversations` to `Practice moments`
- trip fallback subtitle changed from `Practical travel conversations...` to `Practical travel moments to practice first.`

Additional harness-prevention follow-up on 2026-07-06:
- UI-test tab helpers now navigate to `Practice` instead of the retired `Messages` alias.
- Local-greetings proof expectations now use `Hotel greeting` and `Respectful greeting` instead of the old `Hotel Hello` / `Respectful Hello` card labels.
- Exact stale-term scan now finds no `openDock("Messages")`, `case "Messages"`, `Hotel Hello`, `Respectful Hello`, or `Quick conversations` references in `native-ios/UITests` or `native-ios/Tests`.
- The visible-language audit now blocks message-inbox affordances that survived inside scenario practice: `Unread`, `Mark Unread`, and `Open thread`. Current app copy uses `Ready to practice`, `Mark for practice`, and `Start practice`.
- the visible-language audit now catches case variants of exact retired labels, `Conversation complete`, and `Conversation break` accessibility fallbacks

Additional data-backed copy follow-up on 2026-07-06:
- A later semantic scan found `Useful before pickup and hotel messages.` in the Da Nang airport terminal SIM-card proof. This was not a direct SwiftUI `Text("...")` literal, so the first visible-language audit missed it.
- That copy now reads `Useful before pickup and hotel check-in details.`
- The Browse `Hello basics` subtitle now reads `Simple ways to start speaking.` instead of leaning on the old conversation framing.
- The audit now scans source-backed retired phrases as well as direct SwiftUI labels, while keeping legitimate phrase-teaching copy such as `respectful hello` allowed.
- Fresh validation passed: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, exact stale-term `rg` scan, `git diff --check`, and `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`.

Additional test-harness cleanup on 2026-07-06:
- Non-visible accessibility identifiers still used old `Practice.Messages.*` and `BrowseCollection.Messages.*` naming, which could bias future UI tests toward the parked feature vocabulary.
- The identifiers now use `Practice.Scenarios.*` and `BrowseCollection.PracticeMoments.*`; the user-facing labels did not change.
- Validation: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, exact old-identifier `rg` scan, `git diff --check`, a Swift parse pass over the modified Swift files, and a focused native Xcode rerun all passed.
- The first focused native Xcode rerun was blocked by local disk pressure with an asset-catalog `Failed to write to CAR` build-cache error. After clearing generated `/tmp` result bundles, the focused rerun passed `3` tests with `0` failures: `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`, `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy`, and `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`.

Additional source-backed audit hardening on 2026-07-06:
- The visible-language audit now scans active generated/native resource inputs for exact retired multiword labels, not just direct SwiftUI literals.
- Covered active source-backed roots include `native-ios/Resources/viet-authored-listing-pages.json`, `native-ios/Resources/viet-phrase-catalog.json`, `content-draft/viet/city-library/v1.json`, V2.2 city detail JSON, and `content-draft/viet/search-only-surfacing-v1.json`.
- The unit test now proves a generated JSON fixture containing `Quick conversations` and `hotel messages` fails the audit.
- Fresh validation passed: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, and `git diff --check`.

Additional internal generator cleanup on 2026-07-06:
- `native-ios/scripts/audit-viet-content-surfacing.js` no longer frames future reuse rows as `Messages` or writes a new `message-conversation-candidates.csv` report. Future output is `practice-moment-candidates.csv`, with README language describing Browse-launched Practice moments.
- This does not change current app runtime copy; it prevents future audit packets and worker prompts from reintroducing the parked Messages mental model.
- Validation: `node --check native-ios/scripts/audit-viet-content-surfacing.js` and `git diff --check` passed.

Additional live mid-page validation on 2026-07-06:
- XcodeBuildMCP launched current `main` on the `SpeakLocal Frontend QA` simulator with `--browse-category local-greetings --reset-demo-state`; first and mid-page screenshots showed `Local Greetings`, `Greetings`, `Polite Basics`, and `Small talk & boundaries`, with no visible `Quick conversations`, `Market Hello`, `Hotel Hello`, or `Respectful Hello` labels.
- The same live route, after scrolling, showed the sticky top admin section chip updating to `Greetings` and then `Polite Basics`, with phrase rows and speaker affordances still present.
- XcodeBuildMCP launched `--browse-category food --reset-demo-state`; top and mid-page screenshots showed `Eating Out`, section chips, active top admin chips, and audio-backed phrase rows including `Không cay nhé / Not spicy please`.
- Focused simulator UI validation passed: `BrowseSearchUITests/testFoodCollectionUsesPracticeMomentsAfterNounRows`.
- Focused route/function UI validation passed: `testCityBrowseCardSelectionJumpsToMatchingSection`, `testHoiAnBrowseByRestaurantCardJumpsToMatchingSection`, `testBrowseCollectionTopSectionPillJumpsToAirportSubcategory`, and `testRepresentativeCategorySubcategoryJumpsClearTopAdminChrome`.
- Focused Practice UI validation passed: `PracticeUITests/testPracticeHubUsesMatchPracticeInsteadOfMessages`, `PracticeUITests/testLegacyPracticeScenarioLaunchFallsBackToMatchRound`, `BrowseSearchUITests/testBrowsePracticeBackReturnsToCollectionPracticeFocus`, and `BrowseSearchUITests/testBrowsePracticeOverlayKeepsCollectionInPlaceThroughDismissal`.
- A fresh source-backed scan of active app/resource copy still contains legitimate phrase-learning uses of `conversation`, `message`, and `thread` such as text-message phrases, pickup messages, and museum thread copy. The guardrail intentionally blocks retired app-feature labels instead of banning normal traveler copy.

New front-end guardrail added on 2026-07-06:
- Added `ProductLanguageUITests/testRepresentativeRoutesDoNotExposeRetiredPracticeVocabularyWhileScrolling`.
- The test launches and scrolls representative routes across Home, Browse, Local Greetings, Eating Out, Airport, Hotel, Hoi An, Da Nang, Search, Saved, and Practice.
- It fails on exact retired visible labels: `Quick conversations`, exact `Messages`/`MESSAGES`, `Back to Messages`, `Messages thread`, `Restart conversation`, `Conversation complete`, `Conversation break`, `Unread`, `Mark Unread`, `Open thread`, `Market Hello`, `Hotel Hello`, and `Respectful Hello`.
- Validation passed with shell `xcodebuild` after the MCP test transport closed under low disk pressure: `1` test, `0` failures, `283.058` seconds.

Hidden fallback follow-up on 2026-07-06:
- A later source scan found old fallback labels that were not currently visible but could leak back onto Practice surfaces: `Quick practice`, `My practice phrases`, and `First day in Vietnam messages`.
- The fallback labels were renamed to Practice-safe copy (`Quick match`, `Practice pool`, and `practice round` wording), and the visible-language audit plus route-scrolling UI guardrail now block those old labels too.
- Fresh validation passed: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, `swiftc -parse native-ios/UITests/ProductLanguageUITests.swift`, `git diff --check`, exact retired-label `rg` scan showing only negative tests/guardrails, and shell `xcodebuild` rerun of `ProductLanguageUITests/testRepresentativeRoutesDoNotExposeRetiredPracticeVocabularyWhileScrolling` (`1` test, `0` failures, `279.075` seconds).
- Xcode reported low disk while writing extra result-bundle summaries after the successful test run; the temporary derived data was deleted afterward. The test result itself completed successfully before that cleanup warning.

Visual/semantic smell follow-up on 2026-07-06:
- A source-level pass found two subtler legacy cues: the Practice completion surface used the `checkmark.message.fill` symbol, and the driver-help scenario setup said `without letting the thread drift`.
- The completion icon now uses `checkmark.seal.fill`, and the driver-help setup now says `without losing the plan`.
- The visible-language audit now blocks the exact retired visual symbol `checkmark.message.fill` and the exact stale phrase `thread drift` while leaving legitimate traveler copy such as text messages, pickup messages, and real cafe note/messages content alone.
- Fresh validation passed: visible-language audit, audit unit test, Swift parse of the changed Swift files, JS syntax checks for the audit script and test, exact `rg` scan showing only guardrail/test references, and `git diff --check`.
- After the source-of-truth guidance update, the latest `main` reran `ProductLanguageUITests/testRepresentativeRoutesDoNotExposeRetiredPracticeVocabularyWhileScrolling` successfully: `1` test, `0` failures, `280.515` seconds. Temporary xcodebuild derived data was deleted afterward; the disposable `SpeakLocal Traveler` simulator was erased to recover local disk space for continued QA.
