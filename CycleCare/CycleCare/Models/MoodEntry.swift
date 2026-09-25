import Foundation
import SwiftData

enum MoodType: String, Codable, CaseIterable, Identifiable {
    case joyful, calm, tired, anxious, sad, irritable, energetic

    var id: String { rawValue }

    var symbol: String {
        switch self {
        case .joyful: return "face.smiling"
        case .calm: return "leaf"
        case .tired: return "moon.zzz"
        case .anxious: return "wind"
        case .sad: return "cloud.rain"
        case .irritable: return "bolt"
        case .energetic: return "sparkles"
        }
    }
}

@Model
final class MoodEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var mood: String
    var note: String

    init(id: UUID = UUID(), date: Date = .now, mood: MoodType = .calm, note: String = "") {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.mood = mood.rawValue
        self.note = note
    }

    var moodType: MoodType {
        get { MoodType(rawValue: mood) ?? .calm }
        set { mood = newValue.rawValue }
    }
}
