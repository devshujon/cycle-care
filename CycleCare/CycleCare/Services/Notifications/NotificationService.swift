import Foundation
import UserNotifications

@MainActor
final class NotificationService: ObservableObject {
    static let shared = NotificationService()

    @Published private(set) var authorizationStatus: UNAuthorizationStatus = .notDetermined

    private init() {}

    func requestAuthorization() async {
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                await refreshStatus()
            }
        } catch {
            await refreshStatus()
        }
    }

    func refreshStatus() async {
        let settings = await UNUserNotificationCenter.current().notificationSettings()
        authorizationStatus = settings.authorizationStatus
    }

    func schedulePeriodReminder(nextPeriod: Date, daysBefore: Int) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["period.reminder"])

        guard let fireDate = Calendar.current.date(byAdding: .day, value: -daysBefore, to: nextPeriod) else { return }
        guard fireDate > .now else { return }

        var components = Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: fireDate)
        components.hour = 9
        components.minute = 0

        let content = UNMutableNotificationContent()
        content.title = String(localized: "reminder.period.title")
        content.body = String(localized: "reminder.period.body")
        content.sound = .default

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: "period.reminder", content: content, trigger: trigger)
        try? await center.add(request)
    }

    func scheduleWaterReminders(intervalHours: Int) async {
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: ["water.reminder"])

        let content = UNMutableNotificationContent()
        content.title = String(localized: "reminder.water.title")
        content.body = String(localized: "reminder.water.body")
        content.sound = .default

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: TimeInterval(intervalHours * 3600), repeats: true)
        let request = UNNotificationRequest(identifier: "water.reminder", content: content, trigger: trigger)
        try? await center.add(request)
    }
}
