import Hummingbird
import Foundation
import NIOCore
import HTTPTypes

func parseFormBody(_ body: String) -> [String: String] {
    var result: [String: String] = [:]

    let pairs = body.split(separator: "&")

    for pair in pairs {
        let parts = pair.split(separator: "=", maxSplits: 1)
        guard parts.count == 2 else { continue }

        let key = String(parts[0]).removingPercentEncoding ?? String(parts[0])
        let value = String(parts[1])
            .replacingOccurrences(of: "+", with: " ")
            .removingPercentEncoding ?? String(parts[1])

        result[key] = value
    }

    return result
}

func htmlResponse(_ html: String, status: HTTPResponse.Status = .ok) -> Response {
    let buffer = ByteBuffer(string: html)
    return Response(
        status: status,
        headers: [.contentType: "text/html; charset=utf-8"],
        body: .init(byteBuffer: buffer)
    )
}

let db = try Database.setup()
let router = Router()

router.get("/") { request, _ -> Response in
    do {
        let uri = request.uri.string
        let searchQuery: String

        if let components = URLComponents(string: uri),
           let searchItem = components.queryItems?.first(where: { $0.name == "search" })?.value,
           !searchItem.trimmingCharacters(in: .whitespaces).isEmpty {
            searchQuery = searchItem
        } else {
            searchQuery = ""
        }

        let books: [Book]
        if searchQuery.isEmpty {
            books = try Database.fetchAllBooks(db: db)
        } else {
            books = try Database.searchBooks(db: db, query: searchQuery)
        }

        return htmlResponse(Views.index(books: books, search: searchQuery))
    } catch {
        return htmlResponse("""
        <html>
        <body>
            <h1>Failed to load books</h1>
        </body>
        </html>
        """, status: .internalServerError)
    }
}

router.post("/add") { request, _ async -> Response in
    do {
        var bodyText = ""

        for try await buffer in request.body {
            bodyText += String(buffer: buffer)
        }

        let form = parseFormBody(bodyText)

        let title = form["title"] ?? ""
        let author = form["author"] ?? ""
        let genre = form["genre"] ?? ""
        let isRead = (form["isRead"] == "true")
        let rating = Int(form["rating"] ?? "3") ?? 3

        try Database.addBook(
            db: db,
            title: title,
            author: author,
            genre: genre,
            isRead: isRead,
            rating: rating
        )

        return Response(
            status: .seeOther,
            headers: [.location: "/"]
        )
    } catch {
        return htmlResponse("""
        <html>
        <body>
            <h1>Failed to add book</h1>
            <p><a href="/">Back to library</a></p>
        </body>
        </html>
        """, status: .internalServerError)
    }
}

router.get("/edit/:id") { request, _ -> Response in
    do {
        if let idString = request.uri.path.split(separator: "/").last,
           let bookId = Int64(idString),
           let book = try Database.fetchBookById(db: db, id: bookId) {
            return htmlResponse(Views.edit(book: book))
        }

        return htmlResponse("""
        <html>
        <body>
            <h1>Book not found</h1>
            <p><a href="/">Back to library</a></p>
        </body>
        </html>
        """, status: .notFound)
    } catch {
        return htmlResponse("""
        <html>
        <body>
            <h1>Failed to load edit page</h1>
            <p><a href="/">Back to library</a></p>
        </body>
        </html>
        """, status: .internalServerError)
    }
}

router.post("/update/:id") { request, _ async -> Response in
    do {
        guard let idString = request.uri.path.split(separator: "/").last,
              let bookId = Int64(idString) else {
            return htmlResponse("""
            <html>
            <body>
                <h1>Invalid book ID</h1>
                <p><a href="/">Back to library</a></p>
            </body>
            </html>
            """, status: .badRequest)
        }

        var bodyText = ""

        for try await buffer in request.body {
            bodyText += String(buffer: buffer)
        }

        let form = parseFormBody(bodyText)

        let title = form["title"] ?? ""
        let author = form["author"] ?? ""
        let genre = form["genre"] ?? ""
        let isRead = (form["isRead"] == "true")
        let rating = Int(form["rating"] ?? "3") ?? 3

        try Database.updateBook(
            db: db,
            id: bookId,
            title: title,
            author: author,
            genre: genre,
            isRead: isRead,
            rating: rating
        )

        return Response(
            status: .seeOther,
            headers: [.location: "/"]
        )
    } catch {
        return htmlResponse("""
        <html>
        <body>
            <h1>Failed to update book</h1>
            <p><a href="/">Back to library</a></p>
        </body>
        </html>
        """, status: .internalServerError)
    }
}

router.get("/delete/:id") { request, _ -> Response in
    do {
        if let idString = request.uri.path.split(separator: "/").last,
           let bookId = Int64(idString) {
            try Database.deleteBook(db: db, id: bookId)
        }

        return Response(
            status: .seeOther,
            headers: [.location: "/"]
        )
    } catch {
        return htmlResponse("""
        <html>
        <body>
            <h1>Error deleting book</h1>
            <p><a href="/">Back to library</a></p>
        </body>
        </html>
        """, status: .internalServerError)
    }
}

let app = Application(router: router)
try await app.run()
