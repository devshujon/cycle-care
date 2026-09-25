import SwiftData
import SwiftUI

struct MoodTrackerView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \MoodEntry.date, order: .reverse) private var moods: [MoodEntry]
    @State private var selected: MoodType = .calm
    @State private var note = ""

    var body: some View {
        Form {
            Section("mood.today") {
                LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 4), spacing: 12) {
                    ForEach(MoodType.allCases) { mood in
                        Button {
                            selected = mood
                        } label: {
                            VStack {
                                Image(systemName: mood.symbol)
                                    .font(.title2)
                                Text(LocalizedStringKey("mood.\(mood.rawValue)"))
                                    .font(.caption2)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(8)
                            .background(selected == mood ? CCColor.primarySoft : Color.clear)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .buttonStyle(.plain)
                    }
                }
                TextField("mood.note", text: $note)
                Button("common.save") { save() }
            }
            Section("mood.history") {
                ForEach(moods.prefix(SubscriptionManager.shared.isPro ? 100 : 30)) { entry in
                    HStack {
                        Image(systemName: entry.moodType.symbol)
                        VStack(alignment: .leading) {
                            Text(LocalizedStringKey("mood.\(entry.mood)"))
                            Text(entry.date.formatted(date: .abbreviated, time: .omitted))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("mood.title")
    }

    private func save() {
        context.insert(MoodEntry(mood: selected, note: note))
        try? context.save()
        note = ""
    }
}
