import Foundation
import StoreKit

final class IAPManager: NSObject {

    // MARK: - Errors

    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }

    // MARK: - Singleton

    static let shared = IAPManager()

    // MARK: - Handlers

    private var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    private var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?

    private var didFinishPurchase = false
    private var totalRestoredPurchases = 0

    private override init() {
        super.init()
    }

    // MARK: - Setup

    func startObserving() {
        SKPaymentQueue.default().add(self)
    }

    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }

    func canMakePayments() -> Bool {
        SKPaymentQueue.canMakePayments()
    }

    // MARK: - Products

    private func getProductIDs() -> [String]? {
        [
            InAppPurchaseProductID.kWeekly,
            InAppPurchaseProductID.kMonthly,
            InAppPurchaseProductID.kYearly
        ]
    }

    func getProducts(
        withHandler handler: @escaping (Result<[SKProduct], IAPManagerError>) -> Void
    ) {
        onReceiveProductsHandler = handler

        guard let ids = getProductIDs() else {
            handler(.failure(.noProductIDsFound))
            return
        }

        let request = SKProductsRequest(productIdentifiers: Set(ids))
        request.delegate = self
        request.start()
    }

    func getPriceFormatted(for product: SKProduct) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = product.priceLocale
        return formatter.string(from: product.price)
    }

    // MARK: - Purchase

    func buy(
        product: SKProduct,
        withHandler handler: @escaping (Result<Bool, Error>) -> Void
    ) {
        resetPurchaseState()
        onBuyProductHandler = handler

        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)
    }

    func restorePurchases(
        withHandler handler: @escaping (Result<Bool, Error>) -> Void
    ) {
        resetPurchaseState()
        onBuyProductHandler = handler
        totalRestoredPurchases = 0

        SKPaymentQueue.default().restoreCompletedTransactions()
    }

    private func resetPurchaseState() {
        didFinishPurchase = false
        onBuyProductHandler = nil
    }

    private func completePurchase(_ result: Result<Bool, Error>) {
        guard !didFinishPurchase else { return }
        didFinishPurchase = true

        DispatchQueue.main.async {
            self.onBuyProductHandler?(result)
            self.onBuyProductHandler = nil
        }
    }
}

// MARK: - SKPaymentTransactionObserver

extension IAPManager: SKPaymentTransactionObserver {

    func paymentQueue(
        _ queue: SKPaymentQueue,
        updatedTransactions transactions: [SKPaymentTransaction]
    ) {
        for transaction in transactions {
            switch transaction.transactionState {

            case .purchased:
                validateReceipt { error, success in
                    if success {
                        self.completePurchase(.success(true))
                    } else {
                        self.completePurchase(.failure(error ?? IAPManagerError.productRequestFailed))
                    }
                    SKPaymentQueue.default().finishTransaction(transaction)
                }

            case .failed:
                let error = transaction.error as? SKError
                if error?.code == .paymentCancelled {
                    completePurchase(.failure(IAPManagerError.paymentWasCancelled))
                } else {
                    completePurchase(.failure(error ?? IAPManagerError.productRequestFailed))
                }
                SKPaymentQueue.default().finishTransaction(transaction)

            case .restored:
                totalRestoredPurchases += 1
                SKPaymentQueue.default().finishTransaction(transaction)

            case .purchasing, .deferred:
                break

            @unknown default:
                break
            }
        }
    }

    func paymentQueueRestoreCompletedTransactionsFinished(_ queue: SKPaymentQueue) {
        if totalRestoredPurchases == 0 {
            completePurchase(.success(false))
            return
        }

        validateReceipt { error, success in
            if success {
                self.completePurchase(.success(true))
            } else {
                self.completePurchase(.failure(error ?? IAPManagerError.productRequestFailed))
            }
        }
    }

