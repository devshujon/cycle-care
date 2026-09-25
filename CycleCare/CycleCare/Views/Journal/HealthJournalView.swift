import SwiftData
import SwiftUI

struct HealthJournalView: View {
    @Environment(\.modelContext) private var context
    @Query(sort: \JournalEntry.date, order: .reverse) private var entries: [JournalEntry]
    @State private var search = ""
    @State private var showEditor = false

    private var filtered: [JournalEntry] {
        let base = entries.filter { entry in
            search.isEmpty || entry.title.localizedCaseInsensitiveContains(search) || entry.body.localizedCaseInsensitiveContains(search)
        }
        return base.sorted { lhs, rhs in
            if lhs.isPinned != rhs.isPinned { return lhs.isPinned && !rhs.isPinned }
            return lhs.date > rhs.date
        }
    }

    var body: some View {
        List {
            ForEach(filtered) { entry in
                NavigationLink {
                    JournalEditorView(entry: entry)
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        HStack {
                            Text(entry.title.isEmpty ? String(localized: "journal.untitled") : entry.title)
                                .font(.headline)
                            if entry.isPinned { Image(systemName: "pin.fill").font(.caption) }
                        }
                        Text(entry.body)
                            .lineLimit(2)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                }
            }
            .onDelete(perform: delete)
        }
        .searchable(text: $search, prompt: Text("journal.search"))
        .navigationTitle("journal.title")
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button { showEditor = true } label: { Image(systemName: "plus") }
            }
        }
        .sheet(isPresented: $showEditor) {
            NavigationStack {
                JournalEditorView(entry: JournalEntry())
            }
        }
    }

    private func delete(at offsets: IndexSet) {
        for index in offsets { context.delete(filtered[index]) }
        try? context.save()
    }
}

struct JournalEditorView: View {
    @Environment(\.modelContext) private var context
    @Environment(\.dismiss) private var dismiss
    @Bindable var entry: JournalEntry

    var body: some View {
        Form {
            TextField("journal.title", text: $entry.title)
            Picker("journal.category", selection: Binding(
                get: { entry.journalCategory },
                set: { entry.journalCategory = $0 }
            )) {
                ForEach(JournalCategory.allCases) { cat in
                    Text(LocalizedStringKey("journal.category.\(cat.rawValue)")).tag(cat)
                }
            }
            TextField("journal.body", text: $entry.body, axis: .vertical)
                .lineLimit(5...12)
            Toggle("journal.pin", isOn: $entry.isPinned)
        }
        .navigationTitle("journal.edit")
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("common.save") {
                    if entry.modelContext == nil { context.insert(entry) }
                    try? context.save()
                    dismiss()
                }
            }
        }
    }
}
