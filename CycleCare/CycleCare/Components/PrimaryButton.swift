import SwiftUI

struct PrimaryButton: View {
    let title: LocalizedStringKey
    var isLoading: Bool = false
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if isLoading {
                    ProgressView()
                        .tint(.white)
                }
                Text(title)
                    .font(.system(.body, design: .rounded, weight: .semibold))
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 14)
            .background(CCColor.primaryFallback)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
        .disabled(isLoading)
    }
}

struct SecondaryButton: View {
    let title: LocalizedStringKey
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(.body, design: .rounded, weight: .medium))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background(CCColor.primarySoft)
                .foregroundStyle(CCColor.primaryFallback)
                .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))
        }
    }
}
