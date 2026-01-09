//
//  AdsConsentManager.swift
//  WTScan
//
//  Created by IMac on 27/11/25.
//

import Foundation
import GoogleMobileAds
import UserMessagingPlatform

@MainActor
class GoogleMobileAdsConsentManager: NSObject {
    
    static let shared = GoogleMobileAdsConsentManager()
    var isMobileAdsStartCalled = false
    
    var canRequestAds: Bool {
        return ConsentInformation.shared.canRequestAds
    }
    
    var isPrivacyOptionsRequired: Bool {
        return ConsentInformation.shared.privacyOptionsRequirementStatus == .required
    }
    
    func gatherConsent(consentGatheringComplete: @escaping (Error?) -> Void) {
        let parameters = RequestParameters()
        let debugSettings = DebugSettings()
        //debugSettings.geography = DebugGeography.EEA
        parameters.debugSettings = debugSettings

        ConsentInformation.shared.requestConsentInfoUpdate(with: parameters) {
            requestConsentError in
            guard requestConsentError == nil else {
                return consentGatheringComplete(requestConsentError)
            }
            
            Task { @MainActor in
                do {
                    try await ConsentForm.loadAndPresentIfRequired(from: nil)
                    consentGatheringComplete(nil)
                } catch {
                    consentGatheringComplete(error)
                }
            }
        }
    }
    
    @MainActor func presentPrivacyOptionsForm() async throws {
        try await ConsentForm.presentPrivacyOptionsForm(from: nil)
    }
    
    func startGoogleMobileAdsSDK() {
        guard canRequestAds, !isMobileAdsStartCalled else { return }
        isMobileAdsStartCalled = true
        MobileAds.shared.start()
    }
}
