import Foundation
import OSLog
import SQLite3

enum VietSQLiteLanguagePackTable: String, CaseIterable {
    case scenario
    case phraseCluster = "phrase_cluster"
    case phrase
    case phrasePage = "phrase_page"
    case pageAlias = "page_alias"
    case searchDocument = "search_document"
}

struct VietSQLiteLanguagePackCounts: Equatable {
    let scenarios: Int
    let clusters: Int
    let phrases: Int
    let pages: Int
    let aliases: Int
    let searchDocuments: Int
}

struct VietSQLitePhrasePreview: Equatable {
    let phraseID: String
    let pageID: String
    let title: String
    let englishTitle: String
    let pronunciation: String
    let accessTier: String
    let categoryID: String
    let catalogItem: PhraseCatalogItem
    let searchResult: PhraseSearchResult
}

struct VietSQLiteLanguagePackSanitySnapshot: Equatable {
    let languagePackID: String
    let contentVersion: String
    let integrityCheck: String
    let counts: VietSQLiteLanguagePackCounts
    let preview: VietSQLitePhrasePreview
}

struct VietSQLitePhraseGraphCoverage: Equatable {
    let sourcePhraseRows: Int
    let canonicalPhrasePages: Int
    let resolvedPhraseRows: Int
    let searchDocuments: Int
    let relationEdges: Int
    let duplicateCanonicalPageGroups: Int
    let brokenRelationEdges: Int
    let searchDocumentsWithMissingPageTargets: Int
    let audioUsageMismatches: Int
    let missingAudioAuditRows: Int
}

struct VietSQLiteVisibleAudioUsage: Equatable {
    let usageKind: String
    let targetKind: String
    let targetID: String
    let audioKey: String
    let expectedText: String
}

struct VietSQLitePhraseCatalogSnapshot: Equatable {
    let scenarioCategories: [PhraseCategory]
    let catalogItems: [PhraseCatalogItem]
}

enum VietSQLiteRuntimeDiagnostics {
    private static let logger = Logger(
        subsystem: "app.speaklocal.vietnam.native",
        category: "SQLiteRuntime"
    )

    static func reportFallback(surface: String, reason: String) {
        logger.error("SQLite fallback for \(surface, privacy: .public): \(reason, privacy: .public)")
    }

    static func reportFallback(surface: String, error: Error) {
        reportFallback(surface: surface, reason: String(describing: error))
    }
}

private struct VietSQLitePracticeCandidateRow {
    let phraseID: String
    let pageID: String
    let vietnamese: String
    let english: String
    let pronunciation: String
    let categoryIDs: [String]
    let symbolName: String
    let tintName: AccentTint
    let audioKey: String?
    let source: PracticeSourceMetadata

    func candidate(breakdownTokens: [BreakdownToken]) -> PracticeCandidate {
        PracticeCandidate(
            phraseID: phraseID,
            pageID: pageID,
            vietnamese: vietnamese,
            english: english,
            pronunciation: pronunciation,
            categoryIDs: categoryIDs,
            symbolName: symbolName,
            tintName: tintName,
            audioKey: audioKey,
            breakdownTokens: breakdownTokens,
            source: source
        )
    }
}

enum VietSQLiteLanguagePackRepositoryError: Error, LocalizedError {
    case missingBundledFixture(subdirectory: String)
    case openFailed(path: String, message: String)
    case notReadOnly(path: String)
    case prepareFailed(sql: String, message: String)
    case stepFailed(sql: String, message: String)
    case bindFailed(sql: String, message: String)
    case emptyResult(sql: String)
    case missingPreviewPhrase(id: String)
    case missingCanonicalPage(id: String)
    case missingPhrase(id: String)
    case invalidJSONColumn(name: String, value: String)

    var errorDescription: String? {
        switch self {
        case .missingBundledFixture(let subdirectory):
            return "Missing bundled Viet SQLite fixture in \(subdirectory)."
        case .openFailed(let path, let message):
            return "Unable to open SQLite fixture at \(path): \(message)"
        case .notReadOnly(let path):
            return "SQLite fixture was not opened read-only: \(path)"
        case .prepareFailed(let sql, let message):
            return "Unable to prepare SQLite query \(sql): \(message)"
        case .stepFailed(let sql, let message):
            return "SQLite query failed \(sql): \(message)"
        case .bindFailed(let sql, let message):
            return "Unable to bind SQLite query \(sql): \(message)"
        case .emptyResult(let sql):
            return "SQLite query returned no rows: \(sql)"
        case .missingPreviewPhrase(let id):
            return "SQLite preview phrase is missing: \(id)"
        case .missingCanonicalPage(let id):
            return "SQLite canonical phrase page is missing: \(id)"
        case .missingPhrase(let id):
            return "SQLite phrase is missing: \(id)"
        case .invalidJSONColumn(let name, let value):
            return "SQLite JSON column \(name) could not be decoded: \(value)"
        }
    }
}

final class VietSQLiteLanguagePackRepository {
    static let databaseResourceName = "speaklocal-viet"
    static let databaseSubdirectory = "LanguagePacks/viet"

    let databaseURL: URL

    var isReadOnly: Bool {
        guard let database else {
            return false
        }

        return sqlite3_db_readonly(database, "main") == 1
    }

    private var database: OpaquePointer?

    init(databaseURL: URL) throws {
        self.databaseURL = databaseURL

        var openedDatabase: OpaquePointer?
        let flags = SQLITE_OPEN_READONLY | SQLITE_OPEN_NOMUTEX
        let result = sqlite3_open_v2(databaseURL.path, &openedDatabase, flags, nil)

        guard result == SQLITE_OK, let openedDatabase else {
            let message = openedDatabase.map(Self.errorMessage(database:)) ?? "unknown SQLite open failure"
            if let openedDatabase {
                sqlite3_close(openedDatabase)
            }
            throw VietSQLiteLanguagePackRepositoryError.openFailed(path: databaseURL.path, message: message)
        }

        database = openedDatabase

        guard isReadOnly else {
            throw VietSQLiteLanguagePackRepositoryError.notReadOnly(path: databaseURL.path)
        }
    }

    deinit {
        if let database {
            sqlite3_close(database)
        }
    }

    static func bundledDatabaseURL(bundle: Bundle = .main) -> URL? {
        bundle.url(
            forResource: databaseResourceName,
            withExtension: "sqlite",
            subdirectory: databaseSubdirectory
        )
    }

    static func bundled(bundle: Bundle = .main) throws -> VietSQLiteLanguagePackRepository {
        guard let url = bundledDatabaseURL(bundle: bundle) else {
            throw VietSQLiteLanguagePackRepositoryError.missingBundledFixture(
                subdirectory: databaseSubdirectory
            )
        }

        return try VietSQLiteLanguagePackRepository(databaseURL: url)
    }

    func integrityCheck() throws -> String {
        try stringValue("PRAGMA integrity_check;")
    }

    func count(_ table: VietSQLiteLanguagePackTable) throws -> Int {
        try intValue("SELECT count(*) FROM \(table.rawValue);")
    }

    func hasIndex(named name: String) throws -> Bool {
        let sql = """
        SELECT count(*)
        FROM sqlite_master
        WHERE type = 'index'
          AND name = ?;
        """

        return try intValue(sql) { statement in
            try self.bindText(name, to: 1, in: statement, sql: sql)
        } > 0
    }

    func loadSanitySnapshot(previewPhraseID: String = "polite-1") throws -> VietSQLiteLanguagePackSanitySnapshot {
        VietSQLiteLanguagePackSanitySnapshot(
            languagePackID: try stringValue("SELECT id FROM language_pack LIMIT 1;"),
            contentVersion: try stringValue("SELECT content_version FROM language_pack LIMIT 1;"),
            integrityCheck: try integrityCheck(),
            counts: VietSQLiteLanguagePackCounts(
                scenarios: try count(.scenario),
                clusters: try count(.phraseCluster),
                phrases: try count(.phrase),
                pages: try count(.phrasePage),
                aliases: try count(.pageAlias),
                searchDocuments: try count(.searchDocument)
            ),
            preview: try loadPhrasePreview(phraseID: previewPhraseID)
        )
    }

