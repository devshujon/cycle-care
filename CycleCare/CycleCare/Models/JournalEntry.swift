import Foundation
import SwiftData

enum JournalCategory: String, Codable, CaseIterable, Identifiable {
    case general, symptoms, wellness, notes

    var id: String { rawValue }
}

@Model
final class JournalEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var title: String
    var body: String
    var category: String
    var isPinned: Bool
    var symptoms: [String]

    init(
        id: UUID = UUID(),
        date: Date = .now,
        title: String = "",
        body: String = "",
        category: JournalCategory = .general,
        isPinned: Bool = false,
        symptoms: [String] = []
    ) {
        self.id = id
        self.date = date
        self.title = title
        self.body = body
        self.category = category.rawValue
        self.isPinned = isPinned
        self.symptoms = symptoms
    }

    var journalCategory: JournalCategory {
        get { JournalCategory(rawValue: category) ?? .general }
        set { category = newValue.rawValue }
    }
}
