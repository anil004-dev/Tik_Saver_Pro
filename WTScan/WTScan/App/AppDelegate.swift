//
//  AppDelegate.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import UIKit
import UserNotifications
import FirebaseCore
import FirebaseDatabaseInternal

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        UNUserNotificationCenter.current().delegate = self
        return true
    }
    
    // Show banner + sound even when app is OPEN
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification) async -> UNNotificationPresentationOptions {
        return [.banner, .sound]
    }
}
