import Foundation
import SwiftData

@Model
final class WaterEntry {
    @Attribute(.unique) var id: UUID
    var date: Date
    var milliliters: Int

    init(id: UUID = UUID(), date: Date = .now, milliliters: Int = 250) {
        self.id = id
        self.date = date
        self.milliliters = milliliters
    }
}

@Model
final class WaterGoal {
    @Attribute(.unique) var id: UUID
    var dailyTargetML: Int

    init(id: UUID = UUID(), dailyTargetML: Int = 2000) {
        self.id = id
        self.dailyTargetML = dailyTargetML
    }
}
