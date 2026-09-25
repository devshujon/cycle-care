import Foundation
import SwiftData

@Model
final class UserProfile {
    @Attribute(.unique) var id: UUID
    var name: String
    var age: Int
    var weightKg: Double
    var heightCm: Double
    var cycleLengthDays: Int
    var periodLengthDays: Int
    var lastPeriodStart: Date?
    var healthGoals: String
    var languageCode: String
    var pregnancyModeEnabled: Bool
    var expectedDueDate: Date?
    var createdAt: Date
    var updatedAt: Date

    init(
        id: UUID = UUID(),
        name: String = "",
        age: Int = 25,
        weightKg: Double = 60,
        heightCm: Double = 165,
        cycleLengthDays: Int = AppConstants.defaultCycleLength,
        periodLengthDays: Int = AppConstants.defaultPeriodLength,
        lastPeriodStart: Date? = nil,
        healthGoals: String = "",
        languageCode: String = "en",
        pregnancyModeEnabled: Bool = false,
        expectedDueDate: Date? = nil,
        createdAt: Date = .now,
        updatedAt: Date = .now
    ) {
        self.id = id
        self.name = name
        self.age = age
        self.weightKg = weightKg
        self.heightCm = heightCm
        self.cycleLengthDays = cycleLengthDays
        self.periodLengthDays = periodLengthDays
        self.lastPeriodStart = lastPeriodStart
        self.healthGoals = healthGoals
        self.languageCode = languageCode
        self.pregnancyModeEnabled = pregnancyModeEnabled
        self.expectedDueDate = expectedDueDate
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}
