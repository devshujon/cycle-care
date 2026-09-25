import Foundation
import SwiftData

@Model
final class ArticleBookmark {
    @Attribute(.unique) var id: UUID
    var articleID: String
    var savedAt: Date

    init(id: UUID = UUID(), articleID: String, savedAt: Date = .now) {
        self.id = id
        self.articleID = articleID
        self.savedAt = savedAt
    }
}
