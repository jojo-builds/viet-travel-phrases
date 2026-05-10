import XCTest
@testable import SpeakLocalNative

final class PracticeScenarioModeTests: XCTestCase {
    func testStoryTranscriptStartsWithSceneLocalCueAndChoiceSet() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let firstStep = try XCTUnwrap(firstDay.steps.first)
        let turns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: 0,
            selectedOptionIDs: [:]
        )

        XCTAssertEqual(firstDay.id, .danangFirstDay)
        XCTAssertEqual(snapshot.starterScenario?.id, .danangFirstDay)
        XCTAssertEqual(turns.map(\.role), [.localSpeaker, .choiceSet])
        XCTAssertEqual(turns.first?.vietnamese, firstStep.localLine)
        XCTAssertFalse(firstStep.localLine.isEmpty)
        XCTAssertNil(turns.first { $0.role == .travelerReply })

        let choiceTurn = try XCTUnwrap(turns.first { $0.role == .choiceSet })
        XCTAssertGreaterThanOrEqual(choiceTurn.responseOptions.count, 2)
        XCTAssertLessThanOrEqual(choiceTurn.responseOptions.count, 3)
        XCTAssertTrue(choiceTurn.responseOptions.allSatisfy { !$0.scenarioVietnamese.isEmpty })
        XCTAssertFalse(choiceTurn.responseOptions.contains { option in
            option.candidate.pageID.contains("bathroom")
                || option.scenarioEnglish.localizedCaseInsensitiveContains("bathroom")
        })
    }

    func testStoryTranscriptAddsTravelerBubbleThenWaitsForLocalReplyAfterSend() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let firstStep = try XCTUnwrap(firstDay.steps.first)
        let selectedOption = try XCTUnwrap(firstStep.bestResponse)
        let waitingTurns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: 0,
            selectedOptionIDs: [firstStep.id: selectedOption.id]
        )

        XCTAssertEqual(waitingTurns.map(\.role), [.localSpeaker, .travelerReply, .localTyping])
        let travelerTurn = try XCTUnwrap(waitingTurns.first { $0.role == .travelerReply })
        XCTAssertEqual(travelerTurn.vietnamese, selectedOption.scenarioVietnamese)
        XCTAssertEqual(travelerTurn.english, selectedOption.scenarioEnglish)
        XCTAssertEqual(travelerTurn.source?.pageID, selectedOption.candidate.pageID)
        XCTAssertNil(waitingTurns.first { $0.role == .choiceSet })
        XCTAssertNil(waitingTurns.first { $0.role == .recovery })

        let repliedTurns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: 0,
            selectedOptionIDs: [firstStep.id: selectedOption.id],
            revealedReplyStepIDs: [firstStep.id]
        )

        XCTAssertEqual(repliedTurns.map(\.role), [.localSpeaker, .travelerReply, .localSpeaker])
        let localReply = repliedTurns[2]
        XCTAssertEqual(localReply.vietnamese, firstStep.nextLocalLine)
        XCTAssertFalse(firstStep.nextLocalLine.isEmpty)
    }

    func testStoryTranscriptIsContinuousConversationWithoutMomentSceneTurns() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let selectedOptionIDs = Dictionary(
            uniqueKeysWithValues: try firstDay.steps.map { step in
                let bestResponse = try XCTUnwrap(step.bestResponse)
                return (step.id, bestResponse.id)
            }
        )
        let turns = PracticeStoryTranscript.turns(
            for: firstDay,
            currentIndex: firstDay.steps.count - 1,
            selectedOptionIDs: selectedOptionIDs,
            revealedReplyStepIDs: Set(firstDay.steps.map(\.id))
        )

        XCTAssertFalse(turns.contains { $0.role == .scene })
        XCTAssertEqual(turns.first?.role, .localSpeaker)
        XCTAssertEqual(turns.first?.vietnamese, "Xin chào, bạn cần hỗ trợ gì ở sân bay?")
        XCTAssertGreaterThanOrEqual(turns.filter { $0.role == .travelerReply }.count, 6)
        XCTAssertGreaterThanOrEqual(turns.filter { $0.role == .localSpeaker }.count, 12)
    }

    func testEveryMessageScenarioBuildsOneContinuousSixToTenTurnConversation() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        for scenario in snapshot.scenarios {
            let selectedOptionIDs = Dictionary(
                uniqueKeysWithValues: try scenario.steps.map { step in
                    let bestResponse = try XCTUnwrap(step.bestResponse)
                    return (step.id, bestResponse.id)
                }
            )
            let turns = PracticeStoryTranscript.turns(
                for: scenario,
                currentIndex: scenario.steps.count - 1,
                selectedOptionIDs: selectedOptionIDs,
                revealedReplyStepIDs: Set(scenario.steps.map(\.id))
            )

            XCTAssertFalse(turns.contains { $0.role == .scene }, "\(scenario.id) should not show separate moment breaks.")
            XCTAssertEqual(turns.first?.role, .localSpeaker)
            XCTAssertTrue((6...10).contains(scenario.steps.count), "\(scenario.id) should stay short but conversational.")
            XCTAssertEqual(turns.filter { $0.role == .travelerReply }.count, scenario.steps.count)
            XCTAssertEqual(turns.filter { $0.role == .localSpeaker }.count, scenario.steps.count * 2)
            XCTAssertEqual(scenario.steps.first?.localLine, scenario.unreadPreview)
            XCTAssertTrue(scenario.steps.last?.id.hasSuffix("goodbye") ?? false)
        }
    }

    func testScenarioModeUsesAuthoredStarterStories() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        XCTAssertEqual(snapshot.scenarios.map(\.id), [
            .danangFirstDay,
            .hotelCheckInHelp,
            .taxiGrabPickup,
            .pharmacyHelp,
            .danangDay,
            .restaurantOrderingPayment,
        ])
        XCTAssertTrue(snapshot.scenarios.allSatisfy { $0.steps.count >= 6 })

        for scenario in snapshot.scenarios {
            XCTAssertFalse(scenario.sceneTitle.isEmpty)
            XCTAssertFalse(scenario.sceneSetup.isEmpty)
            XCTAssertGreaterThanOrEqual(scenario.id.flowBeats.count, 4)

            let openingStep = try XCTUnwrap(scenario.steps.first)
            XCTAssertTrue(openingStep.id.hasSuffix("opening"))
            XCTAssertTrue(openingStep.localLine.contains("Xin chào"))
            XCTAssertNotEqual(openingStep.bestResponse?.scenarioVietnamese, "Xin chào")
            XCTAssertFalse(openingStep.bestResponse?.scenarioVietnamese.isEmpty ?? true)

            let goodbyeStep = try XCTUnwrap(scenario.steps.last)
            XCTAssertTrue(goodbyeStep.id.hasSuffix("goodbye"))
            XCTAssertFalse(goodbyeStep.bestResponse?.scenarioVietnamese.isEmpty ?? true)
            XCTAssertEqual(goodbyeStep.nextStepTitle, "Finish story")
            XCTAssertTrue(
                goodbyeStep.visibleCopy.contains { $0.contains("Tạm biệt") || $0.contains("Cảm ơn") }
            )

            for step in scenario.steps {
                XCTAssertFalse(step.scene.isEmpty)
                XCTAssertFalse(step.recovery.title.isEmpty)
                XCTAssertFalse(step.recovery.body.isEmpty)
                XCTAssertGreaterThanOrEqual(step.responseOptions.count, 2)
                XCTAssertLessThanOrEqual(step.responseOptions.count, 4)
                if step.momentType == .listen {
                    XCTAssertFalse(step.localLine.isEmpty)
                    XCTAssertFalse(step.localLineMeaning.isEmpty)
                }
                XCTAssertTrue(step.responseOptions.allSatisfy { option in
                    option.candidate.pageID.hasPrefix("viet-phrase-")
                        || option.candidate.pageID.hasPrefix("viet-family-")
                })
                XCTAssertTrue(step.responseOptions.contains(where: \.isBestFit))
            }
        }
    }

    func testScenarioCopyAvoidsSchoolQuizAndIncorrectLanguage() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let visibleCopy = snapshot.visibleCopy.joined(separator: "\n").lowercased()

        let bannedPhrases = [
            "answer",
            "check fit",
            "correct",
            "good fit",
            "incorrect",
            "missed",
            "quiz",
            "phrase pages",
            "reply options",
            "review missed",
            "score",
            "source page",
            "trivia",
            "try saying",
            "wrong answer",
        ]

        for bannedPhrase in bannedPhrases {
            XCTAssertFalse(
                visibleCopy.contains(bannedPhrase),
                "Scenario Mode visible copy should not contain '\(bannedPhrase)'."
            )
        }
    }

    func testScenarioModeUsesContextReadyPhraseCopy() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        let firstDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        XCTAssertEqual(firstDay.sceneSetup, "Ask airport staff for baggage, pickup, driver help, water, and a polite close.")
        XCTAssertEqual(firstDay.id.flowBeats, ["Baggage", "Pickup", "Driver", "Water"])
        XCTAssertEqual(firstDay.steps.map(\.momentType), [.ask, .ask, .ask, .ask, .ask, .ask])
        let firstDayGreeting = try XCTUnwrap(firstDay.steps.first)
        XCTAssertEqual(firstDayGreeting.localPhrase.scenarioVietnamese, "Xin chào, bạn cần hỗ trợ gì ở sân bay?")
        XCTAssertEqual(firstDayGreeting.bestResponse?.scenarioVietnamese, "Lấy hành lý ở đâu?")
        let firstDayBaggage = try XCTUnwrap(firstDay.steps.dropFirst().first)
        XCTAssertEqual(firstDayBaggage.scene, "At baggage claim, you want to confirm the belt before waiting.")
        XCTAssertEqual(firstDayBaggage.bestResponse?.scenarioVietnamese, "Đây là thẻ hành lý của tôi")

        let hotel = try XCTUnwrap(snapshot.scenarios.first { $0.id == .hotelCheckInHelp })
        XCTAssertEqual(hotel.sceneSetup, "Greet the desk, check in, handle room basics, and say thanks.")
        XCTAssertEqual(hotel.id.flowBeats, ["Booking", "Passport", "Wi-Fi", "Room help"])
        XCTAssertEqual(hotel.steps.map(\.momentType), [.listen, .listen, .listen, .ask, .recovery, .ask, .ask])
        let hotelFirstStep = try XCTUnwrap(hotel.steps.dropFirst().first)
        XCTAssertEqual(hotelFirstStep.localPhrase.scenarioVietnamese, "Đặt phòng tên gì ạ?")
        XCTAssertEqual(hotelFirstStep.bestResponse?.scenarioVietnamese, "Tên đặt phòng là tên này")
        let hotelPassportStep = try XCTUnwrap(hotel.steps.dropFirst(2).first)
        XCTAssertEqual(hotelPassportStep.localPhrase.scenarioVietnamese, "Cho tôi xem hộ chiếu được không?")
        XCTAssertEqual(hotelPassportStep.bestResponse?.scenarioVietnamese, "Đây là hộ chiếu của tôi")

        let taxi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .taxiGrabPickup })
        XCTAssertEqual(taxi.sceneSetup, "Greet the driver, confirm the car, set the route, and close the ride.")
        XCTAssertEqual(taxi.id.flowBeats, ["Confirm car", "Pickup point", "Route", "Drop-off"])
        XCTAssertEqual(taxi.steps.map(\.momentType), [.listen, .listen, .ask, .ask, .ask, .ask])

        let pharmacy = try XCTUnwrap(snapshot.scenarios.first { $0.id == .pharmacyHelp })
        XCTAssertEqual(pharmacy.sceneSetup, "Greet, explain one symptom, understand the medicine, and say thanks.")
        XCTAssertEqual(pharmacy.id.flowBeats, ["Find help", "Symptoms", "Medicine", "Directions"])
        XCTAssertEqual(pharmacy.steps.map(\.momentType), [.listen, .ask, .listen, .ask, .ask, .ask])

        let danangDay = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangDay })
        XCTAssertEqual(danangDay.sceneSetup, "Buy water, ask for shade, choose a snack, understand the price, and close politely.")
        XCTAssertEqual(danangDay.id.flowBeats, ["Water", "Shade", "Snack", "Pay"])
        XCTAssertEqual(danangDay.steps.map(\.momentType), [.ask, .ask, .ask, .ask, .ask, .ask])
        XCTAssertTrue(danangDay.visibleCopy.contains("You walk up to a small stand by the beach and want to start with something easy."))
        XCTAssertFalse(danangDay.visibleCopy.joined(separator: "\n").localizedCaseInsensitiveContains("Dragon Bridge"))
        XCTAssertFalse(danangDay.visibleCopy.joined(separator: "\n").localizedCaseInsensitiveContains("get off"))

        let restaurant = try XCTUnwrap(snapshot.scenarios.first { $0.id == .restaurantOrderingPayment })
        XCTAssertEqual(restaurant.sceneSetup, "Greet the server, choose a table, order, ask for help, and pay.")
        XCTAssertEqual(restaurant.steps.map(\.momentType), [.listen, .ask, .listen, .ask, .listen, .ask, .ask])

        let visibleCopy = snapshot.visibleCopy.joined(separator: "\n")
        XCTAssertFalse(visibleCopy.contains("Jojo"))
        XCTAssertFalse(visibleCopy.localizedCaseInsensitiveContains("anh/chị"))
        XCTAssertFalse(visibleCopy.contains("Bạn là Jojo"))
        XCTAssertFalse(visibleCopy.contains("Cho tôi nhận phòng"))
    }

    func testRestaurantMenuQuestionOffersDirectBeginnerReplies() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let restaurant = try XCTUnwrap(snapshot.scenarios.first { $0.id == .restaurantOrderingPayment })
        let menuStep = try XCTUnwrap(restaurant.steps.first { $0.id == "restaurant-story-arrive" })

        XCTAssertEqual(menuStep.localLine, "Bạn muốn xem thực đơn không?")
        XCTAssertEqual(menuStep.localLineMeaning, "Would you like to see the menu?")
        XCTAssertEqual(
            Array(menuStep.responseOptions.prefix(3)).map(\.scenarioVietnamese),
            [
                "Dạ, cho tôi xem thực đơn",
                "Bạn đề xuất món gì?",
                "Không, cảm ơn",
            ]
        )
        XCTAssertEqual(
            Array(menuStep.responseOptions.prefix(3)).map(\.scenarioEnglish),
            [
                "Yes, the menu please",
                "What do you recommend?",
                "No, thank you",
            ]
        )
        XCTAssertEqual(menuStep.nextLocalLine, "Dạ, đây là thực đơn. Món này dễ ăn.")
        XCTAssertEqual(menuStep.nextLocalMeaning, "Yes, here is the menu. This dish is easy to eat.")
    }

    func testMessageScenarioChoicesStayCoherentWithPreviousBubble() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        let airport = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        assertTopReplies(
            airport,
            stepID: "airport-story-baggage-belt",
            vietnamese: [
                "Đây là thẻ hành lý của tôi",
                "Lấy hành lý ở đâu?",
                "Bạn giúp tôi được không?",
            ],
            english: [
                "Here is my baggage tag",
                "Where is baggage claim?",
                "Can you help me?",
            ]
        )

        let hotel = try XCTUnwrap(snapshot.scenarios.first { $0.id == .hotelCheckInHelp })
        assertTopReplies(
            hotel,
            stepID: "hotel-story-passport",
            vietnamese: [
                "Đây là hộ chiếu của tôi",
                "Đây là hộ chiếu của tôi để nhận phòng",
                "Đây là xác nhận đặt phòng",
            ],
            english: [
                "Here is my passport",
                "Here is my passport for check-in",
                "Here is my booking confirmation",
            ]
        )

        let taxi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .taxiGrabPickup })
        assertTopReplies(
            taxi,
            stepID: "taxi-story-opening",
            vietnamese: [
                "Dạ đúng rồi, bạn là tài xế của tôi à?",
                "Dạ, tôi đã đặt xe này",
            ],
            english: [
                "Yes, that's right. Are you my driver?",
                "Yes, I booked this ride",
            ]
        )
        assertTopReplies(
            taxi,
            stepID: "taxi-story-confirm-driver",
            vietnamese: [
                "Tôi đang ở cửa này",
                "Bạn đón tôi ở đây được không?",
                "Điểm đón ở đâu?",
            ],
            english: [
                "I'm at this entrance",
                "Can you pick me up here?",
                "Where is the pickup point?",
            ]
        )

        let beach = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangDay })
        assertTopReplies(
            beach,
            stepID: "beach-vendor-goodbye",
            vietnamese: [
                "Dạ, tính tiền giúp tôi",
                "Tôi quẹt thẻ được không?",
                "Tôi trả bằng tiền mặt",
            ],
            english: [
                "Yes, please let me pay",
                "Can I pay by card?",
                "I'll pay cash",
            ]
        )

        let restaurant = try XCTUnwrap(snapshot.scenarios.first { $0.id == .restaurantOrderingPayment })
        assertTopReplies(
            restaurant,
            stepID: "restaurant-story-opening",
            vietnamese: [
                "Cho tôi bàn cho hai người nhé",
                "Cho tôi bàn cho hai người",
                "Cho tôi xem thực đơn được không?",
            ],
            english: [
                "A table for two, please",
                "A table for two, please",
                "Can I see the menu?",
            ]
        )
        assertTopReplies(
            restaurant,
            stepID: "restaurant-story-ingredients",
            vietnamese: [
                "Không cay nhé",
                "Có đậu phộng không?",
                "Có thịt heo không?",
            ],
            english: [
                "Not spicy, please",
                "Does it have peanuts?",
                "Does it have pork?",
            ]
        )

        let pharmacy = try XCTUnwrap(snapshot.scenarios.first { $0.id == .pharmacyHelp })
        assertTopReplies(
            pharmacy,
            stepID: "pharmacy-story-find",
            vietnamese: [
                "Có, tôi bị sốt",
                "Không, tôi bị đau đầu",
                "Tôi đau bụng",
            ],
            english: [
                "Yes, I have a fever",
                "No, I have a headache",
                "My stomach hurts",
            ]
        )
        assertTopReplies(
            pharmacy,
            stepID: "pharmacy-story-medicine",
            vietnamese: [
                "Tôi uống thuốc này như thế nào?",
                "Uống bao nhiêu lần mỗi ngày?",
                "Tôi bị dị ứng thuốc này",
            ],
            english: [
                "How do I take this medicine?",
                "How many times per day should I take it?",
                "I am allergic to this medicine",
            ]
        )
    }

    func testPersonalQueuePriorityFeedsScenarioModeBeforeTripFallback() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let progressStore = isolatedProgressStore()
        let missedPageID = "viet-phrase-v500-tran-are-you-my-driver"
        let missedCandidate = try XCTUnwrap(
            repository.loadPracticeCandidates(pageIDs: [missedPageID], limit: 1).first
        )
        let missedPromptID = PracticePromptGenerator.stablePromptID(
            kind: .englishToVietnamese,
            candidate: missedCandidate
        )
        progressStore.record(promptID: missedPromptID, isCorrect: false)

        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: ["viet-phrase-hotel-2"],
            savedPageIDs: ["viet-phrase-food-1"],
            recentPageIDs: ["viet-phrase-taxi-1"],
            progressStore: progressStore
        )

        XCTAssertEqual(snapshot.rankedQueueSources.prefix(4), [
            .missedReview,
            .addedPractice,
            .savedRecent,
            .tripFallback,
        ])
        XCTAssertEqual(snapshot.primaryScenario?.queueSource, .missedReview)
        XCTAssertTrue(snapshot.scenarios.contains { $0.queueSource == .missedReview })
    }

    func testAddSavedAndRecentPagesFeedScenarioCandidates() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let requestedPageIDs = [
            "viet-family-hotel-reservation",
            "viet-family-food-pay-now",
            "viet-family-service-water",
        ]
        let expectedCanonicalPageIDs = Set(
            try requestedPageIDs.map { pageID in
                try repository.canonicalPageID(forPageIDOrAlias: pageID)
            }
        )
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: ["viet-family-hotel-reservation"],
            savedPageIDs: ["viet-family-food-pay-now"],
            recentPageIDs: ["viet-family-service-water"],
            progressStore: isolatedProgressStore()
        )
        let optionPageIDs = Set(snapshot.scenarios.flatMap { scenario in
            scenario.steps.flatMap { step in
                step.responseOptions.map(\.candidate.pageID)
            }
        })

        XCTAssertTrue(expectedCanonicalPageIDs.isSubset(of: optionPageIDs))
        XCTAssertGreaterThan(snapshot.queueCounts[.addedPractice, default: 0], 0)
        XCTAssertGreaterThan(snapshot.queueCounts[.savedRecent, default: 0], 0)
    }

    func testTripFallbackIsBoundedToStarterScenarioCategories() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        XCTAssertEqual(snapshot.loadedFallbackScenarioIDs, [
            .danangFirstDay,
            .hotelCheckInHelp,
            .taxiGrabPickup,
            .pharmacyHelp,
            .danangDay,
            .restaurantOrderingPayment,
        ])
        XCTAssertLessThanOrEqual(snapshot.loadedFallbackCandidateCount, 128)
    }

    func testMessagesUseShortSituationNamesAndUnreadPreviews() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        let namesByID = Dictionary(uniqueKeysWithValues: snapshot.scenarios.map { ($0.id, $0.id.messageContactName) })
        XCTAssertEqual(namesByID[.danangFirstDay], "Airport Baggage")
        XCTAssertEqual(namesByID[.hotelCheckInHelp], "Hotel Check-In")
        XCTAssertEqual(namesByID[.taxiGrabPickup], "Grab Pickup")
        XCTAssertEqual(namesByID[.pharmacyHelp], "Pharmacy Visit")
        XCTAssertEqual(namesByID[.danangDay], "Beach Chair")
        XCTAssertEqual(namesByID[.restaurantOrderingPayment], "Restaurant Table")

        for scenario in snapshot.scenarios {
            XCTAssertLessThanOrEqual(scenario.id.messageContactName.split(separator: " ").count, 3)
            XCTAssertEqual(scenario.unreadPreview, scenario.steps.first?.localLine)
            XCTAssertFalse(scenario.unreadPreview.isEmpty)
        }
    }

    func testMessageThreadProgressPersistsForReturnToThread() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let scenario = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let firstStep = try XCTUnwrap(scenario.steps.first)
        let secondStep = try XCTUnwrap(scenario.steps.dropFirst().first)
        let selectedOption = try XCTUnwrap(firstStep.bestResponse)
        let suiteName = "PracticeMessageThreadStoreTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        addTeardownBlock {
            defaults.removePersistentDomain(forName: suiteName)
        }

        var session = PracticeScenarioSession(scenario: scenario)
        session.selectedOptionIDs[firstStep.id] = selectedOption.id
        session.revealedReplyStepIDs.insert(firstStep.id)
        session.currentIndex = 1
        LocalPracticeMessageStore(defaults: defaults).save(session)

        let restoredStore = LocalPracticeMessageStore(defaults: defaults)
        let restoredSession = try XCTUnwrap(restoredStore.session(for: scenario))
        let restoredTurns = PracticeStoryTranscript.turns(
            for: restoredSession.scenario,
            currentIndex: restoredSession.currentIndex,
            selectedOptionIDs: restoredSession.selectedOptionIDs,
            revealedReplyStepIDs: restoredSession.revealedReplyStepIDs
        )

        XCTAssertEqual(restoredSession.currentIndex, 1)
        XCTAssertEqual(restoredSession.currentStep?.id, secondStep.id)
        XCTAssertEqual(restoredSession.selectedOptionIDs[firstStep.id], selectedOption.id)
        XCTAssertTrue(restoredSession.revealedReplyStepIDs.contains(firstStep.id))
        XCTAssertTrue(restoredTurns.contains { $0.role == .travelerReply && $0.vietnamese == selectedOption.scenarioVietnamese })
        XCTAssertTrue(restoredTurns.contains { $0.role == .choiceSet && $0.stepID == secondStep.id })
    }

    func testRepositoryLoadsPracticeCandidatesByCategory() throws {
        let repository = try VietSQLiteLanguagePackRepository.bundled()
        let candidates = try repository.loadPracticeCandidates(
            categoryIDs: ["transport"],
            limit: 12
        )

        XCTAssertFalse(candidates.isEmpty)
        XCTAssertLessThanOrEqual(candidates.count, 12)
        XCTAssertTrue(candidates.allSatisfy { $0.categoryIDs.contains("transport") })
    }

    private func isolatedProgressStore() -> LocalPracticeProgressStore {
        let suiteName = "PracticeScenarioModeTests.\(UUID().uuidString)"
        let defaults = UserDefaults(suiteName: suiteName)!
        defaults.removePersistentDomain(forName: suiteName)
        addTeardownBlock {
            defaults.removePersistentDomain(forName: suiteName)
        }
        return LocalPracticeProgressStore(defaults: defaults)
    }

    private func assertTopReplies(
        _ scenario: PracticeScenario,
        stepID: String,
        vietnamese: [String],
        english: [String],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let step = scenario.steps.first(where: { $0.id == stepID }) else {
            XCTFail("Missing step \(stepID)", file: file, line: line)
            return
        }

        let options = Array(step.responseOptions.prefix(vietnamese.count))
        XCTAssertEqual(options.map(\.scenarioVietnamese), vietnamese, file: file, line: line)
        XCTAssertEqual(options.map(\.scenarioEnglish), english, file: file, line: line)
    }
}
