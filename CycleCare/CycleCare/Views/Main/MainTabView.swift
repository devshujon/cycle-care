import SwiftUI

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView()
                .tabItem { Label("tab.home", systemImage: "house.fill") }
                .tag(0)
            CalendarView()
                .tabItem { Label("tab.calendar", systemImage: "calendar") }
                .tag(1)
            PeriodTrackerView()
                .tabItem { Label("tab.period", systemImage: "drop.fill") }
                .tag(2)
            AnalyticsView()
                .tabItem { Label("tab.analytics", systemImage: "chart.line.uptrend.xyaxis") }
                .tag(3)
            SettingsView()
                .tabItem { Label("tab.settings", systemImage: "gearshape.fill") }
                .tag(4)
        }
        .tint(CCColor.primaryFallback)
    }
}
