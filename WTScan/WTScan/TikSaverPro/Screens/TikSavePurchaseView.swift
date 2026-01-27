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
    @State private var products: [SKProduct] = []
    @State private var errorMessage: String?
    @State private var selectedProduct: SKProduct?
    private let termsURL = URL(string: WTConstant.termsConditionURL)!
    private let privacyURL = URL(string: WTConstant.privacyPolicyURL)!
    @State private var webItem: WebItem?
    @Binding var isPremium: Bool
    @State private var isScreenVisible: Bool = false
    @State private var subscriptionType: Int = UserDefaultManager.subscriptionType
    
    @ViewBuilder func BulletPoint(title: String) -> some View {
        HStack {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 20.0, height: 20.0)
                .foregroundStyle(AppColor.Pink)
            Text(title)
                .foregroundStyle(.white)
                .font(.system(size: 17, weight: .medium))
        }
    }
    
    @ViewBuilder func PlanView(name: String, price: String, period: String, isSelected: Bool, isSubscribed: Bool) -> some View {
        HStack(spacing: 10.0) {
            Image(systemName: "checkmark.circle.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 25.0, height: 25.0)
                .foregroundStyle(AppColor.Pink)
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
            do {
                WTLoader.show()
                let success = try await self.buy(product: product)
                WTLoader.dismiss()
                if success {
                    if product.productIdentifier == InAppPurchaseProductID.kWeekly {
                        subscriptionType = SubscriptionDuration.Weekly.rawValue
                        UserDefaultManager.subscriptionType =  SubscriptionDuration.Weekly.rawValue
                    }
                    else if product.productIdentifier == InAppPurchaseProductID.kMonthly {
                        subscriptionType = SubscriptionDuration.Monthly.rawValue
                        UserDefaultManager.subscriptionType = SubscriptionDuration.Monthly.rawValue
                    }
                    else if product.productIdentifier == InAppPurchaseProductID.kYearly {
                        subscriptionType = SubscriptionDuration.Yearly.rawValue
                        UserDefaultManager.subscriptionType = SubscriptionDuration.Monthly.rawValue
                    }
                    UserDefaultManager.isPremium = true
                    WTToastManager.shared.show("Purchase successful")
                    isPremium = true
                    dismiss()
                }
                else {
                    WTToastManager.shared.show("Something went wrong.")
                }
            } catch let iapError as IAPManager.IAPManagerError {
                WTLoader.dismiss()
                if iapError == .paymentWasCancelled {
                    WTToastManager.shared.show("Purchase cancelled.")
                } else {
                    WTToastManager.shared.show("Purchase failed. Please try again.")
                }
            } catch {
                WTLoader.dismiss()
                WTToastManager.shared.show(error.localizedDescription)
            }
        }
    }
    
    func btnPrivacyPolicyAction() {
        webItem = WebItem(url: privacyURL, title: "Privacy Policy")
    }
    
    func btnTermsOfUseAction() {
        webItem = WebItem(url: termsURL, title: "Terms of Use")
    }
    
    func getProducts() async throws -> [SKProduct] {
        try await withCheckedThrowingContinuation { continuation in
            IAPManager.shared.getProducts { result in
                switch result {
                case .success(let products):
                    continuation.resume(returning: products)
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func buy(product: SKProduct) async throws -> Bool {
        try await withCheckedThrowingContinuation { continuation in
            IAPManager.shared.buy(product: product) { result in
                switch result {
                case .success(let success):
                    continuation.resume(returning: success)

                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    func restore() {
        WTLoader.show()
        IAPManager.shared.restorePurchases { result in
            switch result {
            case .success(let success):
                if success {
                    self.verifyReceipt()
                } else {
                    WTLoader.dismiss()
                    WTToastManager.shared.show("Nothing to restore!")
                }
                
            case .failure(let error):
                WTLoader.dismiss()
                WTToastManager.shared.show(error.localizedDescription)
            }
        }
    }
    
    private func verifyReceipt() {
        AppStoreReceiptValidator.shared.onRestoreHandler = { success in
            AppStoreReceiptValidator.shared.onRestoreHandler = nil
            WTLoader.dismiss()
            if AppData.shared.isSubscriptionExpired {
                WTToastManager.shared.show("Your subscription has expired")
            } else {
                WTToastManager.shared.show("Purchase restored successfully!")
                if UserDefaultManager.subscriptionType == SubscriptionDuration.Weekly.rawValue {
                    subscriptionType = SubscriptionDuration.Weekly.rawValue
                }
                else if UserDefaultManager.subscriptionType == SubscriptionDuration.Monthly.rawValue {
                    subscriptionType = SubscriptionDuration.Monthly.rawValue
                }
                else if UserDefaultManager.subscriptionType == SubscriptionDuration.Yearly.rawValue {
                    subscriptionType = SubscriptionDuration.Yearly.rawValue
                }
                
                UserDefaultManager.isPremium = true
                isPremium = true
                dismiss()
            }
        }
        AppStoreReceiptValidator.shared.verifyPurchase()
    }
    
    func isSubscribed(produc: SKProduct) -> Bool {
        if produc.productIdentifier == InAppPurchaseProductID.kWeekly {
            if subscriptionType == SubscriptionDuration.Weekly.rawValue {
                return true
            }
        }
        else if produc.productIdentifier == InAppPurchaseProductID.kMonthly {
            if subscriptionType == SubscriptionDuration.Monthly.rawValue {
                return true
            }
        }
        else if produc.productIdentifier == InAppPurchaseProductID.kYearly {
            if subscriptionType == SubscriptionDuration.Yearly.rawValue {
                return true
            }
        }
        return false
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
                            BulletPoint(title: "Download HD TikTok Video")
                            BulletPoint(title: "Remove Watermark")
                            BulletPoint(title: "Build Collections")
                        }
                        .padding(.top, 35)
                        VStack(spacing: 6) {
                            if products.count > 0 {
                                ForEach(products, id: \.productIdentifier) { product in
                                    let isSubscribed = self.isSubscribed(produc: product)
                                    PlanView(
                                        name: product.displayName,
                                        price: product.displayPrice,
                                        period: product.displayPeriod,
                                        isSelected: selectedProduct?.productIdentifier == product.productIdentifier,
                                        isSubscribed: isSubscribed
                                    )
                                    .onTapGesture {
                                        selectedProduct = product
                                    }
                                }
                            }
                            else {
                                PlanView(
                                    name: "Weekly",
                                    price: "$0",
                                    period: "Per week",
                                    isSelected: true,
                                    isSubscribed: false
                                )
                                PlanView(
                                    name: "Monthly",
                                    price: "$0",
                                    period: "Per month",
                                    isSelected: false,
                                    isSubscribed: false
                                )
                                PlanView(
                                    name: "Yearly",
                                    price: "$0",
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
                    self.restore()
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
        .task {
            do {
                WTLoader.show()
                products = try await self.getProducts()
                products.sort {
                    $0.price.compare($1.price) == .orderedAscending
                }
                // ✅ Auto-select Weekly (first item)
                if UserDefaultManager.subscriptionType == SubscriptionDuration.Weekly.rawValue {
                    subscriptionType = SubscriptionDuration.Weekly.rawValue
                    if let index = self.products.firstIndex(where: {$0.productIdentifier == InAppPurchaseProductID.kWeekly}) {
                        selectedProduct = products[index]
                    }
                }
                else if UserDefaultManager.subscriptionType == SubscriptionDuration.Monthly.rawValue {
                    subscriptionType = SubscriptionDuration.Monthly.rawValue
                    if let index = self.products.firstIndex(where: {$0.productIdentifier == InAppPurchaseProductID.kMonthly}) {
                        selectedProduct = products[index]
                    }
                }
                else if UserDefaultManager.subscriptionType == SubscriptionDuration.Yearly.rawValue {
                    subscriptionType = SubscriptionDuration.Yearly.rawValue
                    if let index = self.products.firstIndex(where: {$0.productIdentifier == InAppPurchaseProductID.kYearly}) {
                        selectedProduct = products[index]
                    }
                }
                else {
                    selectedProduct = products.first
                }
                WTLoader.dismiss()
            } catch {
                WTLoader.dismiss()
                WTToastManager.shared.show(error.localizedDescription)
            }
        }
        .onAppear {
            isScreenVisible = true
        }
        .onDisappear {
            isScreenVisible = false
        }
    }
}

