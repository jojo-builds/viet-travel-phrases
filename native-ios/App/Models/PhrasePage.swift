import Foundation

struct PhrasePage: Identifiable, Equatable {
    let id: String
    let destination: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let intentSummary: String
    let atGlance: String
    let quickSay: [PhraseOption]
    let situationalGreetingsLeadIn: String
    let situationalGreetings: [PhraseOption]
    let localGreetingsLeadIn: String
    let localGreetings: [PhraseOption]
    let breakdown: [BreakdownToken]
    let followUpsLeadIn: String
    let followUps: [PhraseOption]
    let culturalNote: String
    let exploreNext: [PhraseLink]

    var sectionTitles: [String] {
        [
            "At a glance",
            "Quick say",
            "Break it down",
            "Situational greetings",
            "How locals actually greet",
            "Common follow-ups",
            "Cultural note",
            "Explore next",
        ]
    }
}

struct PhraseOption: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    let pronunciation: String
    let symbolName: String
    let tintName: AccentTint
    var detailPageID: String?
}

struct BreakdownToken: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
}

struct PhraseLink: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    let relation: String
    let symbolName: String
    let tintName: AccentTint
    var detailPageID: String?
}

struct PhraseDetailPage: Identifiable, Equatable {
    let id: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let summary: String
    let iconName: String
    let tintName: AccentTint
    let sections: [PhraseDetailSection]
    let examples: [PhraseOption]
}

struct PhraseDetailSection: Identifiable, Equatable {
    let id: String
    let title: String
    let body: String
    var phrases: [PhraseOption] = []
    var breakdown: [BreakdownToken] = []
}

enum AccentTint: String, Equatable {
    case red
    case orange
    case green
    case blue
    case purple
    case teal
    case gray
}

