# Messages Hand Review Expansion Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make every SpeakLocal Messages scenario, option, selected reply, and follow-up read like a coherent conversation, then expand each Messages category row from four conversations to five using existing audio-backed phrase and noun surfaces.

**Architecture:** Keep authored conversation logic in `native-ios/App/Models/PracticeScenarioBuilder.swift` and scenario metadata in `native-ios/App/Models/PracticeScenarioModels.swift`. Fix branch drift with authored `nextStepID` and selected-option replies rather than generated copy. Add one new scenario per Messages category row, using existing ready/audio-backed phrase IDs and noun/place/menu pages only when the visible Vietnamese has exact bundled audio.

**Tech Stack:** Swift, SwiftUI, XCTest, bundled Viet SQLite resources, generated Viet phrase/audio resources.

---

## Current Branch State

- Current branch: `feature/messages-section`
- Existing branch work checkpointed: `060e44b0 Checkpoint Viet practice content expansion`
- Current local `main` merged into the branch: `7cdeff07 Merge branch 'main' into feature/messages-section`
- Worktree was clean after merge before this plan file was added.

## Review Inputs

Two read-only subagents reviewed current `HEAD 7cdeff07`.

- Conversational review: 28 scenarios / 178 authored steps reviewed one by one. Blocking issues were branch drift in `airportSimCash`, `hotelWifiCheckout`, `danangDay`, `shoppingMarketPrice`, `shoppingPayCard`, `pharmacyHelp`, and `localGreetingHotel`.
- Catalog/noun review: 28 scenarios / 178 steps / 283 unique referenced page IDs reviewed. Strongest expansion gap is food/drink, place noun, and practical noun coverage. Current unresolved IDs to fix first:
  - Replace `viet-family-v500-phon-inte-powe-my-phone-is-almost-dead` with `viet-family-phone-battery-dead`.
  - Replace `viet-family-v900-hote-acco-can-i-get-late-check-out` with `viet-family-hotel-late-checkout` or `viet-family-v500-hote-acco-can-i-check-out-late`.

## Files

- Modify: `native-ios/App/Models/PracticeScenarioBuilder.swift`
  - Fix existing branch drift.
  - Add seven new authored scenario templates.
  - Use only existing phrase/family IDs that resolve to ready bundled resources.
- Modify: `native-ios/App/Models/PracticeScenarioModels.swift`
  - Add seven `PracticeScenarioID` cases.
  - Add title, short title, symbol, tint, category IDs, flow beats, contact name, location, initials, avatar symbol, badge, section rank, and contact sort rank entries.
- Modify: `native-ios/Tests/PracticeScenarioModeTests.swift`
  - Update all-case scenario lists from 28 to 35.
  - Rename the four-thread test to a five-thread test.
  - Add script and transition contracts for every new scenario.
  - Add selected-alternate branch contracts for the current blocker scenarios.
- Modify: `native-ios/Tests/AppChromeTests.swift`
  - Update Browse category message expectations to mirror the five-scenario rows.
- Do not hand-edit generated resource files for this work unless a referenced ready phrase is missing from the current generated bundle and the source content is intentionally changed in the same task.

## Definition Of Done

- Every existing and new Messages scenario has 6-10 steps.
- Every visible option answers the immediately preceding local prompt.
- Every visible option has a selected local reply that acknowledges that exact option.
- Any option that changes the conversation path uses `nextStepID` to land on a coherent next prompt or skips to a close.
- All visible option text has exact bundled audio or intentionally falls back to an exact-audio catalog phrase.
- Every scenario reads end-to-end as a true conversation: a natural greeting/opening, the practical exchange, a gratitude or acknowledgment beat when the local person helps, and a clear goodbye or polite close.
- Each Messages category row has five scenarios:
  - Airport
  - Hotel
  - Food
  - Getting Around
  - Shopping
  - Emergency
  - Local Greetings
- No generated-only or planned-only phrases are used as visible choices.
- No lesson/quiz copy appears in Messages UI.
- Focused XCTest validation passes.
- Final review gate passes with two fresh read-only subagents. TASC is not complete until both agents approve every scenario and option. Any failed item loops back into edits and re-review.

---

### Task 1: Fix Current Resolver And Branch Drift

**Files:**
- Modify: `native-ios/App/Models/PracticeScenarioBuilder.swift`
- Test: `native-ios/Tests/PracticeScenarioModeTests.swift`

- [ ] **Step 1: Replace unresolved phrase IDs**

