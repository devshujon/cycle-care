import Foundation

struct CyclePhase: Equatable {
    enum Kind: String {
        case menstrual, follicular, ovulation, luteal, fertile
    }

    let kind: Kind
    let start: Date
    let end: Date
}

struct CycleOverview {
    let cycleLength: Int
    let periodLength: Int
    let lastPeriodStart: Date?
    let predictedNextPeriod: Date?
    let ovulationDate: Date?
    let fertileWindow: ClosedRange<Date>?
    let currentPhase: CyclePhase.Kind?
}

enum CyclePredictionService {
    static func overview(
        lastPeriodStart: Date?,
        cycleLength: Int,
        periodLength: Int,
        referenceDate: Date = .now
    ) -> CycleOverview {
        let cal = Calendar.current
        let today = cal.startOfDay(for: referenceDate)

        guard let lastStart = lastPeriodStart.map({ cal.startOfDay(for: $0) }) else {
            return CycleOverview(
                cycleLength: cycleLength,
                periodLength: periodLength,
                lastPeriodStart: nil,
                predictedNextPeriod: nil,
                ovulationDate: nil,
                fertileWindow: nil,
                currentPhase: nil
            )
        }

        let predictedNext = cal.date(byAdding: .day, value: cycleLength, to: lastStart)
        let ovulation = cal.date(byAdding: .day, value: cycleLength - 14, to: lastStart)
        let fertileStart = ovulation.flatMap { cal.date(byAdding: .day, value: -5, to: $0) }
        let fertileEnd = ovulation.flatMap { cal.date(byAdding: .day, value: 1, to: $0) }

        let fertileWindow: ClosedRange<Date>? = {
            guard let fertileStart, let fertileEnd else { return nil }
            return fertileStart ... fertileEnd
        }()

        let periodEnd = cal.date(byAdding: .day, value: periodLength - 1, to: lastStart) ?? lastStart
        let phase: CyclePhase.Kind? = {
            if today >= lastStart && today <= periodEnd { return .menstrual }
            if let fertileWindow, fertileWindow.contains(today) { return .fertile }
            if let ovulation, cal.isDate(today, inSameDayAs: ovulation) { return .ovulation }
            if let ovulation, today > ovulation { return .luteal }
            return .follicular
        }()

        return CycleOverview(
            cycleLength: cycleLength,
            periodLength: periodLength,
            lastPeriodStart: lastStart,
            predictedNextPeriod: predictedNext,
            ovulationDate: ovulation,
            fertileWindow: fertileWindow,
            currentPhase: phase
        )
    }

    static func pregnancyWeek(dueDate: Date, reference: Date = .now) -> Int {
        let cal = Calendar.current
        guard let conception = cal.date(byAdding: .day, value: -280, to: dueDate) else { return 1 }
        let days = cal.dateComponents([.day], from: conception, to: reference).day ?? 0
        return min(max((days / 7) + 1, 1), 42)
    }
}
