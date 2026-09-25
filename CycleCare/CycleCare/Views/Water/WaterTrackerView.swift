import SwiftData
import SwiftUI

struct WaterTrackerView: View {
    @Environment(\.modelContext) private var context
    @Query private var goals: [WaterGoal]
    @Query(sort: \WaterEntry.date, order: .reverse) private var entries: [WaterEntry]
    @State private var addAmount = 250

    private var goal: WaterGoal {
        if let g = goals.first { return g }
        let created = WaterGoal()
        context.insert(created)
        try? context.save()
        return created
    }

    private var todayTotal: Int {
        entries.filter { Calendar.current.isDateInToday($0.date) }.map(\.milliliters).reduce(0, +)
    }

    var body: some View {
        Form {
            Section("water.goal") {
                Stepper(value: bindGoal(), in: 1000...4000, step: 250) {
                    Text("water.target \(goal.dailyTargetML) ml")
                }
                ProgressView(value: Double(todayTotal), total: Double(max(goal.dailyTargetML, 1)))
                Text("water.consumed \(todayTotal) ml")
            }
            Section("water.add") {
                Stepper(value: $addAmount, in: 100...1000, step: 50) {
                    Text("\(addAmount) ml")
                }
                Button("water.log") {
                    context.insert(WaterEntry(milliliters: addAmount))
                    try? context.save()
                }
            }
        }
        .navigationTitle("water.title")
    }

    private func bindGoal() -> Binding<Int> {
        Binding(
            get: { goal.dailyTargetML },
            set: {
                goal.dailyTargetML = $0
                try? context.save()
            }
        )
    }
}
