import Foundation

enum AuthoredVietListingPages {
    private static let resource = AuthoredVietListingPageResource.load()

    static let all: [PhraseDetailPage] = uniquePages([repairMeaning] + resource.pages)

    static var bundledTierOneFamilyCount: Int {
        resource.metadata?.tierOneFamilyCount ?? 0
    }

    static var bundledMainPageCount: Int {
        resource.metadata?.resourceMainPageCount ?? 0
    }

    static var bundledChildPageCount: Int {
        resource.metadata?.childPageCount ?? 0
    }

    static var bundledPageIDs: Set<String> {
        Set(resource.pages.map(\.id))
    }

    static func categoryIDs(for pageID: String) -> [String]? {
        switch pageID {
        case repairMeaning.id:
            return ["understanding-repair", "repair"]
        case "viet-thank-you":
            return ["gratitude"]
        case "viet-excuse-sorry":
            return ["repair"]
        case "viet-goodbye":
            return ["goodbyes"]
        case "viet-how-are-you":
            return ["small-talk", "greetings"]
        default:
            return resource.categoryIDsByPageID[pageID]
        }
    }

    private static func uniquePages(_ pages: [PhraseDetailPage]) -> [PhraseDetailPage] {
        var seen = Set<String>()
        return pages.filter { page in
            seen.insert(page.id).inserted
        }
    }

    private static let repairMeaningWays: [PhraseOption] = [
        PhraseOption(
            id: "repair-meaning-standard",
            vietnamese: "Cái đó nghĩa là gì?",
            english: "What does that mean?",
            pronunciation: "gai doh ngee-ah lah zee",
            symbolName: "speaker.wave.2.fill",
            tintName: .blue,
            detailPageID: nil,
            audioKey: "repair-3"
        ),
        PhraseOption(
            id: "repair-meaning-this",
            vietnamese: "Cái này nghĩa là gì?",
            english: "What does this mean?",
            pronunciation: "gai nay ngee-ah lah zee",
            symbolName: "speaker.wave.2.fill",
            tintName: .blue,
            detailPageID: nil,
            audioKey: "audio-phrase-cai-nay-nghia-la-gi"
        ),
        PhraseOption(
            id: "repair-meaning-casual",
            vietnamese: "Nghĩa là sao?",
            english: "What do you mean? / How so?",
            pronunciation: "ngee-ah lah sao",
            symbolName: "speaker.wave.2.fill",
            tintName: .orange,
            detailPageID: nil,
            audioKey: "audio-phrase-nghia-la-sao"
        ),
        PhraseOption(
            id: "repair-meaning-intent",
            vietnamese: "Ý bạn là gì?",
            english: "What do you mean? / What is your point?",
            pronunciation: "ee ban lah zee",
            symbolName: "speaker.wave.2.fill",
            tintName: .purple,
            detailPageID: nil,
            audioKey: "audio-phrase-y-ban-la-gi"
        ),
        PhraseOption(
            id: "repair-meaning-word",
            vietnamese: "Từ này nghĩa là gì?",
            english: "What does this word mean?",
            pronunciation: "too nay ngee-ah lah zee",
            symbolName: "speaker.wave.2.fill",
            tintName: .green,
            detailPageID: nil,
            audioKey: "audio-phrase-tu-nay-nghia-la-gi"
        ),
        PhraseOption(
            id: "repair-meaning-polite",
            vietnamese: "Cho hỏi, cái này nghĩa là gì ạ?",
            english: "May I ask, what does this mean?",
            pronunciation: "cho hoy gai nay ngee-ah lah zee ah",
            symbolName: "speaker.wave.2.fill",
            tintName: .red,
            detailPageID: nil,
            audioKey: "audio-phrase-cho-hoi-cai-nay-nghia-la-gi-a"
        ),
    ]

