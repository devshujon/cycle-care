import SwiftData
import SwiftUI

struct ArticlesView: View {
    @Environment(\.modelContext) private var context
    @Query private var bookmarks: [ArticleBookmark]
    @EnvironmentObject private var languageManager: LanguageManager
    @State private var showBookmarksOnly = false

    private var articles: [HealthArticle] {
        let all = ArticleCache.all
        guard showBookmarksOnly else { return all }
        let ids = Set(bookmarks.map(\.articleID))
        return all.filter { ids.contains($0.id) }
    }

    var body: some View {
        List {
            Toggle("articles.bookmarksOnly", isOn: $showBookmarksOnly)
            ForEach(articles) { article in
                NavigationLink {
                    ArticleDetailView(article: article, isBookmarked: isBookmarked(article)) { toggleBookmark(article) }
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(languageManager.useBangla ? article.titleBN : article.titleEN)
                            .font(.headline)
                        Text(article.topic)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
        .navigationTitle("articles.title")
    }

    private func isBookmarked(_ article: HealthArticle) -> Bool {
        bookmarks.contains { $0.articleID == article.id }
    }

    private func toggleBookmark(_ article: HealthArticle) {
        if let existing = bookmarks.first(where: { $0.articleID == article.id }) {
            context.delete(existing)
        } else {
            context.insert(ArticleBookmark(articleID: article.id))
        }
        try? context.save()
    }
}

struct ArticleDetailView: View {
    let article: HealthArticle
    let isBookmarked: Bool
    let onBookmark: () -> Void
    @EnvironmentObject private var languageManager: LanguageManager

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                Text(languageManager.useBangla ? article.titleBN : article.titleEN)
                    .font(.title2.bold())
                Text(languageManager.useBangla ? article.bodyBN : article.bodyEN)
                    .foregroundStyle(.secondary)
            }
            .padding()
        }
        .navigationTitle(article.topic)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(action: onBookmark) {
                    Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                }
            }
        }
    }
}
