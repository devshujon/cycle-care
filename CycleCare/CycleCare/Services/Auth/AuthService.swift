import AuthenticationServices
import CryptoKit
import FirebaseAuth
import FirebaseCore
import Foundation

enum AuthError: LocalizedError {
    case invalidEmail
    case weakPassword
    case emptyFields
    case firebase(String)

    var errorDescription: String? {
        switch self {
        case .invalidEmail: return String(localized: "auth.error.invalidEmail")
        case .weakPassword: return String(localized: "auth.error.weakPassword")
        case .emptyFields: return String(localized: "auth.error.emptyFields")
        case .firebase(let message): return message
        }
    }
}

@MainActor
final class AuthService: ObservableObject {
    @Published private(set) var user: User?
    @Published private(set) var isAuthenticated = false
    @Published var errorMessage: String?

    private var authStateHandle: AuthStateDidChangeListenerHandle?
    private var currentNonce: String?

    init() {
        guard FirebaseApp.app() != nil else { return }
        authStateHandle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            Task { @MainActor in
                self?.user = user
                self?.isAuthenticated = user != nil
            }
        }
    }

    deinit {
        if let authStateHandle {
            Auth.auth().removeStateDidChangeListener(authStateHandle)
        }
    }

    func signUp(email: String, password: String) async throws {
        try validate(email: email, password: password)
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
        } catch {
            throw AuthError.firebase(error.localizedDescription)
        }
    }

    func signIn(email: String, password: String) async throws {
        try validate(email: email, password: password)
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
        } catch {
            throw AuthError.firebase(error.localizedDescription)
        }
    }

    func resetPassword(email: String) async throws {
        guard email.contains("@") else { throw AuthError.invalidEmail }
        do {
            try await Auth.auth().sendPasswordReset(withEmail: email)
        } catch {
            throw AuthError.firebase(error.localizedDescription)
        }
    }

    func signOut() throws {
        try Auth.auth().signOut()
    }

    func prepareAppleSignInRequest(_ request: ASAuthorizationAppleIDRequest) {
        let nonce = randomNonceString()
        currentNonce = nonce
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }

    func handleAppleSignIn(result: Result<ASAuthorization, Error>) async throws {
        switch result {
        case .failure(let error):
            throw AuthError.firebase(error.localizedDescription)
        case .success(let authorization):
            guard
                let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential,
                let tokenData = appleIDCredential.identityToken,
                let idToken = String(data: tokenData, encoding: .utf8),
                let nonce = currentNonce
            else {
                throw AuthError.firebase(String(localized: "auth.error.apple"))
            }

            let credential = OAuthProvider.credential(
                withProviderID: "apple.com",
                idToken: idToken,
                rawNonce: nonce
            )

            do {
                _ = try await Auth.auth().signIn(with: credential)
            } catch {
                throw AuthError.firebase(error.localizedDescription)
            }
        }
    }

    private func validate(email: String, password: String) throws {
        guard !email.isEmpty, !password.isEmpty else { throw AuthError.emptyFields }
        guard email.contains("@"), email.contains(".") else { throw AuthError.invalidEmail }
        guard password.count >= 6 else { throw AuthError.weakPassword }
    }

    private func sha256(_ input: String) -> String {
        let data = Data(input.utf8)
        let hash = SHA256.hash(data: data)
        return hash.map { String(format: "%02x", $0) }.joined()
    }

    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError("Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)")
        }
        let charset: [Character] = Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        return String(randomBytes.map { charset[Int($0) % charset.count] })
    }
}
