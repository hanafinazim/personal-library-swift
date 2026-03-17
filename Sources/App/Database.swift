import SQLite
import Foundation

extension Connection: @unchecked @retroactive Sendable {}

struct Database {
    static let books = Table("books")

    static let id = Expression<Int64>("id")
    static let title = Expression<String>("title")
    static let author = Expression<String>("author")
    static let genre = Expression<String>("genre")
    static let isRead = Expression<Bool>("is_read")
    static let rating = Expression<Int>("rating")

    static func setup() throws -> Connection {
        let db = try Connection("db.sqlite3")

        try db.run(books.create(ifNotExists: true) { t in
            t.column(id, primaryKey: .autoincrement)
            t.column(title)
            t.column(author)
            t.column(genre)
            t.column(isRead, defaultValue: false)
            t.column(rating)
        })

        return db
    }

    static func fetchAllBooks(db: Connection) throws -> [Book] {
        try db.prepare(books).map { row in
            Book(
                id: row[id],
                title: row[title],
                author: row[author],
                genre: row[genre],
                isRead: row[isRead],
                rating: row[rating]
            )
        }
    }

    static func fetchBookById(db: Connection, id bookId: Int64) throws -> Book? {
        let query = books.filter(id == bookId)

        guard let row = try db.pluck(query) else {
            return nil
        }

        return Book(
            id: row[id],
            title: row[title],
            author: row[author],
            genre: row[genre],
            isRead: row[isRead],
            rating: row[rating]
        )
    }

    static func searchBooks(db: Connection, query: String) throws -> [Book] {
        let pattern = "%\(query)%"
        let filteredBooks = books.filter(
            title.like(pattern) || author.like(pattern) || genre.like(pattern)
        )

        return try db.prepare(filteredBooks).map { row in
            Book(
                id: row[id],
                title: row[title],
                author: row[author],
                genre: row[genre],
                isRead: row[isRead],
                rating: row[rating]
            )
        }
    }

    static func addBook(
        db: Connection,
        title bookTitle: String,
        author bookAuthor: String,
        genre bookGenre: String,
        isRead bookIsRead: Bool,
        rating bookRating: Int
    ) throws {
        try db.run(
            books.insert(
                title <- bookTitle,
                author <- bookAuthor,
                genre <- bookGenre,
                isRead <- bookIsRead,
                rating <- bookRating
            )
        )
    }

    static func updateBook(
        db: Connection,
        id bookId: Int64,
        title bookTitle: String,
        author bookAuthor: String,
        genre bookGenre: String,
        isRead bookIsRead: Bool,
        rating bookRating: Int
    ) throws {
        let book = books.filter(id == bookId)

        try db.run(
            book.update(
                title <- bookTitle,
                author <- bookAuthor,
                genre <- bookGenre,
                isRead <- bookIsRead,
                rating <- bookRating
            )
        )
    }

    static func deleteBook(db: Connection, id bookId: Int64) throws {
        let book = books.filter(id == bookId)
        try db.run(book.delete())
    }
}
