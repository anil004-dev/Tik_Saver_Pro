//
//  WTConstant.swift
//  WTScan
//
//  Created by iMac on 26/11/25.
//

import Foundation

struct WTConstant {
    static let termsConditionURL: String = "https://wtscanforwa.blogspot.com/2025/11/wt-scan-terms-and-condition.html"
    static let privacyPolicyURL: String = "https://wtscanforwa.blogspot.com/2025/11/wt-scan-privacy-policy.html"
    static let appURL: String = "https://apps.apple.com/app/id6755756815"
    static let appReviewURL: String = "https://apps.apple.com/app/id6755756815?action=write-review"
}

// MARK: - AdUnitID No Ads
struct AdUnitID {
  static let BannerAd = "ca-app-pub-3940256099942544/2435*281174"
  static let Interstitial = "ca-app-pub-3940256099942544/4411*468910"
  static let AppOpen = "ca-app-pub-3940256099942544/5575*463023"
}

// MARK: - AdUnitID Testing
//struct AdUnitID {
//  static let BannerAd = "ca-app-pub-3940256099942544/2435281174"
//  static let Interstitial = "ca-app-pub-3940256099942544/4411468910"
//  static let AppOpen = "ca-app-pub-3940256099942544/5575463023"
//}

// MARK: - AdUnitID Production
//struct AdUnitID {
//  static let BannerAd = "ca-app-pub-9727507582715205/1721121258"
//  static let Interstitial = "ca-app-pub-9727507582715205/9579429978"
//  static let AppOpen = "ca-app-pub-9727507582715205/7743496320"
//}



struct InAppConstant {
    static let kSHARED_SECRET = "9a95fcf107784b79b5e2cee740b0a3d0"
    static let kRECEIPT_VERIFY_URL_SANDBOX = "https://sandbox.itunes.apple.com/verifyReceipt"
    static let kRECEIPT_VERIFY_URL_PRODUCTION = "https://buy.itunes.apple.com/verifyReceipt"
}

struct InAppPurchaseProductID {
    static let kWeekly = "com.wtscan.weekly"
    static let kMonthly = "com.wtscan.monthly"
    static let kYearly = "com.wtscan.yearly"
}
