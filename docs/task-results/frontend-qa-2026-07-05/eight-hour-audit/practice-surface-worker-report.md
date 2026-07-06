# Practice Surface Product-Truth Audit

Date: 2026-07-06
Worker scope: read-only audit of Practice plus Browse/Home/Search/Saved entry points after the Messages feature was parked.
Checkout audited: `main` at `87d50da00` (`Add visible product language audit`), including `911864b12` (`Rename legacy conversation practice labels`).

## Recommendation

`needs focused repair`

The retired visible labels from the earlier pass should be treated as stale: current app source passes the new visible-language audit, and the focused Practice UI rerun proved the main hub and Browse first-day entry no longer expose visible `Messages`/old `Quick conversations` copy. The remaining issue is narrower: scenario practice still uses message-era/contact-era affordances in implementation and some identifiers, which can make that surface feel like a parked Messages feature instead of a Practice mode during future work.

Orchestrator follow-up after this report resolved the concrete stale-test/default-copy items:

- `BrowseSearchUITests/testFoodCollectionUsesMessageSectionAfterNounRows` was renamed to `testFoodCollectionUsesPracticeMomentsAfterNounRows` and now expects `Practice moments`.
- `cityPracticeTitle(for:title:)` now falls back to `"\(title) practice"` instead of `"\(title) messages"`.
- The top-level Browse card now says `Respectful greetings` with a matching `greeting` subtitle.
- Visible/accessibility inbox labels in scenario practice were reframed: `Unread` -> `Ready to practice`, `Mark Unread` -> `Mark for practice`, and `Open thread` -> `Start practice`. The visible-language audit now blocks all three retired labels.

## Answers

- Do all Practice entry points say what they do?
  - Mostly yes for the main match-practice paths. Home routes through `Home.PracticeStarter.*`, Browse collection entries use labels like `First day practice`, Saved opens `Practice Saved`, and the Practice hub says `Short matching rounds from the phrasebook`.
  - Current Browse scenario rows are headed `Practice moments`, which is better than `Quick conversations`, but the implementation still renders them as message/contact buttons.

- Do scenario cards feel like Practice, not contacts/messages?
  - Better after the orchestrator follow-up. The visible section title is now `Scenario practice` / `Practice moments`, the dot reads `Ready to practice`, the context action says `Mark for practice`, and the scenario CTA says `Start practice`. Internal component/identifier names still use message/contact language, so a deeper refactor remains useful.

- Do completion buttons and back controls return to the right surface with current labels?
  - Yes for the focused current-source proof. Browse first-day practice opened `Match the pairs`, completed all 4 pairs, showed `Nice match!`, used `Close practice`, and returned to `BrowseCollection.PracticeEntry.category.first-day`.
  - Existing UI tests also cover Saved-launched practice returning to Saved and Home quick practice returning to the Home practice rail.

- Do Practice match rounds, saved practice, topic practice, and scenario practice each have a clear role?
  - Match/topic/saved are clear enough: `Practice Saved`, `Practice by topic`, `Match the pairs`, `Need a hint?`, `Next round`, topic picker, previous round.
  - Scenario practice is clear at the page-title level, but the card model still feels like message contacts. It needs a small vocabulary/affordance pass rather than a product decision.

- Are stale `Messages` strings still visible to users or accessibility users?
  - The new visible-language audit found no retired visible labels in Swift UI literals.
  - I did not find current user-facing `Quick conversations`, exact `Messages`, `Back to Messages`, `Messages thread`, `Restart conversation`, `Market Hello`, `Hotel Hello`, or `Respectful Hello` in app source.
  - Internal accessibility identifiers still contain `Practice.Messages.*` and `BrowseCollection.Messages.*`; those are not read as labels, but they keep tests and implementation tied to the old mental model.

## Findings

1. `SAFE_FIX_NOW, PARTIALLY RESOLVED IN WORKING TREE`: Scenario practice still had message/contact affordances.
   - Source: `native-ios/App/Views/PracticeView.swift`
   - Evidence: `PracticeMessagesHeader` shows `Scenario practice`, but the surface below is `PracticeMessageContactGrid`; items showed unread dots, exposed `Mark Unread`, and label cards with `messageContactName`.
   - Fix applied: the user-facing/accessibility labels now use Practice semantics: `Ready to practice`, `Mark for practice`, and `Start practice`.
   - Remaining follow-up: rename/reframe internal component names and identifiers such as `PracticeMessageContactGrid`, `Practice.Messages.*`, and `messageContactName` in a separate UI-test migration pass.