In `airport-wifi-charge`, replace the alternate page ID and message reply:

```swift
messageReply(
    "viet-family-phone-battery-dead",
    vietnamese: "Điện thoại tôi hết pin rồi",
    english: "My phone battery is dead",
    nextLocalLine: "Bạn có thể sạc ở cạnh quầy thông tin.",
    nextLocalMeaning: "You can charge beside the information desk."
)
```

In `hotel-wifi-checkout`, replace the late-checkout page ID with:

```swift
messageReply(
    "viet-family-hotel-late-checkout",
    vietnamese: "Tôi có thể trả phòng sau được không?",
    english: "Can I check out later?",
    nextLocalLine: "Tôi kiểm tra giúp bạn, thường có thể trả phòng trễ nếu còn phòng.",
    nextLocalMeaning: "I will check for you; late check-out is usually possible if a room is available."
)
```

- [ ] **Step 2: Fix the seven blocker conversations**

Use `nextStepID` and option-specific replies in these places:

```text
airportSimCash:
  ATM alternate -> nextStepID "airport-service-atm"
  information desk alternate -> nextStepID "airport-service-info-desk"

hotelWifiCheckout:
  checkout-time alternate from opening -> nextStepID "hotel-wifi-checkout"
  late-checkout alternate -> nextStepID "hotel-wifi-checkout"

danangDay:
  "No, thank you" snack alternate -> nextStepID "beach-vendor-goodbye"

shoppingMarketPrice:
  "No thank you / look around" style alternates -> nextStepID "shopping-market-goodbye"
  do not let a decline receive "Thank you for buying."

shoppingPayCard:
  QR/how-much/cash alternates -> route to QR/payment/receipt or close, not "This card did not work."

pharmacyHelp:
  If fever is selected in the opening, next prompt must not ask "Do you have a fever?" again.
  Non-fever choices in the fever step must answer with "No..." when the local prompt is yes/no.

localGreetingHotel:
  Replace "Wait for me five minutes" as a reply to "Please wait" with a traveler acknowledgment such as "Dạ, tôi chờ được."
```

- [ ] **Step 3: Add failing branch-coherence tests**

Add tests before implementation edits where practical:

```swift
func testSelectedAlternateBranchesDoNotDriftIntoWrongPrompt() throws {
    let snapshot = try PracticeScenarioBuilder.loadSnapshot(
        practicePageIDs: [],
        savedPageIDs: [],
        recentPageIDs: [],
        progressStore: isolatedProgressStore()
    )

    try assertSelectedReplyRoutes(
        snapshot,
        scenarioID: .airportSimCash,
        selectedStepID: "airport-service-opening",
        selectedEnglishFragment: "ATM",
        expectedNextStepID: "airport-service-atm",
        forbiddenNextLocalMeaningFragment: "regular SIM"
    )

    try assertSelectedReplyRoutes(
        snapshot,
        scenarioID: .danangDay,
        selectedStepID: "beach-vendor-snack",
        selectedEnglishFragment: "No, thank you",
        expectedNextStepID: "beach-vendor-goodbye",
        forbiddenNextLocalMeaningFragment: "spicy"
    )
}
```

Add the helper near existing transition helpers:

```swift
private func assertSelectedReplyRoutes(
    _ snapshot: PracticeScenarioDeckSnapshot,
    scenarioID: PracticeScenarioID,
    selectedStepID: String,
    selectedEnglishFragment: String,
    expectedNextStepID: String,
    forbiddenNextLocalMeaningFragment: String,
    file: StaticString = #filePath,
    line: UInt = #line
) throws {
    let scenario = try XCTUnwrap(snapshot.scenarios.first { $0.id == scenarioID }, file: file, line: line)
    let selectedStep = try XCTUnwrap(scenario.steps.first { $0.id == selectedStepID }, file: file, line: line)
    let selectedOption = try XCTUnwrap(
        selectedStep.responseOptions.first {
            $0.scenarioEnglish.localizedCaseInsensitiveContains(selectedEnglishFragment)
        },
        file: file,
        line: line
    )
    let nextStepID = selectedStep.nextStepID(after: selectedOption) ?? scenario.nextStep(after: selectedStep)?.id
    XCTAssertEqual(nextStepID, expectedNextStepID, file: file, line: line)
    let nextStep = try XCTUnwrap(scenario.steps.first { $0.id == expectedNextStepID }, file: file, line: line)
    XCTAssertFalse(
        nextStep.localLineMeaning.localizedCaseInsensitiveContains(forbiddenNextLocalMeaningFragment),
        file: file,
        line: line
    )
}
```

