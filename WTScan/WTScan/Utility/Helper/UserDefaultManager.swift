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
}

class UserDefaultManager {
    // MARK: - Variables
    static let userDefault = UserDefaults(suiteName: "group.com.glacier.test") ?? UserDefaults.standard
    
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
}
