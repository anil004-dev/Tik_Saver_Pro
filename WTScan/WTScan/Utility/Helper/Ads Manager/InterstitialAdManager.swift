//
//  InterstitialAdManager.swift
//  WTScan
//
//  Created by IMac on 27/11/25.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import Combine

class InterstitialAdManager: NSObject, FullScreenContentDelegate, ObservableObject {
    
    static let shared = InterstitialAdManager()
    var didFinishedAd: (() -> Void)?
    
    private var tapCount: Int = 0
    private var interstitial: InterstitialAd?
    private let adUnitID = AdUnitID.Interstitial
    
    func loadAd() {
        let request = Request()
        InterstitialAd.load(with: adUnitID, request: request) { [weak self] ad, error in
            if let error = error {
                print("❌ Failed to load interstitial ad: \(error.localizedDescription)")
                DispatchQueue.main.async { [weak self] in
                    self?.didFinishedAd?()
                    self?.didFinishedAd = nil
                }
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                    self?.interstitial = ad
                    self?.interstitial?.fullScreenContentDelegate = self
                }
            }
        }
    }
    
    func showAd() {
        tapCount = 0
        if let ad = interstitial {
            ad.present(from: nil)
        } else {
            loadAd()
        }
    }
    
    func increaseTapCount() {
        tapCount += 1
        if tapCount > (AppState.shared.isLive ? 4 : 14) {
            showAd()
        } else {
            DispatchQueue.main.async { [weak self] in
                self?.didFinishedAd?()
                self?.didFinishedAd = nil
            }
        }
    }
    
    // MARK: - GADFullScreenContentDelegate
    
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        interstitial = nil
        
        DispatchQueue.main.async { [weak self] in
            self?.didFinishedAd?()
            self?.didFinishedAd = nil
            self?.loadAd()
        }
    }
}