- [ ] **Step 4: Run focused tests**

Run:

```bash
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=SpeakLocal Messages' -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests
```

Expected: `PracticeScenarioModeTests` passes, or failures identify the next exact branch to fix.

---

### Task 2: Add One New Scenario Column Per Messages Row

**Files:**
- Modify: `native-ios/App/Models/PracticeScenarioModels.swift`
- Modify: `native-ios/App/Models/PracticeScenarioBuilder.swift`
- Test: `native-ios/Tests/PracticeScenarioModeTests.swift`
- Test: `native-ios/Tests/AppChromeTests.swift`

- [ ] **Step 1: Add seven new scenario IDs**

Add these enum cases after the related existing row cases:

```swift
case airportBaggageProblem
case hotelRoomSupplies
case foodMenuItems
case taxiFareComfort
case shoppingMarketProduce
case emergencyCallHelp
case localSmallTalk
```

- [ ] **Step 2: Add metadata for the seven scenarios**

Use these contact names and locations:

```text
airportBaggageProblem -> Baggage Problem / Lost luggage desk
hotelRoomSupplies -> Room Supplies / Hotel room
foodMenuItems -> Menu Items / Local restaurant
taxiFareComfort -> Fare & Comfort / In the taxi
shoppingMarketProduce -> Market Produce / Local market
emergencyCallHelp -> Call for Help / Help desk
localSmallTalk -> Small Talk / Everyday chat
```

Use section placement:

```text
Airport -> airportBaggageProblem contact rank 4
Hotel -> hotelRoomSupplies contact rank 4
Food -> foodMenuItems contact rank 4
Getting Around -> taxiFareComfort contact rank 4
Shopping -> shoppingMarketProduce contact rank 4
Emergency -> emergencyCallHelp contact rank 4
Local Greetings -> localSmallTalk contact rank 4
```

Use flow beats:

```text
Baggage problem: Missing bag, Damaged bag, Phone proof, Report
Room supplies: Towels, Soap, Charger, Laundry
Menu items: Dish, Utensils, Herbs, Drink
Fare and comfort: Fare, Meter, Bag, Air con
Market produce: Per kilo, Final price, Bag, Pay
Call for help: Ambulance, Manager, Hotel, Contact
Small talk: Hello, How are you, Busy, Goodbye
```

- [ ] **Step 3: Add the seven scenario templates**

Add templates in `PracticeScenarioBuilder.swift` beside their row peers. Each new scenario must use `messageScenarioStep` or `PracticeScenarioStepTemplate` with 6 steps including a goodbye step.

Use only these verified ready/audio-backed source IDs unless a better ready ID is checked live in SQLite first:

```text
Airport baggage problem:
  viet-family-v500-airp-bord-arri-my-suitcase-is-missing
  viet-family-v500-airp-bord-arri-my-bag-is-damaged
  viet-family-v500-airp-bord-arri-this-is-my-baggage-tag
  viet-family-v500-airp-bord-arri-can-i-show-it-on-my-phone
  viet-family-v500-prob-help-can-you-help-me

Hotel room supplies:
  viet-phrase-hotel-6
  viet-phrase-v500-hote-acco-can-i-have-more-soap
  viet-phrase-v500-phon-inte-powe-can-i-borrow-a-charger
  viet-phrase-v900-hote-acco-can-i-get-laundry-service
  viet-family-hotel-late-checkout

Food menu items:
  viet-family-food-coffee-bac-xiu
  viet-family-food-this-bowl
  viet-family-food-utensils
  viet-family-food-more-herbs
  viet-family-food-vegetarian

Taxi fare and comfort:
  viet-family-transport-fare
  viet-family-transport-meter
  viet-family-v500-tran-can-i-put-my-bag-here
  viet-family-transport-aircon
  viet-family-city-danang-place-dragon-bridge

Shopping market produce:
  viet-family-money-per-kilo
  viet-family-money-final-price
  viet-family-v500-shop-can-you-put-it-in-a-bag
  viet-family-food-vegetarian
  viet-family-food-pay-now

Emergency call help:
  viet-family-emergency-ambulance
  viet-family-help-manager
  viet-family-help-call-hotel
  viet-family-v500-prob-help-can-you-call-my-emergency-contact
  viet-family-v500-prob-help-can-you-help-me

Local small talk:
  viet-phrase-hello-chao-ban
  viet-family-social-how-are-you
  viet-family-polite-thank-you
  viet-thanks-khong-cam-on
  viet-goodbye
```

