import Foundation

struct Views {

    static func index(
        books: [Book],
        search: String = "",
        selectedRating: Int? = nil,
        favoritesOnly: Bool = false,
        stats: (total: Int, read: Int, favorites: Int, avgRating: Double)
    ) -> String {
        var rows = ""

        for book in books {
            let status = book.isRead ? "Read" : "Not read"
            let favoriteIcon = book.isFavorite ? "⭐" : "☆"

            let favoriteLink =
                book.id != nil
                ? "<a href=\"/toggle-favorite/\(book.id!)\" role=\"button\" class=\"contrast\">\(favoriteIcon)</a>"
                : ""

            let editLink =
                book.id != nil
                ? "<a href=\"/edit/\(book.id!)\" role=\"button\">Edit</a>"
                : ""

            let deleteLink =
                book.id != nil
                ? "<a href=\"/delete/\(book.id!)\" role=\"button\" class=\"secondary\">Delete</a>"
                : ""

            let markReadLink =
                (book.id != nil && !book.isRead)
                ? "<a href=\"/mark-read/\(book.id!)\" role=\"button\">Mark as read</a>"
                : ""

            rows += """
                <tr>
                    <td>\(favoriteIcon)</td>
                    <td>\(book.title)</td>
                    <td>\(book.author)</td>
                    <td>\(book.genre)</td>
                    <td>\(status)</td>
                    <td>\(book.rating)/5</td>
                    <td style="display:flex; gap:10px; flex-wrap:wrap;">\(favoriteLink)\(editLink)\(deleteLink)\(markReadLink)</td>
                </tr>
                """
        }

        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Personal Library</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
            </head>
            <body>
                <main class="container">
                    <h1>📚 Personal Library</h1>

                    <section style="margin-bottom:20px;">
                        <h3>📊 Stats</h3>
                        <p>Total books: \(stats.total)</p>
                        <p>Read: \(stats.read)</p>
                        <p>Favorites: \(stats.favorites)</p>
                        <p>Average rating: \(String(format: "%.1f", stats.avgRating))</p>
                    </section>

                    <p>Manage your books with Swift, Hummingbird and SQLite.</p>

                    <form method="get" action="/" style="margin-bottom: 20px;">
                        <input type="text" name="search" placeholder="Search by title, author or genre" value="\(search)">

                        <select name="rating">
                            <option value="" \(selectedRating == nil ? "selected" : "")>All ratings</option>
                            <option value="1" \(selectedRating == 1 ? "selected" : "")>1+ stars</option>
                            <option value="2" \(selectedRating == 2 ? "selected" : "")>2+ stars</option>
                            <option value="3" \(selectedRating == 3 ? "selected" : "")>3+ stars</option>
                            <option value="4" \(selectedRating == 4 ? "selected" : "")>4+ stars</option>
                            <option value="5" \(selectedRating == 5 ? "selected" : "")>5 stars only</option>
                        </select>

                        <label style="display:flex; align-items:center; gap:8px;">
                            <input type="checkbox" name="favorites" value="true" \(favoritesOnly ? "checked" : "")>
                            Favorites only
                        </label>

                        <button type="submit">Search</button>
                    </form>

                    <form method="post" action="/add">
                        <input type="text" name="title" placeholder="Title" required>
                        <input type="text" name="author" placeholder="Author" required>
                        <input type="text" name="genre" placeholder="Genre" required>

                        <select name="isRead">
                            <option value="false">Not read</option>
                            <option value="true">Read</option>
                        </select>

                        <input type="number" name="rating" min="1" max="5" value="3" required>

                        <button type="submit">Add Book</button>
                    </form>

                    <hr>

                    \(books.isEmpty ? "<p>No books found.</p>" : """
                <table>
                    <thead>
                        <tr>
                            <th>Fav</th>
                            <th>Title</th>
                            <th>Author</th>
                            <th>Genre</th>
                            <th>Status</th>
                            <th>Rating</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        \(rows)
                    </tbody>
                </table>
                """)
                </main>
            </body>
            </html>
            """
    }

    static func edit(book: Book) -> String {
        let notReadSelected = book.isRead ? "" : "selected"
        let readSelected = book.isRead ? "selected" : ""

        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Edit Book</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">
            </head>
            <body>
                <main class="container">
                    <h1>✏️ Edit Book</h1>

                    <form method="post" action="/update/\(book.id ?? 0)">
                        <input type="text" name="title" value="\(book.title)" required>
                        <input type="text" name="author" value="\(book.author)" required>
                        <input type="text" name="genre" value="\(book.genre)" required>

                        <select name="isRead">
                            <option value="false" \(notReadSelected)>Not read</option>
                            <option value="true" \(readSelected)>Read</option>
                        </select>

                        <input type="number" name="rating" min="1" max="5" value="\(book.rating)" required>

                        <button type="submit">Update Book</button>
                    </form>

                    <p><a href="/">← Back to library</a></p>
                </main>
            </body>
            </html>
            """
    }
}
