import Foundation

struct Book: Codable, Sendable {
    let id: Int64?
    var title: String
    var author: String
    var genre: String
    var isRead: Bool
    var rating: Int
}
