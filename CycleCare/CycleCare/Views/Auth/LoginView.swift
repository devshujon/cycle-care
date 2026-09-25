import AuthenticationServices
import SwiftUI

struct LoginView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var isLoading = false
    @State private var alertMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                VStack(spacing: 8) {
                    Text("auth.welcomeBack")
                        .font(.system(.title, design: .rounded, weight: .bold))
                    Text("auth.login.subtitle")
                        .foregroundStyle(.secondary)
                }
                .padding(.top, 24)

                CCCard {
                    VStack(spacing: 14) {
                        FormTextField(title: "auth.email", text: $email)
                        FormTextField(title: "auth.password", text: $password, isSecure: true)
                        PrimaryButton(title: "auth.login", isLoading: isLoading) {
                            Task { await login() }
                        }
                        Button("auth.forgotPassword") { path.append(AuthRoute.forgot) }
                            .font(.footnote)
                    }
                }

                SignInWithAppleButton(.signIn) { request in
                    authService.prepareAppleSignInRequest(request)
                } onCompletion: { result in
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        do {
                            try await authService.handleAppleSignIn(result: result)
                        } catch {
                            alertMessage = error.localizedDescription
                        }
                    }
                }
                .signInWithAppleButtonStyle(.black)
                .frame(height: 48)
                .clipShape(RoundedRectangle(cornerRadius: 12))

                HStack {
                    Text("auth.noAccount")
                    Button("auth.register") { path.append(AuthRoute.register) }
                }
                .font(.footnote)
            }
            .padding()
        }
        .background(Color(uiColor: .systemGroupedBackground))
        .alert("common.error", isPresented: .constant(alertMessage != nil)) {
            Button("common.ok") { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
    }

    private func login() async {
        isLoading = true
        defer { isLoading = false }
        do {
                            try await authService.signIn(email: email, password: password)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
