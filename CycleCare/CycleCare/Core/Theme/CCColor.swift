import SwiftUI

enum CCColor {
    static let primary = Color("PrimaryPink", bundle: .main)
    static let primarySoft = Color("PrimaryPinkSoft", bundle: .main)
    static let accent = Color("AccentRose", bundle: .main)
    static let background = Color("Background", bundle: .main)
    static let card = Color("CardBackground", bundle: .main)
    static let textPrimary = Color.primary
    static let textSecondary = Color.secondary

    /// Fallback when asset colors are missing in preview.
    static var primaryFallback: Color { Color(red: 0.91, green: 0.45, blue: 0.62) }
    static var cardFallback: Color { Color(uiColor: .secondarySystemGroupedBackground) }
}
