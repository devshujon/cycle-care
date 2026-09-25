import Foundation
import GoogleMobileAds
import SwiftUI

@MainActor
final class AdMobService: ObservableObject {
    static let shared = AdMobService()

    @Published private(set) var isInitialized = false

    private init() {}

    func configure() {
        guard !isInitialized else { return }
        GADMobileAds.sharedInstance().start(completionHandler: { [weak self] _ in
            Task { @MainActor in
                self?.isInitialized = true
            }
        })
    }

    var shouldShowAds: Bool {
        !SubscriptionManager.shared.isPro
    }
}

struct AdSlot: View {
    let adUnitID: String

    @ObservedObject private var ads = AdMobService.shared
    @ObservedObject private var subscription = SubscriptionManager.shared

    var body: some View {
        if ads.shouldShowAds {
            BannerAdView(adUnitID: adUnitID)
                .frame(height: 50)
                .accessibilityHidden(true)
        }
    }
}

private struct BannerAdView: UIViewRepresentable {
    let adUnitID: String

    func makeUIView(context: Context) -> GADBannerView {
        let banner = GADBannerView(adSize: GADAdSizeBanner)
        banner.adUnitID = adUnitID
        banner.rootViewController = UIApplication.shared.connectedScenes
            .compactMap { ($0 as? UIWindowScene)?.keyWindow?.rootViewController }
            .first
        banner.load(GADRequest())
        return banner
    }

    func updateUIView(_ uiView: GADBannerView, context: Context) {}
}
