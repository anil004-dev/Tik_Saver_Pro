import Foundation

struct LatestReceiptInfo: Codable {
    let expiresDate: String?
    let expiresDateMs: String?
    let expiresDatePst: String?
    let isInIntroOfferPeriod: String?
    let inAppOwnershipType: String?
    let isTrialPeriod: String?
    let originalPurchaseDate: String?
    let originalPurchaseDateMs: String?
    let originalPurchaseDatePst: String?
    let originalTransactionId: String?
    let productId: String?
    let purchaseDate: String?
    let purchaseDateMs: String?
    let purchaseDatePst: String?
    let quantity: String?
    let transactionId: String?
    let cancellationDate: String?
    let cancellationDateMs: String?
    let cancellationDatePst: String?
    // Add more properties as needed
    
    enum CodingKeys: String, CodingKey {
        case expiresDate = "expires_date"
        case expiresDateMs = "expires_date_ms"
        case expiresDatePst = "expires_date_pst"
        case isInIntroOfferPeriod = "is_in_intro_offer_period"
        case inAppOwnershipType = "in_app_ownership_type"
        case isTrialPeriod = "is_trial_period"
        case originalPurchaseDate = "original_purchase_date"
        case originalPurchaseDateMs = "original_purchase_date_ms"
        case originalPurchaseDatePst = "original_purchase_date_pst"
        case originalTransactionId = "original_transaction_id"
        case productId = "product_id"
        case purchaseDate = "purchase_date"
        case purchaseDateMs = "purchase_date_ms"
        case purchaseDatePst = "purchase_date_pst"
        case quantity
        case transactionId = "transaction_id"
        case cancellationDate = "cancellation_date"
        case cancellationDateMs = "cancellation_date_ms"
        case cancellationDatePst = "cancellation_date_pst"
        // Add coding keys for additional properties
    }
}

struct ReceiptResponse: Codable {
    let latestReceiptInfo: [LatestReceiptInfo]
    enum CodingKeys: String, CodingKey {
        case latestReceiptInfo = "latest_receipt_info"
    }
}

enum SubscriptionDuration: Int {
    case Weekly
    case Monthly
    case Yearly
}