    func loadPhrasePreview(phraseID: String) throws -> VietSQLitePhrasePreview {
        let sql = """
        SELECT
          p.id,
          pp.id,
          pp.title,
          pp.english_title,
          p.pronunciation,
          p.access_tier,
          COALESCE(
            (SELECT pc.category_id FROM page_category pc WHERE pc.page_id = pp.id ORDER BY pc.sort_order LIMIT 1),
            (SELECT ps.scenario_id FROM phrase_scenario ps WHERE ps.phrase_id = p.id ORDER BY ps.sort_order LIMIT 1),
            'greetings'
          ) AS category_id,
          pp.icon_name,
          pp.tint_name
        FROM phrase p
        JOIN phrase_page pp ON pp.phrase_id = p.id
        WHERE p.id = ?
        LIMIT 1;
        """

        return try withPreparedStatement(sql) { statement in
            try self.bindText(phraseID, to: 1, in: statement, sql: sql)

            guard sqlite3_step(statement) == SQLITE_ROW else {
                throw VietSQLiteLanguagePackRepositoryError.missingPreviewPhrase(id: phraseID)
            }

            let phraseID = Self.stringColumn(statement, index: 0)
            let pageID = Self.stringColumn(statement, index: 1)
            let title = Self.stringColumn(statement, index: 2)
            let englishTitle = Self.stringColumn(statement, index: 3)
            let pronunciation = Self.stringColumn(statement, index: 4)
            let accessTier = Self.stringColumn(statement, index: 5)
            let categoryID = Self.stringColumn(statement, index: 6)
            let iconName = Self.stringColumn(statement, index: 7)
            let tintName = Self.stringColumn(statement, index: 8)
            let tint = AccentTint(rawValue: tintName) ?? .gray

            return VietSQLitePhrasePreview(
                phraseID: phraseID,
                pageID: pageID,
                title: title,
                englishTitle: englishTitle,
                pronunciation: pronunciation,
                accessTier: accessTier,
                categoryID: categoryID,
                catalogItem: PhraseCatalogItem(
                    pageID: pageID,
                    title: title,
                    subtitle: englishTitle,
                    categoryIDs: [categoryID],
                    symbolName: iconName,
                    tintName: tint
                ),
                searchResult: PhraseSearchResult(
                    pageID: pageID,
                    title: title,
                    subtitle: englishTitle
                )
            )
        }
    }

    func loadCatalogSnapshot() throws -> VietSQLitePhraseCatalogSnapshot {
        VietSQLitePhraseCatalogSnapshot(
            scenarioCategories: try loadScenarioCategories(),
            catalogItems: try loadCatalogItems()
        )
    }

    func loadVietnameseMenuPayload() throws -> VietnameseMenuPayload {
        VietnameseMenuPayload(
            helperPhrases: try loadVietnameseMenuHelperPhrases(),
            items: try loadVietnameseMenuItems()
        )
    }

    func loadVietnameseMenuHelperPhrases() throws -> [VietnameseMenuHelperPhraseDefinition] {
        let sql = """
        SELECT
          id,
          vietnamese,
          english,
          pronunciation,
          audio_key,
          detail_page_id,
          audio_status,
          applies_to_json
        FROM vietnamese_menu_helper_phrase
        ORDER BY sort_order, id;
        """

        return try rows(sql) { statement in
            VietnameseMenuHelperPhraseDefinition(
                id: Self.stringColumn(statement, index: 0),
                vietnamese: Self.stringColumn(statement, index: 1),
                english: Self.stringColumn(statement, index: 2),
                pronunciation: Self.stringColumn(statement, index: 3),
                audioKey: Self.optionalStringColumn(statement, index: 4),
                detailPageID: Self.optionalStringColumn(statement, index: 5),
                audioStatus: Self.stringColumn(statement, index: 6),
                appliesTo: try Self.jsonStringArrayColumn(statement, index: 7, name: "vietnamese_menu_helper_phrase.applies_to_json")
            )
        }
    }

    func loadVietnameseMenuItems() throws -> [VietnameseMenuItem] {
        let sql = """
        SELECT
          item_id,
          menu_type,
          category,
          subcategory,
          popular,
          vietnamese_item,
          english_translation,
          romanized_no_tones,
          sound_out,
          notes,
          at_a_glance,
          what_it_is,
          usually_includes_json,
          how_to_enjoy,
          how_locals_order,
          worth_knowing,
          regional_association,
          origin_posture,
          traveler_caution,
          good_to_know,
          common_options_json,
          quick_say_vietnamese,
          quick_say_english,
          quick_say_sound_out,
          order_line_vietnamese,
          order_line_english,
          order_line_pronunciation,
          order_line_audio_policy,
          helper_phrase_ids_json,
          editorial_review_status,
          editorial_review_reviewed_by,
          editorial_review_reviewed_at,
          editorial_review_checks_json,
          editorial_review_review_note
        FROM vietnamese_menu_item
        ORDER BY sort_order, item_id;
        """

        return try rows(sql) { statement in
            let orderLine = Self.vietnameseMenuOrderLine(statement: statement)
            let editorialReview = try Self.vietnameseMenuEditorialReview(statement: statement)

            return VietnameseMenuItem(
                itemID: Self.stringColumn(statement, index: 0),
                menuType: Self.stringColumn(statement, index: 1),
                category: Self.stringColumn(statement, index: 2),
                subcategory: Self.stringColumn(statement, index: 3),
                popular: sqlite3_column_int(statement, 4) != 0,
                vietnameseItem: Self.stringColumn(statement, index: 5),
                englishTranslation: Self.stringColumn(statement, index: 6),
                romanizedNoTones: Self.stringColumn(statement, index: 7),
                soundOut: Self.stringColumn(statement, index: 8),
                notes: Self.stringColumn(statement, index: 9),
                atAGlance: Self.stringColumn(statement, index: 10),
                whatItIs: Self.optionalStringColumn(statement, index: 11),
                usuallyIncludes: try Self.jsonStringArrayColumn(statement, index: 12, name: "vietnamese_menu_item.usually_includes_json"),
                howToEnjoy: Self.optionalStringColumn(statement, index: 13),
                howLocalsOrder: Self.optionalStringColumn(statement, index: 14),
                worthKnowing: Self.optionalStringColumn(statement, index: 15),
                regionalAssociation: Self.optionalStringColumn(statement, index: 16),
                originPosture: Self.optionalStringColumn(statement, index: 17),
                travelerCaution: Self.optionalStringColumn(statement, index: 18),
                goodToKnow: Self.stringColumn(statement, index: 19),
                commonOptions: try Self.jsonStringArrayColumn(statement, index: 20, name: "vietnamese_menu_item.common_options_json"),
                quickSayVietnamese: Self.stringColumn(statement, index: 21),
                quickSayEnglish: Self.stringColumn(statement, index: 22),
                quickSaySoundOut: Self.stringColumn(statement, index: 23),
                orderLine: orderLine,
                helperPhraseIDs: try Self.jsonStringArrayColumn(statement, index: 28, name: "vietnamese_menu_item.helper_phrase_ids_json"),
                editorialReview: editorialReview
            )
        }
    }

    func loadScenarioCategories() throws -> [PhraseCategory] {
        let sql = """
        SELECT id, title, symbol_name, tint_name
        FROM scenario
        ORDER BY sort_order, title COLLATE NOCASE;
        """

        return try rows(sql) { statement in
            PhraseCategory(
                id: Self.stringColumn(statement, index: 0),
                title: Self.stringColumn(statement, index: 1),
                symbolName: Self.stringColumn(statement, index: 2),
                tintName: AccentTint(rawValue: Self.stringColumn(statement, index: 3)) ?? .gray
            )
        }
    }

    func loadCatalogItems() throws -> [PhraseCatalogItem] {
        let sql = """
        SELECT
          pp.id,
          pp.title,
          pp.english_title,
          pp.icon_name,
          pp.tint_name,
          pp.hero_image_name,
          aa.source_manifest_key,
          COALESCE(
            (
              SELECT group_concat(category_id, '|')
              FROM (
                SELECT pc.category_id
                FROM page_category pc
                WHERE pc.page_id = pp.id
                ORDER BY pc.sort_order, pc.category_id
              )
            ),
            (
              SELECT group_concat(scenario_id, '|')
              FROM (
                SELECT ps.scenario_id
                FROM phrase_scenario ps
                WHERE ps.phrase_id = p.id
                ORDER BY ps.sort_order, ps.scenario_id
              )
            ),
            'greetings'
          ) AS category_ids,
          COALESCE(
            (SELECT MIN(pc.sort_order) FROM page_category pc WHERE pc.page_id = pp.id),
            9999
          ) AS category_sort
        FROM phrase_page pp
        JOIN phrase p ON p.id = pp.phrase_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'phrase'
         AND au.target_id = p.id
         AND au.is_primary = 1
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        ORDER BY category_sort, pp.title COLLATE NOCASE, pp.id;
        """

        return try rows(sql) { statement in
            let tint = AccentTint(rawValue: Self.stringColumn(statement, index: 4)) ?? .gray
            let categoryIDs = Self.stringColumn(statement, index: 7)
                .split(separator: "|")
                .map(String.init)

            return PhraseCatalogItem(
                pageID: Self.stringColumn(statement, index: 0),
                title: Self.stringColumn(statement, index: 1),
                subtitle: Self.stringColumn(statement, index: 2),
                categoryIDs: categoryIDs.isEmpty ? ["greetings"] : categoryIDs,
                symbolName: Self.stringColumn(statement, index: 3),
                tintName: tint,
                audioKey: Self.optionalStringColumn(statement, index: 5)
            )
        }
    }

