//
//  UserDefaultManager.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Foundation

struct UserDefaultKeys {
    static let isFirsTimeAppLaunched = "isFirsTimeAppLaunched"
    static let isPasscodeOn = "isPasscodeOn"
    static let isAppLive = "isAppLive"
    static let isAdsConsentGathered = "isConsentGathered"
    static let isWTScanPremium = "isPremium"
    static let subscriptionType = "SubscriptionType"
    static let repostCount = "repost_count"
    static let reminderCount = "reminder_count"
}

class UserDefaultManager {
    // MARK: - Variables
    static let userDefault = UserDefaults(suiteName: "group.com.glacier.test") ?? UserDefaults.standard
    static let maxFreeLimit = 5
    
    static var isFirsTimeAppLaunched: Bool {
        get {
            return userDefault.bool(forKey: UserDefaultKeys.isFirsTimeAppLaunched)
        }
        set {
            userDefault.setValue(newValue, forKey: UserDefaultKeys.isFirsTimeAppLaunched)
        }
    }
    
    static var isPasscodeOn: Bool {
        get {
            return userDefault.bool(forKey: UserDefaultKeys.isPasscodeOn)
        }
        set {
            userDefault.setValue(newValue, forKey: UserDefaultKeys.isPasscodeOn)
        }
    }
    
    static var isAppLive: Bool {
        get {
            return userDefault.bool(forKey: UserDefaultKeys.isAppLive)
        }
        set {
            userDefault.setValue(newValue, forKey: UserDefaultKeys.isAppLive)
        }
    }
    
    static var isAdsConsentGathered: Bool {
        get {
            return userDefault.bool(forKey: UserDefaultKeys.isAdsConsentGathered)
        }
        set {
            userDefault.setValue(newValue, forKey: UserDefaultKeys.isAdsConsentGathered)
        }
    }
    
    static var subscriptionType: Int {
        get {
            return userDefault.integer(forKey: UserDefaultKeys.subscriptionType)
        }
        set {
            userDefault.setValue(newValue, forKey: UserDefaultKeys.subscriptionType)
        }
    }
    
    static var isPremium: Bool {
        get {
            return userDefault.bool(forKey: UserDefaultKeys.isWTScanPremium)
        }
        set {
            userDefault.setValue(newValue, forKey: UserDefaultKeys.isWTScanPremium)
        }
    }
    
    // MARK: - Repost
    static var repostCount: Int {
        userDefault.integer(forKey: UserDefaultKeys.repostCount)
    }
    
    static func canRepost() -> Bool {
        isPremium || repostCount < maxFreeLimit
    }
    
    static func incrementRepost() {
        guard !isPremium else { return }
        userDefault.set(repostCount + 1, forKey: UserDefaultKeys.repostCount)
    }
    
    // MARK: - Reminder
    static var reminderCount: Int {
        userDefault.integer(forKey: UserDefaultKeys.reminderCount)
    }
    
    static func canScheduleReminder() -> Bool {
        isPremium || reminderCount < maxFreeLimit
    }
    
    static func incrementReminder() {
        guard !isPremium else { return }
        userDefault.set(reminderCount + 1, forKey: UserDefaultKeys.reminderCount)
    }
}
