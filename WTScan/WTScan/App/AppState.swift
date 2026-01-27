//
//  AppState.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//


import Combine

enum AppFlow {
    case home
    case none
}

class AppState: ObservableObject {
    
    @Published var flow: AppFlow = .home
    @Published var homeViewModel = HomeViewModel()
    @Published var showSplashView: Bool = true
    
    var isRequestingPermission: Bool = false
    var isSplashViewOpen: Bool = false
    var isLive: Bool {  UserDefaultManager.isAppLive }
    var isSubscriptionExpired = false
    
    static let shared = AppState()

    init() {
    }
}