Before using any ID above, verify it resolves through `page_alias` or `phrase_page` and has `audio_status = ready`.

- [ ] **Step 4: Update group and row tests**

Update `testMessagesGroupFourThreadsForEachBrowseCategory` to:

```swift
func testMessagesGroupFiveThreadsForEachBrowseCategory() throws
```

Every section expectation should include five IDs. Update `AppChromeTests.testBrowseCategoryMessageSectionsMirrorMessagesHubGroups()` the same way.

- [ ] **Step 5: Update scenario coverage tests**

Update:

```text
testScenarioModeUsesAuthoredStarterStories
testTripFallbackIsBoundedToStarterScenarioCategories
testMessagesUseShortSituationNamesAndUnreadPreviews
testMessageScenarioScriptContractsProtectRiskyHumanFlow
testMessageScenarioTransitionsReadLikeContinuousConversations
testMessageAvatarsUseUniqueSceneSpecificArt
```

Add one `MessageScriptContract` and one `MessageTransitionContract` for each new scenario. Each contract must assert the first risky prompt, exact visible choices, forbidden wrong choices, and the expected next prompt after the best reply.

---

### Task 3: Hand-Check Every Existing Scenario And Option

**Files:**
- Modify: `native-ios/App/Models/PracticeScenarioBuilder.swift`
- Test: `native-ios/Tests/PracticeScenarioModeTests.swift`

- [ ] **Step 1: Review existing scenarios in row order**

Use this checklist for every step in every scenario:

```text
1. Does the local English prompt make clear what the local person said?
2. Does each visible option answer that exact prompt?
3. Does each option-specific local reply acknowledge the selected option?
4. If selected option changes the topic, does nextStepID route to a matching prompt or close?
5. Does the reread transcript still make sense without hidden scene narration?
6. Is the Vietnamese short, playable, and backed by an existing phrase/page?
7. Is the English chip natural English, not database or lesson phrasing?
8. Does the whole thread include a real conversational arc: greeting/opening, request/problem, local help, thanks/acknowledgment, and goodbye/close?
```

- [ ] **Step 2: Apply copy edits from the two reviews**

Use the conversational review labels:

```text
APPROVE: no copy change unless later tests fail.
EDIT: tighten chip English, add branch reply, or add nextStepID.
BLOCK: fix before expansion work is considered complete.
```

Do not use generated copy for visible new lines. Prefer existing catalog phrase text. If Vietnamese looks awkward but exact audio/catalog status is correct, preserve Vietnamese and improve only English readout/reply routing.

- [ ] **Step 3: Expand only where quality stays high**

Add extra visible choices only to prompts where the fourth option naturally answers the local prompt and has a specific follow-up. Do not add a fourth option to every prompt.

Good fourth-option targets:

```text
food/drink prompts -> drink nouns, utensils, herbs, vegetarian, this bowl
taxi prompts -> fare, meter, bag, air conditioning
hotel prompts -> towels, soap, charger, laundry, late checkout
shopping prompts -> per kilo, final price, bag, pay
emergency prompts -> ambulance, manager, call hotel, emergency contact
```

Bad fourth-option targets:

```text
yes/no prompts where the fourth option changes topic without branch routing
closing prompts
prompts already carrying three distinct beginner-safe choices
planned-only generated noun/action rows
```

- [ ] **Step 4: Fold greetings, gratitude, and goodbyes into real endings**

Use existing ready/audio-backed polite phrases where the conversation needs an actual social beat:

```text
Greeting/opening:
  viet-phrase-hello-chao-ban -> "Chào bạn" / "Hi there"
  viet-family-polite-acknowledge -> "Dạ" / "Okay"

Gratitude/acknowledgment:
  viet-family-polite-thank-you -> "Cảm ơn" / "Thank you"
  viet-phrase-polite-thank-you-polite -> "Cảm ơn nhiều" / "Thank you very much"
  viet-family-directions-understand-now -> "Cảm ơn, tôi hiểu rồi" / "Thanks, I understand now"

Declines and soft exits:
  viet-thanks-khong-cam-on -> "Không, cảm ơn" / "No, thank you"
  viet-phrase-v500-mone-numb-pric-no-thanks-maybe-later -> "Không, cảm ơn, có thể để sau" / "No thanks, maybe later"
  viet-phrase-v900-shop-no-thank-you-ill-look-around-first -> "Không, cảm ơn, tôi sẽ xem xét xung quanh trước" / "No thank you, I'll look around first"

Goodbye/close:
  viet-goodbye -> "Tạm biệt" / "Goodbye"
```

