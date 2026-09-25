import StoreKit
import SwiftUI

struct SubscriptionView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var subscription: SubscriptionManager
    @State private var showConfirmation = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    VStack(spacing: 8) {
                        Image(systemName: "crown.fill")
                            .font(.system(size: 48))
                            .foregroundStyle(CCColor.primaryFallback)
                        Text("subscription.title")
                            .font(.system(.title, design: .rounded, weight: .bold))
                        Text("subscription.subtitle")
                            .multilineTextAlignment(.center)
                            .foregroundStyle(.secondary)
                    }
                    .padding(.top)

                    featureList

                    if subscription.products.isEmpty {
                        ProgressView()
                            .task { await subscription.loadProducts() }
                    } else {
                        ForEach(subscription.products, id: \.id) { product in
                            Button {
                                Task {
                                    await subscription.purchase(product)
                                    if subscription.isPro { showConfirmation = true }
                                }
                            } label: {
                                HStack {
                                    VStack(alignment: .leading) {
                                        Text(product.displayName)
                                        Text(product.description)
                                            .font(.caption)
                                            .foregroundStyle(.secondary)
                                    }
                                    Spacer()
                                    Text(product.displayPrice)
                                        .font(.headline)
                                }
                                .padding()
                                .background(CCColor.cardFallback)
                                .clipShape(RoundedRectangle(cornerRadius: 14))
                            }
                            .buttonStyle(.plain)
                        }
                    }

                    Button("subscription.restore") {
                        Task { await subscription.restore() }
                    }
                    .font(.footnote)
                }
                .padding()
            }
            .navigationTitle("subscription.nav")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("common.close") { dismiss() }
                }
            }
            .overlay {
                if showConfirmation {
                    proConfirmation
                }
            }
        }
    }

    private var featureList: some View {
        VStack(alignment: .leading, spacing: 10) {
            featureRow("subscription.feature.history")
            featureRow("subscription.feature.charts")
            featureRow("subscription.feature.pdf")
            featureRow("subscription.feature.ads")
            featureRow("subscription.feature.backup")
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding()
        .background(CCColor.primarySoft.opacity(0.5))
        .clipShape(RoundedRectangle(cornerRadius: 16))
    }

    private func featureRow(_ key: LocalizedStringKey) -> some View {
        Label { Text(key) } icon: {
            Image(systemName: "checkmark.seal.fill")
                .foregroundStyle(CCColor.primaryFallback)
        }
    }

    private var proConfirmation: some View {
        ZStack {
            Color.black.opacity(0.4)
                .ignoresSafeArea()
            VStack(spacing: 16) {
                Text("subscription.welcomePro")
                    .font(.headline)
                PrimaryButton(title: "common.continue") {
                    showConfirmation = false
                    dismiss()
                }
            }
            .padding(24)
            .background(CCColor.cardFallback)
            .clipShape(RoundedRectangle(cornerRadius: 20))
            .padding(32)
        }
    }
}
