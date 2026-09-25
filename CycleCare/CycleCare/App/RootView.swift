import SwiftUI

struct RootView: View {
    @AppStorage(AppConstants.UserDefaultsKeys.hasCompletedOnboarding) private var hasCompletedOnboarding = false
    @AppStorage(AppConstants.UserDefaultsKeys.hasCompletedProfileSetup) private var hasCompletedProfileSetup = false
    @EnvironmentObject private var authService: AuthService
    @State private var showSplash = true

    var body: some View {
        Group {
            if showSplash {
                SplashView()
            } else if !hasCompletedOnboarding {
                OnboardingFlowView()
            } else if !authService.isAuthenticated {
                AuthFlowView()
            } else if !hasCompletedProfileSetup {
                NavigationStack {
                    ProfileSetupView(onComplete: { hasCompletedProfileSetup = true })
                }
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut, value: showSplash)
        .animation(.easeInOut, value: hasCompletedOnboarding)
        .animation(.easeInOut, value: authService.isAuthenticated)
        .task {
            try? await Task.sleep(for: .seconds(1.2))
            showSplash = false
        }
    }
}