    func loadPracticeCandidates(
        pageIDs: [String]? = nil,
        cityID: String? = nil,
        categoryIDs: [String]? = nil,
        requiringAudio: Bool = false,
        limit: Int = 80
    ) throws -> [PracticeCandidate] {
        var seenCanonicalPageIDs = Set<String>()
        let requestedPageIDs = pageIDs ?? []
        let canonicalPageIDs = requestedPageIDs.compactMap { pageID -> String? in
            guard let canonicalPageID = try? self.canonicalPageID(forPageIDOrAlias: pageID) else {
                return nil
            }

            guard seenCanonicalPageIDs.insert(canonicalPageID).inserted else {
                return nil
            }

            return canonicalPageID
        }

        if pageIDs != nil && canonicalPageIDs.isEmpty {
            return []
        }

        var filters: [String] = []
        if !canonicalPageIDs.isEmpty {
            let placeholders = Array(repeating: "?", count: canonicalPageIDs.count).joined(separator: ", ")
            filters.append("pp.id IN (\(placeholders))")
        }
        if cityID != nil {
            filters.append("pct.city_id = ?")
        }
        let requestedCategoryIDs = categoryIDs ?? []
        if !requestedCategoryIDs.isEmpty {
            let placeholders = Array(repeating: "?", count: requestedCategoryIDs.count).joined(separator: ", ")
            filters.append(
                """
                EXISTS (
                  SELECT 1
                  FROM page_category pc_filter
                  WHERE pc_filter.page_id = pp.id
                    AND pc_filter.category_id IN (\(placeholders))
                )
                """
            )
        }
        if requiringAudio {
            filters.append("aa.source_manifest_key IS NOT NULL")
        }

        let whereClause = filters.isEmpty ? "" : "WHERE \(filters.joined(separator: " AND "))"
        let effectiveLimit = max(limit, canonicalPageIDs.count)
        let sql = """
        SELECT
          p.id,
          pp.id,
          pp.title,
          pp.english_title,
          p.pronunciation,
          pp.icon_name,
          pp.tint_name,
          aa.source_manifest_key,
          COALESCE(
            (
              SELECT group_concat(category_id, '|')
              FROM (
                SELECT pc.category_id
                FROM page_category pc
                WHERE pc.page_id = pp.id
                ORDER BY pc.sort_order, pc.category_id
              )
            ),
            (
              SELECT group_concat(scenario_id, '|')
              FROM (
                SELECT ps.scenario_id
                FROM phrase_scenario ps
                WHERE ps.phrase_id = p.id
                ORDER BY ps.sort_order, ps.scenario_id
              )
            ),
            'greetings'
          ) AS category_ids,
          pct.city_id,
          c.title,
          pct.subcategory_id,
          cs.title,
          pct.place_id,
          COALESCE(NULLIF(cp.english_name, ''), NULLIF(cp.vietnamese_name, ''))
        FROM phrase_page pp
        JOIN phrase p ON p.id = pp.phrase_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'phrase'
         AND au.target_id = p.id
         AND au.is_primary = 1
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        LEFT JOIN phrase_city_tag pct ON pct.phrase_id = p.id
        LEFT JOIN city c ON c.id = pct.city_id
        LEFT JOIN city_subcategory cs ON cs.id = pct.subcategory_id
        LEFT JOIN city_place cp ON cp.id = pct.place_id
        \(whereClause)
        ORDER BY
          CASE WHEN pct.city_id = 'hanoi' THEN 0 ELSE 1 END,
          CASE WHEN aa.source_manifest_key IS NOT NULL THEN 0 ELSE 1 END,
          COALESCE(
            (SELECT MIN(pc.sort_order) FROM page_category pc WHERE pc.page_id = pp.id),
            9999
          ),
          pp.title COLLATE NOCASE,
          pp.id
        LIMIT ?;
        """

        let candidateRows = try rows(sql, bind: { statement in
            var index: Int32 = 1

            for pageID in canonicalPageIDs {
                try self.bindText(pageID, to: index, in: statement, sql: sql)
                index += 1
            }

            if let cityID {
                try self.bindText(cityID, to: index, in: statement, sql: sql)
                index += 1
            }

            for categoryID in requestedCategoryIDs {
                try self.bindText(categoryID, to: index, in: statement, sql: sql)
                index += 1
            }

            try self.bindInt(effectiveLimit, to: index, in: statement, sql: sql)
        }) { statement in
            let phraseID = Self.stringColumn(statement, index: 0)
            let pageID = Self.stringColumn(statement, index: 1)
            let tint = AccentTint(rawValue: Self.stringColumn(statement, index: 6)) ?? .gray
            let categoryIDs = Self.stringColumn(statement, index: 8)
                .split(separator: "|")
                .map(String.init)
            let source = PracticeSourceMetadata(
                phraseID: phraseID,
                pageID: pageID,
                cityID: Self.optionalStringColumn(statement, index: 9),
                cityName: Self.optionalStringColumn(statement, index: 10),
                citySubcategoryID: Self.optionalStringColumn(statement, index: 11),
                citySubcategoryTitle: Self.optionalStringColumn(statement, index: 12),
                placeID: Self.optionalStringColumn(statement, index: 13),
                placeName: Self.optionalStringColumn(statement, index: 14)
            )

            return VietSQLitePracticeCandidateRow(
                phraseID: phraseID,
                pageID: pageID,
                vietnamese: Self.stringColumn(statement, index: 2),
                english: Self.stringColumn(statement, index: 3),
                pronunciation: Self.stringColumn(statement, index: 4),
                categoryIDs: categoryIDs.isEmpty ? ["greetings"] : categoryIDs,
                symbolName: Self.stringColumn(statement, index: 5),
                tintName: tint,
                audioKey: Self.optionalStringColumn(statement, index: 7),
                source: source
            )
        }
        let breakdownTokensByPageID = try loadPracticeBreakdownTokens(forPageIDs: candidateRows.map(\.pageID))
        let candidates = candidateRows.map { row in
            row.candidate(breakdownTokens: breakdownTokensByPageID[row.pageID] ?? [])
        }

        guard !canonicalPageIDs.isEmpty else {
            return candidates
        }

        let requestedOrder = Dictionary(uniqueKeysWithValues: canonicalPageIDs.enumerated().map { index, pageID in
            (pageID, index)
        })

        return candidates.sorted { lhs, rhs in
            requestedOrder[lhs.pageID, default: Int.max] < requestedOrder[rhs.pageID, default: Int.max]
        }
    }

