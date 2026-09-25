import SwiftUI

struct RegisterView: View {
    @Binding var path: NavigationPath
    @EnvironmentObject private var authService: AuthService
    @State private var email = ""
    @State private var password = ""
    @State private var confirm = ""
    @State private var isLoading = false
    @State private var alertMessage: String?

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("auth.createAccount")
                    .font(.system(.title2, design: .rounded, weight: .bold))
                    .frame(maxWidth: .infinity, alignment: .leading)

                CCCard {
                    VStack(spacing: 14) {
                        FormTextField(title: "auth.email", text: $email)
                        FormTextField(title: "auth.password", text: $password, isSecure: true)
                        FormTextField(title: "auth.confirmPassword", text: $confirm, isSecure: true)
                        PrimaryButton(title: "auth.register", isLoading: isLoading) {
                            Task { await register() }
                        }
                    }
                }
            }
            .padding()
        }
        .navigationTitle("auth.register")
        .navigationBarTitleDisplayMode(.inline)
        .alert("common.error", isPresented: .constant(alertMessage != nil)) {
            Button("common.ok") { alertMessage = nil }
        } message: {
            Text(alertMessage ?? "")
        }
    }

    private func register() async {
        guard password == confirm else {
            alertMessage = String(localized: "auth.error.passwordMismatch")
            return
        }
        isLoading = true
        defer { isLoading = false }
        do {
            try await authService.signUp(email: email, password: password)
        } catch {
            alertMessage = error.localizedDescription
        }
    }
}
