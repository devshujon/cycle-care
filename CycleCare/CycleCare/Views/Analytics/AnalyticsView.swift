import SwiftData
import SwiftUI
import Charts

struct AnalyticsView: View {
    @Query(sort: \PeriodEntry.date) private var periodEntries: [PeriodEntry]
    @Query(sort: \MoodEntry.date) private var moodEntries: [MoodEntry]
    @EnvironmentObject private var subscription: SubscriptionManager
    @State private var showPaywall = false

    private var visiblePeriods: [PeriodEntry] {
        if subscription.isPro { return periodEntries }
        let cutoff = Calendar.current.date(byAdding: .month, value: -AppConstants.freeHistoryMonths, to: .now) ?? .distantPast
        return periodEntries.filter { $0.date >= cutoff }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    if !subscription.isPro {
                        CCCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("analytics.freeLimit")
                                    .font(.subheadline)
                                Button("subscription.upgrade") { showPaywall = true }
                                    .buttonStyle(.borderedProminent)
                                    .tint(CCColor.primaryFallback)
                            }
                        }
                        .padding(.horizontal)
                    }

                    CCCard {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("analytics.periodFrequency")
                                .font(.headline)
                            Chart(monthlyCounts, id: \.month) { item in
                                BarMark(x: .value("Month", item.month), y: .value("Days", item.count))
                                    .foregroundStyle(CCColor.primaryFallback.gradient)
                            }
                            .frame(height: 180)
                        }
                    }
                    .padding(.horizontal)
                    .blur(radius: subscription.isPro ? 0 : (visiblePeriods.count > 20 ? 0 : 0))

                    if subscription.isPro {
                        CCCard {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("analytics.moodTrend")
                                    .font(.headline)
                                Text("analytics.moodCount \(moodEntries.count)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("analytics.title")
            .sheet(isPresented: $showPaywall) {
                SubscriptionView()
            }
        }
    }

    private var monthlyCounts: [(month: String, count: Int)] {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM"
        let grouped = Dictionary(grouping: visiblePeriods) { formatter.string(from: $0.date) }
        return grouped.map { (month: $0.key, count: $0.value.count) }.sorted { $0.month < $1.month }
    }
}
