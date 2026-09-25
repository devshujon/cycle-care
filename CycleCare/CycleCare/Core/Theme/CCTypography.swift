import SwiftUI

enum CCTypography {
    static func title(_ text: String) -> some View {
        Text(text)
            .font(.system(.title2, design: .rounded, weight: .semibold))
    }

    static func headline(_ text: String) -> some View {
        Text(text)
            .font(.system(.headline, design: .rounded, weight: .semibold))
    }

    static func body(_ text: String) -> some View {
        Text(text)
            .font(.system(.body, design: .rounded))
    }

    static func caption(_ text: String) -> some View {
        Text(text)
            .font(.system(.caption, design: .rounded))
            .foregroundStyle(.secondary)
    }
}
