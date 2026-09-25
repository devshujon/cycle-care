import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            LinearGradient(
                colors: [CCColor.primarySoft, CCColor.primaryFallback.opacity(0.35)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            VStack(spacing: 16) {
                Image(systemName: "heart.circle.fill")
                    .font(.system(size: 72))
                    .foregroundStyle(CCColor.primaryFallback)
                Text("CycleCare")
                    .font(.system(.largeTitle, design: .rounded, weight: .bold))
                Text("splash.tagline")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
            }
        }
    }
}
