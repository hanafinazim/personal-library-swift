import Foundation

struct Views {

    static func index(
        books: [Book],
        search: String = "",
        selectedRating: Int? = nil,
        favoritesOnly: Bool = false,
        selectedReadFilter: String = "",
        selectedSort: String = "",
        stats: (total: Int, read: Int, favorites: Int, avgRating: Double),
        message: String = ""
    ) -> String {

        var rows = ""

        for book in books {
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
                ? "<a href=\"/delete/\(book.id!)\" role=\"button\" class=\"secondary\" onclick=\"return confirm('Are you sure?')\">Delete</a>"
                : ""

            let markReadLink =
                (book.id != nil && !book.isRead)
                ? "<a href=\"/mark-read/\(book.id!)\" role=\"button\">Mark as read</a>"
                : ""

            let statusBadge =
                book.isRead
                ? "<span class=\"status-badge status-read\">Read</span>"
                : "<span class=\"status-badge status-unread\">Not read</span>"

            rows += """
                <tr>
                    <td>\(favoriteIcon)</td>
                    <td>\(book.title)</td>
                    <td>\(book.author)</td>
                    <td>\(book.genre)</td>
                    <td>\(statusBadge)</td>
                    <td>\(book.rating)/5</td>
                    <td style="display:flex; gap:10px; flex-wrap:wrap;">
                        \(favoriteLink)
                        \(editLink)
                        \(deleteLink)
                        \(markReadLink)
                    </td>
                </tr>
                """
        }

        let flashMessage =
            message.isEmpty
            ? ""
            : """
            <div class="flash-success">✅ \(message)</div>
            """

        return """
            <!DOCTYPE html>
            <html>
            <head>
                <meta charset="UTF-8">
                <meta name="viewport" content="width=device-width, initial-scale=1.0">
                <title>Personal Library</title>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/@picocss/pico@2/css/pico.min.css">

                <style>
                    .flash-success {
                        position: fixed;
                        top: 20px;
                        right: 20px;
                        background: #eafaf1;
                        border: 1px solid #b7ebc6;
                        color: #1f6b3b;
                        border-radius: 14px;
                        padding: 14px;
                        font-weight: 600;
                        box-shadow: 0 8px 20px rgba(0,0,0,0.08);
                        animation: fadeOut 0.5s ease forwards;
                        animation-delay: 3s;
                    }

                    @keyframes fadeOut {
                        to {
                            opacity: 0;
                            transform: translateY(-10px);
                        }
                    }

                    .status-badge {
                        padding: 5px 10px;
                        border-radius: 999px;
                        font-size: 0.8rem;
                        font-weight: 600;
                    }

                    .status-read {
                        background: #eafaf1;
                        color: #1f6b3b;
                    }

                    .status-unread {
                        background: #fff4e5;
                        color: #8a5a00;
                    }

                    .stats {
                        display: flex;
                        gap: 15px;
                        margin: 20px 0;
                    }

                    .card {
                        padding: 15px;
                        border: 1px solid #eee;
                        border-radius: 12px;
                        flex: 1;
                        text-align: center;
                    }
                </style>
            </head>

            <body>
                <main class="container">
                    <h1>📚 Personal Library</h1>

                    \(flashMessage)

                    <div class="stats">
                        <div class="card">Total<br><b>\(stats.total)</b></div>
                        <div class="card">Read<br><b>\(stats.read)</b></div>
                        <div class="card">Favorites<br><b>\(stats.favorites)</b></div>
                        <div class="card">Avg<br><b>\(String(format: "%.1f", stats.avgRating))</b></div>
                    </div>

                    <form method="get">
                        <input type="text" name="search" placeholder="Search..." value="\(search)">
                        <button type="submit">Search</button>
                    </form>

                    <form method="post" action="/add">
                        <input name="title" placeholder="Title" required>
                        <input name="author" placeholder="Author" required>
                        <input name="genre" placeholder="Genre" required>

                        <select name="isRead">
                            <option value="false">Not read</option>
                            <option value="true">Read</option>
                        </select>

                        <input type="number" name="rating" min="1" max="5" value="3">

                        <button type="submit">Add Book</button>
                    </form>

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
                </main>

                <script>
                    setTimeout(() => {
                        const flash = document.querySelector('.flash-success');
                        if (flash) flash.remove();
                    }, 3500);
                </script>
            </body>
            </html>
            """
    }

    static func edit(book: Book) -> String {
        return """
            <html>
            <body>
                <h1>Edit Book</h1>

                <form method="post" action="/update/\(book.id ?? 0)">
                    <input name="title" value="\(book.title)">
                    <input name="author" value="\(book.author)">
                    <input name="genre" value="\(book.genre)">
                    <input name="rating" value="\(book.rating)">
                    <button>Save</button>
                </form>

                <a href="/">Back</a>
            </body>
            </html>
            """
    }
}