    func loadBrowseCityCollectionItems(cityID: String, limit: Int = 120) throws -> [BrowseCityCollectionItem] {
        let sql = """
        SELECT
          pp.id,
          pp.title,
          pp.english_title,
          pp.icon_name,
          pp.tint_name,
          pp.hero_image_name,
          aa.source_manifest_key,
          COALESCE(
            (
              SELECT group_concat(category_id, '|')
              FROM (
                SELECT pc.category_id
                FROM page_category pc
                WHERE pc.page_id = pp.id
                ORDER BY pc.sort_order, pc.category_id
              )
            ),
            'city-guides'
          ) AS category_ids,
          pct.city_id,
          c.title,
          pct.subcategory_id,
          cs.title,
          pct.page_kind,
          pct.place_kind
        FROM phrase_city_tag pct
        JOIN phrase p ON p.id = pct.phrase_id
        JOIN phrase_page pp ON pp.phrase_id = p.id
        JOIN city c ON c.id = pct.city_id
        JOIN city_subcategory cs ON cs.id = pct.subcategory_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'phrase'
         AND au.target_id = p.id
         AND au.is_primary = 1
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE pct.city_id = ?
        ORDER BY
          cs.sort_order,
          pp.title COLLATE NOCASE,
          pp.id
        LIMIT ?;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(cityID, to: 1, in: statement, sql: sql)
            try self.bindInt(limit, to: 2, in: statement, sql: sql)
        }) { statement in
            let categoryIDs = Self.stringColumn(statement, index: 7)
                .split(separator: "|")
                .map(String.init)

            return BrowseCityCollectionItem(
                pageID: Self.stringColumn(statement, index: 0),
                title: Self.stringColumn(statement, index: 1),
                subtitle: Self.stringColumn(statement, index: 2),
                categoryIDs: categoryIDs.isEmpty ? ["city-guides"] : categoryIDs,
                symbolName: Self.stringColumn(statement, index: 3),
                tintName: AccentTint(rawValue: Self.stringColumn(statement, index: 4)) ?? .gray,
                audioKey: Self.optionalStringColumn(statement, index: 6),
                cityID: Self.stringColumn(statement, index: 8),
                cityName: Self.stringColumn(statement, index: 9),
                subcategoryID: Self.stringColumn(statement, index: 10),
                subcategoryTitle: Self.stringColumn(statement, index: 11),
                pageKind: Self.stringColumn(statement, index: 12),
                placeKind: Self.stringColumn(statement, index: 13),
                imageName: Self.optionalStringColumn(statement, index: 5)
            )
        }
    }

    func loadGraphCoverage() throws -> VietSQLitePhraseGraphCoverage {
        VietSQLitePhraseGraphCoverage(
            sourcePhraseRows: try count(.phrase),
            canonicalPhrasePages: try count(.phrasePage),
            resolvedPhraseRows: try intValue("""
                SELECT count(*)
                FROM phrase p
                JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id;
                """),
            searchDocuments: try count(.searchDocument),
            relationEdges: try intValue("SELECT count(*) FROM phrase_relation;"),
            duplicateCanonicalPageGroups: try intValue("""
                SELECT count(*)
                FROM (
                  SELECT p.normalized_target_text
                  FROM phrase_page pp
                  JOIN phrase p ON p.id = pp.phrase_id
                  GROUP BY p.normalized_target_text
                  HAVING count(*) > 1
                );
                """),
            brokenRelationEdges: try intValue("""
                SELECT count(*)
                FROM phrase_relation r
                WHERE r.source_kind != 'phrase_page'
                   OR r.target_kind != 'phrase_page'
                   OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.source_id)
                   OR NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = r.target_id);
                """),
            searchDocumentsWithMissingPageTargets: try intValue("""
                SELECT count(*)
                FROM search_document sd
                WHERE sd.target_kind = 'phrase_page'
                  AND NOT EXISTS (SELECT 1 FROM phrase_page pp WHERE pp.id = sd.target_id);
                """),
            audioUsageMismatches: try intValue("""
                SELECT count(*)
                FROM audio_usage au
                JOIN audio_asset aa ON aa.id = au.audio_asset_id
                WHERE au.normalized_expected_text != aa.normalized_spoken_text;
                """),
            missingAudioAuditRows: try intValue("SELECT count(*) FROM missing_audio_audit;")
        )
    }

    func loadCityPageHeroImageNames() throws -> [String: String] {
        let sql = """
        SELECT
          p.id,
          COALESCE(pp.hero_image_name, '')
        FROM phrase_page pp
        JOIN phrase p ON p.id = pp.phrase_id
        WHERE p.id LIKE 'city-%'
        ORDER BY p.id;
        """

        return Dictionary(uniqueKeysWithValues: try rows(sql) { statement in
            (
                Self.stringColumn(statement, index: 0),
                Self.stringColumn(statement, index: 1)
            )
        })
    }

    func canonicalPageID(forPhraseID phraseID: String) throws -> String {
        let sql = """
        SELECT pp.id
        FROM phrase p
        JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
        WHERE p.id = ?
        LIMIT 1;
        """

        do {
            return try stringValue(sql) { statement in
                try self.bindText(phraseID, to: 1, in: statement, sql: sql)
            }
        } catch VietSQLiteLanguagePackRepositoryError.emptyResult {
            throw VietSQLiteLanguagePackRepositoryError.missingPhrase(id: phraseID)
        }
    }

    func canonicalPageID(forPageIDOrAlias pageIDOrAlias: String) throws -> String {
        let sql = """
        SELECT id
        FROM phrase_page
        WHERE id = ?
        UNION ALL
        SELECT canonical_page_id
        FROM page_alias
        WHERE alias_id = ?
        LIMIT 1;
        """

        do {
            return try stringValue(sql) { statement in
                try self.bindText(pageIDOrAlias, to: 1, in: statement, sql: sql)
                try self.bindText(pageIDOrAlias, to: 2, in: statement, sql: sql)
            }
        } catch VietSQLiteLanguagePackRepositoryError.emptyResult {
            throw VietSQLiteLanguagePackRepositoryError.missingCanonicalPage(id: pageIDOrAlias)
        }
    }

    func canOpenPage(pageIDOrAlias: String) throws -> Bool {
        (try? canonicalPageID(forPageIDOrAlias: pageIDOrAlias)) != nil
    }

    func search(_ query: String, limit: Int = 8) throws -> [PhraseSearchResult] {
        guard !Self.searchComparableText(query).isEmpty else {
            return []
        }

        let expandedQueries = SearchQueryExpander.expandedQueries(for: query)
        let ftsQueries = Self.uniqueFTSQueries(for: expandedQueries)
        let looseQueries = SearchQueryExpander.looseFallbackQueries(for: query)
        let looseFTSQueries = Self.uniqueFTSQueries(for: looseQueries)
            .filter { !ftsQueries.contains($0) }

        let sql = """
        SELECT
          sd.target_id,
          pp.title,
          pp.english_title,
          (sd.priority_tier * 1000.0) - bm25(search_document_fts) AS search_rank
        FROM search_document_fts
        JOIN search_document sd ON sd.rowid = search_document_fts.rowid
        JOIN phrase_page pp ON pp.id = sd.target_id
        WHERE search_document_fts MATCH ?
          AND sd.target_kind = 'phrase_page'
        ORDER BY search_rank DESC, pp.title COLLATE NOCASE ASC
        LIMIT ?;
        """

        func results(for ftsQueries: [String], perQueryLimit: Int) throws -> [PhraseSearchResult] {
            try ftsQueries.flatMap { ftsQuery in
                try rows(sql, bind: { statement in
                    try self.bindText(ftsQuery, to: 1, in: statement, sql: sql)
                    try self.bindInt(perQueryLimit, to: 2, in: statement, sql: sql)
                }) { statement in
                    PhraseSearchResult(
                        pageID: Self.stringColumn(statement, index: 0),
                        title: Self.stringColumn(statement, index: 1),
                        subtitle: Self.stringColumn(statement, index: 2)
                    )
                }
            }
        }

        let strictResults = try results(for: ftsQueries, perQueryLimit: limit * 4)
        let looseResults = try results(for: looseFTSQueries, perQueryLimit: limit * 3)
        let rawResults = strictResults + looseResults

        let primaryRankingQueries = ([query] + SearchQueryExpander.looseRankingQueries(for: query))
            .map(Self.searchComparableText)
            .filter { !$0.isEmpty }
        let normalizedQueries = (expandedQueries + looseQueries)
            .map(Self.searchComparableText)
            .filter { !$0.isEmpty }
        var seenPageIDs = Set<String>()
        let scoredResults = rawResults.enumerated().compactMap { offset, result -> SearchScoredResult? in
            guard seenPageIDs.insert(result.pageID).inserted else {
                return nil
            }

            let identityText = Self.searchIdentityText(for: result)
            return SearchScoredResult(
                result: result,
                offset: offset,
                primaryScore: Self.searchIdentityScore(
                    for: identityText,
                    normalizedQueries: primaryRankingQueries
                ) + SearchQueryExpander.contextualRankingBoost(
                    for: query,
                    resultTitle: result.title,
                    resultSubtitle: result.subtitle
                ),
                secondaryScore: Self.searchIdentityScore(
                    for: identityText,
                    normalizedQueries: normalizedQueries
                )
            )
        }

        return scoredResults
        .sorted { left, right in
            if left.primaryScore != right.primaryScore {
                return left.primaryScore > right.primaryScore
            }

            if left.secondaryScore == right.secondaryScore {
                return left.offset < right.offset
            }

            return left.secondaryScore > right.secondaryScore
        }
        .map(\.result)
        .prefix(limit)
        .map { $0 }
    }

    func loadPhraseDetailPage(pageID: String) throws -> PhraseDetailPage {
        let canonicalPageID = try canonicalPageID(forPageIDOrAlias: pageID)
        let sql = """
        SELECT
          pp.id,
          p.id,
          pp.title,
          pp.english_title,
          p.pronunciation,
          pp.summary,
          pp.icon_name,
          pp.tint_name,
          pp.hero_image_name,
          aa.source_manifest_key,
          pps.cta_label,
          pct.page_kind
        FROM phrase_page pp
        JOIN phrase p ON p.id = pp.phrase_id
        LEFT JOIN phrase_city_tag pct ON pct.phrase_id = p.id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'phrase'
         AND au.target_id = p.id
         AND au.is_primary = 1
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        LEFT JOIN page_practice_seed pps ON pps.page_id = pp.id
        WHERE pp.id = ?
        LIMIT 1;
        """

        return try withPreparedStatement(sql) { statement in
            try self.bindText(canonicalPageID, to: 1, in: statement, sql: sql)

            guard sqlite3_step(statement) == SQLITE_ROW else {
                throw VietSQLiteLanguagePackRepositoryError.missingCanonicalPage(id: pageID)
            }

            let pageID = Self.stringColumn(statement, index: 0)
            let title = Self.stringColumn(statement, index: 2)
            let englishTitle = Self.stringColumn(statement, index: 3)
            let pronunciation = Self.stringColumn(statement, index: 4)
            let summary = Self.stringColumn(statement, index: 5)
            let iconName = Self.stringColumn(statement, index: 6)
            let tintName = AccentTint(rawValue: Self.stringColumn(statement, index: 7)) ?? .gray
            let heroImageName = Self.optionalStringColumn(statement, index: 8)
            let audioKey = Self.optionalStringColumn(statement, index: 9)
            let practiceCTALabel = Self.optionalStringColumn(statement, index: 10)
            let pageKind = Self.stringColumn(statement, index: 11)
            let suppressDerivedPlacePhraseRows = Self.entityPageKinds.contains(pageKind)

            return PhraseDetailPage(
                id: pageID,
                title: title,
                englishTitle: englishTitle,
                pronunciation: pronunciation,
                summary: summary,
                iconName: iconName,
                tintName: tintName,
                heroImageName: heroImageName,
                sections: try loadSections(
                    forPageID: pageID,
                    suppressDerivedPlacePhraseRows: suppressDerivedPlacePhraseRows
                ),
                examples: [],
                audioKey: audioKey,
                practiceCTALabel: practiceCTALabel,
                showsCatalogExplore: true
            )
        }
    }

    func heroImageName(forPageIDOrAlias pageID: String) throws -> String? {
        let canonicalPageID = try canonicalPageID(forPageIDOrAlias: pageID)
        let sql = """
        SELECT hero_image_name
        FROM phrase_page
        WHERE id = ?
        LIMIT 1;
        """

        return try withPreparedStatement(sql) { statement in
            try self.bindText(canonicalPageID, to: 1, in: statement, sql: sql)

            guard sqlite3_step(statement) == SQLITE_ROW else {
                throw VietSQLiteLanguagePackRepositoryError.missingCanonicalPage(id: pageID)
            }

            return Self.optionalStringColumn(statement, index: 0)
        }
    }

    func relatedPages(forPageID pageID: String, limit: Int = 8) throws -> [PhraseLink] {
        let canonicalPageID = try canonicalPageID(forPageIDOrAlias: pageID)
        let sql = """
        SELECT
          r.id,
          pp.id,
          pp.title,
          pp.english_title,
          COALESCE(NULLIF(r.display_label, ''), r.relation_type),
          pp.icon_name,
          pp.tint_name
        FROM phrase_relation r
        JOIN phrase_page pp ON pp.id = r.target_id
        WHERE r.source_kind = 'phrase_page'
          AND r.target_kind = 'phrase_page'
          AND r.source_id = ?
        ORDER BY r.sort_order, r.relation_type, pp.title
        LIMIT ?;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(canonicalPageID, to: 1, in: statement, sql: sql)
            try self.bindInt(limit, to: 2, in: statement, sql: sql)
        }) { statement in
            let tint = AccentTint(rawValue: Self.stringColumn(statement, index: 6)) ?? .gray
            return PhraseLink(
                id: Self.stringColumn(statement, index: 0),
                vietnamese: Self.stringColumn(statement, index: 2),
                english: Self.stringColumn(statement, index: 3),
                relation: Self.stringColumn(statement, index: 4),
                symbolName: Self.stringColumn(statement, index: 5),
                tintName: tint,
                detailPageID: Self.stringColumn(statement, index: 1)
            )
        }
    }

    func relatedPagesLookupPlan(forPageID pageID: String, limit: Int = 8) throws -> [String] {
        let canonicalPageID = try canonicalPageID(forPageIDOrAlias: pageID)
        let sql = """
        EXPLAIN QUERY PLAN
        SELECT
          r.id,
          pp.id,
          pp.title,
          pp.english_title,
          COALESCE(NULLIF(r.display_label, ''), r.relation_type),
          pp.icon_name,
          pp.tint_name
        FROM phrase_relation r
        JOIN phrase_page pp ON pp.id = r.target_id
        WHERE r.source_kind = 'phrase_page'
          AND r.target_kind = 'phrase_page'
          AND r.source_id = ?
        ORDER BY r.sort_order, r.relation_type, pp.title
        LIMIT ?;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(canonicalPageID, to: 1, in: statement, sql: sql)
            try self.bindInt(limit, to: 2, in: statement, sql: sql)
        }) { statement in
            Self.stringColumn(statement, index: 3)
        }
    }

    func visibleAudioUsages(forPageID pageID: String) throws -> [VietSQLiteVisibleAudioUsage] {
        let canonicalPageID = try canonicalPageID(forPageIDOrAlias: pageID)
        let sql = """
        WITH section_items AS (
          SELECT psi.item_kind, psi.target_id
          FROM page_section ps
          JOIN page_section_item psi ON psi.section_id = ps.id
          WHERE ps.page_id = ?
        ),
        page_phrase AS (
          SELECT p.id
          FROM phrase_page pp
          JOIN phrase p ON p.id = pp.phrase_id
          WHERE pp.id = ?
        )
        SELECT DISTINCT
          au.usage_kind,
          au.target_kind,
          au.target_id,
          aa.source_manifest_key,
          au.expected_text
        FROM audio_usage au
        JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE (
          au.target_kind = 'phrase'
          AND au.target_id IN (
            SELECT id FROM page_phrase
            UNION
            SELECT target_id FROM section_items WHERE item_kind = 'phrase'
          )
        )
        OR (
          au.target_kind = 'authored_phrase'
          AND au.target_id IN (
            SELECT target_id FROM section_items WHERE item_kind = 'authored_phrase'
          )
        )
        OR (
          au.target_kind = 'breakdown_token'
          AND au.target_id IN (
            SELECT target_id FROM section_items WHERE item_kind = 'breakdown_token'
          )
        )
        ORDER BY au.usage_kind, au.target_kind, au.target_id;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(canonicalPageID, to: 1, in: statement, sql: sql)
            try self.bindText(canonicalPageID, to: 2, in: statement, sql: sql)
        }) { statement in
            VietSQLiteVisibleAudioUsage(
                usageKind: Self.stringColumn(statement, index: 0),
                targetKind: Self.stringColumn(statement, index: 1),
                targetID: Self.stringColumn(statement, index: 2),
                audioKey: Self.stringColumn(statement, index: 3),
                expectedText: Self.stringColumn(statement, index: 4)
            )
        }
    }

    private static let entityPageKinds: Set<String> = [
        "place",
        "restaurant",
        "dish",
    ]

    private func loadSections(
        forPageID pageID: String,
        suppressDerivedPlacePhraseRows: Bool = false
    ) throws -> [PhraseDetailSection] {
        let sql = """
        SELECT id, section_key, title, body, presentation
        FROM page_section
        WHERE page_id = ?
        ORDER BY sort_order;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(pageID, to: 1, in: statement, sql: sql)
        }) { statement in
            let sectionID = Self.stringColumn(statement, index: 0)
            let sectionKey = Self.stringColumn(statement, index: 1)
            let presentation = Self.sectionPresentation(Self.stringColumn(statement, index: 4))

            return PhraseDetailSection(
                id: sectionKey,
                title: Self.stringColumn(statement, index: 2),
                body: Self.stringColumn(statement, index: 3),
                phrases: try loadPhraseOptions(
                    forSectionID: sectionID,
                    suppressDerivedPlacePhraseRows: suppressDerivedPlacePhraseRows
                ),
                breakdown: try loadBreakdownTokens(forSectionID: sectionID),
                presentation: presentation
            )
        }
    }

    private func loadPhraseOptions(
        forSectionID sectionID: String,
        suppressDerivedPlacePhraseRows: Bool = false
    ) throws -> [PhraseOption] {
        let sql = """
        SELECT
          psi.id,
          psi.item_kind,
          psi.target_id,
          COALESCE(NULLIF(psi.title_override, ''), p.target_text, ''),
          COALESCE(NULLIF(psi.subtitle_override, ''), p.english_text, ''),
          COALESCE(p.pronunciation, ''),
          COALESCE(pp.icon_name, 'speaker.wave.2.fill'),
          COALESCE(pp.tint_name, 'red'),
          pp.id,
          aa.source_manifest_key
        FROM page_section_item psi
        LEFT JOIN phrase p ON p.id = psi.target_id
        LEFT JOIN phrase_page pp ON pp.phrase_id = p.canonical_phrase_id
        LEFT JOIN audio_usage au
          ON (
            psi.item_kind = 'phrase'
            AND au.target_kind = 'phrase'
            AND au.target_id = p.id
            AND au.is_primary = 1
          )
          OR (
            psi.item_kind = 'authored_phrase'
            AND au.target_kind = 'authored_phrase'
            AND au.target_id = psi.target_id
          )
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE psi.section_id = ?
          AND psi.item_kind IN ('phrase', 'authored_phrase')
          AND (
            ? = 0
            OR psi.item_kind != 'phrase'
            OR pp.id IS NULL
            OR NOT EXISTS (
              SELECT 1
              FROM page_category pc
              WHERE pc.page_id = pp.id
                AND pc.category_id = 'derived-place-phrases'
            )
          )
        ORDER BY psi.sort_order;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(sectionID, to: 1, in: statement, sql: sql)
            try self.bindInt(suppressDerivedPlacePhraseRows ? 1 : 0, to: 2, in: statement, sql: sql)
        }) { statement in
            let itemKind = Self.stringColumn(statement, index: 1)
            let targetID = Self.stringColumn(statement, index: 2)
            let detailPageID = itemKind == "phrase" ? Self.optionalStringColumn(statement, index: 8) : nil
            let tint = AccentTint(rawValue: Self.stringColumn(statement, index: 7)) ?? .red

            return PhraseOption(
                id: targetID.isEmpty ? Self.stringColumn(statement, index: 0) : targetID,
                vietnamese: Self.stringColumn(statement, index: 3),
                english: Self.stringColumn(statement, index: 4),
                pronunciation: Self.stringColumn(statement, index: 5),
                symbolName: Self.stringColumn(statement, index: 6),
                tintName: tint,
                detailPageID: detailPageID,
                audioKey: Self.optionalStringColumn(statement, index: 9)
            )
        }
    }

    private func loadBreakdownTokens(forSectionID sectionID: String) throws -> [BreakdownToken] {
        let sql = """
        SELECT
          bt.id,
          bt.token_text,
          bt.english_gloss,
          aa.source_manifest_key
        FROM page_section_item psi
        JOIN breakdown_token bt ON bt.id = psi.target_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'breakdown_token'
         AND au.target_id = bt.id
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE psi.section_id = ?
          AND psi.item_kind = 'breakdown_token'
        ORDER BY psi.sort_order;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(sectionID, to: 1, in: statement, sql: sql)
        }) { statement in
            BreakdownToken(
                id: Self.stringColumn(statement, index: 0),
                vietnamese: Self.stringColumn(statement, index: 1),
                english: Self.stringColumn(statement, index: 2),
                audioKey: Self.optionalStringColumn(statement, index: 3)
            )
        }
    }

    private func loadPracticeBreakdownTokens(forPageID pageID: String) throws -> [BreakdownToken] {
        let sql = """
        SELECT
          bt.id,
          bt.token_text,
          bt.english_gloss,
          aa.source_manifest_key
        FROM page_section ps
        JOIN page_section_item psi ON psi.section_id = ps.id
        JOIN breakdown_token bt ON bt.id = psi.target_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'breakdown_token'
         AND au.target_id = bt.id
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE ps.page_id = ?
          AND psi.item_kind = 'breakdown_token'
        ORDER BY ps.sort_order, psi.sort_order;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(pageID, to: 1, in: statement, sql: sql)
        }) { statement in
            BreakdownToken(
                id: Self.stringColumn(statement, index: 0),
                vietnamese: Self.stringColumn(statement, index: 1),
                english: Self.stringColumn(statement, index: 2),
                audioKey: Self.optionalStringColumn(statement, index: 3)
            )
        }
    }

    private func loadPracticeBreakdownTokens(forPageIDs pageIDs: [String]) throws -> [String: [BreakdownToken]] {
        guard !pageIDs.isEmpty else {
            return [:]
        }

        let uniquePageIDs = Array(Set(pageIDs)).sorted()
        let placeholders = Array(repeating: "?", count: uniquePageIDs.count).joined(separator: ", ")
        let sql = """
        SELECT
          ps.page_id,
          bt.id,
          bt.token_text,
          bt.english_gloss,
          aa.source_manifest_key
        FROM page_section ps
        JOIN page_section_item psi ON psi.section_id = ps.id
        JOIN breakdown_token bt ON bt.id = psi.target_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'breakdown_token'
         AND au.target_id = bt.id
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
        WHERE ps.page_id IN (\(placeholders))
          AND psi.item_kind = 'breakdown_token'
        ORDER BY ps.page_id, ps.sort_order, psi.sort_order;
        """

        let rows = try rows(sql, bind: { statement in
            for (offset, pageID) in uniquePageIDs.enumerated() {
                try self.bindText(pageID, to: Int32(offset + 1), in: statement, sql: sql)
            }
        }) { statement in
            (
                pageID: Self.stringColumn(statement, index: 0),
                token: BreakdownToken(
                    id: Self.stringColumn(statement, index: 1),
                    vietnamese: Self.stringColumn(statement, index: 2),
                    english: Self.stringColumn(statement, index: 3),
                    audioKey: Self.optionalStringColumn(statement, index: 4)
                )
            )
        }

        return rows.reduce(into: [String: [BreakdownToken]]()) { result, row in
            result[row.pageID, default: []].append(row.token)
        }
    }

    private func stringValue(
        _ sql: String,
        bind: ((OpaquePointer) throws -> Void)? = nil
    ) throws -> String {
        try withPreparedStatement(sql) { statement in
            try bind?(statement)
            let result = sqlite3_step(statement)
            guard result == SQLITE_ROW else {
                if result == SQLITE_DONE {
                    throw VietSQLiteLanguagePackRepositoryError.emptyResult(sql: sql)
                }

                throw VietSQLiteLanguagePackRepositoryError.stepFailed(
                    sql: sql,
                    message: errorMessage()
                )
            }

            return Self.stringColumn(statement, index: 0)
        }
    }

    private func intValue(
        _ sql: String,
        bind: ((OpaquePointer) throws -> Void)? = nil
    ) throws -> Int {
        try withPreparedStatement(sql) { statement in
            try bind?(statement)
            let result = sqlite3_step(statement)
            guard result == SQLITE_ROW else {
                if result == SQLITE_DONE {
                    throw VietSQLiteLanguagePackRepositoryError.emptyResult(sql: sql)
                }

                throw VietSQLiteLanguagePackRepositoryError.stepFailed(
                    sql: sql,
                    message: errorMessage()
                )
            }

            return Int(sqlite3_column_int64(statement, 0))
        }
    }

    private func rows<Value>(
        _ sql: String,
        bind: ((OpaquePointer) throws -> Void)? = nil,
        map: (OpaquePointer) throws -> Value
    ) throws -> [Value] {
        try withPreparedStatement(sql) { statement in
            try bind?(statement)

            var values: [Value] = []
            while true {
                let result = sqlite3_step(statement)
                if result == SQLITE_ROW {
                    values.append(try map(statement))
                } else if result == SQLITE_DONE {
                    return values
                } else {
                    throw VietSQLiteLanguagePackRepositoryError.stepFailed(
                        sql: sql,
                        message: errorMessage()
                    )
                }
            }
        }
    }

    private func withPreparedStatement<Value>(
        _ sql: String,
        _ body: (OpaquePointer) throws -> Value
    ) throws -> Value {
        guard let database else {
            throw VietSQLiteLanguagePackRepositoryError.openFailed(
                path: databaseURL.path,
                message: "database handle is closed"
            )
        }

        var statement: OpaquePointer?
        guard sqlite3_prepare_v2(database, sql, -1, &statement, nil) == SQLITE_OK, let statement else {
            throw VietSQLiteLanguagePackRepositoryError.prepareFailed(
                sql: sql,
                message: errorMessage()
            )
        }

        defer {
            sqlite3_finalize(statement)
        }

        return try body(statement)
    }

    private func bindText(
        _ value: String,
        to index: Int32,
        in statement: OpaquePointer,
        sql: String
    ) throws {
        guard sqlite3_bind_text(statement, index, value, -1, sqliteTransient) == SQLITE_OK else {
            throw VietSQLiteLanguagePackRepositoryError.bindFailed(
                sql: sql,
                message: errorMessage()
            )
        }
    }

    private func bindInt(
        _ value: Int,
        to index: Int32,
        in statement: OpaquePointer,
        sql: String
    ) throws {
        guard sqlite3_bind_int64(statement, index, sqlite3_int64(value)) == SQLITE_OK else {
            throw VietSQLiteLanguagePackRepositoryError.bindFailed(
                sql: sql,
                message: errorMessage()
            )
        }
    }

    private func errorMessage() -> String {
        guard let database else {
            return "database handle is closed"
        }

        return Self.errorMessage(database: database)
    }

    private static func errorMessage(database: OpaquePointer) -> String {
        String(cString: sqlite3_errmsg(database))
    }

    private static func stringColumn(_ statement: OpaquePointer, index: Int32) -> String {
        guard let text = sqlite3_column_text(statement, index) else {
            return ""
        }

        return String(cString: text)
    }

    private static func optionalStringColumn(_ statement: OpaquePointer, index: Int32) -> String? {
        guard sqlite3_column_type(statement, index) != SQLITE_NULL else {
            return nil
        }

        let value = stringColumn(statement, index: index)
        return value.isEmpty ? nil : value
    }

    private static func jsonStringArrayColumn(
        _ statement: OpaquePointer,
        index: Int32,
        name: String
    ) throws -> [String] {
        let value = stringColumn(statement, index: index)
        guard let data = value.data(using: .utf8) else {
            throw VietSQLiteLanguagePackRepositoryError.invalidJSONColumn(name: name, value: value)
        }

        do {
            return try JSONDecoder().decode([String].self, from: data)
        } catch {
            throw VietSQLiteLanguagePackRepositoryError.invalidJSONColumn(name: name, value: value)
        }
    }

    private static func vietnameseMenuOrderLine(statement: OpaquePointer) -> VietnameseMenuOrderLine? {
        guard
            let vietnamese = optionalStringColumn(statement, index: 24),
            let english = optionalStringColumn(statement, index: 25),
            let pronunciation = optionalStringColumn(statement, index: 26),
            let audioPolicy = optionalStringColumn(statement, index: 27)
        else {
            return nil
        }

        return VietnameseMenuOrderLine(
            vietnamese: vietnamese,
            english: english,
            pronunciation: pronunciation,
            audioPolicy: audioPolicy
        )
    }

    private static func vietnameseMenuEditorialReview(
        statement: OpaquePointer
    ) throws -> VietnameseMenuEditorialReview? {
        guard let status = optionalStringColumn(statement, index: 29) else {
            return nil
        }

        return VietnameseMenuEditorialReview(
            status: status,
            reviewedBy: optionalStringColumn(statement, index: 30),
            reviewedAt: optionalStringColumn(statement, index: 31),
            checks: try jsonStringArrayColumn(
                statement,
                index: 32,
                name: "vietnamese_menu_item.editorial_review_checks_json"
            ),
            reviewNote: optionalStringColumn(statement, index: 33)
        )
    }

    private static func sectionPresentation(_ value: String) -> SectionPresentation {
        if value == "warning-callout" {
            return .tipCallout
        }

        return SectionPresentation(rawValue: value) ?? .plainText
    }

    private static func ftsQuery(for query: String) -> String {
        searchComparableText(query)
            .split(separator: " ")
            .map { "\($0)*" }
            .joined(separator: " ")
    }

    private static func uniqueFTSQueries(for queries: [String]) -> [String] {
        var seen = Set<String>()

        return queries.compactMap { query in
            let ftsQuery = ftsQuery(for: query)
            guard !ftsQuery.isEmpty, seen.insert(ftsQuery).inserted else {
                return nil
            }

            return ftsQuery
        }
    }

    private static func searchComparableText(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
            .unicodeScalars
            .map { scalar in
                CharacterSet.alphanumerics.contains(scalar) ? String(scalar) : " "
            }
            .joined()
            .split(separator: " ")
            .joined(separator: " ")
    }

    private struct SearchIdentityText {
        let title: String
        let subtitle: String
        let titleTokens: [Substring]
        let subtitleTokens: [Substring]
        let shortestTokenCount: Int
    }

    private struct SearchScoredResult {
        let result: PhraseSearchResult
        let offset: Int
        let primaryScore: Int
        let secondaryScore: Int
    }

    private static func searchIdentityText(for result: PhraseSearchResult) -> SearchIdentityText {
        let title = searchComparableText(result.title)
        let subtitle = searchComparableText(result.subtitle)
        let titleTokens = title.split(separator: " ")
        let subtitleTokens = subtitle.split(separator: " ")
        let shortestTokenCount = min(
            titleTokens.isEmpty ? Int.max : titleTokens.count,
            subtitleTokens.isEmpty ? Int.max : subtitleTokens.count
        )

        return SearchIdentityText(
            title: title,
            subtitle: subtitle,
            titleTokens: titleTokens,
            subtitleTokens: subtitleTokens,
            shortestTokenCount: shortestTokenCount
        )
    }

    private static func searchIdentityScore(for result: PhraseSearchResult, normalizedQuery: String) -> Int {
        searchIdentityScore(for: searchIdentityText(for: result), normalizedQuery: normalizedQuery)
    }

    private static func searchIdentityScore(for identityText: SearchIdentityText, normalizedQuery: String) -> Int {
        guard !normalizedQuery.isEmpty else {
            return 0
        }

        let title = identityText.title
        let subtitle = identityText.subtitle
        var score = 0

        if title == normalizedQuery {
            score += 10_000
        }

        if subtitle == normalizedQuery {
            score += 9_500
        }

        if title.hasPrefix(normalizedQuery) {
            score += 3_000
        }

        if subtitle.hasPrefix(normalizedQuery) {
            score += 2_800
        }

        if identityText.titleTokens.contains(Substring(normalizedQuery)) {
            score += 2_400
        }

        if identityText.subtitleTokens.contains(Substring(normalizedQuery)) {
            score += 2_200
        }

        if title.contains(normalizedQuery) {
            score += 1_800
        }

        if subtitle.contains(normalizedQuery) {
            score += 1_600
        }

        if score > 0, identityText.shortestTokenCount != Int.max {
            score += max(0, 500 - identityText.shortestTokenCount * 40)
        }

        let tokenScore = searchVisibleTokenScore(
            title: title,
            subtitle: subtitle,
            normalizedQuery: normalizedQuery
        )
        score += tokenScore

        return score
    }

    private static func searchIdentityScore(for result: PhraseSearchResult, normalizedQueries: [String]) -> Int {
        searchIdentityScore(for: searchIdentityText(for: result), normalizedQueries: normalizedQueries)
    }

    private static func searchIdentityScore(for identityText: SearchIdentityText, normalizedQueries: [String]) -> Int {
        normalizedQueries
            .map { searchIdentityScore(for: identityText, normalizedQuery: $0) }
            .max() ?? 0
    }

    private static let searchRankingStopwords: Set<String> = [
        "a",
        "am",
        "an",
        "and",
        "are",
        "as",
        "at",
        "be",
        "can",
        "could",
        "do",
        "does",
        "for",
        "from",
        "get",
        "give",
        "have",
        "how",
        "i",
        "in",
        "is",
        "it",
        "me",
        "my",
        "new",
        "of",
        "on",
        "or",
        "please",
        "show",
        "that",
        "the",
        "this",
        "to",
        "want",
        "where",
        "with",
        "you",
        "your",
    ]

    private static let shortSearchRankingTokens: Set<String> = [
        "qr",
        "sim",
        "atm",
        "wc",
        "ve",
    ]

    private static func searchVisibleTokenScore(
        title: String,
        subtitle: String,
        normalizedQuery: String
    ) -> Int {
        let queryTokens = normalizedQuery
            .split(separator: " ")
            .map(String.init)
            .filter { token in
                !searchRankingStopwords.contains(token)
                    && (token.count >= 3 || shortSearchRankingTokens.contains(token))
            }
        guard !queryTokens.isEmpty else {
            return 0
        }

        let visibleText = "\(title) \(subtitle)"
        let visibleTokens = Set(visibleText.split(separator: " ").map(String.init))
        let compactVisibleText = visibleText.replacingOccurrences(of: " ", with: "")
        var matchedTokenCount = 0

        for token in queryTokens {
            let variants = searchRankingTokenVariants(for: token)
            let matched = variants.contains { variant in
                visibleTokens.contains(variant)
                    || visibleTokens.contains { visibleToken in
                        visibleToken.hasPrefix(variant)
                            || (variant.count >= 4 && variant.hasPrefix(visibleToken))
                    }
                    || compactVisibleText.contains(variant)
            }

            if matched {
                matchedTokenCount += 1
            }
        }

        guard matchedTokenCount > 0 else {
            return 0
        }

        var score = matchedTokenCount * 180
        if matchedTokenCount >= 2 {
            score += 420
        }
        if matchedTokenCount == queryTokens.count {
            score += 850
        }

        return score
    }

    private static func searchRankingTokenVariants(for token: String) -> Set<String> {
        var variants: Set<String> = [token]

        if token.count > 3, token.hasSuffix("ies"), token.count > 4 {
            variants.insert(String(token.dropLast(3)) + "y")
        } else if token.count > 3,
                  token.hasSuffix("ses") || token.hasSuffix("xes") || token.hasSuffix("ches") || token.hasSuffix("shes") {
            variants.insert(String(token.dropLast(2)))
        } else if token.count > 3, token.hasSuffix("s"), !token.hasSuffix("ss") {
            variants.insert(String(token.dropLast()))
        }

        return variants
    }
}

