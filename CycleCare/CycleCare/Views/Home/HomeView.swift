import SwiftData
import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject private var subscription: SubscriptionManager

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    headerCard
                    quickActions
                    if !subscription.isPro {
                        AdSlot(adUnitID: AppConstants.AdMob.banner)
                            .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .background(Color(uiColor: .systemGroupedBackground))
            .navigationTitle("home.title")
            .onAppear { profileVM.loadOrCreate(context: context) }
        }
    }

    private var headerCard: some View {
        CCCard {
            VStack(alignment: .leading, spacing: 8) {
                Text(profileVM.profile?.name.isEmpty == false ? profileVM.profile!.name : String(localized: "home.greeting"))
                    .font(.system(.title2, design: .rounded, weight: .bold))
                let overview = profileVM.cycleOverview
                if let phase = overview.currentPhase {
                    Label(String(localized: "home.phase.\(phase.rawValue)"), systemImage: "sparkles")
                        .foregroundStyle(CCColor.primaryFallback)
                }
                if let next = overview.predictedNextPeriod {
                    Text("home.nextPeriod \(next.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal)
    }

    private var quickActions: some View {
        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
            NavigationLink { MoodTrackerView() } label: { quickTile("tab.mood", "face.smiling") }
            NavigationLink { WaterTrackerView() } label: { quickTile("tab.water", "drop") }
            NavigationLink { HealthJournalView() } label: { quickTile("tab.journal", "book") }
            NavigationLink { ArticlesView() } label: { quickTile("tab.articles", "newspaper") }
            NavigationLink { OvulationTrackerView() } label: { quickTile("tab.ovulation", "circle.circle") }
            NavigationLink { NotificationsView() } label: { quickTile("tab.notifications", "bell") }
        }
        .padding(.horizontal)
    }

    private func quickTile(_ title: LocalizedStringKey, _ symbol: String) -> some View {
        VStack(spacing: 8) {
            Image(systemName: symbol)
                .font(.title2)
                .foregroundStyle(CCColor.primaryFallback)
            Text(title)
                .font(.footnote.weight(.semibold))
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, minHeight: 88)
        .background(CCColor.cardFallback)
        .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
