import SwiftData
import SwiftUI

struct PeriodTrackerView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \PeriodEntry.date, order: .reverse) private var entries: [PeriodEntry]
    @State private var selectedDate = Date()
    @State private var flow: FlowLevel = .medium
    @State private var symptoms = ""
    @State private var notes = ""

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    DatePicker("period.date", selection: $selectedDate, displayedComponents: .date)
                    Picker("period.flow", selection: $flow) {
                        ForEach(FlowLevel.allCases) { level in
                            Text(LocalizedStringKey("period.flow.\(level.rawValue)")).tag(level)
                        }
                    }
                    TextField("period.symptoms", text: $symptoms)
                    TextField("period.notes", text: $notes, axis: .vertical)
                        .lineLimit(2...5)
                } header: {
                    Text("period.log")
                } footer: {
                    Text("period.disclaimer")
                }

                Section("period.recent") {
                    ForEach(filteredEntries) { entry in
                        VStack(alignment: .leading) {
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.headline)
                            Text("period.flow.\(entry.flow)")
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .onDelete(perform: delete)
                }
            }
            .navigationTitle("period.title")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button("common.save") { saveEntry() }
                }
            }
        }
    }

    private var filteredEntries: [PeriodEntry] {
        let cutoff = Calendar.current.date(byAdding: .month, value: -AppConstants.freeHistoryMonths, to: .now) ?? .distantPast
        if SubscriptionManager.shared.isPro { return entries }
        return entries.filter { $0.date >= cutoff }
    }

    private func saveEntry() {
        let symptomList = symptoms.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
        let entry = PeriodEntry(date: selectedDate, flow: flow, symptoms: symptomList, notes: notes)
        context.insert(entry)
        try? context.save()
        symptoms = ""
        notes = ""
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets {
            context.delete(filteredEntries[index])
        }
        try? context.save()
    }
}
