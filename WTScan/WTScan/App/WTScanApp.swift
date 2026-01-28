//
//  WTScanApp.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//

import SwiftUI
import SwiftData

@main
struct WTScanApp: App {
    
    @StateObject private var entitlementManager: EntitlementManager
    @StateObject private var subscriptionsManager: SubscriptionsManager
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) private var scenePhase
    
    @StateObject var appState: AppState = AppState.shared
    @StateObject var alertManager: WTAlertManager = WTAlertManager.shared
    
    
    init() {
        let entitlementManager = EntitlementManager.shared
        let subscriptionsManager = SubscriptionsManager(entitlementManager: entitlementManager)
        
        self._entitlementManager = StateObject(wrappedValue: entitlementManager)
        self._subscriptionsManager = StateObject(wrappedValue: subscriptionsManager)
        
        _ = WTNetworkMonitor.shared
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.shadowColor = nil
        appearance.shadowImage = UIImage()
        appearance.backgroundColor = .clear
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18, weight: .bold)]
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white, .font: UIFont.systemFont(ofSize: 18, weight: .semibold)]
        
        UINavigationBar.appearance().standardAppearance = appearance
        UINavigationBar.appearance().scrollEdgeAppearance = appearance
        UINavigationBar.appearance().compactAppearance = appearance
        
        UIBarButtonItem.appearance().tintColor = .white
        InterstitialAdManager.shared.loadAd()
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                ZStack {
                    rootView(for: appState.flow)
                }
                
                if appState.showSplashView {
                    let splashViewModel = SplashViewModel {
                        LaunchTracker.shared.splashCompleted = true
                        appState.showSplashView = false
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                            appState.isSplashViewOpen = false
                        }
                    }
                    
                    SplashView(viewModel: splashViewModel)
                }
            }
            .environmentObject(entitlementManager)
            .environmentObject(subscriptionsManager)
            .task {
                await subscriptionsManager.loadProducts()
                await subscriptionsManager.updatePurchasedProducts()
            }
            .alert(
                alertManager.alertModel.title,
                isPresented: $alertManager.showAlert,
                actions: {
                    Button {
                        alertManager.alertModel.leftButtonAction?()
                    } label: {
                        Text(alertManager.alertModel.leftButtonTitle)
                    }
                    
                    if  !alertManager.alertModel.rightButtonTitle.isEmpty {
                        Button {
                            alertManager.alertModel.rightButtonAction?()
                        } label: {
                            Text(alertManager.alertModel.rightButtonTitle)
                        }
                    }
                },
                message: {
                    Text(alertManager.alertModel.message)
                }
            )
            .onChange(of: scenePhase) { oldPhase, newPhase in
                if newPhase == .active && oldPhase != .active {
                    showAuthenticationView()
                    
                    if LaunchTracker.shared.hasLaunchedOnce,
                       LaunchTracker.shared.splashCompleted, appState.isSplashViewOpen == false, appState.isRequestingPermission == false, !entitlementManager.hasPro {
                        AppOpenAdManager.shared.appOpenAdManagerDelegate = nil
                        AppOpenAdManager.shared.showAdIfAvailable()
                    } else {
                        LaunchTracker.shared.hasLaunchedOnce = true
                    }
                }
            }
        }
        .modelContainer(ModelContainer.shared)
        .environmentObject(alertManager)
    }
    
    func showAuthenticationView() {
        guard appState.isSplashViewOpen == false && appState.isRequestingPermission == false else {
            return
        }
        
        if WTBiometricManager.shared.isBiometricEnabled() || LaunchTracker.shared.splashCompleted == false {
            appState.isSplashViewOpen = true
            appState.showSplashView = true
        } else {
            appState.isSplashViewOpen = false
            appState.showSplashView = false
        }
    }
    
    @ViewBuilder
    private func rootView(for flow: AppFlow) -> some View {
        switch flow {
        /*case .splash:
            let splashViewModel = SplashViewModel {
                LaunchTracker.shared.splashCompleted = true
                appState.flow = .home
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    appState.isSplashViewOpen = false
                }
            }
            
            SplashView(viewModel: splashViewModel)*/
        case .home:
            if appState.isLive {
                MainTabView()
            }
            else {
                STScanTabView(appState: self.appState)
            }
        case .none:
            EmptyView()
        }
    }
}
