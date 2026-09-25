import SwiftData
import SwiftUI

struct PregnancyTrackersView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var profileVM = ProfileViewModel()
    @EnvironmentObject private var subscription: SubscriptionManager
    @State private var showPaywall = false

    @State private var systolic = 120
    @State private var diastolic = 80

    var body: some View {
        Group {
            if !subscription.isPro {
                VStack(spacing: 16) {
                    Text("pregnancy.proRequired")
                        .multilineTextAlignment(.center)
                        .foregroundStyle(.secondary)
                    PrimaryButton(title: "subscription.upgrade") { showPaywall = true }
                }
                .padding()
                .sheet(isPresented: $showPaywall) { SubscriptionView() }
            } else if let profile = profileVM.profile, profile.pregnancyModeEnabled, let due = profile.expectedDueDate {
                List {
                    Section("pregnancy.progress") {
                        let week = CyclePredictionService.pregnancyWeek(dueDate: due)
                        LabeledContent("pregnancy.week", value: "\(week)")
                        LabeledContent("pregnancy.dueDate", value: due.formatted(date: .long, time: .omitted))
                        Text("pregnancy.weekInfo")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }

                    Section {
                        Stepper(value: $systolic, in: 90...180, step: 1) {
                            Text("pregnancy.bp.systolic \(systolic)")
                        }
                        Stepper(value: $diastolic, in: 50...120, step: 1) {
                            Text("pregnancy.bp.diastolic \(diastolic)")
                        }
                        Button("pregnancy.bp.log") {
                            // Extend with SwiftData BP model in future releases.
                        }
                    } header: {
                        Text("pregnancy.bp.addEntry")
                    } footer: {
                        Text("pregnancy.bp.note")
                    }
                }
            } else {
                ContentUnavailableView("pregnancy.disabled", systemImage: "heart.slash")
            }
        }
        .navigationTitle("pregnancy.title")
        .onAppear { profileVM.loadOrCreate(context: context) }
    }
}
