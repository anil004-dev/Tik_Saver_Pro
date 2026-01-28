//
//  SplashViewModel.swift
//  WTScan
//
//  Created by iMac on 26/11/25.
//


import SwiftUI
import Combine
import FirebaseDatabase
import AppTrackingTransparency
import GoogleMobileAds

class SplashViewModel: ObservableObject {
    
    @Published var showNoInternetView: Bool = false
    @Published var showAllowATTPopup: Bool = ATTrackingManager.trackingAuthorizationStatus == .notDetermined
    @Published var showFaceIDButton: Bool = false
    
    var isProcessingFaceId: Bool = false
    var isMobileAdsStartCalled: Bool = false
    
    var dismiss: (() -> Void)
    
    init(dismiss: @escaping () -> Void) {
        self.dismiss = dismiss
        _showNoInternetView = Published(initialValue: false)
    }
    
    func showATTPopup() {
        /*ATTrackingManager.requestTrackingAuthorization(completionHandler: { status in
            DispatchQueue.main.async {
                self.showAllowATTPopup = false
            }
            self.checkForInternet()
        })*/
        
        ATTrackingManager.requestTrackingAuthorization { status in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                self.showAllowATTPopup = false
                self.checkForInternet(attStatus: status)
            }
        }
    }
    
    func checkForInternet(attStatus: ATTrackingManager.AuthorizationStatus) {
        if WTNetworkMonitor.shared.isInternetAvailable {
            DispatchQueue.main.async {
                self.showNoInternetView = false
            }
            initialiseAdsSDK(attStatus: attStatus)
        }
        else {
            showNoInternetView = true
        }
    }
    
    func initialiseAdsSDK(attStatus: ATTrackingManager.AuthorizationStatus) {
        
        if attStatus == .authorized {
            Task { @MainActor in
                GoogleMobileAdsConsentManager.shared.gatherConsent { consentError in
                    if let consentError {
                        print("Error: \(consentError.localizedDescription)")
                    }
                    
                    if GoogleMobileAdsConsentManager.shared.canRequestAds {
                        self.checkAppLive()
                    }
                }
                
                if GoogleMobileAdsConsentManager.shared.canRequestAds {
                    self.checkAppLive()
                }
            }
        }
        else {
            MobileAds.shared.start()
            self.checkAppLive()
        }
    }
    
    func checkAppLive() {
        guard !self.isMobileAdsStartCalled else {
            return
        }
        
        self.isMobileAdsStartCalled = true
        
        if UserDefaultManager.isAppLive == true {
            self.loadAppOpenAdAndNavigate()
        } else {
            self.checkFirebaseFlag()
        }
    }
    
    func checkFirebaseFlag() {
        DispatchQueue.main.async {
            var ref: DatabaseReference!
            ref = Database.database().reference()
            let currentAppVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ref.root.getData { error, snapshot in
                DispatchQueue.main.async {
                    if error == nil {
                        print(snapshot as Any)
                        let dict = snapshot?.value as? [String: Any]
                        if let firebaseAppVersion = dict?["AppVersion"] as? String {
                            if currentAppVersion == firebaseAppVersion {
                                UserDefaultManager.isAppLive = false
                            }
                            else {
                                UserDefaultManager.isAppLive = true
                            }
                        }
                        else {
                            UserDefaultManager.isAppLive = true
                        }
                        
                        GoogleMobileAdsConsentManager.shared.startGoogleMobileAdsSDK()

                        if UserDefaultManager.isAppLive == true {
                            self.loadAppOpenAdAndNavigate()
                        }
                        else {
                            UserDefaultManager.isAdsConsentGathered = true
                            self.performAuthentication()
                        }
                    }
                    else {
                        UserDefaultManager.isAppLive = false
                        //self.view.makeToast(BlackHoleMessages.Comman_Error_Message, position: .bottom, title: "Error")
                        print("Firebase error: \(error?.localizedDescription ?? "N/A")")
                    }
                }
            }
        }
    }
    
    func loadAppOpenAdAndNavigate() {
        Task {
            await AppOpenAdManager.shared.loadAd()
            UserDefaultManager.isAdsConsentGathered = true

            if AppOpenAdManager.shared.isAdAvailable() && !EntitlementManager.shared.hasPro {
                AppOpenAdManager.shared.appOpenAdManagerDelegate = self
                AppOpenAdManager.shared.showAdIfAvailable()
            } else {
                performAuthentication()
            }
        }
    }
    
    func performAuthentication() {
        guard isProcessingFaceId == false else {
            return
        }
        
        showFaceIDButton = true
        if WTBiometricManager.shared.isBiometricEnabled() {
            isProcessingFaceId = true
            WTBiometricManager.shared.authenticate { success, error in
                self.isProcessingFaceId = false
                if let error {
                    WTAlertManager.shared.showAlert(title: error)
                } else if success {
                    self.dismiss()
                }
            }
        } else {
            dismiss()
        }
    }
}

extension SplashViewModel: AppOpenAdManagerDelegate {
    
    func appOpenAdManagerAdDidComplete(_ appOpenAdManager: AppOpenAdManager) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.performAuthentication()
        }
    }
}