enum VietSQLitePhraseGraphRuntime {
    static let launchArgument = "--use-sqlite-phrase-graph"
    static let environmentVariable = "SPEAKLOCAL_USE_SQLITE_GRAPH"
    static let disabledLaunchArgument = "--disable-sqlite-phrase-graph"
    static let disabledEnvironmentVariable = "SPEAKLOCAL_DISABLE_SQLITE_GRAPH"
    private static let canonicalPageIDCacheLimit = 512
    private static let heroImageNameCacheLimit = 512
    private static let detailPageCacheLimit = 96
    private static let searchResultCacheLimit = 32
    private static let cacheLock = NSLock()

    static var isEnabled: Bool {
#if DEBUG
        if let isEnabledOverride {
            return isEnabledOverride
        }
#endif

        if ProcessInfo.processInfo.arguments.contains(disabledLaunchArgument)
            || ProcessInfo.processInfo.environment[disabledEnvironmentVariable] == "1" {
            return false
        }

        return true
    }

    static func catalogSnapshot() -> VietSQLitePhraseCatalogSnapshot? {
        guard isEnabled, let repository = repository(surface: "PhraseCatalog.catalogSnapshot") else {
            return nil
        }

        do {
            return try repository.loadCatalogSnapshot()
        } catch {
            VietSQLiteRuntimeDiagnostics.reportFallback(surface: "PhraseCatalog.catalogSnapshot", error: error)
            return nil
        }
    }

