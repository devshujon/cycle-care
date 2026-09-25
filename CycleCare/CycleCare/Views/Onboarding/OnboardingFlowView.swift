import SwiftUI

struct OnboardingFlowView: View {
    @State private var step = 0
    @State private var showLanguage = true
    @AppStorage(AppConstants.UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @EnvironmentObject private var languageManager: LanguageManager

    var body: some View {
        NavigationStack {
            TabView(selection: $step) {
                onboardingPage(
                    title: "onboarding.track.title",
                    subtitle: "onboarding.track.subtitle",
                    symbol: "calendar"
                ).tag(0)
                onboardingPage(
                    title: "onboarding.wellness.title",
                    subtitle: "onboarding.wellness.subtitle",
                    symbol: "leaf"
                ).tag(1)
                onboardingPage(
                    title: "onboarding.reminders.title",
                    subtitle: "onboarding.reminders.subtitle",
                    symbol: "bell.badge"
                ).tag(2)
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))
            .safeAreaInset(edge: .bottom) {
                VStack(spacing: 12) {
                    PrimaryButton(title: step == 2 ? "onboarding.getStarted" : "common.continue") {
                        if step < 2 { step += 1 } else { hasCompletedOnboarding = true }
                    }
                    if step == 0 {
                        Button("onboarding.chooseLanguage") { showLanguage = true }
                            .font(.footnote)
                    }
                }
                .padding()
            }
            .navigationTitle("")
            .sheet(isPresented: $showLanguage) {
                LanguageSelectionView()
            }
        }
    }

    private func onboardingPage(title: LocalizedStringKey, subtitle: LocalizedStringKey, symbol: String) -> some View {
        VStack(spacing: 24) {
            Spacer()
            Image(systemName: symbol)
                .font(.system(size: 64))
                .foregroundStyle(CCColor.primaryFallback)
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(.title, design: .rounded, weight: .bold))
                    .multilineTextAlignment(.center)
                Text(subtitle)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
            Spacer()
            Spacer()
        }
        .padding()
    }
}

struct LanguageSelectionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var languageManager: LanguageManager

    var body: some View {
        NavigationStack {
            List {
                Button {
                    languageManager.setLanguage(code: "en")
                    dismiss()
                } label: {
                    HStack {
                        Text("English")
                        Spacer()
                        if !languageManager.useBangla { Image(systemName: "checkmark") }
                    }
                }
                Button {
                    languageManager.setLanguage(code: "bn")
                    dismiss()
                } label: {
                    HStack {
                        Text("বাংলা")
                        Spacer()
                        if languageManager.useBangla { Image(systemName: "checkmark") }
                    }
                }
            }
            .navigationTitle("language.title")
        }
    }
}
