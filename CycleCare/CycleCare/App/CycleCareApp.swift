import SwiftData
import SwiftUI

@main
struct CycleCareApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @StateObject private var authService = AuthService()
    @StateObject private var subscriptionManager = SubscriptionManager.shared
    @StateObject private var languageManager = LanguageManager.shared

    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            UserProfile.self,
            PeriodEntry.self,
            MoodEntry.self,
            WaterEntry.self,
            WaterGoal.self,
            JournalEntry.self,
            ReminderSettings.self,
            ArticleBookmark.self
        ])
        let config = ModelConfiguration(isStoredInMemoryOnly: false)
        do {
            return try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environmentObject(authService)
                .environmentObject(subscriptionManager)
                .environmentObject(languageManager)
                .environment(\.appLocale, languageManager.locale)
                .environment(\.locale, languageManager.locale)
        }
        .modelContainer(sharedModelContainer)
    }
}
