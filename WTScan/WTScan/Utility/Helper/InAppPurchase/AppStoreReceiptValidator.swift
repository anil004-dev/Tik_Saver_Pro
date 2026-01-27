import UIKit
import StoreKit

class AppStoreReceiptValidator {
    static let shared = AppStoreReceiptValidator()
    var onRestoreHandler: ((_ value: Bool?) -> Void)?
    
    private init() {}
    
    /// Main entry point for verifying subscription receipt
    func verifyPurchase(isProduction: Bool = true) {
        guard let receiptURL = Bundle.main.appStoreReceiptURL else {
            print("No receiptURL found")
            onRestoreHandler?(false)
            return
        }
        
        guard FileManager.default.fileExists(atPath: receiptURL.path) else {
            //print("No receipt file found at \(receiptURL.path)")
            onRestoreHandler?(false)
            return
        }
        
        do {
            let receiptData = try Data(contentsOf: receiptURL, options: .alwaysMapped)
            let base64encodedReceipt = receiptData.base64EncodedString()
            
            var requestDictionary: [String: Any] = [
                "receipt-data": base64encodedReceipt,
                "exclude-old-transactions": true
            ]
            
            if !InAppConstant.kSHARED_SECRET.isEmpty {
                requestDictionary["password"] = InAppConstant.kSHARED_SECRET
            }
            
            guard let requestData = try? JSONSerialization.data(withJSONObject: requestDictionary) else {
                print("requestDictionary could not be serialized")
                onRestoreHandler?(false)
                return
            }
            
            let urlString = isProduction ? InAppConstant.kRECEIPT_VERIFY_URL_PRODUCTION : InAppConstant.kRECEIPT_VERIFY_URL_SANDBOX
            guard let validationURL = URL(string: urlString) else {
                print("Invalid validation URL")
                onRestoreHandler?(false)
                return
            }
            
            var request = URLRequest(url: validationURL)
            request.httpMethod = "POST"
            request.httpBody = requestData
            request.cachePolicy = .reloadIgnoringCacheData
            
            print("🌐 Sending receipt to \(isProduction ? "Production" : "Sandbox") endpoint")
            
            URLSession.shared.dataTask(with: request) { data, _, error in
                if let error = error {
                    print("Network error: \(error.localizedDescription)")
                    self.onRestoreHandler?(false)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from server")
                    self.onRestoreHandler?(false)
                    return
                }
                
                self.handleReceiptResponse(data: data, isProduction: isProduction)
                
            }.resume()
            
        } catch {
            print("Failed to load receipt data: \(error.localizedDescription)")
            onRestoreHandler?(false)
        }
    }
    
    /// Handle JSON response from Apple
    private func handleReceiptResponse(data: Data, isProduction: Bool) {
        do {
            guard let appReceiptJSON = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else {
                print("Could not parse JSON")
                onRestoreHandler?(nil)
                return
            }
            
            print("Receipt Response: \(appReceiptJSON)")
            
            let status = appReceiptJSON["status"] as? Int ?? -1
            let receiptStatus = IAPManager.ReceiptStatus(rawValue: status) ?? .unknown
            
            switch receiptStatus {
            case .valid:
                print("Receipt is valid")
                self.decodeAndCheckSubscription(from: data)
                
            case .testReceipt:
                print("Receipt is sandbox, retrying in sandbox environment")
                self.verifyPurchase(isProduction: false)
                
            default:
                print("Receipt not valid. Status: \(status)")
                self.onRestoreHandler?(nil)
            }
            
        } catch {
            print("JSON parsing error: \(error.localizedDescription)")
            onRestoreHandler?(nil)
        }
    }
    
    /// Decode response into model and check subscription
    private func decodeAndCheckSubscription(from data: Data) {
        do {
            let responseObj = try JSONDecoder().decode(ReceiptResponse.self, from: data)
            
            if responseObj.latestReceiptInfo.count > 0 {
                self.checkWhichItemPurchased(latestReceiptInfo: responseObj.latestReceiptInfo)
            } else {
                print("No latestReceiptInfo found")
                onRestoreHandler?(nil)
            }
            
        } catch let DecodingError.dataCorrupted(context) {
            print("Data corrupted: \(context)")
        } catch let DecodingError.keyNotFound(key, context) {
            print("Key '\(key)' not found: \(context.debugDescription), path: \(context.codingPath)")
        } catch let DecodingError.valueNotFound(value, context) {
            print("Value '\(value)' not found: \(context.debugDescription), path: \(context.codingPath)")
        } catch let DecodingError.typeMismatch(type, context) {
            print("Type '\(type)' mismatch: \(context.debugDescription), path: \(context.codingPath)")
        } catch {
            print("JSON decoding error: \(error.localizedDescription)")
        }
    }
    
    /// Determines which product is purchased and checks expiry
    func checkWhichItemPurchased(latestReceiptInfo: [LatestReceiptInfo]) {
        if let monthly = latestReceiptInfo.first(where: { $0.productId == InAppPurchaseProductID.kMonthly }) {
            handleSubscriptionCheck(for: monthly, type: .Monthly)
        }
        else if let weekly = latestReceiptInfo.first(where: { $0.productId == InAppPurchaseProductID.kWeekly }) {
            handleSubscriptionCheck(for: weekly, type: .Weekly)
        }
        else if let weekly = latestReceiptInfo.first(where: { $0.productId == InAppPurchaseProductID.kYearly }) {
            handleSubscriptionCheck(for: weekly, type: .Yearly)
        }
        else {
            print("No matching product found in receipt")
            onRestoreHandler?(nil)
        }
    }
    
    /// Handles subscription validation logic for each product
    private func handleSubscriptionCheck(for info: LatestReceiptInfo, type: SubscriptionDuration) {
        onRestoreHandler?(true)
        
        if isValidSubscription(expiresDateMs: info.expiresDateMs) {
            print("\(type) Subscription Valid")
            UserDefaultManager.subscriptionType = type.rawValue
            UserDefaultManager.isPremium = true

        } else {
            print("\(type) Subscription Expired")
            DispatchQueue.main.async {
                AppState.shared.isSubscriptionExpired = true
                UserDefaultManager.isPremium = false
            }
        }
    }
    
    /// Compare current date with expiry date from Apple
    func isValidSubscription(expiresDateMs: String?) -> Bool {
        let currentTimeStamp = Date().currentTimeMillis()
        let expiresDateMs = Int64(expiresDateMs ?? "") ?? 0
        
        print("Current TS: \(currentTimeStamp) | Expires TS: \(expiresDateMs)")
        
        return currentTimeStamp <= expiresDateMs
    }
}

// MARK: - Date Extension
extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}
