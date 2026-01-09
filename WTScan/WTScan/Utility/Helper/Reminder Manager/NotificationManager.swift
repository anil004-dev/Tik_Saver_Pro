//
//  NotificationManager.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import Foundation
import UserNotifications
import Combine

@MainActor
class NotificationManager: NSObject, ObservableObject {

    static let shared = NotificationManager()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Request permission
    func requestNotificationPermission() async throws -> Bool {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        
        switch settings.authorizationStatus {
        case .notDetermined:
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            if granted {
                return true
            } else {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    WTAlertManager.shared.showAlert(
                        title: "Access Denied",
                        message: "Notification access was not granted. You can continue using other features or enable access later in Settings."
                    )
                }
                return false
            }
        case .denied:
            showEnableNotificationPermissionAlert()
            return false
        case .authorized:
            return true
        case .provisional:
            return true
        case .ephemeral:
            return true
        @unknown default:
            showEnableNotificationPermissionAlert()
            return false
        }
        
        func showEnableNotificationPermissionAlert() {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                WTAlertManager.shared.showAlert(
                    title: "Notification Access Needed",
                    message: "To schedule reminders, please enable Notification access in Settings. You can continue without it.",
                    leftButtonTitle: "Cancel",
                    leftButtonRole: .none,
                    rightButtonTitle: "Go to Settings",
                    rightButtonRole: .none,
                    rightButtonAction: {
                        Utility.openNotificationSettings()
                    }
                )
            }
        }
    }
    
    // MARK: - Add notification for selected date/time
    func scheduleNotification(
        id: String,
        title: String,
        body: String,
        date: Date
    ) async throws {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let components = Calendar.current.dateComponents(
            [.year, .month, .day, .hour, .minute], from: date)

        let trigger = UNCalendarNotificationTrigger(dateMatching: components, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        try await UNUserNotificationCenter.current().add(request)
    }
    
    // MARK: - Fetch pending
    func fetchPending() async -> [UNNotificationRequest] {
        await withCheckedContinuation { continuation in
            UNUserNotificationCenter.current().getPendingNotificationRequests { list in
                continuation.resume(returning: list)
            }
        }
    }
    
    
    // MARK: - Remove specific
    func remove(id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    // MARK: - Remove all
    func removeAll() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
    }
}