extension PhrasePage {
    static let xinChao = PhrasePage(
        id: "viet-polite-hello",
        destination: "SpeakLocal Vietnam",
        title: "Xin chào",
        englishTitle: "Hello",
        pronunciation: "sin chow",
        intentSummary: "Hello (universal greeting)",
        atGlance: "For travelers, Xin chào is the safest hello. In everyday Vietnamese, greetings often depend on age, gender, and relationship, so the next step is learning when to use chào plus a relationship word.",
        quickSay: [
            PhraseOption(
                id: "polite-1",
                vietnamese: "Xin chào",
                english: "Hello / polite hello",
                pronunciation: "sin chow",
                symbolName: "speaker.wave.2.fill",
                tintName: .red,
                detailPageID: nil
            ),
            PhraseOption(
                id: "polite-5",
                vietnamese: "Chào",
                english: "Hi / hello (casual)",
                pronunciation: "chow",
                symbolName: "speaker.wave.2.fill",
                tintName: .orange,
                detailPageID: nil
            ),
        ],
        situationalGreetingsLeadIn: "Use these when the setting is more specific: a friend, a respectful adult, a phone call, or a time-of-day greeting.",
        situationalGreetings: [
            PhraseOption(
                id: "friend",
                vietnamese: "Chào bạn",
                english: "Hi, friend",
                pronunciation: "chow ban",
                symbolName: "person.2",
                tintName: .orange,
                detailPageID: "viet-local-greetings"
            ),
            PhraseOption(
                id: "formal",
                vietnamese: "Dạ, chào anh/chị",
                english: "Hello, formal and respectful",
                pronunciation: "yah chow anh chee",
                symbolName: "person.2.fill",
                tintName: .red,
                detailPageID: "viet-respectful-hello"
            ),
            PhraseOption(
                id: "phone",
                vietnamese: "Alô",
                english: "Hello on the phone",
                pronunciation: "ah-lo",
                symbolName: "phone",
                tintName: .green,
                detailPageID: "viet-phone-hello"
            ),
            PhraseOption(
                id: "morning",
                vietnamese: "Chào buổi sáng",
                english: "Good morning",
                pronunciation: "chow boo-ee sahng",
                symbolName: "sun.max",
                tintName: .blue,
                detailPageID: "viet-time-greetings"
            ),
            PhraseOption(
                id: "afternoon",
                vietnamese: "Chào buổi chiều",
                english: "Good afternoon",
                pronunciation: "chow boo-ee chee-ew",
                symbolName: "sun.horizon",
                tintName: .purple,
                detailPageID: "viet-time-greetings"
            ),
        ],
        localGreetingsLeadIn: "This is the most local pattern. Pick the relationship word when the person’s role is clear; stay with Xin chào when you are unsure.",
        localGreetings: [
            PhraseOption(id: "anh", vietnamese: "Chào anh", english: "Hello, older brother / slightly older man", pronunciation: "chow anh", symbolName: "person", tintName: .blue, detailPageID: "viet-hello-anh"),
            PhraseOption(id: "chi", vietnamese: "Chào chị", english: "Hello, older sister / slightly older woman", pronunciation: "chow chee", symbolName: "person", tintName: .red, detailPageID: "viet-hello-chi"),
            PhraseOption(id: "em", vietnamese: "Chào em", english: "Hello, younger sibling / someone younger", pronunciation: "chow em", symbolName: "person", tintName: .green, detailPageID: "viet-hello-em"),
            PhraseOption(id: "ong", vietnamese: "Chào ông", english: "Hello, grandfather / elderly man", pronunciation: "chow ohm", symbolName: "person", tintName: .purple, detailPageID: "viet-hello-ong"),
            PhraseOption(id: "ba", vietnamese: "Chào bà", english: "Hello, grandmother / elderly woman", pronunciation: "chow bah", symbolName: "person", tintName: .red, detailPageID: "viet-hello-ba"),
            PhraseOption(id: "chu", vietnamese: "Chào chú", english: "Hello, uncle / older man", pronunciation: "chow choo", symbolName: "person", tintName: .teal, detailPageID: "viet-hello-chu"),
            PhraseOption(id: "co", vietnamese: "Chào cô", english: "Hello, aunt / older woman", pronunciation: "chow koh", symbolName: "person", tintName: .red, detailPageID: "viet-hello-co"),
        ],
        breakdown: [
            BreakdownToken(id: "xin", vietnamese: "Xin", english: "polite ask"),
            BreakdownToken(id: "chao", vietnamese: "chào", english: "greet / hello"),
            BreakdownToken(id: "full", vietnamese: "Xin chào", english: "polite hello"),
        ],
        followUpsLeadIn: "After hello, small talk often checks health, movement, or the social moment. Use these when the exchange has room to continue.",
        followUps: [
            PhraseOption(id: "how-are-you", vietnamese: "Bạn khỏe không?", english: "How are you?", pronunciation: "ban khweh khom", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: "viet-how-are-you"),
            PhraseOption(id: "where-going", vietnamese: "Đi đâu đấy?", english: "Where are you going?", pronunciation: "dee dow day", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: "viet-where-going"),
            PhraseOption(id: "nice-meet", vietnamese: "Rất vui được gặp bạn", english: "Nice to meet you", pronunciation: "zuht voo-ee duhk gap ban", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: "viet-nice-to-meet-you"),
        ],
        culturalNote: "Vietnamese greetings carry relationship information. Learning the pattern matters more than memorizing one perfect hello.",
        exploreNext: [
            PhraseLink(id: "polite-thank-you", vietnamese: "Cảm ơn", english: "Thank you", relation: "graceful exit", symbolName: "heart", tintName: .green, detailPageID: "viet-thank-you"),
            PhraseLink(id: "polite-sorry", vietnamese: "Xin lỗi", english: "Excuse me / sorry", relation: "attention getter", symbolName: "hand.raised", tintName: .blue, detailPageID: "viet-excuse-sorry"),
            PhraseLink(id: "goodbye", vietnamese: "Tạm biệt", english: "Goodbye", relation: "close conversation", symbolName: "sparkles", tintName: .purple, detailPageID: "viet-goodbye"),
        ]
    )
}

