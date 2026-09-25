import SwiftUI

struct AuthFlowView: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            LoginView(path: $path)
                .navigationDestination(for: AuthRoute.self) { route in
                    switch route {
                    case .register: RegisterView(path: $path)
                    case .forgot: ForgotPasswordView()
                    case .profileSetup: ProfileSetupView()
                    }
                }
        }
    }
}

enum AuthRoute: Hashable {
    case register, forgot, profileSetup
}