    func paymentQueue(
        _ queue: SKPaymentQueue,
        restoreCompletedTransactionsFailedWithError error: Error
    ) {
        if let skError = error as? SKError, skError.code == .paymentCancelled {
            completePurchase(.failure(IAPManagerError.paymentWasCancelled))
        } else {
            completePurchase(.failure(error))
        }
    }
}

// MARK: - Products Request

extension IAPManager: SKProductsRequestDelegate {

    func productsRequest(
        _ request: SKProductsRequest,
        didReceive response: SKProductsResponse
    ) {
        if response.products.isEmpty {
            onReceiveProductsHandler?(.failure(.noProductsFound))
        } else {
            onReceiveProductsHandler?(.success(response.products))
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }
}

// MARK: - Localized Errors

extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound:
            return "No In-App Purchase product identifiers were found."
        case .noProductsFound:
            return "No In-App Purchases were found."
        case .productRequestFailed:
            return "Unable to fetch In-App Purchases."
        case .paymentWasCancelled:
            return "Purchase was cancelled."
        }
    }
}

extension IAPManager {

    enum ReceiptStatus: Int {
        case unknown = -2
        case none = -1
        case valid = 0
        case jsonNotReadable = 21000
        case malformedOrMissingData = 21002
        case receiptCouldNotBeAuthenticated = 21003
        case secretNotMatching = 21004
        case receiptServerUnavailable = 21005
        case subscriptionExpired = 21006
        case testReceipt = 21007
        case productionEnvironment = 21008

        var isValid: Bool { self == .valid }
    }

    func validateReceipt(
        isProduction: Bool = true,
        completion: @escaping (_ error: Error?, _ success: Bool) -> Void
    ) {

        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            refreshReceipt(completion: completion)
            return
        }

        guard FileManager.default.fileExists(atPath: receiptURL.path),
              let receiptData = try? Data(contentsOf: receiptURL) else {
            refreshReceipt(completion: completion)
            return
        }

        let receiptString = receiptData.base64EncodedString()

        var requestBody: [String: Any] = [
            "receipt-data": receiptString,
            "exclude-old-transactions": true
        ]

        if !InAppConstant.kSHARED_SECRET.isEmpty {
            requestBody["password"] = InAppConstant.kSHARED_SECRET
        }

        guard let bodyData = try? JSONSerialization.data(withJSONObject: requestBody) else {
            completion(createCustomError("Receipt serialization failed", 201), false)
            return
        }

        let urlString = isProduction
        ? InAppConstant.kRECEIPT_VERIFY_URL_PRODUCTION
        : InAppConstant.kRECEIPT_VERIFY_URL_SANDBOX

        guard let url = URL(string: urlString) else {
            completion(createCustomError("Invalid receipt URL", 201), false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = bodyData
        request.cachePolicy = .reloadIgnoringCacheData

        URLSession.shared.dataTask(with: request) { data, _, error in
            if let error = error {
                completion(error, false)
                return
            }

            guard let data = data,
                  let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
                completion(self.createCustomError("Invalid receipt response", 201), false)
                return
            }

            let statusCode = json["status"] as? Int ?? -1
            let status = ReceiptStatus(rawValue: statusCode) ?? .unknown

            switch status {
            case .valid:
                completion(nil, true)

            case .testReceipt:
                self.validateReceipt(isProduction: false, completion: completion)

            default:
                completion(
                    self.createCustomError("Receipt validation failed: \(statusCode)", statusCode),
                    false
                )
            }

        }.resume()
    }

    private func refreshReceipt(
        completion: @escaping (_ error: Error?, _ success: Bool) -> Void
    ) {
        let request = SKReceiptRefreshRequest()
        request.start()

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.validateReceipt(isProduction: true, completion: completion)
        }
    }

    private func createCustomError(_ message: String, _ code: Int) -> Error {
        NSError(
            domain: "com.yourapp.iap",
            code: code,
            userInfo: [NSLocalizedDescriptionKey: message]
        )
    }
}
