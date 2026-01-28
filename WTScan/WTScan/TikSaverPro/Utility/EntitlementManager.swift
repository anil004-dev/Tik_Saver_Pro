//
//  EntitlementManager.swift
//  WTScan
//
//  Created by Anil Jadav on 28/01/26.
//

import SwiftUI
import Combine

class EntitlementManager: ObservableObject {
    static let userDefaults = UserDefaults(suiteName: "group.com.glacier.test") ?? UserDefaults.standard
    
    @AppStorage("hasPro", store: userDefaults)
    var hasPro: Bool = false
    
    static let shared = EntitlementManager()
}
