import SwiftData
import SwiftUI

struct NotificationsView: View {
    @Environment(\.modelContext) private var context
    @Query private var settingsList: [ReminderSettings]
    @StateObject private var profileVM = ProfileViewModel()
    @StateObject private var notifications = NotificationService.shared

    private var settings: ReminderSettings {
        if let s = settingsList.first { return s }
        let created = ReminderSettings()
        context.insert(created)
        try? context.save()
        return created
    }

    var body: some View {
        Form {
            Section("notifications.permission") {
                Text(statusText)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                Button("notifications.enable") {
                    Task { await notifications.requestAuthorization() }
                }
            }

            Section {
                Toggle("reminder.period", isOn: bind(\.periodReminderEnabled))
                Stepper(value: bindInt(\.periodReminderDaysBefore), in: 1...7) {
                    Text("reminder.period.daysBefore \(settings.periodReminderDaysBefore)")
                }
            } footer: {
                Text("reminder.period.footer")
            }

            Section("reminder.water") {
                Toggle("reminder.water.enable", isOn: bind(\.waterReminderEnabled))
                Stepper(value: bindInt(\.waterReminderIntervalHours), in: 1...6) {
                    Text("reminder.water.every \(settings.waterReminderIntervalHours) h")
                }
            }

            Section {
                Button("notifications.apply") {
                    Task { await applyReminders() }
                }
            }
        }
        .navigationTitle("notifications.title")
        .onAppear {
            profileVM.loadOrCreate(context: context)
            Task { await notifications.refreshStatus() }
        }
    }

    private var statusText: String {
        switch notifications.authorizationStatus {
        case .authorized, .provisional, .ephemeral: return String(localized: "notifications.enabled")
        case .denied: return String(localized: "notifications.denied")
        default: return String(localized: "notifications.notDetermined")
        }
    }

    private func applyReminders() async {
        try? context.save()
        if settings.periodReminderEnabled, let next = profileVM.cycleOverview.predictedNextPeriod {
            await notifications.schedulePeriodReminder(nextPeriod: next, daysBefore: settings.periodReminderDaysBefore)
        }
        if settings.waterReminderEnabled {
            await notifications.scheduleWaterReminders(intervalHours: settings.waterReminderIntervalHours)
        }
    }

    private func bind(_ keyPath: ReferenceWritableKeyPath<ReminderSettings, Bool>) -> Binding<Bool> {
        Binding(
            get: { settings[keyPath: keyPath] },
            set: {
                settings[keyPath: keyPath] = $0
                try? context.save()
            }
        )
    }

    private func bindInt(_ keyPath: ReferenceWritableKeyPath<ReminderSettings, Int>) -> Binding<Int> {
        Binding(
            get: { settings[keyPath: keyPath] },
            set: {
                settings[keyPath: keyPath] = $0
                try? context.save()
            }
        )
    }
}