    static func canonicalPageID(for pageIDOrAlias: String) -> String? {
        if let cachedResult = cachedCanonicalPageID(for: pageIDOrAlias) {
            return cachedResult
        }

        guard isEnabled, let repository = repository() else {
            return nil
        }

        let canonicalPageID = try? repository.canonicalPageID(forPageIDOrAlias: pageIDOrAlias)
        storeCachedCanonicalPageID(canonicalPageID, for: pageIDOrAlias)
        return canonicalPageID
    }

    static func search(_ query: String, limit: Int = 8) -> [PhraseSearchResult]? {
        let cacheKey = searchCacheKey(query: query, limit: limit)
        if let cachedResults = cachedSearchResults(for: cacheKey) {
            return cachedResults
        }

        guard isEnabled, let repository = repository() else {
            return nil
        }

        guard let results = try? repository.search(query, limit: limit) else {
            return nil
        }

        storeCachedSearchResults(results, for: cacheKey)
        return results
    }

    static func vietnameseMenuPayload() -> VietnameseMenuPayload? {
        if let cachedVietnameseMenuPayload {
            return cachedVietnameseMenuPayload
        }

        guard isEnabled, let repository = repository(surface: "VietnameseMenuCatalog") else {
            return nil
        }

        do {
            let payload = try repository.loadVietnameseMenuPayload()
            cachedVietnameseMenuPayload = payload
            return payload
        } catch {
            VietSQLiteRuntimeDiagnostics.reportFallback(surface: "VietnameseMenuCatalog", error: error)
            return nil
        }
    }

