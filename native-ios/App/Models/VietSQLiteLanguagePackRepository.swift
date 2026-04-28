#if DEBUG
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

enum VietSQLiteLanguagePackRepositoryError: Error, LocalizedError {
    case missingBundledFixture(subdirectory: String)
    case openFailed(path: String, message: String)
    case notReadOnly(path: String)
    case prepareFailed(sql: String, message: String)
    case stepFailed(sql: String, message: String)
    case bindFailed(sql: String, message: String)
    case emptyResult(sql: String)
    case missingPreviewPhrase(id: String)

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
            guard sqlite3_bind_text(statement, 1, phraseID, -1, sqliteTransient) == SQLITE_OK else {
                throw VietSQLiteLanguagePackRepositoryError.bindFailed(
                    sql: sql,
                    message: errorMessage()
                )
            }

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

    private func stringValue(_ sql: String) throws -> String {
        try withPreparedStatement(sql) { statement in
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

    private func intValue(_ sql: String) throws -> Int {
        try withPreparedStatement(sql) { statement in
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
}

private let sqliteTransient = unsafeBitCast(-1, to: sqlite3_destructor_type.self)
#endif
