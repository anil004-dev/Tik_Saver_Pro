import StoreKit
import Combine

@MainActor
final class SubscriptionsManager: ObservableObject {

    // MARK: - Product IDs
    let productIDs: [String] = [
        InAppPurchaseProductID.kWeekly,
        InAppPurchaseProductID.kMonthly,
        InAppPurchaseProductID.kYearly
    ]

    // MARK: - Published State
    @Published var products: [Product] = []
    @Published var activeSubscriptionID: String? = nil
    @Published var activeSubscription: Product? = nil

    @Published var loadProductError: String = ""
    @Published var buyProductsError: String = ""
    @Published var restoreProductsError: String = ""

    private let entitlementManager: EntitlementManager
    private var updatesTask: Task<Void, Never>?

    // MARK: - Init
    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        self.updatesTask = listenForTransactions()
    }

    deinit {
        updatesTask?.cancel()
    }
}

extension SubscriptionsManager {

    func loadProducts() async {
        do {
            products = try await Product.products(for: productIDs)
                .sorted(by: { $0.price < $1.price }) // yearly → weekly
        } catch {
            loadProductError = "Failed to fetch products."
        }
    }
}

extension SubscriptionsManager {

    func buyProduct(_ product: Product) async {
        do {
            let result = try await product.purchase()

            switch result {

            case .success(let verification):
                let transaction = try checkVerified(verification)
                await transaction.finish()
                await updatePurchasedProducts()
                buyProductsError = "Purchased successfully."
            case .userCancelled:
                buyProductsError = "Purchase cancelled."

            case .pending:
                buyProductsError = "Purchase pending approval."

            @unknown default:
                buyProductsError = "Purchase failed."
            }

        } catch {
            buyProductsError = error.localizedDescription
        }
    }
}

extension SubscriptionsManager {

    func restorePurchases() async {
        do {
            try await AppStore.sync()
            await updatePurchasedProducts()
        } catch {
            restoreProductsError = error.localizedDescription
        }
    }
}

extension SubscriptionsManager {

    func updatePurchasedProducts() async {

        activeSubscriptionID = nil
        activeSubscription = nil

        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else { continue }

            // Only auto-renewable subscriptions
            guard transaction.productType == .autoRenewable else { continue }

            // Ignore revoked
            guard transaction.revocationDate == nil else { continue }

            // Ignore expired
            if let expirationDate = transaction.expirationDate,
               expirationDate <= Date() {
                continue
            }

            // ✅ Only ONE subscription can be active
            activeSubscriptionID = transaction.productID
            activeSubscription = products.first { $0.id == transaction.productID }
            break
        }

        entitlementManager.hasPro = activeSubscriptionID != nil
    }
}

extension SubscriptionsManager {

    private func listenForTransactions() -> Task<Void, Never> {
        Task.detached(priority: .background) { [weak self] in
            guard let self else { return }

            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
}

extension SubscriptionsManager {

    private func checkVerified<T>(
        _ result: VerificationResult<T>
    ) throws -> T {
        switch result {
        case .verified(let safe):
            return safe
        case .unverified:
            throw PurchaseVerificationError.failedVerification
        }
    }
}

enum PurchaseVerificationError: Error {
    case failedVerification
}