    static func detailPage(withID pageID: String) -> PhraseDetailPage? {
        if let cachedPage = cachedDetailPage(for: pageID) {
            return cachedPage
        }

        guard isEnabled, let repository = repository() else {
            return nil
        }

        if
            let canonicalPageID = try? repository.canonicalPageID(forPageIDOrAlias: pageID),
            let cachedPage = cachedDetailPage(for: canonicalPageID) {
            storeCachedDetailPage(cachedPage, for: pageID)
            return cachedPage
        }

        guard let page = try? repository.loadPhraseDetailPage(pageID: pageID) else {
            return nil
        }

        storeCachedDetailPage(page, for: pageID)
        storeCachedDetailPage(page, for: page.id)
        return page
    }

    static func heroImageName(for pageID: String) -> String? {
        if let cachedHeroImageName = cachedHeroImageName(for: pageID) {
            return cachedHeroImageName.value
        }

        guard isEnabled, let repository = repository() else {
            return nil
        }

        let heroImageName = try? repository.heroImageName(forPageIDOrAlias: pageID)
        storeCachedHeroImageName(heroImageName, for: pageID)
        return heroImageName
    }

    static func canOpenPage(_ pageID: String) -> Bool {
        canonicalPageID(for: pageID) != nil
    }

    private static func repository(surface: String = "VietSQLitePhraseGraphRuntime") -> VietSQLiteLanguagePackRepository? {
        if let cachedRepository {
            return cachedRepository
        }

        do {
            cachedRepository = try VietSQLiteLanguagePackRepository.bundled()
        } catch {
            if !hasReportedRepositoryOpenFailure {
                VietSQLiteRuntimeDiagnostics.reportFallback(surface: surface, error: error)
                hasReportedRepositoryOpenFailure = true
            }
            return nil
        }

        return cachedRepository
    }

