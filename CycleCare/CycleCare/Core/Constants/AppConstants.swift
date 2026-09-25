import Foundation

enum AppConstants {
    static let appName = "CycleCare"
    static let defaultCycleLength = 28
    static let defaultPeriodLength = 5
    static let freeHistoryMonths = 3

    enum UserDefaultsKeys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let selectedLanguageCode = "selectedLanguageCode"
        static let isLoggedIn = "isLoggedIn"
        static let hasCompletedProfileSetup = "hasCompletedProfileSetup"
    }

    enum AdMob {
        /// Google test banner unit — replace in production.
        static let banner = "ca-app-pub-3940256099942544/2934735716"
    }

    enum StoreKit {
        static let proMonthly = "com.cyclecare.app.pro.monthly"
        static let proYearly = "com.cyclecare.app.pro.yearly"
        static let productIDs: Set<String> = [proMonthly, proYearly]
    }
}
