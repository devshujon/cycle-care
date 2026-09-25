import SwiftData
import SwiftUI

struct SettingsView: View {
    @EnvironmentObject private var authService: AuthService
    @EnvironmentObject private var languageManager: LanguageManager
    @EnvironmentObject private var subscription: SubscriptionManager
    @Environment(\.modelContext) private var context
    @StateObject private var profileVM = ProfileViewModel()
    @State private var showLanguage = false
    @State private var showSubscription = false
    @AppStorage(AppConstants.UserDefaultsKeys.hasCompletedProfileSetup) private var hasCompletedProfileSetup = true

    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink { ProfileView() } label: {
                        Label("settings.profile", systemImage: "person.crop.circle")
                    }
                    NavigationLink { PregnancyTrackersView() } label: {
                        Label("pregnancy.title", systemImage: "figure.and.child.holdinghands")
                    }
                }

                Section("settings.preferences") {
                    Button {
                        showLanguage = true
                    } label: {
                        Label("language.title", systemImage: "globe")
                    }
                    if subscription.isPro {
                        Label("subscription.activePro", systemImage: "crown.fill")
                            .foregroundStyle(CCColor.primaryFallback)
                    } else {
                        Button { showSubscription = true } label: {
                            Label("subscription.upgrade", systemImage: "crown")
                        }
                    }
                }

                Section("settings.data") {
                    if subscription.isPro {
                        Button("settings.exportPDF") { exportPDF() }
                    } else {
                        Text("settings.exportPDF.pro")
                            .font(.footnote)
                            .foregroundStyle(.secondary)
                    }
                }

                Section {
                    Button("auth.signOut", role: .destructive) {
                        try? authService.signOut()
                        hasCompletedProfileSetup = false
                    }
                }
            }
            .navigationTitle("settings.title")
            .onAppear { profileVM.loadOrCreate(context: context) }
            .sheet(isPresented: $showLanguage) { LanguageSelectionView() }
            .sheet(isPresented: $showSubscription) { SubscriptionView() }
        }
    }

    private func exportPDF() {
        // Placeholder: integrate PDFKit report generation for Pro users.
    }
}

struct ProfileView: View {
    @Environment(\.modelContext) private var context
    @StateObject private var viewModel = ProfileViewModel()

    var body: some View {
        ProfileSetupView(onComplete: {})
            .navigationTitle("settings.profile")
            .onAppear { viewModel.loadOrCreate(context: context) }
    }
}