    private static let repairMeaningPronounSwaps: [PhraseOption] = [
        PhraseOption(
            id: "repair-meaning-pronoun-anh",
            vietnamese: "Anh nói thế nghĩa là sao?",
            english: "To an older man: what do you mean by that?",
            pronunciation: "anh noy tay ngee-ah lah sao",
            symbolName: "speaker.wave.2.fill",
            tintName: .blue,
            detailPageID: nil,
            audioKey: "audio-phrase-anh-noi-the-nghia-la-sao"
        ),
        PhraseOption(
            id: "repair-meaning-pronoun-chi",
            vietnamese: "Chị nói thế nghĩa là sao?",
            english: "To an older woman: what do you mean by that?",
            pronunciation: "chee noy tay ngee-ah lah sao",
            symbolName: "speaker.wave.2.fill",
            tintName: .red,
            detailPageID: nil,
            audioKey: "audio-phrase-chi-noi-the-nghia-la-sao"
        ),
        PhraseOption(
            id: "repair-meaning-pronoun-em",
            vietnamese: "Em nói cái này nghĩa là gì?",
            english: "To someone younger: what does this mean?",
            pronunciation: "em noy gai nay ngee-ah lah zee",
            symbolName: "speaker.wave.2.fill",
            tintName: .green,
            detailPageID: nil,
            audioKey: "audio-phrase-em-noi-cai-nay-nghia-la-gi"
        ),
        PhraseOption(
            id: "repair-meaning-pronoun-em-soft",
            vietnamese: "Cái này nghĩa là gì vậy em?",
            english: "Softer, to someone younger: what does this mean?",
            pronunciation: "gai nay ngee-ah lah zee vay em",
            symbolName: "speaker.wave.2.fill",
            tintName: .teal,
            detailPageID: nil,
            audioKey: "audio-phrase-cai-nay-nghia-la-gi-vay-em"
        ),
    ]