    private static func searchCacheKey(query: String, limit: Int) -> String {
        let normalizedQuery = query
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .folding(options: [.diacriticInsensitive, .caseInsensitive], locale: .current)
            .lowercased()
        return "\(limit)|\(normalizedQuery)"
    }

    private static func cachedSearchResults(for key: String) -> [PhraseSearchResult]? {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        guard let results = cachedSearchResultsByKey[key] else {
            return nil
        }

        touchCacheKey(key, in: &cachedSearchResultKeys)
        return results
    }

    private static func cachedCanonicalPageID(for key: String) -> String?? {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        guard let cachedResult = cachedCanonicalPageIDsByAlias[key] else {
            return nil
        }

        touchCacheKey(key, in: &cachedCanonicalPageIDKeys)
        return .some(cachedResult.value)
    }

    private static func storeCachedCanonicalPageID(_ value: String?, for key: String) {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        cachedCanonicalPageIDsByAlias[key] = CachedCanonicalPageID(value)
        touchCacheKey(key, in: &cachedCanonicalPageIDKeys)
        trimCache(
            keys: &cachedCanonicalPageIDKeys,
            limit: canonicalPageIDCacheLimit,
            removeValue: { cachedCanonicalPageIDsByAlias.removeValue(forKey: $0) }
        )
    }

    private static func storeCachedSearchResults(_ results: [PhraseSearchResult], for key: String) {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        cachedSearchResultsByKey[key] = results
        touchCacheKey(key, in: &cachedSearchResultKeys)
        trimCache(
            keys: &cachedSearchResultKeys,
            limit: searchResultCacheLimit,
            removeValue: { cachedSearchResultsByKey.removeValue(forKey: $0) }
        )
    }

    private static func cachedHeroImageName(for key: String) -> CachedOptionalString? {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        guard let imageName = cachedHeroImageNamesByID[key] else {
            return nil
        }

        touchCacheKey(key, in: &cachedHeroImageNameKeys)
        return imageName
    }

    private static func storeCachedHeroImageName(_ imageName: String?, for key: String) {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        cachedHeroImageNamesByID[key] = CachedOptionalString(imageName)
        touchCacheKey(key, in: &cachedHeroImageNameKeys)
        trimCache(
            keys: &cachedHeroImageNameKeys,
            limit: heroImageNameCacheLimit,
            removeValue: { cachedHeroImageNamesByID.removeValue(forKey: $0) }
        )
    }

    private static func cachedDetailPage(for key: String) -> PhraseDetailPage? {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        guard let page = cachedDetailPagesByID[key] else {
            return nil
        }

        touchCacheKey(key, in: &cachedDetailPageKeys)
        return page
    }

    private static func storeCachedDetailPage(_ page: PhraseDetailPage, for key: String) {
        cacheLock.lock()
        defer { cacheLock.unlock() }

        cachedDetailPagesByID[key] = page
        touchCacheKey(key, in: &cachedDetailPageKeys)
        trimCache(
            keys: &cachedDetailPageKeys,
            limit: detailPageCacheLimit,
            removeValue: { cachedDetailPagesByID.removeValue(forKey: $0) }
        )
    }

    private static func touchCacheKey(_ key: String, in keys: inout [String]) {
        keys.removeAll { $0 == key }
        keys.append(key)
    }

    private static func trimCache(
        keys: inout [String],
        limit: Int,
        removeValue: (String) -> Void
    ) {
        while keys.count > limit {
            removeValue(keys.removeFirst())
        }
    }

    private enum CachedCanonicalPageID {
        case found(String)
        case missing

        init(_ value: String?) {
            if let value {
                self = .found(value)
            } else {
                self = .missing
            }
        }

        var value: String? {
            switch self {
            case .found(let value):
                return value
            case .missing:
                return nil
            }
        }
    }

    private enum CachedOptionalString {
        case found(String)
        case missing

        init(_ value: String?) {
            if let value {
                self = .found(value)
            } else {
                self = .missing
            }
        }

        var value: String? {
            switch self {
            case .found(let value):
                return value
            case .missing:
                return nil
            }
        }
    }

    private static var cachedRepository: VietSQLiteLanguagePackRepository?
    private static var cachedCanonicalPageIDsByAlias: [String: CachedCanonicalPageID] = [:]
    private static var cachedCanonicalPageIDKeys: [String] = []
    private static var cachedHeroImageNamesByID: [String: CachedOptionalString] = [:]
    private static var cachedHeroImageNameKeys: [String] = []
    private static var cachedDetailPagesByID: [String: PhraseDetailPage] = [:]
    private static var cachedDetailPageKeys: [String] = []
    private static var cachedSearchResultsByKey: [String: [PhraseSearchResult]] = [:]
    private static var cachedSearchResultKeys: [String] = []
    private static var cachedVietnameseMenuPayload: VietnameseMenuPayload?
    private static var hasReportedRepositoryOpenFailure = false

#if DEBUG
    static var detailPageCacheLimitForTesting: Int { detailPageCacheLimit }
    static var searchResultCacheLimitForTesting: Int { searchResultCacheLimit }

    static var cachedCanonicalPageIDCountForTesting: Int {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return cachedCanonicalPageIDsByAlias.count
    }

    static var cachedDetailPageCountForTesting: Int {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return cachedDetailPagesByID.count
    }

    static var cachedSearchResultCountForTesting: Int {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        return cachedSearchResultsByKey.count
    }

    static func setEnabledForTesting(_ enabled: Bool) {
        isEnabledOverride = enabled
        cachedRepository = nil
        clearCachesForTesting()
        cachedVietnameseMenuPayload = nil
        hasReportedRepositoryOpenFailure = false
        PhraseCatalog.resetCacheForTesting()
    }

    static func resetTestingOverrides() {
        isEnabledOverride = nil
        cachedRepository = nil
        clearCachesForTesting()
        cachedVietnameseMenuPayload = nil
        hasReportedRepositoryOpenFailure = false
        PhraseCatalog.resetCacheForTesting()
    }

    private static func clearCachesForTesting() {
        cacheLock.lock()
        defer { cacheLock.unlock() }
        cachedCanonicalPageIDsByAlias.removeAll()
        cachedCanonicalPageIDKeys.removeAll()
        cachedHeroImageNamesByID.removeAll()
        cachedHeroImageNameKeys.removeAll()
        cachedDetailPagesByID.removeAll()
        cachedDetailPageKeys.removeAll()
        cachedSearchResultsByKey.removeAll()
        cachedSearchResultKeys.removeAll()
    }

    private static var isEnabledOverride: Bool?
#endif
}

private let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
