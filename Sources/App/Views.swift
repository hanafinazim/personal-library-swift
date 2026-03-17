import Foundation

struct Views {

    static func index(books: [Book], search: String = "") -> String {
        var rows = ""

        for book in books {
            let status = book.isRead ? "Read" : "Not read"

            let editLink = book.id != nil
                ? "<a href=\"/edit/\(book.id!)\" role=\"button\">Edit</a>"
                : ""

            let deleteLink = book.id != nil
                ? "<a href=\"/delete/\(book.id!)\" role=\"button\" class=\"secondary\">Delete</a>"
                : ""

            rows += """
            <tr>
                <td>\(book.title)</td>
                <td>\(book.author)</td>
                <td>\(book.genre)</td>
                <td>\(status)</td>
                <td>\(book.rating)/5</td>
                <td style="display:flex; gap:10px;">\(editLink)\(deleteLink)</td>
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
                <p>Manage your books with Swift, Hummingbird and SQLite.</p>

                <form method="get" action="/" style="margin-bottom: 20px;">
                    <input type="text" name="search" placeholder="Search by title, author or genre" value="\(search)">
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
                            <th>Title</th>
                            <th>Author</th>
                            <th>Genre</th>
                            <th>Status</th>
                            <th>Rating</th>
                            <th>Action</th>
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
