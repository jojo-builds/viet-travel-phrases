import Foundation

struct PracticeStoryDefinitionToken: Identifiable, Equatable {
    let id: String
    let vietnamese: String
    let english: String
    let sourcePageID: String?
}

enum PracticeStoryBreakdownDefinitions {
    static func tokens(for turn: PracticeStoryTurn) -> [PracticeStoryDefinitionToken] {
        guard let vietnamese = turn.vietnamese?.trimmingCharacters(in: .whitespacesAndNewlines),
              !vietnamese.isEmpty else {
            return []
        }

        let pageIDs = pageIDCandidates(for: turn, vietnamese: vietnamese)
        for pageID in pageIDs {
            let definitions = tokens(forVietnamese: vietnamese, pageID: pageID)
            if !definitions.isEmpty {
                return scoped(definitions, to: turn.id)
            }
        }

        return []
    }

    static func tokens(
        forVietnamese vietnamese: String,
        pageID: String?
    ) -> [PracticeStoryDefinitionToken] {
        guard let pageID,
              let breakdown = breakdownTokens(forPageID: pageID),
              !breakdown.isEmpty else {
            return []
        }

        return tokens(forVietnamese: vietnamese, breakdownTokens: breakdown, pageID: pageID)
    }

    static func tokens(
        forVietnamese vietnamese: String,
        breakdownTokens: [BreakdownToken],
        pageID: String?
    ) -> [PracticeStoryDefinitionToken] {
        let normalizedPhrase = normalized(vietnamese)
        guard !normalizedPhrase.isEmpty else {
            return []
        }

        let usefulTokens = trimmedWholePhraseToken(
            from: breakdownTokens.filter { token in
                !token.vietnamese.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
                    && !token.english.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            },
            vietnamese: vietnamese
        )
        .filter { token in
            let normalizedToken = normalized(token.vietnamese)
            return !normalizedToken.isEmpty && normalizedPhrase.contains(normalizedToken)
        }

        guard !usefulTokens.isEmpty else {
            return []
        }

        guard tokensCoverPhrase(usefulTokens, vietnamese: vietnamese) else {
            return []
        }

        return usefulTokens.enumerated().map { index, token in
            PracticeStoryDefinitionToken(
                id: stableID(for: token, pageID: pageID, index: index),
                vietnamese: token.vietnamese,
                english: token.english,
                sourcePageID: pageID
            )
        }
    }

    private static func pageIDCandidates(for turn: PracticeStoryTurn, vietnamese: String) -> [String] {
        var candidates: [String] = []

        if let sourcePageID = turn.source?.pageID {
            candidates.append(sourcePageID)
        }

        let normalizedVietnamese = normalized(vietnamese)
        candidates += PhraseCatalog.allItems
            .filter { normalized($0.title) == normalizedVietnamese }
            .map(\.pageID)

        var seen = Set<String>()
        return candidates.filter { seen.insert($0).inserted }
    }

    private static func breakdownTokens(forPageID pageID: String) -> [BreakdownToken]? {
        if pageID == PhrasePage.xinChao.id {
            return PhrasePage.xinChao.breakdown
        }

        let canonicalPageID = PhraseCatalog.canonicalPageID(forOpenablePageID: pageID) ?? pageID
        if let detailPage = PhraseDetailPage.page(withID: canonicalPageID) {
            return detailPage.sections.flatMap(\.breakdown)
        }

        return nil
    }

    private static func trimmedWholePhraseToken(
        from tokens: [BreakdownToken],
        vietnamese: String
    ) -> [BreakdownToken] {
        guard tokens.count > 1, let last = tokens.last else {
            return tokens
        }

        if last.id == "full" || normalized(last.vietnamese) == normalized(vietnamese) {
            return Array(tokens.dropLast())
        }

        return tokens
    }

    private static func tokensCoverPhrase(_ tokens: [BreakdownToken], vietnamese: String) -> Bool {
        var remainder = " \(normalized(vietnamese)) "

        for token in tokens.sorted(by: { normalized($0.vietnamese).count > normalized($1.vietnamese).count }) {
            let normalizedToken = " \(normalized(token.vietnamese)) "
            guard normalizedToken.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false,
                  let range = remainder.range(of: normalizedToken) else {
                return false
            }

            remainder.replaceSubrange(range, with: " ")
        }

        return remainder
            .split(separator: " ")
            .isEmpty
    }

    private static func scoped(
        _ tokens: [PracticeStoryDefinitionToken],
        to turnID: String
    ) -> [PracticeStoryDefinitionToken] {
        let scope = sanitized(turnID)
        return tokens.map { token in
            PracticeStoryDefinitionToken(
                id: "\(scope)-\(token.id)",
                vietnamese: token.vietnamese,
                english: token.english,
                sourcePageID: token.sourcePageID
            )
        }
    }

    private static func stableID(for token: BreakdownToken, pageID: String?, index: Int) -> String {
        sanitized([
            pageID ?? "message",
            token.id,
            String(index),
        ]
            .joined(separator: "-"))
    }

    private static func sanitized(_ value: String) -> String {
        value
            .map { character in
                character.isLetter || character.isNumber || character == "-" ? character : "-"
            }
            .reduce(into: "") { partialResult, character in
                if character != "-" || partialResult.last != "-" {
                    partialResult.append(character)
                }
            }
    }

    private static func normalized(_ value: String) -> String {
        value
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: Locale(identifier: "vi_VN"))
            .replacingOccurrences(of: "đ", with: "d")
            .replacingOccurrences(of: "Đ", with: "d")
            .unicodeScalars
            .map { scalar -> Character in
                CharacterSet.alphanumerics.contains(scalar) ? Character(scalar) : " "
            }
            .reduce(into: "") { result, character in
                if character == " " {
                    if result.last != " " {
                        result.append(character)
                    }
                } else {
                    result.append(character)
                }
            }
            .trimmingCharacters(in: .whitespacesAndNewlines)
    }
}
