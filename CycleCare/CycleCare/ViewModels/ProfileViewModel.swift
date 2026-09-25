import Foundation
import SwiftData

@MainActor
final class ProfileViewModel: ObservableObject {
    @Published var profile: UserProfile?

    func loadOrCreate(context: ModelContext) {
        let descriptor = FetchDescriptor<UserProfile>()
        if let existing = try? context.fetch(descriptor).first {
            profile = existing
        } else {
            let created = UserProfile()
            context.insert(created)
            try? context.save()
            profile = created
        }
    }

    func save(context: ModelContext) {
        profile?.updatedAt = .now
        try? context.save()
    }

    var cycleOverview: CycleOverview {
        guard let profile else {
            return CyclePredictionService.overview(
                lastPeriodStart: nil,
                cycleLength: AppConstants.defaultCycleLength,
                periodLength: AppConstants.defaultPeriodLength
            )
        }
        return CyclePredictionService.overview(
            lastPeriodStart: profile.lastPeriodStart,
            cycleLength: profile.cycleLengthDays,
            periodLength: profile.periodLengthDays
        )
    }
}
