//
//  WTBiometricManager.swift
//  WTScan
//
//  Created by iMac on 28/11/25.
//


import Combine
import LocalAuthentication

class WTBiometricManager: ObservableObject {
    static let shared = WTBiometricManager()
    
    // MARK: - Published UI States
    var isFaceIdOn: Bool {
        get { UserDefaultManager.isPasscodeOn }
        set { UserDefaultManager.isPasscodeOn = newValue }
    }
    
    // MARK: - Face ID Availability
    var isFaceIDAvailable: Bool {
        let context = LAContext()
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error) {
            return context.biometryType == .faceID
        }
        return false
    }
    
    func isBiometricEnabled() -> Bool {
        return self.isFaceIdOn
    }
    
    func authenticate(completion: @escaping (_ success: Bool, _ error: String?) -> Void) {
        AppState.shared.isRequestingPermission = true

        let context = LAContext()
        context.localizedFallbackTitle = "" // hide system "Enter Passcode" button
        var reason = "Face ID Authentication"

        if let name = Bundle.main.infoDictionary?["CFBundleDisplayName"] as? String {
            reason = "\(name) Face ID Authentication"
        }

        var authError: NSError?

        if context.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &authError),
           context.biometryType == .faceID {

            context.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: reason) { success, evaluateError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        let message = self.errorMessage(from: evaluateError)
                        
                        if let error = evaluateError as? LAError {
                            switch error.code {
                            case .biometryNotAvailable, .biometryNotEnrolled, .biometryLockout:
                                self.isFaceIdOn = false
                                completion(false, "Face ID unavailable")
                                return
                            default:
                                break
                            }
                        }
                        
                        completion(false, message)
                    }
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    AppState.shared.isRequestingPermission = false
                }
            }
        } else {
            completion(false, "Face ID not available or not permitted.")
            
            DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                AppState.shared.isRequestingPermission = false
            }
        }
    }
    
    // MARK: - Error Mapping
    private func errorMessage(from error: Error?) -> String {
        guard let error = error as? LAError else {
            return "Face ID may not be configured."
        }
        
        switch error.code {
        case .authenticationFailed:
            return "There was a problem verifying your identity."
        case .userCancel:
            return "You pressed cancel."
        case .biometryNotAvailable:
            return "Face ID is not available on this device."
        case .biometryNotEnrolled:
            return "Face ID is not set up."
        case .biometryLockout:
            return "Face ID is locked. Please try again later."
        default:
            return "Face ID authentication failed."
        }
    }
}
