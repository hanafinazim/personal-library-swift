import Foundation
import SQLite

extension Connection: @unchecked @retroactive Sendable {}

struct Database {
    static let books = Table("books")

    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    static let author = Expression<String>("author")
    static let genre = Expression<String>("genre")
    static let isRead = Expression<Bool>("is_read")
    static let rating = Expression<Int>("rating")
    static let isFavorite = Expression<Bool>("is_favorite")

    static func setup() throws -> Connection {
        let db = try Connection("db.sqlite3")

        try db.run(
            books.create(ifNotExists: true) { t in
                t.column(id, primaryKey: .autoincrement)
                t.column(title)
                t.column(author)
                t.column(genre)
                t.column(isRead, defaultValue: false)
                t.column(rating)
                t.column(isFavorite, defaultValue: false)
            })

        return db
    }

    static func fetchBookById(db: Connection, id bookId: Int64) throws -> Book? {
        let query = books.filter(id == bookId)

        guard let row = try db.pluck(query) else { return nil }

        return Book(
            id: row[id],
            title: row[title],
            author: row[author],
            genre: row[genre],
            isRead: row[isRead],
            rating: row[rating],
            isFavorite: row[isFavorite]
        )
    }

    static func filterBooks(
        db: Connection,
        search: String,
        minimumRating: Int?,
        favoritesOnly: Bool,
        readFilter: String,
        sortBy: String
    ) throws -> [Book] {
        var query = books

        if !search.trimmingCharacters(in: .whitespaces).isEmpty {
            let pattern = "%\(search)%"
            query = query.filter(
                title.like(pattern) || author.like(pattern) || genre.like(pattern)
            )
        }

        if let minRating = minimumRating {
            query = query.filter(rating >= minRating)
        }

        if favoritesOnly {
            query = query.filter(isFavorite == true)
        }

        switch readFilter {
        case "read":
            query = query.filter(isRead == true)
        case "unread":
            query = query.filter(isRead == false)
        default:
            break
        }

        switch sortBy {
        case "title_asc":
            query = query.order(title.asc)
        case "title_desc":
            query = query.order(title.desc)
        case "rating_asc":
            query = query.order(rating.asc)
        case "rating_desc":
            query = query.order(rating.desc)
        case "favorites_first":
            query = query.order(isFavorite.desc, title.asc)
        default:
            query = query.order(id.desc)
        }

        return try db.prepare(query).map { row in
            Book(
                id: row[id],
                title: row[title],
                author: row[author],
                genre: row[genre],
                isRead: row[isRead],
                rating: row[rating],
                isFavorite: row[isFavorite]
            )
        }
    }

    static func addBook(
        db: Connection,
        title: String,
        author: String,
        genre: String,
        isRead: Bool,
        rating: Int
    ) throws {
        try db.run(
            books.insert(
                self.title <- title,
                self.author <- author,
                self.genre <- genre,
                self.isRead <- isRead,
                self.rating <- rating,
                self.isFavorite <- false
            )
        )
    }

    static func updateBook(
        db: Connection,
        id bookId: Int64,
        title: String,
        author: String,
        genre: String,
        isRead: Bool,
        rating: Int
    ) throws {
        let book = books.filter(id == bookId)

        try db.run(
            book.update(
                self.title <- title,
                self.author <- author,
                self.genre <- genre,
                self.isRead <- isRead,
                self.rating <- rating
            )
        )
    }

    static func deleteBook(db: Connection, id bookId: Int64) throws {
        let book = books.filter(id == bookId)
        try db.run(book.delete())
    }

    static func markAsRead(db: Connection, id bookId: Int64) throws {
        let book = books.filter(id == bookId)
        try db.run(book.update(isRead <- true))
    }

    static func toggleFavorite(db: Connection, id bookId: Int64) throws {
        let book = books.filter(id == bookId)

        if let current = try db.pluck(book) {
            try db.run(book.update(isFavorite <- !current[isFavorite]))
        }
    }

    static func getStats(db: Connection) throws -> (
        total: Int, read: Int, favorites: Int, avgRating: Double
    ) {
        let allBooks = Array(try db.prepare(books))

        let total = allBooks.count
        let read = allBooks.filter { $0[isRead] }.count
        let favorites = allBooks.filter { $0[isFavorite] }.count

        let ratings = allBooks.map { Double($0[rating]) }
        let avgRating = ratings.isEmpty ? 0.0 : ratings.reduce(0, +) / Double(ratings.count)

        return (total, read, favorites, avgRating)
    }
}