    static let repairMeaning = PhraseDetailPage(
        id: "viet-family-repair-meaning",
        title: "Cái đó nghĩa là gì?",
        englishTitle: "What does that mean?",
        pronunciation: "gai doh ngee-ah lah zee",
        summary: "Different ways to ask what something means in Vietnam, from a simple word check to a polite clarification.",
        iconName: "questionmark.bubble.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(
                id: "at-glance",
                title: "At a glance",
                body: "Use this when Vietnamese stops making sense for a moment: a word, sign, menu item, receipt, text message, or sentence blocks you, and you need the other person to explain. The standard form is safe, but Vietnamese gives you softer, more casual, and more specific ways to ask.",
                presentation: .plainText
            ),
            PhraseDetailSection(
                id: "breakdown",
                title: "Break it down",
                body: "The phrase points at the thing first, then asks for its meaning. If the thing is nearby, swap Cái đó for Cái này.",
                breakdown: [
                    BreakdownToken(
                        id: "cai-do",
                        vietnamese: "Cái đó",
                        english: "that thing / that",
                        audioKey: "audio-breakdown-cai-do"
                    ),
                    BreakdownToken(
                        id: "nghia-la",
                        vietnamese: "nghĩa là",
                        english: "means",
                        audioKey: "audio-breakdown-nghia-la"
                    ),
                    BreakdownToken(
                        id: "gi",
                        vietnamese: "gì?",
                        english: "what?",
                        audioKey: "audio-breakdown-gi"
                    ),
                    BreakdownToken(
                        id: "full",
                        vietnamese: "Cái đó nghĩa là gì?",
                        english: "What does that mean?",
                        audioKey: "repair-3"
                    ),
                ],
                presentation: .breakdownStrip
            ),
            PhraseDetailSection(
                id: "standard-way",
                title: "The standard way",
                body: "Cái đó nghĩa là gì? works in most situations. It is clear, grammatical, and easy to pair with pointing. Use Cái này nghĩa là gì? when the word or object is right in front of you, like a menu item, sign, form, or message on your phone.",
                phrases: [
                    repairMeaningWays[0],
                    repairMeaningWays[1],
                ],
                presentation: .phraseList
            ),
            PhraseDetailSection(
                id: "natural-variations",
                title: "Natural variations",
                body: "Use these because not every kind of confusion is the same. Pick Nghĩa là sao? when a friend says something unclear, Ý bạn là gì? when the words are clear but the point is not, and Cho hỏi, cái này nghĩa là gì ạ? when you are asking a stranger or older adult.",
                phrases: [
                    repairMeaningWays[2],
                    repairMeaningWays[3],
                    repairMeaningWays[4],
                    repairMeaningWays[5],
                ],
                presentation: .horizontalPhraseCards
            ),
            PhraseDetailSection(
                id: "pronoun-swap",
                title: "Pronoun swap",
                body: "When you are asking about what a person said, Vietnamese often sounds warmer if you use the right relationship word instead of the all-purpose bạn. Keep your tone light so the question sounds curious, not confrontational.",
                phrases: repairMeaningPronounSwaps,
                presentation: .phraseList
            ),
            PhraseDetailSection(
                id: "when-to-use",
                title: "When to use it",
                body: "Use it while pointing at menus, forms, signs, receipts, warnings, instructions, app messages, or unfamiliar words someone writes down for you. If the answer is still unclear, follow with Bạn viết giúp tôi được không? so they can write it instead of repeating it faster.",
                presentation: .plainText
            ),
            PhraseDetailSection(
                id: "watch-out",
                title: "Watch out",
                body: "Ý bạn là gì? can sound defensive if it is said sharply, because it asks about the person's point or intent. Nghĩa là sao? is more casual, and Cho hỏi, cái này nghĩa là gì ạ? is softer with strangers, staff, or older adults.",
                presentation: .warningCallout
            ),
            PhraseDetailSection(
                id: "local-tip",
                title: "Local tip",
                body: "Pointing helps. Vietnamese tone marks can make a word hard to catch by ear, but a finger on the exact word or a phone screen gives the other person something concrete to explain.",
                presentation: .tipCallout
            ),
            PhraseDetailSection(
                id: "explore-next",
                title: "Explore next",
                body: "Use these next when the conversation needs one more step: slower speech, writing, English help, or a simple way to say you do not understand.",
                phrases: [
                    PhraseOption(
                        id: "repair-meaning-next-understand",
                        vietnamese: "Tôi không hiểu",
                        english: "I don't understand",
                        pronunciation: "toy khong hew",
                        symbolName: "speaker.wave.2.fill",
                        tintName: .blue,
                        detailPageID: "viet-family-repair-understand",
                        audioKey: "problems-2"
                    ),
                    PhraseOption(
                        id: "repair-meaning-next-write",
                        vietnamese: "Viết xuống giúp tôi",
                        english: "Please write it down",
                        pronunciation: "vyet zoong zoop toy",
                        symbolName: "speaker.wave.2.fill",
                        tintName: .blue,
                        detailPageID: "viet-family-repair-write-down",
                        audioKey: "repair-2"
                    ),
                    PhraseOption(
                        id: "repair-meaning-next-slower",
                        vietnamese: "Nói chậm chút được không?",
                        english: "Can you speak a little slower?",
                        pronunciation: "noy cham choot dook khong",
                        symbolName: "speaker.wave.2.fill",
                        tintName: .blue,
                        detailPageID: "viet-family-repair-slower",
                        audioKey: "problems-3"
                    ),
                    PhraseOption(
                        id: "repair-meaning-next-english",
                        vietnamese: "Anh/chị nói tiếng Anh không?",
                        english: "Do you speak English?",
                        pronunciation: "anh chee noy tyeng anh khong",
                        symbolName: "speaker.wave.2.fill",
                        tintName: .blue,
                        detailPageID: "viet-family-repair-english-help",
                        audioKey: "repair-english-help"
                    ),
                ],
                presentation: .phraseList
            ),
        ],
        examples: [
            repairMeaningWays[0],
        ],
        audioKey: "repair-3"
    )
}

