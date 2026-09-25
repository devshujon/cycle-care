import SwiftData
import SwiftUI

struct OvulationTrackerView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var profileVM = ProfileViewModel()

    var body: some View {
        List {
            Section("ovulation.overview") {
                let overview = profileVM.cycleOverview
                LabeledContent("ovulation.cycleLength", value: "\(overview.cycleLength) d")
                if let ovulation = overview.ovulationDate {
                    LabeledContent("ovulation.predicted", value: ovulation.formatted(date: .abbreviated, time: .omitted))
                }
                if let window = overview.fertileWindow {
                    LabeledContent("ovulation.fertile") {
                        Text("\(window.lowerBound.formatted(date: .abbreviated, time: .omitted)) – \(window.upperBound.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
            }
            Section {
                Text("ovulation.education")
                    .font(.footnote)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("ovulation.title")
        .onAppear { profileVM.loadOrCreate(context: context) }
    }
}
