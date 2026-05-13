import CoreGraphics
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
        XCTAssertLessThanOrEqual(choiceTurn.responseOptions.count, 4)
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

    func testStoryTranscriptContinuesWithTravelerChoiceAfterLocalReply() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let airportWifi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .airportWifiPower })
        let openingStep = try XCTUnwrap(airportWifi.steps.first { $0.id == "airport-wifi-opening" })
        let deskStep = try XCTUnwrap(airportWifi.steps.first { $0.id == "airport-wifi-desk" })
        let selectedOption = try XCTUnwrap(openingStep.bestResponse)

        let turns = PracticeStoryTranscript.turns(
            for: airportWifi,
            currentIndex: 1,
            selectedOptionIDs: [openingStep.id: selectedOption.id],
            revealedReplyStepIDs: [openingStep.id]
        )

        XCTAssertEqual(turns.map(\.role), [.localSpeaker, .travelerReply, .localSpeaker, .choiceSet])
        XCTAssertFalse(turns.contains { $0.role == .localSpeaker && $0.stepID == deskStep.id })

        let choiceTurn = try XCTUnwrap(turns.last { $0.role == .choiceSet && $0.stepID == deskStep.id })
        XCTAssertEqual(
            Array(choiceTurn.responseOptions.prefix(3)).map(\.scenarioEnglish),
            [
                "Where is the information desk?",
                "Thanks, I understand now",
                "Can you say it in a simpler way?",
            ]
        )
    }

    func testMessageThreadStartsAtTopBeforeFirstReply() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let airportWifi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .airportWifiPower })
        let freshSession = PracticeScenarioSession(scenario: airportWifi)

        XCTAssertEqual(
            PracticeStorySessionLayoutPolicy.startPosition(for: freshSession),
            .top
        )
        XCTAssertFalse(PracticeStorySessionLayoutPolicy.shouldScrollToBottomOnAppear(for: freshSession))
    }

    func testMessageThreadKeepsTopFlowAndScrollsToLatestTurnAfterConversationStarts() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let airportWifi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .airportWifiPower })
        let firstStep = try XCTUnwrap(airportWifi.steps.first)
        let firstReply = try XCTUnwrap(firstStep.bestResponse)
        var activeSession = PracticeScenarioSession(scenario: airportWifi)
        activeSession.selectedOptionIDs[firstStep.id] = firstReply.id
        activeSession.revealedReplyStepIDs.insert(firstStep.id)
        activeSession.currentIndex = 1

        XCTAssertEqual(
            PracticeStorySessionLayoutPolicy.startPosition(for: activeSession),
            .top
        )
        XCTAssertTrue(PracticeStorySessionLayoutPolicy.shouldScrollToBottomOnAppear(for: activeSession))
    }

    func testStoryTranscriptUsesCanonicalAudioForAdaptedMessageCopy() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let marketPrice = try XCTUnwrap(snapshot.scenarios.first { $0.id == .shoppingMarketPrice })
        let priceStep = try XCTUnwrap(marketPrice.steps.first { $0.id == "shopping-market-price" })
        let bestPriceOption = try XCTUnwrap(priceStep.bestResponse)

        XCTAssertEqual(bestPriceOption.scenarioVietnamese, "Giá tốt nhất là bao nhiêu?")
        XCTAssertEqual(bestPriceOption.candidate.vietnamese, "Giá tốt nhất của bạn là gì?")

        let audioKey = try XCTUnwrap(bestPriceOption.audioKey)
        XCTAssertTrue(AudioSpeakerButton.isPlayableAudioKey(audioKey))
        XCTAssertEqual(AudioAssetManifest.main?.entry(for: audioKey)?.text, bestPriceOption.candidate.vietnamese)

        let turns = PracticeStoryTranscript.turns(
            for: marketPrice,
            currentIndex: 1,
            selectedOptionIDs: [priceStep.id: bestPriceOption.id]
        )
        let travelerTurn = try XCTUnwrap(turns.first { $0.role == .travelerReply && $0.stepID == priceStep.id })
        XCTAssertEqual(travelerTurn.vietnamese, bestPriceOption.scenarioVietnamese)
        XCTAssertEqual(travelerTurn.playbackAudioKey, audioKey)
    }

    func testMessageScenarioOptionsSurfaceEveryAvailableCandidateAudio() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        for scenario in snapshot.scenarios {
            for step in scenario.steps {
                for option in step.responseOptions where option.candidate.playableAudioKey != nil {
                    let context = "\(scenario.id.rawValue) / \(step.id) / \(option.scenarioEnglish)"
                    let audioKey = try XCTUnwrap(option.audioKey, context)
                    XCTAssertTrue(AudioSpeakerButton.isPlayableAudioKey(audioKey), context)
                }
            }
        }
    }

    func testVisibleMessageChoicesUseBundledReadyAudio() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let manifest = try XCTUnwrap(AudioAssetManifest.main)
        var failures: [String] = []

        for scenario in snapshot.scenarios {
            for step in scenario.steps {
                for option in Array(step.responseOptions.prefix(4)) {
                    let context = "\(scenario.id.rawValue) / \(step.id) / \(option.scenarioEnglish)"
                    guard let audioKey = option.audioKey else {
                        failures.append("\(context) is missing an audio key")
                        continue
                    }

                    guard let entry = manifest.entry(for: audioKey) else {
                        failures.append("\(context) is missing manifest entry \(audioKey)")
                        continue
                    }

                    if !AudioSpeakerButton.isPlayableAudioKey(audioKey) {
                        failures.append("\(context) has non-playable audio key \(audioKey)")
                    }

                    if normalizedAudioText(entry.text) != normalizedAudioText(option.scenarioVietnamese)
                        && normalizedAudioText(entry.text) != normalizedAudioText(option.candidate.vietnamese) {
                        failures.append("\(context) uses audio for '\(entry.text)'")
                    }
                }
            }
        }

        XCTAssertTrue(failures.isEmpty, failures.joined(separator: "\n"))
    }

    func testStoryTranscriptAnswersTheSelectedMessageOption() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let airport = try XCTUnwrap(snapshot.scenarios.first { $0.id == .danangFirstDay })
        let baggageStep = try XCTUnwrap(airport.steps.first { $0.id == "airport-story-baggage-belt" })
        let luggageHelpOption = try XCTUnwrap(
            baggageStep.responseOptions.first { $0.scenarioEnglish == "I need to report lost luggage" }
        )

        let turns = PracticeStoryTranscript.turns(
            for: airport,
            currentIndex: 1,
            selectedOptionIDs: [baggageStep.id: luggageHelpOption.id],
            revealedReplyStepIDs: [baggageStep.id]
        )

        let replyTurn = try XCTUnwrap(turns.last { $0.role == .localSpeaker && $0.stepID == baggageStep.id })
        XCTAssertEqual(replyTurn.vietnamese, "Được, cho tôi xem thẻ hành lý nhé.")
        XCTAssertEqual(replyTurn.english, "Yes, show me your baggage tag.")
        XCTAssertNotEqual(replyTurn.english, "Belt 4 is on the left.")
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
        XCTAssertEqual(
            turns.filter { $0.role == .localSpeaker }.count,
            turns.filter { $0.role == .travelerReply }.count + 1
        )
        assertNoAdjacentLocalSpeakerTurns(in: turns)
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
            XCTAssertEqual(turns.filter { $0.role == .localSpeaker }.count, scenario.steps.count + 1)
            assertNoAdjacentLocalSpeakerTurns(in: turns)
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
            .airportPassportControl,
            .airportSimCash,
            .airportWifiPower,
            .hotelCheckInHelp,
            .hotelRoomHelp,
            .hotelBagsTaxi,
            .hotelWifiCheckout,
            .restaurantOrderingPayment,
            .danangDay,
            .foodAllergyHelp,
            .foodCoffeeOrder,
            .taxiGrabPickup,
            .taxiRouteHelp,
            .driverProblemHelp,
            .walkingDirectionsHelp,
            .shoppingMarketPrice,
            .shoppingSizeGift,
            .shoppingReceiptHelp,
            .shoppingPayCard,
            .pharmacyHelp,
            .emergencyLostPassport,
            .emergencyLostBag,
            .emergencyDoctorHelp,
            .localGreetingMarket,
            .localGreetingHotel,
            .localGreetingRespect,
            .localThanksSorry,
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
        XCTAssertEqual(hotelFirstStep.bestResponse?.scenarioVietnamese, "Đặt chỗ dưới tên này")
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

    func testMessagesGroupFourThreadsForEachBrowseCategory() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        let expectedGroups: [(String, [PracticeScenarioID], [String])] = [
            (
                "Airport",
                [.danangFirstDay, .airportPassportControl, .airportSimCash, .airportWifiPower],
                [
                    "Đây là hộ chiếu của tôi",
                    "Đây là visa của tôi",
                    "Tôi đến đây du lịch",
                    "Tôi sẽ ở năm ngày",
                    "Tôi có thể mua SIM địa phương ở đâu?",
                    "ATM ở đâu?",
                    "Bàn thông tin ở đâu?",
                    "Tôi có thể lấy Wi-Fi sân bay ở đâu?",
                    "Tôi có thể sạc điện thoại ở đâu?",
                    "Cảm ơn, tôi hiểu rồi",
                ]
            ),
            (
                "Hotel",
                [.hotelCheckInHelp, .hotelRoomHelp, .hotelBagsTaxi, .hotelWifiCheckout],
                [
                    "Thẻ phòng không dùng được",
                    "Máy lạnh không hoạt động",
                    "Nhà vệ sinh không hoạt động",
                    "Có ai lên sửa giúp tôi được không?",
                    "Tôi gửi hành lý được không?",
                    "Tôi lấy hành lý ở đâu?",
                    "Bạn đặt taxi giúp tôi được không?",
                    "Mật khẩu Wi-Fi là gì?",
                    "Mấy giờ trả phòng?",
                ]
            ),
            (
                "Food",
                [.restaurantOrderingPayment, .danangDay, .foodAllergyHelp, .foodCoffeeOrder],
                [
                    "Cho tôi bàn cho hai người nhé",
                    "Có nước suối không?",
                    "Cho tôi cà phê sữa đá",
                    "Tôi bị dị ứng đậu phộng",
                    "Hãy làm món này mà không cần đậu phộng",
                    "Món này có đậu phộng không?",
                    "Món nào không quá cay?",
                    "Ít đá thôi",
                    "Không đường",
                ]
            ),
            (
                "Getting Around",
                [.taxiGrabPickup, .taxiRouteHelp, .driverProblemHelp, .walkingDirectionsHelp],
                [
                    "Bạn là tài xế của tôi à?",
                    "Làm ơn đi theo bản đồ",
                    "Ứng dụng hiển thị tuyến đường khác",
                    "Vui lòng sử dụng giá trên ứng dụng Grab.",
                    "Biển số xe khác",
                    "Bạn gọi bảo vệ giúp tôi được không?",
                    "Tài xế đi mất rồi",
                    "Bàn thông tin gần nhất ở đâu?",
                    "Làm ơn nói lại",
                ]
            ),
            (
                "Shopping",
                [.shoppingMarketPrice, .shoppingSizeGift, .shoppingReceiptHelp, .shoppingPayCard],
                [
                    "Giá tốt nhất là bao nhiêu?",
                    "Bạn giảm giá cho tôi được không?",
                    "Bạn có cái nào rẻ hơn không?",
                    "Phòng thử đồ ở đâu?",
                    "Bạn có size nhỏ hơn không?",
                    "Cho tôi hóa đơn được không?",
                    "Bạn hoàn tiền giúp tôi được không?",
                    "Tôi quẹt thẻ được không?",
                    "Tôi thử thẻ khác được không?",
                ]
            ),
            (
                "Emergency",
                [.pharmacyHelp, .emergencyLostPassport, .emergencyLostBag, .emergencyDoctorHelp],
                [
                    "Tôi bị đau đầu",
                    "Hộ chiếu của tôi bị mất",
                    "Đồn công an gần nhất ở đâu?",
                    "Làm ơn cho tôi một bản sao báo cáo",
                    "Túi của tôi bị lấy mất",
                    "Bạn kiểm tra camera an ninh giúp tôi được không?",
                    "Khi nào tôi nên tìm kiếm sự giúp đỡ khẩn cấp?",
                    "Tôi cần bác sĩ",
                    "Tôi bị sốt",
                ]
            ),
            (
                "Local Greetings",
                [.localGreetingMarket, .localGreetingHotel, .localGreetingRespect, .localThanksSorry],
                [
                    "Chào bạn",
                    "Tôi đang vội",
                    "Chào anh",
                    "Chào chị",
                    "chào ông",
                    "chào bà",
                    "Con vào được không?",
                    "Xin lỗi",
                    "Không, cảm ơn",
                ]
            ),
        ]

        for (sectionTitle, expectedIDs, expectedVisiblePhrases) in expectedGroups {
            let sectionScenarios = snapshot.scenarios.filter { $0.id.messageSectionTitle == sectionTitle }
            XCTAssertEqual(sectionScenarios.map(\.id), expectedIDs)
            XCTAssertEqual(sectionScenarios.count, 4, "\(sectionTitle) should have exactly four message scenarios.")

            let visibleCopy = sectionScenarios.flatMap(\.visibleCopy).joined(separator: "\n")
            for phrase in expectedVisiblePhrases {
                XCTAssertTrue(
                    visibleCopy.contains(phrase),
                    "\(sectionTitle) should surface phrase '\(phrase)'."
                )
            }
        }
    }

    func testMessagesHubRowsReadAsScrollableCarouselOnPhoneWidth() {
        let viewportWidth: CGFloat = 390
        let contentColumnWidth = viewportWidth - (PracticeMessageHubLayout.rowViewportHorizontalBleed * 2)
        let fourthColumnFrame = PracticeMessageHubLayout.columnFrame(column: 3)

        XCTAssertGreaterThan(PracticeMessageHubLayout.avatarSize, 66)
        XCTAssertGreaterThan(PracticeMessageHubLayout.itemSpacing, 8)
        XCTAssertGreaterThan(PracticeMessageHubLayout.sectionSpacing, 18)
        XCTAssertEqual(PracticeMessageHubLayout.rowViewportHorizontalBleed, 20)
        XCTAssertEqual(PracticeMessageHubLayout.rowContentHorizontalInset, 21)
        XCTAssertEqual(PracticeMessageHubLayout.rowViewportWidth(contentColumnWidth: contentColumnWidth), viewportWidth)
        XCTAssertLessThan(fourthColumnFrame.minX, viewportWidth)
        XCTAssertGreaterThan(fourthColumnFrame.maxX, viewportWidth)
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
                "Tôi cần báo cáo hành lý thất lạc",
                "Bạn giúp tôi được không?",
            ],
            english: [
                "Here is my baggage tag",
                "I need to report lost luggage",
                "Can you help me?",
            ]
        )

        let passportControl = try XCTUnwrap(snapshot.scenarios.first { $0.id == .airportPassportControl })
        assertTopReplies(
            passportControl,
            stepID: "airport-passport-visa",
            vietnamese: [
                "Đây là visa của tôi",
                "Bạn nói đơn giản hơn được không?",
            ],
            english: [
                "Here is my visa",
                "Can you say it in a simpler way?",
            ]
        )

        let hotel = try XCTUnwrap(snapshot.scenarios.first { $0.id == .hotelCheckInHelp })
        assertTopReplies(
            hotel,
            stepID: "hotel-story-reservation",
            vietnamese: [
                "Đặt chỗ dưới tên này",
                "Tôi đặt phòng online, tên này",
                "Đây là tên đặt phòng",
            ],
            english: [
                "The reservation is under this name",
                "I booked online under this name",
                "Here is the reservation name",
            ]
        )
        assertTopReplies(
            hotel,
            stepID: "hotel-story-passport",
            vietnamese: [
                "Đây là hộ chiếu của tôi",
                "Đây là hộ chiếu của tôi để nhận phòng",
                "Tôi không có hộ chiếu",
            ],
            english: [
                "Here is my passport",
                "Here is my passport for check-in",
                "I do not have my passport",
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
                "Cho tôi bàn cho một người",
                "Cho tôi bàn cho bốn người",
            ],
            english: [
                "A table for two, please",
                "A table for one, please",
                "A table for four, please",
            ]
        )
        assertTopReplies(
            restaurant,
            stepID: "restaurant-story-ingredients",
            vietnamese: [
                "Không cay nhé",
                "Cái này có đậu phộng không?",
                "Tôi không ăn thịt lợn",
            ],
            english: [
                "Not spicy, please",
                "Does this have peanuts?",
                "I do not eat pork",
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

        let airportServices = try XCTUnwrap(snapshot.scenarios.first { $0.id == .airportSimCash })
        assertTopReplies(
            airportServices,
            stepID: "airport-service-wifi",
            vietnamese: [
                "Tôi có thể lấy Wi-Fi sân bay ở đâu?",
                "Tôi có thể sạc điện thoại ở đâu?",
                "Bàn thông tin ở đâu?",
            ],
            english: [
                "Where can I get airport Wi-Fi?",
                "Where can I charge my phone?",
                "Where is the information desk?",
            ]
        )

        let airportWifi = try XCTUnwrap(snapshot.scenarios.first { $0.id == .airportWifiPower })
        assertTopReplies(
            airportWifi,
            stepID: "airport-wifi-desk",
            vietnamese: [
                "Bàn thông tin ở đâu?",
                "Cảm ơn, tôi hiểu rồi",
                "Bạn nói đơn giản hơn được không?",
            ],
            english: [
                "Where is the information desk?",
                "Thanks, I understand now",
                "Can you say it in a simpler way?",
            ]
        )

        let roomHelp = try XCTUnwrap(snapshot.scenarios.first { $0.id == .hotelRoomHelp })
        assertTopReplies(
            roomHelp,
            stepID: "hotel-room-bathroom",
            vietnamese: [
                "Nhà vệ sinh không hoạt động",
                "Cửa không khóa",
                "Căn phòng có mùi khói",
            ],
            english: [
                "The toilet is not working",
                "The door does not lock",
                "The room smells like smoke",
            ]
        )

        let foodAllergy = try XCTUnwrap(snapshot.scenarios.first { $0.id == .foodAllergyHelp })
        assertTopReplies(
            foodAllergy,
            stepID: "food-allergy-kitchen-note",
            vietnamese: [
                "Hãy làm món này mà không cần đậu phộng",
                "Làm ơn làm cho nó bớt cay đi",
                "Tôi có thể có khăn ăn được không?",
            ],
            english: [
                "Please make it without peanuts",
                "Please make it less spicy",
                "Can I have napkins?",
            ]
        )

        let taxiRoute = try XCTUnwrap(snapshot.scenarios.first { $0.id == .taxiRouteHelp })
        assertTopReplies(
            taxiRoute,
            stepID: "taxi-route-app-price",
            vietnamese: [
                "Vui lòng sử dụng giá trên ứng dụng Grab.",
                "Tôi có thể thanh toán bằng chuyển khoản ngân hàng không?",
                "Hãy cho tôi biết khi nào nên xuống xe",
            ],
            english: [
                "Please use the price in the Grab app.",
                "Can I pay by bank transfer?",
                "Please tell me when to get off",
            ]
        )

        let marketPrice = try XCTUnwrap(snapshot.scenarios.first { $0.id == .shoppingMarketPrice })
        assertTopReplies(
            marketPrice,
            stepID: "shopping-market-cheaper",
            vietnamese: [
                "Bạn có cái nào rẻ hơn không?",
                "Bạn có thể biến nó thành một số tròn được không?",
                "Bạn có cái này màu đen không?",
            ],
            english: [
                "Do you have a cheaper one?",
                "Can you make it a round number?",
                "Do you have this in black?",
            ]
        )

        let lostBag = try XCTUnwrap(snapshot.scenarios.first { $0.id == .emergencyLostBag })
        assertTopReplies(
            lostBag,
            stepID: "emergency-bag-emergency-help",
            vietnamese: [
                "Khi nào tôi nên tìm kiếm sự giúp đỡ khẩn cấp?",
                "Tôi cần một nha sĩ",
                "Tôi cần thuốc chống muỗi",
            ],
            english: [
                "When should I seek emergency help?",
                "I need a dentist",
                "I need mosquito repellent",
            ]
        )

        let marketHello = try XCTUnwrap(snapshot.scenarios.first { $0.id == .localGreetingMarket })
        assertTopReplies(
            marketHello,
            stepID: "greeting-market-small-talk",
            vietnamese: [
                "Chào buổi sáng",
                "Không có gì",
                "Tôi đang vội",
            ],
            english: [
                "Good morning",
                "No problem",
                "I'm in a hurry",
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
            .airportPassportControl,
            .airportSimCash,
            .airportWifiPower,
            .hotelCheckInHelp,
            .hotelRoomHelp,
            .hotelBagsTaxi,
            .hotelWifiCheckout,
            .restaurantOrderingPayment,
            .danangDay,
            .foodAllergyHelp,
            .foodCoffeeOrder,
            .taxiGrabPickup,
            .taxiRouteHelp,
            .driverProblemHelp,
            .walkingDirectionsHelp,
            .shoppingMarketPrice,
            .shoppingSizeGift,
            .shoppingReceiptHelp,
            .shoppingPayCard,
            .pharmacyHelp,
            .emergencyLostPassport,
            .emergencyLostBag,
            .emergencyDoctorHelp,
            .localGreetingMarket,
            .localGreetingHotel,
            .localGreetingRespect,
            .localThanksSorry,
        ])
        XCTAssertLessThanOrEqual(snapshot.loadedFallbackCandidateCount, 420)
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
        XCTAssertEqual(namesByID[.airportPassportControl], "Passport Control")
        XCTAssertEqual(namesByID[.airportSimCash], "SIM & Cash")
        XCTAssertEqual(namesByID[.airportWifiPower], "Airport Wi-Fi")
        XCTAssertEqual(namesByID[.hotelCheckInHelp], "Hotel Check-In")
        XCTAssertEqual(namesByID[.hotelRoomHelp], "Room Help")
        XCTAssertEqual(namesByID[.hotelBagsTaxi], "Bags & Taxi")
        XCTAssertEqual(namesByID[.hotelWifiCheckout], "Hotel Wi-Fi")
        XCTAssertEqual(namesByID[.restaurantOrderingPayment], "Restaurant Table")
        XCTAssertEqual(namesByID[.danangDay], "Beach Snacks")
        XCTAssertEqual(namesByID[.foodAllergyHelp], "Food Allergies")
        XCTAssertEqual(namesByID[.foodCoffeeOrder], "Coffee Order")
        XCTAssertEqual(namesByID[.taxiGrabPickup], "Grab Pickup")
        XCTAssertEqual(namesByID[.taxiRouteHelp], "Taxi Route")
        XCTAssertEqual(namesByID[.driverProblemHelp], "Driver Help")
        XCTAssertEqual(namesByID[.walkingDirectionsHelp], "Walking Help")
        XCTAssertEqual(namesByID[.shoppingMarketPrice], "Market Price")
        XCTAssertEqual(namesByID[.shoppingSizeGift], "Gift & Size")
        XCTAssertEqual(namesByID[.shoppingReceiptHelp], "Receipt Help")
        XCTAssertEqual(namesByID[.shoppingPayCard], "Pay by Card")
        XCTAssertEqual(namesByID[.pharmacyHelp], "Pharmacy Visit")
        XCTAssertEqual(namesByID[.emergencyLostPassport], "Lost Passport")
        XCTAssertEqual(namesByID[.emergencyLostBag], "Lost Bag")
        XCTAssertEqual(namesByID[.emergencyDoctorHelp], "Doctor Help")
        XCTAssertEqual(namesByID[.localGreetingMarket], "Market Hello")
        XCTAssertEqual(namesByID[.localGreetingHotel], "Hotel Hello")
        XCTAssertEqual(namesByID[.localGreetingRespect], "Respectful Hello")
        XCTAssertEqual(namesByID[.localThanksSorry], "Thanks & Sorry")

        for scenario in snapshot.scenarios {
            XCTAssertLessThanOrEqual(scenario.id.messageContactName.split(separator: " ").count, 3)
            XCTAssertEqual(scenario.unreadPreview, scenario.steps.first?.localLine)
            XCTAssertFalse(scenario.unreadPreview.isEmpty)
        }
    }

    func testTopMessageChoicesDoNotDuplicateVisibleEnglish() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        for scenario in snapshot.scenarios {
            for step in scenario.steps {
                let topEnglish = Array(step.responseOptions.prefix(4)).map(\.scenarioEnglish)
                XCTAssertEqual(
                    Set(topEnglish).count,
                    topEnglish.count,
                    "\(scenario.id.rawValue) \(step.id) should not repeat the same visible reply."
                )
            }
        }
    }

    func testVisibleAlternateMessageChoicesHaveBranchReplies() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )

        for scenario in snapshot.scenarios {
            for step in scenario.steps {
                for option in Array(step.responseOptions.prefix(4)) where !option.isBestFit {
                    XCTAssertTrue(
                        option.hasSpecificLocalReply,
                        "\(scenario.id.rawValue) \(step.id) '\(option.scenarioEnglish)' should have a local reply for that selected message."
                    )
                }
            }
        }
    }

    func testMessageScenarioScriptContractsProtectRiskyHumanFlow() throws {
        let snapshot = try PracticeScenarioBuilder.loadSnapshot(
            practicePageIDs: [],
            savedPageIDs: [],
            recentPageIDs: [],
            progressStore: isolatedProgressStore()
        )
        let scenariosByID = Dictionary(uniqueKeysWithValues: snapshot.scenarios.map { ($0.id, $0) })

        let contracts: [MessageScriptContract] = [
            MessageScriptContract(
                scenarioID: .danangFirstDay,
                stepID: "airport-story-baggage-belt",
                localMeaning: "Can I see your baggage tag?",
                expectedTopEnglish: [
                    "Here is my baggage tag",
                    "I need to report lost luggage",
                    "Can you help me?",
                ],
                forbiddenTopEnglish: [
                    "Where is baggage claim?",
                    "Where is the Grab pickup point?",
                    "Here is my passport",
                ]
            ),
            MessageScriptContract(
                scenarioID: .airportPassportControl,
                stepID: "airport-passport-visa",
                localMeaning: "Do you have a visa?",
                expectedTopEnglish: [
                    "Here is my visa",
                    "Can you say it in a simpler way?",
                ],
                forbiddenTopEnglish: [
                    "Here is my passport",
                    "Here is my baggage tag",
                ]
            ),
            MessageScriptContract(
                scenarioID: .airportSimCash,
                stepID: "airport-service-sim-type",
                localMeaning: "Do you need a regular SIM or an eSIM?",
                expectedTopEnglish: [
                    "I need a SIM card with data",
                    "I need an eSIM",
                    "How much is this?",
                ],
                forbiddenTopEnglish: [
                    "Where is the ATM?",
                    "Where is the Grab pickup point?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .airportWifiPower,
                stepID: "airport-wifi-charge",
                localMeaning: "Is your phone almost out of battery?",
                expectedTopEnglish: [
                    "Where can I charge my phone?",
                    "Mobile data is not working",
                ],
                forbiddenTopEnglish: [
                    "Here is my passport",
                    "Can I have a receipt?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .hotelCheckInHelp,
                stepID: "hotel-story-reservation",
                localMeaning: "What name is the reservation under?",
                expectedTopEnglish: [
                    "The reservation is under this name",
                    "I booked online under this name",
                    "Here is the reservation name",
                ],
                forbiddenTopEnglish: [
                    "Yes, I have a reservation",
                    "Here is my passport",
                ]
            ),
            MessageScriptContract(
                scenarioID: .hotelRoomHelp,
                stepID: "hotel-room-opening",
                localMeaning: "Hello, what problem does your room have?",
                expectedTopEnglish: [
                    "The key card is not working",
                    "The door does not lock",
                    "I lost my room key",
                ],
                forbiddenTopEnglish: [
                    "What is the Wi-Fi password?",
                    "Can I leave my luggage here?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .hotelBagsTaxi,
                stepID: "hotel-bags-pickup",
                localMeaning: "Do you need to know where to pick up your luggage later?",
                expectedTopEnglish: [
                    "Where can I pick up my luggage?",
                    "What time is okay?",
                    "How long will it take?",
                ],
                forbiddenTopEnglish: [
                    "Can I leave my bags until check-in?",
                    "Please call a car for me",
                ]
            ),
            MessageScriptContract(
                scenarioID: .hotelWifiCheckout,
                stepID: "hotel-wifi-checkout",
                localMeaning: "Do you need the check-out time?",
                expectedTopEnglish: [
                    "What time is check-out?",
                    "What time is okay?",
                ],
                forbiddenTopEnglish: [
                    "Can I leave my bags until check-in?",
                    "The AC is not working",
                ]
            ),
            MessageScriptContract(
                scenarioID: .restaurantOrderingPayment,
                stepID: "restaurant-story-server-ready",
                localMeaning: "What would you like?",
                expectedTopEnglish: [
                    "One portion of this, please",
                    "I'd like a banh mi, please",
                    "What do you recommend?",
                ],
                forbiddenTopEnglish: [
                    "Can I see the menu?",
                    "The bill, please",
                ]
            ),
            MessageScriptContract(
                scenarioID: .danangDay,
                stepID: "beach-vendor-chair",
                localMeaning: "Do you need a chair and umbrella?",
                expectedTopEnglish: [
                    "Yes, a chair and umbrella, please",
                    "How much are the chair and umbrella?",
                    "Do you have sunscreen?",
                ],
                forbiddenTopEnglish: [
                    "A bottle of water please",
                    "Where is baggage claim?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .foodAllergyHelp,
                stepID: "food-allergy-peanuts",
                localMeaning: "Do you have any allergies?",
                expectedTopEnglish: [
                    "I am allergic to peanuts",
                    "Does this contain peanuts?",
                    "I am allergic to shellfish",
                ],
                forbiddenTopEnglish: [
                    "Less ice, please",
                    "One portion of this, please",
                ]
            ),
            MessageScriptContract(
                scenarioID: .foodCoffeeOrder,
                stepID: "coffee-order-ice",
                localMeaning: "Would you like less ice or less sugar?",
                expectedTopEnglish: [
                    "Less ice, please",
                    "No sugar, please",
                    "Less sugar, please",
                ],
                forbiddenTopEnglish: [
                    "I am allergic to peanuts",
                    "Can I see your passport?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .taxiGrabPickup,
                stepID: "taxi-story-confirm-driver",
                localMeaning: "Which entrance are you at?",
                expectedTopEnglish: [
                    "I'm at this entrance",
                    "Can you pick me up here?",
                    "Where is the pickup point?",
                ],
                forbiddenTopEnglish: [
                    "Where is baggage claim?",
                    "Here is my passport",
                ]
            ),
            MessageScriptContract(
                scenarioID: .taxiRouteHelp,
                stepID: "taxi-route-different",
                localMeaning: "This road has a little traffic.",
                expectedTopEnglish: [
                    "The app shows a different route",
                    "Are we going the right way?",
                    "This is the wrong address",
                ],
                forbiddenTopEnglish: [
                    "Where is the fitting room?",
                    "Can I leave my luggage here?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .driverProblemHelp,
                stepID: "driver-problem-safety",
                localMeaning: "Would you like to wait near security?",
                expectedTopEnglish: [
                    "Can you call security?",
                    "Please stay with me",
                    "Please stay near me",
                ],
                forbiddenTopEnglish: [
                    "Please stop right here",
                    "Where is the ATM?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .walkingDirectionsHelp,
                stepID: "walking-help-repeat",
                localMeaning: "Do you understand?",
                expectedTopEnglish: [
                    "Please say that again",
                    "Can you speak a little slower?",
                    "Can you help me?",
                ],
                forbiddenTopEnglish: [
                    "Can I pay by card?",
                    "I need a doctor",
                ]
            ),
            MessageScriptContract(
                scenarioID: .shoppingMarketPrice,
                stepID: "shopping-market-discount",
                localMeaning: "Is this price okay?",
                expectedTopEnglish: [
                    "Can you give me a discount?",
                    "Can you lower the price?",
                    "That is too expensive",
                ],
                forbiddenTopEnglish: [
                    "Where is the fitting room?",
                    "Can I have a receipt?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .shoppingSizeGift,
                stepID: "shopping-gift-size",
                localMeaning: "Does this size fit yet?",
                expectedTopEnglish: [
                    "Do you have a smaller size?",
                    "Do you have a larger size?",
                    "I want this size",
                ],
                forbiddenTopEnglish: [
                    "Can I have a receipt?",
                    "The payment went through",
                ]
            ),
            MessageScriptContract(
                scenarioID: .shoppingReceiptHelp,
                stepID: "shopping-receipt-final",
                localMeaning: "The payment is done; please check the receipt.",
                expectedTopEnglish: [
                    "The payment went through",
                    "This receipt is not mine",
                    "Is tax included?",
                ],
                forbiddenTopEnglish: [
                    "Can you give me a discount?",
                    "Do you have a smaller size?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .shoppingPayCard,
                stepID: "pay-card-retry",
                localMeaning: "This card did not work.",
                expectedTopEnglish: [
                    "Can I try another card?",
                    "Can I pay by card?",
                    "Can you help me?",
                ],
                forbiddenTopEnglish: [
                    "Do you have a smaller size?",
                    "I need a doctor",
                ]
            ),
            MessageScriptContract(
                scenarioID: .pharmacyHelp,
                stepID: "pharmacy-story-symptom",
                localMeaning: "Are you allergic to any medicine?",
                expectedTopEnglish: [
                    "No, I am not allergic to medicine",
                    "I am allergic to this medicine",
                    "I need a clinic",
                ],
                forbiddenTopEnglish: [
                    "I will pay now",
                    "Can I have a receipt?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .emergencyLostPassport,
                stepID: "emergency-passport-embassy",
                localMeaning: "Have you contacted the embassy yet?",
                expectedTopEnglish: [
                    "Please help me contact my embassy",
                    "Where is the nearest embassy?",
                    "I need the embassy",
                ],
                forbiddenTopEnglish: [
                    "Where is the police station?",
                    "Can you check the security camera?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .emergencyLostBag,
                stepID: "emergency-bag-camera",
                localMeaning: "Do you want us to check the camera in this area?",
                expectedTopEnglish: [
                    "Can you check the security camera?",
                    "This is what happened",
                    "Please write down your name",
                ],
                forbiddenTopEnglish: [
                    "Please help me contact my embassy",
                    "Where is the nearest embassy?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .emergencyDoctorHelp,
                stepID: "doctor-help-symptom",
                localMeaning: "What is wrong?",
                expectedTopEnglish: [
                    "I have a fever",
                    "I have a headache",
                    "My stomach hurts",
                ],
                forbiddenTopEnglish: [
                    "Can I pay by card?",
                    "Where is the fitting room?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .localGreetingMarket,
                stepID: "greeting-market-thanks",
                localMeaning: "Do you need me to hold this item?",
                expectedTopEnglish: [
                    "Thank you",
                    "No thanks, maybe later",
                    "No problem",
                ],
                forbiddenTopEnglish: [
                    "Can you give me a discount?",
                    "Do you have a smaller size?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .localGreetingHotel,
                stepID: "greeting-hotel-sorry",
                localMeaning: "Did you hear clearly?",
                expectedTopEnglish: [
                    "Please say that again",
                    "Could you speak a little slower, please?",
                    "Sorry",
                ],
                forbiddenTopEnglish: [
                    "Excuse me",
                    "I'm very sorry",
                ]
            ),
            MessageScriptContract(
                scenarioID: .localGreetingRespect,
                stepID: "greeting-respect-woman",
                localMeaning: "Hello, what would you like to ask?",
                expectedTopEnglish: [
                    "Hello, ma'am. Can you help me?",
                    "Hello, ma'am. I want to ask something",
                    "Hello, auntie. Can you help me?",
                ],
                forbiddenTopEnglish: [
                    "Hello to an older woman",
                    "Can I sit here?",
                ]
            ),
            MessageScriptContract(
                scenarioID: .localThanksSorry,
                stepID: "thanks-sorry-apology",
                localMeaning: "It's okay.",
                expectedTopEnglish: [
                    "Sorry",
                    "No problem",
                    "Thank you",
                ],
                forbiddenTopEnglish: [
                    "Can I pay by card?",
                    "Where is the hospital?",
                ]
            ),
        ]

        XCTAssertEqual(contracts.count, PracticeScenarioID.allCases.count)

        for contract in contracts {
            let scenario = try XCTUnwrap(
                scenariosByID[contract.scenarioID],
                "Missing scenario \(contract.scenarioID.rawValue)"
            )
            assertMessageScriptContract(contract, in: scenario)
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

    private func assertNoAdjacentLocalSpeakerTurns(
        in turns: [PracticeStoryTurn],
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let roles = turns.map(\.role)
        for index in roles.indices.dropFirst() {
            XCTAssertFalse(
                roles[index - 1] == .localSpeaker && roles[index] == .localSpeaker,
                "Transcript should not show two local-speaker bubbles in a row.",
                file: file,
                line: line
            )
        }
    }

    private struct MessageScriptContract {
        let scenarioID: PracticeScenarioID
        let stepID: String
        let localMeaning: String
        let expectedTopEnglish: [String]
        let forbiddenTopEnglish: [String]
    }

    private func assertMessageScriptContract(
        _ contract: MessageScriptContract,
        in scenario: PracticeScenario,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        guard let step = scenario.steps.first(where: { $0.id == contract.stepID }) else {
            XCTFail("Missing step \(contract.stepID)", file: file, line: line)
            return
        }

        XCTAssertEqual(step.localLineMeaning, contract.localMeaning, file: file, line: line)

        let visibleOptions = Array(step.responseOptions.prefix(3))
        let visibleEnglish = visibleOptions.map(\.scenarioEnglish)
        XCTAssertEqual(
            visibleEnglish,
            contract.expectedTopEnglish,
            "\(scenario.id.rawValue) \(step.id) visible choices should match the local prompt.",
            file: file,
            line: line
        )

        for forbidden in contract.forbiddenTopEnglish {
            XCTAssertFalse(
                visibleEnglish.contains(forbidden),
                "\(scenario.id.rawValue) \(step.id) should not show '\(forbidden)' for '\(contract.localMeaning)'.",
                file: file,
                line: line
            )
        }

        for option in visibleOptions {
            XCTAssertTrue(
                step.hasLocalReply(after: option),
                "\(scenario.id.rawValue) \(step.id) '\(option.scenarioEnglish)' should produce a local reply that follows from the chosen message.",
                file: file,
                line: line
            )
        }
    }

    private func normalizedAudioText(_ value: String) -> String {
        value
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()
            .trimmingCharacters(in: CharacterSet(charactersIn: ".。!?！？"))
    }
}