extension PhraseDetailPage {
    static let all: [PhraseDetailPage] = [
        respectfulHello,
        phoneHello,
        localGreetings,
        helloAnh,
        helloChi,
        helloEm,
        helloOng,
        helloBa,
        helloChu,
        helloCo,
        timeGreetings,
        howAreYou,
        whereGoing,
        niceToMeetYou,
        thankYou,
        excuseSorry,
        goodbye,
    ]

    static func page(withID id: String) -> PhraseDetailPage? {
        all.first { $0.id == id }
    }

    private static func localGreetingPage(
        id: String,
        title: String,
        englishTitle: String,
        pronunciation: String,
        summary: String,
        tintName: AccentTint,
        atGlance: String,
        waysLeadIn: String,
        ways: [PhraseOption],
        relationshipWord: String,
        relationshipMeaning: String,
        fullMeaning: String,
        whenToUse: String,
        localTip: String
    ) -> PhraseDetailPage {
        PhraseDetailPage(
            id: id,
            title: title,
            englishTitle: englishTitle,
            pronunciation: pronunciation,
            summary: summary,
            iconName: "person.fill",
            tintName: tintName,
            sections: [
                PhraseDetailSection(id: "at-glance", title: "At a glance", body: atGlance),
                PhraseDetailSection(
                    id: "ways-to-say",
                    title: "Ways to say it",
                    body: waysLeadIn,
                    phrases: ways
                ),
                PhraseDetailSection(
                    id: "breakdown",
                    title: "Break it down",
                    body: "The same pattern powers most local greeting pages: chào does the greeting, and the relationship word tells the listener how you are placing them socially.",
                    breakdown: [
                        BreakdownToken(id: "chao", vietnamese: "Chào", english: "greet / hello"),
                        BreakdownToken(id: relationshipWord, vietnamese: relationshipWord, english: relationshipMeaning),
                        BreakdownToken(id: "full", vietnamese: title, english: fullMeaning),
                    ]
                ),
                PhraseDetailSection(id: "when-to-use", title: "When to use it", body: whenToUse),
                PhraseDetailSection(id: "local-tip", title: "Local tip", body: localTip),
            ],
            examples: []
        )
    }