private struct AuthoredVietListingPageResource {
    let metadata: Metadata?
    let pages: [PhraseDetailPage]
    let categoryIDsByPageID: [String: [String]]

    struct Metadata: Decodable {
        let tierOneFamilyCount: Int
        let resourceMainPageCount: Int
        let childPageCount: Int
    }

    static func load(bundle: Bundle = .main) -> AuthoredVietListingPageResource {
        guard let url = bundle.url(forResource: "viet-authored-listing-pages", withExtension: "json") else {
            return AuthoredVietListingPageResource(metadata: nil, pages: [], categoryIDsByPageID: [:])
        }

        do {
            let data = try Data(contentsOf: url)
            let decoded = try JSONDecoder().decode(BundleRecord.self, from: data)
            let pages = decoded.pages.map(\.phraseDetailPage)
            let categoryIDsByPageID = Dictionary(uniqueKeysWithValues: decoded.pages.map { page in
                (page.id, page.categoryIDs)
            })

            return AuthoredVietListingPageResource(
                metadata: decoded.metadata,
                pages: pages,
                categoryIDsByPageID: categoryIDsByPageID
            )
        } catch {
            assertionFailure("Unable to load authored Viet listing pages: \(error)")
            return AuthoredVietListingPageResource(metadata: nil, pages: [], categoryIDsByPageID: [:])
        }
    }
}

private struct BundleRecord: Decodable {
    let metadata: AuthoredVietListingPageResource.Metadata
    let pages: [PageRecord]
}

private struct PageRecord: Decodable {
    let id: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let summary: String
    let iconName: String
    let tintName: String
    let categoryIDs: [String]
    let sections: [SectionRecord]
    let examples: [PhraseRecord]
    let audioKey: String?

    var phraseDetailPage: PhraseDetailPage {
        PhraseDetailPage(
            id: id,
            title: title,
            englishTitle: englishTitle,
            pronunciation: pronunciation,
            summary: summary,
            iconName: iconName,
            tintName: AccentTint(rawValue: tintName) ?? .gray,
            sections: sections.map(\.phraseDetailSection),
            examples: examples.map(\.phraseOption),
            audioKey: audioKey
        )
    }
}

private struct SectionRecord: Decodable {
    let id: String
    let title: String
    let body: String
    let phrases: [PhraseRecord]?
    let breakdown: [BreakdownRecord]?
    let presentation: String?

    var phraseDetailSection: PhraseDetailSection {
        let decodedPresentation = presentation.flatMap(SectionPresentation.init(rawValue:))

        return PhraseDetailSection(
            id: id,
            title: title,
            body: body,
            phrases: phrases?.map(\.phraseOption) ?? [],
            breakdown: breakdown?.map(\.breakdownToken) ?? [],
            presentation: decodedPresentation ?? .automatic
        )
    }
}

private struct PhraseRecord: Decodable {
    let id: String
    let vietnamese: String
    let english: String
    let pronunciation: String
    let symbolName: String
    let tintName: String
    let detailPageID: String?
    let audioKey: String?

    var phraseOption: PhraseOption {
        PhraseOption(
            id: id,
            vietnamese: vietnamese,
            english: english,
            pronunciation: pronunciation,
            symbolName: symbolName,
            tintName: AccentTint(rawValue: tintName) ?? .gray,
            detailPageID: detailPageID,
            audioKey: audioKey
        )
    }
}

private struct BreakdownRecord: Decodable {
    let id: String
    let vietnamese: String
    let english: String
    let audioKey: String?

    var breakdownToken: BreakdownToken {
        BreakdownToken(
            id: id,
            vietnamese: vietnamese,
            english: english,
            audioKey: audioKey
        )
    }
}
