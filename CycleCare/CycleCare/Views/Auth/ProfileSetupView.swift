import SwiftData
import SwiftUI

struct ProfileSetupView: View {
    var onComplete: () -> Void = {}
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var languageManager: LanguageManager
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        Form {
            if let profile = viewModel.profile {
                Section("profile.section.basic") {
                    TextField("profile.name", text: bind(profile, \.name))
                    Stepper(value: bindInt(profile, \.age), in: 13...60) {
                        Text("profile.age \(profile.age)")
                    }
                }
                Section("profile.section.body") {
                    Stepper(value: bindDouble(profile, \.weightKg), in: 35...150, step: 0.5) {
                        Text("profile.weight \(profile.weightKg, specifier: "%.1f") kg")
                    }
                    Stepper(value: bindDouble(profile, \.heightCm), in: 120...210, step: 1) {
                        Text("profile.height \(Int(profile.heightCm)) cm")
                    }
                }
                Section("profile.section.cycle") {
                    Stepper(value: bindInt(profile, \.cycleLengthDays), in: 21...40) {
                        Text("profile.cycleLength \(profile.cycleLengthDays)")
                    }
                    DatePicker("profile.lastPeriod", selection: bindOptionalDate(profile, \.lastPeriodStart), displayedComponents: .date)
                }
                Section("profile.section.goals") {
                    TextField("profile.healthGoals", text: bind(profile, \.healthGoals), axis: .vertical)
                        .lineLimit(3...6)
                }
                Section("pregnancy.title") {
                    Toggle("pregnancy.enable", isOn: bindBool(profile, \.pregnancyModeEnabled))
                    if profile.pregnancyModeEnabled {
                        DatePicker("pregnancy.dueDate", selection: bindOptionalDate(profile, \.expectedDueDate), displayedComponents: .date)
                    }
                }
                Section {
                    PrimaryButton(title: "common.saveContinue") {
                        profile.languageCode = languageManager.locale.identifier
                        viewModel.save(context: context)
                        onComplete()
                    }
                }
            }
        }
        .navigationTitle("profile.setup")
        .onAppear { viewModel.loadOrCreate(context: context) }
    }

    private func bind(_ profile: UserProfile, _ keyPath: ReferenceWritableKeyPath<UserProfile, String>) -> Binding<String> {
        Binding(get: { profile[keyPath: keyPath] }, set: { profile[keyPath: keyPath] = $0 })
    }

    private func bindInt(_ profile: UserProfile, _ keyPath: ReferenceWritableKeyPath<UserProfile, Int>) -> Binding<Int> {
        Binding(get: { profile[keyPath: keyPath] }, set: { profile[keyPath: keyPath] = $0 })
    }

    private func bindDouble(_ profile: UserProfile, _ keyPath: ReferenceWritableKeyPath<UserProfile, Double>) -> Binding<Double> {
        Binding(get: { profile[keyPath: keyPath] }, set: { profile[keyPath: keyPath] = $0 })
    }

    private func bindOptionalDate(_ profile: UserProfile, _ keyPath: ReferenceWritableKeyPath<UserProfile, Date?>) -> Binding<Date> {
        Binding(
            get: { profile[keyPath: keyPath] ?? .now },
            set: { profile[keyPath: keyPath] = $0 }
        )
    }

    private func bindBool(_ profile: UserProfile, _ keyPath: ReferenceWritableKeyPath<UserProfile, Bool>) -> Binding<Bool> {
        Binding(get: { profile[keyPath: keyPath] }, set: { profile[keyPath: keyPath] = $0 })
    }
}