Do not force all four beats into every step. The whole scenario should feel complete by the end, and alternate decline/help paths should close naturally instead of receiving purchase-completion thanks.

---

### Task 4: Focused Validation

**Files:**
- Test: `native-ios/Tests/PracticeScenarioModeTests.swift`
- Test: `native-ios/Tests/AppChromeTests.swift`

- [ ] **Step 1: Run exact scenario tests**

Run:

```bash
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=SpeakLocal Messages' -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests
```

Expected: all `PracticeScenarioModeTests` pass.

- [ ] **Step 2: Run browse/message mirror tests**

Run:

```bash
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=SpeakLocal Messages' -only-testing:SpeakLocalNativeTests/AppChromeTests/testBrowseCategoryMessageSectionsMirrorMessagesHubGroups -only-testing:SpeakLocalNativeTests/AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy
```

Expected: both tests pass and category message rows mirror the five-scenario Messages hub rows.

- [ ] **Step 3: Run exact-audio and branch tests again after fixes**

Run:

```bash
xcodebuild test -project native-ios/SpeakLocalNative.xcodeproj -scheme SpeakLocalNative -destination 'platform=iOS Simulator,name=SpeakLocal Messages' -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests/testVisibleMessageChoicesUseExactBundledAudio -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests/testVisibleAlternateMessageChoicesHaveBranchReplies -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests/testMessageScenarioScriptContractsProtectRiskyHumanFlow -only-testing:SpeakLocalNativeTests/PracticeScenarioModeTests/testMessageScenarioTransitionsReadLikeContinuousConversations
```

Expected: all listed tests pass.

---

### Task 5: Mandatory Review Gate

**Files:**
- No edits unless a reviewer blocks an item.

- [ ] **Step 1: Dispatch two fresh read-only subagents**

Reviewer A: conversation/readability gate.

Prompt:

```text
Read-only review at current HEAD. Review every SpeakLocal Messages scenario, every step, every visible option, every selected local reply, and the reread transcript. Approve only if each option makes natural English sense in conversation and routes to a coherent next prompt. Return PASS only if every scenario passes. Otherwise return FAIL with exact scenario, step, option, and required edit.
```

Reviewer B: catalog/audio/noun gate.

Prompt:

```text
Read-only review at current HEAD. Review every SpeakLocal Messages scenario and visible option for phrase/catalog correctness. Verify every visible option resolves to an existing ready phrase/page or exact bundled audio, no planned-only generated rows are visible, and the new fifth scenario in each category row uses existing catalog nouns or phrases without slop. Return PASS only if every scenario passes. Otherwise return FAIL with exact scenario, step, option, and required edit.
```

- [ ] **Step 2: Apply review failures**

If either reviewer returns `FAIL`, edit the exact scenario/step/option, rerun focused tests, and redispatch the same review gate.

- [ ] **Step 3: Complete TASC only after pass**

TASC completion requires:

```text
Reviewer A: PASS
Reviewer B: PASS
PracticeScenarioModeTests: PASS
Message Browse mirror tests: PASS
git status --short: clean or only intentional final docs/code changes staged for commit
```

Do not mark TASC done from local judgment alone.

---

## Completion Notes

Final implementation expanded Messages from 28 to 35 authored scenarios, giving each of the seven Messages rows five conversations. The final gate passed only after reviewer-found issues were fixed:

- Reviewer A, conversational readability: PASS after the last local greetings and small-talk chip fixes.
- Reviewer B, catalog/audio/noun coverage: PASS with 35 scenarios, 7 rows x 5 conversations, and all visible options resolved to ready exact audio.
- Focused simulator validation: PASS for `PracticeScenarioModeTests`, `AppChromeTests/testBrowseCategoryMessageSectionsMirrorMessagesHubGroups`, and `AppChromeTests/testBrowseCollectionDescriptorsExposeStarterRowsAndMessagePolicy`.

Broader `SpeakLocalNativeTests` still has unrelated pre-existing content-library expectation failures around city-library counts and derived-place contextual titles; the Messages-focused suite and review gate are clean.
