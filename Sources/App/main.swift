import Foundation
import HTTPTypes
import Hummingbird
import NIOCore

let db = try Database.setup()
let router = Router()

func htmlResponse(_ html: String) -> Response {
    let buffer = ByteBuffer(string: html)
    return Response(
        status: .ok,
        headers: [.contentType: "text/html; charset=utf-8"],
        body: .init(byteBuffer: buffer)
    )
}

func redirectResponse(to location: String) -> Response {
    Response(status: .seeOther, headers: [.location: location])
}

func parseFormBody(_ body: String) -> [String: String] {
    body.split(separator: "&").reduce(into: [String: String]()) { result, item in
        let parts = item.split(separator: "=", maxSplits: 1)
        if parts.count == 2 {
            let key = String(parts[0]).removingPercentEncoding ?? String(parts[0])
            let value =
                String(parts[1])
                .replacingOccurrences(of: "+", with: " ")
                .removingPercentEncoding ?? String(parts[1])
            result[key] = value
        }
    }
}

router.get("/") { request, _ -> Response in
    let uri = request.uri.string

    var search = ""
    var rating: Int? = nil
    var favoritesOnly = false
    var readFilter = ""
    var sortBy = ""
    var message = ""

    if let components = URLComponents(string: uri) {
        search = components.queryItems?.first(where: { $0.name == "search" })?.value ?? ""

        if let r = components.queryItems?.first(where: { $0.name == "rating" })?.value {
            rating = Int(r)
        }

        favoritesOnly =
            components.queryItems?.contains(where: {
                $0.name == "favorites" && $0.value == "true"
            }) ?? false

        readFilter = components.queryItems?.first(where: { $0.name == "read_status" })?.value ?? ""
        sortBy = components.queryItems?.first(where: { $0.name == "sort" })?.value ?? ""
        message = components.queryItems?.first(where: { $0.name == "message" })?.value ?? ""
    }

    do {
        let books = try Database.filterBooks(
            db: db,
            search: search,
            minimumRating: rating,
            favoritesOnly: favoritesOnly,
            readFilter: readFilter,
            sortBy: sortBy
        )

        let stats = try Database.getStats(db: db)

        return htmlResponse(
            Views.index(
                books: books,
                search: search,
                selectedRating: rating,
                favoritesOnly: favoritesOnly,
                selectedReadFilter: readFilter,
                selectedSort: sortBy,
                stats: stats,
                message: message
            )
        )
    } catch {
        return htmlResponse("<h1>Error loading books</h1>")
    }
}

router.post("/add") { request, _ async -> Response in
    do {
        var body = ""

        for try await buffer in request.body {
            body += String(buffer: buffer)
        }

        let params = parseFormBody(body)

        try Database.addBook(
            db: db,
            title: params["title"] ?? "",
            author: params["author"] ?? "",
            genre: params["genre"] ?? "",
            isRead: params["isRead"] == "true",
            rating: Int(params["rating"] ?? "3") ?? 3
        )

        return redirectResponse(to: "/?message=Book%20added%20successfully")
    } catch {
        return htmlResponse("<h1>Error adding book</h1>")
    }
}

router.get("/edit/:id") { request, _ -> Response in
    do {
        if let idString = request.uri.path.split(separator: "/").last,
            let bookId = Int64(idString),
            let book = try Database.fetchBookById(db: db, id: bookId)
        {
            return htmlResponse(Views.edit(book: book))
        }

        return htmlResponse("<h1>Book not found</h1>")
    } catch {
        return htmlResponse("<h1>Error loading edit page</h1>")
    }
}

router.post("/update/:id") { request, _ async -> Response in
    do {
        guard let idString = request.uri.path.split(separator: "/").last,
            let bookId = Int64(idString)
        else {
            return htmlResponse("<h1>Invalid book ID</h1>")
        }

        var body = ""

        for try await buffer in request.body {
            body += String(buffer: buffer)
        }

        let params = parseFormBody(body)

        try Database.updateBook(
            db: db,
            id: bookId,
            title: params["title"] ?? "",
            author: params["author"] ?? "",
            genre: params["genre"] ?? "",
            isRead: params["isRead"] == "true",
            rating: Int(params["rating"] ?? "3") ?? 3
        )

        return redirectResponse(to: "/?message=Book%20updated%20successfully")
    } catch {
        return htmlResponse("<h1>Error updating book</h1>")
    }
}

router.get("/mark-read/:id") { request, _ -> Response in
    do {
        if let id = request.uri.path.split(separator: "/").last,
            let bookId = Int64(id)
        {
            try Database.markAsRead(db: db, id: bookId)
        }

        return redirectResponse(to: "/?message=Book%20marked%20as%20read")
    } catch {
        return htmlResponse("<h1>Error marking book as read</h1>")
    }
}

router.get("/toggle-favorite/:id") { request, _ -> Response in
    do {
        if let id = request.uri.path.split(separator: "/").last,
            let bookId = Int64(id)
        {
            try Database.toggleFavorite(db: db, id: bookId)
        }

        return redirectResponse(to: "/?message=Favorite%20status%20updated")
    } catch {
        return htmlResponse("<h1>Error toggling favorite</h1>")
    }
}

router.get("/delete/:id") { request, _ -> Response in
    do {
        if let id = request.uri.path.split(separator: "/").last,
            let bookId = Int64(id)
        {
            try Database.deleteBook(db: db, id: bookId)
        }

        return redirectResponse(to: "/?message=Book%20deleted%20successfully")
    } catch {
        return htmlResponse("<h1>Error deleting book</h1>")
    }
}

let app = Application(router: router)
try await app.run()
