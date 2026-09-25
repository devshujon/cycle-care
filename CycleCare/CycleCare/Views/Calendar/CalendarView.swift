import SwiftData
import SwiftUI

struct CalendarView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PeriodEntry.date) private var periodEntries: [PeriodEntry]
    @StateObject private var profileVM = ProfileViewModel()
    @State private var displayedMonth = Date()

    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                monthHeader
                weekdayHeader
                daysGrid
                legend
                Spacer(minLength: 0)
            }
            .padding()
            .navigationTitle("calendar.title")
            .onAppear { profileVM.loadOrCreate(context: context) }
        }
    }

    private var monthHeader: some View {
        HStack {
            Button { shiftMonth(-1) } label: { Image(systemName: "chevron.left") }
            Spacer()
            Text(displayedMonth, format: .dateTime.month(.wide).year())
                .font(.headline)
            Spacer()
            Button { shiftMonth(1) } label: { Image(systemName: "chevron.right") }
        }
    }

    private var weekdayHeader: some View {
        let symbols = Calendar.current.shortWeekdaySymbols
        return HStack {
            ForEach(symbols, id: \.self) { symbol in
                Text(symbol)
                    .font(.caption2)
                    .frame(maxWidth: .infinity)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var daysGrid: some View {
        let days = daysInMonth(displayedMonth)
        let overview = profileVM.cycleOverview
        return LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 8) {
            ForEach(days, id: \.self) { day in
                if let day {
                    dayCell(day, overview: overview)
                } else {
                    Color.clear.frame(height: 36)
                }
            }
        }
    }

    private func dayCell(_ date: Date, overview: CycleOverview) -> some View {
        let cal = Calendar.current
        let isPeriod = periodEntries.contains { cal.isDate($0.date, inSameDayAs: date) && $0.isPeriodDay }
        let isFertile = overview.fertileWindow?.contains(date) ?? false
        let isToday = cal.isDateInToday(date)

        return Text("\(cal.component(.day, from: date))")
            .font(.subheadline.weight(isToday ? .bold : .regular))
            .frame(maxWidth: .infinity, minHeight: 36)
            .background {
                if isPeriod { Circle().fill(CCColor.primaryFallback.opacity(0.85)) }
                else if isFertile { Circle().stroke(CCColor.accent, lineWidth: 2) }
                else if isToday { Circle().stroke(CCColor.primaryFallback, lineWidth: 1) }
            }
            .foregroundStyle(isPeriod ? Color.white : Color.primary)
    }

    private var legend: some View {
        HStack(spacing: 16) {
            Label("calendar.legend.period", systemImage: "circle.fill")
            Label("calendar.legend.fertile", systemImage: "circle")
        }
        .font(.caption)
        .foregroundStyle(.secondary)
    }

    private func shiftMonth(_ value: Int) {
        displayedMonth = Calendar.current.date(byAdding: .month, value: value, to: displayedMonth) ?? displayedMonth
    }

    private func daysInMonth(_ date: Date) -> [Date?] {
        let cal = Calendar.current
        guard let interval = cal.dateInterval(of: .month, for: date),
              let range = cal.range(of: .day, in: .month, for: date) else { return [] }
        let firstWeekday = cal.component(.weekday, from: interval.start)
        let leading = (firstWeekday - cal.firstWeekday + 7) % 7
        var days: [Date?] = Array(repeating: nil, count: leading)
        for day in range {
            if let d = cal.date(byAdding: .day, value: day - 1, to: interval.start) {
                days.append(d)
            }
        }
        return days
    }
}
