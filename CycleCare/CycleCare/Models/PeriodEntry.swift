import Foundation
import SwiftData

enum FlowLevel: String, Codable, CaseIterable, Identifiable {
    case spotting, light, medium, heavy

    var id: String { rawValue }
}

@Model
final class PeriodEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var isPeriodDay: Bool
    var flow: String
    var symptoms: [String]
    var notes: String

    init(
        id: UUID = UUID(),
        date: Date = .now,
        isPeriodDay: Bool = true,
        flow: FlowLevel = .medium,
        symptoms: [String] = [],
        notes: String = ""
    ) {
        self.id = id
        self.date = Calendar.current.startOfDay(for: date)
        self.isPeriodDay = isPeriodDay
        self.flow = flow.rawValue
        self.symptoms = symptoms
        self.notes = notes
    }

    var flowLevel: FlowLevel {
        get { FlowLevel(rawValue: flow) ?? .medium }
        set { flow = newValue.rawValue }
    }
}