    static let helloAnh = PhraseDetailPage(
        id: "viet-hello-anh",
        title: "Chào anh",
        englishTitle: "Hello, older brother / slightly older man",
        pronunciation: "chow anh",
        summary: "Different ways to greet a slightly older man in Vietnam, from standard polite to more local and casual.",
        iconName: "person.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(
                id: "at-glance",
                title: "At a glance",
                body: "Anh literally means older brother, but in daily Vietnamese it is also the normal way to address a man who seems a little older than you. The greeting changes with respect level and setting, so Chào anh is only the center of a small phrase family."
            ),
            PhraseDetailSection(
                id: "ways-to-say",
                title: "Ways to say it",
                body: "Pick the version that matches the setting: standard, formal, respectful, attention-getting, or local small talk.",
                phrases: [
                    PhraseOption(id: "standard", vietnamese: "Chào anh", english: "Standard everyday hello", pronunciation: "chow anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
                    PhraseOption(id: "formal", vietnamese: "Xin chào anh", english: "More formal / polished hello", pronunciation: "sin chow anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
                    PhraseOption(id: "respectful", vietnamese: "Dạ, chào anh", english: "Respectful and well-mannered", pronunciation: "yah chow anh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
                    PhraseOption(id: "attention", vietnamese: "Anh ơi!", english: "Excuse me / hey, older brother", pronunciation: "anh oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
                    PhraseOption(id: "where-going", vietnamese: "Anh đi đâu đấy?", english: "Where are you going?", pronunciation: "anh dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
                    PhraseOption(id: "eaten-yet", vietnamese: "Anh ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "anh un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
                ]
            ),
            PhraseDetailSection(
                id: "breakdown",
                title: "Break it down",
                body: "The same pattern powers most local greeting pages: chào does the greeting, and the relationship word tells the listener how you are placing them socially.",
                breakdown: [
                    BreakdownToken(id: "chao", vietnamese: "Chào", english: "greet / hello"),
                    BreakdownToken(id: "anh", vietnamese: "anh", english: "older brother"),
                    BreakdownToken(id: "full", vietnamese: "Chào anh", english: "hello, older man"),
                ]
            ),
            PhraseDetailSection(
                id: "when-to-use",
                title: "When to use it",
                body: "Use Chào anh with a male shopkeeper, waiter, driver, host, guide, or new acquaintance who appears slightly older than you. Use Xin chào anh when you want a more formal tone, and Dạ, chào anh when you want to sound especially respectful."
            ),
            PhraseDetailSection(
                id: "local-tip",
                title: "Local tip",
                body: "Anh is not only for biological brothers. It can also be used for customer-service workers, slightly older men, and even a boyfriend or husband. If the man looks closer to your father or uncle’s age, switch to Chào chú. If he is elderly, Chào ông is more respectful."
            ),
        ],
        examples: []
    )

    static let helloChi = localGreetingPage(
        id: "viet-hello-chi",
        title: "Chào chị",
        englishTitle: "Hello, older sister / slightly older woman",
        pronunciation: "chow chee",
        summary: "Different ways to greet a slightly older woman in Vietnam, from standard polite to warmer local forms.",
        tintName: .red,
        atGlance: "Chị literally means older sister, but it is also the common way to address a woman who seems a little older than you. Chào chị is the standard greeting, and the variations add formality, respect, attention, or local small talk.",
        waysLeadIn: "Pick the version that matches the setting: standard, formal, respectful, attention-getting, or local social greeting.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào chị", english: "Standard everyday hello", pronunciation: "chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào chị", english: "More formal / polished hello", pronunciation: "sin chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào chị", english: "Respectful and well-mannered", pronunciation: "yah chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Chị ơi!", english: "Excuse me / hey, older sister", pronunciation: "chee oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "where-going", vietnamese: "Chị đi đâu đấy?", english: "Where are you going?", pronunciation: "chee dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Chị ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "chee un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "chị",
        relationshipMeaning: "older sister",
        fullMeaning: "hello, older woman",
        whenToUse: "Use Chào chị with a female shopkeeper, server, driver, host, guide, or new acquaintance who appears slightly older than you. Xin chào chị sounds more formal, while Dạ, chào chị adds a respectful lift.",
        localTip: "Chị is not only for biological sisters. It is often warmer and more natural than a plain hello. If the woman looks closer to your aunt’s age, switch to Chào cô. If she is elderly, Chào bà is more respectful."
    )

    static let helloEm = localGreetingPage(
        id: "viet-hello-em",
        title: "Chào em",
        englishTitle: "Hello, younger sibling / someone younger",
        pronunciation: "chow em",
        summary: "Different ways to greet someone younger in Vietnam without sounding stiff or accidentally too familiar.",
        tintName: .green,
        atGlance: "Em means younger sibling or younger person. It can sound warm and natural when the person is clearly younger than you, but it needs a little care because it also marks the relationship as familiar.",
        waysLeadIn: "Use the softer versions when the relationship is friendly; stay more neutral when the setting is formal or the age gap is unclear.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào em", english: "Standard friendly hello", pronunciation: "chow em", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào em", english: "More formal / polite hello", pronunciation: "sin chow em", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "soft", vietnamese: "Chào em nhé", english: "Soft friendly hello", pronunciation: "chow em nyeh", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Em ơi!", english: "Excuse me / hey, younger person", pronunciation: "em oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "how-are-you", vietnamese: "Em khỏe không?", english: "How are you?", pronunciation: "em khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Em ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "em un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "em",
        relationshipMeaning: "younger sibling / younger person",
        fullMeaning: "hello, younger person",
        whenToUse: "Use Chào em with a younger staff member, student, child, or younger acquaintance in a warm casual moment. Em ơi is common when calling for attention, especially in a shop or cafe.",
        localTip: "Do not use em for someone older than you. If the person is about your age, Chào bạn can be safer. If they are older, use Chào anh or Chào chị instead."
    )

    static let helloOng = localGreetingPage(
        id: "viet-hello-ong",
        title: "Chào ông",
        englishTitle: "Hello, grandfather / elderly man",
        pronunciation: "chow ohm",
        summary: "Different ways to greet an elderly man in Vietnam with clear respect.",
        tintName: .purple,
        atGlance: "Ông means grandfather or elderly man. It carries clear respect for age, so Chào ông is best when the person is truly elderly or in a formal respect-heavy moment.",
        waysLeadIn: "Use the respectful versions when speaking directly to an elderly man; local small-talk forms can sound warm when the relationship is friendly.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào ông", english: "Standard respectful hello", pronunciation: "chow ohm", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào ông", english: "Formal respectful hello", pronunciation: "sin chow ohm", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào ông", english: "Very respectful hello", pronunciation: "yah chow ohm", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Ông ơi!", english: "Excuse me / sir", pronunciation: "ohm oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "how-are-you", vietnamese: "Ông khỏe không?", english: "How are you?", pronunciation: "ohm khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Ông ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "ohm un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "ông",
        relationshipMeaning: "grandfather / elderly man",
        fullMeaning: "hello, elderly man",
        whenToUse: "Use Chào ông when greeting an elderly man in a family, neighborhood, market, hotel, or service setting. Dạ, chào ông is the safest respectful upgrade.",
        localTip: "For a man who is older but not elderly, Chào chú usually sounds more natural. For someone only slightly older, Chào anh is warmer and less distant."
    )

    static let helloBa = localGreetingPage(
        id: "viet-hello-ba",
        title: "Chào bà",
        englishTitle: "Hello, grandmother / elderly woman",
        pronunciation: "chow bah",
        summary: "Different ways to greet an elderly woman in Vietnam with warmth and respect.",
        tintName: .red,
        atGlance: "Bà means grandmother or elderly woman. Chào bà is respectful and direct, and it works best when the woman is clearly elderly or when you want to show extra deference.",
        waysLeadIn: "Use the respectful versions for elderly women; local small-talk forms can feel warmer when the moment is personal.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào bà", english: "Standard respectful hello", pronunciation: "chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào bà", english: "Formal respectful hello", pronunciation: "sin chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào bà", english: "Very respectful hello", pronunciation: "yah chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Bà ơi!", english: "Excuse me / ma'am", pronunciation: "bah oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "how-are-you", vietnamese: "Bà khỏe không?", english: "How are you?", pronunciation: "bah khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Bà ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "bah un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "bà",
        relationshipMeaning: "grandmother / elderly woman",
        fullMeaning: "hello, elderly woman",
        whenToUse: "Use Chào bà when greeting an elderly woman in a family, neighborhood, market, hotel, or service setting. Dạ, chào bà is the extra respectful version.",
        localTip: "For a woman who is older but not elderly, Chào cô usually fits better. For someone only slightly older, Chào chị sounds more natural."
    )

    static let helloChu = localGreetingPage(
        id: "viet-hello-chu",
        title: "Chào chú",
        englishTitle: "Hello, uncle / older man",
        pronunciation: "chow choo",
        summary: "Different ways to greet an older adult man in Vietnam when anh feels too young and ông feels too old.",
        tintName: .teal,
        atGlance: "Chú means uncle or older man. It sits between anh and ông, so Chào chú is useful when the man is older than you but not elderly.",
        waysLeadIn: "Use these when the person feels like an uncle-aged adult rather than a slightly older brother or grandfather.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào chú", english: "Standard respectful hello", pronunciation: "chow choo", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào chú", english: "More formal / polished hello", pronunciation: "sin chow choo", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào chú", english: "Respectful and well-mannered", pronunciation: "yah chow choo", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Chú ơi!", english: "Excuse me / uncle", pronunciation: "choo oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "where-going", vietnamese: "Chú đi đâu đấy?", english: "Where are you going?", pronunciation: "choo dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Chú ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "choo un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "chú",
        relationshipMeaning: "uncle / older man",
        fullMeaning: "hello, older man",
        whenToUse: "Use Chào chú for an adult man older than you, especially if he feels closer to an uncle than an older brother. Dạ, chào chú is a good respectful version for service or family settings.",
        localTip: "If he is only slightly older, Chào anh may feel smoother. If he is elderly, Chào ông is more respectful."
    )

    static let helloCo = localGreetingPage(
        id: "viet-hello-co",
        title: "Chào cô",
        englishTitle: "Hello, aunt / older woman",
        pronunciation: "chow koh",
        summary: "Different ways to greet an older adult woman in Vietnam when chị feels too young and bà feels too old.",
        tintName: .red,
        atGlance: "Cô means aunt or older woman. It is also common for female teachers and adult women in respectful settings, so Chào cô is a useful middle point between chị and bà.",
        waysLeadIn: "Use these when the person feels like an aunt-aged adult rather than a slightly older sister or grandmother.",
        ways: [
            PhraseOption(id: "standard", vietnamese: "Chào cô", english: "Standard respectful hello", pronunciation: "chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "formal", vietnamese: "Xin chào cô", english: "More formal / polished hello", pronunciation: "sin chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respectful", vietnamese: "Dạ, chào cô", english: "Respectful and well-mannered", pronunciation: "yah chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "attention", vietnamese: "Cô ơi!", english: "Excuse me / aunt", pronunciation: "koh oy", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "where-going", vietnamese: "Cô đi đâu đấy?", english: "Where are you going?", pronunciation: "koh dee dow day", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "eaten-yet", vietnamese: "Cô ăn cơm chưa?", english: "Have you eaten yet?", pronunciation: "koh un guhm chua", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ],
        relationshipWord: "cô",
        relationshipMeaning: "aunt / older woman",
        fullMeaning: "hello, older woman",
        whenToUse: "Use Chào cô for an adult woman older than you, especially if she feels closer to an aunt than an older sister. It is also common for teachers and respectful service interactions.",
        localTip: "If she is only slightly older, Chào chị may feel smoother. If she is elderly, Chào bà is more respectful."
    )

    static let respectfulHello = PhraseDetailPage(
        id: "viet-respectful-hello",
        title: "Dạ, chào anh/chị",
        englishTitle: "Respectful hello",
        pronunciation: "yah chow anh chee",
        summary: "A warmer, more local greeting when you want to sound polite to an adult, host, driver, or staff member.",
        iconName: "person.2.fill",
        tintName: .red,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "Dạ softens the greeting and shows respect. Anh and chị choose the relationship word for an adult man or woman."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use this at a hotel desk, shop counter, restaurant, homestay, or with someone helping you."),
            PhraseDetailSection(id: "watch", title: "Watch out", body: "If you are unsure whether to use anh or chị, Xin chào is still safe. This phrase is for when you want to sound a little more natural."),
        ],
        examples: [
            PhraseOption(id: "respect-anh", vietnamese: "Dạ, chào anh", english: "Hello, sir / older brother", pronunciation: "yah chow anh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "respect-chi", vietnamese: "Dạ, chào chị", english: "Hello, ma'am / older sister", pronunciation: "yah chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
        ]
    )

    static let phoneHello = PhraseDetailPage(
        id: "viet-phone-hello",
        title: "Alô",
        englishTitle: "Hello on the phone",
        pronunciation: "ah-lo",
        summary: "The natural way to answer or check a phone call in Vietnamese.",
        iconName: "phone.fill",
        tintName: .green,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "Alô is for calls. It is not the normal greeting when you walk into a shop or meet someone face to face."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it when answering a call, calling a driver, or checking whether the other person can hear you."),
        ],
        examples: [
            PhraseOption(id: "phone-basic", vietnamese: "Alô", english: "Hello? / Can you hear me?", pronunciation: "ah-lo", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ]
    )

    static let localGreetings = PhraseDetailPage(
        id: "viet-local-greetings",
        title: "How locals greet",
        englishTitle: "Relationship-based greetings",
        pronunciation: "chow + relationship word",
        summary: "Vietnamese often swaps a plain hello for a greeting that names the relationship, age, or respect level.",
        iconName: "person.2",
        tintName: .blue,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "These forms can feel warmer than Xin chào because they show how you see the other person in the social moment."),
            PhraseDetailSection(id: "safe", title: "Safe default", body: "Use Xin chào when you are unsure. Try the local forms when the relationship is obvious or someone uses that form with you first."),
        ],
        examples: [
            PhraseOption(id: "friend", vietnamese: "Chào bạn", english: "Hi, friend / you", pronunciation: "chow ban", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
            PhraseOption(id: "anh", vietnamese: "Chào anh", english: "Hello, slightly older man", pronunciation: "chow anh", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
            PhraseOption(id: "chi", vietnamese: "Chào chị", english: "Hello, slightly older woman", pronunciation: "chow chee", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "em", vietnamese: "Chào em", english: "Hello, younger person", pronunciation: "chow em", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "ong", vietnamese: "Chào ông", english: "Hello, elderly man", pronunciation: "chow ohm", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
            PhraseOption(id: "ba", vietnamese: "Chào bà", english: "Hello, elderly woman", pronunciation: "chow bah", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
            PhraseOption(id: "chu", vietnamese: "Chào chú", english: "Hello, uncle / older man", pronunciation: "chow choo", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
            PhraseOption(id: "co", vietnamese: "Chào cô", english: "Hello, aunt / older woman", pronunciation: "chow koh", symbolName: "speaker.wave.2.fill", tintName: .red, detailPageID: nil),
        ]
    )

    static let timeGreetings = PhraseDetailPage(
        id: "viet-time-greetings",
        title: "Time-of-day greetings",
        englishTitle: "Good morning / afternoon",
        pronunciation: "chow boo-ee...",
        summary: "Useful greetings when you want a familiar English-style morning or afternoon greeting.",
        iconName: "sun.max.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "These are understandable, but travelers should know that relationship greetings often sound more natural in everyday Vietnamese."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use them in polite service moments, lessons, hosted stays, or when the time of day is the point of the greeting."),
        ],
        examples: [
            PhraseOption(id: "morning", vietnamese: "Chào buổi sáng", english: "Good morning", pronunciation: "chow boo-ee sahng", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
            PhraseOption(id: "afternoon", vietnamese: "Chào buổi chiều", english: "Good afternoon", pronunciation: "chow boo-ee chee-ew", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
        ]
    )

    static let howAreYou = PhraseDetailPage(
        id: "viet-how-are-you",
        title: "Bạn khỏe không?",
        englishTitle: "How are you?",
        pronunciation: "ban khweh khom",
        summary: "A friendly follow-up after hello when the moment is social enough for small talk.",
        iconName: "bubble.left.and.bubble.right.fill",
        tintName: .purple,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "This is not always necessary in quick service moments. It works best when the exchange has room for friendliness."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it with a host, teacher, guide, familiar staff member, or someone you are meeting socially."),
        ],
        examples: [
            PhraseOption(id: "how-are-you", vietnamese: "Bạn khỏe không?", english: "How are you?", pronunciation: "ban khweh khom", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
        ]
    )

    static let whereGoing = PhraseDetailPage(
        id: "viet-where-going",
        title: "Đi đâu đấy?",
        englishTitle: "Where are you going?",
        pronunciation: "dee dow day",
        summary: "A common casual question that can work as social small talk, not only a literal request for directions.",
        iconName: "figure.walk",
        tintName: .orange,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "The English translation can sound nosy. In Vietnamese, it can be a light neighborly greeting depending on tone and relationship."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it when someone familiar asks first, or when you are practicing casual social language with someone friendly."),
        ],
        examples: [
            PhraseOption(id: "where-going", vietnamese: "Đi đâu đấy?", english: "Where are you going?", pronunciation: "dee dow day", symbolName: "speaker.wave.2.fill", tintName: .orange, detailPageID: nil),
        ]
    )

    static let niceToMeetYou = PhraseDetailPage(
        id: "viet-nice-to-meet-you",
        title: "Rất vui được gặp bạn",
        englishTitle: "Nice to meet you",
        pronunciation: "zuht voo-ee duhk gap ban",
        summary: "A useful next phrase when hello becomes an introduction.",
        iconName: "hands.sparkles.fill",
        tintName: .teal,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "This moves the exchange from a greeting into a social introduction without needing a long conversation."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it after someone tells you their name, when meeting a host, guide, classmate, or new friend."),
        ],
        examples: [
            PhraseOption(id: "nice-meet", vietnamese: "Rất vui được gặp bạn", english: "Nice to meet you", pronunciation: "zuht voo-ee duhk gap ban", symbolName: "speaker.wave.2.fill", tintName: .teal, detailPageID: nil),
        ]
    )

    static let thankYou = PhraseDetailPage(
        id: "viet-thank-you",
        title: "Cảm ơn",
        englishTitle: "Thank you",
        pronunciation: "kahm uhn",
        summary: "A core phrase for keeping service moments and everyday help warm and simple.",
        iconName: "heart.fill",
        tintName: .green,
        sections: [
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it anytime someone helps you, serves you, gives directions, or answers a question."),
            PhraseDetailSection(id: "upgrade", title: "A warmer version", body: "Cảm ơn nhiều means thank you very much. Save it for when someone went out of their way."),
        ],
        examples: [
            PhraseOption(id: "thank-you", vietnamese: "Cảm ơn", english: "Thank you", pronunciation: "kahm uhn", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
            PhraseOption(id: "thank-you-many", vietnamese: "Cảm ơn nhiều", english: "Thank you very much", pronunciation: "kahm uhn nyew", symbolName: "speaker.wave.2.fill", tintName: .green, detailPageID: nil),
        ]
    )

    static let excuseSorry = PhraseDetailPage(
        id: "viet-excuse-sorry",
        title: "Xin lỗi",
        englishTitle: "Excuse me / sorry",
        pronunciation: "sin loy",
        summary: "A flexible phrase for getting attention, passing by, or apologizing lightly.",
        iconName: "hand.raised.fill",
        tintName: .blue,
        sections: [
            PhraseDetailSection(id: "why", title: "Why it matters", body: "Xin lỗi can mean sorry or excuse me, so it is one of the safest repair phrases for travelers."),
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use it before asking a question, when squeezing past someone, or after a small mistake."),
        ],
        examples: [
            PhraseOption(id: "excuse-sorry", vietnamese: "Xin lỗi", english: "Excuse me / sorry", pronunciation: "sin loy", symbolName: "speaker.wave.2.fill", tintName: .blue, detailPageID: nil),
        ]
    )

    static let goodbye = PhraseDetailPage(
        id: "viet-goodbye",
        title: "Tạm biệt",
        englishTitle: "Goodbye",
        pronunciation: "tahm bee-et",
        summary: "A clean way to close the exchange when leaving a shop, cafe, hotel desk, or social moment.",
        iconName: "sparkles",
        tintName: .purple,
        sections: [
            PhraseDetailSection(id: "use", title: "Use it when", body: "Use this when leaving or ending a conversation politely."),
            PhraseDetailSection(id: "natural", title: "Natural exit", body: "A smile plus Cảm ơn can sometimes be enough after a service exchange. Tạm biệt is clearer when you want a real goodbye."),
        ],
        examples: [
            PhraseOption(id: "goodbye", vietnamese: "Tạm biệt", english: "Goodbye", pronunciation: "tahm bee-et", symbolName: "speaker.wave.2.fill", tintName: .purple, detailPageID: nil),
        ]
    )
}
