import SwiftUI

struct ForgotPasswordView: View {
    @EnvironmentObject private var authService: AuthService
    @State private var email = ""
    @State private var isLoading = false
    @State private var message: String?

    var body: some View {
        Form {
            Section {
                TextField("auth.email", text: $email)
                    .textInputAutocapitalization(.never)
                    .keyboardType(.emailAddress)
            } footer: {
                Text("auth.forgot.footer")
            }

            Section {
                PrimaryButton(title: "auth.sendReset", isLoading: isLoading) {
                    Task {
                        isLoading = true
                        defer { isLoading = false }
                        do {
                            try await authService.resetPassword(email: email)
                            message = String(localized: "auth.resetSent")
                        } catch {
                            message = error.localizedDescription
                        }
                    }
                }
            }
        }
        .navigationTitle("auth.forgotPassword")
        .alert("common.info", isPresented: .constant(message != nil)) {
            Button("common.ok") { message = nil }
        } message: {
            Text(message ?? "")
        }
    }
}
