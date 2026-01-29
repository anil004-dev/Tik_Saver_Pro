//
//  TikSavePurchaseView.swift
//  WTScan
//
//  Created by Anil Jadav on 26/01/26.
//

import SwiftUI
import StoreKit

struct TikSavePurchaseView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedProduct: Product?
    private let termsURL = URL(string: WTConstant.termsConditionURL)!
    private let privacyURL = URL(string: WTConstant.privacyPolicyURL)!
    @State private var webItem: WebItem?
    
    @EnvironmentObject private var entitlementManager: EntitlementManager
    @EnvironmentObject private var subscriptionsManager: SubscriptionsManager
    
    @ViewBuilder func BulletPoint(title: String) -> some View {
        HStack {
            Image("ic_pin_checkmark")
                .resizable()
                .scaledToFit()
                .frame(width: 20.0, height: 20.0)
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 17, weight: .medium))
        }
    }
    
    @ViewBuilder func PlanView(name: String, price: String, period: String, isSelected: Bool, isSubscribed: Bool) -> some View {
        HStack(spacing: 10.0) {
            Image(isSelected ? "ic_pin_checkmark" : "ic_uncheck_gray")
                .resizable()
                .scaledToFit()
                .frame(width: 25.0, height: 25.0)
            Text("\(name) \(isSubscribed ? "(Subscribed)": "")")
                .foregroundStyle(.white)
                .font(.system(size: 18, weight: .semibold))
            Spacer()
            VStack(alignment: .trailing, spacing: 3.0) {
                Text(price)
                    .foregroundStyle(.white)
                    .font(.system(size: 20, weight: .semibold))
                Text(period)
                    .foregroundStyle(Color(hex: "#909090"))
                    .font(.system(size: 15, weight: .regular))
            }
        }
        .padding()
        .background(Color(hex: "#D8D8D8", opacity: 0.12))
        .overlay(
            RoundedRectangle(cornerRadius: 20)
                .stroke(isSelected ? AppColor.Pink : .clear, lineWidth: 2)
        )
        .cornerRadius(20.0)
    }
    
    func btnSubscribeNowAction() {
        Task {
            guard let product = selectedProduct else { return }
            await buy(product: product)
        }
    }
    
    func btnPrivacyPolicyAction() {
        webItem = WebItem(url: privacyURL, title: "Privacy Policy")
    }
    
    func btnTermsOfUseAction() {
        webItem = WebItem(url: termsURL, title: "Terms of Use")
    }

    func buy(product: Product) async {
        AppState.shared.isRequestingPermission = true
        WTLoader.show()
        await subscriptionsManager.buyProduct(product)
        WTLoader.dismiss()
        AppState.shared.isRequestingPermission = false
        dismiss()
    }
    
    func restore() async {
        AppState.shared.isRequestingPermission = true
        WTLoader.show()
        await subscriptionsManager.restorePurchases()
        WTLoader.dismiss()
        if subscriptionsManager.activeSubscriptionID == nil {
            WTToastManager.shared.show("Nothing to restore!")
        }
        else {
            WTToastManager.shared.show("Restore scuccessfully!")
        }
        AppState.shared.isRequestingPermission = false
        dismiss()
    }

    private func isSubscribed(_ product: Product) -> Bool {
        subscriptionsManager.activeSubscriptionID == product.id
    }
    
    var body: some View {
        ScreenContainer {
            ZStack {
                ScrollView {
                    VStack {
                        Image("splash_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 242.0, height: 97.0)
                        VStack(alignment: .leading, spacing: 9) {
                            BulletPoint(title: "No Ads")
                            if AppState.shared.isLive {
                                BulletPoint(title: "Download HD TikTok Video")
                                BulletPoint(title: "Remove Watermark")
                                BulletPoint(title: "Build Collections")
                            }
                            else {
                                BulletPoint(title: "Access all features")
                                BulletPoint(title: "Stylish Text")
                                BulletPoint(title: "Font Styling")
                            }
                        }
                        .padding(.top, 35)
                        VStack(spacing: 6) {
                            if !subscriptionsManager.products.isEmpty {
                                ForEach(subscriptionsManager.products, id: \.id) { product in
                                    PlanView(
                                        name: product.displayName,
                                        price: product.displayPrice,
                                        period: product.displayPeriod,
                                        isSelected: selectedProduct?.id == product.id,
                                        isSubscribed: isSubscribed(product)
                                    )
                                    .onTapGesture {
                                        selectedProduct = product
                                    }
                                }
                            } else {
                                // Skeleton / fallback UI
                                PlanView(
                                    name: "Weekly",
                                    price: "--",
                                    period: "Per week",
                                    isSelected: true,
                                    isSubscribed: false
                                )

                                PlanView(
                                    name: "Monthly",
                                    price: "--",
                                    period: "Per month",
                                    isSelected: false,
                                    isSubscribed: false
                                )

                                PlanView(
                                    name: "Yearly",
                                    price: "--",
                                    period: "Per year",
                                    isSelected: false,
                                    isSubscribed: false
                                )
                            }
                        }
                        .padding(.top, 35)
                        Text("Payment will be charged to your Apple ID account.Subscription renews automatically unless cancelled at least 24 hours before the end of the period.")
                            .foregroundStyle(Color(hex: "#EBEBF5", opacity: 0.6))
                            .font(.system(size: 13, weight: .regular))
                            .multilineTextAlignment(.leading)
                            .padding(.top, 9)
                        Button(action: btnSubscribeNowAction) {
                            HStack {
                                Spacer()
                                Text("Subscribe Now")
                                    .font(.system(size: 16, weight: .semibold))
                                    .foregroundStyle(.white)
                                Spacer()
                            }
                            .padding()
                            .background(AppColor.Pink)
                            .clipShape(.capsule)
                        }
                        HStack {
                            Button(action: btnTermsOfUseAction) {
                                Text("Terms of Use")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13, weight: .medium))
                                    .underline()
                            }
                            Spacer()
                            Button(action: btnPrivacyPolicyAction) {
                                Text("Privacy Policy")
                                    .foregroundStyle(.white)
                                    .font(.system(size: 13, weight: .medium))
                                    .underline()
                            }
                        }
                        .padding(.top, 12)
                    }
                    .padding(20)
                }
                WTToastView()
                    .zIndex(9999)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    Task {
                        await self.restore()
                    }
                } label: {
                    Text("Restore")
                }
            }

            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "xmark")
                }
            }
        }
        .sheet(item: $webItem) { item in
            TikSaveWebViewContainer(url: item.url, title: item.title)
        }
        .onChange(of: subscriptionsManager.loadProductError, { oldValue, newValue in
            if !newValue.isEmpty {
                WTToastManager.shared.show(newValue)
            }
        })
        .onChange(of: subscriptionsManager.buyProductsError, { oldValue, newValue in
            if !newValue.isEmpty {
                WTToastManager.shared.show(newValue)
            }
        })
        .task {
            do {
                WTLoader.show()
                await subscriptionsManager.loadProducts()
                if entitlementManager.hasPro {
                    selectedProduct = subscriptionsManager.activeSubscription
                }
                else {
                    selectedProduct = subscriptionsManager.products.first
                }
                WTLoader.dismiss()
            }
        }
    }
}