2. `SAFE_FIX_NOW`: Browse `Practice moments` rows still use message-contact implementation.
   - Source: `native-ios/App/Views/BrowseCollectionPageView.swift`
   - Evidence: `BrowseCollectionMessageSection` renders `BrowseCollectionMessageContactButton` with `PracticeMessageAvatar`, `messageContactName`, and `BrowseCollection.Messages.*` identifiers.
   - Recommended fix: keep the current `Practice moments` title, but rename the component and card semantics to scenario-practice terms. The card label should tell the user it starts a practice moment, not just name a contact-like tile.

3. `SAFE_FIX_NOW, RESOLVED IN WORKING TREE`: Test suite carried stale visible-copy expectations.
   - Source: `native-ios/UITests/BrowseSearchUITests.swift`
   - Evidence: pre-repair `testFoodCollectionUsesMessageSectionAfterNounRows` expected `Quick conversations`, which conflicted with current app source at `BrowseCollectionDescriptor.messageSectionDisplayTitle = "Practice moments"`.
   - Fix applied: renamed the test to `testFoodCollectionUsesPracticeMomentsAfterNounRows` and updated it to expect `Practice moments`.
   - Validation: the focused rerun of `SpeakLocalNativeUITests/BrowseSearchUITests/testFoodCollectionUsesPracticeMomentsAfterNounRows` passed.

4. `FOLLOW_UP, RESOLVED IN WORKING TREE`: Dynamic fallback could generate `"<title> messages"` for unknown city practice titles.
   - Source: `native-ios/App/Models/BrowseSearchDestinations.swift`
   - Evidence: pre-repair `cityPracticeTitle(for:title:)` mapped current known cities to day labels, but the default branch returned `"\(title) messages"`.
   - Fix applied: the fallback now returns `"\(title) practice"`.

## Fresh Validation

- `node native-ios/scripts/audit-visible-product-language.js`
  - Passed: `Visible product language audit passed: no retired visible labels found.`
- `node --test native-ios/scripts/audit-visible-product-language.test.js`
  - Passed: 1 test.
- Focused UI proof on `SpeakLocal Browse` simulator:
  - Command: `xcodebuild -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,id=2BC54208-7EC1-4C1B-8F8E-6357C2E30A10' -only-testing:SpeakLocalNativeUITests/PracticeUITests/testPracticeHubUsesMatchPracticeInsteadOfMessages -only-testing:SpeakLocalNativeUITests/PracticeUITests/testBrowseFirstDayPracticeCallerCompletesRoundAndReturnsToCollection test CODE_SIGNING_ALLOWED=NO`
  - Passed: 2 tests, 0 failures.
- Orchestrator follow-up:
  - XcodeBuildMCP simulator tests passed: `AppChromeTests/testBrowseTopLevelGreetingCardsHaveDistinctJobs`, `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy`, `AppChromeTests/testBrowseCategoryMessageSectionsMirrorMessagesHubGroups`, `AppChromeTests/testCategoryPracticeEntryCopyDescribesMatchPractice`, and `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`.
  - XcodeBuildMCP single-test rerun passed: `BrowseSearchUITests/testFoodCollectionUsesPracticeMomentsAfterNounRows`.
  - Additional inbox-label repair validation passed: `node native-ios/scripts/audit-visible-product-language.js`, `node --test native-ios/scripts/audit-visible-product-language.test.js`, `PracticeUITests/testPracticeHubUsesMatchPracticeInsteadOfMessages`, `PracticeUITests/testLegacyPracticeScenarioLaunchFallsBackToMatchRound`, and `PracticeScenarioModeTests/testMessagesUseShortSituationNamesAndUnreadPreviews`.

## Stale Evidence Retired

Earlier in this worker run, before re-reading `87d50da00`, I observed `Quick conversations` and old `Messages` references in source/tests. After the direction update and fresh source read:

- Current app source uses `Practice moments` for the Browse message/scenario section title.
- The new visible-language audit passes.
- The current Practice hub UI test passes and asserts no visible `Messages`.

Any claim that current shipped UI still visibly says `Quick conversations` or exact `Messages` should be considered stale unless it is reproduced again after `87d50da00`.
