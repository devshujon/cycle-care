import Foundation
import SwiftData

@Model
final class ReminderSettings {
    @Attribute(.unique) var id: UUID
    var periodReminderEnabled: Bool
    var periodReminderDaysBefore: Int
    var waterReminderEnabled: Bool
    var waterReminderIntervalHours: Int
    var healthReminderEnabled: Bool
    var healthReminderHour: Int
    var healthReminderMinute: Int

    init(
        id: UUID = UUID(),
        periodReminderEnabled: Bool = true,
        periodReminderDaysBefore: Int = 2,
        waterReminderEnabled: Bool = true,
        waterReminderIntervalHours: Int = 2,
        healthReminderEnabled: Bool = false,
        healthReminderHour: Int = 9,
        healthReminderMinute: Int = 0
    ) {
        self.id = id
        self.periodReminderEnabled = periodReminderEnabled
        self.periodReminderDaysBefore = periodReminderDaysBefore
        self.waterReminderEnabled = waterReminderEnabled
        self.waterReminderIntervalHours = waterReminderIntervalHours
        self.healthReminderEnabled = healthReminderEnabled
        self.healthReminderHour = healthReminderHour
        self.healthReminderMinute = healthReminderMinute
    }
}
