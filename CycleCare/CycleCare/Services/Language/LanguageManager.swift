import Foundation
import SwiftUI

@MainActor
final class LanguageManager: ObservableObject {
    static let shared = LanguageManager()

    @Published var locale: Locale {
        didSet {
            UserDefaults.standard.set(locale.identifier, forKey: AppConstants.UserDefaultsKeys.selectedLanguageCode)
        }
    }

    var useBangla: Bool {
        locale.identifier.hasPrefix("bn")
    }

    private init() {
        let saved = UserDefaults.standard.string(forKey: AppConstants.UserDefaultsKeys.selectedLanguageCode) ?? "en"
        locale = Locale(identifier: saved)
    }

    func setLanguage(code: String) {
        locale = Locale(identifier: code)
    }
}

private struct AppLocaleKey: EnvironmentKey {
    static let defaultValue = Locale(identifier: "en")
}

extension EnvironmentValues {
    var appLocale: Locale {
        get { self[AppLocaleKey.self] }
        set { self[AppLocaleKey.self] = newValue }
    }
}
