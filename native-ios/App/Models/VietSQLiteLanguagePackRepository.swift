import Foundation
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
            let categoryIDs = Self.stringColumn(statement, index: 6)
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
          cs.title
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
            let categoryIDs = Self.stringColumn(statement, index: 6)
                .split(separator: "|")
                .map(String.init)

            return BrowseCityCollectionItem(
                pageID: Self.stringColumn(statement, index: 0),
                title: Self.stringColumn(statement, index: 1),
                subtitle: Self.stringColumn(statement, index: 2),
                categoryIDs: categoryIDs.isEmpty ? ["city-guides"] : categoryIDs,
                symbolName: Self.stringColumn(statement, index: 3),
                tintName: AccentTint(rawValue: Self.stringColumn(statement, index: 4)) ?? .gray,
                audioKey: Self.optionalStringColumn(statement, index: 5),
                cityID: Self.stringColumn(statement, index: 7),
                cityName: Self.stringColumn(statement, index: 8),
                subcategoryID: Self.stringColumn(statement, index: 9),
                subcategoryTitle: Self.stringColumn(statement, index: 10)
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
        let ftsQuery = Self.ftsQuery(for: query)
        guard !ftsQuery.isEmpty else {
            return []
        }

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

        let rawResults = try rows(sql, bind: { statement in
            try self.bindText(ftsQuery, to: 1, in: statement, sql: sql)
            try self.bindInt(limit * 4, to: 2, in: statement, sql: sql)
        }) { statement in
            PhraseSearchResult(
                pageID: Self.stringColumn(statement, index: 0),
                title: Self.stringColumn(statement, index: 1),
                subtitle: Self.stringColumn(statement, index: 2)
            )
        }

        let normalizedQuery = Self.searchComparableText(query)
        var seenPageIDs = Set<String>()
        return rawResults.filter { result in
            seenPageIDs.insert(result.pageID).inserted
        }
        .enumerated()
        .sorted { left, right in
            let leftScore = Self.searchIdentityScore(for: left.element, normalizedQuery: normalizedQuery)
            let rightScore = Self.searchIdentityScore(for: right.element, normalizedQuery: normalizedQuery)

            if leftScore == rightScore {
                return left.offset < right.offset
            }

            return leftScore > rightScore
        }
        .map(\.element)
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
          aa.source_manifest_key
        FROM phrase_page pp
        JOIN phrase p ON p.id = pp.phrase_id
        LEFT JOIN audio_usage au
          ON au.target_kind = 'phrase'
         AND au.target_id = p.id
         AND au.is_primary = 1
        LEFT JOIN audio_asset aa ON aa.id = au.audio_asset_id
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
            let audioKey = Self.optionalStringColumn(statement, index: 8)

            return PhraseDetailPage(
                id: pageID,
                title: title,
                englishTitle: englishTitle,
                pronunciation: pronunciation,
                summary: summary,
                iconName: iconName,
                tintName: tintName,
                sections: try loadSections(forPageID: pageID),
                examples: [],
                audioKey: audioKey,
                showsCatalogExplore: true
            )
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

    private func loadSections(forPageID pageID: String) throws -> [PhraseDetailSection] {
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
                phrases: try loadPhraseOptions(forSectionID: sectionID),
                breakdown: try loadBreakdownTokens(forSectionID: sectionID),
                presentation: presentation
            )
        }
    }

    private func loadPhraseOptions(forSectionID sectionID: String) throws -> [PhraseOption] {
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
        ORDER BY psi.sort_order;
        """

        return try rows(sql, bind: { statement in
            try self.bindText(sectionID, to: 1, in: statement, sql: sql)
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

    private static func searchIdentityScore(for result: PhraseSearchResult, normalizedQuery: String) -> Int {
        guard !normalizedQuery.isEmpty else {
            return 0
        }

        let title = searchComparableText(result.title)
        let subtitle = searchComparableText(result.subtitle)
        let titleTokens = title.split(separator: " ")
        let subtitleTokens = subtitle.split(separator: " ")
        let shortestTokenCount = min(
            titleTokens.isEmpty ? Int.max : titleTokens.count,
            subtitleTokens.isEmpty ? Int.max : subtitleTokens.count
        )
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

        if titleTokens.contains(Substring(normalizedQuery)) {
            score += 2_400
        }

        if subtitleTokens.contains(Substring(normalizedQuery)) {
            score += 2_200
        }

        if title.contains(normalizedQuery) {
            score += 1_800
        }

        if subtitle.contains(normalizedQuery) {
            score += 1_600
        }

        if score > 0, shortestTokenCount != Int.max {
            score += max(0, 500 - shortestTokenCount * 40)
        }

        return score
    }
}

enum VietSQLitePhraseGraphRuntime {
    static let launchArgument = "--use-sqlite-phrase-graph"
    static let environmentVariable = "SPEAKLOCAL_USE_SQLITE_GRAPH"
    static let disabledLaunchArgument = "--disable-sqlite-phrase-graph"
    static let disabledEnvironmentVariable = "SPEAKLOCAL_DISABLE_SQLITE_GRAPH"

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
        guard isEnabled, let repository = repository() else {
            return nil
        }

        return try? repository.loadCatalogSnapshot()
    }

    static func canonicalPageID(for pageIDOrAlias: String) -> String? {
        guard isEnabled, let repository = repository() else {
            return nil
        }

        return try? repository.canonicalPageID(forPageIDOrAlias: pageIDOrAlias)
    }

    static func search(_ query: String, limit: Int = 8) -> [PhraseSearchResult]? {
        guard isEnabled, let repository = repository() else {
            return nil
        }

        return try? repository.search(query, limit: limit)
    }

    static func detailPage(withID pageID: String) -> PhraseDetailPage? {
        guard isEnabled, let repository = repository() else {
            return nil
        }

        return try? repository.loadPhraseDetailPage(pageID: pageID)
    }

    static func canOpenPage(_ pageID: String) -> Bool {
        guard isEnabled, let repository = repository() else {
            return false
        }

        return ((try? repository.canOpenPage(pageIDOrAlias: pageID)) ?? false)
    }

    private static func repository() -> VietSQLiteLanguagePackRepository? {
        if let cachedRepository {
            return cachedRepository
        }

        cachedRepository = try? VietSQLiteLanguagePackRepository.bundled()
        return cachedRepository
    }

    private static var cachedRepository: VietSQLiteLanguagePackRepository?

#if DEBUG
    static func setEnabledForTesting(_ enabled: Bool) {
        isEnabledOverride = enabled
        cachedRepository = nil
        PhraseCatalog.resetCacheForTesting()
    }

    static func resetTestingOverrides() {
        isEnabledOverride = nil
        cachedRepository = nil
        PhraseCatalog.resetCacheForTesting()
    }

    private static var isEnabledOverride: Bool?
#endif
}

private let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
