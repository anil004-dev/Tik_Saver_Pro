//
//  MessageScheduleReminderViewModel.swift
//  WTScan
//
//  Created by iMac on 24/11/25.
//

import Combine
import Foundation

class MessageSchedulerReminderViewModel: ObservableObject {
    
    @Published var message: String = ""
    @Published var scheduleDate: Date = (Date.now.addingTimeInterval(60*5))
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnScheduleReminderAction() {
        Utility.hideKeyboard()
        
        let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !message.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Message required", message: "Please enter a message")
            return
        }
        
        Task { @MainActor in
            do {
                AppState.shared.isRequestingPermission = true

                guard try await NotificationManager.shared.requestNotificationPermission() else {
                    DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                        AppState.shared.isRequestingPermission = false
                    }
                    return
                }
                
                let reminder = WTMessageReminder(id: UUID(), messageText: message, scheduleDate: self.scheduleDate)
                try await ReminderdManager.shared.addReminder(reminder: reminder)
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    AppState.shared.isRequestingPermission = false
                }

                InterstitialAdManager.shared.didFinishedAd = { [weak self] in
                    guard let self = self else { return }
                    InterstitialAdManager.shared.didFinishedAd = nil
                    
                    WTAlertManager.shared.showAlert(
                        title: "Reminder Scheduled!",
                        message: "Your reminder has been added.",
                        leftButtonAction: { [weak self] in
                            guard let _ = self else { return }
                            NavigationManager.shared.pop()
                        }
                    )
                }
                
                InterstitialAdManager.shared.showAd()
            } catch {
                WTAlertManager.shared.showAlert(title: "Error", message: "Unable to schedule reminder. Please try again.")
                
                DispatchQueue.main.asyncAfter(deadline: .now()+1) {
                    AppState.shared.isRequestingPermission = false
                }
            }
        }
    }
}
